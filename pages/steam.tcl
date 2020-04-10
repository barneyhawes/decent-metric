add_background "steam_menu steam"
add_back_button "steam_menu steam" [translate "steam"]
add_de1_text "steam_menu steam" 180 360 -text [translate "1. Place steam wand into milk."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "steam_menu steam" 180 480 -text [translate "2. Press $::symbol_steam to start."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "steam_menu steam" 180 600 -text [translate "3. After stopping, quickly remove the steam wand and wipe clean."] -font $::font_setting_heading -fill $::color_text -anchor "w" 

set ::steam_action_button_id [create_action_button "steam_menu" 1280 1020 [translate "start"] $::font_action_label $::color_text $::symbol_steam $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate "steam"] $::settings(sound_button_in); do_start_steam} ""]
create_action_button "steam" 1280 1020 [translate "stop"] $::font_action_label $::color_text $::symbol_hand $::font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); metric_jump_back; check_if_steam_clogged } "fullscreen"

proc update_steam_button {} {
	if { [can_start_steam] } {
		update_button_color $::steam_action_button_id $::color_action_button_start
	} else {
		update_button_color $::steam_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "steam_menu" -100 -100 -textvariable {[update_steam_button]} 