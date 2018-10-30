<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns="http://salt.bdw.com/schemas/v3/0"
>
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>

    <xsl:template match="/">
    	<BDWToolBookUpload>
  	     	<xsl:apply-templates/>
		</BDWToolBookUpload>
    </xsl:template>

    <xsl:template match="BDWInfoPathLesson">
		<xsl:apply-templates select="Summary"/>
		<xsl:apply-templates select="Pages"/>
    </xsl:template>
    
    <xsl:template match="Summary">
		<ToolBookID><xsl:value-of select="@ID"/></ToolBookID>
		<ToolBookType><xsl:value-of select="ContentType"/></ToolBookType>
		<NumberOfPages><xsl:value-of select="count(../Pages/Page)"/></NumberOfPages>
		
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
    
     <xsl:template match="Pages">
		<Pages>
			<xsl:apply-templates select="Page"/>
		</Pages>
     </xsl:template>

    <xsl:template match="Page">
            <xsl:element name="Page">
			    <xsl:attribute name="ID"><xsl:value-of select="@ID"/></xsl:attribute>
			    <PageTitle><xsl:value-of select="Title"/></PageTitle>
		    </xsl:element>
    </xsl:template>
</xsl:stylesheet>