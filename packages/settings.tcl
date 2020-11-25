### settings functions ###

proc metric_settings_filename {} {
    return "[skin_directory]/userdata/metric settings.tdb"
}

proc metric_drink_filename {} {
    if {[info exists ::metric_drink] != 1} { set ::metric_drink "A" }
    return "[skin_directory]/userdata/drink-$::metric_drink.tdb"
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
    save_metric_array_to_file ::metric_settings [metric_settings_filename]
    save_metric_array_to_file ::metric_drink_settings [metric_drink_filename]
}

proc save_metric_settings_async { {flush_queue 0 } } {
    if {[info exists ::metric_pending_save_settings] == 1} {
        after cancel $::metric_pending_save_settings; 
        unset -nocomplain ::metric_pending_save_settings
        if {$flush_queue == 1} {
			save_metric_settings
		}
    }
    if {$flush_queue == 0} {
        set ::metric_pending_save_settings [after 100 { save_metric_settings; unset -nocomplain ::metric_pending_save_settings}]
    }
}

proc set_default_setting { varname value } {
    if {[info exists $varname] != 1} { set $varname $value }
}

proc load_metric_settings {} {
    array set ::metric_settings [encoding convertfrom utf-8 [read_binary_file [metric_settings_filename]]]
    set_default_setting ::metric_settings(profile_filename_a) "default"
    set_default_setting ::metric_settings(profile_filename_b) "Pour over"

    array set ::metric_drink_settings [encoding convertfrom utf-8 [read_binary_file [metric_drink_filename]]]
    # set_default_setting ::metric_drink_settings(beans) [translate "Unknown"]
    # set_default_setting ::metric_drink_settings(grind) $::metric_setting_grind_default
    # set_default_setting ::metric_drink_settings(dose) $::metric_setting_dose_default
    # set_default_setting ::metric_drink_settings(ratio) $::metric_setting_ratio_default
    # set_default_setting ::metric_drink_settings(yield) $::metric_setting_yield_default
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

proc save_profile_async { } {
    if {[info exists ::metric_pending_save_profile] == 1} {
        after cancel $::metric_pending_save_profile; 
        unset -nocomplain ::metric_pending_save_profile
    }
    set ::metric_pending_save_profile [after 500 save_profile]
}

# defer sending update to DE1 in case there are multiple calls
# if called with flush parameter, send now if there are any pending updates
proc update_de1_async { {flush_queue 0 } } {
    if {[info exists ::metric_pending_update_de1] == 1} {
        after cancel $::metric_pending_update_de1; 
        unset -nocomplain ::metric_pending_update_de1
		if {$flush_queue == 1} {
			save_settings_to_de1
		}
    }
	if {$flush_queue == 0} {
    	set ::metric_pending_update_de1 [after 500 {save_settings_to_de1; unset -nocomplain ::metric_pending_update_de1}]
	}
}