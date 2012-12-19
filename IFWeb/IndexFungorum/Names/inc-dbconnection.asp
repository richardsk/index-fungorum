<%
Dim objConn
Set objConn = Server.CreateObject("ADODB.Connection")
objConn.Open "Provider=SQLOLEDB.1;Password=;Integrated security=SSPI;User ID=IUSR_KIRK-WEBSERVER;Initial Catalog=Kerstin;Data Source=KIRK-WEBSERVER"
%>
