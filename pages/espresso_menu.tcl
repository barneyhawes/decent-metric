set espresso_contexts "espresso_menu espresso_menu_profile espresso_menu_dose espresso_menu_ratio espresso_menu_yield"
set espresso_setting_contexts "espresso_menu espresso_menu_dose espresso_menu_ratio espresso_menu_yield"
add_background $espresso_contexts
add_back_button $espresso_setting_contexts [translate "espresso"]
add_back_button espresso_menu_profile [translate "choose profile"]
#TODO: dose back button behaviour

proc create_value_button {contexts x y width label symbol color value action} {
	set font_symbol [get_font "Mazzard SemiBold" 64]
	set font_value [get_font "Mazzard Regular" 32]
	set font_label [get_font "Mazzard Regular" 14]

	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + $width]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $::color_menu_background
	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + 180]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $color
	add_de1_text $contexts [expr $x + 90] [expr $y + 70] -text $symbol -font $font_symbol -fill $::color_text -anchor "center" -state "hidden"
	add_de1_text $contexts [expr $x + 90] [expr $y + 170] -text $label -font $font_label -fill $::color_text -anchor "s" -state "hidden"
	add_de1_variable $contexts [expr $x + 90 + ($width / 2.0)] [expr $y + 90] -text "" -font $font_value -fill $::color_text -anchor "center" -state "hidden" -textvariable $value

	add_de1_button $contexts $action $x $y [expr $x + $width] [expr $y + 180]
}

proc create_2value_label {contexts x y value1 value2} {
	set font_value [get_font "Mazzard Regular" 32]
	set font_value_small [get_font "Mazzard Regular" 22]

	add_de1_variable $contexts $x $y -text "" -font $font_value -fill $::color_text -anchor "e" -state "hidden" -textvariable $value1
	add_de1_variable $contexts $x [expr $y + 38] -text "" -font $font_value_small -fill $::color_text -anchor "sw" -state "hidden" -textvariable $value2
}


proc create_2value_button {contexts x y width label symbol color value1 value2 action} {
	set font_symbol [get_font "Mazzard SemiBold" 64]
	set font_value [get_font "Mazzard Regular" 32]
	set font_value_small [get_font "Mazzard Regular" 22]
	set font_label [get_font "Mazzard Regular" 14]

	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + $width]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $::color_menu_background
	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin $y] [rescale_x_skin [expr $x + 180]] [rescale_y_skin [expr $y + 180]] [rescale_x_skin 30] $color
	add_de1_text $contexts [expr $x + 90] [expr $y + 70] -text $symbol -font $font_symbol -fill $::color_text -anchor "center" -state "hidden"
	add_de1_text $contexts [expr $x + 90] [expr $y + 170] -text $label -font $font_label -fill $::color_text -anchor "s" -state "hidden"
	create_2value_label $contexts [expr $x + 90 + ($width / 2.0)] [expr $y + 90] $value1 $value2

	add_de1_button $contexts $action $x $y [expr $x + $width] [expr $y + 180]
}

proc create_arrow_button { contexts x y size thickness direction action } {
	set dx [expr $size * 0.5]
	set dy [expr $size * 0.25]
	set margin 20
	set arrow_id [.can create line [rescale_x_skin [expr $x - $dx]] [rescale_y_skin [expr $y + ($dy * $direction)]] [rescale_x_skin $x] [rescale_y_skin [expr $y - ($dy * $direction)]] [rescale_x_skin [expr $x + $dx]] [rescale_y_skin [expr $y + ($dy * $direction)]] -width [rescale_x_skin $thickness] -fill $::color_arrow -state hidden]
	add_visual_items_to_contexts $contexts $arrow_id
	add_de1_button $contexts $action [expr $x - $dx -$margin] [expr $y - $dy - $margin] [expr $x + $dx + $margin] [expr $y + $dy + $margin]
}

proc create_arrow_buttons { contexts x y varname smalldelta largedelta minval maxval after_adjust_action} {
	rounded_rectangle $contexts .can [rescale_x_skin $x] [rescale_y_skin [expr $y - 290]] [rescale_x_skin [expr $x + 400]] [rescale_y_skin [expr $y + 290]] [rescale_x_skin 80] $::color_menu_background
	create_arrow_button $contexts [expr $x + 200] [expr $y - 220] 100 12 1 "say \"up\" $::settings(sound_button_in); adjust_setting $varname $largedelta $minval $maxval; $after_adjust_action"
	create_arrow_button $contexts [expr $x + 200] [expr $y - 140] 60 8 1 "say \"up\" $::settings(sound_button_in); adjust_setting $varname $smalldelta $minval $maxval; $after_adjust_action"
	create_arrow_button $contexts [expr $x + 200] [expr $y + 140] 60 8 -1 "say \"down\" $::settings(sound_button_in); adjust_setting $varname -$smalldelta $minval $maxval; $after_adjust_action"
	create_arrow_button $contexts [expr $x + 200] [expr $y + 220] 100 12 -1 "say \"down\" $::settings(sound_button_in); adjust_setting $varname -$largedelta $minval $maxval; $after_adjust_action"
}

create_value_button $espresso_setting_contexts 80 240 2400 [translate "profile"] $::symbol_menu $::color_profile {$::metric_settings(espresso_profile_title)} { say [translate "profile"] $::settings(sound_button_in); fill_metric_profiles_listbox; metric_jump_to "espresso_menu_profile"; set_metric_profiles_scrollbar_dimensions; select_metric_profile}

proc get_profile_title { profile_filename } {
	set file_path "[homedir]/profiles/$profile_filename.tcl"
	set file_data [encoding convertfrom utf-8 [read_binary_file $file_path]]
	catch {
		array set profile_data $file_data
	}

	if {[array exists profile_data] == 0} {
		return ""
	}

	set profile_title $profile_data(profile_title)
	set profile_title [translate $profile_title]

	return $profile_title
}

proc metric_profile_changed {} {
	if {[ifexists ::filling_profiles] == 1} {
		return
	}

	set widget $::globals(metric_profiles_listbox)
	set selected_index [$widget curselection]

	if {$selected_index != ""} {
		set ::metric_settings(espresso_profile_filename) $::profile_number_to_directory($selected_index) 
		set ::metric_settings(espresso_profile_title) [get_profile_title $::metric_settings(espresso_profile_filename)]
		save_metric_settings

		select_profile $::metric_settings(espresso_profile_filename)

		# send the settings to DE1. 
		# This is necessary because select_profile will not send settings to non-GHC machines (possibile improvement to DE1 core code?)
		# As well as ensuring the profile is loaded up when Start is pressed, this will start/stop preheating the water tank right away if required.
		save_settings_to_de1

		metric_jump_back
	}
}

# select the listbox item corresponding to the profile specified in metric settings
proc select_metric_profile {} {
	set itemcount [array size profile_number_to_directory]
	if {$itemcount == 0} {
		return
	}

	set selected_index 0
	for {set index 0} {$index < $itemcount} {incr index} {
		if {$::profile_number_to_directory($selected_index) == $::metric_settings(espresso_profile_filename)} {
			set selected_index $index
			continue
		}
	}

	set ::filling_profiles 1
	$::globals(metric_profiles_listbox) selection set $selected_index
	unset -nocomplain ::filling_profiles
}

# populate the listbox with profiles
proc fill_metric_profiles_listbox { } {
	set widget $::globals(metric_profiles_listbox)

	if {[ifexists ::metric_settings(espresso_profile_title)] == ""} {
		set ::metric_settings(espresso_profile_title) $::settings(profile_title)
		save_metric_settings
	}

	set ::filling_profiles 1
	set profile_index [fill_specific_profiles_listbox $widget $::metric_settings(espresso_profile_title) 0]
	$widget selection set $profile_index
	unset -nocomplain ::filling_profiles

	if {$profile_index > 5} {
		$widget see $profile_index
	}

	if {[ifexists ::metric_settings(espresso_profile_filename)] == ""} {
		metric_profile_changed
	}
}

add_de1_widget "espresso_menu_profile" listbox 80 240 {
		set ::globals(metric_profiles_listbox) $widget
	 	fill_metric_profiles_listbox
		bind $::globals(metric_profiles_listbox) <<ListboxSelect>> ::metric_profile_changed
	 } -background $::color_background -foreground $::color_text -selectbackground $::color_menu_background -font [get_font "Mazzard Regular" 32] -bd 0 -height [expr {int(15 * $::globals(listbox_length_multiplier))}] -width 45 -borderwidth 0 -selectborderwidth 0  -relief flat -highlightthickness 0 -selectmode single -xscrollcommand {scale_prevent_horiz_scroll $::globals(metric_profiles_listbox)} -yscrollcommand {scale_scroll_new $::globals(metric_profiles_listbox) ::metric_profiles_slider}   

set ::metric_profiles_slider 0

# draw the scrollbar off screen so that it gets resized and moved to the right place on the first draw
set ::metric_profiles_scrollbar [add_de1_widget "espresso_menu_profile" scale 10000 1 {} -from 0 -to 1 -bigincrement 0.2 -background $::color_background -borderwidth 1 -showvalue 0 -resolution .01 -length [rescale_x_skin 400] -width [rescale_y_skin 150] -variable ::metric_profiles_slider -font Helv_10_bold -sliderlength [rescale_x_skin 125] -relief flat -command {listbox_moveto $::globals(metric_profiles_listbox) $::metric_profiles_slider} -foreground $::color_background -troughcolor $::color_menu_background -borderwidth 0 -highlightthickness 0]

proc set_metric_profiles_scrollbar_dimensions {} {
	# set the height of the scrollbar to be the same as the listbox
	$::metric_profiles_scrollbar configure -length [winfo height $::globals(metric_profiles_listbox)]
	set coords [.can coords $::globals(metric_profiles_listbox) ]
	set newx [expr {[winfo width $::globals(metric_profiles_listbox)] + [lindex $coords 0]}]
	.can coords $::metric_profiles_scrollbar "$newx [lindex $coords 1]"
}



proc get_exponent {value} {
	#TODO error check value contains a decimal
	#TODO limit decimal places
	return [lindex [split $value "."] 1]
}
proc get_mantissa {value} {
	#TODO error check value contains a decimal
	return [lindex [split $value "."] 0]
}

# config
set x 80
set y 770

create_arrow_buttons "espresso_menu_dose" $x $y "::metric_settings(bean_weight)" 0.1 1 $::metric_setting_dose_min $::metric_setting_dose_max metric_dose_changed
create_2value_button $espresso_setting_contexts $x [expr $y -90] 400 [translate "dose"] $::symbol_bean $::color_dose {[get_mantissa $::metric_settings(bean_weight)]} {.[get_exponent $::metric_settings(bean_weight)]g} {say [translate "dose"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu_dose"}
add_de1_button "espresso_menu_dose" {say [translate "close"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu"} $x [expr $y - 90] [expr $x + 400] [expr $y + 90]

incr x 500
create_arrow_buttons "espresso_menu_ratio" $x $y "::metric_settings(brew_ratio)" 0.1 1 $::::metric_setting_ratio_min $::metric_setting_ratio_max metric_ratio_changed
create_2value_button $espresso_setting_contexts $x [expr $y -90] 400 [translate "ratio"] $::symbol_ratio $::color_ratio {1:[get_mantissa $::metric_settings(brew_ratio)]} {.[get_exponent $::metric_settings(brew_ratio)]} {say [translate "ratio"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu_ratio"}
add_de1_button "espresso_menu_ratio" {say [translate "close"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu"} $x [expr $y - 90] [expr $x + 400] [expr $y + 90]

incr x 500
create_arrow_buttons "espresso_menu_yield" $x $y "::metric_settings(cup_weight)" 0.1 1 $::metric_setting_yield_min $::metric_setting_yield_max metric_yield_changed
create_2value_button $espresso_setting_contexts $x [expr $y -90] 400 [translate "yield"] $::symbol_espresso $::color_yield {[get_mantissa $::metric_settings(cup_weight)]} {.[get_exponent $::metric_settings(cup_weight)]g} {say [translate "yield"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu_yield"}
add_de1_button "espresso_menu_yield" {say [translate "close"] $::settings(sound_button_in); metric_jump_to_no_history "espresso_menu"} $x [expr $y - 90] [expr $x + 400] [expr $y + 90]

incr x 500
create_2value_button $espresso_setting_contexts $x [expr $y -90] 400 [translate "grind"] $::symbol_grind $::color_grind "15" "E" { }

incr x 500
create_2value_button $espresso_setting_contexts $x [expr $y -90] 400 [translate "temp"] $::symbol_temperature $::color_temperature "90" ".0\u00B0C" { }





set ::espresso_action_button_id [create_action_button $espresso_setting_contexts 1280 1320 [translate "start"] $::font_action_label $::color_text $::symbol_espresso $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate {start}] $::settings(sound_button_in); do_start_espresso} ""]

proc update_espresso_button {} {
	if { [can_start_espresso] } {
		update_button_color $::espresso_action_button_id $::color_action_button_start
	} else {
		update_button_color $::espresso_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable $espresso_setting_contexts -100 -100 -textvariable {[update_espresso_button]} 
