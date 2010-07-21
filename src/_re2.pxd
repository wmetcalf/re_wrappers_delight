
cdef extern from *:
    ctypedef char* const_char_ptr "const char*"

cdef extern from "stdlib.h":
    ctypedef unsigned long size_t
    void *malloc(size_t size)
    void free(void *ptr)

cdef extern from "string" namespace "std":
    cdef cppclass string:
        const_char_ptr c_str()

    ctypedef string cpp_string "std::string"

cdef extern from "Python.h":
    int PyObject_AsCharBuffer(object, const_char_ptr *, int *)

cdef extern from "stringpiece.h" namespace "re2":
    cdef cppclass StringPiece:
        StringPiece()
        StringPiece(const_char_ptr, int)
        const_char_ptr data()
        int copy(char * buf, size_t n, size_t pos)
        int length()
        

    ctypedef StringPiece const_StringPiece "const StringPiece"
 

cdef extern from "_re2macros.h":
    StringPiece * new_StringPiece_array(int)


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
        #const map<string, int>& NamedCapturingGroups() const;
#bool Match(const StringPiece& text,
#             int startpos,
#             Anchor anchor,
#             StringPiece *match,
#             int nmatch) const;
