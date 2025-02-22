local MAJOR_VERSION = "Threat-2.0"
local MINOR_VERSION = tonumber(("$Revision: 79729 $"):match("%d+"))

if MINOR_VERSION > _G.ThreatLib_MINOR_VERSION then _G.ThreatLib_MINOR_VERSION = MINOR_VERSION end

ThreatLib_funcs[#ThreatLib_funcs+1] = function()

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- Blizzard Combat Log constants, in case your addon loads before Blizzard_CombatLog or it's disabled by the user
---------------------------------------------------------------------------------------------------------------
local bit_band = _G.bit.band
local bit_bor  = _G.bit.bor

local COMBATLOG_OBJECT_AFFILIATION_MINE		= COMBATLOG_OBJECT_AFFILIATION_MINE		or 0x00000001
local COMBATLOG_OBJECT_AFFILIATION_PARTY	= COMBATLOG_OBJECT_AFFILIATION_PARTY	or 0x00000002
local COMBATLOG_OBJECT_AFFILIATION_RAID		= COMBATLOG_OBJECT_AFFILIATION_RAID		or 0x00000004
local COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	= COMBATLOG_OBJECT_AFFILIATION_OUTSIDER	or 0x00000008
local COMBATLOG_OBJECT_AFFILIATION_MASK		= COMBATLOG_OBJECT_AFFILIATION_MASK		or 0x0000000F
-- Reaction
local COMBATLOG_OBJECT_REACTION_FRIENDLY	= COMBATLOG_OBJECT_REACTION_FRIENDLY	or 0x00000010
local COMBATLOG_OBJECT_REACTION_NEUTRAL		= COMBATLOG_OBJECT_REACTION_NEUTRAL		or 0x00000020
local COMBATLOG_OBJECT_REACTION_HOSTILE		= COMBATLOG_OBJECT_REACTION_HOSTILE		or 0x00000040
local COMBATLOG_OBJECT_REACTION_MASK		= COMBATLOG_OBJECT_REACTION_MASK		or 0x000000F0
-- Ownership
local COMBATLOG_OBJECT_CONTROL_PLAYER		= COMBATLOG_OBJECT_CONTROL_PLAYER		or 0x00000100
local COMBATLOG_OBJECT_CONTROL_NPC			= COMBATLOG_OBJECT_CONTROL_NPC			or 0x00000200
local COMBATLOG_OBJECT_CONTROL_MASK			= COMBATLOG_OBJECT_CONTROL_MASK			or 0x00000300
-- Unit type
local COMBATLOG_OBJECT_TYPE_PLAYER			= COMBATLOG_OBJECT_TYPE_PLAYER			or 0x00000400
local COMBATLOG_OBJECT_TYPE_NPC				= COMBATLOG_OBJECT_TYPE_NPC				or 0x00000800
local COMBATLOG_OBJECT_TYPE_PET				= COMBATLOG_OBJECT_TYPE_PET				or 0x00001000
local COMBATLOG_OBJECT_TYPE_GUARDIAN		= COMBATLOG_OBJECT_TYPE_GUARDIAN		or 0x00002000
local COMBATLOG_OBJECT_TYPE_OBJECT			= COMBATLOG_OBJECT_TYPE_OBJECT			or 0x00004000
local COMBATLOG_OBJECT_TYPE_MASK			= COMBATLOG_OBJECT_TYPE_MASK			or 0x0000FC00

-- Special cases (non-exclusive)
local COMBATLOG_OBJECT_TARGET				= COMBATLOG_OBJECT_TARGET				or 0x00010000
local COMBATLOG_OBJECT_FOCUS				= COMBATLOG_OBJECT_FOCUS				or 0x00020000
local COMBATLOG_OBJECT_MAINTANK				= COMBATLOG_OBJECT_MAINTANK				or 0x00040000
local COMBATLOG_OBJECT_MAINASSIST			= COMBATLOG_OBJECT_MAINASSIST			or 0x00080000
local COMBATLOG_OBJECT_RAIDTARGET1			= COMBATLOG_OBJECT_RAIDTARGET1			or 0x00100000
local COMBATLOG_OBJECT_RAIDTARGET2			= COMBATLOG_OBJECT_RAIDTARGET2			or 0x00200000
local COMBATLOG_OBJECT_RAIDTARGET3			= COMBATLOG_OBJECT_RAIDTARGET3			or 0x00400000
local COMBATLOG_OBJECT_RAIDTARGET4			= COMBATLOG_OBJECT_RAIDTARGET4			or 0x00800000
local COMBATLOG_OBJECT_RAIDTARGET5			= COMBATLOG_OBJECT_RAIDTARGET5			or 0x01000000
local COMBATLOG_OBJECT_RAIDTARGET6			= COMBATLOG_OBJECT_RAIDTARGET6			or 0x02000000
local COMBATLOG_OBJECT_RAIDTARGET7			= COMBATLOG_OBJECT_RAIDTARGET7			or 0x04000000
local COMBATLOG_OBJECT_RAIDTARGET8			= COMBATLOG_OBJECT_RAIDTARGET8			or 0x08000000
local COMBATLOG_OBJECT_NONE					= COMBATLOG_OBJECT_NONE					or 0x80000000
local COMBATLOG_OBJECT_SPECIAL_MASK			= COMBATLOG_OBJECT_SPECIAL_MASK			or 0xFFFF0000

-- Object type constants
local COMBATLOG_FILTER_ME = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_MINE,
						COMBATLOG_OBJECT_REACTION_FRIENDLY,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_TYPE_PLAYER
						)						
						
local COMBATLOG_FILTER_MINE = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_MINE,
						COMBATLOG_OBJECT_REACTION_FRIENDLY,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_TYPE_PLAYER,
						COMBATLOG_OBJECT_TYPE_OBJECT
						)

local COMBATLOG_FILTER_MY_PET = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_MINE,
						COMBATLOG_OBJECT_REACTION_FRIENDLY,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_TYPE_GUARDIAN,
						COMBATLOG_OBJECT_TYPE_PET
						)
						
local COMBATLOG_FILTER_FRIENDLY_UNITS = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_PARTY,
						COMBATLOG_OBJECT_AFFILIATION_RAID,
						COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
						COMBATLOG_OBJECT_REACTION_FRIENDLY,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_CONTROL_NPC,
						COMBATLOG_OBJECT_TYPE_PLAYER,
						COMBATLOG_OBJECT_TYPE_NPC,
						COMBATLOG_OBJECT_TYPE_PET,
						COMBATLOG_OBJECT_TYPE_GUARDIAN,
						COMBATLOG_OBJECT_TYPE_OBJECT
						)

local COMBATLOG_FILTER_HOSTILE_UNITS = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_PARTY,
						COMBATLOG_OBJECT_AFFILIATION_RAID,
						COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
						COMBATLOG_OBJECT_REACTION_NEUTRAL,
						COMBATLOG_OBJECT_REACTION_HOSTILE,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_CONTROL_NPC,
						COMBATLOG_OBJECT_TYPE_PLAYER,
						COMBATLOG_OBJECT_TYPE_NPC,
						COMBATLOG_OBJECT_TYPE_PET,
						COMBATLOG_OBJECT_TYPE_GUARDIAN,
						COMBATLOG_OBJECT_TYPE_OBJECT
						)

local COMBATLOG_FILTER_NEUTRAL_UNITS = bit_bor(
						COMBATLOG_OBJECT_AFFILIATION_PARTY,
						COMBATLOG_OBJECT_AFFILIATION_RAID,
						COMBATLOG_OBJECT_AFFILIATION_OUTSIDER,
						COMBATLOG_OBJECT_REACTION_NEUTRAL,
						COMBATLOG_OBJECT_CONTROL_PLAYER,
						COMBATLOG_OBJECT_CONTROL_NPC,
						COMBATLOG_OBJECT_TYPE_PLAYER,
						COMBATLOG_OBJECT_TYPE_NPC,
						COMBATLOG_OBJECT_TYPE_PET,
						COMBATLOG_OBJECT_TYPE_GUARDIAN,
						COMBATLOG_OBJECT_TYPE_OBJECT
						)
local COMBATLOG_FILTER_EVERYTHING =	COMBATLOG_FILTER_EVERYTHING or 0xFFFFFFFF

-- Power Types
local SPELL_POWER_MANA = SPELL_POWER_MANA 			or 0
local SPELL_POWER_RAGE = SPELL_POWER_RAGE 			or 1
local SPELL_POWER_FOCUS = SPELL_POWER_FOCUS 		or 2
local SPELL_POWER_ENERGY = SPELL_POWER_ENERGY 		or 3
local SPELL_POWER_HAPPINESS = SPELL_POWER_HAPPINESS or 4
local SPELL_POWER_RUNES = SPELL_POWER_RUNES 		or 5

-- Temporary
local SCHOOL_MASK_NONE = SCHOOL_MASK_NONE 			or 0x00
local SCHOOL_MASK_PHYSICAL = SCHOOL_MASK_PHYSICAL 	or 0x01
local SCHOOL_MASK_HOLY = SCHOOL_MASK_HOLY 			or 0x02
local SCHOOL_MASK_FIRE = SCHOOL_MASK_FIRE 			or 0x04
local SCHOOL_MASK_NATURE = SCHOOL_MASK_NATURE 		or 0x08
local SCHOOL_MASK_FROST = SCHOOL_MASK_FROST 		or 0x10
local SCHOOL_MASK_SHADOW = SCHOOL_MASK_SHADOW 		or 0x20
local SCHOOL_MASK_ARCANE = SCHOOL_MASK_ARCANE 		or 0x40

-- local AURA_TYPE_DEBUFF = _G.AURA_TYPE_DEBUFF

---------------------------------------------------------------------------------------------------------------
-- End Combat Log constants
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

local _G = _G
local assert = _G.assert
local tonumber = _G.tonumber
local pairs = _G.pairs
local tinsert = _G.tinsert
local tremove = _G.tremove
local max = _G.max
local min = _G.min
local math_max, math_min = _G.math.max, _G.math.min
local time = _G.time
local select = _G.select
local tostring = _G.tostring
local error = _G.error
local type = _G.type
local geterrorhandler = _G.geterrorhandler
local pcall = _G.pcall
local setmetatable = _G.setmetatable
local INF = 1/0
local string_sub = _G.string.sub

local GetSpellInfo = _G.GetSpellInfo
local GetInventoryItemLink = _G.GetInventoryItemLink
local GetItemGem = _G.GetItemGem
local UnitMana = _G.UnitMana
local UnitManaMax = _G.UnitManaMax
local UnitHealth = _G.UnitHealth
local UnitHealthMax = _G.UnitHealthMax
local UnitName = _G.UnitName
local UnitClass = _G.UnitClass
local UnitIsDead = _G.UnitIsDead
local UnitAffectingCombat = _G.UnitAffectingCombat
local UnitExists = _G.UnitExists
local GetNetStats = _G.GetNetStats
local GetTime = _G.GetTime
local IsEquippedItem = _G.IsEquippedItem
local UnitLevel = _G.UnitLevel
local GetNumTalents = _G.GetNumTalents
local UnitGUID = _G.UnitGUID
local UnitBuff, UnitDebuff = _G.UnitBuff, _G.UnitDebuff
local GetSpellLink = _G.GetSpellLink

local ThreatLib = _G.ThreatLib
local prototype = {}

local guidLookup = ThreatLib.GUIDNameLookup

local new, del, newHash, newSet = ThreatLib.new, ThreatLib.del, ThreatLib.newHash, ThreatLib.newSet

local BLACKLIST_MOB_IDS = ThreatLib.BLACKLIST_MOB_IDS or {}		-- Default takes care of people that update and don't reboot WoW :P

local BuffModifiers = {
	-- Tranquil Air
	[25909] = function(self, action)
		if action == "exist" then
			self:AddBuffThreatMultiplier(0.8)
		end
	end,
	
	-- Blessing of Salvation
	[1038] = function(self, action)
		if action == "exist" then
			self:AddBuffThreatMultiplier(0.7)
		end
	end,
	
	-- Not there : Custom naxx ring for Warlock and Priest (TBC5man)
	[28762] = function(self, action)
		if action == "exist" then
			self:AddBuffThreatMultiplier(0.001)
		end
	end,	
	
	-- Greater Blessing of Salvation
	[25895] = function(self, action)
		if action == "exist" then
			self:AddBuffThreatMultiplier(0.7)
		end
	end,

	-- Arcane Shroud
	[26400] = function(self, action)
		if action == "exist" then
			local value = 0.3
			local pl = UnitLevel("player")
			
			if pl > 60 then
				value = value + (pl - 60) * 0.02
			end	
			self:AddBuffThreatMultiplier(value)
		end
	end,	
	
	-- The Eye of Diminution
	[28862] = function(self, action)
		if action == "exist" then
			local value = 0.65
			local pl = UnitLevel("player")
			if pl > 60 then
				value = value + (pl - 60) * 0.01
			end
			self:AddBuffThreatMultiplier(value)
		end
	end,	

	-- Pain Suppression - Maybe 44416? Need to test!
	[33206] = function(self, action)
		if action == "gain" then
			self:MultiplyThreat(0.95)
		end
	end	
}

local DebuffModifiers = {
	-- Fungal Bloom (Loatheb)
	[29232] = function(self, action)
		if action == "exist" then
			self:AddBuffThreatMultiplier(0)
		end
	end,

	-- Insignifigance (Gurtogg Bloodboil)
	[40618] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(0)
		end
	end,
	
	-- Fel Rage (Gurtogg Bloodboil)
	[40604] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(0)
		end
	end,
	
	-- Kaliri hamstring, for testing
	--[[
	[31553] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(0)
		end
	end,
	]]--

	-- Spiteful Fury (Arcatraz)
	[36886] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(6)
		end
	end,
	
	-- Seethe (Essence of Anger, Relinquary of Souls)
	[41520] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(3)
		end
	end,
	
	-- Wild Magic (Kalecgos)
	[45006] = function(self, action)
		if action == "exist" then
			self:AddDebuffThreatMultiplier(2)
		end
	end
}

------------------------------------------
-- Module prototype
------------------------------------------
function prototype:OnInitialize()
	if self.initted then return end
	self.timers = self.timers or {}
	self.initted = true
	ThreatLib:Debug("Init %s", self:GetName())
	self.unitType = "player"

	self.itemSets = new()
	self.itemSetsWorn = new()
	
	-- To be filled in by each class module
	self.BuffHandlers = new()			-- Called when the player gains or loses a buff
	self.DebuffHandlers = new()			-- Called when the player gains or loses a debuff
	self.AbilityHandlers = new()		-- Called when the player uses an ability (ie, has a combatlog entry)
	self.CastHandlers = new()			-- Called when the player uses an ability (ie, casts, used for flat-threat adds like buffing)
	self.CastMissHandlers = new()		-- Called when an ability misses. Used to roll back ability transactions.
	self.CastLandedHandlers = new()		-- ???
	self.MobDebuffHandlers = new()		-- Only used for Devastate right now
	self.SpellReflectSources = new()
	
	self.ClassDebuffs = new()
	self.ThreatQueries = new()
	
	-- Shrouding potion effect
	self.CastLandedHandlers[28548] = function(self)
		self:AddThreat(-800 * self:threatMods())
	end
	
	-- Imp LOTP heals are 0 threat, and in the prototype as any class can proc them
	self.ExemptGains = newHash()	
	self.ExemptGains[34299] = true
	-- Same for Lifebloom end heals
	self.ExemptGains[33778] = true
	
	-- Used to modify all data from a particular school. Only applies to some classes.
	self.schoolThreatMods = new()
	self.transactions = new()
	
	-- Stores a hash of GUID = threat level
	self.targetThreat = new()
	self.unitTypeFilter = 0xFFFFFFFF
	
	self.playerBuffSpellIDs = setmetatable({__owner = self}, {
		__index = function(t, spellName)
			local n, r, i, tn
			for k, v in pairs(BuffModifiers) do
				n, r, i = GetSpellInfo(k)
				tn = n .. "#" .. r .. "#" .. i
				t[tn] = k
				if tn == spellName then
					return k
				end
			end

			for k, v in pairs(t.__owner.BuffHandlers) do
				n, r, i = GetSpellInfo(k)
				tn = n .. "#" .. r .. "#" .. i
				t[tn] = k
				if tn == spellName then
					return k
				end
			end	
			t[spellName] = false
			return false
		end
	})

	self.playerDebuffSpellIDs = setmetatable({__owner = self}, {
		__index = function(t, spellName)
			local n, r, i, tn
			for k, v in pairs(DebuffModifiers) do
				n, r, i = GetSpellInfo(k)
				tn = n .. "#" .. r .. "#" .. i
				t[tn] = k				
				if tn == spellName then
					return k
				end
			end

			for k, v in pairs(t.__owner.DebuffHandlers) do
				n, r, i = GetSpellInfo(k)
				tn = n .. "#" .. r .. "#" .. i
				t[tn] = k
				if tn == spellName then
					return k
				end
			end
			t[spellName] = false
			return false
		end
	})	
end

function prototype:ResetBuffLookups()
	for k, v in pairs(self.playerBuffSpellIDs) do
		if k ~= "__owner" then
			self.playerBuffSpellIDs[k] = nil
		end
	end
	for k, v in pairs(self.playerDebuffSpellIDs) do
		if k ~= "__owner" then
			self.playerDebuffSpellIDs[k] = nil
		end
	end
end

function prototype:Boot()
	self:OnInitialize()
	ThreatLib:Debug("Enable %s", self:GetName())
	if GetNumTalents(1) == 0 then return end 	-- talents aren't available
	ThreatLib:Debug("Talents are available, continuing...")
	
	self.buffThreatMultipliers = 1
	self.debuffThreatMultipliers = 1
	self.buffThreatFlatMods = 0
	self.debuffThreatFlatMods = 0
	self.enchantMods = 1
	self.totalThreatMods = nil
	self.meleeCritReduction = 0
	self.spellCritReduction = 0
	self.passiveThreatModifiers = 1
	self.isTanking = false
	
	self:ScanTalents()	
	
	if not self.classInitted then
		self:ClassInit()
		self.classInitted = true
	end
	self:ClassEnable()

	if self.unitType ~= "pet" then
		self:RegisterBucketEvent("UNIT_INVENTORY_CHANGED", 0.5, "equipChanged")
		self:equipChanged()
	end
	
	self.unitTypeFilter = (self.unitType == "player" and COMBATLOG_FILTER_ME) or (self.unitType == "pet" and 0x1111)

	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	self:RegisterEvent("CHARACTER_POINTS_CHANGED")
	
	if self.unitType == "pet" then
		self:RegisterEvent("PET_ATTACK_START")
		self:RegisterEvent("PET_ATTACK_STOP")
	end
	self:RegisterEvent("PLAYER_REGEN_ENABLED")
	-- self:RegisterEvent("PLAYER_ALIVE", "PLAYER_REGEN_ENABLED")
	-- self:RegisterEvent("PLAYER_UNGHOST", "PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_DEAD", "PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_REGEN_DISABLED")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	ThreatLib:Debug("Initialized actor module")
	
	self:ResetBuffLookups()
	self:calcBuffMods()
	self:calcDebuffMods()
end

function prototype:OnEnable()
	self:Boot()
	self.unitGUID = UnitGUID(self.unitType)
end

function prototype:OnDisable()
	self:MultiplyThreat(0)
	self:PLAYER_REGEN_ENABLED()
	self.unitGUID = nil
	ThreatLib:Debug("Disable %s", self:GetName())
	
	if self.timers.PetInCombat then
		self:CancelTimer(self.timers.PetInCombat)
		self.timers.PetInCombat = nil
	end
	
	--[[
	self.itemSets 				= del(self.itemSets)
	self.itemSetsWorn 			= del(self.itemSetsWorn)
	self.BuffHandlers 			= del(self.BuffHandlers)
	self.DebuffHandlers 		= del(self.DebuffHandlers)
	self.CastHandlers 			= del(self.CastHandlers)
	self.CastLandedHandlers 	= del(self.CastLandedHandlers)
	self.CastMissHandlers 		= del(self.CastMissHandlers)
	self.AbilityHandlers 		= del(self.AbilityHandlers)
	self.schoolThreatMods 		= del(self.schoolThreatMods)
	self.transactions 			= del(self.transactions)
	self.targetThreat 			= del(self.targetThreat)
	self.ExemptGains 			= del(self.ExemptGains)
	self.MobDebuffHandlers		= del(self.MobDebuffHandlers)
	self.SpellReflectSources 	= del(self.SpellReflectSources)
	self.ClassDebuffs 			= del(self.ClassDebuffs)
	self.ThreatQueries 			= del(self.ThreatQueries)	
	]]--
	-- self.booted = false
end

local AFFILIATION_IN_GROUP = bit_bor(COMBATLOG_OBJECT_AFFILIATION_PARTY, COMBATLOG_OBJECT_AFFILIATION_RAID, COMBATLOG_OBJECT_AFFILIATION_MINE)
local NPC_TARGET = bit_bor(COMBATLOG_OBJECT_TYPE_NPC, COMBATLOG_OBJECT_TYPE_PET)
local REACTION_ATTACKABLE = bit_bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_REACTION_NEUTRAL)
local FAKE_HOSTILE = bit_bor(COMBATLOG_OBJECT_AFFILIATION_OUTSIDER, COMBATLOG_OBJECT_REACTION_NEUTRAL, COMBATLOG_OBJECT_CONTROL_NPC, COMBATLOG_OBJECT_TYPE_NPC)



local cleuHandlers = {}
function cleuHandlers:SWING_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				   amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter and bit_band(dstFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0 then
		self:parseDamage(dstGUID, amount, 0, "MELEE", school, critical, eventtype)
	end
end

function cleuHandlers:RANGE_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				   spellId, spellName, spellSchool, amount, _, _, _, critical)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter and bit_band(dstFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0 then
		self:parseDamage(dstGUID, amount, 0, spellName, spellSchool, critical, eventtype)
	end
end

function cleuHandlers:SPELL_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				   spellId, spellName, spellSchool, amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter and bit_band(dstFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0 then
		self:parseDamage(dstGUID, amount, spellId, spellName, spellSchool, critical, eventtype)
	elseif srcGUID == dstGUID and self.SpellReflectSources[srcGUID] then
		self:parseDamage(dstGUID, amount, spellId, spellName, spellSchool, critical, eventtype)
		self.SpellReflectSources[srcGUID] = nil
	end
end

function cleuHandlers:SPELL_PERIODIC_DAMAGE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
					    spellId, spellName, spellSchool, amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter and bit_band(dstFlags, COMBATLOG_OBJECT_CONTROL_PLAYER) == 0 then
		self:parseDamage(dstGUID, amount, spellId, spellName, spellSchool, critical, eventtype)
	end
end

function cleuHandlers:SPELL_CAST_SUCCESS(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
					 spellId, spellName)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter then
		self:parseCast(dstGUID, spellId, spellName)
	end
end

function cleuHandlers:SPELL_HEAL(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				 spellId, spellName, spellSchool, amount, critical)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter then
		local max_potential_heal = UnitHealthMax(dstName) - UnitHealth(dstName)
		local effective_heal = math_min(max_potential_heal, amount)
		if UnitHealthMax(dstName) == 0 then		-- They aren't in our party so we can't really get overheal for them
			effective_heal = amount
		end
		self:parseHeal(dstGUID, dstName, effective_heal, spellId, spellName, spellSchool, critical)
	end
end
cleuHandlers.SPELL_PERIODIC_HEAL = cleuHandlers.SPELL_HEAL

function cleuHandlers:SPELL_MISSED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				   spellId, spellName, spellSchool, missType)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter and self.CastMissHandlers[spellId] then
		self.CastMissHandlers[spellId](self, spellId, dstGUID)
	elseif bit_band(dstFlags, self.unitTypeFilter) == self.unitTypeFilter and missType == "REFLECT" then
		self.SpellReflectSources[srcGUID] = spellId
	elseif srcGUID == dstGUID and self.SpellReflectSources[srcGUID] then
		self.SpellReflectSources[srcGUID] = nil
	end
end

function cleuHandlers:DAMAGE_SHIELD(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				    spellId, spellName, spellSchool, amount, school, resisted, blocked, absorbed, critical, glancing, crushing)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter then
		self:parseDamage(dstGUID, amount, spellId, spellName, spellSchool, critical, eventtype)
	end
end

function cleuHandlers:SPELL_ENERGIZE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
				     spellId, spellName, spellSchool, amount, powerType)
	if bit_band(srcFlags, self.unitTypeFilter) == self.unitTypeFilter then
		self:parseGain(dstGUID, dstName, amount, spellId, spellName, powerType)
	end
end
cleuHandlers.SPELL_PERIODIC_ENERGIZE = cleuHandlers.SPELL_ENERGIZE

function cleuHandlers:SPELL_AURA_APPLIED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
					 spellId, _, _, auraType)
	if bit_band(dstFlags, self.unitTypeFilter) == self.unitTypeFilter then
		local rb, rd = false, false
		ThreatLib:Debug("Applied spell ID %s", spellId)
		if BuffModifiers[spellId] then
			BuffModifiers[spellId](self, "gain", spellId)
			rb = true
		elseif DebuffModifiers[spellId] then
			DebuffModifiers[spellId](self, "gain", spellId)
			rd = true
		end
		
		if self.BuffHandlers[spellId] then
			ThreatLib:Debug("Running gain handler for spell ID %s", spellId)
			self.BuffHandlers[spellId](self, "gain", spellId, 1)
			rb = true
		end
		if self.DebuffHandlers[spellId] then
			self.DebuffHandlers[spellId](self, "gain", spellId, 1)
			rd = true
		end
		if rb then self:calcBuffMods("gain", spellId) end
		if rd then self:calcDebuffMods("gain", spellId) end
	elseif auraType == AURA_TYPE_DEBUFF and bit_band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE and self.MobDebuffHandlers[spellId] then
		self.MobDebuffHandlers[spellId](self, spellId, dstGUID)
	end
end

function cleuHandlers:SPELL_AURA_APPLIED_DOSE(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
					      spellId, _, _, auraType)
	if bit_band(dstFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) == COMBATLOG_OBJECT_REACTION_HOSTILE and auraType == AURA_TYPE_DEBUFF then
		if self.MobDebuffHandlers[spellId] then
			self.MobDebuffHandlers[spellId](self, spellId, dstGUID)
		end
	end
end


function cleuHandlers:SPELL_AURA_REMOVED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags,
					 spellId)
	if bit_band(dstFlags, self.unitTypeFilter) == self.unitTypeFilter then
		local rb, rd = false, false
		ThreatLib:Debug("Removed spell ID %s", spellId)
		if BuffModifiers[spellId] then
			ThreatLib:Debug("Running buff loss handler for spell ID %s", spellId)
			BuffModifiers[spellId](self, "lose", spellId)
			rb = true
		elseif DebuffModifiers[spellId] then
			ThreatLib:Debug("Running debuff loss handler for spell ID %s", spellId)
			DebuffModifiers[spellId](self, "lose", spellId)
			rd = true
		end
		
		if self.BuffHandlers[spellId] then
			ThreatLib:Debug("Running buff loss handler for spell ID %s", spellId)
			self.BuffHandlers[spellId](self, "lose", spellId, 1)
			rb = true
		elseif self.DebuffHandlers[spellId] then
			ThreatLib:Debug("Running debuff loss handler for spell ID %s", spellId)
			self.DebuffHandlers[spellId](self, "lose", spellId, 1)
			rd = true
		end
		if rb then self:calcBuffMods("lose", spellId) end
		if rd then self:calcDebuffMods("lose", spellId) end
	end
end

function cleuHandlers:UNIT_DIED(timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags)
	if bit_band(dstFlags, self.unitTypeFilter) == self.unitTypeFilter then			-- we died
		self.totalThreatMods = nil
		self:MultiplyThreat(0)
	elseif self.targetThreat[dstGUID] and self.targetThreat[dstGUID] > 0 then		-- Something else died
		self:MultiplyTargetThreat(dstGUID, 0)	-- Sorta a notification thing
	end
	self.targetThreat[dstGUID] = nil
end
cleuHandlers.UNIT_DESTROYED = cleuHandlers.UNIT_DIED


function prototype:COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local timestamp, eventtype, srcGUID, srcName, srcFlags, dstGUID, dstName, dstFlags = ...
	
	guidLookup[srcGUID] = srcName
	guidLookup[dstGUID] = dstName

	-- We don't need to handle SPELL_SUMMON, and it's causing issues with shaman totems. Just kill it.
	if eventtype == "SPELL_SUMMON" then return end
	
	-- This catches heals/energizes from totems -> players, before the totems are friendly. Prevent them from being put into the threat table.
	if (eventtype == "SPELL_PERIODIC_HEAL" or eventtype == "SPELL_PERIODIC_ENERGIZE") and srcFlags == FAKE_HOSTILE then return end
	
	-- Some mobs we really don't want to track, like Crypt Scarabs. Just return immediately.
	-- Oddly, they don't have death or despawn events in the combat log, either. WHEE.
	-- This generates extra garbage, but the net/CPU savings is well, well worth it.
	if BLACKLIST_MOB_IDS[string_sub(srcGUID, -12,-7)] or BLACKLIST_MOB_IDS[string_sub(dstGUID, -12,-7)] then return end
	
	-- If this is a hostile <-> party action then enter them into the list of threat targets for global threat accumulation
	if	not self.targetThreat[srcGUID] and 
		bit_band(dstFlags, AFFILIATION_IN_GROUP) > 0 and
		bit_band(srcFlags, REACTION_ATTACKABLE) > 0 and
		bit_band(srcFlags, COMBATLOG_OBJECT_CONTROL_NPC) == COMBATLOG_OBJECT_CONTROL_NPC and
		bit_band(srcFlags, NPC_TARGET) > 0 then
		self.targetThreat[srcGUID] = 0
	elseif not self.targetThreat[dstGUID] and 
		bit_band(srcFlags, AFFILIATION_IN_GROUP) > 0 and
		bit_band(dstFlags, REACTION_ATTACKABLE) > 0 and
		bit_band(dstFlags, COMBATLOG_OBJECT_CONTROL_NPC) == COMBATLOG_OBJECT_CONTROL_NPC and
		bit_band(dstFlags, NPC_TARGET) > 0 then
		self.targetThreat[dstGUID] = 0
	end
	
	local nextEventHook = self.nextEventHook
	if nextEventHook then
		nextEventHook(self, ...)
		self.nextEventHook = nil
	end

	local handler = cleuHandlers[eventtype]
	if handler then
		handler(self, ...)
	end
end
------------------------------------------------
-- Internal utility methods
------------------------------------------------

function prototype:NumMobs()
	-- self.targetThreat is a hash, so #self.targetThreat won't work
	-- TODO: Cache this value
	
	local ct = 0
	for k, v in pairs(self.targetThreat) do
		ct = ct + 1
	end
	return ct
end

function prototype:threatMods()
	if self.totalThreatMods ~= nil then
		return self.totalThreatMods
	end
	local deathMod = 1
	if UnitIsDead(self.unitType) then
		deathMod = 0
	end
	self.totalThreatMods = self.buffThreatMultipliers * self.passiveThreatModifiers * self.debuffThreatMultipliers * self.enchantMods * deathMod
	return self.totalThreatMods
end

------------------------------------------------
-- Equipment handling
------------------------------------------------
function prototype:getWornSetPieces(name)
	if self.unitType == "pet" then
		return 0
	end
	if self.itemSetsWorn[name] then
		return self.itemSetsWorn[name]
	end
	
	local ct = 0
	local data = self.itemSets[name]
	if data then
		for i = 1, #data do
			if IsEquippedItem(data[i]) then
				ct = ct + 1
			end
		end
	end
	self.itemSetsWorn[name] = ct
	return ct
end

function prototype:equipChanged(units)
	if (units and not units.player) or ThreatLib.inCombat() then
		return
	end
	for k in pairs(self.itemSetsWorn) do
		self.itemSetsWorn[k] = nil
	end
	--self.totalThreatMods = nil
	
	self.enchantMods = 1
	
	local enchant = (GetInventoryItemLink("player", 15) or ""):match(".-item:%d+:(%d+).*")
	
	-- -2% threat on cloack
	if tonumber(enchant) == 2621 then
		self.enchantMods = self.enchantMods - 0.02
	end
	enchant = (GetInventoryItemLink("player", 10) or ""):match(".-item:%d+:(%d+).*")
	
	-- +2% threat on gloves
	if tonumber(enchant) == 2613 then
		self.enchantMods = self.enchantMods + 0.02
	end
	
	local helmlink = GetInventoryItemLink("player", 1) or "" 
	for i=1, 3 do 
		local enchant = (select(2, GetItemGem(helmlink, i)) or ""):match(".-item:(%d+).*")
		if tonumber(enchant) == 25897 then 
			self.enchantMods = self.enchantMods - 0.02 
			break
		end
	end
	
	-- metagem -2% threat FIXME: need to make sure that it's active
	--[[
	enchant = (GetItemGem(GetInventoryItemLink("player", 1) or "", 2) or ""):match(".-item:(%d+).*")
	if tonumber(enchant) == 25897 then
		self.enchantMods = self.enchantMods - 0.02
	end
	]]--
	
	-- tonumber here to speed up with possible future trinkets
	local trinket1ID = tonumber((GetInventoryItemLink("player", 13) or ""):match(".-item:(%d+):.*"))
	local trinket2ID = tonumber((GetInventoryItemLink("player", 14) or ""):match(".-item:(%d+):.*"))

	self.meleeCritReduction = 0
	self.spellCritReduction = 0
	
	-- Prism of Inner Calm, see http://www.wowhead.com/?item=30621
	if trinket1ID == 30621 or trinket2ID == 30621 then
		self.meleeCritReduction = 150
		self.spellCritReduction = 1000
	end
	
	self.totalThreatMods = nil
end

----------------------------------------------------------------------------------
-- Buff modifier handling
----------------------------------------------------------------------------------
function prototype:AddBuffThreatMultiplier(multiplier)
	self.buffThreatMultipliers = self.buffThreatMultipliers * multiplier
	ThreatLib:Debug("Set buffThreatMultipliers to %s", multiplier)
	self.totalThreatMods = nil
end

function prototype:AddBuffThreatModifier(amount)
	self.buffThreatFlatMods = self.buffThreatFlatMods + amount
	self.totalThreatMods = nil
end

----------------------------------------------------------------------------------
-- Used to construct your buff modifiers. Currently O(n^2) due to the need to get
-- the spell ID, yech!
-- Metatables make this O(n) for subsequent lookups, so it sucks less, yay!
----------------------------------------------------------------------------------
function prototype:calcBuffMods(action, spellID)
	ThreatLib:Debug("Calculating buff mods, action is %s, spell ID is %s", action, spellID)
	self.buffThreatMultipliers = 1
	local name, rank, tex, count, id
	for i = 1, 40 do
		name, rank, tex, count = UnitBuff("player", i)
		if not name then break end
		id = self.playerBuffSpellIDs[name .. "#" .. rank .. "#" .. tex]
		if id and not (action == "lose" and id == spellID) then
			local func = BuffModifiers[id] or self.BuffHandlers[id]
			if func then
				func(self, "exist", id, count)
			end
		end
	end
	ThreatLib:Debug("Final buff mods: %s", self.buffThreatMultipliers)
	self.totalThreatMods = nil
end

function prototype:calcDebuffMods(action, spellID)
	ThreatLib:Debug("Calculating debuff mods, action is %s, spell ID is %s", action, spellID)
	self.debuffThreatMultipliers = 1
	local name, rank, tex, count, id
	for i = 1, 40 do
		name, rank, tex, count = UnitDebuff("player", i)
		if not name then break end
		id = self.playerDebuffSpellIDs[name .. "#" .. rank .. "#" .. tex]
		if id and not (action == "lose" and id == spellID)  then
			ThreatLib:Debug("Running action for spell ID %s (%s)", id, GetSpellInfo(id))
			local func = DebuffModifiers[id] or self.DebuffHandlers[id]
			if func then
				func(self, "exist", id, count)
			end
		end
	end
	ThreatLib:Debug("Final debuff mods: %s", self.debuffThreatMultipliers)
	self.totalThreatMods = nil
end

----------------------------------------------------------------------------------
-- Debuff modifier handling
----------------------------------------------------------------------------------

function prototype:AddDebuffThreatMultiplier(multiplier)
	self.debuffThreatMultipliers = self.debuffThreatMultipliers * multiplier
	ThreatLib:Debug("Set debuffThreatMultipliers to %s", multiplier)
	self.totalThreatMods = nil
end

function prototype:AddDebuffThreatModifier(amount)
	self.debuffThreatFlatMods = self.debuffThreatFlatMods + amount
	self.totalThreatMods = nil
end

---------------------------------------------------------------------------
-- End buffs/debuffs
---------------------------------------------------------------------------

function prototype:parseDamage(recipient, threat, spellID, skillName, element, isCrit, eventType)
	
	if isCrit then
		if self.meleeCritReduction > 0 and element == SCHOOL_MASK_PHYSICAL then
			threat = threat - self.meleeCritReduction
		elseif self.spellCritReduction > 0 and element ~= SCHOOL_MASK_PHYSICAL then
			threat = threat - self.spellCritReduction
		end
	end
	
	if spellID and spellID ~= 0 and eventType ~= "SPELL_PERIODIC_DAMAGE" then
		self:commitTransactionFor(recipient, spellID)
	end
	
	local handler = self.AbilityHandlers[spellID]
	if handler then
		threat = handler(self, threat, isCrit)
	end
	
	handler = self.schoolThreatMods[element]
	if handler then
		threat = handler(self, threat)
	end
	
	self:AddTargetThreat(recipient, threat * self:threatMods())
end

function prototype:parseHeal(recipient, recipientName, amount, spellID, spellName, spellSchool, isCrit)
	local unitID = recipientName
	if not ThreatLib.inCombat() or not unitID or not UnitAffectingCombat(unitID) then
		return
	end
			
	local threat = amount
	
	if not self.ExemptGains[spellID] then
		local handler = self.AbilityHandlers[spellID]
		if handler then
			threat = handler(self, threat, isCrit)
		end
		
		handler = self.schoolThreatMods[spellSchool]
		if handler then
			threat = handler(self, threat)
		end
		
		threat = threat * 0.5 * self:threatMods()
		if threat ~= 0 then
			self:AddThreat(threat)
		end
	end
end

function prototype:parseGain(recipient, recipientName, amount, spellID, spellName, gainType)
	if not ThreatLib.inCombat() then
		return
	end
	
	local maxgain
	if recipientName then
		maxgain = UnitManaMax(recipientName) - UnitMana(recipientName)
	else
		return -- This can happen if a gain is procced on someone that is not in our party - for example, Blackheart MCs someone and benefits from a gain from that person.
	end
	local amount = math_min(maxgain, amount)
	if not self.ExemptGains[spellID] then
		if gainType == SPELL_POWER_MANA then
			self:AddThreat(amount * 0.5)
		elseif gainType == SPELL_POWER_RAGE then
			self:AddThreat(amount * 5)
		elseif gainType == SPELL_POWER_ENERGY then
			self:AddThreat(amount * 5)
		elseif gainType == SPELL_POWER_FOCUS then		-- TODO: Test this out.
			self:AddThreat(amount * 5)
		elseif gainType == SPELL_POWER_RUNES then		-- TODO: Obviously can't test this yet.
			self:AddThreat(amount * 5)
		end
	end
end

function prototype:parseMiss(recipient, recipientName, spellID, spellName)
	self:rollbackTransaction(recipient, spellID)
end

function prototype:parseCast(recipient, spellID, spellName)
	if self.unitType == "pet" then
		-- Pets don't get UNIT_SPELLCAST_SUCCEEDED, so we just parse their handlers here.
		if self.CastLandedHandlers[spellID] then
			self.CastLandedHandlers[spellID](self, spellID, recipient)
		end
	else
		-- This is for things like Righteous Defense, when you want to take some action for a "land" message.
		-- This can't be used in the general case because of things like Sunder, which don't always produce land messages on success.
		if self.CastLandedHandlers[spellID] then
			self.CastLandedHandlers[spellID](self, spellID, recipient)
		end
	end
end

function prototype:PLAYER_REGEN_DISABLED()
	self.totalThreatMods = nil
	if not ThreatLib.running then return end
	self.TransactionsCommitting = true
	self:activatePeriodicTransactionCommit()
end

local function func(self)
	if not UnitExists("pet") or not UnitAffectingCombat("pet") then
		if self.timers.PetInCombat then
			self:CancelTimer(self.timers.PetInCombat)
			self.timers.PetInCombat = nil
		end
		ThreatLib:Debug("Pet exiting combat.")
		ThreatLib:SendComm(ThreatLib:GroupDistribution(), "LEFT_COMBAT", false, true)
		self:ClearThreat()
		self:rollbackAllTransactions()
		self:deactivatePeriodicTransactionCommit()
		self.TransactionsCommitting = false
	end
end

function prototype:PLAYER_REGEN_ENABLED()
	self.totalThreatMods = nil		-- Accounts for death, mostly
	self:calcBuffMods()
	self:calcDebuffMods()
	if not self.TransactionsCommitting then return end
	-- PET_ATTACK_STOP doesn't always fire like you might expect it to	
	if self.unitType == "pet" then
		if self.timers.PetInCombat then
			self:CancelTimer(self.timers.PetInCombat)
		end
		self.timers.PetInCombat = self:ScheduleRepeatingTimer(func, 0.5, self)
	else
		ThreatLib:Debug("Player exiting combat.")
		local petIsOutOfCombat = not UnitExists("pet") or not UnitAffectingCombat("pet")
		ThreatLib:SendComm(ThreatLib:GroupDistribution(), "LEFT_COMBAT", true, petIsOutOfCombat)		
		self:ClearThreat()
		self:rollbackAllTransactions()
		self:deactivatePeriodicTransactionCommit()
		self.TransactionsCommitting = false
	end
end

function prototype:PET_ATTACK_START()
	self:PLAYER_REGEN_DISABLED()
end

function prototype:PET_ATTACK_STOP()
	-- self:ScheduleRepeatingEvent("ThreatClassModuleCore-PetInCombat", func, 0.5, self)
end

function prototype:CHARACTER_POINTS_CHANGED()
	self:ScanTalents()
end

------------------------------------------------
-- Public API
------------------------------------------------

function prototype:GetAbilityThreat(spell, rank, damage)
	if self.ThreatQueries[spell] then
		local threat = self.ThreatQueries[spell](self, rank or damage)
		if rank and damage then
			return threat + (damage * self:threatMods())
		end
		return threat
	end
	return 0
end

function prototype:ClearThreat()
	if not self.targetThreat then return end
	for k,v in pairs(self.targetThreat) do
		self.targetThreat[k] = nil
	end	
	ThreatLib:_clearThreat(UnitGUID(self.unitType))
end

---------------------------------------------
-- Threat modification interface [Public API]
---------------------------------------------
	
local function addTransactionOp(oplist, func, target)
	local n = #oplist
	oplist[n + 1] = func
	oplist[n + 2] = target
end

-- Specific-target threat
function prototype:AddTargetThreatTransactional(target, spellID, threat)
	local t = self:getTransaction(target, spellID)
	addTransactionOp(t.ops, "AddTargetThreat", threat)
end

-- Specific-target threat
function prototype:MultiplyTargetThreatTransactional(target, spellID, modifier)
	local t = self:getTransaction(target, spellID)
	addTransactionOp(t.ops, "MultiplyTargetThreat", modifier)
end

-- Global threat, like heals, mana gain, buffs, etc
function prototype:AddThreatTransactional(spellID, threat)
	for k, v in pairs(self.targetThreat) do
		local t = self:getTransaction(k, spellID)
		addTransactionOp(t.ops, "AddTargetThreat", threat)
	end
end

function prototype:MultiplyThreatTransactional(spellID, modifier)
	for k, v in pairs(self.targetThreat) do
		local t = self:getTransaction(k, spellID)
		addTransactionOp(t.ops, "MultiplyTargetThreat", modifier)
	end
end

-- Set your target's hate to a given value (Taunt effects, Feign Death minus resists)
function prototype:SetTargetThreatTransactional(target, spellID, threat)
	local t = self:getTransaction(target, spellID)
	addTransactionOp(t.ops, "SetTargetThreat", threat)
end

-- Reduces all threat by a multiplier. Vanish, Invisibility, some trinkets use this.
prototype.ReduceAllThreatTransactional = prototype.MultiplyThreatTransactional

------------------------------------------------
-- Overridable methods
------------------------------------------------

prototype.ScanTalents = function() end
prototype.ClassInit = function() end
prototype.ClassEnable = function() end

------------------------------------------------
-- Internal threat modification function, transaction-free
------------------------------------------------
function prototype:AddTargetThreat(target, threat)
	if threat == 0 then return end
	if self.redirectingThreat and self.redirectTarget then
		if ThreatLib.LogThreat then
			ThreatLib:Log("SEND_THREAT_TO", self.redirectTarget, target, threat)
		end
		ThreatLib:SendThreatTo(self.redirectTarget, target, threat)
	else
		local v = math_max(0, (self.targetThreat[target] or 0) + threat)
		self.targetThreat[target] = v
		if ThreatLib.LogThreat then
			ThreatLib:Log("ADD_THREAT", self.unitGUID or UnitGUID(self.unitType), target, v)
		end
		ThreatLib:ThreatUpdated(self.unitGUID or UnitGUID(self.unitType), target, v)
	end
end

function prototype:MultiplyTargetThreat(target, modifier)
	local v = (self.targetThreat[target] or 0) * modifier
	self.targetThreat[target] = v
	if ThreatLib.LogThreat then
		ThreatLib:Log("MULTIPLY_THREAT", self.unitGUID or UnitGUID(self.unitType), target, v)
	end
	ThreatLib:ThreatUpdated(self.unitGUID or UnitGUID(self.unitType), target, v)
end

-- General threat
function prototype:AddThreat(threat)
	if threat == 0 then return end
	if threat == nil then return end -- Fix for when the player sunders another player while being mind controlled due to target determining issues
	threat = threat / ThreatLib:EncounterMobs()
	for k, v in pairs(self.targetThreat) do
		self:AddTargetThreat(k, threat)
	end
end

function prototype:MultiplyThreat(modifier)
	for k, v in pairs(self.targetThreat) do
		self:MultiplyTargetThreat(k, modifier)
	end
end

function prototype:SetTargetThreat(target, threat)
	self.targetThreat[target] = threat
	ThreatLib:ThreatUpdated(self.unitGUID or UnitGUID(self.unitType), target, threat)
	if ThreatLib.LogThreat then
		ThreatLib:Log("SET_THREAT", self.unitGUID or UnitGUID(self.unitType), target, threat)
	end
end

local t = {}
function prototype:GetGUIDsByNPCID(npcid)
	for i = 1, #t do tremove(t) end
	for k, v in pairs(self.targetThreat) do
		if ThreatLib:NPCID(k) == npcid then
			tinsert(t, k)
		end
	end
	return t
end

-- Legacy, should deprecate
prototype.ReduceAllThreat = prototype.MultiplyThreat

------------------------------------------------
-- Spell transactions 
------------------------------------------------
function prototype:UNIT_SPELLCAST_SUCCEEDED(event, castingUnit, spellName, spellRank)
	if castingUnit ~= self.unitType then return end
	
	-- This only works if the spell we're casting is in our spellbook.
	local link = GetSpellLink(("%s(%s)"):format(spellName, spellRank))
	link = link or GetSpellLink(spellName)
	if not link then
		return
	end
	local spellID = tonumber(link:match("spell:(%d+)"))
	
	-- Param 3 is a target, but we can't get a target from this event! Best-guess it, if you MUST have the target then do it in CastLandedHandlers
	-- TODO: If we haven't interacted with this target before, then we won't get a target, which causes transactional junk to fail.
	if self.CastHandlers[spellID] then
		self.CastHandlers[spellID](self, spellID, UnitGUID("target"))
	end
end

function prototype:startTransaction(recipient, spellID)
	--[[
	if type("recipient") ~= "asdf" then
		error(("Expecting string for recipient, got %s (%s), trace: %s"):format(type(recipient), recipient, debugstack()))
	end	
	]]--
	local key = spellID .. "-" .. recipient
	local t = self.transactions[key]
	if t then
		self:commitTransaction(t)
		self.transactions[key] = del(t)
	end
	local v = new()
	v.spellID = spellID
	v.target = recipient
	v.time = GetTime()
	v.ops = new()
	self.transactions[key] = v
	return v
end

-- Shifts the oldest entry off of the list and invalidates it
function prototype:rollbackTransaction(recipient, spellID)
	local transaction = self:getTransaction(recipient, spellID, true)
	if not transaction then return end
	self:deleteTransaction(transaction)
end

function prototype:getTransaction(target, spellID, dontStartNew)
	local t = self.transactions[spellID .. "-" .. target]
	if not t and not dontStartNew then
		t = self:startTransaction(target, spellID)
	end
	return t
end

function prototype:commitTransactionFor(target, spellID)
	local t = self:getTransaction(target, spellID, true)
	if not t then return end
	self:commitTransaction(t)
end

function prototype:commitTransaction(transaction)
	for i = 1, #transaction.ops, 2 do
		local call = transaction.ops[i]
		local threat = transaction.ops[i + 1]

		self[call](self, transaction.target, threat)
	end
	self:deleteTransaction(transaction)
end

function prototype:deleteTransaction(transaction)
	local k = transaction.spellID .. "-" .. transaction.target
	if self.transactions[k] then
		if self.transactions[k].ops then
			self.transactions[k].ops = del(self.transactions[k].ops)
		end
		self.transactions[k] = del(self.transactions[k])
	end
end

function prototype:rollbackAllTransactions()
	for id, transaction in pairs(self.transactions) do
		self:deleteTransaction(transaction)
	end
end

function prototype:commitTransactionsPeriodic()
	local t = GetTime()
	local lag = select(3, GetNetStats()) / 1000
	for id, transaction in pairs(self.transactions) do
		if transaction and t - transaction.time > (0.65 + lag) then
			self:commitTransaction(transaction)
		end
	end	
end

do
	function prototype:deactivatePeriodicTransactionCommit()
		if self.timers["PeriodicCommit"] then
			self:CancelTimer(self.timers["PeriodicCommit"], true)
			self.timers["PeriodicCommit"] = nil
		end
	end

	function prototype:activatePeriodicTransactionCommit()
		if not self.timers["PeriodicCommit"] then
			local clientLatency = select(3, GetNetStats()) / 1000
			self.timers["PeriodicCommit"] = self:ScheduleRepeatingTimer("commitTransactionsPeriodic", 0.4 + clientLatency)
		end
	end
end

ThreatLib.GetOrCreateModule = function(self, t)	
	return self:GetModule(t, true) or self:NewModule(t, self.ClassModulePrototype, "AceEvent-3.0", "AceTimer-3.0", "AceBucket-3.0")
end

ThreatLib.ClassModulePrototype = prototype

end
