dofile("src/Helpers.lua")

-- CONDITIONS

conditions = {
    [0] = function (states) -- do not print the default document, as it will be printed first by LaTeX, so that the isUsed flags are set correctly
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
    parent = parent or ""
    types[name] = {
        isCollapsed = false, 
        isUsed = false, -- during the first run through, isUsed will be set to true when the environment is used
        color = color,
        counter = 0,
        parent = parent
    }
    if parent ~= "" then
        conditions[#conditions] = function(states)
            return (not states[name] or states[parent])
            -- omit the documents where the parent is collapsed but this is open. Leave the documents where the parent is open and this may be collapsed or not
        end
    end
end

function stateListToString(states)
    local r = ""
    for k, isCollapsed in pairs(states) do
        r = r .. ", " .. (isCollapsed and string.lower(k) or string.upper(k))
    end
    return r:sub(3) -- remove the first ", "
end
function labelFromStateList(name, states)
    return "E." .. name .. "-" .. types[name].counter .. "." .. stateListToString(states)
end

function label(name)
    return labelV(name, false)
end
function labelR(name)
    return labelV(name, true)
end
function labelV(name, remoteState)
    local states = {}
    for k, type in pairs(types) do
        states[k] = type.isCollapsed
    end
    if remoteState then
        local type = types[name]
        local parent = type.parent
        
        -- remote state is opposite
        local c = type.isCollapsed
        states[name] = not c

        if c and parent ~= "" and states[parent] then
            states[parent] = false
        end
        -- assert states ∈ documentList
        -- later, we might allow arbitrary conditions, thus we need to find the "closest" element in documentList with typ.isCollapsed = not c
    end
    return labelFromStateList(name, states)
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
    LaTeX_print("Printing label for " .. name .. " with state " .. tostring(typ.isCollapsed) .. ": ".. label(name))
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
    LaTeX_print("Printing reference for " .. name .. " with state " .. tostring(typ.isCollapsed) .. ": ".. labelR(name))
    tex.sprint(
        "{"..
            "\\hypersetup{allcolors=" ..
                typ.color ..
            "}" ..
            "\\hyperref[" ..
                labelR(name) .. -- this uses the counter and the opposite state
            "]{"..
            -- name
            -- ..
            (typ.isCollapsed and "\\expandButton{" or "\\collapseButton{") ..
            typ.color .. 
            "}" ..
            "}" ..
        "}"
    )
end



separator = "\\collapsibleResetForNextDocument\\collapsibleResetForNextDocumentTwo"

documentList = nil
_types = nil
function setVariablesForNextDocument()
    local tuple = table.remove(documentList, 1)
    for i, b in pairs(tuple) do
        typ = types[_types[i]]
        typ.isCollapsed = b
        typ.counter = 0
    end
end

function produceExtraDocuments()
    local lists = {}
    _types = activeTypes()
    for k, _ in pairs(_types) do
        lists[k] = { [0] = false, [1] = true}
    end
    documentList = filterToArray(
        fulfilConditions,
        cartesian_product(lists)
    )
    
    LaTeX_print("Number of documents: " .. (#documentList + 1))

    for i, _ in pairs(documentList) do
        tex.sprint(
            "\\directlua{setVariablesForNextDocument()}" ..
            "\\typeout{Now parsing the CollapsibleDocument with parameters " ..
            stateListToString(documentList[i]) ..
            "}" ..
            "\\collapsibleCurrentDocumentContent " ..
            separator
        )
        -- while latex parses the content of \collapsibleCurrentDocumentContent, whenever an collapsible environment is encountered, it will call collapsibleEnvironment(name) which then operates with a different state, which was set when setVariablesForNextDocument() was called
    end
end

-- debugging

if tex == nil then
    tex = {sprint=print}
    DeclareCollapsible("Ex", "blue")
    -- collapsibleEnvironment("Ex")
    produceExtraDocuments()
end
