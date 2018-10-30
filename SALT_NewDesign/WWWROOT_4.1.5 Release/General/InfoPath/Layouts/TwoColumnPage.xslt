<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" omit-xml-declaration="yes" indent="yes" />
    <xsl:include href="_Include.xslt" />
    <xsl:include href="_Generic.xslt" />
    <xsl:template match="BDWInfoPathLesson">
        <xsl:call-template name="GenericLessonLayout" />
    </xsl:template>
    <xsl:template match="BDWInfoPathQuiz">
        <xsl:call-template name="GenericQuizLayout" />
    </xsl:template>
    <xsl:template match="Page">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <Td>
                    <div class="allContent">
                        <xsl:apply-templates select="PageElements" />
                    </div>
                </Td>
            </tr>
        </table>
    </xsl:template>
    <xsl:template match="PageElements">
        <xsl:variable name="PageElementCount" select="count(PageElement)" />
        
        
        <table cellpadding="0" cellspacing="0" border="0" width="100%" height="100%" class="TwoColumnTable">
            <tr>
                <td class="TwoColumnLeft" valign="top">
                    <xsl:call-template name="PageTitle" />
                    <xsl:apply-templates select="PageElement[position() &lt; ($PageElementCount div 2+1)]" />
                </td>
                <td class="TwoColumnRight" valign="top" rowspan="2">
                    <xsl:apply-templates select="PageElement[position() &gt;= ($PageElementCount div 2+1)]" />
                </td>
            </tr> 
            
        </table>
    </xsl:template>
    <xsl:template match="PageElement">
        <xsl:apply-templates select="*" />
        <br />
    </xsl:template>
</xsl:stylesheet>