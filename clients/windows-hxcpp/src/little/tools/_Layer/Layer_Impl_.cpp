// Generated by Haxe 4.3.3
#include <hxcpp.h>

#ifndef INCLUDED_little_tools__Layer_Layer_Impl_
#include <little/tools/_Layer/Layer_Impl_.h>
#endif

HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_27_getIndexOf,"little.tools._Layer.Layer_Impl_","getIndexOf",0xaa21a401,"little.tools._Layer.Layer_Impl_.getIndexOf","little/tools/Layer.hx",27,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_7_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",7,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_8_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",8,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_9_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",9,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_10_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",10,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_11_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",11,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_12_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",12,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_13_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",13,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_14_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",14,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_15_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",15,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_16_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",16,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_17_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",17,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_18_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",18,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_19_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",19,0xc338239a)
HX_LOCAL_STACK_FRAME(_hx_pos_2a7736a61596dbd1_20_boot,"little.tools._Layer.Layer_Impl_","boot",0x06fb22e0,"little.tools._Layer.Layer_Impl_.boot","little/tools/Layer.hx",20,0xc338239a)
namespace little{
namespace tools{
namespace _Layer{

void Layer_Impl__obj::__construct() { }

Dynamic Layer_Impl__obj::__CreateEmpty() { return new Layer_Impl__obj; }

void *Layer_Impl__obj::_hx_vtable = 0;

Dynamic Layer_Impl__obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< Layer_Impl__obj > _hx_result = new Layer_Impl__obj();
	_hx_result->__construct();
	return _hx_result;
}

bool Layer_Impl__obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x2d86e0da;
}

::String Layer_Impl__obj::LEXER;

::String Layer_Impl__obj::PARSER;

::String Layer_Impl__obj::PARSER_MACRO;

::String Layer_Impl__obj::INTERPRETER;

::String Layer_Impl__obj::INTERPRETER_VALUE_EVALUATOR;

::String Layer_Impl__obj::INTERPRETER_EXPRESSION_EVALUATOR;

::String Layer_Impl__obj::INTERPRETER_TOKEN_VALUE_STRINGIFIER;

::String Layer_Impl__obj::INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER;

::String Layer_Impl__obj::MEMORY;

::String Layer_Impl__obj::MEMORY_REFERRER;

::String Layer_Impl__obj::MEMORY_STORAGE;

::String Layer_Impl__obj::MEMORY_EXTERNAL_INTERFACING;

::String Layer_Impl__obj::MEMORY_SIZE_EVALUATOR;

::String Layer_Impl__obj::MEMORY_GARBAGE_COLLECTOR;

int Layer_Impl__obj::getIndexOf(::String layer){
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_27_getIndexOf)
HXDLIN(  27)		::String _hx_switch_0 = layer;
            		if (  (_hx_switch_0==HX_("Interpreter",9a,09,07,b9)) ){
HXLINE(  31)			return 4;
HXDLIN(  31)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Interpreter, Expression Evaluator",b5,63,e3,68)) ){
HXLINE(  33)			return 6;
HXDLIN(  33)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Interpreter, Token Identifier Stringifier",a6,f8,78,11)) ){
HXLINE(  35)			return 8;
HXDLIN(  35)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Interpreter, Token Value Stringifier",a4,23,cb,3f)) ){
HXLINE(  34)			return 7;
HXDLIN(  34)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Interpreter, Value Evaluator",32,36,56,9c)) ){
HXLINE(  32)			return 5;
HXDLIN(  32)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Lexer",ec,09,92,05)) ){
HXLINE(  28)			return 1;
HXDLIN(  28)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory",21,3f,54,39)) ){
HXLINE(  36)			return 9;
HXDLIN(  36)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory, External Interfacing",36,f2,8f,d6)) ){
HXLINE(  39)			return 12;
HXDLIN(  39)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory, Garbage Collector",6d,ac,97,1e)) ){
HXLINE(  41)			return 14;
HXDLIN(  41)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory, Referrer",d4,85,0f,64)) ){
HXLINE(  37)			return 10;
HXDLIN(  37)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory, Size Evaluator",25,3d,71,96)) ){
HXLINE(  40)			return 13;
HXDLIN(  40)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Memory, Storage",e6,ab,0b,93)) ){
HXLINE(  38)			return 11;
HXDLIN(  38)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Parser",ff,10,1d,22)) ){
HXLINE(  29)			return 2;
HXDLIN(  29)			goto _hx_goto_0;
            		}
            		if (  (_hx_switch_0==HX_("Parser, Macro",d9,71,44,b3)) ){
HXLINE(  30)			return 3;
HXDLIN(  30)			goto _hx_goto_0;
            		}
            		/* default */{
HXLINE(  42)			return 999999999;
            		}
            		_hx_goto_0:;
HXLINE(  27)		return 0;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Layer_Impl__obj,getIndexOf,return )


Layer_Impl__obj::Layer_Impl__obj()
{
}

bool Layer_Impl__obj::__GetStatic(const ::String &inName, Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 10:
		if (HX_FIELD_EQ(inName,"getIndexOf") ) { outValue = getIndexOf_dyn(); return true; }
	}
	return false;
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *Layer_Impl__obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo Layer_Impl__obj_sStaticStorageInfo[] = {
	{::hx::fsString,(void *) &Layer_Impl__obj::LEXER,HX_("LEXER",ec,d1,52,f0)},
	{::hx::fsString,(void *) &Layer_Impl__obj::PARSER,HX_("PARSER",df,48,0b,a0)},
	{::hx::fsString,(void *) &Layer_Impl__obj::PARSER_MACRO,HX_("PARSER_MACRO",4c,a9,cf,79)},
	{::hx::fsString,(void *) &Layer_Impl__obj::INTERPRETER,HX_("INTERPRETER",9a,7d,10,ab)},
	{::hx::fsString,(void *) &Layer_Impl__obj::INTERPRETER_VALUE_EVALUATOR,HX_("INTERPRETER_VALUE_EVALUATOR",fc,5c,56,c6)},
	{::hx::fsString,(void *) &Layer_Impl__obj::INTERPRETER_EXPRESSION_EVALUATOR,HX_("INTERPRETER_EXPRESSION_EVALUATOR",ed,7f,63,eb)},
	{::hx::fsString,(void *) &Layer_Impl__obj::INTERPRETER_TOKEN_VALUE_STRINGIFIER,HX_("INTERPRETER_TOKEN_VALUE_STRINGIFIER",8f,ca,3a,8d)},
	{::hx::fsString,(void *) &Layer_Impl__obj::INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER,HX_("INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER",9d,99,b2,66)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY,HX_("MEMORY",01,77,42,b7)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY_REFERRER,HX_("MEMORY_REFERRER",1d,e5,9b,6b)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY_STORAGE,HX_("MEMORY_STORAGE",9d,ec,37,d2)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY_EXTERNAL_INTERFACING,HX_("MEMORY_EXTERNAL_INTERFACING",20,09,b8,72)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY_SIZE_EVALUATOR,HX_("MEMORY_SIZE_EVALUATOR",0f,01,00,8e)},
	{::hx::fsString,(void *) &Layer_Impl__obj::MEMORY_GARBAGE_COLLECTOR,HX_("MEMORY_GARBAGE_COLLECTOR",c5,a7,6b,f2)},
	{ ::hx::fsUnknown, 0, null()}
};
#endif

static void Layer_Impl__obj_sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::LEXER,"LEXER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::PARSER,"PARSER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::PARSER_MACRO,"PARSER_MACRO");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::INTERPRETER,"INTERPRETER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_VALUE_EVALUATOR,"INTERPRETER_VALUE_EVALUATOR");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_EXPRESSION_EVALUATOR,"INTERPRETER_EXPRESSION_EVALUATOR");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_TOKEN_VALUE_STRINGIFIER,"INTERPRETER_TOKEN_VALUE_STRINGIFIER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER,"INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY,"MEMORY");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY_REFERRER,"MEMORY_REFERRER");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY_STORAGE,"MEMORY_STORAGE");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY_EXTERNAL_INTERFACING,"MEMORY_EXTERNAL_INTERFACING");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY_SIZE_EVALUATOR,"MEMORY_SIZE_EVALUATOR");
	HX_MARK_MEMBER_NAME(Layer_Impl__obj::MEMORY_GARBAGE_COLLECTOR,"MEMORY_GARBAGE_COLLECTOR");
};

#ifdef HXCPP_VISIT_ALLOCS
static void Layer_Impl__obj_sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::LEXER,"LEXER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::PARSER,"PARSER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::PARSER_MACRO,"PARSER_MACRO");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::INTERPRETER,"INTERPRETER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_VALUE_EVALUATOR,"INTERPRETER_VALUE_EVALUATOR");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_EXPRESSION_EVALUATOR,"INTERPRETER_EXPRESSION_EVALUATOR");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_TOKEN_VALUE_STRINGIFIER,"INTERPRETER_TOKEN_VALUE_STRINGIFIER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER,"INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY,"MEMORY");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY_REFERRER,"MEMORY_REFERRER");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY_STORAGE,"MEMORY_STORAGE");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY_EXTERNAL_INTERFACING,"MEMORY_EXTERNAL_INTERFACING");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY_SIZE_EVALUATOR,"MEMORY_SIZE_EVALUATOR");
	HX_VISIT_MEMBER_NAME(Layer_Impl__obj::MEMORY_GARBAGE_COLLECTOR,"MEMORY_GARBAGE_COLLECTOR");
};

#endif

::hx::Class Layer_Impl__obj::__mClass;

static ::String Layer_Impl__obj_sStaticFields[] = {
	HX_("LEXER",ec,d1,52,f0),
	HX_("PARSER",df,48,0b,a0),
	HX_("PARSER_MACRO",4c,a9,cf,79),
	HX_("INTERPRETER",9a,7d,10,ab),
	HX_("INTERPRETER_VALUE_EVALUATOR",fc,5c,56,c6),
	HX_("INTERPRETER_EXPRESSION_EVALUATOR",ed,7f,63,eb),
	HX_("INTERPRETER_TOKEN_VALUE_STRINGIFIER",8f,ca,3a,8d),
	HX_("INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER",9d,99,b2,66),
	HX_("MEMORY",01,77,42,b7),
	HX_("MEMORY_REFERRER",1d,e5,9b,6b),
	HX_("MEMORY_STORAGE",9d,ec,37,d2),
	HX_("MEMORY_EXTERNAL_INTERFACING",20,09,b8,72),
	HX_("MEMORY_SIZE_EVALUATOR",0f,01,00,8e),
	HX_("MEMORY_GARBAGE_COLLECTOR",c5,a7,6b,f2),
	HX_("getIndexOf",d3,ce,20,30),
	::String(null())
};

void Layer_Impl__obj::__register()
{
	Layer_Impl__obj _hx_dummy;
	Layer_Impl__obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("little.tools._Layer.Layer_Impl_",80,40,35,fb);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &Layer_Impl__obj::__GetStatic;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mMarkFunc = Layer_Impl__obj_sMarkStatics;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(Layer_Impl__obj_sStaticFields);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< Layer_Impl__obj >;
#ifdef HXCPP_VISIT_ALLOCS
	__mClass->mVisitFunc = Layer_Impl__obj_sVisitStatics;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = Layer_Impl__obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = Layer_Impl__obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

void Layer_Impl__obj::__boot()
{
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_7_boot)
HXDLIN(   7)		LEXER = HX_("Lexer",ec,09,92,05);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_8_boot)
HXDLIN(   8)		PARSER = HX_("Parser",ff,10,1d,22);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_9_boot)
HXDLIN(   9)		PARSER_MACRO = HX_("Parser, Macro",d9,71,44,b3);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_10_boot)
HXDLIN(  10)		INTERPRETER = HX_("Interpreter",9a,09,07,b9);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_11_boot)
HXDLIN(  11)		INTERPRETER_VALUE_EVALUATOR = HX_("Interpreter, Value Evaluator",32,36,56,9c);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_12_boot)
HXDLIN(  12)		INTERPRETER_EXPRESSION_EVALUATOR = HX_("Interpreter, Expression Evaluator",b5,63,e3,68);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_13_boot)
HXDLIN(  13)		INTERPRETER_TOKEN_VALUE_STRINGIFIER = HX_("Interpreter, Token Value Stringifier",a4,23,cb,3f);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_14_boot)
HXDLIN(  14)		INTERPRETER_TOKEN_IDENTIFIER_STRINGIFIER = HX_("Interpreter, Token Identifier Stringifier",a6,f8,78,11);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_15_boot)
HXDLIN(  15)		MEMORY = HX_("Memory",21,3f,54,39);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_16_boot)
HXDLIN(  16)		MEMORY_REFERRER = HX_("Memory, Referrer",d4,85,0f,64);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_17_boot)
HXDLIN(  17)		MEMORY_STORAGE = HX_("Memory, Storage",e6,ab,0b,93);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_18_boot)
HXDLIN(  18)		MEMORY_EXTERNAL_INTERFACING = HX_("Memory, External Interfacing",36,f2,8f,d6);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_19_boot)
HXDLIN(  19)		MEMORY_SIZE_EVALUATOR = HX_("Memory, Size Evaluator",25,3d,71,96);
            	}
{
            	HX_STACKFRAME(&_hx_pos_2a7736a61596dbd1_20_boot)
HXDLIN(  20)		MEMORY_GARBAGE_COLLECTOR = HX_("Memory, Garbage Collector",6d,ac,97,1e);
            	}
}

} // end namespace little
} // end namespace tools
} // end namespace _Layer
