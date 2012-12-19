using System.Collections;
using System.IO;
using System.Net;

namespace TapirDotNET 
{

	public class CnsSchemaHandler_v1 : TpConceptualSchemaHandler
	{
		TpConceptualSchema mConceptualSchema;
		string mXmlSchemaNs = "http://www.w3.org/2001/XMLSchema";
		Utility.OrderedMap mNamespaces = new Utility.OrderedMap();
		TpConcept mConcept;
		string mMode; // the kind of data we are digesting
		string mConceptSourceTarget;  // alias of concept source to load
		string mCurrentConceptSource; // alias of current concept source when parsing
		bool mPreparedConcept = false; // flag to indicate if at least one concept was loaded
		string mLastLabel = "";
		string mLastNamespace = "";

		public CnsSchemaHandler_v1( ) 
		{

		} // end of member function DarwinSchemaHandler_v2

		public override bool Load( TpConceptualSchema conceptualSchema ) 
		{
			this.mConceptualSchema = conceptualSchema;

			string file = conceptualSchema.GetLocation();

			// If location follows http://host/path/file#somealias
			// then load only the concepts from the schema with alias "somealias",
			// otherwise load only concepts from the last schema in the file.
			string[] parts = file.Split('#');

			if ( parts.Length == 2 )
			{
				this.mConceptSourceTarget = parts[1];

				file = parts[0];
			}



			// there is nothing here...


			string[] lines = this.ReadFile(file);
        
			foreach ( string line in lines )
			{
				// clear away white space
				string t_line = line.Trim();
            
				// ignore blank lines
				if ( t_line.Length == 0 ) continue;
            
				// ignore comment lines
				if ( t_line.IndexOf("#") == 0 ) continue;
            
				// we are changing mode if the line just contains something in
				// square brackets
				if ( System.Text.RegularExpressions.Regex.Match(t_line, "^\\[.+]$").Success )
				{
					this.mMode = t_line;

					if ( this.mConceptSourceTarget != null && 
						this.mPreparedConcept )
					{
						// no need to continue if concepts were already loaded
						break;
					}

					if ( t_line == "[concept_source]" )
					{
						this.mConceptualSchema.Reset();
					}

					continue;
				}
            
				// got to here so we are loading a KVP of a kind
				string[] kvp = t_line.Split('=');
				string key = kvp[0].Trim();
				string val = kvp[1].Trim();
            
				// fail if the line can't be cut in two
				if ( kvp.Length != 2 || key.Length == 0 || val.Length == 0 )
				{
					//$error = "Problems parsing line $line_number of $file. Could not split it about an = sign.";
					//TpDiagnostics::Append( DC_IO_ERROR, $error, DIAG_ERROR );
					continue;
				}
            
				// now switching depending on the mode we are in
            
				// we are loading a new concept source
				if ( this.mMode == "[concept_source]" )
				{
					if ( key == "alias" )
					{
						this.mCurrentConceptSource = val;
					}
					else if ( key == "label" )
					{
						this.mLastLabel = val;
					}
					else if ( key == "namespace" )
					{
						this.mLastNamespace = val;
					}

					continue;
				}

				// we are working through aliases associated with the last concept source loaded
				if ( this.mMode == "[aliases]" )
				{
					if ( this.mConceptSourceTarget == null ||
						this.mCurrentConceptSource == this.mConceptSourceTarget )
					{
						this.mConceptualSchema.AddConcept( this.PrepareConcept( key, val ) );
					}

					continue;
				}
            
				// if we have got this far then the line does not fall in a mode we understand
				//$error = "Ignoring line $line_number of $file. I do not understand mode $this->mMode.";
				//TpDiagnostics::Append( DC_GENERAL_ERROR, $error, DIAG_WARN );
			}

			// Load additional schema properties if necessary
			if ( this.mPreparedConcept && this.mConceptSourceTarget != null  )
			{
				if ( this.mLastLabel.Length > 0 )
				{
					this.mConceptualSchema.SetAlias( this.mLastLabel );
				}

				if ( this.mLastNamespace.Length > 0 )
				{
					this.mConceptualSchema.SetNamespace( this.mLastNamespace );
				}
			}

			return true;

		} // end of member function Load

		public TpConcept PrepareConcept( string key, string val ) 
		{
			this.mPreparedConcept = true;

			string doc_uri = "";

			string ns = this.mConceptualSchema.GetNamespace();

			if ( ns.IndexOf("http://rs.tdwg.org/ontology/voc/" ) == 0 )
			{
				// the convention is followed that the documentation is at the same
				// location as the CNS file but with a .html ending instead of a .txt ending
				// and theres is an anchor of the alias within that file
				string cns_location = this.mConceptualSchema.GetLocation();
				string doc_file_location = cns_location.Replace( ".txt", ".html");
				doc_uri = doc_file_location + "#" + key;
			}

			TpConcept concept = new TpConcept();
			concept.SetId( val ); // the concept id from the cns
			concept.SetDocumentation( doc_uri ); // derived above
			concept.SetName( key ); // the alias from the cns
			concept.SetRequired( false ); // no info in the cns
			concept.SetType( "http://www.w3.org/2001/XMLSchema:string" ); // defaults to string as we don't have type info in cns

			return concept;

		} // end of member function PrepareConcept

		/**
		* This is needed to overcome the problem 
		* with allow_url_fopen being turned off by some 
		* ISPs
		*
		* Returns the file as an array of lines
		*
		*/
		public string[] ReadFile(string file)
		{        
			ArrayList lines = new ArrayList();
                    
			if (TpUtils.IsUrl(file))
			{
				WebRequest wr = HttpWebRequest.Create(file);
				if ( TpConfigManager.TP_WEB_PROXY.Length > 0 )
				{
					wr.Proxy = new WebProxy(TpConfigManager.TP_WEB_PROXY);
				}

				WebResponse resp = wr.GetResponse();
				StreamReader rdr = new StreamReader(resp.GetResponseStream());
				string l = rdr.ReadLine();
				while ( l != null )
				{
					lines.Add(l);
					l = rdr.ReadLine();
				}
				rdr.Close();
			}
			else
			{
				StreamReader rdr = File.OpenText(file);
				string l = rdr.ReadLine();
				while ( l != null )
				{
					lines.Add(l);
					l = rdr.ReadLine();
				}
				rdr.Close();
			}

			return (string[])lines.ToArray(typeof(string));
        
		} // end member function ReadFile
    
    
	} // end of CnsSchemaHandler_v1
}