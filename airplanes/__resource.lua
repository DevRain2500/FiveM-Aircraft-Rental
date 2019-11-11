resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
dependency 'NativeUI'
description "Airplane rental script made by DevoutRain2500"

files {
	'vehiclelayouts.meta',
	'scamp_vehiclelayouts.meta',
	'vehicles.meta',
	'carvariations.meta',
	'handling.meta',
}

data_file 'VEHICLE_LAYOUTS_FILE' 'scamp_vehiclelayouts.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'vehiclelayouts.meta'
data_file 'HANDLING_FILE' 'handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'vehicles.meta'
data_file 'VEHICLE_VARIATION_FILE' 'carvariations.meta'

client_script '@NativeUI/NativeUI.lua'
client_script "c_airplanes.lua"
