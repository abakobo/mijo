Namespace mijo

#Import "<std>"
#Import "<sdl2>"
Using std..
Using sdl2..

Class Canvas
	
	Field _image:Image
	Field _texture:SDL_Texture Ptr
	
	Method New(image:Image)
		If image=Null
			If MIJO_ROOT_CANVAS=Null
				MIJO_ROOT_CANVAS=Self
				_image=Null
				_texture=Null
			Else
				Print "Error: second time Canvas.New(Null) is called, can create only one root canvas, this canvas will be unusable!!!"
			End
		Else
			_image=image
			_texture=image.Texture
		End
	End
	
	Method DrawImage( image:Image, tv:Vec2f, rz:Double, sv:Vec2f)
		'
		'!!!!!!!! this line is a potential performace issue!!!!
		If SDL_GetRenderTarget(MIJO_SDL_RENDERER)<> Self._texture Then SDL_SetRenderTarget(MIJO_SDL_RENDERER,Self._texture) 

		'moyen de colorer l'image (blend modes?) ???
		SDL_SetRenderDrawColor(MIJO_SDL_RENDERER, 255, 255, 255, 255)
		
		 
		Local rectangle:SDL_Rect
		rectangle.x = tv.x
		rectangle.y = tv.y
		rectangle.w = image.width*sv.x
		rectangle.h = image.height*sv.y
		SDL_RenderCopyEx( MIJO_SDL_RENDERER, image.Texture, Null, Varptr rectangle,rz,Null,SDL_FLIP_NONE )
		

	End
End
