// Generated by Haxe 4.3.3
#ifndef INCLUDED_little_lexer_LexerTokens
#define INCLUDED_little_lexer_LexerTokens

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(little,lexer,LexerTokens)
namespace little{
namespace lexer{


class LexerTokens_obj : public ::hx::EnumBase_obj
{
	typedef ::hx::EnumBase_obj super;
		typedef LexerTokens_obj OBJ_;

	public:
		LexerTokens_obj() {};
		HX_DO_ENUM_RTTI;
		static void __boot();
		static void __register();
		static bool __GetStatic(const ::String &inName, Dynamic &outValue, ::hx::PropertyAccess inCallProp);
		::String GetEnumName( ) const { return HX_("little.lexer.LexerTokens",8c,63,0d,68); }
		::String __ToString() const { return HX_("LexerTokens.",08,cb,d0,16) + _hx_tag; }

		static ::little::lexer::LexerTokens Boolean(::String value);
		static ::Dynamic Boolean_dyn();
		static ::little::lexer::LexerTokens Characters(::String string);
		static ::Dynamic Characters_dyn();
		static ::little::lexer::LexerTokens Documentation(::String content);
		static ::Dynamic Documentation_dyn();
		static ::little::lexer::LexerTokens Identifier(::String name);
		static ::Dynamic Identifier_dyn();
		static ::little::lexer::LexerTokens Newline;
		static inline ::little::lexer::LexerTokens Newline_dyn() { return Newline; }
		static ::little::lexer::LexerTokens NullValue;
		static inline ::little::lexer::LexerTokens NullValue_dyn() { return NullValue; }
		static ::little::lexer::LexerTokens Number(::String num);
		static ::Dynamic Number_dyn();
		static ::little::lexer::LexerTokens Sign(::String _hx_char);
		static ::Dynamic Sign_dyn();
		static ::little::lexer::LexerTokens SplitLine;
		static inline ::little::lexer::LexerTokens SplitLine_dyn() { return SplitLine; }
};

} // end namespace little
} // end namespace lexer

#endif /* INCLUDED_little_lexer_LexerTokens */ 
