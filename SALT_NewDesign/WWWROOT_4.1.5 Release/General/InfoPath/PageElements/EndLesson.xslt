<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:include href="_Include.xslt" />
    <xsl:template match="/">
            <xsl:apply-templates select="EndLesson"/>
    </xsl:template>
    
    <xsl:template match="EndLesson">
        <div class="EndLesson_Main">
          <xsl:element name="input">
            <xsl:attribute name="type">button</xsl:attribute>
            <xsl:attribute name="class">Navigation_Button_Submit</xsl:attribute>
            <xsl:attribute name="value">End Lesson</xsl:attribute>
            <xsl:attribute name="onClick">__doPostBack('Lesson_End','')</xsl:attribute>
          </xsl:element>
        </div>  
    </xsl:template>
    
</xsl:stylesheet>
