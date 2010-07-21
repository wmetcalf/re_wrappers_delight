# cython: infer_types(True)
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
error = re.error

cdef int _I = I, _M = M, _S = S, _U = U, _X = X

cimport _re2
cimport python_unicode

cdef class Match:
    cdef _re2.StringPiece * matches
    cdef int nmatches
    cdef object match_string
    cdef tuple _groups

    cdef init_groups(self):
        cdef list groups = []
        cdef int i
        for i in range(self.nmatches):
            if self.matches[i].data() == NULL:
                groups.append(None)
            else:
                groups.append(self.matches[i].data()[:self.matches[i].length()])
        self._groups = tuple(groups)

    def groups(self):
        return self._groups[1:]

    def group(self, int groupnum=0):
        if groupnum > self.nmatches - 1:
            raise IndexError("no such group")
        return self._groups[groupnum]

    def groupdict(self):
        pass

    def end(self):
        pass

    def start(self):
        pass

    def span(self):
        pass

    def __repr__(self):
        return '<re2.Match object>'


cdef class Pattern:
    cdef _re2.RE2 * pattern
    cdef int ngroups

    def search(self, string, int pos=0, int endpos=-1):
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
            result = self.pattern.Match(sp[0], <int>pos, _re2.UNANCHORED, matches, self.ngroups + 1)

        del sp
        if result == 0:
            return None
        m.matches = matches
        m.nmatches = self.ngroups + 1
        m.match_string = string
        m.init_groups()
        return m

    def match(self, int pos=0, int endpos=-1):
        """
        Matches zero or more characters at the beginning of the string.
        """
        pass

    def finditer(self, int pos=0, int endpos=-1):
        """
        Return an iterator over all non-overlapping matches for the
        RE pattern in string. For each match, the iterator returns a
        match object.
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

    if isinstance(pattern, Pattern):
        return pattern

    # Set the options given the flags above.
    if flags & _I:
        opts.set_case_sensitive(0);
    if flags & _U:
        opts.set_encoding(_re2.EncodingUTF8)
    else:
        opts.set_encoding(_re2.EncodingLatin1)
    if flags & _X:
        opts.set_log_errors(1)
    if flags & _S:
        raise NotImplementedError("This module does not support re.S")
    if flags & _M:
        raise NotImplementedError("The re2 module does not support re.M")

    # We use this function to get the proper length of the string.
    if _re2.PyObject_AsCharBuffer(pattern, <_re2.const_char_ptr*> &string, &length) == -1:
        raise TypeError("first argument must be a string or compiled pattern")

    s = new _re2.StringPiece(string, length)

    cdef _re2.RE2 * re_pattern = new _re2.RE2(s[0], opts)
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
