<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:template match="/">
		<xsl:apply-templates select="Question" />
	</xsl:template>
	<xsl:template match="Question">
		<div class="Question_Main">
			<div class="Question_Text">
				<xsl:apply-templates select="Description" mode="CopyNode" />
			</div>
			<br />
			<hr class="Question_Answer_Divider" />
			<br />
			<xsl:apply-templates select="Answers" />
		</div>
	</xsl:template>
	<xsl:template match="Answers">
		<div class="Question_Answers">
			<xsl:apply-templates select="Answer" />
		</div>
	</xsl:template>
	<xsl:template match="Answer">
		<div class="Question_Answer">
			<xsl:element name="input">
				<xsl:attribute name="type">radio</xsl:attribute>
				<xsl:attribute name="ID">Answer_<xsl:value-of select="@ID" /></xsl:attribute>
				<xsl:attribute name="Name">Answer</xsl:attribute>
				<xsl:attribute name="Value">
					<xsl:value-of select="@ID" />
				</xsl:attribute>
				<xsl:attribute name="class">Question_Answer_Radio</xsl:attribute>
				<xsl:attribute name="onClick">SelectAnswer(<xsl:value-of select="@ID" />);</xsl:attribute>
			</xsl:element>
			<xsl:element name="label">
				<xsl:attribute name="class">Question_Label_Off</xsl:attribute>
				<xsl:attribute name="ID">Label_<xsl:value-of select="@ID" /></xsl:attribute>
				<xsl:attribute name="for">Answer_<xsl:value-of select="@ID" /></xsl:attribute>
				<xsl:attribute name="onClick">SelectAnswer(<xsl:value-of select="@ID" />);</xsl:attribute>
			</xsl:element>
			<xsl:apply-templates select="Description" mode="CopyNode" />
		</div>
	</xsl:template>
</xsl:stylesheet>
