shell.run("wget","https://git.io/aeslua","aeslua")
shell.run("pastebin","get","NJUVA9q0","ChamAPI")

os.loadAPI("ChamAPI")

local width, height = term.getSize()
local introPage = ChamAPI.new("term")
local t = introPage

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

local function writeAt(text,x,y)
	term.setCursorPos(x,y)
	term.write(text)
end

local function cenLeft(objWidth)
	return (width - objWidth) / 2 + 1
end

local function cenTop(objHeight)
	return (height - objHeight) / 2 + 1
end

local function createAccount()

end

local function introScreen()
	
	t:addText(10,"Welcome To",1,1,colors.white,colors.black)
	t:addButton(2,"Create New Account",createAccount,cenLeft(20),cenTop(3)-3,cenLeft(20)+19,cenTop(3)-1,colors.black,colors.lime)
end

local function startup()
	term.clear()
	term.setTextColor(colors.white)
	
	introScreen()
	
	t:run()
end

startup()