add_background "espresso_menu"
add_back_button "espresso_menu" [translate "espresso"]


proc create_value_button {contexts x y width label symbol color value action} {
	set font_symbol [get_font "Mazzard SemiBold" 64]
	set font_value [get_font "Mazzard SemiBold" 32]
	set font_label [get_font "Mazzard Regular" 14]

	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + $width]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $::color_menu_background
	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + 180]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $color
	add_de1_text $contexts [expr $x + 90] [expr $y + 70] -text $symbol -font $font_symbol -fill $::color_text -anchor "center" -state "hidden"
	add_de1_text $contexts [expr $x + 90] [expr $y + 170] -text $label -font $font_label -fill $::color_text -anchor "s" -state "hidden"
	add_de1_variable $contexts [expr $x + 90 + ($width / 2.0)] [expr $y + 90] -text "" -font $font_value -fill $::color_text -anchor "center" -state "hidden" -textvariable $value

	add_de1_button $contexts $action $x $y [expr $x + $width] [expr $y + 180]
}

create_value_button "espresso_menu" 80 240 2400 [translate "profile"] $::symbol_menu $::color_profile {$::settings(profile_title)} { say [translate "profile"] $::settings(sound_button_in); show_settings "settings_1" }

create_value_button "espresso_menu" 80 480 400 [translate "dose"] $::symbol_bean $::color_dose {$::metric_settings(bean_weight)g} { }
create_value_button "espresso_menu" 580 480 400 [translate "grind"] $::symbol_grind $::color_grind "15E" { }
create_value_button "espresso_menu" 1080 480 400 [translate "temp"] $::symbol_temperature $::color_temperature "90\u00B0" { }
create_value_button "espresso_menu" 1580 480 400 [translate "ratio"] $::symbol_ratio $::color_ratio {1:$::metric_settings(brew_ratio)} { }
create_value_button "espresso_menu" 2080 480 400 [translate "yield"] $::symbol_espresso $::color_yield {$::metric_settings(cup_weight)g} { }


set ::espresso_action_button_id [create_action_button "espresso_menu" 1280 1320 $::symbol_espresso $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate {start}] $::settings(sound_button_in); do_start_espresso} ""]

proc update_espresso_button {} {
	if { [can_start_espresso] } {
		update_button_color $::espresso_action_button_id $::color_action_button_start
	} else {
		update_button_color $::espresso_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "espresso_menu" -100 -100 -textvariable {[update_espresso_button]} 
