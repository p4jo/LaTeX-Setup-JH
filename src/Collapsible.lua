dofile("src/Helpers.lua")

-- CONDITIONS

conditions = {
    [0] = function (states) -- not the default document
        for name, state in pairs(states) do
            if state then
                return true
            end
        end
    end
}
function fulfilConditions(states)
    for i, condition in pairs(conditions) do
        if not condition(states) then
            return false
        end
    end
    return true
end

-- TYPES

types = {}

function DeclareCollapsible(name, color, parent)
    if parent == nil then
        parent = ""
    end
    types[name] = {
        isCollapsed = false,
        isUsed = false,
        color = color,
        counter = 0,
        parent = parent
    }
    if parent ~= "" then
        conditions[#conditions] = function(states)
            return (not states[name] or states[parent])
        end
    end
end

function labelV(name, remoteState)
    states = {}
    for k, type in pairs(types) do
        states[k] = type.isCollapsed
    end
    if not remoteState then
        return labelFromList(name, states)
    end

    local type = types[name]
    c = type.isCollapsed
    type.isCollapsed = not c
    local parent = type.parent

    if c and parent ~= "" and types[parent].isCollapsed then
        types[parent].isCollapsed = false
    end
    -- assert list ∈ documentList
    -- later, we might allow arbitrary conditions, thus we need to find the "closest" element in documentList with typ.isCollapsed = not c
    return labelFromList(name, states)
end
function labelFromList(name, states)
    local r = "E." .. name .. "-" .. types[name].counter
    for k, state in pairs(states) do
        r = r .. ", " .. (state and string.upper(k) or string.lower(k))
    end
    return r 
end
function label(name)
    return labelV(name, false)
end
function labelR(name)
    return labelV(name, true)
end

function activeTypes()
    -- return toarray(pairs(types), function(k, v) return v.isUsed end)
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

-- LATEX FUNCTIONS

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
        tex.sprint(
            "\\collapsibleCurrentEnvironmentContent"
        )
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



separator = "\\cleardoublepage"

documentList = nil
function nextDocument()

    local tuple = table.remove(documentList, 1)
    for i, b in pairs(tuple) do
        typ = types[activeTypes()[i]]
        typ.isCollapsed = b
        typ.counter = 0
        -- todo: reset all counters: chapters, theorems, even pages.
    end
end

function produceExtraDocuments()
    local lists = {}
    local _types = activeTypes()
    for k, _ in pairs(_types) do
        lists[k] = { [0] = false, [1] = true}
    end
    documentList = toarray(
        cartesian_product(lists), 
        fulfilConditions
    )
    
    LaTeX_print("Number of documents: " .. (#documentList + 1))

    for i, _ in pairs(documentList) do
        tex.sprint(
            separator ..
            "\\directlua{nextDocument()}" ..
            "\\collapsibleCurrentDocumentContent " 
        )
    end
end

-- debugging

if tex == nil then
    tex = {sprint=print}
    DeclareCollapsible("Ex", "blue")
    collapsibleEnvironment("Ex")
    produceExtraDocuments()
end
