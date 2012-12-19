<%
strIP = request.servervariables("REMOTE_ADDR")
    if strIP = "::1" then
        Session("loggedin") = True
		response.redirect "IndexFungorumPublishNamePreselect.asp"	
    end if
	strA = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strA)-1)
	strB = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strB)-1)
	strC = left(strIP,instr(strIP,".")-1)
	strIP = right(strIP,len(strIP) - len(strC)-1)
	strD = strIP
	if strA = "999" and strB = "168" and strC = "0" then
		Session("loggedin") = True
		response.redirect "IndexFungorumPublishNamePreselect.asp"
	elseif strA = "999" and strB = "172" and strC = "195" and strD = "133" then
		Session("loggedin") = True
		response.redirect "IndexFungorumPublishNamePreselect.asp"	
	else
		response.redirect "login2.asp"
	end If
%>