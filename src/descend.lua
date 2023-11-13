

local function cartesian_product(sets) -- sets an array of sets (i.e. labeled 1, 2, ...)
    local result = {}
    local set_count = #sets
    local yield = coroutine.yield 
    LaTeX_print("Number of sets: " .. set_count)
    if set_count == 0 then 
        return coroutine.wrap(function() yield({}) end)
    end

    local function descend(depth)
        if depth > set_count then
            yield(result)
            return
        end
        for k,v in pairs(sets[depth]) do
            result[depth] = v
            descend(depth + 1)
        end
    end
    return coroutine.wrap(function() descend(1) end)
end

local function table_product(tables) -- tables an arbitrary table of tables
    local result = {}
    local count = #tables
    local yield = coroutine.yield 
    local names = toarray(tables)
    LaTeX_print("Number of tables: " .. count)
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
