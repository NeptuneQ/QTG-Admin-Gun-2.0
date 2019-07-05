function QAG2:AddFont(a,b,c,d)
	surface.CreateFont(a,{
		font = b,
		size = c,
		weight = d
	})
end
local function AddFont(a,b)
	QAG2:AddFont(a,'Roboto Bk',b,1000)
end
local function AddFont2(a,b)
	QAG2:AddFont(a,'Roboto',b,1000)
end
AddFont('QAG2ModeName',80)
AddFont('QAG2ModeSubtitle',24)
AddFont('QAG2ModeHelp',17)

AddFont2('QAG2MTitle',40)
AddFont2('QAG2MName',18)
AddFont2('QAG2MSFont',18)