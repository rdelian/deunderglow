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
local main_menu = nil

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
    _ = bool and main_menu("open_menu") or main_menu("close_menu")
end

local function GetInputFromUser(text, windowTitleEntry, defaultText, maxLength)
    AddTextEntry("FMMC_MPM_NA", text)
    DisplayOnscreenKeyboard(1, windowTitleEntry or 'FMMC_MPM_NA', '', defaultText or '', '', '', '', maxLength or 255)
    while (UpdateOnscreenKeyboard() == 0) do
        DisableAllControlActions(0)
        Wait(0)
    end

    if (GetOnscreenKeyboardResult()) then
        local result = GetOnscreenKeyboardResult()
        return result
    end
end

local function BuildMenu()
    local r, g, b = table.unpack(MENU_STYLE.color)
    main_menu = MenuV:CreateMenu(nil, LOCALE.menu_title, MENU_STYLE.position, r, g, b, MENU_STYLE.size, 'none', 'menuv', 'de_underglow_mainmenu')
    local effects_menu = MenuV:CreateMenu(nil, LOCALE.menu_title, MENU_STYLE.position, r, g, b, MENU_STYLE.size, 'none', 'menuv', 'de_underglow_colors')
    local toggles_menu = MenuV:CreateMenu(nil, LOCALE.menu_title, MENU_STYLE.position, r, g, b, MENU_STYLE.size, 'none', 'menuv', 'de_underglow_toggles')

    local toggle_effects = main_menu:AddCheckbox({ icon = '⚙', label = LOCALE.main_script, value = 'n' })
    local toggle_neons = main_menu:AddCheckbox({ icon = '⚙', label = LOCALE.toggle_neons, value = 'n' })
    main_menu:AddButton({ icon = '🎨', label = LOCALE.effects_menu_title, value = effects_menu, description = nil })
    main_menu:AddButton({ icon = '🚦', label = LOCALE.toggles_menu_title, value = toggles_menu, description = nil })

    toggle_effects:On('change', function(button_ref, toggle)
        DENEON.enabled = toggle
    end)

    toggle_neons:On('change', function(button_ref, toggle)
        DENEON.neons_enabled = toggle
        ToggleVehicleNeons(_VEH, { toggle, toggle, toggle, toggle })
    end)

    -- Toggles SubMenu
    for i = 1, #TOGGLES do
        toggles_menu:AddButton({
            icon = nil,
            label = TOGGLES[i].title,
            value = i,
            description = ("%s / %s"):format(i, #TOGGLES)
        }):On("select", function(button_ref)
            DENEON.toggles_index = i
        end)
    end

    -- Effects SubMenu
    for i = 1, #COLORS do
        local e = COLORS[i]

        effects_menu:AddButton({
            icon = nil,
            label = e.title,
            value = i,
            description = ("%s / %s"):format(i, #COLORS)
        }):On("select", function(button_ref)
            if not e.input then
                DENEON.lights_index = i
            else
                local c_data = e.colors[1]
                local c_data_txt = table.concat(c_data, ', ')
                local input = GetInputFromUser(("%s (%s)"):format(e.title, c_data_txt), "FMMC_MPM_NA", c_data_txt, 13, i == DENEON.lights_index and "✅" or '')
                if input then
                    c_data = {}
                    for color_value in input:gmatch("%d+") do
                        local len = #c_data
                        c_data[len + 1] = tonumber(color_value)
                    end
                    COLORS[i].colors[1] = c_data
                    DENEON.lights_index = i
                end
            end
        end)
    end
end

local function InitialSettings()
    AddTextEntry("FMMC_MPM_NA", "Enter the RGB value, example: 255, 155, 50")

    SetDeltaT(1, 0)
    SetDeltaT(2, 0)

    for i = 1, #TOGGLES do
        local e = TOGGLES[i]
        if e.echo then
            for k = #e.anim - 1, 2, -1 do
                e.anim[#e.anim + 1] = e.anim[k]
            end
        end
    end

    BuildMenu()

    -- Menu Keybind
    if MENU_TOGGLE_KEY then
        RegisterCommand(MENU_COMMAND, function()
            main_menu("open_menu")
        end, false)
        main_menu:OpenWith('KEYBOARD', MENU_TOGGLE_KEY)
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

---@tick EVERY FRAME - Game Tick
Citizen.CreateThread(function()
    while not DENEON.loaded do Wait(20) end
    while true do Wait(0)
        _GTIMER = GetGameTimer() -- used by DeltaT functions
    end
end)

-- Init script settings
Citizen.CreateThread(InitialSettings)
