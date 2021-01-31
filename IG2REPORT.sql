
CREATE OR REPLACE package IG2REPORT as

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

$IF CCompiling.g_ig_exists $THEN

function GetLOVSelect(
  p_app_id number,
  p_col_alias varchar2,
  p_LOV_ID APEX_APPL_PAGE_IG_COLUMNS.LOV_ID%type,
  p_LOV_SOURCE APEX_APPL_PAGE_IG_COLUMNS.LOV_SOURCE%type
)
return varchar2;

/** Returns where sentence and order by from filters.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_apr row of current report in apex_application_page_ir_rpt view.
* @param pio_region_source Source query of region.
*/
procedure IGUseFilters(
    p_region_id number,
    p_page_id number,
    p_use_filters_hidPK number,
    p_master_region_id number,
    p_cols APEXREP2REPORT.tp_cols,
    po_order_by_list out varchar2,
    po_aggr_order_by_list out varchar2,
    po_where out varchar2
);

/**Combine all highlight conditions of current IG from APEX_APPL_PAGE_IG_RPT_HIGHLTS
* view into one column compute with case sentence
*
* @param p_page_id APEX Page ID.
* @param p_region_id APEX Region ID.
* @param p_aggregation true if also aggregation occur
* @param p_cols collection of columns info
*/
function GetHighlightCaseAll(
  p_page_id number,
  p_region_id number,
  p_aggregation boolean,
  p_cols APEXREP2REPORT.tp_cols default null
)
return varchar2;

/**  Returns Array of columns in as they appear in IG report (order and quantity) with using filters.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @param p_current_report_columns Visible IG columns separated with :.
* @return Array of columns in as they appear in report (order and quantity) with hidden and PK columns at the start if p_hidPK is true.
*/
function CollectIGColumns(
   p_region_id            in number,
   p_page_id              in number,
   p_use_filters_hidPK    in number,
   po_IG_Attr             out varchar2,
   po_max_rows_IG         out number
   --p_current_report_columns  in varchar2 default null
)
return APEXREP2REPORT.tp_cols;

/** Function Check apex_application_page_ir_rpt, apex_application_page_ir_comp and other views for any aggregation and outputs parts of select statement if IR is not in GROUP BY mode
*  Verzija  APEXREP2REPORT.AggregateSelectReport
*
*   Source (l_source variable) is region_src or region_src_cc or region_src_filtered or region_src_grpby.
*
*   With region_src as (region_select)
*        ,region_src_cc as (select region_src.*,cc_cols_list from region_src)
*        ,region_src_filtered as (select from region_src_cc where p_where)
*   Select formated_labeled_col_list from
*   (
*       Select po_basic_col_list{, null BREAKROW}[, null REGION_AGGR] from Source
*     [Union
*        Select po_aggr_col_list{, null BREAKROW}, aggr. col. list REGION_AGGR from Source
*        {Group by po_break_group_by_list}]
*        {Union
*        Select po_break_col_list, 1 BREAKROW[, null REGION_AGGR] from Source}
*   )
*   Order by [{po_aggr_order_by_list,}] order_by_list;
*
* SQL in [] applied only if aggregation is applied on IR.
* SQL in {} applied only if control break is applied on IR.
*
*
* @param t_cols Structure with column info received in CollectIGColumns function.
* @param po_breakAttr attribute for Region element of temporary XML
* @param po_basic_col_list list of columns in select
* @param po_aggr_col_list columns with which have aggregations defined (SUM, AVG, COUNT..), columns with no aggregation have null values
* @param po_break_col_list columns in IR break, columns with no break have null values
* @param po_aggr_order_by_list if aggregation applied this is first part of order by column list (BREAKROW, REGION_AGGREGATES desc)
* @param po_break_group_by_list if break and aggregation applied
*/
procedure AggregateSelect(
  p_cols in APEXREP2REPORT.tp_cols,
  po_breakAttr out varchar2,
  po_basic_col_list out varchar2,
  po_aggr_col_list out varchar2,
  po_break_col_list out varchar2,
  pio_aggr_order_by_list in out varchar2,
  po_break_group_by_list out varchar2,
  po_grand_total_col_list  out varchar2
) ;

/**Returns Master Region select and join to Details region
*
* @param p_report_id Report ID of user's current report
* @param p_region_id Region ID of Details Region
* @param po_master_region_source Master region source select
* @param po_join_master_region Join condition in format master_region_src.col1 = region_src.col1 [and master_region_src.colX = region_src.colX]
* @param po_master_select_list Alias column list in region_src_joined_master inline view
*/
procedure MasterRegionSelect(
  p_region_id number,
  t_cols APEXREP2REPORT.tp_cols,
  po_master_region_source out varchar2,
  po_join_master_region out varchar2,
  po_master_select_list out varchar2,
  po_master_region_id out number
);

$END

end;
/
