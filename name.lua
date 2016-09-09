----------------------------------------------------------------------------------
--
-- name.lua
--
----------------------------------------------------------------------------------

-- Load the storyboard 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- listen for the text
function textListener( event )
    if event.phase == ("editing" or event.phase == "submitted") and string.len(event.text) < 20 then

        -- get the text
        getName = event.text   
    end
end

-- listen for done button press
function onDoneRelease()

	-- if get name is nil set it to default(Player)
	if getName == nil then
		getName = "Player"
	end

	-- insert name into appData
	if appData.names ~= nil then
		table.insert(appData.names, #appData.names + 1, getName)
	else
		table.insert(appData.names, 1, getName)
	end

	-- save appData
	saveScoreData()

	-- go to highscores.lua 
	storyboard.gotoScene( "highscores", "fade", 200 )

	return true

end

-- create scene
function scene:createScene( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, width/2, height/2, width, height)
	bg:setFillColor( 0.9 )

	-- create "Enter Player Name" prompt
	local enterNameText = display.newText( sceneGroup, "Enter Player Name", width/2, height/10, native.systemFontBold, 50 )
	enterNameText:setFillColor( 0 )
	
end

-- will enter scene
function scene:willEnterScene( event )
	local sceneGroup = self.view

	-- Create text field
	self.textField = native.newTextField( width/2, height/4, 500, 100 )
	sceneGroup:insert( self.textField )

	-- Create the done button
	self.doneBtn = widget.newButton{
	    left = 6*width/7, top = 10, width = 50, height = 70,
	    label = "Done",
	    font = native.systemFontBold,
	    fontSize = 40,
	    onRelease = onDoneRelease
	}
	sceneGroup:insert(self.doneBtn)

	-- set focus to the textfield
	native.setKeyboardFocus( self.textField )
end

-- enter scnene
function scene:enterScene( event )
	local sceneGroup = self.view

	-- add textListener
	self.textField:addEventListener( "userInput", textListener )

end

-- exit scene
function scene:exitScene( event )
	local sceneGroup = self.view

	-- remove text listener
	Runtime:removeEventListener( "userInput", textListener )
	
end

-- exit scene
function scene:didExitScene( event )
	local sceneGroup = self.view

	-- remove widgets
	if self.textField then
		self.textField:removeSelf( )
	end

	if self.doneBtn then
		self.doneBtn:removeSelf( )
	end

end



-- Add the storyboard event listeners to the scene
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )

-- Retun the scene to the calling module
return scene