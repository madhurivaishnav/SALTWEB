<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:include href="_Include.xslt" />
    <xsl:template match="/">
            <xsl:apply-templates select="Graphic"/>
    </xsl:template>
    
    <xsl:template match="Graphic">
        <div class="Graphic_Main">
            <xsl:apply-templates select="Picture"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
