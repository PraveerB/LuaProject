---------------------------------------------------------------------------------
--
-- scene1134.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
local a = { 
			{ src = "edw.jpg", linkName = "Vivel Cell Renew Moisturizer" },
            { src = "vivel-logo-big.jpg", linkName = "Vivel Cell Renew hand cream" },
            { src = "edw.jpg", linkName = "Vivel Cell Renew All Year Light Body Lotion" },
            { src = "vivel-logo-big.jpg", linkName = "Vivel Cell Renew Body Lotion" },
            { src = "edw.jpg", linkName = "Vivel Cell Renew Pollution Protect face wash" },
            { src = "vivel-logo-big.jpg", linkName = "Vivel Cell Renew Energizing face wash" }
            
      }

local vary
-- print(table.getn(a)) 

-- Touch event listener for background image

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	vary = loadResources(screenGroup,a,false)
	print( "\nHS: createScene event")
end


-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	print( "HS: enterScene event" )
	-- remove previous scene's view
	local prior_scene = storyboard.getPrevious()
	storyboard.purgeScene( prior_scene )
	
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	print( "HS: exitScene event" )
		--vary:removeEventListener( "touch", vary)
	
end

-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying homeScreen's view))" )
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