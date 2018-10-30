<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:include href="_Include.xslt" />
    <xsl:template match="/">
            <xsl:apply-templates select="TextBox"/>
    </xsl:template>

    <xsl:template match="TextBox">
    	<div class="TextBox_Main">
    			<xsl:apply-templates select="Description" mode="CopyNode"/>
        </div>
    </xsl:template>
</xsl:stylesheet>
