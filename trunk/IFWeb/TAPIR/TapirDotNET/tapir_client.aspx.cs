using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Net;
using System.IO;

namespace TapirDotNET
{
	/**
	* $Id: tapir_client.aspx 170 2007-01-24 22:26:25Z rdg $
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

	public partial class tapir_client : System.Web.UI.Page
	{		

		// Accesspoint
		protected Utility.OrderedMap local_accesspoints = new Utility.OrderedMap();
						
		// Operation
		protected Utility.OrderedMap operations = new Utility.OrderedMap(new object[]{"ping", "Ping"}, new object[]{"capabilities", "Capabilities"}, new object[]{"metadata", "Metadata"}, new object[]{"inventory", "Inventory"}, new object[]{"search", "Search"});
			
		// Encodings
		protected Utility.OrderedMap encodings = new Utility.OrderedMap(new object[]{"RAWPOST", "RAW POST"}, new object[]{"GET", "GET w/ request parameter"}, new object[]{"POST", "POST w/ request parameter"});
			

		#region Web Form Designer generated code
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: This call is required by the ASP.NET Web Form Designer.
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{    
			this.PreRender += new EventHandler(tapir_client_PreRender);
			this.sendButton.Click += new EventHandler(sendButton_Click);
		}
		#endregion


		protected void Page_Load(object sender, System.EventArgs e)
		{	
			// Show form when user didn't click on submit button		
			if (!Page.IsPostBack)
			{
				TpResources rResourcesManager = new TpResources().GetInstance();
			
				Utility.OrderedMap resources = rResourcesManager.GetActiveResources();
				foreach( TpResource res in resources.Values)
				{
					local_accesspoints[res.GetAccesspoint()] = res.GetAccesspoint();
				}			
			}
		}
	
		private void tapir_client_PreRender(object sender, EventArgs e)
		{

		}

		private void sendButton_Click(object sender, EventArgs e)
		{
			if (Page.IsPostBack)
			{
				try
				{
					string url = (string)TpUtils.GetVar("local_accesspoint", "");
			
					string body = requestText.Text.Replace("\\\"", "\"");
							
					WebRequest http_request;
			
					string type = (string)TpUtils.GetVar("encoding", "");

					if (type == "GET")
					{
						url += "?request=" + HttpUtility.UrlEncode(body);

						http_request = WebRequest.Create(url);
						http_request.Method = "GET";					
					}
					else
					{
						http_request = WebRequest.Create(url);
						http_request.Method = "POST";
				
						if (type == "RAWPOST")
						{
							http_request.ContentType = "text/xml";					
							Byte[] b = System.Text.Encoding.UTF8.GetBytes(body);
							http_request.ContentLength = b.Length;

							Stream s = http_request.GetRequestStream();
							s.Write(b, 0, b.Length);	
							s.Close();
						}
						else
						{
							body = "request=" + body;
							http_request.ContentType = "application/x-www-form-urlencoded";
							Byte[] b = System.Text.UTF8Encoding.UTF8.GetBytes(body);
							http_request.ContentLength = b.Length;
							
							Stream s = http_request.GetRequestStream();
							s.Write(b, 0, b.Length);	
							s.Close();
						}
					}
						
					WebResponse res = http_request.GetResponse();
			
					StreamReader rdr = new StreamReader(res.GetResponseStream());

					string result = rdr.ReadToEnd();
					rdr.Close();

					// This can be used to see the entire request
					//$raw_request = $http_request->_buildRequest();
			
					Response.ContentType = "text/xml";
					Response.Write(result);					
				}
				catch(Exception ex)
				{
					Response.Write(ex.Message + ":" + ex.StackTrace);
				}
			
				try
				{
					Response.End();
				}
				catch(Exception){}
			}
		}

	}
}
