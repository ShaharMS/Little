﻿// Generated by HLC 4.3.4 (HL v5)
#ifndef INC_little__interpreter__memory___MemoryPointer__MemoryPointer_Impl_
#define INC_little__interpreter__memory___MemoryPointer__MemoryPointer_Impl_
typedef struct _little__interpreter__memory___MemoryPointer__$MemoryPointer_Impl_ *little__interpreter__memory___MemoryPointer__$MemoryPointer_Impl_;
typedef struct _little__interpreter__memory___MemoryPointer__MemoryPointer_Impl_ *little__interpreter__memory___MemoryPointer__MemoryPointer_Impl_;
#include <hl/Class.h>
#include <hl/BaseType.h>
#include <_std/String.h>
#include <hl/types/ArrayBytes_Int.h>
#include <haxe/io/Bytes.h>


struct _little__interpreter__memory___MemoryPointer__$MemoryPointer_Impl_ {
	hl_type *$type;
	hl_type* _hx___type__;
	vdynamic* _hx___meta__;
	varray* _hx___implementedBy__;
	String _hx___name__;
	vdynamic* _hx___constructor__;
	int POINTER_SIZE;
	vclosure* get_rawLocation;
	vclosure* set_rawLocation;
	vclosure* _new;
	vclosure* fromInt;
	vclosure* toString;
	vclosure* toArray;
	vclosure* toBytes;
	vclosure* toInt;
};
struct _little__interpreter__memory___MemoryPointer__MemoryPointer_Impl_ {
	hl_type *$type;
};
#endif
