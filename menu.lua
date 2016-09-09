-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

--include storyboard
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"


-- listener for play button
local function onPlayBtnRelease()

	--play sound for button
	audio.play(clickSound)
	
	--go to game
	storyboard.gotoScene( "game", "fade", 200 )
	
	return true
end

-- listener for high score button
local function onhighScoresButtonRelease()

	--play sound for button
	audio.play(clickSound)
	
	-- go to highscores
	storyboard.gotoScene( "highscores", "fade", 200 )
	
	return true	
end

--function to create missile
local function createMissile()
	local missile = display.newImage("missile.png", -50, math.random( 50, 590 ) )
	missile:rotate( 270 )

	return missile
end

--function to reset missile
local function missileReset()
	transition.cancel(missile)
	missile:removeSelf( )	--Remove target
	missile = nil
end

--funtion to move missile
local function moveTarget(event)
	if missile == nil then
		missile = createMissile()
		transition.to( missile, {time = 5000, x = 1500, y = missile.y, onComplete = missileReset } )
	end
end


-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	

	-- display a background image
	local background = display.newImageRect( group, "sky.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImage( "logo.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 150
	
	-- create "play now" button
	playBtn = widget.newButton{
		defaultFile="playnow.png",
		over="playnow.png",
		onRelease = onPlayBtnRelease	
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 250

	-- create "high scores" button
	highScoresButton = widget.newButton{
		defaultFile="highscoresbutton.png",
		over="highscoresbutton.png",
		onRelease = onhighScoresButtonRelease	
	}
	highScoresButton.x = display.contentWidth*0.5
	highScoresButton.y = display.contentHeight - 100
	
	-- all display objects must be inserted into group
	group:insert( titleLogo )
	group:insert( playBtn )
	group:insert( highScoresButton )
end


function scene:enterScene( event )
	local group = self.view

	--load audio
	clickSound = audio.loadStream( "click.wav")
	background = audio.loadStream( "background.wav")

	--loop background music
	audio.play( background, {loops = -1, fadein = 2000} )

	Runtime:addEventListener( "enterFrame", moveTarget )
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view

	--fade out background music
	audio.fade({ background, time = 1000  })
	
end

function scene:didExitScene( event )
	local sceneGroup = self.view

	--remove missile and its move listener
	if missile then
		transition.cancel(missile)
		Runtime:removeEventListener( "enterFrame", moveTarget )
		missile:removeSelf()	
		missile = nil
	end

end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	--remove play button
	if playBtn then
		playBtn:removeSelf()	
		playBtn = nil
	end

	--remove high scores button
	if highScoresButton then
		highScoresButton:removeSelf()	
		highScoresButton = nil
	end


end

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

scene:addEventListener( "didExitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene