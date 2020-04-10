set status_meter_contexts "off espresso_menu espresso_menu_dose espresso_menu_ratio espresso_menu_yield steam_menu steam water_menu water flush_menu flush"
set status_message_contexts "off espresso_menu espresso_menu_dose espresso_menu_ratio espresso_menu_yield espresso espresso_done steam_menu steam water_menu water flush_menu flush"

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

# status message
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
add_de1_variable $status_message_contexts 2550 10 -anchor "ne" -text "" -font $::font_setting_heading -fill $::color_status_bar -textvariable {[get_status_text]} 
