require 'coffee-script'

# ---

to_value = (value) ->
	return switch value
		when 'none' then null
		when 'on' then true
		when 'off' then false
		when 'true' then true
		when 'false' then false
		else value
		
to_object = (previous, current) ->
	previous[key] = to_value(val) for key, val of current if current
	
	return previous
	
to_array = (previous, current) ->
	previous.push({}) if previous.length == 0 or current == null
	
	previous[previous.length - 1][key] = to_value(val) for key, val of current if current
	
	return previous
	
# ---

###
	@param {string} info
###
exports.linebreak_list = (input) ->
	to_item = (line) ->
		return null if not line
		
		line = line.replace(/^(.+?):\s*/, '"$1":"') + '"'
		
		return JSON.parse("{#{line}}")
		
	return input.split('\n').map(to_item).reduce(to_array, []).filter((item) -> Object.keys(item).length > 0)
	
###
	* @param {string} input
###
exports.namepair_list = (input) ->
	to_item = (line) ->
		line = line.replace(/" {/, '":"{')
		line = line + '"' if line
		
		return JSON.parse("{#{line}}")
		
	input.split('\n').map(to_item).reduce(to_object)
	
###
	* @param {string} input
###
exports.machinereadable_list = (input) ->
	to_item = (line) ->
		line = line.replace(/^(.+)=/, '"$1"=') if line[0] != '"'
		line = line.replace(/^(".+")=/, '$1:')
		
		return JSON.parse("{#{line}}")
		
	return input.split('\n').map(to_item).reduce(to_object)
	