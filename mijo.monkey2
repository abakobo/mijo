Namespace mijo

#Import "<std>"
#Import "<sdl2>"


Using std..
Using sdl2..

'Global MIJO_SDL_RENDERER:SDL_Renderer Ptr
'Global MIJO_SDL_WINDOW:SDL_Window Ptr
'Global MIJO_SDL_Initialized:=False
'Global MIJO_WINDOW:MijoWindow=Null

Const SCREEN_WIDTH:=320
Const SCREEN_HEIGHT:=256

'Global posx:=15
Global MIJO_SDL_RENDERER:SDL_Renderer Ptr=Null
Global MIJO_SDL_WINDOW:SDL_Window Ptr=Null

Function RunMijo(mijoWindow:MijoWindow)

	Print "Hello WorldMijo"
	
	
	
	If SDL_Init(SDL_INIT_VIDEO)<0
		Print ("pasbon")'+SDL_GetError())
	Else
		MIJO_SDL_WINDOW = SDL_CreateWindow( "SDL Tutorial", 5, 5, mijoWindow.width, mijoWindow.height, SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_OPENGL )
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
			End
			
			SDL_DestroyWindow(MIJO_SDL_WINDOW)
			
			
		End
		SDL_Quit()
	End
End

'Function Main()
	
'	Print "mijo main"

'End

Class MijoWindow
	Field width:Int
	Field height:Int
	Method New(windowWidth:Int=320,windowHeight:Int=256)
		width=windowWidth
		height=windowHeight
	End
	
	Method OnRender(canvas:Canvas=Null) Virtual
		
		#rem
		Local startT:=SDL_GetPerformanceCounter()
		'Local afterTexture:=SDL_GetPerformanceCounter()
		SDL_SetRenderDrawColor(MIJO_SDL_RENDERER, 0, 0, 0, 255)
		SDL_RenderClear(MIJO_SDL_RENDERER)
		
		For Local i:=0 To 3
			For Local j:=0 To 6
				SDL_SetRenderDrawColor(MIJO_SDL_RENDERER, 255-10*i, j*20, 0, 255)
				Local rectangle:SDL_Rect
				Local odd:=0
				If j/2 = j/2.0 Then odd=1
				rectangle.x = posx+40*i+20*odd
				rectangle.y = j*20
				rectangle.w = 20
				rectangle.h = 20
				SDL_RenderFillRect(MIJO_SDL_RENDERER, Varptr rectangle)
			Next
		Next
		Local afterTexture:=SDL_GetPerformanceCounter()
		'SDL_RenderPresent(MIJO_SDL_RENDERER)
		Local afterRender:=SDL_GetPerformanceCounter()
		posx+=3
		If posx>SCREEN_WIDTH-60 Then posx=5
		#end
	End
	
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
		SDL_FreeSurface(surface)
		surface = Null
		
		
	End

	Function Load:Image(path:String)
		Local tempPixmap:=Pixmap.Load(path,PixelFormat.RGBA8)
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

