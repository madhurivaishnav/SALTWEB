<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:template name="PageElement_FreeTextQA">
    
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [FreeTextQA]
        </fo:block>
        
        <fo:table border="solid black" table-layout="fixed" width="18cm">
            <fo:table-column column-width="18cm"/>
            <fo:table-header text-align="center" font-weight="bold">
                <fo:table-row border-bottom="solid black" background-color="silver">
                    <fo:table-cell padding="1mm" border-left="solid black">
                        <fo:block font-weight="bold">
                            <xsl:apply-templates select="Question" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body>
                <fo:table-row border-bottom="solid black">
                    <fo:table-cell padding="1mm" border-left="solid black">
                        <fo:block font-weight="normal">
                            <xsl:apply-templates select="Feedback" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
                <xsl:apply-templates select="Answer" />
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <xsl:template match="Question">
        <xsl:apply-templates select="." mode="CopyNode" />
    </xsl:template>
    <xsl:template match="Feedback">
        <xsl:apply-templates select="." mode="CopyNode" />
    </xsl:template>
</xsl:stylesheet>
