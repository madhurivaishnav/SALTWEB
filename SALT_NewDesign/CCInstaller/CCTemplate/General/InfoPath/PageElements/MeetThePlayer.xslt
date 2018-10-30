<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:template match="/">
		<xsl:apply-templates select="Player" />
	</xsl:template>
	<xsl:template match="Player">
		<table cellpadding="0" cellspacing="0" border="1" class="MeetThePlayer_Main">
			<tr>
				<td class="MeetThePlayer_Image">
					<xsl:apply-templates select="Picture" />
				</td>
				<td valign="top">
					<div class="MeetThePlayer_Name">
						<xsl:value-of select="Name" />
					</div>
					<div class="MeetThePlayer_Desc">
						<xsl:apply-templates select="Description" mode="CopyNode" />
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
