add_background "espresso_done"
add_back_button "espresso_done" [translate "espresso"]

set ::font_summary_text [get_font "Mazzard Regular" 16]
set summary_x0 240
set summary_x1 540
set summary_y 360
set summary_y_step 60

rounded_rectangle "espresso_done" .can [rescale_x_skin 180] [rescale_y_skin 300] [rescale_x_skin 1180] [rescale_y_skin 780] [rescale_x_skin 80] $::color_menu_background

add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Profile:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {$::settings(profile_title)} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Date:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {[clock format [expr $::timers(espresso_start) / 1000] -format "%d/%m/%Y" ]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Time:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {[clock format [expr $::timers(espresso_start) / 1000] -format "%R" ]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Temperature:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {$::de1(goal_temperature)[return_html_temperature_units]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Dose:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {$::metric_settings(bean_weight)g} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Target ratio:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {1:$::metric_settings(brew_ratio)} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Target yield:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {$::metric_settings(cup_weight)g} 

rounded_rectangle "espresso_done" .can [rescale_x_skin 180] [rescale_y_skin 840] [rescale_x_skin 1180] [rescale_y_skin 1080] [rescale_x_skin 80] $::color_menu_background

set summary_y 900
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Duration:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {[expr {($::timers(espresso_stop) - $::timers(espresso_start))/1000}][translate "s"]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Actual ratio:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {1:[format "%.1f" [expr [get_weight] / $::metric_settings(bean_weight)]]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Actual yield:"] -font $::font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $::font_summary_text -fill $::color_text -anchor "w" -textvariable {[format "%.1f" [get_weight]]g} 

#steam and flush buttons
set ::espresso_done_steam_action_button_id [create_action_button "espresso_done" 380 1300 $::symbol_steam $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate "steam"] $::settings(sound_button_in); metric_jump_to "steam"; do_start_steam} ""]
set ::espresso_done_flush_action_button_id [create_action_button "espresso_done" 880 1300 $::symbol_flush $::font_action_button $::color_action_button_start $::color_action_button_text {say [translate "flush"] $::settings(sound_button_in); metric_jump_to "flush"; do_start_flush } ""]

proc update_espresso_done_buttons {} {
	if { [can_start_steam] } {
		update_button_color $::espresso_done_steam_action_button_id $::color_action_button_start
	} else {
		update_button_color $::espresso_done_steam_action_button_id $::color_action_button_disabled
	}
	if { [can_start_flush] } {
		update_button_color $::flush_action_button_id $::color_action_button_start
	} else {
		update_button_color $::flush_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "espresso_done" -100 -100 -textvariable {[update_espresso_done_buttons]} 


# chart
set ::font_chart [get_font "Mazzard Regular" 14]
add_de1_widget "espresso_done" graph 1280 60 {
	$widget axis configure x -color $::color_grey_text -tickfont $::font_chart -subdivisions 1; 
	$widget axis configure y -color $::color_grey_text -tickfont $::font_chart -stepsize 1 -subdivisions 1 -min 0 -max 12; 
	$widget grid configure -hide true;


	$widget element create line2_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 10] -color $::color_pressure -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 5] -color $::color_pressure -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {1 3}; 

	$widget element create line_espresso_flow_2x -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 10] -color $::color_flow -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_flow_goal_2x -xdata espresso_elapsed -ydata espresso_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 5] -color $::color_flow -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {1 3};

	$widget element create line_espresso_total_flow -xdata espresso_elapsed -ydata espresso_water_dispensed -symbol none -label "" -linewidth [rescale_x_skin 10] -color ::color_yield -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

} -plotbackground $::color_background -width [rescale_x_skin 1200] -height [rescale_y_skin 1080] -borderwidth 1 -background $::color_background -plotrelief flat

add_de1_text "espresso_done" 1280 60 -text [translate "Flow (mL/s)"] -font $::font_chart -fill $::color_flow -justify "left" -anchor "ne"
add_de1_text "espresso_done" 1280 120 -text [translate "Pressure (bar)"] -font $::font_chart -fill $::color_pressure -justify "left" -anchor "ne"
add_de1_text "espresso_done" 1280 180 -text [translate "Yield (g)"] -font $::font_chart -fill $::color_yield -justify "left" -anchor "ne"
add_de1_text "espresso_done" 2480 1140 -text [translate "Time (s)"] -font $::font_chart -fill $::color_text -justify "left" -anchor "ne"