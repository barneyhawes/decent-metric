
# hot water time
add_background "water_menu water"
add_back_button "water_menu water" [translate "water"]
rounded_rectangle "water_menu water" .can [rescale_x_skin 430] [rescale_y_skin 480] [rescale_x_skin 930] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background

add_de1_text "water_menu water" 680 390 -text [translate "Volume"] -font $::font_setting_heading -fill $::color_text -anchor "center" 
add_de1_variable "water_menu water" 680 730 -text "" -font $::font_setting -fill $::color_text -anchor "e" -textvariable { [expr int($::settings(water_volume)) ] }
add_de1_text "water_menu water" 705 730 -text "ml" -font $::font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 540] [rescale_y_skin 590] [rescale_x_skin 590] [rescale_y_skin 540] [rescale_x_skin 640] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_weight_up_arrow1" -state hidden
.can create line [rescale_x_skin 720] [rescale_y_skin 590] [rescale_x_skin 770] [rescale_y_skin 540] [rescale_x_skin 820] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_weight_up_arrow2" -state hidden
.can create line [rescale_x_skin 540] [rescale_y_skin 850] [rescale_x_skin 590] [rescale_y_skin 900] [rescale_x_skin 640] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_weight_down_arrow1" -state hidden
.can create line [rescale_x_skin 720] [rescale_y_skin 850] [rescale_x_skin 770] [rescale_y_skin 900] [rescale_x_skin 820] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_weight_down_arrow2" -state hidden
add_visual_items_to_contexts "water_menu" "water_weight_up_arrow1 water_weight_up_arrow2 water_weight_down_arrow1 water_weight_down_arrow2"

add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_volume)" 10 10 250 } 430 480 680 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_volume)" 1 10 250 } 680 480 930 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_volume)" -10 10 250 } 430 770 680 960
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_volume)" -1 10 250 } 680 770 930 960

# hot water temperature
rounded_rectangle "water_menu water" .can [rescale_x_skin 1030] [rescale_y_skin 480] [rescale_x_skin 1530] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background

add_de1_text "water_menu water" 1280 390 -text [translate "Temperature"] -font $::font_setting_heading -fill $::color_text -anchor "center" 
add_de1_variable "water_menu water" 1295 720 -text "" -font $::font_setting -fill $::color_text -anchor "e" -textvariable { [expr int($::settings(water_temperature)) ] }
add_de1_text "water_menu water" 1300 730 -text [return_html_temperature_units] -font $::font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 1140] [rescale_y_skin 590] [rescale_x_skin 1190] [rescale_y_skin 540] [rescale_x_skin 1240] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_up_arrow1" -state hidden
.can create line [rescale_x_skin 1320] [rescale_y_skin 590] [rescale_x_skin 1370] [rescale_y_skin 540] [rescale_x_skin 1420] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_up_arrow2" -state hidden
.can create line [rescale_x_skin 1140] [rescale_y_skin 850] [rescale_x_skin 1190] [rescale_y_skin 900] [rescale_x_skin 1240] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_down_arrow1" -state hidden
.can create line [rescale_x_skin 1320] [rescale_y_skin 850] [rescale_x_skin 1370] [rescale_y_skin 900] [rescale_x_skin 1420] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_down_arrow2" -state hidden
add_visual_items_to_contexts "water_menu" "water_temperature_up_arrow1 water_temperature_up_arrow2 water_temperature_down_arrow1 water_temperature_down_arrow2"

add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" 10 60 100 } 1030 480 1280 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" 1 60 100 } 1280 480 1530 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" -10 60 100 } 1030 770 1280 960
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" -1 60 100 } 1280 770 1530 960

set ::water_action_button_id [create_action_button "water_menu" 1880 720 $::symbol_water $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate "hot water"] $::settings(sound_button_in); do_start_water} ""]
create_action_button "water" 1880 720 $::symbol_hand $::font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); set_next_page off water_menu; start_idle } "fullscreen"

proc update_water_button {} {
	if { [can_start_water] } {
		update_button_color $::water_action_button_id $::color_action_button_start
	} else {
		update_button_color $::water_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "water_menu" -100 -100 -textvariable {[update_water_button]} 
