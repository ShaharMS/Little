﻿// Generated by HLC 4.3.4 (HL v5)
#ifndef INC__std__Date
#define INC__std__Date
typedef struct _$Date *$Date;
typedef struct _Date *Date;
#include <hl/Class.h>
#include <hl/BaseType.h>
#include <_std/String.h>


struct _$Date {
	hl_type *$type;
	hl_type* _hx___type__;
	vdynamic* _hx___meta__;
	varray* _hx___implementedBy__;
	String _hx___name__;
	vdynamic* _hx___constructor__;
	vclosure* fromTime;
	vclosure* fromString;
};
struct _Date {
	hl_type *$type;
	int _hx_t;
};
#endif
