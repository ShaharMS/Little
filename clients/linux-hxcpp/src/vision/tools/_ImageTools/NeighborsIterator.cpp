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
#ifndef INCLUDED_vision_ds_Point2D
#include <vision/ds/Point2D.h>
#endif
#ifndef INCLUDED_vision_ds__Image_Image_Impl_
#include <vision/ds/_Image/Image_Impl_.h>
#endif
#ifndef INCLUDED_vision_exceptions_OutOfBounds
#include <vision/exceptions/OutOfBounds.h>
#endif
#ifndef INCLUDED_vision_exceptions_VisionException
#include <vision/exceptions/VisionException.h>
#endif
#ifndef INCLUDED_vision_tools__ImageTools_NeighborsIterator
#include <vision/tools/_ImageTools/NeighborsIterator.h>
#endif

HX_DEFINE_STACK_FRAME(_hx_pos_d7278d83181e5193_575_new,"vision.tools._ImageTools.NeighborsIterator","new",0x11b3e159,"vision.tools._ImageTools.NeighborsIterator.new","vision/tools/ImageTools.hx",575,0x20db1cc3)
HX_LOCAL_STACK_FRAME(_hx_pos_d7278d83181e5193_585_next,"vision.tools._ImageTools.NeighborsIterator","next",0x6bb14dda,"vision.tools._ImageTools.NeighborsIterator.next","vision/tools/ImageTools.hx",585,0x20db1cc3)
HX_LOCAL_STACK_FRAME(_hx_pos_d7278d83181e5193_597_hasNext,"vision.tools._ImageTools.NeighborsIterator","hasNext",0x21b526e6,"vision.tools._ImageTools.NeighborsIterator.hasNext","vision/tools/ImageTools.hx",597,0x20db1cc3)
namespace vision{
namespace tools{
namespace _ImageTools{

void NeighborsIterator_obj::__construct( ::haxe::io::Bytes image,int x,int y,int kernelSize,::hx::Null< bool >  __o_circular){
            		bool circular = __o_circular.Default(false);
            	HX_STACKFRAME(&_hx_pos_d7278d83181e5193_575_new)
HXLINE( 576)		this->image = image;
HXLINE( 577)		this->roundedDown = ((kernelSize - 1) >> 1);
HXLINE( 578)		this->x = x;
HXLINE( 579)		this->y = y;
HXLINE( 580)		this->circular = circular;
HXLINE( 581)		this->X = -(this->roundedDown);
HXLINE( 582)		this->Y = -(this->roundedDown);
            	}

Dynamic NeighborsIterator_obj::__CreateEmpty() { return new NeighborsIterator_obj; }

void *NeighborsIterator_obj::_hx_vtable = 0;

Dynamic NeighborsIterator_obj::__Create(::hx::DynamicArray inArgs)
{
	::hx::ObjectPtr< NeighborsIterator_obj > _hx_result = new NeighborsIterator_obj();
	_hx_result->__construct(inArgs[0],inArgs[1],inArgs[2],inArgs[3],inArgs[4]);
	return _hx_result;
}

bool NeighborsIterator_obj::_hx_isInstanceOf(int inClassId) {
	return inClassId==(int)0x00000001 || inClassId==(int)0x30665943;
}

int NeighborsIterator_obj::next(){
            	HX_GC_STACKFRAME(&_hx_pos_d7278d83181e5193_585_next)
HXLINE( 586)		while(true){
HXLINE( 587)			 ::vision::tools::_ImageTools::NeighborsIterator _hx_tmp = ::hx::ObjectPtr<OBJ_>(this);
HXDLIN( 587)			_hx_tmp->Y = (_hx_tmp->Y + 1);
HXLINE( 588)			if ((this->Y > this->roundedDown)) {
HXLINE( 589)				this->Y = -(this->roundedDown);
HXLINE( 590)				 ::vision::tools::_ImageTools::NeighborsIterator _hx_tmp1 = ::hx::ObjectPtr<OBJ_>(this);
HXDLIN( 590)				_hx_tmp1->X = (_hx_tmp1->X + 1);
            			}
HXLINE( 592)			bool _hx_tmp2;
HXDLIN( 592)			if (this->circular) {
HXLINE( 592)				Float point1_x = ( (Float)(this->X) );
HXDLIN( 592)				Float point1_y = ( (Float)(this->Y) );
HXDLIN( 592)				Float point2_x = ( (Float)(this->roundedDown) );
HXDLIN( 592)				Float point2_y = ( (Float)(this->roundedDown) );
HXDLIN( 592)				Float x = (point2_x - point1_x);
HXDLIN( 592)				Float y = (point2_y - point1_y);
HXDLIN( 592)				_hx_tmp2 = (::Math_obj::sqrt(((x * x) + (y * y))) > this->roundedDown);
            			}
            			else {
HXLINE( 592)				_hx_tmp2 = false;
            			}
HXLINE( 586)			if (!(_hx_tmp2)) {
HXLINE( 586)				goto _hx_goto_1;
            			}
            		}
            		_hx_goto_1:;
HXLINE( 593)		 ::haxe::io::Bytes this1 = this->image;
HXDLIN( 593)		int y1 = (this->y + this->Y);
HXDLIN( 593)		 ::haxe::io::Bytes _this = this1;
HXDLIN( 593)		int ma = ((( (int)(_this->b->__get(0)) ) | (( (int)(_this->b->__get(1)) ) << 8)) - 1);
HXDLIN( 593)		::Array< int > values = ::Array_obj< int >::__new(2)->init(0,(this->x + this->X))->init(1,0);
HXDLIN( 593)		int max = values->__get(0);
HXDLIN( 593)		{
HXLINE( 593)			int _g = 0;
HXDLIN( 593)			int _g1 = values->length;
HXDLIN( 593)			while((_g < _g1)){
HXLINE( 593)				_g = (_g + 1);
HXDLIN( 593)				int i = (_g - 1);
HXDLIN( 593)				if ((values->__get(i) > max)) {
HXLINE( 688)					max = values->__get(i);
            				}
            			}
            		}
HXLINE( 593)		::Array< int > values1 = ::Array_obj< int >::__new(2)->init(0,max)->init(1,ma);
HXDLIN( 593)		int min = values1->__get(0);
HXDLIN( 593)		{
HXLINE( 593)			int _g2 = 0;
HXDLIN( 593)			int _g3 = values1->length;
HXDLIN( 593)			while((_g2 < _g3)){
HXLINE( 593)				_g2 = (_g2 + 1);
HXDLIN( 593)				int i1 = (_g2 - 1);
HXDLIN( 593)				if ((values1->__get(i1) < min)) {
HXLINE( 652)					min = values1->__get(i1);
            				}
            			}
            		}
HXLINE( 593)		int x1 = min;
HXDLIN( 593)		 ::haxe::io::Bytes _this1 = this1;
HXDLIN( 593)		int ma1 = (::Math_obj::ceil((( (Float)((this1->length - ::vision::ds::_Image::Image_Impl__obj::OFFSET)) ) / ( (Float)(((( (int)(_this1->b->__get(0)) ) | (( (int)(_this1->b->__get(1)) ) << 8)) * 4)) ))) - 1);
HXDLIN( 593)		::Array< int > values2 = ::Array_obj< int >::__new(2)->init(0,y1)->init(1,0);
HXDLIN( 593)		int max1 = values2->__get(0);
HXDLIN( 593)		{
HXLINE( 593)			int _g4 = 0;
HXDLIN( 593)			int _g5 = values2->length;
HXDLIN( 593)			while((_g4 < _g5)){
HXLINE( 593)				_g4 = (_g4 + 1);
HXDLIN( 593)				int i2 = (_g4 - 1);
HXDLIN( 593)				if ((values2->__get(i2) > max1)) {
HXLINE( 688)					max1 = values2->__get(i2);
            				}
            			}
            		}
HXLINE( 593)		::Array< int > values3 = ::Array_obj< int >::__new(2)->init(0,max1)->init(1,ma1);
HXDLIN( 593)		int min1 = values3->__get(0);
HXDLIN( 593)		{
HXLINE( 593)			int _g6 = 0;
HXDLIN( 593)			int _g7 = values3->length;
HXDLIN( 593)			while((_g6 < _g7)){
HXLINE( 593)				_g6 = (_g6 + 1);
HXDLIN( 593)				int i3 = (_g6 - 1);
HXDLIN( 593)				if ((values3->__get(i3) < min1)) {
HXLINE( 652)					min1 = values3->__get(i3);
            				}
            			}
            		}
HXLINE( 593)		int y2 = min1;
HXDLIN( 593)		bool _hx_tmp3;
HXDLIN( 593)		bool _hx_tmp4;
HXDLIN( 593)		bool _hx_tmp5;
HXDLIN( 593)		if ((x1 >= 0)) {
HXLINE( 593)			_hx_tmp5 = (y2 >= 0);
            		}
            		else {
HXLINE( 593)			_hx_tmp5 = false;
            		}
HXDLIN( 593)		if (_hx_tmp5) {
HXLINE( 593)			 ::haxe::io::Bytes _this2 = this1;
HXDLIN( 593)			_hx_tmp4 = (x1 < (( (int)(_this2->b->__get(0)) ) | (( (int)(_this2->b->__get(1)) ) << 8)));
            		}
            		else {
HXLINE( 593)			_hx_tmp4 = false;
            		}
HXDLIN( 593)		if (_hx_tmp4) {
HXLINE( 593)			 ::haxe::io::Bytes _this3 = this1;
HXDLIN( 593)			_hx_tmp3 = (y2 < ::Math_obj::ceil((( (Float)((this1->length - ::vision::ds::_Image::Image_Impl__obj::OFFSET)) ) / ( (Float)(((( (int)(_this3->b->__get(0)) ) | (( (int)(_this3->b->__get(1)) ) << 8)) * 4)) ))));
            		}
            		else {
HXLINE( 593)			_hx_tmp3 = false;
            		}
HXDLIN( 593)		if (!(_hx_tmp3)) {
HXLINE( 593)			::cpp::Int64 this2 = _hx_int64_make(x1,y2);
HXDLIN( 593)			int _hx_tmp6 = _hx_int64_high(this2);
HXDLIN( 593)			HX_STACK_DO_THROW( ::vision::exceptions::OutOfBounds_obj::__alloc( HX_CTX ,this1, ::vision::ds::Point2D_obj::__alloc( HX_CTX ,_hx_tmp6,_hx_int64_low(this2))));
            		}
HXDLIN( 593)		 ::haxe::io::Bytes _this4 = this1;
HXDLIN( 593)		int position = (((y2 * (( (int)(_this4->b->__get(0)) ) | (( (int)(_this4->b->__get(1)) ) << 8))) + x1) * 4);
HXDLIN( 593)		position = (position + ::vision::ds::_Image::Image_Impl__obj::OFFSET);
HXDLIN( 593)		return ((((( (int)(this1->b->__get(position)) ) << 24) | (( (int)(this1->b->__get((position + 1))) ) << 16)) | (( (int)(this1->b->__get((position + 2))) ) << 8)) | ( (int)(this1->b->__get((position + 3))) ));
            	}


HX_DEFINE_DYNAMIC_FUNC0(NeighborsIterator_obj,next,return )

bool NeighborsIterator_obj::hasNext(){
            	HX_STACKFRAME(&_hx_pos_d7278d83181e5193_597_hasNext)
HXDLIN( 597)		if ((this->X <= this->roundedDown)) {
HXDLIN( 597)			return (this->Y <= this->roundedDown);
            		}
            		else {
HXDLIN( 597)			return false;
            		}
HXDLIN( 597)		return false;
            	}


HX_DEFINE_DYNAMIC_FUNC0(NeighborsIterator_obj,hasNext,return )


::hx::ObjectPtr< NeighborsIterator_obj > NeighborsIterator_obj::__new( ::haxe::io::Bytes image,int x,int y,int kernelSize,::hx::Null< bool >  __o_circular) {
	::hx::ObjectPtr< NeighborsIterator_obj > __this = new NeighborsIterator_obj();
	__this->__construct(image,x,y,kernelSize,__o_circular);
	return __this;
}

::hx::ObjectPtr< NeighborsIterator_obj > NeighborsIterator_obj::__alloc(::hx::Ctx *_hx_ctx, ::haxe::io::Bytes image,int x,int y,int kernelSize,::hx::Null< bool >  __o_circular) {
	NeighborsIterator_obj *__this = (NeighborsIterator_obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(NeighborsIterator_obj), true, "vision.tools._ImageTools.NeighborsIterator"));
	*(void **)__this = NeighborsIterator_obj::_hx_vtable;
	__this->__construct(image,x,y,kernelSize,__o_circular);
	return __this;
}

NeighborsIterator_obj::NeighborsIterator_obj()
{
}

void NeighborsIterator_obj::__Mark(HX_MARK_PARAMS)
{
	HX_MARK_BEGIN_CLASS(NeighborsIterator);
	HX_MARK_MEMBER_NAME(roundedDown,"roundedDown");
	HX_MARK_MEMBER_NAME(image,"image");
	HX_MARK_MEMBER_NAME(x,"x");
	HX_MARK_MEMBER_NAME(y,"y");
	HX_MARK_MEMBER_NAME(X,"X");
	HX_MARK_MEMBER_NAME(Y,"Y");
	HX_MARK_MEMBER_NAME(circular,"circular");
	HX_MARK_END_CLASS();
}

void NeighborsIterator_obj::__Visit(HX_VISIT_PARAMS)
{
	HX_VISIT_MEMBER_NAME(roundedDown,"roundedDown");
	HX_VISIT_MEMBER_NAME(image,"image");
	HX_VISIT_MEMBER_NAME(x,"x");
	HX_VISIT_MEMBER_NAME(y,"y");
	HX_VISIT_MEMBER_NAME(X,"X");
	HX_VISIT_MEMBER_NAME(Y,"Y");
	HX_VISIT_MEMBER_NAME(circular,"circular");
}

::hx::Val NeighborsIterator_obj::__Field(const ::String &inName,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { return ::hx::Val( x ); }
		if (HX_FIELD_EQ(inName,"y") ) { return ::hx::Val( y ); }
		if (HX_FIELD_EQ(inName,"X") ) { return ::hx::Val( X ); }
		if (HX_FIELD_EQ(inName,"Y") ) { return ::hx::Val( Y ); }
		break;
	case 4:
		if (HX_FIELD_EQ(inName,"next") ) { return ::hx::Val( next_dyn() ); }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"image") ) { return ::hx::Val( image ); }
		break;
	case 7:
		if (HX_FIELD_EQ(inName,"hasNext") ) { return ::hx::Val( hasNext_dyn() ); }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"circular") ) { return ::hx::Val( circular ); }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"roundedDown") ) { return ::hx::Val( roundedDown ); }
	}
	return super::__Field(inName,inCallProp);
}

::hx::Val NeighborsIterator_obj::__SetField(const ::String &inName,const ::hx::Val &inValue,::hx::PropertyAccess inCallProp)
{
	switch(inName.length) {
	case 1:
		if (HX_FIELD_EQ(inName,"x") ) { x=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"y") ) { y=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"X") ) { X=inValue.Cast< int >(); return inValue; }
		if (HX_FIELD_EQ(inName,"Y") ) { Y=inValue.Cast< int >(); return inValue; }
		break;
	case 5:
		if (HX_FIELD_EQ(inName,"image") ) { image=inValue.Cast<  ::haxe::io::Bytes >(); return inValue; }
		break;
	case 8:
		if (HX_FIELD_EQ(inName,"circular") ) { circular=inValue.Cast< bool >(); return inValue; }
		break;
	case 11:
		if (HX_FIELD_EQ(inName,"roundedDown") ) { roundedDown=inValue.Cast< int >(); return inValue; }
	}
	return super::__SetField(inName,inValue,inCallProp);
}

void NeighborsIterator_obj::__GetFields(Array< ::String> &outFields)
{
	outFields->push(HX_("roundedDown",2f,bf,1e,21));
	outFields->push(HX_("image",5b,1f,69,bd));
	outFields->push(HX_("x",78,00,00,00));
	outFields->push(HX_("y",79,00,00,00));
	outFields->push(HX_("X",58,00,00,00));
	outFields->push(HX_("Y",59,00,00,00));
	outFields->push(HX_("circular",5f,a6,d2,0f));
	super::__GetFields(outFields);
};

#ifdef HXCPP_SCRIPTABLE
static ::hx::StorageInfo NeighborsIterator_obj_sMemberStorageInfo[] = {
	{::hx::fsInt,(int)offsetof(NeighborsIterator_obj,roundedDown),HX_("roundedDown",2f,bf,1e,21)},
	{::hx::fsObject /*  ::haxe::io::Bytes */ ,(int)offsetof(NeighborsIterator_obj,image),HX_("image",5b,1f,69,bd)},
	{::hx::fsInt,(int)offsetof(NeighborsIterator_obj,x),HX_("x",78,00,00,00)},
	{::hx::fsInt,(int)offsetof(NeighborsIterator_obj,y),HX_("y",79,00,00,00)},
	{::hx::fsInt,(int)offsetof(NeighborsIterator_obj,X),HX_("X",58,00,00,00)},
	{::hx::fsInt,(int)offsetof(NeighborsIterator_obj,Y),HX_("Y",59,00,00,00)},
	{::hx::fsBool,(int)offsetof(NeighborsIterator_obj,circular),HX_("circular",5f,a6,d2,0f)},
	{ ::hx::fsUnknown, 0, null()}
};
static ::hx::StaticInfo *NeighborsIterator_obj_sStaticStorageInfo = 0;
#endif

static ::String NeighborsIterator_obj_sMemberFields[] = {
	HX_("roundedDown",2f,bf,1e,21),
	HX_("image",5b,1f,69,bd),
	HX_("x",78,00,00,00),
	HX_("y",79,00,00,00),
	HX_("X",58,00,00,00),
	HX_("Y",59,00,00,00),
	HX_("circular",5f,a6,d2,0f),
	HX_("next",f3,84,02,49),
	HX_("hasNext",6d,a5,46,18),
	::String(null()) };

::hx::Class NeighborsIterator_obj::__mClass;

void NeighborsIterator_obj::__register()
{
	NeighborsIterator_obj _hx_dummy;
	NeighborsIterator_obj::_hx_vtable = *(void **)&_hx_dummy;
	::hx::Static(__mClass) = new ::hx::Class_obj();
	__mClass->mName = HX_("vision.tools._ImageTools.NeighborsIterator",e7,40,48,88);
	__mClass->mSuper = &super::__SGetClass();
	__mClass->mConstructEmpty = &__CreateEmpty;
	__mClass->mConstructArgs = &__Create;
	__mClass->mGetStaticField = &::hx::Class_obj::GetNoStaticField;
	__mClass->mSetStaticField = &::hx::Class_obj::SetNoStaticField;
	__mClass->mStatics = ::hx::Class_obj::dupFunctions(0 /* sStaticFields */);
	__mClass->mMembers = ::hx::Class_obj::dupFunctions(NeighborsIterator_obj_sMemberFields);
	__mClass->mCanCast = ::hx::TCanCast< NeighborsIterator_obj >;
#ifdef HXCPP_SCRIPTABLE
	__mClass->mMemberStorageInfo = NeighborsIterator_obj_sMemberStorageInfo;
#endif
#ifdef HXCPP_SCRIPTABLE
	__mClass->mStaticStorageInfo = NeighborsIterator_obj_sStaticStorageInfo;
#endif
	::hx::_hx_RegisterClass(__mClass->mName, __mClass);
}

} // end namespace vision
} // end namespace tools
} // end namespace _ImageTools