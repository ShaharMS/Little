﻿// Generated by HLC 4.3.4 (HL v5)
#define HLC_BOOT
#include <hlc.h>
#include <vision/algorithms/Radix.h>
int hl_types_ArrayDyn_get_length(hl__types__ArrayDyn);
extern hl_type t$_i32;
#include <hl/types/ArrayObj.h>
#include <hl/types/ArrayBytes_Int.h>
extern hl_type t$_dyn;
#include <hl/natives.h>
hl__types__ArrayObj hl_types_ArrayObj_alloc(varray*);
#include <hl/types/ArrayBase.h>
hl__types__ArrayDyn hl_types_ArrayDyn_alloc(hl__types__ArrayBase,bool*);
hl__types__ArrayBytes_Int hl_types_ArrayBase_allocI32(vbyte*,int);
int hl_types_ArrayBytes_Int_push(hl__types__ArrayBytes_Int,int);
void hl_types_ArrayBytes_Int___expand(hl__types__ArrayBytes_Int,int);
int hl_types_ArrayDyn_push(hl__types__ArrayDyn,vdynamic*);
void hl_types_ArrayDyn_reverse(hl__types__ArrayDyn);
hl__types__ArrayDyn hl_types_ArrayDyn_concat(hl__types__ArrayDyn,hl__types__ArrayDyn);

vdynamic* vision_algorithms_Radix_getMax(hl__types__ArrayDyn r0,vdynamic* r1) {
	vdynamic *r2, *r4, *r7;
	int r3, r5, r6;
	if( r1 ) goto label$9830131_1_5;
	if( r0 == NULL ) hl_null_access();
	r3 = hl_types_ArrayDyn_get_length(r0);
	r2 = hl_alloc_dynamic(&t$_i32);
	r2->v.i = r3;
	r1 = r2;
	label$9830131_1_5:
	if( r0 == NULL ) hl_null_access();
	r3 = 0;
	r4 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r3);
	r3 = 1;
	r2 = r1;
	label$9830131_1_10:
	r6 = r2 ? r2->v.i : 0;
	if( r3 >= r6 ) goto label$9830131_1_21;
	r5 = r3;
	++r3;
	if( r0 == NULL ) hl_null_access();
	r7 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	{ int i = hl_dyn_compare((vdynamic*)r4,(vdynamic*)r7); if( i >= 0 && i != hl_invalid_comparison ) goto label$9830131_1_20; };
	r7 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	r4 = r7;
	label$9830131_1_20:
	goto label$9830131_1_10;
	label$9830131_1_21:
	return r4;
}

hl__types__ArrayDyn vision_algorithms_Radix_countingSort(hl__types__ArrayDyn r0,int r1,vdynamic* r2) {
	bool *r11;
	hl__types__ArrayObj r9;
	hl_type *r8;
	bool r10;
	hl__types__ArrayBytes_Int r12, r15;
	double r16, r18;
	hl__types__ArrayDyn r6;
	vdynamic *r4, *r17;
	vbyte *r13, *r23;
	varray *r7;
	int r5, r14, r19, r20, r21, r22;
	if( r2 ) goto label$9830131_2_5;
	if( r0 == NULL ) hl_null_access();
	r5 = hl_types_ArrayDyn_get_length(r0);
	r4 = hl_alloc_dynamic(&t$_i32);
	r4->v.i = r5;
	r2 = r4;
	label$9830131_2_5:
	r8 = &t$_dyn;
	r5 = 0;
	r7 = hl_alloc_array(r8,r5);
	r9 = hl_types_ArrayObj_alloc(r7);
	r10 = true;
	r11 = &r10;
	r6 = hl_types_ArrayDyn_alloc(((hl__types__ArrayBase)r9),r11);
	r5 = -1;
	r14 = 0;
	r13 = hl_alloc_bytes(r14);
	r14 = 0;
	r14 = 0;
	r12 = hl_types_ArrayBase_allocI32(r13,r14);
	if( r12 == NULL ) hl_null_access();
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r14 = 0;
	r14 = hl_types_ArrayBytes_Int_push(r12,r14);
	r15 = r12;
	label$9830131_2_40:
	++r5;
	r14 = r2 ? r2->v.i : 0;
	if( r5 >= r14 ) goto label$9830131_2_63;
	if( r0 == NULL ) hl_null_access();
	r17 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	r16 = (double)hl_dyn_castd(&r17,&t$_dyn);
	r18 = (double)r1;
	r16 = r16 / r18;
	r14 = (int)r16;
	r19 = 10;
	r14 = r19 == 0 ? 0 : r14 % r19;
	if( r15 == NULL ) hl_null_access();
	r20 = r15->length;
	if( ((unsigned)r14) < ((unsigned)r20) ) goto label$9830131_2_56;
	hl_types_ArrayBytes_Int___expand(r15,r14);
	label$9830131_2_56:
	r13 = r15->bytes;
	r20 = 2;
	r20 = r14 << r20;
	r21 = *(int*)(r13 + r20);
	++r21;
	*(int*)(r13 + r20) = r21;
	goto label$9830131_2_40;
	label$9830131_2_63:
	r14 = 0;
	r5 = r14;
	label$9830131_2_65:
	++r5;
	r14 = 10;
	if( r5 >= r14 ) goto label$9830131_2_90;
	if( r15 == NULL ) hl_null_access();
	r19 = r15->length;
	if( ((unsigned)r5) < ((unsigned)r19) ) goto label$9830131_2_73;
	hl_types_ArrayBytes_Int___expand(r15,r5);
	label$9830131_2_73:
	r13 = r15->bytes;
	r19 = 2;
	r19 = r5 << r19;
	r20 = *(int*)(r13 + r19);
	r22 = 1;
	r21 = r5 - r22;
	r22 = r15->length;
	if( ((unsigned)r21) < ((unsigned)r22) ) goto label$9830131_2_83;
	r21 = 0;
	goto label$9830131_2_87;
	label$9830131_2_83:
	r23 = r15->bytes;
	r22 = 2;
	r22 = r21 << r22;
	r21 = *(int*)(r23 + r22);
	label$9830131_2_87:
	r20 = r20 + r21;
	*(int*)(r13 + r19) = r20;
	goto label$9830131_2_65;
	label$9830131_2_90:
	r14 = r2 ? r2->v.i : 0;
	r5 = r14;
	label$9830131_2_92:
	--r5;
	r14 = 0;
	if( r5 < r14 ) goto label$9830131_2_135;
	if( r6 == NULL ) hl_null_access();
	if( r15 == NULL ) hl_null_access();
	if( r0 == NULL ) hl_null_access();
	r17 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	r16 = (double)hl_dyn_castd(&r17,&t$_dyn);
	r18 = (double)r1;
	r16 = r16 / r18;
	r14 = (int)r16;
	r19 = 10;
	r14 = r19 == 0 ? 0 : r14 % r19;
	r19 = r15->length;
	if( ((unsigned)r14) < ((unsigned)r19) ) goto label$9830131_2_110;
	r14 = 0;
	goto label$9830131_2_114;
	label$9830131_2_110:
	r13 = r15->bytes;
	r19 = 2;
	r19 = r14 << r19;
	r14 = *(int*)(r13 + r19);
	label$9830131_2_114:
	r19 = 1;
	r14 = r14 - r19;
	r17 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	((void (*)(hl__types__ArrayDyn,int,vdynamic*))r6->$type->vobj_proto[1])(r6,r14,r17);
	r17 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r5);
	r16 = (double)hl_dyn_castd(&r17,&t$_dyn);
	r18 = (double)r1;
	r16 = r16 / r18;
	r14 = (int)r16;
	r19 = 10;
	r14 = r19 == 0 ? 0 : r14 % r19;
	r20 = r15->length;
	if( ((unsigned)r14) < ((unsigned)r20) ) goto label$9830131_2_128;
	hl_types_ArrayBytes_Int___expand(r15,r14);
	label$9830131_2_128:
	r13 = r15->bytes;
	r20 = 2;
	r20 = r14 << r20;
	r21 = *(int*)(r13 + r20);
	--r21;
	*(int*)(r13 + r20) = r21;
	goto label$9830131_2_92;
	label$9830131_2_135:
	r14 = -1;
	r5 = r14;
	label$9830131_2_137:
	++r5;
	r14 = r2 ? r2->v.i : 0;
	if( r5 >= r14 ) goto label$9830131_2_146;
	if( r0 == NULL ) hl_null_access();
	if( r6 == NULL ) hl_null_access();
	r17 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r6->$type->vobj_proto[0])(r6,r5);
	((void (*)(hl__types__ArrayDyn,int,vdynamic*))r0->$type->vobj_proto[1])(r0,r5,r17);
	goto label$9830131_2_137;
	label$9830131_2_146:
	return r6;
}

hl__types__ArrayDyn vision_algorithms_Radix_sort(hl__types__ArrayDyn r0) {
	bool *r7;
	hl__types__ArrayObj r5;
	hl_type *r3;
	bool r6;
	double r15, r16;
	hl__types__ArrayDyn r1, r9, r11, r17;
	vdynamic *r14, *r18, *r19;
	int r4, r10, r12, r13;
	varray *r2;
	r3 = &t$_dyn;
	r4 = 0;
	r2 = hl_alloc_array(r3,r4);
	r5 = hl_types_ArrayObj_alloc(r2);
	r6 = true;
	r7 = &r6;
	r1 = hl_types_ArrayDyn_alloc(((hl__types__ArrayBase)r5),r7);
	r3 = &t$_dyn;
	r4 = 0;
	r2 = hl_alloc_array(r3,r4);
	r5 = hl_types_ArrayObj_alloc(r2);
	r6 = true;
	r7 = &r6;
	r9 = hl_types_ArrayDyn_alloc(((hl__types__ArrayBase)r5),r7);
	r4 = 0;
	if( r0 == NULL ) hl_null_access();
	r10 = hl_types_ArrayDyn_get_length(r0);
	label$9830131_3_17:
	if( r4 >= r10 ) goto label$9830131_3_35;
	r12 = r4;
	++r4;
	if( r0 == NULL ) hl_null_access();
	r14 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r12);
	r15 = (double)hl_dyn_castd(&r14,&t$_dyn);
	r16 = 0.;
	if( !(r15 < r16) ) goto label$9830131_3_31;
	if( r1 == NULL ) hl_null_access();
	r14 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r12);
	r14 = -r14;
	r13 = hl_types_ArrayDyn_push(r1,r14);
	goto label$9830131_3_34;
	label$9830131_3_31:
	if( r9 == NULL ) hl_null_access();
	r14 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r0->$type->vobj_proto[0])(r0,r12);
	r13 = hl_types_ArrayDyn_push(r9,r14);
	label$9830131_3_34:
	goto label$9830131_3_17;
	label$9830131_3_35:
	r11 = r1;
	if( r1 == NULL ) hl_null_access();
	r4 = hl_types_ArrayDyn_get_length(r1);
	r18 = hl_alloc_dynamic(&t$_i32);
	r18->v.i = r4;
	r14 = vision_algorithms_Radix_getMax(r1,r18);
	r4 = 1;
	label$9830131_3_41:
	r15 = (double)hl_dyn_castd(&r14,&t$_dyn);
	r16 = (double)r4;
	r15 = r15 / r16;
	r16 = 0.;
	if( !(r16 < r15) ) goto label$9830131_3_56;
	if( r11 == NULL ) hl_null_access();
	r12 = hl_types_ArrayDyn_get_length(r11);
	r18 = hl_alloc_dynamic(&t$_i32);
	r18->v.i = r12;
	r17 = vision_algorithms_Radix_countingSort(r11,r4,r18);
	r11 = r17;
	r12 = 10;
	r10 = r4 * r12;
	r4 = r10;
	goto label$9830131_3_41;
	label$9830131_3_56:
	r11 = r9;
	if( r9 == NULL ) hl_null_access();
	r4 = hl_types_ArrayDyn_get_length(r9);
	r18 = hl_alloc_dynamic(&t$_i32);
	r18->v.i = r4;
	r14 = vision_algorithms_Radix_getMax(r9,r18);
	r4 = 1;
	label$9830131_3_62:
	r15 = (double)hl_dyn_castd(&r14,&t$_dyn);
	r16 = (double)r4;
	r15 = r15 / r16;
	r16 = 0.;
	if( !(r16 < r15) ) goto label$9830131_3_77;
	if( r11 == NULL ) hl_null_access();
	r12 = hl_types_ArrayDyn_get_length(r11);
	r18 = hl_alloc_dynamic(&t$_i32);
	r18->v.i = r12;
	r17 = vision_algorithms_Radix_countingSort(r11,r4,r18);
	r11 = r17;
	r12 = 10;
	r10 = r4 * r12;
	r4 = r10;
	goto label$9830131_3_62;
	label$9830131_3_77:
	if( r1 == NULL ) hl_null_access();
	hl_types_ArrayDyn_reverse(r1);
	r3 = &t$_dyn;
	r4 = 0;
	r2 = hl_alloc_array(r3,r4);
	r5 = hl_types_ArrayObj_alloc(r2);
	r6 = true;
	r7 = &r6;
	r11 = hl_types_ArrayDyn_alloc(((hl__types__ArrayBase)r5),r7);
	r4 = 0;
	r17 = r1;
	label$9830131_3_88:
	if( r17 == NULL ) hl_null_access();
	r12 = hl_types_ArrayDyn_get_length(r17);
	if( r4 >= r12 ) goto label$9830131_3_98;
	r14 = ((vdynamic* (*)(hl__types__ArrayDyn,int))r17->$type->vobj_proto[0])(r17,r4);
	++r4;
	if( r11 == NULL ) hl_null_access();
	r19 = -r14;
	r10 = hl_types_ArrayDyn_push(r11,r19);
	goto label$9830131_3_88;
	label$9830131_3_98:
	if( r11 == NULL ) hl_null_access();
	r17 = hl_types_ArrayDyn_concat(r11,r9);
	return r17;
}
