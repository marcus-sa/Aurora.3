/obj/item/device/megaphone
	name = "megaphone"
	desc = "A device used to project your voice. Loudly."
	icon_state = "megaphone"
	item_state = "megaphone"
	w_class = ITEMSIZE_SMALL
	flags = CONDUCT

	var/spamcheck = 0
	var/emagged = 0
	var/insults = 0
	var/list/insultmsg = list("FUCK EVERYONE!", "I'M A TATER!", "ALL SECURITY TO SHOOT ME ON SIGHT!", "I HAVE A BOMB!", "CAPTAIN IS A COMDOM!", "FOR THE SYNDICATE!")
	var/activation_sound = 'sound/items/megaphone.ogg'
	var/needs_user_location = TRUE

/obj/item/device/megaphone/attack_self(mob/living/user as mob)
	if (user.client)
		if(user.client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	if(!ishuman(user))
		to_chat(user, "<span class='warning'>You don't know how to use this!</span>")
		return
	if(user.silent)
		return
	if(spamcheck)
		to_chat(user, "<span class='warning'>\The [src] needs to recharge!</span>")
		return

	var/message = sanitize(input(user, "Shout a message?", "Megaphone", null)  as text)
	if(!message)
		return
	message = capitalize(message)
	if ((user.stat == CONSCIOUS))
		if(needs_user_location)
			if(!src.loc == user)
				return
		if(emagged)
			if(insults)
				user.visible_message("<B>[user]</B> broadcasts, <FONT size=3>\"[pick(insultmsg)]\"</FONT>")
				insults--
			else
				to_chat(user, "<span class='warning'>*BZZZZzzzzzt*</span>")
		else
			user.visible_message("<B>[user]</B> broadcasts, <FONT size=3>\"[message]\"</FONT>")
		if(activation_sound)
			playsound(loc, activation_sound, 100, 0, 1)
		spamcheck = 1
		spawn(20)
			spamcheck = 0
		return

/obj/item/device/megaphone/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		to_chat(user, "<span class='warning'>You overload \the [src]'s voice synthesizer.</span>")
		emagged = 1
		insults = rand(1, 3)//to prevent dickflooding
		return 1
