Namespace mijo

#Import "<std>"
#Import "<sdl2>"


Using std..
Using sdl2..

'Global MIJO_SDL_RENDERER:SDL_Renderer Ptr
'Global MIJO_SDL_WINDOW:SDL_Window Ptr
'Global MIJO_SDL_Initialized:=False
'Global MIJO_WINDOW:MijoWindow=Null



'Global posx:=15
Global MIJO_SDL_RENDERER:SDL_Renderer Ptr=Null
Global MIJO_SDL_WINDOW:SDL_Window Ptr=Null


'Global SCREEN_WIDTH:=320
'Global SCREEN_HEIGHT:=256

Function InitMijo(wwidth:Int,wheight:Int)
	Print "mijo init"
	If SDL_Init(SDL_INIT_VIDEO)<0
		Print ("pasbon")'+SDL_GetError())
	Else
		MIJO_SDL_WINDOW = SDL_CreateWindow( "SDL Tutorial", 5, 5, wwidth, wheight, SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_OPENGL )
		If MIJO_SDL_WINDOW = Null
			Print( "Window could not be created!")
		Else
			Print "ok?"
			
			SetHintRenderDriverMetal()
			'SetHintRenderDriverOpenGL()
			'SetHintRenderDriverOpenGLES2()
			MIJO_SDL_RENDERER = SDL_CreateRenderer(MIJO_SDL_WINDOW, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC )'| SDL_RENDERER_TARGETTEXTURE)
			If MIJO_SDL_RENDERER = Null
				Print ("Failed to create renderer")
			Else
				PrintRendererInfo(MIJO_SDL_RENDERER)
			End
		End
	End
End

Function RunMijo(mijoWindow:MijoWindow)

	Print "Hello WorldMijo"
	
	Local e:SDL_Event
	Local quit := False
	While Not quit
		
		While SDL_PollEvent(Varptr e)
			If e.type = SDL_QUIT
				quit = True
			End
			If e.type = SDL_KEYDOWN
				quit = True
			End
			If e.type = SDL_MOUSEBUTTONDOWN
				Print "--------"
				
			End
		End
		
		mijoWindow.OnRender()
		SDL_RenderPresent(MIJO_SDL_RENDERER)
		
	End
	SDL_DestroyWindow(MIJO_SDL_WINDOW)
	SDL_Quit()
End

'Function Main()
	
'	Print "mijo main"

'End

Class MijoWindow Abstract

	Method New()
	End
	
	Method OnRender(canvas:Canvas=Null) Abstract
	
End

Class Canvas
	
End

Class Image Extends Resource
	
	Field texture:SDL_Texture Ptr=Null
	
	Method New(pixm:Pixmap)
		
		Local depth := 32
		Local pitch := 4*pixm.Width
		Local pixel_format := SDL_PIXELFORMAT_RGBA32
		Local dataVoidPtr:=Cast<Void Ptr>(pixm.Data)
		Local surface:SDL_Surface Ptr = SDL_CreateRGBSurfaceWithFormatFrom(dataVoidPtr, pixm.Width, pixm.Height, depth, pitch, pixel_format)
		
		
		
		If surface = Null
			'SDL_Log("Creating surface failed: %s", SDL_GetError());
			Print "could not create surface in Image.New(pixmap)"
			Return
		End
		texture=SDL_CreateTextureFromSurface(MIJO_SDL_RENDERER, surface)
		If texture=Null
			Print "textufoire"
			Local str:=String.FromCString(SDL_GetError())
		Else
			Print "texureOK" 
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
		'SDL_PIXELFORMAT_RGBA8888
	End
	
		
	Method OnDiscard() Override
	End
	Method OnFinalize() Override
	End
	
End

Function PixmapToImage:Image(pixm:Pixmap)
	Return Null
End
'Function PixMapToSDL_Surface:SDL_Surface(pixm:Pixmap)
'	Return Null
'End

