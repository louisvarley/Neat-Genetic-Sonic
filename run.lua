--Update to Seth-Bling's MarI/O app to run Sonic The Hedgehog 2, Megadrive / Genesis

--Config Settings can be changed to change the reward system and neat weights and numbers

-------------------------------------------------------------------------
--GLOBALS
-------------------------------------------------------------------------

local _SONIC = {}
local _SPRITES = {}
local _CONFIG = {}
local _MATH = {}

-------------------------------------------------------------------------
--CONFIGS
-------------------------------------------------------------------------

_CONFIG.StateDir = "state/"
_CONFIG.PoolDir = "pool/"
_CONFIG.State = "S2.State"

_CONFIG.NeatConfig = {
	Filename = _CONFIG.StateDir .. _CONFIG.State,
	PoolFilename = _CONFIG.PoolDir .. _CONFIG.State,
	Population = 200, -- 300
	DeltaDisjoint = 2.0,
	DeltaWeights = 0.4,
	DeltaThreshold = 1.0,
	StaleSpecies = 10, -- 10
	MutateConnectionsChance = 0.25,
	PerturbChance = 0.90,
	CrossoverChance = 0.75,
	LinkMutationChance = 2.0,
	NodeMutationChance = 0.50,
	BiasMutationChance = 0.40,
	StepSize = 0.1,
	DisableMutationChance = 0.4,
	EnableMutationChance = 0.2,
	TimeoutConstant = 30,
	MaxNodes = 10000000,
}

--Enable / Disable These Fitness Reward Bonuses
_CONFIG.enableRingBonus = true -- Reward for collecting Rings
_CONFIG.enableScoreBonus = true -- Reward for Score
_CONFIG.enablePowerUpBonus = true -- Reward for collecting powerups
_CONFIG.enableBossHitBonus = true -- Reward for any hits on a boss
_CONFIG.enableLevelBeatBonus = true -- Reward for beating a level
_CONFIG.enableJumpBonus = false -- Reward for the number of jumps
_CONFIG.enableVelocityBonus = true -- Reward for maintaing velocity

--Bonus Multipliers
_CONFIG.ringMultiplier = 10
_CONFIG.scoreMultiplier = 1
_CONFIG.powerUpMultiplier = 1000
_CONFIG.bossHitMultiplier = 3000
_CONFIG.levelBeatMultiplier = 10
_CONFIG.jumpMultiplier = 20

--Values to apply to inputs
_CONFIG.bad = -1
_CONFIG.neutral = 1
_CONFIG.good = -1
_CONFIG.boss = -1

--Button names used by BizHawk
_CONFIG.ButtonA = "P1 A"
_CONFIG.ButtonUp = "P1 Up"
_CONFIG.ButtonDown = "P1 Down"
_CONFIG.ButtonLeft = "P1 Left"
_CONFIG.ButtonRight = "P1 Right"

_CONFIG.ButtonNames = {
	_CONFIG.ButtonA,
	_CONFIG.ButtonUp,
	_CONFIG.ButtonDown,
	_CONFIG.ButtonLeft,
	_CONFIG.ButtonRight,
}
	
_CONFIG.autoFireButton = true -- Should holding down a button act as a single push or many pushes  

_CONFIG.BoxRadius = 10 --Increased from 8
_CONFIG.InputSize = (_CONFIG.BoxRadius*2+1)*(_CONFIG.BoxRadius*2+1)
_CONFIG.Running = false

------------------------------------------------------------
--SPRITES--
------------------------------------------------------------

_SPRITES.Sprites = {}

--Sprite Table with a name and given type using the RAM offset
--Type [good/bad/neutral]

_SPRITES.objectfields = {
	types = {		
		[0x01] = {type="" , name="Sonic"},
		[0x02] = {type="" , name="Tails"},
		[0x03] = {type="" , name="PlaneSwitcher"},
		[0x04] = {type="" , name="WaterSurface"},
		[0x05] = {type="" , name="TailsTails"},
		[0x06] = {type="" , name="Spiral"},
		[0x07] = {type="" , name="Oil"},
		[0x08] = {type="" , name="SpindashDust"},
		[0x08] = {type="" , name="Splash"},
		[0x09] = {type="" , name="SonicSS"},
		[0x0A] = {type="" , name="SmallBubbles"},
		[0x0B] = {type="" , name="TippingFloor"},
		[0x0D] = {type="" , name="Signpost"},
		[0x0E] = {type="" , name="IntroStars"},
		[0x0F] = {type="" , name="TitleMenu"},
		[0x10] = {type="" , name="TailsSS"},
		[0x11] = {type="" , name="Bridge"},
		[0x12] = {type="" , name="HPZEmerald"},
		[0x13] = {type="" , name="HPZWaterfall"},
		[0x14] = {type="" , name="Seesaw"},
		[0x15] = {type="" , name="SwingingPlatform"},
		[0x16] = {type="" , name="HTZLift"},
		[0x18] = {type="" , name="ARZPlatform"},
		[0x18] = {type="good" , name="EHZPlatform"},
		[0x19] = {type="" , name="CPZPlatform"},
		[0x19] = {type="" , name="OOZMovingPform"},
		[0x19] = {type="" , name="WFZPlatform"},
		[0x1A] = {type="" , name="HPZCollapsPform"},
		[0x1B] = {type="" , name="SpeedBooster"},
		[0x1C] = {type="" , name="Scenery"},
		[0x1C] = {type="" , name="BridgeStake"},
		[0x1C] = {type="" , name="FallingOil"},
		[0x1D] = {type="" , name="BlueBalls"},
		[0x1E] = {type="" , name="CPZSpinTube"},
		[0x1F] = {type="" , name="CollapsPform"},
		[0x20] = {type="" , name="LavaBubble"},
		[0x21] = {type="" , name="HUD"},
		[0x22] = {type="" , name="ArrowShooter"},
		[0x23] = {type="" , name="FallingPillar"},
		[0x24] = {type="" , name="ARZBubbles"},
		[0x25] = {type="good" , name="Ring"},
		[0x26] = {type="good" , name="Monitor"},
		[0x27] = {type="" , name="Explosion"},
		[0x28] = {type="" , name="Animal"},
		[0x29] = {type="" , name="Points"},
		[0x2A] = {type="" , name="Stomper"},
		[0x2B] = {type="" , name="RisingPillar"},
		[0x2C] = {type="" , name="LeavesGenerator"},
		[0x2D] = {type="" , name="Barrier"},
		[0x2E] = {type="" , name="MonitorContents"},
		[0x2F] = {type="" , name="SmashableGround"},
		[0x30] = {type="" , name="RisingLava"},
		[0x31] = {type="" , name="LavaMarker"},
		[0x32] = {type="" , name="BreakableBlock"},
		[0x32] = {type="" , name="BreakableRock"},
		[0x33] = {type="" , name="OOZPoppingPform"},
		[0x34] = {type="" , name="TitleCard"},
		[0x35] = {type="" , name="InvStars"},
		[0x36] = {type="bad" , name="Spikes"},
		[0x37] = {type="good" , name="LostRings"},
		[0x38] = {type="" , name="Shield"},
		[0x39] = {type="" , name="GameOver"},
		[0x39] = {type="" , name="TimeOver"},
		[0x3A] = {type="" , name="Results"},
		[0x3D] = {type="" , name="OOZLauncher"},
		[0x3E] = {type="" , name="EggPrison"},
		[0x3F] = {type="" , name="Fan"},
		[0x40] = {type="neutral" , name="Springboard"},
		[0x41] = {type="neutral" , name="Spring"},
		[0x42] = {type="" , name="SteamSpring"},
		[0x43] = {type="" , name="SlidingSpike"},
		[0x44] = {type="" , name="RoundBumper"},
		[0x45] = {type="" , name="OOZSpring"},
		[0x46] = {type="" , name="OOZBall"},
		[0x47] = {type="" , name="Button"},
		[0x48] = {type="" , name="LauncherBall"},
		[0x49] = {type="" , name="EHZWaterfall"},
		[0x4A] = {type="" , name="Octus"},
		[0x4B] = {type="bad" , name="Buzzer"},
		[0x50] = {type="" , name="Aquis"},
		[0x51] = {type="boss" , name="CNZBoss"},
		[0x52] = {type="boss" , name="HTZBoss"},
		[0x53] = {type="boss" , name="MTZBossOrb"},
		[0x54] = {type="" , name="MTZBoss"},
		[0x55] = {type="" , name="OOZBoss"},
		[0x56] = {type="boss" , name="EHZBoss"},
		[0x57] = {type="" , name="MCZBoss"},
		[0x58] = {type="" , name="BossExplosion"},
		[0x59] = {type="" , name="SSEmerald"},
		[0x5A] = {type="" , name="SSMessage"},
		[0x5B] = {type="" , name="SSRingSpill"},
		[0x5C] = {type="bad" , name="Masher"},
		[0x5D] = {type="boss" , name="CPZBoss"},
		[0x5E] = {type="" , name="SSHUD"},
		[0x5F] = {type="" , name="StartBanner"},
		[0x5F] = {type="" , name="EndingController"},
		[0x60] = {type="" , name="SSRing"},
		[0x61] = {type="" , name="SSBomb"},
		[0x63] = {type="" , name="SSShadow"},
		[0x64] = {type="" , name="MTZTwinStompers"},
		[0x65] = {type="" , name="MTZLongPlatform"},
		[0x66] = {type="" , name="MTZSpringWall"},
		[0x67] = {type="" , name="MTZSpinTube"},
		[0x68] = {type="" , name="SpikyBlock"},
		[0x69] = {type="" , name="Nut"},
		[0x6A] = {type="" , name="MCZRotPforms"},
		[0x6A] = {type="" , name="MTZMovingPforms"},
		[0x6B] = {type="" , name="MTZPlatform"},
		[0x6B] = {type="" , name="CPZSquarePform"},
		[0x6C] = {type="" , name="Conveyor"},
		[0x6D] = {type="bad" , name="FloorSpike"},
		[0x6E] = {type="" , name="LargeRotPform"},
		[0x6F] = {type="" , name="SSResults"},
		[0x70] = {type="" , name="Cog"},
		[0x71] = {type="" , name="MTZLavaBubble"},
		[0x71] = {type="" , name="HPZBridgeStake"},
		[0x71] = {type="" , name="PulsingOrb"},
		[0x72] = {type="" , name="CNZConveyorBelt"},
		[0x73] = {type="" , name="RotatingRings"},
		[0x74] = {type="" , name="InvisibleBlock"},
		[0x75] = {type="" , name="MCZBrick"},
		[0x76] = {type="bad" , name="SlidingSpikes"},
		[0x77] = {type="" , name="MCZBridge"},
		[0x78] = {type="" , name="CPZStaircase"},
		[0x79] = {type="" , name="Starpost"},
		[0x7A] = {type="" , name="SidewaysPform"},
		[0x7B] = {type="" , name="PipeExitSpring"},
		[0x7C] = {type="" , name="CPZPylon"},
		[0x7E] = {type="" , name="SuperSonicStars"},
		[0x7F] = {type="" , name="VineSwitch"},
		[0x80] = {type="" , name="MovingVine"},
		[0x81] = {type="" , name="MCZDrawbridge"},
		[0x82] = {type="" , name="SwingingPform"},
		[0x83] = {type="" , name="ARZRotPforms"},
		[0x84] = {type="" , name="ForcedSpin"},
		[0x84] = {type="" , name="PinballMode"},
		[0x85] = {type="" , name="LauncherSpring"},
		[0x86] = {type="" , name="Flipper"},
		[0x87] = {type="" , name="SSNumberOfRings"},
		[0x88] = {type="" , name="SSTailsTails"},
		[0x89] = {type="" , name="ARZBoss"},
		[0x8B] = {type="" , name="WFZPalSwitcher"},
		[0x8C] = {type="" , name="Whisp"},
		[0x8D] = {type="" , name="GrounderInWall"},
		[0x8E] = {type="" , name="GrounderInWall2"},
		[0x8F] = {type="" , name="GrounderWall"},
		[0x90] = {type="" , name="GrounderRocks"},
		[0x91] = {type="" , name="ChopChop"},
		[0x92] = {type="" , name="Spiker"},
		[0x93] = {type="" , name="SpikerDrill"},
		[0x94] = {type="" , name="Rexon"},
		[0x95] = {type="" , name="Sol"},
		[0x96] = {type="" , name="Rexon2"},
		[0x97] = {type="" , name="RexonHead"},
		[0x98] = {type="" , name="Projectile"},
		[0x99] = {type="" , name="Nebula"},
		[0x9A] = {type="" , name="Turtloid"},
		[0x9B] = {type="" , name="TurtloidRider"},
		[0x9C] = {type="" , name="BalkiryJet"},
		[0x9D] = {type="bad" , name="Coconuts"},
		[0x9E] = {type="" , name="Crawlton"},
		[0x9F] = {type="" , name="Shellcracker"},
		[0xA0] = {type="" , name="ShellcrackerClaw"},
		[0xA1] = {type="" , name="Slicer"},
		[0xA2] = {type="" , name="SlicerPincers"},
		[0xA3] = {type="" , name="Flasher"},
		[0xA4] = {type="" , name="Asteron"},
		[0xA5] = {type="" , name="Spiny"},
		[0xA6] = {type="" , name="SpinyOnWall"},
		[0xA7] = {type="" , name="Grabber"},
		[0xA8] = {type="" , name="GrabberLegs"},
		[0xA9] = {type="" , name="GrabberBox"},
		[0xAA] = {type="" , name="GrabberString"},
		[0xAC] = {type="" , name="Balkiry"},
		[0xAD] = {type="" , name="CluckerBase"},
		[0xAE] = {type="" , name="Clucker"},
		[0xAF] = {type="" , name="MechaSonic"},
		[0xB0] = {type="" , name="SonicOnSegaScr"},
		[0xB1] = {type="" , name="SegaHideTM"},
		[0xB2] = {type="" , name="Tornado"},
		[0xB3] = {type="" , name="Cloud"},
		[0xB4] = {type="" , name="VPropeller"},
		[0xB5] = {type="" , name="HPropeller"},
		[0xB6] = {type="" , name="TiltingPlatform"},
		[0xB7] = {type="" , name="VerticalLaser"},
		[0xB8] = {type="" , name="WallTurret"},
		[0xB9] = {type="" , name="Laser"},
		[0xBA] = {type="" , name="WFZWheel"},
		[0xBC] = {type="" , name="WFZShipFire"},
		[0xBD] = {type="" , name="SmallMetalPform"},
		[0xBE] = {type="" , name="LateralCannon"},
		[0xBF] = {type="" , name="WFZStick"},
		[0xC0] = {type="" , name="SpeedLauncher"},
		[0xC1] = {type="" , name="BreakablePlating"},
		[0xC2] = {type="" , name="Rivet"},
		[0xC3] = {type="" , name="TornadoSmoke"},
		[0xC4] = {type="" , name="TornadoSmoke2"},
		[0xC5] = {type="" , name="WFZBoss"},
		[0xC6] = {type="" , name="Eggman"},
		[0xC7] = {type="" , name="Eggrobo"},
		[0xC8] = {type="" , name="Crawl"},
		[0xC9] = {type="" , name="TtlScrPalChanger"},
		[0xCA] = {type="" , name="CutScene"},
		[0xCB] = {type="" , name="EndingSeqClouds"},
		[0xCC] = {type="" , name="EndingSeqTrigger"},
		[0xCD] = {type="" , name="EndingSeqBird"},
		[0xCE] = {type="" , name="EndingSeqSonic"},
		[0xCE] = {type="" , name="EndingSeqTails"},
		[0xCF] = {type="" , name="TornadoHelixes"},
		[0xD2] = {type="" , name="CNZRectBlocks"},
		[0xD3] = {type="" , name="BombPrize"},
		[0xD4] = {type="" , name="CNZBigBlock"},
		[0xD5] = {type="" , name="Elevator"},
		[0xD6] = {type="" , name="PointPokey"},
		[0xD7] = {type="" , name="Bumper"},
		[0xD8] = {type="" , name="BonusBlock"},
		[0xD9] = {type="" , name="Grab"},
		[0xDA] = {type="" , name="ContinueText"},
		[0xDA] = {type="" , name="ContinueIcons"},
		[0xDB] = {type="" , name="ContinueChars"},
		[0xDC] = {type="" , name="RingPrize"},
			
	},
};

------------------------------------------------------------
--SONIC GAME--
------------------------------------------------------------

--Get Sonics X and Y Positions from RAM plus screen positions using layer
function _SONIC.getPositions()

	sonicX = mainmemory.read_u16_be(0xB008) 
	sonicY = mainmemory.read_u16_be(0xB00C)

	layer1x = mainmemory.read_u16_be(0xEE00)
	layer1y = mainmemory.read_u16_be(0xEE04)
	
	screenX = sonicX-layer1x
	screenY = sonicY-layer1y

end

--Number of rings collected, doesnt go down when hit at end of run
function _SONIC.getRings()

	local ringsNow = mainmemory.read_u16_be(0xFE20)

	if ringsNow == nil then
		ringsNow = 0
	end

	if ringsNow > rings then
		rings = ringsNow
	end
	return rings

end

--Get the current level
function _SONIC.getLevel() 
end

--Get the current act
function _SONIC.getact()
end

--True / False if sonic is within 100 pixels of levels end (ie post)
function _SONIC.beatLevel()

	maxLevelX = mainmemory.read_u16_be(0xEECA)
	
	if(maxLevelX - sonicX) < 100 then
		beatLevelCounter = beatLevelCounter + 1
		return true
	else
		return false
	end

end

--Number of hits a boss has taken if one is on screen
function _SONIC.bossHits()

	for i = 1,#sprites do
		if sprites[i]["type"] == "boss" then
			bossHits = sprites[i]["custom"]
		end
	end

end

--True / False if sonic is fighting a boss
function _SONIC.isBoss()

	boss = mainmemory.read_u16_be(0xF7AA)

	if(boss == 0 or boss == nil) then
		return false
	else
		return true
	end
	 
end

--Are controls currently locked from the player
function _SONIC.controlsLocked()

	if mainmemory.read_u16_be(0xF7CC) == 0 then 
		return false
	else
		return true
	end

end

--Get Current score
function _SONIC.getScore()
	local scoreLeft = mainmemory.read_u16_be(0xFE28)
	local scoreRight = mainmemory.read_u16_be(0xFE28)
	local score = ( scoreLeft * 10 ) + scoreRight

	return score
end

--increments when sonic jumps
function _SONIC.jumpCheck()

	local sonicStatus = mainmemory.read_u16_be(0xD022)
	if sonicStatus > 1500 then
		jumpCounter = jumpCounter + 1
	end
end

--Get Current Lives, fixed so only returns lives up not down (as shouldnt happen)
function _SONIC.updateLives()
	local nowLives = mainmemory.read_u16_be(0xFE12) / 256

	if Lives == nil then
		Lives = nowLives
	elseif nowLives > Lives then 	
		Lives = nowLives
	elseif nowLives < Lives then
		Lives = 0
	end
	
end

function _SONIC.getLives()
	return Lives
end

--Checks if sonic has been hit, seems to work better than using the timer by check for LostRings sprites
function _SONIC.hitCheck()	

	for i = 1,#sprites do
		if sprites[i]["name"] == "LostRings" then
			stopRun = true
			return true
		end
	end

	stopRun = false

end

function _SONIC.powerUpCheck()

	local nowPowerUp = mainmemory.read_u16_be(0xB02b)

	if nowPowerUp == 0 or nowPowerUp == powerUp then
		powerUp = nowPowerUp
	else
		powerUp = nowPowerUp
		powerUpCounter = powerUpCounter + 1
	end

end

-- Tile Map
function _SONIC.getTile(dx, dy)
	x = math.floor((sonicX+dx+8)/16)
	y = math.floor((sonicY+dy)/16)

	return memory.readbyte(0x8000 + math.floor(x/0x10)*0x1B0 + y*0x10 + x%0x10)
end

--Gets all current sprites that to be used as inputs
function _SONIC.getSprites()

	local sprites = {}
	local objectTable
	local objectfields

	objectTable = 0xB000
	objectfields = _SPRITES.objectfields
	
	for i = 1, 160 do
		objectBase = objectTable + (0x40 * (i - 1));

		local slot = {
			--Type Code
			type = mainmemory.readbyte(objectBase + 0x00),
			--X / Y
			x = mainmemory.read_u16_be(objectBase + 0x08),
			y = mainmemory.read_u16_be(objectBase + 0x0C),

			--Custom, holds boss hit count		
			custom = mainmemory.read_u16_be(objectBase + 0x021),		

			--Height and Width
			h = mainmemory.readbyte(objectBase + 0x16) * 2,
			w = mainmemory.readbyte(objectBase + 0x19) * 2,

		};

		if slot.h > 100 or slot.h < 1 then
			slot.h = 20
		end

		if objectfields.types[slot.type] ~= nil then
			
			slot.name = objectfields.types[slot.type].name;
			slot.type = objectfields.types[slot.type].type;
			slot.screenX = slot.x - layer1x
			slot.screenY = slot.y - layer1y

			--if slot.screenX - screenX < 200 and slot.screenX - screenX > -100 then
				--if slot.screenY - screenY < 200 and slot.screenY - screenY > -100 then
					if slot.type == "bad"  then
						slot.value = _CONFIG.bad 
						sprites[#sprites+1] = slot
					elseif slot.type == "boss" then
						slot.value = _CONFIG.bad 
						sprites[#sprites+1] = slot		
					elseif slot.type == "neutral" then
						slot.value = _CONFIG.neutral 
						sprites[#sprites+1] = slot
					elseif slot.type == "good" then
						slot.value = _CONFIG.good 
						sprites[#sprites+1] = slot
					end
				--end
			--end				
		end	
	end

	return sprites
end

--Not Required for SONIC
function _SONIC.getExtendedSprites()
	local extended = {}

	return extended
end

--Draw a box around sonic
function _SONIC.positionBox()

	--gui.drawBox(screenX-17,screenY+25,screenX+17,screenY-25,0x00000000,0x8055FF00)
	--gui.drawText(100, 35, "Sonic" .. '(' .. sonicX .. ',' .. sonicY .. ')', 0xFFFFFFFFF, 0xFF000000, 11)
	
end

--Draw coloured box around all sprites being collected from get sprites
function _SONIC.spriteBoxes()
	
	for i = 1,#sprites do
		if sprites[i]["value"] == _CONFIG.bad then
			colorBox = 0x80FF0000
		elseif sprites[i]["value"] == _CONFIG.neutral then
			colorBox = 0x80696C6A
		elseif sprites[i]["value"] == _CONFIG.good then
			colorBox = 0x8000FF2B
		else
			colorBox = 0x8000FFFF
		end

		local w = sprites[i]["w"] / 2
		local h = sprites[i]["h"] / 2		

		gui.drawBox(sprites[i]["screenX"]-w,sprites[i]["screenY"]+h,sprites[i]["screenX"]+w,sprites[i]["screenY"]-h,0x00000000,colorBox)
		gui.drawText(100, 35 + (i * 15), sprites[i]["name"], 0xFFFFFFFFF, 0xFF000000, 11)
	end
end

--Draw Coloured box around a single sprite
function _SONIC.spriteInputToConsole(sprite,dist)


	local w = sprite["w"] / 2
	local h = sprite["h"] / 2
	console.clear()
	console.log(sprite["name"] .. "[" .. dist .. "]")
	

	--gui.drawBox(sprite["screenX"]-w,sprite["screenY"]+h,sprite["screenX"]+w,sprite["screenY"]-h,0x00000000,colorBox)
	--gui.pixelText(sprite["screenX"], sprite["screenY"], sprite["name"], 0xFFFFFFFFF, 0xFF000000)

end

--Get the inputs to be used
function _SONIC.getInputs()

	_SONIC.getPositions()

	sprites = _SONIC.getSprites()
	extended = _SONIC.getExtendedSprites()

	local inputs = {}
	local inputDeltaDistance = {}
	
	local layer1x = 0 --memory.read_s16_le(0x1A);
	local layer1y = 0 --memory.read_s16_le(0x1C);

	local h = 0
	
	for dy=-_CONFIG.BoxRadius*16,_CONFIG.BoxRadius*16,16 do
		for dx=-_CONFIG.BoxRadius*16,_CONFIG.BoxRadius*16,16 do
			inputs[#inputs+1] = 0
			inputDeltaDistance[#inputDeltaDistance+1] = 1
			
			tile = _SONIC.getTile(dx, dy)
			if tile == 1 and sonicY+dy < 0x1B0 then
				inputs[#inputs] = 1
			end
			
			for i = 1,#sprites do
				distx = math.abs(sprites[i]["x"] - (sonicX+dx))
				disty = math.abs(sprites[i]["y"] - (sonicY+dy))
				if distx <= 8 and disty <= 8 then

					inputs[#inputs] = sprites[i]["value"]
					
					local dist = math.sqrt((distx * distx) + (disty * disty))

					--_SONIC.spriteInputToConsole(sprites[i],distx)

					if dist > 8 then
						inputDeltaDistance[#inputDeltaDistance] = _MATH.squashDistance(dist)
						gui.drawLine(screenX, screenY, sprites[i]["x"] - layer1x, sprites[i]["y"] - layer1y, 0x50000000)
					end
				end
			end

			for i = 1,#extended do
				distx = math.abs(extended[i]["x"] - (sonicX+dx))
				disty = math.abs(extended[i]["y"] - (sonicY+dy))
				if distx < 8 and disty < 8 then
					
					inputs[#inputs] = extended[i]["value"]
					local dist = math.sqrt((distx * distx) + (disty * disty))
					if dist > 8 then
						inputDeltaDistance[#inputDeltaDistance] = _MATH.squashDistance(dist)
						gui.drawLine(screenX, screenY, extended[i]["x"] - layer1x, extended[i]["y"] - layer1y, 0x50000000)
					end
				end
			end
		end
	end

	return inputs, inputDeltaDistance
end

function _SONIC.clearJoypad()
	controller = {}
	for b = 1,#_CONFIG.ButtonNames do
		controller[_CONFIG.ButtonNames[b]] = false
	end
	joypad.set(controller)
end

--Custom function for pressing joypad buttons.
function _SONIC.setJoypad(controller, gameFrame)

	if _CONFIG.autoFireButton == true then
		for k, v in pairs(controller) do
			if frameController[k] == true then
				if k == _CONFIG.ButtonA then
					if gameFrame%5 == 0 then
						controller[k] = false
					end
				end
			end
		end	
	end

	joypad.set(controller)
	frameController = controller

end

------------------------------------------------------------
--MATH FUNCTIONS
------------------------------------------------------------

function _MATH.sigmoid(x)
	return 2/(1+math.exp(-4.9*x))-1
end

function _MATH.squashDistance(x)
	local window = 0.20
	local delta = 0.25
	
	local dist = (x-8)
	local newDist = 1
	
	while dist > 0 do
		newDist = newDist - (window*delta)
		dist = dist - 1
	end
	
	if newDist < 0.80 then
		newDist = 0.80
	end
	
	return newDist
end

------------------------------------------------------------
--MAIN / RUN--
------------------------------------------------------------

Inputs = _CONFIG.InputSize+1
Outputs = #_CONFIG.ButtonNames

function newInnovation()
	pool.innovation = pool.innovation + 1
	return pool.innovation
end

function newPool()
	local pool = {}
	pool.species = {}
	pool.generation = 0
	pool.innovation = Outputs
	pool.currentSpecies = 1
	pool.currentGenome = 1
	pool.currentFrame = 0
	pool.maxFitness = 0
	
	return pool
end

function newSpecies()
	local species = {}
	species.topFitness = 0
	species.staleness = 0
	species.genomes = {}
	species.averageFitness = 0
	
	return species
end

function newGenome()
	local genome = {}
	genome.genes = {}
	genome.fitness = 0
	genome.adjustedFitness = 0
	genome.network = {}
	genome.maxneuron = 0
	genome.globalRank = 0
	genome.mutationRates = {}
	genome.mutationRates["connections"] = _CONFIG.NeatConfig.MutateConnectionsChance
	genome.mutationRates["link"] = _CONFIG.NeatConfig.LinkMutationChance
	genome.mutationRates["bias"] = _CONFIG.NeatConfig.BiasMutationChance
	genome.mutationRates["node"] = _CONFIG.NeatConfig.NodeMutationChance
	genome.mutationRates["enable"] = _CONFIG.NeatConfig.EnableMutationChance
	genome.mutationRates["disable"] = _CONFIG.NeatConfig.DisableMutationChance
	genome.mutationRates["step"] = _CONFIG.NeatConfig.StepSize
	
	return genome
end

function copyGenome(genome)
	local genome2 = newGenome()
	for g=1,#genome.genes do
		table.insert(genome2.genes, copyGene(genome.genes[g]))
	end
	genome2.maxneuron = genome.maxneuron
	genome2.mutationRates["connections"] = genome.mutationRates["connections"]
	genome2.mutationRates["link"] = genome.mutationRates["link"]
	genome2.mutationRates["bias"] = genome.mutationRates["bias"]
	genome2.mutationRates["node"] = genome.mutationRates["node"]
	genome2.mutationRates["enable"] = genome.mutationRates["enable"]
	genome2.mutationRates["disable"] = genome.mutationRates["disable"]
	
	return genome2
end

function basicGenome()
	local genome = newGenome()
	local innovation = 1

	genome.maxneuron = Inputs
	mutate(genome)
	
	return genome
end

function newGene()
	local gene = {}
	gene.into = 0
	gene.out = 0
	gene.weight = 0.0
	gene.enabled = true
	gene.innovation = 0
	
	return gene
end

function copyGene(gene)
	local gene2 = newGene()
	gene2.into = gene.into
	gene2.out = gene.out
	gene2.weight = gene.weight
	gene2.enabled = gene.enabled
	gene2.innovation = gene.innovation
	
	return gene2
end

function newNeuron()
	local neuron = {}
	neuron.incoming = {}
	neuron.value = 0.0
	--neuron.dw = 1
	return neuron
end

function generateNetwork(genome)
	local network = {}
	network.neurons = {}
	
	for i=1,Inputs do
		network.neurons[i] = newNeuron()
	end
	
	for o=1,Outputs do
		network.neurons[_CONFIG.NeatConfig.MaxNodes+o] = newNeuron()
	end
	
	table.sort(genome.genes, function (a,b)
		return (a.out < b.out)
	end)
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if gene.enabled then
			if network.neurons[gene.out] == nil then
				network.neurons[gene.out] = newNeuron()
			end
			local neuron = network.neurons[gene.out]
			table.insert(neuron.incoming, gene)
			if network.neurons[gene.into] == nil then
				network.neurons[gene.into] = newNeuron()
			end
		end
	end
	
	genome.network = network
end

function evaluateNetwork(network, inputs, inputDeltas)
	table.insert(inputs, 1)
	table.insert(inputDeltas,99)
	if #inputs ~= Inputs then
		console.writeline("Incorrect number of neural network inputs.")
		return {}
	end
	

	for i=1,Inputs do
		--network.neurons[i].value = inputs[i] * inputDeltas[i]
		network.neurons[i].value = inputs[i]
	end
	
	for _,neuron in pairs(network.neurons) do
		local sum = 0
		for j = 1,#neuron.incoming do
			local incoming = neuron.incoming[j]
			local other = network.neurons[incoming.into]
			sum = sum + incoming.weight * other.value
		end
		
		if #neuron.incoming > 0 then
			neuron.value = _MATH.sigmoid(sum)
		end
	end
	
	local outputs = {}
	for o=1,Outputs do
		local button = _CONFIG.ButtonNames[o]
		if network.neurons[_CONFIG.NeatConfig.MaxNodes+o].value > 0 then
			outputs[button] = true
		else
			outputs[button] = false
		end
	end
	
	return outputs
end

function crossover(g1, g2)
	-- Make sure g1 is the higher fitness genome
	if g2.fitness > g1.fitness then
		tempg = g1
		g1 = g2
		g2 = tempg
	end

	local child = newGenome()
	
	local innovations2 = {}
	for i=1,#g2.genes do
		local gene = g2.genes[i]
		innovations2[gene.innovation] = gene
	end
	
	for i=1,#g1.genes do
		local gene1 = g1.genes[i]
		local gene2 = innovations2[gene1.innovation]
		if gene2 ~= nil and math.random(2) == 1 and gene2.enabled then
			table.insert(child.genes, copyGene(gene2))
		else
			table.insert(child.genes, copyGene(gene1))
		end
	end
	
	child.maxneuron = math.max(g1.maxneuron,g2.maxneuron)
	
	for mutation,rate in pairs(g1.mutationRates) do
		child.mutationRates[mutation] = rate
	end
	
	return child
end

function randomNeuron(genes, nonInput)
	local neurons = {}
	if not nonInput then
		for i=1,Inputs do
			neurons[i] = true
		end
	end
	for o=1,Outputs do
		neurons[_CONFIG.NeatConfig.MaxNodes+o] = true
	end
	for i=1,#genes do
		if (not nonInput) or genes[i].into > Inputs then
			neurons[genes[i].into] = true
		end
		if (not nonInput) or genes[i].out > Inputs then
			neurons[genes[i].out] = true
		end
	end

	local count = 0
	for _,_ in pairs(neurons) do
		count = count + 1
	end
	local n = math.random(1, count)
	
	for k,v in pairs(neurons) do
		n = n-1
		if n == 0 then
			return k
		end
	end
	
	return 0
end

function containsLink(genes, link)
	for i=1,#genes do
		local gene = genes[i]
		if gene.into == link.into and gene.out == link.out then
			return true
		end
	end
end

function pointMutate(genome)
	local step = genome.mutationRates["step"]
	
	for i=1,#genome.genes do
		local gene = genome.genes[i]
		if math.random() < _CONFIG.NeatConfig.PerturbChance then
			gene.weight = gene.weight + math.random() * step*2 - step
		else
			gene.weight = math.random()*4-2
		end
	end
end

function linkMutate(genome, forceBias)
	local neuron1 = randomNeuron(genome.genes, false)
	local neuron2 = randomNeuron(genome.genes, true)
	 
	local newLink = newGene()
	if neuron1 <= Inputs and neuron2 <= Inputs then
		--Both input nodes
		return
	end
	if neuron2 <= Inputs then
		-- Swap output and input
		local temp = neuron1
		neuron1 = neuron2
		neuron2 = temp
	end

	newLink.into = neuron1
	newLink.out = neuron2
	if forceBias then
		newLink.into = Inputs
	end
	
	if containsLink(genome.genes, newLink) then
		return
	end
	newLink.innovation = newInnovation()
	newLink.weight = math.random()*4-2
	
	table.insert(genome.genes, newLink)
end

function nodeMutate(genome)
	if #genome.genes == 0 then
		return
	end

	genome.maxneuron = genome.maxneuron + 1

	local gene = genome.genes[math.random(1,#genome.genes)]
	if not gene.enabled then
		return
	end
	gene.enabled = false
	
	local gene1 = copyGene(gene)
	gene1.out = genome.maxneuron
	gene1.weight = 1.0
	gene1.innovation = newInnovation()
	gene1.enabled = true
	table.insert(genome.genes, gene1)
	
	local gene2 = copyGene(gene)
	gene2.into = genome.maxneuron
	gene2.innovation = newInnovation()
	gene2.enabled = true
	table.insert(genome.genes, gene2)
end

function enableDisableMutate(genome, enable)
	local candidates = {}
	for _,gene in pairs(genome.genes) do
		if gene.enabled == not enable then
			table.insert(candidates, gene)
		end
	end
	
	if #candidates == 0 then
		return
	end
	
	local gene = candidates[math.random(1,#candidates)]
	gene.enabled = not gene.enabled
end

function mutate(genome)
	for mutation,rate in pairs(genome.mutationRates) do
		if math.random(1,2) == 1 then
			genome.mutationRates[mutation] = 0.95*rate
		else
			genome.mutationRates[mutation] = 1.05263*rate
		end
	end

	if math.random() < genome.mutationRates["connections"] then
		pointMutate(genome)
	end
	
	local p = genome.mutationRates["link"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, false)
		end
		p = p - 1
	end

	p = genome.mutationRates["bias"]
	while p > 0 do
		if math.random() < p then
			linkMutate(genome, true)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["node"]
	while p > 0 do
		if math.random() < p then
			nodeMutate(genome)
		end
		p = p - 1
	end
	
	p = genome.mutationRates["enable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, true)
		end
		p = p - 1
	end

	p = genome.mutationRates["disable"]
	while p > 0 do
		if math.random() < p then
			enableDisableMutate(genome, false)
		end
		p = p - 1
	end
end

function disjoint(genes1, genes2)
	local i1 = {}
	for i = 1,#genes1 do
		local gene = genes1[i]
		i1[gene.innovation] = true
	end

	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = true
	end
	
	local disjointGenes = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if not i2[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	for i = 1,#genes2 do
		local gene = genes2[i]
		if not i1[gene.innovation] then
			disjointGenes = disjointGenes+1
		end
	end
	
	local n = math.max(#genes1, #genes2)
	
	return disjointGenes / n
end

function weights(genes1, genes2)
	local i2 = {}
	for i = 1,#genes2 do
		local gene = genes2[i]
		i2[gene.innovation] = gene
	end

	local sum = 0
	local coincident = 0
	for i = 1,#genes1 do
		local gene = genes1[i]
		if i2[gene.innovation] ~= nil then
			local gene2 = i2[gene.innovation]
			sum = sum + math.abs(gene.weight - gene2.weight)
			coincident = coincident + 1
		end
	end
	
	return sum / coincident
end
	
function sameSpecies(genome1, genome2)
	local dd = _CONFIG.NeatConfig.DeltaDisjoint*disjoint(genome1.genes, genome2.genes)
	local dw = _CONFIG.NeatConfig.DeltaWeights*weights(genome1.genes, genome2.genes) 
	return dd + dw < _CONFIG.NeatConfig.DeltaThreshold
end

function rankGlobally()
	local global = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		for g = 1,#species.genomes do
			table.insert(global, species.genomes[g])
		end
	end
	table.sort(global, function (a,b)
		return (a.fitness < b.fitness)
	end)
	
	for g=1,#global do
		global[g].globalRank = g
	end
end

function calculateAverageFitness(species)
	local total = 0
	
	for g=1,#species.genomes do
		local genome = species.genomes[g]
		total = total + genome.globalRank
	end
	
	species.averageFitness = total / #species.genomes
end

function totalAverageFitness()
	local total = 0
	for s = 1,#pool.species do
		local species = pool.species[s]
		total = total + species.averageFitness
	end

	return total
end

function cullSpecies(cutToOne)
	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		local remaining = math.ceil(#species.genomes/2)
		if cutToOne then
			remaining = 1
		end
		while #species.genomes > remaining do
			table.remove(species.genomes)
		end
	end
end

function breedChild(species)
	local child = {}
	if math.random() < _CONFIG.NeatConfig.CrossoverChance then
		g1 = species.genomes[math.random(1, #species.genomes)]
		g2 = species.genomes[math.random(1, #species.genomes)]
		child = crossover(g1, g2)
	else
		g = species.genomes[math.random(1, #species.genomes)]
		child = copyGenome(g)
	end
	
	mutate(child)
	
	return child
end

function removeStaleSpecies()
	local survived = {}

	for s = 1,#pool.species do
		local species = pool.species[s]
		
		table.sort(species.genomes, function (a,b)
			return (a.fitness > b.fitness)
		end)
		
		if species.genomes[1].fitness > species.topFitness then
			species.topFitness = species.genomes[1].fitness
			species.staleness = 0
		else
			species.staleness = species.staleness + 1
		end
		if species.staleness < _CONFIG.NeatConfig.StaleSpecies or species.topFitness >= pool.maxFitness then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end

function removeWeakSpecies()
	local survived = {}

	local sum = totalAverageFitness()
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * _CONFIG.NeatConfig.Population)
		if breed >= 1 then
			table.insert(survived, species)
		end
	end

	pool.species = survived
end


function addToSpecies(child)
	local foundSpecies = false
	for s=1,#pool.species do
		local species = pool.species[s]
		if not foundSpecies and sameSpecies(child, species.genomes[1]) then
			table.insert(species.genomes, child)
			foundSpecies = true
		end
	end
	
	if not foundSpecies then
		local childSpecies = newSpecies()
		table.insert(childSpecies.genomes, child)
		table.insert(pool.species, childSpecies)
	end
end

function newGeneration()
	cullSpecies(false) -- Cull the bottom half of each species
	rankGlobally()
	removeStaleSpecies()
	rankGlobally()
	for s = 1,#pool.species do
		local species = pool.species[s]
		calculateAverageFitness(species)
	end
	removeWeakSpecies()
	local sum = totalAverageFitness()
	local children = {}
	for s = 1,#pool.species do
		local species = pool.species[s]
		breed = math.floor(species.averageFitness / sum * _CONFIG.NeatConfig.Population) - 1
		for i=1,breed do
			table.insert(children, breedChild(species))
		end
	end
	cullSpecies(true) -- Cull all but the top member of each species
	while #children + #pool.species < _CONFIG.NeatConfig.Population do
		local species = pool.species[math.random(1, #pool.species)]
		table.insert(children, breedChild(species))
	end
	for c=1,#children do
		local child = children[c]
		addToSpecies(child)
	end
	
	pool.generation = pool.generation + 1
	
	--writeFile("backup." .. pool.generation .. "." .. forms.gettext(saveLoadFile))
	writeFile(forms.gettext(saveLoadFile) .. ".gen" .. pool.generation .. ".pool")
end
	
function initializePool()
	pool = newPool()

	for i=1,_CONFIG.NeatConfig.Population do
		basic = basicGenome()
		addToSpecies(basic)
	end

	initializeRun()
end

function initializeRun()
	savestate.load(_CONFIG.NeatConfig.Filename);
	rightmost = 0 --right most current level
	rightCarried = 0 -- right most all levels
	rings = 0
	bossHits = 0 -- hits on boss
	jumpCounter = 0 -- frames spent jumping
	sprites = {}
	stopRun = false -- if true adds a penalty and stops run
	pool.currentFrame = 0
	timeout = _CONFIG.NeatConfig.TimeoutConstant
	_SONIC.clearJoypad()
	startRings = 0
	startScore = 0
	frameController = {}
	checkSonicCollision = true
	powerUp = 0 --Current held powerup
	powerUpCounter = 0 --Count of powerups collected
	beatLevelCounter = 0 --used to calculate bonus, this increments when a level is completed by 1 per frame
	spinDashCounter = 0 -- Increments everytime spindash is used

	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	generateNetwork(genome)
	evaluateCurrent()
end

function evaluateCurrent()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	local inputDeltas = {}
	inputs, inputDeltas = _SONIC.getInputs()
	
	controller = evaluateNetwork(genome.network, inputs, inputDeltas)
	
	if controller["P1 Left"] and controller["P1 Right"] then
		controller["P1 Left"] = false
		controller["P1 Right"] = false
	end
	if controller["P1 Up"] and controller["P1 Down"] then
		controller["P1 Up"] = false
		controller["P1 Down"] = false
	end
	

	joypad.set(controller)
end

if pool == nil then
	initializePool()
end


function nextGenome()
	pool.currentGenome = pool.currentGenome + 1
	if pool.currentGenome > #pool.species[pool.currentSpecies].genomes then
		pool.currentGenome = 1
		pool.currentSpecies = pool.currentSpecies+1
		if pool.currentSpecies > #pool.species then
			newGeneration()
			pool.currentSpecies = 1
		end
	end
end

function fitnessAlreadyMeasured()
	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	return genome.fitness ~= 0
end

form = forms.newform(500, 500, "Sonic-Neat")
netPicture = forms.pictureBox(form, 5, 250,470, 200)


--int forms.pictureBox(int formhandle, [int? x = null], [int? y = null], [int? width = null], [int? height = null]) 

function displayGenome(genome)
	forms.clear(netPicture,0x80808080)
	local network = genome.network
	local cells = {}
	local i = 1
	local cell = {}
	for dy=-_CONFIG.BoxRadius,_CONFIG.BoxRadius do
		for dx=-_CONFIG.BoxRadius,_CONFIG.BoxRadius do
			cell = {}
			cell.x = 50+5*dx
			cell.y = 70+5*dy
			cell.value = network.neurons[i].value
			cells[i] = cell
			i = i + 1
		end
	end
	local biasCell = {}
	biasCell.x = 80
	biasCell.y = 110
	biasCell.value = network.neurons[Inputs].value
	cells[Inputs] = biasCell
	
	for o = 1,Outputs do
		cell = {}
		cell.x = 220
		cell.y = 30 + 8 * o
		cell.value = network.neurons[_CONFIG.NeatConfig.MaxNodes + o].value
		cells[_CONFIG.NeatConfig.MaxNodes+o] = cell
		local color
		if cell.value > 0 then
			color = 0xFF0000FF
		else
			color = 0xFF000000
		end
		--gui.drawText(223, 24+8*o, _CONFIG.ButtonNames[o], color, 9)
		forms.drawText(netPicture,223, 24+8*o, _CONFIG.ButtonNames[o], color, 9)
	end
	
	for n,neuron in pairs(network.neurons) do
		cell = {}
		if n > Inputs and n <= _CONFIG.NeatConfig.MaxNodes then
			cell.x = 140
			cell.y = 40
			cell.value = neuron.value
			cells[n] = cell
		end
	end
	
	for n=1,4 do
		for _,gene in pairs(genome.genes) do
			if gene.enabled then
				local c1 = cells[gene.into]
				local c2 = cells[gene.out]
				if gene.into > Inputs and gene.into <= _CONFIG.NeatConfig.MaxNodes then
					c1.x = 0.75*c1.x + 0.25*c2.x
					if c1.x >= c2.x then
						c1.x = c1.x - 40
					end
					if c1.x < 90 then
						c1.x = 90
					end
					
					if c1.x > 220 then
						c1.x = 220
					end
					c1.y = 0.75*c1.y + 0.25*c2.y
					
				end
				if gene.out > Inputs and gene.out <= _CONFIG.NeatConfig.MaxNodes then
					c2.x = 0.25*c1.x + 0.75*c2.x
					if c1.x >= c2.x then
						c2.x = c2.x + 40
					end
					if c2.x < 90 then
						c2.x = 90
					end
					if c2.x > 220 then
						c2.x = 220
					end
					c2.y = 0.25*c1.y + 0.75*c2.y
				end
			end
		end
	end
	
	--gui.drawBox(50-_CONFIG.BoxRadius*5-3,70-_CONFIG.BoxRadius*5-3,50+_CONFIG.BoxRadius*5+2,70+_CONFIG.BoxRadius*5+2,0xFF000000, 0x80808080)
	forms.drawBox(netPicture, 50-_CONFIG.BoxRadius*5-3,70-_CONFIG.BoxRadius*5-3,50+_CONFIG.BoxRadius*5+2,70+_CONFIG.BoxRadius*5+2,0xFF000000, 0x80808080)
	--oid forms.drawBox(int componenthandle, int x, int y, int x2, int y2, [color? line = null], [color? background = null]) 
	for n,cell in pairs(cells) do
		if n > Inputs or cell.value ~= 0 then
			local color = math.floor((cell.value+1)/2*256)
			if color > 255 then color = 255 end
			if color < 0 then color = 0 end
			local opacity = 0xFF000000
			if cell.value == 0 then
				opacity = 0x50000000
			end
			color = opacity + color*0x10000 + color*0x100 + color
			forms.drawBox(netPicture,cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
			--gui.drawBox(cell.x-2,cell.y-2,cell.x+2,cell.y+2,opacity,color)
		end
	end
	for _,gene in pairs(genome.genes) do
		if gene.enabled then
			local c1 = cells[gene.into]
			local c2 = cells[gene.out]
			local opacity = 0xA0000000
			if c1.value == 0 then
				opacity = 0x20000000
			end
			
			local color = 0x80-math.floor(math.abs(_MATH.sigmoid(gene.weight))*0x80)
			if gene.weight > 0 then 
				color = opacity + 0x8000 + 0x10000*color
			else
				color = opacity + 0x800000 + 0x100*color
			end
			--gui.drawLine(c1.x+1, c1.y, c2.x-3, c2.y, color)
			forms.drawLine(netPicture,c1.x+1, c1.y, c2.x-3, c2.y, color)
		end
	end
	
	--gui.drawBox(49,71,51,78,0x00000000,0x80FF0000)
	forms.drawBox(netPicture, 49,71,51,78,0x00000000,0x80FF0000)
	--if forms.ischecked(showMutationRates) then
		local pos = 100
		for mutation,rate in pairs(genome.mutationRates) do
			--gui.drawText(100, pos, mutation .. ": " .. rate, 0xFF000000, 10)
			forms.drawText(netPicture,100, pos, mutation .. ": " .. rate, 0xFF000000, 10)
			--forms.drawText(pictureBox,400,pos, mutation .. ": " .. rate)
			
			--void forms.drawText(int componenthandle, int x, int y, string message, [color? forecolor = null], [color? backcolor = null], [int? fontsize = null], [string fontfamily = null], [string fontstyle = null], [string horizalign = null], [string vertalign = null]) 

			pos = pos + 8
		end
	--end
	forms.refresh(netPicture)
end

function writeFile(filename)

        local file = io.open(filename, "w")
        file:write(pool.generation .. "\n")
        file:write(pool.maxFitness .. "\n")
        file:write(#pool.species .. "\n")
        for n,species in pairs(pool.species) do
                file:write(species.topFitness .. "\n")
                file:write(species.staleness .. "\n")
                file:write(#species.genomes .. "\n")
                for m,genome in pairs(species.genomes) do
                        file:write(genome.fitness .. "\n")
                        file:write(genome.maxneuron .. "\n")
                        for mutation,rate in pairs(genome.mutationRates) do
                                file:write(mutation .. "\n")
                                file:write(rate .. "\n")
                        end
                        file:write("done\n")
                        
                        file:write(#genome.genes .. "\n")
                        for l,gene in pairs(genome.genes) do
                                file:write(gene.into .. " ")
                                file:write(gene.out .. " ")
                                file:write(gene.weight .. " ")
                                file:write(gene.innovation .. " ")
                                if(gene.enabled) then
                                        file:write("1\n")
                                else
                                        file:write("0\n")
                                end
                        end
                end
        end
        file:close()
end

function savePool()
	local filename = forms.gettext(saveLoadFile)
	print(filename)
	writeFile(filename)
end

function mysplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function loadFile(filename)
		print("Loading pool from " .. filename)
        local file = io.open(filename, "r")
        pool = newPool()
        pool.generation = file:read("*number")
        pool.maxFitness = file:read("*number")
        forms.settext(MaxLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
        local numSpecies = file:read("*number")
        for s=1,numSpecies do
                local species = newSpecies()
                table.insert(pool.species, species)
                species.topFitness = file:read("*number")
                species.staleness = file:read("*number")
                local numGenomes = file:read("*number")
                for g=1,numGenomes do
                        local genome = newGenome()
                        table.insert(species.genomes, genome)
                        genome.fitness = file:read("*number")
                        genome.maxneuron = file:read("*number")
                        local line = file:read("*line")
                        while line ~= "done" do

                                genome.mutationRates[line] = file:read("*number")
                                line = file:read("*line")
                        end
                        local numGenes = file:read("*number")
                        for n=1,numGenes do

                                local gene = newGene()
                                local enabled
								
								local geneStr = file:read("*line")
								local geneArr = mysplit(geneStr)
								gene.into = tonumber(geneArr[1])
								gene.out = tonumber(geneArr[2])
								gene.weight = tonumber(geneArr[3])
								gene.innovation = tonumber(geneArr[4])
								enabled = tonumber(geneArr[5])


                                if enabled == 0 then
                                        gene.enabled = false
                                else
                                        gene.enabled = true
                                end
                                
								table.insert(genome.genes, gene)
                        end
                end
        end
        file:close()
        
        while fitnessAlreadyMeasured() do
                nextGenome()
        end
        initializeRun()
        pool.currentFrame = pool.currentFrame + 1
		print("Pool loaded.")
end

function flipState()
	if _CONFIG.Running == true then
		_CONFIG.Running = false
		forms.settext(startButton, "Start")
	else
		_CONFIG.Running = true
		forms.settext(startButton, "Stop")
	end
end
 
function loadPool()
	filename = forms.openfile("DP1.state.pool",_CONFIG.PoolDir) 
	--local filename = forms.gettext(saveLoadFile)
	forms.settext(saveLoadFile, filename)
	loadFile(filename)
end

function playTop()
	local maxfitness = 0
	local maxs, maxg
	for s,species in pairs(pool.species) do
		for g,genome in pairs(species.genomes) do
			if genome.fitness > maxfitness then
				maxfitness = genome.fitness
				maxs = s
				maxg = g
			end
		end
	end
	
	pool.currentSpecies = maxs
	pool.currentGenome = maxg
	pool.maxFitness = maxfitness
	forms.settext(MaxLabel, "Max Fitness: " .. math.floor(pool.maxFitness))
	initializeRun()
	pool.currentFrame = pool.currentFrame + 1
	return
end

function onExit()
	forms.destroy(form)
end

writeFile(_CONFIG.PoolDir.."temp.pool")

event.onexit(onExit)

GenerationLabel = forms.label(form, "Generation: " .. pool.generation, 5, 5)
SpeciesLabel = forms.label(form, "Species: " .. pool.currentSpecies, 130, 5)
GenomeLabel = forms.label(form, "Genome: " .. pool.currentGenome, 230, 5)
MeasuredLabel = forms.label(form, "Measured: " .. "", 330, 5)
FitnessLabel = forms.label(form, "Fitness: " .. "", 5, 30)
MaxLabel = forms.label(form, "Max: " .. "", 130, 30)
RingsLabel = forms.label(form, "Rings: " .. "", 5, 65, 65, 14)
LevelBeatLabel = forms.label(form, "Level Beat: 0" .. "", 5, 80, 65, 14)
ScoreLabel = forms.label(form, "Score: " .. "", 130, 65, 90, 14)
LivesLabel = forms.label(form, "Lives: " .. "", 130, 80, 90, 14)
PowerUpLabel = forms.label(form, "PowerUps: " .. "", 230, 80, 110, 14)
startButton = forms.button(form, "Start", flipState, 155, 102)
restartButton = forms.button(form, "Restart", initializePool, 155, 102)
saveButton = forms.button(form, "Save", savePool, 5, 102)
loadButton = forms.button(form, "Load", loadPool, 80, 102)
playTopButton = forms.button(form, "Play Top", playTop, 230, 102)
saveLoadFile = forms.textbox(form, _CONFIG.NeatConfig.PoolFilename .. ".pool", 170, 25, nil, 5, 148)	
saveLoadLabel = forms.label(form, "Save/Load:", 5, 129)

while true do
	
	if _CONFIG.Running == true then

	local species = pool.species[pool.currentSpecies]
	local genome = species.genomes[pool.currentGenome]
	
	displayGenome(genome)
	
	if pool.currentFrame%5 == 0 then
		evaluateCurrent()
	end
	
	--joypad.set(controller)

	_SONIC.setJoypad(controller, pool.currentFrame )

	_SONIC.getPositions()
	_SONIC.hitCheck()
	_SONIC.updateLives()
	_SONIC.jumpCheck()

	if _SONIC.controlsLocked() == false then

		--Ensures when a new level is started, the previous rightmost continues to be appended
		if sonicX + rightCarried > rightmost then
			rightmost = sonicX + rightCarried
			timeout = _CONFIG.NeatConfig.TimeoutConstant
		end

	end

	if _SONIC.beatLevel() then
		rightCarried = rightmost
	end

	timeout = timeout - 1
	
	local timeoutBonus = pool.currentFrame / 4

	--While Controls Locked, IE end of level, apply a time bonus so wait is applied
	if _SONIC.controlsLocked() then
		timeoutBonus = timeoutBonus + 1
	end

	--While fighting a boss,add timeout bonus so wait is applied
	if _SONIC.isBoss() then
		timeoutBonus = timeoutBonus + 1
	end

	--Called when either...
		--Run times out
		--StopRun is true
		--Boss Hit 6 times
	
	if timeout + timeoutBonus <= 0 or stopRun == true or bossHits == 6 then

		--Run is Over, work out fitness
		local rings = _SONIC.getRings()
		local score = _SONIC.getScore() 

		--REWARD Rings and Score Bonus
		local scoreBonus = 0
		local ringBonus = 0
		local powerupBonus = 0
		local bossHitBonus = 0
		local jumpBonus = 0
		local beatLevelBonus = 0

		if _CONFIG.enableRingBonus == true then
			ringBonus = (rings * _CONFIG.ringMultiplier) + (score * _CONFIG.scoreMultiplier) 	
		end

		if _CONFIG.enableScoreBonus == true then
			scoreBonus = (score * _CONFIG.scoreMultiplier) 	
		end		

		if _CONFIG.enablePowerUpBonus == true then
			powerupBonus = powerUpCounter * _CONFIG.powerUpMultiplier
		end

		if _CONFIG.enableBossHitBonus == true then
			bossHitBonus = bossHits * _CONFIG.bossHitMultiplier
		end

		if _CONFIG.enableLevelBeatBonus == true then
			beatLevelBonus = beatLevelCounter * _CONFIG.levelBeatMultiplier
		end

		if _CONFIG.enableJumpBonus == true then
			jumpBonus = jumpCounter * _CONFIG.jumpMultiplier
		end

		local fitness = (beatLevelBonus + bossHitBonus + ringBonus + scoreBonus + rightmost) - pool.currentFrame / 2

		if fitness == 0 then
			fitness = -1
		end

		genome.fitness = fitness
		
		if fitness > pool.maxFitness then
			pool.maxFitness = fitness
			writeFile(forms.gettext(saveLoadFile) .. ".gen" .. pool.generation .. ".pool")
		end
		console.clear() 
		console.writeline("--------")
		console.writeline(" Gen " .. pool.generation)
		console.writeline(" Species " .. pool.currentSpecies)
		console.writeline(" Genome " .. pool.currentGenome)
		console.writeline(" RightMost: " .. rightmost)
		console.writeline(" Score Bonus: " .. scoreBonus)
		console.writeline(" Ring Bonus: " .. ringBonus)
		console.writeline(" Boss Bonus: " .. bossHitBonus)
		console.writeline(" Level Bonus: " .. beatLevelBonus)
		console.writeline(" Jump Bonus: " .. jumpBonus)			
		console.writeline(" Powerup Bonus: " .. powerupBonus)									
		console.writeline(" Fitness: " .. fitness)
		console.writeline(" Top Fitness: " .. pool.maxFitness)

		pool.currentSpecies = 1
		pool.currentGenome = 1

		while fitnessAlreadyMeasured() do
			nextGenome()
		end
		initializeRun()
		
	end

	local measured = 0
	local total = 0
	for _,species in pairs(pool.species) do
		for _,genome in pairs(species.genomes) do
			total = total + 1
			if genome.fitness ~= 0 then
				measured = measured + 1
			end
		end
	end
	
	--gui.drawEllipse(screenX-84, screenY-84, 192, 192, 0x50000000) 
	forms.settext(FitnessLabel, "Fitness: " .. math.floor(rightmost - (pool.currentFrame) / 2 - (timeout + timeoutBonus)*2/3))
	forms.settext(GenerationLabel, "Generation: " .. pool.generation)
	forms.settext(SpeciesLabel, "Species: " .. pool.currentSpecies)
	forms.settext(GenomeLabel, "Genome: " .. pool.currentGenome)
	forms.settext(MaxLabel, "Max: " .. math.floor(pool.maxFitness))
	forms.settext(MeasuredLabel, "Measured: " .. math.floor(measured/total*100) .. "%")
	forms.settext(RingsLabel, "Rings: " .. (_SONIC.getRings() - startRings))
	forms.settext(ScoreLabel, "Score: " .. (_SONIC.getScore() - startScore))
	forms.settext(LivesLabel, "Lives: " .. Lives)
	forms.settext(PowerUpLabel, "PowerUp: " .. powerUpCounter)
	forms.settext(LevelBeatLabel, "Level Beat: " .. beatLevelCounter)

	pool.currentFrame = pool.currentFrame + 1
	
	end
	emu.frameadvance();
	
end