# Functions for creating the Metric menu framework

proc add_background { contexts } {
	set background_id [.can create rect 0 0 [rescale_x_skin 2560] [rescale_y_skin 1600] -fill $::color_background -width 0 -state "hidden"]
	add_visual_items_to_contexts $contexts $background_id
}

# add a back button and page title to a context
proc add_back_button { contexts text } {
	set item_id [.can create line [rescale_x_skin 120] [rescale_y_skin  60] [rescale_x_skin 60] [rescale_y_skin 120] [rescale_x_skin 120] [rescale_y_skin 180] -width [rescale_x_skin 24] -fill $::color_text -state "hidden"]
	add_visual_items_to_contexts $contexts $item_id
	set page_title_id [add_de1_text $contexts 180 120 -text $text -font $::font_main_menu -fill $::color_text -anchor "w" -state "hidden"]
	add_de1_button $contexts {say [translate "back"] $::settings(sound_button_in); metric_jump_back } 0 0 1280 240
	return $page_title_id
}

# add a home-page style button
proc add_home_button { contexts yoffset symbol text color_menu_background color_text action} {
	rounded_rectangle $contexts .can [rescale_x_skin 680] [rescale_y_skin $yoffset] [rescale_x_skin 1880] [rescale_y_skin [expr $yoffset + 240]] [rescale_x_skin 80] $::color_menu_background
	add_de1_text $contexts 820 [expr $yoffset + 120] -text $symbol -font [get_font "Mazzard SemiBold" 72] -fill $color_text -anchor "center" -state "hidden"
	add_de1_text $contexts 1280 [expr $yoffset + 120] -text $text -font  [get_font "Mazzard SemiBold" 48] -fill $color_text -anchor "center" -state "hidden"
	.can create line [rescale_x_skin 1720] [rescale_y_skin [expr $yoffset + 60]] [rescale_x_skin 1780] [rescale_y_skin [expr $yoffset + 120]] [rescale_x_skin 1720] [rescale_y_skin [expr $yoffset + 180]] -width [rescale_x_skin 24] -fill $color_text -tag "menu_arrow" -state "hidden"
	add_de1_button $contexts $action 680 $yoffset 1880 [expr $yoffset + 240]
	add_visual_items_to_contexts $contexts "menu_arrow"
}

# add a regular button
proc create_button { contexts x1 y1 x2 y2 text font backcolor textcolor action } {
	if { [info exists ::_button_id] != 1 } { set ::_button_id 0 }
	rounded_rectangle $contexts .can [rescale_x_skin $x1] [rescale_y_skin $y1] [rescale_x_skin $x2] [rescale_y_skin $y2] [rescale_x_skin 80] $backcolor
	add_de1_text $contexts [expr ($x1 + $x2) / 2.0 ] [expr ($y1 + $y2) / 2.0 ] -text $text -font $font -fill $textcolor -anchor "center" -tag "button_text_$::_button_id" -state "hidden"
	add_de1_button $contexts $action $x1 $y1 $x2 $y2
	incr ::_button_id
}

# add a button for starting a DE1 function
proc create_action_button { contexts x y label_text label_font label_textcolor icon_text icon_font backcolor icon_textcolor action fullscreen } {
	if { [info exists ::_button_id] != 1 } { set ::_button_id 0 }
    set radius 180
    set x1 [expr $x - $radius]
    set y1 [expr $y - $radius]
    set x2 [expr $x + $radius]
    set y2 [expr $y + $radius]
    .can create oval [rescale_x_skin $x1] [rescale_y_skin $y1] [rescale_x_skin $x2] [rescale_y_skin $y2] -fill $backcolor -width 0 -tag "button_$::_button_id" -state "hidden"
    add_visual_items_to_contexts $contexts "button_$::_button_id"
    add_de1_text $contexts $x $y -text $icon_text -font $icon_font -fill $icon_textcolor -anchor "center" -state "hidden"
	add_de1_text $contexts $x [expr $y + $radius] -text $label_text -font $label_font -fill $label_textcolor -anchor "n" -state "hidden"
    if {$fullscreen != ""} {
        add_de1_button $contexts $action 0 0 2560 1600
    } else {
        add_de1_button $contexts $action $x1 $y1 $x2 $y2
    }
    incr ::_button_id
	return [expr $::_button_id -1]
}

proc update_button_color { button_id backcolor } {
	.can itemconfigure "button_$button_id" -fill $backcolor
}

### page navigation and history functions ###

set ::metric_page_history "off"
proc metric_history_push { pagename } {
	if {$pagename == "off"} {
		set ::metric_page_history "off"
	} else {
		lappend ::metric_page_history $pagename
	}
	# when tank is empty, stay on current page
	set_next_page "tankempty" $pagename
}
proc metric_history_pop {} {
	# remove last item
	set ::metric_page_history [lreplace $::metric_page_history end end]

	set pagename [lindex $::metric_page_history end]
	if {$pagename == ""} {
		set pagename "off"
	} else {
		# remove last item
		set ::metric_page_history [lreplace $::metric_page_history end end]
	}
	return $pagename
}

proc metric_jump_to { pagename } {
	set_next_page "off" $pagename
	page_show "off"
	start_idle
	if {[lindex $::metric_page_history end] != $pagename} {
		metric_history_push $pagename
	}
}

proc metric_jump_to_no_history { pagename } {
	set_next_page "off" $pagename
	page_show "off"
	start_idle
}

proc metric_jump_back {} {
	set pagename [metric_history_pop]
	metric_jump_to $pagename
}

proc metric_jump_home {} {
	metric_jump_to "off"
	set ::metric_page_history "off"
}

proc metric_jump_current {} {
	set pagename [lindex $::metric_page_history end]
	metric_jump_to $pagename
}


### drawing functions ###

# convert back from screen coords to skin coords for calling functions like add_de1_text (note - can cause rounding roundtrip errors)
proc reverse_scale_x { in } { return [ expr { [skin_xscale_factor] * $in }] }
proc reverse_scale_y { in } { return [ expr { [skin_yscale_factor] * $in }] }

# add multiple visuals to multiple contexts
proc add_visual_items_to_contexts { contexts tags } {
    set context_list [split $contexts " "]
    set tag_list [split $tags " " ]
    foreach context $context_list {
        foreach tag $tag_list {
            add_visual_item_to_context $context $tag
        }
    }
}

proc rounded_rectangle {contexts canvas x1 y1 x2 y2 radius colour } {
	if { [info exists ::_rect_id] != 1 } { set ::_rect_id 0 }
	set tag "rect_$::_rect_id"
    $canvas create oval $x1 $y1 [expr $x1 + $radius] [expr $y1 + $radius] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
    $canvas create oval [expr $x2-$radius] $y1 $x2 [expr $y1 + $radius] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
    $canvas create oval $x1 [expr $y2-$radius] [expr $x1+$radius] $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
    $canvas create oval [expr $x2-$radius] [expr $y2-$radius] $x2 $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
    $canvas create rectangle [expr $x1 + ($radius/2.0)] $y1 [expr $x2-($radius/2.0)] $y2 -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
    $canvas create rectangle $x1 [expr $y1 + ($radius/2.0)] $x2 [expr $y2-($radius/2.0)] -fill $colour -outline $colour -width 0 -tag $tag -state "hidden"
	add_visual_items_to_contexts $contexts $tag
	incr ::_rect_id
	return $tag
}

proc create_grid { } {
	for {set x 80} {$x < 2560} {incr x 100} {
		.can create line [rescale_x_skin $x] [rescale_y_skin 0] [rescale_x_skin $x] [rescale_y_skin 1600] -width 1 -fill "#fff" -tags "grid" -state "hidden"
		.can create text [rescale_x_skin $x] 0 -text $x -font [get_font "Mazzard Regular" 12] -fill $::color_text -anchor "nw" -tag "grid" -state "hidden"
	}
	for {set y 60} {$y < 1600} {incr y 60} {
		.can create line [rescale_x_skin 0] [rescale_y_skin $y] [rescale_x_skin 2560] [rescale_y_skin $y] -width 1 -fill "#fff" -tags "grid" -state "hidden"
		.can create text 0 [rescale_y_skin $y] -text $y -font [get_font "Mazzard Regular" 12] -fill $::color_text -anchor "nw" -tag "grid" -state "hidden"
	}
}