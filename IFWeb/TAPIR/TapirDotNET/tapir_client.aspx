<%@ Page validateRequest=false language="c#" Codebehind="tapir_client.aspx.cs" AutoEventWireup="True" Inherits="TapirDotNET.tapir_client" %>

<html>
	<head>
	<title>TapirDotNET XML Client</title>
	<script language='javascript'>
		function getDefaultRequest()
		{
			var header = '  <header>\n'
		+'    <source sendtime="2005-11-11T12:23:56.023+01:00">\n'
		+'      <software name="tapir_client.aspx" version="1.0"/>\n'
		+'    </source>\n'
		+'  </header>\n';
	
			var operation = document.forms[0].operation.value;
	
			var body;
	
			switch ( operation ) 
		{
				case 'ping':
			
					body = '  <ping />\n';
					break;
			
				case 'capabilities':
			
					body = '  <capabilities />\n';
					break;
			
				case 'metadata':
			
					body = '  <metadata />\n';
					break;
			
				case 'inventory':
			
					body = '  <inventory count="true" start="0" limit="20">\n'
		+'    <concepts>\n'
		+'      <concept id="http://rs.tdwg.org/dwc/dwcore/ScientificName" />\n'
		+'    </concepts>\n'
		+'  </inventory>\n';
					break;
			
				case 'search':
			
					body = '  <search count="true" start="0" limit="20" envelope="true">\n'
		+'    <outputModel>\n'
		+'      <structure>\n'
		+'        <xs:schema targetNamespace="http://example.net/simple_specimen" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:schemaLocation="http://www.w3.org/2001/XMLSchema http://www.w3.org/2001/XMLSchema.xsd">\n'
		+'          <xs:element name="records">\n'
		+'            <xs:complexType>\n'
		+'              <xs:sequence>\n'
		+'                <xs:element name="record" minOccurs="0" maxOccurs="unbounded" type="unitType">\n'
		+'                </xs:element>\n'
		+'              </xs:sequence>\n'
		+'            </xs:complexType>\n'
		+'          </xs:element>\n'
		+'          <xs:complexType name="unitType">\n'
		+'            <xs:sequence>\n'
		+'              <xs:element name="name" type="xs:string"/>\n'
		+'              <xs:element name="author" type="xs:string" minOccurs="0"/>\n'
		+'            </xs:sequence>\n'
		+'            <xs:attribute name="catnum" type="xs:int" use="required"/>\n'
		+'          </xs:complexType>\n'
		+'        </xs:schema>\n'
		+'      </structure>\n'
		+'      <indexingElement path="/records/record"/>\n'
		+'      <mapping>\n'
		+'        <node path="/records/record/@catnum">\n'
		+'          <concept id="http://rs.tdwg.org/dwc/dwcore/CatalogNumber"/>\n'
		+'        </node>\n'
		+'        <node path="/records/record/name">\n'
		+'          <concept id="http://rs.tdwg.org/dwc/dwcore/ScientificName"/>\n'
		+'        </node>\n'
		+'        <node path="/records/record/author">\n'
		+'          <concept id="http://rs.tdwg.org/dwc/dwcore/AuthorYearOfScientificName"/>\n'
		+'        </node>\n'
		+'      </mapping>\n'
		+'    </outputModel>\n'
		+'    <filter>\n'
		+'      <and>\n'
		+'        <equals>\n'
		+'          <concept id="http://rs.tdwg.org/dwc/dwcore/Genus"/>\n'
		+'          <literal value="Astyanax"/>\n'
		+'        </equals>\n'
		+'        <not>\n'
		+'          <isnull>\n'
		+'            <concept id="http://rs.tdwg.org/dwc/dwcore/ScientificName"/>\n'
		+'          </isnull>\n'
		+'        </not>\n'
		+'      </and>\n'
		+'    </filter>\n'
		+'    <orderBy>\n'
		+'      <concept id="http://rs.tdwg.org/dwc/dwcore/ScientificName" descend="true"/>\n'
		+'    </orderBy>\n'
		+'  </search>\n';
					break;
			}
				
			var xmlRequest = '<?xml version="1.0" encoding="UTF-8" ?>\n'
		+'<request \n'
		+'    xmlns="http://rs.tdwg.org/tapir/1.0"\n'
		+'    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\n'
		+'    xsi:schemaLocation="http://rs.tdwg.org/tapir/1.0 \n'
		+'                        http://rs.tdwg.org/tapir/1.0/schema/tapir.xsd">\n'
		+ header 
		+ body 
		+ '</request>\n';
					
			document.forms[0].requestText.value = xmlRequest;
				}
	</script>
			
	</head>
			
	<body onload="getDefaultRequest()">
		<h1>TapirDotNET XML Client</h1>
			
		<form runat="server" id= "Form1" action="tapir_client.aspx" method=post target=_blank>
			<b>Accesspoint:</b> 
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("local_accesspoint", TapirDotNET.TpUtils.GetVar("local_accesspoint", local_accesspoints.Current), local_accesspoints, false, 0, ""));%>
			<br />
			<br />
			<b>Operation:</b> 
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("operation", TapirDotNET.TpUtils.GetVar("operation", "ping"), operations, false, false, "getDefaultRequest()"));%>
			<br />
			<br/>
			<b>Request encoding:</b> 
			<%Response.Write(new TapirDotNET.TpHtmlUtils().GetCombo("encoding", TapirDotNET.TpUtils.GetVar("encoding", "rawpost"), encodings, false, 0, ""));%>
			<br />
			<br />
			<b>XML Request:</b> <br />
			
			<asp:TextBox ID="requestText" TextMode=MultiLine Runat=server Columns="120" rows="18"></asp:TextBox>
			<br />
			
			<asp:Button ID="sendButton" Runat=server Text="Send request"></asp:Button>
		
			<asp:Button ID="resetButton" Runat=server Text="Reset"></asp:Button>
		
		</form>
	</body>
</html>
