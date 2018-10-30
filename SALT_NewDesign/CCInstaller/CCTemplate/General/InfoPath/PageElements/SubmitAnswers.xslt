<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:template match="/">
		<xsl:apply-templates select="SubmitAnswers" />
	</xsl:template>
	<xsl:template match="SubmitAnswers">
		<div class="SubmitAnswers_Main">
			<xsl:element name="img">
				<xsl:attribute name="class">Navigation_Button_Submit_Quiz</xsl:attribute>
				<xsl:attribute name="style">cursor:hand</xsl:attribute>
				<xsl:attribute name="src">/General/Images/InfoPath/CC_SubmitQuiz.gif</xsl:attribute>
				<xsl:attribute name="onClick">__doPostBack('Quiz_End','');</xsl:attribute>
				<xsl:attribute name="onmouseover">this.src=activeSubmitQAns;</xsl:attribute>
				<xsl:attribute name="onmouseout">this.src=SubmitQAns;</xsl:attribute>
			</xsl:element>
		</div>
	</xsl:template>
</xsl:stylesheet>
