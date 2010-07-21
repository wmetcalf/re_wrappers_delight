# cython: infer_types(False)
# Import re flags to be compatible.
import re
I = re.I
IGNORECASE = re.IGNORECASE
M = re.M
MULTILINE = re.MULTILINE
S = re.S
DOTALL = re.DOTALL
U = re.U
UNICODE = re.UNICODE
X = re.X
VERBOSE = re.VERBOSE

class RegexError(re.error):
    """
    Some error has occured in compilation of the regex.
    """
    pass

cdef int _I = I, _M = M, _S = S, _U = U, _X = X

cimport _re2
cimport python_unicode
from cython.operator cimport preincrement as inc, dereference as deref

cdef inline object cpp_to_pystring(_re2.cpp_string input):
    return input.c_str()[:input.length()]

cdef class Match:
    cdef _re2.StringPiece * matches
    cdef _re2.const_stringintmap * named_groups

    cdef object _lastgroup
    cdef int _lastindex
    cdef int nmatches
    cdef object match_string
    cdef tuple _groups
    cdef dict _named_groups

    def __init__(self):
        self._lastgroup = -1
        self._lastindex = -1

    cdef init_groups(self):
        cdef list groups = []
        cdef int i
        for i in range(self.nmatches):
            if self.matches[i].data() == NULL:
                groups.append(None)
            else:
                groups.append(self.matches[i].data()[:self.matches[i].length()])
        self._lastindex = len(groups) - 1
        self._groups = tuple(groups)

    def groups(self):
        return self._groups[1:]

    def group(self, groupnum=0):
        cdef int idx
        if isinstance(groupnum, basestring):
            return self.groupdict()[groupnum]

        idx = groupnum

        if idx > self.nmatches - 1:
            raise IndexError("no such group")
        return self._groups[idx]

    cdef _makespan(self, int groupnum=0):
        cdef int start, end
        cdef _re2.StringPiece * piece
        cdef char * s = self.match_string
        if groupnum > self.nmatches - 1:
            raise IndexError("no such group")
        piece = &self.matches[groupnum]
        if piece.data() == NULL:
            return (-1, -1)
        start = piece.data() - s
        end = start + piece.length()
        return (start, end)

    def groupdict(self):
        cdef _re2.stringintmapiterator it
        cdef dict result = {}

        if self._named_groups:
            return self._named_groups

        self._named_groups = result
        it = self.named_groups.begin()
        self._lastgroup = None
        while it != self.named_groups.end():
            result[cpp_to_pystring(deref(it).first)] = self._groups[deref(it).second]
            self._lastgroup = cpp_to_pystring(deref(it).first)
            inc(it)

        return result

    def end(self, int groupnum=0):
        return self._makespan(groupnum)[1]

    def start(self, int groupnum=0):
        return self._makespan(groupnum)[0]

    def span(self, int groupnum=0):
        return self._makespan(groupnum)

    property lastindex:
        def __get__(self):
            if self._lastindex < 1:
                return None
            else:
                return self._lastindex

    property lastgroup:
        def __get__(self):
            if self._lastgroup == -1:
                self.groupdict()
            return self._lastgroup


cdef class Pattern:
    cdef _re2.RE2 * pattern
    cdef int ngroups

    cdef _search(self, string, int pos, int endpos, _re2.re2_Anchor anchoring):
        """
        Scan through string looking for a match, and return a corresponding
        Match instance. Return None if no position in the string matches.
        """
        cdef int size
        cdef int result
        cdef char * cstring
        cdef _re2.StringPiece * sp
        cdef _re2.StringPiece * matches = _re2.new_StringPiece_array(self.ngroups + 2)
        cdef Match m = Match()

        if _re2.PyObject_AsCharBuffer(string, <_re2.const_char_ptr*> &cstring, &size) == -1:
            raise TypeError("expected string or buffer")
        if endpos != -1 and endpos < size:
            size = endpos

        sp = new _re2.StringPiece(cstring, size)
        with nogil:
            result = self.pattern.Match(sp[0], <int>pos, anchoring, matches, self.ngroups + 1)

        del sp
        if result == 0:
            return None
        m.matches = matches
        m.named_groups = _re2.addressof(self.pattern.NamedCapturingGroups())
        m.nmatches = self.ngroups + 1
        m.match_string = string
        m.init_groups()
        return m

    def search(self, string, int pos=0, int endpos=-1):
        """
        Scan through string looking for a match, and return a corresponding
        Match instance. Return None if no position in the string matches.
        """
        return self._search(string, pos, endpos, _re2.UNANCHORED)

    def match(self, string, int pos=0, int endpos=-1):
        """
        Matches zero or more characters at the beginning of the string.
        """
        return self._search(string, pos, endpos, _re2.ANCHOR_START)


    def finditer(self, int pos=0, int endpos=-1):
        """
        Return an iterator over all non-overlapping matches for the
        RE pattern in string. For each match, the iterator returns a
        match object.
        """
        pass

    def split(self, string, int maxsplit=0):
        """
        split(string[, maxsplit = 0]) --> list
        Split a string by the occurances of the pattern.
        """
        pass

    def sub(self, string, int count=0):
        """
        sub(repl, string[, count = 0]) --> newstring
        Return the string obtained by replacing the leftmost non-overlapping
        occurrences of pattern in string by the replacement repl.
        """
        return self.subn(string, count)

    def subn(self, string, int count=0):
        """
        subn(repl, string[, count = 0]) --> (newstring, number of subs)
        Return the tuple (new_string, number_of_subs_made) found by replacing
        the leftmost non-overlapping occurrences of pattern with the
        replacement repl.
        """
        pass


def compile(pattern, int flags=0):
    """
    Compile a regular expression pattern, returning a pattern object.
    """
    cdef char * string
    cdef int length
    cdef _re2.StringPiece * s
    cdef _re2.Options opts
    cdef _re2.cpp_string error_msg

    if isinstance(pattern, Pattern):
        return pattern

    cdef str strflags = ''
    # Set the options given the flags above.
    if flags & _I:
        opts.set_case_sensitive(0);
    if flags & _U:
        opts.set_encoding(_re2.EncodingUTF8)
    else:
        opts.set_encoding(_re2.EncodingLatin1)
    if not (flags & _X):
        opts.set_log_errors(0)

    if flags & _S:
        strflags += 's'
    if flags & _M:
        strflags += 'm'

    if strflags:
        pattern = '(?' + strflags + ')' + pattern

    # We use this function to get the proper length of the string.
    if _re2.PyObject_AsCharBuffer(pattern, <_re2.const_char_ptr*> &string, &length) == -1:
        raise TypeError("first argument must be a string or compiled pattern")

    s = new _re2.StringPiece(string, length)

    cdef _re2.RE2 * re_pattern = new _re2.RE2(s[0], opts)
    if not re_pattern.ok():
        # Something went wrong with the compilation.
        del s
        error_msg = re_pattern.error()
        raise RegexError(cpp_to_pystring(re_pattern.error()))

    cdef Pattern pypattern = Pattern()
    pypattern.pattern = re_pattern
    pypattern.ngroups = re_pattern.NumberOfCapturingGroups()
    del s
    return pypattern

def search(pattern, string, int flags=0):
    """
    Scan through string looking for a match to the pattern, returning
    a match object or none if no match was found.
    """
    return compile(pattern, flags).search(string)

def match(pattern, string, int flags=0):
    """
    Try to apply the pattern at the start of the string, returning
    a match object, or None if no match was found.
    """
    return compile(pattern, flags).match(string)
