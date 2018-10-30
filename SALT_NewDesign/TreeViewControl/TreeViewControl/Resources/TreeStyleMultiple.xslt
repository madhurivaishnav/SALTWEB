<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no" encoding="utf-8" omit-xml-declaration="yes"/> 
    <xsl:variable name="systemImagesPath" select="/TreeView/CustomParameters/Param[@Name='SystemImagesPath']/@Value"/>
    <xsl:variable name="treeViewControlID" select="/TreeView/CustomParameters/Param[@Name='TreeViewControlID']/@Value"/>
    <xsl:variable name="cssClass" select="/TreeView/CustomParameters/Param[@Name='CssClass']/@Value"/>
    <xsl:variable name="indent" select="/TreeView/CustomParameters/Param[@Name='Indent']/@Value"/>
	<xsl:template match="/TreeView">
	<table border="0" cellspacing="0" cellpadding="0" class="TreeView_Control">
		<tr bgcolor="E0E0E0">
			<td valign="middle" align="left">
			<a href="javascript:__doPostBack('{$treeViewControlID}',':Expand')" class="{$cssClass}">Expand All</a><img src="{$systemImagesPath}transparent.gif" width="10px" height="0"/> 
			<a href="javascript:__doPostBack('{$treeViewControlID}',':Collapse')" class="{$cssClass}">Collapse All</a><img src="{$systemImagesPath}transparent.gif" width="10px" height="0"/>
			<a href="javascript:__doPostBack('{$treeViewControlID}',':Select')" class="{$cssClass}">Select All</a><img src="{$systemImagesPath}transparent.gif" width="10px" height="0"/> 
			<a href="javascript:__doPostBack('{$treeViewControlID}',':Clear')" class="{$cssClass}">Clear All</a>
			</td>
			<td align="right">
				<a href="javascript:TreeView_OpenWindow('{$systemImagesPath}help.htm')" class="{$cssClass}">Help</a>
			</td>
		</tr>
		<xsl:apply-templates select="TreeNode">
			<xsl:with-param name="depth" select="0"/>
		</xsl:apply-templates>
	</table>
	</xsl:template>
	<xsl:template match="TreeNode">
			<xsl:param name="depth"/>
			<xsl:variable name="leaf" select="count(child::TreeNode)=0"/>
			<tr>
			<td valign="middle" colspan="2">
				<img src="{$systemImagesPath}transparent.gif" width="{$depth*$indent}" height="0"/>
				<xsl:choose>
					<xsl:when test="$leaf"><img src="{$systemImagesPath}minus.gif"  align="absMiddle"/></xsl:when>
					<xsl:when test="@Expanded='true'"><a href="javascript:__doPostBack('{$treeViewControlID}','{@ID}:Collapse')"><img src="{$systemImagesPath}minus.gif"  border="0"  align="absMiddle"/></a></xsl:when>
					<xsl:otherwise><a href="javascript:__doPostBack('{$treeViewControlID}','{@ID}:Expand')"><img src="{$systemImagesPath}plus.gif" border="0"  align="absMiddle"/></a></xsl:otherwise>
				</xsl:choose>
				<input type="checkbox" name="{$treeViewControlID}:Node" value="{@ID}" onchange="javascript: TreeView_ClickCheckBox( '{$treeViewControlID}', this, '{@ID}');">
					<xsl:if test="@Disabled='true'">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:if test="@Selected='true'">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
					
				<xsl:choose>
					<xsl:when test="@Selected='true'">
						<a href="javascript:__doPostBack('{$treeViewControlID}','{@ID}:Clear')" class="{$cssClass}"><xsl:value-of select="@Text"/></a>
					</xsl:when>
					<xsl:otherwise>
						<a href="javascript:__doPostBack('{$treeViewControlID}','{@ID}:Select')" class="{$cssClass}"><xsl:value-of select="@Text"/></a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			</tr>
			<xsl:if test="@Expanded='true'">
				<xsl:apply-templates select="TreeNode">
					<xsl:with-param name="depth" select="$depth+1"/>
				</xsl:apply-templates>
			</xsl:if>
	</xsl:template>
</xsl:stylesheet>
  