rednet.open("back")
os.loadAPI("touchpoint")

busy = false

options = {}

opID = 422
reID = 425

rcm = window.create(term,0,0,10,0)

function maxLen(t)
	local max = 0
	for _, s in pairs(t) do
		max = #s>max and #s or max
	end
	return max
end

function send(...)
    rednet.send(id, {...},"csm")
end

function moreOptions(x,y)
	rcm.reposition(x,y,maxLen(options),#options)
end

function disconnect()

end

while true do
    local id, msg = rednet.receive()
    if not busy and type(msg)=="table" and type(msg[1])=="number" then
        local tid = msg[1]
        local width = msg[2]
        if id==opID or id==reID then
            busy = true
            rednet.broadcast("busy","csm")
        end
        if id==opID then
            print("Received connection from Operator")
            print("Connected to ID:"..tid)
            shell.run("operate",tid,width)
        elseif id==reID then
            print("Received connection from Registration")
            print("Connected to ID: "..tid)
            print()
            shell.run("register",tid,width)
        end
    end
end