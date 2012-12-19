using System;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;

namespace TapirDotNET.Controls
{
	/// <summary>
	///		Summary description for TpWizardForm.
	/// </summary>
	public class TpWizardForm : TpPage
	{		
		public bool mWizardMode;
		public int mNumSteps = 6;
		public int mStep = -1;
		public string mLabel = "unlabelled step";
		public bool mDone = false;
		public TpResource mResource;// to be defined by subclasses
						
		public virtual bool Initialize(TpResource rResource)
		{
			string error;
			if (rResource == null)
			{
				error = "Could not initialize form with a null resource!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			this.mResource = rResource;
			
			if (this.mResource.IsNew())
			{
				this.mWizardMode = true;
			}
			
			string form = HttpContext.Current.Request.Params["form"];
			if (form == null) form = (string)HttpContext.Current.Session["form"];
			if (form != null)
			{
				if (HttpContext.Current.Request.Form["form"] != null) 
				{
					// Here user can be opening a form for the first time
					// or refreshing the same form on subsequent operations.
					if (HttpContext.Current.Request.HttpMethod == "GET")
					{
						// Here the resource should never be new
						this.LoadFromXml();
						return true;
					}
					else
					{
						// Here it can be a new or an existing resource
						this.LoadFromSession();
						return true;
					}
				}
				else
				{
					// In this case, resource should always be new and user is coming 
					// from a previous step, so load defaults
					this.LoadDefaults();
					return true;
				}
			}
			else
			{
				// Here user is resuming a wizard process previously interrupted
				// TpConfigManager guessed the form. Resource should be always new here.
				
				// Note: LoadDefaults should usually check if there's any existing 
				// configuration, and in that case call LoadFromXml
				this.LoadDefaults();
				return true;
			}
		}// end of member function Initialize
		
		public virtual void  LoadDefaults()
		{
			// To be used by subclasses
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			// To be used by subclasses
		}// end of member function LoadFromSession
		
		public virtual void  LoadFromXml()
		{
			// To be used by subclasses
		}// end of member function LoadFromXml
		
		public virtual void  HandleEvents()
		{
			// To be used by subclasses
		}// end of member function HandleEvents
		
		public virtual bool Done()
		{
			// Property needs to be set in method handleEvents of subclasses
			return this.mDone;
		}// end of member function Done
		
		public virtual bool ReadyToProceed()
		{
			return true;
		}// end of member function ReadyToProceed
						
		
		public virtual int GetStep()
		{
			return this.mStep;
		}// end of member function GetStep
		
		public virtual int GetNumSteps()
		{
			return this.mNumSteps;
		}// end of member function GetNumSteps
		
		public virtual string GetLabel()
		{
			return this.mLabel;
		}// end of member function GetLabel
		
		public virtual string GetResourceId()
		{
			if (this.mResource == null)
			{
				return "undefined";
			}
			
			return this.mResource.GetCode();
		}// end of member function GetResourceId
		
		public virtual bool InWizardMode()
		{
			return this.mWizardMode;
		}// end of member function InWizardMode
	}
}
