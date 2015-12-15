require "base/internal/ui/reflexcore"

doppelHealth = {
	visible = true;
	anchor = {
		x = 0;
		y = 0;
	};
	offset = {
		x = 0;
		y = 0;
	}
}
doppelArmor = {
	visible = true;
	anchor = {
		x = 0;
		y = 0;
	};
	offset = {
		x = 0;
		y = 0;
	}
}
registerWidget("doppelHealth")
registerWidget("doppelArmor")

local function shouldDrawHud(ignoreShowHud)
	local lp = getLocalPlayer()
	return (lp and lp.connected and replayName ~= "menu" and not isInMenu() and (ignoreShowHud or consoleGetVariable("cl_show_hud") ~= 0))
end

function doppelHealth:draw()
	if not world or world.gameState == GAME_STATE_GAMEOVER or not shouldDrawHud() then return end
	local player = getPlayer()
	if not player or not player.connected or player.state ~= PLAYER_STATE_INGAME or player.health <= 0 then return end
	local angle = math.pi -math.pi/4
	nvgBeginPath()
	nvgArc(0, 0, 100, -angle, angle, NVG_CCW)
	nvgArc(0, 0, 120, angle, -angle, NVG_CW)
	nvgFillColor(Color(0, 0, 0, 0x60))
	nvgFill()
	nvgClosePath()
	nvgBeginPath()
	local startAngle = math.pi - (math.pi/4* 0.98)
	local endAngle = startAngle + ((math.pi/2 * math.min(100,player.health)/100) * 0.98)
	nvgArc(0, 0, 102, startAngle, endAngle, NVG_CW)
	nvgArc(0, 0, 118, endAngle, startAngle, NVG_CCW)
	nvgFillColor(Color(0, 0xFF, 0, 0x60))
	nvgFill()
	nvgClosePath()
	if player.health > 100 then
		nvgBeginPath()
		local health = player.health - 100
		endAngle = startAngle + ((math.pi/2 * (health)/100) * 0.98)
		nvgArc(0, 0, 104, startAngle, endAngle, NVG_CW)
		nvgArc(0, 0, 116, endAngle, startAngle, NVG_CCW)
		nvgFillColor(Color(0, 0, 0xFF, 0x60))
		nvgFill()
		nvgClosePath()
	end
	nvgBeginPath()
	local textAngle = angle
	nvgArc(0, 0, 120, textAngle, textAngle+(math.pi/6), NVG_CW)
	bottomY = 120*math.sin(textAngle)
	topY = 120*math.sin(textAngle+(math.pi/6))
	leftX = 120*math.cos(textAngle)-120
	bottomRightX = 120*math.cos(textAngle)
	nvgLineTo(leftX, topY)
	nvgLineTo(leftX, bottomY)
	nvgFillColor(Color(0xFF, 0xFF, 0xFF, 0x60))
	nvgFill()
	nvgClosePath()
	nvgBeginPath()
	nvgFontSize(bottomY-topY)
	nvgFillColor(Color(0, 0, 0, 0xFF))
	nvgText(leftX+10, bottomY-10, player.health)
	nvgFill()
	nvgClosePath()
end

function doppelArmor:draw()
	if not world or world.gameState == GAME_STATE_GAMEOVER or not shouldDrawHud() then return end
	local player = getPlayer()
	if not player or not player.connected or player.state ~= PLAYER_STATE_INGAME or player.armor <= 0 then return end
	local angle = -math.pi/4
	nvgBeginPath()
	nvgArc(0, 0, 100, -angle, angle, NVG_CCW)
	nvgArc(0, 0, 120, angle, -angle, NVG_CW)
	nvgFillColor(Color(0, 0, 0, 0x60))
	nvgFill()
	nvgClosePath()
	nvgBeginPath()
	local startAngle = -angle * 0.98
	local endAngle = startAngle - ((math.pi/2 * player.armor/200) * 0.98)
	nvgArc(0, 0, 102, startAngle, endAngle, NVG_CCW)
	nvgArc(0, 0, 118, endAngle, startAngle, NVG_CW)
	if player.armorProtection == 1 then
		nvgFillColor(Color(0xFF, 0xFF, 0, 0x60))
	elseif player.armorProtection == 2 then
		nvgFillColor(Color(0xFF, 0, 0, 0x60))
	else
		nvgFillColor(Color(0, 0xFF, 0, 0x60))
	end
	nvgFill()
	nvgClosePath()
	nvgBeginPath()
	local textAngle = -angle
	nvgArc(0, 0, 120, textAngle, textAngle-(math.pi/6), NVG_CCW)
	bottomY = 120*math.sin(textAngle)
	topY = 120*math.sin(textAngle-(math.pi/6))
	rightX = 120*math.cos(textAngle)+120
	bottomLeftX = 120*math.cos(textAngle)
	nvgLineTo(rightX, topY)
	nvgLineTo(rightX, bottomY)
	nvgFillColor(Color(0xFF, 0xFF, 0xFF, 0x60))
	nvgFill()
	nvgClosePath()
	nvgBeginPath()
	nvgFontSize(bottomY-topY)
	nvgTextAlign(NVG_ALIGN_RIGHT, NVG_ALIGN_BASELINE)
	nvgFillColor(Color(0, 0, 0, 0xFF))
	nvgText(rightX-10, bottomY-10, player.armor)
	nvgFill()
	nvgClosePath()
end
