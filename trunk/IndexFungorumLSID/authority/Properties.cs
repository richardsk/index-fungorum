using System;
using System.Collections;

namespace LSIDBase
{
    [Serializable()]
    public class Properties 
    {

        //--------------------------/
        //- Class/Member Variables -/
        //--------------------------/

        /**
         * Field _propertyList
         */
        private ArrayList _propertyList;


        //----------------/
        //- Constructors -/
        //----------------/

        public Properties() 
        {
            _propertyList = new ArrayList();
        }


        //-----------/
        //- Methods -/
        //-----------/

        /**
         * Method addProperty
         * 
         * @param vProperty
         */
        public void addProperty(Property vProperty)
        {
            _propertyList.Add(vProperty);
        }

        /**
         * Method addProperty
         * 
         * @param index
         * @param vProperty
         */
        public void addProperty(int index, Property vProperty)
        {
            _propertyList.Insert(index, vProperty);
        }

		
		public void addProperty(string name, string val)
		{
			Property p = new Property();
			p.setName(name);
			p.setValue(val);
			_propertyList.Add(p);
		}

        /**
         * Method clearProperty
         */
        public void clearProperty()
        {
            _propertyList.Clear();
        }

        /**
         * Method enumerateProperty
         */
        public IEnumerator enumerateProperty()
        {
            return _propertyList.GetEnumerator();
        }

        /**
         * Note: hashCode() has not been overriden
         * 
         * @param obj
         */
        public Boolean equals(Object obj)
        {
            if ( this == obj )
                return true;
        
            if (obj is Properties) 
            {
        
                Properties temp = (Properties)obj;
                if (this._propertyList != null) 
                {
                    if (temp._propertyList == null) return false;
                    else if (!(this._propertyList.Equals(temp._propertyList))) 
                        return false;
                }
                else if (temp._propertyList != null)
                    return false;
                return true;
            }
            return false;
        }

        /**
         * Method getProperty
         * 
         * @param index
         */
        public Property getProperty(int index)
        {
            //-- check bounds for index
            if ((index < 0) || (index > _propertyList.Count)) 
            {
                throw new IndexOutOfRangeException();
            }
        
            return (Property) _propertyList[index];
        }

        /**
         * Method getProperty
         */
        public Property[] getProperty()
        {
            return (Property[])_propertyList.ToArray(typeof(Property));
        }

        /**
         * Method getPropertyAsReferenceReturns a reference to
         * 'property'. No type checking is performed on any modications
         * to the Collection.
         * 
         * @return returns a reference to the Collection.
         */
        public ArrayList getPropertyAsReference()
        {
            return _propertyList;
        }

        /**
         * Method getPropertyCount
         */
        public int getPropertyCount()
        {
            return _propertyList.Count;
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
        //    public void marshal(java.io.Writer out)
        //        throws org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //    {
        //        
        //        Marshaller.marshal(this, out);
        //    } //-- void marshal(java.io.Writer) 

        /**
         * Method marshal
         * 
         * @param handler
         */
        //    public void marshal(org.xml.sax.ContentHandler handler)
        //        throws java.io.IOException, org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //    {
        //        
        //        Marshaller.marshal(this, handler);
        //    } //-- void marshal(org.xml.sax.ContentHandler) 

        /**
         * Method removeProperty
         * 
         * @param vProperty
         */
        public Boolean removeProperty(Property vProperty)
        {
            _propertyList.Remove(vProperty);
            return true;
        }

        /**
         * Method setProperty
         * 
         * @param index
         * @param vProperty
         */
        public void setProperty(int index, Property vProperty)
        {
            //-- check bounds for index
            if ((index < 0) || (index > _propertyList.Count)) 
            {
                throw new IndexOutOfRangeException();
            }
            _propertyList[index] = vProperty;
        }

        /**
         * Method setProperty
         * 
         * @param propertyArray
         */
        public void setProperty(Property[] propertyArray)
        {
            //-- copy array
            _propertyList.Clear();
            for (int i = 0; i < propertyArray.Length; i++) 
            {
                _propertyList.Add(propertyArray[i]);
            }
        }

        /**
         * Method setPropertySets the value of 'property' by copying
         * the given ArrayList.
         * 
         * @param propertyCollection the Vector to copy.
         */
        public void setProperty(ArrayList propertyCollection)
        {
            //-- copy collection
            _propertyList.Clear();
            for (int i = 0; i < propertyCollection.Count; i++) 
            {
                _propertyList.Add((Property)propertyCollection[i]);
            }
        }

        /**
         * Method setPropertyAsReferenceSets the value of 'property' by
         * setting it to the given ArrayList. No type checking is
         * performed.
         * 
         * @param propertyCollection the ArrayList to copy.
         */
        public void setPropertyAsReference(ArrayList propertyCollection)
        {
            _propertyList = propertyCollection;
        }

        /**
         * Method unmarshalProperties
         * 
         * @param reader
    //     */
        //    public static Properties unmarshalProperties(Reader reader)
        //        throws org.exolab.castor.xml.MarshalException, org.exolab.castor.xml.ValidationException
        //    {
        //        return (com.ibm.lsid.client.conf.castor.Properties) Unmarshaller.unmarshal(com.ibm.lsid.client.conf.castor.Properties.class, reader);
        //    } //-- com.ibm.lsid.client.conf.castor.Properties unmarshalProperties(java.io.Reader) 

        /**
         * Method validate
         */
        public void validate()
        {
            //        org.exolab.castor.xml.Validator validator = new org.exolab.castor.xml.Validator();
            //        validator.validate(this);
        } //-- void validate() 

    }
}
