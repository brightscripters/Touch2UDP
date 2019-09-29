Function touch2udp_Initialize(msgPort As Object, userVariables As Object, bsp as Object)


    print "Touchscreen to UDP Plugin by Bright Scripters"

    touch2udp = newtouch2udp(msgPort, userVariables, bsp)
    return touch2udp

End Function


Function newtouch2udp(msgPort As Object, userVariables As Object, bsp as Object)

    ' SET UDP PORT HERE
    UDP_PORT = 21075 

	s = {}
	s.version = 0.1
	s.msgPort = msgPort
	s.userVariables = userVariables
	s.bsp = bsp
	s.ProcessEvent = touch2udp_ProcessEvent
	s.objectName = "touch2udp_object"
	s.debug  = true
	
    vm = CreateObject("roVideoMode")

    t=CreateObject("roTouchScreen")
    t.SetPort(msgPort)
    t.AddRectangleRegion(0,0,vm.GetResX(),vm.GetResY(),2)	

    s.sender = CreateObject("roDatagramSender")
    s.sender.SetDestination("255.255.255.255", UDP_PORT)

        if userVariables["UdpPort"] <> invalid then userVariables["UdpPort"]["CurrentValue$"] = UDP_PORT

    
    s.sender.Send("Bright Scripters")    
    
    print "Touch2UDP is here"
	return s
	
End Function

Function touch2udp_ProcessEvent(event As Object) as boolean

	
	retval = false

	if type(event) = "roTouchEvent"

		print "Touch Event ", event.GetX(), event.GetY()

        MsgObj = {}
        MsgObj["x"] = event.GetX()
        MsgObj["y"] = event.GetY()
        
        Msg$ = FormatJSON(MsgObj)
        m.sender.Send(Msg$)  

            if m.userVariables["UdpMessage"] <> invalid then m.userVariables["UdpMessage"]["CurrentValue$"] = Msg$

	end if

	return retval

End Function



Function Parsetouch2udpPluginMsg(origMsg as string, s as object) as boolean
	retval  = false
	command = ""
		
	' convert the message to all lower case for easier string matching later
	msg = lcase(origMsg)
	print "Received Plugin message: "+msg
	r = CreateObject("roRegex", "^touch2udp", "i")
	match=r.IsMatch(msg)

	if match then
		retval = true

		' split the string
		r2 = CreateObject("roRegex", "!", "i")
		fields=r2.split(msg)
		numFields = fields.count()
		if (numFields < 2) or (numFields > 2) then
			s.bsp.diagnostics.printdebug("Incorrect number of fields for touch2udp command:"+msg)
			return retval
		else if (numFields = 2) then
			command=fields[1]
		end if
	end if

	s.bsp.diagnostics.printdebug("command found: " +command)

	if command = "SomeCommand" then

	endif
	
	return retval
end Function





