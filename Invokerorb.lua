--<<Invoker OrbControl>>
--[[
                                    ●▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬●

                                   I am Nova, I do stuff

                                    ●▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬● 
]]--
----------------------------------------------------------------------------------------------------------
require("libs.Utils") 
require("libs.ScriptConfig") 
require("libs.Animations")


config = ScriptConfig.new()
config:SetParameter("InvokeDelay", 500, config.TYPE_NUMBER) 
config:Load()

local InvokeDelay = config.InvokeDelay

local registered	 = false 
local RightClick = false 

function onLoad()
	if PlayingGame() then  
		local me = entityList:GetMyHero()
		if not me or me.classId ~= CDOTA_Unit_Hero_Invoker then 
			script:Disable()
		else
			registered = true
			script:RegisterEvent(EVENT_TICK,Main)  
			script:UnregisterEvent(onLoad) 
		end
	end
end

function Main(tick) 
	if not SleepCheck() then return end

	local me = entityList:GetMyHero()
	local mp = entityList:GetMyPlayer()
	if not me then return end  
	
 local Quas = me:GetAbility(1)
	local Wex = me:GetAbility(2)
	local Exort = me:GetAbility(3)
	local Invoke = me:GetAbility(6)
	
	if mp.orderId == Player.ORDER_USEABILITY then
   if Invoke.cd > 0 and SleepCheck("Once") then
	    CurrentMode = "Random"
			  Sleep(InvokeDelay,"InvokeDelay")
			  Sleep(Invoke.cd*1000,"Once")
		 end
 elseif SleepCheck("InvokeDelay") then
    if Exort:CanBeCasted() and mp.orderId == Player.ORDER_ATTACKENTITY and CurrentMode ~= "Exort" then
		    me:Stop()
		    Cast(Exort,Exort,Exort)
		  	 me:Attack(mp.target)
		  	 CurrentMode = "Exort" 
		  elseif Quas:CanBeCasted() and mp.orderId == Player.ORDER_ATTACKENTITY and Animations.CanMove(me) and me.health < me.maxHealth and CurrentMode ~= "Quas" then
      Cast(Quas,Quas,Quas)
		  	 CurrentMode = "Quas" 
		  elseif Quas:CanBeCasted() and mp.orderId == Player.ORDER_MOVETOPOSITION and me.health < me.maxHealth and CurrentMode ~= "Quas"  then
      Cast(Quas,Quas,Quas)
	     CurrentMode = "Quas" 
		  elseif Wex:CanBeCasted() and mp.orderId == Player.ORDER_MOVETOPOSITION and me.health == me.maxHealth and CurrentMode ~= "Wex"  then
	     Cast(Wex,Wex,Wex)
      CurrentMode = "Wex" 
		  end
	end
	
end

function Cast(Orb,Orb,Orb)
	local me = entityList:GetMyHero()
	
	me:CastAbility(Orb)
	me:CastAbility(Orb)
	me:CastAbility(Orb)
end


function onClose()
	collectgarbage("collect")
	if registered then
		script:UnregisterEvent(Main)
		script:UnregisterEvent(Key)
  script:RegisterEvent(EVENT_TICK,onLoad)
		registered = false
	end
end

script:RegisterEvent(EVENT_CLOSE,onClose) 
script:RegisterEvent(EVENT_TICK,onLoad)
