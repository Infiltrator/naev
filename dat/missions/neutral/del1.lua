--[[

	Del's mission or something

	Author: Del

Basic plot: Someone hails you and tells you to move some stuff from Eclipse to Cluster One. You go to Eclipse and its TODO an Empire ship (?). And you find something but trip an alarm and youre attacked. Then you go to Toaxis to and are hailed by drone Jessica to go to Ingot and it self-destructs. You go to Ingot and monies come.
]]--
 
-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
misn_title = "Del" -- TODO
misn_reward = [["It's a gas"]]
misn_desc = "A foreigner gave you a mysterious mission." -- Lol change 	this
credits = 120000 -- Oooh may be adjustable maybe

title = {}
	title[0] = "Hai"
	title[1] = "Money for nothing"
	title[2] = "X" -- TODO
	title[3] = "Y" -- TODO
	title[4] = "Mission Accomplished"
	 
shipname = {}
	shipname[1] = "Eclipse" -- "Abandoned" ship
	shipname[2] = "Jessica" -- Drone informant boi
	shipname[3] = "Cluster One" -- "New" ship/baddie ship
 
sysname = {}
	sysname[1] = "Sigur" -- Where Eclipse is TODO maybe change it
	sysname[2] = "Toaxis" -- Where Cluster One is supposed to be
	sysname[3] = "Ingot" -- Where Cluster One is
 
text = {}
	text[0] = [[WOULD YOU LIKE TO ACCEPT MEIN MISSION?]]
	text[1] = [[Move some stuff from Eclipse to Cluster One.]]
	text[2] = [[Boarding Eclipse. You see a note left by someone telling you to take X. Its suspicious that its an Empire ship. As you undock you see empire ships in the distance.]]
	text[3] = [["Hello this is an automated message.." Jessicas message to tell you that you go to Ingot lol "Self-destruct in 10"]]
	text[4] = [["One of these days.." "Ahem." Gratz have monies. AND HE HAS A CAT THE PERSON WHO IS THERE.]]
 
osd_title = "Del"
osd_msg = "Go to %s in %s."
 
refusetitle = "Loser"
refusetext = "Ownt"
 
acceptbutton = "Accept"
declinebutton = "Decline"
end

function create ()
if tk.choice(title[0], text[0], acceptbutton, declinebutton) == 1 then
	accept()
else
	tk.msg(refusetitle, refusetext)
	--abort()
	end
end

function accept()
	tk.msg(title[1], string.format(text[1]))
 
	misn.accept()
 
	var.push("del1progress", 1) -- DONT KNOW IF THIS WILL WORK LOL TODO change name
 
	misn.setTitle(misn_title)
	misn.setReward(misn_reward)
	misn.setDesc(misn_desc)
 
	osd_msg1 = string.format(osd_msg, shipname[1], sysname[1])
	osd_msg2 = string.format(osd_msg, shipname[3], sysname[2])
	misn.osdCreate(osd_title, {osd_msg1, osd_msg2})
	misn.osdActive(1)
 
	misn.setMarker(system.get(sysname[1]), "misc")

	talked=false
	stopping=false -- Do these talked and stopping actually do anything?

	hook.land("land")
	hook.takeoff("takeoff")
	hook.enter("enter")
end

function enter()
   del1progress = var.peek("del1progress")
if del1progress == 1 and system.cur() == system.get(sysname[1]) then
	eclipse = pilot.add("Empire Pacifier", "def", vec2.new(0, 0))[1]
		eclipse:rename(shipname[1])
 
		eclipse:setFaction(faction.get("Independent"))
 
		eclipse:disable()
		eclipse:setInvincible(true)
 
	hook.pilot(eclipse, "board", "board")
	hook.pilot(eclipse, "death", "abort")
elseif del1progress == 2 and system.cur() == system.get(sysname[2]) then
	jessica = pilot.add("Trader Llama", "def", vec2.new(0, 500))[1]
		jessica:setFaction(faction.get("Independent"))
		jessica:rename(shipname[2])
		jessica:hailPlayer()

		jessica:control()
		jessica:follow(player.pilot())

	hook.pilot(jessica, "hail", "hail")
elseif del1progress == 3 and system.cur() == system.get(sysname[3]) then
	cluster = pilot.add("Trader Quicksilver", "trader", vec2.new(-400,-400), false)[1]
		cluster:setFaction(faction.get("Independent"))
		cluster:rename(shipname[3])
		cluster:setInvincible()
		cluster:control()
		cluster:goto(vec2.new( 400, -400), false)

	--hook.pilot(cluster, "board", "board")
	hook.pilot(cluster, "idle", "idle")
	hook.pilot(cluster, "hail", "hail")
	end
end

function board() -- It would probably be best to make this use ship.get or ship.name
if del1progress == 1 then
	tk.msg(title[2], string.format(text[2]))
 
	carg_id = misn.addCargo("Food", 1) -- TODO Make it something other than food
 
   var.push("del1progress", 2)
 
	misn.osdActive(2)
	misn.setMarker(system.get(sysname[2]), "misc")

	lancelot = pilot.add("Empire Lancelot", "def", vec2.new( -347, 531 ))[1]
		lancelot:setFaction(faction.get("Empire"))
		lancelot:rename("Empire FAST RESPONSE SUPER COMMANDO TURBO NUTTER UNIT Lancelot")
		lancelot:setHostile() -- TODO maybe make it broadcast something funny

		lancelot:control()
		lancelot:attack(player.pilot())
 
	--player.unboard() -- Offblast! But does this make you unboard automatically? I think you could use enter once again for this, or maybe not..
elseif del1progress == 3 then
	tk.msg(title[4], string.format(text[4]))

   player.pay( credits )
   player.refuel()
   --player.unboard()

   cluster:setHealth(100, 100)
   cluster:control(false)
   cluster:changeAI("flee")

   misn.finish(true)
	end
end

--[[function unboard()
	lancelot = pilot.add("Empire Lancelot", "def", vec2.new(-500,0))
	lancelot:setFaction(faction.get("Empire"))
	lancelot:rename("Empire FAST RESPONSE SUPER COMMANDO TURBO NUTTER UNIT Lancelot")
	lancelot:setHostile() -- TODO maybe make it broadcast something funny
end]]

function hail()
del1progress = var.peek("del1progress")
--if ship.get(ship.name()) == shipname[2] then
if del1progress == 2 then
		tk.msg(title[3], string.format(text[3]))
 
	misn.osdDestroy()
 
	osd_msg1 = string.format(osd_msg, shipname[1], shipname[1]) -- TODO make these what they should be
	osd_msg2 = string.format(osd_msg, shipname[1], shipname[1])
	osd_msg3 = string.format(osd_msg, shipname[1], shipname[1])
	misn.osdCreate(osd_title, {osd_msg1, osd_msg2, osd_msg3})
	misn.osdActive(3)
 
   var.push("del1progress", 3)
 
	jessica:setHealth(0,0) -- I dont think this will work. pilot.setHealth
 
--	evt.finish(true)
-- elseif ship.get(ship.name()) == shipname[3] then
-- TODO this should make cluster stop and disable when you hail it so you can board it
elseif del1progress == 3 then
	cluster:cleartask()
   cluster:brake()
   stopping = true
   hook.pilot(cluster, "board", "board")
   end
end

function idle()
if stopping then
	cluster:disable()
else
	cluster:goto(vec2.new( 400, 400), false)
	cluster:goto(vec2.new(-400, 400), false)
	cluster:goto(vec2.new(-400, -400), false)
	cluster:goto(vec2.new( 400, -400), false)
	end
end
