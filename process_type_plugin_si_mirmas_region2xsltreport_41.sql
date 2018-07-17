set define off
set verify off
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_040100 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>nvl(wwv_flow_application_install.get_workspace_id,23372214038154876));
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2011.02.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := nvl(wwv_flow_application_install.get_application_id,104);
   wwv_flow_api.g_id_offset := nvl(wwv_flow_application_install.get_offset,0);
null;
 
end;
/

prompt  ...plugins
--
--application/shared_components/plugins/process_type/si_mirmas_region2xsltreport
 
begin
 
wwv_flow_api.create_plugin (
  p_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_type => 'PROCESS TYPE'
 ,p_name => 'SI.MIRMAS.REGION2XSLTREPORT'
 ,p_display_name => 'Region2XSLTReport'
 ,p_image_prefix => '#PLUGIN_PREFIX#'
 ,p_execution_function => 'apexrep2report.Region2XSLTReport'
 ,p_substitute_attributes => true
 ,p_help_text => '<p>'||unistr('\000a')||
'	Plug-in uses the source queries of all report regions on a page (standard or interactive) to fetch and convert data to temporary XML with DBMS_XMLGEN package. Plug-in then applies on temporary XML one or two XSLT transformation with XSLT processor implemented as DBMS_XSLPROCESSOR package. If we can&rsquo;t build desired output just with XSLT final conversions can be made with <em>ConverClob</em> procedure. Plug-in then starts download of transformed output. XSLT transformations must be uploaded in APEX application as static files.</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'	Plug-in is low cost report tool for Oracle APEX. Helper procedures are specialized for Office formats, but any text, HTML or XML base format can be produced and downloaded (like Scalable Vector Graphics - SVG, Formatted objects - FO, Virtual Reality Modeling Language &ndash; VRML or even some programming code &ndash; Java or PL/SQL).</p>'||unistr('\000a')||
''
 ,p_version_identifier => '1.0'
 ,p_about_url => 'www.mirmas.si'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698119842659884522 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 1
 ,p_display_sequence => 10
 ,p_prompt => 'First XSLT static file'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,3'
 ,p_help_text => 'Filename of APEX static file with XSLT applied first. If after first XSLT second XSLT will be applied then output of first XSLT must be XML.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698094940348819562 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 2
 ,p_display_sequence => 20
 ,p_prompt => 'Transformed output filename'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => '0'
 ,p_help_text => 'Filename of downloaded output in browser download dialog. File type can do a lot of work here. If you don’t use ConvertBLOB procedure output will be in fact text, XML or HTML. Text can be RTF or MHT or something else. Let''s say output is MS Word Filtered HTML. If you enter here document.doc Word will start automatically on opening file. It’s far better to enter target file type (DOC, XLS) here rather than XML, HTM, HTML or even TXT file type. Sometimes you must answer to conversion dialog when opening file. For example If you named XML of type Spreadsheet 2003 XML as test.xls you get conversion dialog in Microsoft Excel 2010.'||unistr('\000a')||
'You can use three replacment strings here: #PAGE_NAME#, #PAGE_TITLE# and #PAGE_ALIAS#. This strings will be replaced with page name, page title or page alias of page with ID entered in Report Page ID field.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 3
 ,p_display_sequence => 5
 ,p_prompt => 'What to download'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
 ,p_help_text => 'Here we can define what final output we want to download:'||unistr('\000a')||
'•	Transformed output. This is only production option. Rest of the values is for developing and testing purposes only. This downloads final output after one or two XSLT and possibly some ConvertCLOB procedure are applied.'||unistr('\000a')||
'•	Temporary XML. We stopped process after XML is generated and we download XML.'||unistr('\000a')||
'•	Temporary XML, copy XML to XPM. We stopped process after XML is generated, downloaded and copied to XSLT Project Manager(XPM). You can start develop and test your XSLT inside XPM.'||unistr('\000a')||
'•	Source selects. We stopped process before XML is generated and we download region select(s) separated with semicolon.'||unistr('\000a')||
'•	First XSLT. We download first XSLT saved in APEX application static files.'||unistr('\000a')||
'•	Second XSLT. If exists we download second XSLT saved in APEX application static files.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100956185880087420 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Transformed output'
 ,p_return_value => '0'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100960491421088977 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'temporary XML (development and testing)'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100964799386091288 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 25
 ,p_display_value => 'temporary XML, copy XML to XPM (development and testing)'
 ,p_return_value => '5'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100969073544093299 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Suorce select(s) (development and testing)'
 ,p_return_value => '2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100973378393094669 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'First XSLT (development and testing)'
 ,p_return_value => '3'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 100977682895096033 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Second XSLT (development and testing)'
 ,p_return_value => '4'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698098358403853180 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 4
 ,p_display_sequence => 40
 ,p_prompt => 'Use filters'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '2'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,1,2'
 ,p_help_text => '<p>Value <b>Don’t use filters</b> just puts whole result set from report select into XML. '||unistr('\000a')||
'	No filtering, selecting columns and sorting from report are applied. '||unistr('\000a')||
'	You should choose this if you want to do all the work inside your XSLT.'||unistr('\000a')||
'</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'<b>Use filters - don''t include hidden columns and PK columns:</b> '||unistr('\000a')||
'Inside Interactive Reports (IR) we can sort and filter result set. '||unistr('\000a')||
'Usually we want our Office report looks like APEX IR rather than Office report include all data returned by IR source select. '||unistr('\000a')||
'Value <b>Use filters - don''t include hidden columns and PK columns</b> does just that. '||unistr('\000a')||
'Filtering is trickier in Classic Report (CR). Only filter we can use in Classic Reports is report column property <b>Include in Export</b>.'||unistr('\000a')||
'</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'<b>Use filters but include also hidden columns and PK columns:</b> '||unistr('\000a')||
'Sometimes you want to create links and cross references in your XSLT and also use APEX report filtering. '||unistr('\000a')||
'ID columns are usually hidden so they won’t be included in XML if we chose '||unistr('\000a')||
'<b>Use filters - don''t include hidden columns and PK columns</b>. '||unistr('\000a')||
'We should select <b>Use filters but include also hidden columns, PK columns and columns with SC</b> for that. '||unistr('\000a')||
'</p>'||unistr('\000a')||
'<p>'||unistr('\000a')||
'This plugin attribute considers two types of columns:'||unistr('\000a')||
'<ul>'||unistr('\000a')||
'<li>Hidden columns are common in IR and CR. </li>'||unistr('\000a')||
'<li>PK column stands for Primary key column. '||unistr('\000a')||
'	Primary key column is column in tabular form where type of report is SQL Report (updateable report) and '||unistr('\000a')||
'	<b>Source Type</b> column attribute has value <b>Primary Key</b>.</li> '||unistr('\000a')||
'</ul> '||unistr('\000a')||
'</p>'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698098833946855567 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698098358403853180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Don''t use filters'
 ,p_return_value => '0'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698099241218857682 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698098358403853180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Use filters but include also hidden coulumns and PK columns'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698099647452859414 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698098358403853180 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Use filters - don''t include hidden columns and PK columns'
 ,p_return_value => '2'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 5
 ,p_display_sequence => 50
 ,p_prompt => 'Columns with HTML markup in temporary XML'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,1,2'
 ,p_help_text => 'Columns with HTML markup (Special characters) are columns which are displayed as <b>Standard Report Column</b>. There is no special characters escaping. This type of column is used to put custom HTML (e.g. formated text, images) into report cell.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 106445617629591965 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Convert to text, exclude columns with image links'
 ,p_return_value => '0'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 106446005768597421 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Exlude columns with HTML markup'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 106446419127606478 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Exclude columns with image links, preserve rest HTML markup'
 ,p_return_value => '2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 106446811566625162 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'Preserve HTML markup'
 ,p_return_value => '3'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 106447205528627940 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 106445207074581701 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'Convert to text'
 ,p_return_value => '4'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 99633014082540816 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 6
 ,p_display_sequence => 60
 ,p_prompt => 'Region names and report queries'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,1,2'
 ,p_help_text => 'Page report regions names separated with semicolon. If left blank plugin uses sources of all report regions on report page. You can add custom SQL report query here with temporary XML Region element name attribute and number of fetched rows. Example of valid syntax: '||unistr('\000a')||
'region1;select name, surname, salary from emp;salary;50;region2'||unistr('\000a')||
'Temporary XML from example will have three Region elements with name attributes region1, salary and region2 where region1 and region2 are region names from page report.'||unistr('\000a')||
'Region names are case sensitive! '
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 7
 ,p_display_sequence => 70
 ,p_prompt => 'Output format'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => true
 ,p_default_value => '0'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,6'
 ,p_help_text => 'Define output format to apply format corrections (e.g. inserting new lines to make output format more readable.). Value MHT must be set for Single Web Page (MHT) format. Default format is TEXT.'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698101659142881710 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Text'
 ,p_return_value => '0'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698102062605882776 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'HTML'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698102434339884052 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'MHT'
 ,p_return_value => '2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698102838148885167 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 40
 ,p_display_value => 'XML'
 ,p_return_value => '3'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 66698103241265886022 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 50
 ,p_display_value => 'RTF'
 ,p_return_value => '4'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 23861520348902102 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 60
 ,p_display_value => 'OOXML (DOCX, XLSX)'
 ,p_return_value => '5'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698103740835904852 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 8
 ,p_display_sequence => 80
 ,p_prompt => 'First XSLT External Parameters'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 66698119842659884522 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_NULL'
 ,p_help_text => 'Here you can pass external parameters to XSLT processor for first XSLT transformation. Format for single parameter is name=''value''. Single quotes are not necessary for numeric values. Example: startX=50 baseColor=''magenta''. Notice that we had to put single quotes around the text value magenta! Left blank if first XSLT doesn''t need any external parameters!'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698120434132891475 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 9
 ,p_display_sequence => 90
 ,p_prompt => 'Second XSLT'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'IN_LIST'
 ,p_depending_on_expression => '0,4'
 ,p_help_text => 'Filename of APEX static file with XSLT applied after first XSLT. Left blank if no second XSLT will be applied! If not blank output of first XSLT must be XML.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698104764299930495 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 10
 ,p_display_sequence => 100
 ,p_prompt => 'Second XSLT external parameters'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 66698120434132891475 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'NOT_NULL'
 ,p_help_text => 'Here you can pass external parameters to XSLT processor for second XSLT transformation. Left blank if second XSLT doesn''t need any external parameters or second XSLT will not be applied. '||unistr('\000a')||
'Format for single parameter is name=''value''. Single quotes are not necessary for numeric values. Example: startX=50 baseColor=''magenta''. Notice that we had to put single quotes around the text value magenta! '||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 66698121034956901170 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 11
 ,p_display_sequence => 3
 ,p_prompt => 'Report Page ID'
 ,p_attribute_type => 'INTEGER'
 ,p_is_required => true
 ,p_is_translatable => false
 ,p_help_text => 'APEX page ID with report region(s). We want output report contains data from that regions. This is ID of page where we create branch or link targeting to plug-in host page.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 101069576624141493 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 12
 ,p_display_sequence => 120
 ,p_prompt => 'Run in Backgroud'
 ,p_attribute_type => 'CHECKBOX'
 ,p_is_required => false
 ,p_default_value => 'N'
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 100951181032085975 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => '0'
 ,p_help_text => 'Plugin will always rerun query and create temporary XML inside APEX. Reason is VPD and/or use of application context and fine-grained access control. When set to yes plugin process will just start job for XSL transformation(s) and ConvertBlob procedure and exit. Use this options if you want to XSL transform large XML (let say more then 10000 rows) and you don''t need immediate output download. That way you can perform XSLT on XML with millions of rows and send output as email attachment or save it to disk without significantly affecting application performance (without freezing).'||unistr('\000a')||
''||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 68825051793674298 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 13
 ,p_display_sequence => 75
 ,p_prompt => 'Static parts template (Flat OPC)'
 ,p_attribute_type => 'TEXT'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_depending_on_attribute_id => 66698101154986880540 + wwv_flow_api.g_id_offset
 ,p_depending_on_condition_type => 'EQUALS'
 ,p_depending_on_expression => '5'
 ,p_help_text => 'Enter static file name of Flat OPC template with static parts. Parts in OPC are equivalents to zipped files in OOXML (DOCX or XLSX). Plugin will merge final output from two files, both in Flat OPC format and convert Flat OPC to OOXML at the end. First file is output from XSL transformation. It''s included in output as a whole. Second file is the entered file. Only parts that aren''t already in first file will be included in final OOXML Output.'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 104653620285989486 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 14
 ,p_display_sequence => 140
 ,p_prompt => 'Log Level'
 ,p_attribute_type => 'SELECT LIST'
 ,p_is_required => false
 ,p_default_value => '2'
 ,p_is_translatable => false
 ,p_help_text => 'Plug-in packages write log records in XSLT_LOG table. See PAK_XSLT_LOG technical specification for details. Here you can enter level of logging. '||unistr('\000a')||
'You can query log info with select on table XSLT_LOG. E.g.'||unistr('\000a')||
'select * from xslt_log where log_date >= to_date(''14.08.2012 08:47'', ''dd.mm.yyyy hh24:mi'') order by id_xslt_log; '||unistr('\000a')||
'LOG_TYPE column meaning: I - Information, W - Warning, E - Error. You can query just performance log info if you add next condition to where clause: and description like ''%time: %''. E.g. '||unistr('\000a')||
'select * from xslt_log where log_date >= to_date(''14.08.2012 09:05'', ''dd.mm.yyyy hh24:mi'') and description like ''%time: %'' order by id_xslt_log;'||unistr('\000a')||
'Plug-in never clears XSLT_LOG table or copy records to some archive table. This is plug-in user responsibility.'||unistr('\000a')||
''
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 104654238986994871 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 104653620285989486 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 10
 ,p_display_value => 'Log just errors'
 ,p_return_value => '1'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 104654612237006103 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 104653620285989486 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 20
 ,p_display_value => 'Log errors and warnings (default)'
 ,p_return_value => '2'
  );
wwv_flow_api.create_plugin_attr_value (
  p_id => 104655025396009940 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_attribute_id => 104653620285989486 + wwv_flow_api.g_id_offset
 ,p_display_sequence => 30
 ,p_display_value => 'Log all (informations, errors and warnings)'
 ,p_return_value => '3'
  );
wwv_flow_api.create_plugin_attribute (
  p_id => 101094897879157094 + wwv_flow_api.g_id_offset
 ,p_flow_id => wwv_flow.g_flow_id
 ,p_plugin_id => 66698094256231795746 + wwv_flow_api.g_id_offset
 ,p_attribute_scope => 'COMPONENT'
 ,p_attribute_sequence => 15
 ,p_display_sequence => 150
 ,p_prompt => 'ConvertBLOB Parameter'
 ,p_attribute_type => 'TEXTAREA'
 ,p_is_required => false
 ,p_is_translatable => false
 ,p_help_text => 'ConvertBLOB is unwrapped procedure which comes with plug-in and it''s called every time after XSLT transformation(s) and before download report. You are free to change code in that procedure to suit your needs. Here you can enter P_PARAM parameter of ConvertBLOB. '||unistr('\000a')||
'Possible scenario of using this parameter would be converting from XSL-FO to PDF (if this is possible in PL/SQL...). First XSLT would return some Office XML format. With some luck you can find XSLT which transforms from that Office format to XSL-FO. This would be Second XSLT. In step three you would convert XSL-FO to PDF with ConvertBLOB procedure. '||unistr('\000a')||
''
  );
null;
 
end;
/

commit;
begin 
execute immediate 'begin dbms_session.set_nls( param => ''NLS_NUMERIC_CHARACTERS'', value => '''''''' || replace(wwv_flow_api.g_nls_numeric_chars,'''''''','''''''''''') || ''''''''); end;';
end;
/
set verify on
set feedback on
prompt  ...done
