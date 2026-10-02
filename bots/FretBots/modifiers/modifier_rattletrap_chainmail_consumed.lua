--[[
Rattletrap "Consume Chainmail" custom modifier.
Each consumed Chainmail grants a permanent +5 armor. The modifier uses
MODIFIER_ATTRIBUTE_MULTIPLE so every consumed Chainmail adds an independent
stacking instance (each returns +5 armor from GetModifierPhysicalArmorBonus).
--]]
if modifier_rattletrap_chainmail_consumed == nil then modifier_rattletrap_chainmail_consumed = class({}) end

function modifier_rattletrap_chainmail_consumed:IsHidden()
	return false
end

function modifier_rattletrap_chainmail_consumed:IsDebuff()
	return false
end

function modifier_rattletrap_chainmail_consumed:IsPurgable()
	return false
end

function modifier_rattletrap_chainmail_consumed:RemoveOnDeath()
	return false
end

function modifier_rattletrap_chainmail_consumed:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_rattletrap_chainmail_consumed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_rattletrap_chainmail_consumed:GetModifierPhysicalArmorBonus( params )
	return 5
end
