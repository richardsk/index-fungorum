<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>HerbIMI-Online - label data</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript">
<!--

function popUp(URL) {
eval("page" + " = window.open(URL, '" + "', 'toolbar=0,scrollbars=1,location=0,statusbar=0,menubar=0,resizable=0,width=740,height=440,left=150,top=00');");
}
//-->
</script>
<link href="../StyleSheets/HerbIMI.css" rel="stylesheet" type="text/css">
<!--#include file="../Connections/DataAccess.asp"-->
<!--#include file="../Helpers/Utility.asp"-->
</head>
<body topmargin=0 bottommargin=0 leftmargin=0 rightmargin=0 bgcolor="#9CFF9C">
<a name="TopOfPage"></a> 
<table width="100%" height="100%" class="mainbody">
  <tr> 
    <td height="20"> 
      </td>
  </tr>
  <tr> 
    <td align="left" valign="top"><table width="100%" cellpadding="5">
        <tr> 
          <td bgcolor="#CCFFCC"> <%
dim strRecordID
if request.querystring("RecordID") <> "" then
	strRecordID = request.querystring("RecordID")
else
	response.write("No data to process")
end if

dim strSQL, dbConn, rs
	Set dbConn = Server.CreateObject("ADODB.Connection")
	strIP = request.servervariables("LOCAL_ADDR")
	if true then        
       strConn = GetConnectionString()
	   dbConn.connectiontimeout = 180
	   dbConn.commandtimeout = 180
	   dbConn.open strConn
	elseif strIP = "192.168.0.3" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "10.0.5.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_AINSWORTH;Initial Catalog=herbIMI;Data Source=AINSWORTH"
	   dbConn.open strConn
	elseif strIP = "194.203.77.76" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_EDWINBUTLER;Initial Catalog=herbIMI;Data Source=EDWINBUTLER"
	   dbConn.open strConn
	elseif strIP = "194.131.255.4" then
	   strConn = "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_INDEXFUNGORUM;Initial Catalog=herbIMI;Data Source=INDEXFUNGORUM"
	   dbConn.open strConn
	elseif strIP = "192.168.0.1" then
	   strConn="provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	elseif strIP = "127.0.0.1" then
	   strConn = "provider=microsoft.jet.oledb.4.0; data source=d:\databases\access\herbimi\herbimi.mdb"
	   dbConn.open strConn
	else
	   dbConn.open "FILEDSN=herbimi"
	end if
	if strIP = "10.0.5.4" then
		strSQL = "SELECT tblHerbIMI.IMInumber, tblHerbIMI.FinalNameDataEdited, tblHerbIMI.AssociatedOrganism, " _
			& "tblHerbIMI.Substratum, tblHerbIMI.DayOfCollection, tblHerbIMI.MonthOfCollection, tblHerbIMI.YearOfCollection, " _
			& "tblHerbIMI.SpecimenTypeStatus, tblHerbIMI.Vouchered, " _
			& "tblGeography.L4ISOcountry, tblGeography.L4country, tblGeography.Locality, " _
			& "tblGeography.L3area, tblGeography.L2region, tblGeography.L1continent " _
			& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.IMInumber = tblGeography.IMInumber " _
			& "WHERE ((tblHerbIMI.IMInumber) = '" & protectSQL(strRecordID,true) & "');"
	else
		strSQL = "SELECT tblHerbIMI.IMInumber, tblHerbIMI.NameOfFungus, tblHerbIMI.AssociatedOrganism, " _
			& "tblHerbIMI.Substratum, tblHerbIMI.Year, tblHerbIMI.SpecimenCulture, tblHerbIMI.TypeStatus, " _
			& "tblGeography.L4ISOcountry, tblGeography.L4country, tblGeography.Locality, " _
			& "tblGeography.L3area, tblGeography.L2region, tblGeography.L1continent " _
			& "FROM tblHerbIMI INNER JOIN tblGeography ON tblHerbIMI.IMInumber = tblGeography.IMInumber " _
			& "WHERE ((tblHerbIMI.IMInumber) = '" & protectSQL(strRecordID,true) & "');"
	end if
Set rs = Server.CreateObject("ADODB.Recordset")
rs.Open strSql, dbConn, 3
if not rs.bof then
	if strIP = "10.0.5.4" then
		IMInumber = rs("IMInumber")
		NameOfFungus = rs("FinalNameDataEdited")
		AssociatedOrganism = rs("AssociatedOrganism")
		Substratum = rs("Substratum")
		DayOfCollection = strn(rs("DayOfCollection"))
		MonthOfCollection = strn(rs("MonthOfCollection"))
		YearOfCollection = strn(rs("YearOfCollection"))
		SpecimenCulture = rs("Vouchered")
		TypeStatus = rs("SpecimenTypeStatus")
		L1continent = strn(rs("L1continent"))
		L2region = strn(rs("L2region"))
		L3area = strn(rs("L3area"))
		L4country = strn(rs("L4country"))
		L4ISOcountry = strn(rs("L4ISOcountry"))
		Locality = strn(rs("Locality"))
	else
		IMInumber = rs("IMInumber")
		NameOfFungus = rs("NameOfFungus")
		AssociatedOrganism = rs("AssociatedOrganism")
		Substratum = rs("Substratum")
		CollectionYear = rs("Year")
		SpecimenCulture = rs("SpecimenCulture")
		TypeStatus = rs("TypeStatus")
		L1continent = rs("L1continent")
		L2region = rs("L2region")
		L3area = rs("L3area")
		L4country = rs("L4country")
		L4ISOcountry = rs("L4ISOcountry")
		Locality = rs("Locality")
	end if
else
   response.write("No records found<br>")
end if
rs.close
set rs = nothing
dbConn.close
set dbConn = nothing

function strn(str)
	if isnull(str) then 
		strn = ""
	else
		strn = str
	end if  
end function
%> 
            <table width="100%" cellspacing="0" cellpadding="5">
              <tr> 
              </tr>
              <tr> 
                <td height="94" colspan="2" align="centre" valign="top"><div align="left"> 
                    <table width="100%">
                      <tr> 
                        <td width="15%" height="69"><font size="6"><img src="Images/CABILogo.gif" width="50" height="50"></font></td>
                        <td width="70%"><div align="center"><font size="7"><b>Herb. 
                            IMI</b></font></div></td>
                        <td width="15%">&nbsp;</td>
                      </tr>
                    </table>
                    <font color='#FF0000'><b> </b></font></div></td>
              </tr>
              <tr> 
                <td colspan="2" align="centre" valign="top"><div align="right"><font color='#FF0000'><b> 
                    <%response.write(TypeStatus)%>
                    </b></font></div></td>
              </tr>
              <tr> 
                <td colspan="2" align="left" valign="top"><div align="right">Herb. 
                    <b>IMI</b> 
                    <%response.write(IMInumber)%>
                  </div></td>
              </tr>
              <tr> 
                <td width="25%">Fungus Name:</td>
                <td width="75%"><b> 
                  <%response.write(NameOfFungus)%>
                  </b></td>
              </tr>
              <tr> 
                <td>Associated Organism: </td>
                <td width="75%"><b> 
                  <%response.write(AssociatedOrganism)%>
                  </b></td>
              </tr>
              <tr> 
                <td>Actually on:</td>
                <td width="75%"><b> 
                  <%response.write(Substratum)%>
                  </b></td>
              </tr>
              <tr> 
                <td>Locality:</td>
                <td width="75%"><b> 
                  <%
if L1continent <> "" then
	DataOut = L1continent
end if

if L2region <> "" then
	DataOut = DataOut & ": " & L2region
end if

if L3area <> "" then
	if L4country <> L3area then
		DataOut = DataOut & ": " & L3area
	end if
end if

if L4country <> "" then
	DataOut = DataOut & ": " & L4country
end if

if Locality <> "" and DataOut <> "" then
	DataOut = DataOut & ": " & Locality
else
	DataOut = Locality
end if
if DataOut = "" and L4ISOcountry <> "" then DataOut = L4ISOcountry
if DataOut <> "" then
	response.write(DataOut & "<br>")
else
	response.write("No locality data available")
	response.write(L4country & "<br>")
end if
%>
                  </b> </td>
              </tr>
              <tr> 
                <td>Date:</td>
                <td width="75%"><b> 
<%
	if DayOfCollection <> "" then strOut = DayOfCollection
	if MonthOfCollection <> "" then strOut = strOut & "/" & MonthOfCollection
	if YearOfCollection <> "" then strOut = strOut & "/" & YearOfCollection
response.write(strOut)
%>
                  </b></td>
              </tr>
              <tr> 
                <td>Notes:</td>
                <td width="75%"><b> 
                  <%response.write(Notes)%>
                  </b></td>
              </tr>
              <tr> 
                <td>&nbsp;</td>
                <td width="75%">&nbsp;</td>
              </tr>
              <tr> 
                <td><a href="javascript:window.close();">Close</a></td>
                <td width="75%">&nbsp;</td>
              </tr>
            </table>
          </td>
        </tr>
      </table></td>
  </tr>
  <tr> 
    <td height="10" class="Footer"> <font size="-1">&copy; 2004</font> <font size="1" face="Verdana, Arial, Helvetica, sans-serif" color="#333333"> 
      <a href="http://www.cabi.org/" target="_blank">CABI</a></font></td>
  </tr>
</table>
</body>
</html>
