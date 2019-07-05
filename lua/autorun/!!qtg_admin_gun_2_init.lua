AddCSLuaFile('qtg_admin_gun_2/load/init.lua')
include('qtg_admin_gun_2/load/init.lua')

list.Add('NPCUsableWeapons',{class='qtg_admin_gun_2',title='QTG Admin Gun 2.0'})

if SERVER then
	resource.AddWorkshop('1410750647')
end