function gadget:GetInfo()  return {    name      = "War Spawner",    desc      = "Spawns units for war test. Use with NullAI",    author    = "Google Frog",    date      = "14 May 2013",    license   = "GNU GPL, v2 or later",    layer     = 0,    enabled   = true  --  loaded by default?  }end--------------------------------------------------------------------------------------------------------------------------------------------------------------------------if (not gadgetHandler:IsSyncedCode()) then    returnend--------------------------------------------------------------------------------------------------------------------------------------------------------------------------local MAP_SIZE_X = Game.mapSizeXlocal MAP_SIZE_Z = Game.mapSizeZlocal CMD_FIGHT = CMD.FIGHTlocal spawnDef = UnitDefNames["corfav"].idlocal SPACING = 50local LineLength = 100local spawnCount = 400local END_FRAME = 30*20*1local spawn = {	[0] = {x = MAP_SIZE_X*0.5 - LineLength*SPACING*0.5, z = MAP_SIZE_Z*0.75-200, face = 0, pos = 0},	[1] = {x = MAP_SIZE_X*0.5 - LineLength*SPACING*0.5, z = MAP_SIZE_Z*0.75+200, face = 2, pos = 0}	}function gadget:GameStart() -- GameStart	Spring.Echo("War Spawner Active")	for i = 1, spawnCount do		for t = 0, 1 do			spawn[t].pos = spawn[t].pos + 1			if spawn[t].pos > LineLength then				spawn[t].pos = 0			end						local unitID = Spring.CreateUnit(spawnDef, spawn[t].x + spawn[t].pos*SPACING, 0, spawn[t].z, spawn[t].face, t)			Spring.GiveOrderToUnit(unitID, CMD_FIGHT, {spawn[1 - t].x  + spawn[t].pos*SPACING,0,spawn[1 - t].z}, {})			--units[t][#units[t] + 1] = unitID		end	end		--[[		local units = {[0] = {}, [1] = {}}	for x = -Num, Num do		for z = -Num, Num do			for t = 0, 1 do				local unitID = Spring.CreateUnit(spawnDef, spawn[t].x + x*SPACING, 0, spawn[t].z + z*SPACING, spawn[t].face, t)				units[t][#units[t] + 1] = unitID			end		end	end			Spring.GiveOrderToUnitArray(units[0], CMD_FIGHT, {spawn[1].x + spawn[0].pos*SPACING,0,spawn[1].z}, {})	Spring.GiveOrderToUnitArray(units[1], CMD_FIGHT, {spawn[0].x + spawn[1].pos*SPACING,0,spawn[0].z}, {})--]]endfunction gadget:UnitDestroyed(unitID, unitDefID, unitTeam)	if unitDefID == spawnDef and spawn[unitTeam] then		spawn[unitTeam].pos = spawn[unitTeam].pos + 1		if spawn[unitTeam].pos > LineLength then			spawn[unitTeam].pos = 0		end		local unitID = Spring.CreateUnit(spawnDef, spawn[unitTeam].x + spawn[unitTeam].pos*SPACING, 0, spawn[unitTeam].z, spawn[unitTeam].face, unitTeam)		Spring.GiveOrderToUnit(unitID, CMD_FIGHT, {spawn[1 - unitTeam].x  + spawn[unitTeam].pos*SPACING,0,spawn[1 - unitTeam].z}, {})	endendfunction gadget:GameFrame(f)	if f == END_FRAME then		Spring.GameOver({})	endend