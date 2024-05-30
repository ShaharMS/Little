// Generated by Haxe 4.3.3
#include <hxcpp.h>

#ifndef INCLUDED_haxe_IMap
#include <haxe/IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_little_interpreter_InterpTokens
#include <little/interpreter/InterpTokens.h>
#endif
#ifndef INCLUDED_little_tools_BaseOrderedMap
#include <little/tools/BaseOrderedMap.h>
#endif
namespace little{
namespace interpreter{

::little::interpreter::InterpTokens InterpTokens_obj::Block(::Array< ::Dynamic> body, ::little::interpreter::InterpTokens type)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Block",2d,e5,29,48),13,2)->_hx_init(0,body)->_hx_init(1,type);
}

::little::interpreter::InterpTokens InterpTokens_obj::Characters(::String string)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Characters",ca,5c,7f,4c),18,1)->_hx_init(0,string);
}

::little::interpreter::InterpTokens InterpTokens_obj::ClassPointer(int pointer)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("ClassPointer",85,b3,b4,01),20,1)->_hx_init(0,pointer);
}

::little::interpreter::InterpTokens InterpTokens_obj::ConditionCall( ::little::interpreter::InterpTokens name, ::little::interpreter::InterpTokens exp, ::little::interpreter::InterpTokens body)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("ConditionCall",b9,e7,7b,a2),6,3)->_hx_init(0,name)->_hx_init(1,exp)->_hx_init(2,body);
}

::little::interpreter::InterpTokens InterpTokens_obj::ConditionCode( ::haxe::ds::ObjectMap callers)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("ConditionCode",48,80,86,a2),5,1)->_hx_init(0,callers);
}

::little::interpreter::InterpTokens InterpTokens_obj::Decimal(Float num)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Decimal",71,dc,24,b4),17,1)->_hx_init(0,num);
}

::little::interpreter::InterpTokens InterpTokens_obj::Documentation(::String doc)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Documentation",9a,d1,58,89),19,1)->_hx_init(0,doc);
}

::little::interpreter::InterpTokens InterpTokens_obj::ErrorMessage(::String msg)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("ErrorMessage",ff,66,53,13),27,1)->_hx_init(0,msg);
}

::little::interpreter::InterpTokens InterpTokens_obj::Expression(::Array< ::Dynamic> parts, ::little::interpreter::InterpTokens type)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Expression",b8,15,50,25),12,2)->_hx_init(0,parts)->_hx_init(1,type);
}

::little::interpreter::InterpTokens InterpTokens_obj::FalseValue;

::little::interpreter::InterpTokens InterpTokens_obj::FunctionCall( ::little::interpreter::InterpTokens name, ::little::interpreter::InterpTokens params)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("FunctionCall",f6,a7,c7,f0),8,2)->_hx_init(0,name)->_hx_init(1,params);
}

::little::interpreter::InterpTokens InterpTokens_obj::FunctionCode( ::little::tools::BaseOrderedMap requiredParams, ::little::interpreter::InterpTokens body)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("FunctionCode",85,40,d2,f0),7,2)->_hx_init(0,requiredParams)->_hx_init(1,body);
}

::little::interpreter::InterpTokens InterpTokens_obj::FunctionDeclaration( ::little::interpreter::InterpTokens name, ::little::interpreter::InterpTokens params, ::little::interpreter::InterpTokens type, ::little::interpreter::InterpTokens doc)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("FunctionDeclaration",a2,b0,bc,39),4,4)->_hx_init(0,name)->_hx_init(1,params)->_hx_init(2,type)->_hx_init(3,doc);
}

::little::interpreter::InterpTokens InterpTokens_obj::FunctionReturn( ::little::interpreter::InterpTokens value, ::little::interpreter::InterpTokens type)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("FunctionReturn",08,ba,3f,c2),9,2)->_hx_init(0,value)->_hx_init(1,type);
}

::little::interpreter::InterpTokens InterpTokens_obj::HaxeExtern( ::Dynamic func)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("HaxeExtern",46,22,b7,35),28,1)->_hx_init(0,func);
}

::little::interpreter::InterpTokens InterpTokens_obj::Identifier(::String word)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Identifier",89,cc,dd,c4),25,1)->_hx_init(0,word);
}

::little::interpreter::InterpTokens InterpTokens_obj::NullValue;

::little::interpreter::InterpTokens InterpTokens_obj::Number(int num)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Number",e9,fa,0e,d6),16,1)->_hx_init(0,num);
}

::little::interpreter::InterpTokens InterpTokens_obj::Object( ::haxe::ds::StringMap props,::String typeName)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Object",df,f2,d3,49),26,2)->_hx_init(0,props)->_hx_init(1,typeName);
}

::little::interpreter::InterpTokens InterpTokens_obj::PartArray(::Array< ::Dynamic> parts)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("PartArray",86,a8,3f,36),14,1)->_hx_init(0,parts);
}

::little::interpreter::InterpTokens InterpTokens_obj::PropertyAccess( ::little::interpreter::InterpTokens name, ::little::interpreter::InterpTokens property)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("PropertyAccess",f9,53,2f,68),15,2)->_hx_init(0,name)->_hx_init(1,property);
}

::little::interpreter::InterpTokens InterpTokens_obj::SetLine(int line)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("SetLine",96,80,88,da),0,1)->_hx_init(0,line);
}

::little::interpreter::InterpTokens InterpTokens_obj::SetModule(::String module)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("SetModule",ce,89,4d,c2),1,1)->_hx_init(0,module);
}

::little::interpreter::InterpTokens InterpTokens_obj::Sign(::String sign)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Sign",5d,bc,2c,37),21,1)->_hx_init(0,sign);
}

::little::interpreter::InterpTokens InterpTokens_obj::SplitLine;

::little::interpreter::InterpTokens InterpTokens_obj::TrueValue;

::little::interpreter::InterpTokens InterpTokens_obj::TypeCast( ::little::interpreter::InterpTokens value, ::little::interpreter::InterpTokens type)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("TypeCast",b9,de,36,88),11,2)->_hx_init(0,value)->_hx_init(1,type);
}

::little::interpreter::InterpTokens InterpTokens_obj::VariableDeclaration( ::little::interpreter::InterpTokens name, ::little::interpreter::InterpTokens type, ::little::interpreter::InterpTokens doc)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("VariableDeclaration",fe,13,49,4f),3,3)->_hx_init(0,name)->_hx_init(1,type)->_hx_init(2,doc);
}

::little::interpreter::InterpTokens InterpTokens_obj::Write(::Array< ::Dynamic> assignees, ::little::interpreter::InterpTokens value)
{
	return ::hx::CreateEnum< InterpTokens_obj >(HX_("Write",bf,dc,86,63),10,2)->_hx_init(0,assignees)->_hx_init(1,value);
}

bool InterpTokens_obj::__GetStatic(const ::String &inName, ::Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	if (inName==HX_("Block",2d,e5,29,48)) { outValue = InterpTokens_obj::Block_dyn(); return true; }
	if (inName==HX_("Characters",ca,5c,7f,4c)) { outValue = InterpTokens_obj::Characters_dyn(); return true; }
	if (inName==HX_("ClassPointer",85,b3,b4,01)) { outValue = InterpTokens_obj::ClassPointer_dyn(); return true; }
	if (inName==HX_("ConditionCall",b9,e7,7b,a2)) { outValue = InterpTokens_obj::ConditionCall_dyn(); return true; }
	if (inName==HX_("ConditionCode",48,80,86,a2)) { outValue = InterpTokens_obj::ConditionCode_dyn(); return true; }
	if (inName==HX_("Decimal",71,dc,24,b4)) { outValue = InterpTokens_obj::Decimal_dyn(); return true; }
	if (inName==HX_("Documentation",9a,d1,58,89)) { outValue = InterpTokens_obj::Documentation_dyn(); return true; }
	if (inName==HX_("ErrorMessage",ff,66,53,13)) { outValue = InterpTokens_obj::ErrorMessage_dyn(); return true; }
	if (inName==HX_("Expression",b8,15,50,25)) { outValue = InterpTokens_obj::Expression_dyn(); return true; }
	if (inName==HX_("FalseValue",ee,6e,33,78)) { outValue = InterpTokens_obj::FalseValue; return true; }
	if (inName==HX_("FunctionCall",f6,a7,c7,f0)) { outValue = InterpTokens_obj::FunctionCall_dyn(); return true; }
	if (inName==HX_("FunctionCode",85,40,d2,f0)) { outValue = InterpTokens_obj::FunctionCode_dyn(); return true; }
	if (inName==HX_("FunctionDeclaration",a2,b0,bc,39)) { outValue = InterpTokens_obj::FunctionDeclaration_dyn(); return true; }
	if (inName==HX_("FunctionReturn",08,ba,3f,c2)) { outValue = InterpTokens_obj::FunctionReturn_dyn(); return true; }
	if (inName==HX_("HaxeExtern",46,22,b7,35)) { outValue = InterpTokens_obj::HaxeExtern_dyn(); return true; }
	if (inName==HX_("Identifier",89,cc,dd,c4)) { outValue = InterpTokens_obj::Identifier_dyn(); return true; }
	if (inName==HX_("NullValue",4a,27,1b,e8)) { outValue = InterpTokens_obj::NullValue; return true; }
	if (inName==HX_("Number",e9,fa,0e,d6)) { outValue = InterpTokens_obj::Number_dyn(); return true; }
	if (inName==HX_("Object",df,f2,d3,49)) { outValue = InterpTokens_obj::Object_dyn(); return true; }
	if (inName==HX_("PartArray",86,a8,3f,36)) { outValue = InterpTokens_obj::PartArray_dyn(); return true; }
	if (inName==HX_("PropertyAccess",f9,53,2f,68)) { outValue = InterpTokens_obj::PropertyAccess_dyn(); return true; }
	if (inName==HX_("SetLine",96,80,88,da)) { outValue = InterpTokens_obj::SetLine_dyn(); return true; }
	if (inName==HX_("SetModule",ce,89,4d,c2)) { outValue = InterpTokens_obj::SetModule_dyn(); return true; }
	if (inName==HX_("Sign",5d,bc,2c,37)) { outValue = InterpTokens_obj::Sign_dyn(); return true; }
	if (inName==HX_("SplitLine",ce,83,e5,ed)) { outValue = InterpTokens_obj::SplitLine; return true; }
	if (inName==HX_("TrueValue",23,ed,ed,d7)) { outValue = InterpTokens_obj::TrueValue; return true; }
	if (inName==HX_("TypeCast",b9,de,36,88)) { outValue = InterpTokens_obj::TypeCast_dyn(); return true; }
	if (inName==HX_("VariableDeclaration",fe,13,49,4f)) { outValue = InterpTokens_obj::VariableDeclaration_dyn(); return true; }
	if (inName==HX_("Write",bf,dc,86,63)) { outValue = InterpTokens_obj::Write_dyn(); return true; }
	return super::__GetStatic(inName, outValue, inCallProp);
}

HX_DEFINE_CREATE_ENUM(InterpTokens_obj)

int InterpTokens_obj::__FindIndex(::String inName)
{
	if (inName==HX_("Block",2d,e5,29,48)) return 13;
	if (inName==HX_("Characters",ca,5c,7f,4c)) return 18;
	if (inName==HX_("ClassPointer",85,b3,b4,01)) return 20;
	if (inName==HX_("ConditionCall",b9,e7,7b,a2)) return 6;
	if (inName==HX_("ConditionCode",48,80,86,a2)) return 5;
	if (inName==HX_("Decimal",71,dc,24,b4)) return 17;
	if (inName==HX_("Documentation",9a,d1,58,89)) return 19;
	if (inName==HX_("ErrorMessage",ff,66,53,13)) return 27;
	if (inName==HX_("Expression",b8,15,50,25)) return 12;
	if (inName==HX_("FalseValue",ee,6e,33,78)) return 24;
	if (inName==HX_("FunctionCall",f6,a7,c7,f0)) return 8;
	if (inName==HX_("FunctionCode",85,40,d2,f0)) return 7;
	if (inName==HX_("FunctionDeclaration",a2,b0,bc,39)) return 4;
	if (inName==HX_("FunctionReturn",08,ba,3f,c2)) return 9;
	if (inName==HX_("HaxeExtern",46,22,b7,35)) return 28;
	if (inName==HX_("Identifier",89,cc,dd,c4)) return 25;
	if (inName==HX_("NullValue",4a,27,1b,e8)) return 22;
	if (inName==HX_("Number",e9,fa,0e,d6)) return 16;
	if (inName==HX_("Object",df,f2,d3,49)) return 26;
	if (inName==HX_("PartArray",86,a8,3f,36)) return 14;
	if (inName==HX_("PropertyAccess",f9,53,2f,68)) return 15;
	if (inName==HX_("SetLine",96,80,88,da)) return 0;
	if (inName==HX_("SetModule",ce,89,4d,c2)) return 1;
	if (inName==HX_("Sign",5d,bc,2c,37)) return 21;
	if (inName==HX_("SplitLine",ce,83,e5,ed)) return 2;
	if (inName==HX_("TrueValue",23,ed,ed,d7)) return 23;
	if (inName==HX_("TypeCast",b9,de,36,88)) return 11;
	if (inName==HX_("VariableDeclaration",fe,13,49,4f)) return 3;
	if (inName==HX_("Write",bf,dc,86,63)) return 10;
	return super::__FindIndex(inName);
}

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,Block,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Characters,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,ClassPointer,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC3(InterpTokens_obj,ConditionCall,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,ConditionCode,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Decimal,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Documentation,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,ErrorMessage,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,Expression,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,FunctionCall,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,FunctionCode,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC4(InterpTokens_obj,FunctionDeclaration,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,FunctionReturn,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,HaxeExtern,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Identifier,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Number,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,Object,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,PartArray,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,PropertyAccess,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,SetLine,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,SetModule,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC1(InterpTokens_obj,Sign,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,TypeCast,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC3(InterpTokens_obj,VariableDeclaration,return)

STATIC_HX_DEFINE_DYNAMIC_FUNC2(InterpTokens_obj,Write,return)

int InterpTokens_obj::__FindArgCount(::String inName)
{
	if (inName==HX_("Block",2d,e5,29,48)) return 2;
	if (inName==HX_("Characters",ca,5c,7f,4c)) return 1;
	if (inName==HX_("ClassPointer",85,b3,b4,01)) return 1;
	if (inName==HX_("ConditionCall",b9,e7,7b,a2)) return 3;
	if (inName==HX_("ConditionCode",48,80,86,a2)) return 1;
	if (inName==HX_("Decimal",71,dc,24,b4)) return 1;
	if (inName==HX_("Documentation",9a,d1,58,89)) return 1;
	if (inName==HX_("ErrorMessage",ff,66,53,13)) return 1;
	if (inName==HX_("Expression",b8,15,50,25)) return 2;
	if (inName==HX_("FalseValue",ee,6e,33,78)) return 0;
	if (inName==HX_("FunctionCall",f6,a7,c7,f0)) return 2;
	if (inName==HX_("FunctionCode",85,40,d2,f0)) return 2;
	if (inName==HX_("FunctionDeclaration",a2,b0,bc,39)) return 4;
	if (inName==HX_("FunctionReturn",08,ba,3f,c2)) return 2;
	if (inName==HX_("HaxeExtern",46,22,b7,35)) return 1;
	if (inName==HX_("Identifier",89,cc,dd,c4)) return 1;
	if (inName==HX_("NullValue",4a,27,1b,e8)) return 0;
	if (inName==HX_("Number",e9,fa,0e,d6)) return 1;
	if (inName==HX_("Object",df,f2,d3,49)) return 2;
	if (inName==HX_("PartArray",86,a8,3f,36)) return 1;
	if (inName==HX_("PropertyAccess",f9,53,2f,68)) return 2;
	if (inName==HX_("SetLine",96,80,88,da)) return 1;
	if (inName==HX_("SetModule",ce,89,4d,c2)) return 1;
	if (inName==HX_("Sign",5d,bc,2c,37)) return 1;
	if (inName==HX_("SplitLine",ce,83,e5,ed)) return 0;
	if (inName==HX_("TrueValue",23,ed,ed,d7)) return 0;
	if (inName==HX_("TypeCast",b9,de,36,88)) return 2;
	if (inName==HX_("VariableDeclaration",fe,13,49,4f)) return 3;
	if (inName==HX_("Write",bf,dc,86,63)) return 2;
	return super::__FindArgCount(inName);
}

::hx::Val InterpTokens_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	if (inName==HX_("Block",2d,e5,29,48)) return Block_dyn();
	if (inName==HX_("Characters",ca,5c,7f,4c)) return Characters_dyn();
	if (inName==HX_("ClassPointer",85,b3,b4,01)) return ClassPointer_dyn();
	if (inName==HX_("ConditionCall",b9,e7,7b,a2)) return ConditionCall_dyn();
	if (inName==HX_("ConditionCode",48,80,86,a2)) return ConditionCode_dyn();
	if (inName==HX_("Decimal",71,dc,24,b4)) return Decimal_dyn();
	if (inName==HX_("Documentation",9a,d1,58,89)) return Documentation_dyn();
	if (inName==HX_("ErrorMessage",ff,66,53,13)) return ErrorMessage_dyn();
	if (inName==HX_("Expression",b8,15,50,25)) return Expression_dyn();
	if (inName==HX_("FalseValue",ee,6e,33,78)) return FalseValue;
	if (inName==HX_("FunctionCall",f6,a7,c7,f0)) return FunctionCall_dyn();
	if (inName==HX_("FunctionCode",85,40,d2,f0)) return FunctionCode_dyn();
	if (inName==HX_("FunctionDeclaration",a2,b0,bc,39)) return FunctionDeclaration_dyn();
	if (inName==HX_("FunctionReturn",08,ba,3f,c2)) return FunctionReturn_dyn();
	if (inName==HX_("HaxeExtern",46,22,b7,35)) return HaxeExtern_dyn();
	if (inName==HX_("Identifier",89,cc,dd,c4)) return Identifier_dyn();
	if (inName==HX_("NullValue",4a,27,1b,e8)) return NullValue;
	if (inName==HX_("Number",e9,fa,0e,d6)) return Number_dyn();
	if (inName==HX_("Object",df,f2,d3,49)) return Object_dyn();
	if (inName==HX_("PartArray",86,a8,3f,36)) return PartArray_dyn();
	if (inName==HX_("PropertyAccess",f9,53,2f,68)) return PropertyAccess_dyn();
	if (inName==HX_("SetLine",96,80,88,da)) return SetLine_dyn();
	if (inName==HX_("SetModule",ce,89,4d,c2)) return SetModule_dyn();
	if (inName==HX_("Sign",5d,bc,2c,37)) return Sign_dyn();
	if (inName==HX_("SplitLine",ce,83,e5,ed)) return SplitLine;
	if (inName==HX_("TrueValue",23,ed,ed,d7)) return TrueValue;
	if (inName==HX_("TypeCast",b9,de,36,88)) return TypeCast_dyn();
	if (inName==HX_("VariableDeclaration",fe,13,49,4f)) return VariableDeclaration_dyn();
	if (inName==HX_("Write",bf,dc,86,63)) return Write_dyn();
	return super::__Field(inName,inCallProp);
}

static ::String InterpTokens_obj_sStaticFields[] = {
	HX_("SetLine",96,80,88,da),
	HX_("SetModule",ce,89,4d,c2),
	HX_("SplitLine",ce,83,e5,ed),
	HX_("VariableDeclaration",fe,13,49,4f),
	HX_("FunctionDeclaration",a2,b0,bc,39),
	HX_("ConditionCode",48,80,86,a2),
	HX_("ConditionCall",b9,e7,7b,a2),
	HX_("FunctionCode",85,40,d2,f0),
	HX_("FunctionCall",f6,a7,c7,f0),
	HX_("FunctionReturn",08,ba,3f,c2),
	HX_("Write",bf,dc,86,63),
	HX_("TypeCast",b9,de,36,88),
	HX_("Expression",b8,15,50,25),
	HX_("Block",2d,e5,29,48),
	HX_("PartArray",86,a8,3f,36),
	HX_("PropertyAccess",f9,53,2f,68),
	HX_("Number",e9,fa,0e,d6),
	HX_("Decimal",71,dc,24,b4),
	HX_("Characters",ca,5c,7f,4c),
	HX_("Documentation",9a,d1,58,89),
	HX_("ClassPointer",85,b3,b4,01),
	HX_("Sign",5d,bc,2c,37),
	HX_("NullValue",4a,27,1b,e8),
	HX_("TrueValue",23,ed,ed,d7),
	HX_("FalseValue",ee,6e,33,78),
	HX_("Identifier",89,cc,dd,c4),
	HX_("Object",df,f2,d3,49),
	HX_("ErrorMessage",ff,66,53,13),
	HX_("HaxeExtern",46,22,b7,35),
	::String(null())
};

::hx::Class InterpTokens_obj::__mClass;

Dynamic __Create_InterpTokens_obj() { return new InterpTokens_obj; }

void InterpTokens_obj::__register()
{

::hx::Static(__mClass) = ::hx::_hx_RegisterClass(HX_("little.interpreter.InterpTokens",1a,72,c4,82), ::hx::TCanCast< InterpTokens_obj >,InterpTokens_obj_sStaticFields,0,
	&__Create_InterpTokens_obj, &__Create,
	&super::__SGetClass(), &CreateInterpTokens_obj, 0
#ifdef HXCPP_VISIT_ALLOCS
    , 0
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
	__mClass->mGetStaticField = &InterpTokens_obj::__GetStatic;
}

void InterpTokens_obj::__boot()
{
FalseValue = ::hx::CreateConstEnum< InterpTokens_obj >(HX_("FalseValue",ee,6e,33,78),24);
NullValue = ::hx::CreateConstEnum< InterpTokens_obj >(HX_("NullValue",4a,27,1b,e8),22);
SplitLine = ::hx::CreateConstEnum< InterpTokens_obj >(HX_("SplitLine",ce,83,e5,ed),2);
TrueValue = ::hx::CreateConstEnum< InterpTokens_obj >(HX_("TrueValue",23,ed,ed,d7),23);
}


} // end namespace little
} // end namespace interpreter
