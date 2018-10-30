<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:template match="/">
		<xsl:apply-templates select="ExtraInfo" />
	</xsl:template>
	<xsl:template match="ExtraInfo">
		<xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
		<xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
		<div class="ExtraInfo_Main">
			<xsl:choose>
				<xsl:when test="translate(Heading,$lcletters,$ucletters)='EXAMPLE'">
					<xsl:variable name="header" select="EXAMPLE" />
					<xsl:apply-templates select="Links">
						<xsl:with-param name="headervalue">
							<xsl:value-of select="Heading" />
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="translate(Heading,$lcletters,$ucletters)='HINT'">
					<xsl:variable name="header" select="HINT" />
					<xsl:apply-templates select="Links">
						<xsl:with-param name="headervalue">
							<xsl:value-of select="Heading" />
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:when test="translate(Heading,$lcletters,$ucletters)='CASESTUDY'">
					<xsl:variable name="header" select="CASESTUDY" />
					<xsl:apply-templates select="Links">
						<xsl:with-param name="headervalue">
							<xsl:value-of select="Heading" />
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="header" select="OTHER" />
					<xsl:apply-templates select="Heading" />
					<xsl:apply-templates select="Links">
						<xsl:with-param name="headervalue">
							<xsl:value-of select="Heading" />
						</xsl:with-param>
					</xsl:apply-templates>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="Heading">
		<div class="ExtraInfo_Heading">
			<xsl:value-of select="." />
		</div>
	</xsl:template>
	<xsl:template match="Links">
		<xsl:param name="headervalue"></xsl:param>
		<xsl:apply-templates select="Link">
			<xsl:with-param name="headervalue">
				<xsl:value-of select="$headervalue" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Link">
		<xsl:param name="headervalue"></xsl:param>
		<xsl:apply-templates select="*">
			<xsl:with-param name="headervalue">
				<xsl:value-of select="$headervalue" />
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	<xsl:template match="Internal">
		<xsl:param name="headervalue"></xsl:param>
		<!-- Link -->
		<xsl:choose>
			<xsl:when test="$headervalue='EXAMPLE'">
				<table cellpadding="0" cellspacing="0" border="0" class="ExtraInfoExtraVisible">
					<tr>
						<td width="2%" class="" style="padding-left:5px;cursor:hand;">
							<xsl:element name="img">
								<xsl:attribute name="class"></xsl:attribute>
								<xsl:attribute name="src">/General/Images/InfoPath/CC_Example.gif</xsl:attribute>
								<xsl:attribute name="name">EX_"<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="ID">EX_<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" />');</xsl:attribute>
								<xsl:attribute name="onmouseover">this.src=activeExample;</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src=Example;</xsl:attribute>
							</xsl:element>
						</td>
						<td class="" align="left" style="padding-left:5px;vertical-align:top;">
							<div class="">
								<xsl:value-of select="Title" />
							</div>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="$headervalue='HINT'">
				<table cellpadding="0" cellspacing="0" border="0" class="ExtraInfoExtraVisible">
					<tr>
						<td width="2%" class="" style="padding-left:5px;cursor:hand;">
							<xsl:element name="img">
								<xsl:attribute name="class"></xsl:attribute>
								<xsl:attribute name="src">/General/Images/InfoPath/CC_Hint.gif</xsl:attribute>
								<xsl:attribute name="name">HI_"<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="ID">HI_<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" />');</xsl:attribute>
								<xsl:attribute name="onmouseover">this.src=activeHintImg;</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src=hintImg;</xsl:attribute>
							</xsl:element>
						</td>
						<td class="" align="left" style="padding-left:5px;vertical-align:top;">
							<div class="">
								<xsl:value-of select="Title" />
							</div>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="$headervalue='CASESTUDY'">
				<table cellpadding="0" cellspacing="0" border="0" class="ExtraInfoExtraVisible">
					<tr>
						<td width="2%" class="" style="padding-left:5px;cursor:hand;">
							<xsl:element name="img">
								<xsl:attribute name="class"></xsl:attribute>
								<xsl:attribute name="src">/General/Images/InfoPath/CC_CaseStudy.gif</xsl:attribute>
								<xsl:attribute name="name">CS_"<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="ID">CS_<xsl:value-of select="@GUID" /></xsl:attribute>
								<xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" />');</xsl:attribute>
								<xsl:attribute name="onmouseover">this.src=ActiveCaseStudyImg;</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src=CaseStudyImg;</xsl:attribute>
							</xsl:element>
						</td>
						<td class="" align="left" style="padding-left:5px;vertical-align:top;">
							<div class="">
								<xsl:value-of select="Title" />
							</div>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:otherwise>
				<div class="ExtraInfoLinkOther">
					<xsl:element name="A">
						<xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" />');</xsl:attribute>
						<xsl:attribute name="HREF">#</xsl:attribute>
						<xsl:value-of select="Title" />
					</xsl:element>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<!-- Details -->
		<xsl:element name="div">
			<xsl:attribute name="ID">Content_<xsl:value-of select="@GUID" /></xsl:attribute>
			<xsl:attribute name="class">ExtraInfo_Hide</xsl:attribute>
			<table>
				<tr>
					<!-- Picture is optional -->
					<xsl:if test="Picture">
						<td class="TextGraphic_Image_Left">
							<xsl:apply-templates select="Picture" />
						</td>
					</xsl:if>
					<td class="TextGraphic_Description">
						<xsl:apply-templates select="Description" mode="CopyNode" />
					</td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<xsl:element name="img">
							<xsl:attribute name="class"></xsl:attribute>
							<xsl:attribute name="style">position:absolute;left:488px;top:368px;;cursor:hand;</xsl:attribute>
							<xsl:attribute name="src">/General/Images/InfoPath/CC_Close.gif</xsl:attribute>
							<xsl:attribute name="onClick">TogglePopup('<xsl:value-of select="@GUID" disable-output-escaping="yes" />');</xsl:attribute>
							<xsl:attribute name="onmouseover">this.src=activeCloseImg;</xsl:attribute>
							<xsl:attribute name="onmouseout">this.src=closeImg;</xsl:attribute>
						</xsl:element>
					</td>
				</tr>
			</table>
		</xsl:element>
	</xsl:template>
	<xsl:template match="External">
		<xsl:param name="headervalue"></xsl:param>
		<xsl:element name="A">
			<xsl:attribute name="HREF">
				<xsl:value-of select="Url" />
			</xsl:attribute>
			<xsl:attribute name="class">ExtraInfo_Link</xsl:attribute>
			<xsl:attribute name="target">_blank</xsl:attribute>
			<xsl:value-of select="DisplayName" />
			<!-- DisplayName is optional -->
			<xsl:if test="DisplayName=''">
				<xsl:value-of select="Url" />
			</xsl:if>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
