<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:include href="_Include.xslt"/>
	<xsl:include href="_Generic.xslt"/>
        
    <xsl:template match="BDWInfoPathLesson">
		<xsl:call-template name="GenericLessonLayout"/>
    </xsl:template>
    
    <xsl:template match="BDWInfoPathQuiz">
        <xsl:call-template name="GenericQuizLayout"/>
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
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td> 
                <div class="SingleColumn">
				    <xsl:call-template name="PageTitle"/>
                    <xsl:apply-templates select="PageElement" />
                </div>
            </td>
        </tr>
        </table>
     </xsl:template>
     
    <xsl:template match="PageElement">
			<xsl:apply-templates select="*" />
			<br/>
    </xsl:template>
</xsl:stylesheet>