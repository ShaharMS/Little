// Generated by Haxe 4.3.3
#ifndef INCLUDED_little_interpreter_memory_ExtTree
#define INCLUDED_little_interpreter_memory_ExtTree

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(haxe,IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(little,interpreter,InterpTokens)
HX_DECLARE_CLASS3(little,interpreter,memory,ExtTree)

namespace little{
namespace interpreter{
namespace memory{


class HXCPP_CLASS_ATTRIBUTES ExtTree_obj : public ::hx::Object
{
	public:
		typedef ::hx::Object super;
		typedef ExtTree_obj OBJ_;
		ExtTree_obj();

	public:
		enum { _hx_ClassId = 0x5c8b5f3e };

		void __construct( ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc);
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="little.interpreter.memory.ExtTree")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"little.interpreter.memory.ExtTree"); }
		static ::hx::ObjectPtr< ExtTree_obj > __new( ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc);
		static ::hx::ObjectPtr< ExtTree_obj > __alloc(::hx::Ctx *_hx_ctx, ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~ExtTree_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("ExtTree",7f,5e,74,32); }

		 ::Dynamic getter;
		Dynamic getter_dyn() { return getter;}
		int doc;
		int type;
		 ::haxe::ds::StringMap properties;
};

} // end namespace little
} // end namespace interpreter
} // end namespace memory

#endif /* INCLUDED_little_interpreter_memory_ExtTree */ 
