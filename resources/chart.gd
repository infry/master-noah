@icon("res://assets/sprites/nodes/chart_file.png")

extends Resource
class_name Chart

@export_group("Chart Data")

@export_range(0.0, 5.0, 0.1) var scroll_speed = 1.0
## Audio latency.
@export var offset = 0.0

# Actual Chart Storage
@export var chart_data = {
	
	"notes": [],
	"events": [],
	"tempos": {0.0: 60},
	"meters": {0.0: [4, 16]},
}

func get_notes_data() -> Array: return chart_data.get("notes")
func get_events_data() -> Array: return chart_data.get("events")
func get_tempos_data() -> Dictionary: return chart_data.get("tempos")
func get_meters_data() -> Dictionary:
	return chart_data.get("meters")

func get_tempo_at(time: float) -> float:
	time = max(0, time)
	var output: float = -1
	for point in get_tempos_data():
		if time >= point:
			output = get_tempos_data().get(point)
		else:
			continue
	
	return output

func get_meter_at(time: float) -> Array:
	time = max(0, time)
	var output: Array = []
	for point in get_meters_data():
		if time >= point:
			output = get_meters_data().get(point)
		else:
			continue
	
	return output

func get_tempo_time_at(time: float) -> float:
	time = max(0, time)
	var output: float = -1
	for point in get_tempos_data():
		if time >= point:
			output = point
	
	return output

enum ChartType {
	CODENAME,
	VSLICE,
	PSYCH,
	PSYCH_V1,
	UNDEFINED
}

static func load(path:String) -> Chart:
	
	if path.get_extension() == 'res': ##probably a chart already
		return load(path)
	elif path.get_extension() == 'json':
		
		var file_content = FileAccess.open(path, FileAccess.READ)
		if file_content:
			var json = JSON.parse_string(file_content.get_as_text())
			if json and json is Dictionary:
				print(chart_type_to_str(resolve_chart_type(json)))
	
	
	return null

static func resolve_chart_type(raw_json:Dictionary) -> ChartType:
	
	if raw_json.has('format'):
		var format:String = raw_json.get('format')
		if format.contains('psych_v1'):
			return ChartType.PSYCH_V1
	
	if raw_json.has('codenameChart'):
		return ChartType.CODENAME
	
	if raw_json.has('version') and raw_json.has('scrollSpeed'):
		return ChartType.VSLICE
	
	if raw_json.has('song') and raw_json.get('song').has('gfVersion'):
		return ChartType.PSYCH
	
	return ChartType.UNDEFINED


static func chart_type_to_str(type:ChartType) -> String:
	match type:
		ChartType.CODENAME: return "Codename"
		ChartType.VSLICE: return 'VSlice'
		ChartType.PSYCH: return 'Psych Legacy'
		ChartType.PSYCH_V1: return 'Psych V1'
	
	return "Undefined"
