

local marker_switch = Menu.Switch("Visual", "Damage Marker", false)
local verdana = Render.InitFont('Verdana',12)
local log_dmg = {}

function render_string(x,y,cen,string,color,TYPE,font,fontsize)
    if TYPE == 0 then
        Render.Text(string, Vector2.new(x,y), color, fontsize,font,false,cen)
    elseif TYPE == 1 then
        Render.Text(string, Vector2.new(x+1,y+1), Color.new(0.1,0.1,0.1,color.a), fontsize,font,false,cen)
        Render.Text(string, Vector2.new(x,y), color, fontsize,font,false,cen)
    elseif TYPE == 2 then
        Render.Text(string, Vector2.new(x,y), color, fontsize,font,true,cen)
    end
end

function dmg_marker()
    if marker_switch:Get() == false then return end
    for i, mark in ipairs(log_dmg) do
        mark.pos.z = mark.pos.z + 50*GlobalVars.frametime
        local pos = Render.WorldToScreen(mark.pos)
        mark.size = mark.size - GlobalVars.frametime*55
        render_string(pos.x,pos.y,true,'-' ..  mark.damage ,mark.is_lethal and Color.RGBA(155,200,20,255) or Color.RGBA(255,255,255,255),1,verdana,math.floor(math.min(mark.size,12)))
        if mark.time + 3 < GlobalVars.realtime or mark.size < 0 then table.remove(log_dmg,i) end
    end
end

function dmg_event(e)
    if e:GetName() ~= 'player_hurt' then return end
    if EntityList.GetPlayerForUserID(e:GetInt('attacker')) == EntityList.GetLocalPlayer() then
        table.insert(log_dmg,{size = 120,pos = EntityList.GetPlayerForUserID(e:GetInt('userid')):GetHitboxCenter(e:GetInt('hitgroup')),damage = e:GetInt('dmg_health'),is_lethal = (e:GetInt('health') < 1),time = GlobalVars.realtime})   
    end
end

Cheat.RegisterCallback("draw", function()
    dmg_marker()
end)

Cheat.RegisterCallback("events", function(e)
    dmg_event(e)
end)