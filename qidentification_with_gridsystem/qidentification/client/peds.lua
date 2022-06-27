-- This entire file is a modified ped spawner that we 
-- use in many resources to create and manage peds. 
-- They're spawned in when you're close, and removed 
-- when you leave the area, reducing overhead on your server.

-- I wouldn't touch this unless you know what you're doing.


local spawnedPeds = {}

TriggerEvent('gridsystem:registerMarker', {
	name = 'license',  
	pos = vector3(250.12927246094,-1078.6301269531,29.294147491455),
	scale = vector3(1.5, 1.5, 1.5),
	size = vector3(2.5, 2.5, 2.5),
	msg = 'Municipio',
	type = 20,
	--show3D = false,
    control = 'E',
	action = function()
		TriggerEvent('qidentification:requestLicense')
	end
})

function NearPed(model, coords, gender, animDict, animName, scenario)
	RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
	if Config.MinusOne then
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
	else
		spawnedPed = CreatePed(Config.GenderNumbers[gender], model, coords.x, coords.y, coords.z, coords.w, false, true)
	end
	SetEntityAlpha(spawnedPed, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(spawnedPed, true)
	end
	if Config.Invincible then
		SetEntityInvincible(spawnedPed, true)
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(spawnedPed, true)
	end
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(50)
		end
		TaskPlayAnim(spawnedPed, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(spawnedPed, scenario, 0, true)
	end
	if Config.FadeIn then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(spawnedPed, i, false)
		end
	end
	SetEntityAsMissionEntity(spawnedPed, true, true)
	return spawnedPed
end
