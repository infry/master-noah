extends BasicSong

func note_hit(time, lane, note_type, hit_time, strum_manager):
	get_tree().set_group(get_group_from_manager(strum_manager), "animation_prefix",
	&"mom_" if str(note_type) == "mom" else &"")
	super(time, lane, note_type, hit_time, strum_manager)
