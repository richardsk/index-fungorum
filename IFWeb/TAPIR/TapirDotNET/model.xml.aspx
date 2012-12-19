
	<%@ Page language="c#" %>
	
	<script runat="server" language="c#">
	
		public TpRequest request;
		public object resource_code;
		public object r_resources;
		public bool raise_errors;
		public object r_resource;
		public object r_local_mapping;
		public Utility.OrderedMap r_mapped_schemas;
		public Utility.OrderedMap concepts;
		public Utility.OrderedMap r_concepts;
		public int i;
		public string pth;
		public bool tmp;
		public string current_include_path;
		public string revision_regexp;
		public string root_dir;
		public string msg;
		public string revision;
		public bool res;
		public Utility.OrderedMap matches;
	</script>
	
	
	<%
		 /**
		* model.xml.aspx 
		*
		* LICENSE INFORMATION
		*
		* This program is free software; you can redistribute it and/or
		* modify it under the terms of the GNU General Public License
		* as published by the Free Software Foundation; either version 2
		* of the License, or (at your option) any later version.
		*
		* This program is distributed in the hope that it will be useful,
		* but WITHOUT ANY WARRANTY; without even the implied warranty of
		* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
		* GNU General Public License for more details:
		*
		* http://www.gnu.org/copyleft/gpl.html
		*
		*
		* @author Kevin Richards <richardsk [at] landcareresearch . co . nz>
		*/
		
	%>
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "tapir_globals.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpRequest.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpResources.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpResource.aspx" -->
	<!--CONVERSION_WARNING: Language construct 'require_once' was converted to '#include' which has a different behavior.-->
	<!-- #include file = "TpLocalMapping.aspx" -->
	<%
		
		if (!(Request["a"] != null))
		{
			Utility.MiscSupport.End("Parameter \"a\" (accesspoint) not specified");
		}
		
		if (!(Request["c"] != null))
		{
			Utility.MiscSupport.End("Parameter \"c\" (concept id) not specified");
		}
		
		if (!(Request["v"] != null))
		{
			Utility.MiscSupport.End("Parameter \"v\" (filter value) not specified");
		}
		
		// Instantiate request object to get resource code
		request = new TpRequest();
		
		// If no resource was specified in the request URI, display error
		if (!Utility.TypeSupport.ToBoolean(request.ExtractResourceCode(Request["a"])))
		{
			Utility.MiscSupport.End("Could not determine resource");
		}
		
		// Get resource code and check if it's valid
		resource_code = request.GetResourceCode();
		
		r_resources = & new TpResources().GetInstance();
		
		raise_errors = false;
		r_resource = & r_resources.GetResource(resource_code, raise_errors);
		
		if (r_resource == null)
		{
			Utility.MiscSupport.End("Could not find resource \"" + Utility.TypeSupport.ToString(resource_code) + "\"");
		}
		
		// Get all mapped concepts
		r_local_mapping = & r_resource.GetLocalMapping();
		
		r_local_mapping.LoadFromXml(r_resource.GetConfigFile());
		
		r_mapped_schemas = & r_local_mapping.GetMappedSchemas();
		
		concepts = new Utility.OrderedMap();
		
		
		Response.AppendHeader("Content-type: text/xml", "");
		
		
	%><outputModel xmlns="http://rs.tdwg.org/tapir/1.0"
	             xmlns:xs="http://www.w3.org/2001/XMLSchema"
	             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	             xsi:schemaLocation="http://rs.tdwg.org/tapir/1.0
	                                 http://rs.tdwg.org/tapir/1.0/tapir.xsd
	                                 http://www.w3.org/2001/XMLSchema
	                                 http://www.w3.org/2001/XMLSchema.xsd">
	  <structure>
	    <xs:schema targetNamespace="http://tapirdotnet/model/search/default">
	      <xs:element name="records">
	        <xs:complexType>
	          <xs:sequence>
	            <xs:element name="record" minOccurs="0" maxOccurs="unbounded">
	              <xs:complexType>
	                <xs:sequence>
	                  <%i = 0;
	%>
	                  <%%>
	                </xs:sequence>
	              </xs:complexType>
	            </xs:element>
	          </xs:sequence>
	          <xs:attribute name="concept" type="xs:string" use="required" default="<%Response.Write(Request["c"]);
	%>"/>
	          <xs:attribute name="value" type="xs:string" use="required" default="<%Response.Write(Request["v"]);
	%>"/>
	        </xs:complexType>
	      </xs:element>
	    </xs:schema>
	  </structure>
	  <indexingElement path="/records/record"/>
	  <mapping>
	    <%i = 0;%>
	  </mapping>
	 </outputModel>
	