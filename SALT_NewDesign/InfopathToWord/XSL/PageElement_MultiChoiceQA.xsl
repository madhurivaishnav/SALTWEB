<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:template name="PageElement_MultiChoiceQA">
    
        <fo:block font-weight="bold" color="#0000aa" space-before="30pt">
            [MultiChoiceQA]
        </fo:block>
        
        <fo:table border="solid black" table-layout="fixed" width="18cm">
            <fo:table-column column-width="18cm"/>
            <fo:table-header text-align="center" font-weight="bold">
                <fo:table-row border-bottom="solid black" background-color="silver">
                    <fo:table-cell padding="1mm" border-left="solid black">
                        <xsl:call-template name="Question" />
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            
            <fo:table-body>
                <xsl:for-each select="Answer">
                    <xsl:call-template name="Question_Answer" />
                    <xsl:call-template name="Question_Answer_Feedback" />
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
        
    </xsl:template>
    
    <xsl:template name="Question">
        <fo:block font-weight="bold">
            <xsl:apply-templates select="Question/." mode="CopyNode" />
        </fo:block>
        
    </xsl:template>
    <xsl:template name="Question_Answer">
        <fo:table-row border-bottom="solid black">
            <fo:table-cell padding="1mm" border-left="solid black">
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
                <fo:block font-weight="normal" font-size="10pt">
                    <xsl:apply-templates select="AnswerText/." mode="CopyNode" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template name="Question_Answer_Feedback">
        <fo:table-row border-bottom="solid black">
            <fo:table-cell padding="1mm" border-left="solid black">
                <fo:block font-weight="normal" font-size="10pt">
                    <xsl:apply-templates select="Feedback/." mode="CopyNode" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
</xsl:stylesheet>
