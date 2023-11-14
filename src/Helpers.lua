
function LaTeX_Error(msg, msg2)
    msg = tostring(msg)--:gsub(" ", "~")
    msg2 = tostring(msg2)--:gsub(" ", "~")
    tex.sprint("\\PackageError{Collapsible}{" .. msg .. "}{".. msg2  .."}")
end

function LaTeX_print(msg)
    msg = tostring(msg)--:gsub(" ", "~")
    tex.sprint("\\typeout{" ..  msg .. "}")
end

function cartesian_product(sets) -- assume sets to be indexed 1, 2, ...; yields  indexed 1, 2, ...
    local result = {}
    local set_count = #sets
    local yield = coroutine.yield 
    if set_count == 0 then 
        return coroutine.wrap(function() yield({}) end)
    end

    local function descend(depth)
		if depth == set_count then
			for k,v in pairs(sets[depth]) do
				result[depth] = v
				yield(result)
			end
		else
			for k,v in pairs(sets[depth]) do
				result[depth] = v
				descend(depth + 1)
			end
		end
    end
    return coroutine.wrap(function() descend(1) end)
end

function toarray(stuff, check) -- one based array
    local arr = {}
	if check == nil then
		check = function(x) return true end
	end
    for v in stuff do
		if check(v) then
			arr[#arr + 1] = v
		end
    end
    return arr
end