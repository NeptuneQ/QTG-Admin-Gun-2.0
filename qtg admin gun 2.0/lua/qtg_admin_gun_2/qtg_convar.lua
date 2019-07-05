function QAG2:AddConvar(a,b,c)
	if c == 'server' or c == 'sv' then
		if !ConVarExists('qag2_'..a) then CreateConVar('qag2_'..a,b,{FCVAR_ARCHIVE,FCVAR_REPLICATED,FCVAR_SERVER_CAN_EXECUTE}) end
	elseif c == 'client' or c == 'cl' then
		if !ConVarExists('qag2_'..a) then CreateClientConVar('qag2_'..a,b,true,true) end
	end
end

function QAG2:GetConvar(a)
	if ConVarExists('qag2_'..a) then
		return GetConVar('qag2_'..a)
	end
	error('"'..'qag2_'..a..'" QTG Admin Gun 2.0 Convar Not Found!')
end

QAG2:AddConvar('gun_text',1,'cl')
QAG2:AddConvar('language','en','cl')
QAG2:AddConvar('dev',0,'cl')
QAG2:AddConvar('set_my_health',100,'cl')
QAG2:AddConvar('set_ply_health',100,'cl')