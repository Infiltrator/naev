--[[

	Event for starting the Del series of missions or maybe 1 mission involving a cat and strange characters that possible speak in poems and/or song lyrics

	Author: Del

]]--


function create ()
	if var.peek("del1progress") == nil then
		schroedinger = pilot.add("Schroedinger", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-1000,1000) ))[1]
		schroedinger:control()
		schroedinger:follow(player.pilot())

		hook.pilot(schroedinger, "jump", "finish")
		hook.pilot(schroedinger, "death", "finish")
		hook.land("finish")
		hook.jumpout("finish")

		hailie = evt.timerStart("hailme", 6000)
	else
	end
end

-- In Soviet Russia Schroedinger hails YOU
function hailme()
	schroedinger:hailPlayer()
	hook.pilot(schroedinger, "hail", "hail")
end

-- You hail Schroedinger, not in Soviet Russia
function hail()
	schroedinger:control(false)
	schroedinger:changeAI("flee")

	evt.misnStart("Del") -- Del=WIP
	evt.finish(true)
end

function finish()
	evt.timerStop(hailie)
	evt.finish()
end
