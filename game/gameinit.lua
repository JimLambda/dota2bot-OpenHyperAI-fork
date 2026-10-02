--============ Copyright (c) Valve Corporation, All rights reserved. ==========
--
--
--=============================================================================
require( "game/dkjson" )

function HasBaseClass( object, baseClass )
    while ( object ~= nil ) do
		if ( object == baseClass ) then
			return true
		end
		local mt = getmetatable( object )
		if mt == nil then
			return false
		end
		object = mt.__index
	end
	return false
end


-- Backwards compatability glue.
if PrecacheUnitByNameSync ~= nil then
	PrecacheUnitByNameSync_Engine = PrecacheUnitByNameSync
	PrecacheUnitByNameSync = function( szUnitName, hContext, nPlayerID )
		if nPlayerID == nil then
			nPlayerID = -1
		end
		PrecacheUnitByNameSync_Engine( szUnitName, hContext, nPlayerID )
	end
end

if PrecacheUnitByNameAsync ~= nil then
	PrecacheUnitByNameAsync_Engine = PrecacheUnitByNameAsync
	PrecacheUnitByNameAsync = function( szUnitName, hCallback, nPlayerID)
		if nPlayerID == nil then
			nPlayerID = -1
		end
		PrecacheUnitByNameAsync_Engine( szUnitName, hCallback, nPlayerID )
	end
end

if CDOTABaseAbility ~= nil then		
	-- Ensure we always pass enough arguments to GetCastRange.
	-- Passing nil as target is fine.
	CDOTABaseAbility.GetCastRange_Engine = CDOTABaseAbility.GetCastRange
	CDOTABaseAbility.GetCastRange = function( self, vLocation, hTarget )
		if vLocation == nil then
			vLocation = Vector( 0, 0, 0 )
		end
		return CDOTABaseAbility.GetCastRange_Engine( self, vLocation, hTarget )
	end

	CDOTABaseAbility.IsCosmetic_Engine = CDOTABaseAbility.IsCosmetic
	CDOTABaseAbility.IsCosmetic = function( self, hTarget )
		return CDOTABaseAbility.IsCosmetic_Engine( self, hTarget )
	end
end

if CBaseEntity ~= nil then
	CBaseEntity.IsBaseNPC = function ( self ) return false end

	CBaseEntity.GetAbsOrigin_Engine = CBaseEntity.GetAbsOrigin
	CBaseEntity.GetAbsOrigin = CBaseEntity.GetOrigin 
	CBaseEntity.SetAbsOrigin_Engine = CBaseEntity.SetAbsOrigin
	CBaseEntity.SetAbsOrigin = function( self, v )
		self.SetOrigin( self, v )
	end
end

if CDOTA_BaseNPC ~= nil then
	CDOTA_BaseNPC.IsHardDisarmed = function( self ) 
		print( "CDOTA_BaseNPC.IsHardDisarmed is deprecated, please call IsDisarmed." )
		return CDOTA_BaseNPC.IsDisarmed( self )
	end
	CDOTA_BaseNPC.IsSoftDisarmed = function( self ) 
		print( "CDOTA_BaseNPC.IsSoftDisarmed is deprecated, please call IsDisarmed." )
		return CDOTA_BaseNPC.IsDisarmed( self )
	end
	CDOTA_BaseNPC.IsBaseNPC = function ( self ) return true end
end

if CDOTA_BaseNPC_Hero ~= nil then
	CDOTA_BaseNPC_Hero.AddExperience_Engine = CDOTA_BaseNPC_Hero.AddExperience
	CDOTA_BaseNPC_Hero.AddExperience = function( self, flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal, nCloneCount )
		if bIncrementTotal == nil then
			-- Argument added in the middle of the parameters.
			bIncrementTotal = bApplyBotDifficultyScaling
			bApplyBotDifficultyScaling = nReason
			nReason = DOTA_ModifyXP_Unspecified
		end
		if nCloneCount == nil then
			nCloneCount = 0
		end
		return CDOTA_BaseNPC_Hero.AddExperience_Engine( self, flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal, nCloneCount )
	end

	CDOTA_BaseNPC_Hero.IncrementDeaths_Engine = CDOTA_BaseNPC_Hero.IncrementDeaths
	CDOTA_BaseNPC_Hero.IncrementDeaths = function( self, nKillerID )
		if nKillerID == nil then
			nKillerID = -1
		end
		return CDOTA_BaseNPC_Hero.IncrementDeaths_Engine( self, nKillerID )
	end
end

if CDOTA_PlayerResource ~= nil then
	CDOTA_PlayerResource.GetCreepDamageTaken_Engine = CDOTA_PlayerResource.GetCreepDamageTaken
	CDOTA_PlayerResource.GetCreepDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetCreepDamageTaken_Engine( self, nPlayerID, bTotal )
	end

	CDOTA_PlayerResource.GetHeroDamageTaken_Engine = CDOTA_PlayerResource.GetHeroDamageTaken
	CDOTA_PlayerResource.GetHeroDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetHeroDamageTaken_Engine( self, nPlayerID, bTotal )
	end
	
	CDOTA_PlayerResource.GetTowerDamageTaken_Engine = CDOTA_PlayerResource.GetTowerDamageTaken
	CDOTA_PlayerResource.GetTowerDamageTaken = function( self, nPlayerID, bTotal )
		if bTotal == nil then
			bTotal = false
		end
		return CDOTA_PlayerResource.GetTowerDamageTaken_Engine( self, nPlayerID, bTotal )
	end

	CDOTA_PlayerResource.IncrementDeaths_Engine = CDOTA_PlayerResource.IncrementDeaths
	CDOTA_PlayerResource.IncrementDeaths = function( self, nPlayerID, nKillerID )
		if nKillerID == nil then
			nKillerID = -1
		end
		return CDOTA_PlayerResource.IncrementDeaths_Engine( self, nPlayerID, nKillerID )
	end

	CDOTA_PlayerResource.GetEventPremiumPointsGranted = CDOTA_PlayerResource.GetEventPremiumPoints
 	CDOTA_PlayerResource.GetEventRankGranted = CDOTA_PlayerResource.GetEventRanks

	CDOTA_PlayerResource.IncrementTotalEarnedXP_Engine = CDOTA_PlayerResource.IncrementTotalEarnedXP
	CDOTA_PlayerResource.IncrementTotalEarnedXP = function( self, nPlayerID, nXP, nReason )
		if nReason == nil then
			nReason = DOTA_ModifyXP_Unspecified
		end
		return CDOTA_PlayerResource.IncrementTotalEarnedXP_Engine( self, nPlayerID, nXP, nReason )
	end

	CDOTA_PlayerResource.HeroLevelUp = function( self, nPlayerID )
		print("DEPRICATED FUNCTION CALLED: PlayerResource:HeroLevelUp, remove before the end of BETA to prevent script errors")
	end
end

-- Lua ability binding glue-
if CDOTA_Ability_Lua ~= nil then
	CDOTA_Ability_Lua.CastFilterResult_Engine = CDOTA_Ability_Lua.CastFilterResult
	CDOTA_Ability_Lua.CastFilterResult = function( self, param )
		if getmetatable( param ) == Vector then
			return CDOTA_Ability_Lua.CastFilterResultLocation( self, param )
		elseif param ~= nil then
			return CDOTA_Ability_Lua.CastFilterResultTarget( self, param )
		else
			return CDOTA_Ability_Lua.CastFilterResult_Engine( self )
		end
	end

	CDOTA_Ability_Lua.GetCustomCastError_Engine = CDOTA_Ability_Lua.GetCustomCastError
	CDOTA_Ability_Lua.GetCustomCastError = function( self, param )
		if getmetatable( param ) == Vector then
			return CDOTA_Ability_Lua.GetCustomCastErrorLocation( self, param )
		elseif param ~= nil then
			return CDOTA_Ability_Lua.GetCustomCastErrorTarget( self, param )
		else
			return CDOTA_Ability_Lua.GetCustomCastError_Engine( self )
		end
	end
end

if LinkLuaModifier ~= nil then
	LinkLuaModifier_Engine = LinkLuaModifier
	function LinkLuaModifier( modifierName, fileName, modifierType )
		if modifierType == nil then
			return LinkLuaModifier_Engine( modifierName, modifierName, fileName )
		else
			return LinkLuaModifier_Engine( modifierName, fileName, modifierType )
		end
	end
end

--=============================================================================
-- Rattletrap "consume Chainmail" consumer.
--
-- The custom bot scripts (bots/ability_item_usage_generic.lua and
-- bots/item_purchase_generic.lua) run in the bot Lua VM, whose unit handles expose
-- neither RemoveItem() nor AddNewModifier(). A bot can therefore buy Chainmail
-- forever but can never destroy it or gain the armor. This file is the game VM
-- entry point and does have the full unit API, so the consuming lives here.
--
-- Every Chainmail that shows up on a Rattletrap (main inventory, backpack or stash)
-- is destroyed and replaced with one permanent +5 armor stack.
--
-- Two engine quirks make this harder than it looks, and both are handled below:
--   1. LinkLuaModifier() never reports failure. It leaves the name unregistered, and
--      AddNewModifier() then still hands back a placeholder modifier - so HasModifier()
--      is TRUE - while printing "Attempted to create unknown modifier type". Neither the
--      return value nor HasModifier() proves anything; only the hero's armor going up does.
--   2. Which (path, argument-order) form the engine accepts is not knowable up front, so
--      every plausible form is tried in turn and only a working one is kept.
--=============================================================================
local OHA_CHAINMAIL_HERO = "npc_dota_hero_rattletrap"
local OHA_CHAINMAIL_ITEM = "item_chainmail"
local OHA_CHAINMAIL_MOD = "modifier_rattletrap_chainmail_consumed"
-- Candidate registrations. Re-registering the same modifier name replaces the previous
-- entry, which is what makes probing possible. Paths are relative to scripts/vscripts.
-- "legacy" means the raw engine function called with the old (name, name, file) order.
local OHA_CHAINMAIL_TRIES = {
	{ path = "bots/FretBots/modifiers/" .. OHA_CHAINMAIL_MOD },
	{ path = "bots/FretBots/modifiers/" .. OHA_CHAINMAIL_MOD .. ".lua" },
	{ path = "game/" .. OHA_CHAINMAIL_MOD },
	{ path = "game/" .. OHA_CHAINMAIL_MOD .. ".lua" },
	{ path = "FretBots/modifiers/" .. OHA_CHAINMAIL_MOD },
	{ path = "FretBots/modifiers/" .. OHA_CHAINMAIL_MOD .. ".lua" },
	{ path = "bots/FretBots/modifiers/" .. OHA_CHAINMAIL_MOD, legacy = true },
	{ path = "bots/FretBots/modifiers/" .. OHA_CHAINMAIL_MOD .. ".lua", legacy = true },
}
local OHA_ChainmailTotals = {}
local OHA_ModReady = false
local OHA_ProbeTicks = 0
local OHA_NextTry = 1

function OHA_FindHeroesNamed( sUnitName )
	local tHeroes = {}
	if PlayerResource == nil then return tHeroes end
	for nPlayerID = 0, 23 do
		local hHero = nil
		pcall( function() hHero = PlayerResource:GetSelectedHeroEntity( nPlayerID ) end )
		if hHero == nil and PlayerResource.GetPlayer ~= nil then
			pcall( function()
				local pPlayer = PlayerResource:GetPlayer( nPlayerID )
				if pPlayer ~= nil then hHero = pPlayer:GetAssignedHero() end
			end )
		end
		if hHero ~= nil and hHero.GetUnitName ~= nil and hHero:GetUnitName() == sUnitName then
			table.insert( tHeroes, hHero )
		end
	end
	return tHeroes
end

function OHA_GetArmor( hHero )
	local nArmor = nil
	pcall( function() nArmor = hHero:GetPhysicalArmorValue( false ) end )
	if nArmor == nil then
		pcall( function() nArmor = hHero:GetPhysicalArmorBaseValue() end )
	end
	return nArmor
end

-- Registers the modifier name against one candidate and proves it by measuring armor.
-- A candidate only counts as working if the hero's armor really rises by ~5.
function OHA_TryChainmailModifier( hHero, tTry )
	if tTry.legacy and LinkLuaModifier_Engine ~= nil then
		pcall( function() LinkLuaModifier_Engine( OHA_CHAINMAIL_MOD, OHA_CHAINMAIL_MOD, tTry.path ) end )
	else
		local nType = LUA_MODIFIER_MOTION_NONE
		if nType == nil then nType = 0 end
		pcall( LinkLuaModifier, OHA_CHAINMAIL_MOD, tTry.path, nType )
	end

	local nBefore = OHA_GetArmor( hHero )
	pcall( function() hHero:AddNewModifier( hHero, nil, OHA_CHAINMAIL_MOD, {} ) end )
	local nAfter = OHA_GetArmor( hHero )
	local bOk = nBefore ~= nil and nAfter ~= nil and ( nAfter - nBefore ) >= 4.9
	if not bOk then
		-- The registration did not take, so AddNewModifier only left a placeholder behind.
		pcall( function() hHero:RemoveModifierByName( OHA_CHAINMAIL_MOD ) end )
	end
	print( "[chainmail-consume] try path=" .. tTry.path .. ( tTry.legacy and " legacy" or "" )
		.. " armor=" .. tostring(nBefore) .. "->" .. tostring(nAfter) .. " ok=" .. tostring(bOk) )
	return bOk
end

function OHA_ConsumeChainmail()
	local nConsumed = 0
	for _, hHero in ipairs( OHA_FindHeroesNamed( OHA_CHAINMAIL_HERO ) ) do
		if hHero:IsAlive() then
			-- 0-5 main inventory, 6-8 backpack, 9-14 stash.
			local nSlot = -1
			for s = 0, 14 do
				local hItem = hHero:GetItemInSlot( s )
				if hItem ~= nil and hItem:GetName() == OHA_CHAINMAIL_ITEM then
					nSlot = s
					break
				end
			end
			-- While no candidate works yet, sweep them only every ~5s so a failing
			-- registration does not turn into a per-tick stream of engine errors.
			if nSlot >= 0 and OHA_ProbeTicks <= 0 then
				if not OHA_ModReady then
					for _ = 1, #OHA_CHAINMAIL_TRIES do
						if OHA_TryChainmailModifier( hHero, OHA_CHAINMAIL_TRIES[OHA_NextTry] ) then
							OHA_ModReady = true
							OHA_ProbeTicks = 0
							break
						end
						OHA_NextTry = OHA_NextTry + 1
						if OHA_NextTry > #OHA_CHAINMAIL_TRIES then OHA_NextTry = 1 end
					end
					if not OHA_ModReady then
						-- A failed sweep must never destroy the Chainmail.
						OHA_ProbeTicks = 10
						print( "[chainmail-consume] no working registration yet, item kept" )
					end
				else
					hHero:AddNewModifier( hHero, nil, OHA_CHAINMAIL_MOD, {} )
				end

				if OHA_ModReady then
					local hItem = hHero:GetItemInSlot( nSlot )
					if hItem ~= nil and hItem:GetName() == OHA_CHAINMAIL_ITEM then
						hHero:RemoveItem( hItem )
						local nKey = 0
						pcall( function() nKey = hHero:entindex() end )
						OHA_ChainmailTotals[nKey] = ( OHA_ChainmailTotals[nKey] or 0 ) + 1
						nConsumed = nConsumed + 1
						print( "[chainmail-consume] slot=" .. tostring(nSlot)
							.. " total=" .. tostring(OHA_ChainmailTotals[nKey]) )
					end
				end
			end
		end
	end
	return nConsumed
end

function OHA_ChainmailStart()
	if _G.OHA_ChainmailActive then return true end
	if GameRules == nil or GameRules.GetGameModeEntity == nil then return false end
	local gm = GameRules:GetGameModeEntity()
	if gm == nil then return false end
	_G.OHA_ChainmailActive = true

	gm:SetThink( function()
		if not OHA_ModReady then OHA_ProbeTicks = OHA_ProbeTicks - 1 end
		OHA_ConsumeChainmail()
		return 0.5
	end, "OHA_ChainmailConsume", 0.5 )
	print( "[chainmail-consume] game VM hook active (" .. OHA_CHAINMAIL_HERO .. " -> +5 armor per Chainmail)" )
	return true
end

if not OHA_ChainmailStart() then
	pcall( function()
		ListenToGameEvent( "game_rules_state_change", function() OHA_ChainmailStart() end, nil )
	end )
end