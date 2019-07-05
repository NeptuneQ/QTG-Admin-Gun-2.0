
-- Remove this to add it to the menu
QAG2M.AddToMenu 	= false

-- Define these!
QAG2M.Name 			= 'Example Mode' -- Name to display.
QAG2M.Author 		= 'Neptune QTG' -- The name of you (author name)
QAG2M.Introduction 	= 'This is an example' -- Introduction to the fire mode
QAG2M.IsAutomatic	= true -- Is this a fully automatic mode or a semi-automatic firing mode?
QAG2M.FireSound		= 'Airboat.FireGunRevDown' -- Fire sound
QAG2M.FireTime		= 0 -- Fire buffer time
QAG2M.DrawToolTracer= true -- Whether to draw Tool Tracer

QAG2M.Information = { -- Help text
	{name = 'left',helptext = 'Fire!!!'}, -- Left is the type of icon,Helptext is the displayed text
	{name = 'right'} -- Right is an invalid icon type
}

-- You can fill in a lot of fire types in an open fire mode, press E+R to switch the type.

QAG2M.FireType[1] = { -- a type of fire
	TypeName = 'Type 1', -- type name
	StartFire = function(self,t)
		Msg('Fire Type 1') -- This function/hook is called when the player presses their left click
	end
}

QAG2M.FireType[2] = { -- You can add unlimited fire types
	TypeName = 'Type 2',
	StartFire = function(self,t)
		Msg('Fire Type 2')
	end
}

QAG2M.FireType[3] = { -- You can add unlimited fire types
	TypeName = 'Type 3',
	StartFire = function(self,t)
		Msg('Fire Type 3')
	end
}

QAG2M.FireType[4] = { -- You can add unlimited fire types
	TypeName = 'Type 4',
	StartFire = function(self,t)
		Msg('Fire Type 4')
	end
}

-- Please do not fill in the values at random, you must fill in the value +1
-- QAG2M.FireType[99] = {
	-- TypeName = 'Error Type',
	-- StartFire = function(self)
	-- end
-- }

-- This function/hook is called when the player presses their reload key
function QAG2M:Reload()
	-- The SWEP doesn't reload so this does nothing :(
	Msg( 'RELOAD\n' )
end

-- This function/hook is called every frame on client and every tick on the server
function QAG2M:Think()
end
