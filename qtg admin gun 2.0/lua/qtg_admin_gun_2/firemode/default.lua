QAG2M.Name			= 'Default'
QAG2M.Author		= 'Neptune QTG'
QAG2M.Introduction 	= 'Default Fire Mode'
QAG2M.IsAutomatic	= true
QAG2M.FireSound		= 'Airboat.FireGunRevDown'
QAG2M.FireTime		= 0

QAG2M.Information = {
	{name = 'left',helptext = 'Launch high damage bullets'}
}

local ReplaceList = {
	'prop_door_rotating',
	'prop_door',
	'func_door_rotating',
	'func_door'
}
local ReplaceList2 = {
	'func_physbox'
}
local RemoveList = {
}

local dontremeve = {
	'qtg_ent_barrier',
	'qtg_grenade_ar2',
	'qtg_grenade_frag',
	'qtg_nuke_explosion',
	'qtg_ent_barrier',
	'qtg_ent_bullet',
	'qtg_ent_timestop',
	'qtg_ent_timestop_bomb',
	'qtg_explosion',
	'qtg_nuke_bomb',
	'env_spritetrail',
	'predicted_viewmodel',
	'info_player_start',
	'func_precipitation',
	'beam',
	'env_laserdot'
}

local function QTG_DefStartFire(self,t,a)
	local DefModeBullet = {Vector(0.165,0.165,0),'AirboatGunHeavyTracer'}
	if a == 1 then
		DefModeBullet = {Vector(0,0,0),'AR2Tracer'}
	elseif a == 2 then
		DefModeBullet = {Vector(0.5,0,0),'AirboatGunHeavyTracer'}
	end
	self:FireAdminBullets(DefModeBullet[1],DefModeBullet[2],function(a,t,d)
		local eff = EffectData()
		eff:SetOrigin(t.HitPos)
		eff:SetNormal(t.HitNormal)
		eff:SetScale(500)
		util.Effect('AR2Impact',eff)
		util.Effect('MetalSpark',eff)
		if t.Hit then
			if t.Entity:IsValid() and !IsValid(t.Entity.TimeStopENT) then
				if SERVER then
					if table.HasValue(ReplaceList,t.Entity:GetClass()) then
						local d = ents.Create('prop_physics')
						d:SetModel(t.Entity:GetModel())
						d:SetPos(t.Entity:GetPos())
						d:SetAngles(t.Entity:GetAngles())
						d:Spawn()
						d:Activate()
						if t.Entity:GetSkin() != nil then
							d:SetSkin(t.Entity:GetSkin())
						end
						d:SetMaterial(t.Entity:GetMaterial())
						t.Entity:QTGRemove1()
						timer.Simple(3,function()
							if IsValid(d) then
								d:SetCollisionGroup(1)
							end
						end)
						local phys = d:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetVelocity(((d:GetPos() -self:GetPos()) *500 +(d:GetPos() +d:GetForward() *400 -self:GetPos()) +(d:GetPos() +d:GetUp() *200 -self:GetPos()) *140))
						end
					end
					if table.HasValue(ReplaceList2,t.Entity:GetClass()) then
						local d = ents.Create('prop_physics')
						d:SetModel(t.Entity:GetModel())
						d:SetPos(t.Entity:GetPos())
						d:SetAngles(t.Entity:GetAngles())
						d:Spawn()
						d:Activate()
						if t.Entity:GetSkin() != nil then
							d:SetSkin(t.Entity:GetSkin())
						end
						d:SetMaterial(t.Entity:GetMaterial())
						t.Entity:QTGRemove2()
						local phys = d:GetPhysicsObject()
						if phys:IsValid() then
							phys:SetVelocity(((d:GetPos() -self:GetPos()) *500 +(d:GetPos() +d:GetForward() *400 -self:GetPos()) +(d:GetPos() +d:GetUp() *200 -self:GetPos()) *140))
						end
					end
				end
				if ((t.Entity:IsPlayer() and t.Entity:GetActiveWeaponClass() != 'qtg_admin_gun') or t.Entity:IsNPC() or (t.Entity:Health() > 0 and !t.Entity:IsPlayer())) then
					if t.Entity:IsNPC() or t.Entity:IsPlayer() then
						t.Entity:SetHealth(0,self:QTGGetKey())
					end
					local epos = t.Entity:GetPos()
					local eff = EffectData()
					eff:SetStart(epos)
					eff:SetOrigin(epos)
					eff:SetScale(1)
					util.Effect('Explosion',eff)
					timer.Simple(0, function()
						if t.Entity:IsValid() and SERVER then
							if t.Entity:IsPlayer() and t.Entity:Alive() then
								t.Entity:KillSilent()
								if self.Owner:IsNPC() then
									net.Start('PlayerKilled')
										net.WriteEntity(t.Entity)
										net.WriteString(self.ClassName)
										net.WriteString(self.Owner:GetClass())
									net.Broadcast()
									MsgAll(t.Entity:Nick()..' was killed by '..self.Owner:GetClass()..'\n')
								else
									net.Start('PlayerKilledByPlayer')
										net.WriteEntity(t.Entity)
										net.WriteString(self.ClassName)
										net.WriteEntity(self.Owner)
									net.Broadcast()
									MsgAll(self.Owner:Nick()..' killed '..t.Entity:Nick()..' using '..self.ClassName..'\n')
								end
							elseif !t.Entity:IsPlayer() then
								if t.Entity:IsNPC() and t.Entity:GetNPCState() == NPC_STATE_DEAD then
								else
									t.Entity.UseQAGRemoveEnt = self.Owner
									t.Entity.OnRemove = function(self)
										self:QTGRemove25()
										self:StopSound('windgrinpanic')
										self:StopSound('lubenweipanic')
									end
									t.Entity:QTGRemove3(self:QTGGetKey())
								end
							end
						end 
					end)
					if SERVER then
						t.Entity:Ignite(math.huge,0)
					end
				end
			end
		end	
	end)
	if SERVER and self.Owner:IsPlayer() then
		for k,v in pairs(ents.FindAlongRay(self.Owner:GetShootPos()+self.Owner:GetAimVector()*50,t.HitPos,Vector(-10,-10,-10),Vector(25,25,25))) do
			if ((v:IsPlayer() and v != self.Owner and v:GetActiveWeaponClass() != 'qtg_admin_gun_2') or v:IsNPC() or (v:Health() > 0 and !v:IsPlayer())) and v != self then
				local d = DamageInfo()
				d:SetAttacker(self.Owner)
				d:SetInflictor(self)
				d:SetDamage(math.huge)
				d:SetDamageType(bit.bor(DMG_BLAST,DMG_AIRBOAT))
				v:SetHealth(0)
				v:TakeDamageInfo(d)
				timer.Simple(0,function()
					if v:IsValid() and !IsValid(v.TimeStopENT) then
						if v:IsPlayer() and v:Alive() then
							v:KillSilent()
						elseif !v:IsWeapon() and !v:IsPlayer() and !table.HasValue(dontremeve,v:GetClass()) then
							if v:IsNPC() and v:GetNPCState() == NPC_STATE_DEAD then
							else
								v.UseQAGRemoveEnt = self.Owner
								v:QTGRemove99()
							end
						end
					end
				end)
			end
		end
	end
end

QAG2M.FireType[1] = {
	TypeName = 'Shotgun Type',
	StartFire = function(self,t)
		QTG_DefStartFire(self,t)
	end
}

QAG2M.FireType[2] = {
	TypeName = 'Rifle Type',
	StartFire = function(self,t)
		QTG_DefStartFire(self,t,1)
	end
}

QAG2M.FireType[3] = {
	TypeName = 'Shotgun Type 2',
	StartFire = function(self,t)
		QTG_DefStartFire(self,t,2)
	end
}

function QAG2M:Reload()
end

function QAG2M:Think()
end

hook.Add('EntityRemoved','QAG_DefRemove',function(e)
	if e.UseQAGRemoveEnt != nil and IsValid(e) then
		if IsValid(e.UseQAGRemoveEnt) then
			if e.UseQAGRemoveEnt:IsNPC() then
				net.Start('NPCKilledNPC')
					net.WriteString(e:GetClass())
					net.WriteString('qtg_admin_gun_2')
					net.WriteString(e.UseQAGRemoveEnt:GetClass())
				net.Broadcast()
			else
				net.Start('PlayerKilledNPC')
					net.WriteString(e:GetClass())
					net.WriteString('qtg_admin_gun_2')
					net.WriteEntity(e.UseQAGRemoveEnt)
				net.Broadcast()
			end
		end
	end
end)