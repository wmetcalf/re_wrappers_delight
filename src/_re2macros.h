#ifndef __RE2MACROS_H
#define __RE2MACROS_H
#include "stringpiece.h"

static inline re2::StringPiece * new_StringPiece_array(int n)
{
    re2::StringPiece * sp = new re2::StringPiece[n];
    return sp;
}

#define addressof(A) (&A)

#define as_char(A) (char *)(A)
#define pattern_Replace(A, B, C) re2::RE2::Replace((A), (B), (C))
#define pattern_GlobalReplace(A, B, C) re2::RE2::GlobalReplace((A), (B), (C))

#endif
