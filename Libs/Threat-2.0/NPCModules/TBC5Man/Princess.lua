local MAJOR_VERSION = "Threat-2.0"
local MINOR_VERSION = tonumber(("$Revision: 70635 $"):match("%d+"))

if MINOR_VERSION > _G.ThreatLib_MINOR_VERSION then _G.ThreatLib_MINOR_VERSION = MINOR_VERSION end

ThreatLib_funcs[#ThreatLib_funcs+1] = function()
	local ThreatLib = _G.ThreatLib

	local PRINCESS_ID = 15509

	ThreatLib:GetModule("NPCCore"):RegisterModule(PRINCESS_ID, function(Princess)
		
		--local firstAirTimer, secondAirTimer

		function Princess:Init()
			self:RegisterCombatant(PRINCESS_ID, true)

			self:RegisterEvent("TBC5_PRINCESS_REFLECT_ENDING", "ResetPrincessThreat")
		end
		

		-- Sent from custom DBM of AQ on TBC5Man
		function Princess:ResetPrincessThreat()
			--phaseTimer = nil
			self:WipeRaidThreatOnMob(PRINCESS_ID)
		end

	end)

end
