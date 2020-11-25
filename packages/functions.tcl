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
	update_de1_async 1
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
	# TODO: only execute following lines if start_espresso is successful
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

proc metric_profile_changed {} {
	save_metric_settings_async
}

proc metric_grind_changed {} {
	save_metric_settings_async
}

proc metric_dose_changed {} {
	recalculate_yield
	save_metric_settings_async
}

proc metric_ratio_changed {} {
	recalculate_yield
	save_metric_settings_async
}

proc metric_yield_changed {} {
	recalculate_brew_ratio
	update_DE_yield
	save_metric_settings_async
}

proc metric_temperature_changed {} {
	if {[ifexists ::metric_temperature_delta] != 0} {
		change_espresso_temperature $::metric_temperature_delta
		set ::metric_temperature_delta 0
		save_profile_async
		update_de1_async
	}
}

proc recalculate_yield {} {
    set new_yield [expr $::metric_drink_settings(dose) * $::metric_drink_settings(ratio)]
    set new_yield [round_to_one_digits $new_yield]
    set ::metric_drink_settings(yield) $new_yield
    update_DE_yield
}

proc recalculate_brew_ratio {} {
    set new_ratio [round_to_one_digits [expr $::metric_drink_settings(yield) / $::metric_drink_settings(dose)]]
	if {$new_ratio < $::metric_setting_ratio_min} {
		set new_ratio $::metric_setting_ratio_min
    	set ::metric_drink_settings(ratio) $new_ratio
		recalculate_yield
	} elseif {$new_ratio > $::metric_setting_ratio_max} {
		set new_ratio $::metric_setting_ratio_max
    	set ::metric_drink_settings(ratio) $new_ratio
		recalculate_yield
	} else {
	    set ::metric_drink_settings(ratio) $new_ratio
	}
}

# Set the DE1 settings' stop-at-weight or stop-at-volume to the value for this skin
proc update_DE_yield {} {
	set new_yield $::metric_drink_settings(yield)
    if {[ifexists ::settings(settings_profile_type)] == "settings_2c"} {
		if {$::settings(scale_bluetooth_address) != ""} {
        	set ::settings(final_desired_shot_weight_advanced) $new_yield
		} else {
			set ::settings(final_desired_shot_volume_advanced) $new_yield
		}
    } else {
		if {$::settings(scale_bluetooth_address) != ""} {
        	set ::settings(final_desired_shot_weight) $new_yield
		} else {
			set ::settings(final_desired_shot_volume) $new_yield
		}
    }
	update_de1_async
	save_metric_settings_async
}

# defer sending update to DE1 in case there are multiple calls
# if called with flush parameter, send now if there are any pending updates
proc update_de1_async { {flush_queue 0 } } {
    if {[info exists ::metric_pending_update_de1] == 1} {
        after cancel $::metric_pending_update_de1; 
        unset -nocomplain ::metric_pending_update_de1
		if {flush_queue == 1} {
			save_settings_to_de1
		}
    }
	if {flush_queue == 0} {
    	set ::metric_pending_update_de1 [after 500 {save_settings_to_de1; unset -nocomplain ::metric_pending_update_de1}]
	}
}