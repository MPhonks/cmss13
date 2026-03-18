/datum/tutorial/marine/ot_basic
	name = "Marine - Ordnance Tech (Basic)"
	desc = "Learn the basics of manufacture and maintenance of military-grade explosive devices."
	tutorial_id = "marine_ot_1"
	tutorial_template = /datum/map_template/tutorial/s15x10/ot
	category = TUTORIAL_CATEGORY_MARINE
	required_tutorial = "marine_basic_1"

	// Did we explain the softlock yet?
	var/softlock_explained = FALSE
	// The invisible requisitions Joe answering the softlock calls
	var/mob/living/carbon/human/synthetic/req_joe
	// How much patience does this Joe have?
	var/patience = 3
	// Calls without softlock help
	var/useless_calls = 0
	// Maximum calls (so that we don't keep spawning items in the tutorial)
	var/maximum_calls = 25

	// Autolathe stage
	var/igniter_printed = FALSE
	var/timer_printed = FALSE

/datum/tutorial/marine/ot_basic/init_mob()
	. = ..()
	arm_equipment(tutorial_mob, /datum/equipment_preset/uscm_ship/ordn)
	tutorial_mob.set_skills(/datum/skills/OT)
	tutorial_mob.job = JOB_ORDNANCE_TECH
	tutorial_mob.forceMove(get_turf(loc_from_corner(12,4))) // door to OT workshop

/datum/tutorial/marine/ot_basic/init_map()
	// There probably would have been an easier way of doing this, right?
	var/labeler = new /obj/item/tool/hand_labeler/tutorial(loc_from_corner(10, 2))
	add_to_tracking_atoms(labeler)
	var/bluespace_one = new /obj/item/reagent_container/glass/beaker/bluespace/tutorial/one(loc_from_corner(1, 2))
	add_to_tracking_atoms(bluespace_one)
	var/bluespace_two = new /obj/item/reagent_container/glass/beaker/bluespace/tutorial/two(loc_from_corner(1, 2))
	add_to_tracking_atoms(bluespace_two)
	var/bluespace_three = new /obj/item/reagent_container/glass/beaker/bluespace/tutorial/three(loc_from_corner(1, 2))
	add_to_tracking_atoms(bluespace_three)
	var/bluespace_four = new /obj/item/reagent_container/glass/beaker/bluespace/tutorial/four(loc_from_corner(1, 2))
	add_to_tracking_atoms(bluespace_four)
	var/silverbeaker = new /obj/item/reagent_container/glass/beaker/catalyst/silver/tutorial(loc_from_corner(3, 4))
	add_to_tracking_atoms(silverbeaker)

	// ...right?
	//shutter
	add_to_tracking_atoms(locate(/obj/structure/machinery/door/poddoor/shutters/almayer/tutorial/ot) in get_turf(loc_from_corner(2, 3)))
	//shutter_button
	add_to_tracking_atoms(locate(/obj/structure/machinery/door_control/tutorial/ot_shutters) in get_turf(loc_from_corner(3, 3)))
	//line_button
	add_to_tracking_atoms(locate(/obj/structure/machinery/door_control/tutorial/ot_line) in get_turf(loc_from_corner(8, 4)))
	//mortar_tv
	add_to_tracking_atoms(locate(/obj/structure/machinery/computer/cameras/wooden_tv/ot/tutorial) in get_turf(loc_from_corner(4, 2)))
	//apollo_computer
	add_to_tracking_atoms(locate(/obj/structure/machinery/computer/non_functional/apollo_controller/tutorial) in get_turf(loc_from_corner(8, 4)))
	//demo_computer
	add_to_tracking_atoms(locate(/obj/structure/machinery/computer/non_functional/demolitions_simulator/tutorial) in get_turf(loc_from_corner(9, 4)))
	//ot_phone
	add_to_tracking_atoms(locate(/obj/structure/transmitter/tutorial/ot_workshop) in get_turf(loc_from_corner(12, 3)))
	//req_phone
	add_to_tracking_atoms(locate(/obj/structure/transmitter/tutorial/ot_requisitions) in get_turf(loc_from_corner(-1, 0)))
	//autolathe
	add_to_tracking_atoms(locate(/obj/structure/machinery/autolathe/tutorial) in get_turf(loc_from_corner(12, 0)))
	//electronic_vendor
	add_to_tracking_atoms(locate(/obj/structure/machinery/cm_vending/sorted/tech/electronics_storage/tutorial) in get_turf(loc_from_corner(11, 0)))
	//armylathe
	add_to_tracking_atoms(locate(/obj/structure/machinery/autolathe/armylathe/partial/tutorial) in get_turf(loc_from_corner(10, 0)))
	//comp_vendor
	add_to_tracking_atoms(locate(/obj/structure/machinery/cm_vending/sorted/tech/comp_storage/tutorial) in get_turf(loc_from_corner(9, 0)))
	//secure_closet
	add_to_tracking_atoms(locate(/obj/structure/closet/secure_closet/tutorial) in get_turf(loc_from_corner(6, 0)))
	//grinder
	add_to_tracking_atoms(locate(/obj/structure/machinery/reagentgrinder/industrial/tutorial) in get_turf(loc_from_corner(5, 0)))
	//mixer
	add_to_tracking_atoms(locate(/obj/structure/machinery/chem_master/industry_mixer/tutorial) in get_turf(loc_from_corner(4, 0)))
	//softlock_chute
	add_to_tracking_atoms(locate(/obj/structure/machinery/disposal/delivery/tutorial) in get_turf(loc_from_corner(6, 2)))
	//delivery_chute
	add_to_tracking_atoms(locate(/obj/structure/disposaloutlet/tutorial) in get_turf(loc_from_corner(5, 2)))
	//ot_mats
	add_to_tracking_atoms(locate(/obj/structure/closet/crate/tutorial/ot_mats) in get_turf(loc_from_corner(2, 0)))
	//ot_exotics
	add_to_tracking_atoms(locate(/obj/structure/closet/crate/tutorial/ot_exotics) in get_turf(loc_from_corner(3, 0)))
	//chem_closet
	add_to_tracking_atoms(locate(/obj/structure/closet/secure_closet/engineering_materials/tutorial) in get_turf(loc_from_corner(1, 0)))
	//freezer
	add_to_tracking_atoms(locate(/obj/structure/closet/secure_closet/freezer/industry/tutorial) in get_turf(loc_from_corner(3, 4)))
	//bio_closet
	add_to_tracking_atoms(locate(/obj/structure/closet/l3closet/tutorial) in get_turf(loc_from_corner(3, 7)))
	//pacid
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/pacid/tutorial) in get_turf(loc_from_corner(0, 7)))
	//amonia
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/ammonia/tutorial) in get_turf(loc_from_corner(1, 7)))
	//fuel
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/tutorial) in get_turf(loc_from_corner(2, 7)))
	//sacid
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/sacid/tutorial) in get_turf(loc_from_corner(5, 7)))
	//hydrogen
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/gas/hydrogen/tutorial) in get_turf(loc_from_corner(5, 4)))
	//methane
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/gas/methane/tutorial) in get_turf(loc_from_corner(1, 4)))
	//oxygen
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/oxygentank/tutorial) in get_turf(loc_from_corner(0, 4)))
	//custom_north
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/custom/tutorial/north) in get_turf(loc_from_corner(4, 7)))
	//custom_south
	add_to_tracking_atoms(locate(/obj/structure/reagent_dispensers/tank/fuel/custom/tutorial/south) in get_turf(loc_from_corner(4, 4)))

/datum/tutorial/marine/ot_basic/proc/init_npcs()
	req_joe = new(loc_from_corner(-1, 0))
	arm_equipment(req_joe, /datum/equipment_preset/synth/working_joe)
	req_joe.name = "Requisitions Joe"
	req_joe.alpha = 0

/datum/tutorial/marine/ot_basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	init_npcs()
	message_to_player("Welcome to the basic tutorial of the Ordnance Technician role, where the real threats are made and mantained.")
	addtimer(CALLBACK(src, PROC_REF(softlock_explanation)), 4 SECONDS)

/datum/tutorial/marine/ot_basic/proc/softlock_explanation()
	message_to_player("To begin, direct your attention at the phone to the right. Should you ever need something in the tutorial that no longer exists, you can \"order\" it from requisitions. Try ordering... pizza.")
	update_objective("Use the phone, call requisitions, and ask for some fresh \"pizza\"!")

	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_workshop, ot_phone)
	add_highlight(ot_phone)
	RegisterSignal(ot_phone, COMSIG_TRANSMITTER_UPDATE_ICON, PROC_REF(handle_phone))

/datum/tutorial/marine/ot_basic/proc/phone_softlock_pizza(mob/speaking, message, datum/language/L)
	var/has_phone = FALSE
	var/obj/active_item = tutorial_mob.get_active_hand()
	var/obj/inactive_item = tutorial_mob.get_inactive_hand()
	if (active_item != null && istype(active_item, /obj/item/phone))
		has_phone = TRUE
	if (inactive_item != null && istype(inactive_item, /obj/item/phone))
		has_phone = TRUE

	if(has_phone && findtext(message, "pizza"))
		message_to_player("Well done. Your mystery pizza should arrive shortly (look to your left)!")
		TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_workshop, ot_phone)
		remove_highlight(ot_phone)
		softlock_explained = TRUE
		addtimer(CALLBACK(src, PROC_REF(accept_vend_request), /obj/item/pizzabox/mystery), 2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(workshop_tutorial)), 10 SECONDS)

/datum/tutorial/marine/ot_basic/proc/workshop_tutorial()
	message_to_player("This is a smaller version of your actual workshop. Outside of the tutorial, you can find it south of medbay, on the first floor of the USS Almayer.")
	addtimer(CALLBACK(src, PROC_REF(vendor_tutorial)), 4 SECONDS)

/datum/tutorial/marine/ot_basic/proc/vendor_tutorial()
	message_to_player("Start by creating an assembly. Find the autolathe, vend an igniter, and a timer.")
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/autolathe/tutorial, autolathe)
	add_highlight(autolathe)
	RegisterSignal(autolathe, COMSIG_ACTION_ACTIVATED)

/datum/tutorial/check

// --- Phone Stuff ---
/datum/tutorial/marine/ot_basic/proc/handle_phone()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_workshop, ot_phone)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_requisitions, req_phone)
	if(ot_phone.icon_state != "wall_phone")
		UnregisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK)
		var/joe_has_phone = FALSE
		var/obj/active_item = req_joe.get_active_hand()
		if (active_item != null && istype(active_item, /obj/item/phone))
			joe_has_phone = TRUE
		if (joe_has_phone)
			req_phone.attackby(active_item, req_joe)
	else
		addtimer(CALLBACK(src, PROC_REF(joe_pickup_phone)), 2 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(phone_talk_start)), 2 SECONDS)

/datum/tutorial/marine/ot_basic/proc/phone_talk_start()
	if (!softlock_explained)
		RegisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK, PROC_REF(phone_softlock_pizza))

/datum/tutorial/marine/ot_basic/proc/joe_pickup_phone()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_requisitions, ot_phone)
	if (ot_phone.icon_state == "wall_phone")
		return
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/transmitter/tutorial/ot_requisitions, req_phone)
	req_phone.attack_hand(req_joe)
	playsound(get_turf(tutorial_mob), 'sound/voice/joe/hello.ogg', 100)
	req_joe.say("Hello.")

/datum/tutorial/marine/ot_basic/proc/accept_vend_request(item_path)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/disposaloutlet/tutorial, softlock_vender)
	add_highlight(softlock_vender)
	req_joe.say("Let me help you.")
	playsound(get_turf(tutorial_mob), 'sound/voice/joe/let_me_help.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(vend_item), item_path), 4 SECONDS)

/datum/tutorial/marine/ot_basic/proc/vend_item(item_path)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/disposaloutlet/tutorial, softlock_vender)
	softlock_vender.pipe_eject()
	remove_highlight(softlock_vender)
	new item_path(loc_from_corner(5, 2))
