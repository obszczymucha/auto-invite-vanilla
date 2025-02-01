if AutoInvite.minimap_button then return end

local ColorType = {
  White = "White",
  Green = "Green",
  Blue = "Blue"
}
---@diagnostic disable-next-line: undefined-field
local mod = math.mod

function AutoInvite.minimap_button( facade, config, on_left_click, on_shift_left_click, on_middle_click, on_right_click )
  local hl = facade.colors.hl
  local blue = facade.colors.blue
  local pretty_print = facade.pretty_print
  local api = facade.api

  local function persist_angle( angle )
    config.minimap_angle = angle
  end

  local function get_angle()
    return config.minimap_angle
  end

  local function is_locked()
    return config.minimap_locked
  end

  local function is_hidden()
    return config.minimap_hidden
  end

  local function create()
    local frame = api.CreateFrame( "Button", "AutoInviteMinimapButton", api.Minimap )
    local was_dragging = false

    function frame.OnClick()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local button = arg1

      if button == "LeftButton" then
        if api.IsShiftKeyDown() then
          on_shift_left_click()
        else
          on_left_click()
        end
      elseif button == "MiddleButton" then
        on_middle_click()
      elseif button == "RightButton" then
        on_right_click()
      end

      self:OnEnter()
      api.GameTooltip:Hide()
    end

    function frame.OnMouseDown()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      self.icon:SetTexCoord( 0, 1, 0, 1 )
      was_dragging = false
    end

    function frame.OnMouseUp()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      self.icon:SetTexCoord( 0.05, 0.95, 0.05, 0.95 )
      if not was_dragging then self:OnClick() end
    end

    function frame.OnEnter()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      if not self.dragging then
        api.GameTooltip:SetOwner( self, "ANCHOR_LEFT" )
        api.GameTooltip:SetText( blue( "Auto Invite" ) )

        api.GameTooltip:AddLine( " " )
        api.GameTooltip:AddLine( string.format( "Status: %s", hl( config.enabled and "Enabled" or "Disabled" ) ) )
        api.GameTooltip:AddLine( string.format( "Keyword: %s", hl( config.keyword ) ) )
        api.GameTooltip:AddLine( string.format( "Auto-raid: %s", hl( config.autoraid and "Enabled" or "Disabled" ) ) )

        api.GameTooltip:Show()
      end
    end

    function frame.OnLeave()
      api.GameTooltip:Hide()
    end

    function frame.OnDragStart()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      self.dragging = true
      self:LockHighlight()
      self.icon:SetTexCoord( 0, 1, 0, 1 )
      self:SetScript( "OnUpdate", self.OnUpdate )
      api.GameTooltip:Hide()
      was_dragging = true
    end

    function frame.OnDragStop()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this
      self.dragging = nil
      self:SetScript( "OnUpdate", nil )
      self.icon:SetTexCoord( 0.05, 0.95, 0.05, 0.95 )
      self:UnlockHighlight()
    end

    function frame.OnUpdate()
      ---@diagnostic disable-next-line: undefined-global, redefined-local
      local self = this

      local mx, my = api.Minimap:GetCenter()
      local px, py = api.GetCursorPosition()
      local scale = api.Minimap:GetEffectiveScale()

      px, py = px / scale, py / scale

      persist_angle( mod( math.deg( math.atan2( py - my, px - mx ) ), 360 ) )
      self:UpdatePosition()
    end

    -- Copy pasted from Bongos.
    --magic fubar code for updating the minimap button"s position
    --I suck at trig, so I"m not going to bother figuring it out
    function frame.UpdatePosition( self )
      local angle = math.rad( get_angle() or api.random( 0, 360 ) )
      local cos = math.cos( angle )
      local sin = math.sin( angle )
      local minimapShape = api.GetMinimapShape and api.GetMinimapShape() or "ROUND"

      local round = false
      if minimapShape == "ROUND" then
        round = true
      elseif minimapShape == "SQUARE" then
        round = false
      elseif minimapShape == "CORNER-TOPRIGHT" then
        round = not (cos < 0 or sin < 0)
      elseif minimapShape == "CORNER-TOPLEFT" then
        round = not (cos > 0 or sin < 0)
      elseif minimapShape == "CORNER-BOTTOMRIGHT" then
        round = not (cos < 0 or sin > 0)
      elseif minimapShape == "CORNER-BOTTOMLEFT" then
        round = not (cos > 0 or sin > 0)
      elseif minimapShape == "SIDE-LEFT" then
        round = cos <= 0
      elseif minimapShape == "SIDE-RIGHT" then
        round = cos >= 0
      elseif minimapShape == "SIDE-TOP" then
        round = sin <= 0
      elseif minimapShape == "SIDE-BOTTOM" then
        round = sin >= 0
      elseif minimapShape == "TRICORNER-TOPRIGHT" then
        round = not (cos < 0 and sin > 0)
      elseif minimapShape == "TRICORNER-TOPLEFT" then
        round = not (cos > 0 and sin > 0)
      elseif minimapShape == "TRICORNER-BOTTOMRIGHT" then
        round = not (cos < 0 and sin < 0)
      elseif minimapShape == "TRICORNER-BOTTOMLEFT" then
        round = not (cos > 0 and sin < 0)
      end

      local x, y
      if round then
        x = cos * 80
        y = sin * 80
      else
        x = math.max( -82, math.min( 110 * cos, 84 ) )
        y = math.max( -86, math.min( 110 * sin, 82 ) )
      end

      self:SetPoint( "CENTER", x, y )
    end

    frame:SetFrameStrata( "MEDIUM" )
    frame:SetWidth( 31 )
    frame:SetHeight( 31 )
    frame:SetFrameLevel( 8 )
    frame:RegisterForClicks( "anyUp" )
    frame:RegisterForDrag( "LeftButton" )
    frame:SetHighlightTexture( "Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight" )

    local overlay = frame:CreateTexture( nil, "OVERLAY" )
    overlay:SetWidth( 53 )
    overlay:SetHeight( 53 )
    overlay:SetTexture( "Interface\\Minimap\\MiniMap-TrackingBorder" )
    overlay:SetPoint( "TOPLEFT", 0, 0 )

    local icon = frame:CreateTexture( nil, "BACKGROUND" )
    icon:SetWidth( 20 )
    icon:SetHeight( 20 )
    icon:SetTexCoord( 0.05, 0.95, 0.05, 0.95 )
    icon:SetPoint( "TOPLEFT", 7, -5 )
    frame.icon = icon

    frame:SetScript( "OnEnter", frame.OnEnter )
    frame:SetScript( "OnLeave", frame.OnLeave )
    frame:SetScript( "OnClick", frame.OnClick )

    frame:SetScript( "OnMouseDown", frame.OnMouseDown )
    frame:SetScript( "OnMouseUp", frame.OnMouseUp )

    frame:UpdatePosition()

    return frame
  end

  local frame = create()

  local function show()
    if is_hidden() then
      frame:Hide()
      pretty_print( string.format( "Minimap button is hidden. Type %s to show.", hl( "/rfm" ) ) )
    else
      frame:Show()
    end
  end

  local function lock()
    if is_locked() then
      frame:SetScript( "OnDragStart", nil )
      frame:SetScript( "OnDragStop", nil )
    else
      frame:SetScript( "OnDragStart", frame.OnDragStart )
      frame:SetScript( "OnDragStop", frame.OnDragStop )
    end
  end

  local function set_icon( color )
    frame.icon:SetTexture( string.format( "Interface\\AddOns\\AutoInvite\\assets\\icon-%s.tga", string.lower( color ) ) )
  end

  show()
  lock()
  set_icon( ColorType.White )

  local function toggle()
    if is_hidden() then
      config.minimap_hidden = nil
    else
      config.minimap_hidden = true
    end

    show()
  end

  local function toggle_lock()
    if is_locked() then
      config.minimap_locked = nil
      pretty_print( string.format( "Minimap button %s.", hl( "unlocked" ) ) )
    else
      config.minimap_locked = true
      pretty_print( string.format( "Minimap button %s.", hl( "locked" ) ) )
    end

    lock()
  end

  return {
    toggle = toggle,
    toggle_lock = toggle_lock,
    set_icon = set_icon,
    ColorType = ColorType
  }
end
