<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:template name="PageElement_ExtraInfo">
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [ExtraInfo]
        </fo:block>
        <fo:table border="solid black" table-layout="fixed" width="18cm">
            <fo:table-column column-width="18cm"/>
                <fo:table-header text-align="center" font-weight="bold">
                    <fo:table-row border-bottom="solid black" background-color="silver">
                        <fo:table-cell padding="1mm" border-left="solid black">
                            <fo:block>
                                <xsl:apply-templates select="Heading" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-header>
                <fo:table-body>
                    <fo:table-row border-bottom="solid black">
                        <fo:table-cell padding="1mm" border-left="solid black">
                            <fo:block font-weight="normal" font-size="10pt">
                                <xsl:apply-templates select="Links" />
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
           
        </fo:table>
    </xsl:template>
    <xsl:template match="Heading">
        <xsl:apply-templates select="." mode="CopyNode" />
    </xsl:template>
    <xsl:template match="Links">
        <xsl:apply-templates select="Link" />
    </xsl:template>
    <xsl:template match="Link">
        <xsl:apply-templates select="Internal" />
        <xsl:apply-templates select="External" />
    </xsl:template>
    <xsl:template match="Internal">
        <xsl:apply-templates select="Title" />
        <xsl:apply-templates select="Description" />
    </xsl:template>
    <xsl:template match="External">
        <xsl:apply-templates select="Title" />
        <xsl:apply-templates select="Description" />
    </xsl:template>
    <xsl:template match="Title">
        <xsl:apply-templates select="." mode="CopyNode" />
    </xsl:template>
    <xsl:template match="Description">
        <xsl:apply-templates select="." mode="CopyNode" />
    </xsl:template>
</xsl:stylesheet>
