if AutoInvite.shitlist then return end

function AutoInvite.shitlist( db, facade )
  db.shitlist = db.shitlist or {}

  local pp = facade.pretty_print
  local hl = facade.colors.hl
  local capitalize = facade.capitalize

  local function add( player_name, reason )
    local name = capitalize( player_name )

    db.shitlist[ name ] = {
      timestamp = facade.api.time(),
      reason = reason
    }

    pp( string.format( "%s is now shitlisted%s.", facade.colors.hl( name ), reason and string.format( " [%s]", hl( reason ) ) or "" ) )
  end

  local function get( player_name )
    local name = capitalize( player_name )

    return db.shitlist[ name ]
  end

  local function print( player_name )
    local name = capitalize( player_name )
    local shitlisted = db.shitlist[ name ]

    if not shitlisted then
      pp( string.format( "%s is not shitlisted.", hl( name ) ) )
      return
    end

    pp( string.format( "%s is shitlisted%s.", hl( name ), shitlisted.reason and string.format( " [%s]", hl( shitlisted.reason ) ) or "" ) )
  end

  local function remove( player_name )
    local name = capitalize( player_name )

    if not db.shitlist[ name ] then
      print( name )
      return
    end

    db.shitlist[ name ] = nil
    pp( string.format( "%s is no longer shitlisted.", facade.colors.hl( name ) ) )
  end

  return {
    add = add,
    get = get,
    remove = remove,
    print = print
  }
end
