
function LaTeX_Error(msg, msg2)
    msg = tostring(msg)--:gsub(" ", "~")
    msg2 = tostring(msg2)--:gsub(" ", "~")
    tex.sprint("\\PackageError{Collapsible}{" .. msg .. "}{".. msg2  .."}")
end

function LaTeX_print(msg)
    msg = tostring(msg)--:gsub(" ", "~")
    tex.sprint("\\typeout{" ..  msg .. "}")
end

function cartesian_product(sets) -- sets an array of sets (i.e. labeled 1, 2, ...)
    return table_product(sets)
end

function table_product(tables) -- tables an arbitrary table of tables
    local result = {}
    local count = #tables
    local yield = coroutine.yield 
    local names = tableKeys(tables)
    
    if count == 0 then 
        return coroutine.wrap(function() yield({}) end)
    end

    local function descend(depth)
        if depth > count then
            yield(result)
            return
        end
        for k,v in pairs(tables[names[depth]]) do
            result[names[depth]] = v
            descend(depth + 1)
        end
    end
    return coroutine.wrap(function() descend(1) end)
end

function tableKeys(table)
    return toArray(pairs(table))
end

function filteredTableKeys(check, table)
    return filterToArray(check, pairs(table))
end

-- takes an iterator (e.g. pairs(a table) or coroutine.wrap(something)) and returns an array of the values that are true under the check function
function toArray(next, invariantState, startValue)
    return filterToArray(nil, next, invariantState, startValue)
end

local function true_function(x) return true end
-- takes a function to bool and an iterator (e.g. pairs(a table) or coroutine.wrap(something)) and returns an array of the values that are true under the check function
function filterToArray(check, next, invariantState, startValue) 
    local arr = {}
	check = check or true_function
    for v in next, invariantState, startValue do
		if check(v) then
			arr[#arr + 1] = v
		end
    end
    return arr
end