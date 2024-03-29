local version = "Beta 0.2"

local passKey = "Do not edit. Re-install ChamShop Mobile if you do so."

local width, height = term.getSize()
local id

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

local function run()
	while true do
		local e = {os.pullEvent()}
		if e[1]=="rednet_message" and e[4]=="csm" and type(e[3])=="table" and type(e[3][1])=="string" then
			id = e[2]
			local c = e[3]
			local api = c[1]
			local func = c[2]
			for i = 3, 9 do
				c[i] = c[i] or ""
				if type(c[i])=="table" then
					for 
				end
			end
			_G[api][func](c[3],c[4],c[5],c[6],c[7],c[8],c[9])
		elseif id then
			if e[1]=="key" then
				local key = e[2]
				local held = e[3]
				rednet.broadcast(id,{"key",key,held},"csm")
			elseif e[1]=="mouse_click" then
				local button = e[2]
				local x = e[3]
				local y = e[4]
			end
		end
	end
end

local function loadingAnimation()
	term.setCursorPos(1,cenTop(1))
	local i = 1
	local w = width or 20
	while i <= w do
		io.write("-")
		i = i + 1
		os.sleep(1/w)
	end
end

locateRednet()
startup()
parallel.waitForAny(loadingAnimation, run)
term.setCursorPos(cenLeft(26),cenTop(1)-1)
term.write("Cannot connect to servers.")
term.setCursorPos(1,cenTop(1)+1)
term.clearLine()
print("Try reinstalling the program, or ChamShop Mobile Services may be under maintenance. Check updates on twitter.com/ChamShopInfo")