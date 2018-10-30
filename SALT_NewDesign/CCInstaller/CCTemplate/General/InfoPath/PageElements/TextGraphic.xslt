<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
	<xsl:include href="_Include.xslt" />
     <xsl:template match="/">
         <xsl:apply-templates select="TextGraphic"/>
    </xsl:template>
    
    <xsl:template match="TextGraphic">
        <div class="TextGraphic_Main">
        <table border="0" align="center" cellpadding="0" cellspacing="0" class="TextGraphic_Main">
            <tr>
                <xsl:choose>
                    <xsl:when test="Picture/Align='Left'">
                        <td class="TextGraphic_Image_Left">
                            <xsl:apply-templates select="Picture"/>
                        </td>
                        <td class="TextGraphic_Description">
							<xsl:apply-templates select="Description" mode="CopyNode"/>
                        </td>
                    </xsl:when>
                    <xsl:otherwise>
                        <td class="TextGraphic_Description">
							<xsl:apply-templates select="Description" mode="CopyNode"/>
                        </td>
                        <td class="TextGraphic_Image_Right">
                            <xsl:apply-templates select="Picture"/>
                        </td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
        </table>
        </div>
    </xsl:template>
</xsl:stylesheet>



  