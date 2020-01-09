local administrativeSteamIDs={[999]=true}

local pickups = {}

AddEvent("OnPackageStart",function()
    print("[Pickups] Starting pickups package")
    
    loadPickups()

    --table.insert(pickups,{model=1,x=0,y=2,z=3,type="health"})
    --tprint(pickups,0)
    --savePickups()
end)

AddEvent("OnPackageStop",function()
	for _, v in pairs(pickups) do
		DestroyPickup(v.id)
		print(v.id)
	end
end)

AddEvent("OnPlayerPickupHit",function(p,pickup)
	if(GetPickupPropertyValue(pickup,"pickupplugin")==true)then
		SetPlayerPropertyValue(p,"pickupplugin_lasthit",pickup)
		if administrativeSteamIDs[steamID] or administrativeSteamIDs[999] then
			AddPlayerChat(p,"<span color=\"#FF4422FF\">[Admin message] This pickup can be deleted with /deletepickup</>")
		end

		local type = GetPickupPropertyValue(pickup,"pickupplugin_type")
		if(type=="health")then
			SetPlayerHealth(p,100)
		elseif type=="repair" then
			local vehicleid = GetPlayerVehicle(p)

			if vehicleid > 0 then
				SetVehicleHealth(vehicleid, 5000)
				SetVehicleDamage(vehicleid,1,0)
				SetVehicleDamage(vehicleid,2,0)
				SetVehicleDamage(vehicleid,3,0)
				SetVehicleDamage(vehicleid,4,0)
				SetVehicleDamage(vehicleid,5,0)
				SetVehicleDamage(vehicleid,6,0)
				SetVehicleDamage(vehicleid,7,0)
				SetVehicleDamage(vehicleid,8,0)
			end
		end
	end
end)

function loadPickups()
    local loadedpickups = File_LoadJSONTable("pickups.json")
    
	if(loadedpickups~=nil)then
		pickups = loadedpickups
		
		for i=1, #loadedpickups do
			-- print("[Pickups] "..loadedpickups[i].x.." "..loadedpickups[i].y.." "..loadedpickups[i].z.." "..loadedpickups[i].type.." "..loadedpickups[i].model)
			local newpickup = CreatePickup(loadedpickups[i].model,loadedpickups[i].x,loadedpickups[i].y,loadedpickups[i].z)
			SetPickupPropertyValue(newpickup,"pickupplugin",true)
			SetPickupPropertyValue(newpickup,"pickupplugin_type",loadedpickups[i].type)

			table.insert(pickups,{model=loadedpickups[i].model,x=loadedpickups[i].x,y=loadedpickups[i].y,z=loadedpickups[i].z,type=loadedpickups[i].type,id=newpickup})
	    end
        print("[pickups] Loaded pickups")
    else
        print("[Pickups] No saved pickups to load")
    end
end

function savePickups()
    File_SaveJSONTable("pickups.json", pickups)
    print("[Pickups] Saved pickups")
end


AddCommand("deletepickup",function(p)
	local thepickup = GetPlayerPropertyValue(p,"pickupplugin_lasthit")
	if(thepickup==nil)then
		return
	end
	for i=1, #pickups do
		if (pickups[i].id==thepickup) then
			pickups[i] = nil
			DestroyPickup(thepickup)
			tprint(pickups)
			savePickups()
			AddPlayerChat(p,"<span color=\"#FF4422FF\">Deleted the last hit pickup</>")
			break
		end
	end
end)

AddCommand("createpickup",function(p,type)
	local steamID = GetPlayerSteamId(p)
	if not administrativeSteamIDs[steamID] and not administrativeSteamIDs[999] then
		return
	end

	AddPlayerChat(p,type)
    if type~="health" and type~="repair" then
        AddPlayerChat(p,"<span color=\"#FF4422FF\">Error: available types: health, repair</>")
    else
		local model = false
		if type=="health" then
			model = 816
		elseif type=="repair" then
			model=551
		end

		local px,py,pz=GetPlayerLocation(p)
		local newpickup = CreatePickup(model,px,py,pz)
		
		SetPickupPropertyValue(newpickup,"pickupplugin",true)
		SetPickupPropertyValue(newpickup,"pickupplugin_type",type)

		
        table.insert(pickups,{model=model,x=px,y=py,z=pz,type=type,id=newpickup})
		savePickups()
		
		
    end
end)

function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
end