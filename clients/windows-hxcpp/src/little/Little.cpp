// Generated by Haxe 4.3.3
#include <hxcpp.h>

#ifndef INCLUDED_little_KeywordConfig
#include <little/KeywordConfig.h>
#endif
#ifndef INCLUDED_little_Little
#include <little/Little.h>
#endif
#ifndef INCLUDED_little_interpreter_InterpTokens
#include <little/interpreter/InterpTokens.h>
#endif
#ifndef INCLUDED_little_interpreter_Interpreter
#include <little/interpreter/Interpreter.h>
#endif
#ifndef INCLUDED_little_interpreter_Runtime
#include <little/interpreter/Runtime.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_Memory
#include <little/interpreter/memory/Memory.h>
#endif
#ifndef INCLUDED_little_lexer_Lexer
#include <little/lexer/Lexer.h>
#endif
#ifndef INCLUDED_little_lexer_LexerTokens
#include <little/lexer/LexerTokens.h>
#endif
#ifndef INCLUDED_little_parser_Parser
#include <little/parser/Parser.h>
#endif
#ifndef INCLUDED_little_parser_ParserTokens
#include <little/parser/ParserTokens.h>
#endif
#ifndef INCLUDED_little_tools_Plugins
#include <little/tools/Plugins.h>
#endif
#ifndef INCLUDED_little_tools_PrepareRun
#include <little/tools/PrepareRun.h>
#endif
#ifndef INCLUDED_little_tools_PrettyPrinter
#include <little/tools/PrettyPrinter.h>
#endif
#ifndef INCLUDED_vision_ds_Queue_String
#include <vision/ds/Queue_String.h>
#endif

HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_82_loadModule,"little.Little","loadModule",0x799ca252,"little.Little.loadModule","little/Little.hx",82,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_121_run,"little.Little","run",0x02558c6b,"little.Little.run","little/Little.hx",121,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_161_compile,"little.Little","compile",0xe6f6da93,"little.Little.compile","little/Little.hx",161,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_165_format,"little.Little","format",0xf3abde17,"little.Little.format","little/Little.hx",165,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_170_reset,"little.Little","reset",0x619276ef,"little.Little.reset","little/Little.hx",170,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_27_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",27,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_34_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",34,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_40_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",40,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_47_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",47,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_54_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",54,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_62_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",62,0x981f31cf)
HX_LOCAL_STACK_FRAME(_hx_pos_9a3daa5a3ce12a32_68_boot,"little.Little","boot",0xfded5b12,"little.Little.boot","little/Little.hx",68,0x981f31cf)
namespace little{

void Little_obj::__construct() { }

Dynamic Little_obj::__CreateEmpty() { return new Little_obj; }

void *Little_obj::_hx_vtable = 0;

Dynamic Little_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< Little_obj > _hx_result = new Little_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool Little_obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x2369c2b8;
}

 ::little::KeywordConfig Little_obj::keywords;

 ::little::interpreter::Runtime Little_obj::runtime;

 ::little::interpreter::memory::Memory Little_obj::memory;

 ::little::tools::Plugins Little_obj::plugin;

 ::vision::ds::Queue_String Little_obj::queue;

bool Little_obj::debug;

::String Little_obj::version;

void Little_obj::loadModule(::String code,::String name,::hx::Null< bool >  __o_debug,::hx::Null< bool >  __o_runRightBeforeMain){
            		bool debug = __o_debug.Default(false);
            		bool runRightBeforeMain = __o_runRightBeforeMain.Default(false);
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_82_loadModule)
HXLINE(  83)		::little::Little_obj::runtime->errorThrown = false;
HXLINE(  84)		::little::Little_obj::runtime->line = 0;
HXLINE(  85)		::little::Little_obj::runtime->module = name;
HXLINE(  86)		if (runRightBeforeMain) {
HXLINE(  87)			::little::Little_obj::queue->enqueue(code);
            		}
            		else {
HXLINE(  89)			bool previous = ::little::Little_obj::debug;
HXLINE(  90)			::little::Little_obj::debug = debug;
HXLINE(  91)			if (!(::little::tools::PrepareRun_obj::prepared)) {
HXLINE(  92)				::little::tools::PrepareRun_obj::addTypes();
HXLINE(  93)				::little::tools::PrepareRun_obj::addSigns();
HXLINE(  94)				::little::tools::PrepareRun_obj::addFunctions();
HXLINE(  95)				::little::tools::PrepareRun_obj::addConditions();
HXLINE(  96)				::little::tools::PrepareRun_obj::addProps();
            			}
HXLINE(  98)			 ::Dynamic array = ::little::parser::Parser_obj::parse;
HXDLIN(  98)			::little::interpreter::Interpreter_obj::run(::little::interpreter::Interpreter_obj::convert(( (::Array< ::Dynamic>)(array(::little::lexer::Lexer_obj::lex(code))) )),null());
HXLINE(  99)			::little::Little_obj::debug = previous;
            		}
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC4(Little_obj,loadModule,(void))

void Little_obj::run(::String code, ::Dynamic debug){
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_121_run)
HXDLIN( 121)		try {
            			HX_STACK_CATCHABLE( ::Dynamic, 0);
HXLINE( 122)			bool previous = ::little::Little_obj::debug;
HXLINE( 123)			if (::hx::IsNotNull( debug )) {
HXLINE( 123)				::little::Little_obj::debug = ( (bool)(debug) );
            			}
HXLINE( 124)			if (!(::little::tools::PrepareRun_obj::prepared)) {
HXLINE( 125)				::little::tools::PrepareRun_obj::addTypes();
HXLINE( 126)				::little::tools::PrepareRun_obj::addSigns();
HXLINE( 127)				::little::tools::PrepareRun_obj::addFunctions();
HXLINE( 128)				::little::tools::PrepareRun_obj::addConditions();
HXLINE( 129)				::little::tools::PrepareRun_obj::addProps();
            			}
HXLINE( 131)			::little::Little_obj::runtime->module = ::little::Little_obj::keywords->MAIN_MODULE_NAME;
HXLINE( 132)			::little::Little_obj::runtime->errorThrown = false;
HXLINE( 133)			::little::Little_obj::runtime->line = 0;
HXLINE( 134)			::little::Little_obj::queue->enqueue(code);
HXLINE( 135)			{
HXLINE( 135)				 ::Dynamic item = ::little::Little_obj::queue->iterator();
HXDLIN( 135)				while(( (bool)(item->__Field(HX_("hasNext",6d,a5,46,18),::hx::paccDynamic)()) )){
HXLINE( 135)					::String item1 = ( (::String)(item->__Field(HX_("next",f3,84,02,49),::hx::paccDynamic)()) );
HXLINE( 136)					 ::Dynamic array = ::little::parser::Parser_obj::parse;
HXDLIN( 136)					::little::interpreter::Interpreter_obj::run(::little::interpreter::Interpreter_obj::convert(( (::Array< ::Dynamic>)(array(::little::lexer::Lexer_obj::lex(item1))) )),null());
            				}
            			}
HXLINE( 138)			if (::hx::IsNotNull( debug )) {
HXLINE( 138)				::little::Little_obj::debug = previous;
            			}
            		} catch( ::Dynamic _hx_e) {
            			if (_hx_e.IsClass<  ::Dynamic >() ){
            				HX_STACK_BEGIN_CATCH
            				 ::Dynamic _g = _hx_e;
            			}
            			else {
            				HX_STACK_DO_THROW(_hx_e);
            			}
            		}
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Little_obj,run,(void))

::Array< ::Dynamic> Little_obj::compile(::String code){
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_161_compile)
HXDLIN( 161)		 ::Dynamic array = ::little::parser::Parser_obj::parse;
HXDLIN( 161)		return ::little::interpreter::Interpreter_obj::convert(( (::Array< ::Dynamic>)(array(::little::lexer::Lexer_obj::lex(code))) ));
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Little_obj,compile,return )

::String Little_obj::format(::String code){
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_165_format)
HXDLIN( 165)		 ::Dynamic _hx_tmp = ::little::parser::Parser_obj::parse;
HXDLIN( 165)		return ::little::tools::PrettyPrinter_obj::stringifyParser(( (::Array< ::Dynamic>)(_hx_tmp(::little::lexer::Lexer_obj::lex(code))) ),null());
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Little_obj,format,return )

void Little_obj::reset(){
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_170_reset)
HXLINE( 171)		::little::Little_obj::runtime =  ::little::interpreter::Runtime_obj::__alloc( HX_CTX );
HXLINE( 172)		::little::Little_obj::memory->reset();
HXLINE( 173)		::little::Little_obj::queue =  ::vision::ds::Queue_String_obj::__alloc( HX_CTX );
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC0(Little_obj,reset,(void))


Little_obj::Little_obj()
{
}

bool Little_obj::__GetStatic(const ::String &inName, Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"run") ) { outValue = run_dyn(); return true; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"queue") ) { outValue = ( queue ); return true; }
		if (HX_FIELD_EQ(inName,"debug") ) { outValue = ( debug ); return true; }
		if (HX_FIELD_EQ(inName,"reset") ) { outValue = reset_dyn(); return true; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"memory") ) { outValue = ( memory ); return true; }
		if (HX_FIELD_EQ(inName,"plugin") ) { outValue = ( plugin ); return true; }
		if (HX_FIELD_EQ(inName,"format") ) { outValue = format_dyn(); return true; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"runtime") ) { outValue = ( runtime ); return true; }
		if (HX_FIELD_EQ(inName,"version") ) { outValue = ( version ); return true; }
		if (HX_FIELD_EQ(inName,"compile") ) { outValue = compile_dyn(); return true; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"keywords") ) { outValue = ( keywords ); return true; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"loadModule") ) { outValue = loadModule_dyn(); return true; }
	}
	return false;
}

bool Little_obj::__SetStatic(const ::String &inName,Dynamic &ioValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 5:
		if (HX_FIELD_EQ(inName,"queue") ) { queue=ioValue.Cast<  ::vision::ds::Queue_String >(); return true; }
		if (HX_FIELD_EQ(inName,"debug") ) { debug=ioValue.Cast< bool >(); return true; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"memory") ) { memory=ioValue.Cast<  ::little::interpreter::memory::Memory >(); return true; }
		if (HX_FIELD_EQ(inName,"plugin") ) { plugin=ioValue.Cast<  ::little::tools::Plugins >(); return true; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"runtime") ) { runtime=ioValue.Cast<  ::little::interpreter::Runtime >(); return true; }
		if (HX_FIELD_EQ(inName,"version") ) { version=ioValue.Cast< ::String >(); return true; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"keywords") ) { keywords=ioValue.Cast<  ::little::KeywordConfig >(); return true; }
	}
	return false;
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *Little_obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo Little_obj_sStaticStorageInfo[] = {
	{::hx::fsObject /*  ::little::KeywordConfig */ ,(void *) &Little_obj::keywords,HX_("keywords",6a,c5,a0,7f)},
	{::hx::fsObject /*  ::little::interpreter::Runtime */ ,(void *) &Little_obj::runtime,HX_("runtime",d8,b4,60,ef)},
	{::hx::fsObject /*  ::little::interpreter::memory::Memory */ ,(void *) &Little_obj::memory,HX_("memory",01,cb,bf,04)},
	{::hx::fsObject /*  ::little::tools::Plugins */ ,(void *) &Little_obj::plugin,HX_("plugin",b3,8a,e3,44)},
	{::hx::fsObject /*  ::vision::ds::Queue_String */ ,(void *) &Little_obj::queue,HX_("queue",91,8d,ea,5d)},
	{::hx::fsBool,(void *) &Little_obj::debug,HX_("debug",53,52,1f,d7)},
	{::hx::fsString,(void *) &Little_obj::version,HX_("version",18,e7,f1,7c)},
	{ ::hx::fsUnknown, 0, null()}
};
#endif

static void Little_obj_sMarkStatics(HX_MARK_PARAMS) {
	HX_MARK_MEMBER_NAME(Little_obj::keywords,"keywords");
	HX_MARK_MEMBER_NAME(Little_obj::runtime,"runtime");
	HX_MARK_MEMBER_NAME(Little_obj::memory,"memory");
	HX_MARK_MEMBER_NAME(Little_obj::plugin,"plugin");
	HX_MARK_MEMBER_NAME(Little_obj::queue,"queue");
	HX_MARK_MEMBER_NAME(Little_obj::debug,"debug");
	HX_MARK_MEMBER_NAME(Little_obj::version,"version");
};

#ifdef HXCPP_VISIT_ALLOCS
static void Little_obj_sVisitStatics(HX_VISIT_PARAMS) {
	HX_VISIT_MEMBER_NAME(Little_obj::keywords,"keywords");
	HX_VISIT_MEMBER_NAME(Little_obj::runtime,"runtime");
	HX_VISIT_MEMBER_NAME(Little_obj::memory,"memory");
	HX_VISIT_MEMBER_NAME(Little_obj::plugin,"plugin");
	HX_VISIT_MEMBER_NAME(Little_obj::queue,"queue");
	HX_VISIT_MEMBER_NAME(Little_obj::debug,"debug");
	HX_VISIT_MEMBER_NAME(Little_obj::version,"version");
};

#endif

::hx::Class Little_obj::__mClass;

static ::String Little_obj_sStaticFields[] = {
	HX_("keywords",6a,c5,a0,7f),
	HX_("runtime",d8,b4,60,ef),
	HX_("memory",01,cb,bf,04),
	HX_("plugin",b3,8a,e3,44),
	HX_("queue",91,8d,ea,5d),
	HX_("debug",53,52,1f,d7),
	HX_("version",18,e7,f1,7c),
	HX_("loadModule",72,63,fe,75),
	HX_("run",4b,e7,56,00),
	HX_("compile",73,25,6f,83),
	HX_("format",37,8f,8e,fd),
	HX_("reset",cf,49,c8,e6),
	::String(null())
};

void Little_obj::__register()
{
	Little_obj _hx_dummy;
	Little_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("little.Little",8e,f5,11,18);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &Little_obj::__GetStatic;
	__mClass->mSetStaticField = &Little_obj::__SetStatic;
	__mClass->mMarkFunc = Little_obj_sMarkStatics;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(Little_obj_sStaticFields);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< Little_obj >;
#ifdef HXCPP_VISIT_ALLOCS
	__mClass->mVisitFunc = Little_obj_sVisitStatics;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = Little_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = Little_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

void Little_obj::__boot()
{
{
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_27_boot)
HXDLIN(  27)		keywords =  ::little::KeywordConfig_obj::__alloc( HX_CTX ,null(),true);
            	}
{
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_34_boot)
HXDLIN(  34)		runtime =  ::little::interpreter::Runtime_obj::__alloc( HX_CTX );
            	}
{
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_40_boot)
HXDLIN(  40)		memory =  ::little::interpreter::memory::Memory_obj::__alloc( HX_CTX );
            	}
{
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_47_boot)
HXDLIN(  47)		plugin =  ::little::tools::Plugins_obj::__alloc( HX_CTX ,::little::Little_obj::memory);
            	}
{
            	HX_GC_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_54_boot)
HXDLIN(  54)		queue =  ::vision::ds::Queue_String_obj::__alloc( HX_CTX );
            	}
{
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_62_boot)
HXDLIN(  62)		debug = false;
            	}
{
            	HX_STACKFRAME(&_hx_pos_9a3daa5a3ce12a32_68_boot)
HXDLIN(  68)		version = HX_("1.0.0-f",8e,90,ce,1b);
            	}
}

} // end namespace little
