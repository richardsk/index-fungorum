
import com.ibm.lsid.LSID;
import com.ibm.lsid.MalformedLSIDException;
import com.ibm.lsid.ExpiringResponse;
import com.ibm.lsid.wsdl.LSIDDataPort;
import com.ibm.lsid.wsdl.LSIDMetadataPort;
import com.ibm.lsid.wsdl.SOAPLocation;
import com.ibm.lsid.server.LSIDServiceConfig;
import com.ibm.lsid.server.LSIDServerException;
import com.ibm.lsid.server.impl.SimpleAuthority;
import com.ibm.lsid.wsdl.HTTPLocation;
import com.ibm.lsid.wsdl.FTPLocation;


public class lsidauth extends SimpleAuthority {

    public void initService(LSIDServiceConfig config) throws LSIDServerException {
    }

    public LSIDMetadataPort[] getMetaDataLocations(LSID lsid, String url) {
    	return new LSIDMetadataPort[] {
    	        new HTTPLocation(
    	          //"localhost", 80, "/cabihost/fungus.asmx/NameByKey?NameKey=213645"
    	        		"nzbugs.landcareresearch.co.nz", 80, "/default.aspx?selected=NameDetails&TabNum=0&NameId=D3473673-EF49-4A86-A721-2888C5BA8A31"
    	        )
    	      };
    }

    public LSIDDataPort[] getDataLocations(LSID lsid, String url) {
      return new LSIDDataPort[] {
        new HTTPLocation(
          //"localhost", 80, "/cabihost/fungus.asmx/NameByKey?NameKey=213645"
        		"nzbugs.landcareresearch.co.nz", 80, "/default.aspx?selected=NameDetails&TabNum=0&NameId=D3473673-EF49-4A86-A721-2888C5BA8A31"
        )
      };
    }
  }

