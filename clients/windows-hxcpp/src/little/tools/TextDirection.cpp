// Generated by Haxe 4.3.3
#include <hxcpp.h>

#ifndef INCLUDED_little_tools_TextDirection
#include <little/tools/TextDirection.h>
#endif
namespace little{
namespace tools{

::little::tools::TextDirection TextDirection_obj::LTR;

::little::tools::TextDirection TextDirection_obj::RTL;

::little::tools::TextDirection TextDirection_obj::UNDETERMINED;

bool TextDirection_obj::__GetStatic(const ::String &inName, ::Dynamic &outValue, ::hx::PropertyAccess inCallProp)
{
	if (inName==HX_("LTR",ca,f4,39,00)) { outValue = TextDirection_obj::LTR; return true; }
	if (inName==HX_("RTL",4a,82,3e,00)) { outValue = TextDirection_obj::RTL; return true; }
	if (inName==HX_("UNDETERMINED",0a,ed,9d,50)) { outValue = TextDirection_obj::UNDETERMINED; return true; }
	return super::__GetStatic(inName, outValue, inCallProp);
}

HX_DEFINE_CREATE_ENUM(TextDirection_obj)

int TextDirection_obj::__FindIndex(::String inName)
{
	if (inName==HX_("LTR",ca,f4,39,00)) return 1;
	if (inName==HX_("RTL",4a,82,3e,00)) return 0;
	if (inName==HX_("UNDETERMINED",0a,ed,9d,50)) return 2;
	return super::__FindIndex(inName);
}

int TextDirection_obj::__FindArgCount(::String inName)
{
	if (inName==HX_("LTR",ca,f4,39,00)) return 0;
	if (inName==HX_("RTL",4a,82,3e,00)) return 0;
	if (inName==HX_("UNDETERMINED",0a,ed,9d,50)) return 0;
	return super::__FindArgCount(inName);
}

::hx::Val TextDirection_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	if (inName==HX_("LTR",ca,f4,39,00)) return LTR;
	if (inName==HX_("RTL",4a,82,3e,00)) return RTL;
	if (inName==HX_("UNDETERMINED",0a,ed,9d,50)) return UNDETERMINED;
	return super::__Field(inName,inCallProp);
}

static ::String TextDirection_obj_sStaticFields[] = {
	HX_("RTL",4a,82,3e,00),
	HX_("LTR",ca,f4,39,00),
	HX_("UNDETERMINED",0a,ed,9d,50),
	::String(null())
};

::hx::Class TextDirection_obj::__mClass;

Dynamic __Create_TextDirection_obj() { return new TextDirection_obj; }

void TextDirection_obj::__register()
{

::hx::Static(__mClass) = ::hx::_hx_RegisterClass(HX_("little.tools.TextDirection",a7,46,c3,0d), ::hx::TCanCast< TextDirection_obj >,TextDirection_obj_sStaticFields,0,
	&__Create_TextDirection_obj, &__Create,
	&super::__SGetClass(), &CreateTextDirection_obj, 0
#ifdef HXCPP_VISIT_ALLOCS
    , 0
#endif
#ifdef HXCPP_SCRIPTABLE
    , 0
#endif
);
	__mClass->mGetStaticField = &TextDirection_obj::__GetStatic;
}

void TextDirection_obj::__boot()
{
LTR = ::hx::CreateConstEnum< TextDirection_obj >(HX_("LTR",ca,f4,39,00),1);
RTL = ::hx::CreateConstEnum< TextDirection_obj >(HX_("RTL",4a,82,3e,00),0);
UNDETERMINED = ::hx::CreateConstEnum< TextDirection_obj >(HX_("UNDETERMINED",0a,ed,9d,50),2);
}


} // end namespace little
} // end namespace tools
