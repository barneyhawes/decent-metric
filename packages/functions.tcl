### helper functions ###

proc is_connected {} {return [expr {[clock seconds] - $::de1(last_ping)} < 5]}
proc is_heating {} { return [expr [is_connected] && $::de1(substate) == 1] }
# multiple water refill point by 1.1 because the DE1 can shut off just before this is reached
proc has_water {} { return [expr ![is_connected] || $::de1(water_level) > ($::settings(water_refill_point) * 1.1)] }

proc get_water_level {} {
	if {[expr ![is_connected]]} {return 0}
	return $::de1(water_level) 
}
proc get_min_water_level {} {return $::settings(water_refill_point)}
proc get_max_water_level {} {return [expr $::settings(water_level_sensor_max) * 0.9]}

proc get_machine_temperature {} {
		if {[expr ![is_connected]]} {return 0}
		#TODO: watertemp works in simulator
		return [group_head_heater_temperature]
}
proc get_min_machine_temperature {} {return $::settings(minimum_water_temperature)}


proc get_status_text {} {
	if {[expr ![is_connected]]} {
		return [translate "disconnected"]
	}

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

# for the main functions (espresso, steam, water, flush), each has can_start_action and do_start_action functions
proc can_start_espresso {} { return [expr [is_connected] && ($::de1(substate) == 0) && [has_water]] }
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
	set_next_page "off" "espresso_done"
	metric_history_push "espresso_done"
}

proc can_start_steam {} { return [expr [is_connected] && ($::de1(substate) == 0) && [has_water]] }
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

proc can_start_water {} { return [expr [is_connected] && ($::de1(substate) == 0) && [has_water]] }
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

proc can_start_flush {} { return [expr [is_connected] && ($::de1(substate) == 0) && [has_water]] }
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