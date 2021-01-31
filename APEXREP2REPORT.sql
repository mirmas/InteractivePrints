
CREATE OR REPLACE PACKAGE "APEXREP2REPORT" AS
-- Interactive Prints using the following MIT License:
  --
  -- The MIT License (MIT)
  --
  -- Copyright (c) 2021 Mirmas IC
  --
  -- Permission is hereby granted, free of charge, to any person obtaining a copy
  -- of this software and associated documentation files (the "Software"), to deal
  -- in the Software without restriction, including without limitation the rights
  -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  -- copies of the Software, and to permit persons to whom the Software is
  -- furnished to do so, subject to the following conditions:
  --
  -- The above copyright notice and this permission notice shall be included in all
  -- copies or substantial portions of the Software.
  --
  -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  -- SOFTWARE.
  
g_views_granted constant boolean := false;
--Use filters constants--
g_no_filters      constant number := 0;
g_filters_hid_pk  constant number := 1;
g_filters         constant number := 2;
/* 0-No HTML markup, 1-HTML markup, 2-image link */

g_start_region_src constant varchar2(200) := ' region_src as ( ';
g_end_region_src constant varchar2(200)   := ')/*end of region_src*/';

/** Type for column in report */
type tp_col is record
    ( label         apex_application_page_ir_col.report_label%type
    , fullname      apex_application_page_ir_col.report_label%type
    , alias         apex_application_page_ir_col.column_alias%type
    , master_alias  apex_application_page_ir_col.column_alias%type
    , col_type      apex_application_page_ir_col.column_type%type
    , format_mask varchar2(400)
    , PRINT_COLUMN_WIDTH number
    , display_sequence number
    , sum_total varchar2(1) --Y/N
    , query_id number
    , html_img_included number --0-no html markup, 1-html markup, 2-html and image link
    , lov_sql varchar2(4000)
    , aggregation varchar(20)
    , item_type varchar(400)
    );

/** Type for column aggregation in report */
type tp_col_aggr is record
(
  column_alias apex_application_page_ir_col.column_alias%type
  ,aggregation varchar2(30)
  ,column_type varchar2(30)
);

/** Type for array of columns in as they appear in report (order and quantity) */
type tp_cols is table of tp_col;

/** Ordinary table of strings - used for column names*/
type tp_strtbl is table of varchar2(30);

/** Type for array of column aggregations in as they appear in report */
type tp_cols_aggr is table of tp_col_aggr;

/**Split separated cols used in apex_application_page_ir_* views. Also exclude 0 (used in apex_application_page_ir_rpt.break_enabled_on)
*
* @param str String with ':' separated columns
* @return string array table of columns
*/
function split_cols(str in varchar2)
return tp_strtbl;

function Html_img_included(
  p_display_as          varchar2
  ,p_column_link_text   varchar2
  ,p_format_mask        varchar2
)
return number;

function LOVSuperSelect(p_LOV_query varchar2)
return varchar2;

procedure LogComposeSelectAndAttr(
  p_procedure           varchar2,
  p_region_id           number default null,
  p_use_filters_hidPK   number default null,
  p_cols                tp_cols default null,
  p_basic_col_list      varchar2 default null,
  p_aggr_col_list       varchar2 default null,
  p_break_col_list      varchar2 default null,
  p_where               varchar2 default null,
  p_group_by_list       varchar2 default null,
  p_order_by_list       varchar2 default null,
  p_aggr_order_by_list  varchar2 default null,
  p_group_by_col_list   varchar2 default null,
  p_break_group_by_list varchar2 default null,
  p_break_group_by_list_alias varchar2 default null,
  p_cc_col_list         varchar2 default null,
  p_IRAttr              varchar2 default null,
  p_breakAttr           varchar2 default null,
  p_grpbyAttr           varchar2 default null,
  p_LOV_selects         varchar2 default null,
  p_join_LOV_selects    varchar2 default null,
  p_grand_total_col_list varchar2 default null,
  p_master_region_source      varchar2 default null,
  p_join_master_region        varchar2 default null,
  p_master_select_list                varchar2 default null
);

/** Compose source select with aggregation like union of ordinary IR source select and aggregation select
* sorting is the same like in IR (aggregation row is at the end of break group)
*
* @param pio_basic_col_list basic column list
* @param pio_aggr_col_list aggregation column list
* @param p_column_list column list of aggregate part of select
* @param pio_break_col_list break column list
* @param p_region_aggregates aggregates in format for row: aggr function, column,.. (eg: SUM, COL1, AVG, COL2)
* @param p_break_in_grand_total break and grand total applied on IG
*/
procedure AddAggregateColumns(
  --pio_region_source in out nocopy clob,
  pio_basic_col_list  in out varchar2,
  pio_aggr_col_list   in out varchar2,
  pio_break_col_list  in out varchar2,
  pio_grand_total_col_list in out varchar2,
  p_region_aggregates in varchar2 default null,
  p_grand_total_aggregates in varchar2 default null,
  p_break_in_grand_total in boolean default false
);

/** Get Source Query or Queries of the region(s) and resulting XML
*
* @param p_region_name Region name(s) separarted with semicolon. If null procedure uses suorces of all regions on the page.
* @param p_app_id APEX Application ID. If null current Application ID
* @param p_page_id APEX Page ID. If null current Page ID
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* You want to use 1 or 0 for cross reference by hidden or PK columns inside complex XML build from multiple queries.
* @param po_source_queries select queries for region(s) from p_region_name parameter
* @param po_xml one XML with region(s) data
*/
procedure GetSourceQueriesAndXML(
    p_region_name         in varchar2 default null,
    p_use_filters_hidPK   in number default g_filters,
    p_html_cols           in number default 0,
    p_page_id             in number default null,
    p_dwld_type           in number,
    po_xml                out CLOB,
    po_source_queries     out CLOB,
    po_regionAttrs        out query2report.tab_string,
    po_reportTypes        out query2report.t_coltype_tables
);
function GetLOVSelect(
  p_app_id number,
  p_col_alias varchar2,
  p_named_LOV varchar2,
  p_inline_LOV varchar2
)
return varchar2;
function BindSSApexItem(p_name varchar2)
return varchar2;
function PrepareColumnHeader(p_header varchar2)
return varchar2;

function RemoveLineBreak(p_fullname varchar2)
return varchar2;

/** Guess column type from region source query and format mask for non IR reports.
*
* @param p_report_types column types from region source query
* @param p_column_alias curent column alias
* @param p_format_mask Format mask.
* @return column type STRING, NUMBER or DATE
*/
function ColumnType(
  p_format_mask varchar2
)
return varchar2;

function MergeOrderList(
  p_aggr_order_by_list varchar2,
  p_order_by_list varchar2,
  p_IG boolean default false
)
return varchar2;

/** Download otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single temporary XML
  * created from data fetched by region(s) source selects
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_page_id APEX ID of page with report region(s)
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
  * You want to use 1 or 0 for cross referencing by hidden or PK columns inside complex XML build from multiple queries.
  * @param p_html_cols Columns with HTML markup in temporary XML. 0 - Convert to text, exclude columns with image links, 1 - Exlude columns with HTML markup,
  * 2 - Exclude columns with image links, preserve rest HTML markup, 3 - Preserve HTML markup, 4 - Convert to text. Default 0.
  * @param p_region_name Region(s) name(s) separarted with semicolon. If null procedure uses suorces of current region.
  * @param p_format Define output format to apply format corrections (e.g. inserting new lines to make output format more readable.). Must be set for MHT format or if download Starter XSLT.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Single quotes are not necessary for numeric values. Example: startX=50 baseColor='magenta'.
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_BBFile Building block file
  * @param p_BB_no_esc_sc Applied only when p_format is F_TEXT. If true then not escape XML special characters.
  * You should escape special XML (<,>," and &) characters if Building block file is in RTF format.
  * You should not escape special characters if Building block file is in MHT format.
  * @param p_convertblob_param P_PARAM Parameter of ConvertCLOB procedure
  */
function GetApexReport(
  p_xsltStaticFile            IN  varchar2,
  p_filename                  in out VARCHAR2,
  p_page_id                   in  number,
  p_dwld_type                 in  number default Query2Report.g_dwld_transformed,
  p_use_filters_hidPK         in  number default g_filters,
  p_html_cols                 in  number default 0,
  p_region_name               in  varchar2 default null,
  p_format                    IN  number default null,
  p_templateStaticFile        in  VARCHAR2 default null,
  p_external_params           IN  varchar2 default null,
  p_second_XsltStaticFile      IN  varchar2 default null,
  p_second_external_params     IN  varchar2 default null,
  --p_run_in_background         IN  boolean default false,
  p_log_level                 IN  number default null--,
  --p_convertblob_param       IN varchar2 default null
)
return BLOB;

/** Process plugin function
  * Download otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single temporary XML
  * created from data fetched by region(s) source selects
  * @param p_process.attribute_01 Text with filename of APEX static file with main XSLT
  * @param p_process.attribute_02 Filename of downloaded output
  * @param p_process.attribute_11 ID of APEX page with report region(s)
  * @param p_process.attribute_03 Static LOV: What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT. Default Query2Report.g_dwld_transformed (0)
  * @param p_process.attribute_04 Static LOV: 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters. Default g_filters (2)
  * You want to use 1 or 0 for cross referencing by hidden or PK columns inside complex XML build from multiple queries.
  * @param p_process.attribute_05 Columns with HTML markup in temporary XML. 0 - Convert to text, exclude columns with image links, 1 - Exlude columns with HTML markup,
  * 2 - Exclude columns with image links, preserve rest HTML markup, 3 - Preserve HTML markup, 4 - Convert to text. Default 0.
  * @param p_process.attribute_06 Region name(s) separarted with semicolon. If null procedure uses suorces of current region. Default null means current region.
  * @param p_process.attribute_07 Define output format to apply format corrections (e.g. inserting new lines to make output format more readable.). Must be set for MHT format or if download Starter XSLT. Default Query2Report.F_TEXT (0)
  * @param p_process.attribute_08 External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Single quotes are not necessary for numeric values. Example: startX=50 baseColor='magenta'. Default null no first XSLT.
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_process.attribute_09 Text with filename of APEX static file with XSLT applied before main XSLT. Default null means no params.
  * @param p_process.attribute_10 External parameters for transformation XSLT applied before main XSLT. Default null means no params.
  * See format notes at p_external_params parameter.
  * @param  p_process.attribute_12 Run in Background Y/N default N. If Y means XSL process and ConvertBlob will run in separate job
  * @param  p_process.attribute_13 Template Static File and Parts to transform separated with comma. Template Static File must be first
  * @param p_process.attribute_14 Log level
  * @param p_process.attribute_15 P_PARAM Parameter of ConvertCLOB procedure
  */
function Region2XSLTReport(
    p_process in apex_plugin.t_process,
    p_plugin  in apex_plugin.t_plugin
)
return apex_plugin.t_process_exec_result;
END APEXREP2REPORT;
/
