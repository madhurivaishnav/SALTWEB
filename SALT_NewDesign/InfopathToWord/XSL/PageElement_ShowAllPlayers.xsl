<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:template name="PageElement_ShowAllPlayers">
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [ShowAllPlayers]
        </fo:block>
         <xsl:apply-templates select="Players"/>
    </xsl:template>

    <xsl:template match="Players">
        The players involved in this scenario are:
        <xsl:apply-templates select="Player"/>
    </xsl:template>
    
    <xsl:template match="Player">
        <xsl:value-of select="Name"/>
        <!-- Details -->
        <xsl:apply-templates select="Description" mode="CopyNode" />
    </xsl:template>
    
    
    </xsl:stylesheet>