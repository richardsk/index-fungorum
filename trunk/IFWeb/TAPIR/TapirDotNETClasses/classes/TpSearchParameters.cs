using System;
using System.Web;
using System.Xml;

namespace TapirDotNET 
{

	public class TpSearchParameters:TpOperationParameters
	{
		public TpOutputModel mOutputModel;
		public Utility.OrderedMap mPartial = new Utility.OrderedMap();
		public Utility.OrderedMap mOrderBy = new Utility.OrderedMap();
		
		public TpSearchParameters() : base()
		{
		}
		
		
		public override bool LoadKvpParameters()
		{
			// Output model
			string output_model = null;
			object partial = null;
			object orderby = null;
			object descend = null;
			int i;
			bool desc;
			
			if (HttpContext.Current.Request["model"] != null)
			{
				output_model = HttpContext.Current.Request["model"];
			}
			else
			{
				if (HttpContext.Current.Request["m"] != null)
				{
					output_model = HttpContext.Current.Request["m"];
				}
			}
			
			if (output_model != null)
			{
				this.LoadOutputModel(output_model);
			}
			
			// Partial
			if (HttpContext.Current.Request["partial"] != null)
			{
				partial = HttpContext.Current.Request["partial"];
			}
			else
			{
				if (HttpContext.Current.Request["p"] != null)
				{
					partial = HttpContext.Current.Request["p"];
				}
			}
			
			if (partial != null)
			{
				//TODO ?? 
				if (partial is Utility.OrderedMap)
				{
					this.mPartial = (Utility.OrderedMap)partial;
				}
				else if (partial is System.String)
				{
					this.mPartial.Push(partial);
				}
			}
			
			// Order by
			if (HttpContext.Current.Request["orderby"] != null)
			{
				orderby = HttpContext.Current.Request["orderby"];
			}
			else
			{
				if (HttpContext.Current.Request["o"] != null)
				{
					orderby = HttpContext.Current.Request["o"];
				}
			}
			
			// Ascending or descending
			if (HttpContext.Current.Request["descend"] != null)
			{
				descend = HttpContext.Current.Request["descend"];
			}
			else
			{
				if (HttpContext.Current.Request["d"] != null)
				{
					descend = HttpContext.Current.Request["d"];
				}
			}
			
			if (orderby != null)
			{
				if (orderby is Utility.OrderedMap)
				{
					i = 0;
					
					foreach ( string concept_id in Utility.TypeSupport.ToArray(orderby).Values ) 
					{
						desc = false;
						
						if (descend is Utility.OrderedMap && ((Utility.OrderedMap)descend)[i] != null)
						{
							string d = ((Utility.OrderedMap)descend)[i].ToString();
							
							if (d.ToLower() == "true" || d == "1")
							{
								desc = true;
							}
						}
						
						this.mOrderBy[concept_id] = desc;
						
						++i;
					}
					
				}
				else if (orderby is System.String)
				{
					desc = false;
					
					if (descend != null && !(descend is Utility.OrderedMap))
					{
						if (descend.ToString() == "true" || descend.ToString() == "1")
						{
							desc = true;
						}
					}
					
					this.mOrderBy[orderby] = desc;
				}
			}
			
			return base.LoadKvpParameters();
		}// end of member function LoadKvpParameters
		
		public override void StartElement(TpXmlReader reader, Utility.OrderedMap attrs) 
		{
			string name;
			int depth;
			object msg = "";
			bool descend;
			
			name = TpUtils.GetUnqualifiedName(reader.XmlReader.Name);
			
			base.StartElement(reader, attrs);
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			if (Utility.StringSupport.StringCompare(name, "externalOutputModel", false) == 0)
			{
				if (attrs["location"].ToString() != "")
				{
					this.LoadOutputModel(attrs["location"].ToString());
				}
				else
				{
					msg = "Missing attribute \"location\" in <externalOutputModel> element";
					new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, msg.ToString(), TpConfigManager.DIAG_ERROR);
				}
			}
			else if (this.mInTags.Search("outputmodel") != null)
			{
				// Delegate to output model parser
				if (this.mOutputModel == null)
				{
					this.mOutputModel = new TpOutputModel();
				}
					
				this.mOutputModel.StartElement(reader, attrs);
			}
			// <node> element whose parent is <partial>
			else if (depth > 1 && this.mInTags[depth - 2].ToString() == "partial" && Utility.StringSupport.StringCompare(name, "node", false) == 0 
				&& attrs["path"].ToString() != "")
			{
				this.mPartial.Push(attrs["path"]);
			}
			// <concept> element whose parent is <orderBy>
			else if (depth > 1 && this.mInTags[depth - 2].ToString() == "orderby" && Utility.StringSupport.StringCompare(name, "concept", false) == 0 
				&& attrs["id"].ToString() != "")
			{
				string d = TpUtils.GetInArray(attrs, "descend", false).ToString();
							
				if (d == "true" || d == "1")
				{
					descend = true;
				}
				else
				{
					descend = false;
				}
							
				this.mOrderBy[attrs["id"].ToString()] = descend;
			}
		}// end of member function StartElement
		
		public override void  EndElement(TpXmlReader reader)
		{
			if (this.mInTags.Search("outputmodel") != null)
			{
				// Delegate to output model parser
				this.mOutputModel.EndElement(reader);
			}
			
			base.EndElement(reader);
		}// end of member function EndElement
		
		public override void  CharacterData(TpXmlReader reader, string data)
		{
			if (this.mInTags.Search("outputModel") != null)
			{
				// Delegate to output model parser
				this.mOutputModel.CharacterData(reader, data);
			}
			
			base.CharacterData(reader, data);
		}// end of member function CharacterData
		
		public virtual bool LoadOutputModel(string location)
		{
			// Here output models must be specified as URLs
			// (it's important to check this also for security reasons since
			// "fopen" is used to read templates!)
			string error;
			bool loaded_from_cache;
			Utility.OrderedMap cache_options;
			object cached_data;
			int cache_expires;
			
			if (!TpUtils.IsUrl(location))
			{
				error = "Output model is not a URL.";
				new TpDiagnostics().Append(TpConfigManager.DC_INVALID_REQUEST, error, TpConfigManager.DIAG_FATAL);
				
				return false;
			}
			
			loaded_from_cache = false;
			
			// If cache is enabled
			if (TpConfigManager.TP_USE_CACHE)
			{
				//TODO ?? cache
				mOutputModel = (TpOutputModel)HttpContext.Current.Cache.Get("models");
				loaded_from_cache = true;
			}
			
			if (!loaded_from_cache)
			{
				this.mOutputModel = new TpOutputModel();
				
				if (this.mOutputModel.Parse(location))
				{
					// Save parameters in cache
					
					if (TpConfigManager.TP_USE_CACHE)
					{
						cache_expires = TpConfigManager.TP_OUTPUT_MODEL_CACHE_LIFE_SECS;
						HttpContext.Current.Cache.Add("models", this.mOutputModel, null, DateTime.MaxValue, new TimeSpan(0,0,cache_expires), System.Web.Caching.CacheItemPriority.Normal, null);						
					}
				}
				else
				{
					return false;
				}
			}
			
			return true;
		}// end of member function LoadOutputModel
		
		public virtual Utility.OrderedMap GetOrderBy()
		{
			return this.mOrderBy;
		}// end of member function GetOrderBy
		
		public virtual Utility.OrderedMap GetPartial()
		{
			return this.mPartial;
		}// end of member function GetPartial
		
		public virtual TpOutputModel GetOutputModel()
		{
			return this.mOutputModel;
		}// end of member function GetOutputModel
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public override Utility.OrderedMap __sleep()
		{
			return Utility.OrderedMap.Merge(base.__sleep(), new Utility.OrderedMap("mOutputModel", "mPartial", "mOrderBy"));
		}// end of member function __sleep
	}
}
