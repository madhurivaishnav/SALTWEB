<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-20T23-45-49" xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xdExtension="http://schemas.microsoft.com/office/infopath/2003/xslt/extension" xmlns:xdXDocument="http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument" xmlns:xdSolution="http://schemas.microsoft.com/office/infopath/2003/xslt/solution" xmlns:xdFormatting="http://schemas.microsoft.com/office/infopath/2003/xslt/formatting" xmlns:xdImage="http://schemas.microsoft.com/office/infopath/2003/xslt/xImage" xmlns:xdUtil="http://schemas.microsoft.com/office/infopath/2003/xslt/Util" xmlns:xdMath="http://schemas.microsoft.com/office/infopath/2003/xslt/Math" xmlns:xdDate="http://schemas.microsoft.com/office/infopath/2003/xslt/Date" xmlns:sig="http://www.w3.org/2000/09/xmldsig#" xmlns:xdSignatureProperties="http://schemas.microsoft.com/office/infopath/2003/SignatureProperties">
	<xsl:output method="html" indent="no"/>
	<xsl:template match="Phrases">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html"></meta>
				<style controlStyle="controlStyle">@media screen 			{ 			BODY{margin-left:21px;background-position:21px 0px;} 			} 		BODY{color:windowtext;background-color:window;layout-grid:none;} 		.xdListItem {display:inline-block;width:100%;vertical-align:text-top;} 		.xdListBox,.xdComboBox{margin:1px;} 		.xdInlinePicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) } 		.xdLinkedPicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) url(#default#urn::controls/Binder) } 		.xdSection{border:1pt solid #FFFFFF;margin:6px 0px 6px 0px;padding:1px 1px 1px 5px;} 		.xdRepeatingSection{border:1pt solid #FFFFFF;margin:6px 0px 6px 0px;padding:1px 1px 1px 5px;} 		.xdBehavior_Formatting {BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting);} 	 .xdBehavior_FormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting);} 	.xdExpressionBox{margin: 1px;padding:1px;word-wrap: break-word;text-overflow: ellipsis;overflow-x:hidden;}.xdBehavior_GhostedText,.xdBehavior_GhostedTextNoBUI{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#TextField) url(#default#GhostedText);}	.xdBehavior_GTFormatting{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_GTFormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_Boolean{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#BooleanHelper);}	.xdBehavior_Select{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#SelectHelper);}	.xdRepeatingTable{BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word;}.xdScrollableRegion{BEHAVIOR: url(#default#ScrollableRegion);} 		.xdMaster{BEHAVIOR: url(#default#MasterHelper);} 		.xdActiveX{margin:1px; BEHAVIOR: url(#default#ActiveX);} 		.xdFileAttachment{display:inline-block;margin:1px;BEHAVIOR:url(#default#urn::xdFileAttachment);} 		.xdPageBreak{display: none;}BODY{margin-right:21px;} 		.xdTextBoxRTL{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:right;} 		.xdRichTextBoxRTL{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:right;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTTextRTL{height:100%;width:100%;margin-left:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButtonRTL{margin-right:-21px;height:18px;width:20px;behavior: url(#default#DTPicker);}.xdTextBox{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:left;} 		.xdRichTextBox{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:left;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTPicker{;display:inline;margin:1px;margin-bottom: 2px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;} 		.xdDTText{height:100%;width:100%;margin-right:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButton{margin-left:-21px;height:18px;width:20px;behavior: url(#default#DTPicker);} 		.xdRepeatingTable TD {VERTICAL-ALIGN: top;}</style>
				<style tableEditor="TableStyleRulesID">TABLE.xdLayout TD {
	BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none
}
TABLE.msoUcTable TD {
	BORDER-RIGHT: 1pt solid; BORDER-TOP: 1pt solid; BORDER-LEFT: 1pt solid; BORDER-BOTTOM: 1pt solid
}
TABLE {
	BEHAVIOR: url (#default#urn::tables/NDTable)
}
</style>
				<style languageStyle="languageStyle">BODY {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
TABLE {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
SELECT {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
.optionalPlaceholder {
	PADDING-LEFT: 20px; FONT-WEIGHT: normal; FONT-SIZE: xx-small; BEHAVIOR: url(#default#xOptional); COLOR: #333333; FONT-STYLE: normal; FONT-FAMILY: Verdana; TEXT-DECORATION: none
}
.langFont {
	FONT-FAMILY: Verdana
}
</style>
				<style themeStyle="urn:office.microsoft.com:themeBlue">BODY {
	COLOR: black; BACKGROUND-COLOR: white
}
TABLE {
	BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse
}
TD {
	BORDER-LEFT-COLOR: #517dbf; BORDER-BOTTOM-COLOR: #517dbf; BORDER-TOP-COLOR: #517dbf; BORDER-RIGHT-COLOR: #517dbf
}
TH {
	BORDER-LEFT-COLOR: #517dbf; BORDER-BOTTOM-COLOR: #517dbf; COLOR: black; BORDER-TOP-COLOR: #517dbf; BACKGROUND-COLOR: #cbd8eb; BORDER-RIGHT-COLOR: #517dbf
}
.xdTableHeader {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
P {
	MARGIN-TOP: 0px
}
H1 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H2 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H3 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H4 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H5 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #517dbf
}
H6 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #ebf0f9
}
.primaryVeryDark {
	COLOR: #ebf0f9; BACKGROUND-COLOR: #1e3c7b
}
.primaryDark {
	COLOR: white; BACKGROUND-COLOR: #517dbf
}
.primaryMedium {
	COLOR: black; BACKGROUND-COLOR: #cbd8eb
}
.primaryLight {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
.accentDark {
	COLOR: white; BACKGROUND-COLOR: #517dbf
}
.accentLight {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
</style>
			</head>
			<body>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 628px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 186px"></col>
							<col style="WIDTH: 442px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr class="primaryVeryDark" style="MIN-HEIGHT: 49px">
								<td colSpan="2" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #517dbf 6pt">
									<div style="LINE-HEIGHT: 2" align="center">
										<font size="5">Standard Text</font>
									</div>
								</td>
							</tr>
							<tr class="primarylight" style="MIN-HEIGHT: 0.156in">
								<td vAlign="top" style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #517dbf 6pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; TEXT-ALIGN: left">
									<div>
										<font size="2">Content Type: </font>
									</div>
								</td>
								<td vAlign="top" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #517dbf 6pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #517dbf 6pt; TEXT-ALIGN: left">
									<div>
										<font size="2"><select class="xdComboBox xdBehavior_Select" title="" size="1" tabIndex="0" xd:boundProp="value" xd:binding="ContentType" xd:CtrlId="CTRL4" xd:xctname="DropDown" style="WIDTH: 374px">
												<xsl:attribute name="value">
													<xsl:value-of select="ContentType"/>
												</xsl:attribute>
												<option value="lesson">
													<xsl:if test="ContentType=&quot;lesson&quot;">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>lesson</option>
												<option value="quiz">
													<xsl:if test="ContentType=&quot;quiz&quot;">
														<xsl:attribute name="selected">selected</xsl:attribute>
													</xsl:if>quiz</option>
											</select>
										</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 0.156in">
								<td vAlign="top" style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9; TEXT-ALIGN: left">
									<div>
										<font size="2">Instruction: </font>
									</div>
								</td>
								<td vAlign="top" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #517dbf 6pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9; TEXT-ALIGN: left">
									<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:binding="Instruction" xd:CtrlId="CTRL3" xd:xctname="RichText" style="WIDTH: 375px; HEIGHT: 112px">
											<xsl:copy-of select="Instruction/node()"/>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 629px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 187px"></col>
							<col style="WIDTH: 442px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 186px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL5_4" xd:masterID="CTRL5_4">
											<colgroup>
												<col style="WIDTH: 186px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr style="MIN-HEIGHT: 19px">
													<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #cbd8eb">
														<div>
															<strong>Phrases:</strong>
														</div>
													</td>
												</tr>
											</tbody><tbody xd:xctname="RepeatingTable" xd:masterName="CTRL5_4">
												<xsl:for-each select="Phrase">
													<tr>
														<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #cbd8eb 1pt solid"><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL13" xd:xctname="ExpressionBox" xd:disableEditing="yes" style="WIDTH: 100%">
																<xsl:value-of select="Title"/>
															</span>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="Phrase_4" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 186px">Insert phrase</div>
									</div>
									<div> </div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL9" select="xdXDocument:GetNamedNodeProperty(/Phrases, 'CTRL5_4', 1)"/>
											<xsl:apply-templates select="Phrase [ (position() = $masterPosCTRL9) ] " mode="_1"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Phrase" mode="_1">
		<div class="xdRepeatingSection xdRepeating" title="" style="BORDER-RIGHT: #ffffff 1pt; PADDING-RIGHT: 0px; BORDER-TOP: #ffffff 1pt; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; BORDER-LEFT: #ffffff 1pt; WIDTH: 100%; PADDING-TOP: 0px; BORDER-BOTTOM: #ffffff 1pt; HEIGHT: 119px" align="left" xd:CtrlId="CTRL9" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL5_4" tabIndex="-1">
			<div>
				<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 378px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
					<colgroup>
						<col style="WIDTH: 52px"></col>
						<col style="WIDTH: 326px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 19px">
							<td colSpan="2" style="BORDER-RIGHT-STYLE: none; BACKGROUND-COLOR: #cbd8eb; BORDER-BOTTOM-STYLE: none">
								<div>
									<font face="Verdana" size="2">
										<strong>Phrase Details:</strong>
									</font>
								</div>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 19px">
							<td style="BORDER-TOP-STYLE: none; BACKGROUND-COLOR: #ebf0f9">
								<div>
									<font face="Verdana" size="2">Title:</font>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BACKGROUND-COLOR: #ebf0f9">
								<div>
									<font face="Verdana" size="2"><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:binding="Title" xd:CtrlId="CTRL11" xd:xctname="PlainText" style="WIDTH: 100%">
											<xsl:value-of select="Title"/>
										</span>
									</font>
								</div>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 56px">
							<td style="BACKGROUND-COLOR: #ebf0f9">
								<div>
									<font face="Verdana" size="2">Text:</font>
								</div>
							</td>
							<td style="BACKGROUND-COLOR: #ebf0f9">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:binding="Text" xd:CtrlId="CTRL12" xd:xctname="RichText" style="WIDTH: 100%; HEIGHT: 191px">
										<xsl:copy-of select="Text/node()"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
