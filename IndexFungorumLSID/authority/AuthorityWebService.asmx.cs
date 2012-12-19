using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;

using LSIDFramework;

namespace AuthorityWebService
{       
    [WebService(Namespace = "http://www.omg.org/LSID/2003/AuthorityServiceSOAPBindings")]
    [WebServiceBinding("LSIDAuthoritySOAPBinding","http://www.omg.org/LSID/2003/Standard/WSDL")]
            
    public class AuthorityWebService : LSIDWebService
    {
        /**
        * get the services WSDL for the the given lsid
        * @param SOAPBodyElement[] the body elements
        * @return SOAPBodyElement[] the return body elements
        * returned as an attachment.
        */
        [WebMethod()]
        [SoapDocumentMethod(Binding="LSIDAuthoritySOAPBinding")]   
		//[PublishViaMime()] ??
        public ExpiringResponse getAvailableServices(String lsid) 
        {
            try 
            {
                LSID theLsid = new LSID(lsid);
                LSIDRequestContext ctx = getRequestContext(theLsid);
                
                ServiceRegistry reg = LSIDFramework.Global.TheServiceRegistry;
                    //getServiceRegistry(ServiceConfigurationConstants.AUTHORITY_SERVICE_IMPLEMENTATION_REGISTRY);
                LSIDAuthorityService service = (LSIDAuthorityService) reg.lookupService(theLsid);
                if (service == null)
                    throw new LSIDServerException(LSIDException.UNKNOWN_LSID, "Unknown lsid: " + lsid);

                
                ExpiringResponse resp = service.getAvailableServices(ctx);
                if (resp.getExpires() != DateTime.MinValue)
                    addExpirationHeader(resp.getExpires());
                MemoryStream str = new MemoryStream(System.Text.ASCIIEncoding.ASCII.GetBytes((String) resp.getValue()));
                addAttachment(str);

                return resp;

//                SOAPBodyElement responseElt = new SOAPBodyElement();
//                responseElt.setName(SoapConstants.GET_WSDL_OP_NAME + SoapConstants.OPERATION_RESPONSE_SUFFIX);
//                responseElt.setNamespaceURI(WSDLConstants.OMG_AUTHORITY_SOAP_BINDINGS_WSDL_NS_URI);
//                return new SOAPBodyElement[] { responseElt };
            } 
            catch (LSIDException e) 
            {
                throw new Exception("Error"); //AxisFaultBuilder.createFault(e);
            }
        }

        /**
         * register a foreign authority for the given LSID
         * @param SOAPBodyElement[] the body elements
         * @return SOAPBodyElement[] the return body elements
         * returned as an attachment.
         */
        [WebMethod()]
        [SoapDocumentMethod(Binding="LSIDAuthoritySOAPBinding")]   
        public void notifyForeignAuthority(LSIDRequestContext req, LSIDAuthority authorityName)
        {
            try 
            {
                //todo
//                LSID theLsid = getLSID(bodyElements[0]);
//                LSIDAuthority auth = getAuthority(bodyElements[0]);
//                LSIDRequestContext ctx = getRequestContext(theLsid);
//                ServiceRegistry reg = getServiceRegistry(ServiceConfigurationConstants.AUTHORITY_SERVICE_IMPLEMENTATION_REGISTRY);
//                LSIDAuthorityService service = (LSIDAuthorityService) reg.lookupService(theLsid);
//                if (service == null)
//                    throw new LSIDServerException(LSIDException.UNKNOWN_LSID, "Unknown lsid: " + theLsid);
//                service.notifyForeignAuthority(ctx, auth);
//                SOAPBodyElement responseElt = new SOAPBodyElement();
//                responseElt.setName(SoapConstants.NOTIFY_FOREIGN_AUTHORITY_OP_NAME + SoapConstants.OPERATION_RESPONSE_SUFFIX);
//                responseElt.setNamespaceURI(WSDLConstants.OMG_AUTHORITY_SOAP_BINDINGS_WSDL_NS_URI);
//                return new SOAPBodyElement[] { responseElt };
            } 
            catch (LSIDException e) 
            {
                throw new Exception("Error"); //AxisFaultBuilder.createFault(e);
            }
        }

        /**
         * register a foreign authority for the given LSID
         * @param SOAPBodyElement[] the body elements
         * @return SOAPBodyElement[] the return body elements
         * returned as an attachment.
         */
        [WebMethod()]
        [SoapDocumentMethod(Binding="LSIDAuthoritySOAPBinding")]   
        public void revokeNotificationForeignAuthority(LSIDRequestContext req, LSIDAuthority authorityName) 
        {
            try 
            {
                //todo
//                LSID theLsid = getLSID(bodyElements[0]);
//                LSIDAuthority auth = getAuthority(bodyElements[0]);
//                LSIDRequestContext ctx = getRequestContext(theLsid);
//                ServiceRegistry reg = getServiceRegistry(ServiceConfigurationConstants.AUTHORITY_SERVICE_IMPLEMENTATION_REGISTRY);
//                LSIDAuthorityService service = (LSIDAuthorityService) reg.lookupService(theLsid);
//                if (service == null)
//                    throw new LSIDServerException(LSIDException.UNKNOWN_LSID, "Unknown lsid: " + theLsid);
//                service.revokeNotificationForeignAuthority(ctx, auth);
//                SOAPBodyElement responseElt = new SOAPBodyElement();
//                responseElt.setName(SoapConstants.REVOKE_NOTIFICATION_FOREIGN_AUTHORITY_OP_NAME + SoapConstants.OPERATION_RESPONSE_SUFFIX);
//                responseElt.setNamespaceURI(WSDLConstants.OMG_AUTHORITY_SOAP_BINDINGS_WSDL_NS_URI);
//                return new SOAPBodyElement[] { responseElt };
            } 
            catch (LSIDException e) 
            {
                throw new Exception("Error"); // AxisFaultBuilder.createFault(e);
            }
        }

        /**
             * get the lsid from the given body element
             */
//        protected LSIDAuthority getAuthority(SOAPBodyElement bodyElt) 
//        {
//            try 
//            {
//                Iterator it = bodyElt.getChildElements(new PrefixedQName(null, AUTHORITY_NAME_PART, null));
//                if (!it.hasNext())
//                    throw AxisFaultBuilder.createFault(LSIDException.INVALID_METHOD_CALL, "Must specify LSID parameter");
//                MessageElement elt = (MessageElement) it.next();
//                return new LSIDAuthority(elt.getValue());
//            } 
//            catch (MalformedLSIDException e) 
//            {
//                throw AxisFaultBuilder.createFault(e);
//            }
//        }
    }
}
