local Key = string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))..string.char(math.random(70,100))

local YellowBlood = {
	BLOOD_COLOR_ANTLION,
	BLOOD_COLOR_ANTLION_WORKER,
	BLOOD_COLOR_GREEN,
	BLOOD_COLOR_YELLOW,
	BLOOD_COLOR_ZOMBIE
}

local BloodTable = {
	[BLOOD_COLOR_RED] = 'blood_impact_red_01',
	[BLOOD_COLOR_MECH] = ''
}

local EntTable = {
	['npc_hunter'] = 'blood_impact_synth_01',
	['npc_turret'] = '',
	['npc_rollermine'] = '',
	['npc_clawscanner'] = '',
	['npc_cscanner'] = '',
	['npc_manhack'] = ''
}

local ModelTable = {
	['models/props_c17/furnituremattress001a.mdl'] = ''
}

local qag2 = 'qtg_admin_gun_2'

local function QAG2_EntityTakeDamage(e,d)
	local a = d:GetAttacker()
	local ae = d:GetInflictor()
	if ae.Gun != nil and IsValid(ae.Gun) and ae.Gun:GetClass() == qag2 then
		local go = ae.Owner
		if ae:GetClass() == 'crossbow_bolt' then
			local bp = ''
			local p = ents.Create('info_particle_system')
			p:Fire('Kill','',0.1)
			if (e:IsPlayer() or e:IsNPC() or type(e) == 'NextBot' or e:IsRagdoll()) then
				if table.HasValue(YellowBlood,e:GetBloodColor()) then
					bp = 'blood_impact_yellow_01'
				elseif BloodTable[e:GetBloodColor()] != nil then
					bp = BloodTable[e:GetBloodColor()]
				elseif EntTable[e:GetClass()] != nil then
					bp = EntTable[e:GetClass()]
				elseif ModelTable[e:GetModel()] != nil then
					bp = ModelTable[e:GetModel()]
				else
					bp = 'blood_impact_red_01'
				end
			end
			if bp != '' then
				p:SetKeyValue('effect_name',bp)
				p:SetKeyValue('start_active',tostring(1))
				p:Spawn()
				p:Activate()
				p:SetPos(a:GetEyeTrace().HitPos)
			end
			if ae.Owner != e then
				e:SetHealth(0)
				-- d:SetAttacker(go:IsValid() and go or ae)
				d:SetInflictor(ae.Gun:IsValid() and ae.Gun or ae)
				d:SetDamage(math.huge)
				d:SetDamageType(bit.bor(DMG_BLAST,DMG_AIRBOAT))
				if e:IsPlayer() or e:IsNPC() or type(e) == 'NextBot' then
					d:SetDamageForce(d:GetInflictor():GetForward()*1e9)
				elseif e:GetPhysicsObject():IsValid() then
					e:GetPhysicsObject():ApplyForceCenter(d:GetInflictor():GetForward()*1e9)
				end
			else
				return true
			end
		else
			if ae.Owner != e then
				d:SetAttacker(go:IsValid() and go or ae)
				d:SetInflictor(ae.Gun:IsValid() and ae.Gun or ae)
				d:SetDamage(math.huge)
			else
				return true
			end
		end
	end
	if e.Gun != nil and IsValid(e.Gun) and e.Gun:GetClass() == qag2 then
		return true
	end
	if e:IsPlayer() and e:GetActiveWeaponClass() == qag2 and SERVER then
		net.Start('QTG_miss')
		net.WriteEntity(e)
		net.WriteVector(e:EyePos())
		net.Broadcast()
		e:EmitSound(Sound('undertale/qtg_attack_miss.wav'),75,100,1,CHAN_AUTO)
		return true
	end
end

local function QAG2_FallDamage(p,s)
	if p:GetActiveWeaponClass() == qag2 then
		return 0
	end
end

local function QAG2_PhysgunPickup(p,e)
	if e:GetClass() == qag2 then
		return false
	end
end

local RemovedList = {
	'npc_windgrinbot',
	'npc_lubenweibot'
}

local function QAG2_KillSpecialNPC()
	for  _,e in pairs(ents.GetAll()) do
		if table.HasValue(RemovedList,e:GetClass()) then
			e.OnRemove = function(self)
				self:Remove()
				self:StopSound('windgrinpanic')
				self:StopSound('lubenweipanic')
			end
		end
	end
end

local function QAG2_KillSpecialNPC_OnCreated(e)
	if table.HasValue(RemovedList,e:GetClass()) then
		hook.Remove('ContextMenuOpen','windgrinno')
		hook.Add('EntityRemoved',Key,function(e)
			if table.HasValue(RemovedList,e:GetClass()) then
				e:Remove()
			end
		end)
	end
end

local function QAG2_Tick()
	for k,v in ipairs(ents.FindByClass('qtg_ent_*')) do
		if v:IsValid() then
			if v.QAG2Think then v:QAG2Think() end
		end
	end
end

local function QAG2_PlayerCanPickupWeapon(p,w)
	if w:GetClass() == qag2 then
		return true
	end
end

local function QAG2_PlayerGiveSWEP(p,w,s)
	if w == qag2 then
		return true
	end
end

local function QAG2_PlayerSpawnedSWEP(p,w)
	if w == qag2 then
		return true
	end
end

local function QAG2_PlayerSpawnSWEP(p,w,s)
	if w == qag2 then
		return true
	end
end

local function AddHook(a,b,c)
	hook.Add(a,c or 'QAG2_Hook',b)
end

AddHook('EntityTakeDamage',QAG2_EntityTakeDamage)
AddHook('GetFallDamage',QAG2_FallDamage)
AddHook('PhysgunPickup',QAG2_PhysgunPickup)
AddHook('Think',QAG2_KillSpecialNPC,Key)
AddHook('OnEntityCreated',QAG2_KillSpecialNPC_OnCreated,Key)
AddHook('Tick',QAG2_Tick)
AddHook('PlayerCanPickupWeapon',QAG2_PlayerCanPickupWeapon)
AddHook('PlayerGiveSWEP',QAG2_PlayerGiveSWEP)
AddHook('PlayerSpawnedSWEP',QAG2_PlayerSpawnedSWEP)
AddHook('PlayerSpawnSWEP',QAG2_PlayerSpawnSWEP)