add_background "off"
add_home_button "off" 120 $::symbol_espresso [translate "espresso"] $::color_menu_background $::color_text {say [translate "espresso"] $::settings(sound_button_in); metric_jump_to "espresso_menu" }
add_home_button "off" 420 $::symbol_espresso [translate "pour over"] $::color_menu_background $::color_grey_text { }
add_home_button "off" 720 $::symbol_steam [translate "steam"] $::color_menu_background $::color_text {say [translate "steam"] $::settings(sound_button_in); metric_jump_to "steam_menu" }
add_home_button "off" 1020 $::symbol_water [translate "water"] $::color_menu_background $::color_text {say [translate "water"] $::settings(sound_button_in); metric_jump_to "water_menu" }

create_button "off" 680 1320 1030 1500 [translate "flush"] $::font_button $::color_button $::color_button_text { say [translate "flush"] $::settings(sound_button_in); metric_jump_to "flush_menu"}
create_button "off" 1105 1320 1455 1500 [translate "settings"] $::font_button $::color_button $::color_button_text { say [translate "settings"] $::settings(sound_button_in); show_settings }
create_button "off" 1530 1320 1880 1500 [translate "sleep"] $::font_button $::color_button $::color_button_text { say [translate "settings"] $::settings(sound_button_in); start_sleep }

create_button "off" 2280 60 2480 180 [translate "debug"] $::font_button $::color_button $::color_button_text { say [translate "debug"] $::settings(sound_button_in); metric_jump_to "debug"}