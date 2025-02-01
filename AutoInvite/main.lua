---@diagnostic disable-next-line: undefined-global
local facade = AutoInvite.facade()
local blue = facade.colors.blue
local can_invite = facade.can_invite
local hl = facade.colors.hl
local invite = facade.invite
local now = facade.now
local pp = facade.pretty_print
local register_slash_command = facade.register_slash_command
local seconds_between = facade.seconds_between
local whisper = facade.whisper
local is_in_party = facade.is_in_party
local convert_to_raid = facade.convert_to_raid

local invites = {}
local config
local minimap_button
local shitlist
local response

---@diagnostic disable-next-line: undefined-field
local gmatch = string.gmatch or string.gfind

local function update_minimap_button()
  if config.enabled and config.autoraid then
    minimap_button.set_icon( minimap_button.ColorType.Blue )
  elseif config.enabled then
    minimap_button.set_icon( minimap_button.ColorType.Green )
  else
    minimap_button.set_icon( minimap_button.ColorType.White )
  end
end

local function print_status()
  local autoraid = hl( config.autoraid and "on" or "off" )

  if config.enabled then
    pp( string.format( "%s [%s] (auto-raid: %s).", hl( "Enabled" ), blue( config.keyword ), autoraid ) )
  else
    pp( string.format( "%s (auto-raid: %s).", hl( "Disabled" ), autoraid ) )
  end
end

local function toggle( keyword )
  if keyword and keyword ~= "" then
    config.keyword = keyword
    config.enabled = true
  else
    config.enabled = not config.enabled
  end

  print_status()
  update_minimap_button()
end

local function setup_storage()
  if not AutoInviteDb then AutoInviteDb = {} end
  if not AutoInviteCharDb then AutoInviteCharDb = {} end
  config = AutoInviteCharDb

  if not config.keyword then config.keyword = "1337" end
  if config.enabled == nil then config.enabled = false end
  if config.autoraid == nil then config.autoraid = false end
end

local function toggle_auto_raid()
  config.autoraid = not config.autoraid

  print_status()
  update_minimap_button()
end

local function on_shitlist( args )
  if not args or args == "" then
    pp( "Usage:" )
    pp( string.format( "%s add <%s> [%s]", hl( "/shitlist" ), hl( "name" ), hl( "reason" ) ) )
    pp( string.format( "%s remove <%s>", hl( "/shitlist" ), hl( "name" ) ) )
    pp( string.format( "%s <%s>", hl( "/shitlist" ), hl( "name" ) ) )

    return
  end

  for name, reason in gmatch( args, "add (.-) (.*)" ) do
    shitlist.add( name, reason )
    return
  end

  for name in gmatch( args, "add (.*)" ) do
    shitlist.add( name )
    return
  end

  for name in gmatch( args, "remove (.*)" ) do
    shitlist.remove( name )
    return
  end

  shitlist.print( args )
end

local function setup_slash_commands()
  register_slash_command( "ai", toggle )
  register_slash_command( "ais", print_status )
  register_slash_command( "air", toggle_auto_raid )
  register_slash_command( "shitlist", on_shitlist )
  register_slash_command( "sl", on_shitlist )
end

local function invite_player( player_name )
  if not can_invite() then
    whisper( player_name, "Can't invite you, no permissions." )
    return
  end

  invite( player_name )
  invites[ player_name ] = { invite_timestamp = now() }
  pp( string.format( "Auto-invited %s.", hl( player_name ) ) )
end

local function player_in_a_group( player_name )
  invites[ player_name ] = invites[ player_name ] or {}
  invites[ player_name ].in_a_group = true

  local timestamp = invites[ player_name ].invite_timestamp
  if not timestamp then return end

  local delta = seconds_between( timestamp )

  if delta < 3 then
    whisper( player_name, "You're in a group." )
  end
end

local function on_left_click()
  toggle()
end

local function on_shift_left_click()
  --toggle_auto_raid()
end

local function on_middle_click()
  minimap_button.toggle_lock()
end

local function on_right_click()
  toggle_auto_raid()
end

local function on_load()
  setup_storage()
  setup_slash_commands()
  print_status()
  minimap_button = AutoInvite.minimap_button( facade, config, on_left_click, on_shift_left_click, on_middle_click, on_right_click )
  shitlist = AutoInvite.shitlist( AutoInviteDb, facade )
  response = AutoInvite.response( facade )
  update_minimap_button()
end

local function on_chat( player_name, message )
  if message ~= config.keyword then return end

  if not config.enabled then
    whisper( player_name, "Sorry, auto-invites are now disabled." )
    return
  end

  local shitlisted = shitlist.get( player_name )

  if shitlisted then
    shitlist.print( player_name )
    whisper( player_name, response.random() )
    return
  end

  invite_player( player_name )
  whisper( player_name, response.random() )
end

local function on_group_changed()
  if not config.enabled or not config.autoraid then return end
  if is_in_party() then convert_to_raid() end
end

local function on_system_chat( message )
  for name in gmatch( message, "(%w-) is already in a group" ) do
    if name then player_in_a_group( name ) end
    return
  end

  for name in gmatch( message, "You have invited (%w-) to join your group%." ) do
    invites[ name ] = nil
    return
  end

  for _ in gmatch( message, "(%w-) joins the party" ) do
    on_group_changed()
  end
end

local function on_timer()
  for player_name, data in pairs( invites ) do
    if not data.in_a_group and data.invite_timestamp then
      local current_time = facade.api.GetTime()
      local diff = current_time - data.invite_timestamp

      if diff >= AutoInvite.update_interval then
        invite_player( player_name )
      end
    end
  end
end

AutoInvite.handle_events( facade, on_load, on_chat, on_system_chat, on_group_changed, on_timer )
