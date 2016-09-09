----------------------------------------------------------------------------------
--
-- scene.lua
--
-- Template file for a scene in a storyboard app.
----------------------------------------------------------------------------------

-- Load the storyboard module if necessary, and create a new scene object
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

function textListener( event )

    if event.phase == ("editing" or event.phase == "submitted") and string.len(event.text) < 20 then

        -- text field loses focus
        getName = event.text   

    end
end

function onDoneRelease()

	print( getName )
	if getName == nil then
		getName = "Player"
	else
		table.insert(appData.names, #appData.names + 1, getName)
	end

	saveScoreData()

	-- go to game.lua scene
	storyboard.gotoScene( "highscores", { params = custom} )

	return true

end

-- Called when the scene's view does not exist.
-- Create display objects and widgets and add them to the sceneGroup.
function scene:createScene( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, width/2, height/2, width, height)
	bg:setFillColor( 0.9 )

	local enterNameText = display.newText( sceneGroup, "Enter Player Name", width/2, height/10, native.systemFontBold, 50 )
	enterNameText:setFillColor( 0 )
	
end

-- Called just before a scene starts to go onscreen.
-- Setup the scene contents for the correct appearance.
-- Create temporary widgets, init other widgets, etc.
function scene:willEnterScene( event )
	local sceneGroup = self.view

	-- Create text field
	self.textField = native.newTextField( width/2, height/4, 500, 100 )
	sceneGroup:insert( self.textField )

	-- Create the Add (+) button
	self.doneBtn = widget.newButton{
	    left = 6*width/7, top = 10, width = 50, height = 70,
	    label = "Done",
	    font = native.systemFontBold,
	    fontSize = 40,
	    onRelease = onDoneRelease
	}
	sceneGroup:insert(self.doneBtn)
end

-- Called immediately after scene has moved onscreen.
-- Add event listeners, start timers, load audio, etc.
function scene:enterScene( event )
	local sceneGroup = self.view

	self.textField:addEventListener( "userInput", textListener )

end

-- Called when scene is about to move offscreen.
-- Remove event listeners, stop timers, unload sounds, etc.
function scene:exitScene( event )
	local sceneGroup = self.view

	Runtime:removeEventListener( "userInput", textListener )
	
end

-- Called when scene is finished moving offscreen.
-- Remove temporary widgets, etc.
function scene:didExitScene( event )
	local sceneGroup = self.view

	if self.textField then
		self.textField:removeSelf( )
	end

	if self.doneBtn then
		self.doneBtn:removeSelf( )
	end

end

-- Called prior to the removal of scene's "view" (display group).
-- Remove remaining widgets, save state, etc.
function scene:destroyScene( event )
	local sceneGroup = self.view



end


-- Add the storyboard event listeners to the scene
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )

-- Retun the scene to the calling module
return scene