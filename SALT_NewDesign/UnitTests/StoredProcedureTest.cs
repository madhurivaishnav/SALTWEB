using System;
using System.Data;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Bdw.Application.Salt.BusinessServices;
using NUnit.Framework;

namespace UnitTests
{

	public class Recordset
	{

	}

	[TestFixture]
	/// <summary>
	/// Summary description for Class1.
	/// </summary>
	public class BusinessServicesTest
	{

		DataSet ds;
		DataTable dt;
		SqlConnection conn;
		string strFileName = @"..\..\XML\TestData.xml";
		string strDbRows = "UnitTests/User_cs/Record";


		
		[TestFixtureSetUp]
		public void DBConnect()
		{
			// Create test sample of 10 records
			// use the same db connection for the collection of tests
			string source = "server=SYD-SQL-DEV1; Integrated Security=SSPI; database=Salt_Testing";
			conn = new SqlConnection( source );
			// delete possibly existing sample data in the database
			// insert sample data into the database

			try
			{

				System.Xml.XmlDocument docTestFixtureData = new System.Xml.XmlDocument();
				docTestFixtureData.Load( strFileName );

				System.Xml.XmlNodeList nodeDbRecords = docTestFixtureData.SelectNodes( strDbRows );
				foreach( System.Xml.XmlNodeList nodeDbRecord in nodeDbRecords )
				{
					foreach( System.Xml.XmlNode nodeDbCell in nodeDbRecord )
					{
						System.Diagnostics.Debug.WriteLine( nodeDbCell.Value );
					}
				}
			}
			catch
			{

			}


			ds = new DataSet(); // reset ds for each test
	

		}

		[SetUp]
		public void Init()
		{

			dt = new DataTable(); // reset data table for each test
		}


		[Test]
		public void GetUser()
		{

			// create user object populate data table
			User user = new User();
			dt = user.GetUser(10);

			foreach ( DataRow row in dt.Rows )
			{
				Assert.AreEqual( ds, row[0] );
				Assert.AreEqual( ds, row[1] );
				Assert.AreEqual( ds, row[2] );
				Assert.AreEqual( ds, row[3] );
				Assert.AreEqual( ds, row[4] );
				Assert.AreEqual( ds, row[5] );
				Assert.AreEqual( ds, row[6] );
				Assert.AreEqual( ds, row[7] );
				Assert.AreEqual( ds, row[8] );
				Assert.AreEqual( ds, row[9] );
				Assert.AreEqual( ds, row[10] );
				Assert.AreEqual( ds, row[11] );
			}
        }

		
	}
}
