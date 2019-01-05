<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0"/>
<xsl:param name="use_print_settings" select="1"/> <!--If 1 use settings from APEX Print Attributes dialog-->
<xsl:param name="invoice_header" select="0"/> <!--If 1 activate header for invoice (SDA Page ID 29)-->
<xsl:param name="Subtitle" select="'Subtitle'"/>
<xsl:param name="GrandTotalText" select="'GRAND TOTAL:'"/>
<xsl:param name="boldValue" select="'Title'"/>
<xsl:param name="def_orient" select="'portrait'"/> <!--page def_orientation landscape or portrait-->
<xsl:param name="def_pagewidth" select="11906"/> <!--page width for A4 format-->
<xsl:param name="def_pageheight" select="16838"/> <!--page height for A4 format-->
<xsl:param name="margintop" select="1417"/>  <!--page margins-->
<xsl:param name="marginright" select="1417"/> 
<xsl:param name="marginbottom" select="1417"/> 
<xsl:param name="marginleft" select="1417"/> 
<xsl:param name="headerfromtop" select="708"/>  <!--header margin-->
<xsl:param name="footerfrombottom" select="708"/> <!--footer margin--> 

<!--default colors and fonts-->
<xsl:param name="def_firstrowfontcolor" select="'000000'"/> <!--First row font color (default black)--> 
<xsl:param name="def_firstrowthemecolor" select="'FFFFFF'"/> <!--First row background color (default white)--> 
<xsl:param name="def_firstrowfont" select="'Calibri'"/> <!--table header font-->
<xsl:param name="def_firstrowfontsize" select="24"/> <!--table header font size 12-->

<xsl:param name="def_rowfontcolor" select="'000000'"/> <!--Row font color (default black)--> 
<xsl:param name="def_rowthemecolor" select="'FFFFFF'"/> <!--Row background color (default white)--> 
<xsl:param name="def_rowfont" select="'Calibri'"/> <!--Row font (default Calibri)--> 
<xsl:param name="def_rowfontsize" select="22"/> <!--Row font size (default 11)--> 
<xsl:param name="pagebreak_for_region" select="1"/> <!--If multiple APEX regions are in single document separate it with page breaks-->
<!--end of default colors and fonts-->
<!--Word marker colors: Possible values are: yellow,green,darkGreen,darkMagenta,magenta,darkRed,red,darkYellow,lightGray,darkGray,black,cyan,blue,darkBlue,darkCyan-->
<!--xsl:param name="highlightcolor_list"/-->
<xsl:param name="highlightcolor_list" select="'yellow'"/>
<xsl:param name="valuecolor_list"/>
<!--xsl:param name="valuecolor_list" select="'lightGray'"/-->
<xsl:param name="headercolor_list"/>
<!--xsl:param name="headercolor_list" select="'darkGray'"/-->

			 	
<!--page width-->
<xsl:variable name="pagewidth"> 
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="#PAGE_WIDTH#"/>
			<xsl:with-param name="unit" select="'#UNITS#'"/>
			<xsl:with-param name="default_value" select="$def_pagewidth"/>
		</xsl:call-template>
</xsl:variable>

<!--page orientation landscape or portrait-->
<xsl:variable name="orient"> 
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#ORIENTATION#'"/>
			<xsl:with-param name="unit" select="'or'"/>
			<xsl:with-param name="default_value" select="$def_orient"/>
		</xsl:call-template>
</xsl:variable>	
	
<!--page height-->	
<xsl:variable name="pageheight"> 
	<xsl:call-template name="ms_units_with_default">
		<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
		<xsl:with-param name="val" select="#PAGE_HEIGHT#"/>
		<xsl:with-param name="unit" select="'#UNITS#'"/>
		<xsl:with-param name="default_value" select="$def_pageheight"/>
	</xsl:call-template>
</xsl:variable>

<!--table body fonts and colors-->
<xsl:variable name="rowfontcolor"> <!--table row font color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowfontcolor"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowfont"> <!--table row font-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_FAMILY#'"/>
			<xsl:with-param name="unit" select="'ft'"/>
			<xsl:with-param name="default_value" select="$def_rowfont"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowfontsize"> <!--table row font size-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_SIZE#'"/>
			<xsl:with-param name="unit" select="'fs'"/>
			<xsl:with-param name="default_value" select="$def_rowfontsize"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowthemecolor"> <!--table row background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_BG_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowthemecolor"/>
		</xsl:call-template>
	</xsl:variable>
<!--end of table body fonts and colors-->
	
	<xsl:variable name="firstrowfontcolor"> <!--table header font color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfontcolor"/>
		</xsl:call-template>
	</xsl:variable>

  
	<xsl:variable name="firstrowfont"> <!--table header font-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_FAMILY#'"/>
			<xsl:with-param name="unit" select="'ft'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfont"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="firstrowfontsize"> <!--table header font size-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_SIZE#'"/>
			<xsl:with-param name="unit" select="'fs'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfontsize"/>
		</xsl:call-template>
	</xsl:variable>	
	
	<xsl:variable name="rowthemecolor"> <!--table row background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_BG_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowthemecolor"/>
		</xsl:call-template>
	</xsl:variable>


<xsl:preserve-space elements="*"/>
<xsl:template match="/">
		
<xsl:processing-instruction name="mso-application">progid="Word.Document"</xsl:processing-instruction>

<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
  <pkg:part pkg:name="/word/document.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml">
    <pkg:xmlData>
      <w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">
        <w:body>
        	<!--render data (ROWSET nodes) here-->
        	<xsl:apply-templates select="//DOCUMENT/ROWSET"/>
        	
        	<xsl:if test="$use_print_settings=1">
	          <w:sectPr w:rsidR="00002B63">
	          	<w:headerReference w:type="even" r:id="rId7"/> <!--header1-->
							<w:headerReference w:type="default" r:id="rId8"/> <!--header2-->
							<w:headerReference w:type="first" r:id="rId9"/> <!--header3-->
							<w:footerReference w:type="even" r:id="rId10"/> <!--footer1-->
							<w:footerReference w:type="default" r:id="rId11"/> <!--footer2-->
							<w:footerReference w:type="first" r:id="rId12"/> <!--footer3-->
	            <w:pgSz w:w="{$pagewidth}" w:h="{$pageheight}" w:orient="{$orient}"/>
	            <w:pgMar w:top="{$margintop}" w:right="{$marginright}" w:bottom="{$marginbottom}" w:left="{$marginleft}" w:header="{$headerfromtop}" w:footer="{$footerfrombottom}" w:gutter="0"/>
	            <w:cols w:space="708"/>
	            <w:docGrid w:linePitch="360"/>
	          </w:sectPr>
          </xsl:if>
        </w:body>
      </w:document>
    </pkg:xmlData>
  </pkg:part>
</pkg:package>

</xsl:template>

<xsl:template match="ROWSET">
	<!--save column names with breaks in variables-->
	<xsl:variable name="break_on_col1">
		<xsl:value-of select="@break_on_col1"/>
	</xsl:variable>
	<xsl:variable name="break_on_col2">
		<xsl:value-of select="@break_on_col2"/>
	</xsl:variable>
	<xsl:variable name="break_on_col3">
		<xsl:value-of select="@break_on_col3"/>
	</xsl:variable>
	<xsl:variable name="break_on_col4">
		<xsl:value-of select="@break_on_col4"/>
	</xsl:variable>
	<xsl:variable name="break_on_col5">
		<xsl:value-of select="@break_on_col5"/>
	</xsl:variable>
	<xsl:variable name="break_on_col6">
		<xsl:value-of select="@break_on_col6"/>
	</xsl:variable>
	
	<!--save first 20 column names from report select statement to use in word table header-->
	<!--Extend if you want to display more columns-->
	<xsl:variable name="col1_name">
		<xsl:value-of select="name(ROW[1]/*[1])"/>
	</xsl:variable>
	<xsl:variable name="col2_name">
		<xsl:value-of select="name(ROW[1]/*[2])"/>
	</xsl:variable>
	<xsl:variable name="col3_name">
		<xsl:value-of select="name(ROW[1]/*[3])"/>
	</xsl:variable>
	<xsl:variable name="col4_name">
		<xsl:value-of select="name(ROW[1]/*[4])"/>
	</xsl:variable>
	<xsl:variable name="col5_name">
		<xsl:value-of select="name(ROW[1]/*[5])"/>
	</xsl:variable>
	<xsl:variable name="col6_name">
		<xsl:value-of select="name(ROW[1]/*[6])"/>
	</xsl:variable>
	<xsl:variable name="col7_name">
		<xsl:value-of select="name(ROW[1]/*[7])"/>
	</xsl:variable>
	<xsl:variable name="col8_name">
		<xsl:value-of select="name(ROW[1]/*[8])"/>
	</xsl:variable>
	<xsl:variable name="col9_name">
		<xsl:value-of select="name(ROW[1]/*[9])"/>
	</xsl:variable>
	<xsl:variable name="col10_name">
		<xsl:value-of select="name(ROW[1]/*[10])"/>
	</xsl:variable>
	<xsl:variable name="col11_name">
		<xsl:value-of select="name(ROW[1]/*[11])"/>
	</xsl:variable>
	<xsl:variable name="col12_name">
		<xsl:value-of select="name(ROW[1]/*[12])"/>
	</xsl:variable>
	<xsl:variable name="col13_name">
		<xsl:value-of select="name(ROW[1]/*[13])"/>
	</xsl:variable>
	<xsl:variable name="col14_name">
		<xsl:value-of select="name(ROW[1]/*[14])"/>
	</xsl:variable>
	<xsl:variable name="col15_name">
		<xsl:value-of select="name(ROW[1]/*[15])"/>
	</xsl:variable>
	<xsl:variable name="col16_name">
		<xsl:value-of select="name(ROW[1]/*[16])"/>
	</xsl:variable>
	<xsl:variable name="col17_name">
		<xsl:value-of select="name(ROW[1]/*[17])"/>
	</xsl:variable>
	<xsl:variable name="col18_name">
		<xsl:value-of select="name(ROW[1]/*[18])"/>
	</xsl:variable>
	<xsl:variable name="col19_name">
		<xsl:value-of select="name(ROW[1]/*[19])"/>
	</xsl:variable>
	<xsl:variable name="col20_name">
		<xsl:value-of select="name(ROW[1]/*[20])"/>
	</xsl:variable>
	
	<!--save first 20 APEX report column full names to use in word table header-->
	<!--Extend if you want to display more columns-->
	<xsl:variable name="col1_fullname">
		<xsl:value-of select="ROW[1]/*[1]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col2_fullname">
		<xsl:value-of select="ROW[1]/*[2]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col3_fullname">
		<xsl:value-of select="ROW[1]/*[3]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col4_fullname">
		<xsl:value-of select="ROW[1]/*[4]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col5_fullname">
		<xsl:value-of select="ROW[1]/*[5]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col6_fullname">
		<xsl:value-of select="ROW[1]/*[6]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col7_fullname">
		<xsl:value-of select="ROW[1]/*[7]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col8_fullname">
		<xsl:value-of select="ROW[1]/*[8]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col9_fullname">
		<xsl:value-of select="ROW[1]/*[9]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col10_fullname">
		<xsl:value-of select="ROW[1]/*[10]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col11_fullname">
		<xsl:value-of select="ROW[1]/*[11]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col12_fullname">
		<xsl:value-of select="ROW[1]/*[12]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col13_fullname">
		<xsl:value-of select="ROW[1]/*[13]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col14_fullname">
		<xsl:value-of select="ROW[1]/*[14]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col15_fullname">
		<xsl:value-of select="ROW[1]/*[15]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col16_fullname">
		<xsl:value-of select="ROW[1]/*[16]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col17_fullname">
		<xsl:value-of select="ROW[1]/*[17]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col18_fullname">
		<xsl:value-of select="ROW[1]/*[18]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col19_fullname">
		<xsl:value-of select="ROW[1]/*[19]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col20_fullname">
		<xsl:value-of select="ROW[1]/*[20]/@FULL_NAME"/>
	</xsl:variable>
	
	<!--calculate and save first 20 column names to use in word table header-->
	<!--Extend if you want to display more columns-->
	<xsl:variable name="col1_name_show">
		<xsl:call-template name="colname-header">
			<xsl:with-param name="colname"><xsl:value-of select="$col1_name"/></xsl:with-param>
			<xsl:with-param name="fullname"><xsl:value-of select="$col1_fullname"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col2_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col2_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col3_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col3_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col4_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col4_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col5_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col5_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col6_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col6_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col7_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col7_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col8_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col8_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col9_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col9_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col10_name_show">
		<xsl:call-template name="colname-header">
			<xsl:with-param name="colname"><xsl:value-of select="$col10_name"/></xsl:with-param>
			<xsl:with-param name="fullname"><xsl:value-of select="$col10_fullname"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col11_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col11_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col12_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col12_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col13_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col13_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col14_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col14_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col15_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col15_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col16_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col16_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col17_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col17_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col18_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col18_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col19_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col19_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col20_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col20_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	
	<!--Title and subtitle-->
	<!--Title of document-->
	<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
	<w:pPr>
	<w:pStyle w:val="Title"/>
	<w:divId w:val="1183738353"/>
	</w:pPr>
	<w:r>
	<w:t>
		<!--Document title is APEX region name-->
		<xsl:value-of select="@name"/>
		<!--xsl:text> </xsl:text>
		<xsl:value-of select="@IR_name"/-->
	</w:t>
	</w:r>
	</w:p>
	<!--Subtitle is renderd in case of IR as name of IR-->
	<xsl:if test="@IR_name != ''">
		<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
		<w:pPr>
		<w:pStyle w:val="Subtitle"/>
		</w:pPr>
		<w:r>
		<w:t><xsl:value-of select="@IR_name"/></w:t>
		</w:r>
		</w:p>
	</xsl:if>
	<!--w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
	<w:r>
	<w:t> </w:t>
	</w:r>
	</w:p-->
	<!--Empty paragraph-->
	<!--w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
    <w:r>
      <w:t> </w:t>
    </w:r>
  </w:p-->
  <!--Invoice addition-->
	<xsl:if test="$invoice_header = '1'">  
	  <w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r>
		<w:t xml:space="preserve">Order Number </w:t>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_ID#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r>
		<w:t xml:space="preserve">Customer Info </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_CUSTOMER_INFO_WORD#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Order Date </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_TIMESTAMP#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Order Total </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_TOTAL#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Sales Rep </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_USER_NAME#</w:t>
		</w:r>
		<w:bookmarkStart w:id="0" w:name="_GoBack"/>
		<w:bookmarkEnd w:id="0"/>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRPr="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Tags </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r>
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_TAGS#</w:t>
		</w:r>
		</w:p>
  <!--End of Invoice addition-->
  </xsl:if>
	

  <!--Render word list from data in XML-->
	<xsl:for-each select="ROW">
		<xsl:variable name="highlight_col"><xsl:value-of select="@highlight_col"/></xsl:variable>
		<xsl:variable name="highlight_cell"><xsl:value-of select="@highlight_cell"/></xsl:variable>
		<xsl:variable name="highlight_bkg_color"><xsl:value-of select="@highlight_bkg_color"/></xsl:variable>
		<xsl:variable name="highlight_font_color"><xsl:value-of select="@highlight_font_color"/></xsl:variable>
		<xsl:choose>
			<!--This is breakrow, end list of previous break group, list info from break cols (= common info of break group), then start new list -->
			<xsl:when test="@breakrow=1">
				<!--Empty paragraph-->
				<!--w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
          <w:r>
            <w:t> </w:t>
          </w:r>
        </w:p-->
        <!--list info from break cols (= common info of break group)-->
				<xsl:call-template name="breakrow_header">
					<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
					<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
					<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
					<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
					<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
					<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			
			<xsl:when test="@breakrow=2">
				<!--Grand total caption-->
				<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
					<w:pPr>
					<w:pStyle w:val="Heading1"/>
					<w:rPr>
					<!--w:lang w:val="en-US"/-->
					</w:rPr>
					</w:pPr>
					<w:r w:rsidR="00B13FF7">
					<w:rPr>
					<!--w:lang w:val="en-US"/-->
					</w:rPr>
					<w:t>
						<xsl:value-of select="$GrandTotalText"/>
					</w:t>
					</w:r>
					<w:bookmarkStart w:id="0" w:name="_GoBack"/>
					<w:bookmarkEnd w:id="0"/>
				</w:p>
				
				<!--render list line-->
				<xsl:for-each select="*">
					<xsl:call-template name="list-line"> 
						<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
						<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
						<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
						<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
						<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
						<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
						<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
						<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
						<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
						<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
						<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
						<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
						<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
						<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
						<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
						<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
						<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
						<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
						<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
						<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
						<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
						<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
						<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
						<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
						<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
						<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>	<!--@breakrow=2"-->
			
			<!--render aggregation line-->
			<xsl:when test="@aggregation">
				<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50" w:rsidP="00570139">
					<!--Heading3 style text "Summary"-->
          <w:pPr>
            <w:pStyle w:val="Heading3"/>
          </w:pPr>
          <w:r>
            <w:t>Summary</w:t>
          </w:r>
        </w:p>
				
				<!--render list line-->
				<xsl:for-each select="*">
					<xsl:call-template name="list-line"> 
						<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
						<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
						<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
						<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
						<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
						<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
						<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
						<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
						<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
						<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
						<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
						<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
						<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
						<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
						<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
						<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
						<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
						<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
						<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
						<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
						<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
						<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
						<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
						<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
						<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
						<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<!--not aggregation, ordinary list line-->
			<xsl:otherwise>
				<!--Empty paragraph-->
				<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00BB61A6" w:rsidRDefault="00BB61A6" w:rsidP="00BB61A6">
					<w:pPr>
						<w:pStyle w:val="NoSpacing"/>
					</w:pPr>
					<w:bookmarkStart w:id="0" w:name="_GoBack"/>
					<w:bookmarkEnd w:id="0"/>
				</w:p>
		      
				<xsl:for-each select="*">
					<xsl:call-template name="list-line"> 
						<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
						<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
						<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
						<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
						<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
						<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
						<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
						<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
						<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
						<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
						<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
						<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
						<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
						<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
						<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
						<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
						<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
						<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
						<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
						<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
						<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
						<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
						<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
						<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
						<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
						<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
	<xsl:if test="position() != last()">
		<xsl:if test ="$pagebreak_for_region = 1">
			<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
				<w:r w:rsidRPr="00455D06">
					<w:br w:type="page"/>
				</w:r>
			</w:p>
		</xsl:if>
	  <xsl:if test ="$pagebreak_for_region = 0">
			<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
				<w:r w:rsidRPr="00455D06">
				<w:t> </w:t>
				</w:r>
			</w:p>
		</xsl:if>
	</xsl:if>
</xsl:template>

<!--template render list line-->
<xsl:template name="list-line"> 
	<xsl:param name="col1_name"/>
	<xsl:param name="col2_name"/>
	<xsl:param name="col3_name"/>
	<xsl:param name="col4_name"/>
	<xsl:param name="col5_name"/>
	<xsl:param name="col6_name"/>
	<xsl:param name="col7_name"/>
	<xsl:param name="col8_name"/>
	<xsl:param name="col9_name"/>
	<xsl:param name="col10_name"/>
	<xsl:param name="col11_name"/>
	<xsl:param name="col12_name"/>
	<xsl:param name="col13_name"/>
	<xsl:param name="col14_name"/>
	<xsl:param name="col15_name"/>
	<xsl:param name="col16_name"/>
	<xsl:param name="col17_name"/>
	<xsl:param name="col18_name"/>
	<xsl:param name="col19_name"/>
	<xsl:param name="col20_name"/>
	<xsl:param name="col1_name_show"/>
	<xsl:param name="col2_name_show"/>
	<xsl:param name="col3_name_show"/>
	<xsl:param name="col4_name_show"/>
	<xsl:param name="col5_name_show"/>
	<xsl:param name="col6_name_show"/>
	<xsl:param name="col7_name_show"/>
	<xsl:param name="col8_name_show"/>
	<xsl:param name="col9_name_show"/>
	<xsl:param name="col10_name_show"/>
	<xsl:param name="col11_name_show"/>
	<xsl:param name="col12_name_show"/>
	<xsl:param name="col13_name_show"/>
	<xsl:param name="col14_name_show"/>
	<xsl:param name="col15_name_show"/>
	<xsl:param name="col16_name_show"/>
	<xsl:param name="col17_name_show"/>
	<xsl:param name="col18_name_show"/>
	<xsl:param name="col19_name_show"/>
	<xsl:param name="col20_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	<xsl:param name="highlight_col"/>
	<xsl:param name="highlight_cell"/>
	<xsl:param name="highlight_bkg_color"/>
	<xsl:param name="highlight_font_color"/>
	
	<!--render list line, format header: value, header in bold. e.g. Name: John Surname: Smith-->
	<xsl:call-template name="list-header-values"> 
		<xsl:with-param name="position"><xsl:value-of select="position()"/></xsl:with-param>
		<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
		<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
		<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
		<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
		<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
		<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
		<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
		<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
		<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
		<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
		<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
		<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
		<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
		<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
		<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
		<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
		<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
		<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
		<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
		<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
		
		<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
		<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
		<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
		<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
		<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
		<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
		<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
		<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
		<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
		<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
		<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
		<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
		<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
		<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
		<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
		<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
		<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
		<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
		<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
		<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
			
		<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
		<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
		<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
		<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
		<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
		<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		
		<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
		<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
		<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
		<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		
	</xsl:call-template>
</xsl:template>	

<!--render one list line header value pair, format - header: value, header in bold. e.g. Name: John-->
<xsl:template name="list-header-value"> 
	<xsl:param name="col_name"/>
	<xsl:param name="col_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	<xsl:param name="highlight_col"/>
	<xsl:param name="highlight_cell"/>
	<xsl:param name="highlight_bkg_color"/>
	<xsl:param name="highlight_font_color"/>

  <!--dont include break cols into list, break cols are in heading before each break group list-->
	<xsl:if test="not($col_name=$break_on_col1)">
	<xsl:if test="not($col_name=$break_on_col2)">
	<xsl:if test="not($col_name=$break_on_col3)">
	<xsl:if test="not($col_name=$break_on_col4)">
	<xsl:if test="not($col_name=$break_on_col5)">
	<xsl:if test="not($col_name=$break_on_col6)">
		
	<!--current font color-->	
	<xsl:variable name="rowfontcolor_cur">
			<xsl:choose>
				<xsl:when test="($highlight_cell='false' or name()=$highlight_col) and $highlight_font_color">
					<xsl:value-of select="$highlight_font_color"/>
				</xsl:when>
				<xsl:otherwise>
			  	<xsl:value-of select="$rowfontcolor"/>
			  </xsl:otherwise>
		  </xsl:choose>
	</xsl:variable>
	
	<!--current background color-->	
	<xsl:variable name="highlight_bkg_color_cur">
		<xsl:choose>
			<xsl:when test="($highlight_cell='false' or name()=$highlight_col) and $highlight_bkg_color">
				<xsl:call-template name="find_color">
					<xsl:with-param name="color" select="substring($highlight_bkg_color,2,6)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			 	<xsl:value-of select="$valuecolor_list"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
								
		<xsl:if test="text()">
			<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00570139" w:rsidP="00570139">
        <w:pPr>
          <w:pStyle w:val="NoSpacing"/>
        </w:pPr>
        
        <!--if there is aggregation function, render name of aggregation function first, e.g. SUM Income: 20-->
        <xsl:if test="@aggr_function">
        	<w:r>
						<w:rPr>
              <w:rFonts w:ascii="{$firstrowfont}" w:hAnsi="{$firstrowfont}" w:cs="{$firstrowfont}"/>		
							#HEADER_FONT_WEIGHT#	
							<w:color w:val="{$firstrowfontcolor}"/>
							<w:sz w:val="{$firstrowfontsize}"/>
							<w:szCs w:val="{$firstrowfontsize}"/>
							<xsl:if test = "$headercolor_list and string-length($headercolor_list) &gt; 0">
								<w:highlight w:val="{$headercolor_list}"/>
							</xsl:if>
            </w:rPr>
            <w:t xml:space="preserve">
							<xsl:value-of select="@aggr_function"/>
							<xsl:text> </xsl:text>
						</w:t>
					</w:r>
				</xsl:if>
        
        <!--if there is no aggregation function, render just header and value like Income: 5-->
        <w:r w:rsidR="00F80F50">
          <w:rPr>
            <w:rFonts w:ascii="{$firstrowfont}" w:hAnsi="{$firstrowfont}" w:cs="{$firstrowfont}"/>		
						#HEADER_FONT_WEIGHT#	
						<w:color w:val="{$firstrowfontcolor}"/>
						<w:sz w:val="{$firstrowfontsize}"/>
						<w:szCs w:val="{$firstrowfontsize}"/>
						<xsl:if test = "$headercolor_list and string-length($headercolor_list) &gt; 0">
							<w:highlight w:val="{$headercolor_list}"/>
						</xsl:if>
          </w:rPr>
          <w:t xml:space="preserve">
          	<xsl:value-of select="$col_name_show"/>
						<xsl:text>: </xsl:text> 
					</w:t>
        </w:r>
        <w:rPr>
            <w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>		
						#BODY_FONT_WEIGHT#	
						<w:color w:val="{$rowfontcolor_cur}"/>
						<w:sz w:val="{$rowfontsize}"/>
						<w:szCs w:val="{$rowfontsize}"/>
						<xsl:if test = "$highlight_bkg_color_cur and string-length($highlight_bkg_color_cur) &gt; 0">
							<w:highlight w:val="{$highlight_bkg_color_cur}"/>
						</xsl:if>
         </w:rPr>
        <w:r w:rsidR="00F80F50">
          <w:t xml:space="preserve"><xsl:value-of select="."/></w:t>
        </w:r>
      </w:p>          
		</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>								
</xsl:template>

<!--render list header-value pairs (max 20, extend if you want more)--> 
<xsl:template name="list-header-values"> 
	<xsl:param name="position"/>
	<xsl:param name="col1_name"/>
	<xsl:param name="col2_name"/>
	<xsl:param name="col3_name"/>
	<xsl:param name="col4_name"/>
	<xsl:param name="col5_name"/>
	<xsl:param name="col6_name"/>
	<xsl:param name="col7_name"/>
	<xsl:param name="col8_name"/>
	<xsl:param name="col9_name"/>
	<xsl:param name="col10_name"/>
	<xsl:param name="col11_name"/>
	<xsl:param name="col12_name"/>
	<xsl:param name="col13_name"/>
	<xsl:param name="col14_name"/>
	<xsl:param name="col15_name"/>
	<xsl:param name="col16_name"/>
	<xsl:param name="col17_name"/>
	<xsl:param name="col18_name"/>
	<xsl:param name="col19_name"/>
	<xsl:param name="col20_name"/>
	<xsl:param name="col1_name_show"/>
	<xsl:param name="col2_name_show"/>
	<xsl:param name="col3_name_show"/>
	<xsl:param name="col4_name_show"/>
	<xsl:param name="col5_name_show"/>
	<xsl:param name="col6_name_show"/>
	<xsl:param name="col7_name_show"/>
	<xsl:param name="col8_name_show"/>
	<xsl:param name="col9_name_show"/>
	<xsl:param name="col10_name_show"/>
	<xsl:param name="col11_name_show"/>
	<xsl:param name="col12_name_show"/>
	<xsl:param name="col13_name_show"/>
	<xsl:param name="col14_name_show"/>
	<xsl:param name="col15_name_show"/>
	<xsl:param name="col16_name_show"/>
	<xsl:param name="col17_name_show"/>
	<xsl:param name="col18_name_show"/>
	<xsl:param name="col19_name_show"/>
	<xsl:param name="col20_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	
	<xsl:param name="highlight_col"/>
	<xsl:param name="highlight_cell"/>
	<xsl:param name="highlight_bkg_color"/>
	<xsl:param name="highlight_font_color"/>
		
	<xsl:if test="$position = 1">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 2">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 3">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 4">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 5">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 6">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 7">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 8">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 9">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 10">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 11">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 12">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 13">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 14">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 15">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 16">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 17">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 18">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 19">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 20">
		<xsl:call-template name="list-header-value">
			<xsl:with-param name="col_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
			<xsl:with-param name="highlight_col"><xsl:value-of select="$highlight_col"/></xsl:with-param>
			<xsl:with-param name="highlight_cell"><xsl:value-of select="$highlight_cell"/></xsl:with-param>
			<xsl:with-param name="highlight_bkg_color"><xsl:value-of select="$highlight_bkg_color"/></xsl:with-param>
			<xsl:with-param name="highlight_font_color"><xsl:value-of select="$highlight_font_color"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<!--template for render breakrow header. Here is data from breakrow columns.-->
<xsl:template name="breakrow_header">
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	<xsl:if test="@breakrow=1">
		<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
			<w:pPr>
			<w:pStyle w:val="Heading1"/>
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			</w:pPr>
			<w:r w:rsidR="00B13FF7">
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			<w:t>
				<xsl:for-each select="*">	
					<xsl:if test="name()=$break_on_col1">
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col2">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col3">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col4">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col5">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col6">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</w:t>
			</w:r>
			<w:bookmarkStart w:id="0" w:name="_GoBack"/>
			<w:bookmarkEnd w:id="0"/>
		</w:p>
	</xsl:if>
</xsl:template>

<!--XSLT version of replace string function-->
<xsl:template name="replace-substring">
	<xsl:param name="original"/>
	<xsl:param name="substring"/>
	<xsl:param name="replacement" select="''"/>
	<xsl:variable name="first">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="substring-before($original, $substring)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="middle">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="$replacement"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="last">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:choose>
					<xsl:when test="contains(substring-after($original, $substring), $substring)">
						<xsl:call-template name="replace-substring">
							<xsl:with-param name="original">
								<xsl:value-of select="substring-after($original, $substring)"/>
							</xsl:with-param>
							<xsl:with-param name="substring">
								<xsl:value-of select="$substring"/>
							</xsl:with-param>
							<xsl:with-param name="replacement">
								<xsl:value-of select="$replacement"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-after($original, $substring)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:value-of select="concat($first, $middle, $last)"/>
</xsl:template>

<!--template used for converting measures to MS OOXML mesaure units-->
<xsl:template name="ms_units">
	<xsl:param name="val"/>
	<xsl:param name="unit"/>
	
	<xsl:choose>
		<!--number values first-->
		<xsl:when test="$unit='dx'"> <!--MS OOXML mesaure unit-->
			<xsl:value-of select="round(number($val))"/>	
		</xsl:when>
		<xsl:when test="$unit='pt'"> <!--point, pixel-->
			<xsl:value-of select="round(number($val) * 20)"/>	
		</xsl:when>
		<xsl:when test="$unit='in'"> <!--inch-->
			<xsl:value-of select="round(number($val) * 1440)"/>	
		</xsl:when>
		<xsl:when test="$unit='mm'"> <!--milimeter-->
			<xsl:value-of select="round(number($val) * 56.69291338)"/>	
		</xsl:when>
		<xsl:when test="$unit='cm'"> <!--centimeter-->
			<xsl:value-of select="round(number($val) * 566.9291338)"/>	
		</xsl:when>
		<xsl:when test="$unit='fs'"> <!--font size-->
			<xsl:value-of select="number($val)"/>	
		</xsl:when>
		<xsl:when test="$unit='pc'"> <!--percent-->
			<xsl:value-of select="round(number($val) * 50)"/>	
		</xsl:when>
		<xsl:when test="$unit='or'"> <!--orientation-->
			<xsl:choose>
				<xsl:when test="$val='VERTICAL'">
					<xsl:text>portrait</xsl:text>
				</xsl:when>	
				<xsl:when test="$val='HORIZONTAL'">
					<xsl:text>landscape</xsl:text>
				</xsl:when>	
			</xsl:choose>
		</xsl:when>
		<!--text values-->
		<xsl:otherwise>	
			<xsl:value-of select="$val"/>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--Use default. Must be in MS OOXML mesaure unit-->
<xsl:template name="ms_units_with_default">
	<xsl:param name="use_print_settings1"/>
	<xsl:param name="val"/>
	<xsl:param name="unit"/>
	<xsl:param name="default_value"/>
	
	<xsl:choose>
		<xsl:when test="$val='' or $use_print_settings1='0'">  
			<xsl:value-of select="$default_value"/>	
		</xsl:when>
		<xsl:otherwise>	
			<xsl:call-template name="ms_units">
				<xsl:with-param name="val" select="$val"/>
				<xsl:with-param name="unit" select="$unit"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	

<!--Template to calculate table column in MS OOXML mesaure units-->
<xsl:template name="dummy">
</xsl:template>	


<!--returns column header name from APEX report column name or from report select statement-->
<!--handles underscore and XML special characters-->
<xsl:template name="colname-header">
	<xsl:param name="colname"/>
	<xsl:param name="fullname"/>
	<!--xsl:value-of select="$colname"/-->
	<xsl:variable name="colname_">
		<xsl:call-template name="replace-substring">
			<xsl:with-param name="original">
				<xsl:value-of select="$colname"/>
			</xsl:with-param>
			<xsl:with-param name="substring">_x005F_</xsl:with-param>
			<xsl:with-param name="replacement">_</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="colname_show">
		<xsl:choose> 
			<xsl:when test="$fullname">
				<xsl:value-of select="$fullname"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$colname_"/>
			</xsl:otherwise>
		</xsl:choose> 
	</xsl:variable>
	
	<xsl:call-template name="replace-substring">
		<xsl:with-param name="original">
			<xsl:call-template name="replace-substring">
				<xsl:with-param name="original">
					<xsl:call-template name="replace-substring">
						<xsl:with-param name="original">
							<xsl:value-of select="$colname_show"/>
						</xsl:with-param>
						<xsl:with-param name="substring">_</xsl:with-param>
						<xsl:with-param name="replacement"><xsl:text> </xsl:text></xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="substring">x26</xsl:with-param>
				<xsl:with-param name="replacement"><![CDATA[&]]></xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
		<xsl:with-param name="substring">x2e</xsl:with-param>
		<xsl:with-param name="replacement">.</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!-- templates for finding best posibble color between predefined 16 colors -->
<!--convert hex-digit to decimal digit-->
<xsl:template name="hex_digit_to_decimal">
	<xsl:param name="hex"/>
	
	<xsl:choose>
		<xsl:when test="$hex='F'">  
			<xsl:value-of select="15"/>
		</xsl:when>
		<xsl:when test="$hex='E'">  
			<xsl:value-of select="14"/>
		</xsl:when>
		<xsl:when test="$hex='D'">  
			<xsl:value-of select="13"/>
		</xsl:when>
		<xsl:when test="$hex='C'">  
			<xsl:value-of select="12"/>
		</xsl:when>
		<xsl:when test="$hex='B'">  
			<xsl:value-of select="11"/>
		</xsl:when>
		<xsl:when test="$hex='A'">  
			<xsl:value-of select="10"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="number($hex)"/>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>	

<!--convert two digit hex number to decimal digit-->
<xsl:template name="hex_to_digit">
	<xsl:param name="hex"/>
	
	<xsl:variable name="hex1">
		<xsl:call-template name="hex_digit_to_decimal">
			<xsl:with-param name="hex" select="substring($hex,1,1)"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="hex2">
		<xsl:call-template name="hex_digit_to_decimal">
			<xsl:with-param name="hex" select="substring($hex,2,1)"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="$hex1*16+$hex2"/>
</xsl:template>	

<!--return numeric difference between two two-digit hex numbers-->
<xsl:template name="hex_diff">
	<xsl:param name="hex1"/>
	<xsl:param name="hex2"/>
	
	<xsl:variable name="hex1_value">
		<xsl:call-template name="hex_to_digit">
			<xsl:with-param name="hex" select="$hex1"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="hex2_value">
		<xsl:call-template name="hex_to_digit">
			<xsl:with-param name="hex" select="$hex2"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="diff">
		<xsl:choose>
			<xsl:when test="number($hex1_value) &gt; number($hex2_value)">
				<xsl:value-of select="$hex1_value - $hex2_value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$hex2_value - $hex1_value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:value-of select="$diff"/>
</xsl:template>	


<!--return numeric difference betwwen two colors in format rbg XXXXXX, e.g AAB157-->
<xsl:template name="color_diff">
	<xsl:param name="color1"/>
	<xsl:param name="color2"/>
	<xsl:param name="index"/>
	
	<xsl:variable name="rdiff">
		<xsl:call-template name="hex_diff">
			<xsl:with-param name="hex1" select="substring($color1,1,2)"/>
			<xsl:with-param name="hex2" select="substring($color2,1,2)"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="bdiff">
		<xsl:call-template name="hex_diff">
			<xsl:with-param name="hex1" select="substring($color1,3,2)"/>
			<xsl:with-param name="hex2" select="substring($color2,3,2)"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="gdiff">
		<xsl:call-template name="hex_diff">
			<xsl:with-param name="hex1" select="substring($color1,5,2)"/>
			<xsl:with-param name="hex2" select="substring($color2,5,2)"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:value-of select="($rdiff+$bdiff+$gdiff)*100+$index"/>
</xsl:template>	

<!--template return minimum value of two numbers-->
<xsl:template name="min">
	<xsl:param name="num1"/>
	<xsl:param name="num2"/>
	
	<xsl:choose>
		<xsl:when test="number($num1) &lt; number($num2)">
			<xsl:value-of select="$num1"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$num2"/>
		</xsl:otherwise>	
	</xsl:choose>
</xsl:template>

<!--template return minimum value of 16 numbers-->
<xsl:template name="min16">
	<xsl:param name="num1"/>
	<xsl:param name="num2"/>
	<xsl:param name="num3"/>
	<xsl:param name="num4"/>
	<xsl:param name="num5"/>
	<xsl:param name="num6"/>
	<xsl:param name="num7"/>
	<xsl:param name="num8"/>
	<xsl:param name="num9"/>
	<xsl:param name="num10"/>
	<xsl:param name="num11"/>
	<xsl:param name="num12"/>
	<xsl:param name="num13"/>
	<xsl:param name="num14"/>
	<xsl:param name="num15"/>
	<xsl:param name="num16"/>
	
	<xsl:call-template name="min">
		<xsl:with-param name="num1" select="$num16"/>
		<xsl:with-param name="num2">
			<xsl:call-template name="min">
				<xsl:with-param name="num1" select="$num15"/>
				<xsl:with-param name="num2">
					<xsl:call-template name="min">
						<xsl:with-param name="num1" select="$num14"/>
						<xsl:with-param name="num2">
							<xsl:call-template name="min">
								<xsl:with-param name="num1" select="$num13"/>
								<xsl:with-param name="num2">
									<xsl:call-template name="min">
										<xsl:with-param name="num1" select="$num12"/>
										<xsl:with-param name="num2">
											<xsl:call-template name="min">
												<xsl:with-param name="num1" select="$num11"/>
												<xsl:with-param name="num2">
													<xsl:call-template name="min">
														<xsl:with-param name="num1" select="$num10"/>
														<xsl:with-param name="num2">
															<xsl:call-template name="min">
																<xsl:with-param name="num1" select="$num9"/>
																<xsl:with-param name="num2">
																	<xsl:call-template name="min">
																		<xsl:with-param name="num1" select="$num8"/>
																		<xsl:with-param name="num2">
																			<xsl:call-template name="min">
																				<xsl:with-param name="num1" select="$num7"/>
																				<xsl:with-param name="num2">
																					<xsl:call-template name="min">
																						<xsl:with-param name="num1" select="$num6"/>
																						<xsl:with-param name="num2">
																							<xsl:call-template name="min">
																								<xsl:with-param name="num1" select="$num5"/>
																								<xsl:with-param name="num2">																		
																									<xsl:call-template name="min">
																										<xsl:with-param name="num1" select="$num4"/>
																										<xsl:with-param name="num2">
																											<xsl:call-template name="min">
																												<xsl:with-param name="num1" select="$num3"/>
																												<xsl:with-param name="num2">
																													<xsl:call-template name="min">
																															<xsl:with-param name="num1" select="$num1"/>
																															<xsl:with-param name="num2" select="$num2"/>
																													</xsl:call-template>
																												</xsl:with-param>
																											</xsl:call-template>
																										</xsl:with-param>
																									</xsl:call-template>
																								</xsl:with-param>
																							</xsl:call-template>
																						</xsl:with-param>
																					</xsl:call-template>
																			 	</xsl:with-param>
																			</xsl:call-template>
																		</xsl:with-param>
																	</xsl:call-template>
																</xsl:with-param>
															</xsl:call-template>
													 	</xsl:with-param>
													</xsl:call-template>
											 	</xsl:with-param>
											</xsl:call-template>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:with-param>
							</xsl:call-template>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
	</xsl:call-template>
</xsl:template>


<xsl:template name="find_color">
	<xsl:param name="color"/>

  <!-- APEX colors 
     yellow FFFF99
     green  99FF99
     blue   99CCFF
     orange FFDD44 (not MS Word Marker color)
		 red    FF7755	
     **Word Marker colors**
		 darkGreen #006400,
		 darkMagenta #8b008b,
		 magenta ff00ff,
		 darkRed 8B0000,
		 darkYellow CDCD00,
		 lightGray D3D3D3,
		 darkGray 303030,
		 black 000000,
		 cyan 00FFFF,
		 darkBlue 0000EE,
		 darkCyan 008B8B
-->
	
	<xsl:variable name = "mindiff">
		<xsl:call-template name="min16">
			<xsl:with-param name="num1">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'FFFF99'"/> <!--yellow-->
					<xsl:with-param name="index" select="0"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num2">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'99FF99'"/> <!--green-->
					<xsl:with-param name="index" select="1"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num3">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'99CCFF'"/> <!--blue-->
					<xsl:with-param name="index" select="2"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num4">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'FFDD44'"/> <!--orange (not MS Word Marker color)-->
					<xsl:with-param name="index" select="3"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num5">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'FF7755'"/> <!--red-->
					<xsl:with-param name="index" select="4"/>
				</xsl:call-template>
			</xsl:with-param>
			
		 <!--darkGreen #006400,
		 darkMagenta #8b008b,
		 magenta ff00ff,
		 darkRed 8B0000,
		 darkYellow CDCD00,
		 lightGray D3D3D3,
		 darkGray 303030,
		 black 000000,
		 cyan 00FFFF,
		 darkBlue 0000EE,
		 darkCyan 008B8B-->
		 
			<xsl:with-param name="num6">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'006400'"/> <!--darkGreen-->
					<xsl:with-param name="index" select="5"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num7">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'8B008B'"/> <!--darkMagenta-->
					<xsl:with-param name="index" select="6"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num8">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'FF00FF'"/> <!--magenta-->
					<xsl:with-param name="index" select="7"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num9">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'8B0000'"/> <!--darkRed-->
					<xsl:with-param name="index" select="8"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num10">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'CDCD00'"/> <!--darkYellow-->
					<xsl:with-param name="index" select="9"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num11">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'D3D3D3'"/> <!--lightGray-->
					<xsl:with-param name="index" select="10"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num12">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/> <!--darkGray-->
					<xsl:with-param name="color2" select="'303030'"/>
					<xsl:with-param name="index" select="11"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num13">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'000000'"/> <!--black--> 
					<xsl:with-param name="index" select="12"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num14">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'00FFFF'"/> <!--cyan-->
					<xsl:with-param name="index" select="13"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num15">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'0000EE'"/> <!--darkBlue--> 
					<xsl:with-param name="index" select="14"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="num16">
				<xsl:call-template name="color_diff">
					<xsl:with-param name="color1" select="$color"/>
					<xsl:with-param name="color2" select="'008B8B'"/> <!--darkCyan--> 
					<xsl:with-param name="index" select="15"/>
				</xsl:call-template>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="color_index" select="$mindiff mod 10"/>
	<xsl:choose>
		<xsl:when test="$color_index = 0">
			<xsl:value-of select="'yellow'"/>
		</xsl:when>
		<xsl:when test="$color_index = 1">
			<xsl:value-of select="'green'"/>
		</xsl:when>
		<xsl:when test="$color_index = 2">
			<xsl:value-of select="'blue'"/>
		</xsl:when>
		<xsl:when test="$color_index = 3">
			<xsl:value-of select="'red'"/>
		</xsl:when>
		<xsl:when test="$color_index = 4">
			<xsl:value-of select="'red'"/>
		</xsl:when>
		<xsl:when test="$color_index = 5">
			<xsl:value-of select="'darkGreen'"/>
		</xsl:when>
		<xsl:when test="$color_index = 6">
			<xsl:value-of select="'darkMagenta'"/>
		</xsl:when>
		<xsl:when test="$color_index = 7">
			<xsl:value-of select="'magenta'"/>
		</xsl:when>
		<xsl:when test="$color_index = 8">
			<xsl:value-of select="'darkRed'"/>
		</xsl:when>
		<xsl:when test="$color_index = 9">
			<xsl:value-of select="'darkYellow'"/>
		</xsl:when>
		<xsl:when test="$color_index = 10">
			<xsl:value-of select="'lightGray'"/>
		</xsl:when>
		<xsl:when test="$color_index = 11">
			<xsl:value-of select="'darkGray'"/>
		</xsl:when>
		<xsl:when test="$color_index = 12">
			<xsl:value-of select="'black'"/>
		</xsl:when>
		<xsl:when test="$color_index = 13">
			<xsl:value-of select="'cyan'"/>
		</xsl:when>
		<xsl:when test="$color_index = 14">
			<xsl:value-of select="'darkBlue'"/>
		</xsl:when>
		<xsl:when test="$color_index = 15">
			<xsl:value-of select="'darkCyan'"/>
		</xsl:when>
	</xsl:choose>	
	
	
</xsl:template>
	
<!-- APEX colors 
     yellow FFFF99
     green  99FF99
     blue   99CCFF
     orange FFDD44 (not MS Word Marker color)
		 red    FF7755	
  **Word Marker colors**
		 darkGreen #006400,
		 darkMagenta #8b008b,
		 magenta ff00ff,
		 darkRed 8B0000,
		 darkYellow CDCD00,
		 lightGray D3D3D3,
		 darkGray 303030,
		 black 000000,
		 cyan 00FFFF,
		 darkBlue 0000EE,
		 darkCyan 008B8B
-->
<!-- End of templates for finding best posibble color between predefined 16 colors -->



</xsl:stylesheet>
