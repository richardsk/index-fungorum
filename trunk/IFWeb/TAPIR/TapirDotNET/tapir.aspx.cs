using System;
using System.Web;
using System.Web.UI.WebControls;
using System.Net;
using System.IO;
using System.Xml;
using System.Data.OleDb;
using System.Data;


		/**
		* $Id: tapir.aspx 252 2007-02-14 13:25:58Z rdg $
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
		* @author Dave Vieglais (Biodiversity Research Center, University of Kansas)
		*
		* ACKNOWLEDGEMENTS
		*
		* TapirDotNET has been generously funded by the Biodiversity
		* Information Standards, TDWG, with resources from the Gordon and
		* Betty Moore Foundation. The Global Biodiversity Information
		* Facility, GBIF, has also been a major supporter of the TAPIR
		* initiative since its very beginning and also collaborated to
		* test this software.
		*
		* --------------------------------
		*
		* Copyright (c) 2002 Landcare Research New Zealand
		* All rights reserved.
		*
		* Permission is hereby granted, free of charge, to any person
		* obtaining a copy of this software and associated documentation
		* files (the "Software"), to deal with the Software without
		* restriction, including without limitation the rights to use,
		* copy, modify, merge, publish, distribute, sublicense, and/or
		* sell copies of the Software, and to permit persons to whom the
		* Software is furnished to do so, subject to the following
		* conditions:
		*
		* - Redistributions of source code must retain the above copyright
		* notice, this list of conditions and the following disclaimers.
		*
		* - Redistributions in binary form must reproduce the above
		* copyright notice, this list of conditions and the following
		* disclaimers in the documentation and/or other materials provided
		* with the distribution.
		*
		* - Neither the names of Landcare Research, nor the names of its 
		* contributors may be used to endorse or promote products derived 
		* from this Software without specific prior written permission.
		*
		* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
		* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
		* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
		* NONINFRINGEMENT. IN NO EVENT SHALL THE CONTRIBUTORS OR COPYRIGHT
		* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
		* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
		* DEALINGS IN THE SOFTWARE.
		*
		* @author Kevin Richards richardsk [at] landcareresearch . co . nz
		*/


namespace TapirDotNET
{
	/// <summary>
	/// Summary description for configurator.
	/// </summary>
	public partial class tapir : System.Web.UI.Page
	{		
		public object g_dlog;
		public TpRequest tpRequest;
		public string resource_code;
		public TpResources r_resources;
		public bool raise_errors;
		public TpResource r_resource;
		public TpResponse tpResponse;
		public string current_version;
		public string msg;
		public string operation;
		public TpResources resources;
		public string pth;
		public bool tmp;
		public string current_include_path;
		public string root_dir;
		public string revision;
		public bool res;
		public string revision_regexp;
		public Utility.OrderedMap matches;



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
			this.Load += new EventHandler(tapir_Load);

		}
		#endregion

		public tapir()
		{
		}

		private void tapir_Load(object sender, EventArgs e)
		{		
			try
			{
				Response.AppendHeader("Pragma: no-cache", "");
				new TpDiagnostics().Reset();

				// Instantiate a manager for configuration
				TpConfigManager config_manager = new TpConfigManager();
				
				config_manager.CheckEnvironment();


				// Avoid HTML in errors
				TpConfigManager.INITIAL_TIMESTAMP = TpUtils.MicrotimeFloat();
		
				// Logs
				TpLog.InitialiseLogs();
			
		
				//TODO log
				//g_dlog.debug("[Starting debug log]");
				//g_dlog.debug("TapirDotNET version: " + TP_VERSION + " (revision " + TP_REVISION + ")");
				//g_dlog.debug("Request URI: " + Utility.TypeSupport.ToString(Request.RawUrl));
				//g_dlog.debug("Include path: " + (string) System.Configuration.ConfigurationSettings.GetConfig("include_path"));
		
						
				// Debugging
				// Load the value from a request variable called "debug", default is false
				// for security reasons
				if (System.Configuration.ConfigurationSettings.AppSettings["TP_ALLOW_DEBUG"] == "true")
				{
					TpConfigManager._DEBUG = Utility.TypeSupport.ToBoolean(TpUtils.GetVar("debug", false));
				}
				else
				{
					TpConfigManager._DEBUG = false;
				}
		
				//OAI PMH request?
				if (Request["verb"] != null && Request["verb"].Length > 0)
				{
					TapirDotNET.OAI_PMHRequest.HandleOAIPMHRequest();
					return;
				}
		
				// Instantiate request object
				tpRequest = new TpRequest();
		
				// If no resource was specified in the request URI, then dump some help information
				if (!tpRequest.ExtractResourceCode(Request.Url.AbsoluteUri))
				{
					Response.Redirect("index.aspx", true);
					return;
				}
		
				// Get resource code and check if it's valid
				resource_code = tpRequest.GetResourceCode();
		
				r_resources = new TpResources().GetInstance();
		
				raise_errors = false;
			
				r_resource = r_resources.GetResource(resource_code, raise_errors);
		
				if (r_resource == null)
				{
					tpResponse = new TpResponse(tpRequest);
					tpResponse.Init();
					tpResponse.ReturnError("Resource \"" + resource_code + "\" not found.");
				}
		
				if (r_resource.GetStatus() != "active")
				{
					tpResponse = new TpResponse(tpRequest);
					tpResponse.Init();
					tpResponse.ReturnError("Resource \"" + resource_code + "\" is not active.");
				}
		
				//TODO check .NET version??

				// Get parameters
				if (!tpRequest.InitializeParameters() || new TpDiagnostics().Count(new Utility.OrderedMap(TpConfigManager.DIAG_ERROR, TpConfigManager.DIAG_FATAL)) > 0)
				{
					tpResponse = new TpResponse(tpRequest);
					tpResponse.Init();
					tpResponse.ReturnError("Failed to parse request");
				}
		
				operation = tpRequest.GetOperation();
		
				if (operation == "ping")
				{			
					tpResponse = new TpPingResponse(tpRequest);
				}
				else if (operation == "capabilities")
				{
					tpResponse = new TpCapabilitiesResponse(tpRequest);
				}
				else if (operation == "metadata")
				{
					tpResponse = new TpMetadataResponse(tpRequest);
				}
				else if (operation == "inventory")
				{
					tpResponse = new TpInventoryResponse(tpRequest);
				}
				else if (operation == "search")
				{
					tpResponse = new TpSearchResponse(tpRequest);
				}
				else
				{
					// Unknown operation 
					tpResponse = new TpResponse(tpRequest);
					tpResponse.Init();
					tpResponse.ReturnError("Unknown operation \"" + operation + "\"");
				}
		
				tpResponse.Process();
				
				//Response.End();
			}
			catch(Exception ex)
			{
				TpLog.debug("Error : " + ex.Message + " : " + ex.StackTrace);	
				string m = ex.Message;
				Response.Write("<ServerError>Incorrect message format, or unhandled exception.</ServerError>");
				//Response.StatusCode = 500;
			}
		}
	}
}
