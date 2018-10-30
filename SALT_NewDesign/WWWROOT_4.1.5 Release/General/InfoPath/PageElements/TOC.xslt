<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:template match="/">
            <xsl:apply-templates select="*/Pages"/>
    </xsl:template>

	<xsl:template match="Pages">
		<div class="TableOfContents_Main">
		    <div class="TableOfContentsTitle">Table of Contents</div>
		    <ul class="TableOfContentsList">
		        <xsl:apply-templates select="Page[IncludedInTOC='true']" />
			</ul>
         </div>
	</xsl:template>

    <xsl:template match="Page">
    	<li class="TableOfContentsListItem"/>
    	    <xsl:element name="A">
                <xsl:attribute name="class">TableOfContents_Link</xsl:attribute>
                <xsl:attribute name="HREF">javascript:__doPostBack('TableOfContents_Click','<xsl:value-of select="@ID"/>')</xsl:attribute>
                <xsl:value-of select="Title"/>
            </xsl:element>            
    </xsl:template>

</xsl:stylesheet>
