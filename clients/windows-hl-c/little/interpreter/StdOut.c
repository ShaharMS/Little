﻿// Generated by HLC 4.3.4 (HL v5)
#define HLC_BOOT
#include <hlc.h>
#include <little/interpreter/StdOut.h>
extern String s$;
extern hl_type t$hl_types_ArrayObj;
void hl_types_ArrayObj_new(hl__types__ArrayObj);

void little_interpreter_StdOut_reset(little__interpreter__StdOut r0) {
	String r1;
	hl__types__ArrayObj r2;
	r1 = (String)s$;
	r0->output = r1;
	r2 = (hl__types__ArrayObj)hl_alloc_obj(&t$hl_types_ArrayObj);
	hl_types_ArrayObj_new(r2);
	r0->stdoutTokens = r2;
	return;
}

void little_interpreter_StdOut_new(little__interpreter__StdOut r0) {
	String r3;
	hl__types__ArrayObj r1;
	r1 = (hl__types__ArrayObj)hl_alloc_obj(&t$hl_types_ArrayObj);
	hl_types_ArrayObj_new(r1);
	r0->stdoutTokens = r1;
	r3 = (String)s$;
	r0->output = r3;
	return;
}
