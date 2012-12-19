using System;
using System.Xml;

namespace TapirDotNET 
{

	public class TpLocalMapping
	{
		public Utility.OrderedMap mMappedSchemas = new Utility.OrderedMap();
		public Utility.OrderedMap mAvailableSchemas = new Utility.OrderedMap();
		public bool mFetchedListOfSchemas;
		public string mInTag;
		public TpConceptualSchema mCurrentSchema;
		public TpConcept mCurrentConcept;
		public TpConceptMapping mCurrentMapping;
		
		public TpLocalMapping()
		{
			
		}
		
		
		public virtual void  Reset()
		{
			this.mMappedSchemas = new Utility.OrderedMap();
			this.mAvailableSchemas = new Utility.OrderedMap();
			this.mFetchedListOfSchemas = false;
		}// end of member function Reset
		
		public virtual string GetSchemasFile()
		{
			return System.IO.Path.GetFullPath(TpConfigManager.TP_CONFIG_DIR + "\\" + TpConfigManager.TP_SCHEMAS_FILE);
		}// end of member function GetSchemasFile
		
		public virtual void  AddMappedSchema(TpConceptualSchema schema)
		{
			string namespace_Renamed = schema.GetNamespace();
			
			this.mMappedSchemas[namespace_Renamed] = schema;
		}// end of member function AddMappedSchema
		
		public virtual Utility.OrderedMap GetMappedSchemas()
		{
			Utility.OrderedMap.SortValuePreserve(ref this.mMappedSchemas, 0);
			
			return this.mMappedSchemas;
		}// end of member function GetMappedSchemas
		
		public virtual Utility.OrderedMap GetUnmappedSchemas()
		{
			Utility.OrderedMap unmapped_schemas = new Utility.OrderedMap();
			bool is_mapped;

			this.FetchListOfSchemas();
			
			unmapped_schemas = new Utility.OrderedMap();
			
			foreach ( string namespace_Renamed in this.mAvailableSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mAvailableSchemas[namespace_Renamed];
				is_mapped = false;
				
				foreach ( string mapped_namespace in this.mMappedSchemas.Keys ) 
				{
					TpConceptualSchema mapped_schema = (TpConceptualSchema)this.mMappedSchemas[mapped_namespace];
					if (mapped_namespace == namespace_Renamed)
					{
						is_mapped = true;
					}
				}
				
				
				if (!is_mapped)
				{
					unmapped_schemas[namespace_Renamed] = schema;
				}
			}
			
			
			Utility.OrderedMap.SortValuePreserve(ref unmapped_schemas, 0);
			
			return unmapped_schemas;
		}// end of member function GetMappedSchemas
		
		public virtual void  FetchListOfSchemas()
		{
			string error;
			
			if (this.mFetchedListOfSchemas)
			{
				return ;
			}
		
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.SchemasStartElement);
			rdr.EndElementHandler = new EndElement(this.SchemasEndElement);
			rdr.CharacterDataHandler = new CharacterData(this.SchemasCharacterData);
								
			try
			{
				rdr.ReadXml(this.GetSchemasFile());
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
			}

			this.mInTag = "";
			
			this.mFetchedListOfSchemas = true;
		}// end of member function FetchListOfSchemas
		
		public virtual void  SchemasStartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			this.mInTag = reader.XmlReader.Name;
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "schema", false) == 0)
			{
				this.mCurrentSchema = new TpConceptualSchema();
				
				this.mCurrentSchema.SetAlias(attrs["alias"].ToString());
			}
		}// end of member function SchemasStartElement
		
		public virtual void  SchemasEndElement(TpXmlReader reader)
		{
			string namespace_Renamed;
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "schema", false) == 0)
			{
				namespace_Renamed = this.mCurrentSchema.GetNamespace();
				
				this.mAvailableSchemas[namespace_Renamed] = this.mCurrentSchema;
			}
		}// end of member function SchemasEndElement
		
		public virtual void  SchemasCharacterData(TpXmlReader reader, string data)
		{
			if (data.Trim(new char[]{' ', '\t', '\n', '\r', '0'}).Length > 0)
			{
				if (Utility.StringSupport.StringCompare(this.mInTag, "namespace", false) == 0)
				{
					this.mCurrentSchema.SetNamespace(data);
				}
				else
				{
					if (Utility.StringSupport.StringCompare(this.mInTag, "location", false) == 0)
					{
						this.mCurrentSchema.SetLocation(data);
					}
					else
					{
						if (Utility.StringSupport.StringCompare(this.mInTag, "handler", false) == 0)
						{
							this.mCurrentSchema.SetHandler(data);
						}
					}
				}
			}
		}// end of member function SchemasCharacterData
		
		public virtual void  LoadSuggestedSchema(string namespace_Renamed)
		{
			string error;
			TpConceptualSchema schema;
			this.FetchListOfSchemas();
			
			if (this.mAvailableSchemas[namespace_Renamed] == null)
			{
				error = "Selected schema is not available!";
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return ;
			}
			
			schema = (TpConceptualSchema)this.mAvailableSchemas[namespace_Renamed];
			
			if (schema.FetchConcepts())
			{
				
				// Move schema from lists
				this.mMappedSchemas[namespace_Renamed] = schema;
				this.mAvailableSchemas[namespace_Renamed] = null;
			}
		}// end of member function LoadSuggestedSchema
		
		public virtual void  LoadNewSchema(string location, string schemaHandler)
		{
			TpConceptualSchema schema;
			string namespace_Renamed;
			schema = new TpConceptualSchema();
			schema.SetLocation(location);
			schema.SetHandler(schemaHandler);
			
			if (schema.FetchConcepts())
			{
				
				namespace_Renamed = schema.GetNamespace();
				
				if (this.mMappedSchemas[namespace_Renamed] != null)
				{
					// ignore because schema is already loaded/mapped
					return ;
				}
				
				// Move schema from lists
				this.mMappedSchemas[namespace_Renamed] = schema;
				this.mAvailableSchemas[namespace_Renamed] = null;
			}
		}// end of member function LoadNewSchema
		
		public virtual void  UnmapSchema(string namespace_Renamed)
		{
			if (this.mMappedSchemas[namespace_Renamed] != null)
			{
				// Note: Assuming that all schemas in schemas.xml have an alias which
				//       is different than the namespace, the following condition
				//       does not add to the list of available schemas a schema that
				//       was not originally proposed in the list.
				if (namespace_Renamed != ((TpConceptualSchema)this.mMappedSchemas[namespace_Renamed]).GetAlias())
				{
					this.mAvailableSchemas[namespace_Renamed] = this.mMappedSchemas[namespace_Renamed];
				}
				
				this.mMappedSchemas.Remove(namespace_Renamed);
			}
		}// end of member function UnmapSchema
		
		public virtual bool LoadFromXml(string file)
		{
			string error;
			this.Reset();
		
			TpXmlReader rdr = new TpXmlReader();
			rdr.StartElementHandler = new StartElement(this.StartElement);
			rdr.EndElementHandler = new EndElement(this.EndElement);
			rdr.CharacterDataHandler = new CharacterData(this.CharacterData);
								
			try
			{
				rdr.ReadXml(file);
			}
			catch(Exception ex)
			{
				error = "Could not import content from XML file: " + ex.Message;
				new TpDiagnostics().Append(TpConfigManager.CFG_INTERNAL_ERROR, error, TpConfigManager.DIAG_ERROR);
				return false;
			}			
			
			return true;
		}// end of member function LoadFromXml
		
		public virtual void  StartElement(TpXmlReader reader, Utility.OrderedMap attrs)
		{
			bool required = false;
			bool searchable = false;
			
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "schema", false) == 0)
			{
				this.mCurrentSchema = new TpConceptualSchema();
				
				this.mCurrentSchema.SetNamespace(attrs["namespace"].ToString());
				this.mCurrentSchema.SetLocation(attrs["location"].ToString());
				this.mCurrentSchema.SetAlias(attrs["alias"].ToString());
				this.mCurrentSchema.SetHandler(attrs["handler"].ToString());
			}
			// Assuming "<concept>" can only occur inside "<schema>"
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "concept", false) == 0)
				{
					this.mCurrentConcept = new TpConcept();
					this.mCurrentConcept.SetId(attrs["id"].ToString());
					this.mCurrentConcept.SetName(attrs["name"].ToString());
					
					required = (attrs["required"].ToString() == "true");
					searchable = (attrs["searchable"].ToString() == "true");
					
					this.mCurrentConcept.SetRequired(required);
					this.mCurrentConcept.SetSearchable(searchable);
					
					if (attrs["type"].ToString() != "")
					{
						this.mCurrentConcept.SetType(attrs["type"].ToString());
						
						if ((string)attrs["documentation"] != "")
						{
							this.mCurrentConcept.SetDocumentation((string)attrs["documentation"]);
						}
					}
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "singleColumnMapping", false) == 0)
				{
					this.mCurrentMapping = new TpConceptMappingFactory().GetInstance("SingleColumnMapping");
					if (attrs["type"].ToString() != "")
					{
						this.mCurrentMapping.SetLocalType(attrs["type"]);
					}
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lsidDataMapping", false) == 0)
				{
					this.mCurrentMapping = new TpConceptMappingFactory().GetInstance("LSIDDataMapping");
					if (attrs["type"].ToString() != "")
					{
						this.mCurrentMapping.SetLocalType(attrs["type"]);
					}
				}
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "fixedValueMapping", false) == 0)
				{
					this.mCurrentMapping = new TpConceptMappingFactory().GetInstance("FixedValueMapping");
					if (attrs["type"].ToString() != "")
					{
						this.mCurrentMapping.SetLocalType(attrs["type"]);
					}
				}
					// Assuming "<column>" can only occur inside "<singleColumnMapping>"
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "column", false) == 0)
				{
					if (mCurrentMapping.GetMappingType() == "SingleColumnMapping")
					{
						SingleColumnMapping scm = (SingleColumnMapping)this.mCurrentMapping;
						scm.SetTable(attrs["table"].ToString());
						scm.SetField(attrs["field"].ToString());
					}
					else if (mCurrentMapping.GetMappingType() == "LSIDDataMapping")
					{
						LSIDDataMapping dm = (LSIDDataMapping)this.mCurrentMapping;
						dm.SetTable(attrs["table"].ToString());
						dm.SetField(attrs["field"].ToString());
					}
				}
					// Assuming "<value>" can only occur inside "<fixedValueMapping>"
				else if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "value", false) == 0)
				{
					FixedValueMapping scm = (FixedValueMapping)this.mCurrentMapping;
					scm.SetValue(attrs["v"].ToString());
				}
			}
		}// end of member function StartElement
		
		public virtual void  EndElement(TpXmlReader reader)
		{
			string namespace_Renamed;
			if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "schema", false) == 0)
			{
				namespace_Renamed = this.mCurrentSchema.GetNamespace();
				
				this.mMappedSchemas[namespace_Renamed] = this.mCurrentSchema;
				
				this.mAvailableSchemas[namespace_Renamed] = null;
			}
			else
			{
				if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "concept", false) == 0)
				{
					this.mCurrentSchema.AddConcept(this.mCurrentConcept);
				}
				else
				{
					if (Utility.StringSupport.StringCompare(reader.XmlReader.Name, "singleColumnMapping", false) == 0 || Utility.StringSupport.StringCompare(reader.XmlReader.Name, "fixedValueMapping", false) == 0 ||
						Utility.StringSupport.StringCompare(reader.XmlReader.Name, "lsidDataMapping", false) == 0 )
					{
						this.mCurrentConcept.SetMapping(this.mCurrentMapping);
					}
				}
			}
		}// end of member function EndElement
		
		public virtual void  CharacterData(TpXmlReader reader, string data)
		{
			
		}// end of member function CharacterData
		
		public virtual string GetConfigXml()
		{
			string xml;
			xml = "\t<mapping>\n";
			
			foreach ( string namespace_Renamed in this.mMappedSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mMappedSchemas[namespace_Renamed];
				xml = xml + schema.GetConfigXml();
			}
			
			
			xml += "\t</mapping>\n";
			
			return xml;
		}// end of member function GetConfigXml
		
		public virtual string GetCapabilitiesXml()
		{
			string xml;
			xml = "\t<concepts>\n";
			
			xml += "\t\t<conceptNameServers/>\n";
			
			foreach ( string namespace_Renamed in this.mMappedSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mMappedSchemas[namespace_Renamed];
				xml = xml + schema.GetCapabilitiesXml();
			}
			
			
			xml += "\t</concepts>\n";
			
			return xml;
		}// end of member function GetCapabilitiesXml
		
		public virtual bool Validate()
		{
			bool ret_val;
			bool set_errors;
			ret_val = true;
			set_errors = true;
			
			foreach ( string namespace_Renamed in this.mMappedSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mMappedSchemas[namespace_Renamed];
				if (!schema.IsMapped(set_errors))
				{
					ret_val = false;
				}
			}
			
			
			return ret_val;
		}// end of member function Validate
		
		public virtual bool IsMappedConcept(object conceptId)
		{
			Utility.OrderedMap r_concepts;
			foreach ( string namespace_Renamed in this.mMappedSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mMappedSchemas[namespace_Renamed];
				r_concepts = schema.GetConcepts();
				
				foreach ( string id in r_concepts.Keys ) 
				{
					TpConcept concept = (TpConcept)r_concepts[id];
					if (id == conceptId.ToString() && concept.IsMapped())
					{
						return true;
					}
				}
				
			}
			
			
			return false;
		}// end of member function IsMappedConcept
		
		public virtual TpConcept GetConcept(object conceptId)
		{
			Utility.OrderedMap r_concepts;
			foreach ( string namespace_Renamed in this.mMappedSchemas.Keys ) 
			{
				TpConceptualSchema schema = (TpConceptualSchema)this.mMappedSchemas[namespace_Renamed];
				r_concepts = schema.GetConcepts();
				
				foreach ( string id in r_concepts.Keys ) 
				{
					TpConcept concept = (TpConcept)r_concepts[id];
					if (id == conceptId.ToString())
					{
						return concept;
					}
				}
				
			}
			
			
			return null;
		}// end of member function GetConcept
		
		 /**
		* Internal method called before serialization
		*
		* @return array Properties that should be considered during serialization
		*/
		public virtual Utility.OrderedMap __sleep()
		{
			return new Utility.OrderedMap("mMappedSchemas", "mAvailableSchemas", "mFetchedListOfSchemas");
		}// end of member function __sleep
	}
}
