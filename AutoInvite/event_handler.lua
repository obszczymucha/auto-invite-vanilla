if AutoInvite and AutoInvite.event_handler then return end

local frame
local last_update

AutoInvite.update_interval = 1.0

function AutoInvite.handle_events( facade, on_load, on_chat, on_system_chat, on_group_changed, on_timer )
  if frame then return end
  last_update = facade.api.GetTime()

  local function handle()
    ---@diagnostic disable-next-line: undefined-global
    local event = event
    ---@diagnostic disable-next-line: undefined-global
    local arg1, arg2 = arg1, arg2

    if event == "PLAYER_LOGIN" then
      on_load()
    elseif event == "CHAT_MSG_WHISPER" then
      on_chat( arg2, arg1 )
    elseif event == "CHAT_MSG_SYSTEM" then
      on_system_chat( arg1 )
    elseif event == "PARTY_MEMBERS_CHANGED" then
      on_group_changed()
    end
  end

  frame = facade.create_frame()
  frame:RegisterEvent( "PLAYER_LOGIN" )
  frame:RegisterEvent( "CHAT_MSG_WHISPER" )
  frame:RegisterEvent( "CHAT_MSG_SYSTEM" )
  frame:RegisterEvent( "PARTY_MEMBERS_CHANGED" )
  frame:SetScript( "OnEvent", handle )
  frame:SetScript( "OnUpdate", function()
    local current_time = facade.api.GetTime()
    local time_diff = current_time - last_update

    if time_diff >= AutoInvite.update_interval then
      last_update = current_time
      on_timer()
    end
  end )
end
