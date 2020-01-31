set status_bar_contexts "off espresso_menu espresso_config espresso steam_menu steam water_menu water flush_menu flush"

### status bar
.can create rect 0 [rescale_y_skin 1260] [rescale_x_skin 2560] [rescale_y_skin 1600] -fill $::color_status_bar -width 0 -tag "status_background" -state "hidden"
add_visual_items_to_contexts $status_bar_contexts "status_background" 

# Connection
set ::connection_message_background_id [rounded_rectangle $status_bar_contexts .can [rescale_x_skin 880] [rescale_y_skin 1290] [rescale_x_skin 1680] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::connection_message_text_id [add_de1_text $status_bar_contexts 1280 1430 -text "" -font $::font_setting_heading -fill $::color_temperature -anchor "center" ]

# Water
set ::refill_message_background_id [rounded_rectangle $status_bar_contexts .can [rescale_x_skin 1780] [rescale_y_skin 1290] [rescale_x_skin 2530] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::refill_message_text_id [add_de1_text $status_bar_contexts 1990 1430 -text "" -font $::font_setting_heading -fill $::color_water -anchor "center" ]

set ::water_meter [meter new -x [rescale_x_skin 2200] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue [get_max_water_level] -get_meter_value get_water_level -get_target_value get_min_water_level -show_empty_full 1 _tick_frequency [expr ($::settings(water_level_sensor_max) * 0.9 * 0.25)] -needle_color $::color_water -label_color $::color_grey_text -tick_color $::color_status_bar -contexts $status_bar_contexts -title [translate "Water"]]
add_de1_variable $status_bar_contexts -100 -100 -text "" -textvariable {[$::water_meter update]} 

# Temperature
set ::heating_message_background_id [ rounded_rectangle $status_bar_contexts .can [rescale_x_skin 30] [rescale_y_skin 1290] [rescale_x_skin 780] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::heating_message_text_id [ add_de1_text $status_bar_contexts 570 1430 -text "" -font $::font_setting_heading -fill $::color_temperature -anchor "center" ]

set ::temperature_meter [meter new -x [rescale_x_skin 80] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue 100.0 -get_meter_value get_machine_temperature -get_target_value get_min_machine_temperature -tick_frequency 10.0 -label_frequency 20 -needle_color $::color_temperature -label_color $::color_grey_text -tick_color $::color_status_bar -contexts $status_bar_contexts -title [translate "Head temperature"] -units [return_html_temperature_units]]
add_de1_variable $status_bar_contexts -100 -100 -text "" -textvariable {[$::temperature_meter update]} 

proc set_status_message_visibility {} {
	if {[is_connected]} {
		.can itemconfigure $::connection_message_background_id -fill $::color_status_bar
		.can itemconfigure $::connection_message_text_id -text ""
	} else {
		.can itemconfigure $::connection_message_background_id -fill $::color_button
		.can itemconfigure $::connection_message_text_id -text [translate "Not connected"]
	}

	if { [is_heating] } {
		.can itemconfigure $::heating_message_background_id -fill $::color_button
		.can itemconfigure $::heating_message_text_id -text [translate "Heating"]
	} else {
		.can itemconfigure $::heating_message_background_id -fill $::color_status_bar
		.can itemconfigure $::heating_message_text_id -text ""
	}

	if { [has_water] } {
		.can itemconfigure $::refill_message_background_id -fill $::color_status_bar
		.can itemconfigure $::refill_message_text_id -text ""
	} else {
		.can itemconfigure $::refill_message_background_id -fill $::color_button
		.can itemconfigure $::refill_message_text_id -text [translate "Refill water"]
	}
}
add_de1_variable $status_bar_contexts -100 -100 -text "" -textvariable {[set_status_message_visibility]}

# Display of machine state
add_de1_variable $status_bar_contexts 2550 10 -anchor "ne" -text "" -font $::font_setting_heading -fill $::color_status_bar -textvariable {[get_status_text]} 
