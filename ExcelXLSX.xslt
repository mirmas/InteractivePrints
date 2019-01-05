<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0"/>

<xsl:param name="use_print_settings" select="1"/> <!--If 1 use settings from APEX Print Attributes dialog-->
<xsl:param name="invoice_header" select="0"/> <!--If 1 activate header for invoice (SDA Page ID 29)-->
<xsl:param name="def_orient" select="'portrait'"/> <!--page def_orientation landscape or portrait-->
<xsl:param name="papersize" select="9"/>
<xsl:param name="margintop" select="0.75"/>  <!--page margins (2,5 cm)-->
<xsl:param name="marginright" select="0.7"/> 
<xsl:param name="marginbottom" select="0.75"/> 
<xsl:param name="marginleft" select="0.7"/> 
<xsl:param name="headerfromtop" select="0.3"/>  <!--header margin (1,25 cm)-->
<xsl:param name="footerfrombottom" select="0.3"/> <!--footer margin (1,25 cm)--> 

<xsl:variable name="orient"> <!--page orientation landscape or portrait-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#ORIENTATION#'"/>
			<xsl:with-param name="unit" select="'or'"/>
			<xsl:with-param name="default_value" select="$def_orient"/>
		</xsl:call-template>
</xsl:variable>

<!--TODO add your format, step 3, Number of base formats supported. Change this if you add or remove any of base format.-->
<!--Number must be equal to number of base formats defined in ExcelXSLX.xml. Base formats are defined between comment "base formats - possible values" and "end of base formats"-->
<xsl:variable name="num_of_base_formats" select="10"/>
<!--end of step3 -->

<xsl:variable name="header-font"> <!--page orientation landscape or portrait-->
		<xsl:if test="$use_print_settings = '1'">
			<xsl:value-of select="2*number($num_of_base_formats)"/> <!--header format if APEX print dialog is used-->
		</xsl:if>	
		<xsl:if test="$use_print_settings = '0'">
			<xsl:value-of select="number($num_of_base_formats)"/>  <!--just bold-->
		</xsl:if>	
</xsl:variable>

<xsl:variable name="aggr-font"> <!--page orientation landscape or portrait-->
		<xsl:if test="$use_print_settings = '1'">
			<xsl:value-of select="3*number($num_of_base_formats)+1"/> <!--body bold formats for aggregation rows if APEX print dialog is used-->
		</xsl:if>	
		<xsl:if test="$use_print_settings = '0'">
			<xsl:value-of select="number($num_of_base_formats)"/>  <!--just bold-->
		</xsl:if>	
</xsl:variable>
	
<xsl:template match="/">


<xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>

<xsl:variable name="worksheets">
	<xsl:if test="$invoice_header = '0'">  
		<xsl:value-of select="count(//DOCUMENT/ROWSET)"/>
	</xsl:if>
	<xsl:if test="$invoice_header = '1'">  
		<xsl:value-of select="count(//DOCUMENT/ROWSET)+1"/>
	</xsl:if>
</xsl:variable>

<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
  <pkg:part pkg:name="/xl/workbook.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml">
    <pkg:xmlData>
      <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"> 
        <fileVersion appName="xl" lastEdited="5" lowestEdited="5" rupBuild="9303"/>
        <workbookPr defaultThemeVersion="124226"/>
        <bookViews>
          <workbookView xWindow="480" yWindow="120" windowWidth="27795" windowHeight="12585"/>
        </bookViews>
        <sheets>
        	<!--list all worksheets-->
        	<xsl:for-each select="//DOCUMENT/ROWSET"> 
        		<xsl:variable name="worksheet-name1">
        			<xsl:call-template name="worksheet-name">
								<xsl:with-param name="name">
									<xsl:value-of select="@name"/>
								</xsl:with-param>
								<xsl:with-param name="IR_name">
									<xsl:value-of select="@IR_name"/>
								</xsl:with-param>
							</xsl:call-template>
        		</xsl:variable>
          	<sheet name="{$worksheet-name1}" sheetId="{position()}" r:id="rId{position()}"/>
          </xsl:for-each>
          <xsl:if test="$invoice_header = '1'"> 
          	<sheet name="Header" sheetId="{$worksheets}" r:id="rId{$worksheets}"/> 
          </xsl:if>	 
          <!-- -->
        </sheets>
        <calcPr calcId="145621"/>
      </workbook>
    </pkg:xmlData>
  </pkg:part>
  
  <pkg:part pkg:name="/xl/_rels/workbook.xml.rels" pkg:contentType="application/vnd.openxmlformats-package.relationships+xml">
		<pkg:xmlData>
			<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
				<xsl:for-each select="//DOCUMENT/ROWSET"> 
	      	<Relationship Id="rId{position()}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet{position()}.xml"/>
	      </xsl:for-each>
	      <xsl:if test="$invoice_header = '1'"> 
	        <Relationship Id="rId{$worksheets}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet{$worksheets}.xml"/> 
	      </xsl:if>	  	
	      <Relationship Id="rId{$worksheets+1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="theme/theme1.xml"/>
				<!--Relationship Id="rId{$worksheets+2}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/calcChain" Target="calcChain.xml"/-->
				<Relationship Id="rId{$worksheets+2}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/>
			</Relationships>
		</pkg:xmlData>
	</pkg:part>
	
	<xsl:for-each select="//DOCUMENT/ROWSET">
		<pkg:part pkg:name="/xl/worksheets/sheet{position()}.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml">
			<pkg:xmlData>
  			<xsl:apply-templates select="."/>
  		</pkg:xmlData>
  	</pkg:part>	
  </xsl:for-each>
  
  <xsl:if test="$invoice_header = '1'"> 
  	<pkg:part pkg:name="/xl/worksheets/sheet{$worksheets}.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml">
			<pkg:xmlData>
  			<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac xr xr2 xr3" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac" xmlns:xr="http://schemas.microsoft.com/office/spreadsheetml/2014/revision" xmlns:xr2="http://schemas.microsoft.com/office/spreadsheetml/2015/revision2" xmlns:xr3="http://schemas.microsoft.com/office/spreadsheetml/2016/revision3" xr:uid="{E4D9A877-5A00-458B-A5BB-253F9AC3ACB8}">
				<dimension ref="A1:A6"/>
				<sheetViews>
				<sheetView tabSelected="1" workbookViewId="0">
				<selection activeCell="A6" sqref="A6"/>
				</sheetView>
				</sheetViews>
				<sheetFormatPr defaultRowHeight="15" x14ac:dyDescent="0.25"/>
				<cols>
				<col min="1" max="1" width="74.5703125" customWidth="1"/>
				<col min="2" max="2" width="21.42578125" customWidth="1"/>
				<col min="3" max="3" width="16.140625" customWidth="1"/>
				<col min="4" max="4" width="18.5703125" customWidth="1"/>
				<col min="5" max="5" width="18.85546875" customWidth="1"/>
				<col min="6" max="6" width="20" customWidth="1"/>
				</cols>
				<sheetData>
				<row r="1" spans="1:5" s="2" customFormat="1" ht="15.75" x14ac:dyDescent="0.25">
				<c r="A1" s="2" t="inlineStr">
				<is><t>Order Number: #P29_ORDER_ID#</t></is>
				</c>
				</row>
				<row r="2" spans="1:5" x14ac:dyDescent="0.25">
				<c r="A2" s="2" t="inlineStr">
				<is><t>Customer Info: #P29_CUSTOMER_INFO_EXCEL#</t></is>
				</c>
				</row>
				<row r="3" spans="1:5" x14ac:dyDescent="0.25">
				<c r="A3" s="2" t="inlineStr">
				<is><t>Order Date: #P29_ORDER_TIMESTAMP#</t></is>
				</c>
				</row>
				<row r="4" spans="1:5" x14ac:dyDescent="0.25">
				<c r="A4" s="2" t="inlineStr">
				<is><t>Order Total: #P29_ORDER_TOTAL#</t></is>
				</c>
				</row>
				<row r="5" spans="1:5" x14ac:dyDescent="0.25">
				<c r="A5" s="2" t="inlineStr">
				<is><t>Sales Rep: #P29_USER_NAME#</t></is>
				</c>
				</row>
				<row r="6" spans="1:5" x14ac:dyDescent="0.25">
				<c r="A6" s="2" t="inlineStr">
				<is><t>Tags: #P29_TAGS#</t></is>
				</c>
				</row>
				</sheetData>
				<pageMargins left="{$marginleft}" right="{$marginright}" top="{$margintop}" bottom="{$marginbottom}" header="{$headerfromtop}" footer="{$footerfrombottom}"/>
    		<pageSetup paperSize="{$papersize}" orientation="{$orient}" r:id="rId1"/>
				</worksheet>
  		</pkg:xmlData>
  	</pkg:part>	
  </xsl:if>	
  
  <pkg:part pkg:name="/docProps/app.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.extended-properties+xml">
    <pkg:xmlData>
    	<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
        <Application>Microsoft Excel</Application>
        <DocSecurity>0</DocSecurity>
        <ScaleCrop>false</ScaleCrop>
        <HeadingPairs>
          <vt:vector size="2" baseType="variant">
            <vt:variant>
              <vt:lpstr>Worksheets</vt:lpstr>
            </vt:variant>
            <vt:variant>
              <vt:i4>
              	<xsl:value-of select="$worksheets"/>
							</vt:i4>
            </vt:variant>
          </vt:vector>
        </HeadingPairs>
        <TitlesOfParts>
        	<vt:vector size="{$worksheets}" baseType="lpstr">
						<xsl:for-each select="//DOCUMENT/ROWSET"> 
          		<vt:lpstr>
								<xsl:call-template name="worksheet-name">
									<xsl:with-param name="name">
										<xsl:value-of select="@name"/>
									</xsl:with-param>
									<xsl:with-param name="IR_name">
										<xsl:value-of select="@IR_name"/>
									</xsl:with-param>
								</xsl:call-template>
							</vt:lpstr>
          	</xsl:for-each>  
          	<xsl:if test="$invoice_header = '1'"> 
          		<vt:lpstr>
	          	  <xsl:text>Header</xsl:text>
	          	</vt:lpstr>
	          </xsl:if>	 
          </vt:vector>
        </TitlesOfParts>
        <LinksUpToDate>false</LinksUpToDate>
        <SharedDoc>false</SharedDoc>
        <HyperlinksChanged>false</HyperlinksChanged>
        <AppVersion>14.0300</AppVersion>
      </Properties>
    </pkg:xmlData>
  </pkg:part>
  
</pkg:package>

	

</xsl:template>

<xsl:template match="ROWSET"> 
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
	<xsl:variable name="region_rows">
		<xsl:value-of select="count(ROW)"/>
	</xsl:variable>
	<xsl:variable name="break_rows">
		<xsl:value-of select="count(ROW[@breakrow=1])"/>
	</xsl:variable>
	<xsl:variable name="rows">
		<xsl:value-of select="count(ROW)"/>
	</xsl:variable>
	<xsl:variable name="cols">
		<xsl:value-of select="count(ROW[1]/*)"/>
	</xsl:variable>
	<xsl:variable name="cols_excel">
		<xsl:call-template name="excel_col">
			<xsl:with-param name="col_num">
				<xsl:value-of select="$cols"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
  <worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" mc:Ignorable="x14ac" xmlns:x14ac="http://schemas.microsoft.com/office/spreadsheetml/2009/9/ac">
    <dimension ref="A1:{$cols_excel}{$rows+1}"/>
    <sheetViews>
      <sheetView tabSelected="1" topLeftCell="A1" workbookViewId="0">
        <!--selection activeCell="A1" sqref="A1"/-->
      </sheetView>
    </sheetViews>
    <sheetFormatPr defaultRowHeight="15" x14ac:dyDescent="0.25"/>
    <cols>
      <col min="{$cols}" max="{$cols}" width="14.140625" customWidth="1"/>
    </cols>
    <sheetData>
      <row r="1" spans="1:{$cols}" s="1" customFormat="1" x14ac:dyDescent="0.25"> <!--header row-->
      	<xsl:for-each select="ROW[1]/*">
      		<xsl:variable name="curcol_excel">
						<xsl:call-template name="excel_col">
							<xsl:with-param name="col_num">
								<xsl:value-of select="position()"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:variable>
					<xsl:variable name="element_name">
						<xsl:value-of select="name()"/>
					</xsl:variable>
					<xsl:variable name="full_name">
						<xsl:value-of select="@FULL_NAME"/>
					</xsl:variable>
					<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{$curcol_excel}1" s="{$header-font}" t="inlineStr">
						<is><t>
						 	<xsl:call-template name="colname-header">
								<xsl:with-param name="colname"><xsl:value-of select="$element_name"/></xsl:with-param>
								<xsl:with-param name="fullname"><xsl:value-of select="$full_name"/></xsl:with-param>
							</xsl:call-template>
						</t></is>
					</c>
		   	</xsl:for-each>
			</row>
			<xsl:for-each select="ROW">
				<xsl:variable name="currow">
					<xsl:value-of select="position()+1"/>
				</xsl:variable>
				<row r="{$currow}" spans="1:{$cols}" x14ac:dyDescent="0.25">
					<xsl:choose> <!--choose between aggregation, break row and ordinary row-->
						<xsl:when test="@aggregation">
							<xsl:for-each select="*">

								<xsl:variable name="excelcol">
									<xsl:call-template name="excel_col">
										<xsl:with-param name="col_num">
											<xsl:value-of select="position()"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								
								<xsl:choose> 
									<!-- No break rows aggregation just in last row-->
									<xsl:when test="@aggr_function and ($break_rows = '0')"> 
										<xsl:variable name="formula">
											<xsl:call-template name="oraaggr2excelaggr">
												<xsl:with-param name="oraaggr">
													<xsl:value-of select="@aggr_function"/>
												</xsl:with-param>
												<xsl:with-param name="excelcol">
													<xsl:value-of select="$excelcol"/>
												</xsl:with-param>
												<xsl:with-param name="currow">
													<xsl:value-of select="$currow"/>
												</xsl:with-param>
												<xsl:with-param name="rowsabove">
													<xsl:value-of select="$region_rows - 1"/>
												</xsl:with-param>
											</xsl:call-template>
										</xsl:variable>
									
										<xsl:call-template name="oracle2excelcell">
											<xsl:with-param name="curvalue">
												<xsl:value-of select="."/>
											</xsl:with-param>
											<xsl:with-param name="oratype" select="@TYPE"/>
											<xsl:with-param name="ora_format_mask" select="@FORMAT_MASK"/>	
											<xsl:with-param name="currow">
												<xsl:value-of select="$currow"/>
											</xsl:with-param>
											<xsl:with-param name="curcol">
												<xsl:value-of select="position()"/>
											</xsl:with-param>
											<xsl:with-param name="aggregation">
												<xsl:value-of select="'1'"/>
											</xsl:with-param>
											<xsl:with-param name="formula">
												<xsl:value-of select="$formula"/>
											</xsl:with-param>
										</xsl:call-template> 		
									</xsl:when>
									<!-- End of - No break rows aggregation just in last row-->
									
									<xsl:otherwise>
										<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{$excelcol}{$currow}" s="{$aggr-font}" t="inlineStr">
											<is><t>
												<xsl:if test="@aggr_function">
													<xsl:value-of select="@aggr_function"/>
													<xsl:text>: </xsl:text>
												</xsl:if>
												<xsl:value-of select="."/>
											</t></is>
										</c>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when> <!-- end of xsl:when test="@aggregation"-->
						
						<xsl:when test="@breakrow = 1"> <!--always string-->
							<xsl:for-each select="*">
								
								<xsl:variable name="excelcol">
									<xsl:call-template name="excel_col">
										<xsl:with-param name="col_num">
											<xsl:value-of select="position()"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:variable>
								
								<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{$excelcol}{$currow}" s="{$aggr-font}" t="inlineStr">
									<is><t><xsl:value-of select="."/></t></is>
								</c>
							</xsl:for-each>
						</xsl:when> <!-- end of xsl:when test="@breakrow = 1"-->
						 
						<xsl:otherwise>
							<xsl:variable name="highlight_col" select="@highlight_col"/>
							<xsl:variable name="highlight_cell" select="@highlight_cell"/>
							<xsl:variable name="highlight_bkg_color" select="@highlight_bkg_color"/>
							<xsl:variable name="highlight_font_color" select="@highlight_font_color"/>
							
							<xsl:for-each select="*"> <!--ordinary row-->
								<xsl:call-template name="oracle2excelcell">
									<xsl:with-param name="curvalue" select="."/>
									<xsl:with-param name="oratype" select="@TYPE"/>
									<xsl:with-param name="ora_format_mask" select="@FORMAT_MASK"/>	
									<xsl:with-param name="currow" select="$currow"/>
									<xsl:with-param name="curcol" select="position()"/>
									<xsl:with-param name="colname" select="name()"/>
									<xsl:with-param name="highlight_col" select="$highlight_col"/>
									<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
									<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
									<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
								</xsl:call-template>
							</xsl:for-each> <!--end of ordinary row-->
						</xsl:otherwise>
					</xsl:choose> <!--end of choose between aggregation, break row and ordinary row-->
			  </row>
   		</xsl:for-each> <!-- end of xsl:for-each select="ROW"-->
    </sheetData>
    
    <!--w:pgSz w:w="{$pagewidth}" w:h="{$pageheight}" w:orient="{$orient}"/>
    <w:pgMar w:top="{$margintop}" w:right="{$marginright}" w:bottom="{$marginbottom}" w:left="{$marginleft}" w:header="{$headerfromtop}" w:footer="{$footerfrombottom}" w:gutter="0"/-->
    
    <pageMargins left="{$marginleft}" right="{$marginright}" top="{$margintop}" bottom="{$marginbottom}" header="{$headerfromtop}" footer="{$footerfrombottom}"/>
    <pageSetup paperSize="{$papersize}" orientation="{$orient}" r:id="rId1"/>
    <xsl:if test="$use_print_settings = 1">
    	<headerFooter>
				<oddHeader>&amp;#PAGE_HEADER_ALIGNMENT#&amp;"-,#PAGE_HEADER_FONT_WEIGHT#"&amp;#PAGE_HEADER_FONT_SIZE#&amp;K#PAGE_HEADER_FONT_COLOR# &amp;"#PAGE_HEADER_FONT_FAMILY#,#PAGE_HEADER_FONT_WEIGHT#"#PAGE_HEADER#&amp;"-,#PAGE_HEADER_FONT_WEIGHT#"&amp;11</oddHeader>
	    	<oddFooter>&amp;#PAGE_FOOTER_ALIGNMENT#&amp;"-,#PAGE_FOOTER_FONT_WEIGHT#"&amp;#PAGE_FOOTER_FONT_SIZE#&amp;K#PAGE_FOOTER_FONT_COLOR# &amp;"#PAGE_FOOTER_FONT_FAMILY#,#PAGE_FOOTER_FONT_WEIGHT#"#PAGE_FOOTER#&amp;"-,#PAGE_FOOTER_FONT_WEIGHT#"&amp;11</oddFooter>
	    </headerFooter>
    </xsl:if>

  </worksheet>
 </xsl:template>
 
 <xsl:template name="worksheet-name">
    <xsl:param name="name"/>
	<xsl:param name="IR_name"/>
 	<xsl:variable name="worksheet-name-full">
 		<xsl:value-of select="$name"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="$IR_name"/>
 	</xsl:variable>
 	<xsl:value-of select="substring($worksheet-name-full,1,30)"/>
 </xsl:template>

<xsl:template name="excel_col">
	<xsl:param name="col_num"/>
	<xsl:variable name="excel_col1">
		<xsl:value-of select="number($col_num - 1) div 26"/>
	</xsl:variable>
	<xsl:variable name="excel_col2">
		<xsl:value-of select="number($col_num - 1) mod 26"/>
	</xsl:variable>
	<xsl:choose>
		<xsl:when test="$excel_col1='1'">
			<xsl:text>A</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='2'">
			<xsl:text>B</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='3'">
			<xsl:text>C</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='4'">
			<xsl:text>D</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='5'">
			<xsl:text>E</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='6'">
			<xsl:text>F</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='7'">
			<xsl:text>G</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='8'">
			<xsl:text>H</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='9'">
			<xsl:text>I</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='10'">
			<xsl:text>J</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='11'">
			<xsl:text>K</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='12'">
			<xsl:text>L</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='13'">
			<xsl:text>M</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='14'">
			<xsl:text>N</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='15'">
			<xsl:text>O</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='16'">
			<xsl:text>P</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='17'">
			<xsl:text>Q</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='18'">
			<xsl:text>R</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='19'">
			<xsl:text>S</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='20'">
			<xsl:text>T</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='21'">
			<xsl:text>U</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='22'">
			<xsl:text>V</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='23'">
			<xsl:text>W</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='24'">
			<xsl:text>X</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='25'">
			<xsl:text>Y</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col1='26'">
			<xsl:text>Z</xsl:text>
		</xsl:when>
	</xsl:choose>
		
	<xsl:choose>
		<xsl:when test="$excel_col2='0'">
			<xsl:text>A</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='1'">
			<xsl:text>B</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='2'">
			<xsl:text>C</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='3'">
			<xsl:text>D</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='4'">
			<xsl:text>E</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='5'">
			<xsl:text>F</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='6'">
			<xsl:text>G</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='7'">
			<xsl:text>H</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='8'">
			<xsl:text>I</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='9'">
			<xsl:text>J</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='10'">
			<xsl:text>K</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='11'">
			<xsl:text>L</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='12'">
			<xsl:text>M</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='13'">
			<xsl:text>N</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='14'">
			<xsl:text>O</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='15'">
			<xsl:text>P</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='16'">
			<xsl:text>Q</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='17'">
			<xsl:text>R</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='18'">
			<xsl:text>S</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='19'">
			<xsl:text>T</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='20'">
			<xsl:text>U</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='21'">
			<xsl:text>V</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='22'">
			<xsl:text>W</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='23'">
			<xsl:text>X</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='24'">
			<xsl:text>Y</xsl:text>
		</xsl:when>
		<xsl:when test="$excel_col2='25'">
			<xsl:text>Z</xsl:text>
		</xsl:when>
	</xsl:choose>	
</xsl:template>

<!-- template choose format from formats defined in styles.xml part-->
<xsl:template name="font_formats">
	<!--possible values of "base_format"-->
	<!--s=0 - String -->                                                                                                                                     
	<!--s=1 - Date DD-MM-YYYY-->                                                                                                                   
	<!--s=2 - numFmtId="2" predefined - Number with fixed Excel format (NO thousand separator two decimal places) '999999999999990D00'-->          
	<!--s=3 - numFmtId="4" predefined - Number with standard Excel format (thousand separator two and decimal places) '999G999G999G999G990D00'-->  
	<!--s=4 - numFmtId="1" predefined - Number without decimal places (NO thousand separator NO decimal places) '999999999999990'-->               
	<!--s=5 - numFmtId="3" predefined - Number without decimal places (thousand separator NO decimal places) '999G999G999G999G990'-->              
	<!--s=6 - Number without thousand separator and three decimal places '999999999999990D000'-->                                                  
	<!--s=7 - Number with thousand separator and without places '999G999G999G999G999G999G990'-->                                                   
	<!--s=8 - Dollar curency-->
	<!--TODO add your format, step 4 add comment for evidence-->
	<!--s=9 - Date in M/D/YY H:MM format-->
	<!--end of step4 -->                            
	<xsl:param name="base_format"/> <!--non bold format if APEX print dialog is used-->                                                                                       
	<xsl:param name="use_print_settings"/>
	<xsl:param name="aggregation"/>
	<xsl:param name="colname"/> 
	<xsl:param name="highlight_col"/>
	<xsl:param name="highlight_cell"/>
	<xsl:param name="highlight_bkg_color"/>
	<xsl:param name="highlight_font_color"/>
  
  <!--TODO convert colors to indexes of predefined excel colors-->
  <xsl:variable name="excel_highlight_bkg_color">
  	<xsl:call-template name="find_color">
			<xsl:with-param name="color" select="substring($highlight_bkg_color,2,6)"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="excel_highlight_font_color">
		<xsl:call-template name="find_color">
			<xsl:with-param name="color" select="substring($highlight_font_color,2,6)"/>
		</xsl:call-template>
	</xsl:variable>
  
  <xsl:variable name="return_value">								
		<xsl:if test="$use_print_settings = '1'">
			<xsl:if test="$aggregation = 0">
				<xsl:choose>
					<xsl:when test="($highlight_cell='false' or $colname=$highlight_col) and $highlight_bkg_color and string-length($highlight_bkg_color) &gt; 0">
						<xsl:value-of select="number($base_format)+number($num_of_base_formats)*7+1+number($num_of_base_formats)*4*number($excel_highlight_bkg_color)"/>
					</xsl:when>
					<xsl:when test="($highlight_cell='false' or $colname=$highlight_col) and $highlight_font_color and string-length($highlight_font_color) &gt; 0">
						<xsl:value-of select="number($base_format)+number($num_of_base_formats)*6+1+number($num_of_base_formats)*4*number($excel_highlight_font_color)"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="number($base_format)+number($num_of_base_formats)*2+1"/>
					</xsl:otherwise>
			  </xsl:choose>
			</xsl:if>
			<xsl:if test="$aggregation = 1">
				<xsl:value-of select="number($base_format)+number($num_of_base_formats)*3+1"/>
			</xsl:if>
		</xsl:if>	
		
		<xsl:if test="$use_print_settings = '0'">
			<xsl:if test="$aggregation = 0">
				<xsl:choose>
					<xsl:when test="($highlight_cell='false' or $colname=$highlight_col) and $highlight_bkg_color and string-length($highlight_bkg_color) &gt; 0">
						<xsl:value-of select="number($base_format)+number($num_of_base_formats)*5+1+number($num_of_base_formats)*4*$excel_highlight_bkg_color"/>
					</xsl:when>
					<xsl:when test="($highlight_cell='false' or $colname=$highlight_col) and $highlight_font_color and string-length($highlight_font_color) &gt; 0">
						<xsl:value-of select="number($base_format)+number($num_of_base_formats)*4+1+number($num_of_base_formats)*4*$excel_highlight_font_color"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="number($base_format)"/>
					</xsl:otherwise>
			  </xsl:choose>
			</xsl:if>
			<xsl:if test="$aggregation = 1">
				<xsl:value-of select="number($base_format)+number($num_of_base_formats)"/>
			</xsl:if>
		</xsl:if>
	</xsl:variable>
	<xsl:value-of select="$return_value"/>
	<!--DEBUG
	<xsl:text> excel_bkg_color: </xsl:text><xsl:value-of select="$excel_highlight_bkg_color"/>
	<xsl:text> excel_font_color: </xsl:text><xsl:value-of select="$excel_highlight_font_color"/>
	<xsl:text> bkg_color: </xsl:text><xsl:value-of select="$highlight_bkg_color"/>
	<xsl:text> font_color: </xsl:text><xsl:value-of select="$highlight_font_color"/>
	END OF DEBUG-->
	
	<!--DEBUG-->
	<!--OK
	<xsl:text>Hex A to decimal: </xsl:text> 
	<xsl:call-template name="hex_digit_to_decimal"> 
		<xsl:with-param name="hex" select="'A'"/>
	</xsl:call-template>
	<xsl:text>Hex 8 to decimal: </xsl:text> 
	<xsl:call-template name="hex_digit_to_decimal"> 
		<xsl:with-param name="hex" select="'8'"/>
	</xsl:call-template>
	<xsl:text>Hex D3 to decimal: </xsl:text> 
	<xsl:call-template name="hex_to_digit">
		<xsl:with-param name="hex" select="'D3'"/>
	</xsl:call-template>
	<xsl:text>Hex 33 to decimal: </xsl:text> 
	<xsl:call-template name="hex_to_digit">
		<xsl:with-param name="hex" select="'33'"/>
	</xsl:call-template>
	<xsl:text>Hex FF to decimal: </xsl:text> 
	<xsl:call-template name="hex_to_digit">
		<xsl:with-param name="hex" select="'FF'"/>
	</xsl:call-template>
	<xsl:text>Hex 00 to decimal: </xsl:text> 
	<xsl:call-template name="hex_to_digit">
		<xsl:with-param name="hex" select="'00'"/>
	</xsl:call-template>
	
	<xsl:text>abs(A1-03): </xsl:text>
	<xsl:call-template name="hex_diff">
		<xsl:with-param name="hex1" select="'A1'"/>
		<xsl:with-param name="hex2" select="'03'"/>     
	</xsl:call-template>
	
	<xsl:text>abs(32-DE): </xsl:text>
	<xsl:call-template name="hex_diff">
		<xsl:with-param name="hex1" select="'32'"/>
		<xsl:with-param name="hex2" select="'DE'"/>     
	</xsl:call-template>
	
	
	<xsl:text> diff(AAAFE0,AAAFE0,1): </xsl:text>
	<xsl:call-template name="color_diff">
		<xsl:with-param name="color1" select="'AAAFE0'"/>
		<xsl:with-param name="color2" select="'AAAFE0'"/>
		<xsl:with-param name="index" select="1"/>
	</xsl:call-template>
	
	<xsl:text> diff(BCAFE0,02AFFF,2): </xsl:text>
	<xsl:call-template name="color_diff">
		<xsl:with-param name="color1" select="'BCAFE0'"/>
		<xsl:with-param name="color2" select="'02AFFF'"/>
		<xsl:with-param name="index" select="2"/>
	</xsl:call-template>
	
	<xsl:text> min(354,211): </xsl:text>
	<xsl:call-template name="min">
		<xsl:with-param name="num1" select="354"/>
		<xsl:with-param name="num2" select="211"/>
	</xsl:call-template>
	
	<xsl:text> min16(354,211,476,34,55,788,4,78,19,94893,5,100,11,2222,66,66): </xsl:text>
	<xsl:call-template name="min16">
		<xsl:with-param name="num1" select="354"/>
		<xsl:with-param name="num2" select="211"/>
		<xsl:with-param name="num3" select="476"/>
		<xsl:with-param name="num4" select="34"/>
		<xsl:with-param name="num5" select="55"/>
		<xsl:with-param name="num6" select="788"/>
		<xsl:with-param name="num7" select="4"/>
		<xsl:with-param name="num8" select="78"/>
		<xsl:with-param name="num9" select="19"/>
		<xsl:with-param name="num10" select="94893"/>
		<xsl:with-param name="num11" select="5"/>
		<xsl:with-param name="num12" select="100"/>
		<xsl:with-param name="num13" select="11"/>
		<xsl:with-param name="num14" select="2222"/>
		<xsl:with-param name="num15" select="66"/>
		<xsl:with-param name="num16" select="66"/>
	</xsl:call-template>
	
	<xsl:text> find_color(CA7796): </xsl:text>    
	<xsl:call-template name="find_color">             
  	<xsl:with-param name="color" select="'CA7796'"/>                  
  </xsl:call-template>
  END OF OK-->
	<!--end of DEBUG-->
	
</xsl:template>

<!-- template choose highlight format from formats defined in styles.xml part-->
<xsl:template name="highlight_formats">
	<!--possible values of "base_format"-->
	<!--s=0 - String -->                                                                                                                                     
	<!--s=1 - Date DD-MM-YYYY-->                                                                                                                   
	<!--s=2 - numFmtId="2" predefined - Number with fixed Excel format (NO thousand separator two decimal places) '999999999999990D00'-->          
	<!--s=3 - numFmtId="4" predefined - Number with standard Excel format (thousand separator two and decimal places) '999G999G999G999G990D00'-->  
	<!--s=4 - numFmtId="1" predefined - Number without decimal places (NO thousand separator NO decimal places) '999999999999990'-->               
	<!--s=5 - numFmtId="3" predefined - Number without decimal places (thousand separator NO decimal places) '999G999G999G999G990'-->              
	<!--s=6 - Number without thousand separator and three decimal places '999999999999990D000'-->                                                  
	<!--s=7 - Number with thousand separator and without places '999G999G999G999G999G999G990'-->                                                   
	<!--s=8 - Dollar curency-->    
	<!--TODO add your format, repeat step 4 add comment for evidence-->
	<!--s=9 - Date in M/D/YY H:MM format-->
	<!--end of step4 -->                             
	<xsl:param name="base_format"/> <!--non bold format if APEX print dialog is used-->
	                                                                                        
	<xsl:param name="use_print_settings"/>
	<xsl:param name="bck_or_font_highlight" select="'background'"/> <!--doesnt support both (background and font). If both are highlighted in APEX only background would be highlighted in Excel-->
	<xsl:param name="color" select="'0'"/>
	
	<xsl:if test="$use_print_settings = '0'">
		<xsl:if test="bck_or_font_highlight = 'background'">
			<xsl:value-of select="number($base_format)+number($num_of_base_formats)*5+1+number($num_of_base_formats)*4*$color"/>
		</xsl:if>
		<xsl:if test="bck_or_font_highlight = 'font'">
			<xsl:value-of select="number($base_format)+number($num_of_base_formats)*4+1+number($num_of_base_formats)*4*$color"/>
		</xsl:if>
	</xsl:if>
	<xsl:if test="$use_print_settings = '1'">
		<xsl:if test="bck_or_font_highlight = 'background'">
			<xsl:value-of select="number($base_format)+number($num_of_base_formats)*7+1+number($num_of_base_formats)*4*$color"/>
		</xsl:if>
		<xsl:if test="bck_or_font_highlight = 'font'">
			<xsl:value-of select="number($base_format)+number($num_of_base_formats)*6+1+number($num_of_base_formats)*4*$color"/>
		</xsl:if>
	</xsl:if>		
	
</xsl:template>

	
<!-- maps Oracle data types to Excel data types -->
<xsl:template name="oracle2excelcell">
	<xsl:param name="curvalue"/>
	<xsl:param name="oratype"/>
	<xsl:param name="ora_format_mask"/>
	<xsl:param name="currow"/>
	<xsl:param name="curcol"/>
	<xsl:param name="aggregation" select="0"/>
	<xsl:param name="formula" select="''"/>
	<xsl:param name="colname"/> 
	<xsl:param name="highlight_col"/>
	<xsl:param name="highlight_cell"/>
	<xsl:param name="highlight_bkg_color"/>
	<xsl:param name="highlight_font_color"/>
	
	<xsl:variable name="excelcol">
		<xsl:call-template name="excel_col">
			<xsl:with-param name="col_num">
				<xsl:value-of select="$curcol"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	
	<!--choose one of excel styles defined in FlatOPC XML element cellXfs-->
	<xsl:variable name="excelstyle"> <!--excelstyle variable is zero based index of xf child element in cellXfs element in FlatOPC XML-->
		<xsl:choose>
			<xsl:when test="$oratype='DATE'"> 
				<xsl:choose>
					<!--TODO add your format, step 6. Define mapping between Oracle APEX format and Excel base format-->
					<xsl:when test="$ora_format_mask='DD/MM/YYYY HH24:MI:SS'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="9"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<!--end of step6 -->
					<xsl:when test="$ora_format_mask='DD-MM-YYYY'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="1"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<!--TODO add date format masks if needed-->
					<xsl:otherwise> <!--TODO change default date format mask-->
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="1"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oratype='NUMBER'"> 
				<xsl:choose>
					<xsl:when test="$ora_format_mask='FML999G999G999G999G990D00'"> <!--currency dollar-->
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="8"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999G999G999G999G990D00'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="3"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999999999999990D00'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="2"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999999999999990'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="4"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999G999G999G999G990' or $ora_format_mask='999G999G999G999G999G999G990'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="5"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999G999G999G999G990D000'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="7"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="$ora_format_mask='999999999999990D000'">
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="8"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:when>
					<!--TODO add aditional number format mask if needed-->
					<xsl:otherwise> <!-- default 999999999999990D000 -->
						<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="4"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when> <!--end of number styles-->
			<xsl:otherwise> <!-- show as string-->
				<xsl:call-template name="font_formats">
							<xsl:with-param name="base_format" select="0"/> <!--non bold format if APEX print dialog is NOT used-->
							<xsl:with-param name="use_print_settings" select="$use_print_settings"/>
							<xsl:with-param name="aggregation" select="$aggregation"/>
							<xsl:with-param name="colname" select="$colname"/> 
							<xsl:with-param name="highlight_col" select="$highlight_col"/>
							<xsl:with-param name="highlight_cell" select="$highlight_cell"/>
							<xsl:with-param name="highlight_bkg_color" select="$highlight_bkg_color"/>
							<xsl:with-param name="highlight_font_color" select="$highlight_font_color"/>
						</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable> <!--end of excelstyle variable-->
	
	<xsl:variable name="excelvalue">
		<xsl:choose>
			<xsl:when test="$oratype='DATE' and $curvalue"> <!--convert date to integer -->
				<xsl:choose>
					<!--extract year, month and day as numbers from date string-->
					<!--and convert date to day serial number = number of days from 1.1.1900 -->
					<xsl:when test="$ora_format_mask='DD-MON-YYYY'">
						<xsl:call-template name="excel-day-number-month">
		    			<xsl:with-param name="year" select="substring-after(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="month" select="substring-before(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="day" select="substring-before($curvalue,'-')"/>
		    		</xsl:call-template>	
					</xsl:when>
					
					<!--extract year, month and day as numbers from date string-->
					<!--and convert date to day serial number = number of days from 1.1.1900 -->
					<xsl:when test="$ora_format_mask='DD-MON-RR'">
						
						<xsl:variable name="year2" select="number(substring-after(substring-after($curvalue,'-'),'-'))"/>
						<xsl:variable name="year">
							<xsl:if test="$year2 &gt; 50">
								<xsl:value-of select="$year2 + 1900"/>
							</xsl:if>
							<xsl:if test="$year2 &lt;= 50">
								<xsl:value-of select="$year2 + 2000"/>
							</xsl:if>
						</xsl:variable>	
						
						<xsl:call-template name="excel-day-number-month">
		    			<xsl:with-param name="year" select="$year"/>
		    			<xsl:with-param name="month" select="substring-before(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="day" select="substring-before($curvalue,'-')"/>
		    		</xsl:call-template>	
					</xsl:when>
					
					<xsl:when test="$ora_format_mask='MM/DD/YYYY'">
						<xsl:call-template name="excel-day-number">
		    			<xsl:with-param name="year" select="substring-after(substring-after($curvalue,'/'),'/')"/>
		    			<xsl:with-param name="day" select="substring-before(substring-after($curvalue,'/'),'/')"/>
		    			<xsl:with-param name="month" select="substring-before($curvalue,'/')"/>
		    		</xsl:call-template>
					</xsl:when>
					
					<!--TODO add your format, step 5, If needed, add calculation for converting Oracle type to Excel data type storage-->
					<!--Here, Oracle date is converted to number of days after 1.1.1900. This is how Excel store dates-->
					<xsl:when test="$ora_format_mask='DD/MM/YYYY HH24:MI:SS'">
						<xsl:call-template name="excel-day-number">
		    			<xsl:with-param name="year" select="number(substring-before(substring-after(substring-after($curvalue,'/'),'/'),' '))"/>
		    			<xsl:with-param name="month" select="number(substring-before(substring-after($curvalue,'/'),'/'))"/>
		    			<xsl:with-param name="day" select="number(substring-before($curvalue,'/'))"/>
		    			<xsl:with-param name="hour" select="number(substring-before(substring-after($curvalue,' '),':'))"/>
		    			<xsl:with-param name="minute" select="number(substring-before(substring-after($curvalue,':'),':'))"/>
		    		</xsl:call-template>
					</xsl:when>
					<!--end of step5 -->
					
					<xsl:when test="$ora_format_mask='DD/MM/YYYY'">
						<xsl:call-template name="excel-day-number">
		    			<xsl:with-param name="year" select="substring-after(substring-after($curvalue,'/'),'/')"/>
		    			<xsl:with-param name="month" select="substring-before(substring-after($curvalue,'/'),'/')"/>
		    			<xsl:with-param name="day" select="substring-before($curvalue,'/')"/>
		    		</xsl:call-template>
					</xsl:when>
					
					<xsl:when test="$ora_format_mask='DD-MM-YYYY'">
						<xsl:call-template name="excel-day-number">
		    			<xsl:with-param name="year" select="substring-after(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="month" select="substring-before(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="day" select="substring-before($curvalue,'-')"/>
		    		</xsl:call-template>
					</xsl:when>
					
					<!--extract year, month and day from default MM/DD/YYYY e.g. 7/5/2014, 5/16/2014-->
					<!--and convert date to day serial number = number of days from 1.1.1900 -->	
					<xsl:otherwise> <!-- format DD-MON-YYYY	is asumed by default-->
						<xsl:call-template name="excel-day-number-month">
		    			<xsl:with-param name="year" select="substring-after(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="month" select="substring-before(substring-after($curvalue,'-'),'-')"/>
		    			<xsl:with-param name="day" select="substring-before($curvalue,'-')"/>
		    		</xsl:call-template>
					</xsl:otherwise>
					<!--TODO add other date formats -->
				</xsl:choose>
			</xsl:when>
			<xsl:when test="$oratype='NUMBER' and $curvalue"> 
				<xsl:choose>
					<xsl:when test="$ora_format_mask='FML999G999G999G999G990D00'"> <!--currency dollar-->
						<xsl:choose>
							<xsl:when test="substring($curvalue,1,1) = '$'"> <!--cut dollar sign at the begining-->
								<xsl:call-template name="to-number">
									<xsl:with-param name="number"><xsl:value-of select="substring($curvalue,2)"/></xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:when test="substring($curvalue,string-length($curvalue),1) = '€'"> <!--cut euro sign at the end-->
								<xsl:call-template name="to-number">
									<xsl:with-param name="number"><xsl:value-of select="number(substring($curvalue,1,string-length($curvalue)-1))"/></xsl:with-param>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise> 
								<xsl:call-template name="to-number">
									<xsl:with-param name="number"><xsl:value-of select="$curvalue"/></xsl:with-param>
								</xsl:call-template>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise> 
						<xsl:call-template name="to-number">
							<xsl:with-param name="number"><xsl:value-of select="$curvalue"/></xsl:with-param>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise> 
				<xsl:value-of select="$curvalue"/>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:variable> <!-- end of excelvalue variable-->
	
	<!--excel cell-->
	<xsl:choose>
		<xsl:when test="($oratype!='DATE' and $oratype!='NUMBER') or not($excelvalue)">		
			<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{$excelcol}{$currow}" s="{$excelstyle}" t="inlineStr">
				<is><t><xsl:value-of select="$excelvalue"/></t></is>
			</c>
		</xsl:when>
		<xsl:otherwise> 			
			<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{$excelcol}{$currow}" s="{$excelstyle}">
				<xsl:if test="$formula">
					<f><xsl:value-of select="$formula"/></f>
				</xsl:if>
				<v><xsl:value-of select="$excelvalue"/></v>	
			</c>
		</xsl:otherwise>
	</xsl:choose>	
</xsl:template>
			
	

<!-- maps Oracle aggregations to Excel aggregation formula -->
<xsl:template name="oraaggr2excelaggr">
	<xsl:param name="oraaggr"/>
	<xsl:param name="excelcol"/>
	<xsl:param name="currow"/>
	<xsl:param name="rowsabove"/>
	<xsl:variable name="excelaggr">
		<!-- TODO add other mappings -->
		<xsl:choose>
			<xsl:when test="$oraaggr='AVG'">
				<xsl:text>AVERAGE</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$oraaggr"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	
	<!-- compose formula like <f>AVERAGE(D2:D8)</f> -->
	<xsl:value-of select="$excelaggr"/>
	<xsl:text>(</xsl:text>
	<xsl:value-of select="$excelcol"/>
	<xsl:value-of select="$currow - $rowsabove"/>
	<xsl:text>:</xsl:text>
	<xsl:value-of select="$excelcol"/>
	<xsl:value-of select="$currow - 1"/>
	<xsl:text>)</xsl:text>
</xsl:template>

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

<xsl:template name="to-number">
	<xsl:param name="number"/>	
	
	<xsl:variable name="number_noseparator">
		<xsl:call-template name="replace-substring">
			<xsl:with-param name="original"><xsl:value-of select="$number"/></xsl:with-param>
			<xsl:with-param name="substring">,</xsl:with-param>
		</xsl:call-template>
		<!--TODO remove other separators if needed-->
	</xsl:variable>
	<xsl:if test="$number_noseparator and string-length($number_noseparator) &gt; 0">
		<xsl:value-of select="number($number_noseparator)"/>	
	</xsl:if>
</xsl:template>

<xsl:template name="calculate-julian-day">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    <xsl:param name="hour" select="0"/>
    <xsl:param name="minute" select="0"/>

    <xsl:variable name="a" select="floor((14 - $month) div 12)"/>
    <xsl:variable name="y" select="$year + 4800 - $a"/>
    <xsl:variable name="m" select="$month + 12 * $a - 3"/>
    <xsl:variable name="day-fraction" select="number($hour div 24) + number($minute div 1440)"/>

    <xsl:value-of select="$day + floor((153 * $m + 2) div 5) + $y * 365 + floor($y div 4) - floor($y div 100) + floor($y div 400) + number($day-fraction) - 32045"/>
</xsl:template>

<xsl:template name="excel-day-number">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    <xsl:param name="hour" select="0"/>
    <xsl:param name="minute" select="0"/>
    <xsl:variable name="julian_day_number">
    	<xsl:if test="$year &gt;= 1900 and $month &gt;= 1 and $month &lt;= 12 and $day &gt;= 1 and $day &lt;= 31">
	    	<xsl:call-template name="calculate-julian-day">
	    		<xsl:with-param name="year" select="$year"/>
	    		<xsl:with-param name="month" select="$month"/>
	    		<xsl:with-param name="day" select="$day"/>
	    		<xsl:with-param name="hour" select="$hour"/>
	    		<xsl:with-param name="minute" select="$minute"/>
	    	</xsl:call-template>
    	</xsl:if>
    </xsl:variable>
    <xsl:variable name="julian_111900_number">
    	<xsl:if test="$year &gt;= 1900 and $month &gt;= 1 and $month &lt;= 12 and $day &gt;= 1 and $day &lt;= 31">
	    	<xsl:call-template name="calculate-julian-day">
	    		<xsl:with-param name="year" select="1900"/>
	    		<xsl:with-param name="month" select="1"/>
	    		<xsl:with-param name="day" select="1"/>
	    	</xsl:call-template>
    	</xsl:if>
    </xsl:variable>
    <xsl:if test="$year &gt;= 1900 and $month &gt;= 1 and $month &lt;= 12 and $day &gt;= 1 and $day &lt;= 31">
    	<xsl:value-of select="$julian_day_number - $julian_111900_number + 2"/>
    </xsl:if>
</xsl:template>

<xsl:template name="excel-day-number-month">
    <xsl:param name="year"/>
    <xsl:param name="month"/>
    <xsl:param name="day"/>
    <xsl:variable name="month-number">
    	<xsl:choose>
				<xsl:when test="$month='JAN'">
					<xsl:text>1</xsl:text>
				</xsl:when>
				<xsl:when test="$month='FEB'">
					<xsl:text>2</xsl:text>
				</xsl:when>
				<xsl:when test="$month='MAR'">
					<xsl:text>3</xsl:text>
				</xsl:when>
				<xsl:when test="$month='APR'">
					<xsl:text>4</xsl:text>
				</xsl:when>
				<xsl:when test="$month='MAY'">
					<xsl:text>5</xsl:text>
				</xsl:when>
				<xsl:when test="$month='JUN'">
					<xsl:text>6</xsl:text>
				</xsl:when>
				<xsl:when test="$month='JUL'">
					<xsl:text>7</xsl:text>
				</xsl:when>
				<xsl:when test="$month='AUG'">
					<xsl:text>8</xsl:text>
				</xsl:when>
				<xsl:when test="$month='SEP'">
					<xsl:text>9</xsl:text>
				</xsl:when>
				<xsl:when test="$month='OCT'">
					<xsl:text>10</xsl:text>
				</xsl:when>
				<xsl:when test="$month='NOV'">
					<xsl:text>11</xsl:text>
				</xsl:when>
				<xsl:when test="$month='DEC'">
					<xsl:text>12</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>1</xsl:text>
				</xsl:otherwise>
		</xsl:choose>
    </xsl:variable>	
    <xsl:call-template name="excel-day-number">
	    <xsl:with-param name="year" select="$year"/>
    	<xsl:with-param name="month" select="$month-number"/>
    	<xsl:with-param name="day" select="$day"/>
	  </xsl:call-template>
</xsl:template>

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
	<xsl:value-of select="$mindiff mod 10"/>
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
