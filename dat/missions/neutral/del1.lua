--[[

	Del's mission or something

	Author: Del

   Basic plot: Someone hails you and tells you to move some stuff from Eclipse to Cluster One. You go to Eclipse and its TODO an Empire ship (?). And you find something but trip an alarm and youre attacked. Then you go to Toaxis to and are hailed by drone Jessica to go to Ingot and it self-destructs. You go to Ingot and monies come.

]]--

-- localization stuff, translators would work here
lang = naev.lang()
if lang == "es" then
else -- default english
	NPC_desc = "You notice a perfect stranger seemingly inviting you to come over to his booth."
	misn_title = "Del" -- TODO
	misn_reward = [["It's a gas"]]
	misn_desc = "A foreigner gave you a mysterious mission." -- Lol change this
	credits = 120000 -- Oooh may be adjustable maybe
	title = {}
	title[1] = "Money for nothing"
	title[2] = "X" -- TODO
	title[3] = "Y" -- TODO
	title[4] = "Mission Accomplished"
	
	shipname1 = "Eclipse" -- "Abandoned" ship
	shipname2 = "Jessica" -- Drone informant boi
	shipname3 = "Cluster One" -- "New" ship/baddie ship

	sysname1 = "Sigur" -- Where Eclipse is TODO maybe change it
	sysname2 = "Toaxis" -- Where Cluster One is supposed to be
	sysname3 = "Ingot" -- Where Cluster One is
	
	text = {}
	text[1] = [[Move some stuff from Eclipse to Cluster One.]]
	text[2] = [[Boarding Eclipse. You see a note left by someone telling you to take X. Its suspicious that its an Empire ship. As you undock you see empire ships in the distance.]]
	text[3] = [["Hello this is an automated message.." Jessicas message to tell you that you go to Ingot lol "Self-destruct in 10"]]
	text[4] = [[Gratz have monies. AND HE HAS A CAT THE PERSON WHO IS THERE]]

	osd_title = "Del"

   osd_msg = {}
	osd_msg[1] = "Go to Eclipse in Sigur"
	osd_msg[2] = "Go to Cluster One in Toadis"

	osd_xmsg = "Go to Cluster One in Ingot"

	refusetitle = "Loser"
	refusetext = "Ownt"

	acceptbutton = "Accept"
	declinebutton = "Decline"
end

function create ()
	if tk.choice(title[1], text[1], acceptbutton, declinebutton) == 1 then
		accept()
	else
		tk.msg(refusetitle, refusetext)
		abort()
	end
end

function accept()
	tk.msg(title[2], string.format(text[2]))

	misn.accept()

	var.push("del1Progress", 1) -- DONT KNOW IF THIS WILL WORK LOL TODO change name

	misn.setTitle(misn_title)
	misn.setReward(misn_reward)
	misn.setDesc(misn_desc)

	osd_msg1 = string.format(osd_msg[1])
	osd_msg2 = string.format(osd_msg[2])
	misn.osdCreate(osd_title, {osd_msg1, osd_msg2})
	misn.osdActive(1)

	misn.setMarker(system.get(sysname1), "misc")

	talked=false
	stopping=false

	hook.land("land")
	hook.jumpin("jumpin")
	hook.takeoff("takeoff")
	hook.enter("enter")
end

function enter()
	if del1progress == 1 and system.get() == sysname1 then
		eclipse = pilot.add("Empire Pacifier", "def")
			eclipse:rename(shipname1)

			eclipse:setFaction(faction.get("Independent"))

			eclipse:disable()
			eclipse:setInvincible(true)

		hook.pilot(eclipse, "board", "board")
		hook.pilot(eclipse, "death", "abort")
	end
end

function board()
	tk.msg(title[2], string.format(text[2]))
	
	carg_id = misn.addCargo("X", 0) -- TODO name this thing

	del1progress = 2

	misn.osdActive(2)
	misn.setMarker(system.get(sysname2), "misc")

	player.unboard()
end

function unboard()
	lancelot = pilot.add("Empire Lancelot", "def", vec2.new(-500,0))
		lancelot:setFaction(faction.get("Empire"))
		lancelot:rename("Empire FAST RESPONSE SUPER COMMANDO TURBO NUTTER UNIT Lancelot")
		lancelot:setHostile() -- TODO maybe make it broadcast something funny
end

function enter()
	if del1progress == 2 and system.get() == sysname2 then
		jessica = pilot.add("Trader Llama", "def", vec2.new(0, 500))
			jessica:setFaction(faction.get("Independent"))
			jessica:rename(shipname2)
			jessica:hailPlayer()
				hook.pilot(jessica, "hail", "hail")
   end
end
-- TODO THIS MUST BE BROKEN
function hail()
	tk.msg(title[3], string.format(text[3]))

	misn.osdDestroy()

	osd_msg1 = string.format(osd_msg[1])
	osd_msg2 = string.format(osd_msg[2])
	osd_xmsg = string.format(osd_xmsg)
	misn.osdCreate(osd_title, {osd_msg1, osd_msg2, osd_xmsg})
	misn.osdActive(3)

   var.push("del1progress", 3)

	jessica:setHealth(0,0)
	
	evt.finish(true)
end
--[[ 100% brokenness may or may not end here. Should I add anything to segue to the next event? And it probably wont self-destruct ]]--

function enter()
	if del1progress == 3 and system.get() == sysname3 then
		cluster = pilot.add("Trader Quicksilver", "trader", vec2.new(-400,-400), false)
			cluster:setFaction("Independent")
			cluster:rename(shipname3)
			cluster:setInvincible()
			cluster:control()
			cluster:goto(vec2.new( 400, -400), false)
			hook.pilot(cluster, "idle", "idle")
			hook.pilot(cluster, "hail", "hail")
	end
end

function idle()
	if stopping then
		cluster:disable()
	else
		cluster:goto(vec2.new( 400,  400), false)
		cluster:goto(vec2.new(-400,  400), false)
		cluster:goto(vec2.new(-400, -400), false)
		cluster:goto(vec2.new( 400, -400), false)
	end
end

function hail()
	if talked then
		cluster:cleartask()
		cluster:brake()
		stopping = true
		hook.pilot(cluster, "board", "board")
    end
end

function board()
	tk.msg(title[4], string.format(text[4]))
	player.pay( credits )
	player.refuel()
	player.unboard()
	cluster:setHealth(100, 100)
	cluster:control(false)
	cluster:changeAI("flee")
	misn.finish(true)
end
