Namespace mijo

#Import "<std>"
#Import "<sdl2>"
#Import "image.monkey2"
#Import "canvas.monkey2"



Using std..
Using sdl2..

Global MIJO_SDL_RENDERER:SDL_Renderer Ptr=Null
Global MIJO_SDL_WINDOW:SDL_Window Ptr=Null
Global MIJO_SDL_Initialized:=False
Global MIJO_ROOT_CANVAS:Canvas=Null

Class MijoWindow Abstract

	Method New(title:String="mijoWindow",wwidth:Int=800,wheight:Int=600)

		If SDL_Init(SDL_INIT_VIDEO)<0
			Print ("SDL_inti() Failed")'+SDL_GetError())
		Else
			MIJO_SDL_Initialized=True
			MIJO_SDL_WINDOW = SDL_CreateWindow( title, 5, 5, wwidth, wheight, SDL_WINDOW_SHOWN | SDL_WINDOW_ALLOW_HIGHDPI | SDL_WINDOW_OPENGL )
			If MIJO_SDL_WINDOW = Null
				Print( "SDL_Window could not be created!")
			Else
				SetHintRenderDriverMetal()
				'SetHintRenderDriverOpenGL()
				'SetHintRenderDriverOpenGLES2()
				MIJO_SDL_RENDERER = SDL_CreateRenderer(MIJO_SDL_WINDOW, -1, SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC )'| SDL_RENDERER_TARGETTEXTURE)
				If MIJO_SDL_RENDERER = Null
					Print ("Failed to create SDL_Renderer")
				Else
					PrintRendererInfo(MIJO_SDL_RENDERER)
				End
			End
			MIJO_ROOT_CANVAS=New Canvas(Null)
		End
	End
	
	Method Run()
		
		If MIJO_SDL_RENDERER=Null Or MIJO_SDL_WINDOW=Null Or MIJO_SDL_Initialized=False
			Print "Error: problem while initializing SDL or SDL_window or SDL_Renderer. Can't Run Mijo."
		Else
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
				
				OnRender(MIJO_ROOT_CANVAS)
				SDL_RenderPresent(MIJO_SDL_RENDERER)
				
			End
			SDL_DestroyRenderer(MIJO_SDL_RENDERER)
			SDL_DestroyWindow(MIJO_SDL_WINDOW)
			SDL_Quit()
		End
	End

	Method OnRender(canvas:Canvas) Abstract
	
End
