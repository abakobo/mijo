Namespace mijo

#Import "<std>"
#Import "<sdl2>"
Using std..
Using sdl2..

Class Image Extends Resource
	
	Field width:Int
	Field height:Int
	
	Private
	Field _texture:SDL_Texture Ptr=Null
	
	Public
	
	Method New(pixm:Pixmap)
		
		Local depth := 32
		Local pitch := 4*pixm.Width
		Local pixel_format := SDL_PIXELFORMAT_RGBA32
		Local dataVoidPtr:=Cast<Void Ptr>(pixm.Data)
		Local surface:SDL_Surface Ptr = SDL_CreateRGBSurfaceWithFormatFrom(dataVoidPtr, pixm.Width, pixm.Height, depth, pitch, pixel_format)
		
		If surface = Null
			Print "could not create surface in Image.New(pixmap)"
			Return
		End
		width=pixm.Width
		height=pixm.Height
		_texture=SDL_CreateTextureFromSurface(MIJO_SDL_RENDERER, surface)
		If _texture=Null
			Print "Failed creating SDL_Texture in mijo.Image"
			Local str:=String.FromCString(SDL_GetError())
		End
		SDL_FreeSurface(surface)
		surface = Null

	End

	Function Load:Image(path:String)
		Local tempPixmap:=Pixmap.Load(path,PixelFormat.RGBA32)
		If Not tempPixmap
			Print "failed to load pixmap at "+path
			Return Null
		End
		Return New Image(tempPixmap)
	End
	
		
	Method OnDiscard() Override
		SDL_DestroyTexture(_texture)
	End
	Method OnFinalize() Override
		SDL_DestroyTexture(_texture)
	End
	
	Property Texture:SDL_Texture Ptr()
		Return _texture
	End
	
End
