﻿// Generated by HLC 4.3.4 (HL v5)
#ifndef INC_vision__exceptions__VisionException
#define INC_vision__exceptions__VisionException
typedef struct _vision__exceptions__$VisionException *vision__exceptions__$VisionException;
typedef struct _vision__exceptions__VisionException *vision__exceptions__VisionException;
#include <hl/Class.h>
#include <hl/BaseType.h>
#include <_std/String.h>
#include <haxe/Exception.h>
#include <hl/types/ArrayObj.h>


struct _vision__exceptions__$VisionException {
	hl_type *$type;
	hl_type* _hx___type__;
	vdynamic* _hx___meta__;
	varray* _hx___implementedBy__;
	String _hx___name__;
	vdynamic* _hx___constructor__;
};
struct _vision__exceptions__VisionException {
	hl_type *$type;
	String _hx___exceptionMessage;
	hl__types__ArrayObj _hx___exceptionStack;
	varray* _hx___nativeStack;
	int _hx___skipStack;
	vdynamic* _hx___nativeException;
	haxe__Exception _hx___previousException;
};
#endif
