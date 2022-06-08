DENEON = {
    enabled = false,
    neons_enabled = true,
    -- toggles_enabled = false,
    toggles_index = 1,
    lights_index = 1,
    loaded = false,
}
_PED, _VEH, _GTIMER = nil, nil, 0
local wm = WarMenu

-- [1] = toggles, [2] = colors
MyTimeraMs = {}
local function SetDeltaT(key, a)
    MyTimeraMs[key] = GetGameTimer() - a
end

local function GetDeltaT(key)
    return (GetGameTimer() - MyTimeraMs[key])
end

local function InitDeneon()
    -- if 1 == 1 then
    --     ToggleVehicleMod(GetVehiclePedIsUsing(PlayerPedId()), 22, true)
    -- end
    AddTextEntry("FMMC_MPM_NA", "Enter the RGB value, example: 255, 155, 50")
    SetDeltaT(1, 0)
    SetDeltaT(2, 0)

    wm.CreateMenu("main", LOCALE.menu_title, LOCALE.menu_subtitle)
    wm.CreateSubMenu('toggles', 'main', LOCALE.toggles_menu_subtitle)
    wm.CreateSubMenu('effects', 'main', LOCALE.effects_menu_subtitle)
    wm.OpenMenu("main")

    for i = 1, #CONFIG.TOGGLES do
        local e = CONFIG.TOGGLES[i]
        if e.echo then
            for k = #e.anim - 1, 2, -1 do
                e.anim[#e.anim + 1] = e.anim[k]
            end
        end
    end

    DENEON.loaded = true
end

---@param handle integer @Car handle
---@param data table @ value `:boolean` neon state
local function ToggleVehicleNeons(handle, data)
    for i = 0, #data - 1 do
        SetVehicleNeonLightEnabled(handle, i, data[i + 1])
    end
end

---@param handle integer @Car handle
---@param e table @Effect data
function AnimVehicleNeonsLight(handle, e)
    if e.type == 'step' then
        for i = 1, #e.colors do
            SetVehicleNeonLightsColour(handle, e.colors[i][1], e.colors[i][2], e.colors[i][3])
            while GetDeltaT(2) < 200 do Wait(0) end
            SetDeltaT(2, 0)
        end
    elseif e.type == 'breath' then
        for i = 1, #e.colors do
            for a = 0.0, 1.0, 0.1 do
                while GetDeltaT(2) < 50 do Wait(0) end
                SetDeltaT(2, 0)
                SetVehicleNeonLightsColour(handle,
                    math.floor(e.colors[i][1] * a),
                    math.floor(e.colors[i][2] * a),
                    math.floor(e.colors[i][3] * a)
                )
            end

            while GetDeltaT(2) < 50 do Wait(0) end
            SetDeltaT(2, 0)

            for a = 1.0, 0.0, -0.1 do
                while GetDeltaT(2) < 50 do Wait(0) end
                SetDeltaT(2, 0)
                SetVehicleNeonLightsColour(handle,
                    math.floor(e.colors[i][1] * a),
                    math.floor(e.colors[i][2] * a),
                    math.floor(e.colors[i][3] * a)
                )
            end
        end
    end
end

local function AnimVehicleNeonsToggle(handle, e)
    if GetDeltaT(1) > 200 then
        if not e.index or e.index > #e.anim then e.index = 1 end

        ToggleVehicleNeons(handle, e.anim[e.index])
        SetDeltaT(1, 0)

        e.index = e.index + 1
    end
end

local function interface()
    if wm.Begin("main") then
        if wm.CheckBox(LOCALE.main_script, DENEON.enabled) then
            DENEON.enabled = not DENEON.enabled
        end

        if wm.CheckBox(LOCALE.toggle_neons, DENEON.neons_enabled) then
            DENEON.neons_enabled = not DENEON.neons_enabled
            local bool = DENEON.neons_enabled
            ToggleVehicleNeons(_VEH, { bool, bool, bool, bool })
        end

        -- if wm.CheckBox("⚙ Enable Toggles", DENEON.toggles_enabled) then
        --     DENEON.toggles_enabled = not DENEON.toggles_enabled
        --     local bool = DENEON.neons_enabled
        --     ToggleVehicleNeons(_VEH, { bool, bool, bool, bool })
        -- end

        -- local xc = {
        --     [0] = "White",
        --     [1] = "Blue",
        --     [2] = "Electric_Blue",
        --     [3] = "Mint_Green",
        --     [4] = "Lime_Green",
        --     [5] = "Yellow",
        --     [6] = "Golden_Shower",
        --     [7] = "Orange",
        --     [8] = "Red",
        --     [9] = "Pony_Pink",
        --     [10] = "Hot_Pink",
        --     [11] = "Purple",
        --     [12] = "Blacklight"
        -- }
        -- for i = 0, 12 do
        --     local color = xc[i]
        --     if wm.Button("Headlight Color #" .. i, color) then
        --         SetVehicleXenonLightsColor(_VEH, i)
        --     end
        -- end

        wm.MenuButton(LOCALE.effects_menu_title, 'effects', '→→→')
        wm.MenuButton(LOCALE.toggles_menu_title, 'toggles', '→→→')

        wm.End()
    elseif wm.Begin("effects") then
        for i = 1, #CONFIG.COLORS do
            local e = CONFIG.COLORS[i]
            if e.input then
                local c_data = e.colors[1]
                local c_data_txt = table.concat(c_data, ', ')
                local pressed, input = wm.InputButton(("%s (%s)"):format(e.title, c_data_txt), "FMMC_MPM_NA", c_data_txt, 13, i == DENEON.lights_index and "✅" or '')

                if pressed then
                    c_data = {}
                    for color_value in input:gmatch("%d+") do
                        local len = #c_data
                        c_data[len + 1] = tonumber(color_value)
                    end
                    CONFIG.COLORS[i].colors[1] = c_data
                    DENEON.lights_index = i
                end
            else
                if wm.Button(e.title, i == DENEON.lights_index and "✅" or '') then
                    DENEON.lights_index = i
                end
            end
        end
        wm.End()
    elseif wm.Begin("toggles") then
        for i = 1, #CONFIG.TOGGLES do
            if wm.Button(CONFIG.TOGGLES[i].title, i == DENEON.toggles_index and "✅" or '') then
                DENEON.toggles_index = i
            end
        end
        wm.End()
    end
end

---@tick 300ms
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(300)
        _PED = PlayerPedId()
        _VEH = GetVehiclePedIsIn(_PED, false)

        SetEntityAlpha(_VEH, 153)
    end
end)

---@tick 10ms - Colors only
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(10)
        if DENEON.enabled and DENEON.neons_enabled  then
            AnimVehicleNeonsLight(_VEH, CONFIG.COLORS[DENEON.lights_index])
        end
    end
end)

---@tick 0ms - Main
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(0)
        _GTIMER = math.floor(GetGameTimer() / 100)

        interface()

        if DENEON.enabled and DENEON.neons_enabled then
            AnimVehicleNeonsToggle(_VEH, CONFIG.TOGGLES[DENEON.toggles_index])
        end
    end
end)

InitDeneon()

-- Menu Keybind
local event_name = "deunderglow:ShowMenu"
RegisterCommand(event_name, function()
    wm.OpenMenu("main")
end, false)

RegisterKeyMapping(event_name, "Open De Underglow Menu", "KEYBOARD", "F11")
