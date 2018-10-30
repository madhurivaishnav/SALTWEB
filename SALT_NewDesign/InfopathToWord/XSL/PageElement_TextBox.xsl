<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:template name="PageElement_TextBox">
        
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [TextBox]
        </fo:block>
       
        <fo:table border="solid black" width="18cm" table-layout="fixed">
            <fo:table-column column-width="18cm"/>
            <fo:table-body>
                <fo:table-row border-bottom="solid black">
                    <fo:table-cell padding="1mm" border-left="solid black">
                        <fo:block font-weight="normal" font-size="10pt" reference-orientation="180">
                            <xsl:value-of select="Description" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        
    </xsl:template>
</xsl:stylesheet>
