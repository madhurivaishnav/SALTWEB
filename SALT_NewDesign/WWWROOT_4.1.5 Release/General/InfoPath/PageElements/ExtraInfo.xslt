<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:include href="_Include.xslt" />
    <xsl:template match="/">
            <xsl:apply-templates select="ExtraInfo"/>
    </xsl:template>

    <xsl:template match="ExtraInfo">
        <div class="ExtraInfo_Main">
            <xsl:apply-templates select="Heading"/>
            <xsl:apply-templates select="Links"/>
        </div>
    </xsl:template>
    
    <xsl:template match="Heading">
    	<div class="ExtraInfo_Heading">
	    	<xsl:value-of select="."/>
    	</div>
    </xsl:template>
    
    
    <xsl:template match="Links">
		<ul style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px">
    		<xsl:apply-templates select="Link"/>
    	</ul>
    </xsl:template>
    
    <xsl:template match="Link">
			<li>
            <xsl:apply-templates select="*"/>
            </li>
    </xsl:template>
	
	<xsl:template match="Internal">
		<!-- Link -->
	    <xsl:element name="A">
            <xsl:attribute name="HREF">#</xsl:attribute>
            <xsl:attribute name="class">ExtraInfo_Link</xsl:attribute>
            <xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID"/>');</xsl:attribute>
            <xsl:value-of select="Title" />
        </xsl:element>
	    <!-- Details -->
	    <xsl:element name="div">
	            <xsl:attribute name="ID">Content_<xsl:value-of select="@GUID"/></xsl:attribute>
	            <xsl:attribute name="class">ExtraInfo_Hide</xsl:attribute>
					<table>
					<tr>
						<!-- Picture is optional -->
						<xsl:if test="Picture">
							<td class="TextGraphic_Image_Left">
								<xsl:apply-templates select="Picture"/>
							</td>
						</xsl:if> 
						<td class="TextGraphic_Description">
							<xsl:apply-templates select="Description" mode="CopyNode"/>
						</td>
					</tr>
                <tr><td align="center" colspan="2" >            
		             <xsl:element name="A">
			            <xsl:attribute name="HREF">#</xsl:attribute>
				        <xsl:attribute name="class">Hide_Link</xsl:attribute>
					    <xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" disable-output-escaping="yes" />');</xsl:attribute>
						[Hide]
					</xsl:element>
				</td></tr>
				</table>
       </xsl:element>	
	</xsl:template>

	<xsl:template match="External">
		<xsl:element name="A">
            <xsl:attribute name="HREF"><xsl:value-of select="Url" /></xsl:attribute>
            <xsl:attribute name="class">ExtraInfo_Link</xsl:attribute>
            <xsl:attribute name="target">_blank</xsl:attribute>
            <xsl:value-of select="DisplayName"/>
            <!-- DisplayName is optional -->
            <xsl:if test="DisplayName=''">
				<xsl:value-of select="Url"/>
            </xsl:if>
        </xsl:element>
     </xsl:template>
	
</xsl:stylesheet>
