add_background "flush_menu flush"
add_back_button "flush_menu flush" [translate "flush"]
add_de1_text "flush_menu flush" 180 360 -text [translate "1. Remove the portafilter."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "flush_menu flush" 180 480 -text [translate "2. Press $::symbol_flush to run water through the head."] -font $::font_setting_heading -fill $::color_text -anchor "w" 
set ::flush_action_button_id [create_action_button "flush_menu" 1280 1020 $::symbol_flush $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate "flush"] $::settings(sound_button_in); do_start_flush } ""]
create_action_button "flush" 1280 1020 $::symbol_hand $::font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); set_next_page off "flush_menu"; start_idle} "fullscreen"

proc update_flush_button {} {
	if { [can_start_flush] } {
		update_button_color $::flush_action_button_id $::color_action_button_start
	} else {
		update_button_color $::flush_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "flush_menu" -100 -100 -textvariable {[update_flush_button]}