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

