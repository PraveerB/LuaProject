-- hide device status bar
display.setStatusBar( display.HiddenStatusBar )


-- set background image for all scenes
local image = display.newImage( "assets/bgPort.jpg", display.contentHeight*display.contentWidth)
local image2 = display.newImage( "assets/bgLand.jpg", display.contentHeight*display.contentWidth)
--
image2.isVisible = false
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
local aHolder,isLastLevelHolder , storyboardHolder

local function onComplete( event )
    if group ~= nil then
        group.isVisible = false
    end
    pageId = ""
    homeImage.isVisible = false
    navigator = nil
    navigator = {{linkName = "tabBar" , linkSrc = "" , linkId = "", linkObj=""} }
    if "clicked" == event.action then
        local i = event.index
        if i == 1 then
            storyboard.gotoScene( "views.homeScreen", "flip", 70 )
        elseif i==2 then
            os.exit()
        end
    else
        storyboard.gotoScene( "views.homeScreen", "flip", 70 )
    end
end


local function myUnhandledErrorListener( event )
    local iHandledTheError = true
    if iHandledTheError then
        print( "Handling the unhandled error", event.errorMessage )
        native.showAlert("error report",event.errorMessage,{"Reload?","Exit App"},onComplete)
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
    --group.isVisible = true
    i = #navigator
    i=i+1
    pageId = pageId..event.target.id
    if event.name == "tap" then
        print ("views.scene"..pageId)
        if pageId == "2" then
            pageId = ""
            media.playVideo("Corona-iPhone.m4v",true,onComplete)
        elseif pageId == "3" then
            pageId = ""
            system.openURL( "tel:+918884366552" )
        elseif pageId == "4" then
            pageId = ""
            local options =
                    {
                    to = { "08884366552", "08006206769" },
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


function onOrientationChange()
    if portraitMode then
        print("portrait mode")
        image2.isVisible = true
        image.isVisible = false
        --image.parent = display.newImage( "assets/bgPort.jpg", display.contentHeight*display.contentWidth)
        portraitMode = false
    else
        print("landscape mode")
        image.isVisible = true
        image2.isVisible = false
        --image.setFilePath("assets/bgLand.jpg")
        --image.parent = display.newImage( "assets/bgLand.jpg", display.contentHeight*display.contentWidth)
        portraitMode = true
    end
    if screenGroupHolder ~= nil then
        scrollView:removeSelf()
        --screenGroupHolder = nil
    end
    group = nil
    print("scrollView   ::: ")
    loadResources(screenGroupHolder,aHolder,isLastLevelHolder)
end


function loadResources(screenGroup,a,isLastLevel)
    if a~=nil then
        storyboardHolder = storyboard
        screenGroupHolder= screenGroup 
        aHolder = a 
        isLastLevelHolder = isLastLevel
	local xLeft, vary, varyText 
	local i=0
        if #a < 4 then
            xLeft = ((display.contentWidth)-(#a*307))/2
        else
            xLeft = 0
        end
    
	if isLastLevel==false then
            if portraitMode then
                scrollView = widget.newScrollView {
                    top = 0,
                    left = display.contentWidth/2 - 110,
                    width = 0,   
                    height = display.contentHeight,
                    scrollWidth = 0,
                    scrollHeight = 1005,
                    horizontalScrollDisabled=true,
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
                    verticalScrollDisabled=true,
                    hideScrollBar = false,
                    --listener = onSceneTouch
                }
            end  
        local yCordinate = 0
        for i=1,#a do
            if portraitMode then  
                vary = display.newImage("assets/"..a[i].src, 0, 220*(i-1)+(i*70)  ,true)
                varyText = display.newText(a[i].linkName,30,220*(i-1)+(i*60), native.systemFontBold, 40 )
            else
              vary = display.newImage("assets/"..a[i].src,295*(i-1)+(i*15), yCordinate ,true)  
              varyText = display.newText(a[i].linkName,307*(i-1)+ 100,240, native.systemFontBold, 20 )
            end           
            vary.id = i
            vary.linkName = a[i].linkName
            screenGroup:insert(vary)
            
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
    screenGroupHolder = screenGroup
    createNavigator()
    return vary
end
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
        group.isVisible = false
        navigator = nil
        navigator = {{linkName = "tabBar" , linkSrc = "" , linkId = "", linkObj=""} }
        storyboard.gotoScene( "views.homeScreen", "crossFade", 500  )
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
local function checkMemory()
   collectgarbage( "collect" )
   local memUsage_str = string.format( "MEMORY = %.3f KB", collectgarbage( "count" ) )
   print( memUsage_str, "TEXTURE = "..(system.getInfo("textureMemoryUsed") / (1024 * 1024) ) )
end
timer.performWithDelay( 5000, checkMemory, 0 )
-- load first scene
storyboard.gotoScene( "views.homeScreen", "fade", 400 )

Runtime:addEventListener( "orientation", onOrientationChange ) 
