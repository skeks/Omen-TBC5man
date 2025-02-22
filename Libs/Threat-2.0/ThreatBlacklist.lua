local MAJOR_VERSION = "Threat-2.0"
local MINOR_VERSION = tonumber(("$Revision: 90000 $"):match("%d+"))

if MINOR_VERSION > _G.ThreatLib_MINOR_VERSION then _G.ThreatLib_MINOR_VERSION = MINOR_VERSION end

ThreatLib_funcs[#ThreatLib_funcs+1] = function()

	local ThreatLib = _G.ThreatLib
	
	--[[
	 Mob IDs to completely ignore all threat calculations on, in decimal.
	 This should be things like Crypt Scarabs, which do not have a death message after kamakazing, or
	 other very-low-HP enemies that zerg players and for whom threat data is not important.
	 
	 The reason for this is to eliminate unnecessary comms traffic gluts when these enemies are spawned, or to
	 prevent getting enemies that despawn (and not die) from getting "stuck" in the threat list for the duration
	 of the fight.
	]]-- 
	
	ThreatLib.BLACKLIST_MOB_IDS = {
	
		[17967] = true,		-- Crypt Scarabs, used by Crypt Fiends in Hyjal
		[10577] = true,		-- More scarabs
		
		-- Karazhan
		-- [16491] = true, 	-- Mana Feeder, fish like mob and no aggro table
							-- Mana Feeders do have an aggro table - my rogue holds aggro on them regularly! :P		-- Antiarc
							
		-- [16524] = true,		-- Shade of Aran -- I guess people use threat info on him for all-school lockouts.
		[17267] = true,		-- Fiendish Imp, from the Illhoof encounter
		[17535] = true,		-- Dorothee, Opera House "Wizard of Oz" (no aggro table)
		
		-- Magister's Terrace
		[24553] = true,		-- Apoko
		[24554] = true,		-- Eramas Brightblaze
		[24555] = true,		-- Garaxxas
		[24556] = true,		-- Zelfan
		[24557] = true,		-- Kagani Nightstrike 
		[24558] = true,		-- Ellris Duskhallow 
		[24559] = true,		-- Warlord Salaris
		[24560] = true,		-- Priestess Delrissa
		[24561] = true,		-- Yazzai
		
		-- Serpentshrine Cavern
		[22140] = true,		-- Toxic Spore Bats

		-- AQ40
		[15630] = true,		-- Spawn of Fankriss
		
		-- Strathholme
		[11197] = true,		-- Mindless Skeleton
		[11030] = true,		-- Mindless Zombie
		[10461] = true,		-- Plagued Insect
		[10536] = true,		-- Plagued Maggot
		[10441] = true,		-- Plagued Rat
		[10876] = true,		-- Undead Scarab
		
		-- World
		[19833] = true,		-- Snake Trap snakes
		[19921] = true,		-- Snake Trap snakes
		
		-- Black Temple
		[22841] = true,		-- Shade of Akama
		[22929] = true,		-- Greater Shadowfiend, Summon by Illidari Nightlord
		[23398] = true,		-- Angered Soul Fragment
		[23418] = true,		-- Essence of Suffering (Essence of Soul encounter)
		[23469] = true,		-- Enslaved Soul (Essence of Soul encounter)
		[23421] = true,		-- Ashtongue Channeler (Shade of Akama encounter)
		[23215] = true,		-- Ashtongue Sorcerer (same)
		[23111] = true,		-- Shadowy Construct (Teron Gorefiend)
		[23375] = true,		-- Shadow Demon (Illidan encounter)
		[23254] = true,         -- Fel Geyser (Gurtogg Bloodboil)
		
		-- Sunwell
		[25214] = true,		-- Shadow Image, Eredar Twins
		[25744] = true,		-- Dark Fiend, M'uru encounter
		[25502] = true,		-- Shield Orb, Kil'jaeden encounter
		
		-- [22144] = true,		-- Test, comment out for production 
	}

	-- Convert the IDs to hex for direct string matching in the GUID
	local HexList = {}
	for k, v in pairs(ThreatLib.BLACKLIST_MOB_IDS) do
		HexList[("%06X"):format(k)] = true
	end
	ThreatLib.BLACKLIST_MOB_IDS = HexList
	HexList = nil
	
	function ThreatLib:IsMobBlacklisted(guid)
		return ThreatLib.BLACKLIST_MOB_IDS[string_sub(guid, -12,-7)] == true
	end	
end
