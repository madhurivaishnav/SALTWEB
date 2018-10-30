<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" omit-xml-declaration="yes" indent="yes" />
	<xsl:include href="_Include.xslt" />
	<xsl:template match="/">
		<xsl:apply-templates select="MultiChoiceQA" />
	</xsl:template>
	<xsl:template match="MultiChoiceQA">
		<table border="0" style="position:absolute;bottom:2px;height:400px;" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="bottom">
					<div>
						<xsl:apply-templates select="Question" />
						<xsl:apply-templates select="Answer" />
					</div>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template match="Question">
		<div class="MultiChoiceQA_Question">
			<xsl:apply-templates select="." mode="CopyNode" />
		</div>
	</xsl:template>
	<xsl:template match="Answer">
		<xsl:param name="ACount" select="position()"></xsl:param>
		<div class="MultiChoiceQA_Answer">
			<xsl:apply-templates select="AnswerText">
				<xsl:with-param name="avalue">
					<xsl:value-of select="$ACount" />
				</xsl:with-param>
			</xsl:apply-templates>
			<xsl:apply-templates select="Feedback"></xsl:apply-templates>
		</div>
	</xsl:template>
	<xsl:template match="AnswerText">
		<xsl:param name="avalue"></xsl:param>
		<div>
			<table border="0" rowspacing="1" rowpadding="1" cellpadding="0" cellspacing="0" class="MultiChoiceQA_AnswerTextRadioTABLE">
				<tr>
					<td class="MultiChoiceQA_AnswerTextRadioTD">
						<xsl:choose>
							<xsl:when test="$avalue=1">
								<xsl:element name="img">
									<xsl:attribute name="class"></xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>																		
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="src">/General/Images/InfoPath/CC_OptA.gif</xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
									<xsl:attribute name="onmouseover">this.src=activeOptA;</xsl:attribute>
									<xsl:attribute name="onmouseout">this.src=optA;</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$avalue=2">
								<xsl:element name="img">
									<xsl:attribute name="class"></xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>																		
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="src">/General/Images/InfoPath/CC_OptB.gif</xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
									<xsl:attribute name="onmouseover">this.src=activeOptB;</xsl:attribute>
									<xsl:attribute name="onmouseout">this.src=optB;</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$avalue=3">
								<xsl:element name="img">
									<xsl:attribute name="class"></xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>																		
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="src">/General/Images/InfoPath/CC_OptC.gif</xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
									<xsl:attribute name="onmouseover">this.src=activeOptC;</xsl:attribute>
									<xsl:attribute name="onmouseout">this.src=optC;</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$avalue=4">
								<xsl:element name="img">
									<xsl:attribute name="class"></xsl:attribute>
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>									
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="src">/General/Images/InfoPath/CC_OptD.gif</xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
									<xsl:attribute name="onmouseover">this.src=activeOptD;</xsl:attribute>
									<xsl:attribute name="onmouseout">this.src=optD;</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:when test="$avalue=5">
								<xsl:element name="img">
									<xsl:attribute name="class"></xsl:attribute>
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>									
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="src">/General/Images/InfoPath/CC_OptE.gif</xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
									<xsl:attribute name="onmouseover">this.src=activeOptE;</xsl:attribute>
									<xsl:attribute name="onmouseout">this.src=optE;</xsl:attribute>
								</xsl:element>
							</xsl:when>
							<xsl:otherwise>
								<xsl:element name="input">
									<xsl:attribute name="class">MultiChoiceQA_AnswerTextRadio</xsl:attribute>
									<xsl:attribute name="type">radio</xsl:attribute>
									<xsl:attribute name="style">cursor:hand</xsl:attribute>																		
									<xsl:attribute name="name">Q<xsl:value-of select="../../Question/@GUID" /></xsl:attribute>
									<xsl:attribute name="ID">A<xsl:value-of select="../@GUID" /></xsl:attribute>
									<xsl:attribute name="onClick">ShowAnswer('<xsl:value-of select="../@GUID" />','<xsl:value-of select="../@Correct" />');</xsl:attribute>
								</xsl:element>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td class="MultiChoiceQA_AnswerTextRadioTD2">
						<xsl:apply-templates select="." mode="CopyNode" />
					</td>
				</tr>
			</table>
		</div>
	</xsl:template>
	<xsl:template match="Feedback">
		<xsl:element name="div">
			<xsl:attribute name="class">MultiChoiceQA_AnswerFeedback_Hide</xsl:attribute>
			<xsl:attribute name="ID">
				<xsl:value-of select="../@GUID" />
			</xsl:attribute>
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td id="tblShowMsg" valign="top">
						<xsl:apply-templates select="." mode="CopyNode" />
					</td>
				</tr>
				<tr>
					<td height="2%">
						<div id="divClose" style="cursor:hand;position:relative;vertical-align:bottom;padding-right:2px;"
							align="right">
							<xsl:element name="A">
								<xsl:attribute name="onClick">HideShowMessage('<xsl:value-of select="../@GUID" />');</xsl:attribute>
								<img src="/General/Images/InfoPath/CCClose_Button.gif" border="0" alt="Close" />
							</xsl:element>
						</div>
					</td>
				</tr>
			</table>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>