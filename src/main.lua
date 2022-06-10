DENEON = {
    should_draw = false,
    enabled = false,
    neons_enabled = false,
    -- toggles_enabled = false,
    toggles_index = 1,
    lights_index = 1,
    loaded = false,
}
DELTAT_DATA = {0,0}
_GTIMER, _PED, _VEH, _IN_CAR  = 0, nil, nil, nil
local wm = WarMenu

local function SetDeltaT(key, a)
    DELTAT_DATA[key] = _GTIMER - a
end

local function GetDeltaT(key)
    return _GTIMER - DELTAT_DATA[key]
end

local function DeltaWait(timer_key, ms)
    while GetDeltaT(timer_key) < ms do Wait(0) end
    SetDeltaT(timer_key, 0)
end

---@param handle integer @Car handle
---@param data table @ value `:boolean` neons state
function ToggleVehicleNeons(handle, data)
    for i = 0, #data - 1 do
        SetVehicleNeonLightEnabled(handle, i, data[i + 1])
    end
end

---@param handle integer @Car handle
---@param e table @Effect data
function AnimVehicleNeonsColor(handle, e)
    if e.type == 'step' then
        for i = 1, #e.colors do
            SetVehicleNeonLightsColour(handle, e.colors[i][1], e.colors[i][2], e.colors[i][3])
            DeltaWait(2, 200)
        end
    elseif e.type == 'breath' then
        for i = 1, #e.colors do
            for a = 0.0, 1.0, 0.1 do
                DeltaWait(2, 20)
                SetVehicleNeonLightsColour(handle,
                    math.floor(e.colors[i][1] * a),
                    math.floor(e.colors[i][2] * a),
                    math.floor(e.colors[i][3] * a)
                )
            end

            DeltaWait(2, 20)

            for a = 1.0, 0.0, -0.1 do
                DeltaWait(2, 20)
                SetVehicleNeonLightsColour(handle,
                    math.floor(e.colors[i][1] * a),
                    math.floor(e.colors[i][2] * a),
                    math.floor(e.colors[i][3] * a)
                )
            end
        end
    end
end

---@param handle integer @Car handle
---@param e table @Effect data
function AnimVehicleNeonsToggle(handle, e)
    if GetDeltaT(1) > 200 then
        if not e.index or e.index > #e.anim then e.index = 1 end

        ToggleVehicleNeons(handle, e.anim[e.index])
        SetDeltaT(1, 0)

        e.index = e.index + 1
    end
end

function ToggleMenu(bool)
    if bool then
        wm.OpenMenu('deunderglow_main')
    else
        wm.CloseMenu()
    end
    DENEON.should_draw = bool
end

local function DrawMenu()
    if wm.Begin("deunderglow_main") then
        if wm.CheckBox(LOCALE.main_script, DENEON.enabled) then
            DENEON.enabled = not DENEON.enabled
        end

        if wm.CheckBox(LOCALE.toggle_neons, DENEON.neons_enabled) then
            DENEON.neons_enabled = not DENEON.neons_enabled
            local bool = DENEON.neons_enabled
            ToggleVehicleNeons(_VEH, { bool, bool, bool, bool })
        end

        wm.MenuButton(LOCALE.effects_menu_title, 'deunderglow_effects', '→→→')
        wm.MenuButton(LOCALE.toggles_menu_title, 'deunderglow_toggles', '→→→')

        wm.End()
    elseif wm.Begin("deunderglow_effects") then
        for i = 1, #COLORS do
            local e = COLORS[i]
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
                    COLORS[i].colors[1] = c_data
                    DENEON.lights_index = i
                end
            else
                if wm.Button(e.title, i == DENEON.lights_index and "✅" or '') then
                    DENEON.lights_index = i
                end
            end
        end
        wm.End()
    elseif wm.Begin("deunderglow_toggles") then
        for i = 1, #TOGGLES do
            if wm.Button(TOGGLES[i].title, i == DENEON.toggles_index and "✅" or '') then
                DENEON.toggles_index = i
            end
        end
        wm.End()
    end
end

local function InitialSettings()
    AddTextEntry("FMMC_MPM_NA", "Enter the RGB value, example: 255, 155, 50")

    SetDeltaT(1, 0)
    SetDeltaT(2, 0)

    wm.CreateMenu("deunderglow_main", LOCALE.menu_title, LOCALE.menu_subtitle)
    wm.CreateSubMenu('deunderglow_toggles', 'deunderglow_main', LOCALE.toggles_menu_subtitle)
    wm.CreateSubMenu('deunderglow_effects', 'deunderglow_main', LOCALE.effects_menu_subtitle)
    wm.SetMenuStyle('deunderglow_main', MENU_STYLE)
    wm.SetMenuStyle('deunderglow_toggles', MENU_STYLE)
    wm.SetMenuStyle('deunderglow_effects', MENU_STYLE)

    for i = 1, #TOGGLES do
        local e = TOGGLES[i]
        if e.echo then
            for k = #e.anim - 1, 2, -1 do
                e.anim[#e.anim + 1] = e.anim[k]
            end
        end
    end

    -- Menu Keybind
    if MENU_TOGGLE_KEY then
        RegisterCommand(MENU_COMMAND, function()
            ToggleMenu(not wm.IsAnyMenuOpened())
        end, false)
        RegisterKeyMapping(MENU_COMMAND, "Open de_underglow Menu", "KEYBOARD", MENU_TOGGLE_KEY)
    end

    print('de_underglow by ^1-del1an#9999^7 | ^2Loaded')

    DENEON.loaded = true
end

---@tick 500ms
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(500)
        _PED = PlayerPedId()
        _VEH = GetVehiclePedIsIn(_PED, false)
        _IN_CAR = GetVehiclePedIsIn(_PED, false) ~= 0
    end
end)

---@tick 100ms -- Neons Toggle
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(100)
        if _IN_CAR and DENEON.enabled and DENEON.neons_enabled then
            AnimVehicleNeonsToggle(_VEH, TOGGLES[DENEON.toggles_index])
        end
    end
end)

---@tick 10ms - Colors only
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(10)
        if _IN_CAR and DENEON.enabled and DENEON.neons_enabled then
            AnimVehicleNeonsColor(_VEH, COLORS[DENEON.lights_index])
        end
    end
end)

---@tick EVERY FRAME - Main (Menu and Toggles)
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(0)
        _GTIMER = GetGameTimer() -- used by DeltaT functions

        if DENEON.should_draw then
            DrawMenu()
        end
    end
end)

-- Init script settings
Citizen.CreateThread(InitialSettings)
