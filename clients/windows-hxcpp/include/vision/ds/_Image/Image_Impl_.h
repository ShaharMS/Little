// Generated by Haxe 4.3.3
#ifndef INCLUDED_vision_ds__Image_Image_Impl_
#define INCLUDED_vision_ds__Image_Image_Impl_

#ifndef HXCPP_H
#include <hxcpp.h>
#endif

HX_DECLARE_CLASS2(haxe,io,Bytes)
HX_DECLARE_CLASS2(vision,ds,ImageView)
HX_DECLARE_CLASS2(vision,ds,Line2D)
HX_DECLARE_CLASS2(vision,ds,Point2D)
HX_DECLARE_CLASS2(vision,ds,Ray2D)
HX_DECLARE_CLASS2(vision,ds,Rectangle)
HX_DECLARE_CLASS3(vision,ds,_Image,Image_Impl_)

namespace vision{
namespace ds{
namespace _Image{


class HXCPP_CLASS_ATTRIBUTES Image_Impl__obj : public ::hx::Object
{
	public:
		typedef ::hx::Object super;
		typedef Image_Impl__obj OBJ_;
		Image_Impl__obj();

	public:
		enum { _hx_ClassId = 0x17e3139c };

		void __construct();
		inline void *operator new(size_t inSize, bool inContainer=false,const char *inName="vision.ds._Image.Image_Impl_")
			{ return ::hx::Object::operator new(inSize,inContainer,inName); }
		inline void *operator new(size_t inSize, int extra)
			{ return ::hx::Object::operator new(inSize+extra,false,"vision.ds._Image.Image_Impl_"); }

		inline static ::hx::ObjectPtr< Image_Impl__obj > __new() {
			::hx::ObjectPtr< Image_Impl__obj > __this = new Image_Impl__obj();
			__this->__construct();
			return __this;
		}

		inline static ::hx::ObjectPtr< Image_Impl__obj > __alloc(::hx::Ctx *_hx_ctx) {
			Image_Impl__obj *__this = (Image_Impl__obj*)(::hx::Ctx::alloc(_hx_ctx, sizeof(Image_Impl__obj), false, "vision.ds._Image.Image_Impl_"));
			*(void **)__this = Image_Impl__obj::_hx_vtable;
			return __this;
		}

		static void * _hx_vtable;
		static Dynamic __CreateEmpty();
		static Dynamic __Create(::hx::DynamicArray inArgs);
		//~Image_Impl__obj();

		HX_DO_RTTI_ALL;
		static bool __GetStatic(const ::String &inString, Dynamic &outValue, ::hx::PropertyAccess inCallProp);
		static void __register();
		bool _hx_isInstanceOf(int inClassId);
		::String __ToString() const { return HX_("Image_Impl_",1b,6a,67,44); }

		static void __boot();
		static int OFFSET;
		static int WIDTH_BYTES;
		static int VIEW_XY_BYTES;
		static int VIEW_WH_BYTES;
		static int VIEW_SHAPE_BYTES;
		static int DATA_GAP;
		static  ::haxe::io::Bytes get_underlying( ::haxe::io::Bytes this1);
		static ::Dynamic get_underlying_dyn();

		static int get_width( ::haxe::io::Bytes this1);
		static ::Dynamic get_width_dyn();

		static int get_height( ::haxe::io::Bytes this1);
		static ::Dynamic get_height_dyn();

		static  ::vision::ds::ImageView get_view( ::haxe::io::Bytes this1);
		static ::Dynamic get_view_dyn();

		static  ::vision::ds::ImageView set_view( ::haxe::io::Bytes this1, ::vision::ds::ImageView view);
		static ::Dynamic set_view_dyn();

		static  ::haxe::io::Bytes _new(int width,int height,::hx::Null< int >  color);
		static ::Dynamic _new_dyn();

		static int getColorFromStartingBytePos( ::haxe::io::Bytes this1,int position);
		static ::Dynamic getColorFromStartingBytePos_dyn();

		static int setColorFromStartingBytePos( ::haxe::io::Bytes this1,int position,int c);
		static ::Dynamic setColorFromStartingBytePos_dyn();

		static int getPixel( ::haxe::io::Bytes this1,int x,int y);
		static ::Dynamic getPixel_dyn();

		static int getSafePixel( ::haxe::io::Bytes this1,int x,int y);
		static ::Dynamic getSafePixel_dyn();

		static int getUnsafePixel( ::haxe::io::Bytes this1,int x,int y);
		static ::Dynamic getUnsafePixel_dyn();

		static int getFloatingPixel( ::haxe::io::Bytes this1,Float x,Float y);
		static ::Dynamic getFloatingPixel_dyn();

		static void setPixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic setPixel_dyn();

		static void setSafePixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic setSafePixel_dyn();

		static void setFloatingPixel( ::haxe::io::Bytes this1,Float x,Float y,int color);
		static ::Dynamic setFloatingPixel_dyn();

		static void setUnsafePixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic setUnsafePixel_dyn();

		static void paintPixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic paintPixel_dyn();

		static void paintFloatingPixel( ::haxe::io::Bytes this1,Float x,Float y,int color);
		static ::Dynamic paintFloatingPixel_dyn();

		static void paintSafePixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic paintSafePixel_dyn();

		static void paintUnsafePixel( ::haxe::io::Bytes this1,int x,int y,int color);
		static ::Dynamic paintUnsafePixel_dyn();

		static bool hasPixel( ::haxe::io::Bytes this1,Float x,Float y);
		static ::Dynamic hasPixel_dyn();

		static void movePixel( ::haxe::io::Bytes this1,int fromX,int fromY,int toX,int toY,int oldPixelResetColor);
		static ::Dynamic movePixel_dyn();

		static void moveSafePixel( ::haxe::io::Bytes this1,int fromX,int fromY,int toX,int toY,int oldPixelResetColor);
		static ::Dynamic moveSafePixel_dyn();

		static void moveFloatingPixel( ::haxe::io::Bytes this1,Float fromX,Float fromY,Float toX,Float toY,int oldPixelResetColor);
		static ::Dynamic moveFloatingPixel_dyn();

		static void moveUnsafePixel( ::haxe::io::Bytes this1,int fromX,int fromY,int toX,int toY,int oldPixelResetColor);
		static ::Dynamic moveUnsafePixel_dyn();

		static int copyPixelFrom( ::haxe::io::Bytes this1, ::haxe::io::Bytes image,int x,int y);
		static ::Dynamic copyPixelFrom_dyn();

		static int copyPixelTo( ::haxe::io::Bytes this1, ::haxe::io::Bytes image,int x,int y);
		static ::Dynamic copyPixelTo_dyn();

		static  ::haxe::io::Bytes getImagePortion( ::haxe::io::Bytes this1, ::vision::ds::Rectangle rect);
		static ::Dynamic getImagePortion_dyn();

		static void setImagePortion( ::haxe::io::Bytes this1, ::vision::ds::Rectangle rect, ::haxe::io::Bytes image);
		static ::Dynamic setImagePortion_dyn();

		static void drawLine( ::haxe::io::Bytes this1,int x1,int y1,int x2,int y2,int color);
		static ::Dynamic drawLine_dyn();

		static void drawRay2D( ::haxe::io::Bytes this1, ::vision::ds::Ray2D line,int color);
		static ::Dynamic drawRay2D_dyn();

		static void drawLine2D( ::haxe::io::Bytes this1, ::vision::ds::Line2D line,int color);
		static ::Dynamic drawLine2D_dyn();

		static void fillRect( ::haxe::io::Bytes this1,int x,int y,int width,int height,int color);
		static ::Dynamic fillRect_dyn();

		static void drawRect( ::haxe::io::Bytes this1,int x,int y,int width,int height,int color);
		static ::Dynamic drawRect_dyn();

		static void drawQuadraticBezier( ::haxe::io::Bytes this1, ::vision::ds::Line2D line,::cpp::Int64 control,int color,::hx::Null< Float >  accuracy);
		static ::Dynamic drawQuadraticBezier_dyn();

		static void drawCubicBezier( ::haxe::io::Bytes this1, ::vision::ds::Line2D line,::cpp::Int64 control1,::cpp::Int64 control2,int color, ::Dynamic accuracy);
		static ::Dynamic drawCubicBezier_dyn();

		static void fillCircle( ::haxe::io::Bytes this1,int X,int Y,int r,int color);
		static ::Dynamic fillCircle_dyn();

		static void drawCircle( ::haxe::io::Bytes this1,int X,int Y,int r,int color);
		static ::Dynamic drawCircle_dyn();

		static void drawEllipse( ::haxe::io::Bytes this1,int centerX,int centerY,int radiusX,int radiusY,int color);
		static ::Dynamic drawEllipse_dyn();

		static void fillColorRecursive( ::haxe::io::Bytes this1,::cpp::Int64 position,int color);
		static ::Dynamic fillColorRecursive_dyn();

		static void fillColor( ::haxe::io::Bytes this1,::cpp::Int64 position,int color);
		static ::Dynamic fillColor_dyn();

		static void fillUntilColor( ::haxe::io::Bytes this1,::cpp::Int64 position,int color,int borderColor);
		static ::Dynamic fillUntilColor_dyn();

		static  ::haxe::io::Bytes clone( ::haxe::io::Bytes this1);
		static ::Dynamic clone_dyn();

		static  ::haxe::io::Bytes mirror( ::haxe::io::Bytes this1);
		static ::Dynamic mirror_dyn();

		static  ::haxe::io::Bytes flip( ::haxe::io::Bytes this1);
		static ::Dynamic flip_dyn();

		static  ::haxe::io::Bytes stamp( ::haxe::io::Bytes this1,int X,int Y, ::haxe::io::Bytes image);
		static ::Dynamic stamp_dyn();

		static  ::haxe::io::Bytes resize( ::haxe::io::Bytes this1,::hx::Null< int >  newWidth,::hx::Null< int >  newHeight, ::Dynamic algorithm);
		static ::Dynamic resize_dyn();

		static  ::haxe::io::Bytes rotate( ::haxe::io::Bytes this1,Float angle, ::Dynamic degrees,::hx::Null< bool >  expandImageBounds);
		static ::Dynamic rotate_dyn();

		static ::String toString( ::haxe::io::Bytes this1,::hx::Null< bool >  special);
		static ::Dynamic toString_dyn();

		static void forEachPixel( ::haxe::io::Bytes this1, ::Dynamic callback);
		static ::Dynamic forEachPixel_dyn();

		static void forEachPixelInView( ::haxe::io::Bytes this1, ::Dynamic callback);
		static ::Dynamic forEachPixelInView_dyn();

		static  ::Dynamic iterator( ::haxe::io::Bytes this1);
		static ::Dynamic iterator_dyn();

		static  ::vision::ds::Point2D center( ::haxe::io::Bytes this1);
		static ::Dynamic center_dyn();

		static bool hasView( ::haxe::io::Bytes this1);
		static ::Dynamic hasView_dyn();

		static  ::haxe::io::Bytes setView( ::haxe::io::Bytes this1, ::vision::ds::ImageView view);
		static ::Dynamic setView_dyn();

		static  ::vision::ds::ImageView getView( ::haxe::io::Bytes this1);
		static ::Dynamic getView_dyn();

		static  ::haxe::io::Bytes removeView( ::haxe::io::Bytes this1);
		static ::Dynamic removeView_dyn();

		static bool hasPixelInView( ::haxe::io::Bytes this1,int x,int y, ::vision::ds::ImageView v);
		static ::Dynamic hasPixelInView_dyn();

		static  ::haxe::io::Bytes from2DArray(::Array< ::Dynamic> array);
		static ::Dynamic from2DArray_dyn();

		static ::Array< ::Dynamic> to2DArray( ::haxe::io::Bytes this1);
		static ::Dynamic to2DArray_dyn();

		static  ::Dynamic fromBytes( ::haxe::io::Bytes bytes,int width, ::Dynamic height);
		static ::Dynamic fromBytes_dyn();

		static  ::haxe::io::Bytes image_or_image( ::haxe::io::Bytes lhs, ::haxe::io::Bytes rhs);
		static ::Dynamic image_or_image_dyn();

		static  ::haxe::io::Bytes image_xor_image( ::haxe::io::Bytes lhs, ::haxe::io::Bytes rhs);
		static ::Dynamic image_xor_image_dyn();

		static  ::haxe::io::Bytes image_and_image( ::haxe::io::Bytes lhs, ::haxe::io::Bytes rhs);
		static ::Dynamic image_and_image_dyn();

};

} // end namespace vision
} // end namespace ds
} // end namespace _Image

#endif /* INCLUDED_vision_ds__Image_Image_Impl_ */ 
