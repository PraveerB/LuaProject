-- slideView.lua
-- 
-- Version 1.0 
--
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

local screenW, screenH = display.contentWidth, display.contentHeight
local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight
local imgNum = nil
local images = {}
local touchListener, nextImage, prevImage, cancelMove, initImage
local imageNumberText
system.activate( "multitouch" )
require("multitouch")
require("pinchlib")

function new( imageSet, slideBackground, top, bottom )	
	local pad = 20
	local top = top or 0 
	local bottom = bottom or 0
	local g = display.newGroup()
	local defaultString = "1 of " .. #imageSet
	function touchListener (self, touch) 
		local phase = touch.phase
		if ( phase == "began" ) then
		        --Subsequent touch events will target button even if they are outside the contentBounds of button
		        display.getCurrentStage():setFocus( self )
		        self.isFocus = true
				startPos = touch.x
				prevPos = touch.x
				imgNum = self.imgNum
				
		elseif( self.isFocus ) then	
        
			if ( phase == "moved" ) then
			
				transition.to(defaultString,  { time=400, alpha=0 } )
						
				if tween then transition.cancel(tween) end
	
				--print(imgNum)
				
				local delta = touch.x - prevPos
				prevPos = touch.x
				
				images[imgNum].x = images[imgNum].x + delta
				
				if (images[imgNum-1]) then
					images[imgNum-1].x = images[imgNum-1].x + delta
				end
				
				if (images[imgNum+1]) then
					images[imgNum+1].x = images[imgNum+1].x + delta
				end

			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				dragDistance = touch.x - startPos
				print("dragDistance: " .. dragDistance)
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
                                elseif (dragDistance > -40 and dragDistance < 40) then
                                    display.getCurrentStage():setFocus( nil )
                                    self.isFocus = false
                                        if((touch.x > 845 and touch.x < 950) and (touch.y > 360 and touch.y < 390)) then
                                            local widget = require "widget"
                                            local img
                                            local text = display.newText("X",500,0,"Helvetica",30)
                                            text:setTextColor(0,40,90)
                                                       
                                            local scrollView = widget.newScrollView {
                                                        top = 180,
                                                        left = 470,
                                                        width = 530,
                                                        height = 250,
                                                        scrollWidth = 0,
                                                        scrollHeight = 200,
                                                        horizontalScrollDisabled=true,
                                                        hideScrollBar = false,
                                                        
                                                    }
                                                    img = display.newImage("assets/men-aqua-sport_showergel-_popup.jpg",0,30,true)
                                                    scrollView:insert(text)
                                                    scrollView:insert(img)
                                                    
                                                    
                                            function textListener (event )
                                                display.getCurrentStage():setFocus( self )
                                                --self.isFocus = false
                                                scrollView.isVisible = false
                                                img:removeSelf()
                                                scrollView = nil
                                                
                                                self.touch = touchListener
                                                self:addEventListener( "touch", self)
                                                
                                            end
                                            text:addEventListener("touch", textListener)
                                            self.touch = doNothing()
                                            --self.removeEventListener("touch", touchListener) 
                                            --Runtime:addEventListener("touch",scrollListener)
                                           --native.showPopup( "mail" )
                                            
                                        end
				else
					cancelMove()
				end
									
				if ( phase == "cancelled" ) then		
					cancelMove()
				end

                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
                
														
			end
		end
					
		return true
		
	end
        for i = 1,#imageSet do
		local p = display.newImage(imageSet[i])
		local h = viewableScreenH-(top+bottom)
		if p.width > viewableScreenW or p.height > h then
			if p.width/viewableScreenW > p.height/h then 
					p.xScale = viewableScreenW/p.width
					p.yScale = viewableScreenW/p.width
			else
					p.xScale = h/p.height
					p.yScale = h/p.height
			end		 
		end
		g:insert(p)
	    
		if (i > 1) then
			p.x = screenW*1.5 + pad -- all images offscreen except the first one
		else 
			p.x = screenW*.5
		end
		
		p.y = h*.5
                p.imgNum = i
		images[i] = p
                p.touch = touchListener
                p:addEventListener( "touch", p )
                p:addEventListener( "multitouch", multitouch )
	end
	


	--local navBar = display.newGroup()
	--g:insert(navBar)
	
	--local navBarGraphic = display.newImage("assets/navBar.png", 0, 0, false)
	--navBar:insert(navBarGraphic)
	--navBarGraphic.x = viewableScreenW*.5
	--navBarGraphic.y = 0
			
	imageNumberText = display.newText(defaultString,screenW*.4,screenH-60, native.systemFontBold, 45)
	imageNumberText:setTextColor(255, 255, 255)
	--imageNumberTextShadow = display.newText(defaultString, 0,0, native.systemFontBold, 54)
	--imageNumberTextShadow:setTextColor(0, 0, 0)
	--navBar:insert(imageNumberTextShadow)
	--navBar:insert(imageNumberText)
	--imageNumberText.x = navBar.width*.5
	--imageNumberText.y = navBarGraphic.y
	--imageNumberTextShadow.x = imageNumberText.x - 1
	--imageNumberTextShadow.y = imageNumberText.y - 1
	
	--navBar.y = math.floor(navBar.height*0.5)
	g:insert(imageNumberText)

	imgNum = 1
	
	g.x = 0
	g.y = top + display.screenOriginY
			
	
	
	function setSlideNumber()
		print("setSlideNumber", imgNum .. " of " .. #imageSet)
		imageNumberText.text = imgNum .. " of " .. #imageSet
		--imageNumberTextShadow.text = imgNum .. " of " .. #images
	end
	
	function cancelTween()
		if prevTween then 
			transition.cancel(prevTween)
		end
		prevTween = tween 
	end
	
	function nextImage()
		tween = transition.to( images[imgNum], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum + 1
		initImage(imgNum)
	end
	
	function prevImage()
		tween = transition.to( images[imgNum], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=screenW*.5, transition=easing.outExpo } )
		imgNum = imgNum - 1
		initImage(imgNum)
	end
	
	function cancelMove()
		tween = transition.to( images[imgNum], {time=400, x=screenW*.5, transition=easing.outExpo } )
		tween = transition.to( images[imgNum-1], {time=400, x=(screenW*.5 + pad)*-1, transition=easing.outExpo } )
		tween = transition.to( images[imgNum+1], {time=400, x=screenW*1.5+pad, transition=easing.outExpo } )
	end
	
	function initImage(num)
		if (num < #images) then
			images[num+1].x = screenW*1.5 + pad			
		end
		if (num > 1) then
			images[num-1].x = (screenW*.5 + pad)*-1
		end
		setSlideNumber()
	end

	--images.touch = touchListener
        --images:addEventListener( "touch", images )

	------------------------
	-- Define public methods
	
	function g:jumpToImage(num)
		local i
		print("jumpToImage")
		print("#images", #images)
		for i = 1, #images do
			if i < num then
				images[i].x = -screenW*.5;
			elseif i > num then
				images[i].x = screenW*1.5 + pad
			else
				images[i].x = screenW*.5 - pad
			end
		end
		imgNum = num
		initImage(imgNum)
	end

	function g:cleanUp()
		print("slides cleanUp")
		--background:removeEventListener("touch", touchListener)
	end

	return g	
end

function doNothing()
    
end

function multitouch(e)
        if (e.phase == "began") then
                doPinchZoom( e.target, {} )
                doPinchZoom( e.target, e.list )
        elseif (e.phase == "moved") then
                doPinchZoom( e.target, e.list )
        else
                doPinchZoom( e.target, {} )
        end
        
        return true -- unfortunately, this will not propogate down if false is returned
end
 
