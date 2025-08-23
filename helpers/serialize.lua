local function serialize(tbl)
	local result = "{\n"

	local arg_type = type(tbl)

	if arg_type == "number" then
		result = result .. "  " .. tostring(tbl) .. ",\n"
	elseif arg_type == "table" then
		for k, v in pairs(tbl) do
			-- Format the key
			local key_str
			if type(k) == "string" then
				key_str = '["' .. tostring(k) .. '"]'
			else
				key_str = "[" .. tostring(k) .. "]"
			end

			-- Format the value
			local value_str
			if type(v) == "table" then
				value_str = serialize(v) -- Recurse for nested tables
			elseif type(v) == "string" then
				value_str = '"' .. tostring(v) .. '"'
			else
				value_str = tostring(v)
			end

			result = result .. "  " .. key_str .. " = " .. value_str .. ",\n"
		end
	end
	return result .. "}"
end

return serialize
