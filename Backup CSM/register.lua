local targs = {...}
local timeout = 300

local buttons = {}

local id = tonumber(targs[1])
local width = tonumber(targs[2] or 26)
local height = tonumber(targs[3] or 20)

local function send(...)
    rednet.send(id, {...},"csm")
end

local function cenLeft(objWidth)
	return (width - objWidth) / 2 + 1
end

local function cenTop(objHeight)
	return (height - objHeight) / 2 + 1
end

local function inBounds(x,y,x1,y1,x2,y2)
    if x>=x1 and x<=x2 and y>=y1 and y<=y2 then
        return true
    end
    return false
end

local function writeAtPos(text,x,y,color)
	send("term","setCursorPos",x,y)
	send("term","setTextColor",color or colors.black)
	send("term","write",text)
end

local function writeMultiColor({text},x,y)
	local i = x
	for _, part in pairs(text) do
		writeAtPos(part,i,y,part[2])
		i = i + #part[1]
	end

local function addButton(name,func,x1,y1,x2,y2)
	buttons[name] = {func, x1, y1, x2, y2} 
end

local function updateButtons()
	for name, button in pairs(buttons) do
		if button[6]~="hide" then
			writeAtPos(name,x1,y1)
		end
	end
end

local function callButton(x,y)
	for name, button in pairs(buttons) do
		if button[6]~="hide" then
			if inBounds(x,y,button[2],button[3],button[4],button[5]) then
				buttion[1]()
				return
			end
		end
	end
end

local function hideButton(name)
	buttons[name][6] = "hide"
end

local function showButton(name)
	buttons[name][6] = nil
end

-- Welcome Text On Top Of Screen
local function writeHeader()
    
end

local function mainScreen()
	writeHeader()
	
	-- Description Text
	send("term","setCursorPos",1,3)
	send("term","setTextColor",colors.lime)
	send("_G","print","Please click or use arrow keys on one of the options below to continue!")
	
	-- Create New Account Button
	send("term","setBackgroundColor",colors.lime)
	send("term","setTextColor",colors.black)
	local center = (width - 22) / 2 + 1
	send("term","setCursorPos",center,7)
	send("term","write",string.rep(" ",22))
	send("term","setCursorPos",center,8)
	send("term","write"," > Create New Account ")
	send("term","setCursorPos",center,9)
	send("term","write",string.rep(" ",22))
	send("term","setBackgroundColor",colors.lightGray)
	center = (width - 24) / 2 + 1
	send("term","setCursorPos",center,12)
	send("term","write",string.rep(" ",24))
	send("term","setCursorPos",center,13)
	send("term","write","   I Already Signed Up  ")
	send("term","setCursorPos",center,14)
	send("term","write",string.rep(" ",24))
	send("term","setBackgroundColor",colors.black)
end

local function registerAccount()
    send("term","clear")
    writeHeader()
    send("term","setCursorPos",1,3)
    send("term","setTextColor",colors.white)
    send("term","write","Username:")
end

local function run()
    local rid, msg = rednet.receive("csm")
    if rid==id and type(msg)=="table" and type(msg[1])=="string" then
        local e = msg[1]
        if e=="mouse_click" then
            local button = msg[2]
            local x = msg[3]
            local y = msg[4]
            print(x,y)
            local registerButtonPos = (width-22)/2+1
            if x>=registerButtonPos and x<=registerButtonPos + 21 and y>=7 and y<=9 then
                registerAccount()
            end
        end
    end
end

local function timer()
    os.sleep(1)
    timeout = timeout - 1
end

while true do
    parallel.waitForAny(run, timer)
end

local function startup()
	send("term","clear")
	mainScreen()
end

local function disconnect()

end

startup()