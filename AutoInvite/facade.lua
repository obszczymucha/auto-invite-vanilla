---@diagnostic disable: undefined-global
if AutoInvite and AutoInvite.facade then return end

local api = {
  CanGroupInvite = CanGroupInvite,
  ConvertToRaid = ConvertToRaid,
  CreateFrame = CreateFrame,
  DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME,
  GameTooltip = GameTooltip,
  GetAddOnMetadata = GetAddOnMetadata,
  GetCursorPosition = GetCursorPosition,
  GetMinimapShape = GetMinimapShape,
  GetNumPartyMembers = GetNumPartyMembers,
  GetNumRaidMembers = GetNumRaidMembers,
  GetRaidRosterInfo = GetRaidRosterInfo,
  InviteUnit = InviteByName,
  IsShiftKeyDown = IsShiftKeyDown,
  Minimap = Minimap,
  SendChatMessage = SendChatMessage,
  SlashCmdList = SlashCmdList,
  UnitIsPartyLeader = UnitIsPartyLeader,
  UnitName = UnitName,
  getfenv = getfenv,
  random = random,
  time = time,
  math = math,
  GetTime = GetTime
}

local _G = api.getfenv( 0 )

local colors = {
  hl = function( text )
    return text and string.format( "|cffff9f69%s|r", text ) or ""
  end,
  blue = function( text )
    return text and string.format( "|cff209ff9%s|r", text ) or ""
  end
}

local function pretty_print( message, color_fn )
  if not message then return end

  local c = color_fn and type( color_fn ) == "function" and color_fn or color_fn and type( color_fn ) == "string" and colors[ color_fn ] or colors.blue
  api.DEFAULT_CHAT_FRAME:AddMessage( string.format( "%s: %s", c( "AutoInvite" ), message ) )
end

local function whisper( player_name, message )
  api.SendChatMessage( message, "WHISPER", nil, player_name )
end

local function seconds_between( timestamp )
  return api.time() - timestamp
end

local function create_frame()
  return api.CreateFrame( "Frame" )
end

local function can_invite()
  if api.GetNumRaidMembers() > 0 then
    local playerName = api.UnitName( "player" )

    for i = 1, api.GetNumRaidMembers() do
      local name, rank = api.GetRaidRosterInfo( i )
      if name == playerName then
        return rank > 0
      end
    end

    return false
  end

  if api.GetNumPartyMembers() > 0 then
    return api.UnitIsPartyLeader( "player" )
  end

  return true
end

local function invite( player_name )
  api.InviteUnit( player_name )
end

local function now()
  return api.time()
end

local function register_slash_command( name, callback )
  local upper = string.upper( name )
  _G[ "SLASH_" .. upper .. "1" ] = "/" .. string.lower( name )
  api.SlashCmdList[ upper ] = callback
end

local function my_name()
  return api.UnitName( "player" )
end

local function is_in_party()
  return api.GetNumRaidMembers() == 0 and api.GetNumPartyMembers() > 0
end

local function convert_to_raid()
  api.ConvertToRaid()
end

local function capitalize( str )
  if not str then return nil end

  local lower = string.lower( str )
  local head = string.upper( string.sub( lower, 1, 1 ) )
  local tail = string.sub( lower, 2 )

  return head .. tail
end

AutoInvite = {}

function AutoInvite.facade()
  return {
    can_invite = can_invite,
    colors = colors,
    convert_to_raid = convert_to_raid,
    create_frame = create_frame,
    invite = invite,
    is_in_party = is_in_party,
    my_name = my_name,
    now = now,
    pretty_print = pretty_print,
    register_slash_command = register_slash_command,
    seconds_between = seconds_between,
    whisper = whisper,
    capitalize = capitalize,
    api = api
  }
end
