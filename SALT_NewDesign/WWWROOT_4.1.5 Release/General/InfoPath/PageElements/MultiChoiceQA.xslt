<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:include href="_Include.xslt" />    
    <xsl:template match="/">
        <xsl:apply-templates select="MultiChoiceQA"/>
    </xsl:template>
    
    <xsl:template  match="MultiChoiceQA">
        <div class="MultiChoiceQA_Main">
                <xsl:apply-templates select="Question"/>
                <xsl:apply-templates select="Answer"/>
        </div>
    </xsl:template>
    
    <xsl:template match="Question">
        <div class="MultiChoiceQA_Question">
            <xsl:apply-templates select="." mode="CopyNode"/>
        </div>
    </xsl:template>
    
    <xsl:template match="Answer">
        <div class="MultiChoiceQA_Answer">
            <xsl:apply-templates select="AnswerText"></xsl:apply-templates>
            <xsl:apply-templates select="Feedback"></xsl:apply-templates>
        </div>
    </xsl:template>
    
    <xsl:template match="AnswerText">
        <div class="MultiChoiceQA_AnswerText">
             <xsl:element name="input">
                <xsl:attribute name="class">MultiChoiceQA_AnswerTextRadio</xsl:attribute>
                <xsl:attribute name="type">radio</xsl:attribute>
                <xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
                <xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
                
                <xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct"/>');</xsl:attribute>
            </xsl:element>
            <xsl:apply-templates select="." mode="CopyNode"/>
        </div>
    </xsl:template>
    
    <xsl:template match="Feedback">
         <xsl:element name="div">
            <xsl:attribute name="class">MultiChoiceQA_AnswerFeedback_Hide</xsl:attribute>
            <xsl:attribute name="ID"><xsl:value-of select="../@GUID" /></xsl:attribute>
            <xsl:apply-templates select="." mode="CopyNode"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>