<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://salt.bdw.com/schemas/v3/0">
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

    <xsl:template match="/">
    	<BDWToolBookUpload>
  	     	<xsl:apply-templates/>
		</BDWToolBookUpload>
    </xsl:template>

    <xsl:template match="BDWInfoPathQuiz">
		<xsl:apply-templates select="Summary"/>
		<xsl:apply-templates select="Questions"/>
    </xsl:template>

    <xsl:template match="Summary">
		<ToolBookID><xsl:value-of select="@ID"/></ToolBookID>
		<ToolBookType>quiz</ToolBookType>
		<NumberOfPages><xsl:value-of select="count(../Questions/Page)"/></NumberOfPages>

		<DatePublished>
		    <xsl:choose>
                <xsl:when test="LastModifiedDate=''">
                    <xsl:value-of select="substring-before(CreatedDate,'T')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-before(LastModifiedDate,'T')"/>
                </xsl:otherwise>
            </xsl:choose>
		</DatePublished>

		<UploadType><xsl:value-of select="UploadType"/></UploadType>
    </xsl:template>


    <xsl:template match="Questions">
		<Pages>
		    <xsl:apply-templates select="Page" />
		</Pages>
     </xsl:template>

	<xsl:template match="Page">
        <xsl:element name="Page">
            <xsl:attribute name="ID"><xsl:value-of select="@ID"/></xsl:attribute>
            <PageTitle>
			       <xsl:value-of select="PageElements/PageElement/Question/Description"/>
            </PageTitle>

            <xsl:apply-templates select="PageElements"/>
        </xsl:element>
	</xsl:template>
	
	
	<xsl:template match="PageElements">
		<xsl:apply-templates select="PageElement"/>
    </xsl:template>
    
    <xsl:template match="PageElement">
		<xsl:apply-templates select="Question"/>
    </xsl:template>

    <xsl:template match="Question">
		<xsl:apply-templates select="Answers"/>
    </xsl:template>
    
    <xsl:template match="Answers">
        <Answers>
        	<xsl:apply-templates select="Answer"/>
        </Answers>
    </xsl:template>

    <xsl:template match="Answer">
    	<xsl:element name="Answer">
    		<xsl:attribute name="ID"><xsl:value-of select="@ID"/></xsl:attribute>
    		<xsl:attribute name="correct"><xsl:value-of select="@Correct"/></xsl:attribute>
    		<AnswerText>
    		    <xsl:value-of select="."/>
    		</AnswerText>
    	</xsl:element>
    </xsl:template>

</xsl:stylesheet>