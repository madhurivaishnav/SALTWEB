<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_ScenarioInclude.xslt" />
	<xsl:include href="_Generic.xslt" />
	<xsl:template match="BDWInfoPathLesson">
		<xsl:call-template name="GenericLessonLayout" />
	</xsl:template>
	<xsl:template match="BDWInfoPathQuiz">
		<xsl:call-template name="GenericQuizLayout" />
	</xsl:template>
	<!-- Content -->
	<xsl:template match="Page">
		<table cellpadding="0" class="TDBGColour" cellspacing="0" border="0" width="100%">
			<tr class="TDBGColour">
				<Td class="LegalContent">
					<xsl:apply-templates select="PageElements" />
				</Td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="PageElements">
		<table cellpadding="0" class="TDBGColour" cellspacing="0" border="0" width="100%">
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
						<!--Hidden DIV to display Popup Results-->
						<div ID="OptionContent_Result" class="ExtraInfo_Hide_Option">
							<table border="0" align="center" height="98%" width="98%" cellpadding="0" cellspacing="0">
								<tr>
									<td id="tblShowMsg" valign="top">
										<xsl:call-template name="Space" />
									</td>
								</tr>
								<tr>
									<td height="2%">
										<xsl:call-template name="ButtonClose" />
									</td>
								</tr>
							</table>
						</div>
						<div ID="OptionContent_ShowPlayer" class="ExtraInfo_Hide_Option">
							<table border="0" align="center" height="98%" width="98%" cellpadding="0" cellspacing="0">
								<tr>
									<td id="tblShowMsgPlayer" valign="top">
										<xsl:call-template name="Space" />
									</td>
								</tr>
								<tr>
									<td height="2%">
										<xsl:call-template name="ButtonClose" />
									</td>
								</tr>
							</table>
						</div>
					</div>
				</td>
				<td class="LegalContentRight">
					<!-- If the first page element is image, show the image in the right hand side
					otherwise show generic image -->
					<table border="0" class="LegalContentBackground" cellpadding="0" cellspacing="0" width="100%">
						<tr>
							<td id="tdScenario" height="200px" style="vertical-align:top;">
								<div class="ScenarioDivLegalContentRight">
									<xsl:choose>
										<xsl:when test="count(PageElement[1]/Graphic)=1">
											<xsl:apply-templates select="PageElement[1]" />
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="PageElement/MeetThePlayer" />
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</td>
						</tr>
						<tr>
							<td style="vertical-align:top;padding-top:4px;">
								<div id="divLegalContentRight">
									<xsl:apply-templates select="PageElement/ExtraInfo" />
								</div>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!--Template to display EXAMPLES, HINTS and CASE STUDIES-->
	<xsl:template name="ExtraInfoExtras">
		<xsl:apply-templates select="PageElement/ExtraInfo" />
	</xsl:template>
	<xsl:template match="PageElement">
		<xsl:apply-templates select="*[not(self::MeetThePlayer)]" />
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
			<span>
				<table cellpadding="0" cellspacing="0" border="0" width="100%" class="MeetThePlayer_Scenario_Main">
					<tr>
						<td width="2%" class="MeetThePlayer_Scenario_Main_Row">
							<xsl:element name="img">
								<xsl:attribute name="class">MeetThePlayer_Scenario_IMG</xsl:attribute>
								<xsl:attribute name="src">/General/Images/InfoPath/CC_MTP.gif</xsl:attribute>
								<xsl:attribute name="name">I<xsl:value-of select="$idvalue" /></xsl:attribute>
								<xsl:attribute name="ID">I<xsl:value-of select="$idvalue" /></xsl:attribute>
								<xsl:attribute name="onClick">ShowMeetThePlayer(this);</xsl:attribute>
								<xsl:attribute name="onmouseover">this.src=ActiveMTP;</xsl:attribute>
								<xsl:attribute name="onmouseout">this.src=MTP;</xsl:attribute>
							</xsl:element>
						</td>
						<td class="MeetThePlayer_Scenario_Main_Row" align="left" style="width:100px;">
							<div class="MeetThePlayer_Scenario_IMG">
								<xsl:value-of select="Name" />
								<!--<xsl:value-of select="Name" />-->
							</div>
						</td>
					</tr>
					<br />
				</table>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="class">HiddenPlayers</xsl:attribute>
					<xsl:attribute name="id">PID<xsl:value-of select="$idvalue" /></xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="Picture/Image" />
					</xsl:attribute>
				</xsl:element>
				<xsl:element name="input">
					<xsl:attribute name="type">hidden</xsl:attribute>
					<xsl:attribute name="class">HiddenPlayers</xsl:attribute>
					<xsl:attribute name="id">PNAME<xsl:value-of select="$idvalue" /></xsl:attribute>
					<xsl:attribute name="value">
						<xsl:value-of select="Name" />
					</xsl:attribute>
				</xsl:element>
				<xsl:element name="SPAN">
					<xsl:attribute name="id">PDESC<xsl:value-of select="$idvalue" /></xsl:attribute>
					<xsl:attribute name="class">HiddenScenarioPlayers</xsl:attribute>
					<xsl:copy-of select="Description/node()" />
				</xsl:element>
			</span>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>