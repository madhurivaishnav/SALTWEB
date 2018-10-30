<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-20T23-45-49" xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" version="1.0">
	<xsl:output encoding="UTF-8" method="xml"/>
	<xsl:template match="text() | *[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="/">
		<xsl:copy-of select="processing-instruction() | comment()"/>
		<xsl:choose>
			<xsl:when test="Phrases">
				<xsl:apply-templates select="Phrases" mode="_0"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="var">
					<xsl:element name="Phrases"/>
				</xsl:variable>
				<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Phrase" mode="_1">
		<xsl:copy>
			<xsl:attribute name="ID">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>
			<xsl:if test="Title">
				<xsl:element name="Title">
					<xsl:copy-of select="Title/text()[1]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="Text">
				<xsl:element name="Text">
					<xsl:apply-templates select="Text/text() | Text/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
				</xsl:element>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Phrases" mode="_0">
		<xsl:copy>
			<xsl:if test="ContentType">
				<xsl:element name="ContentType">
					<xsl:copy-of select="ContentType/text()[1]"/>
				</xsl:element>
			</xsl:if>
			<xsl:if test="Instruction">
				<xsl:element name="Instruction">
					<xsl:apply-templates select="Instruction/text() | Instruction/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
				</xsl:element>
			</xsl:if>
			<xsl:apply-templates select="Phrase" mode="_1"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>