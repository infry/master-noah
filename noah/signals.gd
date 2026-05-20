extends Node

## Signal to be emitted when the countdown is ready to begin.
## Emit this at a later point if u have a intro cutscene
signal play_host_initiated

signal play_conductor_step_hit(step: int, measure: int)
signal play_conductor_beat_hit(step: int, measure: int)


signal play_note_hit
signal play_note_miss
signal play_note_holding


#
signal play_note_created(note)
signal play_new_event(event_name: String, params: Array, time: float)
