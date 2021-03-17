add_background "flush"
add_page_title "flush" [translate "flush"]
add_de1_text "flush" 1280 360 -text [translate "Flush in progress"] -font $::font_setting_heading -fill $::color_text -anchor "center" 

create_action_button "flush" 1280 820 [translate "stop"] $::font_action_label $::color_text $::symbol_hand $::font_action_button $::color_action_button_stop $::color_action_button_text {say [translate "stop"] $::settings(sound_button_in); metric_jump_back} "fullscreen"