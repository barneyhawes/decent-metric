add_background "espresso_menu"
add_back_button "espresso_menu" [translate "espresso"]
add_de1_variable "espresso_menu" 180 360 -text "" -font $::font_setting_heading -fill $::color_text -anchor "w" -textvariable {[translate "1. Grind $::metric_settings(bean_weight)g dose into the portafilter."] }
add_de1_text "espresso_menu" 180 480 -text [translate "2. Distribute grounds evenly, tamp and lock in the portafilter."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "espresso_menu" 180 600 -text [translate "3. Place cup on scale and tare."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "espresso_menu" 180 720 -text [translate "4. Press $::symbol_espresso to start espresso."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_variable "espresso_menu" 180 840 -text "" -font $::font_setting_heading -fill $::color_text -anchor "w" -textvariable {[translate "5. Target yield $::metric_settings(cup_weight)g."]}
create_button "espresso_menu" 180 1020 780 1200 [translate "change weights"] $::font_button $::color_button $::color_button_text { say [translate "weights"] $::settings(sound_button_in); metric_jump_to "espresso_config" }

add_de1_text "espresso_menu" 2380 720 -text [translate "Profile:"] -font $::font_setting_heading -fill $::color_text -anchor "e" 
add_de1_variable "espresso_menu" 2380 840 -text "" -font $::font_setting_heading -fill $::color_text -anchor "e" -textvariable {$::settings(profile_title)}
create_button "espresso_menu" 1780 1020 2380 1200 [translate "change profile"] $::font_button $::color_button $::color_button_text { say [translate "profile"] $::settings(sound_button_in); show_settings "settings_1" }

set ::espresso_action_button_id [create_action_button "espresso_menu" 1280 1020 $::symbol_espresso $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate {start}] $::settings(sound_button_in); do_start_espresso} ""]

proc update_espresso_button {} {
	if { [can_start_espresso] } {
		update_button_color $::espresso_action_button_id $::color_action_button_start
	} else {
		update_button_color $::espresso_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "espresso_menu" -100 -100 -textvariable {[update_espresso_button]} 
