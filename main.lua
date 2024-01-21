
function love.load()

	width = love.graphics.getWidth()    -- half the window width
	height = love.graphics.getHeight()    -- half the window height

	x, y = love.mouse.getPosition()  
	love.keyboard.setKeyRepeat(true)

	ease=0.001
	
	minSeparation=256
	VelMax=32
	sepNormMag = 128
	
	gridWidth = 32
	gridHeight = 16
	Npoints=gridWidth*gridHeight
	
	cellWidth = width/gridWidth;
	cellHeight = height/gridHeight;
	
	Xpos = {}
	Ypos = {}
	XposAve = {}
	YposAve = {}
	
	Xvel = {}
	Yvel = {}
	XvelAve = {}
	YvelAve = {}
	
	Xsep = {}
	Ysep = {}

	for i = 1 , Npoints do
		Xpos[i]	=math.floor(math.random()*width)
		Ypos[i]	=math.floor(math.random()*height)
		Xvel[i]	=math.floor(math.random()-0.5)
		Yvel[i] =math.floor(math.random()-0.5)
		Xsep[i]=0
		Ysep[i]=0
		XposAve[i]=width/2
		YposAve[i]=height/2
		XvelAve[i]=0
		YvelAve[i]=0
	end
	
	
end

function love.draw()

	love.graphics.setColor(255,255,255)
	love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)

	for i = 1,Npoints do
		r=Xpos[i]/width
		b=Ypos[i]/height
		love.graphics.setColor(r,(r+b)/2,b)
		love.graphics.rectangle("fill",((i-1) % gridWidth)*cellWidth,  ((i-((i-1) % gridWidth)) / gridWidth)*cellHeight ,cellWidth,cellHeight )
		
		--love.graphics.points(Xpos[i],Ypos[i])
		--love.graphics.circle("fill",Xpos[i],Ypos[i] ,4 ,8)
	end
end

function love.keypressed(key)

	if key=="escape" then
		love.event.push('quit')
	end

	if key=="return" then
		for i = 1 , Npoints do
			Xpos[i]	=math.floor(math.random()*width)
			Ypos[i]	=math.floor(math.random()*height)
			Xvel[i]	=math.floor(math.random()-0.5)
			Yvel[i] =math.floor(math.random()-0.5)
			Xsep[i]=0
			Ysep[i]=0
			XposAve[i]=width/2
			YposAve[i]=height/2
			XvelAve[i]=0
			YvelAve[i]=0
		end
	end

end


function love.quit()
	print("The End")
	return false
end


function love.update(dt)

	love.timer.sleep(0.01)

	for h = 1 , Npoints do
		for i = 1 , Npoints do 
			if i ~= h then 
				XposAve[h] = XposAve[h] + Xpos[i]
				YposAve[h] = YposAve[h] + Ypos[i]
				
				XvelAve[h] = XvelAve[h] + Xvel[i]
				YvelAve[h] = YvelAve[h] + Yvel[i]
				dx = Xpos[h] - Xpos[i]
				dy = Ypos[h] - Ypos[i]
				
				if (dx*dx + dy*dy < minSeparation) then
					Xsep[h] = Xsep[h] + dx
					Ysep[h] = Ysep[h] + dy
				end
				
			end
		end	
		
		XposAve[h] = XposAve[h]/Npoints
		YposAve[h] = YposAve[h]/Npoints
		XvelAve[h] = XvelAve[h]/Npoints
		YvelAve[h] = YvelAve[h]/Npoints
		
		if ((Xsep[h] ~= 0) or (Ysep[h] ~= 0)) then
			normalize = math.sqrt(Xsep[h]*Xsep[h] + Ysep[h]*Ysep[h] )
			Xsep[h] = Xsep[h] * sepNormMag/normalize
			Ysep[h] = Ysep[h] * sepNormMag/normalize
		end
		
		Xvel[h] = (1-ease)*Xvel[h] + ease*(Xsep[h] + XvelAve[h] + XposAve[h] - Xpos[h] )
		Yvel[h] = (1-ease)*Yvel[h] + ease*(Ysep[h] + YvelAve[h] + YposAve[h] - Ypos[h] )
		
		--if the velocity is too high, clamp it
		if (Xvel[h]*Xvel[h] + Yvel[h]*Yvel[h] > VelMax) then
			Xvel[h] = Xvel[h]/2
			Yvel[h] = Yvel[h]/2
		end
		
		Xpos[h]=Xpos[h] + Xvel[h] 
		Ypos[h]=Ypos[h] + Yvel[h] 
		
		if Xpos[h] > width then 
			Xpos[h] = width
			Xvel[h] = -10
		end
		if Ypos[h] > height then 
			Ypos[h] = height
			Yvel[h] = -10
		end
		if Xpos[h] <= 0 then 
			Xpos[h] = 0
			Xvel[h] = 10
		end
		if Ypos[h] <= 0 then 
			Ypos[h] = 0
			Yvel[h] = 10
		end
	end

end
