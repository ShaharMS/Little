// Generated by Haxe 4.3.3
#include <hxcpp.h>

#ifndef INCLUDED_haxe_IMap
#include <haxe/IMap.h>
#endif
#ifndef INCLUDED_haxe_ds_StringMap
#include <haxe/ds/StringMap.h>
#endif
#ifndef INCLUDED_little_Little
#include <little/Little.h>
#endif
#ifndef INCLUDED_little_interpreter_InterpTokens
#include <little/interpreter/InterpTokens.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_ConstantPool
#include <little/interpreter/memory/ConstantPool.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_ExtTree
#include <little/interpreter/memory/ExtTree.h>
#endif
#ifndef INCLUDED_little_interpreter_memory_Memory
#include <little/interpreter/memory/Memory.h>
#endif
#ifndef INCLUDED_little_interpreter_memory__MemoryPointer_MemoryPointer_Impl_
#include <little/interpreter/memory/_MemoryPointer/MemoryPointer_Impl_.h>
#endif

HX_DEFINE_STACK_FRAME(_hx_pos_29b9ca378041c078_180_new,"little.interpreter.memory.ExtTree","new",0x6d26b8b0,"little.interpreter.memory.ExtTree.new","little/interpreter/memory/ExternalInterfacing.hx",180,0x5edd7fb3)
HX_DEFINE_STACK_FRAME(_hx_pos_29b9ca378041c078_182_new,"little.interpreter.memory.ExtTree","new",0x6d26b8b0,"little.interpreter.memory.ExtTree.new","little/interpreter/memory/ExternalInterfacing.hx",182,0x5edd7fb3)
namespace little{
namespace interpreter{
namespace memory{

void ExtTree_obj::__construct( ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc){
            	HX_GC_STACKFRAME(&_hx_pos_29b9ca378041c078_180_new)
HXLINE( 181)		 ::Dynamic tmp = getter;
HXDLIN( 181)		 ::Dynamic _hx_tmp;
HXDLIN( 181)		if (::hx::IsNotNull( tmp )) {
HXLINE( 181)			_hx_tmp = tmp;
            		}
            		else {
            			HX_BEGIN_LOCAL_FUNC_S0(::hx::LocalFunc,_hx_Closure_0) HXARGC(2)
            			 ::Dynamic _hx_run( ::little::interpreter::InterpTokens objectValue,int objectAddress){
            				HX_STACKFRAME(&_hx_pos_29b9ca378041c078_182_new)
HXLINE( 182)				return  ::Dynamic(::hx::Anon_obj::Create(2)
            					->setFixed(0,HX_("objectAddress",b5,00,cc,8b),objectAddress)
            					->setFixed(1,HX_("objectValue",32,9c,e7,a0),::little::interpreter::InterpTokens_obj::Characters((HX_("Externally registered, attached to ",67,b8,14,21) + ::little::interpreter::memory::_MemoryPointer::MemoryPointer_Impl__obj::toString(objectAddress)))));
            			}
            			HX_END_LOCAL_FUNC2(return)

HXLINE( 181)			_hx_tmp =  ::Dynamic(new _hx_Closure_0());
            		}
HXDLIN( 181)		this->getter = _hx_tmp;
HXLINE( 187)		 ::haxe::ds::StringMap tmp1 = properties;
HXDLIN( 187)		 ::haxe::ds::StringMap _hx_tmp1;
HXDLIN( 187)		if (::hx::IsNotNull( tmp1 )) {
HXLINE( 187)			_hx_tmp1 = tmp1;
            		}
            		else {
HXLINE( 187)			_hx_tmp1 =  ::haxe::ds::StringMap_obj::__alloc( HX_CTX );
            		}
HXDLIN( 187)		this->properties = _hx_tmp1;
HXLINE( 188)		 ::Dynamic tmp2 = doc;
HXDLIN( 188)		int _hx_tmp2;
HXDLIN( 188)		if (::hx::IsNotNull( tmp2 )) {
HXLINE( 188)			_hx_tmp2 = ( (int)(tmp2) );
            		}
            		else {
HXLINE( 188)			_hx_tmp2 = ::little::Little_obj::memory->constants->EMPTY_STRING;
            		}
HXDLIN( 188)		this->doc = _hx_tmp2;
HXLINE( 189)		 ::Dynamic tmp3 = type;
HXDLIN( 189)		int _hx_tmp3;
HXDLIN( 189)		if (::hx::IsNotNull( tmp3 )) {
HXLINE( 189)			_hx_tmp3 = ( (int)(tmp3) );
            		}
            		else {
HXLINE( 189)			_hx_tmp3 = ::little::Little_obj::memory->constants->UNKNOWN;
            		}
HXDLIN( 189)		this->type = _hx_tmp3;
            	}

Dynamic ExtTree_obj::__CreateEmpty() { return new ExtTree_obj; }

void *ExtTree_obj::_hx_vtable = 0;

Dynamic ExtTree_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< ExtTree_obj > _hx_result = new ExtTree_obj();
	_hx_result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3]);
	return _hx_result;
}

bool ExtTree_obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x5c8b5f3e;
}


::hx::ObjectPtr< ExtTree_obj > ExtTree_obj::__new( ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc) {
	::hx::ObjectPtr< ExtTree_obj > __this = new ExtTree_obj();
	__this->__construct(type,getter,properties,doc);
	return __this;
}

::hx::ObjectPtr< ExtTree_obj > ExtTree_obj::__alloc(::hx::Ctx *_hx_ctx, ::Dynamic type, ::Dynamic getter, ::haxe::ds::StringMap properties, ::Dynamic doc) {
	ExtTree_obj *__this = (ExtTree_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(ExtTree_obj), true, "little.interpreter.memory.ExtTree"));
	*(void **)__this = ExtTree_obj::_hx_vtable;
	__this->__construct(type,getter,properties,doc);
	return __this;
}

ExtTree_obj::ExtTree_obj()
{
}

void ExtTree_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(ExtTree);
	HX_MARK_MEMBER_NAME(getter,"getter");
	HX_MARK_MEMBER_NAME(doc,"doc");
	HX_MARK_MEMBER_NAME(type,"type");
	HX_MARK_MEMBER_NAME(properties,"properties");
	HX_MARK_END_CLASS();
}

void ExtTree_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(getter,"getter");
	HX_VISIT_MEMBER_NAME(doc,"doc");
	HX_VISIT_MEMBER_NAME(type,"type");
	HX_VISIT_MEMBER_NAME(properties,"properties");
}

::hx::Val ExtTree_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"doc") ) { return ::hx::Val( doc ); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"type") ) { return ::hx::Val( type ); }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"getter") ) { return ::hx::Val( getter ); }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"properties") ) { return ::hx::Val( properties ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val ExtTree_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 3:
		if (HX_FIELD_EQ(inName,"doc") ) { doc=inValue.Cast< int >(); return inValue; }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"type") ) { type=inValue.Cast< int >(); return inValue; }
		break;
	case 6:
		if (HX_FIELD_EQ(inName,"getter") ) { getter=inValue.Cast<  ::Dynamic >(); return inValue; }
		break;
	case 10:
		if (HX_FIELD_EQ(inName,"properties") ) { properties=inValue.Cast<  ::haxe::ds::StringMap >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void ExtTree_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("doc",78,42,4c,00));
	outFields->push(HX_("type",ba,f2,08,4d));
	outFields->push(HX_("properties",f3,fb,0e,61));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo ExtTree_obj_sMemberStorageInfo[] = {
	{::hx::fsObject /*  ::Dynamic */ ,(int)offsetof(ExtTree_obj,getter),HX_("getter",0b,df,3f,a3)},
	{::hx::fsInt,(int)offsetof(ExtTree_obj,doc),HX_("doc",78,42,4c,00)},
	{::hx::fsInt,(int)offsetof(ExtTree_obj,type),HX_("type",ba,f2,08,4d)},
	{::hx::fsObject /*  ::haxe::ds::StringMap */ ,(int)offsetof(ExtTree_obj,properties),HX_("properties",f3,fb,0e,61)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *ExtTree_obj_sStaticStorageInfo = 0;
#endif

static ::String ExtTree_obj_sMemberFields[] = {
	HX_("getter",0b,df,3f,a3),
	HX_("doc",78,42,4c,00),
	HX_("type",ba,f2,08,4d),
	HX_("properties",f3,fb,0e,61),
	::String(null()) };

::hx::Class ExtTree_obj::__mClass;

void ExtTree_obj::__register()
{
	ExtTree_obj _hx_dummy;
	ExtTree_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("little.interpreter.memory.ExtTree",be,e0,58,1a);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(ExtTree_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< ExtTree_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = ExtTree_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = ExtTree_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace little
} // end namespace interpreter
} // end namespace memory
