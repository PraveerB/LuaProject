--
-- Abstract: Storyboard Sample
--
-- Version: 1.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2011 Corona Labs Inc. All Rights Reserved.
--
-- Demonstrates use of the Storyboard API (scene events, transitioning, etc.)
--

-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )
--native.setActivityIndicator( false )

-- set background image for all scenes
local image = display.newImage( "assets/bg.jpg", 320*480)
--

--require widget and storyboard libraries
local storyboard = require "storyboard"
local widget = require "widget"
--local views = require "views."
local scrollView
--
local function onSceneTouch( self,event )
        print("Phase :: "..event.phase)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(self)
            self.isFocus = true
            return true
        elseif event.phase == "moved" then
            display.getCurrentStage():setFocus(self)
            self.isFocus = true
            return true
        elseif event.phase == "ended" then
            print(self.id)
            storyboard.gotoScene( "views."..self.id, "crossFade", 800  )
            display.getCurrentStage():setFocus(event.target)
            return true
        end
end

function loadResources(screenGroup,a,isLastLevel)
	local vary
	local i=0
	if isLastLevel==false then
                scrollView = widget.newScrollView {
                top = 200,
                left = 0,
                width = 2000,
                height = 250,
                scrollWidth = 1005,
                scrollHeight = 0,
                verticalScrollDisabled=true,
                hideScrollBar = false,
                listener = scrollListener
            }
            
            for key,value in pairs(a) do
                i = i+1
                vary = display.newImage("assets/"..value, 250*(i-1), 0, native.systemFontBold, 24 )
                vary:setStrokeColor(0,0,0)
                vary.strokeWidth= 15
                vary.id = "scene"..(i+1)
                screenGroup:insert(vary)
                vary.touch = onSceneTouch
                vary:addEventListener( "touch", vary)
                scrollView:insert(vary)
            end
	else
            --to do
	end
	return vary
end
--on touch of home page image
local function onHomeTouch( self, event )
	if event.phase == "began" then
		storyboard.gotoScene( "views.scene1", "slideRight", 500  )
		return true
	end
end
--

-- Create a home page image
homeImage  = display.newImage( "assets/Icon-ldpi.png",0,0 )
homeImage.touch = onHomeTouch
--
homeImage:addEventListener( "touch", homeImage )

-- load first scene
storyboard.gotoScene( "views.scene1", "fade", 400 )