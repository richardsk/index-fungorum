import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Hashtable;

import com.ibm.lsid.LSID;
import com.ibm.lsid.LSIDException;
import com.ibm.lsid.MalformedLSIDException;
import com.ibm.lsid.ExpiringResponse;
import com.ibm.lsid.MetadataResponse;
import com.ibm.lsid.wsdl.LSIDDataPort;
import com.ibm.lsid.wsdl.LSIDMetadataPort;
import com.ibm.lsid.wsdl.SOAPLocation;
import com.ibm.lsid.http.HTTPConstants;
import com.ibm.lsid.http.HTTPResponse;
import com.ibm.lsid.http.HTTPUtils;
import com.ibm.lsid.ontologies.LSIDBuilder;
import com.ibm.lsid.server.LSIDAuthorityService;
import com.ibm.lsid.server.LSIDRequestContext;
import com.ibm.lsid.server.LSIDServiceConfig;
import com.ibm.lsid.server.LSIDServerException;
import com.ibm.lsid.server.impl.SimpleAuthority;
import com.ibm.lsid.server.impl.SimpleResolutionService;
import com.ibm.lsid.server.metadata.rdf.RDFConstants;
import com.ibm.lsid.server.metadata.rdf.RDFDocument;
import com.ibm.lsid.server.metadata.rdf.Resource;
import com.ibm.lsid.wsdl.HTTPLocation;
import com.ibm.lsid.wsdl.FTPLocation;

public class IFAuthority extends SimpleResolutionService {

    public void initService(LSIDServiceConfig config) throws LSIDServerException {
    }

    @Override
	protected String getServiceName() {
		return "IFAuthority";
	}

	@Override
	protected boolean hasData(LSIDRequestContext arg0) {
		try
		{
			if (arg0.getLsid().getAuthority().getAuthority().toLowerCase().equals("indexfungorum.org"))
			{
				return true;
			}
			return false;
		}
		catch(Exception ex)
		{
			return false;
		}
	}

	@Override
	protected boolean hasMetadata(LSIDRequestContext arg0) {
		try
		{
			if (arg0.getLsid().getAuthority().getAuthority().toLowerCase().equals("indexfungorum.org"))
			{
				return true;
			}
			return false;
		}
		catch(Exception ex)
		{
			return false;
		}
	}

	@Override
	protected void validate(LSIDRequestContext arg0) throws LSIDServerException {
		// TODO Auto-generated method stub
		
	}


	public InputStream getData(LSIDRequestContext arg0) throws LSIDServerException {
		try
		{
			String id = arg0.getLsid().getObject();
			Hashtable wsArg = new Hashtable();
			wsArg.put("NameKey", id);
			
			String url = "http://indexfungorum.org/ixfwebservice/Fungus.asmx/NameByKey?NameKey=" + id;
			
			HTTPResponse resp = HTTPUtils.doGet(url, null, null, null);
						
			return resp.getData();			
		}
		catch (LSIDException ex)
		{
			throw new LSIDServerException(ex.getMessage());
		}
	}

	public MetadataResponse getMetadata(LSIDRequestContext arg0, String[] arg1) throws LSIDServerException {
		try
		{
			String id = arg0.getLsid().getObject();
			Hashtable wsArg = new Hashtable();
			wsArg.put("NameKey", id);
			
			String url = "http://indexfungorum.org/ixfwebservice/Fungus.asmx/NameByKey?NameKey=" + id;
			
			HTTPResponse resp = HTTPUtils.doGet(url, null, null, null);
					
			return new MetadataResponse(resp.getData(), null);			
		}
		catch (LSIDException ex)
		{
			throw new LSIDServerException(ex.getMessage());
		}		
	}

  }

