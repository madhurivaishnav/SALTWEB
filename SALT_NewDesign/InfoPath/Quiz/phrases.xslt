<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no" encoding="utf-8" omit-xml-declaration="yes"/> 
	<xsl:template match="/Phrases">	
	<html>
	<head>
		<title>Common Phrases</title>
		<script language="jscript" type="text/javascript">
		 <![CDATA[
	 		var XDocument	= null;
	
			// The Initialize function is called OnLoad.
			function Initialize()
			{
				// Save a reference to the XDocument object.
				XDocument = window.external.Window.XDocument;
			}
		
			function InsertPhrase(phraseID)
			{
				XDocument.Extension.TaskPanelInsertPhrase(phraseID);
			}
		]]>
		</script>
	</head>
	<BODY onLoad="Initialize()" bgcolor="#EAE8E4">
	   <table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td style="FONT-SIZE: 8pt; FONT-FAMILY: Verdana;">
				<xsl:copy-of select="Instruction/node()"/>
			</td>
		</tr>
		<tr><td><hr style="height:1px; color:black;" /></td></tr>
		<tr>
			<td>
				<table border="0" cellspacing="6" cellpadding="0">
					<xsl:for-each select="Phrase">
					<tr>
						<td style="FONT-SIZE: 8pt; FONT-FAMILY: Verdana;">
							<a href="#" onclick="javascript:void InsertPhrase('{@ID}');"><xsl:value-of select="Title"/></a>
						</td>
					</tr>
					</xsl:for-each>
				</table>
			</td>
		</tr>
	   </table>
	</BODY>
	</html>
  </xsl:template>
</xsl:stylesheet>
  