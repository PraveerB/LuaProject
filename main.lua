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

navigator = {
		{linkName = "tabBar" , linkSrc = "" , linkId = "", linkObj=""}
}
pageId = "" 
local screenGroupHolder = {};
--navSequence =0;
 local group = display.newGroup()
--local nav,i 
local function onNavTouch ( event )
	storyboard.gotoScene( navigator[event.target.id].linkSrc, "crossFade", 400  )
	if event.target.id < #navigator+1 then
        print("ID  "..event.target.id .."  Size "..#navigator )
	for i=event.target.id,#navigator do
		print(navigator[i+1].linkObj.text)
		table.remove(navigator,i+1)
		end
		
	end
return true
end

local function onSceneTouch( event )
	i = #navigator
	i=i+1
        pageId = pageId..event.target.id
        homeImage.isVisible = true
        --print("views.scene"..pageId)
        if event.phase == "began" then
            --navSequence =navSequence +1
            table.insert(navigator, { linkName = event.target.linkName, linkSrc = "views.scene"..pageId, linkId = i } )
            storyboard.gotoScene( "views.scene"..pageId, "crossFade", 400  )
            return true
        end
        return true
end

function loadResources(screenGroup,a,isLastLevel)
	local vary
	local i=0
         --print("navigator ::"..navigator)
        screenGroupHolder = screenGroup
	if isLastLevel==false then
--                local scrollView = widget.newScrollView {
--                top = 200,
--                left = 0,
--                width = 1024,
--                height = 250,
--                scrollWidth = 1005,
--                scrollHeight = 0,
--                verticalScrollDisabled=true,
--                hideScrollBar = false
--                
--            }
            
            for i=1,#a do
                vary = display.newImage("assets/"..a[i].src, 250*(i-1), 200, native.systemFontBold, 24 )
                vary:setStrokeColor(254,254,254)
                vary.strokeWidth= 15
                vary.id = i
                vary.linkName = a[i].linkName
		-- set link name print(key).
                screenGroup:insert(vary)
                --vary.touch = onSceneTouch
                vary:addEventListener( "touch", onSceneTouch)
                --scrollView:insert(vary)
            end
	else 
           local slideView = require("slideView")
           print("else part")
           slideView.new(a)
	end
        createNavigator()
       
	return vary
end

-- Creates the navigation bar
function createNavigator()
    group.isVisible = true
    local nav= {}
    local e = 0
    if #navigator > 1 then
        print(" ::: "..#navigator)
        for i=2,#navigator do  
            nav = display.newText(navigator[i].linkName.." > ",55+e,0,"Helvetica",40)
            print("Before ::::::")
            
            --print(display.newText(navigator[i].linkName.." > ",55+e,0,"Helvetica",40))
            navigator[i].linkObj = nav
            e = e + nav.width
            nav.wid = e
            nav.id = i
            group:insert(nav)
            screenGroupHolder:insert(group)
            navigator[i].linkObj:addEventListener( "touch", onNavTouch)
            --print(key .."  =  ".. value)
            -- Create the navigation Bar with the key and value
            print("Name "..navigator[i].linkName)
            print(navigator[i].linkObj.text)
        end
        --print("hohohoho"..#navigator)
    end
end

--on touch of home page image
local function onHomeTouch( event )
print(event.phase)
	if event.phase == "began" then
            pageId = ""
            homeImage.isVisible = false
            storyboard.gotoScene( "views.homeScreen", "slideRight", 500  )
            group.isVisible = false
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