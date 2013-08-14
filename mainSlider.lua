module(..., package.seeall)

function new( imageSet,screenGroup)
    local widget = require "widget"
    local vary,i
    local varyTable = {}
    --local navigator = {{linkName = "" , linkSrc = "" , linkId = "", linkObj=""}}
    --local pageId = "" 
    
    for i=1,#imageSet do
            vary = display.newImage("assets/"..imageSet[i].src, 250*(i-1),0, native.systemFontBold, 24 )
            vary:setStrokeColor(254,254,254)
            vary.strokeWidth= 15
            vary.id = i
            vary.linkName = imageSet[i].linkName
            -- set link name print(key).
            screenGroup:insert(vary)
            --vary.touch = onSceneTouch
            --vary:addEventListener( "touch", onSceneTouch)
--            vary.touch = scrollViewListener
--            vary:addEventListener( "touch", vary )
            table.insert(varyTable,i,vary)
            --scrollView:insert(vary)
    end
      local scrollView = widget.newScrollView {
                top = 200,
                left = 0,
                width = 1024,
                height = 250,
                scrollWidth = 1005,
                scrollHeight = 0,
                verticalScrollDisabled=true,
                hideScrollBar = true,
                --listener = scrollViewListener("touch")
            }
  for i=1,#varyTable do
   scrollView:insert(varyTable[i])
 end
return varyTable,scrollView
end
