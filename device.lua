shell.run("wget","https://git.io/aeslua","aeslua")

local version = "Beta 0.2"

local passKey = "Do not edit. Re-install ChamShop Mobile if you do so."

local width, height = term.getSize()
local id

local opID = 422
local reID = 425

local connected = false

local function cenLeft(objWidth)
	return (width - objWidth) / 2 + 1
end

local function cenTop(objHeight)
	return (height - objHeight) / 2 + 1
end

local function startup()
	term.clear()
	term.setCursorPos(cenLeft(26),cenTop(1)-1)
	term.write("Launching ChamShop Mobile!")
	term.setCursorPos(cenLeft(24),cenTop(1)+1)
	term.write("Connecting to Servers...")
	term.setCursorPos(1,1)
	print("WARNING: Beware of counterfeit programs! Do not trust computers given from other players! Keep your computer on you at all times!")
end

local function locateRednet()
	if peripheral.find("modem")==nil then
		error("Ender modem not found", 2)
	end
	local sides = peripheral.getNames()
	
	for _, side in pairs(sides) do
		if peripheral.getType(side)=="modem" then
			rednet.open(side)
			return
		end
	end
end

local function runMsg(c)
	local l = #c
	local msgType = c[1]
	local msgCat = -1
	if (msgType=="func" or msgType=="var" or msgType=="impRcl") then
		msgCat = 0
	elseif msgType=="impSto" then
		msgCat = 1
	end
	if (msgCat==0 and l<3) or (msgCat==1 and l<4) or msgCat==-1 then
		return c
	end
	
	if msgCat==0 then
		
		-- Set Implicit Values and Functions
		local api = c[2]
		local func = c[3]
		
		-- Check for things to handle in arguments
		for i = 4, l do
			if type(c[i])=="table" then
				c[i] = runMsg(c[i])
			end
		end
		
		-- Sets up the function/variable
		local prompt = _G[api][func]
		
		-- Removes the first 3 values of the table, which are before the arguments
		for i = 1, 3 do
			table.remove(c,1)
		end
		
		if l==3 then
			if msgType=="func" then
				return prompt()
			elseif msgType=="var" then
				return prompt
			elseif msgType=="impRcl" then
				return _G["csm_"..api].prompt()
			end
		elseif l>3 then
			if msgType=="func" then
				return prompt(unpack(c))
			elseif msgType=="impRcl" then
				return _G["csm_"..api].prompt(unpack(c))
			end
		end
	elseif msgCat==1 and msgType=="impSto" then
		local var = c[2]
		local api = c[3]
		local func = c[4]
		for i = 5, l do
			if type(c[i])=="table" then
				c[i] = runMsg(c[i])
			end
		end
		
		local prompt = _G[api][func]
		
		for i = 1, 4 do
			table.remove(c,1)
		end
		
		if l==4 then
			_G["csm_"..var] = prompt()
		elseif l>4 then
			_G["csm_"..var] = prompt(unpack(c))
		end
		return _G["csm_"..var]
	end
end

local function run()
	while true do
		local e = {os.pullEvent()}
		if e[1]=="rednet_message" and e[4]=="csm" and type(e[3])=="table" and (e[3][1]=="func" or e[3][1]=="var") then
			id = e[2]
			local output = runMsg(e[3])
			if (id==reID or id==opID) and output then
				connected = true
			end
			rednet.send(id, output, "csm")
		elseif id then
			if e[1]=="key" then
				local key = e[2]
				local held = e[3]
				rednet.send(id,{"key",key,held},"csm")
			elseif e[1]=="key_up" then
				local key = e[2]
				rednet.send(id,{"key_up",key},"csm")
			elseif e[1]=="mouse_click" then
				local button = e[2]
				local x = e[3]
				local y = e[4]
				rednet.send(id,{"mouse_click",button,x,y},"csm")
			elseif e[1]=="terminate" then
			
			end
		end
	end
end

local function connectExcept()
	term.setCursorPos(cenLeft(26),cenTop(1)-1)
	term.write("Cannot connect to servers.")
	term.setCursorPos(1,cenTop(1)+1)
	term.clearLine()
	print("Try reinstalling the program, or ChamShop Mobile Services may be under maintenance. Check updates on twitter.com/ChamShopInfo")
end

local function disconnect(check)
	if not check then
		error()
	end
end

local function loadingAnimation()
	term.setCursorPos(1,cenTop(1))
	local i = 1
	local w = width or 20
	while i <= w and not connected do
		io.write("-")
		i = i + 1
		os.sleep(1/w)
	end
	if not connected then
		connectExcept()
		error()
	end
end

locateRednet()
startup()
parallel.waitForAll(loadingAnimation, run)
