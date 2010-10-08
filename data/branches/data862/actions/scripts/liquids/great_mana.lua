local MIN = 200
local MAX = 300
local EMPTY_POTION = 7635

local combat = createCombatObject()
setCombatParam(combat, COMBAT_PARAM_TYPE, COMBAT_MANADRAIN)
setCombatParam(combat, COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
setCombatParam(combat, COMBAT_PARAM_TARGETCASTERORTOPMOST, TRUE)
setCombatParam(combat, COMBAT_PARAM_AGGRESSIVE, FALSE)
setCombatFormula(combat, COMBAT_FORMULA_DAMAGE, MIN, 0, MAX, 0)

local exhaust = createConditionObject(CONDITION_EXHAUST_POTION)
setConditionParam(exhaust, CONDITION_PARAM_TICKS, getConfigInfo('minactionexinterval'))

function onUse(cid, item, frompos, item2, topos)
	if(isPlayer(item2.uid) == FALSE)then
		return FALSE
	end

	if not(isSorcerer(cid) or isDruid(cid)) or (getPlayerLevel(cid) < 80) and not(getPlayerAccess(cid) > 0) then
		doCreatureSay(cid, "Only sorcerers and druids of level 80 or above may drink this fluid.", TALKTYPE_ORANGE_1)
		return TRUE
	end

	if(hasCondition(cid, CONDITION_EXHAUST_POTION) == TRUE) then
		doPlayerSendDefaultCancel(cid, RETURNVALUE_YOUAREEXHAUSTED)
		return TRUE
	end

	if(doCombat(cid, combat, numberToVariant(item2.uid)) == LUA_ERROR) then
		return FALSE
	end

	doAddCondition(cid, exhaust)
	doCreatureSay(item2.uid, "Aaaah...", TALKTYPE_ORANGE_1)
    doRemoveItem(item.uid, 1)
    doPlayerAddItem(cid, EMPTY_POTION, 1)
	return TRUE
end
