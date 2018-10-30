<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ns1="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T22:48:56" xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-13T23-42-36" xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" version="1.0">
	<xsl:output encoding="UTF-8" method="xml"/>
	<xsl:template match="text() | *[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText">
		<xsl:copy-of select="."/>
	</xsl:template>
	<xsl:template match="/">
		<xsl:copy-of select="processing-instruction() | comment()"/>
		<xsl:choose>
			<xsl:when test="BDWInfoPathLesson">
				<xsl:apply-templates select="BDWInfoPathLesson" mode="_0"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="var">
					<xsl:element name="BDWInfoPathLesson"/>
				</xsl:variable>
				<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_0"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="Summary" mode="_1">
		<xsl:copy>
			<xsl:attribute name="ID">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>
			<xsl:element name="ContentType">
				<xsl:choose>
					<xsl:when test="ContentType">
						<xsl:copy-of select="ContentType/text()[1]"/>
					</xsl:when>
					<xsl:otherwise>lesson</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="UploadType">
				<xsl:choose>
					<xsl:when test="UploadType">
						<xsl:copy-of select="UploadType/text()[1]"/>
					</xsl:when>
					<xsl:otherwise>update</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="Title">
				<xsl:copy-of select="Title/text()[1]"/>
			</xsl:element>
			<xsl:element name="CreatedBy">
				<xsl:copy-of select="CreatedBy/text()[1]"/>
			</xsl:element>
			<xsl:element name="CreatedDate">
				<xsl:copy-of select="CreatedDate/text()[1]"/>
			</xsl:element>
			<xsl:element name="LastModifiedBy">
				<xsl:copy-of select="LastModifiedBy/text()[1]"/>
			</xsl:element>
			<xsl:element name="LastModifiedDate">
				<xsl:choose>
					<xsl:when test="LastModifiedDate/text()[1]">
						<xsl:copy-of select="LastModifiedDate/text()[1]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="xsi:nil">true</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Picture" mode="_4">
		<xsl:copy>
			<xsl:element name="Image">
				<xsl:copy-of select="Image/text()[1]"/>
			</xsl:element>
			<xsl:element name="AltText">
				<xsl:copy-of select="AltText/text()[1]"/>
			</xsl:element>
			<xsl:element name="Align">
				<xsl:choose>
					<xsl:when test="Align">
						<xsl:copy-of select="Align/text()[1]"/>
					</xsl:when>
					<xsl:otherwise>Left</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Player" mode="_3">
		<xsl:copy>
			<xsl:attribute name="ID">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>
			<xsl:element name="Name">
				<xsl:copy-of select="Name/text()[1]"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="Picture">
					<xsl:apply-templates select="Picture[1]" mode="_4"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Picture"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_4"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:element name="Description">
				<xsl:apply-templates select="Description/text() | Description/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Players" mode="_2">
		<xsl:copy>
			<xsl:apply-templates select="Player" mode="_3"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TextGraphic" mode="_9">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="Picture">
					<xsl:apply-templates select="Picture[1]" mode="_4"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Picture"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_4"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:element name="Description">
				<xsl:apply-templates select="Description/text() | Description/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="TextBox" mode="_9">
		<xsl:copy>
			<xsl:element name="Description">
				<xsl:apply-templates select="Description/text() | Description/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Picture" mode="_10">
		<xsl:copy>
			<xsl:element name="Image">
				<xsl:copy-of select="Image/text()[1]"/>
			</xsl:element>
			<xsl:element name="AltText">
				<xsl:copy-of select="AltText/text()[1]"/>
			</xsl:element>
			<xsl:element name="Align">
				<xsl:copy-of select="Align/text()[1]"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Graphic" mode="_9">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="Picture">
					<xsl:apply-templates select="Picture[1]" mode="_10"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Picture"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_10"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Picture" mode="_14">
		<xsl:copy>
			<xsl:element name="Image">
				<xsl:copy-of select="Image/text()[1]"/>
			</xsl:element>
			<xsl:element name="AltText">
				<xsl:copy-of select="AltText/text()[1]"/>
			</xsl:element>
			<xsl:element name="Align">
				<xsl:copy-of select="Align/text()[1]"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Internal" mode="_13">
		<xsl:copy>
			<xsl:element name="Title">
				<xsl:copy-of select="Title/text()[1]"/>
			</xsl:element>
			<xsl:apply-templates select="Picture[1]" mode="_14"/>
			<xsl:element name="Description">
				<xsl:apply-templates select="Description/text() | Description/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="External" mode="_13">
		<xsl:copy>
			<xsl:element name="DisplayName">
				<xsl:copy-of select="DisplayName/text()[1]"/>
			</xsl:element>
			<xsl:element name="Url">
				<xsl:copy-of select="Url/text()[1]"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Link" mode="_12">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="(Internal | External)[1]">
					<xsl:apply-templates select="(Internal | External)[1]" mode="_13"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Internal"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_13"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Links" mode="_11">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="Link">
					<xsl:apply-templates select="Link" mode="_12"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Link"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_12"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ExtraInfo" mode="_9">
		<xsl:copy>
			<xsl:element name="Heading">
				<xsl:copy-of select="Heading/text()[1]"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="Links">
					<xsl:apply-templates select="Links[1]" mode="_11"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Links"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_11"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Answer" mode="_15">
		<xsl:copy>
			<xsl:attribute name="Correct">
				<xsl:choose>
					<xsl:when test="@Correct">
						<xsl:value-of select="@Correct"/>
					</xsl:when>
					<xsl:otherwise>false</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="AnswerText">
				<xsl:apply-templates select="AnswerText/text() | AnswerText/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
			<xsl:element name="Feedback">
				<xsl:apply-templates select="Feedback/text() | Feedback/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="MultiChoiceQA" mode="_9">
		<xsl:copy>
			<xsl:element name="Question">
				<xsl:apply-templates select="Question/text() | Question/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
			<xsl:apply-templates select="Answer" mode="_15"/>
			<xsl:if test="count(Answer) &lt; 2">
				<xsl:variable name="var">
					<xsl:element name="Answer"/>
				</xsl:variable>
				<xsl:if test="not(Answer[1])">
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_15"/>
				</xsl:if>
				<xsl:if test="not(Answer[2])">
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_15"/>
				</xsl:if>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="FreeTextQA" mode="_9">
		<xsl:copy>
			<xsl:element name="Question">
				<xsl:apply-templates select="Question/text() | Question/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
			<xsl:element name="Feedback">
				<xsl:apply-templates select="Feedback/text() | Feedback/*[namespace-uri()='http://www.w3.org/1999/xhtml']" mode="RichText"/>
			</xsl:element>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="MeetThePlayer" mode="_9">
		<xsl:copy>
			<xsl:attribute name="ID">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="ShowAllPlayers" mode="_9">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="TOC" mode="_9">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="EndLesson" mode="_9">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="PageElement" mode="_8">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="(TextGraphic | TextBox | Graphic | ExtraInfo | MultiChoiceQA | FreeTextQA | MeetThePlayer | ShowAllPlayers | TOC | EndLesson)[1]">
					<xsl:apply-templates select="(TextGraphic | TextBox | Graphic | ExtraInfo | MultiChoiceQA | FreeTextQA | MeetThePlayer | ShowAllPlayers | TOC | EndLesson)[1]" mode="_9"/>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="PageElements" mode="_7">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="PageElement">
					<xsl:apply-templates select="PageElement" mode="_8"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="PageElement"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_8"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Page" mode="_6">
		<xsl:copy>
			<xsl:attribute name="ID">
				<xsl:value-of select="@ID"/>
			</xsl:attribute>
			<xsl:attribute name="IsActive">
				<xsl:choose>
					<xsl:when test="@IsActive">
						<xsl:value-of select="@IsActive"/>
					</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:element name="IncludedInTOC">
				<xsl:choose>
					<xsl:when test="IncludedInTOC">
						<xsl:copy-of select="IncludedInTOC/text()[1]"/>
					</xsl:when>
					<xsl:otherwise>true</xsl:otherwise>
				</xsl:choose>
			</xsl:element>
			<xsl:element name="Title">
				<xsl:copy-of select="Title/text()[1]"/>
			</xsl:element>
			<xsl:choose>
				<xsl:when test="PageElements">
					<xsl:apply-templates select="PageElements[1]" mode="_7"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="PageElements"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_7"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="Pages" mode="_5">
		<xsl:copy>
			<xsl:attribute name="PageFilter">
				<xsl:choose>
					<xsl:when test="@PageFilter">
						<xsl:value-of select="@PageFilter"/>
					</xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="Page">
					<xsl:apply-templates select="Page" mode="_6"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Page"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_6"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="BDWInfoPathLesson" mode="_0">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="Summary">
					<xsl:apply-templates select="Summary[1]" mode="_1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Summary"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_1"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="Players">
					<xsl:apply-templates select="Players[1]" mode="_2"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Players"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_2"/>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="Pages">
					<xsl:apply-templates select="Pages[1]" mode="_5"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="var">
						<xsl:element name="Pages"/>
					</xsl:variable>
					<xsl:apply-templates select="msxsl:node-set($var)/*" mode="_5"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>