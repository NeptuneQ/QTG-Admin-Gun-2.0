function QAG2:AddKillIcon(a,b)
	killicon.Add(a,b,Color(255,80,0))
end
hook.Add('Initialize','QTG_LoadKillIcon',function()
	QAG2:AddKillIcon('qtg_admin_gun_2','neptune_qtg/qtg_admin_gun_2/Default')
end)