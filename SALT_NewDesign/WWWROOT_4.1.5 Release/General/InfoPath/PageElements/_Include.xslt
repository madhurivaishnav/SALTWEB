<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<!-- The following template copy the elements, it functions the same as <xsl:copy-of>, but handle the external hyper links
		Usage: <xsl:apply-templates select="." mode="CopyNode"/> 
	-->
 	 <xsl:template match="@*|node()" mode="CopyNode">
	   <xsl:copy>
			<!-- if the element name is "a" and the value of the href attribute starts with "http", it is an external link, and should be opened in a new window -->
			<xsl:if test="name()='a' and starts-with(translate(@href,'HTP','htp'),'http') and not(@target)">
				<xsl:attribute name="target">
					<xsl:value-of select="'_blank'"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="@*|node()" mode="CopyNode"/>			
	    </xsl:copy>
  </xsl:template>
  
	<!-- Show Picture element -->
    <xsl:template match="Picture">
            <xsl:element name="img">
				<xsl:attribute name="src"><xsl:value-of select="Image" /></xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="AltText" disable-output-escaping="yes"/></xsl:attribute>
				<xsl:attribute name="align">texttop</xsl:attribute>
            </xsl:element>
    </xsl:template>

</xsl:stylesheet>