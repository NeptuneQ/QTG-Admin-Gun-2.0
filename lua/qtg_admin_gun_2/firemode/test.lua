if CLIENT then
	QAG2M.AddToMenu 	= QAG2:GetConvar('dev'):GetBool()
end

QAG2M.Name			= 'Dev Test'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Developer test mode'
QAG2M.IsAutomatic	= true
QAG2M.DrawToolTracer= true

QAG2M.FireType[1] = {
	TypeName = '',
	StartFire = function(self,t)
		if SERVER then
			if t.Entity:IsNPC() then
				t.Entity:SetNPCState(NPC_STATE_DEAD)
			end
		end
	end
}