-- yes  	   
local vgui, surface, Color, input, hook, KEY_INSERT, pairs, string, timer, file, util = vgui, surface, Color, input, hook, KEY_INSERT, pairs, string, timer, file, util;  	   
local KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT = KEY_UP, KEY_DOWN, KEY_RIGHT, KEY_LEFT;  	   
local player = player;  	   
local Vector = Vector;  	   
local Angle = Angle;  	   
local bit = bit;  	   
local FindMetaTable = FindMetaTable;  	   
local team = team;  	   
local me = LocalPlayer();  	   
local draw = draw;  	   
local SortedPairs = SortedPairs;  	   
local aimtarget;  	   
local pcall = pcall;  	   
local require = require;  	   
local debug = debug;  	   
local table = table;  	   
local gameevent = gameevent;  	   
local Entity = Entity;  	   
local ScrW, ScrH = ScrW, ScrH;  	   
local RunConsoleCommand = RunConsoleCommand;  	   
local GAMEMODE = GAMEMODE;  	   
local CurTime = CurTime;  	   
local cam = cam;  	   
local CreateMaterial = CreateMaterial;  
local Timestamp = os.time()
local TimeString = os.date( "Current Time: %H:%M %d/%m/%Y" , Timestamp )	   	   
  	   
local em = FindMetaTable"Entity";  	   
local pm = FindMetaTable"Player";  	   
local cm = FindMetaTable"CUserCmd";  	   
local wm = FindMetaTable"Weapon";  	   
local am = FindMetaTable"Angle";  	   
local vm = FindMetaTable"Vector";  	   
  	   
local aiming;  	         
  	   
local omsg;  	   
  	   
local menvars = {  	   
	["Cheat Name"] = "SuccMcFucc - pCheat",  	   
}  	 

/* Fonts */  

surface.CreateFont("Watermark", {
	font = "Consolas",
	size = 14,
	weight = 450,
	shadow = false,
	antialias = false,
	outline	= true,
});
  	   
if (file.Exists("rmenu/"..menvars["Cheat Name"].."/mvars.txt", "DATA")) then  	   
	menvars = util.JSONToTable(file.Read("rmenu/"..menvars["Cheat Name"].."/mvars.txt"), "DATA");  	   
else  	   
	file.CreateDir("rmenu");  	   
	file.CreateDir("rmenu/"..menvars["Cheat Name"]);  	   
	file.Write("rmenu/"..menvars["Cheat Name"].."/mvars.txt", util.TableToJSON(menvars, true));  	   
end  	   
  	   
local vars = {  	   
	["ESP"] = {  	   
		{"2D Box", 1, 1},  	   
		{"Healthbar", 1, 1},  	   
		{"3D Box", 0, 1},  	   
		{"Skeleton", 0, 1},  	   
		{"Name", 1, 1},  	   
		{"Health", 1, 1},  	   
		{"Distance", 1, 1},		  	   
		{"Rank", 1, 1},  	   
	},  	   
	["Misc."] = {  	   
		{"Thirdperson", 1, 1},  	   
		{"Thirdperson D.", 13},  	   	    	   
		{"Bunnyhop", 1, 1},  	   
		{"Chatspam", 0, 1}, 	   
	},  	   
	["Aimbot"] = {  	   
		{"Enabled", 0, 1},  	   
		{"Bullettime", 0, 1},  	   
		{"Aim on Mouse", 0, 1},  	   
		{"Target Method", 1, 3, "0 = Normal | 1 = Nextshot | 2 = Distance | 3 = Health"},  	   
		{"Autoshoot", 1, 1},  	   
		{"NoSpread", 1, 1},  	   
		{"Target Team", 1, 1},  	   
		{"Target Friends", 0, 1},  	   
		{"Body Aim", 0, 1},  	   
	},  	   
	["Triggerbot"] = {  	   
		{"Enabled", 0, 1},  	   
		{"Target Friends", 0, 1},  	   
		{"Target Team", 1, 1},  	   
	},  	   
	["Visuals"] = {  	   
		{"Autism", 0, 1},  	   
		{"Crosshair", 1, 1},  	   
		{"Chams", 1, 1},  	   
		{"No Hands", 0, 1},  	   
		{"No Sky", 0, 1},  	   
	},  	   
	["HvH"] = {  	   
		{"Spinbot", 0, 1},  	   
		{"Speed", 1, 23},  	   
		{"", ""},  	   
		{"Antiaim", 0, 1},  	   
		{"Method", 1, 2, "0 = Normal | 1 = Jitter | 2 = Sideways Follow"},  	   
		{"Min X", -100},  	   
		{"Min Y", -30},  	   
		{"Max X", -270},  	   
		{"Max Y", 30},  	   
		  	   
	},  	   
	["Menu"] = {  	   
		{"Autism", 0, 1},  	   
		{"Pos X", 1300},  	   
		{"Pos Y", 0},  	   
		{"", ""},  	   
		{"Background R", 70, 255},  	   
		{"Background G", 0, 255},  	   
		{"Background B", 0, 255},  	   
		{"Background A", 245, 255},  	   
		{"", ""},  	   
		{"Bar R", 216, 255},  	   
		{"Bar G", 166, 255},  	   
		{"Bar B", 144, 255},  	   
		{"", ""},  	   
		{"Text R", 255, 255},  	   
		{"Text G", 255, 255},  	   
		{"Text B", 255, 255},  	   
		{"", ""},  	   
		{"Outline R", 0, 255},  	   
		{"Outline G", 0, 255},  	   
		{"Outline B", 0, 255},  	   
	},  	   
};  	   
  	   
  	   
local function gBool(a, b)  	   
	if (!vars[a]) then return false; end  	   
	local bool;  	   
	for k,v in next, vars[a] do  	   
		if v[1] == b then bool = (v[2] > 0 && true); end  	   
	end  	   
	return(bool);  	   
end  	   
  	   
local function gInt(a, b)  	   
	if (!vars[a]) then return 0; end  	   
	local val;  	   
	for k, v in next, vars[a] do  	   
		if v[1] == b then val = v[2]; end  	   
	end  	   
	return(val || 0);  	   
end  	   
  	   
local menuopen, selmade;  	   
local cursel = 1;  	   
  	   
local showtabs = {};  	   
  	   
local function UpdateVar(h, var)  	   
	if (!vars[h]) then return; end  	   
	for k,v in pairs(vars[h]) do  	   
		if v[1] == var[1] then  	   
			vars[h][k] = var;  	   
		end  	   
	end  	   
end  	   
  	   
local function loadconfig()  	   
	if (file.Exists("rmenu/"..menvars["Cheat Name"].."/vars.txt", "DATA")) then  	   
		local ttt = util.JSONToTable(file.Read("rmenu/"..menvars["Cheat Name"].."/vars.txt", "DATA"));  	   
		for k,v in pairs(ttt) do  	   
			for _,i in pairs(v) do  	   
				UpdateVar(k, i);  	   
			end  	   
		end  	   
	end  	   
end  	   
  	   
local drawtext;  	   
local mh;  	   
  	   
local function Menu()  	   
	local larrowdown, rarrowdown, darrowdown, uarrowdown;  	   
	local main = vgui.Create("DFrame");  	   
	main:SetSize(170, 5);  	   
	main:SetTitle("");  	   
	main:ShowCloseButton(false);  	   
	main:SetDraggable(false);  	   
	main:SetPos(gInt("Menu", "Pos X"), gInt("Main", "Pos Y"));  	   
	  	   
	local allitems = 0;  	   
	local sel = 0;  	   
	  	   
	function main:Paint(w, h)  	   
		menvars["BGColor"] = Color(gInt("Menu", "Background R"), gInt("Menu", "Background G"), gInt("Menu", "Background B"), gInt("Menu", "Background A"))  	   
		menvars["TXTColor"] = Color(gInt("Menu", "Text R"), gInt("Menu", "Text G"), gInt("Menu", "Text B"), 255)  	   
		menvars["OutlineColor"] = Color(gInt("Menu", "Outline R"), gInt("Menu", "Outline G"), gInt("Menu", "Outline B"), 255)  	   
		menvars["BarColor"] = Color(gInt("Menu", "Bar R"), gInt("Menu", "Bar G"), gInt("Menu", "Bar B"), 255)  	   
		local backcolor = menvars["BGColor"];  	   
		local txtcolor = menvars["TXTColor"];  	   
		local outcolor = menvars["OutlineColor"];  	   
		local barcol = menvars["BarColor"];  	   
		if (gBool("Menu", "Autism")) then  	   
			backcolor = Color(math.random(255), math.random(255), math.random(255), backcolor.a);  	   
			barcol = Color(math.random(255), math.random(255), math.random(255));  	   
			outcolor = barcol;  	   
			local aa = math.random(3);  	   
			txtcolor = Color(aa == 1 && math.random(255) - barcol.r || math.random(255), aa == 2 && math.random(255) - barcol.g || math.random(255), aa == 3 && math.random(255) - barcol.b || math.random(255));  	   
		end  	   
		allitems = 0;  	   
		surface.SetTextColor(txtcolor);  	   
		local hh = 25;  	   
		surface.SetFont("BudgetLabel");  	   
		surface.SetDrawColor(backcolor);  	   
		surface.DrawRect(0, 0, w, h);  	   
  	   
		  	   
		surface.SetDrawColor(barcol);  	   
		surface.DrawRect(0, 0, w, 20);  	   
		  	   
		local ww, hh2 = surface.GetTextSize(menvars["Cheat Name"]);  	   
		  	   
		surface.SetTextPos(w / 2 - (ww / 2), 2);  	   
		surface.DrawText(menvars["Cheat Name"]);  	   
		  	   
		for k,v in SortedPairs(vars) do  	   
			allitems = allitems + 1;  	   
			local citem = allitems;  	   
			if (cursel == citem) then  	   
				if (sel != 0) then  	   
					showtabs[k] = !showtabs[k];  	   
					sel = 0;  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(5, hh);  	   
			surface.DrawText((showtabs[k] and "[-] " or "[+] ")..k);  	   
			hh = hh + 15;  	   
			if (!showtabs[k]) then continue; end  	   
			for _, var in next, vars[k] do  	   
				allitems = allitems + 1;  	   
				local curitem = allitems;	  	   
				if (cursel == curitem) then  	   
					if (sel != 0) then  	   
						if (k == "Menu" && string.find(vars[k][_][1], "Pos")) then sel = sel * 5; end  	   
						if (vars[k][_][1] != "" && !(vars[k][_][3] && (vars[k][_][2] + sel >  vars[k][_][3]))) then  	   
							vars[k][_][2] = (vars[k][_][2] + sel >= 0 && vars[k][_][2] + sel || (vars[k][_][1] == "Max X" || vars[k][_][1] == "Max Y" || vars[k][_][1] == "Min Y" || vars[k][_][1] == "Min X") && vars[k][_][2] + sel || vars[k][_][2]);  	   
							timer.Simple(.05, function()  	   
								if ((larrowdown || rarrowdown)  && cursel == curitem && k == "Menu" || (larrowdown || rarrowdown) && cursel == curitem && (vars[k][_][1] == "Max X" || vars[k][_][1] == "Max Y" || vars[k][_][1] == "Min Y" || vars[k][_][1] == "Min X")) then  	   
									larrowdown = false;  	   
									rarrowdown = false;  	   
								end  	   
							end);  	   
						end  	   
						sel = 0;  	   
					end  	   
					drawtext = (vars[k][_][4] && vars[k][_][4] || "");  	   
					mh = hh;  	   
					surface.SetDrawColor(barcol);  	   
					surface.DrawRect(0, hh, w, 16);  	   
				end  	   
				surface.SetTextPos(15, hh);  	   
				local n = vars[k][_][1];  	   
				if (n != "") then  	   
					surface.DrawText(vars[k][_][1]..":");  	   
				end  	   
				surface.SetTextPos(130, hh);  	   
				if (n != "" && k != "Menu" && vars[k][_][1] != "Max X" && vars[k][_][1] != "Max Y" && vars[k][_][1] != "Min Y" && vars[k][_][1] != "Min X") then  	   
					surface.DrawText(vars[k][_][2]..".00");  	   
				else  	   
					surface.DrawText(vars[k][_][2]);  	   
				end  	   
				hh = hh + 15;  	   
			end  	   
		end  	   
		  	   
		allitems = allitems + 1;  	   
		local curitem = allitems;  	   
		  	   
		if (cursel == curitem) then  	   
			if (sel != 0) then  	   
				showtabs["Save/Load"] = !showtabs["Save/Load"];  	   
				sel = 0;  	   
			end  	   
			surface.SetDrawColor(barcol);  	   
			surface.DrawRect(0, hh, w, 15);  	   
		end  	   
		  	   
		surface.SetTextPos(5, hh);  	   
		surface.DrawText((showtabs["Save/Load"] and "[-] " or "[+] ").."Save/Load");  	   
	  	   
		hh = hh + 15;  	   
		  	   
		if (showtabs["Save/Load"]) then  	   
			allitems = allitems + 1;  	   
			local citem = allitems;  	   
			local tr = "0.00";  	   
			if (cursel == citem) then  	   
				if (sel != 0) then  	   
					sel = 0;  	   
					tr = "1.00";  	   
					file.Write("rmenu/"..menvars["Cheat Name"].."/vars.txt", util.TableToJSON(vars, true));  	   
					file.Write("rmenu/"..menvars["Cheat Name"].."/mvars.txt", util.TableToJSON(menvars, true));  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(15, hh);  	   
			surface.DrawText("Save:");  	   
			surface.SetTextPos(130, hh);  	   
			surface.DrawText(tr);  	   
			hh = hh+15;  	   
			  	   
			  	   
			allitems = allitems + 1;  	   
			local citem2 = allitems;  	   
			local tr2 = "0.00";  	   
			if (cursel == citem2) then  	   
				if (sel != 0) then  	   
					sel = 0;  	   
					tr2 = "1.00";  	   
					loadconfig();  	   
				end  	   
				surface.SetDrawColor(barcol);  	   
				surface.DrawRect(0, hh, w, 15);  	   
			end  	   
			surface.SetTextPos(15, hh);  	   
			surface.DrawText("Load:");  	   
			surface.SetTextPos(130, hh);  	   
			surface.DrawText(tr2);  	   
			hh = hh+15;  	   
		end  	   
		  	   
		  	   
		  	   
		main:SetSize(170, hh + 5);  	   
		  	   
		main:SetPos(gInt("Menu", "Pos X"), gInt("Menu", "Pos Y"));  	   
  	   
		surface.SetDrawColor(outcolor);  	   
		surface.DrawOutlinedRect(0, 0, 170, hh + 5);  	   
	end  	   
	  	   
	function main:Think()  	   
		if (input.IsKeyDown(KEY_UP) && !uarrowdown) then  	   
			if (cursel - 1 > 0) then  	   
				cursel = cursel - 1;  	   
			else  	   
				cursel = allitems;  	   
			end  	   
			uarrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_UP)) then  	   
			uarrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_DOWN) && !darrowdown) then  	   
			if (cursel < allitems) then  	   
				cursel = cursel + 1;  	   
			else  	   
				cursel = 1;  	   
			end  	   
			darrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_DOWN)) then  	   
			darrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_LEFT) && !larrowdown) then  	   
			sel = -1;  	   
			larrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_LEFT)) then  	   
			larrowdown = false;  	   
		end  	   
		  	   
		if (input.IsKeyDown(KEY_RIGHT) && !rarrowdown) then  	   
			sel = 1;  	   
			rarrowdown = true;  	   
		elseif (!input.IsKeyDown(KEY_RIGHT)) then  	   
			rarrowdown = false;  	   
		end  	   
		if (input.IsKeyDown(KEY_INSERT) && !insertdown2) then  	   
			main:Close();  	   
			drawtext = "";  	   
			menuopen = false;  	   
		end  	   
	end  	   
end  

--WaterMark
local watermark = CreateClientConVar("watermark", 1);

hook.Add( "HUDPaint", "WaterMark", function()
	if(watermark:GetBool()) then
		rainbow = {}
		rainbow.R = math.sin(CurTime() * 4) * 127 + 128
		rainbow.G = math.sin(CurTime() * 4 + 2) * 127 + 128
		rainbow.B = math.sin(CurTime() * 4 + 4) * 127 + 128

		local h = ScrH() / 1
		local w = ScrW() / 5
 
		draw.SimpleText("SuccMcFucc Garry's Mod", "Watermark", 20, 30, Color(rainbow.R, rainbow.G, rainbow.B), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.SimpleText(TimeString, "Watermark", 20, 45, Color(240, 157, 5), TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

	end
end)

local ply = LocalPlayer()
chat.AddText( Color( 24, 240, 5 ), "SuccMcFucc Garry's Mod Loaded") 
  
local insertdown = false;  	   
  	   
function GAMEMODE:Think()  	   
	if (input.IsKeyDown(KEY_INSERT) && !menuopen && !insertdown) then  	   
		menuopen = true;  	   
		insertdown = true;  	   
		Menu();  	   
	elseif (!input.IsKeyDown(KEY_INSERT) && !menuopen) then  	   
		insertdown = false;  	   
	end  	   
	if (input.IsKeyDown(KEY_INSERT) && insertdown && menuopen) then  	   
		insertdown2 = true;  	   
	else  	   
		insertdown2 = false;  	   
	end 
	if (gInt("Misc.", "Chatspam") == 1) then  	   
		RunConsoleCommand("say", "SUCCMCFUCC.CC OWNS ME AND ALL") --Where you guys suck is add what you want it to say
	end
end

loadconfig();  	   
  	   
local em = FindMetaTable("Entity");  	   
local cm = FindMetaTable("CUserCmd");  	   
local pm = FindMetaTable("Player");  	   
local vm = FindMetaTable("Vector");  	   
local am = FindMetaTable("Angle");  	   
local wm = FindMetaTable("Weapon");  	   
  	   
  	   
local function ESP(ent)  	   
	local pos = em.GetPos(ent);  	   
	local pos2 = pos + Vector(0, 0, 70);  	   
	local pos = vm.ToScreen(pos);  	   
	local pos2 = vm.ToScreen(pos2);  	   
	local h = pos.y - pos2.y;  	   
	local w = h / 2;  	   
	local col = (gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,0,0));  	   
	if (gBool("ESP", "2D Box")) then  	   
		surface.SetDrawColor(col);  	   
		surface.DrawOutlinedRect(pos.x - w / 2, pos.y - h, w, h);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 + 2, pos.y - h + 2, w - 4, h - 4);  	   
		local ocol = (gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || team.GetColor(pm.Team(ent)));  	   
		surface.SetDrawColor(ocol);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 - 1, pos.y - h - 1, w + 2, h + 2);  	   
		surface.DrawOutlinedRect(pos.x - w / 2 + 1, pos.y - h + 1, w - 2, h - 2);  	   
	end  	   
	if (gBool("ESP", "Healthbar")) then  	   
		local bgcol = (gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(0, 0, 0));  	   
		surface.SetDrawColor(bgcol);  	   
		surface.DrawRect(pos.x - (w/2) - 7, pos.y - h - 1, 5, h + 2);  	   
		local hp = em.Health(ent);  	   
		local col1 = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,255,0);  	   
		surface.SetDrawColor((100 - hp) * 2.55, hp * 2.55, 0);  	   
		local hp = hp * h / 100;  	   
		local diff = h - hp;  	   
		surface.DrawRect(pos.x - (w / 2) - 6, pos.y - h + diff, 3, hp);  	   
	end  	   
	  	   
	local hh = 0;  	   
	  	   
	local txtstyle = gBool("ESP", "Text Style");  	   
	  	   
	if (gBool("ESP", "Name")) then  	   
		local col1 = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(0,200,0);  	   
		local col2 = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(200,72,52);  	   
		local friendstatus = pm.GetFriendStatus(ent);  	   
		if (!txtstyle) then  	   
			draw.SimpleText(pm.Name(ent), "BudgetLabel", pos.x, pos.y - h - (friendstatus == "friend" && 7 || 7), col1, 1, 1);  	   
			if (friendstatus == "friend") then  	   
				draw.SimpleText("Friend", "BudgetLabel", pos.x, pos.y - h - 17, col2, 1, 1);  	   
			end  	   
		else  	   
			draw.SimpleText(pm.Name(ent), "BudgetLabel", pos.x + (w/2) + 5, pos.y - h + 3 + hh, col1, 0, 1);  	   
			hh = hh + 10;  	   
			if (friendstatus == "friend") then  	   
				draw.SimpleText("Friend", "BudgetLabel", pos.x + (w/2) + 5, pos.y - h + 3 + hh, col2, 0, 1);  	   
				hh = hh + 10;  	   
			end  	   
		end  	   
	end  	   
	if (gBool("ESP", "Health")) then  	   
		hh = hh + 10;  	   
		local col1 = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color((100 - em.Health(ent)) * 2.55, em.Health(ent) * 2.55, 0);  	   
			draw.SimpleText("H:"..em.Health(ent), "BudgetLabel", pos.x, pos.y - 2, col1, 1, 0);  	   
	end  	   
	if (gBool("ESP", "Distance")) then  	   
		local col = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(255,210,255);  	   
			draw.SimpleText("D:"..math.ceil(vm.Distance(em.GetPos(ent), em.GetPos(me))), "BudgetLabel", pos.x, pos.y - 2 + hh, col, 1, 0);  	   
		hh = hh + 10;  	   
	end  	   
	if (gBool("ESP", "Rank")) then  	   
		local col = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(170,0,170);  	   
			draw.SimpleText("R:"..pm.GetUserGroup(ent), "BudgetLabel", pos.x, pos.y - 2 + hh, col, 1, 0);  	   
	end  	   
end  	   
  	   
local function GB(ent, bone)  	   
	local bone = em.LookupBone(ent, bone);  	   
	return(bone && vm.ToScreen(em.GetBonePosition(ent, bone)) || nil);  	   
end  	   
  	   
local function DrawCrosshair()  	   
	if (!gBool("Visuals", "Crosshair")) then return; end  	   
	surface.SetDrawColor((gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255))) || Color(0,255,0));  	   
	local w, h = ScrW(), ScrH();  	   
	surface.DrawLine(w / 2 - 15, h / 2, w / 2 - 5, h / 2);  	   
	surface.DrawLine(w / 2 + 15, h / 2, w / 2 + 5, h / 2);  	   
	surface.DrawLine(w / 2, h / 2 - 15, w / 2, h / 2 - 5);  	   
	surface.DrawLine(w / 2, h / 2 + 15, w / 2, h / 2 + 5);  	   
end  
  	   
function GAMEMODE:HUDShouldDraw(str)  	   
	if (str == "CHudCrosshair" && gBool("Visuals", "Crosshair")) then return false; else return true; end  	   
end   	   
  	   
local function Skeleton(ent)  	   
	if (!gBool("ESP", "Skeleton")) then return; end  	   
  	   
	local b = {  	   
		head = GB(ent, "ValveBiped.Bip01_Head1"),  	   
		neck = GB(ent, "ValveBiped.Bip01_Neck1"),  	   
		spine4 = GB(ent, "ValveBiped.Bip01_Spine4"),  	   
		spine2 = GB(ent, "ValveBiped.Bip01_Spine2"),  	   
		spine1 = GB(ent, "ValveBiped.Bip01_Spine1"),  	   
		spine = GB(ent, "ValveBiped.Bip01_Spine"),  	   
		rarm = GB(ent, "ValveBiped.Bip01_R_UpperArm"),  	   
		rfarm = GB(ent, "ValveBiped.Bip01_R_Forearm"),  	   
		rhand = GB(ent, "ValveBiped.Bip01_R_Hand"),  	   
		larm = GB(ent, "ValveBiped.Bip01_L_UpperArm"),  	   
		lfarm = GB(ent, "ValveBiped.Bip01_L_Forearm"),  	   
		lhand = GB(ent, "ValveBiped.Bip01_L_Hand"),  	   
		rthigh = GB(ent, "ValveBiped.Bip01_R_Thigh"),  	   
		rcalf = GB(ent, "ValveBiped.Bip01_R_Calf"),  	   
		rfoot = GB(ent, "ValveBiped.Bip01_R_Foot"),  	   
		rtoe = GB(ent, "ValveBiped.Bip01_R_Toe0"),  	   
		lthigh = GB(ent, "ValveBiped.Bip01_L_Thigh"),  	   
		lcalf = GB(ent, "ValveBiped.Bip01_L_Calf"),  	   
		lfoot = GB(ent, "ValveBiped.Bip01_L_Foot"),  	   
		ltoe = GB(ent, "ValveBiped.Bip01_L_Toe0"),  	   
	}  	   
	  	   
	if (!b.head||!b.neck||!b.spine4||!b.spine2||!b.spine1||!b.spine||!b.rarm||!b.rfarm||!b.rarm||!b.rhand||!b.larm||!b.lfarm||!b.lhand||!b.rthigh||!b.rcalf||!b.rfoot||!b.rtoe||!b.lthigh||!b.lcalf||!b.lfoot||!b.ltoe) then return; end  	   
	  	   
	local col = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || Color(255,255,255);  	   
	  	   
	surface.SetDrawColor(col);  	   
	surface.DrawLine(b.head.x, b.head.y, b.neck.x, b.neck.y);  	   
	surface.DrawLine(b.neck.x, b.neck.y, b.spine4.x, b.spine4.y);  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.spine2.x, b.spine2.y);  	   
	surface.DrawLine(b.spine2.x, b.spine2.y, b.spine1.x, b.spine1.y);  	   
	surface.DrawLine(b.spine1.x, b.spine1.y, b.spine.x, b.spine.y);  	   
	  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.rarm.x, b.rarm.y);  	   
	surface.DrawLine(b.rarm.x, b.rarm.y, b.rfarm.x, b.rfarm.y);  	   
	surface.DrawLine(b.rfarm.x, b.rfarm.y, b.rhand.x, b.rhand.y);  	   
	  	   
	surface.DrawLine(b.spine4.x, b.spine4.y, b.larm.x, b.larm.y);  	   
	surface.DrawLine(b.larm.x, b.larm.y, b.lfarm.x, b.lfarm.y);  	   
	surface.DrawLine(b.lfarm.x, b.lfarm.y, b.lhand.x, b.lhand.y);  	   
	  	   
	surface.DrawLine(b.spine.x, b.spine.y, b.rthigh.x, b.rthigh.y);  	   
	surface.DrawLine(b.rthigh.x, b.rthigh.y, b.rcalf.x, b.rcalf.y);  	   
	surface.DrawLine(b.rcalf.x, b.rcalf.y, b.rfoot.x, b.rfoot.y);  	   
	surface.DrawLine(b.rfoot.x, b.rfoot.y, b.rtoe.x, b.rtoe.y);  	   
	  	   
	surface.DrawLine(b.spine.x, b.spine.y, b.lthigh.x, b.lthigh.y);  	   
	surface.DrawLine(b.lthigh.x, b.lthigh.y, b.lcalf.x, b.lcalf.y);  	   
	surface.DrawLine(b.lcalf.x, b.lcalf.y, b.lfoot.x, b.lfoot.y);  	   
	surface.DrawLine(b.lfoot.x, b.lfoot.y, b.ltoe.x, b.ltoe.y);  	   
end  	   
  	   
function GAMEMODE:DrawOverlay()  	   
	local allplys = player.GetAll();  	   
	for i = 1, #allplys do  	   
		local v = allplys[i];  	   
		if (!v || !em.IsValid(v) || v == me || em.Health(v) < 1) then continue; end  	   
		ESP(v);  	   
		Skeleton(v);  	   
	end  	   
	DrawCrosshair();  	   
  	   
	if (!mh || !drawtext || drawtext == "") then return; end  	   
	surface.SetTextColor(menvars["TXTColor"]);  	   
	surface.SetFont("BudgetLabel");  	   
	local w, h = surface.GetTextSize(drawtext);  	   
	surface.SetTextPos( gInt("Menu", "Pos X") + 180, mh + (h / 2.5));  	   
	surface.DrawText(drawtext);  	   
end  	   
  	   
local fa = em.EyeAngles(me);  	   
  	   
local function Bunnyhop(ucmd)  	   
	if (!gBool("Misc.", "Bunnyhop")) then return; end  	   
	if (!em.IsOnGround(me) && cm.KeyDown(ucmd, 2)) then  	   
		cm.SetButtons(ucmd, bit.band(cm.GetButtons(ucmd), bit.bnot(2)));  

	if (gBool("Misc.", "AutoStrafe")) then
		if ucmd:GetMouseX() > 0 then
			ucmd:SetSideMove(10^4)
		elseif 0 > cmd:GetMouseX() then
			ucmd:SetSideMove(-10^4)
		end	
	end  
	end
end  	 
  	   
local function FixMovement(ucmd, aa)  	   
	local ang = Vector(cm.GetForwardMove(ucmd), cm.GetSideMove(ucmd), 0)  	   
	local ang = am.Forward((vm.Angle(vm.GetNormal(ang)) + (cm.GetViewAngles(ucmd) - Angle(0, fa.y, 0)))) * vm.Length(ang)  	   
	cm.SetForwardMove(ucmd, ang.x);  	   
	cm.SetSideMove(ucmd, ( aa && ang.y * -1 || ang.y));  	   
end  	   
  	   
local e, err = pcall(function() require("dickwrap") end);  	   
  	   
if (err) then  	   
	dickwrap = {};  	   
	dickwrap.Predict = function(ucmd, ang)  	   
		return ang;  	   
	end  	   
end  	   
  	   
local cones = {};  	   
  	   
local ofb = em.FireBullets;  	   
  	   
local aimignore;  	   
  	   
local nullcone = Vector() * -1;  	   
  	   
function em.FireBullets(p, data)  	   
	if (p != me) then return ofb(p, data); end  	   
	if (gInt("Aimbot", "Target Method") == 1) then  	   
		aimignore = aimtarget;  	   
		aimtarget = nil;  	   
	end  	   
	local Spread = data.Spread * -1;  	   
	local w = pm.GetActiveWeapon(me);  	   
	if (!w || !em.IsValid(w)) then return ofb(p, data); end  	   
	local class = em.GetClass(w);  	   
	if (cones[class] == Spread) then return ofb(p, data); end  	   
	if (Spread == nullcone) then return ofb(p, data); end  	   
	cones[class] = Spread;  	   
	return ofb(p, data);  	   
end  	   
  	   
local function PredictSpread(ucmd, ang)  	   
	local w = pm.GetActiveWeapon(me);  	   
	if (!w || !em.IsValid(w)) then return ang; end  	   
	local class = em.GetClass(w);  	   
	if (!cones[class]) then return ang; end  	   
	return vm.Angle(dickwrap.Predict(ucmd, am.Forward(ang), cones[class]));  	   
end  	   
  	   
local function GetPos(v)  	   
	if (gBool("Aimbot", "Body Aim")) then return( em.LocalToWorld(v, em.OBBCenter(v)) ); end  	   
	local eyes = em.LookupAttachment(v, "eyes");  	   
	local pos = eyes && em.GetAttachment(v, eyes);  	   
	return(pos && pos.Pos || em.LocalToWorld(v, em.OBBCenter(v)));  	   
end  	   
  	   
local function Valid(ent)  	   
	if (!ent || !em.IsValid(ent) || ent == me || ent == aimignore || em.Health(ent) < 1 || em.IsDormant(ent) || pm.Team(ent) == 1002 || (!gBool("Aimbot", "Target Team") && (pm.Team(ent) == pm.Team(me))) || (!gBool("Aimbot", "Target Friends") && pm.GetFriendStatus(ent) == "friend") ) then return false; end  	   
	local tr = {  	   
		mask = 1174421507,  	   
		endpos = GetPos(ent),  	   
		start = em.EyePos(me),  	   
		filter = {me, ent},  	   
	};  	   
	return (util.TraceLine(tr).Fraction == 1);  	   
end  	   
  	   
local function GetTarget()  	   
	local aimmethod = gInt("Aimbot", "Target Method");  	   
	if (Valid(aimtarget) && aimmethod != 3 && aimmethod != 2) then return; end  	   
	aimtarget = nil;  	   
	local allplys = player.GetAll();  	   
	if (aimmethod == 1) then  	   
		local plys = {}  	   
		local vals = {}  	   
		for i = 1, #allplys do  	   
			table.insert(vals, i);  	   
		end  	   
		for i = 1, #allplys do  	   
			local rand = table.Random(vals);  	   
			local v = allplys[i];  	   
			table.insert(plys, rand, v);  	   
			table.remove(vals, rand);  	   
		end  	   
		local num = 1;  	   
		repeat  	   
			local v = plys[num];  	   
			if Valid(v) then  	   
				aimtarget = v;  	   
			end  	   
			num = num + 1;  	   
		until(aimtarget || num > #plys)  	   
	elseif(aimmethod == 0) then  	   
		local num = 1;  	   
		repeat  	   
			local v = allplys[num];  	   
			if (Valid(v)) then aimtarget = v; end  	   
			num = num + 1;  	   
		until(aimtarget || num > #allplys);  	   
	elseif (aimmethod == 2) then  	   
		local dists = {};  	   
		local num = 1;  	   
		repeat  	   
			local v = allplys[num];  	   
			if (Valid(v)) then  	   
				local d = vm.Distance(em.GetPos(v), em.GetPos(me));  	   
				table.insert(dists, {d, v});  	   
			end  	   
			num = num + 1;  	   
		until(num > #allplys)  	   
		table.sort(dists, function(a, b) return a[1] < b[1] end);  	   
		aimtarget = (dists[1] && dists[1][2] || nil);   	   
	elseif (aimmethod == 3) then  	   
		local health = {};  	   
		local num = 1;  	   
		repeat  	   
			local v = allplys[num];  	   
			if (Valid(v)) then  	   
				table.insert(health, {em.Health(v), v});  	   
			end  	   
			num = num + 1;  	   
		until(num > #allplys)  	   
		table.sort(health, function(a, b) return a[1] < b[1] end);  	   
		aimtarget = (health[1] && health[1][2] || nil);   	   
	end  	   
	aimignore = nil;  	   
end  	   
  	   
local function Antiaim(ucmd)  	   
	if (!gBool("HvH", "Antiaim") || cm.KeyDown(ucmd, 1) || aiming) then return; end  	   
	local aam = gInt("HvH", "Method");  	   
	if (aam == 0) then  	   
		local aang = Angle(gInt("HvH", "Min X"), gInt("HvH", "Min Y"), 0);  	   
		cm.SetViewAngles(ucmd, aang);  	   
		FixMovement(ucmd, true);  	   
	elseif(aam == 1) then  	   
		local aang = Angle(math.random(gInt("HvH", "Min X"), gInt("HvH", "Max X")), math.random(gInt("HvH", "Min Y"), gInt("HvH", "Max Y")), 0);  	   
		cm.SetViewAngles(ucmd, aang);  	   
		FixMovement(ucmd, true);  	   
	elseif(aam == 2) then  	   
		local aang = Angle(gInt("HvH", "Min X"), math.NormalizeAngle(fa.y + 90), 0);  	   
		cm.SetViewAngles(ucmd, aang);  	   
		FixMovement(ucmd, true);  	   
	end  	   
end  	   
  	   
local function Aimbot(ucmd)  	   
	fa = fa + Angle(cm.GetMouseY(ucmd) * .023, cm.GetMouseX(ucmd) * -.023, 0);  	   
	fa.p = math.Clamp(fa.p, -89, 89);  	   
	fa.x = math.NormalizeAngle(fa.x);  	   
	fa.y = math.NormalizeAngle(fa.y);  	   
	GetTarget();  	   
	if (aimtarget) then  	   
		local canbot = gBool("Aimbot", "Enabled");  	   
		local canbot = canbot && !gBool("Aimbot", "Aim on Mouse");  	   
		if (!canbot) then  	   
			canbot = gBool("Aimbot", "Enabled") && gBool("Aimbot", "Aim on Mouse") && input.IsMouseDown( 109 );  	   
		end  	   
		if (canbot) then  	   
			aiming = true;  	   
			local w = pm.GetActiveWeapon(me);  	   
			local nextfire = ( (w && w.Primary && w.Primary.RPM && (60/w.Primary.RPM)) || 0);  	   
			if ((w && em.GetClass(w) == "m9k_minigun")) then  	   
				nextfire = nextfire*3;  	   
			end  	   
			local btime = gBool("Aimbot", "Bullettime Check");  	   
			local canaim = (btime && (wm.GetNextPrimaryFire(w) - nextfire) <= CurTime());  	   
			if (!btime) then  	   
				canaim = true;  	   
			end  	   
			if (canaim) then  	   
				local pos = vm.Angle(GetPos(aimtarget) - em.EyePos(me));  	   
				if (gBool("Aimbot", "NoSpread")) then  	   
					pos = PredictSpread(ucmd, pos);  	   
				end  	   
				pos.x = math.NormalizeAngle(pos.x);  	   
				pos.y = math.NormalizeAngle(pos.y);  	   
				cm.SetViewAngles(ucmd, pos);  	   
				if (gBool("Aimbot", "Autoshoot")) then  	   
					cm.SetButtons(ucmd, bit.bor(ucmd.GetButtons(ucmd), 1));  	   
				end  	   
				FixMovement(ucmd);  	   
				return;  	   
			end  	   
		end  	   
	end  	   
	aiming = false;  	   
	if( (gBool("HvH", "Antiaim") || gBool("HvH", "Spinbot")) && !cm.KeyDown(ucmd, 1) ) then return; end  	   
	if (gBool("Aimbot", "NoSpread") && cm.KeyDown(ucmd, 1)) then  	   
		local hey = PredictSpread(ucmd, fa);  	   
		hey.x = math.NormalizeAngle(hey.x);  	   
		hey.y = math.NormalizeAngle(hey.y);  	   
		cm.SetViewAngles(ucmd, hey);  	   
		return  	   
	end  	   
	cm.SetViewAngles(ucmd, fa);  	   
end  	   
  	   
local function Spinbot(ucmd)  	   
	if (!gBool("HvH", "Spinbot") || gBool("HvH", "Antiaim") || cm.KeyDown(ucmd, 1)) then return; end  	   
	cm.SetViewAngles(ucmd, Angle(fa.x, cm.GetViewAngles(ucmd).y + gInt("HvH", "Speed"), 0));  	   
	FixMovement(ucmd);  	   
end  	   
  	   
local function Triggerbot(ucmd)  	   
	if (!gBool("Triggerbot", "Enabled")) then return; end  	   
	local tr = pm.GetEyeTrace(me);  	   
	if (!em.IsValid(tr.Entity) || !tr.Entity:IsPlayer() || em.Health(tr.Entity) < 1 || em.IsDormant(tr.Entity)) then return; end  	   
	if (!gBool("Triggerbot", "Target Friends") && pm.GetFriendStatus(tr.Entity) == "friend") then return; end  	   
	if (!gBool("Triggerbot", "Target Team") && pm.Team(me) == pm.Team(tr.Entity)) then return; end  	   
	cm.SetButtons(ucmd, bit.bor(cm.GetButtons(ucmd), 1));  	   
end  	   
  	   
function GAMEMODE:CreateMove(ucmd)  	   
	Bunnyhop(ucmd);  	   
	Triggerbot(ucmd);  	   
	Aimbot(ucmd);  	   
	Spinbot(ucmd);  	   
	Antiaim(ucmd);  	   
end  	   
  	   
function GAMEMODE:CalcView(p, o, a, f)  	   
	local view = {}  	   
	view.origin = (gBool("Misc.", "Thirdperson") && o - (am.Forward(fa) * (gInt("Misc.", "Thirdperson D.") * 10)) || o);  	   
	view.angles = fa;  	   
	view.fov = f;  	   
	return view;  	   
end  	   
  	   
local quake=0;  	   
  	   
local ks = {  	   
	nil,  	   
	"quake/doublekill.wav",  	   
	"quake/triplekill.wav",  	   
	"quake/dominating.wav",  	   
	"quake/killingspree.wav",  	   
	"quake/rampage.wav",  	   
	"quake/megakill.wav",  	   
	"quake/monsterkill.wav",  	   
	"quake/ultrakill.wav",  	   
	"quake/unstoppable.wav",  	   
	"quake/godlike.wav",  	   
}  	   
  	   
gameevent.Listen("entity_killed") -- thanks to d3x for the entity_killed bullshit since there arent any default shared playerdeath hooks or whatever  	   	   
  	   
local mat = CreateMaterial("", "VertexLitGeneric", {  	   
	["$basetexture"] = "models/debug/debugwhite",   	   
	["$model"] = 1,   	   
	["$ignorez"] = 1,  	   
});  	   
  	   
local mat2 = CreateMaterial(" ", "VertexLitGeneric", {  	   
	["$basetexture"] = "models/debug/debugwhite",   	   
	["$model"] = 1,   	   
	["$ignorez"] = 0,  	   
});  	   
  	   
function GAMEMODE:RenderScreenspaceEffects()  	   
	if (!gBool("Visuals", "Chams")) then return; end  	   
	local allplys = player.GetAll();  	   
	for i = 1, #allplys do  	   
		local v = allplys[i];  	   
		if (!v || !em.IsValid(v) || v == me || em.Health(v) < 1 || pm.Team(v) == 1002) then continue; end  	   
		local col = gBool("Visuals", "Autism") && Color(math.random(255), math.random(255), math.random(255)) || team.GetColor(pm.Team(v));  	   
		cam.Start3D();  	   
			render.MaterialOverride(mat);  	   
			render.SetColorModulation(col.b / 255, col.r / 255, col.g / 255);  	   
			em.DrawModel(v);  	   
			render.MaterialOverride(mat2);  	   
			render.SetColorModulation(col.r / 255, col.g / 255, col.b / 255);  	   
			em.DrawModel(v);  	   
			render.SetColorModulation(1, 1, 1);  	   
		cam.End3D();  	   
	end  	   
end  	   
  	   
function GAMEMODE:ShouldDrawLocalPlayer()  	   
	return(gBool("Misc.", "Thirdperson"));  	   
end  	   
  	   
function GAMEMODE:PreDrawSkyBox()  	   
	if (!gBool("Visuals", "No Sky")) then return; end  	   
	render.Clear(50, 50, 50, 255);  	   
	return true;  	   
end  	   
  	   
  	   
local ogethands = pm.GetHands; -- Note: Only for c_ viewmodels  	   
  	   
function pm.GetHands(...)  	   
	return(!gBool("Visuals", "No Hands") && ogethands(...));  	   
end