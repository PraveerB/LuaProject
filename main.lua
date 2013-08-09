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

navigator = {}
pageId = "" ;
--navSequence =0;
--
local function onSceneTouch( event )
        pageId = pageId..event.target.id
        homeImage.isVisible = true
        print("views.scene"..pageId)
        if event.phase == "began" then
            --navSequence =navSequence +1
            navigator[event.target.linkName] = "views.scene"..pageId
            storyboard.gotoScene( "views.scene"..pageId, "crossFade", 800  )
            return true
        end
        return true
end

function loadResources(screenGroup,a,isLastLevel)
	local vary
	local i=0
         --print("navigator ::"..navigator)
        
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
            
            for i=1,#a  do
            	print (#a)
                vary = display.newImage("assets/"..a[i].src, 250*(i-1), 0, native.systemFontBold, 24 )
                vary:setStrokeColor(254,254,254)
                vary.strokeWidth= 15
                vary.id = i
                vary.linkName = a[i].linkName
		-- set link name print(key).
                screenGroup:insert(vary)
                --vary.touch = onSceneTouch
                vary:addEventListener( "touch", onSceneTouch)
                scrollView:insert(vary)
            end
	else
            --to do
	end
        createNavigator()
	return vary
end

-- Creates the navigation bar
function createNavigator()
    if navigator ~= nil then
    local nav = display.newText(""..navigator['Skin Care'],0,0,"Helvetica",24)
        for key,value in pairs(navigator) do
            print(key .."  =  ".. value)
            -- Create the navigation Bar with the key and value
            --display.newGroup()
            
        end
    end
end

--on touch of home page image
local function onHomeTouch( event )
	if event.phase == "began" then
            homeImage.isVisible = false
            storyboard.gotoScene( "views.homeScreen", "slideRight", 500  )
            return true
	end
end
--

-- Create a home page image
homeImage  = display.newImage( "assets/Icon-ldpi.png",0,0 )
homeImage.isVisible = false
--homeImage.touch = onHomeTouch
--
homeImage:addEventListener( "touch", onHomeTouch)

-- load first scene
storyboard.gotoScene( "views.homeScreen", "fade", 400 )