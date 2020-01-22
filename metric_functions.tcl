package provide metric_functions 1.0

# This is a drop-in replacement for John's load_font function in utils.tcl.  I'm hoping he'll update that and I can then delete this.
proc metric_load_font {name fn pcsize {androidsize {}} } {
    # calculate font size
    if {($::android == 1 || $::undroid == 1) && $androidsize != ""} {
        set pcsize $androidsize
    }
    set platform_font_size [expr {int(1.0 * $::fontm * $pcsize)}]

    if {[language] == "zh-hant" || [language] == "zh-hans"} {
        set fn ""
        set familyname $::helvetica_font
    } elseif {[language] == "th"} {
        set fn "[homedir]/fonts/sarabun.ttf"
    }

    if {[info exists ::loaded_fonts] != 1} {
        set ::loaded_fonts list
    }
    set fontindex [lsearch $::loaded_fonts $fn]
    if {$fontindex != -1} {
        set familyname [lindex $::loaded_fonts [expr $fontindex + 1]]
    } elseif {($::android == 1 || $::undroid == 1) && $fn != ""} {
        catch {
            set familyname [lindex [sdltk addfont $fn] 0]
        }
        lappend ::loaded_fonts $fn $familyname
    }

    if {[info exists familyname] != 1 || $familyname == ""} {
        msg "Font familyname not available; using name '$name'."
        set familyname $name
    }

    catch {
        font create $name -family $familyname -size $platform_font_size
    }
    msg "added font name: \"$name\" family: \"$familyname\" size: $platform_font_size filename: \"$fn\""
}

proc metric_get_font { font_name size } {
	if {[info exists ::metric_fonts] != 1} {
        set ::metric_fonts list
    }

	set font_key "$font_name $size"
	set font_index [lsearch $::metric_fonts $font_key]
	if {$font_index == -1} {
		metric_load_font $font_key "[skin_directory]/fonts/$font_name.otf" $size
		lappend ::metric_fonts $font_key
	}

	return $font_key
}


### settings functions ###

proc metric_filename {} {
    return "[skin_directory]/userdata/metric_usersettings.tdb"
}

proc append_file {filename data} {
    set success 0
    set errcode [catch {
        set fn [open $filename a]
        puts $fn $data
        close $fn
        set success 1
    }]
    if {$errcode != 0} {
        msg "append_file $::errorInfo"
    }
    return $success
}

proc save_metric_array_to_file {arrname fn} {
    upvar $arrname item
    set metric_data {}
    foreach k [lsort -dictionary [array names item]] {
        set v $item($k)
        append metric_data [subst {[list $k] [list $v]\n}]
    }
    write_file $fn $metric_data
}

proc save_metric_settings {} {
    save_metric_array_to_file ::metric_settings [metric_filename]
}

proc load_metric_settings {} {
    array set ::metric_settings [encoding convertfrom utf-8 [read_binary_file [metric_filename]]]
}



### helper functions ###

proc get_status_text {} {
	switch $::de1(substate) {
		"-" { 
			return "starting"
		}
		0 {
			return "ready"
		}
		1 {
			return "heating"
		}
		3 {
			return "stabilising"
		}
		4 {
			return "preinfusion"
		}
		5 {
			return "pouring"
		}
		6 {
			return "ending"
		}
		17 {
			return "refilling"
		}
		default {
			set result [de1_connected_state 0]
			if {$result == ""} { return "unknown" }
			return $result
		}
	}

}

# some handy boolean status functions
proc is_heating {} { return [expr $::de1(substate) == 1] }
proc has_water {} { return [expr $::de1(water_level) > $::settings(water_refill_point)] }

# for the main functions (espresso, steam, water, flush), each has can_start_action and do_start_action functions
proc can_start_espresso {} { return [expr ($::de1(substate) == 0) && [has_water]] }
proc do_start_espresso {} {
	if {[is_heating]} { 
		borg toast [translate "Please wait for heating"]
		return
	}
	if {[expr ![has_water]]} {
		borg toast [translate "Please refill water tank"]
		return
	}
	if { $::de1(substate) != 0 } {
		borg toast [translate "Machine is not ready"]
		return
	}
	start_espresso
}

proc can_start_steam {} { return [expr ($::de1(substate) == 0) && [has_water]] }
proc do_start_steam {} {
	if {[is_heating]} { 
		borg toast [translate "Please wait for heating"]
		return
	}
	if {[expr ![has_water]]} {
		borg toast [translate "Please refill water tank"]
		return
	}
	if { $::de1(substate) != 0 } {
		borg toast [translate "Machine is not ready"]
		return
	}
	start_steam
}

proc can_start_water {} { return [expr ($::de1(substate) == 0) && [has_water]] }
proc do_start_water {} {
	if {[is_heating]} { 
		borg toast [translate "Please wait for heating"]
		return
	}
	if {[expr ![has_water]]} {
		borg toast [translate "Please refill water tank"]
		return
	}
	if { $::de1(substate) != 0 } {
		borg toast [translate "Machine is not ready"]
		return
	}
	start_water
}

proc can_start_flush {} { return [expr ($::de1(substate) == 0) && [has_water]] }
proc do_start_flush {} {
	if {[is_heating]} { 
		borg toast [translate "Please wait for heating"]
		return
	}
	if {[expr ![has_water]]} {
		borg toast [translate "Please refill water tank"]
		return
	}
	if { $::de1(substate) != 0 } {
		borg toast [translate "Machine is not ready"]
		return
	}
	set ::settings(preheat_temperature) 90
	set_next_page hotwaterrinse flush
	start_hot_water_rinse
}

# helper proc for named arguments
# creates a variable called _argname for each parameter -argname
# there may be a better way to do this in Tcl!
proc named {args defaults} {
	foreach {key value} [string map {- _} $defaults] {
		upvar 1 $key varname
		set varname $value
	}

	foreach {key value} [string map {- _} $args] {
		upvar 1 $key varname
		set varname $value
	}
}

proc adjust_setting {varname delta minval maxval} {
	if {[info exists $varname] != 1} { set $varname 0 }
	set currentval [subst \$$varname]
	set newval [expr $currentval + $delta]
	set newval [round_one_digits $newval]
	if {$newval > $maxval} {
		set $varname $maxval
	} elseif {$newval < $minval} {
		set $varname $minval
	} else {
		set $varname [round_one_digits $newval]
	}
	return $newval
}

proc recalculate_cup_weight {} {
    set new_weight [expr $::metric_settings(bean_weight) * $::metric_settings(brew_ratio)]
    set new_weight [round_to_one_digits $new_weight]
    set ::metric_settings(cup_weight) [round_to_one_digits $new_weight]
    save_metric_settings
    update_cup_weight
}

proc recalculate_brew_ratio {} {
    set ::metric_settings(brew_ratio) [round_to_one_digits [expr $::metric_settings(cup_weight) / $::metric_settings(bean_weight)]]
    save_metric_settings
}

# Set the DE settings' cup weight to the value for this skin
proc update_cup_weight {} {
    if {[ifexists ::settings(settings_profile_type)] == "settings_2c"} {
        set $::settings(final_desired_shot_weight_advanced) $::metric_settings(cup_weight)]]
    } else {
        set $::settings(final_desired_shot_weight) $::metric_settings(cup_weight)]]
    }
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
    $canvas create oval $x1 $y1 [expr $x1 + $radius] [expr $y1 + $radius] -fill $colour -outline $colour -width 0 -tag $tag
    $canvas create oval [expr $x2-$radius] $y1 $x2 [expr $y1 + $radius] -fill $colour -outline $colour -width 0 -tag $tag
    $canvas create oval $x1 [expr $y2-$radius] [expr $x1+$radius] $y2 -fill $colour -outline $colour -width 0 -tag $tag
    $canvas create oval [expr $x2-$radius] [expr $y2-$radius] $x2 $y2 -fill $colour -outline $colour -width 0 -tag $tag
    $canvas create rectangle [expr $x1 + ($radius/2.0)] $y1 [expr $x2-($radius/2.0)] $y2 -fill $colour -outline $colour -width 0 -tag $tag
    $canvas create rectangle $x1 [expr $y1 + ($radius/2.0)] $x2 [expr $y2-($radius/2.0)] -fill $colour -outline $colour -width 0 -tag $tag
	add_visual_items_to_contexts $contexts $tag
	incr ::_rect_id
	return $tag
}

proc create_button { contexts x1 y1 x2 y2 text font backcolor textcolor action } {
	if { [info exists ::_button_id] != 1 } { set ::_button_id 0 }
	rounded_rectangle $contexts .can [rescale_x_skin $x1] [rescale_y_skin $y1] [rescale_x_skin $x2] [rescale_y_skin $y2] [rescale_x_skin 80] $backcolor
	add_de1_text $contexts [expr ($x1 + $x2) / 2.0 ] [expr ($y1 + $y2) / 2.0 ] -text $text -font $font -fill $textcolor -anchor "center" -tag "button_text_$::_button_id"
	add_de1_button $contexts $action $x1 $y1 $x2 $y2
	incr ::_button_id
}

proc create_action_button { contexts x y text font backcolor textcolor action fullscreen } {
	if { [info exists ::_button_id] != 1 } { set ::_button_id 0 }
    set radius 180
    set x1 [expr $x - $radius]
    set y1 [expr $y - $radius]
    set x2 [expr $x + $radius]
    set y2 [expr $y + $radius]
    .can create oval [rescale_x_skin $x1] [rescale_y_skin $y1] [rescale_x_skin $x2] [rescale_y_skin $y2] -fill $backcolor -width 0 -tag "button_$::_button_id" -state hidden
    add_visual_item_to_context $contexts "button_$::_button_id"
    add_de1_text $contexts $x $y -text $text -font $font -fill $textcolor -anchor "center" 
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


oo::class create meter {
	variable _x _y _width _minvalue _maxvalue _arc_range _arc_color _needle_width _needle_color
	variable _tick_width _tick_frequency _tick_color _label_frequency _label_color _label_font _title _title_font _units _show_empty_full
	variable _get_meter_value
    variable _get_target_value

	variable _meter_needle_id _meter_target_id
	variable _arc_width _center_x _center_y _needle_length
	variable _contexts

	variable _previous_value

	constructor { args } {
		set defaults {-x 0 -y 0 -width 100 -minvalue 0 -maxvalue 10 -arc_range 240 -arc_color #777 -needle_width 4 -needle_color #e00 -tick_width 2 -tick_frequency 1 -label_frequency 0 -label_color #fff -get_meter_value "" -show_empty_full 0 -tick_color #fff -contexts "x" -title "" -units "" -get_target_value ""}
		named $args $defaults

		if {$_width < [rescale_x_skin 300]} {
			set _label_font [metric_get_font "Mazzard Medium" 12]
			set _title_font [metric_get_font "Mazzard Regular" 12]
		} elseif {$_width < [rescale_x_skin 600]} {
			set _label_font [metric_get_font "Mazzard Medium" 18]
			set _title_font [metric_get_font "Mazzard Regular" 20]
		} else {
			set _label_font [metric_get_font "Mazzard Medium" 22]
			set _title_font [metric_get_font "Mazzard Regular" 24]
		}
		set _arc_width [expr [reverse_scale_x $_width] * 0.035]
		set _center_x [expr ($_x + ($_width / 2.0))]
		set _center_y [expr ($_y + ($_width / 2.0))]
		set _needle_length [expr (($_width - ($_arc_width * 2.0) - ($_needle_width * 3.0)) / $_width)]
		set _previous_value 0
		my draw
	}

	method get_angle_from_percent { percent } {
		# calculate angle of needle
		set arc_min [expr ($_arc_range / 2.0) + 90.0]
		set angle [expr $arc_min - ($_arc_range * $percent)]
		set degrees_to_radians 0.017453292519943001
		return [expr $angle * $degrees_to_radians]
	}

	# set the coordinates of a line to be a radial of the dial.  Use for positioning tick marks and needle.
	# inner and outer are the start and finish positions of the needle (0.0 = centre, 1.0 = on dial)
	method set_radial_coords { item_id inner outer value } {
		set percent [expr (($value - $_minvalue) / ($_maxvalue - $_minvalue))]
		set inner_radius [expr ($_width * $inner / 2.0)]
		set outer_radius [expr ($_width * $outer / 2.0)]

		# limit value to range 0.0 .. 1.0
		set value [expr min (1.0, max(0.0, $value))]

		# calculate angle of needle
		set needle_angle_rads [my get_angle_from_percent $percent]

		# get (x,y) for ends of needle
		set inner_x [expr ($_center_x + ($inner_radius * cos ($needle_angle_rads)))]
		set inner_y [expr ($_center_y + ($inner_radius * -sin ($needle_angle_rads)))]
		set outer_x [expr ($_center_x + ($outer_radius * cos ($needle_angle_rads)))]
		set outer_y [expr ($_center_y + ($outer_radius * -sin ($needle_angle_rads)))]

		.can coords $item_id $inner_x $inner_y $outer_x $outer_y
	}

	method draw_number { value label } {
		set percent [expr (($value - $_minvalue) / ($_maxvalue - $_minvalue))]
		set angle_rads [my get_angle_from_percent $percent]
		set radius [expr ($_width * 0.33)]
		set x [expr $_center_x + ($radius * cos ($angle_rads)) ]
		set y [expr $_center_y - ($radius * sin ($angle_rads)) ]

		add_de1_text $_contexts [expr [reverse_scale_x $x]] [expr [reverse_scale_y $y]] -justify center -anchor "center" -text $label -font $_label_font -fill $_label_color -width $_width
	}

	method draw {} {
		# pre-calculate some geometry
		set meter_x0 [expr $_x + ($_arc_width / 2.0)]
		set meter_y0 [expr $_y + ($_arc_width / 2.0)]
		set meter_x1 [expr $_x + $_width - ($_arc_width / 2.0)]
		set meter_y1 [expr $_y + $_width - ($_arc_width / 2.0)]
		set arc_min [expr ($_arc_range / 2.0) + 90.0]

        # draw the target value
        set _meter_target_id [.can create line 0 0 0 0 -width [expr $_arc_width * 0.5] -fill $_needle_color -capstyle round -state "hidden"]
		add_visual_items_to_contexts $_contexts $_meter_target_id

		# draw the arc
		set item_id [.can create arc $meter_x0 $meter_y0 $meter_x1 $meter_y1 -start $arc_min -extent [expr $_arc_range * -1] -style arc -width $_arc_width -outline $_arc_color]
		add_visual_items_to_contexts $_contexts $item_id

		# add some tick marks
		if {$_tick_frequency > 0} {
			for {set i [expr $_minvalue + $_tick_frequency]} {$i < $_maxvalue} { set i [expr $i + $_tick_frequency] } {
				set item_id [.can create line 0 0 0 0 -width $_tick_width -fill $_tick_color]
				my set_radial_coords $item_id 0.8 0.92 $i
				add_visual_items_to_contexts $_contexts $item_id
			}
		}

		if {$_label_frequency > 0} {
			for {set i $_minvalue} {$i <= $_maxvalue} { set i [expr $i + $_label_frequency] } {
				my draw_number $i [round_to_integer $i] 
			}
		}

		if {$_show_empty_full == 1} {
			my draw_number $_minvalue [translate "E"]
			my draw_number $_maxvalue [translate "F"]
		}

		add_de1_text $_contexts [expr [reverse_scale_x [expr $_x + ($_width/2.0)]]] [expr [reverse_scale_y [expr $_y + ($_width * 0.665)]]] -anchor "center" -text $_units -font $_label_font -fill $_label_color 

		add_de1_text $_contexts [expr [reverse_scale_x [expr $_x + ($_width/2.0)]]] [expr [reverse_scale_y [expr $_y + ($_width * 0.84)]]] -anchor "center" -text $_title -font $_title_font -fill $_needle_color 

		# add needle
		set _meter_needle_id [.can create line 0 0 0 0 -width $_needle_width -fill $_needle_color -capstyle round]
		add_visual_items_to_contexts $_contexts $_meter_needle_id
		my update
	}

	method smooth { value } {
		set mean [expr ($value + $_previous_value) / 2.0]
		set _previous_value $value
		return $mean
	}

	method update { } {
		if {[.can itemcget $$_meter_needle_id -state] != "hidden"} {
			set value [$_get_meter_value]
			set value [my smooth $value]
			if {$value < $_minvalue} { set value $_minvalue }
			if {$value > $_maxvalue} { set value $_maxvalue }
			my set_radial_coords $_meter_needle_id 0.0 $_needle_length $value
		}

        if {$_get_target_value != "" && [.can itemcget $$_meter_needle_id -state] != "hidden"} {
            set target [$_get_target_value]
            if {$target <= $_minvalue || $target >= $_maxvalue} {
                .can coords $_meter_target_id -100 -100 -100 -100
            } else {
                my set_radial_coords $_meter_target_id 0.98 1.1 $target
            }
        }
	}
}
