using System;
using System.Configuration;
using System.Security.Principal;
using System.Text;
using System.Web;
using System.Xml;
using System.IO;

using LSIDClient;
using LSIDFramework;

namespace AuthorityWebService
{
	/** 
	* Handles the authentication for the LSID authority.
	*
	* This HTTP Module is designed to support HTTP Basic authentication,
	* without using the built-in IIS implementation.  The IIS implementation
	* can only authenticate against the Active Directory store; but in
	* many applications, one would rather authenticate against a separate
	* database.
	*
	* The implementation was designed particularly for web services, but 
	* should suffice for any web application.  For a non-service application,
	* one obvious change would be to support a redirection on a failed login,
	* to display a more friendly message to the user.
	*
	* The credential store in this version is a simple XML file (sample in
	* users.xml).  In a real application, you would probably want to modify
	* this to use a database or LDAP store.  An easy way to do this would be
	* to derive from Rassoc.BasicAuthenticationModule and override the 
	* AuthenticateUser function.
	*
	* Usage:
	*
	* (Assuming ASP.NET) 
	* 1. Copy BasicAuthMod.dll to your ASP.NET application's bin directory.
	* 2. Make the following changes to your web.config file (within <system.web>):
	*     - change authentication line to: <authentication mode="None" /> 
	*     - add an authorization section if you wish, such as
	*         <authorization>
	*           <deny users="?" />
	*         </authorization>
	*     - add the following lines:
	*         <httpModules>
	*           <add name="BasicAuthenticationModule" 
	*                type="[namespace].BasicAuthenticationModule,[dll name]" />
	*         </httpModules>   
	* 3. Add the following to your web.config (within <configuration>):
	*         <appSettings>
	*           <add key="[namespace].BasicAuthenticationModule_Realm" value="[realm]" />
	*         </appSettings>

	* @author Kevin Richards (<a href="mailto:richardsk@landcareresearch.co.nz">richardsk@landcareresearch.co.nz</a>)
	*
	*/
	public class BasicAuthenticationModule : IHttpModule
	{		
		public static LSIDRequestContext LSIDRequest = null;
		public static LSIDAuthenticationException AuthException = null;
		public static LSIDCredentials RequestCredentials = null;

		public BasicAuthenticationModule()
		{
		}

		public void Dispose()
		{
		}

		public void Init(HttpApplication application)
		{
			application.AuthenticateRequest += new EventHandler(this.OnAuthenticateRequest);
			application.EndRequest += new EventHandler(this.OnEndRequest);
		}

		public void OnAuthenticateRequest(object source, EventArgs eventArgs)
		{
			//no current credentials by default
			LSIDRequest = new LSIDRequestContext();
			RequestCredentials = new LSIDCredentials();

			HttpApplication app = (HttpApplication) source;

			string lsidStr = app.Request.QueryString.Get("lsid");
			if (lsidStr != null) LSIDRequest.Lsid = new LSIDClient.LSID(lsidStr);
     
			LSIDRequest.ReqUrl = app.Request.Url.GetLeftPart(UriPartial.Path);
      
			string hint = app.Request.PathInfo;
			if (hint != null && hint.Length > 0 && hint[0] == '/')
			{
				LSIDRequest.Hint = hint; 
			}


			//for authorities that want to authorize by IP :
			RequestCredentials.setProperty("IPAddress", app.Request.UserHostAddress);						

			string authStr = app.Request.Headers["Authorization"];

			string[] roles;
			if (authStr == null || authStr.Length == 0)
			{
				// No credentials; anonymous request
				// or POST request, ie SOAP
				//try authroization by IP only
				AuthenticateUser(app, "", "", LSIDRequest.Lsid, out roles);
				return;
			}
			    

			authStr = authStr.Trim();
			if (authStr.IndexOf("Basic",0) != 0)
			{
				// Don't understand this header...we'll pass it along and 
				// assume someone else will handle it
				return;
			}

			string encodedCredentials = authStr.Substring(6);

			byte[] decodedBytes = Convert.FromBase64String(encodedCredentials);
			string s = new ASCIIEncoding().GetString(decodedBytes);

			string[] userPass = s.Split(new char[] {':'});
			string username = userPass[0];
			string password = userPass[1];

			RequestCredentials.setProperty(LSIDCredentials.BASICUSERNAME, username);
			RequestCredentials.setProperty(LSIDCredentials.BASICPASSWORD, password);

			//if HTTP SOAP/POST then authenticate later using details from SOAP message
			if (app.Request.RequestType == "POST") return;

			if (AuthenticateUser(app, username, password, LSIDRequest.Lsid, out roles))
			{
				app.Context.User = new GenericPrincipal(new GenericIdentity(username, "LSID.Basic"), roles);
			}
			else
			{
				// Invalid credentials; deny access
				DenyAccess(app, LSIDRequest.Lsid);
				return;
			}
		}

		public void OnEndRequest(object source, EventArgs eventArgs)
		{
			// We add the WWW-Authenticate header here, so if an authorization 
			// fails elsewhere than in this module, we can still request authentication 
			// from the client.

			HttpApplication app = (HttpApplication) source;
			if (app.Response.StatusCode == 401)
			{
				string realm = "LSID";
				string val = String.Format("Basic Realm=\"{0}\"",realm);
				app.Response.AppendHeader("WWW-Authenticate",val);
			}
		}

		private void DenyAccess(HttpApplication app, LSID lsid)
		{
			Stream os = null;
			try 
			{
				String errorMsg = "LSID Authentication failed: ";
				String realm = null;
				if (LSIDRequest.AuthResponse != null) 
				{
					object respData = LSIDRequest.AuthResponse.ResponseData;
					if (respData != null)
						errorMsg += respData.ToString();
					else
						errorMsg += "No reason given";
					realm = LSIDRequest.AuthResponse.Realm;
					if (realm == null)
						realm = lsid.Authority.Authority + ":" + lsid.Namespace;
				} 
				else if (AuthException != null) 
				{
					realm = lsid.Authority.Authority + ":" + lsid.Namespace;
					StringWriter sw = new StringWriter();
					errorMsg += AuthException.ToString(); 
					LSIDException.WriteError(errorMsg);
				} 
				app.Response.AppendHeader(HTTPConstants.HEADER_REQUEST_AUTHORIZATION, "BASIC realm=\"" + realm + "\"");
				app.Response.AppendHeader(HTTPConstants.HEADER_LSID_ERROR_CODE, LSIDException.AUTHENTICATION_ERROR.ToString());
				app.Response.StatusCode = (int)System.Net.HttpStatusCode.Unauthorized; //HttpServletResponse.SC_UNAUTHORIZED);
				app.Response.ContentType = HTTPConstants.HTML_CONTENT;
				app.Response.Write(errorMsg);
			} 
			catch (IOException e) 
			{
				LSIDException.PrintStackTrace(e);
				throw new Exception("Could not get response outputstream");
			} 
			finally 
			{
				try 
				{
					if (os != null) 
					{
						os.Close();
					}
				} 
				catch (IOException e) 
				{
					LSIDException.PrintStackTrace(e);
				}
			}

			app.CompleteRequest();
		}

		protected virtual bool AuthenticateUser(HttpApplication app, string username, string password, LSID lsid, out string[] roles)
		{
			LSIDSecurityService security = null;
			if (lsid != null)
				security = (LSIDSecurityService) LSIDFramework.Global.AuthenticationRegistry.lookupService(lsid);

			AuthenticationResponse authResp = null;

			if (security != null) 
			{
				LSIDCredentials creds = new LSIDCredentials();
			
				creds.setProperty(LSIDCredentials.BASICUSERNAME, username);
				creds.setProperty(LSIDCredentials.BASICPASSWORD, password);
				creds.setProperty("IPAddress", app.Request.UserHostAddress);
				LSIDRequest.Credentials = creds;

				try 
				{
					authResp = security.authenticate(LSIDRequest);
				} 
				catch (LSIDAuthenticationException e) 
				{
					e.PrintStackTrace();
					AuthException = e;
				}
				LSIDRequest.AuthResponse = authResp;

			}

			if ((LSIDRequest.AuthResponse == null && AuthException == null) || LSIDRequest.AuthResponse.Success)
			{
				roles = new string[1];
				roles[0] = "LSIDUser"; //??Roles
				return true;
			}
			else
			{
				roles = null;
				return false;
			}


		}
	}
}
