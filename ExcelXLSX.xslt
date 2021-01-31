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

<!--Number of base formats supported. Change this if you add or remove any of base format. Find comment for more detais: possible values of "base_format"-->
<xsl:variable name="num_of_base_formats" select="10"/>

<xsl:variable name="header-font"> 
		<xsl:if test="$use_print_settings = '1'">
			<xsl:value-of select="2*number($num_of_base_formats)"/> 
		</xsl:if>	
		<xsl:if test="$use_print_settings = '0'">
			<xsl:value-of select="number($num_of_base_formats)"/> 
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
		<xsl:value-of select="(ROW[1]/*)[last()]/@excelcol"/>
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
				<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{@excelcol}1" s="{$header-font}" t="inlineStr">
					<is><t>
						<xsl:value-of select="@FULL_NAME"/>
					</t></is>
				</c>
			 </xsl:for-each>
		</row>
		<xsl:for-each select="ROW">			    
			<xsl:variable name="currow">
				<xsl:value-of select="position()+1"/>
			</xsl:variable>
			
			<row r="@position" spans="1:{$cols}" x14ac:dyDescent="0.25">
				<xsl:for-each select="*">
					<xsl:variable name="excel_format">
						<xsl:choose>
							<xsl:when test="$use_print_settings = 1">
								<xsl:value-of select="@ps_format"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@format"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:choose>
						<xsl:when test="@aggr_function and @excelval">							
							<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{@excelcol}{$currow}" s="{$excel_format}">
								<f>
									<xsl:value-of select="@excelval"/>								
								</f>
							</c>
						</xsl:when>
						<xsl:when test="(@TYPE = 'DATE' or @TYPE = 'NUMBER') and @excelval"> 	
							<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{@excelcol}{$currow}" s="{$excel_format}">
								<v>
									<xsl:value-of select="@excelval"/>								
								</v>
							</c>
						</xsl:when>
						<xsl:otherwise> 	
							<c xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" r="{@excelcol}{$currow}" s="{$excel_format}" t="inlineStr">
								<is><t>
									<xsl:value-of select="."/>								
								</t></is>
							</c>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</row>
		</xsl:for-each>
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
</xsl:stylesheet>
