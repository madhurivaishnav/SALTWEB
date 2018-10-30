<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ns1="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T22:48:56" xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-13T23-42-36" xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xdExtension="http://schemas.microsoft.com/office/infopath/2003/xslt/extension" xmlns:xdXDocument="http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument" xmlns:xdSolution="http://schemas.microsoft.com/office/infopath/2003/xslt/solution" xmlns:xdFormatting="http://schemas.microsoft.com/office/infopath/2003/xslt/formatting" xmlns:xdImage="http://schemas.microsoft.com/office/infopath/2003/xslt/xImage" xmlns:xdUtil="http://schemas.microsoft.com/office/infopath/2003/xslt/Util" xmlns:xdMath="http://schemas.microsoft.com/office/infopath/2003/xslt/Math" xmlns:xdDate="http://schemas.microsoft.com/office/infopath/2003/xslt/Date" xmlns:sig="http://www.w3.org/2000/09/xmldsig#" xmlns:xdSignatureProperties="http://schemas.microsoft.com/office/infopath/2003/SignatureProperties">
	<xsl:output method="html" indent="no"/>
	<xsl:template match="BDWInfoPathLesson">
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
					<table class="msoUcTable" style="TABLE-LAYOUT: fixed; WIDTH: 755px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 127px"></col>
							<col style="WIDTH: 230px"></col>
							<col style="WIDTH: 137px"></col>
							<col style="WIDTH: 261px"></col>
						</colgroup>
						<tbody>
							<tr style="MIN-HEIGHT: 46px">
								<td colSpan="4" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #c0c0c0">
									<div align="center">
										<font size="5">Lesson Content</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>ID:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL106" xd:xctname="PlainText" xd:binding="Summary/@ID" style="WIDTH: 100%">
											<xsl:value-of select="Summary/@ID"/>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Upload Type:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><select class="xdComboBox xdBehavior_Select" title="" size="1" tabIndex="0" xd:CtrlId="CTRL199" xd:xctname="DropDown" xd:binding="Summary/UploadType" xd:boundProp="value" style="WIDTH: 130px">
											<xsl:attribute name="value">
												<xsl:value-of select="Summary/UploadType"/>
											</xsl:attribute>
											<option value="update">
												<xsl:if test="Summary/UploadType=&quot;update&quot;">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>update</option>
											<option value="correction">
												<xsl:if test="Summary/UploadType=&quot;correction&quot;">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>correction</option>
										</select>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Name:</div>
								</td>
								<td colSpan="3" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL108" xd:xctname="PlainText" xd:binding="Summary/Title" style="WIDTH: 80%">
											<xsl:value-of select="Summary/Title"/>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Created By:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL114" xd:xctname="ExpressionBox" xd:disableEditing="yes" style="WIDTH: 100%; FONT-FAMILY: ">
											<xsl:value-of select="Summary/CreatedBy"/>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Last Modified By:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL116" xd:xctname="ExpressionBox" xd:disableEditing="yes" style="WIDTH: 100%; FONT-FAMILY: ">
											<xsl:value-of select="Summary/LastModifiedBy"/>
										</span>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>Created Date:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL113" xd:xctname="ExpressionBox" xd:disableEditing="yes" xd:datafmt="&quot;datetime&quot;,&quot;dateFormat:Short Date;&quot;" style="WIDTH: 100%; FONT-FAMILY: ">
											<xsl:choose>
												<xsl:when test="function-available('xdFormatting:formatString')">
													<xsl:value-of select="xdFormatting:formatString(Summary/CreatedDate,&quot;datetime&quot;,&quot;dateFormat:Short Date;&quot;)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="Summary/CreatedDate"/>
												</xsl:otherwise>
											</xsl:choose>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>Last Modified Date:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL115" xd:xctname="ExpressionBox" xd:disableEditing="yes" xd:datafmt="&quot;datetime&quot;,&quot;dateFormat:Short Date;&quot;" style="WIDTH: 100%; FONT-FAMILY: ">
											<xsl:choose>
												<xsl:when test="function-available('xdFormatting:formatString')">
													<xsl:value-of select="xdFormatting:formatString(Summary/LastModifiedDate,&quot;datetime&quot;,&quot;dateFormat:Short Date;&quot;)"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="Summary/LastModifiedDate"/>
												</xsl:otherwise>
											</xsl:choose>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 755px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 246px"></col>
							<col style="WIDTH: 509px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 248px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL90_5" xd:masterID="CTRL90_5">
											<colgroup>
												<col style="WIDTH: 248px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr style="MIN-HEIGHT: 19px">
													<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #517dbf 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<div>
															<strong>
																<font size="3">Meet the players:</font>
															</strong>
														</div>
													</td>
												</tr>
											</tbody><tbody xd:xctname="RepeatingTable" xd:masterName="CTRL90_5">
												<xsl:for-each select="Players/Player">
													<tr style="MIN-HEIGHT: 26px">
														<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #517dbf 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid"><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL285" xd:xctname="ExpressionBox" xd:disableEditing="yes" style="OVERFLOW-Y: hidden; WIDTH: 100%; FONT-FAMILY: ; WHITE-SPACE: nowrap; WORD-WRAP: normal">
																<xsl:value-of select="Name"/>
															</span>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="player_62" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 248px">Insert a player</div>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL98" select="xdXDocument:GetNamedNodeProperty(/BDWInfoPathLesson/Players, 'CTRL90_5', 1)"/>
											<xsl:apply-templates select="Players/Player [ (position() = $masterPosCTRL98) ] " mode="_51"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div>
					<strong>
						<font size="3"></font>
					</strong> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 757px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 245px"></col>
							<col style="WIDTH: 512px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr style="MIN-HEIGHT: 1in">
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 242px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL1_5" xd:masterID="CTRL1_5">
											<colgroup>
												<col style="WIDTH: 205px"></col>
												<col style="WIDTH: 37px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr>
													<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<div align="left">
															<strong>
																<font size="3">Pages:         <select class="xdComboBox xdBehavior_Select" title="" size="1" tabIndex="0" xd:CtrlId="CTRL272" xd:xctname="DropDown" xd:binding="Pages/@PageFilter" xd:boundProp="value" style="WIDTH: 86px">
																		<xsl:attribute name="value">
																			<xsl:value-of select="Pages/@PageFilter"/>
																		</xsl:attribute>
																		<option value="0">
																			<xsl:if test="Pages/@PageFilter=&quot;0&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>All Pages</option>
																		<option value="1">
																			<xsl:if test="Pages/@PageFilter=&quot;1&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>1 - 10</option>
																		<option value="11">
																			<xsl:if test="Pages/@PageFilter=&quot;11&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>11 - 20</option>
																		<option value="21">
																			<xsl:if test="Pages/@PageFilter=&quot;21&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>21 - 30</option>
																		<option value="31">
																			<xsl:if test="Pages/@PageFilter=&quot;31&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>31 - 40</option>
																		<option value="41">
																			<xsl:if test="Pages/@PageFilter=&quot;41&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>41 - 50</option>
																		<option value="51">
																			<xsl:if test="Pages/@PageFilter=&quot;51&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>51 - 60</option>
																		<option value="61">
																			<xsl:if test="Pages/@PageFilter=&quot;61&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>61 - 70</option>
																		<option value="71">
																			<xsl:if test="Pages/@PageFilter=&quot;71&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>71 - 80</option>
																		<option value="81">
																			<xsl:if test="Pages/@PageFilter=&quot;81&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>81 - 90</option>
																		<option value="91">
																			<xsl:if test="Pages/@PageFilter=&quot;91&quot;">
																				<xsl:attribute name="selected">selected</xsl:attribute>
																			</xsl:if>91 - 100</option>
																	</select>
																</font>
															</strong>
														</div>
													</td>
													<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #517dbf 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<div>
															<strong>
																<font size="3"></font>
															</strong> </div>
													</td>
												</tr>
											</tbody><tbody xd:xctname="RepeatingTable" xd:masterName="CTRL1_5">
												<xsl:if test="function-available('xdXDocument:GetDOM')">
													<xsl:variable name="filterParentHasNewRowsCTRL1_5" select="xdXDocument:GetNamedNodeProperty(Pages/Page/.., &quot;filterHasNewRows&quot;, &quot;false&quot;)"/>
													<xsl:variable name="filterParentVersionCTRL1_5" select="xdXDocument:GetNamedNodeProperty(Pages/Page/.., &quot;parentFilterVersion&quot;, &quot;0&quot;)"/>
													<xsl:for-each select="Pages/Page [ (../@PageFilter = 0 or position() &gt;= ../@PageFilter and position() &lt; ../@PageFilter + 10)  or ($filterParentHasNewRowsCTRL1_5 = &quot;true&quot; and xdXDocument:GetNamedNodeProperty(., &quot;filterVersion&quot;, &quot;0&quot;) &gt; $filterParentVersionCTRL1_5)  ] ">
														<tr style="MIN-HEIGHT: 27px">
															<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid">
																<div align="left"><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL284" xd:xctname="ExpressionBox" xd:disableEditing="yes" style="OVERFLOW-Y: hidden; WIDTH: 100%; FONT-FAMILY: ; WHITE-SPACE: nowrap; WORD-WRAP: normal">
																		<xsl:value-of select="Title"/>
																	</span>
																</div>
															</td>
															<td style="BORDER-RIGHT: #000000 1pt; PADDING-RIGHT: 1px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #517dbf 1pt; PADDING-TOP: 1px; BORDER-BOTTOM: #cbd8eb 1pt solid">
																<div align="center">
																	<font face="Verdana" size="1"><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="5" xd:CtrlId="btnPage_MoveUp" xd:xctname="Button" tabIndex="0">
																			<xsl:choose>
																				<xsl:when test="count(preceding-sibling::Page) = 0">
																					<xsl:attribute name="disabled">true</xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</input><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="6" xd:CtrlId="btnPage_MoveDown" xd:xctname="Button" tabIndex="0">
																			<xsl:choose>
																				<xsl:when test="count(following-sibling::Page) = 0">
																					<xsl:attribute name="disabled">true</xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</input>
																	</font>
																</div>
															</td>
														</tr>
													</xsl:for-each>
												</xsl:if>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="Page_2" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 242px">Insert a page</div>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #000000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; BORDER-LEFT: #000000 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL26" select="xdXDocument:GetNamedNodeProperty(/BDWInfoPathLesson/Pages, 'CTRL1_5', 1)"/>
											<xsl:apply-templates select="Pages/Page [ (position() = $masterPosCTRL26) ] " mode="_15"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Player" mode="_51">
		<div class="xdRepeatingSection xdRepeating" title="" style="MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; WIDTH: 100%" align="left" xd:CtrlId="CTRL98" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL90_5" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 498px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 96px"></col>
						<col style="WIDTH: 402px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 23px">
							<td colSpan="2" style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BACKGROUND-COLOR: #c0c0c0; BORDER-BOTTOM-STYLE: none">
								<div>
									<div>
										<strong><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL295" xd:xctname="ExpressionBox" xd:binding="concat(&quot;Player &quot;, count(preceding-sibling::Player) + 1, &quot; Details:&quot;)" xd:disableEditing="yes" style="WIDTH: 200px; FONT-FAMILY: ; HEIGHT: 20px">
												<xsl:value-of select="concat(&quot;Player &quot;, count(preceding-sibling::Player) + 1, &quot; Details:&quot;)"/>
											</span>
										</strong>
									</div>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Player Name:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL100" xd:xctname="PlainText" xd:binding="Name" style="WIDTH: 100%">
										<xsl:value-of select="Name"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Description:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL105" xd:xctname="RichText" xd:binding="Description" style="MARGIN-BOTTOM: 5px; WIDTH: 100%; HEIGHT: 171px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Picture:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="Picture" mode="_78"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_78">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL203" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 386px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 248px"></col>
						<col style="WIDTH: 138px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 42px">
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" tabIndex="0" xd:CtrlId="CTRL204" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text</div>
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL205" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Page" mode="_15">
		<div class="xdRepeatingSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL26" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL1_5" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 506px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 506px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 1px; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BACKGROUND-COLOR: #c0c0c0; BORDER-BOTTOM-STYLE: none">
								<div>
									<strong><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL283" xd:xctname="ExpressionBox" xd:binding="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)" xd:disableEditing="yes" style="WIDTH: 200px; FONT-FAMILY: ; HEIGHT: 20px">
											<xsl:value-of select="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)"/>
										</span>
									</strong>
								</div>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 91px">
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 507px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
										<colgroup>
											<col style="WIDTH: 138px"></col>
											<col style="WIDTH: 84px"></col>
											<col style="WIDTH: 285px"></col>
										</colgroup>
										<tbody vAlign="top">
											<tr style="MIN-HEIGHT: 25px">
												<td style="BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-RIGHT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div>Page Title:</div>
												</td>
												<td colSpan="2" style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL129" xd:xctname="PlainText" xd:binding="Title" style="WIDTH: 100%">
															<xsl:value-of select="Title"/>
														</span>
													</div>
												</td>
											</tr>
											<tr style="MIN-HEIGHT: 23px">
												<td style="BORDER-RIGHT: #000000 1pt; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-TOP-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div>Include in TOC?</div>
												</td>
												<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt">
													<div><input class="xdBehavior_Boolean" title="" type="radio" name="{generate-id(IncludedInTOC)}" tabIndex="0" xd:CtrlId="CTRL120" xd:xctname="OptionButton" xd:binding="IncludedInTOC" xd:boundProp="xd:value" xd:onValue="true">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="IncludedInTOC"/>
															</xsl:attribute>
															<xsl:if test="IncludedInTOC=&quot;true&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Yes      </div>
												</td>
												<td style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div><input class="xdBehavior_Boolean" title="" type="radio" name="{generate-id(IncludedInTOC)}" tabIndex="0" xd:CtrlId="CTRL121" xd:xctname="OptionButton" xd:binding="IncludedInTOC" xd:boundProp="xd:value" xd:onValue="false">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="IncludedInTOC"/>
															</xsl:attribute>
															<xsl:if test="IncludedInTOC=&quot;false&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>No</div>
												</td>
											</tr>
											<tr style="MIN-HEIGHT: 24px">
												<td style="BORDER-RIGHT: #000000 1pt; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div>Status:</div>
												</td>
												<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" name="{generate-id(@IsActive)}" tabIndex="0" xd:CtrlId="CTRL118" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="true">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;true&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Active  </div>
												</td>
												<td style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" name="{generate-id(@IsActive)}" tabIndex="0" xd:CtrlId="CTRL119" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="false">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;false&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Inactive</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<strong>Page Contents:</strong>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div> </div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div><xsl:apply-templates select="PageElements" mode="_54"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="PageElements" mode="_54">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; MARGIN-BOTTOM: 6px; MARGIN-LEFT: 0px; WIDTH: 100%; MARGIN-RIGHT: 0px" align="left" xd:CtrlId="CTRL131" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdRepeatingTable msoUcTable" title="" style="TABLE-LAYOUT: fixed; WIDTH: 502px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL132">
					<colgroup>
						<col style="WIDTH: 502px"></col>
					</colgroup><tbody xd:xctname="RepeatingTable">
						<xsl:for-each select="PageElement">
							<tr>
								<td style="BORDER-RIGHT: #517dbf 1pt solid; BORDER-TOP: #517dbf 1pt solid; BORDER-LEFT: #517dbf 1pt solid; BORDER-BOTTOM: #517dbf 1pt solid">
									<div align="right">
										<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 490px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
											<colgroup>
												<col style="WIDTH: 402px"></col>
												<col style="WIDTH: 88px"></col>
											</colgroup>
											<tbody vAlign="top">
												<tr>
													<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
														<div>
															<font face="Verdana" size="2"><span class="xdExpressionBox xdDataBindingUI" title="" tabIndex="-1" xd:CtrlId="CTRL291" xd:xctname="ExpressionBox" xd:binding="&quot;Spacer&quot;" xd:disableEditing="yes">
																	<xsl:attribute name="style">WIDTH: 80%;<xsl:choose>
																			<xsl:when test="count(*) != 0">DISPLAY: none</xsl:when>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:value-of select="&quot;Spacer&quot;"/>
																</span>
															</font>
														</div>
													</td>
													<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
														<div align="right">
															<font face="Verdana" size="2"><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 44px; COLOR: #ff0000; LINE-HEIGHT: 10px; FONT-FAMILY: Arial; HEIGHT: 16px" type="button" size="46" value="Delete" xd:CtrlId="btnPageElement_Delete" xd:xctname="Button" tabIndex="0">
																	<xsl:choose>
																		<xsl:when test="count(../PageElement) = 1">
																			<xsl:attribute name="disabled">true</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																</input><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="5" xd:CtrlId="btnPageElement_MoveUp" xd:xctname="Button" tabIndex="0">
																	<xsl:choose>
																		<xsl:when test="count(preceding-sibling::PageElement) = 0">
																			<xsl:attribute name="disabled">true</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																</input><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="6" xd:CtrlId="btnPageElement_MoveDown" xd:xctname="Button" tabIndex="0">
																	<xsl:choose>
																		<xsl:when test="count(following-sibling::PageElement) = 0">
																			<xsl:attribute name="disabled">true</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																</input>
															</font>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div>
										<div class="xdSection xdRepeating" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" xd:xctname="choicegroup" xd:ref=".">
											<div><xsl:apply-templates select="TextGraphic" mode="_58"/>
											</div>
											<div><xsl:apply-templates select="TextBox" mode="_56"/>
											</div>
											<div><xsl:apply-templates select="Graphic" mode="_60"/>
											</div>
											<div><xsl:apply-templates select="ExtraInfo" mode="_93"/><xsl:apply-templates select="MultiChoiceQA" mode="_64"/>
											</div>
											<div><xsl:apply-templates select="FreeTextQA" mode="_65"/>
											</div>
											<div><xsl:apply-templates select="MeetThePlayer" mode="_62"/>
											</div>
											<div><xsl:apply-templates select="ShowAllPlayers" mode="_63"/>
											</div>
											<div><xsl:apply-templates select="TOC" mode="_57"/>
											</div>
											<div><xsl:apply-templates select="EndLesson" mode="_66"/>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
				<div class="optionalPlaceholder" xd:xmlToEdit="PageElement_73" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 502px">Insert page element</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextGraphic" mode="_58">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL136" xd:xctname="choiceterm" tabIndex="-1">
			<div>Text and Graphic</div>
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 465px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 64px"></col>
						<col style="WIDTH: 401px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<div>Text: </div>
								</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL180" xd:xctname="RichText" xd:binding="Description" style="MARGIN-BOTTOM: 5px; WIDTH: 100%; HEIGHT: 166px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Picture:</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="Picture" mode="_74"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_74">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL175" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 388px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 253px"></col>
						<col style="WIDTH: 135px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" tabIndex="0" xd:CtrlId="CTRL201" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text:<span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL177" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>Align:</div>
								<div><select class="xdComboBox xdBehavior_Select" title="" size="1" tabIndex="0" xd:CtrlId="CTRL179" xd:xctname="DropDown" xd:binding="Align" xd:boundProp="value" style="WIDTH: 100%">
										<xsl:attribute name="value">
											<xsl:value-of select="Align"/>
										</xsl:attribute>
										<option value="Left">
											<xsl:if test="Align=&quot;Left&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Left</option>
										<option value="Right">
											<xsl:if test="Align=&quot;Right&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Right</option>
									</select>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextBox" mode="_56">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL133" xd:xctname="choiceterm" tabIndex="-1">
			<div>Text Box</div>
			<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL173" xd:xctname="RichText" xd:binding="Description" style="MARGIN-BOTTOM: 5px; WIDTH: 100%; HEIGHT: 159px">
					<xsl:copy-of select="Description/node()"/>
				</span>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Graphic" mode="_60">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%; HEIGHT: 10px" align="left" xd:CtrlId="CTRL142" xd:xctname="choiceterm" tabIndex="-1">
			<div>Graphic</div>
			<div><xsl:apply-templates select="Picture" mode="_61"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_61">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL143" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 459px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 305px"></col>
						<col style="WIDTH: 154px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" tabIndex="0" xd:CtrlId="CTRL144" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text:</div>
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL145" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ExtraInfo" mode="_93">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL240" xd:xctname="choiceterm" tabIndex="-1">
			<div>Extra Info link</div>
			<div>Heading:</div>
			<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL249" xd:xctname="PlainText" xd:binding="Heading" style="WIDTH: 100%">
					<xsl:value-of select="Heading"/>
				</span>
			</div>
			<div>Links:</div>
			<div><xsl:apply-templates select="Links/Link" mode="_96"/>
				<div class="optionalPlaceholder" xd:xmlToEdit="Link_171" tabIndex="0" xd:action="xCollection::insert" align="left" style="WIDTH: 100%">Insert link</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Link" mode="_96">
		<div class="xdRepeatingSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL250" xd:xctname="RepeatingSection" tabIndex="-1">
			<div>
				<div class="xdSection xdRepeating" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" xd:xctname="choicegroup" xd:ref=".">
					<div><xsl:apply-templates select="Internal" mode="_102"/>
					</div>
					<div><xsl:apply-templates select="External" mode="_104"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Internal" mode="_102">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL261" xd:xctname="choiceterm" tabIndex="-1">
			<div>Internal</div>
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 444px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 56px"></col>
						<col style="WIDTH: 388px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Title:</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL262" xd:xctname="PlainText" xd:binding="Title" style="WIDTH: 100%">
										<xsl:value-of select="Title"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Text:</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL267" xd:xctname="RichText" xd:binding="Description" style="WIDTH: 100%; HEIGHT: 50px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Picture:</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div> </div>
								<div><xsl:choose>
										<xsl:when test="Picture">
											<xsl:apply-templates select="Picture" mode="_106"/>
										</xsl:when>
										<xsl:otherwise>
											<div class="optionalPlaceholder" xd:xmlToEdit="Picture_188" tabIndex="0" align="left" style="WIDTH: 100%">Insert picture</div>
										</xsl:otherwise>
									</xsl:choose>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_106">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL278" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 385px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 255px"></col>
						<col style="WIDTH: 130px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 42px">
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" tabIndex="0" xd:CtrlId="CTRL279" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text:<span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL280" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="External" mode="_104">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 445px; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL268" xd:xctname="choiceterm" tabIndex="-1">
			<div>External</div>
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 444px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 55px"></col>
						<col style="WIDTH: 389px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Title:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL269" xd:xctname="PlainText" xd:binding="DisplayName" style="WIDTH: 100%">
										<xsl:value-of select="DisplayName"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Url:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL270" xd:xctname="PlainText" xd:binding="Url" style="WIDTH: 100%">
										<xsl:value-of select="Url"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="MultiChoiceQA" mode="_64">
		<div class="xdSection xdRepeating" title="" style="PADDING-LEFT: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL150" xd:xctname="choiceterm" tabIndex="-1">
			<div>Multiple-Choice Question and Answer</div>
			<div>Question:<span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL182" xd:xctname="RichText" xd:binding="Question" style="WIDTH: 100%; HEIGHT: 83px">
					<xsl:copy-of select="Question/node()"/>
				</span>
			</div>
			<div><xsl:apply-templates select="Answer" mode="_95"/>
				<div class="optionalPlaceholder" xd:xmlToEdit="Answer_165" tabIndex="0" xd:action="xCollection::insert" align="left" style="WIDTH: 100%">Insert answer</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Answer" mode="_95">
		<div class="xdRepeatingSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL246" xd:xctname="RepeatingSection" tabIndex="-1">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 456px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 80px"></col>
						<col style="WIDTH: 376px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 65px">
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Answer:</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL247" xd:xctname="RichText" xd:binding="AnswerText" style="WIDTH: 100%; HEIGHT: 60px">
										<xsl:copy-of select="AnswerText/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 63px">
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Feedback: </div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL248" xd:xctname="RichText" xd:binding="Feedback" style="WIDTH: 100%; HEIGHT: 57px">
										<xsl:copy-of select="Feedback/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Correct</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><input class="xdBehavior_Boolean" title="" type="checkbox" tabIndex="0" xd:CtrlId="CTRL289" xd:xctname="CheckBox" xd:binding="@Correct" xd:boundProp="xd:value" xd:onValue="true" xd:offValue="false">
										<xsl:attribute name="xd:value">
											<xsl:value-of select="@Correct"/>
										</xsl:attribute>
										<xsl:if test="@Correct=&quot;true&quot;">
											<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
										</xsl:if>
									</input>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div> </div>
		</div>
	</xsl:template>
	<xsl:template match="FreeTextQA" mode="_65">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL155" xd:xctname="choiceterm" tabIndex="-1">
			<div>Free Text Question</div>
			<div>Question:</div>
			<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL156" xd:xctname="RichText" xd:binding="Question" style="WIDTH: 100%; HEIGHT: 50px">
					<xsl:copy-of select="Question/node()"/>
				</span>
			</div>
			<div>Feedback:</div>
			<div><span class="xdRichTextBox" hideFocus="1" title="" tabIndex="0" xd:CtrlId="CTRL157" xd:xctname="RichText" xd:binding="Feedback" style="WIDTH: 100%; HEIGHT: 50px">
					<xsl:copy-of select="Feedback/node()"/>
				</span>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="MeetThePlayer" mode="_62">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL147" xd:xctname="choiceterm" tabIndex="-1">
			<div>Meet the Player Link</div>
			<div>
				<select class="xdComboBox xdBehavior_Select" title="" style="WIDTH: 60%" size="1" xd:CtrlId="CTRL181" xd:xctname="DropDown" xd:binding="@ID" value="" xd:boundProp="value" tabIndex="0">
					<xsl:attribute name="value">
						<xsl:value-of select="@ID"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="function-available('xdXDocument:GetDOM')">
							<option/>
							<xsl:variable name="val" select="@ID"/>
							<xsl:if test="not(../../../../../Players/Player[@ID=$val] or $val='')">
								<option selected="selected">
									<xsl:attribute name="value">
										<xsl:value-of select="$val"/>
									</xsl:attribute>
									<xsl:value-of select="$val"/>
								</option>
							</xsl:if>
							<xsl:for-each select="../../../../../Players/Player">
								<option>
									<xsl:attribute name="value">
										<xsl:value-of select="@ID"/>
									</xsl:attribute>
									<xsl:if test="$val=@ID">
										<xsl:attribute name="selected">selected</xsl:attribute>
									</xsl:if>
									<xsl:value-of select="Name"/>
								</option>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<option>
								<xsl:value-of select="@ID"/>
							</option>
						</xsl:otherwise>
					</xsl:choose>
				</select>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="ShowAllPlayers" mode="_63">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL149" xd:xctname="choiceterm" tabIndex="-1">
			<div> </div>
			<div>Show all Players Links</div>
			<div> </div>
		</div>
	</xsl:template>
	<xsl:template match="TOC" mode="_57">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL135" xd:xctname="choiceterm" tabIndex="-1">
			<div> </div>
			<div>Table of Contents</div>
			<div> </div>
		</div>
	</xsl:template>
	<xsl:template match="EndLesson" mode="_66">
		<div class="xdSection xdRepeating" title="Authors should only place this control on the last page. Clicking this button will trigger information to be sent to SALT for updating student records." style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL158" xd:xctname="choiceterm" tabIndex="-1">
			<div> </div>
			<div>End Lesson Button</div>
			<div> </div>
		</div>
	</xsl:template>
</xsl:stylesheet>
