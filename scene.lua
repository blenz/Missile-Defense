----------------------------------------------------------------------------------
--
-- scene.lua
--
-- Template file for a scene in a storyboard app.
----------------------------------------------------------------------------------

-- Load the storyboard module if necessary, and create a new scene object
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()


-- Called when the scene's view does not exist.
-- Create display objects and widgets and add them to the sceneGroup.
function scene:createScene( event )
	local sceneGroup = self.view

end

-- Called just before a scene starts to go onscreen.
-- Setup the scene contents for the correct appearance.
-- Create temporary widgets, init other widgets, etc.
function scene:willEnterScene( event )
	local sceneGroup = self.view

end

-- Called immediately after scene has moved onscreen.
-- Add event listeners, start timers, load audio, etc.
function scene:enterScene( event )
	local sceneGroup = self.view

end

-- Called when scene is about to move offscreen.
-- Remove event listeners, stop timers, unload sounds, etc.
function scene:exitScene( event )
	local sceneGroup = self.view
	
end

-- Called when scene is finished moving offscreen.
-- Remove temporary widgets, etc.
function scene:didExitScene( event )
	local sceneGroup = self.view
	
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