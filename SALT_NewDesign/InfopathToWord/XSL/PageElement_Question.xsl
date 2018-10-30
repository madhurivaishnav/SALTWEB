<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    
    <xsl:template name="PageElement_Question">
    
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [Question]
        </fo:block>
        
        <fo:table border="solid black" width="18cm" table-layout="fixed">
            <fo:table-column column-width="18cm"/>
            <fo:table-header text-align="center" font-weight="bold">
                <fo:table-row border-bottom="solid black" background-color="silver">
                    <fo:table-cell padding="1mm" border-left="solid black">
                        <fo:block>
                            <xsl:apply-templates select="Description" mode="CopyNode" />
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            
            <fo:table-body>
                <xsl:apply-templates select="Answers" />
            </fo:table-body>
            
        </fo:table>
        
    </xsl:template>
    
    <xsl:template match="Answers">
        <xsl:apply-templates select="Answer" />
    </xsl:template>
    
    <xsl:template match="Answer">
    
        <fo:table-row border-bottom="solid black">
            <fo:table-cell padding="1mm" border-left="solid black">
                <fo:block>
                    <xsl:choose>
                        <!-- Correct Answer -->
                        <xsl:when test="@Correct='true'">
                            <fo:block font-weight="bold" color="#00EE00">
                            Correct Answer:
                            </fo:block>
                        </xsl:when>
                        <!-- InCorrect Answer -->
                        <xsl:otherwise>
                            <fo:block font-weight="bold" color="#AA0000">
                            Incorrect Answer:
                            </fo:block>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates select="Description" mode="CopyNode" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
        
    </xsl:template>
    
</xsl:stylesheet>
