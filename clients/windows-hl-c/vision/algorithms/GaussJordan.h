﻿// Generated by HLC 4.3.4 (HL v5)
#ifndef INC_vision__algorithms__GaussJordan
#define INC_vision__algorithms__GaussJordan
typedef struct _vision__algorithms__$GaussJordan *vision__algorithms__$GaussJordan;
typedef struct _vision__algorithms__GaussJordan *vision__algorithms__GaussJordan;
#include <hl/Class.h>
#include <hl/BaseType.h>
#include <_std/String.h>
#include <vision/ds/Array2D.h>
#include <hl/types/ArrayObj.h>
#include <hl/types/ArrayBytes_Int.h>


struct _vision__algorithms__$GaussJordan {
	hl_type *$type;
	hl_type* _hx___type__;
	vdynamic* _hx___meta__;
	varray* _hx___implementedBy__;
	String _hx___name__;
	vdynamic* _hx___constructor__;
	vclosure* invert;
	vclosure* createIdentityMatrix;
	vclosure* augmentMatrix;
	vclosure* swapRows;
	vclosure* extractMatrix;
};
struct _vision__algorithms__GaussJordan {
	hl_type *$type;
};
#endif
