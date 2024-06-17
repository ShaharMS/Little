// Generated by Haxe 4.3.4
#include <hxcpp.h>

#ifndef INCLUDED_Std
#include <Std.h>
#endif
#ifndef INCLUDED_Type
#include <Type.h>
#endif
#ifndef INCLUDED_haxe_IMap
#include <haxe/IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_ObjectMap
#include <haxe/ds/ObjectMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
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
#ifndef INCLUDED_little_interpreter_memory_ConstantPool
#include <little/interpreter/memory/ConstantPool.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_Memory
#include <little/interpreter/memory/Memory.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_Storage
#include <little/interpreter/memory/Storage.h>
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
#ifndef INCLUDED_little_tools_BaseOrderedMap
#include <little/tools/BaseOrderedMap.h>
#endif
#ifndef INCLUDED_little_tools_Extensions
#include <little/tools/Extensions.h>
#endif
#ifndef INCLUDED_little_tools_InterpTokensSimple
#include <little/tools/InterpTokensSimple.h>
#endif
#ifndef INCLUDED_little_tools_TextTools
#include <little/tools/TextTools.h>
#endif

HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_36_tokenize,"little.tools.Extensions","tokenize",0x70a4d22a,"little.tools.Extensions.tokenize","little/tools/Extensions.hx",36,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_43_eval,"little.tools.Extensions","eval",0x1dbdc44b,"little.tools.Extensions.eval","little/tools/Extensions.hx",43,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_65_passedByValue,"little.tools.Extensions","passedByValue",0x780949fb,"little.tools.Extensions.passedByValue","little/tools/Extensions.hx",65,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_72_passedByReference,"little.tools.Extensions","passedByReference",0x6f8edf55,"little.tools.Extensions.passedByReference","little/tools/Extensions.hx",72,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_80_staticallyStorable,"little.tools.Extensions","staticallyStorable",0x54241e93,"little.tools.Extensions.staticallyStorable","little/tools/Extensions.hx",80,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_87_extractIdentifier,"little.tools.Extensions","extractIdentifier",0x3e79a2fb,"little.tools.Extensions.extractIdentifier","little/tools/Extensions.hx",87,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_102_asStringPath,"little.tools.Extensions","asStringPath",0xd3325257,"little.tools.Extensions.asStringPath","little/tools/Extensions.hx",102,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_132_asJoinedStringPath,"little.tools.Extensions","asJoinedStringPath",0x2ded4d40,"little.tools.Extensions.asJoinedStringPath","little/tools/Extensions.hx",132,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_139_type,"little.tools.Extensions","type",0x27aa4b69,"little.tools.Extensions.type","little/tools/Extensions.hx",139,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_154_asObjectToken,"little.tools.Extensions","asObjectToken",0xb3d69d59,"little.tools.Extensions.asObjectToken","little/tools/Extensions.hx",154,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_161_asEmptyObject,"little.tools.Extensions","asEmptyObject",0x0de412cb,"little.tools.Extensions.asEmptyObject","little/tools/Extensions.hx",161,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_167_asTokenPath,"little.tools.Extensions","asTokenPath",0x24c90d1d,"little.tools.Extensions.asTokenPath","little/tools/Extensions.hx",167,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_174_extractValue,"little.tools.Extensions","extractValue",0x63fdae1f,"little.tools.Extensions.extractValue","little/tools/Extensions.hx",174,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_192_writeInPlace,"little.tools.Extensions","writeInPlace",0x39398f32,"little.tools.Extensions.writeInPlace","little/tools/Extensions.hx",192,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_210_toIdentifierPath,"little.tools.Extensions","toIdentifierPath",0x498c60b8,"little.tools.Extensions.toIdentifierPath","little/tools/Extensions.hx",210,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_232_containsAny,"little.tools.Extensions","containsAny",0xc07de13e,"little.tools.Extensions.containsAny","little/tools/Extensions.hx",232,0x6f62d1fd)
HX_LOCAL_STACK_FRAME(_hx_pos_10cd80ef5e4418f0_239_toArray,"little.tools.Extensions","toArray",0x5085b8cf,"little.tools.Extensions.toArray","little/tools/Extensions.hx",239,0x6f62d1fd)
namespace little{
namespace tools{

void Extensions_obj::__construct() { }

Dynamic Extensions_obj::__CreateEmpty() { return new Extensions_obj; }

void *Extensions_obj::_hx_vtable = 0;

Dynamic Extensions_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< Extensions_obj > _hx_result = new Extensions_obj();
	_hx_result->__construct();
	return _hx_result;
}

bool Extensions_obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x6945c8d9;
}

::Array< ::Dynamic> Extensions_obj::tokenize(::String code){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_36_tokenize)
HXDLIN(  36)		 ::Dynamic array = ::little::parser::Parser_obj::parse;
HXDLIN(  36)		return ::little::interpreter::Interpreter_obj::convert(( (::Array< ::Dynamic>)(array(::little::lexer::Lexer_obj::lex(code))) ));
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,tokenize,return )

 ::little::interpreter::InterpTokens Extensions_obj::eval(::String code){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_43_eval)
HXDLIN(  43)		 ::Dynamic array = ::little::parser::Parser_obj::parse;
HXDLIN(  43)		return ::little::interpreter::Interpreter_obj::run(::little::interpreter::Interpreter_obj::convert(( (::Array< ::Dynamic>)(array(::little::lexer::Lexer_obj::lex(code))) )),null());
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,eval,return )

bool Extensions_obj::passedByValue( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_65_passedByValue)
HXDLIN(  65)		::Array< ::Dynamic> _this = ::Array_obj< ::Dynamic>::__new(7)->init(0,::little::tools::InterpTokensSimple_obj::TRUE_VALUE_dyn())->init(1,::little::tools::InterpTokensSimple_obj::FALSE_VALUE_dyn())->init(2,::little::tools::InterpTokensSimple_obj::NULL_VALUE_dyn())->init(3,::little::tools::InterpTokensSimple_obj::NUMBER_dyn())->init(4,::little::tools::InterpTokensSimple_obj::DECIMAL_dyn())->init(5,::little::tools::InterpTokensSimple_obj::SIGN_dyn())->init(6,::little::tools::InterpTokensSimple_obj::CHARACTERS_dyn())->copy();
HXDLIN(  65)		::Array< ::String > result = ::Array_obj< ::String >::__new(_this->length);
HXDLIN(  65)		{
HXDLIN(  65)			int _g = 0;
HXDLIN(  65)			int _g1 = _this->length;
HXDLIN(  65)			while((_g < _g1)){
HXDLIN(  65)				_g = (_g + 1);
HXDLIN(  65)				int i = (_g - 1);
HXDLIN(  65)				{
HXDLIN(  65)					::String inValue = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this,i)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  65)					result->__unsafe_set(i,inValue);
            				}
            			}
            		}
HXDLIN(  65)		return result->contains(::Type_obj::enumConstructor(token).toLowerCase());
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,passedByValue,return )

bool Extensions_obj::passedByReference( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_72_passedByReference)
HXDLIN(  72)		::Array< ::Dynamic> _this = ::Array_obj< ::Dynamic>::__new(7)->init(0,::little::tools::InterpTokensSimple_obj::TRUE_VALUE_dyn())->init(1,::little::tools::InterpTokensSimple_obj::FALSE_VALUE_dyn())->init(2,::little::tools::InterpTokensSimple_obj::NULL_VALUE_dyn())->init(3,::little::tools::InterpTokensSimple_obj::NUMBER_dyn())->init(4,::little::tools::InterpTokensSimple_obj::DECIMAL_dyn())->init(5,::little::tools::InterpTokensSimple_obj::SIGN_dyn())->init(6,::little::tools::InterpTokensSimple_obj::CHARACTERS_dyn())->copy();
HXDLIN(  72)		::Array< ::String > result = ::Array_obj< ::String >::__new(_this->length);
HXDLIN(  72)		{
HXDLIN(  72)			int _g = 0;
HXDLIN(  72)			int _g1 = _this->length;
HXDLIN(  72)			while((_g < _g1)){
HXDLIN(  72)				_g = (_g + 1);
HXDLIN(  72)				int i = (_g - 1);
HXDLIN(  72)				{
HXDLIN(  72)					::String inValue = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this,i)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  72)					result->__unsafe_set(i,inValue);
            				}
            			}
            		}
HXDLIN(  72)		return !(result->contains(::Type_obj::enumConstructor(token).toLowerCase()));
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,passedByReference,return )

bool Extensions_obj::staticallyStorable( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_80_staticallyStorable)
HXDLIN(  80)		::Array< ::Dynamic> _this = ::Array_obj< ::Dynamic>::__new(7)->init(0,::little::tools::InterpTokensSimple_obj::TRUE_VALUE_dyn())->init(1,::little::tools::InterpTokensSimple_obj::FALSE_VALUE_dyn())->init(2,::little::tools::InterpTokensSimple_obj::NULL_VALUE_dyn())->init(3,::little::tools::InterpTokensSimple_obj::NUMBER_dyn())->init(4,::little::tools::InterpTokensSimple_obj::DECIMAL_dyn())->init(5,::little::tools::InterpTokensSimple_obj::SIGN_dyn())->init(6,::little::tools::InterpTokensSimple_obj::CHARACTERS_dyn())->copy();
HXDLIN(  80)		::Array< ::String > result = ::Array_obj< ::String >::__new(_this->length);
HXDLIN(  80)		{
HXDLIN(  80)			int _g = 0;
HXDLIN(  80)			int _g1 = _this->length;
HXDLIN(  80)			while((_g < _g1)){
HXDLIN(  80)				_g = (_g + 1);
HXDLIN(  80)				int i = (_g - 1);
HXDLIN(  80)				{
HXDLIN(  80)					::String inValue = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this,i)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  80)					result->__unsafe_set(i,inValue);
            				}
            			}
            		}
HXDLIN(  80)		if (!(result->contains(::Type_obj::enumConstructor(token).toLowerCase()))) {
HXDLIN(  80)			::Array< ::Dynamic> _this1 = ::Array_obj< ::Dynamic>::__new(1)->init(0,::little::tools::InterpTokensSimple_obj::CHARACTERS_dyn())->copy();
HXDLIN(  80)			::Array< ::String > result1 = ::Array_obj< ::String >::__new(_this1->length);
HXDLIN(  80)			{
HXDLIN(  80)				int _g2 = 0;
HXDLIN(  80)				int _g3 = _this1->length;
HXDLIN(  80)				while((_g2 < _g3)){
HXDLIN(  80)					_g2 = (_g2 + 1);
HXDLIN(  80)					int i1 = (_g2 - 1);
HXDLIN(  80)					{
HXDLIN(  80)						::String inValue1 = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this1,i1)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  80)						result1->__unsafe_set(i1,inValue1);
            					}
            				}
            			}
HXDLIN(  80)			return result1->contains(::Type_obj::enumConstructor(token).toLowerCase());
            		}
            		else {
HXDLIN(  80)			return true;
            		}
HXDLIN(  80)		return false;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,staticallyStorable,return )

::String Extensions_obj::extractIdentifier( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_87_extractIdentifier)
HXLINE(  88)		::Array< ::Dynamic> _this = ::Array_obj< ::Dynamic>::__new(1)->init(0,::little::tools::InterpTokensSimple_obj::IDENTIFIER_dyn())->copy();
HXDLIN(  88)		::Array< ::String > result = ::Array_obj< ::String >::__new(_this->length);
HXDLIN(  88)		{
HXLINE(  88)			int _g = 0;
HXDLIN(  88)			int _g1 = _this->length;
HXDLIN(  88)			while((_g < _g1)){
HXLINE(  88)				_g = (_g + 1);
HXDLIN(  88)				int i = (_g - 1);
HXDLIN(  88)				{
HXLINE(  88)					::String inValue = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this,i)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  88)					result->__unsafe_set(i,inValue);
            				}
            			}
            		}
HXDLIN(  88)		if (result->contains(::Type_obj::enumConstructor(token).toLowerCase())) {
HXLINE(  88)			return ( (::String)(::Type_obj::enumParameters(token)->__get(0)) );
            		}
            		else {
HXLINE(  89)			::Array< ::Dynamic> _this1 = ::Array_obj< ::Dynamic>::__new(1)->init(0,::little::tools::InterpTokensSimple_obj::PROPERTY_ACCESS_dyn())->copy();
HXDLIN(  89)			::Array< ::String > result1 = ::Array_obj< ::String >::__new(_this1->length);
HXDLIN(  89)			{
HXLINE(  89)				int _g2 = 0;
HXDLIN(  89)				int _g3 = _this1->length;
HXDLIN(  89)				while((_g2 < _g3)){
HXLINE(  89)					_g2 = (_g2 + 1);
HXDLIN(  89)					int i1 = (_g2 - 1);
HXDLIN(  89)					{
HXLINE(  89)						::String inValue1 = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this1,i1)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  89)						result1->__unsafe_set(i1,inValue1);
            					}
            				}
            			}
HXDLIN(  89)			if (result1->contains(::Type_obj::enumConstructor(token).toLowerCase())) {
HXLINE(  90)				 ::little::interpreter::InterpTokens t = ::little::interpreter::Interpreter_obj::evaluate(token,null());
HXLINE(  91)				::Array< ::Dynamic> _this2 = ::Array_obj< ::Dynamic>::__new(2)->init(0,::little::tools::InterpTokensSimple_obj::IDENTIFIER_dyn())->init(1,::little::tools::InterpTokensSimple_obj::PROPERTY_ACCESS_dyn())->copy();
HXDLIN(  91)				::Array< ::String > result2 = ::Array_obj< ::String >::__new(_this2->length);
HXDLIN(  91)				{
HXLINE(  91)					int _g4 = 0;
HXDLIN(  91)					int _g5 = _this2->length;
HXDLIN(  91)					while((_g4 < _g5)){
HXLINE(  91)						_g4 = (_g4 + 1);
HXDLIN(  91)						int i2 = (_g4 - 1);
HXDLIN(  91)						{
HXLINE(  91)							::String inValue2 = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this2,i2)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  91)							result2->__unsafe_set(i2,inValue2);
            						}
            					}
            				}
HXDLIN(  91)				if (result2->contains(::Type_obj::enumConstructor(t).toLowerCase())) {
HXLINE(  91)					return ::little::tools::Extensions_obj::extractIdentifier(t);
            				}
            				else {
HXLINE(  92)					::Array< ::Dynamic> _this3 = ::Array_obj< ::Dynamic>::__new(1)->init(0,::little::tools::InterpTokensSimple_obj::CLASS_POINTER_dyn())->copy();
HXDLIN(  92)					::Array< ::String > result3 = ::Array_obj< ::String >::__new(_this3->length);
HXDLIN(  92)					{
HXLINE(  92)						int _g6 = 0;
HXDLIN(  92)						int _g7 = _this3->length;
HXDLIN(  92)						while((_g6 < _g7)){
HXLINE(  92)							_g6 = (_g6 + 1);
HXDLIN(  92)							int i3 = (_g6 - 1);
HXDLIN(  92)							{
HXLINE(  92)								::String inValue3 = ::little::tools::TextTools_obj::remove(::Type_obj::enumConstructor(_hx_array_unsafe_get(_this3,i3)),HX_("_",5f,00,00,00)).toLowerCase();
HXDLIN(  92)								result3->__unsafe_set(i3,inValue3);
            							}
            						}
            					}
HXDLIN(  92)					if (result3->contains(::Type_obj::enumConstructor(t).toLowerCase())) {
HXLINE(  92)						 ::little::interpreter::memory::Memory _hx_tmp = ::little::Little_obj::memory;
HXDLIN(  92)						return _hx_tmp->getTypeName(( (int)(::Type_obj::enumParameters(t)->__get(0)) ));
            					}
            				}
HXLINE(  93)				return ( (::String)(::Type_obj::enumParameters(t)->__get(0)) );
            			}
            		}
HXLINE(  96)		return ( (::String)(::Type_obj::enumParameters(::little::interpreter::Interpreter_obj::evaluate(token,null()))->__get(0)) );
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,extractIdentifier,return )

::Array< ::String > Extensions_obj::asStringPath( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_102_asStringPath)
HXLINE( 103)		::Array< ::String > path = ::Array_obj< ::String >::__new(0);
HXLINE( 104)		 ::little::interpreter::InterpTokens current = token;
HXLINE( 105)		while(::hx::IsNotNull( current )){
HXLINE( 106)			switch((int)(current->_hx_getIndex())){
            				case (int)15: {
HXLINE( 107)					 ::little::interpreter::InterpTokens source = current->_hx_getObject(0).StaticCast<  ::little::interpreter::InterpTokens >();
HXDLIN( 107)					 ::little::interpreter::InterpTokens property = current->_hx_getObject(1).StaticCast<  ::little::interpreter::InterpTokens >();
HXDLIN( 107)					{
HXLINE( 108)						path->unshift(::little::tools::Extensions_obj::extractIdentifier(property));
HXLINE( 109)						current = source;
            					}
            				}
            				break;
            				case (int)18: {
HXLINE( 115)					::String string = current->_hx_getString(0);
HXDLIN( 115)					{
HXLINE( 116)						path->unshift(((HX_("\"",22,00,00,00) + string) + HX_("\"",22,00,00,00)));
HXLINE( 117)						current = null();
            					}
            				}
            				break;
            				case (int)25: {
HXLINE( 111)					::String word = current->_hx_getString(0);
HXDLIN( 111)					{
HXLINE( 112)						path->unshift(word);
HXLINE( 113)						current = null();
            					}
            				}
            				break;
            				default:{
HXLINE( 119)					path->unshift(::little::tools::Extensions_obj::extractIdentifier(current));
HXLINE( 120)					current = null();
            				}
            			}
            		}
HXLINE( 125)		return path;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,asStringPath,return )

::String Extensions_obj::asJoinedStringPath( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_132_asJoinedStringPath)
HXDLIN( 132)		return ::little::tools::Extensions_obj::asStringPath(token)->join(::little::Little_obj::keywords->PROPERTY_ACCESS_SIGN);
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,asJoinedStringPath,return )

::String Extensions_obj::type( ::little::interpreter::InterpTokens token){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_139_type)
HXDLIN( 139)		switch((int)(token->_hx_getIndex())){
            			case (int)5: {
HXLINE( 146)				 ::haxe::ds::ObjectMap callers = token->_hx_getObject(0).StaticCast<  ::haxe::ds::ObjectMap >();
HXDLIN( 146)				return ::little::Little_obj::keywords->TYPE_CONDITION;
            			}
            			break;
            			case (int)7: {
HXLINE( 145)				 ::little::tools::BaseOrderedMap requiredParams = token->_hx_getObject(0).StaticCast<  ::little::tools::BaseOrderedMap >();
HXDLIN( 145)				 ::little::interpreter::InterpTokens body = token->_hx_getObject(1).StaticCast<  ::little::interpreter::InterpTokens >();
HXDLIN( 145)				return ::little::Little_obj::keywords->TYPE_FUNCTION;
            			}
            			break;
            			case (int)16: {
HXLINE( 141)				int number = token->_hx_getInt(0);
HXDLIN( 141)				return ::little::Little_obj::keywords->TYPE_INT;
            			}
            			break;
            			case (int)17: {
HXLINE( 142)				Float number1 = token->_hx_getFloat(0);
HXDLIN( 142)				return ::little::Little_obj::keywords->TYPE_FLOAT;
            			}
            			break;
            			case (int)18: {
HXLINE( 140)				::String string = token->_hx_getString(0);
HXDLIN( 140)				return ::little::Little_obj::keywords->TYPE_STRING;
            			}
            			break;
            			case (int)20: {
HXLINE( 149)				int pointer = token->_hx_getInt(0);
HXDLIN( 149)				return ::little::Little_obj::keywords->TYPE_MODULE;
            			}
            			break;
            			case (int)21: {
HXLINE( 147)				::String sign = token->_hx_getString(0);
HXDLIN( 147)				return ::little::Little_obj::keywords->TYPE_SIGN;
            			}
            			break;
            			case (int)22: {
HXLINE( 144)				return ::little::Little_obj::keywords->TYPE_DYNAMIC;
            			}
            			break;
            			case (int)23: case (int)24: {
HXLINE( 143)				return ::little::Little_obj::keywords->TYPE_BOOLEAN;
            			}
            			break;
            			case (int)26: {
HXLINE( 148)				 ::haxe::ds::StringMap _g = token->_hx_getObject(0).StaticCast<  ::haxe::ds::StringMap >();
HXDLIN( 148)				::String typeName = token->_hx_getString(1);
HXDLIN( 148)				return typeName;
            			}
            			break;
            			default:{
HXLINE( 150)				::String _hx_tmp = ((HX_("",00,00,00,00) + ::Std_obj::string(token)) + HX_(" is not a simple token (given ",78,75,4a,a0));
HXDLIN( 150)				HX_STACK_DO_THROW(((_hx_tmp + ::Std_obj::string(token)) + HX_(")",29,00,00,00)));
            			}
            		}
HXLINE( 139)		return null();
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,type,return )

 ::little::interpreter::InterpTokens Extensions_obj::asObjectToken( ::haxe::ds::StringMap o,::String typeName){
            	HX_GC_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_154_asObjectToken)
HXLINE( 155)		 ::haxe::ds::StringMap _g =  ::haxe::ds::StringMap_obj::__alloc( HX_CTX );
HXDLIN( 155)		{
HXLINE( 155)			::Dynamic map = o;
HXDLIN( 155)			::Dynamic _g_map = map;
HXDLIN( 155)			 ::Dynamic _g_keys = ::haxe::IMap_obj::keys(map);
HXDLIN( 155)			while(( (bool)(_g_keys->__Field(HX_("hasNext",6d,a5,46,18),::hx::paccDynamic)()) )){
HXLINE( 155)				::String key = ( (::String)(_g_keys->__Field(HX_("next",f3,84,02,49),::hx::paccDynamic)()) );
HXDLIN( 155)				 ::little::interpreter::InterpTokens _g_value = ::haxe::IMap_obj::get(_g_map,key);
HXDLIN( 155)				::String _g_key = key;
HXDLIN( 155)				::String k = _g_key;
HXDLIN( 155)				 ::little::interpreter::InterpTokens v = _g_value;
HXDLIN( 155)				_g->set(k, ::Dynamic(::hx::Anon_obj::Create(2)
            					->setFixed(0,HX_("value",71,7f,b8,31),v)
            					->setFixed(1,HX_("documentation",ba,81,68,41),HX_("",00,00,00,00))));
            			}
            		}
HXDLIN( 155)		 ::haxe::ds::StringMap map1 = _g;
HXLINE( 156)		{
HXLINE( 156)			 ::Dynamic v1 =  ::Dynamic(::hx::Anon_obj::Create(2)
            				->setFixed(0,HX_("value",71,7f,b8,31),::little::interpreter::InterpTokens_obj::Characters(typeName))
            				->setFixed(1,HX_("documentation",ba,81,68,41),((HX_("The type of this object, as a ",ea,9a,26,74) + ::little::Little_obj::keywords->TYPE_STRING) + HX_(".",2e,00,00,00))));
HXDLIN( 156)			map1->set(::little::Little_obj::keywords->OBJECT_TYPE_PROPERTY_NAME,v1);
            		}
HXLINE( 157)		return ::little::interpreter::InterpTokens_obj::Object(map1,typeName);
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Extensions_obj,asObjectToken,return )

 ::little::interpreter::InterpTokens Extensions_obj::asEmptyObject(::cpp::VirtualArray a,::String typeName){
            	HX_GC_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_161_asEmptyObject)
HXDLIN( 161)		 ::haxe::ds::StringMap _g =  ::haxe::ds::StringMap_obj::__alloc( HX_CTX );
HXDLIN( 161)		_g->set(::little::Little_obj::keywords->OBJECT_TYPE_PROPERTY_NAME, ::Dynamic(::hx::Anon_obj::Create(2)
            			->setFixed(0,HX_("value",71,7f,b8,31),::little::interpreter::InterpTokens_obj::Characters(typeName))
            			->setFixed(1,HX_("documentation",ba,81,68,41),((HX_("The type of this object, as a ",ea,9a,26,74) + ::little::Little_obj::keywords->TYPE_STRING) + HX_(".",2e,00,00,00)))));
HXDLIN( 161)		return ::little::interpreter::InterpTokens_obj::Object(_g,typeName);
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Extensions_obj,asEmptyObject,return )

 ::little::interpreter::InterpTokens Extensions_obj::asTokenPath(::String string){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_167_asTokenPath)
HXLINE( 168)		::Array< ::String > path = string.split(::little::Little_obj::keywords->PROPERTY_ACCESS_SIGN);
HXLINE( 169)		if ((path->length == 1)) {
HXLINE( 169)			return ::little::interpreter::InterpTokens_obj::Identifier(path->__get(0));
            		}
            		else {
HXLINE( 170)			 ::little::interpreter::InterpTokens _hx_tmp = ::little::tools::Extensions_obj::asTokenPath(path->slice(0,(path->length - 1))->join(::little::Little_obj::keywords->PROPERTY_ACCESS_SIGN));
HXDLIN( 170)			return ::little::interpreter::InterpTokens_obj::PropertyAccess(_hx_tmp,::little::interpreter::InterpTokens_obj::Identifier(path->pop()));
            		}
HXLINE( 169)		return null();
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,asTokenPath,return )

 ::little::interpreter::InterpTokens Extensions_obj::extractValue(int address,::String type){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_174_extractValue)
HXLINE( 186)		bool _hx_tmp;
HXLINE( 185)		bool _hx_tmp1;
HXLINE( 184)		bool _hx_tmp2;
HXLINE( 181)		bool _hx_tmp3;
HXLINE( 180)		bool _hx_tmp4;
HXLINE( 179)		bool _hx_tmp5;
HXLINE( 178)		bool _hx_tmp6;
HXLINE( 177)		bool _hx_tmp7;
HXLINE( 176)		bool _hx_tmp8;
HXLINE( 175)		if (((type == ::little::Little_obj::keywords->TYPE_STRING) == true)) {
HXLINE( 175)			return ::little::interpreter::InterpTokens_obj::Characters(::little::Little_obj::memory->storage->readString(address));
            		}
            		else {
HXLINE( 176)			_hx_tmp8 = (type == ::little::Little_obj::keywords->TYPE_INT);
HXDLIN( 176)			if ((_hx_tmp8 == true)) {
HXLINE( 176)				return ::little::interpreter::InterpTokens_obj::Number(::little::Little_obj::memory->storage->readInt32(address));
            			}
            			else {
HXLINE( 177)				_hx_tmp7 = (type == ::little::Little_obj::keywords->TYPE_FLOAT);
HXDLIN( 177)				if ((_hx_tmp7 == true)) {
HXLINE( 177)					return ::little::interpreter::InterpTokens_obj::Decimal(::little::Little_obj::memory->storage->readDouble(address));
            				}
            				else {
HXLINE( 178)					_hx_tmp6 = (type == ::little::Little_obj::keywords->TYPE_BOOLEAN);
HXDLIN( 178)					if ((_hx_tmp6 == true)) {
HXLINE( 178)						return ::little::Little_obj::memory->constants->getFromPointer(address);
            					}
            					else {
HXLINE( 179)						_hx_tmp5 = (type == ::little::Little_obj::keywords->TYPE_FUNCTION);
HXDLIN( 179)						if ((_hx_tmp5 == true)) {
HXLINE( 179)							return ::little::Little_obj::memory->storage->readCodeBlock(address);
            						}
            						else {
HXLINE( 180)							_hx_tmp4 = (type == ::little::Little_obj::keywords->TYPE_CONDITION);
HXDLIN( 180)							if ((_hx_tmp4 == true)) {
HXLINE( 180)								return ::little::Little_obj::memory->storage->readCondition(address);
            							}
            							else {
HXLINE( 181)								_hx_tmp3 = (type == ::little::Little_obj::keywords->TYPE_MODULE);
HXDLIN( 181)								if ((_hx_tmp3 == true)) {
HXLINE( 181)									return ::little::interpreter::InterpTokens_obj::ClassPointer(address);
            								}
            								else {
HXLINE( 184)									bool _hx_tmp9;
HXDLIN( 184)									bool _hx_tmp10;
HXDLIN( 184)									if ((type != ::little::Little_obj::keywords->TYPE_DYNAMIC)) {
HXLINE( 184)										_hx_tmp10 = (type == ::little::Little_obj::keywords->TYPE_UNKNOWN);
            									}
            									else {
HXLINE( 184)										_hx_tmp10 = true;
            									}
HXDLIN( 184)									if (_hx_tmp10) {
HXLINE( 184)										_hx_tmp9 = ::little::Little_obj::memory->constants->hasPointer(address);
            									}
            									else {
HXLINE( 184)										_hx_tmp9 = false;
            									}
HXDLIN( 184)									if (_hx_tmp9) {
HXLINE( 184)										_hx_tmp2 = __hxcpp_enum_eq(::little::Little_obj::memory->constants->getFromPointer(address),::little::interpreter::InterpTokens_obj::NullValue_dyn());
            									}
            									else {
HXLINE( 184)										_hx_tmp2 = false;
            									}
HXDLIN( 184)									if ((_hx_tmp2 == true)) {
HXLINE( 184)										return ::little::interpreter::InterpTokens_obj::NullValue_dyn();
            									}
            									else {
HXLINE( 185)										_hx_tmp1 = (type == ::little::Little_obj::keywords->TYPE_SIGN);
HXDLIN( 185)										if ((_hx_tmp1 == true)) {
HXLINE( 185)											return ::little::Little_obj::memory->storage->readSign(address);
            										}
            										else {
HXLINE( 186)											_hx_tmp = (type == ::little::Little_obj::keywords->TYPE_UNKNOWN);
HXDLIN( 186)											if ((_hx_tmp == true)) {
HXLINE( 186)												HX_STACK_DO_THROW(HX_("Cannot extract value of unknown type",2e,c3,fb,e3));
            											}
            											else {
HXLINE( 188)												return ::little::Little_obj::memory->storage->readObject(address);
            											}
            										}
            									}
            								}
            							}
            						}
            					}
            				}
            			}
            		}
HXLINE( 175)		return null();
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Extensions_obj,extractValue,return )

void Extensions_obj::writeInPlace(int address, ::little::interpreter::InterpTokens value){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_192_writeInPlace)
HXLINE( 193)		::String type = ::little::tools::Extensions_obj::type(value);
HXLINE( 194)		{
HXLINE( 202)			bool _hx_tmp;
HXLINE( 201)			bool _hx_tmp1;
HXLINE( 200)			bool _hx_tmp2;
HXLINE( 199)			bool _hx_tmp3;
HXLINE( 198)			bool _hx_tmp4;
HXLINE( 197)			bool _hx_tmp5;
HXLINE( 196)			bool _hx_tmp6;
HXLINE( 195)			if (((type == ::little::Little_obj::keywords->TYPE_STRING) == true)) {
HXLINE( 195)				 ::little::interpreter::memory::Storage _hx_tmp7 = ::little::Little_obj::memory->storage;
HXDLIN( 195)				_hx_tmp7->setString(address,( (::String)(::Type_obj::enumParameters(value)->__get(0)) ));
            			}
            			else {
HXLINE( 196)				_hx_tmp6 = (type == ::little::Little_obj::keywords->TYPE_INT);
HXDLIN( 196)				if ((_hx_tmp6 == true)) {
HXLINE( 196)					 ::little::interpreter::memory::Storage _hx_tmp8 = ::little::Little_obj::memory->storage;
HXDLIN( 196)					_hx_tmp8->setInt32(address,( (int)(::Type_obj::enumParameters(value)->__get(0)) ));
            				}
            				else {
HXLINE( 197)					_hx_tmp5 = (type == ::little::Little_obj::keywords->TYPE_FLOAT);
HXDLIN( 197)					if ((_hx_tmp5 == true)) {
HXLINE( 197)						 ::little::interpreter::memory::Storage _hx_tmp9 = ::little::Little_obj::memory->storage;
HXDLIN( 197)						_hx_tmp9->setDouble(address,( (Float)(::Type_obj::enumParameters(value)->__get(0)) ));
            					}
            					else {
HXLINE( 198)						_hx_tmp4 = (type == ::little::Little_obj::keywords->TYPE_FUNCTION);
HXDLIN( 198)						if ((_hx_tmp4 == true)) {
HXLINE( 198)							 ::little::interpreter::memory::Storage _hx_tmp10 = ::little::Little_obj::memory->storage;
HXDLIN( 198)							_hx_tmp10->setCodeBlock(address,::Type_obj::enumParameters(value)->__get(0));
            						}
            						else {
HXLINE( 199)							_hx_tmp3 = (type == ::little::Little_obj::keywords->TYPE_CONDITION);
HXDLIN( 199)							if ((_hx_tmp3 == true)) {
HXLINE( 199)								 ::little::interpreter::memory::Storage _hx_tmp11 = ::little::Little_obj::memory->storage;
HXDLIN( 199)								_hx_tmp11->setCondition(address,::Type_obj::enumParameters(value)->__get(0));
            							}
            							else {
HXLINE( 200)								_hx_tmp2 = (type == ::little::Little_obj::keywords->TYPE_MODULE);
HXDLIN( 200)								if ((_hx_tmp2 == true)) {
HXLINE( 200)									 ::little::interpreter::memory::Storage _hx_tmp12 = ::little::Little_obj::memory->storage;
HXDLIN( 200)									_hx_tmp12->setPointer(address,( (int)(::Type_obj::enumParameters(value)->__get(0)) ));
            								}
            								else {
HXLINE( 201)									_hx_tmp1 = (type == ::little::Little_obj::keywords->TYPE_SIGN);
HXDLIN( 201)									if ((_hx_tmp1 == true)) {
HXLINE( 201)										 ::little::interpreter::memory::Storage _hx_tmp13 = ::little::Little_obj::memory->storage;
HXDLIN( 201)										_hx_tmp13->setSign(address,( (::String)(::Type_obj::enumParameters(value)->__get(0)) ));
            									}
            									else {
HXLINE( 202)										_hx_tmp = (type == ::little::Little_obj::keywords->TYPE_UNKNOWN);
HXDLIN( 202)										if ((_hx_tmp == true)) {
HXLINE( 202)											HX_STACK_DO_THROW(HX_("Cannot extract value of unknown type",2e,c3,fb,e3));
            										}
            										else {
HXLINE( 203)											 ::little::interpreter::memory::Storage _hx_tmp14 = ::little::Little_obj::memory->storage;
HXDLIN( 203)											_hx_tmp14->setObject(address,::Type_obj::enumParameters(value)->__get(0));
            										}
            									}
            								}
            							}
            						}
            					}
            				}
            			}
            		}
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Extensions_obj,writeInPlace,(void))

::Array< ::Dynamic> Extensions_obj::toIdentifierPath( ::little::interpreter::InterpTokens propertyAccess){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_210_toIdentifierPath)
HXLINE( 211)		::Array< ::Dynamic> arr = ::Array_obj< ::Dynamic>::__new(0);
HXLINE( 212)		 ::little::interpreter::InterpTokens current = propertyAccess;
HXLINE( 213)		while(::hx::IsNotNull( current )){
HXLINE( 214)			if ((current->_hx_getIndex() == 15)) {
HXLINE( 215)				 ::little::interpreter::InterpTokens source = current->_hx_getObject(0).StaticCast<  ::little::interpreter::InterpTokens >();
HXDLIN( 215)				 ::little::interpreter::InterpTokens property = current->_hx_getObject(1).StaticCast<  ::little::interpreter::InterpTokens >();
HXDLIN( 215)				{
HXLINE( 216)					arr->unshift(property);
HXLINE( 217)					current = source;
            				}
            			}
            			else {
HXLINE( 220)				arr->unshift(current);
HXLINE( 221)				current = null();
            			}
            		}
HXLINE( 225)		return arr;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,toIdentifierPath,return )

bool Extensions_obj::containsAny(::cpp::VirtualArray array, ::Dynamic func){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_232_containsAny)
HXDLIN( 232)		::cpp::VirtualArray _g = ::cpp::VirtualArray_obj::__new(0);
HXDLIN( 232)		{
HXDLIN( 232)			int _g1 = 0;
HXDLIN( 232)			::cpp::VirtualArray _g2 = array;
HXDLIN( 232)			while((_g1 < _g2->get_length())){
HXDLIN( 232)				 ::Dynamic v = _g2->__get(_g1);
HXDLIN( 232)				_g1 = (_g1 + 1);
HXDLIN( 232)				if (( (bool)(func(v)) )) {
HXDLIN( 232)					_g->push(v);
            				}
            			}
            		}
HXDLIN( 232)		return (_g->get_length() > 0);
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC2(Extensions_obj,containsAny,return )

::cpp::VirtualArray Extensions_obj::toArray( ::Dynamic iter){
            	HX_STACKFRAME(&_hx_pos_10cd80ef5e4418f0_239_toArray)
HXDLIN( 239)		::cpp::VirtualArray _g = ::cpp::VirtualArray_obj::__new(0);
HXDLIN( 239)		{
HXDLIN( 239)			 ::Dynamic i = iter;
HXDLIN( 239)			while(( (bool)(i->__Field(HX_("hasNext",6d,a5,46,18),::hx::paccDynamic)()) )){
HXDLIN( 239)				 ::Dynamic i1 = i->__Field(HX_("next",f3,84,02,49),::hx::paccDynamic)();
HXDLIN( 239)				_g->push(i1);
            			}
            		}
HXDLIN( 239)		return _g;
            	}


STATIC_HX_DEFINE_DYNAMIC_FUNC1(Extensions_obj,toArray,return )


Extensions_obj::Extensions_obj()
{
}

bool Extensions_obj::__GetStatic(const ::String &inName, Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 4:
		if (HX_FIELD_EQ(inName,"eval") ) { outValue = eval_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"type") ) { outValue = type_dyn(); return true; }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"toArray") ) { outValue = toArray_dyn(); return true; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"tokenize") ) { outValue = tokenize_dyn(); return true; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"asTokenPath") ) { outValue = asTokenPath_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"containsAny") ) { outValue = containsAny_dyn(); return true; }
		break;
	case 12:
		if (HX_FIELD_EQ(inName,"asStringPath") ) { outValue = asStringPath_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"extractValue") ) { outValue = extractValue_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"writeInPlace") ) { outValue = writeInPlace_dyn(); return true; }
		break;
	case 13:
		if (HX_FIELD_EQ(inName,"passedByValue") ) { outValue = passedByValue_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"asObjectToken") ) { outValue = asObjectToken_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"asEmptyObject") ) { outValue = asEmptyObject_dyn(); return true; }
		break;
	case 16:
		if (HX_FIELD_EQ(inName,"toIdentifierPath") ) { outValue = toIdentifierPath_dyn(); return true; }
		break;
	case 17:
		if (HX_FIELD_EQ(inName,"passedByReference") ) { outValue = passedByReference_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"extractIdentifier") ) { outValue = extractIdentifier_dyn(); return true; }
		break;
	case 18:
		if (HX_FIELD_EQ(inName,"staticallyStorable") ) { outValue = staticallyStorable_dyn(); return true; }
		if (HX_FIELD_EQ(inName,"asJoinedStringPath") ) { outValue = asJoinedStringPath_dyn(); return true; }
	}
	return false;
}

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo *Extensions_obj_sMemberStorageInfo = 0;
static ::hx::StaticInfo *Extensions_obj_sStaticStorageInfo = 0;
#endif

::hx::Class Extensions_obj::__mClass;

static ::String Extensions_obj_sStaticFields[] = {
	HX_("tokenize",fb,f5,57,2b),
	HX_("eval",9c,6b,1c,43),
	HX_("passedByValue",8a,b0,ad,22),
	HX_("passedByReference",64,39,ab,71),
	HX_("staticallyStorable",a4,91,d6,2a),
	HX_("extractIdentifier",0a,fd,95,40),
	HX_("asStringPath",a8,32,72,c0),
	HX_("asJoinedStringPath",51,c0,9f,04),
	HX_("type",ba,f2,08,4d),
	HX_("asObjectToken",e8,03,7b,5e),
	HX_("asEmptyObject",5a,79,88,b8),
	HX_("asTokenPath",ec,61,93,88),
	HX_("extractValue",70,8e,3d,51),
	HX_("writeInPlace",83,6f,79,26),
	HX_("toIdentifierPath",89,3d,b1,a7),
	HX_("containsAny",0d,36,48,24),
	HX_("toArray",1e,ba,13,f2),
	::String(null())
};

void Extensions_obj::__register()
{
	Extensions_obj _hx_dummy;
	Extensions_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("little.tools.Extensions",1f,c6,ef,cd);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &Extensions_obj::__GetStatic;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(Extensions_obj_sStaticFields);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(0 /* sMemberFields */);
	__mClass->mCanCast = ::hx::TCanCast< Extensions_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = Extensions_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = Extensions_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace little
} // end namespace tools
