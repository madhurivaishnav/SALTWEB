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
    
    <!-- Content -->
    
    <xsl:template match="Page">
       <table cellpadding="0" cellspacing="0" border="0" width="100%">
            <tr>
                <Td class="LegalContent">
    		            <xsl:apply-templates select="PageElements" />
                </Td>
                
            </tr>
       </table>
    </xsl:template>
    
    <xsl:template match="PageElements">
        <table cellpadding="0" cellspacing="0" border="0" width="100%">
        <tr>
            <td> 
                <div class="LegalContentLeft">
					<xsl:call-template name="PageTitle"/>
					
					<!-- If the first page element is image, show all page elements except the first image
						otherwise show page elements. -->
						
					<xsl:choose>
					    
						<xsl:when test="count(PageElement[1]/Graphic)=1">
		                    <xsl:apply-templates select="PageElement[position()!=1]" />
						</xsl:when> 
						<xsl:otherwise>
		                    <xsl:apply-templates select="PageElement" />
						</xsl:otherwise>
					</xsl:choose>
                </div>
            </td>
            <td class="LegalContentRight">
				<!-- If the first page element is image, show the image in the right hand side
					otherwise show generic image -->
				<xsl:choose>
					<xsl:when test="count(PageElement[1]/Graphic)=1">
						<xsl:apply-templates select="PageElement[1]" />	
					</xsl:when>
					<xsl:otherwise>
						<img src="/General/Images/InfoPath/InfoPathGenericImage.gif" />
					</xsl:otherwise>
				</xsl:choose>
            </td>
        </tr>
		</table>
     </xsl:template>

    <xsl:template match="PageElement">
			<xsl:apply-templates select="*" />
			<br/>
    </xsl:template>

</xsl:stylesheet>