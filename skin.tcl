# Barney's Metric skin
package provide metric 0.5

set ::skindebug 0
set ::debugging 0
set ::showgrid 0

package require de1plus 1.0

package ifneeded metric_functions 1.0 [list source [file join "[skin_directory]/metric_functions.tcl"]]
package require metric_functions 1.0

# fonts
set font_setting_heading [get_font "Mazzard Regular" 24]
set font_setting_description [get_font "Mazzard Regular" 14]
set font_setting [get_font "Mazzard Regular" 36]
set font_button [get_font "Mazzard Regular" 24]
set font_list [get_font "Mazzard Regular" 24]
set font_action_button [get_font "Mazzard SemiBold" 80]
set ::font_main_menu [get_font "Mazzard SemiBold" 48]

# special characters
set ::symbol_espresso "\u00A2"
set ::symbol_hand "\u00A3"
set ::symbol_flush "\u00A4"
set ::symbol_water "\u00A5"
set ::symbol_steam "\u00A7"
set ::symbol_menu "\u00A6"

# colours
set ::color_text "#eee"
set ::color_grey_text "#777"
set ::color_background "#1e1e1e"
set ::color_menu_background "#333333"
set ::color_status_bar "#252525"
set ::color_water "#19BBFF"
set ::color_temperature "#D34237"
set ::color_pressure "#6A9949"
set ::color_yield "#986F4A"
set ::color_flow "#4237D3"
set ::color_arrow "#666"
set ::color_button "#333333"
set ::color_button_text "#eee"
set ::color_action_button_start "#6A9949"
set ::color_action_button_stop "#D34237"
set ::color_action_button_disabled "#252525"
set ::color_action_button_text "#eee"

# standard pages
add_de1_page "sleep" "sleep.jpg" "default"
add_de1_page "tankfilling" "filling_tank.jpg" "default"
add_de1_page "tankempty refill" "fill_tank.jpg" "default"
add_de1_page "cleaning" "cleaning.jpg" "default"
add_de1_page "message calibrate infopage tabletstyles languages measurements" "settings_message.png" "default"
add_de1_page "create_preset" "settings_3_choices.png" "default"
add_de1_page "descaling" "descaling.jpg" "default"
add_de1_page "descale_prepare" "descale_prepare.jpg" "default"
add_de1_page "ghc" "ghc.jpg" "default"
add_de1_page "travel_prepare" "travel_prepare.jpg" "default"
add_de1_page "travel_do" "travel_do.jpg" "default"
add_de1_page "descalewarning" "descalewarning.jpg" "default"

add_de1_page "ghc_steam ghc_espresso ghc_flush ghc_hotwater" "ghc.jpg" "default"
add_de1_text "ghc_steam" 1990 680 -text "\[      \]\n[translate {Tap here for steam}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 950
add_de1_text "ghc_espresso" 1936 950 -text "\[      \]\n[translate {Tap here for espresso}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 950
add_de1_text "ghc_flush" 1520 840 -text "\[      \]\n[translate {Tap here to flush}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 750
add_de1_text "ghc_hotwater" 1630 600 -text "\[      \]\n[translate {Tap here for hot water}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 820
add_de1_button "ghc_steam ghc_espresso ghc_flush ghc_hotwater" {say [translate {Ok}] $::settings(sound_button_in); page_show off;} 0 0 2560 1600 

# when tank is empty, just return to menu
set_next_page "tankempty" "off"

add_de1_button "tankempty refill" {say [translate {awake}] $::settings(sound_button_in);start_refill_kit} 0 0 2560 1400 
add_de1_text "tankempty refill" 1280 750 -text [translate "Please add water"] -font Helv_20_bold -fill "#CCCCCC" -justify "center" -anchor "center" -width 900
add_de1_variable "tankempty refill" 1280 900 -justify center -anchor "center" -text "" -font Helv_10 -fill "#CCCCCC" -width 520 -textvariable {[refill_kit_retry_button]} 
add_de1_text "tankempty" 340 1504 -text [translate "Exit App"] -font Helv_10_bold -fill "#AAAAAA" -anchor "center" 
add_de1_text "tankempty" 2220 1504 -text [translate "Ok"] -font Helv_10_bold -fill "#AAAAAA" -anchor "center" 
add_de1_button "tankempty" {say [translate {Exit}] $::settings(sound_button_in); .can itemconfigure $::message_label -text [translate "Going to sleep"]; .can itemconfigure $::message_button_label -text [translate "Wait"]; after 10000 {.can itemconfigure $::message_button_label -text [translate "Ok"]; }; set_next_page off message; page_show message; after 500 app_exit} 0 1402 800 1600
add_de1_button "tankempty refill" {say [translate {awake}] $::settings(sound_button_in);start_refill_kit} 1760 1402 2560 1600

# cleaning and descaling
add_de1_text "cleaning" 1280 80 -text [translate "Cleaning"] -font Helv_20_bold -fill "#EEEEEE" -justify "center" -anchor "center" -width 900
add_de1_text "descaling" 1280 80 -text [translate "Descaling"] -font Helv_20_bold -fill "#CCCCCC" -justify "center" -anchor "center" -width 900
add_de1_text "descalewarning" 1280 1310 -text [translate "Your steam wand is clogging up"] -font Helv_17_bold -fill "#FFFFFF" -justify "center" -anchor "center" -width 900
add_de1_text "descalewarning" 1280 1480 -text [translate "It needs to be descaled soon"] -font Helv_15_bold -fill "#FFFFFF" -justify "center" -anchor "center" -width 900
add_de1_button "descalewarning" {say [translate {descale}] $::settings(sound_button_in); show_settings descale_prepare} 0 0 2560 1600 

# group head controller FYI messages
add_de1_page "ghc_steam ghc_espresso ghc_flush ghc_hotwater" "ghc.jpg" "default"
add_de1_text "ghc_steam" 1990 680 -text "\[      \]\n[translate {Tap here for steam}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 950
add_de1_text "ghc_espresso" 1936 950 -text "\[      \]\n[translate {Tap here for espresso}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 950
add_de1_text "ghc_flush" 1520 840 -text "\[      \]\n[translate {Tap here to flush}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 750
add_de1_text "ghc_hotwater" 1630 600 -text "\[      \]\n[translate {Tap here for hot water}]" -font Helv_30_bold -fill "#FFFFFF" -anchor "ne" -justify right  -width 820
add_de1_button "ghc_steam ghc_espresso ghc_flush ghc_hotwater" {say [translate {Ok}] $::settings(sound_button_in); page_show off;} 0 0 2560 1600 

set_de1_screen_saver_directory "[homedir]/saver"

# include the settings screens.  
source "[homedir]/skins/default/de1_skin_settings.tcl"

# load settings for this skin
load_metric_settings

# complete list of contexts
set metric_contexts "off espresso_menu espresso_config espresso espresso_done steam_menu steam water_menu water flush_menu flush"
set status_bar_contexts "off espresso_menu espresso_config espresso steam_menu steam water_menu water flush_menu flush"

### background
.can create rect 0 0 [rescale_x_skin 2560] [rescale_y_skin 1600] -fill $::color_background -width 0 -tag "background" -state "hidden"
add_visual_items_to_contexts $metric_contexts "background"

.can create rect 0 [rescale_y_skin 1260] [rescale_x_skin 2560] [rescale_y_skin 1600] -fill $::color_status_bar -width 0 -tag "status_background"
add_visual_items_to_contexts $status_bar_contexts "status_background" 

if {$::showgrid == 1} {
    for {set x 80} {$x < 2560} {incr x 100} {
        .can create line [rescale_x_skin $x] [rescale_y_skin 0] [rescale_x_skin $x] [rescale_y_skin 1600] -width [rescale_x_skin 1] -fill "#fff"
        add_de1_text $metric_contexts $x 0 -text $x -font [get_font "Mazzard Regular" 12] -fill $::color_text -anchor "nw" 
    }
    for {set y 60} {$y < 1600} {incr y 60} {
        .can create line [rescale_x_skin 0] [rescale_y_skin $y] [rescale_x_skin 2560] [rescale_y_skin $y] -width [rescale_x_skin 1] -fill "#fff"
        add_de1_text $metric_contexts 0 $y -text $y -font [get_font "Mazzard Regular" 12] -fill $::color_text -anchor "sw" 
    }
}


### status bar

# Connection
set ::connection_message_background_id [ rounded_rectangle $status_bar_contexts .can [rescale_x_skin 880] [rescale_y_skin 1290] [rescale_x_skin 1680] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::connection_message_text_id [ add_de1_text $status_bar_contexts 1280 1430 -text "" -font $font_setting_heading -fill $::color_temperature -anchor "center" ]

# Water
set ::refill_message_background_id [ rounded_rectangle $status_bar_contexts .can [rescale_x_skin 1780] [rescale_y_skin 1290] [rescale_x_skin 2530] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::refill_message_text_id [ add_de1_text $status_bar_contexts 1990 1430 -text "" -font $font_setting_heading -fill $::color_water -anchor "center" ]

#TODO: embed this in the water meter command below.
proc get_water_level {} { return $::de1(water_level) }
proc get_min_water_level {} { return $::settings(water_refill_point) }

set ::water_meter [meter new -x [rescale_x_skin 2200] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue [expr $::settings(water_level_sensor_max) * 0.9] -get_meter_value get_water_level -get_target_value get_min_water_level -show_empty_full 1 _tick_frequency [expr ($::settings(water_level_sensor_max) * 0.9 * 0.25)] -needle_color $::color_water -label_color $::color_grey_text -tick_color $::color_status_bar -contexts $status_bar_contexts -title [translate "Water"]]
add_de1_variable $status_bar_contexts -100 -100 -text "" -textvariable {[$::water_meter update]} 

# Temperature
set ::heating_message_background_id [ rounded_rectangle $status_bar_contexts .can [rescale_x_skin 30] [rescale_y_skin 1290] [rescale_x_skin 780] [rescale_y_skin 1570] [rescale_x_skin 80] $::color_status_bar ]
set ::heating_message_text_id [ add_de1_text $status_bar_contexts 570 1430 -text "" -font $font_setting_heading -fill $::color_temperature -anchor "center" ]

#TODO: should be group_head_heater_temperature but this is not useful in the simulator
proc get_min_temperature {} { return $::settings(minimum_water_temperature) }
set ::temperature_meter [meter new -x [rescale_x_skin 80] -y [rescale_y_skin 1310] -width [rescale_x_skin 280] -minvalue 0.0 -maxvalue 100.0 -get_meter_value watertemp -get_target_value get_min_temperature -tick_frequency 10.0 -label_frequency 20 -needle_color $::color_temperature -label_color $::color_grey_text -tick_color $::color_status_bar -contexts $status_bar_contexts -title [translate "Head temperature"] -units [return_html_temperature_units]]
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
add_de1_variable $status_bar_contexts 2550 10 -anchor "ne" -text "" -font $font_setting_heading -fill $::color_status_bar -textvariable {[get_status_text]} 


### back button / page title
set item_id [.can create line [rescale_x_skin 120] [rescale_y_skin  60] [rescale_x_skin 60] [rescale_y_skin 120] [rescale_x_skin 120] [rescale_y_skin 180] -width [rescale_x_skin 24] -fill $::color_text]
add_visual_items_to_contexts "espresso_menu espresso_config espresso espresso_done steam_menu steam water_menu water flush_menu flush" $item_id
add_de1_text "espresso_menu espresso espresso_done" 180 120 -text [translate "espresso"] -font $::font_main_menu -fill $::color_text -anchor "w" 
add_de1_text "espresso_config" 180 120 -text [translate "espresso weights"] -font $::font_main_menu -fill $::color_text -anchor "w" 
add_de1_text "steam_menu steam" 180 120 -text [translate "steam"] -font $::font_main_menu -fill $::color_text -anchor "w" 
add_de1_text "water_menu water" 180 120 -text [translate "water"] -font $::font_main_menu -fill $::color_text -anchor "w" 
add_de1_text "flush_menu flush" 180 120 -text [translate "flush"] -font $::font_main_menu -fill $::color_text -anchor "w" 
add_de1_button "espresso_menu espresso_config espresso espresso_done steam_menu steam water_menu water flush_menu flush" {say [translate "back"] $::settings(sound_button_in); metric_jump_back } 0 0 1280 240

#### Home page

proc add_home_button { contexts yoffset symbol text color_menu_background color_text action} {
	rounded_rectangle $contexts .can [rescale_x_skin 680] [rescale_y_skin $yoffset] [rescale_x_skin 1880] [rescale_y_skin [expr $yoffset + 240]] [rescale_x_skin 80] $::color_menu_background
	add_de1_text $contexts 820 [expr $yoffset + 120] -text $symbol -font [get_font "Mazzard SemiBold" 72] -fill $::color_text -anchor "center" 
	add_de1_text $contexts 1280 [expr $yoffset + 120] -text $text -font  [get_font "Mazzard SemiBold" 48] -fill $::color_text -anchor "center" 
	.can create line [rescale_x_skin 1720] [rescale_y_skin [expr $yoffset + 60]] [rescale_x_skin 1780] [rescale_y_skin [expr $yoffset + 120]] [rescale_x_skin 1720] [rescale_y_skin [expr $yoffset + 180]] -width [rescale_x_skin 24] -fill $::color_text -tag "menu_arrow" -state hidden
	add_de1_button $contexts $action 680 $yoffset 1880 [expr $yoffset + 240]
	add_visual_items_to_contexts $contexts "menu_arrow"
}

add_home_button "off" 120 $::symbol_espresso [translate "espresso"] $::color_menu_background $::color_text {say [translate "espresso"] $::settings(sound_button_in); metric_jump_to "espresso_menu" }
add_home_button "off" 420 $::symbol_steam [translate "steam"] $::color_menu_background $::color_text {say [translate "steam"] $::settings(sound_button_in); metric_jump_to "steam_menu" }
add_home_button "off" 720 $::symbol_water [translate "water"] $::color_menu_background $::color_text {say [translate "water"] $::settings(sound_button_in); metric_jump_to "water_menu" }

create_button "off" 680 1020 1030 1200 [translate "flush"] $font_button $::color_button $::color_button_text { say [translate "flush"] $::settings(sound_button_in); metric_jump_to "flush_menu"}
create_button "off" 1105 1020 1455 1200 [translate "settings"] $font_button $::color_button $::color_button_text { say [translate "settings"] $::settings(sound_button_in); show_settings }
create_button "off" 1530 1020 1880 1200 [translate "sleep"] $font_button $::color_button $::color_button_text { say [translate "settings"] $::settings(sound_button_in); start_sleep }

### espresso_menu
add_de1_variable "espresso_menu" 180 360 -text "" -font $font_setting_heading -fill $::color_text -anchor "w" -textvariable {[translate "1. Grind $::metric_settings(bean_weight)g dose into the portafilter."] }
add_de1_text "espresso_menu" 180 480 -text [translate "2. Distribute grounds evenly, tamp and lock in the portafilter."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "espresso_menu" 180 600 -text [translate "3. Place cup on scale and tare."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "espresso_menu" 180 720 -text [translate "4. Press $::symbol_espresso to start espresso."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_variable "espresso_menu" 180 840 -text "" -font $font_setting_heading -fill $::color_text -anchor "w" -textvariable {[translate "5. Target yield $::metric_settings(cup_weight)g."]}
create_button "espresso_menu" 180 1020 780 1200 [translate "change weights"] $font_button $::color_button $::color_button_text { say [translate "weights"] $::settings(sound_button_in); metric_jump_to "espresso_config" }

add_de1_text "espresso_menu" 2380 720 -text [translate "Profile:"] -font $font_setting_heading -fill $::color_text -anchor "e" 
add_de1_variable "espresso_menu" 2380 840 -text "" -font $font_setting_heading -fill $::color_text -anchor "e" -textvariable {$::settings(profile_title)}
create_button "espresso_menu" 1780 1020 2380 1200 [translate "change profile"] $font_button $::color_button $::color_button_text { say [translate "profile"] $::settings(sound_button_in); show_settings "settings_1" }

set ::espresso_action_button_id [create_action_button "espresso_menu" 1280 1020 $::symbol_espresso $font_action_button $::color_action_button_start $::color_action_button_text {say [translate {start}] $::settings(sound_button_in); do_start_espresso} ""]

proc update_espresso_button {} {
	if { [can_start_espresso] } {
		update_button_color $::espresso_action_button_id $::color_action_button_start
	} else {
		update_button_color $::espresso_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "espresso_menu" -100 -100 -textvariable {[update_espresso_button]} 


### espresso
add_de1_variable "espresso" 2480 120 -text "" -font $font_setting_heading -fill $::color_text -anchor "e" -textvariable { $::settings(profile_title) }

proc get_target_pressure {} { return $::de1(goal_pressure) }
set ::espresso_pressure_meter [meter new -x [rescale_x_skin 480] -y [rescale_y_skin 200] -width [rescale_x_skin 750] -minvalue 0.0 -maxvalue 12.0 -get_meter_value pressure -get_target_value get_target_pressure -tick_frequency 1.0 -label_frequency 1 -needle_color $::color_pressure -label_color $::color_grey_text -tick_color $::color_background -contexts "espresso" -title [translate "Pressure"] -units "bar"]
add_de1_variable "espresso" -100 -100 -text "" -textvariable {[$::espresso_pressure_meter update]} 

proc get_target_flow {} {
	if { $::de1(substate) == 4 || $::de1(substate) == 5 } {
		return $::de1(goal_flow) 
	}
	return 0
}
set ::espresso_flow_meter [meter new -x [rescale_x_skin 1330] -y [rescale_y_skin 200] -width [rescale_x_skin 750] -minvalue 0.0 -maxvalue 5.0 -get_meter_value waterflow -get_target_value get_target_flow -tick_frequency 0.5 -label_frequency 1 -needle_color $::color_flow -label_color $::color_grey_text -tick_color $::color_background -contexts "espresso" -title [translate "Flow rate"] -units "mL/s"]
add_de1_variable "espresso" -100 -100 -text "" -textvariable {[$::espresso_flow_meter update]} 

proc get_target_temperature {} { return $::de1(goal_temperature) }
set ::espresso_temperature_meter [meter new -x [rescale_x_skin 80] -y [rescale_y_skin 780] -width [rescale_x_skin 500] -minvalue 80.0 -maxvalue 100.0 -get_meter_value water_mix_temperature -get_target_value get_target_temperature -tick_frequency 1 -label_frequency 5 -needle_color $::color_temperature -label_color $::color_grey_text -tick_color $::color_background -contexts "espresso" -title [translate "Water temperature"] -units [return_html_temperature_units]]
add_de1_variable "espresso" -100 -100 -text "" -textvariable {[$::espresso_temperature_meter update]} 

proc get_target_weight {} {
	if {$::settings(settings_profile_type) == "settings_2c" } {
		return $::settings(final_desired_shot_volume_advanced)
	} else {
		return $::settings(final_desired_shot_volume)
	} 
}

proc get_weight {} {
	if {$::settings(scale_bluetooth_address) != "" && $::de1(scale_weight) != ""} {
		return $::de1(scale_weight)
	}

	if {$::settings(settings_profile_type) == "settings_2c" } {
		return [expr {$::de1(preinfusion_volume) + $::de1(pour_volume)}]
	} else {
		return $::de1(pour_volume)
	}
}

set ::espresso_weight_meter [meter new -x [rescale_x_skin 1980] -y [rescale_y_skin 780] -width [rescale_x_skin 500] -minvalue 0.0 -maxvalue 50.0 -get_meter_value get_weight -get_target_value get_target_weight -tick_frequency 5 -label_frequency 10 -needle_color $::color_yield -label_color $::color_grey_text -tick_color $::color_background -contexts "espresso" -title [translate "Yield"] -units "g"]
add_de1_variable "espresso" -100 -100 -text "" -textvariable {[$::espresso_weight_meter update]} 

create_action_button "espresso" 1280 1020 $::symbol_hand $font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); start_idle } "fullscreen"

# timer on stop button
# TODO: rounded ends (need to draw a circle at each endpoint)
# TODO: create a reusable function (or add as an option to create_action_button?)
add_de1_variable "espresso" 1300 1090 -text "" -font $font_setting_heading -fill $::color_action_button_text -anchor "ne" -textvariable {[espresso_elapsed_timer]}
add_de1_text "espresso" 1310 1090 -text [translate "s"] -font $font_setting_heading -fill $::color_action_button_text -anchor "nw"
.can create arc [rescale_x_skin 1100] [rescale_y_skin 840] [rescale_x_skin 1460] [rescale_y_skin 1200] -start 90 -extent 0 -style arc -width [rescale_x_skin 15] -outline $::color_action_button_text -tag "espresso_timer"
add_visual_items_to_contexts "espresso" "espresso_timer"

proc update_espresso_timer {} {
	if {$::timers(espresso_start) == 0} {
		set duration 0.0
	} elseif {$::timers(espresso_stop) == 0} {
		set duration [expr {[clock milliseconds] - $::timers(espresso_start)}]
	} else {
		set duration [expr {$::timers(espresso_stop) - $::timers(espresso_start)}]
	}
	set angle [expr $duration / 1000.0 / 60.0 * -360.0]
	.can itemconfigure "espresso_timer"	-extent $angle
}
add_de1_variable "espresso" -100 -100 -text "" -textvariable {[update_espresso_timer]} 

### espresso_config
proc get_mantissa { n } { return [expr int($n)] }
proc get_exponent { n } { return [expr round(fmod($n,1)*10) ] }

rounded_rectangle "espresso_config" .can [rescale_x_skin 430] [rescale_y_skin 480] [rescale_x_skin 930] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 1030] [rescale_y_skin 480] [rescale_x_skin 1530] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 1630] [rescale_y_skin 480] [rescale_x_skin 2130] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 430] [rescale_y_skin 1020] [rescale_x_skin 930] [rescale_y_skin 1140] [rescale_x_skin 80] $::color_menu_background

add_de1_text "espresso_config" 980 720 -text "x" -font $font_setting -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1580 720 -text "=" -font $font_setting -fill $::color_text -anchor "center" 

# Bean weight
add_de1_text "espresso_config" 680 390 -text [translate "Dose"] -font $font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 680 730 -text "." -font $font_setting -fill $::color_text -anchor "center" 
add_de1_variable "espresso_config" 640 730 -text "" -font $font_setting -fill $::color_text -anchor "e" -textvariable {[ get_mantissa $::metric_settings(bean_weight) ]}
add_de1_variable "espresso_config" 720 730 -text "" -font $font_setting -fill $::color_text -anchor "w" -textvariable {[ get_exponent $::metric_settings(bean_weight) ]}

add_de1_text "espresso_config" 800 730 -text "g" -font $font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 540] [rescale_y_skin 590] [rescale_x_skin 590] [rescale_y_skin 540] [rescale_x_skin 640] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "bean_weight_up_arrow1" -state hidden
.can create line [rescale_x_skin 720] [rescale_y_skin 590] [rescale_x_skin 770] [rescale_y_skin 540] [rescale_x_skin 830] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "bean_weight_up_arrow2" -state hidden
.can create line [rescale_x_skin 540] [rescale_y_skin 850] [rescale_x_skin 590] [rescale_y_skin 900] [rescale_x_skin 640] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "bean_weight_down_arrow1" -state hidden
.can create line [rescale_x_skin 720] [rescale_y_skin 850] [rescale_x_skin 770] [rescale_y_skin 900] [rescale_x_skin 830] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "bean_weight_down_arrow2" -state hidden
add_visual_items_to_contexts "espresso_config" "bean_weight_up_arrow1 bean_weight_up_arrow2 bean_weight_down_arrow1 bean_weight_down_arrow2"

add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(bean_weight)" 1 1 30; recalculate_cup_weight} 430 480 680 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(bean_weight)" 0.1 1 30; recalculate_cup_weight} 680 480 930 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(bean_weight)" -1 1 30; recalculate_cup_weight} 430 770 680 960
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(bean_weight)" -0.1 1 30; recalculate_cup_weight} 680 770 930 960

#TODO: get weight from scale
create_button "espresso_config" 430 1020 930 1200 [translate "weigh"] $font_button $::color_button $::color_button_text { say [translate "weigh"] $::settings(sound_button_in); }


# Brew ratio
add_de1_text "espresso_config" 1280 390 -text [translate "Ratio"] -font $font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1230 720 -text ":" -font $font_setting -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1210 720 -text "1" -font $font_setting -fill $::color_text -anchor "e" 
add_de1_variable "espresso_config" 1250 720 -text "" -font $font_setting -fill $::color_text -anchor "w" -textvariable {$::metric_settings(brew_ratio)}

.can create line [rescale_x_skin 1230] [rescale_y_skin 590] [rescale_x_skin 1280] [rescale_y_skin 540] [rescale_x_skin 1330] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "brew_ratio_up_arrow" -state hidden
.can create line [rescale_x_skin 1230] [rescale_y_skin 850] [rescale_x_skin 1280] [rescale_y_skin 900] [rescale_x_skin 1330] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "brew_ratio_down_arrow" -state hidden
add_visual_items_to_contexts "espresso_config" "brew_ratio_up_arrow brew_ratio_down_arrow"

add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(brew_ratio)" 0.1 1 5; recalculate_cup_weight} 1030 480 1530 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(brew_ratio)" -0.1 1 5; recalculate_cup_weight} 1030 770 1530 960


# Yield
add_de1_text "espresso_config" 1880 390 -text [translate "Yield"] -font $font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1880 720 -text "." -font $font_setting -fill $::color_text -anchor "center" 
add_de1_variable "espresso_config" 1840 720 -text "" -font $font_setting -fill $::color_text -anchor "e" -textvariable {[ get_mantissa $::metric_settings(cup_weight) ]}
add_de1_variable "espresso_config" 1920 720 -text "" -font $font_setting -fill $::color_text -anchor "w" -textvariable {[ get_exponent $::metric_settings(cup_weight) ]}
add_de1_text "espresso_config" 2000 720 -text "g" -font $font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 1740] [rescale_y_skin 590] [rescale_x_skin 1790] [rescale_y_skin 540] [rescale_x_skin 1840] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_up_arrow1" -state hidden
.can create line [rescale_x_skin 1920] [rescale_y_skin 590] [rescale_x_skin 1970] [rescale_y_skin 540] [rescale_x_skin 2020] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_up_arrow2" -state hidden
.can create line [rescale_x_skin 1740] [rescale_y_skin 850] [rescale_x_skin 1790] [rescale_y_skin 900] [rescale_x_skin 1840] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_down_arrow1" -state hidden
.can create line [rescale_x_skin 1920] [rescale_y_skin 850] [rescale_x_skin 1970] [rescale_y_skin 900] [rescale_x_skin 2020] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_down_arrow2" -state hidden
add_visual_items_to_contexts "espresso_config" "cup_weight_up_arrow1 cup_weight_up_arrow2 cup_weight_down_arrow1 cup_weight_down_arrow2"

add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" 1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1630 480 1880 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" 0.1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1880 480 2130 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" -1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1630 770 1880 960
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" -0.1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1880 770 2130 960


create_button "espresso_config" 1880 1020 2380 1200 [translate "reset"] $font_button $::color_button $::color_button_text { say [translate "reset"] $::settings(sound_button_in); set ::metric_settings(bean_weight) "18.0"; set ::metric_settings(brew_ratio) "2.0"; recalculate_cup_weight; }

### espresso_done
set font_summary_text [get_font "Mazzard Regular" 14]
set summary_x0 240
set summary_x1 480
set summary_x2 630
set summary_y 360
set summary_y_step 60

rounded_rectangle "espresso_done" .can [rescale_x_skin 180] [rescale_y_skin 300] [rescale_x_skin 1080] [rescale_y_skin 780] [rescale_x_skin 80] $::color_menu_background

add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Preset:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {$::settings(profile_title)} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Time and date:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {[clock format [expr $::timers(espresso_start) / 1000] -format "%R" ]} 
add_de1_variable "espresso_done" $summary_x2 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {[clock format [expr $::timers(espresso_start) / 1000] -format "%d/%m/%Y" ]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Temperature:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {$::de1(goal_temperature)[return_html_temperature_units]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Dose:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {$::metric_settings(bean_weight)g} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Target yield:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {$::metric_settings(cup_weight)g} 
add_de1_variable "espresso_done" $summary_x2 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {1:$::metric_settings(brew_ratio)} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Actual yield:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {[format "%.1f" [get_weight]]g} 
add_de1_variable "espresso_done" $summary_x2 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {1:[format "%.1f" [expr [get_weight] / $::metric_settings(bean_weight)]]} 
incr summary_y $summary_y_step
add_de1_text "espresso_done" $summary_x0 $summary_y -text [translate "Duration:"] -font $font_summary_text -fill $::color_text -anchor "w" 
add_de1_variable "espresso_done" $summary_x1 $summary_y -font $font_summary_text -fill $::color_text -anchor "w" -textvariable {[expr {($::timers(espresso_stop) - $::timers(espresso_start))/1000}][translate "s"]} 

set ::font_chart [get_font "Mazzard Regular" 12]
add_de1_widget "espresso_done" graph 1180 60 {
	$widget axis configure x -color $::color_grey_text -tickfont $::font_chart -stepsize 1 -subdivisions 1; 
	$widget axis configure y -color $::color_grey_text -tickfont $::font_chart -stepsize 1 -subdivisions 1 -min 0 -max 12; 
	$widget grid configure -hide true;


	$widget element create line2_espresso_pressure -xdata espresso_elapsed -ydata espresso_pressure -symbol none -label "" -linewidth [rescale_x_skin 10] -color $::color_pressure -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_pressure_goal -xdata espresso_elapsed -ydata espresso_pressure_goal -symbol none -label "" -linewidth [rescale_x_skin 5] -color $::color_pressure -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {1 3}; 

	$widget element create line_espresso_flow_2x -xdata espresso_elapsed -ydata espresso_flow -symbol none -label "" -linewidth [rescale_x_skin 10] -color $::color_flow -smooth $::settings(live_graph_smoothing_technique) -pixels 0;
	$widget element create line_espresso_flow_goal_2x -xdata espresso_elapsed -ydata espresso_flow_goal -symbol none -label "" -linewidth [rescale_x_skin 5] -color $::color_flow -smooth $::settings(live_graph_smoothing_technique) -pixels 0 -dashes {1 3};

	$widget element create line_espresso_total_flow -xdata espresso_elapsed -ydata espresso_water_dispensed -symbol none -label "" -linewidth [rescale_x_skin 10] -color ::color_yield -smooth $::settings(live_graph_smoothing_technique) -pixels 0;

} -plotbackground $::color_background -width [rescale_x_skin 1300] -height [rescale_y_skin 1080] -borderwidth 1 -background $::color_background -plotrelief flat

add_de1_text "espresso_done" 1180 60 -text [translate "Flow (mL/s)"] -font $::font_chart -fill $::color_flow -justify "left" -anchor "ne"
add_de1_text "espresso_done" 1180 120 -text [translate "Pressure (bar)"] -font $::font_chart -fill $::color_pressure -justify "left" -anchor "ne"
add_de1_text "espresso_done" 1180 180 -text [translate "Yield (g)"] -font $::font_chart -fill $::color_yield -justify "left" -anchor "ne"
add_de1_text "espresso_done" 2480 1140 -text [translate "Time (s)"] -font $::font_chart -fill $::color_text -justify "left" -anchor "ne"



create_button "espresso_done" 180 840 480 1020 [translate "steam"] $font_button $::color_button $::color_button_text { say [translate "steam"] $::settings(sound_button_in); metric_jump_to "steam_menu" }
create_button "espresso_done" 780 840 1080 1020 [translate "flush"] $font_button $::color_button $::color_button_text { say [translate "flush"] $::settings(sound_button_in); metric_jump_to "flush_menu" }


### steam_menu
add_de1_text "steam_menu steam" 180 360 -text [translate "1. Place steam wand into milk."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "steam_menu steam" 180 480 -text [translate "2. Press $::symbol_steam to start."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "steam_menu steam" 180 600 -text [translate "3. After stopping, quickly remove the steam wand and wipe clean."] -font $font_setting_heading -fill $::color_text -anchor "w" 

set ::steam_action_button_id [create_action_button "steam_menu" 1280 1020 $::symbol_steam $font_action_button $::color_action_button_start $::color_action_button_text {say [translate "steam"] $::settings(sound_button_in); do_start_steam} ""]
create_action_button "steam" 1280 1020 $::symbol_hand $font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); start_idle; check_if_steam_clogged } "fullscreen"

proc update_steam_button {} {
	if { [can_start_steam] } {
		update_button_color $::steam_action_button_id $::color_action_button_start
	} else {
		update_button_color $::steam_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "steam_menu" -100 -100 -textvariable {[update_steam_button]} 


### hot water

# hot water time
rounded_rectangle "water_menu water" .can [rescale_x_skin 430] [rescale_y_skin 480] [rescale_x_skin 930] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background

add_de1_text "water_menu water" 680 390 -text [translate "Volume"] -font $font_setting_heading -fill $::color_text -anchor "center" 
add_de1_variable "water_menu water" 680 730 -text "" -font $font_setting -fill $::color_text -anchor "e" -textvariable { [expr int($::settings(water_volume)) ] }
add_de1_text "water_menu water" 705 730 -text "ml" -font $font_setting -fill $::color_text -anchor "w" 

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

add_de1_text "water_menu water" 1280 390 -text [translate "Temperature"] -font $font_setting_heading -fill $::color_text -anchor "center" 
add_de1_variable "water_menu water" 1295 720 -text "" -font $font_setting -fill $::color_text -anchor "e" -textvariable { [expr int($::settings(water_temperature)) ] }
add_de1_text "water_menu water" 1300 730 -text [return_html_temperature_units] -font $font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 1140] [rescale_y_skin 590] [rescale_x_skin 1190] [rescale_y_skin 540] [rescale_x_skin 1240] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_up_arrow1" -state hidden
.can create line [rescale_x_skin 1320] [rescale_y_skin 590] [rescale_x_skin 1370] [rescale_y_skin 540] [rescale_x_skin 1420] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_up_arrow2" -state hidden
.can create line [rescale_x_skin 1140] [rescale_y_skin 850] [rescale_x_skin 1190] [rescale_y_skin 900] [rescale_x_skin 1240] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_down_arrow1" -state hidden
.can create line [rescale_x_skin 1320] [rescale_y_skin 850] [rescale_x_skin 1370] [rescale_y_skin 900] [rescale_x_skin 1420] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "water_temperature_down_arrow2" -state hidden
add_visual_items_to_contexts "water_menu" "water_temperature_up_arrow1 water_temperature_up_arrow2 water_temperature_down_arrow1 water_temperature_down_arrow2"

add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" 10 60 100 } 1030 480 1280 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" 1 60 100 } 1280 480 1530 670
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" -10 60 100 } 1030 770 1280 960
add_de1_button "water_menu" {say "" $::settings(sound_button_in); adjust_setting "::settings(water_temperature)" -1 60 100 } 1280 770 1530 960

set ::water_action_button_id [create_action_button "water_menu" 1880 720 $::symbol_water $font_action_button $::color_action_button_start $::color_action_button_text {say [translate "hot water"] $::settings(sound_button_in); do_start_water} ""]
create_action_button "water" 1880 720 $::symbol_hand $font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); set_next_page off water_menu; start_idle } "fullscreen"

proc update_water_button {} {
	if { [can_start_water] } {
		update_button_color $::water_action_button_id $::color_action_button_start
	} else {
		update_button_color $::water_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "water_menu" -100 -100 -textvariable {[update_water_button]} 

### flush
add_de1_text "flush_menu flush" 180 360 -text [translate "1. Remove the portafilter."] -font $font_setting_heading -fill $::color_text -anchor "w" 
add_de1_text "flush_menu flush" 180 480 -text [translate "2. Press $::symbol_flush to run water through the head."] -font $font_setting_heading -fill $::color_text -anchor "w" 
set ::flush_action_button_id [create_action_button "flush_menu" 1280 1020 $::symbol_flush $font_action_button $::color_action_button_start $::color_action_button_text {say [translate "flush"] $::settings(sound_button_in); do_start_flush } ""]
create_action_button "flush" 1280 1020 $::symbol_hand $font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); set_next_page off "flush_menu"; start_idle} "fullscreen"

proc update_flush_button {} {
	if { [can_start_flush] } {
		update_button_color $::flush_action_button_id $::color_action_button_start
	} else {
		update_button_color $::flush_action_button_id $::color_action_button_disabled
	}
}
add_de1_variable "flush_menu" -100 -100 -textvariable {[update_flush_button]} 

### sleep
add_de1_button "saver" {say [translate "wake"] $::settings(sound_button_in); set_next_page "off" "off"; page_show "off"; start_idle; de1_send_waterlevel_settings} 0 0 2560 1600


# debug info
if {$::debugging == 1} {
	add_de1_variable $metric_contexts 1280 10 -text "" -font [get_font "Mazzard Medium" 12] -fill #fff -anchor "n" -textvariable {[join $::::metric_page_history " > "]}
    #.can create rectangle [rescale_x_skin 0] [rescale_y_skin 210] [rescale_x_skin 1500] [rescale_y_skin 1150] -fill "#fff" 
    add_de1_variable $metric_contexts 10 220 -text "" -font Helv_6 -fill "#000" -anchor "nw" -justify left -width 440 -textvariable {$::debuglog}
}