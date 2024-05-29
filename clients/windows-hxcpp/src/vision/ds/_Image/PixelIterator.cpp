// Generated by Haxe 4.3.4
#include <hxcpp.h>

#ifndef INCLUDED_38344beec7696400
#define INCLUDED_38344beec7696400
#include "cpp/Int64.h"
#endif
#ifndef INCLUDED_95f339a1d026d52c
#define INCLUDED_95f339a1d026d52c
#include "hxMath.h"
#endif
#ifndef INCLUDED_haxe_Exception
#include <haxe/Exception.h>
#endif
#ifndef INCLUDED_haxe_io_Bytes
#include <haxe/io/Bytes.h>
#endif
#ifndef INCLUDED_vision_ds_Pixel
#include <vision/ds/Pixel.h>
#endif
#ifndef INCLUDED_vision_ds_Point2D
#include <vision/ds/Point2D.h>
#endif
#ifndef INCLUDED_vision_ds__Image_Image_Impl_
#include <vision/ds/_Image/Image_Impl_.h>
#endif
#ifndef INCLUDED_vision_ds__Image_PixelIterator
#include <vision/ds/_Image/PixelIterator.h>
#endif
#ifndef INCLUDED_vision_exceptions_OutOfBounds
#include <vision/exceptions/OutOfBounds.h>
#endif
#ifndef INCLUDED_vision_exceptions_VisionException
#include <vision/exceptions/VisionException.h>
#endif

HX_DEFINE_STACK_FRAME(_hx_pos_28409f2a982e6d01_1651_new,"vision.ds._Image.PixelIterator","new",0xea2a702d,"vision.ds._Image.PixelIterator.new","vision/ds/Image.hx",1651,0x0a62203c)
HX_LOCAL_STACK_FRAME(_hx_pos_28409f2a982e6d01_1659_next,"vision.ds._Image.PixelIterator","next",0xfaf7b886,"vision.ds._Image.PixelIterator.next","vision/ds/Image.hx",1659,0x0a62203c)
HX_LOCAL_STACK_FRAME(_hx_pos_28409f2a982e6d01_1668_hasNext,"vision.ds._Image.PixelIterator","hasNext",0x647dafba,"vision.ds._Image.PixelIterator.hasNext","vision/ds/Image.hx",1668,0x0a62203c)
namespace vision{
namespace ds{
namespace _Image{

void PixelIterator_obj::__construct( ::haxe::io::Bytes img){
            	HX_STACKFRAME(&_hx_pos_28409f2a982e6d01_1651_new)
HXLINE(1652)		this->i = 4;
HXLINE(1656)		this->img = img;
            	}

Dynamic PixelIterator_obj::__CreateEmpty() { return new PixelIterator_obj; }

void *PixelIterator_obj::_hx_vtable = 0;

Dynamic PixelIterator_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< PixelIterator_obj > _hx_result = new PixelIterator_obj();
	_hx_result->__construct(inArgs[0]);
	return _hx_result;
}

bool PixelIterator_obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x29670be1;
}

 ::vision::ds::Pixel PixelIterator_obj::next(){
            	HX_GC_STACKFRAME(&_hx_pos_28409f2a982e6d01_1659_next)
HXLINE(1660)		 ::haxe::io::Bytes _this = this->img;
HXDLIN(1660)		int x = ::hx::Mod(this->i,(( (int)(_this->b->__get(0)) ) | (( (int)(_this->b->__get(1)) ) << 8)));
HXLINE(1661)		 ::haxe::io::Bytes _this1 = this->img;
HXDLIN(1661)		int y = ::Math_obj::floor((( (Float)(this->i) ) / ( (Float)((( (int)(_this1->b->__get(0)) ) | (( (int)(_this1->b->__get(1)) ) << 8))) )));
HXLINE(1662)		 ::haxe::io::Bytes this1 = this->img;
HXDLIN(1662)		bool pixel;
HXDLIN(1662)		bool pixel1;
HXDLIN(1662)		bool pixel2;
HXDLIN(1662)		if ((x >= 0)) {
HXLINE(1662)			pixel2 = (y >= 0);
            		}
            		else {
HXLINE(1662)			pixel2 = false;
            		}
HXDLIN(1662)		if (pixel2) {
HXLINE(1662)			 ::haxe::io::Bytes _this2 = this1;
HXDLIN(1662)			pixel1 = (x < (( (int)(_this2->b->__get(0)) ) | (( (int)(_this2->b->__get(1)) ) << 8)));
            		}
            		else {
HXLINE(1662)			pixel1 = false;
            		}
HXDLIN(1662)		if (pixel1) {
HXLINE(1662)			 ::haxe::io::Bytes _this3 = this1;
HXDLIN(1662)			pixel = (y < ::Math_obj::ceil((( (Float)((this1->length - ::vision::ds::_Image::Image_Impl__obj::OFFSET)) ) / ( (Float)(((( (int)(_this3->b->__get(0)) ) | (( (int)(_this3->b->__get(1)) ) << 8)) * 4)) ))));
            		}
            		else {
HXLINE(1662)			pixel = false;
            		}
HXDLIN(1662)		if (!(pixel)) {
HXLINE(1662)			::cpp::Int64 this2 = _hx_int64_make(x,y);
HXDLIN(1662)			int pixel3 = _hx_int64_high(this2);
HXDLIN(1662)			HX_STACK_DO_THROW( ::vision::exceptions::OutOfBounds_obj::__alloc( HX_CTX ,this1, ::vision::ds::Point2D_obj::__alloc( HX_CTX ,pixel3,_hx_int64_low(this2))));
            		}
HXDLIN(1662)		 ::haxe::io::Bytes _this4 = this1;
HXDLIN(1662)		int position = (((y * (( (int)(_this4->b->__get(0)) ) | (( (int)(_this4->b->__get(1)) ) << 8))) + x) * 4);
HXDLIN(1662)		position = (position + ::vision::ds::_Image::Image_Impl__obj::OFFSET);
HXDLIN(1662)		 ::vision::ds::Pixel pixel4 =  ::vision::ds::Pixel_obj::__alloc( HX_CTX ,x,y,((((( (int)(this1->b->__get(position)) ) << 24) | (( (int)(this1->b->__get((position + 1))) ) << 16)) | (( (int)(this1->b->__get((position + 2))) ) << 8)) | ( (int)(this1->b->__get((position + 3))) )));
HXLINE(1663)		 ::vision::ds::_Image::PixelIterator _hx_tmp = ::hx::ObjectPtr<OBJ_>(this);
HXDLIN(1663)		_hx_tmp->i = (_hx_tmp->i + 4);
HXLINE(1664)		return pixel4;
            	}


HX_DEFINE_DYNAMIC_FUNC0(PixelIterator_obj,next,return )

bool PixelIterator_obj::hasNext(){
            	HX_STACKFRAME(&_hx_pos_28409f2a982e6d01_1668_hasNext)
HXDLIN(1668)		return (this->i < this->img->length);
            	}


HX_DEFINE_DYNAMIC_FUNC0(PixelIterator_obj,hasNext,return )


::hx::ObjectPtr< PixelIterator_obj > PixelIterator_obj::__new( ::haxe::io::Bytes img) {
	::hx::ObjectPtr< PixelIterator_obj > __this = new PixelIterator_obj();
	__this->__construct(img);
	return __this;
}

::hx::ObjectPtr< PixelIterator_obj > PixelIterator_obj::__alloc(::hx::Ctx *_hx_ctx, ::haxe::io::Bytes img) {
	PixelIterator_obj *__this = (PixelIterator_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(PixelIterator_obj), true, "vision.ds._Image.PixelIterator"));
	*(void **)__this = PixelIterator_obj::_hx_vtable;
	__this->__construct(img);
	return __this;
}

PixelIterator_obj::PixelIterator_obj()
{
}

void PixelIterator_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(PixelIterator);
	HX_MARK_MEMBER_NAME(i,"i");
	HX_MARK_MEMBER_NAME(img,"img");
	HX_MARK_END_CLASS();
}

void PixelIterator_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(i,"i");
	HX_VISIT_MEMBER_NAME(img,"img");
}

::hx::Val PixelIterator_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { return ::hx::Val( i ); }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"img") ) { return ::hx::Val( img ); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return ::hx::Val( next_dyn() ); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasNext") ) { return ::hx::Val( hasNext_dyn() ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val PixelIterator_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"i") ) { i=inValue.Cast< int >(); return inValue; }
		break;
	case 3:
		if (HX_FIELD_EQ(inName,"img") ) { img=inValue.Cast<  ::haxe::io::Bytes >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void PixelIterator_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("i",69,00,00,00));
	outFields->push(HX_("img",03,0c,50,00));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo PixelIterator_obj_sMemberStorageInfo[] = {
	{::hx::fsInt,(int)offsetof(PixelIterator_obj,i),HX_("i",69,00,00,00)},
	{::hx::fsObject /*  ::haxe::io::Bytes */ ,(int)offsetof(PixelIterator_obj,img),HX_("img",03,0c,50,00)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *PixelIterator_obj_sStaticStorageInfo = 0;
#endif

static ::String PixelIterator_obj_sMemberFields[] = {
	HX_("i",69,00,00,00),
	HX_("img",03,0c,50,00),
	HX_("next",f3,84,02,49),
	HX_("hasNext",6d,a5,46,18),
	::String(null()) };

::hx::Class PixelIterator_obj::__mClass;

void PixelIterator_obj::__register()
{
	PixelIterator_obj _hx_dummy;
	PixelIterator_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("vision.ds._Image.PixelIterator",bb,d5,71,b9);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(PixelIterator_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< PixelIterator_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = PixelIterator_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = PixelIterator_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace vision
} // end namespace ds
} // end namespace _Image