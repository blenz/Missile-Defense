-----------------------------------------------------------------------------------------
--[[ 							HEADER


	• The point of this game is to protect the city from the incoming missiles. To shoot missiles, 
	simply tap the missiles and the laser will dstroy them. As the the player destroys more missiles 
	the game gets harder by increasing the missiles speed and adding more missiles. The player loses 
	onces 4 missiles hit the city. The goal is to shoot as many rockets as possible until the city 
	gets destroyed. The player can then save their score so either the user or someone else can try 
	and beat it.

	• The app is fairly simple in how its used. In the actual game, the missiles are created above
	the screen using transition animation to hit the city. If the user's touch comes
	within a certain range of the missiles coordinates then the missile is destroyed and reset above 
	the screen. The laser animation gives the effect that the laser is shooting down the missiles.
	Each time the user destroys a missile the game keeps count and also keeps count of the city's 
	health. Each hit takes 25% of the city's health. The game checks to see how many missiles have
	been destroyed and increases missile speed and adds missiles accordingly. Once the player loses, they are 
	prompted to either "Play Again",  "Save Score", "Menu(go back to the menu)". If the player chooses
	to save their score, the player is then prompted to input their name. Once completed, 
	the game puts their score and name into appData so it can be saved or loaded each time 
	the game is started or terminated. The scores are then put into a tableview so the player can see
	their score as well as others.

	• Coding Items

		- (5) Transition animations( transition.moveTo, transition.to)
		- (5) manual frame animation
		- (5) Sprite sheet(fire)
		- (5) Changing text display (score display)
		- (5) Touch events
		- (5) Sound effects (laser sounds, explosions, button clicks)
		- (5) Background music ( menu music)
		- (10) Storyboard (menu, game, name, highscores)
		- (5) Buttons
		- (5) Native text field (get names)
		- (10) TableView (high scores)
		- (5) User data load/save
		----------------------------------------------
		  70pts if everything is done correctly


	*** I used iPhone 5 as the Corona view ***

]]--
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "storyboard" module
local storyboard = require "storyboard"

--include json
local json = require( "json" )

--Assign width/height(global)
width = display.contentWidth
height = display.contentHeight

--Appdata that holds the name and score of player(global)
appData = 
{
	names = {},
	scores = {},	  
}

-- Return path name
local function dataFilePath()
	return system.pathForFile( "scores.txt", system.DocumentsDirectory )
end

-- Save appdata to file
function saveScoreData()
	local file = io.open( dataFilePath(), "w" )
	if file then
		file:write( json.encode( appData) )
		io.close(file)
		print("Appdata list saved")
	end
end

-- Load appdata from file
function loadScoreData()
	local file = io.open( dataFilePath(), "r" )
	if file then
		local str = file:read( "*a" )	
		if str then
			local scoreTable = json.decode(str)
			if scoreTable then
				appData = scoreTable
				print("Appdata list loaded")
			end
		end
		io.close(file)
	end
end

-- Handle system events for the app
local function onSystemEvent( event )
	if event.type == "applicationSuspend" or event.type == "applicationExit" then
		saveScoreData()
	elseif event.type == "applicationStart" or event.type == "applicationOpen" then
		loadScoreData()
	end
end

-- Init the app
local function initApp()

-- Add system event listener to the app (stays installed in all scenes)
Runtime:addEventListener( "system", onSystemEvent )

	-- Start with menu
	storyboard.gotoScene( "menu", "fade", 200   )
end

--Start app
initApp()