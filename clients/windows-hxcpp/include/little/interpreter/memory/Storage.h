// Generated by Haxe 4.3.3
#ifndef INCLUDED_little_interpreter_memory_Storage
#define INCLUDED_little_interpreter_memory_Storage

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS1(haxe,IMap)
HX_DECLARE_CLASS2(haxe,ds,StringMap)
HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(little,interpreter,InterpTokens)
HX_DECLARE_CLASS3(little,interpreter,memory,Memory)
HX_DECLARE_CLASS3(little,interpreter,memory,Storage)

namespace little{
namespace interpreter{
namespace memory{


class HXCPP_CLASS_ATTRIBUTES Storage_obj : public ::hx::Object
{
	public:
		typedef ::hx::Object super;
		typedef Storage_obj OBJ_;
		Storage_obj();

	public:
		enum { _hx_ClassId = 0x3c1107da };

		void __construct( ::little::interpreter::memory::Memory memory);
		inline void *operator new(size_t inSize, bool inContainer=true,const char *inName="little.interpreter.memory.Storage")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,true,"little.interpreter.memory.Storage"); }
		static ::hx::ObjectPtr< Storage_obj > __new( ::little::interpreter::memory::Memory memory);
		static ::hx::ObjectPtr< Storage_obj > __alloc(::hx::Ctx *_hx_ctx, ::little::interpreter::memory::Memory memory);
		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~Storage_obj();

		HX_DO_RTTI_ALL;
		::hx::Val __Field(const ::String &inString, ::hx::PropertyAccess inCallProp);
		::hx::Val __SetField(const ::String &inString,const ::hx::Val &inValue, ::hx::PropertyAccess inCallProp);
		void __GetFields(Array< ::String> &outFields);
		static void __register();
		void __Mark(HX_MARK_PARAMS);
		void __Visit(HX_VISIT_PARAMS);
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("Storage",1b,07,fa,11); }

		 ::little::interpreter::memory::Memory parent;
		 ::haxe::io::Bytes reserved;
		 ::haxe::io::Bytes storage;
		void requestMemory();
		::Dynamic requestMemory_dyn();

		int storeByte(int b);
		::Dynamic storeByte_dyn();

		void setByte(int address,int b);
		::Dynamic setByte_dyn();

		int readByte(int address);
		::Dynamic readByte_dyn();

		void freeByte(int address);
		::Dynamic freeByte_dyn();

		int storeBytes(int size, ::haxe::io::Bytes b);
		::Dynamic storeBytes_dyn();

		void setBytes(int address, ::haxe::io::Bytes bytes);
		::Dynamic setBytes_dyn();

		 ::haxe::io::Bytes readBytes(int address,int size);
		::Dynamic readBytes_dyn();

		void freeBytes(int address,int size);
		::Dynamic freeBytes_dyn();

		int storeArray(int length,int elementSize, ::haxe::io::Bytes defaultElement);
		::Dynamic storeArray_dyn();

		void setArray(int address,int length,int elementSize, ::haxe::io::Bytes defaultElement);
		::Dynamic setArray_dyn();

		::Array< ::Dynamic> readArray(int address);
		::Dynamic readArray_dyn();

		void freeArray(int address);
		::Dynamic freeArray_dyn();

		int storeInt16(int b);
		::Dynamic storeInt16_dyn();

		void setInt16(int address,int b);
		::Dynamic setInt16_dyn();

		int readInt16(int address);
		::Dynamic readInt16_dyn();

		void freeInt16(int address);
		::Dynamic freeInt16_dyn();

		int storeUInt16(int b);
		::Dynamic storeUInt16_dyn();

		void setUInt16(int address,int b);
		::Dynamic setUInt16_dyn();

		 ::Dynamic readUInt16(int address);
		::Dynamic readUInt16_dyn();

		void freeUInt16(int address);
		::Dynamic freeUInt16_dyn();

		int storeInt32(int b);
		::Dynamic storeInt32_dyn();

		void setInt32(int address,int b);
		::Dynamic setInt32_dyn();

		int readInt32(int address);
		::Dynamic readInt32_dyn();

		void freeInt32(int address);
		::Dynamic freeInt32_dyn();

		int storeUInt32(int b);
		::Dynamic storeUInt32_dyn();

		void setUInt32(int address,int b);
		::Dynamic setUInt32_dyn();

		int readUInt32(int address);
		::Dynamic readUInt32_dyn();

		void freeUInt32(int address);
		::Dynamic freeUInt32_dyn();

		int storeDouble(Float b);
		::Dynamic storeDouble_dyn();

		void setDouble(int address,Float b);
		::Dynamic setDouble_dyn();

		Float readDouble(int address);
		::Dynamic readDouble_dyn();

		void freeDouble(int address);
		::Dynamic freeDouble_dyn();

		int storePointer(int p);
		::Dynamic storePointer_dyn();

		void setPointer(int address,int p);
		::Dynamic setPointer_dyn();

		int readPointer(int address);
		::Dynamic readPointer_dyn();

		void freePointer(int address);
		::Dynamic freePointer_dyn();

		int storeString(::String b);
		::Dynamic storeString_dyn();

		void setString(int address,::String b);
		::Dynamic setString_dyn();

		::String readString(int address);
		::Dynamic readString_dyn();

		void freeString(int address);
		::Dynamic freeString_dyn();

		int storeCodeBlock( ::little::interpreter::InterpTokens caller);
		::Dynamic storeCodeBlock_dyn();

		void setCodeBlock(int address, ::little::interpreter::InterpTokens caller);
		::Dynamic setCodeBlock_dyn();

		 ::little::interpreter::InterpTokens readCodeBlock(int address);
		::Dynamic readCodeBlock_dyn();

		void freeCodeBlock(int address);
		::Dynamic freeCodeBlock_dyn();

		int storeCondition( ::little::interpreter::InterpTokens caller);
		::Dynamic storeCondition_dyn();

		void setCondition(int address, ::little::interpreter::InterpTokens caller);
		::Dynamic setCondition_dyn();

		 ::little::interpreter::InterpTokens readCondition(int address);
		::Dynamic readCondition_dyn();

		void freeCondition(int address);
		::Dynamic freeCondition_dyn();

		int storeSign(::String sign);
		::Dynamic storeSign_dyn();

		void setSign(int address,::String sign);
		::Dynamic setSign_dyn();

		 ::little::interpreter::InterpTokens readSign(int address);
		::Dynamic readSign_dyn();

		void freeSign(int address);
		::Dynamic freeSign_dyn();

		int storeStatic( ::little::interpreter::InterpTokens token);
		::Dynamic storeStatic_dyn();

		int storeObject( ::little::interpreter::InterpTokens object);
		::Dynamic storeObject_dyn();

		int setObject(int address, ::little::interpreter::InterpTokens object);
		::Dynamic setObject_dyn();

		 ::little::interpreter::InterpTokens readObject(int pointer);
		::Dynamic readObject_dyn();

		void freeObject(int pointer);
		::Dynamic freeObject_dyn();

		int storeType(::String name, ::haxe::ds::StringMap statics, ::haxe::ds::StringMap instances);
		::Dynamic storeType_dyn();

		void setType(int address,::String name, ::haxe::ds::StringMap statics, ::haxe::ds::StringMap instances);
		::Dynamic setType_dyn();

		 ::Dynamic readType(int pointer);
		::Dynamic readType_dyn();

		void freeType(int pointer);
		::Dynamic freeType_dyn();

};

} // end namespace little
} // end namespace interpreter
} // end namespace memory

#endif /* INCLUDED_little_interpreter_memory_Storage */ 
