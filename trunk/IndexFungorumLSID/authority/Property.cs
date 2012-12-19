using System;

namespace LSIDBase
{
    [Serializable()]
    public class Property 
    {


        //--------------------------/
        //- Class/Member Variables -/
        //--------------------------/

        /**
                               * Field _name
                               */
        private String _name;

        /**
         * Field _value
         */
        private String _value;


        //----------------/
        //- Constructors -/
        //----------------/

        public Property() 
        {
        }


        //-----------/
        //- Methods -/
        //-----------/

        /**
         * Note: hashCode() has not been overriden
         * 
         * @param obj
         */
        public Boolean equals(Object obj)
        {
            if ( this == obj )
                return true;
        
            if (obj is Property) 
            {
        
                Property temp = (Property)obj;
                if (this._name != null) 
                {
                    if (temp._name == null) return false;
                    else if (!(this._name.Equals(temp._name))) 
                        return false;
                }
                else if (temp._name != null)
                    return false;
                if (this._value != null) 
                {
                    if (temp._value == null) return false;
                    else if (!(this._value.Equals(temp._value))) 
                        return false;
                }
                else if (temp._value != null)
                    return false;
                return true;
            }
            return false;
        }

        /**
         * Returns the value of field 'name'.
         * 
         * @return the value of field 'name'.
         */
        public String getName()
        {
            return this._name;
        }

        /**
         * Returns the value of field 'value'.
         * 
         * @return the value of field 'value'.
         */
        public String getValue()
        {
            return this._value;
        }

        /**
         * Method isValid
         */
        public Boolean isValid()
        {
            try 
            {
                validate();
            }
            catch (Exception) 
            {
                return false;
            }
            return true;
        }

        /**
         * Method marshal
         * 
         * @param out
         */
        //        public void marshal(java.io.Writer out)
        //        throws org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //                                                       {
        //        
        //        Marshaller.marshal(this, out);
        //    } //-- void marshal(java.io.Writer) 

        /**
         * Method marshal
         * 
         * @param handler
         */
        //    public void marshal(org.xml.sax.ContentHandler handler)
        //    throws java.io.IOException, org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //{
        //        
        //    Marshaller.marshal(this, handler);
        //} //-- void marshal(org.xml.sax.ContentHandler) 

        /**
         * Sets the value of field 'name'.
         * 
         * @param name the value of field 'name'.
         */
        public void setName(String name)
        {
            this._name = name;
        }

        /**
         * Sets the value of field 'value'.
         * 
         * @param value the value of field 'value'.
         */
        public void setValue(String value)
        {
            this._value = value;
        }

        /**
         * Method unmarshalProperty
         * 
         * @param reader
         */
        //    public static com.ibm.lsid.client.conf.castor.Property unmarshalProperty(java.io.Reader reader)
        //    throws org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //{
        //    return (com.ibm.lsid.client.conf.castor.Property) Unmarshaller.unmarshal(com.ibm.lsid.client.conf.castor.Property.class, reader);
        //                                                                                                                      } //-- com.ibm.lsid.client.conf.castor.Property unmarshalProperty(java.io.Reader) 

        /**
         * Method validate
         */
        public void validate()
        {
            //    org.exolab.castor.xml.Validator validator = new org.exolab.castor.xml.Validator();
            //    validator.validate(this);
        } //-- void validate() 

    }
}
