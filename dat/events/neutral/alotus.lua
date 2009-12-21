--[[

	Event for starting the Del series of missions or maybe 1 mission involving a cat and strange characters that possible speak in poems and/or song lyrics

	Author: Del

]]--


function create ()
	schroedinger = pilot.add("Schroedinger")[1]

	hook.pilot(schroedinger, "jump", "finish")
	hook.pilot(schroedinger, "death", "finish")
	hook.land("finish")
	hook.jumpout("finish")

	hailie = evt.timerStart("hailme", 9001)
end

-- In Soviet Russia Schroedinger hails YOU
function hailme()
	schroedinger:hailPlayer()
	hook.pilot(schroedinger, "hail", "hail")
end

-- You hail Schroedinger, not in Soviet Russia
function hail()
	evt.misnStart("Del") -- Del=WIP
	evt.finish(true)
end

function finish()
	evt.timerStop(hailie)
	evt.finish()
end
