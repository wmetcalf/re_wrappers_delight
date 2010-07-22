
cdef extern from *:
    ctypedef char* const_char_ptr "const char*"

cdef extern from "<string>" namespace "std":
    cdef cppclass string:
        const_char_ptr c_str()
        int length()

    ctypedef string cpp_string "std::string"


cdef extern from "<map>" namespace "std":
    cdef cppclass stringintmapiterator "std::map<std::string, int>::const_iterator":
        cpp_string first
        int second
        stringintmapiterator operator++()
        bint operator==(stringintmapiterator)
        stringintmapiterator& operator*(stringintmapiterator)
        bint operator!=(stringintmapiterator)

    cdef cppclass const_stringintmap "const std::map<std::string, int>":
        stringintmapiterator begin()
        stringintmapiterator end()
        int operator[](cpp_string)


cdef extern from "Python.h":
    int PyObject_AsCharBuffer(object, const_char_ptr *, int *)
    char * PyString_AS_STRING(object)

cdef extern from "stringpiece.h" namespace "re2":
    cdef cppclass StringPiece:
        StringPiece()
        StringPiece(const_char_ptr, int)
        const_char_ptr data()
        int copy(char * buf, size_t n, size_t pos)
        int length()
        

    ctypedef StringPiece const_StringPiece "const StringPiece"
 

cdef extern from "_re2macros.h":
    StringPiece * new_StringPiece_array(int) nogil
    const_stringintmap * addressof(const_stringintmap&)


cdef extern from "re2.h" namespace "re2":
    cdef enum Anchor:
        UNANCHORED "RE2::UNANCHORED"
        ANCHOR_START "RE2::ANCHOR_START"
        ANCHOR_BOTH "RE2::ANCHOR_BOTH"

    ctypedef Anchor re2_Anchor "RE2::Anchor"

    cdef enum Encoding:
        EncodingUTF8 "RE2::Options::EncodingUTF8"
        EncodingLatin1 "RE2::Options::EncodingLatin1"

    ctypedef Encoding re2_Encoding "RE2::Options::Encoding"

    cdef cppclass Options "RE2::Options":
        Options()
        void set_posix_syntax(int b)
        void set_longest_match(int b)
        void set_log_errors(int b)
        void set_max_mem(int m)
        void set_literal(int b)
        void set_never_nl(int b)
        void set_case_sensitive(int b)
        void set_perl_classes(int b)
        void set_word_boundary(int b)
        void set_one_line(int b)
        int case_sensitive()
        void set_encoding(re2_Encoding encoding)

    ctypedef Options const_Options "const RE2::Options"

    cdef cppclass RE2:
        RE2(const_StringPiece pattern, Options option)
        RE2(const_StringPiece pattern)
        int Match(const_StringPiece text, int startpos, Anchor anchor,
                   StringPiece * match, int nmatch) nogil
        int NumberOfCapturingGroups()
        int ok()
        cpp_string error()
        const_stringintmap& NamedCapturingGroups()
        
    #int Replace "RE2::Replace" (cpp_string *str,
    #                            const_RE2 pattern,
    #                            const_StringPiece rewrite)

    #int GlobalReplace "RE2::GlobalReplace" (cpp_string *str,
    #                                        const_RE2 pattern,
    #                                        const_StringPiece rewrite)

    ctypedef RE2 const_RE2 "const RE2"
