
add_background "espresso_config"
add_back_button "espresso_config" [translate "espresso weights"]

proc get_mantissa { n } { return [expr int($n)] }
proc get_exponent { n } { return [expr round(fmod($n,1)*10) ] }

rounded_rectangle "espresso_config" .can [rescale_x_skin 430] [rescale_y_skin 480] [rescale_x_skin 930] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 1030] [rescale_y_skin 480] [rescale_x_skin 1530] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 1630] [rescale_y_skin 480] [rescale_x_skin 2130] [rescale_y_skin 960] [rescale_x_skin 80] $::color_menu_background
rounded_rectangle "espresso_config" .can [rescale_x_skin 430] [rescale_y_skin 1020] [rescale_x_skin 930] [rescale_y_skin 1140] [rescale_x_skin 80] $::color_menu_background

add_de1_text "espresso_config" 980 720 -text "x" -font $::font_setting -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1580 720 -text "=" -font $::font_setting -fill $::color_text -anchor "center" 

# Bean weight
add_de1_text "espresso_config" 680 390 -text [translate "Dose"] -font $::font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 680 730 -text "." -font $::font_setting -fill $::color_text -anchor "center" 
add_de1_variable "espresso_config" 640 730 -text "" -font $::font_setting -fill $::color_text -anchor "e" -textvariable {[ get_mantissa $::metric_settings(bean_weight) ]}
add_de1_variable "espresso_config" 720 730 -text "" -font $::font_setting -fill $::color_text -anchor "w" -textvariable {[ get_exponent $::metric_settings(bean_weight) ]}

add_de1_text "espresso_config" 800 730 -text "g" -font $::font_setting -fill $::color_text -anchor "w" 

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
create_button "espresso_config" 430 1020 930 1200 [translate "weigh"] $::font_button $::color_button $::color_button_text { say [translate "weigh"] $::settings(sound_button_in); }


# Brew ratio
add_de1_text "espresso_config" 1280 390 -text [translate "Ratio"] -font $::font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1230 720 -text ":" -font $::font_setting -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1210 720 -text "1" -font $::font_setting -fill $::color_text -anchor "e" 
add_de1_variable "espresso_config" 1250 720 -text "" -font $::font_setting -fill $::color_text -anchor "w" -textvariable {$::metric_settings(brew_ratio)}

.can create line [rescale_x_skin 1230] [rescale_y_skin 590] [rescale_x_skin 1280] [rescale_y_skin 540] [rescale_x_skin 1330] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "brew_ratio_up_arrow" -state hidden
.can create line [rescale_x_skin 1230] [rescale_y_skin 850] [rescale_x_skin 1280] [rescale_y_skin 900] [rescale_x_skin 1330] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "brew_ratio_down_arrow" -state hidden
add_visual_items_to_contexts "espresso_config" "brew_ratio_up_arrow brew_ratio_down_arrow"

add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(brew_ratio)" 0.1 1 5; recalculate_cup_weight} 1030 480 1530 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(brew_ratio)" -0.1 1 5; recalculate_cup_weight} 1030 770 1530 960


# Yield
add_de1_text "espresso_config" 1880 390 -text [translate "Yield"] -font $::font_setting_heading -fill $::color_text -anchor "center" 
add_de1_text "espresso_config" 1880 720 -text "." -font $::font_setting -fill $::color_text -anchor "center" 
add_de1_variable "espresso_config" 1840 720 -text "" -font $::font_setting -fill $::color_text -anchor "e" -textvariable {[ get_mantissa $::metric_settings(cup_weight) ]}
add_de1_variable "espresso_config" 1920 720 -text "" -font $::font_setting -fill $::color_text -anchor "w" -textvariable {[ get_exponent $::metric_settings(cup_weight) ]}
add_de1_text "espresso_config" 2000 720 -text "g" -font $::font_setting -fill $::color_text -anchor "w" 

.can create line [rescale_x_skin 1740] [rescale_y_skin 590] [rescale_x_skin 1790] [rescale_y_skin 540] [rescale_x_skin 1840] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_up_arrow1" -state hidden
.can create line [rescale_x_skin 1920] [rescale_y_skin 590] [rescale_x_skin 1970] [rescale_y_skin 540] [rescale_x_skin 2020] [rescale_y_skin 590] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_up_arrow2" -state hidden
.can create line [rescale_x_skin 1740] [rescale_y_skin 850] [rescale_x_skin 1790] [rescale_y_skin 900] [rescale_x_skin 1840] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_down_arrow1" -state hidden
.can create line [rescale_x_skin 1920] [rescale_y_skin 850] [rescale_x_skin 1970] [rescale_y_skin 900] [rescale_x_skin 2020] [rescale_y_skin 850] -width [rescale_x_skin 12] -fill $::color_arrow -tag "cup_weight_down_arrow2" -state hidden
add_visual_items_to_contexts "espresso_config" "cup_weight_up_arrow1 cup_weight_up_arrow2 cup_weight_down_arrow1 cup_weight_down_arrow2"

add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" 1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1630 480 1880 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" 0.1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1880 480 2130 670
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" -1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1630 770 1880 960
add_de1_button "espresso_config" {say "" $::settings(sound_button_in); adjust_setting "::metric_settings(cup_weight)" -0.1 $::metric_settings(bean_weight) 150; update_cup_weight; recalculate_brew_ratio} 1880 770 2130 960


create_button "espresso_config" 1880 1020 2380 1200 [translate "reset"] $::font_button $::color_button $::color_button_text { say [translate "reset"] $::settings(sound_button_in); set ::metric_settings(bean_weight) "18.0"; set ::metric_settings(brew_ratio) "2.0"; recalculate_cup_weight; }
