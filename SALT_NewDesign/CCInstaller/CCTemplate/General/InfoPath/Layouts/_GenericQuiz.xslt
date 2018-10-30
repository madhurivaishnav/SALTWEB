<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" omit-xml-declaration="yes" indent="yes" />
	<!-- Generic layout stylesheet -->
	<xsl:template name="GenericLessonLayout">
		<table border="0" class="TABLEBODY" align="center" cellpadding="0" cellspacing="0" height="100%"
			width="100%">
			<tr>
				<td>
					<table class="Main_Table" id="Main_Table" align="center" valign="center" cellpadding="0"
						cellspacing="0" border="0">
						<tr class="Main_Table_Top_Row">
							<td valign="top">
								<xsl:call-template name="GenericLessonHeader" />
							</td>
						</tr>
						<tr class="Main_Table_Content_Row">
							<td valign="top">
								<xsl:apply-templates select="//Page[@ID=$PageID]" />
							</td>
						</tr>
						<tr>
							<td class="Main_Table_Navigation">
								<xsl:call-template name="GenericLessonFooter" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="GenericQuizLayout">
		<table border="0" class="TABLEBODY" align="center" cellpadding="0" cellspacing="0" height="100%"
			width="100%">
			<tr>
				<td>
					<table class="Main_Table" id="Main_Table" align="center" cellpadding="0" cellspacing="0"
						border="0">
						<tr class="Main_Table_Top_Row">
							<td valign="top">
								<xsl:call-template name="GenericQuizHeader" />
							</td>
						</tr>
						<tr class="Main_Table_Content_Row">
							<td valign="top">
								<xsl:apply-templates select="//Page[@ID=$PageID]" />
							</td>
						</tr>
						<tr>
							<td class="Main_Table_Navigation">
								<xsl:call-template name="GenericQuizFooter" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</xsl:template>
	<!-- Headers  -->
	<xsl:template name="GenericLessonHeader">
		<!-- Page Header -->
		<xsl:call-template name="PageHeader" />
		<!-- Navigation Section -->
		<table class="TopNavBar" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="20px" align="center" nowrap="true">
					<xsl:call-template name="Space" />
				</td>
				<td>
					<xsl:call-template name="Space" />
				</td>
				<td valign="top" width="100%" align="center">
					<xsl:call-template name="ButtonSpacer" />
				</td>
				<td>
					<xsl:call-template name="ButtonHome" />
				</td>
				<td>
					<xsl:call-template name="ButtonQuickFacts" />
				</td> <!--
                <td class="ButtonDisclaimer">
                    <xsl:call-template name="Disclaimer"/>
                </td>
                 -->
				<td align="center">
					<xsl:call-template name="ButtonExitLesson" />
					<xsl:call-template name="PageCount" />
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="GenericQuizHeader">
		<!-- Page Header -->
		<xsl:call-template name="PageHeader" />
		<!-- Navigation Section -->
		<table class="TopNavBar" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="20px" align="center" nowrap="true">
					<xsl:call-template name="Space" />
				</td>
				<td>
					<xsl:call-template name="Space" />
				</td>
				<td valign="top" width="100%" align="center">
					<xsl:call-template name="ButtonSpacer" />
				</td>
				<td>
					<xsl:call-template name="ButtonQuizInstructions" />
				</td>
				<td>
					<xsl:call-template name="ButtonExitQuiz" />
				</td> <!--
                <td class="ButtonDisclaimer">
                    <xsl:call-template name="Disclaimer"/>
                </td>                 
				<td align="center">
					<xsl:call-template name="ButtonExitQuiz" />
				</td>
				
				<td width="100%" align="center">
					<xsl:call-template name="ButtonSpacer" />
				</td>
				<td class="ButtonHome">
					<xsl:call-template name="ButtonHome" />
				</td>
				<td class="ButtonDisclaimer">
					<xsl:call-template name="Disclaimer" />
				</td>
				<td class="ButtonExit">
					<xsl:call-template name="ButtonExitQuiz" />
				</td>-->
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="GenericLessonFooter">
		<!-- Navigation Section -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="80%" align="left" style="padding-left:15px" valign="top">
					<xsl:call-template name="Copyright" />
				</td>
				<td width="10%" valign="top" align="center">
					<xsl:call-template name="ButtonPrevious" />
				</td>
				<td width="10%" valign="top" align="center">
					<xsl:call-template name="ButtonNext" />
				</td>
			</tr>
		</table>
	</xsl:template>
	<xsl:template name="GenericQuizFooter">
		<!-- Navigation Section -->
		<table width="100%" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td width="80%" align="left" style="padding-left:15px" valign="top">
					<xsl:call-template name="Copyright" />
				</td>
				<td width="10%" valign="top" align="center">
					<xsl:call-template name="ButtonPrevious" />
				</td>
				<td width="10%" valign="top" align="center">
					<xsl:call-template name="ButtonQuizNext" />
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
