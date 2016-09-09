----------------------------------------------------------------------------------
--
-- highscores.lua
--
----------------------------------------------------------------------------------

-- Load the storyboard module 
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- load widgets
local widget = require( "widget" )

-- Render a row in the table widget
local function onRowRender( event )

	-- Get reference to the row group
    local row = event.row

    -- get the row height, width, and index
    local rowHeight = row.contentHeight 
    local rowWidth = row.contentWidth
    local index = row.index

    -- set the name of the player in the row
    local rowName = display.newText( row, appData.names[index], rowWidth/4 + 60, rowHeight/2, native.systemFont, 40 )
    rowName:setFillColor( 0 )

    -- set the score of the player on the row
    local rowScore = display.newText( row, appData.scores[index], 3*rowWidth/4 - 60, rowHeight/2, native.systemFont, 40 )
    rowScore:setFillColor( 0 )
end


-- clear the tableview
function scene:clearList()
	appData.scores = {}
	appData.names = {}
	index = nil
	self.tableView:deleteAllRows()
	self.tableView:reloadData()
end

-- Handler that gets notified when the Clear alert closes
local function onClearAlertComplete( event )
   if event.index == 2 then  -- Clear pressed
        	scene:clearList()
    end
end

-- Handle a push on the Clear button
local function clearBtnPush(event)
	-- Show alert to confirm the clear
	native.showAlert( "High Scores", "Clear all scores?", { "Cancel", "Clear" }, onClearAlertComplete )
end


-- menu button press
function onMenuButtonRelease()

	-- go to menu.lua scene
	storyboard.gotoScene( "menu", "fade", 200 )
	
	return true
end



--create scene
function scene:createScene( event )
	local sceneGroup = self.view

	-- Make a light gray background
	local bg = display.newRect( sceneGroup, width/2, height/2, width, height)
	bg:setFillColor( 0.9 )

	-- create "Name" text
	local nameText = display.newText( sceneGroup, "Name", width/3, 150, native.systemFontBold, 50 )
	nameText:setFillColor( 0 )

	-- create "Score" text
	local scoreText = display.newText( sceneGroup, "Score", 2*width/3, 150, native.systemFontBold, 50 )
	scoreText:setFillColor( 0 )


	-- create the "High Scores" title of the tableview
	display.newImage( sceneGroup, "highscoresbutton.png", width/2, 50, native.systemFontBold, 50 )
end



-- will enter scene
function scene:willEnterScene( event )
	local sceneGroup = self.view

	-- create the clear button
	self.clearBtn = widget.newButton{
	    left = width - 150, top = 10, width = 70, height = 70,
	    label = "Clear",
	    font = native.systemFontBold,
	    fontSize = 40,
	    onRelease = clearBtnPush
	}
	sceneGroup:insert(self.clearBtn)

	-- create the menu button
	self.menuBtn = widget.newButton{
	    left = 50, top = 10, width = 50, height = 70,
	    label = "Menu",
	    font = native.systemFontBold,
	    fontSize = 40,
	    onRelease = onMenuButtonRelease
	}
	sceneGroup:insert(self.menuBtn)

	-- create the table widget
	self.tableView = widget.newTableView
	{
	    left = 50,
	    top = 200,
	    height = 440,
	    width = 1036,
	    onRowRender = onRowRender,
	}
	sceneGroup:insert(self.tableView)

	-- get the size of the scores table
		local scoreTableSize = #appData.scores

		-- create the right amount of rows
		while #appData.scores > self.tableView:getNumRows( ) do
			self.tableView:insertRow( {
							            isCategory = false,
							            rowHeight = 100,
							            lineColor = {1,1,1} } )
		end
	

	-- Init the table view or reload for any changes made in details view
	self.tableView:reloadData()
end

-- destroy scene
function scene:destroyScene( event )
	local sceneGroup = self.view

	-- Remove the widgets
	if self.clearBtn then
		self.clearBtn:removeSelf()
		self.clearBtn = nil
	end	
	if self.menuBtn then
		self.menuBtn:removeSelf()
		self.menuBtn = nil
	end	
	if self.tableView then
		self.tableView:removeSelf()
		self.tableView = nil
	end	
end


-- Add the storyboard event listeners to the scene
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "destroyScene", scene )

-- Retun the scene to the calling module
return scene