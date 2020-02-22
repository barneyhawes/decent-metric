# special characters
set ::symbol_temperature "\u00A1"
set ::symbol_espresso "\u00A2"
set ::symbol_hand "\u00A3"
set ::symbol_flush "\u00A4"
set ::symbol_water "\u00A5"
set ::symbol_menu "\u00A6"
set ::symbol_steam "\u00A7"
set ::symbol_ratio "\u00A8"
set ::symbol_bean "\u00A9"
set ::symbol_grind "\u00AA"

# colours
set ::color_text "#eee"
set ::color_grey_text "#777"
set ::color_background "#1e1e1e"
set ::color_menu_background "#333333"
set ::color_status_bar "#252525"
set ::color_water "#19BBFF"
set ::color_temperature "#D34237"
set ::color_pressure "#6A9949"
set ::color_yield "#995A27"
set ::color_dose "#986F4A"
set ::color_ratio "#3F4E65"
set ::color_profile "#424F54"
set ::color_flow "#4237D3"
set ::color_grind "#4B9793"
set ::color_arrow "#666"
set ::color_button "#333333"
set ::color_button_text "#eee"
set ::color_action_button_start "#6A9949"
set ::color_action_button_stop "#D34237"
set ::color_action_button_disabled "#252525"
set ::color_action_button_text "#eee"

# fonts
set ::font_setting_heading [get_font "Mazzard Regular" 24]
set ::font_setting_description [get_font "Mazzard Regular" 14]
set ::font_setting [get_font "Mazzard Regular" 36]
set ::font_button [get_font "Mazzard Regular" 24]
set ::font_list [get_font "Mazzard Regular" 24]
set ::font_action_button [get_font "Mazzard SemiBold" 80]
set ::font_main_menu [get_font "Mazzard SemiBold" 48]

# settings limits
set ::metric_setting_dose_min 10.0
set ::metric_setting_dose_max 30.0
set ::metric_setting_ratio_min 1.0
set ::metric_setting_ratio_max 5.0
set ::metric_setting_yield_min 10.0
set ::metric_setting_yield_max 150.0