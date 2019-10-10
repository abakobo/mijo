
Namespace myap

#Import "<std>"
#Import "<sdl2>"
#Import "<mijo>"
#Import "assets/navet.png"

Using std..
Using sdl2..
Using mijo..



Class Myw Extends MijoWindow
	Field posx:=15
	Field img:Image
	Method New(title:String="mijoWindow",width:Int=800,height:Int=600)
		Super.New(title,width,height)
		img=Image.Load("asset::navet.png")
	End
	Method OnRender(canvas:Canvas) Override
		Local startT:=SDL_GetPerformanceCounter()
		'Local afterTexture:=SDL_GetPerformanceCounter()
		SDL_SetRenderDrawColor(MIJO_SDL_RENDERER, 0, 0, 0, 255)
		SDL_RenderClear(MIJO_SDL_RENDERER)
		
		canvas.DrawImage(img,New Vec2f(posx,25),posx*1.5,New Vec2f(1,1))
		
		#rem
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
		#End
			
		
		Local afterTexture:=SDL_GetPerformanceCounter()
		'SDL_RenderPresent(MIJO_SDL_RENDERER)
		Local afterRender:=SDL_GetPerformanceCounter()
		posx+=3
		If posx>400-60 Then posx=5	
	End
	
End

Function Main()
	Local theGame:=New Myw("test_sdl_mijo",1000,250)
	theGame.Run()
End