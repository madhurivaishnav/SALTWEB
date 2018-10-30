using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.Data;
using System.Collections.Specialized;
using Localization;
namespace Bdw.Application.Salt.BusinessServices
{
	/// <summary>
	/// This class retrieves Organisation Configuration settings.
	/// </summary>
	public class OrganisationConfig
	{
        
        /// <summary>
        /// Gets a list of Organisation configuration
        /// </summary>
        /// <param name="organisationID">Organisation to return configuration values for</param>
        /// <returns></returns>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Kneale, 28/06/2004
        /// Changes:
        /// </remarks>
        public DataTable GetList(int organisationID)
        {
            DataTable dtbClientConfig;

            // Get datatable of results from database
            using(StoredProcedure sp = new StoredProcedure("prcOrganisationConfig_GetList",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, 4, organisationID)
                      ))
            {
                dtbClientConfig = sp.ExecuteTable();
            }

            // return result
            return (dtbClientConfig);
        } // GetList

        /// <summary>
        /// Get a single Organisation configuration value
        /// </summary>
        /// <returns></returns>
        /// <param name="organisationID">Organisation to return configuration values for</param>
        /// <param name="name">Name of the configuration value</param>
        /// <remarks>
        /// Assumptions: None
        /// Notes: 
        /// Author: Peter Kneale, 28/06/2004
        /// Changes:
        /// </remarks>
        public string GetOne(int organisationID,string name)
        {
            // Collection to hold name value pairs
            string strValue;
            
            // Get datatable of results from database
            using(StoredProcedure sp = new StoredProcedure("prcOrganisationConfig_GetOne",
                      StoredProcedure.CreateInputParam("@organisationID", SqlDbType.Int, 4, organisationID),
                      StoredProcedure.CreateInputParam("@name", SqlDbType.NVarChar, 255, name)
                      ))
            {
                strValue = sp.ExecuteScalar().ToString();
            }

            // return result
            return (strValue);
        } // GetList

        /// <summary>
        /// Update an organisations configuration value
        /// </summary>
        /// <param name="organisationID">organisations id</param>
        /// <param name="name">name of the key</param>
        /// <param name="value">value of the key</param>
        /// <param name="description">Description of key</param>
        public void Update(int organisationID, string name,string description, string value)
        {

            using(StoredProcedure sp = new StoredProcedure("prcOrganisationConfig_Update",
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@Name", SqlDbType.NVarChar, name),
                      StoredProcedure.CreateInputParam("@Description", SqlDbType.NVarChar, description),
                      StoredProcedure.CreateInputParam("@Value", SqlDbType.NVarChar, value)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage =  rdr.GetString(1);
				
                //2. Close the reader.
                rdr.Close();
				
                //4. Throw the required exception if error number is not 0.
                switch(intErrorNumber)
                {
                    case 0: // Succeeded.
                    {
                        break;
                    }
                    case 2:
                    {
                        throw new FKViolationException(String.Format(ResourceManager.GetString("prcOrganisationConfig_Update.2"), organisationID.ToString()));
                    }
					case 21:
					{
						throw new FKViolationException(String.Format(ResourceManager.GetString("prcOrganisationConfig_Update.21"), name));
					}
                    case 5: // Parameter Exception.
                    {
                        throw new ParameterException(strErrorMessage);
                    }
                    default: // Whatever is left.
                    {
                        throw new BusinessServiceException(strErrorMessage);
                    }
                }
            }
            
        }

        /// <summary>
        /// Delete an organisation configuration value
        /// </summary>
        /// <param name="organisationID">organisation id</param>
        /// <param name="name">name of key to remove</param>
        public void Delete(int organisationID, string name)
        {

            using(StoredProcedure sp = new StoredProcedure("prcOrganisationConfig_Delete",
                      StoredProcedure.CreateInputParam("@OrganisationID", SqlDbType.Int, organisationID),
                      StoredProcedure.CreateInputParam("@Name", SqlDbType.NVarChar, name)
                      ))
            {
                SqlDataReader rdr = sp.ExecuteReader();
                int intErrorNumber; // Holds the error number return from the stored procedure.
                string strErrorMessage; // Holds the error message return from the stored procedure.

                //1. Get the response.
                rdr.Read();
                intErrorNumber = rdr.GetInt32(0);
                strErrorMessage =  rdr.GetString(1);
				
                //2. Close the reader.
                rdr.Close();
				
                //4. Throw the required exception if error number is not 0.
                switch(intErrorNumber)
                {
                    case 0: // Succeeded.
                    {
                        break;
                    }
					case 2:
					{
						throw new FKViolationException(String.Format(ResourceManager.GetString("prcOrganisationConfig_Delete.2"), organisationID.ToString()));
					}
					case 21:
					{
						throw new FKViolationException(String.Format(ResourceManager.GetString("prcOrganisationConfig_Delete.21"), name));
					}
                    case 5: // Parameter Exception.
                    {
                        throw new ParameterException(strErrorMessage);
                    }
                    default: // Whatever is left.
                    {
                        throw new BusinessServiceException(strErrorMessage);
                    }
                }
            }
            
        }

	}
}



