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

-- initialize global empty table

local navigator = {name="gaurav" }
pageId = "" ;
--
local function onSceneTouch( event )
        pageId = pageId..event.target.id
        print("views.scene"..pageId)
        if event.phase == "began" then
            --print (event.target.id)
            --Upadate global table ..
                    --Key : get the link name eg. Skin, Bath.
                    --Value: "views."..self.id
            storyboard.gotoScene( "views.scene"..pageId, "crossFade", 800  )
            return true
        end
        return true
end

function loadResources(screenGroup,a,isLastLevel)
	local vary
	local i=0
        
	if isLastLevel==false then
                local scrollView = widget.newScrollView {
                top = 200,
                left = 0,
                width = 1024,
                height = 250,
                scrollWidth = 1005,
                scrollHeight = 0,
                verticalScrollDisabled=true,
                hideScrollBar = false
                
            }
            
            for key,value in pairs(a) do
                i = i+1
                --pageId = pageId..i
                --print ("pageId :: "..pageId)
                vary = display.newImage("assets/"..value, 250*(i-1), 0, native.systemFontBold, 24 )
                vary:setStrokeColor(254,254,254)
                vary.strokeWidth= 15
                vary.id = i	
		-- set link name print(key).
                screenGroup:insert(vary)
                --vary.touch = onSceneTouch
                vary:addEventListener( "touch", onSceneTouch)
                scrollView:insert(vary)
            end
	else
            --to do
	end
	return vary
end
--on touch of home page image
local function onHomeTouch( event )
	if event.phase == "began" then
		storyboard.gotoScene( "views.scene1", "slideRight", 500  )
		return true
	end
end
--

-- Create a home page image
homeImage  = display.newImage( "assets/Icon-ldpi.png",0,0 )
--homeImage.touch = onHomeTouch
--
homeImage:addEventListener( "touch", onHomeTouch)

-- load first scene
storyboard.gotoScene( "views.homeScreen", "fade", 400 )