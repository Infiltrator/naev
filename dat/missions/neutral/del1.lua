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
		shipname[4] = "IRP Lancelot" -- IRP=Immediate Response Patrol ©lumikant

	sysname = {}
		sysname[1] = "NGC-8037" -- TODO maybe change it
		sysname[2] = "Arandon"
		sysname[3] = "Oriantis"

	-- OSD stuff
	osd_title = misn_title
	osd_msg = "Fly to the %s system and dock with (board) %s"

	title = {}
	text = {}
	
	-- All dialogue and related
	title[0] = "Is there anybody out there?" -- Probably change :D
	text[0] = [[Your video screen shows dancing static. You're about to bang it to get it working when a voice-only transmission comes through. 
   "Hey, you're %s, right? Yeah... We've heard of you.
   "Listen, mate, we need you to do something for us. Nothing fancy, mind, just a little... courier mission.
   "You interested?"]]

		acceptbutton = "Accept"
		declinebutton = "Decline"

	title[1] = "Money for nothing" -- Could maybe be kept
	text[1] = [["Okay, great. Well, we need you to move some... stuff from the %s in the %s system to the %s. Real quiet-like, ya know?
   "They'll then meet you in the %s system. Don't keep them waiting. Well, good luck, mate."]]

	title[2] = "Dust and echoes" -- TODO
	text[2] = [[You board the %s. It seems strangely deserted. As you proceed down the hall, you realise you're on an abandoned Empire ship. Heading onto the bridge, you notice a note left on one of the consoles.
   "Go to the cargo bay and grab the box labelled 'X'."
   Suddenly, the comm goes off and you hear someone broadcasting angrily. Something about stolen property or some nonsense like that.
   Do you want to idle on the ship or grab the cargo and run?]]

			yes = "Idle around"
			no = "Run!"

	title[3] = "Helpless Automaton" -- TODO
	text[3] = [[Another voice-only transmission comes through on your comm.
   "Hello. This is an automated message. There has been a change of plans. You are to proceed to the %s system, where you will board the %s.
   In order to protect all those involved from unwanted attention, this messenger will self-destruct in 10 seconds..."]]

	title[4] = "Space Odessy"
	text[4] = [[Yet another voice-only transmission casts static across your video screen. You're begining to wonder why you payed 2.2k for it.
   "Ah, %s, we've been expecting you. Glad to see you got my message. Excellent. Well, don't dawdle, then. Hurry up and dock."
   If you didn't know better, you'd say that disembodied voice was purring.]]

	title[5] = "Mission Accomplished"
	text[5] = [[You proceed to your airlock, expecting to finally see the face of your employer when you're greeted by two men wearing visored helmets, bearing a mark that appears to be a white bushy tail.
   "We'll take it from here," says one of the men, extending his hand. You hesitantly hand the box over.
   "Here's something for your troubles," says the other, handing you the silver case he was holding. "It's plenty fair, we reckon."
   With that, they both turn around, walk off, and seal their airlock. This would appear to be the end of your little adventure.]]

	refusetitle = "Loser"
	refusetext = [["Alright, mate. Suit yerself, then."]]
end

function create ()
	if tk.choice(title[0], string.format(text[0], player.name()), acceptbutton, declinebutton) == 1 then
		accept()
	else
		abort()
	end
end

function accept() -- Accept mission, set general stuff
	tk.msg(title[1], string.format(text[1], shipname[1], sysname[1], shipname[3], sysname[2]))
 
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

	stopping=false

	hook.enter("enter")
end

function enter() -- When entering system
   del1progress = var.peek("del1progress")
	if del1progress == 1 and system.cur() == system.get(sysname[1]) then -- Entering sysname[1]
		eclipse = pilot.add("Empire Pacifier", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
		eclipse:rename(shipname[1])
 
		eclipse:setFaction(faction.get("Independent"))
 
		eclipse:disable()
		eclipse:setInvincible(true)
 
		hook.pilot(eclipse, "board", "board")
		hook.pilot(eclipse, "death", "abort")
	elseif del1progress == 2 and system.cur() == system.get(sysname[2]) then -- Entering sysname[2]
		jessica = pilot.add("Trader Llama", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-1000,1000) ))[1]
		jessica:setFaction(faction.get("Independent"))
		jessica:rename(shipname[2])
		jessica:hailPlayer()

		jessica:control()
		jessica:follow(player.pilot())

	hook.pilot(jessica, "hail", "hail")
	elseif del1progress == 3 and system.cur() == system.get(sysname[3]) then -- Entering sysname[3]
		cluster = pilot.add("Trader Quicksilver", "trader", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750, 750) ), false)[1]
		cluster:setFaction(faction.get("Independent"))
		cluster:rename(shipname[3])
		cluster:setInvincible()
		cluster:control()
		cluster:goto(vec2.new( rnd.rnd(0,427), rnd.rnd(-531,0) ), false)

		hook.pilot(cluster, "idle", "idle")
		hook.pilot(cluster, "hail", "hail")
	end
spawn()
end

function board() -- When boarding ships
	if del1progress == 1 then -- When boarding shipname[1]
 
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

		if tk.choice(title[2], string.format(text[2], shipname[1]), yes, no) == 2 then -- If you don't stay on the ship
			var.push("del1spawn", 1)

			player.unboard()
		else -- If you stay on the ship
			var.push("del1spawn", 2)

			lancelot2 = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-750,750) ))[1]
			lancelot2:setFaction(faction.get("Empire"))
			lancelot2:rename(shipname[4])
			lancelot2:setHostile() -- TODO maybe make it broadcast something funny

			lancelot2:control()
			lancelot2:attack(player.pilot())
		end
 
	elseif del1progress == 3 then -- Boarding shipname[3]
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

function spawn() -- Spawn ships when entering systems
	del1spawn = var.peek("del1spawn")
	spawnrnd = rnd.rnd(0,100)
	if del1spawn == 1 and system.cur() ~= system.get(sysname[3]) then -- If you didn't stay on shipname[1]
		if spawnrnd >= 60 then
			lancelot = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
			lancelot:setFaction(faction.get("Empire"))
			lancelot:rename(shipname[4])
			lancelot:setHostile() -- TODO maybe make it broadcast something funny

			lancelot:control()
			lancelot:attack(player.pilot())
		end
	elseif del1spawn == 2 and system.cur() ~= system.get(sysname[3]) then -- If you stayed on shipname[1]
		if spawnrnd >= 45 then
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
			end
		end
	end
end

function hail() -- When hailing ships
	del1progress = var.peek("del1progress")
	if del1progress == 2 then -- Hailing shipname[2]
		tk.msg(title[3], string.format(text[3], sysname[3], shipname[3]))
 
		misn.osdDestroy()
 
		osd_msg1 = string.format(osd_msg, sysname[1], shipname[1])
		osd_msg2 = string.format(osd_msg, sysname[2], shipname[3])
		osd_msg3 = string.format(osd_msg, sysname[3], shipname[3])
		misn.osdCreate(osd_title, {osd_msg1, osd_msg2, osd_msg3})
		misn.osdActive(3)

		misn.setMarker(system.get(sysname[3]), "misc")
 
   	var.push("del1progress", 3)
 
		jessica:setHealth(0,0)
	elseif del1progress == 3 then -- Hailing shipname[3]
		tk.msg(title[4], string.format(text[4], player.name()))

		cluster:cleartask()
   	cluster:brake()
   	stopping = true
   	hook.pilot(cluster, "board", "board")
   end
end

function idle() -- shipname[3] behaviour
	if stopping then
		cluster:disable()
	else
		cluster:goto(vec2.new( rnd.rnd(0,351), rnd.rnd(0,390) ), false)
		cluster:goto(vec2.new( rnd.rnd(-518,0), rnd.rnd(0,418) ), false)
		cluster:goto(vec2.new( rnd.rnd(-485,0), rnd.rnd(-432,0) ), false)
		cluster:goto(vec2.new( rnd.rnd(0,452), rnd.rnd(-392,0) ), false)
	end
end

function abort() -- If you decline or abort the mission
	tk.msg(refusetitle, refusetext)
	misn.finish(false)
end
