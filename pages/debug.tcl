add_background "debug"
add_back_button "debug" [translate "debug"]

add_de1_text "debug" 180 300 -text "Grid" -font [get_font "Mazzard SemiBold" 18] -fill $::color_text -anchor "w" 
create_button "debug" 680 240 880 360 [translate "off"] [get_font "Mazzard SemiBold" 18] $::color_button $::color_button_text { say [translate "off"] $::settings(sound_button_in); .can itemconfigure "grid" -state "hidden" }
create_button "debug" 980 240 1180 360 [translate "on"] [get_font "Mazzard SemiBold" 18] $::color_button $::color_button_text { say [translate "on"] $::settings(sound_button_in); .can itemconfigure "grid" -state "normal" }
