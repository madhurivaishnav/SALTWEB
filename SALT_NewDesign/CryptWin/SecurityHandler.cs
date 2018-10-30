using System;
using System.Text;
using System.Security.Cryptography;
namespace Bdw.Application.Salt.Data
{
	/// <summary>
	/// Summary description for CryptWin.
	/// </summary>
	public class SecurityHandler
	{
        /// <summary>
        /// This is the key used to encrypt strings
        /// </summary>
        private string m_xmlKey="<RSAKeyValue><Modulus>sB88yiSMn6FVCFL5Ttj7GVBo10LXPopEcjO37YlmDS6fVb15HSVQecE6y1QtubLVf1KHKjEdPiMWbbe6q5SeTGt3FyqyOu6rcOOQBZ3SsMQ6KkTrEOEEePykQ5eKE9FX5lhA9qi1pEPy9a89yzUgCgEXDgVViO/O9E/aJ99arJU=</Modulus><Exponent>AQAB</Exponent><P>1yoMt/hcpeSFOIgxUwYh68jmWOEX+RXn7V/NTeUVit/BdQLr2XElDnwWiXQIrM1lfvxhaRZmU/ePiuOQUinGQQ==</P><Q>0YxJEKjbStL+NvMMl8rL7FE5P8+jQWauQW4Un5iX+wuJXr495PJKApuhgh7ie4PlDHXjD8NTo3FlzPlAVj+ZVQ==</Q><DP>wh6e4O/C7qxwgONm1MfInMhhAbj6/vADkgaH3Ioc2HEtQZtEG6ZXz2ymjJZSKU0aD+o1HDFoWsMUDzNmBqrHwQ==</DP><DQ>hpnXIRVl71VCqCdNMn+4p66w2HVWx57eVfcQ1kddcIvDjJElDtg3hB9WClAuaOqbCXr8BFcSdY1Ut+pvUjd+FQ==</DQ><InverseQ>ECyIkKaBfwfhmdlzAQcm7nlBiJYVdRSLyXeB4MaCzy6np5YnkL20+LkKo+spHCTl2blZ+tnKE0vPpGRv1PJh/g==</InverseQ><D>RbaHpGflNcZxVxMo1bnzYmi+pv4xHvMx9pZcJmztdShQL2sJRq0fdqIyuIsAcnHEKlqrX9sC/TZ8ST+hZwszwNnn3GQJ4cpNxF7fXtCPUO2QHUlg6cg6H19kjVH3CIKwYbqHr7/MfHw95d8j4v2O1KAncxPlad5O2SamI+B+kQE=</D></RSAKeyValue>";

        /// <summary>
        /// Member variable of the rsa encryption engine
        /// </summary>
        private RSACryptoServiceProvider m_RSA;
        
        /// <summary>
        /// Gets the public key in xml format
        /// </summary>
        public string XmlPublicKey
        {
            get{return(m_RSA.ToXmlString(false));}
        }

        /// <summary>
        /// Gets the private key in xml format
        /// </summary>
        public string xmlPrivateKey
        {
            get{return(m_RSA.ToXmlString(true));}
        }

        /// <summary>
        /// Default constructor
        /// Instantiates itself with the internal key
        /// </summary>
		public SecurityHandler()
		{
            m_RSA = new RSACryptoServiceProvider();
            m_RSA.FromXmlString(m_xmlKey);
		}

        /// <summary>
        /// Builds a new random key
        /// </summary>
        public void GenerateRandom()
        {
            CspParameters cspParam = new CspParameters();
            cspParam.Flags = CspProviderFlags.UseMachineKeyStore;
            m_RSA = new RSACryptoServiceProvider(cspParam);
        }

        /// <summary>
        /// Encrypts a string
        /// </summary>
        /// <param name="inputString">input string</param>
        /// <returns>encrypted string</returns>
        public string Encrypt(string inputString)
        {
            byte[] decrypted = System.Text.Encoding.Unicode.GetBytes(inputString);
            byte[] encrypted = m_RSA.Encrypt(decrypted, false);
            return(System.Convert.ToBase64String(encrypted));
        }	

        /// <summary>
        /// Decrypts a string
        /// </summary>
        /// <param name="inputString">input string</param>
        /// <returns>decrypted string</returns>
        public string Decrypt(string inputString)
        {
            byte[] encrypted = System.Convert.FromBase64String(inputString);
            byte[] decrypted = m_RSA.Decrypt(encrypted, false);
            return(Encoding.Unicode.GetString(decrypted));
        }

        /// <summary>
        /// Returns the object as an xml string.
        /// </summary>
        /// <returns>xml string of the object.</returns>
        public override string ToString()
        {
            return m_RSA.ToXmlString(true);
        }

	}
}
