<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:include href="_Generic.xslt" />
	<xsl:template match="BDWInfoPathLesson">
		<xsl:call-template name="GenericLessonLayout" />
	</xsl:template>
	<xsl:template match="BDWInfoPathQuiz">
		<xsl:call-template name="GenericQuizLayout" />
	</xsl:template>
	<!-- Content -->
	<xsl:template match="Page">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<Td class="LegalContent">
					<xsl:apply-templates select="PageElements" />
				</Td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="PageElements">
		<table cellpadding="0" cellspacing="0" border="0" width="100%">
			<tr>
				<td>
					<div id="divLegalContentLeft" class="LegalContentLeft">
						<xsl:call-template name="PageTitle" />
						<!-- If the first page element is image, show all page elements except the first image
						otherwise show page elements. -->
						<xsl:choose>
							<xsl:when test="count(PageElement[1]/Graphic)=1">
								<xsl:apply-templates select="PageElement[position()!=1]" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="PageElement" />
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</td>
				<td class="LegalContentRight">
					<!-- If the first page element is image, show the image in the right hand side
					otherwise show generic image -->
					<table border="0" class="LegalContentBackground" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td height="200px" style="vertical-align:top;">
								<div class="DivLegalContentRight">
									<xsl:choose>
										<xsl:when test="count(PageElement[1]/Graphic)=1">
											<xsl:apply-templates select="PageElement[1]" />
										</xsl:when>
										<xsl:otherwise></xsl:otherwise>
									</xsl:choose>
								</div>
							</td>
						</tr>
						<tr>
							<td id="tdExtraInfo" style="vertical-align:top;padding-top:4px;">
								<div id="divLegalContentRight">
									<!--<xsl:call-template name="Space" />-->
									<xsl:apply-templates select="PageElement/ExtraInfo" />
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="PageElement">
		<xsl:apply-templates select="*" />
	</xsl:template>
	<xsl:template match="MeetThePlayer">
		<xsl:apply-templates select="//Player">
			<xsl:with-param name="idvalue">
				<xsl:value-of select="@ID" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Player">
		<xsl:param name="idvalue"></xsl:param>
		<xsl:if test="@ID=$idvalue">
			<table cellpadding="0" cellspacing="0" border="0" class="MeetThePlayer_Main">
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
		</xsl:if>
	</xsl:template>
	<!-- Show Picture element -->
	<xsl:template match="Picture">
		<xsl:element name="img">
			<xsl:attribute name="src">
				<xsl:value-of select="Image" />
			</xsl:attribute>
			<xsl:attribute name="alt">
				<xsl:value-of select="AltText" disable-output-escaping="yes" />
			</xsl:attribute>
			<xsl:attribute name="align">texttop</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>