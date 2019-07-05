net.Receive('QAG2_SetFireMode',function(_,p)
	local a = net.ReadString()
	p:SetQAG2FireMode(a)
end)