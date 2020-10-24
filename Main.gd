extends Node

export (PackedScene) var Mission

var mute = false
var mission = preload("res://Mission.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	$IntroEnd.new_game()
	$System.init()

func connections():
	$Office/HUDLayer/HUDOffice.connect("see_missionIntro", self, "mission_intro", [mission])
	$Office/HUDLayer/HUDOffice.connect("mission_accepted", self, "mission_accepte", [mission])
	$Office/HUDLayer/HUDOffice.connect("see_mission", mission, "show_text_mission")
	$Office/HUDLayer/HUDOffice.connect("see_system", self, "go_to_system", [mission])
	$System/HUDLayer/HUDSystem.connect("mission_finished", self, "mission_validated", [mission])
	$Office/HUDLayer/HUDOffice.connect("thanks_ended", self, "mission_finished", [mission])

func start_scenario():
	connections()
	add_child(mission)
	
	create_mission_1()
	$Office.new_mission()
	yield($EntreMissions, "timeout")
	$EntreMissions.stop()
	
	create_mission_2()
	$System.reinit()
	$Office.new_mission()
	yield($EntreMissions, "timeout")
	$EntreMissions.stop()
	
	create_mission_3()
	$System.reinit()
	$Office.new_mission()
	yield($EntreMissions, "timeout")
	$EntreMissions.stop()
	
	$System.my_free()
	end_game()

func go_to_system(_mission):
	var money = int($Office/HUDLayer/HUDOffice.get_money())
	$System/HUDLayer/HUDSystem.give_money_value(money)
	$Office.hide_buttons()
	$Office/HUDLayer/HUDOffice.hide_prestige()
	$System.show()
	_mission.hide()
	_mission.hide_alien()
	
func mission_intro(_mission):
	_mission.show_intro_mission()
	$Office/HUDLayer/HUDOffice.show_ordi_accept()
	
func mission_accepte(_mission):
	_mission.hide()
	$Office/HUDLayer/HUDOffice.mission_accepted(mission)
	
func mission_validated(text, tmp_min, tmp_max, gas, _mission):
	$System.hide()
	$Office.show()
	var prestige = _mission.show_ending_mission(tmp_min, tmp_max, gas)
	var coef_prestige = _mission.get_coef_prestige()
	$Office/HUDLayer/HUDOffice.mission_validated(text, prestige, coef_prestige)

func mission_finished(_mission):
	_mission.hide()
	_mission.hide_alien()
	startTimer()

func end_game():
	$System.hide()
	$Office.hide()
	var pres = $Office/HUDLayer/HUDOffice.get_prestige()
	var money = $Office/HUDLayer/HUDOffice.get_money()
	$IntroEnd.comment_result(pres, 5, money, 1400)
	$Office/HUDLayer/HUDOffice.endgame()
	$IntroEnd.connect("start_new_game", self, "_ready")

func startTimer():
	$EntreMissions.start()

# =============
# = Callbacks =
# =============

func _on_Office_animation_finished():
	start_scenario()

func _on_BeforeAnimOrdi_timeout():
	$BeforeAnimOrdi.stop()
	$Office/HUDLayer/HUDOffice.start_anim_ordi()

func _on_HUD_start_game():
	$Office.show()
	$BeforeAnimOrdi.start()

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_M:
		if mute == false:
			AudioServer.set_bus_mute(0,true)
			mute = true
		else:
			AudioServer.set_bus_mute(0,false)
			mute = false

# ====================
# = List of missions =
# ====================

func create_mission_1():
	var descri = "Excuse me, I’m wondering if you can help me. You see, the Xenomorphs have destroyed my home planet following a misunderstanding about a certain “spud-gun”. It isn’t a weapon, rest assured… \nWould you be so kind as to find us a planet rich in Oxygen, with a nice and welcoming climate averaging about 20°C ? If it’s not too much to ask, that is."
	mission.update_descr(descri)
	var thanksBien = "Thank you so much! Oh and please don’t mention our new planet to the Xenomorphs."
	var thanksNuls = "Hum... well, I may have asked too much. \nBut please don’t mention our new planet to the Xenomorphs."
	mission.update_thank(thanksBien, thanksNuls)
	mission.update_values(-60, 100, 20, "Oxygen", 700, 1, "res://assets/aliens/alien_ET.png")
	mission.set_intro_sound("res://assets/sounds/ET.wav")
	
func create_mission_2():
	var descri = "Don’t run, I am your friend ! I have a simple mission for you ! I’m looking for a new planet in order to please my superior kind. Some place where we could breathe pure nitrogen, with a nice, fresh tropical climate would be fine. Minus 50° would be the least you can do.\nNow hurry up you punk, my palace won’t build itself up !"
	mission.update_descr(descri)
	var thanksBien = "Not bad, friend, come visit my palace if you get the chance."
	var thanksNuls = "Just asking for a friend... how strong is your army?"
	mission.update_thank(thanksBien, thanksNuls)
	mission.update_values(-100, 0, -50, "Nitrogen", 400, 2, "res://assets/aliens/alien_mars_double.png")
	mission.set_intro_sound("res://assets/sounds/martian.wav")
	
func create_mission_3():
	var descri = "YOU THERE! MY PLANET HAS BEEN DESTROYED DUE TO SOME FILTHY MAGGOTS’ DECEPTION. FIND US A NEW PLANET FROM WHICH I CAN ANNIHILATE THEM WITH XENON. FAR CLOSE TO THE SUN, WE DON’T LIKE THE COLD, SO MAKE IT 120°C, YOU HEAR?! AND HURRY UP OR YOUR MANGY OFFICE WILL\nSUFFER THE SAME\nFATE AS THE\nCREATORS!!"
	mission.update_descr(descri)
	var thanksBien = "PERHAPS YOU AREN’T AS USELESS AS YOU SEEM !\nNOW TELL ME, HAS A SMALL SPECIES WITH LIGHT-UP FINGERS BEEN THROUGH HERE?"
	var thanksNuls = "DIE!!!!"
	mission.update_thank(thanksBien, thanksNuls)
	mission.update_values(80, 160, 120, "Xenon", 300, 3,  "res://assets/aliens/alien_xenomorph_half.png")
	mission.set_intro_sound("res://assets/sounds/xenomorph.wav")
