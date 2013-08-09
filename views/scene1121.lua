---------------------------------------------------------------------------------
--
-- scene1121.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local a = { 
			{ src = "edw.jpg", linkName = "Fiama Di Wills Perfect Young  Repleneshing Multi Benefit Cream" },
            { src = "vivel-logo-big.jpg", linkName = "Fiama Di Wills Perfect Young Repleneshing Night Skin Infuse" },
            { src = "edw.jpg", linkName = "Fiama Di Wills Perfect Young Intensive Replenishment Concentrate" },
            { src = "vivel-logo-big.jpg", linkName = "Fiama Di Wills Perfect Young Replinishing Eye Serum" },
            { src = "edw.jpg", linkName = "Fiama Di Wills Men Regenerating Anti Ageing Moisteurizer" },
            { src = "vivel-logo-big.jpg", linkName = "Fiama Di Wills Men  Revitalizing Anti-Fatigue Under Eye Gel" }
      }
local vary
-- print(table.getn(a)) 

-- Touch event listener for background image

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	vary = loadResources(screenGroup,a,false)
	print( "\n1121: createScene event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "1121: enterScene event" )
	
	-- remove previous scene's view
	local prior_scene = storyboard.getPrevious()
	storyboard.purgeScene( prior_scene )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "1121: exitScene event" )
		--vary:removeEventListener( "touch", vary)
	
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying scene 1121's view))" )
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

--"didExitScene" event is dispatched when scene becomes off-screen
--scene:addEventListener( "didExitScene", scene)

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene