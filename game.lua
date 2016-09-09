
----------------------------------------------------------------------------------
--
-- game.lua
--
----------------------------------------------------------------------------------

-- include storyboard
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include widgets
local widget = require "widget"

local missileCount = 0
local missiles = {}
local missileGroup = display.newGroup( )

-- Load the sprite sheet
local sheetData =
{
    width = 400,   -- pixel width 
    height = 400,  -- pixel height 
    numFrames = 16  -- total number of frames 
}

-- sprite sheet
local sheet = graphics.newImageSheet( "fire.png", sheetData )

-- Create the sprite
local sequenceData =
{
    name = "fire",   -- Needed when there is more than one sequence in the sheet
    start = 1,         -- First frame in the sequence
    count = 16,        -- Number of frames in the sequence
    time = 3000,       -- Time in ms for the entire frame sequence (here 14 frames)
    loopCount = 0,     -- Optional, default is 0 (loop indefinitely)
}


-- create the laser
function createLaser()
	local laser = display.newLine(cannon.x, cannon.y, xTap, yTap )
	audio.play(laserSound)
	laser:setStrokeColor( 1, 0, 0 )
	laser.strokeWidth = 3
	cannon:toFront()
	
	return laser
end

--called to reset laser
function resetLaser()
	if laser then
		transition.cancel(laser)
		laser:removeSelf( )	--Remove bullet
		laser = nil
	end
end

-- handle replay button press
function onReplayButtonRelease()

	audio.play(clickSound)

	-- go to game
	storyboard.gotoScene( "game", "fade", 200 )
	
	return true	
end

--handle menu button press
function onMenuButtonRelease()

	audio.play(clickSound)

	-- go to menu scene
	storyboard.gotoScene( "menu", "fade", 200 )
	
	return true	
end

-- called to reset missile and set it to nil
function resetMissile(obj)
	transition.cancel(obj)
	obj:removeSelf( )

	--determine obj and set to nil
	if obj == missile1 then
		missile1 = nil
	elseif obj == missile2 then
		missile2 = nil
	elseif obj == missile3 then
		missile3 = nil
	end
end

--create missile
function createMissile()

	-- create actual missile object
	local missile = display.newImage( missileGroup, "missile.png", math.random(-500, width + 200), -50 )

	-- trig to find missile rotation
	local getAngle = math.deg(math.atan(math.abs(missile.y - city.y)/math.abs(missile.x - city.x)))

	-- set missile rotation acccording to spawn location
	if missile.x < city.x then
			missile.rotation = getAngle - 90 
		elseif missile.x > city.x then
			missile.rotation = 90 - getAngle 
	end

	return missile
end

-- function that increases the game difficulty
function gameDifficulty()

	-- as the player destroy more rockets add missile speed and more rockets accordingly
	if destroyCount < 1 then
		addMissile2 = false
		addMissile3 = false
		missileTime1 = 9000
	elseif destroyCount < 5 then
		missileTime1 = 4000
	elseif destroyCount < 10 then
		missileTime1 = 3000
	elseif destroyCount < 15 then
		missileTime2 = 3000
		addMissile2 = true
	elseif destroyCount > 20 then
		addMissile3 = true
	end
end

-- remove the explosion effect
function explosionDone()
	transition.cancel( explosion )
	explosion:removeSelf( )
end 

-- create the expolsion effect on missile location
function explode(x, y, obj)

	-- play explosion sound
	audio.play( explosionSound)

	-- reset the obj(missile)
	resetMissile(obj)

	-- create the explosion animation
	explosion = display.newImage("explosion.png", x, y)
	transition.to( explosion, {alpha = 0, xScale = 2, yScale = 2, time = 200, onComplete = explosionDone})
end

-- function to detect whether the missile has been destroyed by hitting the city or laser
function detectCollision(obj)
	if laser ~= nil and math.abs(xTap - obj.x) < 20 and math.abs(yTap - obj.y) < 20 then
		explode(obj.x , obj.y, obj)
		destroyCount = destroyCount + 1
		hitDisplay.text = destroyCount
	elseif math.abs(city.x - obj.x) < 20 and math.abs(city.y - obj.y) < 20 then
		explode(obj.x , obj.y, obj)
		hpCount = hpCount - 25
		cityHealthDisplay.text = hpCount.."%"
	end
end

-- handles the save score button press
function onHighScoreButtonRelease(event)
	
	-- get the number of missiles hit with the laser
	local getScore = destroyCount
	
	-- insert that into an appData table for scores
	if appData.scores ~= nil then
		table.insert(appData.scores, #appData.scores + 1, getScore)
	else
		table.insert(appData.scores, 1, getScore)
	end

	-- save the data
	saveScoreData()

	-- play click sound
	audio.play(clickSound)

	-- go to name input 
	storyboard.gotoScene( "name", "fade", 200  )
	
	return true	
end

function enterFrame(event)

		-- spawn missiles
		if missile1 == nil then

			missile1 = createMissile()

			-- check game difficulty
			gameDifficulty()
			transition.to( missile1, { time = missileTime1, x = city.x, y = city.y, onComplete = resetMissile}  )
		end

		-- if addMissile2 is true from gameDifficulty() then spawn it
		if missile2 == nil and addMissile2 == true then
			missile2 = createMissile()
			gameDifficulty()
			transition.to( missile2, { time = missileTime2, x = city.x, y = city.y, onComplete = resetMissile}  )
		end

		-- if addMissile3 is true from gameDifficulty() then spawn it
		if missile3 == nil and addMissile3 == true then
			missile3 = createMissile()
			gameDifficulty()
			transition.to( missile3, { time = 2000, x = city.x, y = city.y, onComplete = resetMissile}  )
		end

		
		-- listen for collisions
		if missile1 ~=nil then
			detectCollision(missile1)
		end
		if missile2 ~=nil then
			detectCollision(missile2)
		end
		if missile3 ~=nil then
			detectCollision(missile3)
		end

	-- determine if player loses
	if hpCount <= 0 then
		youLose = display.newImage( "youlose.png", width/2, height/2 - 150 )

		--place fire on city
		fire.x = city.x
		fire.y = city.y - 100

		-- set city on fire
		fire.isVisible = true
		fire:play( )

		-- reset all missiles
		if missile1 then
			resetMissile(missile1)
		end
		if missile2 then
			resetMissile(missile2)
		end
		if missile3 then
			resetMissile(missile3)
		end

		-- show the "game lost" menu
		replayButton.isVisible = true
		highScoreButton.isVisible = true
		menuButton.isVisible = true

		-- remove listeners
		Runtime:removeEventListener( "enterFrame", enterFrame )
		Runtime:removeEventListener( "touch", touch )
	end
end

-- touch function
function touch(event)
	if event.phase == "began" then

		-- remove instruction when touched
		if instructions then
			instructions:removeSelf( )
			instructions = nil
		end

		-- remove the prompt when touched
		if saveCityText then
			saveCityText:removeSelf( )
			saveCityText = nil
		end

		-- show laser animation
		if laser == nil then

			--laser goes to touch
			xTap = event.x
			yTap = event.y
			
			-- get the angle for the cannon
			local getAngle = math.deg(math.atan(math.abs(cannon.y - yTap)/math.abs(cannon.x - xTap)))

			-- set cannon angle according to tap
			if xTap < cannon.x then
				cannon.rotation = getAngle - 90 
			elseif xTap > cannon.x then
				cannon.rotation = 90 - getAngle 
			end

			-- create the laser
			laser = createLaser() --Bullet is created

			-- laser animation
			transition.moveTo( laser, { time = 500, onComplete = resetLaser} ) 

		end
	end
end

-- create scene
function scene:createScene( event )
	local sceneGroup = self.view

	-- show instruction on start
	instructions = display.newText(sceneGroup, "Tap to shoot laser", width/2, height/2, native.systemFont, 30 )
	instructions:setFillColor( 0 )

	--set the background image
	sky = display.newImage( sceneGroup, "sky.png", width/2, height/2)
	sky:toBack( )

	-- create the cannon model
	cannon = display.newRect(sceneGroup, width/4, height - 50, 10, 50)
	cannon:setFillColor( black )
	cannon:toFront()

	-- create cannon base
	local cannonBase = display.newCircle(sceneGroup, cannon.x, cannon.y + 15, 15 )
		cannonBase:setFillColor( black )
		cannonBase:toFront( )
	
	-- create the ground
	local ground = display.newRect(sceneGroup, 0, 630, width*2, 20 )
		ground:setFillColor( 1, 0.8, 0.2 )

	-- create the city
	city = display.newImage( sceneGroup, "city.png", 800, 570 )

	-- Scoring display
	cityHealthDisplay = display.newText( sceneGroup, "100%", 3*width/4, height/20, native.systemFont, 30 )		  	
		cityHealthDisplay:setFillColor( black )
	hitDisplay = display.newText( sceneGroup, "0", width/4 + 50, height/20, native.systemFont, 30  )		      	 
		hitDisplay:setFillColor( black )
end

-- will enter scene
function scene:willEnterScene( event )
	local sceneGroup = self.view

	-- save city prompt
	saveCityText = display.newText(sceneGroup, "Protect the city!", width/2, height/2 - 50, native.systemFont, 30 )
	saveCityText:setFillColor( 1,0,0 )

	-- image for destroyed missiles count
	missileDestroyed = display.newImage( sceneGroup, "missiledestroyed.png", width/4 - 20, height/20 )

	-- image for city health
	miniCity = display.newImage( sceneGroup, "citymini.png", 3*width/4 - 80, height/20 )

	-- create the fire sprite but hide it
	fire = display.newSprite( sheet, sequenceData )
	fire.isVisible = false

	-- create replay button and hide it
	replayButton = widget.newButton{
				defaultFile="playagain.png",
				over="playagain.png",
				onRelease = onReplayButtonRelease}	
		replayButton.x = display.contentWidth*0.5
		replayButton.y = display.contentHeight - 300
		replayButton.isVisible = false
		sceneGroup:insert( replayButton )

	-- create high scores button and hide it
	highScoreButton = widget.newButton{
				defaultFile="savescore.png",
				over="savescore.png",
				onRelease = onHighScoreButtonRelease}	
		highScoreButton.x = width/2
		highScoreButton.y = display.contentHeight - 200
		highScoreButton.isVisible = false
		sceneGroup:insert( highScoreButton )

	-- create the menu button and hide it
	menuButton = widget.newButton{
				defaultFile="menubutton.png",
				over="menubutton.png",
				onRelease = onMenuButtonRelease}	
		menuButton.x = width/2
		menuButton.y = height - 100
		menuButton.isVisible = false
		sceneGroup:insert( menuButton )

	
end

-- enter scene
function scene:enterScene( event )
	local sceneGroup = self.view

	-- load sounds
	explosionSound = audio.loadStream("explosion.wav")

	laserSound = audio.loadStream("lasersound.wav")

	clickSound = audio.loadStream( "click.wav")

	-- start runtime listeners
	Runtime:addEventListener( "touch", touch )
	Runtime:addEventListener( "enterFrame", enterFrame )

	-- set the score display
	destroyCount = 0
	hpCount = 100
end

function scene:exitScene( event )
	local sceneGroup = self.view
	
	-- unload audio
	audio.dispose( explosionSound )
	audio.dispose( laserSound )
	audio.dispose( clickSound )

end

-- did exit scene
function scene:didExitScene( event )
	local sceneGroup = self.view

	-- remove any left over objects
	if fire then
		fire:removeSelf( )
	end

	if youLose then
		youLose:removeSelf( )
		youLose = nil
	end

	if replayButton then
		replayButton:removeSelf( )
	end
	
	if replayButton then
		replayButton:removeSelf( )
	end

	if highScoreButton then
		highScoreButton:removeSelf( )
	end

	if menuButton then
		menuButton:removeSelf( )
	end

	if self.missile1 then
		self.missile1:removeSelf( )
	end

	if self.missile2 then
		self.missile2:removeSelf( )
	end

	if self.missile3 then
		self.missile3:removeSelf( )
	end

	if saveCityText then
		saveCityText:removeSelf( )
	end

	if missileDestroyed then
		missileDestroyed:removeSelf( )
	end

	if miniCity then
		miniCity:removeSelf( )
	end

	cityHealthDisplay.text = "100%"
	hitDisplay.text = "0"
end



-- Add the storyboard event listeners to the scene
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )


-- Retun the scene to the calling module
return scene