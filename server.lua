rednet.open("back")
os.loadAPI("touchpoint")

busy = false

options = {}

opID = 422
reID = 425

function writeAt(text,x,y)
	term.setCursorPos(x,y)
	term.write(text)
end

function maxLen(t)
	local max = 0
	for _, s in pairs(t) do
		max = #s>max and #s or max
	end
	return max
end

function sendSpecial(...)
	if not id then
		error("no id specified", 2)
	end
    rednet.send(id, {...},"csm")
	repeat
		local rid, msg = rednet.receive("csm",1)
	until rid==id
	return msg
end

function send(...)
	sendSpecial("func",...)
end

function moreOptions(x,y)
	rcm.reposition(x,y,maxLen(options),#options)
end

function connected()
	send("rednet","send",os.getComputerID(),"connectionCheck","csm")
	local rid, msg = rednet.receive("csm",1)
	if rid==id and msg=="connectionCheck" then
		return true
	end
	return false
end

function disconnect()
	rednet.send(opID,"ready","csm")
	term.clear()
	term.writeAt("Server Status: Ready",1,1)
	send("_G","error")
end

while true do
    local rid, msg = rednet.receive("csm",1)
    if not busy and type(msg)=="table" and type(msg[1])=="number" then
        local tid = msg[1]
        local width = msg[2]
        if rid==opID or rid==reID then
			term.clear()
            busy = true
            rednet.send(opID,"busy","csm")
            rednet.send(reID,"busy","csm")
			term.writeAt("Server Status: Busy",1,1)
			term.writeAt("Connected To ID: "..rid,1,3)
        end
        if rid==opID then
            term.writeAt("Connection Type: Operator",1,2)
            shell.run("operate",tid,width)
        elseif rid==reID then
            term.writeAt("Connection Type: Registration",1,2)
			id = tid
			sendSpecial("impSto","rcm","window","create",{"func","term","current"},0,0,10,10,true)
			sendSpecial("impRcl","rcm","setBackgroundColor",colors.lightGray)
            shell.run("register",tid,width)
        end
    end
	if not connected() and busy then
		disconnect()
	end
end