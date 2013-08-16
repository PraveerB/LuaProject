-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )

-- set background image for all scenes
local image = display.newImage( "assets/bg.jpg", 320*480)
--

--require widget and storyboard libraries
local storyboard = require "storyboard"
local widget = require "widget"

-- initialize global empty table
local slideViewGroup
local navigator = {{linkName = "tabBar" , linkSrc = "0" , linkId = "0", linkObj=""}}
pageId = "" 
local screenGroupHolder = {};
local group
local varyTextTable = {}
local scrollView = {}

local function onNavTouch (event)
    pageId = string.sub(pageId ,1 , event.target.id-1 )
    storyboard.gotoScene( navigator[event.target.id].linkSrc, "crossFade", 400  )
    if event.target.id < #navigator then
        local tableElementsToRemove = {}
        for i=event.target.id+1,#navigator do
            if slideViewGroup ~= nil then
                slideViewGroup:removeSelf()
            end
            table.insert(tableElementsToRemove , i)
            navigator[i] = { linkName = "", linkSrc = "", linkId = "" }
        end
        local i=1
        while(i < 5) do
            if(navigator[i] ~= nil and  navigator[i].linkName  == "") then
                table.remove(navigator, i)
            end
            i= i +1
        end
        group.isVisible = false
        createNavigator()
        return true
        end
	return true
end

local function onSceneTouch( event )
	group.isVisible = true
	i = #navigator
	i=i+1
        local startPos = 0
        local endPos
    pageId = pageId..event.target.id
    homeImage.isVisible = true
    if event.name == "tap" then
        print ("views.scene"..pageId)
        --[[if event.phase == "began" then
           startPos = scrollView.x
           print(startPos)
        end
        if event.phase == "moved" then
            display.currentStage:setFocus(scrollView)
            
            endPos = scrollView.x
            print(endPos)
         end
        if event.phase == "ended" then
            endPos = scrollView.x
            local drag = math.floor(endPos - startPos)
            if (drag > -20 and drag < 20) then]]
                table.insert(navigator, { linkName = event.target.linkName, linkSrc = "views.scene"..pageId, linkId = i } )
                storyboard.gotoScene( "views.scene"..pageId, "flip", 50  )
                print ("views.scene"..pageId)
                --return true
            --end
        --end
        end
    return true
end

function loadResources(screenGroup,a,isLastLevel)
	local vary, varyText 
	local i=0
    screenGroupHolder = screenGroup
	if isLastLevel==false then
	    scrollView = widget.newScrollView {
	    top = 200,
	    left = 0,
	    width = 1024,
	    height = 250,
	    scrollWidth = 1005,
	    scrollHeight = 0,
	    verticalScrollDisabled=true,
	    hideScrollBar = false
	    --listener = onSceneTouch
	    }
            
        for i=1,#a do
            vary = display.newImage("assets/"..a[i].src, 250*(i-1),0,true)
            vary:setStrokeColor(254,254,254)
            vary.strokeWidth= 15
            vary.id = i
            vary.linkName = a[i].linkName
            screenGroup:insert(vary)
            varyText = display.newText(vary.linkName,250*(i-1)+30,220, native.systemFontBold, 20 )
            varyText:setTextColor(0,0,0)
            varyTextTable[i] = varyText
            vary:addEventListener( "tap", onSceneTouch)
            scrollView:insert(i ,vary)
            scrollView:insert(varyText)
            screenGroup:insert(scrollView)
            --scrollView.id = i
        end
        
    else 
       local slideView = require("slideView")
       slideViewGroup = slideView.new(a)
	end
	
    createNavigator()
    return vary
end

function createNavigator()
	group = display.newGroup()
	group.isVisible = true
	local nav= {}
	local e = 0
	if #navigator > 1 then
        for i=2,#navigator do  
            if( navigator[i].linkName ~= "") then
                nav = display.newText(navigator[i].linkName.." > ",55+e,0,"Helvetica",35)
                navigator[i].linkObj = nav
                e = e + nav.width
                nav.wid = e
                nav.id = i
                if nav ~= nil then
                    group:insert(nav)
                end
                screenGroupHolder:insert(group)
                navigator[i].linkObj:addEventListener( "touch", onNavTouch)
            end
        end
    end
end

--on touch of home page image
local function onHomeTouch( event )
	if event.phase == "began" then
	    if slideViewGroup ~= nil then
	        slideViewGroup:removeSelf()
	    end
	    group = nil
	    group = display.newGroup()
	    pageId = ""
	    homeImage.isVisible = false
	    storyboard.gotoScene( "views.homeScreen", "crossFade", 500  )
	    group.isVisible = false
	    navigator = nil
	    navigator = {{linkName = "tabBar" , linkSrc = "" , linkId = "", linkObj=""} }
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