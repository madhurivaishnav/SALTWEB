<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" omit-xml-declaration="yes" indent="yes"/>
    <xsl:include href="_Include.xslt" />
    <xsl:template match="/">
         <xsl:apply-templates select="FreeTextQA"/>
    </xsl:template>
    
    <xsl:template match="FreeTextQA">
        <div class="FreeTextQA_Main">
            <xsl:apply-templates select="Question"/>
            <xsl:apply-templates select="Feedback"/>
        </div>
    </xsl:template>    
    
    <xsl:template match="Question">
        <div class="FreeTextQA_Question">
            <xsl:apply-templates select="." mode="CopyNode"/>
        </div>
        <div class="FreeTextQA_Input">
            <!-- xsl:element name="input">
                <xsl:attribute name="class">FreeTextQA_Input</xsl:attribute>
                <xsl:attribute name="type">text</xsl:attribute>
                <xsl:attribute name="ID"><xsl:value-of select="@GUID"  disable-output-escaping="yes"/></xsl:attribute>
            </xsl:element -->
            <xsl:element name="textarea">
                <xsl:attribute name="class">FreeTextQA_Input</xsl:attribute>
                <xsl:attribute name="rows">7</xsl:attribute>
                <xsl:attribute name="cols">30</xsl:attribute>
                <xsl:attribute name="ID"><xsl:value-of select="@GUID"  disable-output-escaping="yes"/></xsl:attribute>
            </xsl:element>
        </div>
        <xsl:element name="input">
            <xsl:attribute name="type">button</xsl:attribute>
            <xsl:attribute name="class">FreeTextQA_FeedbackButton</xsl:attribute>
            <xsl:attribute name="value">Show Answer</xsl:attribute>
            <xsl:attribute name="onClick">GiveFeedback(this,'<xsl:value-of select="../Feedback/@GUID"/>');</xsl:attribute>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="Feedback">
        <xsl:element name="div">
            <xsl:attribute name="class">FreeTextQA_Feedback</xsl:attribute>
            <xsl:attribute name="ID"><xsl:value-of select="@GUID"  disable-output-escaping="yes"/></xsl:attribute>
            <xsl:apply-templates select="." mode="CopyNode"/>
            <div id="{@GUID}" style="vertical-align:bottom;padding-right:2px;" align="right">
				<a id="btnCloseFeedback" href="javascript:HideFreeTxtFeedback('{@GUID}');">
					<img src="/General/Images/InfoPath/CC_Close.gif" onmouseover="this.src=activeCloseImg;" onmouseout="this.src=closeImg;" border="0" alt="Close"/></a></div>
        </xsl:element>
    </xsl:template>
    
</xsl:stylesheet>