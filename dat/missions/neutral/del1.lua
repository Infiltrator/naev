--[[

	Del's mission or something

	Author: Del

Basic plot: Someone hails you and tells you to move some stuff from Eclipse to Cluster One. You go to Eclipse and its an Empire ship. And you find something but trip an alarm and youre attacked. Then you go to Toaxis to and are hailed by drone Jessica to go to Ingot and it self-destructs. You go to Ingot and monies come.
]]--
 
-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	misn_title = "Del" -- TODO
	misn_reward = [["It's a gas"]]
	misn_desc = "A foreigner gave you a mysterious mission." -- Lol change 	this
	credits = 120000 -- Oooh may be adjustable maybe

	shipname = {}
		shipname[1] = "Eclipse" -- "Abandoned" ship
		shipname[2] = "Jessica" -- Drone informant boi
		shipname[3] = "Cluster One" -- "New" ship/baddie ship
		shipname[4] = "Empire FAST RESPONSE SUPER COMMANDO TURBO NUTTER UNIT Lancelot"

	sysname = {}
		sysname[1] = "Sigur" -- TODO maybe change it
		sysname[2] = "Toaxis"
		sysname[3] = "Ingot"

	-- OSD stuff
	osd_title = misn_title
	osd_msg = "Fly to the %s system and dock with (board) %s"

	title = {}
	text = {}
	
	-- All dialogue and related
	title[0] = "Is there anybody out there?" -- Probably change :D
	text[0] = [[WOULD YOU LIKE TO ACCEPT MEIN MISSION?]]

		acceptbutton = "Accept"
		declinebutton = "Decline"

	title[1] = "Money for nothing" -- Could maybe be kept
	text[1] = [[Move some stuff from Eclipse to Cluster One.]]

	title[2] = "X" -- TODO
	text[2] = [[Boarding Eclipse. You see a note left by someone telling you to take X. Its suspicious that its an Empire ship. You hear someone broadcasting angrily.

Do you want to stay on the ship?]]

			yes = "Yes" 
			no = "No"

	title[3] = "Y" -- TODO
	text[3] = [["Hello this is an automated message.." Jessicas message to tell you that you go to Ingot lol "Self-destruct in 10"]]

	title[4] = "Roger dat"
	text[4] = [[Welcome on board lol]]

	title[5] = "Mission Accomplished"
	text[5] = [["One of these days.." "Ahem." Gratz have monies. AND HE HAS A CAT THE PERSON WHO IS THERE.]] -- Cat is optional

	refusetitle = "Loser"
	refusetext = "Ownt"
end

function create ()
	if tk.choice(title[0], text[0], acceptbutton, declinebutton) == 1 then
		accept()
	else
		tk.msg(refusetitle, refusetext)
		abort()
	end
end

function accept()
	tk.msg(title[1], string.format(text[1]))
 
	misn.accept()
 
	var.push("del1progress", 1) -- TODO maybe change name
 
	misn.setTitle(misn_title)
	misn.setReward(misn_reward)
	misn.setDesc(misn_desc)
 
	osd_msg1 = string.format(osd_msg, sysname[1], shipname[1])
	osd_msg2 = string.format(osd_msg, sysname[2], shipname[3])
	misn.osdCreate(osd_title, {osd_msg1, osd_msg2})
	misn.osdActive(1)
 
	misn.setMarker(system.get(sysname[1]), "misc")

	talked=false
	stopping=false

	hook.enter("enter")
end

function enter()
   del1progress = var.peek("del1progress")
	del1spawn = var.peek("del1spawn")
	spawnrnd = rnd.rnd(0,100)
	if del1progress == 1 and system.cur() == system.get(sysname[1]) then
		eclipse = pilot.add("Empire Pacifier", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
		eclipse:rename(shipname[1])
 
		eclipse:setFaction(faction.get("Independent"))
 
		eclipse:disable()
		eclipse:setInvincible(true)
 
		hook.pilot(eclipse, "board", "board")
		hook.pilot(eclipse, "death", "abort")
	elseif del1progress == 2 and system.cur() == system.get(sysname[2]) then
		jessica = pilot.add("Trader Llama", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-1000,1000) ))[1]
		jessica:setFaction(faction.get("Independent"))
		jessica:rename(shipname[2])
		jessica:hailPlayer()

		jessica:control()
		jessica:follow(player.pilot())

	hook.pilot(jessica, "hail", "hail")
	elseif del1progress == 3 and system.cur() == system.get(sysname[3]) then
		cluster = pilot.add("Trader Quicksilver", "trader", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750, 750) ), false)[1]
		cluster:setFaction(faction.get("Independent"))
		cluster:rename(shipname[3])
		cluster:setInvincible()
		cluster:control()
		cluster:goto(vec2.new( rnd.rnd(0,427), rnd.rnd(-531,0) ), false)

		hook.pilot(cluster, "idle", "idle")
		hook.pilot(cluster, "hail", "hail")
	end

	if del1spawn == 1 and system.cur() ~= system.get(sysname[3]) then
		if spawnrnd >= 65 then
			lancelot = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
			lancelot:setFaction(faction.get("Empire"))
			lancelot:rename(shipname[4])
			lancelot:setHostile() -- TODO maybe make it broadcast something funny

			lancelot:control()
			lancelot:attack(player.pilot())
		else
		end
	elseif del1spawn == 2 and system.cur() ~= system.get(sysname[3]) then
		if spawnrnd >= 55 then
			lancelot = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
			lancelot:setFaction(faction.get("Empire"))
			lancelot:rename(shipname[4])
			lancelot:setHostile() -- TODO maybe make it broadcast something funny

			lancelot:control()
			lancelot:attack(player.pilot())
			if spawnrnd >= 85 then
				lancelot2 = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-750,750) ))[1]
				lancelot2:setFaction(faction.get("Empire"))
				lancelot2:rename(shipname[4])
				lancelot2:setHostile() -- TODO maybe make it broadcast something funny

				lancelot2:control()
				lancelot2:attack(player.pilot())
			else
			end
		else
		end
	end
end

function board()
	if del1progress == 1 then
		--stay = tk.choice(title[2], string.format(text[2]))
 
		carg_id = misn.addCargo("Food", 1) -- TODO Make it something other than food
 
   	var.push("del1progress", 2)
 
		misn.osdActive(2)
		misn.setMarker(system.get(sysname[2]), "misc")


		lancelot = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
		lancelot:setFaction(faction.get("Empire"))
		lancelot:rename(shipname[4])
		lancelot:setHostile() -- TODO maybe make it broadcast something funny

		lancelot:control()
		lancelot:attack(player.pilot())

		if tk.choice(title[2], string.format(text[2]), yes, no) == 2 then
			var.push("del1spawn", 1)

			player.unboard()
		else
			var.push("del1spawn", 2)

			lancelot2 = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-750,750) ))[1]
			lancelot2:setFaction(faction.get("Empire"))
			lancelot2:rename(shipname[4])
			lancelot2:setHostile() -- TODO maybe make it broadcast something funny

			lancelot2:control()
			lancelot2:attack(player.pilot())
		end
 
	elseif del1progress == 3 then
		tk.msg(title[5], string.format(text[5]))

   	player.pay( credits )
   	player.refuel()
		player.unboard()

   	cluster:setHealth(100, 100)
   	cluster:control(false)
   	cluster:changeAI("flee")

   	misn.finish(true)
	end
end

function hail()
	del1progress = var.peek("del1progress")
	if del1progress == 2 then
		tk.msg(title[3], string.format(text[3]))
 
		misn.osdDestroy()
 
		osd_msg1 = string.format(osd_msg, sysname[1], shipname[1])
		osd_msg2 = string.format(osd_msg, sysname[2], shipname[3])
		osd_msg3 = string.format(osd_msg, sysname[3], shipname[3])
		misn.osdCreate(osd_title, {osd_msg1, osd_msg2, osd_msg3})
		misn.osdActive(3)

		misn.setMarker(system.get(sysname[3]), "misc")
 
   	var.push("del1progress", 3)
 
		jessica:setHealth(0,0)
	elseif del1progress == 3 then
		tk.msg(title[4], string.format(text[4]))

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
		cluster:goto(vec2.new( rnd.rnd(0,351), rnd.rnd(0,390) ), false)
		cluster:goto(vec2.new( rnd.rnd(-518,0), rnd.rnd(0,418) ), false)
		cluster:goto(vec2.new( rnd.rnd(-485,0), rnd.rnd(-432,0) ), false)
		cluster:goto(vec2.new( rnd.rnd(0,452), rnd.rnd(-392,0) ), false)
	end
end

function abort()
	misn.finish(false)
end
