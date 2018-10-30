<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:include href="_Include.xslt" />
    <xsl:template match="/">
            <xsl:apply-templates select="Players"/>
    </xsl:template>
    
    <xsl:template match="Players">
        <div class="ShowAllPlayers_Main">
            <div class="ShowAllPlayers_Title">
            The players involved in this scenario are:
            </div>
            <ul>
                <xsl:apply-templates select="Player"/>
            </ul>
        </div>
    </xsl:template>
    
    <xsl:template match="Player">
        <li/>
        <!-- links -->
        <xsl:element name="A">
            <xsl:attribute name="HREF">#</xsl:attribute>
            <xsl:attribute name="class">ShowAllPlayers_Link</xsl:attribute>
            <xsl:attribute name="onClick">ShowPlayer_All('<xsl:value-of select="@GUID" disable-output-escaping="yes" />');</xsl:attribute>
            <xsl:value-of select="Name"/>
        </xsl:element>
        <!-- Details -->
        <xsl:element name="div">
            <xsl:attribute name="ID"><xsl:value-of select="@GUID"/></xsl:attribute>
	        <xsl:attribute name="class">ShowAllPlayers_Player_Hide</xsl:attribute>
            <table cellpadding="2" cellspacing="0" border="0">
                <tr>
                    <td  valign="top">
                        <xsl:apply-templates select="Picture"/></td>
                    <td valign="top">
                        <xsl:apply-templates select="Description" mode="CopyNode"/>
                    </td>
                </tr>
                <tr><td align="center" colspan="2" >            
					<xsl:element name="A">
						<xsl:attribute name="HREF">#</xsl:attribute>
						<xsl:attribute name="class">Hide_Link</xsl:attribute>
						<xsl:attribute name="onClick">HidePlayer_All('<xsl:value-of select="@GUID" disable-output-escaping="yes" />');</xsl:attribute>
						[Hide]
					</xsl:element>
					</td></tr>
            </table>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>
