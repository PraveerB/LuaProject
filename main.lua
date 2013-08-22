-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )


-- set background image for all scenes
local image = display.newImage( "assets/bgLand.jpg", display.contentHeight*display.contentWidth)
--

--require widget and storyboard libraries
local storyboard = require "storyboard"
local widget = require "widget"
local native = require "native"

-- initialize global empty table
local slideViewGroup
local navigator = {{linkName = "tabBar" , linkSrc = "0" , linkId = "0", linkObj=""}}
pageId = "" 
local screenGroupHolder = {};
local group
local varyTextTable = {}
local scrollView = {}

portraitMode = true
local screenGroup,a,isLastLevel

local function onComplete( event )
    if "clicked" == event.action then
        storyboard.gotoScene( "views.homeScreen", "flip", 70 )
    end
end


local function myUnhandledErrorListener( event )
    local iHandledTheError = true
    if iHandledTheError then
        print( "Handling the unhandled error", event.errorMessage )
        native.showAlert("error report","This page doesn't exist","Reload?",onComplete)
        storyboard.gotoScene( "views.homeScreen", "flip", 70 )
        homeImage.isVisible = false
    else
        print( "Not handling the unhandled error", event.errorMessage )
    end
    
    return iHandledTheError
end

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
    pageId = pageId..event.target.id
    if event.name == "tap" then
        print ("views.scene"..pageId)
        if pageId == "2" then
            pageId = ""
            media.playVideo("Corona-iPhone.m4v",true)
        elseif pageId == "3" then
            pageId = ""
            system.openURL( "tel:+918884366552" )
        elseif pageId == "4" then
            pageId = ""
            local options =
                    {
                    to = { "1234567890", "9876543210" },
                    body = "I scored over 9000!!! Can you do better?"
                    }
            native.showPopup("sms", options)
        else
            table.insert(navigator, { linkName = event.target.linkName, linkSrc = "views.scene"..pageId, linkId = i } )
            storyboard.gotoScene( "views.scene"..pageId, "flip", 50  )
            homeImage.isVisible = true
        end
        print ("views.scene"..pageId)
    end
    return true
end


function onOrientationChange(event)
    portraitMode = true
    scrollView = nil
    scrollView = {}
    group = nil
    group = display.newGroup()
    loadResources(screenGroup,a,isLastLevel)
end


function loadResources(screenGroup,a,isLastLevel)
        screenGroup= screenGroup 
        a = a 
        isLastLevel = isLastLevel
	local xLeft, vary, varyText 
	local i=0
        if #a < 4 then
            xLeft = ((display.contentWidth)-(#a*307))/2
        else
            xLeft = 0
        end
    screenGroupHolder = screenGroup
	if isLastLevel==false then
            if portraitMode then
                scrollView = widget.newScrollView {
                    top = 200,
                    left = xLeft,
                    width = 0,   
                    height = display.contentHeight,
                    scrollWidth = 0,
                    scrollHeight = 1005,
                    --verticalScrollDisabled=true,
                    hideScrollBar = false,
                    --listener = onSceneTouch
                }
            else
                scrollView = widget.newScrollView {
                    top = 200,
                    left = xLeft,
                    width = display.contentWidth,   
                    height = 0,
                    scrollWidth = 1005,
                    scrollHeight = 0,
                    --verticalScrollDisabled=true,
                    hideScrollBar = false,
                    --listener = onSceneTouch
                }
            end  
        local yCordinate = 0
        for i=1,#a do
            if portraitMode then  
                vary = display.newImage("assets/"..a[i].src, 295*(((i%2)+1)%2)+(((i%2)+1)%2)*15, yCordinate  ,true)
                if i % 2 == 0 then
                    yCordinate = yCordinate + 220 + (((i%2)+1)%2)*70 
                end
            else
              vary = display.newImage("assets/"..a[i].src,295*(i-1)+(i*15), yCordinate ,true)  
            end           
            vary.id = i
            vary.linkName = a[i].linkName
            screenGroup:insert(vary)
            varyText = display.newText(vary.linkName,307*(i-1)+ 100,240, native.systemFontBold, 20 )
            print(varyText.width)
--            if varyText.width > 200 then
--                varyText = varyText.."\n"..string.sub(varyText, 24)
--            end
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
Runtime:addEventListener("unhandledError", myUnhandledErrorListener)

-- load first scene
storyboard.gotoScene( "views.homeScreen", "fade", 400 )

Runtime:addEventListener( "orientation", onOrientationChange ) 
