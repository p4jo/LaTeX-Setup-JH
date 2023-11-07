
types = {}

function DeclareCollapsible(name, color)
    types[name] = {
        isCollapsed = false,
        isUsed = false,
        color = color,
        counter = 0
    }
    LaTeX_print(label(name))
end

function labelV(name, otherState)
    local r = "E." .. name .. "-" .. types[name].counter
    for k, v in pairs(types) do
        r = r .. ", " .. k .. "=" .. ((v.isCollapsed ~= ((k == name) and otherState)) and "coll" or "exp")
    end
    return r 
end


function label(name)
    return labelV(name, false)
end
function labelR(name)
    return labelV(name, true)
end

function LaTeX_Error(msg, msg2)
    tex.sprint("\\PackageError{Collapsible}{" .. msg .. "}{".. msg2  .."}")
end

function LaTeX_print(msg)
    tex.sprint("\\typeout{" .. tostring(msg) .. "}")
end

function collapsibleEnvironment(name)
    -- check if name is in types
    --check if names is in types
    if types[name] == nil then
        LaTeX_Error("Collapsible environment " .. name .. " is not declared", "Use \\DeclareExpandableType{" .. name .. ", color} to declare it")
        return
    end

    local typ = types[name]
    typ.isUsed = true
    typ.counter = typ.counter + 1
    
    tex.sprint(
        "\\label{" .. 
            label(name) .. 
        "}"
    )
    
    if not typ.isCollapsed then
        tex.sprint("\\collapsibleCurrentEnvironmentContent")
    end

    tex.sprint(
        "{"..
            "\\hypersetup{allcolors=" ..
                typ.color ..
            "}" ..
            "\\hyperref[" ..
                labelR(name) ..
            "]{\\collapseButton{" ..
                typ.color .. 
            "}}" ..
        "}"
    )
end

local function activeTypes()
    local r = {}
    local i = 1
    for k, v in pairs(types) do
        if v.isUsed then
            r[i] = k
            i = i+1
        end
    end
    return r
end

local function cartesian_product(sets) -- assume sets to be indexed 1, 2, ...
    local result = {}
    local set_count = #sets
    local yield = coroutine.yield 
    LaTeX_print("Number of sets: " .. set_count)
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

function BuildArray(...)
    local arr = {}
    for v in ... do
      arr[#arr + 1] = v
    end
    return arr
  end


separator = "\\cleardoublepage"

documentList = nil
function nextDocument()
    local tuple = table.remove(documentList, 1)
    for i, b in pairs(tuple) do
        typ = types[activeTypes()[i]]
        typ.isCollapsed = b
        typ.counter = 0
    end
end

function produceExtraDocuments()
    local lists = {}
    local _types = activeTypes()
    for k, _ in pairs(_types) do
        lists[k] = { [0] = false, [1] = true}
    end

    documentList = BuildArray(cartesian_product(lists))
    LaTeX_print("Number of documents: " .. #documentList)
    table.remove(documentList, 1) -- this is the (false, false, ...) tuple, i.e. the default document
    for i, _ in pairs(documentList) do
        tex.sprint(
            separator ..
            "\\directlua{nextDocument()}" ..
            "\\collapsibleCurrentDocumentContent " 
        )
    end
end


if tex == nil then
    tex = {sprint=print}
    DeclareCollapsible("Ex", "blue")
    collapsibleEnvironment("Ex")
    produceDocument()
end
