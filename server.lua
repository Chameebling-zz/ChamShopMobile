rednet.open("back")
os.loadAPI("touchpoint")

busy = false

options = {}

opID = 422
reID = 425

function maxLen(t)
	local max = 0
	for _, s in pairs(t) do
		max = #s>max and #s or max
	end
	return max
end

function send(...)
	if not id then
		error("no id specified", 2)
	end
    rednet.send(id, {...},"csm")
	repeat
		local rid, msg = rednet.receive("csm",1)
	until rid==id
	return msg
end

function moreOptions(x,y)
	rcm.reposition(x,y,maxLen(options),#options)
end

function disconnect()

end

while true do
    local rid, msg = rednet.receive()
    if not busy and type(msg)=="table" and type(msg[1])=="number" then
        local tid = msg[1]
        local width = msg[2]
        if rid==opID or rid==reID then
            busy = true
            rednet.broadcast("busy","csm")
        end
        if rid==opID then
            print("Received connection from Operator")
            print("Connected to ID:"..tid)
            shell.run("operate",tid,width)
        elseif rid==reID then
            print("Received connection from Registration")
            print("Connected to ID: "..tid)
            print()
			id = tid
			rcm = send("window","create",{"_G","term"},0,0,10,10,true)
            shell.run("register",tid,width)
        end
    end
end