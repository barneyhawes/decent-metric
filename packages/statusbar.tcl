set status_meter_contexts "off espresso_menu_profile espresso_menu_beans espresso_menu_grind espresso_menu_dose espresso_menu_ratio espresso_menu_yield espresso_menu_temperature espresso_done steam_menu steam water_menu water flush_menu flush"

# Water
set water_meter_background_id [.can create oval [rescale_x_skin 2140] [rescale_y_skin 1230] [rescale_x_skin 2580] [rescale_y_skin 1670] -fill $::color_status_bar -width 0 -state "hidden"]
add_visual_items_to_contexts $status_meter_contexts $water_meter_background_id

set ::water_meter [meter new -x [rescale_x_skin 2220] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue [get_max_water_level] -get_meter_value get_water_level -get_target_value get_min_water_level -show_empty_full 1 _tick_frequency [expr ($::settings(water_level_sensor_max) * 0.9 * 0.25)] -needle_color $::color_water -label_color $::color_meter_grey -tick_color $::color_status_bar -contexts $status_meter_contexts -title [translate "Water"]]
add_de1_variable $status_meter_contexts -100 -100 -text "" -textvariable {[$::water_meter update]} 

# Temperature
set temperate_meter_background_id [.can create oval [rescale_x_skin -20] [rescale_y_skin 1230] [rescale_x_skin 420] [rescale_y_skin 1670] -fill $::color_status_bar -width 0 -state "hidden"]
add_visual_items_to_contexts $status_meter_contexts $temperate_meter_background_id

set ::temperature_meter [meter new -x [rescale_x_skin 60] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue 100.0 -get_meter_value get_machine_temperature -get_target_value get_min_machine_temperature -tick_frequency 10.0 -label_frequency 20 -needle_color $::color_temperature -label_color $::color_meter_grey -tick_color $::color_status_bar -contexts $status_meter_contexts -title [translate "Head temperature"] -units [return_html_temperature_units]]
add_de1_variable $status_meter_contexts -100 -100 -text "" -textvariable {[$::temperature_meter update]} 

# Function bar
set status_function_contexts "off espresso_done steam_menu water_menu flush_menu"
proc create_symbol_button {contexts x y width height symbol label action} {
	set font_symbol [get_font "Mazzard SemiBold" 64]
	set font_label [get_font "Mazzard Regular" 14]
	add_de1_text $contexts [expr $x + ($width / 2.0)] [expr $y + ($height / 2) - 40] -text $symbol -font $font_symbol -fill $::color_text -anchor "center" -state "hidden"

	add_de1_text $contexts [expr $x + ($width / 2.0)] [expr $y + $height - 40] -text $label -font $font_label -fill $::color_text -anchor "s" -state "hidden"
	add_de1_button $contexts $action $x $y [expr $x + $width] [expr $y + $height]
}

rounded_rectangle $status_function_contexts .can [rescale_x_skin 520] [rescale_y_skin 1380] [rescale_x_skin 1000] [rescale_y_skin 2680] [rescale_x_skin 80] $::color_menu_background
create_symbol_button $status_function_contexts 520 1400 250 220 $::symbol_steam [translate "steam"] {say [translate "steam"] $::settings(sound_button_in); metric_jump_to "steam"; do_start_steam}
create_symbol_button $status_function_contexts 750 1400 250 220 $::symbol_water [translate "water"] {say [translate "water"] $::settings(sound_button_in); metric_jump_to "water_menu" }

rounded_rectangle $status_function_contexts .can [rescale_x_skin 1560] [rescale_y_skin 1380] [rescale_x_skin 2040] [rescale_y_skin 2680] [rescale_x_skin 80] $::color_menu_background
create_symbol_button $status_function_contexts 1560 1400 250 220 $::symbol_flush [translate "flush"] {say [translate "flush"] $::settings(sound_button_in); metric_jump_to "flush"; do_start_flush }
create_symbol_button $status_function_contexts 1780 1400 250 220 $::symbol_settings [translate "settings"] { say [translate "settings"] $::settings(sound_button_in); show_settings; metric_load_profile $::settings(profile_filename) }

rounded_rectangle "espresso_done water_menu" .can [rescale_x_skin 1140] [rescale_y_skin 1380] [rescale_x_skin 1420] [rescale_y_skin 2680] [rescale_x_skin 80] $::color_menu_background
create_symbol_button "espresso_done water_menu" 1155 1400 250 220 $::symbol_espresso [translate "espresso"] {say [translate "espresso"] $::settings(sound_button_in); metric_jump_home }

create_button "off" 2400 20 2500 120 "sleep" [get_font "Mazzard Regular" 14] $::color_menu_background $::color_text { say [translate "settings"] $::settings(sound_button_in); start_sleep }

# status message
set status_message_contexts "off espresso_menu_profile espresso_menu_beans espresso_menu_grind espresso_menu_dose espresso_menu_ratio espresso_menu_yield espresso_menu_temperature espresso espresso_done steam_menu steam water_menu water flush_menu flush"
set ::connection_message_background_id [rounded_rectangle $status_message_contexts .can [rescale_x_skin 880] [rescale_y_skin 1430] [rescale_x_skin 1680] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::connection_message_text_id [add_de1_text $status_message_contexts 1280 1500 -text "" -font $::font_setting_heading -fill $::color_temperature -anchor "center" ]

proc set_status_message_visibility {} {
	if {![is_connected]} {
		.can itemconfigure $::connection_message_background_id -state ""
		.can itemconfigure $::connection_message_text_id -text [translate "Not connected"]
	} elseif {![has_water]} {
		.can itemconfigure $::connection_message_background_id -state ""
		.can itemconfigure $::connection_message_text_id -text [translate "Refill water"]
	} elseif {[is_heating]} {
		.can itemconfigure $::connection_message_background_id -state ""
		.can itemconfigure $::connection_message_text_id -text [translate "Heating"]
	} else {
		.can itemconfigure $::connection_message_background_id -state "hidden"
		.can itemconfigure $::connection_message_text_id -text ""
	}
}
add_de1_variable $status_message_contexts -100 -100 -text "" -textvariable {[set_status_message_visibility]}

# Display of machine state (mostly for debugging)
#add_de1_variable $status_message_contexts 2550 10 -anchor "ne" -text "" -font $::font_setting_heading -fill $::color_status_bar -textvariable {[get_status_text]} 
