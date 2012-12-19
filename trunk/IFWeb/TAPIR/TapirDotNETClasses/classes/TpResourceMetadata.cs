using System;
using System.Web;
using System.Xml;

namespace TapirDotNET 
{

	public class TpResourceMetadata:TpBusinessObject
	{
		public string mId = "";
		public string mDefaultLanguage = "";
		public string mType = "";
		public string mAccessPoint = "";
		public string mLanguage = "";
		public string mCreated = "";
		public Utility.OrderedMap mTitles = new Utility.OrderedMap();
		public Utility.OrderedMap mDescriptions = new Utility.OrderedMap();
		public Utility.OrderedMap mSubjects = new Utility.OrderedMap();
		public Utility.OrderedMap mBibliographicCitations = new Utility.OrderedMap();
		public Utility.OrderedMap mRights = new Utility.OrderedMap();
		public Utility.OrderedMap mRelatedEntities = new Utility.OrderedMap();
		public TpIndexingPreferences mIndexingPreferences;
		public Utility.OrderedMap mInTags = new Utility.OrderedMap();
		public Utility.OrderedMap mAttrs = new Utility.OrderedMap();
		public bool mIsLoaded = false;
		public string mCharData = "";
		
		public TpResourceMetadata() : base()
		{
		}
		
		private void Clear()
		{
			mId = "";
			mDefaultLanguage = "";
			mType = "";
			mAccessPoint = "";
			mLanguage = "";
			mCreated = "";
			mTitles = new Utility.OrderedMap();
			mDescriptions = new Utility.OrderedMap();
			mSubjects = new Utility.OrderedMap();
			mBibliographicCitations = new Utility.OrderedMap();
			mRights = new Utility.OrderedMap();
			mRelatedEntities = new Utility.OrderedMap();
			mInTags = new Utility.OrderedMap();
			mAttrs = new Utility.OrderedMap();
			mInTags = new Utility.OrderedMap();
			mAttrs = new Utility.OrderedMap();
			mIsLoaded = false;
			mCharData = "";
		}
		
		public virtual bool IsLoaded()
		{
			return this.mIsLoaded;
		}// end of member function IsLoaded
		
		public virtual void  LoadDefaults()
		{
			Clear();

			string path_to_www_dir;
			string request_uri;
			int pos_admin;
			TpRelatedEntity related_entity;
			TpEntity entity;
			this.mId = "";
			this.mType = "http://purl.org/dc/dcmitype/Service";
			
			path_to_www_dir = "/PATH_TO_WWW_DIR";
			
			request_uri = HttpContext.Current.Request.RawUrl;
			
			pos_admin = request_uri.IndexOf("/admin/");
			
			if (pos_admin > 0)
			{
				path_to_www_dir = request_uri.Substring(0, pos_admin);
			}
			
			this.mAccessPoint = "http://" + HttpContext.Current.Request.Headers["HOST"] + path_to_www_dir + "/tapir.aspx/LOCAL_ID";
			
			this.mDefaultLanguage = "";
			this.AddTitle("", "");
			this.AddDescription("", "");
			this.AddSubjects("", "");
			this.AddBibliographicCitation("", "");
			this.AddRights("", "");
			
			this.mCreated = TpUtils.TimestampToXsdDateTime(DateTime.Now);
			
			related_entity = new TpRelatedEntity();
			entity = new TpEntity();
			entity.LoadDefaults();
			related_entity.SetEntity(entity);
			this.AddRelatedEntity(related_entity);
			
			this.mIndexingPreferences = new TpIndexingPreferences();
			this.mIndexingPreferences.LoadDefaults();
			
			this.mIsLoaded = true;
		}// end of member function LoadDefaults
		
		public virtual void  LoadFromSession()
		{
			Clear();

			this.mId = TpUtils.FindVar(":mid", "").ToString();
			
			this.mDefaultLanguage = TpUtils.FindVar("default_language", "").ToString();
			
			this.LoadLangElementFromSession("title", this.mTitles);
			
			this.mType = System.Web.HttpUtility.UrlDecode(TpUtils.FindVar("mtype", "").ToString());
			
			this.mAccessPoint = System.Web.HttpUtility.UrlDecode(TpUtils.FindVar(":accesspoint", "").ToString());
			
			this.LoadLangElementFromSession("description", this.mDescriptions);
			
			this.mLanguage = TpUtils.GetVar("language", "").ToString();
			
			this.LoadLangElementFromSession("subjects", this.mSubjects);
			
			this.LoadLangElementFromSession("bibliographicCitation", this.mBibliographicCitations);
			this.LoadLangElementFromSession("rights", this.mRights);
			
			this.LoadRelatedEntitiesFromSession();
			
			this.mCreated = System.Web.HttpUtility.UrlDecode(TpUtils.FindVar("mcreated", "").ToString());
			
			this.mIndexingPreferences = new TpIndexingPreferences();
			this.mIndexingPreferences.LoadFromSession();
			
			this.mIsLoaded = true;
		}// end of member function LoadFromSession
		
		public virtual void  LoadRelatedEntitiesFromSession()
		{
			int cnt = 1;
			
			while (HttpContext.Current.Request.Params["entity_" + cnt.ToString()] != null && cnt < 6)
			{
				string prefix = "entity_" + cnt.ToString();
				
				if (TpUtils.FindVar("del_" + prefix, null) == null)
				{
					Utility.OrderedMap roles = new Utility.OrderedMap();
					
					int cnt2 = 1;
					
					// Max number of roles is hard coded!
					while (cnt2 < 10)
					{
						if (HttpContext.Current.Request[prefix + "_role_" + cnt2.ToString()] != null)
						{
							roles.Push(HttpContext.Current.Request[prefix + "_role_" + cnt2.ToString()]);
						}
						
						++cnt2;
					}
					
					TpRelatedEntity related_entity = new TpRelatedEntity();
					TpEntity entity = new TpEntity();
					entity.LoadFromSession(prefix);
					related_entity.SetEntity(entity);
					related_entity.SetRoles(roles);
					this.AddRelatedEntity(related_entity);
				}
				
				++cnt;
			}
			if (HttpContext.Current.Request.Params["add_entity"] != null)
			{
				TpRelatedEntity related_entity = new TpRelatedEntity();
				TpEntity entity = new TpEntity();
				entity.LoadDefaults();
				related_entity.SetEntity(entity);
				this.AddRelatedEntity(related_entity);
			}
		}// end of member function LoadRelatedEntitiesFromSession
		
		public virtual bool LoadFromXml(string localId, string xml)
		{
			Clear();

			string error;
			string path_to_www_dir;
			string request_uri;
			int pos_admin;
			this.mId = localId;
			
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				rdr.ReadXmlStr(xml);				
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}
			
			if (this.mAccessPoint.Length == 0)
			{
				path_to_www_dir = "/PATH_TO_WWW_DIR";
				
				request_uri = HttpContext.Current.Request.RawUrl;
				
				pos_admin = request_uri.IndexOf("/admin/");
				
				if (pos_admin > 0)
				{
					path_to_www_dir = request_uri.Substring(0, pos_admin);
				}
				
				this.mAccessPoint = "http://" + HttpContext.Current.Request.Headers["HOST"] + path_to_www_dir + "/tapir.aspx?dsa=" + this.mId;
			}
			
			this.mIsLoaded = true;
			
			return true;
		}// end of member function LoadFromXml
		

		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			int depth;
			string lastTag;
			TpRelatedEntity r_related_entity;
			TpEntity r_entity;
			TpRelatedContact r_related_contact;
			this.mInTags.Push(reader.XmlReader.Name);
			
			this.mAttrs = attrs;
			
			depth = Utility.OrderedMap.CountElements(this.mInTags);
			
			lastTag = "";
			
			if (depth >= 2)
			{
				lastTag = Utility.TypeSupport.ToString(this.mInTags[depth - 2]);
			}
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "metadata", false) == 0)
			{
				if (attrs[TpConfigManager.TP_XML_PREFIX + ":lang"] != null)
				{
					this.mDefaultLanguage = Utility.TypeSupport.ToString(attrs[TpConfigManager.TP_XML_PREFIX + ":lang"]);
				}
			}
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "indexingPreferences", false) == 0)
				{
					this.mIndexingPreferences = new TpIndexingPreferences();
					
					this.mIndexingPreferences.SetStartTime(attrs["startTime"].ToString());
					this.mIndexingPreferences.SetMaxDuration(attrs["maxDuration"].ToString());
					this.mIndexingPreferences.SetFrequency(attrs["frequency"].ToString());
				}
				else
				{
					if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "relatedEntity", false) == 0)
					{
						this.AddRelatedEntity(new TpRelatedEntity());
					}
					else
					{
						if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "entity", false) == 0)
						{
							r_related_entity = this.GetLastRelatedEntity();
							r_related_entity.SetEntity(new TpEntity());
						}
						else
						{
							if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "hasContact", false) == 0)
							{
								r_related_entity = this.GetLastRelatedEntity();
								r_entity = r_related_entity.GetEntity();
								r_entity.AddRelatedContact(new TpRelatedContact());
							}
							else
							{
								if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, TpConfigManager.TP_VCARD_PREFIX + ":VCARD", false) == 0)
								{
									r_related_entity = this.GetLastRelatedEntity();
									r_entity = r_related_entity.GetEntity();
									r_related_contact = r_entity.GetLastRelatedContact();
									r_related_contact.SetContact(new TpContact());
								}
							}
						}
					}
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			int depth;
			string in_tag;
			string last_tag;
			bool reset_char_data;
			string lang;
			TpRelatedEntity r_related_entity;
			TpEntity r_entity;
			TpRelatedContact r_related_contact;
			TpContact r_contact;

			if (this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}).Length > 0)
			{
				depth = Utility.OrderedMap.CountElements(this.mInTags);
				in_tag = reader.XmlReader.Name;
				last_tag = Utility.TypeSupport.ToString(this.mInTags[depth - 2]);
				
				reset_char_data = true;
				
				lang = "";
				
				if (this.mAttrs[TpConfigManager.TP_XML_PREFIX + ":lang"] != null)
				{
					lang = Utility.TypeSupport.ToString(this.mAttrs[TpConfigManager.TP_XML_PREFIX + ":lang"]);
				}
				
				if (Utility.StringSupport.StringCompare(last_tag, "metadata", false) == 0)
				{
					if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":title", false) == 0)
					{
						this.AddTitle(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
					}
					else
					{
						if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":type", false) == 0)
						{
							this.mType = this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'});
						}
						else
						{
							if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":description", false) == 0)
							{
								this.AddDescription(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
							}
							else
							{
								if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":language", false) == 0)
								{
									this.mLanguage = this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'});
								}
								else
								{
									if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":subject", false) == 0)
									{
										this.AddSubjects(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
									}
									else
									{
										if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":bibliographicCitation", false) == 0)
										{
											this.AddBibliographicCitation(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
										}
										else
										{
											if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DC_PREFIX + ":rights", false) == 0)
											{
												this.AddRights(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
											}
											else
											{
												if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_DCT_PREFIX + ":created", false) == 0)
												{
													this.mCreated = this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'});
												}
												else
												{													
													if (Utility.StringSupport.StringCompare(in_tag, "accesspoint", false) == 0)
													{
														this.mAccessPoint = this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'});
													}
													else
													{
														reset_char_data = false;
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
				else
				{
					if (this.mInTags.Search("relatedEntity") != null)
					{
						r_related_entity = this.GetLastRelatedEntity();
						
						if (Utility.StringSupport.StringCompare(last_tag, "relatedEntity", false) == 0)
						{
							if (Utility.StringSupport.StringCompare(in_tag, "role", false) == 0)
							{
								r_related_entity.AddRole(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
							}
							else
							{
								reset_char_data = false;
							}
						}
						else
						{
							if (this.mInTags.Search("entity") != null)
							{
								r_entity = r_related_entity.GetEntity();
								
								if (Utility.StringSupport.StringCompare(last_tag, "entity", false) == 0)
								{
									if (Utility.StringSupport.StringCompare(in_tag, "identifier", false) == 0)
									{
										r_entity.SetIdentifier(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
									}
									else
									{
										if (Utility.StringSupport.StringCompare(in_tag, "name", false) == 0)
										{
											r_entity.AddName(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
										}
										else
										{
											if (Utility.StringSupport.StringCompare(in_tag, "description", false) == 0)
											{
												r_entity.AddDescription(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
											}
											else
											{
												if (Utility.StringSupport.StringCompare(in_tag, "acronym", false) == 0)
												{
													r_entity.SetAcronym(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
												}
												else
												{
													if (Utility.StringSupport.StringCompare(in_tag, "address", false) == 0)
													{
														r_entity.SetAddress(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
													}
													else
													{
														if (Utility.StringSupport.StringCompare(in_tag, "logoURL", false) == 0)
														{
															r_entity.setLogoUrl(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
														}
														else
														{
															if (Utility.StringSupport.StringCompare(in_tag, "relatedInformation", false) == 0)
															{
																r_entity.SetRelatedInformation(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
															}
															else
															{
																reset_char_data = false;
															}
														}
													}
												}
											}
										}
									}
								}
								else
								{
									if (Utility.StringSupport.StringCompare(last_tag, TpConfigManager.TP_GEO_PREFIX + ":Point", false) == 0)
									{
										if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_GEO_PREFIX + ":long", false) == 0)
										{
											r_entity.SetLongitude(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
										}
										else
										{
											if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_GEO_PREFIX + ":lat", false) == 0)
											{
												r_entity.SetLatitude(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
											}
											else
											{
												reset_char_data = false;
											}
										}
									}
									else
									{
										if (this.mInTags.Search("hasContact") != null)
										{
											r_related_contact = r_entity.GetLastRelatedContact();
											
											if (Utility.StringSupport.StringCompare(last_tag, "hasContact", false) == 0)
											{
												if (Utility.StringSupport.StringCompare(in_tag, "role", false) == 0)
												{
													r_related_contact.AddRole(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
												}
												else
												{
													reset_char_data = false;
												}
											}
											else
											{
												if (this.mInTags.Search(TpConfigManager.TP_VCARD_PREFIX + ":VCARD") != null)
												{
													r_contact = r_related_contact.GetContact();
													
													if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_VCARD_PREFIX + ":FN", false) == 0)
													{
														r_contact.SetFullName(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
													}
													else
													{
														if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_VCARD_PREFIX + ":TITLE", false) == 0)
														{
															r_contact.AddTitle(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}), lang);
														}
														else
														{
															if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_VCARD_PREFIX + ":EMAIL", false) == 0)
															{
																r_contact.SetEmail(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
															}
															else
															{
																if (Utility.StringSupport.StringCompare(in_tag, TpConfigManager.TP_VCARD_PREFIX + ":TEL", false) == 0)
																{
																	r_contact.SetTelephone(this.mCharData.Trim(new char[]{' ', '\t', '\n', '\r', '0'}));
																}
																else
																{
																	reset_char_data = false;
																}
															}
														}
													}
												}
												else
												{
													reset_char_data = false;
												}
											}
										}
										else
										{
											reset_char_data = false;
										}
									}
								}
							}
							else
							{
								reset_char_data = false;
							}
						}
					}
					else
					{
						reset_char_data = false;
					}
				}
				
				if (reset_char_data)
				{
					this.mCharData = "";
				}
			}
			
			this.mInTags.Pop();
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			this.mCharData += data;
		}// end of member function CharacterData
		
		public virtual void  AddTitle(string title, string lang)
		{
			this.mTitles.Push(new TpLangString(title, lang));
		}// end of member function AddTitle
		
		public virtual void  AddDescription(string description, string lang)
		{
			this.mDescriptions.Push(new TpLangString(description, lang));
		}// end of member function AddDescription
		
		public virtual void  AddSubjects(string subjects, string lang)
		{
			this.mSubjects.Push(new TpLangString(subjects, lang));
		}// end of member function AddSubjects
		
		public virtual void  AddBibliographicCitation(string citation, string lang)
		{
			this.mBibliographicCitations.Push(new TpLangString(citation, lang));
		}// end of member function AddBibliographicCitation
		
		public virtual void  AddRights(string rights, string lang)
		{
			this.mRights.Push(new TpLangString(rights, lang));
		}// end of member function AddRights
		
		public virtual void  AddRelatedEntity(TpRelatedEntity relatedEntity)
		{
			this.mRelatedEntities.Push(relatedEntity);
		}// end of member function AddRelatedEntity
		
		public virtual void  SetType(string type)
		{
			this.mType = (type == null ? "" : type);
		}// end of member function SetType
		
		public virtual void  SetId(string localId)
		{
			this.mId = (localId == null ? "" : localId);
		}// end of member function SetId
		
		public virtual string GetId()
		{
			return this.mId;
		}// end of member function GetId
		
		public virtual string GetDefaultLanguage()
		{
			return this.mDefaultLanguage;
		}// end of member function GetDefaultLanguage
		
		public new string GetType()
		{
			return this.mType;
		}// end of member function GetType
		
		public virtual Utility.OrderedMap GetTitles()
		{
			return this.mTitles;
		}// end of member function GetTitles
		
		public virtual Utility.OrderedMap GetDescriptions()
		{
			return this.mDescriptions;
		}// end of member function GetDescriptions
		
		public virtual Utility.OrderedMap GetSubjects()
		{
			return this.mSubjects;
		}// end of member function GetDescriptions
		
		public virtual Utility.OrderedMap GetBibliographicCitations()
		{
			return this.mBibliographicCitations;
		}// end of member function GetBibliographicCitations
		
		public virtual Utility.OrderedMap GetRights()
		{
			return this.mRights;
		}// end of member function GetRights
		
		public virtual Utility.OrderedMap GetRelatedEntities()
		{
			return this.mRelatedEntities;
		}// end of member function GetRelatedEntities
		
		public virtual TpRelatedEntity GetLastRelatedEntity()
		{
			int cnt;
			cnt = Utility.OrderedMap.CountElements(this.mRelatedEntities);
			
			return (TpRelatedEntity)this.mRelatedEntities[cnt - 1];
		}// end of member function GetLastRelatedEntity
		
		public virtual TpIndexingPreferences GetIndexingPreferences()
		{
			if (this.mIndexingPreferences == null)
			{
				this.mIndexingPreferences = new TpIndexingPreferences();
				this.mIndexingPreferences.LoadDefaults();
			}
			
			return this.mIndexingPreferences;
		}// end of member function GetIndexingPreferences
		
		public virtual string GetCreated()
		{
			return this.mCreated;
		}// end of member function GetCreated
		
		public virtual void  SetCreated(string created)
		{
			this.mCreated = (created == null ? "" : created);
		}// end of member function SetCreated
		
		public virtual string GetAccesspoint()
		{
			return this.mAccessPoint;
		}// end of member function GetAccesspoint
		
		public virtual void  SetAccesspoint(string accesspoint)
		{
			this.mAccessPoint = (accesspoint == null ? "" : accesspoint);
		}// end of member function SetAccesspoint
		
		public virtual string GetLanguage()
		{
			return this.mLanguage;
		}// end of member function GetLanguage
		
		public virtual bool Validate(bool raiseErrors)
		{
			bool ret_val;
			string default_lang;
			string error;
			TpResources resources;
			bool raise_error;
			string resource_param;
			int cnt;
			ret_val = true;
			
			default_lang = this.mDefaultLanguage;
			
			// id is mandatory
			if (this.mId.Length == 0)
			{
				if (raiseErrors)
				{
					error = "Local identifier is empty!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else
			{
				// Check that id does not contain special chars for URL
				if (this.mId != System.Web.HttpUtility.UrlEncode(this.mId))
				{
					if (raiseErrors)
					{
						error = "Local identifier must not contain URL special characters!";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					ret_val = false;
				}
				
				// Check that id is unique
				resources = new TpResources().GetInstance();
				
				raise_error = false;
				
				resource_param = TpUtils.GetVar("resource", "").ToString();
				
				if (resource_param != "")
				// only check when adding/editing a resource
				{
					if (this.mId != resource_param && resources.GetResource(this.mId, raise_error) != null)
					{
						if (raiseErrors)
						{
							error = "Local identifier already exists! Please choose another one.";
							new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
						}
						ret_val = false;
					}
				}
			}
			
			// Validate type
			if (this.mType.Length == 0)
			{
				if (raiseErrors)
				{
					error = "Resource type must be specified! " + "(this message is intended for developers " + "because the type should be automatically " + "defined internally).";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate accesspoint
			if (this.mAccessPoint.Length == 0)
			{
				if (raiseErrors)
				{
					error = "Resource accesspoint must be specified!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else
			{
				if (!TpUtils.IsUrl(this.mAccessPoint))
				{
					if (raiseErrors)
					{
						error = "Resource accesspoint is not a URL!";
						new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
					}
					ret_val = false;
				}
			}
			
			// Validate created
			if (this.mCreated.Length == 0)
			{
				if (raiseErrors)
				{
					error = "\"Creation date\" must be specified! " + "(this message is intended for developers " + "because dct:created should be automatically " + "defined internally).";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// At least one title
			if (Utility.OrderedMap.CountElements(this.mTitles) == 0)
			{
				if (raiseErrors)
				{
					error = "Resource metadata must have at least one title!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else
			{
				// Validate titles
				if (!new TpConfigUtils().ValidateLangSection("Resource title", this.mTitles, raiseErrors, true, default_lang))
				{
					ret_val = false;
				}
			}
			
			// At least one description
			if (Utility.OrderedMap.CountElements(this.mDescriptions) == 0)
			{
				if (raiseErrors)
				{
					error = "Resource metadata must have at least one description!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			else
			{
				// Validate descriptions
				if (!new TpConfigUtils().ValidateLangSection("Resource description", this.mDescriptions, raiseErrors, true, default_lang))
				{
					ret_val = false;
				}
			}
			
			// Language
			if (this.mLanguage.Length == 0)
			{
				if (raiseErrors)
				{
					error = "Content language is empty!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			// Validate subjects
			if (!new TpConfigUtils().ValidateLangSection("Resource subjects", this.mSubjects, raiseErrors, false, default_lang))
			{
				ret_val = false;
			}
			
			// Validate bibliographic citations
			if (!new TpConfigUtils().ValidateLangSection("Bibliographic citation", this.mBibliographicCitations, raiseErrors, false, default_lang))
			{
				ret_val = false;
			}
			
			// Validate rights
			if (!new TpConfigUtils().ValidateLangSection("Resource rights", this.mRights, raiseErrors, false, default_lang))
			{
				ret_val = false;
			}
			
			// Validate related entities
			cnt = 0;
			foreach ( TpRelatedEntity related_entity in this.mRelatedEntities.Values ) 
			{
				if (!related_entity.Validate(raiseErrors, default_lang))
				{
					ret_val = false;
				}
				
				++cnt;
			}
			
			
			if (cnt == 0)
			{
				if (raiseErrors)
				{
					error = "There must be at least one related entity!";
					new TpDiagnostics().Append(TpConfigManager.CFG_DATA_VALIDATION_ERROR, error, TpConfigManager.DIAG_ERROR);
				}
				ret_val = false;
			}
			
			return ret_val;
		}// end of member function Validate
		
		public virtual string GetXml(string offset, string indentWith)
		{
			Utility.OrderedMap attrs = new Utility.OrderedMap();
			string xml;
			string indent;
			attrs = new Utility.OrderedMap();
			
			if (this.mDefaultLanguage != "")
			{
				attrs[TpConfigManager.TP_XML_PREFIX + ":lang"] = this.mDefaultLanguage;
			}
			
			xml = TpUtils.OpenTag("", "metadata", offset, attrs);
			
			indent = offset + indentWith;
			
			foreach ( TpLangString lang_string in this.mTitles.Values ) 
			{
				xml += TpUtils.MakeLangTag(TpConfigManager.TP_DC_PREFIX, "title", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
			}
			
			
			xml += TpUtils.MakeTag(TpConfigManager.TP_DC_PREFIX, "type", this.mType, indent, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			
			xml += indent + "<accesspoint>[ACCESS_POINT]</accesspoint>\n";
			
			foreach ( TpLangString lang_string in this.mDescriptions.Values ) 
			{
				xml += TpUtils.MakeLangTag(TpConfigManager.TP_DC_PREFIX, "description", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
			}
			
			
			xml += TpUtils.MakeTag(TpConfigManager.TP_DC_PREFIX, "language", this.mLanguage, indent, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			
			foreach ( TpLangString lang_string in this.mSubjects.Values ) 
			{
				if (lang_string.GetValue().ToString().Length > 0)
				{
					xml += TpUtils.MakeLangTag(TpConfigManager.TP_DC_PREFIX, "subject", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
				}
			}
			
			
			foreach ( TpLangString lang_string in this.mBibliographicCitations.Values ) 
			{
				if (lang_string.GetValue().ToString().Length > 0)
				{
					xml += TpUtils.MakeLangTag(TpConfigManager.TP_DC_PREFIX, "bibliographicCitation", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
				}
			}
			
			
			foreach ( TpLangString lang_string in this.mRights.Values ) 
			{
				if (lang_string.GetValue().ToString().Length > 0)
				{
					xml += TpUtils.MakeLangTag(TpConfigManager.TP_DC_PREFIX, "rights", lang_string.GetValue().ToString(), lang_string.GetLang().ToString(), indent);
				}
			}
			
			
			xml += indent + "<" + TpConfigManager.TP_DCT_PREFIX + ":modified>[LAST_MODIFIED_DATE]</" + TpConfigManager.TP_DCT_PREFIX + ":modified>" + "\n";
			
			xml += TpUtils.MakeTag(TpConfigManager.TP_DCT_PREFIX, "created", this.mCreated, indent, Utility.TypeSupport.ToArray(new Utility.OrderedMap()));
			
			// Indexing preferences
			if (this.mIndexingPreferences != null)
			{
				xml += this.mIndexingPreferences.GetXml(indent, indentWith);
			}
			
			foreach ( TpRelatedEntity related_entity in this.mRelatedEntities.Values ) 
			{
				xml = xml + related_entity.GetXml(indent, indentWith);
			}
			
			
			xml += TpUtils.CloseTag("", "metadata", offset);
			
			return xml;
		}// end of member function GetXml
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mId", "mDefaultLanguage", "mTitles", "mType", "$mAccessPoint", "mDescriptions", "mLanguage", "mSubjects", "mBibliographicCitations", "mRights", "mCreated", "mRelatedEntities", "mIndexingPreferences", "mIsLoaded");
		}// end of member function __sleep
	}
}
