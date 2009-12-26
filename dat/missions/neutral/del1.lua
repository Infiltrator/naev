--[[

	Del's mission or something

	Author, general dictator: Del
	Dialogue, bugfixing, general ownage: Infiltrator

Basic plot: Someone hails you and tells you to move some stuff from Eclipse to Cluster One. You go to Eclipse and its an Empire ship. And you find something but trip an alarm and youre attacked. Then you go to Toaxis to and are hailed by drone Jessica to go to Ingot and it self-destructs. You go to Ingot and monies come.
]]--
 
-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	misn_title = "Del" -- TODO
	misn_reward = [["It's a gas"]]
	misn_desc = "A foreigner gave you a mysterious mission." -- Lol change 	this
	credits = rnd.rnd(40000,60000)

	shipname = {}
		shipname[1] = "Eclipse" -- "Abandoned" ship
		shipname[2] = "Jessica" -- Drone informant boi
		shipname[3] = "Astoria" -- "New" ship/baddie ship 
		shipname[4] = "IRP Lancelot" -- IRP=Immediate Response Patrol ©lumikant

	sysname = {}
		sysname[1] = "NGC-8037"
		sysname[2] = "Arandon"
		sysname[3] = "Oriantis"

	-- OSD stuff
	osd_title = misn_title
	osd_msg = "Fly to the %s system and dock with (board) %s"

	-- All dialogue and related
	title = {}
	text = {}
	
	title[0] = "Is there anybody out there?" -- TODO Probably change :D
	text[0] = [[Your video screen shows dancing static. You're about to bang it to get it working when a voice-only transmission comes through. 
   "Hey, you're %s, right? Yeah... We've heard of you.
   "Listen, mate, we need you to do something for us. Nothing fancy, mind, just a little... courier mission.
   "You interested?"]]

		acceptbutton = "Yes" -- TODO check these Inf
		declinebutton = "No"

	title[1] = "Money for nothing" -- TODO Is this ok?
	text[1] = [["Okay, great. Well, we need you to move some... stuff from the %s in the %s system to the %s. Real quiet-like, ya know?
   "They'll then meet you in the %s system. Don't keep them waiting. Well, good luck, mate."]]

	title[2] = "Dust and echoes"
	text[2] = [[You board the %s. It seems strangely deserted. As you proceed down the hall, you realise you're on an abandoned Empire ship. Heading onto the bridge, you notice a note left on one of the consoles.
   "Go to the cargo bay and grab the box labelled 'X'."
   Suddenly, the comm goes off and you hear someone broadcasting angrily. Something about stolen property or some nonsense like that.
   Do you want to idle on the ship or grab the cargo and run?]] -- TODO broadcasting angrily was just something off the top of my head

			yes = "Idle around"
			no = "Run!"

	title[3] = "Helpless Automaton"
	text[3] = [[Another voice-only transmission comes through on your comm.
   "Hello. This is an automated message. There has been a change of plans. You are to proceed to the %s system, where you will board the %s.
   "In order to protect all those involved from unwanted attention, this messenger will self-destruct in 10 seconds..."]]

	title[4] = "Space Odyssey"
	text[4] = [[Yet another voice-only transmission casts static across your video screen. You're begining to wonder why you paid 2.2k for it.
   "Ah, %s, we've been expecting you. Glad to see you got my message. Excellent. Well, don't dawdle, then. Hurry up and dock."
   If you didn't know better, you'd say that disembodied voice was purring.]]

	title[5] = "It's a long way to the top"
	text[5] = [[You proceed to your airlock, expecting to finally see the face of your employer when you're greeted by two men wearing visored helmets, bearing odd, disc-shaped black and reflective marks. You also pay attention to the black walls which are adorned with dispersive prisms and accompanying rays of light.
   "We'll take it from here," says one of the men, extending his hand. You hesitantly hand the box over.
   "Here's something for your troubles," says the other, handing you the silver case he was holding. "It's plenty fair, we reckon."
   With that, they both turn around, walk off, and seal their airlock. This would appear to be the end of your little adventure.]]

	refusetitle = "Tunnel visionary" -- TODO is this OK?
	refusetext = [["Alright, mate. Suit yerself, then."]]
end

function create ()
	if tk.choice(title[0], string.format(text[0], player.name()), acceptbutton, declinebutton) == 1 then
		accept()
	else
		abort()
	end
end

-- Accept mission, set general stuff
function accept()
	tk.msg(title[1], string.format(text[1], shipname[1], sysname[1], shipname[3], sysname[2]))
 
	misn.accept()
 
	var.push("del1progress", 1)
 
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
-- Entering systems
function enter()
   del1progress = var.peek("del1progress")

	if del1progress == 1 and system.cur() == system.get(sysname[1]) then
	-- Entering sysname[1]
		eclipse = pilot.add("Empire Pacifier", "def", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750,750) ))[1]
		eclipse:rename(shipname[1])
 
		eclipse:setFaction(faction.get("Independent"))
 
		eclipse:disable()
		eclipse:setInvincible(true)
 
		hook.pilot(eclipse, "board", "board")
		hook.pilot(eclipse, "death", "abort")

   elseif del1progress == 2 then
      if system.cur() == system.get(sysname[2]) then
      -- Entering sysname[2]
         
         jessica = pilot.add("Trader Llama", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-1000,1000) ))[1]
         jessica:setFaction(faction.get("Independent"))
         jessica:rename(shipname[2])
         jessica:hailPlayer()

         jessica:control()
         jessica:follow(player.pilot())

         hook.pilot(jessica, "hail", "hail")
      else
         spawn()
      end

	elseif del1progress == 3 and system.cur() == system.get(sysname[3]) then
	-- Entering sysname[3]
		cluster = pilot.add("Trader Quicksilver", "trader", vec2.new( rnd.rnd(-750,750), rnd.rnd(-750, 750) ), false)[1]
		cluster:setFaction(faction.get("Independent"))
		cluster:rename(shipname[3])
		cluster:setInvincible()
		cluster:control()
		cluster:goto(vec2.new( rnd.rnd(0,427), rnd.rnd(-531,0) ), false)

		var.pop("del1spawn")

		hook.pilot(cluster, "idle", "idle")
		hook.pilot(cluster, "hail", "hail")
	end
end

-- Boarding ships
function board() 
	if del1progress == 1 then
	-- Boarding shipname[1]
 
		carg_id = misn.addCargo("Food", 1) -- TODO Make it something other than food
 
   	var.push("del1progress", 2)
 
		misn.osdActive(2)
		misn.setMarker(system.get(sysname[2]), "misc")

		if tk.choice(title[2], string.format(text[2], shipname[1]), yes, no) == 2 then
		-- If you don't stay on the ship
			var.push("del1spawn", 1.5)
			player.unboard()

		else 
		-- If you stay on the ship
			var.push("del1spawn", 1.9)
		end

      spawn()
 
	elseif del1progress == 3 then
	-- Boarding shipname[3]
		tk.msg(title[5], string.format(text[5]))

   	player.pay( credits )
   	player.refuel()
		player.unboard()
		pilot.setHealth(player.pilot(), 100, 100)

   	cluster:setHealth(100, 100)
   	cluster:control(false)
   	cluster:changeAI("flee")

   	misn.finish(true)
	end
end

-- Spawn ships when entering systems
-- Also used when boarding shipname[1]
function spawn()
   del1spawn = var.peek("del1spawn")

   for i = 1, del1spawn, 1 do
      lancelot = pilot.add("Empire Lancelot", "def", vec2.new( rnd.rnd(-1000,1000), rnd.rnd(-1000,1000) ))[1]
      lancelot:setFaction(faction.get("Empire"))
      lancelot:rename(shipname[4])
      lancelot:setHostile() -- TODO maybe make it broadcast something funny

      lancelot:control()
      lancelot:attack(player.pilot())

      hook.pilot(lancelot, "death", "deadLancelot")
   end
end

function deadLancelot()
   -- If you've killed one, reduce the number of Lancelots chasing you
   del1spawn = var.peek("del1spawn")
   var.push("del1spawn", del1spawn - 0.5)
end

-- Hailing ships
function hail()
	del1progress = var.peek("del1progress")

	if del1progress == 2 then
	-- Hailing shipname[2]
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

	elseif del1progress == 3 then
	-- Hailing shipname[3]
		tk.msg(title[4], string.format(text[4], player.name()))

		cluster:cleartask()
   	cluster:brake()
   	stopping = true
   	hook.pilot(cluster, "board", "board")
   end
end

-- shipname[3] behaviour
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

-- Decline/abort
function abort()
	var.pop("del1progress")
	var.pop("del1spawn")

	tk.msg(refusetitle, refusetext)
	misn.finish(false)
end
