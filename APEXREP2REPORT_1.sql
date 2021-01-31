
CREATE OR REPLACE PACKAGE BODY "APEXREP2REPORT" AS

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

/** Type for region name with (optional - mixed syntax) queries */
type tp_region is record
(
  region_name varchar2(32000),
  region_query varchar2(32000),
  max_rows number
);

/** Type for array of region names with (optional - mixed syntax) queries */
type tp_regions is table of tp_region;

/** Indexed table of columns in computed columns. Index is one or two capital letter word, like in interactive report*/
TYPE tp_idcols IS TABLE OF varchar2(30) INDEX BY VARCHAR2(2);

type tp_order_cols is table of varchar2(40) index by binary_integer;

/** Type for array of hidden or PK columns in report (just label)*/
--type tp_hidden_pk_cols is table of varchar2(200);

procedure WriteAppendAllString(
  lob_loc IN OUT NOCOPY CLOB CHARACTER SET ANY_CS,
   buffer  IN            VARCHAR2 CHARACTER SET lob_loc%CHARSET
)
as
begin
  dbms_lob.writeappend(lob_loc, length(buffer), buffer);
end;

function tp_col2string(t_cols tp_cols)
return varchar2
as
l_ret varchar2(32000);
begin
  for i in 1..t_cols.count loop
    l_ret:=l_ret||i||'.'||t_cols(i).query_id||'.'||t_cols(i).display_sequence||','||t_cols(i).alias||','||t_cols(i).label||'|';
  end loop;
  return l_ret;
end;

/**Converts column label to valid xml name. At the same time it also must
* be valid column name for use in super select so it's cut to 30 chars
*
* @param p_col_label column label
* @return valid xml name cuted to 30 chars.
*/
/*
function Query2Report.ConvertColName2XmlName(p_col_label varchar2)
return varchar2
as
begin
  return substr(translate(p_col_label,' ()','_'), 1, 30);
end;
*/

/** Generates REPORT_TYPES XML element
*
* @param t_cols table of cols records.
* @return REPORT_TYPES XML element.
*/
function ReportTypesTable(t_cols tp_cols)
return t_coltype_table
as
l_ret     t_coltype_table := t_coltype_table();
l_xmlname varchar2(100);
begin
  for i in 1..t_cols.count loop
    l_xmlname := Query2Report.ConvertColName2XmlName(t_cols(i).label);
    --l_xmlname := t_cols(i).label;
    l_ret.extend;
    l_ret(l_ret.count) := t_coltype_row(l_xmlname, t_cols(i).col_type, t_cols(i).format_mask, t_cols(i).PRINT_COLUMN_WIDTH,
    replace(htf.escape_sc(BindSSApexItem(t_cols(i).fullname)),'''','&#39;'),
    i, Query2Report.ExcelCol(i),
    null, null, null, null, null, null, null, null, null, null, null);
    /*
    l_ret := l_ret||'<'||l_xmlname||'>'||Query2Report.g_crlf;
    l_ret := l_ret||'<TYPE>'||t_cols(i).col_type||'</TYPE>'||Query2Report.g_crlf;
    l_ret := l_ret||'<FORMAT_MASK>'||t_cols(i).format_mask||'</FORMAT_MASK>'||Query2Report.g_crlf;
    l_ret := l_ret||'</'||l_xmlname||'>'||Query2Report.g_crlf;
    */
  end loop;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'ReportTypesTable', p_sqlerrm => sqlerrm );
  raise;
end ReportTypesTable;

function RemoveSemicolon(p_region_source VARCHAR2)
return VARCHAR2
as
l_ret VARCHAR2(32000);
l_region_source VARCHAR2(32000):= rtrim(p_region_source,';');
l_semicolon_pos NUMBER := 0;
i PLS_INTEGER := 1;
begin
    l_semicolon_pos := instr(l_region_source, ';',-1,1);
    
    if nvl(l_semicolon_pos, 0) > 0 
        and nvl(regexp_substr(substr(l_region_source, l_semicolon_pos + 1),'(\s*)(\)/\*end of region_src\*/)*'),'') = 
        nvl(substr(l_region_source, l_semicolon_pos + 1),'') --just whitespaces after semicolon 
    then
        l_ret := trim(substr(l_region_source, 1, l_semicolon_pos - 1));
    else
        l_ret := trim(l_region_source);
    end if;
    return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_region_source '||p_region_source,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'RemoveSemicolon',
    p_sqlerrm => sqlerrm );
  raise;
end;


/** Returns row from apex_application_page_ir_rpt table which describe base report of region p_region_id.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @return Row from apex_application_page_ir_rpt table which describe current report of region p_region_id.
*/
function Get_current_report_row(
   p_region_id in number,
   p_page_id in number
)
return apex_application_page_ir_rpt%rowtype
as
  t_interactive_report_id number;
  t_pref varchar2(200);
  t_base_report_id number;
  t_apr apex_application_page_ir_rpt%rowtype;
  l_exists number; 				  
begin

  select api.interactive_report_id
  into t_interactive_report_id
  from apex_application_page_ir api
  where api.application_id = APEX_APPLICATION.G_FLOW_ID
  and   api.page_id = p_page_id
  and   api.region_id = p_region_id;
--
  t_pref := apex_util.get_preference( 'FSP_IR_' || to_char(APEX_APPLICATION.G_FLOW_ID) || '_P' || p_page_id || '_W' || t_interactive_report_id, v( 'APP_USER') );

  if t_pref is null then
    pak_xslt_log.WriteLog( 'User preference t_pref is null', p_procedure => 'Get_current_report_row');

    select *
    into t_apr
    from
    (
      select *
      from apex_application_page_ir_rpt apr
      where apr.application_id = APEX_APPLICATION.G_FLOW_ID
      and   apr.page_id = p_page_id
      and   apr.APPLICATION_USER  = V('APP_USER')
      and   apr.session_id = V('SESSION')
$IF CCOMPILING.g_IG_exists $THEN	  
      and   apr.region_id = p_region_id
$END	  
      order by apr.report_id desc
    ) where rownum = 1;
  else
    t_base_report_id := substr( t_pref, 1, instr( t_pref, '_' ) - 1 );

    pak_xslt_log.WriteLog( 'User preference t_pref is NOT null t_base_report_id '||t_base_report_id,
                            p_log_type => pak_xslt_log.g_error,
                           p_procedure => 'Get_current_report_row');
    pak_xslt_log.WriteLog( 'APEX_APPLICATION.G_FLOW_ID: '||APEX_APPLICATION.G_FLOW_ID||
                            ' p_page_id: '||p_page_id||
                            ' V(''APP_USER''): '||V('APP_USER')||
                            ' V(''SESSION''): '||V('SESSION')||
                            ' p_region_id: '||p_region_id,
                            p_log_type => pak_xslt_log.g_error,
                            p_procedure => 'Get_current_report_row');
                            
    select count(*) 
    into l_exists
    from apex_application_page_ir_rpt apr
    where apr.application_id = APEX_APPLICATION.G_FLOW_ID
    and   apr.page_id = p_page_id
    and   apr.APPLICATION_USER  = V('APP_USER')
    and   apr.base_report_id = t_base_report_id
$IF CCOMPILING.g_IG_exists $THEN
    and   apr.region_id = p_region_id
$END
    ;                           

    if l_exists = 1 then       
        select *
        into t_apr
        from apex_application_page_ir_rpt apr
        where apr.application_id = APEX_APPLICATION.G_FLOW_ID
        and   apr.page_id = p_page_id
        and   apr.APPLICATION_USER  = V('APP_USER')
        and   apr.base_report_id = t_base_report_id
$IF CCOMPILING.g_IG_exists $THEN
        and   apr.region_id = p_region_id
$END     
    ;--and   apr.session_id = V('SESSION');
    elsif l_exists > 1 then
		select *
		into t_apr
		from apex_application_page_ir_rpt apr
		where apr.application_id = APEX_APPLICATION.G_FLOW_ID
		and   apr.page_id = p_page_id
		and   apr.APPLICATION_USER  = V('APP_USER')
		and   apr.base_report_id = t_base_report_id
$IF CCOMPILING.g_IG_exists $THEN	 	
		and   apr.region_id = p_region_id
$END	
		and   apr.session_id = V('SESSION');
	else 
		select *
		into t_apr
		from apex_application_page_ir_rpt apr
		where apr.application_id = APEX_APPLICATION.G_FLOW_ID
		and   apr.page_id = p_page_id
		and   apr.APPLICATION_USER  = 'APXWS_DEFAULT'
		--and   apr.base_report_id = t_base_report_id
$IF CCOMPILING.g_IG_exists $THEN
        and   apr.region_id = p_region_id
$END     
    ;--and   apr.session_id = V('SESSION');
    end if;
  end if;


  --pak_xslt_log.WriteLog( 'Break on '||t_apr.break_on||' Break enabled on '||t_apr.break_enabled_on, p_procedure => 'Get_current_report_row');

  return t_apr;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Get_current_report_row', p_sqlerrm => sqlerrm );
  raise;
end Get_current_report_row;

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
  p_master_region_source varchar2 default null,
  p_join_master_region   varchar2 default null,
  p_master_select_list   varchar2 default null
)
as
l_ret varchar(32000);
begin
  if p_region_id is not null then
    l_ret := 'p_region_id: '||p_region_id;
  end if;

  if p_use_filters_hidPK is not null then
    l_ret := l_ret||
    case p_use_filters_hidPK
      when g_no_filters then ' No filters '
      when g_filters_hid_pk then ' Hidden PK '
      when g_filters then ' Use filters '
    end;
  end if;
  if p_cols is not null then
    l_ret := l_ret ||' p_cols: '||tp_col2string(p_cols);
  end if;
  if p_basic_col_list is not null then
    l_ret := l_ret ||' p_basic_col_list: '||p_basic_col_list;
  end if;
  if p_aggr_col_list is not null then
    l_ret := l_ret ||' p_aggr_col_list: '||p_aggr_col_list;
  end if;
  if p_break_col_list is not null then
    l_ret := l_ret ||' p_break_col_list: '||p_break_col_list;
  end if;
  if p_cc_col_list is not null then
    l_ret := l_ret ||' p_cc_col_list: '||p_cc_col_list;
  end if;
  if p_where is not null then
    l_ret := l_ret ||' p_where: '||p_where;
  end if;
  if p_group_by_list is not null then
    l_ret := l_ret ||' p_group_by_list: '||p_group_by_list;
  end if;
  if p_break_group_by_list is not null then
    l_ret := l_ret ||' p_break_group_by_list: '||p_break_group_by_list;
  end if;
  if p_break_group_by_list_alias is not null then
    l_ret := l_ret ||' p_break_group_by_list_alias: '||p_break_group_by_list_alias;
  end if;
  if p_order_by_list is not null then
    l_ret := l_ret ||' p_order_by_list: '||p_order_by_list;
  end if;
  if p_aggr_order_by_list is not null then
    l_ret := l_ret ||' p_aggr_order_by_list: '||p_aggr_order_by_list;
  end if;
  if p_group_by_col_list is not null then
    l_ret := l_ret ||' p_group_by_col_list: '||p_group_by_col_list;
  end if;
  if p_IRAttr is not null then
    l_ret := l_ret ||' p_IRAttr: '||p_IRAttr;
  end if;
  if p_breakAttr is not null then
    l_ret := l_ret ||' p_breakAttr: '||p_breakAttr;
  end if;
  if p_grpbyAttr is not null then
    l_ret := l_ret ||' p_grpbyAttr: '||p_grpbyAttr;
  end if;
  if p_LOV_selects is not null then
    l_ret := l_ret ||' p_LOV_selects: '||p_LOV_selects;
  end if;
  if p_join_LOV_selects is not null then
    l_ret := l_ret ||' p_join_LOV_selects: '||p_join_LOV_selects;
  end if;
  if p_grand_total_col_list is not null then
    l_ret := l_ret ||' p_grand_total_col_list: '||p_grand_total_col_list;
  end if;
  if p_master_region_source is not null then
    l_ret := l_ret ||' p_master_region_source: '||p_master_region_source;
  end if;
  if p_join_master_region is not null then
    l_ret := l_ret ||' p_join_master_region: '||p_join_master_region;
  end if;
  
  if p_master_select_list is not null then
    l_ret := l_ret ||' p_master_select_list: '||p_master_select_list;
  end if;
  
  pak_xslt_log.WriteLog( l_ret, p_procedure => p_procedure);
end;
/** Returns Max Rows parameter of IR report
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @return Max Rows parameter of IR report.
*/
function IRMaxRows(
   p_region_id            in number,
   p_page_id              in number
)
return pls_integer
as
l_ret pls_integer;
begin
  select max_row_count into l_ret
  from apex_application_page_ir
  where page_id = p_page_id
  and region_id = p_region_id;

  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IRMaxRows', p_sqlerrm => sqlerrm );
  raise;
end;

/* 0-No HTML markup, 1-HTML markup, 2-image link */
function Html_img_included(
  p_display_as          varchar2
  ,p_column_link_text   varchar2
  ,p_format_mask        varchar2
)
return number
as
begin
  if p_format_mask like 'IMAGE%' then
    return 2;
  end if;
  if p_display_as in ('WITHOUT_MODIFICATION', 'NATIVE_HTML_EXPRESSION') then
    if p_column_link_text like '%<img %' or p_format_mask like 'IMAGE%' then
      return 2;
    else
      return 1;
    end if;
  end if;
  return 0;
end Html_img_included;

/** Returns Array of columns in as they appear in IR report (order and quantity) with using filters where IR is not in GROUP BY mode.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_report_id current report ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @param p_current_report_columns Visible IR columns separated with :.
* @return Array of columns in as they appear in report (order and quantity) with hidden and PK columns at the start if p_hidPK is true.
*/
function CollectIRColumnsReport(
   p_region_id            in number,
   p_page_id              in number,
   p_report_id            in number,
   p_use_filters_hidPK    in number,
   p_current_report_columns  in varchar2 default null
)
return tp_cols
as
t_cols tp_cols;
l_report_id number;
begin
  pak_xslt_log.WriteLog( 'Start p_report_id '||p_report_id||' p_region_id '||p_region_id||
                        ' p_use_filters_hidPK '||p_use_filters_hidPK||
                        ' p_current_report_columns '||p_current_report_columns,
                        p_procedure => 'CollectIRColumnsReport');

  if p_use_filters_hidPK = 0 then
    select report_label
           , column_alias
           , null as master_alias
           , column_fullname
           , column_type
           , format_mask
           , PRINT_COLUMN_WIDTH
           , display_order
           , null sum_total
           , null query_id
           , Html_img_included(display_text_as, column_linktext, format_mask) html_img_included
           , GetLOVSelect(application_id, column_alias, named_LOV, null) LOV_SQL
           , null as aggregation
           , null as item_type
    bulk collect into t_cols
    from
    (
      select PrepareColumnHeader(report_label) report_label--ordinary columns
           , RemoveLineBreak(report_label) column_fullname
           , column_alias
           , null as master_alias
           , case when col.named_LOV is not null then 'VARCHAR2' else col.column_type end column_type
           , format_mask
           , null as PRINT_COLUMN_WIDTH
           , display_order
           , display_text_as
           , column_linktext
           , named_LOV
           , application_id
        from apex_application_page_ir_col col
        where region_id = p_region_id
        and   upper(col.column_alias) <> 'ROWID'

        $IF CCOMPILING.g_views_granted $THEN
        union

        select --computed columns
        PrepareColumnHeader(comp.computation_report_label) report_label,
        RemoveLineBreak(comp.computation_report_label) column_fullname,
        comp.computation_column_alias column_alias,
        null as master_alias,
        comp.computation_column_type column_type,
        comp.computation_format_mask format_mask,
        null as print_column_width,
        999 display_order,
        null display_text_as,
        null column_link_test,
         null named_LOV,
         comp.application_id
         from apex_application_page_regions apr
         join apex_application_page_ir ir on apr.region_id = ir.region_id
         join apex_application_page_ir_rpt rpt on rpt.interactive_report_id = ir.interactive_report_id
         join apex_application_page_ir_comp comp on comp.report_id = rpt.report_id
         where apr.region_id = p_region_id
         and rpt.report_id = p_report_id
         order by display_order, column_alias
         $END
     );
  elsif p_current_report_columns is not null then
    if  p_use_filters_hidPK = 1 then
      select report_label
           , column_fullname
           , column_alias
           , null as master_alias
           , column_type
           , format_mask
           , PRINT_COLUMN_WIDTH
           , so display_sequence
           , null sum_total
           , null query_id
           , Html_img_included(display_text_as, column_linktext, format_mask) html_img_included
           , GetLOVSelect(application_id, column_alias, named_LOV, null) LOV_SQL
           , null as aggregation
           , null as item_type
      bulk collect into t_cols
      from
      (
        select PrepareColumnHeader(col.report_label) report_label
             , RemoveLineBreak(col.report_label) column_fullname
             , col.column_alias
             , case when col.named_LOV is not null then 'VARCHAR2' else col.column_type end column_type
             , col.format_mask
             , null as PRINT_COLUMN_WIDTH
             , 0 so
             , col.display_text_as
             , col.column_linktext
             , col.named_LOV
             , col.application_id
        from apex_application_page_ir_col col
        where col.application_id = APEX_APPLICATION.G_FLOW_ID
        and   col.page_id = p_page_id
        and   col.region_id = p_region_id
        --and   p_use_filters_hidPK = 1
        and   col.display_text_as = 'HIDDEN' --('HIDDEN', 'WITHOUT_MODIFICATION')
        and   upper(col.column_alias) <> 'ROWID'
        and   (col.report_label , col.column_alias , col.format_mask) not in
        --this protect us from getting the same column twice once with display_sequence 0 and second with display_sequence greater than 0
        (
           select col.report_label --ordinary columns
               , col.column_alias
               --, col.column_type
               , col.format_mask
          from apex_application_page_ir_col col
             , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                      , level so
                 from ( select p_current_report_columns cols
                             , ':' sep from dual )
                 connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
               ) fil --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
          where col.application_id = APEX_APPLICATION.G_FLOW_ID
          and   col.page_id = p_page_id
          and   col.region_id = p_region_id
          and   col.column_alias = fil.col

          $IF CCOMPILING.g_views_granted $THEN
          union

          select  --computed columns
          PrepareColumnHeader(comp.computation_report_label) report_label,
          RemoveLineBreak(comp.computation_column_alias) column_alias,
          --comp.computation_column_type  column_type,
          comp.computation_format_mask  format_mask--,
          --fil.so
          from apex_application_page_regions apr
          , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                  , level so
             from ( select p_current_report_columns cols
                         , ':' sep from dual )
             connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
           ) fil, --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
          apex_application_page_ir ir,
          apex_application_page_ir_rpt rpt,
          apex_application_page_ir_comp comp
          where apr.region_id = p_region_id
          and apr.region_id = ir.region_id
          and rpt.interactive_report_id = ir.interactive_report_id
          and rpt.report_id = p_report_id
          and comp.computation_column_alias = fil.col
          and comp.report_id = rpt.report_id
          $END
        ) --end of not in

        union

        select PrepareColumnHeader(col.report_label) report_label --ordinary columns
             , RemoveLineBreak(col.report_label) column_fullname
             , col.column_alias
             , col.column_type
             , col.format_mask
             , NULL AS PRINT_COLUMN_WIDTH
             , fil.so
             , col.display_text_as
             , col.column_linktext
             , col.named_LOV
             , col.application_id
        from apex_application_page_ir_col col
           , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                    , level so
               from ( select p_current_report_columns cols
                           , ':' sep from dual )
               connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
             ) fil --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
        where col.application_id = APEX_APPLICATION.G_FLOW_ID
        and   col.page_id = p_page_id
        and   col.region_id = p_region_id
        and   col.column_alias = fil.col
        and   upper(col.column_alias) <> 'ROWID'

        $IF CCOMPILING.g_views_granted $THEN
        union

        select --computed columns
        PrepareColumnHeader(comp.computation_report_label) report_label,
        RemoveLineBreak(comp.computation_report_label) column_fullname,
        comp.computation_column_alias column_alias,
        comp.computation_column_type  column_type,
        comp.computation_format_mask format_mask,
        null as_print_column_width,
        fil.so,
        null display_text_as,
        null column_linktext,
        null named_LOV,
        comp.application_id
        from apex_application_page_regions apr
        , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                , level so
           from ( select p_current_report_columns cols
                       , ':' sep from dual )
           connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
         ) fil, --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
        apex_application_page_ir ir,
        apex_application_page_ir_rpt rpt,
        apex_application_page_ir_comp comp
        where apr.region_id = p_region_id
        and apr.region_id = ir.region_id
        and rpt.interactive_report_id = ir.interactive_report_id
        and rpt.report_id = p_report_id
        and comp.computation_column_alias = fil.col
        and comp.report_id = rpt.report_id
        $END
      )
      order by so;
    elsif  p_use_filters_hidPK = 2 then
      select report_label
           , fullname
           , column_alias
           , null as master_alias
           , column_type
           , format_mask
           , PRINT_COLUMN_WIDTH
           , so display_sequence
           , null sum_total
           , null query_id
           , Html_img_included(display_text_as, column_linktext, format_mask) html_img_included
           , GetLOVSelect(application_id, column_alias, named_LOV, null) LOV_SQL
           , null as aggregation
           , null as item_type
      bulk collect into t_cols
      from
      (
        select PrepareColumnHeader(col.report_label) report_label --ordinary columns
             , RemoveLineBreak(col.report_label) fullname
             , col.column_alias
             , case when col.named_LOV is not null then 'VARCHAR2' else col.column_type end column_type
             , col.format_mask
             , null as PRINT_COLUMN_WIDTH
             , fil.so
             , col.display_text_as
             , col.column_linktext
             , col.named_LOV
             , col.application_id
        from apex_application_page_ir_col col
           , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                    , level so
               from ( select p_current_report_columns cols
                           , ':' sep from dual )
               connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
             ) fil --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
        where col.application_id = APEX_APPLICATION.G_FLOW_ID
        and   col.page_id = p_page_id
        and   col.region_id = p_region_id
        and   col.column_alias = fil.col
        and   col.display_text_as <> 'HIDDEN' --not in ('HIDDEN', 'WITHOUT_MODIFICATION')
        and   upper(col.column_alias) <> 'ROWID'

        $IF CCOMPILING.g_views_granted $THEN
        union

        select --computed columns
        PrepareColumnHeader(comp.computation_report_label) report_label,
        RemoveLineBreak(comp.computation_report_label) fullname,
        comp.computation_column_alias column_alias,
        comp.computation_column_type column_type,
        comp.computation_format_mask format_mask,
        null as print_column_width,
        fil.so,
        null display_text_as,
        null column_link_text,
        null named_LOV,
        comp.application_id
        from apex_application_page_regions apr
        , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                , level so
           from ( select p_current_report_columns cols
                       , ':' sep from dual )
           connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
         ) fil, --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
        apex_application_page_ir ir,
        apex_application_page_ir_rpt rpt,
        apex_application_page_ir_comp comp
        where apr.region_id = p_region_id
        and apr.region_id = ir.region_id
        and rpt.interactive_report_id = ir.interactive_report_id
        and rpt.report_id = p_report_id
        and comp.computation_column_alias = fil.col
        and comp.report_id = rpt.report_id
        $END
      )
      order by so;
    end if;
  end if;

  return t_cols;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'CollectIRColumnsReport', p_sqlerrm => sqlerrm );
  raise;
end CollectIRColumnsReport;

/**Returns column label for IR in group by mode. Tipically this function is called only if label is not defined by user
*
* @param p_aggr_function Aggregation function
* @param p_function_column Column alias of column for aggregate
* @return column label for IR in group by mode
*/
function GroupByLabel(
  p_region_id         number,
  p_page_id           number,
  p_report_id         number,
  p_aggr_function     varchar2,
  p_function_column   varchar2
)
return varchar2
as
l_label varchar2(200);
begin
  pak_xslt_log.WriteLog( 'Start p_page_id '||p_page_id||' p_region_id '||p_region_id||
                        ' p_function_column '||p_function_column,
                        p_procedure => 'GroupByLabel');

  select label into l_label from
  (
    select nvl(report_label, column_alias) label
    from apex_application_page_ir_col
    where page_id = p_page_id
    and region_id = p_region_id
    and column_alias = p_function_column

    $IF CCOMPILING.g_views_granted $THEN
    union
    select comp.computation_column_alias label --computed cols can be part of group by or aggregation group by
    from apex_application_page_regions apr
    join apex_application_page_ir ir on apr.region_id = ir.region_id
    join apex_application_page_ir_rpt rpt on rpt.interactive_report_id = ir.interactive_report_id
    join apex_application_page_ir_comp comp on comp.report_id = rpt.report_id
    where apr.region_id = p_region_id
    and rpt.report_id = p_report_id
    and comp.computation_column_alias = p_function_column
    $END
  );

  l_label :=
  case p_aggr_function
    when 'AVG' then 'Average'
    when 'MAX' then 'Maximum'
    when 'MIN' then 'Minimum'
    when 'RATIO_TO_REPORT_SUM' then 'Percent of Total Sum'
    when 'RATIO_TO_REPORT_COUNT' then 'Percent of Total Count'
    else initcap(lower(p_aggr_function))
  end ||' '|| l_label;

  return l_label;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'GroupByLabel', p_sqlerrm => sqlerrm );
  raise;
end;

function GetGroupByView(
  p_report_id  in  apex_application_page_ir_rpt.report_id%type,
  po_grpby_row out apex_application_page_ir_grpby%rowtype
)
return boolean
as
  l_ret boolean default false;

  cursor c_cur is
  select * from apex_application_page_ir_grpby
  where report_id = p_report_id;

begin
  open c_cur;
  fetch c_cur into po_grpby_row;
  l_ret := c_cur%found;
  close c_cur;
  if l_ret then
    pak_xslt_log.WriteLog( 'Group by mode : '||to_char(p_report_id), p_procedure => 'GetGroupByView');
  else
    pak_xslt_log.WriteLog( 'Report mode', p_procedure => 'GetGroupByView');
  end if;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'GetGroupByView', p_sqlerrm => sqlerrm );
  raise;
end GetGroupByView;



/** Returns Array of columns in as they appear in IR report (order and quantity) when IR is in GROUP BY mode.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_rpt_row row of current report.
* @param po_grpbyAttr Region arguments grpby_colX
* @return Array of columns in as they appear in IR report (order and quantity) when IR is in GROUP BY mode.
*/
function CollectIRColumnsGroupBy(
   p_region_id            in number,
   p_page_id              in number,
   p_rpt_row              apex_application_page_ir_rpt%rowtype,
   po_grpbyAttr          out varchar2
)
return tp_cols
as
t_cols tp_cols;
t_col tp_col;
l_grpby_row apex_application_page_ir_grpby%rowtype;
begin
    select report_label --ordinary columns
         , fullname
         , column_alias
         , null as master_alias
         , column_type
         , format_mask
         , PRINT_COLUMN_WIDTH
         , so
         , null sum_total
         , null query_id
         , Html_img_included(display_text_as, column_linktext, format_mask) html_img_included
         , GetLOVSelect(application_id, column_alias, named_LOV, null) LOV_SQL
         , null as aggregation
         , null as item_type
         bulk collect into t_cols
    from
    (
      select PrepareColumnHeader(col.report_label) report_label --ordinary columns
           , RemoveLineBreak(col.report_label) fullname
           , col.column_alias
           , case when col.named_LOV is not null then 'VARCHAR2' else col.column_type end column_type
           , col.format_mask
           , null as PRINT_COLUMN_WIDTH
           , fil.so
           , col.display_text_as
           , col.column_linktext
           , col.named_LOV
           , col.application_id
      from apex_application_page_ir_col col
         , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
                  , level so
             from ( select group_by_columns cols, ':' sep from apex_application_page_ir_grpby cols
                    where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = p_page_id and report_id = p_rpt_row.report_id
                  )
             connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
           ) fil --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
      where col.application_id = APEX_APPLICATION.G_FLOW_ID
      and   col.page_id = p_page_id
      and   col.region_id = p_region_id
      and   col.column_alias = fil.col

      $IF CCOMPILING.g_views_granted $THEN
      union

      select --computed columns
      PrepareColumnHeader(comp.computation_report_label) report_label,
      RemoveLineBreak(comp.computation_report_label) fullname,
      comp.computation_column_alias column_alias,
      comp.computation_column_type column_type,
      comp.computation_format_mask format_mask,
      null as PRINT_COLUMN_WIDTH,
      fil.so,
      null display_text_as,
      null column_link_text,
      null named_LOV,
      comp.application_id
      from apex_application_page_regions apr
      , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
              , level so
         from ( select group_by_columns cols, ':' sep from apex_application_page_ir_grpby cols
                    where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = p_page_id and report_id = p_rpt_row.report_id )
         connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
       ) fil, --Upper select converts columns in p_current_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
      apex_application_page_ir ir,
      apex_application_page_ir_rpt rpt,
      apex_application_page_ir_comp comp
      where apr.region_id = p_region_id
      and apr.region_id = ir.region_id
      and rpt.interactive_report_id = ir.interactive_report_id
      and rpt.report_id = p_rpt_row.report_id
      and comp.computation_column_alias = fil.col
      and comp.report_id = rpt.report_id
      $END
    )
    order by so;

    --prepare Region attributes
    for i in 1..t_cols.count loop
      po_grpbyAttr := po_grpbyAttr||' grpby_col'||to_char(i)||'="'||Query2Report.ConvertColName2XmlName(t_cols(i).label)||'"';
    end loop;

    select * into l_grpby_row
    from apex_application_page_ir_grpby cols
    where application_id = APEX_APPLICATION.G_FLOW_ID
    and page_id = p_page_id
    and report_id = p_rpt_row.report_id;

    if l_grpby_row.function_01 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_01, l_grpby_row.function_column_01)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_01, l_grpby_row.function_column_01));
      t_col.fullname := RemoveLineBreak(t_col.fullname); 
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_01;
      t_col.format_mask := l_grpby_row.function_format_mask_01;
      t_col.display_sequence := 991;
      t_col.sum_total := l_grpby_row.function_sum_01;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;

     if l_grpby_row.function_02 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_02,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_02, l_grpby_row.function_column_02)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_02, l_grpby_row.function_column_02));
      t_col.fullname := RemoveLineBreak(t_col.fullname);
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_02;
      t_col.format_mask := l_grpby_row.function_format_mask_02;
      t_col.display_sequence := 992;
      t_col.sum_total := l_grpby_row.function_sum_02;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;

    if l_grpby_row.function_03 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_03,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_03, l_grpby_row.function_column_03)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_03, l_grpby_row.function_column_03));
      t_col.fullname := RemoveLineBreak(t_col.fullname);
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_03;
      t_col.format_mask := l_grpby_row.function_format_mask_03;
      t_col.display_sequence := 993;
      t_col.sum_total := l_grpby_row.function_sum_03;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;

    if l_grpby_row.function_04 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_04,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_04, l_grpby_row.function_column_04)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_04, l_grpby_row.function_column_04));
      t_col.fullname := RemoveLineBreak(t_col.fullname);
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_04;
      t_col.format_mask := l_grpby_row.function_format_mask_04;
      t_col.display_sequence := 994;
      t_col.sum_total := l_grpby_row.function_sum_04;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;

    if l_grpby_row.function_05 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_05,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_05, l_grpby_row.function_column_05)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_05, l_grpby_row.function_column_05));
      t_col.fullname := RemoveLineBreak(t_col.fullname);
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_05;
      t_col.format_mask := l_grpby_row.function_format_mask_05;
      t_col.display_sequence := 995;
      t_col.sum_total := l_grpby_row.function_sum_05;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;

    if l_grpby_row.function_06 is not null then
      t_col.label := PrepareColumnHeader(nvl(l_grpby_row.function_label_06,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_06, l_grpby_row.function_column_06)));
      t_col.fullname := nvl(l_grpby_row.function_label_01,
        GroupByLabel(p_region_id, p_page_id, p_rpt_row.report_id, l_grpby_row.function_06, l_grpby_row.function_column_06));
      t_col.fullname := RemoveLineBreak(t_col.fullname);
      t_col.col_type := 'NUMBER';
      t_col.alias := l_grpby_row.function_db_column_name_06;
      t_col.format_mask := l_grpby_row.function_format_mask_06;
      t_col.display_sequence := 996;
      t_col.sum_total := l_grpby_row.function_sum_06;
      t_cols.extend;
      t_cols(t_cols.count) := t_col;
    end if;
return t_cols;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'CollectIRColumnsGroupBy', p_sqlerrm => sqlerrm );
  raise;
end CollectIRColumnsGroupBy;

/** Returns Array of columns in as they appear in IR report (order and quantity) with using filters.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @param p_current_report_columns Visible IR columns separated with :.
* @param po_grpby_arg Region attributes grpby_colX.
* @return Array of columns in as they appear in report (order and quantity) with hidden and PK columns at the start if p_hidPK is true.
*/
function CollectIRColumns(
   p_region_id            in number,
   p_page_id              in number,
   p_use_filters_hidPK    in number,
   p_current_report_columns  in varchar2 default null,
   po_IR_Attr             out varchar2,
   po_grpby_arg           out varchar2
)
return tp_cols
as
l_rpt_row apex_application_page_ir_rpt%rowtype;
begin
  po_grpby_arg := null;
  po_IR_Attr := null;
  l_rpt_row := Get_current_report_row(p_region_id, p_page_id);
  if l_rpt_row.report_name is not null then
    po_IR_Attr := 'IR_name="'||l_rpt_row.report_name||'"';
  end if;
  if l_rpt_row.report_description is not null then
    po_IR_Attr := po_IR_Attr||' IR_description="'||l_rpt_row.report_description||'"';
  end if;

  pak_xslt_log.WriteLog( 'po_IR_Attr: '||po_IR_Attr, p_log_type => pak_xslt_log.g_information, p_procedure => 'CollectIRColumns');

  if l_rpt_row.report_view_mode = 'GROUP_BY' then
    return CollectIRColumnsGroupBy(p_region_id, p_page_id, l_rpt_row, po_grpby_arg);
  else
    return CollectIRColumnsReport(
       p_region_id,
       p_page_id,
       l_rpt_row.report_id,
       p_use_filters_hidPK,
       p_current_report_columns
    );
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'CollectIRColumns', p_sqlerrm => sqlerrm );
  raise;
end CollectIRColumns;

/** Guess column type from format mask for non IR reports.
*
* @param p_format_mask Format mask.
* @return column type STRING, NUMBER or DATE
*/
function ColumnType(
  p_format_mask varchar2
)
return varchar2
as
  function DateFormatMask(p_format_mask varchar2)
  return boolean
  as
  l_temp varchar2(200);
  begin
    l_temp := to_char(sysdate, p_format_mask);
    return true;
  exception
    when others then
    return false;
  end;

  function NumberFormatMask(p_format_mask varchar2)
  return boolean
  as
  l_temp varchar2(200);
  begin
    l_temp := to_char(12345.45, p_format_mask);
    return true;
  exception
    when others then
    return false;
  end;
begin
  if p_format_mask is null then
    return 'VARCHAR2';
  elsif NumberFormatMask(p_format_mask) then
    return 'NUMBER';
  elsif DateFormatMask(p_format_mask) then
    return 'DATE';
  else
    return 'VARCHAR2';
  end if;
end;

function  ReportTypesElementTab(p_region_id in number)
return t_coltype_table
as
l_region_source  varchar2(32000);
l_ret            t_coltype_table;
begin
  select region_source
  into l_region_source
  from apex_application_page_regions
  where region_id = p_region_id;

  return Query2Report.ReportTypesElementTab(l_region_source);
end;

/** Returns Array of columns in as they appear in report (order and quantity) for non IR reports.
*
* @param p_region_id Region ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @return Array of columns in as they appear in report (order and quantity)
*/
function CollectReportColumns(
   p_region_id in number,
   p_use_filters_hidPK number
)
return tp_cols
as
t_cols tp_cols;
l_region_source   varchar2(32000);
l_use_filters     number default 1;
l_coltypes        t_coltype_table;
begin
  pak_xslt_log.WriteLog( 'p_region_id: '||to_char(p_region_id)||
                         ' p_use_filters_hidPK: '||to_char(p_use_filters_hidPK),
                          p_procedure => 'CollectReportColumns');

  l_coltypes := ReportTypesElementTab(p_region_id);

  if p_use_filters_hidPK = 0 then
    select PrepareColumnHeader(nvl(a.heading, a.column_alias)) heading
         , RemoveLineBreak(nvl(a.heading, a.column_alias)) fullname
         , a.column_alias
         , null as master_alias
         --, ColumnType(l_report_types, a.column_alias, a.format_mask) column_type
         , case when nvl(a.format_mask, nvl(a.named_list_of_values, a.inline_list_of_values)) is not null then ColumnType(a.format_mask) else t.coltype end column_type
         , a.format_mask
         , a.PRINT_COLUMN_WIDTH
         , a.display_sequence
         , substr(a.sum_column,1,1) sum_total

         $IF CCOMPILING.g_views_granted $THEN
         , q.query_column_id query_id
         $ELSE
         , null query_id
         $END

         , Html_img_included(a.display_as_code, a.column_link_text, a.format_mask) html_img_included
         , GetLOVSelect(a.application_id, a.column_alias, a.named_list_of_values, a.inline_list_of_values) LOV_SQL
         , null as aggregation
         , null as item_type
    bulk collect into t_cols
    from apex_application_page_rpt_cols a
    join table(l_coltypes) t on a.column_alias = t.colname

    $IF CCOMPILING.g_views_granted $THEN
    join APEX_RPT_COLS_QUERY_ID q on a.region_report_column_id = q.region_report_column_id
    $END

    where a.region_id = p_region_id
    --and a.display_as_code <> 'CHECKBOX'
    and a.column_alias not like 'CHECK$__'
    and a.column_alias not like 'DERIVED$__'
    and   upper(a.column_alias) <> 'ROWID'
    order by a.display_sequence;
  elsif p_use_filters_hidPK = 2 then
    select PrepareColumnHeader(nvl(a.heading, a.column_alias)) heading
     , RemoveLineBreak(nvl(a.heading, a.column_alias)) fullname
     , a.column_alias
     , null as master_alias
     , case when nvl(a.format_mask, nvl(a.named_list_of_values, a.inline_list_of_values)) is not null then ColumnType(a.format_mask) else t.coltype end column_type
     , a.format_mask
     , a.PRINT_COLUMN_WIDTH
     , a.display_sequence
     , substr(a.sum_column,1,1) sum_total

     $IF CCOMPILING.g_views_granted $THEN
     , q.query_column_id query_id
     $ELSE
     , null query_id
     $END

     , Html_img_included(a.display_as_code, a.column_link_text, a.format_mask) html_img_included
     , GetLOVSelect(a.application_id, a.column_alias, a.named_list_of_values, a.inline_list_of_values) LOV_SQL
     , null as aggregation
     , null as item_type
    bulk collect into t_cols
    from apex_application_page_rpt_cols a
    join table(l_coltypes) t on a.column_alias = t.colname

    $IF CCOMPILING.g_views_granted $THEN
    join APEX_RPT_COLS_QUERY_ID q on a.region_report_column_id = q.region_report_column_id
    $END

    where a.region_id = p_region_id
    and   nvl( a.include_in_export, 'Yes') = 'Yes'
    and   a.COLUMN_IS_HIDDEN <>'Yes'
    --and   nvl(a.Primary_key_column_source_type, 'N') <> 'T'
    and   a.display_as_code <> 'HIDDEN' --not in ('HIDDEN', 'CHECKBOX')--,'WITHOUT_MODIFICATION')
    and   a.column_alias not like 'CHECK$__'
    and   a.column_alias not like 'DERIVED$__'
    and   upper(a.column_alias) <> 'ROWID'
    --and   nvl(a.column_link_text,' ') not like '<img %'
    order by a.display_sequence;
  elsif p_use_filters_hidPK = 1 then
    select PrepareColumnHeader(nvl(a.heading, a.column_alias)) heading
         , RemoveLineBreak(nvl(a.heading, a.column_alias)) fullname
         , a.column_alias
         , null as master_alias
         , case when nvl(a.format_mask, nvl(a.named_list_of_values, a.inline_list_of_values)) is not null then ColumnType(a.format_mask) else t.coltype end column_type
         , a.format_mask
         , a.PRINT_COLUMN_WIDTH
         , a.display_sequence
         , substr(a.sum_column,1,1) sum_total

         $IF CCOMPILING.g_views_granted $THEN
         , q.query_column_id query_id
         $ELSE
         , null query_id
         $END

         , Html_img_included(a.display_as_code, a.column_link_text, a.format_mask) html_img_included
         , GetLOVSelect(a.application_id, a.column_alias, a.named_list_of_values, a.inline_list_of_values) LOV_SQL
         , null as aggregation
         , null as item_type
    bulk collect into t_cols
    from apex_application_page_rpt_cols a
    join table(l_coltypes) t on a.column_alias = t.colname

    $IF CCOMPILING.g_views_granted $THEN
    join APEX_RPT_COLS_QUERY_ID q on a.region_report_column_id = q.region_report_column_id
    $END

    where a.region_id = p_region_id
    and   nvl( a.include_in_export, 'Yes') = 'Yes'
    and   a.column_alias not like 'CHECK$__'
    and   a.column_alias not like 'DERIVED$__'
    and   upper(a.column_alias) <> 'ROWID'
    --and a.display_as_code <> 'CHECKBOX'
    --and nvl(a.column_link_text,' ') not like '<img %'
    order by a.display_sequence;
  end if;
  return t_cols;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'CollectReportColumns', p_sqlerrm => sqlerrm );
  raise;
end CollectReportColumns;


/**Binds one or two letter computed column expression variables with real column names
* e.g. substr(AA,1,200) change to substr(message,1,200) where AA is variable and message is column name
*
* @param p_comp_expr computed column expression with one or two letter variables
* @param t_cols hash table of real column names. Index is one or two letter variable
* @return computed column expression with real column names
*/
function BindExpression(
  p_comp_expr varchar2,
  t_cols tp_idcols
) return varchar2
as
l_ret varchar2(1000);
t_colstrids tp_strtbl := tp_strtbl();
l_colstrid varchar2(20);
begin
  l_ret := p_comp_expr;
  pak_xslt_log.WriteLog( 'p_comp_expr '||p_comp_expr,
   p_procedure => 'BindExpression');
  for i in 1..length(p_comp_expr) loop
    if substr(p_comp_expr,i,1) between 'A' and 'Z' then
      l_colstrid := l_colstrid || substr(p_comp_expr,i,1);
      --pak_xslt_log.WriteLog( 'l_colstrid '||l_colstrid,
      --p_procedure => 'BindExpression');
    else
      if length(l_colstrid) in (1,2) and t_cols.exists(l_colstrid) then --TODO if exists
        --Add to table
        t_colstrids.extend;
        t_colstrids(t_colstrids.count) := l_colstrid;
        pak_xslt_log.WriteLog( 'Added to table at '|| t_colstrids.count||' l_colstrid '||l_colstrid,
        p_procedure => 'BindExpression');
      end if;
      l_colstrid := '';
    end if;
  end loop;
  --We put all but last column identifiers in t_colstrids now

  pak_xslt_log.WriteLog( 'end loop p_comp_expr l_colstrid '||l_colstrid,
    p_procedure => 'BindExpression');

  if length(l_colstrid) in (1,2) then
    --Add to table
    t_colstrids.extend;
    t_colstrids(t_colstrids.count) := l_colstrid;
    pak_xslt_log.WriteLog( 'Added to table at '|| t_colstrids.count||' l_colstrid '||l_colstrid,
    p_procedure => 'BindExpression');
  end if;

  --We put last column identifier in t_colstrids now

  for i in 1..t_colstrids.count loop
    --l_ret := replace(l_ret, t_colstrids(i), t_cols(t_colstrids(i)));'(^|\W)O(\W|$)'  '(^|\W)(O)(\W|$)', '\1yeba\3'
    pak_xslt_log.WriteLog( 'Before regexp_replace i '||i|| ' t_cols(t_colstrids(i)) '||t_cols(t_colstrids(i))||
                          ' t_colstrids(i) '||t_colstrids(i),
                            p_procedure => 'BindExpression');

    l_ret := regexp_replace(l_ret, '(^|\W)('||t_colstrids(i)||')(\W|$)', '\1'||t_cols(t_colstrids(i))||'\3');
    --regexp_replace(r_apr.region_source, ':([a-zA-Z0-9_]*)','v(''\1'')'); --bind session state values
    pak_xslt_log.WriteLog( 'After regexp_replace l_ret '||l_ret, p_procedure => 'BindExpression');
  end loop;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BindExpression', p_sqlerrm => sqlerrm );
  raise;
end BindExpression;

/**Binds (compose) condition for use in where sentence
*
* @param p_condition_sql SQL condition in apex dictionary view apex_application_page_ir_cond format
* @param p_condition_expression first condition expression in apex dictionary view apex_application_page_ir_cond format
* @param p_condition_expression2 second condition expression in apex dictionary view apex_application_page_ir_cond format
* @return complete part of where sentence
*/
function BindCondition(
  p_condition_sql varchar2,
  p_condition_expression varchar2,
  p_condition_expression2 varchar2
)
return varchar2
as
  t_val_ind pls_integer;
  t_start pls_integer;
  t_end pls_integer;
  t_val varchar2(32767);
  l_condition_sql varchar2(32767);

begin
  l_condition_sql := p_condition_sql;
  if instr( l_condition_sql, '#APXWS_EXPR#' ) > 0 --#APXWS_CC_EXPR#
  then
    l_condition_sql := replace( l_condition_sql, '#APXWS_EXPR#', '''' || replace( p_condition_expression, '''', '''''' ) || '''' );
  end if;
  if instr( l_condition_sql, '#APXWS_EXPR2#' ) > 0
  then
    l_condition_sql := replace( l_condition_sql, '#APXWS_EXPR2#', '''' || replace( p_condition_expression2, '''', '''''' ) || '''' );
  end if;
  --
  t_start := 1;
  t_val_ind := 1;
  while instr( l_condition_sql, '#APXWS_EXPR_VAL' || t_val_ind || '#' ) > 0
  loop
    t_end := instr( p_condition_expression || ',', ',', t_start );
    t_val := trim( substr( p_condition_expression, t_start, t_end - t_start ) );
    if t_val is null
    then
      l_condition_sql := replace( l_condition_sql, ', #APXWS_EXPR_VAL' || t_val_ind || '#' );
      l_condition_sql := replace( l_condition_sql, '#APXWS_EXPR_VAL' || t_val_ind || '# ,' );
    else
      l_condition_sql := replace( l_condition_sql, '#APXWS_EXPR_VAL' || t_val_ind || '#', '''' || replace( t_val, '''', '''''' ) || '''' );
    end if;
    t_val_ind := t_val_ind + 1;
    t_start := t_end + 1;
  end loop;
  return l_condition_sql;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BindCondition', p_sqlerrm => sqlerrm );
  raise;
end BindCondition;



/**Binds (compose) case sentence to get higlighted rows in source select
*
* @param p_condition_sql SQL condition in apex dictionary view apex_application_page_ir_cond format
* @param p_condition_expression first condition expression in apex dictionary view apex_application_page_ir_cond format
* @param p_condition_expression2 second condition expression in apex dictionary view apex_application_page_ir_cond format
* @param p_condition_name second condition name like appears in apex dictionary view apex_application_page_ir_cond
* @param p_highlight_cell_color highlight cell color in apex dictionary view apex_application_page_ir_cond format
* @param p_highlight_cell_font_color highlight cell font color in apex dictionary view apex_application_page_ir_cond format
* @param p_highlight_row_color highlight row color in apex dictionary view apex_application_page_ir_cond format
* @param p_highlight_row_font_color highlight row font color in apex dictionary view apex_application_page_ir_cond format
* @param p_col_label column label
* @return complete case sentence to get higlighted rows in source select
*/
function GetHighlightCase(
  p_condition_sql varchar2,
  p_condition_expression varchar2,
  p_condition_expression2 varchar2,
  p_condition_name varchar2,
  p_highlight_cell_color varchar2,
  p_highlight_cell_font_color varchar2,
  p_highlight_row_color varchar2,
  p_highlight_row_font_color varchar2,
  p_col_label varchar2
)
return varchar2
as
begin
  return
  replace(apexrep2report.BindCondition(p_condition_sql, p_condition_expression, p_condition_expression2), '#APXWS_HL_ID#',
  '''highlight_name="'||p_condition_name||'" '||
  'highlight_col="'||Query2Report.ConvertColName2XmlName(p_col_label)||'" '||
  'highlight_cell="'||
  case when nvl(p_highlight_cell_color, p_highlight_cell_font_color)  is not null then 'true' else 'false' end||'" '||
  'highlight_bkg_color="'||nvl(p_highlight_row_color, p_highlight_cell_color)||'" '||
  'highlight_font_color="'||nvl(p_highlight_row_font_color, p_highlight_cell_font_color)||'"''');
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'GetHighlightCase', p_sqlerrm => sqlerrm );
  raise;
end GetHighlightCase;

/** Procedure adds Computed columns and highlights column at region source (IR)
*
* @param p_region_id Region ID of IR
* @param p_page_id Page ID of IR
* @param pio_region_source Region source of IR
*/

$IF CCOMPILING.g_views_granted $THEN
function AddComputedColumns(
    p_page_id number,
    p_region_id number
)
return varchar2
as
l_report_id number;
l_cc_cols_list varchar2(32767);
l_highlight_case varchar2(4000);
t_cols tp_idcols;

cursor c_cols is
  select c.column_alias
        , c.display_order
        , cid.column_identifier
    from apex_application_page_ir_col c
    join apex_application_page_ir_colid cid on c.column_id = cid.column_id
    where c.region_id = p_region_id;

cursor c_comps(c_report_id number) is
 select
    comp.computation_column_alias column_alias,
    comp.COMPUTATION_EXPRESSION comp_expr
   from apex_application_page_regions apr
   join apex_application_page_ir ir on apr.region_id = ir.region_id
   join apex_application_page_ir_rpt rpt on rpt.interactive_report_id = ir.interactive_report_id
   join apex_application_page_ir_comp comp on comp.report_id = rpt.report_id
   where apr.region_id = p_region_id
   and rpt.report_id = c_report_id
   order by column_alias;

begin
  for r_cols in c_cols loop
    t_cols(r_cols.column_identifier) := r_cols.column_alias;
  end loop;

  l_report_id := Get_current_report_row(p_region_id, p_page_id).report_id;
  for r_comp in c_comps(l_report_id) loop
    l_cc_cols_list := l_cc_cols_list||', '||BindExpression(r_comp.comp_expr, t_cols)||
                      ' "'||r_comp.column_alias||'"';

  end loop;

  pak_xslt_log.WriteLog( ' p_region_id '||p_region_id|| ' l_cc_cols_list: '||l_cc_cols_list,
                          p_procedure => 'AddComputedColumns'
                        );

  --we added computed cols expressions after first select
  /*
  l_insert_point := instr(lower(pio_region_source), ' from ');
  pio_region_source := substr(pio_region_source, 1, l_insert_point)||' '||
                       l_cc_cols_list||' '||substr(pio_region_source, l_insert_point + 1);
   */
   return l_cc_cols_list;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_page_id '||p_page_id||' p_region_id '||p_region_id,
                          p_log_type => pak_xslt_log.g_error,
                          p_procedure => 'AddComputedColumns',
                          p_sqlerrm => sqlerrm
                        );
  raise;
end;
$END
/**Split separated cols used in apex_application_page_ir_* views. Also exclude 0 (used in apex_application_page_ir_rpt.break_enabled_on)
*
* @param str String with ':' separated columns
* @return string array table of columns
*/
function split_cols(str in varchar2)
return tp_strtbl
AS
return_value         tp_strtbl := tp_strtbl();
split_str            VARCHAR2(4000) default str || ':';
i                    number;
l_break_col          varchar2(30);
begin
loop
i := instr(split_str, ':');
exit when nvl(i,0) = 0;
l_break_col := trim(substr(split_str, 1, i-1));
if l_break_col <>'0' then
  return_value.extend;
  return_value(return_value.count) := trim(substr(split_str, 1, i-1));
END IF;
split_str := substr(split_str, i + length(':'));
end loop;
return return_value;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'split_cols', p_sqlerrm => sqlerrm );
  raise;
end split_cols;

/** Bind (compose) sort statement for use in ORDER BY statement in IR suorce in ordinary (non GOUP BY) mode
*
* @param p_apr row of current report in apex_application_page_ir_rpt view
* @param p_already_order_by true if ORDER BY already exists
*/
function BindSort(
  p_apr apex_application_page_ir_rpt%rowtype
)
return varchar2
as
l_sort varchar2(4000);
begin
--add sorting in source
  if nvl(p_apr.sort_column_1, '0') <> '0'
  then
    l_sort := ' "' || p_apr.sort_column_1 || '" ' || p_apr.sort_direction_1;
    if nvl(p_apr.sort_column_2, '0') <> '0'
    then
      l_sort := l_sort || ', "' || p_apr.sort_column_2 || '" ' || p_apr.sort_direction_2;
    end if;
    if nvl(p_apr.sort_column_3, '0') <> '0'
    then
      l_sort := l_sort || ', "' || p_apr.sort_column_3 || '" ' || p_apr.sort_direction_3;
    end if;
    if nvl(p_apr.sort_column_4, '0') <> '0'
    then
      l_sort := l_sort || ', "' || p_apr.sort_column_4 || '" ' || p_apr.sort_direction_4;
    end if;
    if nvl(p_apr.sort_column_5, '0') <> '0'
    then
      l_sort := l_sort || ', "' || p_apr.sort_column_5 || '" ' || p_apr.sort_direction_5;
    end if;
    if nvl(p_apr.sort_column_6, '0') <> '0'
    then
      l_sort := l_sort || ', "' || p_apr.sort_column_6 || '" ' || p_apr.sort_direction_6;
    end if;
  end if;
  pak_xslt_log.WriteLog( 'return '||l_sort, p_procedure => 'BindSort' );
  return l_sort;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BindSort', p_sqlerrm => sqlerrm );
  raise;
end;

/** Bind (compose) sort statement for use in ORDER BY statement in IR suorce in GROUP BY mode
*
* @param p_apr row of current report in apex_application_page_ir_rpt view
* @param p_already_order_by true if ORDER BY already exists
*/
function BindSort(
  p_apr apex_application_page_ir_grpby%rowtype,
  p_simple_col_list varchar2 --group by columns separated with :
)
return varchar2
as
l_sort varchar2(4000);
begin
--add sorting in source
  if nvl(p_apr.sort_column_01, '0') <> '0' and regexp_instr(p_simple_col_list,'(:|^)'||p_apr.sort_column_01||'(:|$)') > 0
  then
    l_sort := ' ' || p_apr.sort_column_01 || ' ' || p_apr.sort_direction_01;

    if nvl(p_apr.sort_column_02, '0') <> '0' and regexp_instr(p_simple_col_list,'(:|^)'||p_apr.sort_column_02||'(:|$)') > 0
    then
      l_sort := l_sort || ', ' || p_apr.sort_column_02 || ' ' || p_apr.sort_direction_02;
    end if;
    if nvl(p_apr.sort_column_03, '0') <> '0' and regexp_instr(p_simple_col_list,'(:|^)'||p_apr.sort_column_03||'(:|$)') > 0
    then
      l_sort := l_sort || ', ' || p_apr.sort_column_03 || ' ' || p_apr.sort_direction_03;
    end if;
    if nvl(p_apr.sort_column_04, '0') <> '0' and regexp_instr(p_simple_col_list,'(:|^)'||p_apr.sort_column_04||'(:|$)') > 0
    then
      l_sort := l_sort || ', ' || p_apr.sort_column_04 || ' ' || p_apr.sort_direction_04;
    end if;
  end if;
  pak_xslt_log.WriteLog( 'return '||l_sort, p_procedure => 'BindSort(group_by)' );
  return l_sort;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BindSort', p_sqlerrm => sqlerrm );
  raise;
end;

/** Return Source Query of region with Interactive report and array of columns. Filters are in included in where sentence of suorce query
* 'DYNAMIC_QUERY'
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_apr row of current report in apex_application_page_ir_rpt view.
* @param pio_region_source Source query of region.
*/
procedure IRUseFilters(
    p_region_id number,
    p_page_id number,
    p_apr apex_application_page_ir_rpt%rowtype,
    po_order_by_list out varchar2,
    po_where out varchar2
)
as
  t_base_report_id number;
  t_pref varchar2(32767);
  --po_where varchar2(32767);
  t_search varchar2(32767);
  --t_break_cols tp_strtbl;

  --different report versions: primary, alternative, public versions
  --filters or searches (conditions) for this versions are in apex_application_page_ir_cond view
  cursor c_con is
  select replace(con.condition_sql, '#APXWS_CC_EXPR#',con.condition_column_name) condition_sql
        , con.condition_type
        , con.condition_expr_type
        , con.condition_expression
        , con.condition_expression2
   from apex_application_page_ir_cond con
   where con.application_id = APEX_APPLICATION.G_FLOW_ID
   and   con.page_id = p_page_id
   and   con.report_id = p_apr.report_id
   and   con.condition_enabled = 'Yes'
   and   con.condition_type in ( 'Filter', 'Search' );


   cursor c_search(c_report_columns varchar2) is
   select col.column_alias
   from apex_application_page_ir_col col
      , ( select substr( cols, instr( sep || cols, sep, 1, level ), instr( cols || sep, sep, 1, level ) - instr( sep || cols, sep, 1, level ) ) col
               , level so
         from ( select c_report_columns cols
                     , ':' sep from dual )
         connect by level <= length( cols ) - nvl( length( replace( cols, sep ) ), 0 ) + 1
        ) fil --Upper select converts columns in c_report_columns string separated with ':' to table fil of column names. Each column name has its own row.
  where col.application_id = APEX_APPLICATION.G_FLOW_ID
  and   col.page_id = p_page_id
  and   col.region_id = p_region_id
  and   col.column_alias = fil.col
  and   col.allow_filtering = 'Yes'
  and   col.column_type in ( 'VARCHAR2', 'NUMBER', 'CLOB' );

begin
  --build where sentence from Filter and Search--
  po_where := '';
  po_order_by_list := '';
  for r_con in c_con
  loop
    if (   r_con.condition_type = 'Filter'
       and r_con.condition_sql is not null
       )
    then --build where sentence from Filter--
      if r_con.condition_expr_type = 'ROW'
      then --ROW filter
        if po_where is null then
          po_where := '(' || r_con.condition_sql || ')';
        else
          po_where := po_where ||' and (' || r_con.condition_sql || ')';
        end if;
      else --column filter
        if po_where is null then
          po_where := BindCondition(r_con.condition_sql, r_con.condition_expression, r_con.condition_expression2);
        else
          po_where := po_where ||' and '|| BindCondition(r_con.condition_sql, r_con.condition_expression, r_con.condition_expression2);
        end if;
      end if;
    end if; --End of filter
--
    if r_con.condition_type = 'Search'
    then --build where sentence from Search--
      for r_sea in c_search(p_apr.report_columns)
      loop
        t_search := t_search || 'or instr( upper( "' || r_sea.column_alias || '" ), upper( ''' || replace( r_con.condition_expression, '''', '''''' ) || ''' ) ) > 0 ';
      end loop;
      if t_search is not null
      then
        if length(trim(po_where)) > 0 then
          po_where := po_where||' and ( ' || ltrim( t_search, 'or' ) || ' )';
        else
          po_where := po_where||' ( ' || ltrim( t_search, 'or' ) || ' )';
        end if;
      end if;
    end if; --End of search
  end loop;
--
  /*
  if po_where is not null
  then --add where sentence to source
    pio_region_source := 'select * from ( ' || pio_region_source || ' ) where ' ||
                           ltrim( t_where, query2report.g_crlf || 'and'  );
  end if;
  */

  po_order_by_list := BindSort(p_apr);
  /*
  pio_region_source := pio_region_source ||
            BindSort(p_apr, false);
  */

exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IRUseFilters', p_sqlerrm => sqlerrm );
  raise;
end IRUseFilters; --end of block Use of filters in select

function AggregateFunction(
  p_function varchar2,
  p_function_column varchar2 --,
  --po_ratio_group_by out boolean
)
return varchar2
as
l_function varchar2(30);
begin
  pak_xslt_log.WriteLog( 'Starting p_function '||p_function||' p_function_column '||p_function_column,
                        p_procedure => 'AggregateFunction');
  --po_ratio_group_by := false;
  if p_function like 'RATIO_TO_REPORT_%' then
    l_function := substr(p_function, instr(p_function, '_', -1) + 1);
    --po_ratio_group_by := true;
    return '100 * RATIO_TO_REPORT('||l_function||'('||p_function_column||')) OVER() ';
  elsif p_function = 'COUNT_DISTINCT' then
    return 'COUNT(DISTINCT '||p_function_column||') ';
  else
    return p_function||'('||p_function_column||') ';
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'AggregateFunction', p_sqlerrm => sqlerrm );
  raise;
end AggregateFunction;

/** Helper function of IRUseGroupBy. Extends column list and group_by for one aggregate column
*
* @param pio_column_list Column list string
* @param pio_group_by_columns Group by string
* @param p_function Aggregation function
* @param p_function_column Aggregation column alias
* @param p_function_db_column_name Apex column alias

*/
procedure IRUseGroupByFunction(
  pio_column_list         in out varchar2,
  pio_simple_column_list  in out varchar2,
--  pio_group_by_columns in out varchar2,
  p_function varchar2,
  p_function_column varchar2,
  p_function_db_column_name varchar2
)
as
--l_ratio_group_by boolean default false;

begin
  if p_function is not null then
    pio_column_list := pio_column_list || ', ' ||
    AggregateFunction(p_function, p_function_column) ||
    p_function_db_column_name;
    pio_simple_column_list := pio_simple_column_list|| ':' ||p_function_column;
    --if l_ratio_group_by then pio_group_by_columns := pio_group_by_columns||':'||p_function_column; end if;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IRUseGroupByFunction', p_sqlerrm => sqlerrm );
  raise;
end IRUseGroupByFunction;

/** Return Source Query of region with Interactive report in group by mode
*
* @param p_page_id APEX Page ID.
* @param p_apr row of current report in apex_application_page_ir_rpt view.
* @param pio_region_source Source query of region.
*/
procedure IRUseGroupBy(
    p_page_id number,
    p_apr apex_application_page_ir_rpt%rowtype,
    po_group_by_list     out varchar2,
    po_group_by_col_list  out varchar2,
    po_order_by_list      out varchar2
)
as
l_grpby apex_application_page_ir_grpby%rowtype;
l_simple_col_list varchar2(4000);

begin
  select * into l_grpby
  from apex_application_page_ir_grpby
  where  page_id=p_page_id and report_id = p_apr.report_id;
  po_group_by_col_list := replace(l_grpby.group_by_columns,':',', ');--label--, format
  l_simple_col_list := l_grpby.group_by_columns;
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_01,
        l_grpby.function_column_01,
        l_grpby.function_db_column_name_01
      );
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_02,
        l_grpby.function_column_02,
        l_grpby.function_db_column_name_02
      );
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_03,
        l_grpby.function_column_03,
        l_grpby.function_db_column_name_03
      );
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_04,
        l_grpby.function_column_04,
        l_grpby.function_db_column_name_04
      );
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_05,
        l_grpby.function_column_05,
        l_grpby.function_db_column_name_05
      );
      IRUseGroupByFunction(
        po_group_by_col_list,
        l_simple_col_list,
        l_grpby.function_06,
        l_grpby.function_column_06,
        l_grpby.function_db_column_name_06
      );

      /*
      pio_region_source := l_column_list||' from ('||pio_region_source||') '||
      ' group by '||replace(l_grpby.group_by_columns,':',', ');
      */
      po_group_by_list := replace(l_grpby.group_by_columns,':',', ');
      po_order_by_list := BindSort(l_grpby, l_simple_col_list);
      LogComposeSelectAndAttr(
        'IRUseGroupBy',
        p_group_by_list => po_group_by_list,
        p_order_by_list => po_order_by_list,
        p_group_by_col_list => po_group_by_col_list
      );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IRUseGroupBy', p_sqlerrm => sqlerrm );
  raise;
end;

/** Return Source Query of region with Interactive report and array of columns. Filters are in included in where sentence of suorce query if IR is not in GROUP BY mode
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* You want to use 1 for cross reference by hidden or PK columns inside complex XML build from multiple queries.
* @param po_basic_col_list Columns separated with :
* @param pio_region_source Source query of region.
*/
procedure IRUseFiltersOrGroupBy(
    p_region_id number,
    p_page_id number,
    p_use_filters_hidPK number, --can be 1 or 2
    po_basic_col_list out varchar2,
    po_group_by_list out varchar2,
    po_order_by_list out varchar2,
    po_where out varchar2,
    po_group_by_col_list out varchar2
)
as
t_apr apex_application_page_ir_rpt%rowtype;

begin
  po_order_by_list := null;
  t_apr := Get_current_report_row(p_region_id, p_page_id);

  if p_use_filters_hidPK > 0 then
    IRUseFilters(
      p_region_id,
      p_page_id,
      t_apr,
      po_order_by_list => po_order_by_list,
      po_where => po_where
    );
  end if;

  if t_apr.report_view_mode = 'GROUP_BY' then
    IRUseGroupBy(
        p_page_id,
        t_apr,
        po_group_by_list => po_group_by_list,
        po_group_by_col_list => po_group_by_col_list,
        po_order_by_list => po_order_by_list
    );
  else
    --po_basic_col_list := '"'||replace(t_apr.report_columns,':','":"')||'"';
    po_basic_col_list :=t_apr.report_columns;
  end if;
  LogComposeSelectAndAttr(
    'IRUseFiltersOrGroupBy',
    p_region_id,
    p_use_filters_hidPK,
    p_basic_col_list => po_basic_col_list,
    p_group_by_list => po_group_by_list,
    p_group_by_col_list => po_group_by_col_list,
    p_order_by_list => po_order_by_list,
    p_where => po_where
  );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IRUseFiltersOrGroupBy', p_sqlerrm => sqlerrm );
  raise;
end;

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
  p_break_in_grand_total in boolean default false  --TODO use of parameter in procedure
)
as
/*
l_aggr_col_list varchar2(4000);
l_basic_col_list varchar2(4000);
l_break_col_list varchar2(4000);
l_aggr_source clob;
*/
begin
  pio_basic_col_list := pio_basic_col_list||
    case when pio_break_col_list is not null then ', null BREAKROW ' else '' end||
    case when pio_aggr_col_list is not null then ', null REGION_AGGREGATES ' else '' end;

  if pio_aggr_col_list is not null then
    pio_aggr_col_list := pio_aggr_col_list||
    case when pio_break_col_list is not null then ', null BREAKROW ' else '' end||
    ', '''||p_region_aggregates||''' REGION_AGGREGATES ';
  end if;

  if pio_break_col_list is not null then
    pio_break_col_list := pio_break_col_list||', 1 BREAKROW '||
    case when pio_aggr_col_list is not null then ', null REGION_AGGREGATES ' else '' end;
  end if;

  if pio_grand_total_col_list is not null then
    pio_grand_total_col_list := pio_grand_total_col_list||', 2 BREAKROW '||
    case when pio_grand_total_col_list is not null then ', '''||p_grand_total_aggregates||''' REGION_AGGREGATES ' else '' end;
  end if;

  /*
  dbms_lob.createtemporary(l_aggr_source, false);
  writeappendAllString(l_aggr_source, l_basic_col_list|| ' from (');
  dbms_lob.append(l_aggr_source, pio_region_source);
  writeappendAllString(l_aggr_source,')');
  if p_aggr_col_list is not null then
    writeappendAllString(l_aggr_source,
                         query2report.g_crlf||
                         ' union ('
                         ||query2report.g_crlf||
                         l_aggr_col_list||' from (');
    dbms_lob.append(l_aggr_source, pio_region_source);
    writeappendAllString(l_aggr_source,') '||p_group_by||' ) ');--||p_order_by);


    end if;

    if p_break_col_list is not null then
      writeappendAllString(l_aggr_source,
                           query2report.g_crlf||
                           ' union '
                           ||query2report.g_crlf||
                           l_break_col_list||' from (');
      dbms_lob.append(l_aggr_source, pio_region_source);
      writeappendAllString(l_aggr_source,') ');--||p_order_by);


    end if;
    dbms_lob.copy(pio_region_source, l_aggr_source, dbms_lob.LOBMAXSIZE);
    dbms_lob.freetemporary(l_aggr_source);
    --pak_xslt_log.WriteLog( 'Here Iam2 ', p_procedure => 'AggregateSelectReport');
    */
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'AddAggregateColumns', p_sqlerrm => sqlerrm );
  raise;
end;


/** Function Check p_cols array for any SUM total and compose select statement.
* Used for IR in GROUP BY mode and for classic report with SUM column
*
* @param @param pio_region_source IR source select
* @param p_cols table of columns (also aggregation function is there)
*/
function SumTotalSelect(
  --pio_region_source in out nocopy clob,
  p_cols            tp_cols,
  po_basic_col_list out varchar2,
  po_aggr_col_list  out varchar2
)
return boolean
as
 l_region_aggregates varchar2(4000);
 l_aggregate boolean default false;
 l_break_col_list varchar2(4000) default null;
 l_grand_total_col_list varchar2(4000) default null;
 begin
  for i in 1..p_cols.count loop
    if i = 1 then
      if p_cols(i).sum_total = 'Y' then
        po_aggr_col_list := 'SUM("'||p_cols(i).alias||'") ';
        if p_cols(i).lov_sql is not null then
          po_aggr_col_list := 'to_char('||po_aggr_col_list||') ';
        end if;
        l_region_aggregates := l_region_aggregates || 'SUM,'||Query2Report.ConvertColName2XmlName(p_cols(i).label)||',';
        l_aggregate := true;
      else
        po_aggr_col_list := 'null "'||p_cols(i).alias||'" ';
      end if;
      po_basic_col_list := ' "'||p_cols(i).alias||'" ';
    else
      if p_cols(i).sum_total = 'Y' then
        if p_cols(i).lov_sql is not null then
          po_aggr_col_list := po_aggr_col_list||', to_char(SUM("'||p_cols(i).alias||'")) ';
        else
          po_aggr_col_list := po_aggr_col_list||', SUM("'||p_cols(i).alias||'") ';
        end if;
        l_region_aggregates := l_region_aggregates || 'SUM,'||Query2Report.ConvertColName2XmlName(p_cols(i).label)||',';
        l_aggregate := true;
      else
        po_aggr_col_list := po_aggr_col_list||',null "'||p_cols(i).alias||'"';
      end if;
      po_basic_col_list := po_basic_col_list||', "'||p_cols(i).alias||'" ';
    end if;
  end loop;

  if l_aggregate then
    AddAggregateColumns(
      pio_basic_col_list => po_basic_col_list,
      pio_aggr_col_list => po_aggr_col_list,
      pio_break_col_list => l_break_col_list, --dummy, always null
      pio_grand_total_col_list => l_grand_total_col_list, --dummy, always null
      p_region_aggregates => l_region_aggregates
    );
  else
    po_aggr_col_list := null;
  end if;

  LogComposeSelectAndAttr(
    'SumTotalSelect',
    null,
    null,
    p_basic_col_list => po_basic_col_list,
    p_aggr_col_list => po_aggr_col_list
  );

  return l_aggregate;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'SumTotalSelect', p_sqlerrm => sqlerrm );
  raise;
end;

function OrderNum2ColLabel(
  t_cols tp_cols,
  p_col_order varchar2
)
return varchar2
as
l_col_order number;
begin
  pak_xslt_log.WriteLog( 'p_col_order '||p_col_order||' t_cols: '||tp_col2string(t_cols), p_procedure => 'OrderNum2ColLabel');
  l_col_order := to_number(p_col_order);
  for i in 1..t_cols.count loop
    if t_cols(i).query_id = l_col_order then
      return t_cols(i).alias;
    end if;
  end loop;
  return p_col_order;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'OrderNum2ColLabel', p_sqlerrm => sqlerrm );
  return p_col_order;
end;


/** Procedure outputs parts of select statement for region with Standard Report (not IR)
* NOT 'DYNAMIC_QUERY' ==> 'SQL_QUERY' or 'STRUCTURED_QUERY'
*
* With region_src as (region_select)
* Select formated_labeled_col_list from
* (
*      Select basic_col_list, null REGION_AGGR from region_src
*   [Union
*      Select aggr_col_list, aggr. col. list REGION_AGGR from region_src]
* )
* Order by [aggr_order_by_list,] order_by_list;
*
* SQL in [] applied only if final SUM is applied on Standard report.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @param po_cols Array of columns as they appear in report.
* @param po_basic_col_list list of columns in select
* @param po_aggr_col_list Only SUM function is possible, columns with no aggregation have null values
* @param po_order_by_list order by part of select statement
*/
procedure NotDynamicQuery(
    p_region_id number,
    p_page_id number,
    p_use_filters_hidPK number,
    po_cols out tp_cols,
    po_basic_col_list out varchar2,
    po_aggr_col_list out varchar2,
    po_order_by_list out varchar2 --,
    --po_aggregation out boolean
    --pio_region_source in out varchar2
)
as
  --t_use_filters varchar2(1);
  t_pref varchar2(32767);
  l_aggregation boolean default false;
  --t_sort varchar2(32767);
begin

  po_cols :=  CollectReportColumns(p_region_id, p_use_filters_hidPK => p_use_filters_hidPK);
  pak_xslt_log.WriteLog( 'CollectReportColumns: '||tp_col2string(po_cols), p_procedure => 'NotDynamicQuery');

  if p_use_filters_hidPK > 0 --Source need to be changed only if we using filters
  then
    t_pref := apex_util.get_preference( 'FSP' || to_char(APEX_APPLICATION.G_FLOW_ID) || '_P' || p_page_id || '_R' || p_region_id || '_SORT', v('APP_USER'));
    if instr( t_pref, 'fsp_sort_' ) = 1
    then
      po_order_by_list := substr( t_pref, 10 );
      pak_xslt_log.WriteLog( 'po_order_by_list(1): '||po_order_by_list, p_procedure => 'NotDynamicQuery');
      if instr( po_order_by_list, 'desc' ) > 0
      then
        po_order_by_list := substr( po_order_by_list, 1, instr( po_order_by_list, '_' ) - 1 );
        po_order_by_list := OrderNum2ColLabel(po_cols, po_order_by_list) || ' asc'; -- bug in APEX????

      else
        po_order_by_list := OrderNum2ColLabel(po_cols, po_order_by_list) || ' desc';
      end if;
      pak_xslt_log.WriteLog( 'po_order_by_list(2): '||po_order_by_list, p_procedure => 'NotDynamicQuery');
    end if;
    if po_order_by_list is null
    then
      po_order_by_list := replace( substr( t_pref, 10 ), '_', ' ' );
      pak_xslt_log.WriteLog( 'po_order_by_list(3): '||po_order_by_list, p_procedure => 'NotDynamicQuery');
      po_order_by_list := OrderNum2ColLabel(po_cols, po_order_by_list); --test daj nazaj
      pak_xslt_log.WriteLog( 'po_order_by_list(4): '||po_order_by_list, p_procedure => 'NotDynamicQuery');
    end if;
  end if;

  l_aggregation := SumTotalSelect(
    po_cols,
    po_basic_col_list => po_basic_col_list,
    po_aggr_col_list => po_aggr_col_list
  );

  if l_aggregation then
    if po_order_by_list is null then
      po_order_by_list := 'REGION_AGGREGATES desc ';
    else
      $IF CCOMPILING.g_views_granted $THEN
        po_order_by_list := 'REGION_AGGREGATES desc, '||po_order_by_list;
      $ELSE
        po_order_by_list := 'REGION_AGGREGATES desc ';
      $END

    end if;
  end if;

  LogComposeSelectAndAttr(
    'NotDynamicQuery',
    p_region_id,
    p_use_filters_hidPK,
    p_basic_col_list => po_basic_col_list,
    p_aggr_col_list => po_aggr_col_list,
    p_order_by_list => po_order_by_list
  );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'NotDynamicQuery', p_sqlerrm => sqlerrm );
  raise;
end NotDynamicQuery;

function tab_string2Clob(
  p_queries query2report.tab_string
)
return CLOB
as
i number default 1;
l_ret CLOB;
begin
  dbms_lob.CreateTemporary(l_ret, false);
  for i in 1..p_queries.count() loop
    dbms_lob.writeappend(l_ret, length(p_queries(i)), p_queries(i));
    if i < p_queries.count() then
      dbms_lob.writeappend(l_ret, 3, ';'||query2report.g_crlf);
    else
      dbms_lob.writeappend(l_ret, 1, ';');
    end if;
  end loop;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'tab_string2Clob', p_sqlerrm => sqlerrm );
  raise;
end;

function FormatMaskIsValid(p_format_mask varchar2, p_column_type varchar2)
return boolean
as
l_date    varchar2(50);
l_number  varchar2(50);
begin
  if p_column_type = 'VARCHAR2' then
    return FormatMaskIsValid(p_format_mask, 'DATE') or FormatMaskIsValid(p_format_mask, 'NUMBER');
  elsif p_column_type = 'DATE' then
    l_date := to_char(sysdate, p_format_mask);
  elsif p_column_type = 'NUMBER' then
    l_number := to_char(9999999.99, p_format_mask);
  end if;
  RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
end FormatMaskIsValid;

/** Return one column part of super select with column aliases and to_char formating
* if there is format mask in report
*
* @param p_col Column record with label, alias, format mask, display sequence
* @param p_html_cols Columns with HTML markup in temporary XML. 0 - Convert to text, exclude columns with image links, 1 - Exlude columns with HTML markup,
* 2 - Exclude columns with image links, preserve rest of columns with HTML markup, 3 - Preserve HTML markup, 4 - Convert to text. Default 0.
* @param pio_html_cols_attr If p_col is html column column name is added to Region attribute html_cols. Syntax: html_cols="col1,col2,colN"
* @param pio_img_cols_attr If p_col is html column with image link column name is added to Region attribute img_cols. Syntax: html_cols_attr="col1,col2,colN"
* @return one column part of super select
*/
function SuperSelectColumn(
  p_col tp_col,
  p_html_cols number,
  pio_html_cols_attr in out varchar2,
  pio_img_cols_attr in out varchar2
)
return varchar2
as
l_ret varchar2(256);
l_label varchar2(256);
l_formated_value varchar2(256);
begin
  if (p_col.html_img_included > 0 and p_html_cols = 1)
  or (p_col.html_img_included = 2 and p_html_cols in (0,2))
  then
    return null;
  end if;
  if p_col.label is null or length(p_col.label) = 0 then --hidden or link column or without label
    l_label := '"'||p_col.alias||'"';
  else
    l_label := '"'||Query2Report.ConvertColName2XmlName(p_col.label)||'"';
  end if;
  if (p_col.format_mask is not null and FormatMaskIsValid(p_col.format_mask, p_col.col_type))
      or p_col.item_type = 'NATIVE_YES_NO'
  then
    --add formating if defined format mask of column
    if p_col.item_type = 'NATIVE_YES_NO' then
       l_formated_value  := ' decode("'||p_col.alias||'", ''Y'', ''Yes'', ''N'', ''No'')';
    else
        if p_col.col_type = 'NUMBER' then
          l_formated_value := ' trim(to_char("'||p_col.alias||'", '''||p_col.format_mask||'''))';
        else
          l_formated_value := ' to_char("'||p_col.alias||'", '''||p_col.format_mask||''')';
        end if;
    end if;
  else
    l_formated_value := ' "'||p_col.alias||'" ';
  end if;
  if (p_col.html_img_included > 0 and p_html_cols in (0,4)) then --convert HTML to TEXT
    l_formated_value := ' query2report.html2str('||l_formated_value||')';
  end if;
  l_ret := l_formated_value||' '||l_label||',';

  l_label := trim('"' from l_label); --remove "

  if (p_col.html_img_included = 1 and p_html_cols in (2,3)) then --column added to html_cols Region attribute
    if pio_html_cols_attr is null then
      pio_html_cols_attr := 'html_cols="'||l_label ;
    else
      pio_html_cols_attr := pio_html_cols_attr||','||l_label ;
    end if;
  end if;

  if (p_col.html_img_included = 2 and p_html_cols = 3) then --column added to html_cols Region attribute
    if pio_img_cols_attr is null then
      pio_img_cols_attr := 'img_cols="'||l_label ;
    else
      pio_img_cols_attr := pio_img_cols_attr||','||l_label ;
    end if;
  end if;

  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'SuperSelectColumn', p_sqlerrm => sqlerrm );
  raise;
end;

/**Procedure adds columns with same aggregation function (SUM, AVG...) to the table of aggregation columns
* for later use
*
* @param pio_t_cols_aggr table of of aggregation columns
* @param p_aggr_cols Aggregation columns separated with :
* @param p_aggregation Aggregation function (SUM, AVG...)
*/
procedure FillAggrColsTable
(
  pio_t_cols_aggr in out tp_cols_aggr
  ,p_aggr_cols in varchar2
  ,p_aggregation in varchar2
)
as
t_strtbl tp_strtbl := tp_strtbl();
begin
  if p_aggr_cols is not null then
    t_strtbl:=split_cols(p_aggr_cols);
    for i in 1..t_strtbl.count loop
      pio_t_cols_aggr.extend;
      pio_t_cols_aggr(pio_t_cols_aggr.count).column_alias := t_strtbl(i);
      pio_t_cols_aggr(pio_t_cols_aggr.count).aggregation := p_aggregation;
    end loop;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'FillAggrColsTable', p_sqlerrm => sqlerrm );
  raise;
end FillAggrColsTable;

/** Function Check apex_application_page_ir_grpby view for any aggregation and outputs parts of select statement if IR is in GROUP BY mode
*
*  Source (ComposeRegionQuery l_source variable) is region_src or region_src_cc or region_src_filtered or region_src_grpby.
*
*  With region_src as (region_select)
*           ,region_src_cc as (select region_src.*,cc_cols_list from region_src)
*           ,region_src_filtered as (select region_src_cc.* from region_src_cc where p_where)
*           ,region_src_grpby as (select group_by_col_list from region_src_filtered group by group_by_list)
*  Select formated_labeled_col_list from
*  (
*    Select po_basic_col_list[, null REGION_AGGR] from source
*    [Union
*    Select po_aggr_col_list, (aggr. cols) REGION_AGGR from source]
*  )
*  Order by [po_aggr_order_by_list,] order_by_list;
*
*  SQL in [] applied only if final SUM is applied on group by IR
*
* @param p_page_id APEX Page ID.
* @param p_rpt_row Row of current IR in apex_application_page_ir_rpt view
* @param p_cols table of columns (also aggregation function is there)
* @param po_basic_col_list list of columns in select
* @param po_aggr_col_list Only SUM function is possible, columns with no aggregation have null values
* @param po_aggr_order_by_list if final SUM applied this is first part of order by column list (REGION_AGGREGATES desc)
*/
function AggregateSelectGroupBy(
  p_page_id         number,
  p_rpt_row         apex_application_page_ir_rpt%rowtype,
  p_cols            tp_cols,
  po_basic_col_list out varchar2,
  po_aggr_col_list  out varchar2,
  po_aggr_order_by_list  out varchar2
)
return boolean
as
 --l_grpby_row apex_application_page_ir_grpby%rowtype;
 l_aggregate boolean default false;
 l_basic_col_list varchar2(32000);
begin
  l_aggregate := SumTotalSelect(
    p_cols,
    po_basic_col_list => po_basic_col_list,
    po_aggr_col_list => po_aggr_col_list
  );
  if l_aggregate then
    /*
    select * into l_grpby_row
    from apex_application_page_ir_grpby cols
    where application_id = APEX_APPLICATION.G_FLOW_ID
    and page_id = p_page_id
    and report_id = p_rpt_row.report_id;
    */
    po_aggr_order_by_list := 'REGION_AGGREGATES desc ';
  end if;

  return l_aggregate;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'AggregateSelectGroupBy', p_sqlerrm => sqlerrm );
  raise;
end;

/** Function Check apex_application_page_ir_rpt, apex_application_page_ir_comp and other views for any aggregation and outputs parts of select statement if IR is not in GROUP BY mode
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
* @param p_region_id APEX Region ID.
* @param p_page_id APEX Page ID.
* @param p_rpt_row Row of current IR in apex_application_page_ir_rpt view
* @param po_breakAttr attribute for Region element of temporary XML
* @param po_basic_col_list list of columns in select
* @param po_aggr_col_list columns with which have aggregations defined (SUM, AVG, COUNT..), columns with no aggregation have null values
* @param po_break_col_list columns in IR break, columns with no break have null values
* @param po_aggr_order_by_list if aggregation applied this is first part of order by column list (BREAKROW, REGION_AGGREGATES desc)
* @param po_break_group_by_list if break and aggregation applied
*/
function AggregateSelectReport(
  p_region_id in number,
  p_page_id in number,
  p_rpt_row apex_application_page_ir_rpt%rowtype,
  po_breakAttr out varchar2,
  po_basic_col_list out varchar2,
  po_aggr_col_list out varchar2,
  po_break_col_list out varchar2,
  po_aggr_order_by_list out varchar2,
  po_break_group_by_list out varchar2
)
return boolean
as
l_aggregated_col varchar2(50);
l_found boolean;
l_count boolean;
l_aggregation boolean default false;
l_break_enabled boolean default false;
l_break_count number default 0;
l_region_aggregates varchar2(4000);
l_grand_total_col_list varchar2(4000) default null;  --dummy, always null
t_cols_aggr tp_cols_aggr := tp_cols_aggr();


cursor c_cols(c_report_id number) is
  select column_alias
       , display_order
       , column_type
       , report_label
    from apex_application_page_ir_col col
    where page_id = p_page_id
    and region_id = p_region_id
     --commented out 14.2.2013
    $IF CCOMPILING.g_views_granted $THEN
    union

    select --computed columns
    comp.computation_column_alias column_alias,
    999 display_order,
    comp.computation_column_type column_type,
    comp.computation_report_label report_label
   from apex_application_page_regions apr
   join apex_application_page_ir ir on apr.region_id = ir.region_id
   join apex_application_page_ir_rpt rpt on rpt.interactive_report_id = ir.interactive_report_id
   join apex_application_page_ir_comp comp on comp.report_id = rpt.report_id
   where apr.region_id = p_region_id
   and rpt.report_id = c_report_id
   $END

   order by display_order, column_alias;

begin
  --l_rpt_row := Get_current_report_row(p_region_id, p_page_id);
  FillAggrColsTable(t_cols_aggr, p_rpt_row.SUM_COLUMNS_ON_BREAK, 'SUM');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.AVG_COLUMNS_ON_BREAK, 'AVG');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MAX_COLUMNS_ON_BREAK, 'MAX');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MIN_COLUMNS_ON_BREAK, 'MIN');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MEDIAN_COLUMNS_ON_BREAK, 'MEDIAN');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.COUNT_COLUMNS_ON_BREAK, 'COUNT');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.COUNT_DISTNT_COL_ON_BREAK, 'COUNT_DISTINCT');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.BREAK_ENABLED_ON, 'GROUP BY');

  for r_col in c_cols(p_rpt_row.report_id) loop
    l_found := false;
    l_count := false;
    for i in 1..t_cols_aggr.count loop
      if r_col.column_alias = t_cols_aggr(i).column_alias then
        l_found := true;
        if t_cols_aggr(i).aggregation = 'GROUP BY' then
          l_break_enabled := true;
          if po_aggr_col_list is null then
            po_aggr_col_list := ' '||r_col.column_alias;
          else
            po_aggr_col_list := po_aggr_col_list||', '||r_col.column_alias;
          end if;

          if po_break_col_list is null then
            po_break_col_list := ' distinct '||r_col.column_alias;
          else
            po_break_col_list := po_break_col_list||', '||r_col.column_alias;
          end if;

          if po_break_group_by_list is null then
            po_break_group_by_list := t_cols_aggr(i).column_alias;
          else
            po_break_group_by_list := po_break_group_by_list||', '||t_cols_aggr(i).column_alias;
          end if;
          l_break_count := l_break_count + 1;
          po_breakAttr := po_breakAttr||'break_on_col'||to_char(l_break_count)||
                        '="'||Query2Report.ConvertColName2XmlName(r_col.report_label)||'" ';


        else --not group by
          l_aggregation := true;
          if t_cols_aggr(i).aggregation = 'COUNT_DISTINCT' then
            l_aggregated_col := 'round(COUNT(DISTINCT '||t_cols_aggr(i).column_alias||'),3)';
          else
            l_aggregated_col := 'round('||t_cols_aggr(i).aggregation||'('||t_cols_aggr(i).column_alias||'),3)';
          end if;
          l_region_aggregates := l_region_aggregates || t_cols_aggr(i).aggregation||','||Query2Report.ConvertColName2XmlName(r_col.report_label)||',';
          if t_cols_aggr(i).aggregation like 'COUNT%'
            --and r_col.column_type <> 'NUMBER'
          then
            l_count := true;
            l_aggregated_col := 'to_char('||l_aggregated_col||')';
          end if;
          if po_aggr_col_list is null then
            po_aggr_col_list := ' '||l_aggregated_col||' '||t_cols_aggr(i).column_alias;
          else
            po_aggr_col_list := po_aggr_col_list||', '||l_aggregated_col||' '||t_cols_aggr(i).column_alias;
          end if;

          if po_break_col_list is null then
            po_break_col_list := ' distinct null '||r_col.column_alias;
          else
            po_break_col_list := po_break_col_list||', null '||r_col.column_alias;
          end if;

        end if;
      end if;
    end loop;
    if not l_found then
      if po_aggr_col_list is null then
        po_aggr_col_list := ' null '||r_col.column_alias;
      else
        po_aggr_col_list := po_aggr_col_list||', null '||r_col.column_alias;
      end if;

      if po_break_col_list is null then
        po_break_col_list := ' distinct null '||r_col.column_alias;
      else
        po_break_col_list := po_break_col_list||', null '||r_col.column_alias;
      end if;
    end if;

    if po_basic_col_list is null then
      if l_count then
        po_basic_col_list := ' to_char('||r_col.column_alias||') '||r_col.column_alias;
      else
        po_basic_col_list := ' '||r_col.column_alias;
      end if;
    else
      if l_count then
        po_basic_col_list := po_basic_col_list||', to_char('||r_col.column_alias||') '||r_col.column_alias;
      else
        po_basic_col_list := po_basic_col_list||', '||r_col.column_alias;
      end if;
    end if;
  end loop;

  if po_aggr_col_list is not null then
    if l_break_enabled then
      --l_order_by := replace(po_break_group_by_list, 'GROUP BY', 'ORDER BY');
      po_aggr_order_by_list := trim(both ',' from po_break_group_by_list);
    end if;

    if l_aggregation then

        if l_break_enabled then
          po_aggr_order_by_list := po_aggr_order_by_list||', BREAKROW, REGION_AGGREGATES desc ';
          AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => l_grand_total_col_list, --dummy, always null
            p_region_aggregates => l_region_aggregates
          );
        else
          po_aggr_order_by_list := 'REGION_AGGREGATES desc ';
          po_break_col_list := null;
          AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => l_grand_total_col_list, --dummy, always null
            p_region_aggregates => l_region_aggregates
          );
        end if;
    elsif l_break_enabled then--not aggregation
      pak_xslt_log.WriteLog( 'No aggregation just break', p_procedure => 'AggregateSelectReport');
      po_aggr_col_list := null;
      AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => l_grand_total_col_list, --dummy, always null
            p_region_aggregates => l_region_aggregates
          );
      po_aggr_order_by_list := po_aggr_order_by_list||', '||' BREAKROW';
    else --no aggregation or break
      pak_xslt_log.WriteLog( 'No aggregation or break', p_procedure => 'AggregateSelectReport');
      po_aggr_col_list := null;
      po_break_col_list := null;
    end if;
  end if;
  return l_aggregation;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'AggregateSelectReport', p_sqlerrm => sqlerrm );
  raise;
end AggregateSelectReport;

/** Function Check apex_application_page_ir_grpby, apex_application_page_ir_rpt, apex_application_page_ir_comp and other views for any aggregation and outputs parts of select statement for IR
*
*  Source (ComposeRegionQuery l_source variable) is region_src or region_src_cc or region_src_filtered or region_src_grpby.
*
*   With region_src as (region_select)
*       ,region_src_cc as (select region_src.*,cc_cols_list from region_src)
*       ,region_src_filtered as (select region_src_cc.* from region_src_cc where p_where)
*       [[,region_src_grpby as (select group_by_col_list from region_src_filtered group by group_by_list)]]
*   Select formated_labeled_col_list from
*   (
*        Select basic_col_list{, null BREAKROW} [, null REGION_AGGR] from source
*     [Union
*       Select aggr_col_list{, null BREAKROW}, aggr. col. list REGION_AGGR from source]
*     {Union
*       Select break_col_list, 1 BREAKROW[, null REGION_AGGR] from source }
*   )
*   Order by [{aggr_order_by_list,}] order_by_list;
*
*   SQL in [] applied only if aggregation is applied on IR.
*   SQL in {} applied only if control break is applied on IR.
*   SQL in [[]] applied only if IR is in group by mode.
*
* @param p_region_id APEX Region ID.
* @param p_page_id APEX Page ID.
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* @param pio_basic_col_list list of columns in select
* @param po_aggr_col_list columns with which have aggregations defined (SUM, AVG, COUNT..), columns with no aggregation have null values
* @param po_break_col_list columns in IR break, columns with no break have null values
* @param po_break_group_by_list if break and aggregation applied
* @param po_aggr_order_by_list if aggregation applied this is first part of order by column list (BREAKROW, REGION_AGGREGATES desc)
* @param po_IRAttr IRAttr attribute for Region element of temporary XML
* @param po_breakAttr break attribute for Region element of temporary XML
* @param po_grpbyAttr grpby attribute for Region element of temporary XML
* @param po_max_rows_IR Maximum number of rows fetched, depend on IR settings
* @param p_cols table of columns (also aggregation function is there)
*/
procedure AggregateSelect(
  --pio_region_source in out nocopy clob,
  p_region_id             in number,
  p_page_id               in number,
  p_use_filters_hidPK     in number,
  pio_basic_col_list      in out varchar2,
  po_aggr_col_list        out varchar2,
  po_break_col_list       out varchar2,
  po_break_group_by_list  out varchar2,
  po_aggr_order_by_list   out varchar2,
  po_IRAttr               out varchar2,
  po_breakAttr            out varchar2,
  po_grpbyAttr            out varchar2,
  po_max_rows_IR          out number,
  po_cols                 out tp_cols
)
as
l_rpt_row apex_application_page_ir_rpt%rowtype;

l_aggregation boolean;

begin
  po_cols := CollectIRColumns(p_region_id, p_page_id, p_use_filters_hidPK, pio_basic_col_list, po_IRAttr, po_grpbyAttr);
  LogComposeSelectAndAttr(
    'AggregateSelect after CollectIRColumns',
    p_region_id,
    p_use_filters_hidPK,
    p_cols => po_cols
  );

  po_max_rows_IR := IRMaxRows(p_region_id, p_page_id);

  l_rpt_row := Get_current_report_row(p_region_id, p_page_id);
  if l_rpt_row.report_view_mode = 'GROUP_BY' then
    po_breakAttr := null;
    l_aggregation := AggregateSelectGroupBy(
      --pio_region_source,
      p_page_id,
      l_rpt_row,
      po_cols,
      --pio_basic_col_list,
      po_basic_col_list => pio_basic_col_list,
      po_aggr_col_list => po_aggr_col_list,
      po_aggr_order_by_list => po_aggr_order_by_list
    );
  else
    l_aggregation := AggregateSelectReport(
      --pio_region_source,
      p_region_id,
      p_page_id,
      l_rpt_row,
      po_breakAttr => po_breakAttr,
      po_basic_col_list => pio_basic_col_list,
      po_aggr_col_list => po_aggr_col_list,
      po_break_col_list => po_break_col_list,
      po_aggr_order_by_list => po_aggr_order_by_list,
      po_break_group_by_list => po_break_group_by_list
    );
  end if;
  if not l_aggregation then
    po_aggr_col_list := null;
  end if;
  LogComposeSelectAndAttr(
    'AggregateSelect',
    p_region_id,
    p_use_filters_hidPK,
    p_cols => po_cols,
    p_basic_col_list => pio_basic_col_list,
    p_aggr_col_list => po_aggr_col_list,
    p_break_col_list => po_break_col_list,
    p_break_group_by_list => po_break_group_by_list,
    p_aggr_order_by_list => po_aggr_order_by_list,
    p_IRAttr => po_IRAttr,
    p_breakAttr => po_breakAttr,
    p_grpbyAttr => po_grpbyAttr
  );

end AggregateSelect;

/**Combine all highlight conditions of current IR from apex_application_page_ir_cond
* view into one column compute with case sentence
*
* @param p_page_id APEX Page ID.
* @param p_region_id APEX Region ID.
* @param p_aggregation true if also aggregation occur
*/
function GetHighlightCaseAll(
  p_page_id number,
  p_region_id number,
  p_aggregation boolean
)
return varchar2
as
l_highlight_case varchar2(32767);
l_report_id number;

cursor c_highlights(c_report_id number) is
  select  cond.condition_sql,
          cond.condition_expression,
          cond.condition_expression2,
          cond.condition_name,
          cond.highlight_cell_color,
          cond.highlight_cell_font_color,
          cond.highlight_row_color,
          cond.highlight_row_font_color,
          col.report_label
  from
  apex_application_page_ir_cond cond
  join apex_application_page_ir_col col on
  cond.application_id = col.application_id
  and cond.page_id = col.page_id
  and col.column_alias = cond.condition_column_name
   where cond.page_id = p_page_id
   and cond.report_id = c_report_id
   and cond.condition_type = 'Highlight'
   and cond.condition_enabled = 'Yes'
   order by cond.highlight_sequence desc;


begin
  l_report_id := Get_current_report_row(p_region_id, p_page_id).report_id;

  for r_highlights in c_highlights(l_report_id) loop
    l_highlight_case := l_highlight_case||
                        GetHighlightCase(
                          r_highlights.condition_sql,
                          r_highlights.condition_expression,
                          r_highlights.condition_expression2,
                          r_highlights.condition_name,
                          r_highlights.highlight_cell_color,
                          r_highlights.highlight_cell_font_color,
                          r_highlights.highlight_row_color,
                          r_highlights.highlight_row_font_color,
                          r_highlights.report_label
                          )||query2report.g_crlf;
  end loop;
  if l_highlight_case is not null then
    l_highlight_case:=replace(l_highlight_case, '(case','');
    l_highlight_case:=replace(l_highlight_case, 'end)','');
    if p_aggregation then
      l_highlight_case:=replace(l_highlight_case, 'when','when REGION_AGGREGATES is null and ');
    end if;
    l_highlight_case:='(case '||l_highlight_case||' end)';
  end if;
  return l_highlight_case;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_page_id '||to_char(p_page_id)||' l_report_id '||to_char(l_report_id),
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'GetHighlightCaseAll',
    p_sqlerrm => sqlerrm );
  raise;
end GetHighlightCaseAll;

function BindSSApexItem(p_name varchar2)
return varchar2
as
l_replacment_string varchar2(50);
l_replacment_strpos number := 1;
l_item_id varchar2(50);
l_ret varchar2(400);
begin
  l_ret := p_name;
  --pak_xslt_log.WriteLog( 'start l_ret: '||l_ret,
  --    p_procedure => 'BindSSApexItem');
  loop
    l_replacment_strpos := regexp_instr(l_ret, '&([a-zA-Z0-9_]*).', l_replacment_strpos); --bind session state values
     exit when nvl(l_replacment_strpos, 0) = 0;
    l_replacment_string := regexp_substr(l_ret, '&([a-zA-Z0-9_]*).', l_replacment_strpos); --bind session state values
    exit when length(l_replacment_string) = 0;

    l_item_id := ltrim(rtrim(l_replacment_string,'.'),'&');

    --pak_xslt_log.WriteLog( 'l_item_id: '||l_item_id||' V(l_item_id): '||V(l_item_id),
      --p_procedure => 'BindSSApexItem');

    if V(l_item_id) is not null then
      l_ret := substr(l_ret, 1, l_replacment_strpos - 1)||V(l_item_id)||substr(l_ret, l_replacment_strpos + length(l_replacment_string));
    else
      if substr(l_ret, l_replacment_strpos + length(l_replacment_string), 1) ='.' then --regexp_substr('&).', '&([a-zA-Z0-9_]*).') returns '&)' - without dot!
          l_ret := substr(l_ret, 1, l_replacment_strpos - 1)||'&'||l_item_id||'.'||substr(l_ret, l_replacment_strpos + length(l_replacment_string) + 1);
      else
          l_ret := substr(l_ret, 1, l_replacment_strpos - 1)||'&'||l_item_id||'.'||substr(l_ret, l_replacment_strpos + length(l_replacment_string));
      end if;
    end if;
    l_replacment_strpos := l_replacment_strpos + 1;
  end loop;

  --pak_xslt_log.WriteLog( 'return l_ret: '||l_ret,
      --p_procedure => 'BindSSApexItem');
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error: '||p_name,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'BindSSApexItem',
    p_sqlerrm => sqlerrm );
  raise;
end BindSSApexItem;

function PrepareColumnHeader(p_header varchar2)
return varchar2
as
l_ret varchar2(400);
begin
  l_ret := BindSSApexItem(p_header);
  --l_ret := PrepareColumnHeader(l_ret);
  l_ret := Query2Report.ConvertColName2XmlName(l_ret);
  l_ret := replace(l_ret,'_',' ');
  --l_ret := '"'||substr(l_ret,1,30)||'"';
  pak_xslt_log.WriteLog( 'l_ret: '||l_ret,
      p_procedure => 'PrepareColumnHeader');
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error: '||p_header,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'PrepareColumnHeader',
    p_sqlerrm => sqlerrm );
  raise;
end PrepareColumnHeader;

function RemoveLineBreak(p_fullname varchar2)
return varchar2
as
l_ret varchar2(400);
begin
  l_ret:= replace(p_fullname,'<br>',' ');
  l_ret:= replace(l_ret,'<br/>',' ');
  
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error: '||p_fullname,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'RemoveLineBreak',
    p_sqlerrm => sqlerrm );
  raise;
end RemoveLineBreak;


function BindSSSource(p_region_source varchar2)
return varchar2
as
l_start_string number;
l_end_string number;
l_region_source varchar2(32767);
l_first_part varchar2(32767);

begin
  l_start_string := instr(p_region_source, '''');
  l_end_string := instr(p_region_source, '''', 1, 2);

  if nvl(l_start_string, 0) = 0 or nvl(l_end_string, 0) = 0 then
    l_region_source := replace(p_region_source, '#OWNER#', V('OWNER'));
    l_region_source := replace(l_region_source, '#owner#', V('OWNER'));
    l_region_source := replace(l_region_source, '#FLOW_OWNER#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER);
    l_region_source := replace(l_region_source, '#flow_owner#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER);
    return regexp_replace(l_region_source, ':([a-zA-Z0-9_]*)','v(''\1'')');
  else
    l_first_part := substr(p_region_source, 1 , l_start_string - 1);
    l_first_part := replace(l_first_part, '#OWNER#', V('OWNER'));
    l_first_part := replace(l_first_part, '#owner#', V('OWNER'));
    l_first_part := replace(l_first_part, '#FLOW_OWNER#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER);
    l_first_part := replace(l_first_part, '#flow_owner#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER);
    l_first_part := regexp_replace(l_first_part, ':([a-zA-Z0-9_]*)','v(''\1'')');
    l_region_source := l_first_part||--bind session state values
                       substr(p_region_source, l_start_string, l_end_string - l_start_string+1); --leave string untouched
    if l_end_string < length(p_region_source) then
      l_region_source := l_region_source||BindSSSource(substr(p_region_source, l_end_string + 1)); --recursive call on second half of source
    end if;
    RETURN l_region_source;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'BindSSSource',
    p_sqlerrm => sqlerrm );
  raise;
end BindSSSource;

procedure GetSourceName(
  p_cc_col_list           in varchar2,
  p_where                 in varchar2,
  p_master_region_id      in number,
  p_group_by_col_list     in varchar2,
  po_source               out varchar2,
  po_source_before_filter out varchar2
)
as

begin
  LogComposeSelectAndAttr(
    p_procedure         =>  'GetSourceName start',
    p_cc_col_list       => p_cc_col_list,
    p_group_by_col_list => p_group_by_col_list,
    p_where             => p_where
  );
  if p_master_region_id is not null then
      po_source := 'region_src_joined_master';
      po_source_before_filter := 'region_src_joined_master';
  else
      po_source := 'region_src';
      po_source_before_filter := 'region_src';
  end if;

  if p_cc_col_list is not null then
    po_source_before_filter := 'region_src_cc';
  end if;

  if p_group_by_col_list is not null then --IR group by mode
    po_source := 'region_src_grpby';
  elsif p_where is not null then
    po_source := 'region_src_filtered';
  elsif p_cc_col_list is not null then
    po_source := 'region_src_cc';
  end if;

  pak_xslt_log.WriteLog( 'Finished po_source '||po_source||
                         ' po_source_before_filter '||po_source_before_filter,
  p_procedure => 'GetSourceName');
end;

function LOVSuperSelect(p_LOV_query varchar2)
return varchar2
as
  c           NUMBER;
  d           NUMBER;
  col_cnt     INTEGER;
  f           BOOLEAN;
  rec_tab     DBMS_SQL.DESC_TAB;
  col_num    NUMBER;
begin
  if p_LOV_query is null then
    return null;
  end if;

  c := DBMS_SQL.OPEN_CURSOR;
  --first bind variables (APEX items)
  DBMS_SQL.PARSE(c, BindSSSource(RemoveSemicolon(p_LOV_query)), DBMS_SQL.NATIVE);
  d := DBMS_SQL.EXECUTE(c);
  DBMS_SQL.DESCRIBE_COLUMNS(c, col_cnt, rec_tab);
  DBMS_SQL.CLOSE_CURSOR(c);
  if col_cnt <> 2 then
    return null;
  end if;
  return 'select '||rec_tab(1).col_name||' d, '||rec_tab(2).col_name||' v from ('||p_LOV_query||')';
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_LOV_query: '||p_LOV_query, p_log_type => pak_xslt_log.g_error, p_procedure => 'LOVSuperSelect', p_sqlerrm => sqlerrm );
  raise;
end LOVSuperSelect;

function GetLOVSelect(
  p_app_id number,
  p_col_alias varchar2,
  p_named_LOV varchar2,
  p_inline_LOV varchar2
)
return varchar2
as
l_ret varchar2(32000);
l_LOV_query varchar2(32000);
l_LOV_type varchar2(20);
l_static_LOV varchar2(32000);
l_row varchar2(4000);
l_comma number;
l_semicolon number;
l_static boolean default false;

begin
  if p_named_LOV is not null then --named LOV
    select list_of_values_query, lov_type
    into l_LOV_query, l_LOV_type
    from apex_application_lovs
    where application_id = p_app_id
    and list_of_values_name = p_named_LOV;

    if l_lov_type = 'Static' and p_app_id is not null then --static named LOV
      l_LOV_query := 'select display_value d, trim(return_value) v from APEX_APPLICATION_LOV_ENTRIES where application_id = '||
        p_app_id||' and list_of_values_name = '''||p_named_LOV||'''';
      l_static := true;
    end if;
  elsif p_inline_LOV is not null then --not named LOV
    if substr(upper(trim(p_inline_LOV)),1,6) = 'SELECT' then --dynamic named LOV
      l_LOV_query := p_inline_LOV;
    elsif substr(upper(trim(p_inline_LOV)),1,6) = 'STATIC'  --static named LOV
          and instr(p_inline_LOV,';') > 0
          and instr(p_inline_LOV,':') > 0
    then --STATIC:President;1,Member;0
      l_static_LOV := substr(p_inline_LOV, instr(p_inline_LOV,':')+1); --President;1,Member;0
      l_static_LOV := l_static_LOV||','; --President;1,Member;0,
      loop
        l_comma := nvl(instr(l_static_LOV,','), 0);
        exit when l_comma = 0;
        l_row := substr(l_static_LOV, 1, l_comma-1);
        l_semicolon := nvl(instr(l_row,';'),0);
        exit when l_semicolon = 0;
        if l_LOV_query is null then
          l_LOV_query := 'select '''||substr(l_row,1,l_semicolon - 1)||''' d, '''||
          substr(l_row, l_semicolon + 1)||''' v from dual';
        else
          l_LOV_query := l_LOV_query||' union select '''||
            substr(l_row,1,l_semicolon - 1)||''' d, '''||
            substr(l_row, l_semicolon + 1)||''' v from dual';
        end if;
        l_static_LOV := substr(l_static_LOV, l_comma+1);--Member;0, on first loop
      end loop;
      l_static := true;
    end if; --static named LOV
  end if; --not named LOV
  if not l_static then --must add or chage aliases to d (dispaly_value) and v (return_value)
                       --also binding variables (APEX ITEMS) takes place
    l_LOV_query := LOVSuperSelect(l_LOV_query);
  end if;
  return l_LOV_query;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'GetLOVSelect', p_sqlerrm => sqlerrm );
  raise;
end;


procedure Compose_LOV_selects(
      p_cc_col_list                     IN varchar2,
      p_where                           IN varchar2,
      p_cols                            IN tp_cols,
      p_master_region_id                IN integer,
      pio_group_by_col_list             IN OUT varchar2,
      pio_basic_col_list                IN OUT varchar2,
      pio_aggr_col_list                 IN OUT varchar2,
      pio_break_group_by_list           IN OUT varchar2,
      pio_where                         IN OUT varchar2,
      pio_break_col_list                IN OUT varchar2,
      po_LOV_selects                    OUT varchar2,
      po_join_LOV_selects               OUT varchar2,
      po_join_LOV_filtersel             OUT varchar2
)
as
l_source                varchar2(100);
l_source_before_filter  varchar2(100);
begin
  LogComposeSelectAndAttr(
    p_procedure                     =>  'Compose_LOV_selects start',
    p_cols                          => p_cols,
    p_cc_col_list                   => p_cc_col_list,
    p_group_by_col_list             => pio_group_by_col_list,
    p_basic_col_list                => pio_basic_col_list,
    p_aggr_col_list                 => pio_aggr_col_list,
    p_break_group_by_list           => pio_break_group_by_list,
    p_where                         => pio_where,
    p_break_col_list                => pio_break_col_list,
    p_LOV_selects                   => po_LOV_selects,
    p_join_LOV_selects              => po_join_LOV_selects
  );
  GetSourceName(p_cc_col_list, p_where, p_master_region_id, pio_group_by_col_list, l_source, l_source_before_filter);

  for i in 1..p_cols.count loop
    if p_cols(i).lov_sql is not null then
      pio_basic_col_list := regexp_replace(pio_basic_col_list, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                            '\1'||p_cols(i).alias||'_LOV.d \2'||p_cols(i).alias||'\3\4');

      if pio_group_by_col_list is not null then
          pio_group_by_col_list := regexp_replace(pio_group_by_col_list, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                            '\1'||p_cols(i).alias||'_LOV.d \2'||p_cols(i).alias||'\3\4');
      end if;

      if nvl(instr(pio_aggr_col_list, 'null '||p_cols(i).alias), 0) = 0
         and nvl(instr(pio_aggr_col_list, 'null "'||p_cols(i).alias||'"'), 0) = 0
      then --replace just if not null value
          pio_aggr_col_list := regexp_replace(pio_aggr_col_list, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                            '\1'||p_cols(i).alias||'_LOV.d \2'||p_cols(i).alias||'\3\4');
      end if;

      if pio_break_group_by_list is not null then
          pio_break_group_by_list := replace(pio_break_group_by_list, p_cols(i).alias, p_cols(i).alias||'_LOV.d ');
      end if;

      if nvl(instr(pio_break_col_list, 'null '||p_cols(i).alias), 0) = 0
         and nvl(instr(pio_break_col_list, 'null "'||p_cols(i).alias||'"'), 0) = 0
      then --replace just if not null value
          pio_break_col_list := regexp_replace(pio_break_col_list, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                                '\1'||p_cols(i).alias||'_LOV.d \2'||p_cols(i).alias||'\3\4');
      end if;



      if pio_where is not null then
        pio_where := regexp_replace(pio_where, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                              '\1\2'||p_cols(i).alias||'_LOV\3.d\4 ');
      end if;
      if po_LOV_selects is null then
        po_LOV_selects := p_cols(i).alias||'_LOV as ('||p_cols(i).lov_sql||')';
      else
        po_LOV_selects := po_LOV_selects||query2report.g_crlf||','||p_cols(i).alias||'_LOV as ('||p_cols(i).lov_sql||')';
      end if;
      po_join_LOV_filtersel := po_join_LOV_filtersel||query2report.g_crlf||'left outer join '||p_cols(i).alias||'_LOV on '||
                             p_cols(i).alias||'_LOV.v = '||l_source_before_filter||'.'||p_cols(i).alias;

      po_join_LOV_selects := po_join_LOV_selects||query2report.g_crlf||'left outer join '||p_cols(i).alias||'_LOV on '||
                             p_cols(i).alias||'_LOV.v = '||l_source||'.'||p_cols(i).alias;
    else
      pio_basic_col_list := regexp_replace(pio_basic_col_list, '(\W|^)("?)'||p_cols(i).alias||'("?)(\W|$)',
                            '\1'||l_source||'.\2'||p_cols(i).alias||'\3\4');
      --TODO replace to_char(region_src.CUSTOMERS) region_src.CUSTOMERS, with to_char(region_src.CUSTOMERS) CUSTOMERS,
      --this is because COUNT, COUNT DISTINCT aggregations
      pio_basic_col_list := replace(pio_basic_col_list,
                                    'to_char('||l_source||'.'||p_cols(i).alias||') '||l_source||'.'||p_cols(i).alias||',',
                                    'to_char('||l_source||'.'||p_cols(i).alias||') '||p_cols(i).alias||',');
    end if;
  end loop;
 --TODO procedure body
  LogComposeSelectAndAttr(
    p_procedure         =>  'Compose_LOV_selects end',
    p_cols              => p_cols,
    p_cc_col_list       => p_cc_col_list,
    p_group_by_col_list => pio_group_by_col_list,
    p_basic_col_list    => pio_basic_col_list,
    p_aggr_col_list   => pio_aggr_col_list,
    p_break_group_by_list => pio_break_group_by_list,
    p_where             => pio_where,
    p_break_col_list    => pio_break_col_list,
    p_LOV_selects       => po_LOV_selects,
    p_join_LOV_selects  => po_join_LOV_selects
  );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Compose_LOV_selects',
    p_sqlerrm => sqlerrm );
  raise;
end Compose_LOV_selects;

/** Returns main labeled column list with formating, Column names are converted to element names in temporary XML
*
* @param p_page_id APEX Page ID.
* @param p_region_id APEX region ID.
* @param p_source_type_code Dynamic Query or not. For including highlights
* @param p_cols Array of columns from region source selects
* @param p_html_cols Columns with HTML markup in temporary XML. 0 - Convert to text, exclude columns with image links, 1 - Exlude columns with HTML markup,
* 2 - Exclude columns with image links, preserve rest of columns with HTML markup, 3 - Preserve HTML markup, 4 - Convert to text. Default 0.
* @param p_break Break rows included
* @param p_aggregation Aggregation is done
* @param p_group_by_mode IR is in group by mode
* @return Main labeled column list with formating
*/
function FormatedAndLabeledColList(
  p_page_id number,
  p_region_id number,
  p_source_type_code varchar2,
  p_cols tp_cols,
  p_html_cols number,
  p_break boolean default false,
  p_aggregation boolean default false,
  p_group_by_mode boolean default false,
  p_break_group_by_list varchar2 default null,
  p_break_group_by_list_alias varchar2 default null,
  po_html_cols_attr out varchar2,
  po_img_cols_attr out varchar2
)
return varchar2
as
l_col_lost varchar2(32767);
l_cols varchar2(32767);
l_highlight_case varchar2(32767);
begin
  --select just in report visible columns (this are columns in t_col)
  for cc in 1 .. p_cols.count() loop
    l_col_lost := l_col_lost ||
                  SuperSelectColumn(
                    p_cols(cc),
                    p_html_cols,
                    po_html_cols_attr,
                    po_img_cols_attr
                  );
    l_cols:= l_cols||p_cols( cc ).alias||'|'||p_cols( cc ).label||', '; --Just for logging
  end loop;

  if l_col_lost is not null then
    if p_break then
      l_col_lost := l_col_lost||' BREAKROW,';
    end if;
    if p_aggregation then
      if p_break then
          if p_break_group_by_list_alias is not null then
              l_col_lost := l_col_lost||' case when REGION_AGGREGATES is not null then
                case BREAKROW WHEN 2 then ''1'' --Total sum
                else
                    to_char(row_number() over (order by '||p_break_group_by_list_alias||', BREAKROW, REGION_AGGREGATES desc) - row_number() over (partition by '||p_break_group_by_list_alias||' order by '||p_break_group_by_list_alias||', BREAKROW, REGION_AGGREGATES desc) + 2)
                end
                ||'':''||
                to_char(row_number() over (order by '||p_break_group_by_list_alias||', BREAKROW, REGION_AGGREGATES desc) - 1)||'',''||
                REGION_AGGREGATES end REGION_AGGREGATES,';
          else
              l_col_lost := l_col_lost||' REGION_AGGREGATES,';
          end if;
      else
          l_col_lost := l_col_lost||' case when REGION_AGGREGATES is not null then ''1:''||to_char(rownum - 1)||'',''||REGION_AGGREGATES end REGION_AGGREGATES,';
      end if;
    end if;
    l_col_lost := rtrim(l_col_lost, ','); --remove last colon

    if p_source_type_code = 'DYNAMIC_QUERY' and not p_group_by_mode then --no highlights if IR in group by mode
      l_highlight_case := GetHighlightCaseAll(p_page_id, p_region_id, p_aggregation);
      if l_highlight_case is not null then
        l_col_lost := l_col_lost||', '||query2report.g_crlf||l_highlight_case||' REGION_HIGHLIGHTS';
      end if;
    end if;

	$if CCOMPILING.g_IG_exists $then


    if p_source_type_code = 'NATIVE_IG' then
      l_highlight_case := IG2REPORT.GetHighlightCaseAll(p_page_id, p_region_id, p_aggregation, p_cols);
      if l_highlight_case is not null then
        l_col_lost := l_col_lost||', '||query2report.g_crlf||l_highlight_case||' REGION_HIGHLIGHTS';
      end if;
    end if;
	$end



    if po_html_cols_attr is not null then --close attribute
      po_html_cols_attr := po_html_cols_attr||'"';
    end if;
    if po_img_cols_attr is not null then --close attribute
      po_img_cols_attr := po_img_cols_attr||'"';
    end if;
  end if;
  pak_xslt_log.WriteLog( 'p_region_id: '||p_region_id||' FormatedAndLabeledColList: '||l_col_lost,
                          p_procedure => 'FormatedAndLabeledColList');

  return l_col_lost;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'FormatedAndLabeledColList',
    p_sqlerrm => sqlerrm );
  raise;
end FormatedAndLabeledColList;

function RegionAttr(
  p_region_name varchar2,
  p_IRAttr      varchar2,
  p_breakAttr   varchar2,
  p_grpby_args  varchar2,
  p_max_rows_IR number,
  p_maximum_row_count number,
  p_aggregation boolean,
  p_html_cols_attr varchar2,
  p_img_cols_attr varchar2,
  po_max_row    out number
)
return varchar2
as
l_regionAttr varchar2(4000);

begin
  l_regionAttr := BindSSApexItem(p_region_name); --bind session state values
  l_regionAttr := 'name="'||htf.escape_sc(l_regionAttr)||'"';
  --pak_xslt_log.WriteLog('p_IRAttr: '||p_IRAttr, p_procedure => 'GetSourceQueriesAndXML' );
  if p_IRAttr is not null then
    l_regionAttr := l_regionAttr||' '||p_IRAttr;
  end if;
  if p_breakAttr is not null then
    l_regionAttr := l_regionAttr||' '||p_breakAttr;
  end if;
  if p_grpby_args is not null then
    l_regionAttr := l_regionAttr||' '||p_grpby_args;
  end if;
  if p_html_cols_attr is not null then
    l_regionAttr := l_regionAttr||' '||p_html_cols_attr;
  end if;
  if p_img_cols_attr is not null then
    l_regionAttr := l_regionAttr||' '||p_img_cols_attr;
  end if;
  --TODO
  po_max_row := nvl(p_max_rows_IR, p_maximum_row_count);
  if p_aggregation then
    if p_breakAttr is not null then
      po_max_row := po_max_row * 1.3;
    end if;
    po_max_row := po_max_row + 1;
  end if;
  return l_regionAttr;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'RegionAttr',
    p_sqlerrm => sqlerrm );
  raise;
end RegionAttr;

FUNCTION SplitString (p_in_string VARCHAR2, p_delim VARCHAR2 default ',') RETURN tp_order_cols
IS
  i       number :=0;
  pos     number :=0;
  lv_str  varchar2(4000) := p_in_string;
  strings tp_order_cols;
   BEGIN
      -- determine first chuck of string
      pos := instr(lv_str,p_delim,1,1);
      -- while there are chunks left, loop
      WHILE ( pos != 0) LOOP
         -- increment counter
         i := i + 1;
         -- create array element for chuck of string
         strings(i) := trim(substr(lv_str,1,pos-length(p_delim)));
         -- remove chunk from string
         lv_str := substr(lv_str,pos+1,length(lv_str));
         -- determine next chunk
         pos := instr(lv_str,p_delim,1,1);
         -- no last chunk, add to array
         IF pos = 0 THEN
            strings(i+1) := trim(lv_str);
         END IF;
      END LOOP;

      -- return array
      RETURN strings;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'SplitString',
    p_sqlerrm => sqlerrm );
  raise;
END SplitString;

function MergeOrderList(
  p_aggr_order_by_list varchar2,
  p_order_by_list varchar2,
  p_IG boolean default false
)
return varchar2
as
l_ret varchar2(4000);
l_aggr_tbl tp_order_cols;
l_order_tbl tp_order_cols;
l_start_order_tbl tp_order_cols;
l_colname varchar2(40);
l_temp varchar2(40);
l_position integer;
l_finded integer := 0;
begin
  if p_IG then
      l_ret := ltrim(rtrim(p_aggr_order_by_list||','||p_order_by_list,','),',');
  else
      if nvl(instr(p_aggr_order_by_list, 'BREAKROW'),0) = 0 then
        l_ret := trim( both ',' from p_aggr_order_by_list||','||p_order_by_list);
      else
        l_aggr_tbl := SplitString(trim( both ',' from p_aggr_order_by_list));
        l_order_tbl := SplitString(trim( both ',' from p_order_by_list));
        for i in 1..l_order_tbl.count loop
          --extract COL name
          l_colname := trim(replace(rtrim(rtrim(l_order_tbl(i),'DESC'),'ASC'),'"'));
          l_position := 0;
          --find COL name in l_aggr_tbl
          for j in 1..l_aggr_tbl.count loop
            if l_aggr_tbl(j) = l_colname then
              l_position := j;
              l_finded := l_finded +1;
              exit;
            end if;
          end loop;
          if l_position > 0 then --finded in l_aggr_tbl
            --add finded to start table
            l_start_order_tbl(l_finded) :=  l_order_tbl(i);
            --mark order_tbl(i) and l_aggr_tbl(l_position) to not double include column in order by
            l_aggr_tbl(l_position) := 'ORDER BY';
            l_order_tbl(i):='ORDER BY';
          end if;
        end loop;
        --create order by sentence from l_aggr_tbl and l_order_tbl without 'BREAKROW' values
        for i in 1..l_start_order_tbl.count loop
          l_ret := l_ret||l_start_order_tbl(i)||', ';
        end loop;
        for i in 1..l_aggr_tbl.count loop
          if l_aggr_tbl(i) != 'ORDER BY' then
            l_ret := l_ret||l_aggr_tbl(i)||', ';
          end if;
        end loop;
        for i in 1..l_order_tbl.count loop
          if l_order_tbl(i) != 'ORDER BY' then
            l_ret := l_ret||l_order_tbl(i)||', ';
          end if;
        end loop;
        l_ret := rtrim(l_ret,', ');
      end if;
  end if;
return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_aggr_order_by_list '||p_aggr_order_by_list||' p_order_by_list '||p_order_by_list,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'MergeOrderList',
    p_sqlerrm => sqlerrm );
  raise;
end;

function ComposeRegionSource(p_region_source varchar2, p_start_region varchar2) 
return varchar2
as
l_ret varchar2(32767);
l_last_select varchar2(32767);
l_region_source_no_with varchar2(32767);
l_region_source_with varchar2(32767);

begin
if regexp_replace(p_region_source,'[[:space:]]*') like ('with%as(%)%') then --there is with in region source
    l_region_source_with := trim(RemoveSemicolon(p_region_source)); 
    l_region_source_no_with := substr(l_region_source_with, instr(lower(l_region_source_with), 'with')+length('with'));
    l_last_select := regexp_instr(lower(l_region_source_no_with), '\)[[:space:]]*select');
    l_last_select := instr(lower(l_region_source_no_with), 'select', l_last_select);
    l_ret := substr(l_region_source_no_with, 1, l_last_select-1)||' , '||
                                      p_start_region ||query2report.g_crlf
                                      ||substr(l_region_source_no_with, l_last_select)
                                      ||query2report.g_crlf||g_end_region_src||query2report.g_crlf;
  else
    l_ret := p_start_region||query2report.g_crlf||RemoveSemicolon(p_region_source)||query2report.g_crlf||g_end_region_src||query2report.g_crlf;
  end if;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_region_source '||p_region_source||' p_start_region '||p_start_region,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'RemoveSemicolon',
    p_sqlerrm => sqlerrm );
  raise;     
end;

/** Function returns complete select from select parts in input parameters
*
*   With region_src as (p_region_source)
*       ,region_src_cc as (select region_src.*,p_cc_cols_list from region_src)
*       ,region_src_filtered as (select region_src_cc.* from region_src_cc where p_where)
*       [[,region_src_grpby as (select p_group_by_col_list from region_src_filtered group by p_group_by_list)]]
*   Select p_formated_labeled_col_list from
*   (
*        Select p_basic_col_list{, null BREAKROW} [, null REGION_AGGR] from source
*     [Union
*       Select p_aggr_col_list{, null BREAKROW}, aggr. col. list REGION_AGGR from source]
*     {Union
*       Select p_break_col_list, 1 BREAKROW[, null REGION_AGGR] from source }
*   )
*   Order by [{p_aggr_order_by_list,}] p_order_by_list;
*
*   Source (l_source variable) is region_src or region_src_cc or region_src_filtered or region_src_grpby.
*
*   SQL in [] applied only if aggregation is applied on IR.
*   SQL in {} applied only if control break is applied on IR.
*   SQL in [[]] applied only if IR is in group by mode.
*
* @param p_region_source Original region souce select
* @param p_formated_labeled_col_list Part of select.
* @param p_where Part of select
* @param p_basic_col_list Part of select
* @param p_aggr_col_list Part of select
* @param p_break_col_list Part of select
* @param p_break_group_by_list Part of select
* @param p_cc_col_list Part of select
* @param p_group_by_list Part of select
* @param p_aggr_order_by_list Part of select
* @param p_order_by_list Part of select
* @param p_group_by_col_list Part of select
*/
function ComposeRegionQuery(
  p_region_source             varchar2,
  p_formated_labeled_col_list varchar2,
  p_where                     varchar2,
  p_basic_col_list            varchar2,
  p_aggr_col_list             varchar2,
  p_break_col_list            varchar2,
  p_break_group_by_list       varchar2,
  p_cc_col_list               varchar2,
  p_group_by_list             varchar2,
  p_aggr_order_by_list        varchar2,
  p_order_by_list             varchar2,
  p_group_by_col_list         varchar2,
  p_LOV_selects               varchar2,
  p_join_LOV_selects          varchar2,
  p_join_LOV_filtersel        varchar2,
  p_grand_total_col_list      varchar2,
  p_IG                        boolean default false,
  p_master_region_source      varchar2 default null,
  p_join_master_region        varchar2 default null,
  p_master_select_list        varchar2 default null
)
return varchar2
as
l_region_source varchar2(32767);
l_source varchar2(100);
l_group_by_mode boolean;

begin
  LogComposeSelectAndAttr(
    p_procedure => 'ComposeRegionQuery',
    p_basic_col_list => p_basic_col_list,
    p_aggr_col_list =>  p_aggr_col_list,
    p_break_col_list => p_break_col_list,
    p_where => p_where,
    p_group_by_list => p_group_by_list,
    p_order_by_list =>  p_order_by_list,
    p_aggr_order_by_list => p_aggr_order_by_list,
    p_group_by_col_list => p_group_by_col_list,
    p_break_group_by_list => p_break_group_by_list,
    p_cc_col_list => p_cc_col_list,
    p_LOV_selects => p_LOV_selects,
    p_join_LOV_selects => p_join_LOV_selects,
    p_grand_total_col_list => p_grand_total_col_list,
    p_master_region_source => p_master_region_source,
    p_join_master_region => p_join_master_region,
    p_master_select_list => p_master_select_list
  );

  l_region_source := 'with ';
  if p_LOV_selects is not null then
    l_region_source := l_region_source||p_LOV_selects||query2report.g_crlf||',';
  end if;
  if p_master_region_source is not null then
    l_region_source := l_region_source || ComposeRegionSource(p_master_region_source, 'master_region_src as ( ')||query2report.g_crlf||','; 
    --l_region_source := l_region_source||'master_region_src as ( '||RemoveSemicolon(p_master_region_source)||')'||query2report.g_crlf||',';
  end if;

  l_region_source := l_region_source || ComposeRegionSource(p_region_source, g_start_region_src);
  
  /*
  if regexp_replace(p_region_source,'[[:space:]]*') like ('with%as(%)%') then --there is with in region source
    l_region_source_with := rtrim(trim(p_region_source),';'); 
    l_region_source_no_with := substr(l_region_source_with, instr(lower(l_region_source_with), 'with')+length('with'));
    l_last_select := regexp_instr(lower(l_region_source_no_with), '\)[[:space:]]*select');
    l_last_select := instr(lower(l_region_source_no_with), 'select', l_last_select);
    l_region_source := l_region_source|| substr(l_region_source_no_with, 1, l_last_select-1)||' , '||
                                      g_start_region_src ||query2report.g_crlf
                                      ||substr(l_region_source_no_with, l_last_select)
                                      ||query2report.g_crlf||g_end_region_src||query2report.g_crlf;
  else
    l_region_source := l_region_source||g_start_region_src||query2report.g_crlf||RemoveSemicolon(p_region_source)||query2report.g_crlf||g_end_region_src||query2report.g_crlf;
  end if;
  */
  
  if p_join_master_region is not null and p_master_region_source is not null /*and p_master_select_list is not null*/ then
      --l_region_source := l_region_source||', region_src_joined_master '||p_master_select_list||' as ( select master_region_src.*, region_src.* from master_region_src join region_src on '||
      l_region_source := l_region_source||', region_src_joined_master as ( select '||p_master_select_list||' region_src.* from master_region_src join region_src on '||
      p_join_master_region||')'||query2report.g_crlf;
      l_source := 'region_src_joined_master';
  else
      l_source := 'region_src';
  end if;
  if p_cc_col_list is not null then
    l_region_source := l_region_source||
      ',region_src_cc as ( select '||l_source||'.* '||p_cc_col_list||' from '||l_source||')'||query2report.g_crlf;
      l_source := 'region_src_cc';
  end if;
  if p_where is not null then
    l_region_source := l_region_source||
      ',region_src_filtered as ( select '||l_source||'.* from '||l_source||
      p_join_LOV_filtersel||
      query2report.g_crlf||'where '||p_where||')'||query2report.g_crlf;
      l_source := 'region_src_filtered';
  end if;
  if p_group_by_col_list is not null then --IR group by mode
    l_region_source := l_region_source||',region_src_grpby as (select '||p_group_by_col_list||
                      ' from '||l_source||' group by '||p_group_by_list||')'||query2report.g_crlf;
    l_source := 'region_src_grpby';
    l_group_by_mode := true;
  end if;
  l_region_source := l_region_source||'select '||nvl(p_formated_labeled_col_list,'*')||' from '||query2report.g_crlf||'('||query2report.g_crlf||
  'select '||nvl(p_basic_col_list,'*')||' from '||l_source||query2report.g_crlf;
  if p_join_LOV_selects is not null then
    l_region_source := l_region_source||p_join_LOV_selects||query2report.g_crlf;
  end if;
  /*
  if p_break_col_list is null and p_group_by_list is not null then --group by in IR group by mode
    l_region_source := l_region_source ||' group by '||p_break_group_by_list||query2report.g_crlf;
  end if;
  */
  if p_aggr_col_list is not null then
    l_region_source := l_region_source ||' union '||query2report.g_crlf||
                       'select '||p_aggr_col_list||' from '||l_source||' ';

    if p_join_LOV_selects is not null then
        l_region_source := l_region_source||p_join_LOV_selects||query2report.g_crlf;
    end if;

    if p_break_group_by_list is not null and p_break_col_list is not null then --group by in IR when break and aggregation applied.
      l_region_source := l_region_source ||query2report.g_crlf||'group by '||p_break_group_by_list;
    end if;
  end if;
  if p_break_col_list is not null then
    l_region_source := l_region_source||query2report.g_crlf||'union '||query2report.g_crlf||
                       'select '||p_break_col_list||' from '||l_source||' ';
    if p_join_LOV_selects is not null then
        l_region_source := l_region_source||p_join_LOV_selects||query2report.g_crlf;
    end if;
  end if;
  if p_grand_total_col_list is not null then
    l_region_source := l_region_source||query2report.g_crlf||'union '||query2report.g_crlf||
                       'select '||p_grand_total_col_list||' from '||l_source||' ';
  end if;


  l_region_source := l_region_source ||query2report.g_crlf||')';
  if nvl(p_order_by_list, p_aggr_order_by_list) is not null then
    l_region_source := l_region_source ||query2report.g_crlf||
            ' order by '||MergeOrderList(p_aggr_order_by_list, p_order_by_list, p_IG);
  end if;
  return BindSSSource(l_region_source); --bind session state values;
end ComposeRegionQuery;

function GetPosint(p_string varchar2)
return number
as
l_ret number;
begin
  l_ret := to_number(p_string);
  if abs(floor(l_ret)) = l_ret then
    return l_ret;
  else
    return 0;
  end if;
exception
  when others then
    return 0;
end;

function LogParsedRegions(p_regions tp_regions)
return varchar2
as
l_ret varchar2(4000);
begin
  for i in 1..p_regions.count loop
    l_ret := l_ret || p_regions(i).region_name||';';
    if  p_regions(i).region_query is not null then
      l_ret := l_ret||' select'||i||';';
    end if;
    if  p_regions(i).max_rows is not null then
      l_ret := l_ret||' '||p_regions(i).max_rows||';';
    end if;
     l_ret := l_ret||' | ';
  end loop;
  return l_ret;
end;

function ParseRegions(
  p_region_names varchar2,
  p_page_id number
)
return tp_regions
as
l_regions tp_regions := tp_regions();
l_semicolon_pos number := 1;
l_region_names varchar2(32000);
l_region_name varchar2(32000);
l_max_rows number;

cursor c_apr is
select BindSSApexItem(region_name) region_name
 from apex_application_page_regions
 where application_id = APEX_APPLICATION.G_FLOW_ID
 and   page_id = p_page_id
 --and   source_type_code in ( 'UPDATABLE_SQL_QUERY', 'SQL_QUERY', 'DYNAMIC_QUERY', 'STRUCTURED_QUERY', 'FUNCTION_RETURNING_SQL_QUERY', 'NATIVE_IG' ) --'UPDATABLE_SQL_QUERY' Added by MM
 and  lower(trim(region_source))  like '%select%from%'
 order by display_sequence;
begin
  pak_xslt_log.WriteLog( 'Parse regions starts p_region_names: '||p_region_names||' p_page_id: '||p_page_id, p_procedure => 'ParseRegions');
  if p_region_names is not null then
    l_region_names := p_region_names||';';
    loop
      l_semicolon_pos := instr(l_region_names,';');
      exit when nvl(l_semicolon_pos, 0) = 0;
      l_region_name := substr(l_region_names, 1, l_semicolon_pos-1);
      l_region_name := trim(leading chr(13) from trim(l_region_name));
      l_region_name := trim(leading chr(10) from l_region_name);
      l_region_name := trim(trailing chr(10) from l_region_name);
      l_region_name := trim(trailing chr(13) from l_region_name);
      l_region_name := trim(l_region_name);
      l_max_rows := GetPosInt(l_region_name);

      pak_xslt_log.WriteLog(
        'l_region_name: '||l_region_name,
        p_procedure => 'ParseRegions'
      );

      if l_regions.count > 0
         and l_regions(l_regions.count).region_name is not null
         and lower(l_region_name) like 'select%'
         and instr(lower(l_region_name),'from') > 0
         then
        l_regions(l_regions.count).region_query := l_region_name;
      elsif l_regions.count > 0
            and l_regions(l_regions.count).region_name is not null
            and l_regions(l_regions.count).region_query is not null
            and l_max_rows > 0
      then
        l_regions(l_regions.count).max_rows := l_max_rows;
      elsif length(l_region_name) > 0 then
        l_regions.extend;
        l_regions(l_regions.count).region_name := l_region_name;
      end if;
      l_region_names := substr(l_region_names, l_semicolon_pos+1);
    end loop;
  else --p_region_names is null
    pak_xslt_log.WriteLog( 'Parse regions starts with p_region_names is null, p_page_id: '||p_page_id, p_procedure => 'ParseRegions');
    for r_apr in c_apr loop
      l_regions.extend;
      l_regions(l_regions.count).region_name := r_apr.region_name;
      pak_xslt_log.WriteLog( 'Parse regions find region: '||r_apr.region_name, p_procedure => 'ParseRegions');
    end loop;
  end if;
  pak_xslt_log.WriteLog( 'Parse regions finished: '||LogParsedRegions(l_regions), p_procedure => 'ParseRegions');
  return l_regions;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ParseRegions',
    p_sqlerrm => sqlerrm );
  raise;
end;

/** Get Source Query or Queries of the region(s) and resulting XML
*
* @param p_region_name Region name(s) separarted with semicolon. If null procedure uses suorces of all regions on the page.
* @param p_app_id APEX Application ID. If null current Application ID
* @param p_page_id APEX Page ID. If null current Page ID
* @param p_use_filters_hidPK 0 - Don't use filters, 1 - Use filters but include also hidden and PK columns, 2 - Just use filters.
* You want to use 1 or 0 for cross reference by hidden or PK columns inside complex XML build from multiple queries.
* @param p_html_cols Columns with HTML markup in temporary XML. 0 - Convert to text, exclude columns with image links, 1 - Exlude columns with HTML markup,
* 2 - Exclude columns with image links, preserve rest HTML markup, 3 - Preserve HTML markup, 4 - Convert to text. Default 0.
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
)
as
--columns collection
t_cols tp_cols;

--query2report collections

l_selectQueries  query2report.tab_string := query2report.tab_string();
l_maxRows  query2report.tab_integer := query2report.tab_integer();

------------------Lists to compose select---------------
--column lists
l_formatedAndLabeledColList varchar2(32767);
l_basic_col_list varchar2(32767);
l_aggr_col_list  varchar2(32767);
l_break_col_list  varchar2(32767);
l_cc_col_list  varchar2(4000);
l_highlight_case varchar2(4000);

--LOV--
l_LOV_selects varchar2(32767);
l_join_LOV_selects varchar2(32767);
l_join_LOV_filtersel varchar2(32767);

--where, order by, group by lists
l_order_by_list  varchar2(32767);
l_aggr_order_by_list  varchar2(32767);
l_group_by_col_list varchar2(32767);
l_group_by_list  varchar2(32767);
l_break_group_by_list varchar2(32767);
l_break_group_by_list_alias varchar2(32767);
l_grand_total_col_list varchar2(32767);
l_where          varchar2(32767);

--master region-------------
l_master_region_source varchar2(32767);
l_join_master_region varchar2(32767);
l_master_select_list varchar2(32767);
l_master_region_id number;
-----------------------------------------------------------

--XML attributes parameters-----
--l_aggregation boolean default false;
l_regionAttr varchar2(4000);
l_breakAttr varchar2(4000);
l_IRAttr varchar2(4000);
l_grpbyAttr varchar2(400);
l_html_cols_attr varchar2(4000);
l_img_cols_attr varchar2(4000);

l_IG boolean := false;

----rest of params -------
l_page_id number;
l_max_rows_IR PLS_INTEGER; --Query2Report.Query2Xml call
l_max_row number;  --Query2Report.Query2Xml call
l_start_time PLS_INTEGER; --debuging
l_regions tp_regions;

cursor c_apr(c_region_name varchar2) is
select * from
(
  select region_id
        , BindSSApexItem(region_name) region_name
        , region_source
        , source_type_code
        , report_column_source_type
        , page_name
        , maximum_row_count
  from apex_application_page_regions
  where application_id = APEX_APPLICATION.G_FLOW_ID--V('APP_ID') --TODO optimize
  and   page_id = p_page_id
  --and   source_type_code in ( 'UPDATABLE_SQL_QUERY', 'SQL_QUERY', 'DYNAMIC_QUERY', 'STRUCTURED_QUERY', 'FUNCTION_RETURNING_SQL_QUERY', 'NATIVE_IG' ) --'UPDATABLE_SQL_QUERY' Added by MM
  and  lower(trim(region_source))  like '%select%from%'
)
where region_name = c_region_name;

 r_apr c_apr%rowtype;

begin
  l_start_time := dbms_utility.get_time();
  l_page_id := nvl(p_page_id, V('PAGE_ID'));
  po_regionAttrs := query2report.tab_string();
  po_reportTypes := query2report.t_coltype_tables();

  l_regions := ParseRegions(p_region_name, p_page_id);

  for i in 1..l_regions.count loop --loop through all selected regions
    if l_regions(i).region_query is not null then
      pak_xslt_log.WriteLog( 'Direct Query2Report.AddQuery region name: '|| l_regions(i).region_name || ' query: ' || l_regions(i).region_query, p_procedure => 'GetSourceQueriesAndXML' );
      Query2Report.AddQuery(
        'name="'||htf.escape_sc(l_regions(i).region_name)||'"',
        l_regions(i).region_query,
        Query2Report.ReportTypesElementTab(l_regions(i).region_query),
        l_max_row,
        po_regionAttrs,
        l_selectQueries,
        po_reportTypes,
        l_maxRows
      );
    else
      --Initialization at start of the loop
      ------------------Lists to compose select---------------
      --column lists
      open c_apr(l_regions(i).region_name);
      fetch c_apr into r_apr;
      if c_apr%found then
        pak_xslt_log.WriteLog( 'found ' || r_apr.source_type_code || ' ' || r_apr.region_name, p_procedure => 'GetSourceQueriesAndXML' );
        --l_aggregation := false;
        l_basic_col_list := null;
        l_aggr_col_list  := null;
        l_break_col_list  := null;

        l_cc_col_list  := null;
        l_highlight_case := null;

        --LOV--
        l_LOV_selects := null;
        l_join_LOV_selects := null;
        l_join_LOV_filtersel := null;

        --where, order by, group by lists
        l_order_by_list  := null;
        l_aggr_order_by_list  := null;
        l_group_by_col_list := null;
        l_group_by_list  := null;
        l_break_group_by_list := null;
        l_break_group_by_list_alias := null;
        l_grand_total_col_list := null;
        l_where          := null;
        -----------------------------------------------------------

        --XML attributes parameters-----
        --l_aggregation boolean default false;
        l_regionAttr := null;
        l_breakAttr := null;
        l_IRAttr := null;
        l_grpbyAttr := null;
        l_max_rows_IR := null;
        l_max_row := null;
        l_html_cols_attr := null;
        l_img_cols_attr := null;

        --master region-------------
        l_master_region_source := null;
        l_join_master_region := null;
        l_master_select_list := null;
        l_master_region_id := null;
        -----------------------------------------------------------


        l_IG := false;


        if r_apr.source_type_code = 'FUNCTION_RETURNING_SQL_QUERY' --Select generated with function
        then
          r_apr.region_source := apex_plugin_util.get_plsql_function_result( r_apr.region_source );
          pak_xslt_log.WriteLog( r_apr.region_name||' (FUNCTION_RETURNING_SQL_QUERY): ', p_procedure => 'GetSourceQueriesAndXML' );
        elsif r_apr.source_type_code = 'DYNAMIC_QUERY' --Interactive report
        then

          IRUseFiltersOrGroupBy(
            r_apr.region_id,
            l_page_id,
            p_use_filters_hidPK,
            po_basic_col_list => l_basic_col_list,
            po_order_by_list => l_order_by_list,
            po_where => l_where,
            po_group_by_col_list => l_group_by_col_list,
            po_group_by_list => l_group_by_list
          );

          /*
          pak_xslt_log.WriteLog( 'Source before aggregate select: '||r_apr.region_source, p_procedure => 'GetSourceQueriesAndXML');
          pak_xslt_log.WriteLog( 'l_report_columns before aggregate select: '||l_basic_col_list, p_procedure => 'GetSourceQueriesAndXML');
          */
          AggregateSelect(
            r_apr.region_id,
            l_page_id,
            p_use_filters_hidPK,
            pio_basic_col_list => l_basic_col_list   ,
            po_aggr_col_list => l_aggr_col_list    ,
            po_break_col_list => l_break_col_list   ,
            po_break_group_by_list => l_break_group_by_list    ,
            po_aggr_order_by_list => l_aggr_order_by_list    ,
            po_IRAttr => l_IRAttr           ,
            po_breakAttr => l_breakAttr        ,
            po_grpbyAttr => l_grpbyAttr       ,
            po_max_rows_IR => l_max_rows_IR      ,
            po_cols => t_cols
          );

          $IF CCOMPILING.g_views_granted $THEN
          l_cc_col_list := AddComputedColumns(l_page_id, r_apr.region_id);
          $END
        --DYNAMIC_QUERY

          $IF CCOMPILING.g_IG_exists $THEN
          elsif r_apr.source_type_code = 'NATIVE_IG' then--Interactive grid
            l_IG := true;
            t_cols := IG2Report.CollectIGColumns(
               r_apr.region_id,
               l_page_id,
               p_use_filters_hidPK,
               po_IG_Attr => l_IRAttr,
               po_max_rows_IG => l_max_rows_IR
            );

            IG2Report.MasterRegionSelect(
                   r_apr.region_id,
                   t_cols,
                   po_master_region_source => l_master_region_source,
                   po_join_master_region => l_join_master_region,
                   po_master_select_list => l_master_select_list,
                   po_master_region_id => l_master_region_id
               );

            IG2Report.IGUseFilters(  --IG version of IRUseFilters
                r_apr.region_id,
                l_page_id,
                p_use_filters_hidPK,
                l_master_region_id,
                p_cols => t_cols,
                po_order_by_list => l_order_by_list,
                po_aggr_order_by_list => l_aggr_order_by_list,
                po_where => l_where
              );


              IG2Report.AggregateSelect(
                  p_cols => t_cols,
                  po_breakAttr => l_breakAttr,
                  po_basic_col_list => l_basic_col_list  ,
                  po_break_col_list => l_break_col_list,
                  po_aggr_col_list => l_aggr_col_list    ,
                  pio_aggr_order_by_list => l_aggr_order_by_list,
                  po_break_group_by_list => l_break_group_by_list,
                  po_grand_total_col_list => l_grand_total_col_list
               );
           $END


        else
          NotDynamicQuery(
            r_apr.region_id,
            l_page_id,
            p_use_filters_hidPK,
            t_cols,
            l_basic_col_list,
            l_aggr_col_list,
            l_order_by_list --,
            --l_aggregation
          );
        end if;

        l_break_group_by_list_alias := l_break_group_by_list;

        Compose_LOV_selects(
          p_cc_col_list => l_cc_col_list,
          p_where => l_where,
          p_cols => t_cols,
          p_master_region_id => l_master_region_id,
          pio_group_by_col_list  => l_group_by_col_list,
          pio_basic_col_list => l_basic_col_list,
          pio_aggr_col_list => l_aggr_col_list,
          pio_break_group_by_list => l_break_group_by_list,
          pio_where => l_where,
          pio_break_col_list    => l_break_col_list,
          po_LOV_selects => l_LOV_selects,
          po_join_LOV_selects => l_join_LOV_selects,
          po_join_LOV_filtersel => l_join_LOV_filtersel
        );

        l_formatedAndLabeledColList :=
        FormatedAndLabeledColList(
          l_page_id,
          r_apr.region_id,
          r_apr.source_type_code,
          t_cols,
          p_html_cols,
          l_breakAttr is not null,
          l_aggr_col_list is not null,
          l_grpbyAttr is not null,
          l_break_group_by_list,
          l_break_group_by_list_alias,
          po_html_cols_attr => l_html_cols_attr,
          po_img_cols_attr => l_img_cols_attr
        );

        --TODO sestavi query
        r_apr.region_source :=
        ComposeRegionQuery(
          r_apr.region_source          ,
          p_formated_labeled_col_list => l_formatedAndLabeledColList ,
          p_where => l_where  ,
          p_basic_col_list => l_basic_col_list,
          p_aggr_col_list => l_aggr_col_list,
          p_break_col_list => l_break_col_list            ,
          p_break_group_by_list => l_break_group_by_list,
          p_cc_col_list => l_cc_col_list               ,
          p_group_by_list => l_group_by_list             ,
          p_aggr_order_by_list => l_aggr_order_by_list,
          p_order_by_list => l_order_by_list,
          p_group_by_col_list => l_group_by_col_list,
          p_LOV_selects => l_LOV_selects,
          p_join_LOV_selects => l_join_LOV_selects,
          p_join_LOV_filtersel => l_join_LOV_filtersel,
          p_grand_total_col_list => l_grand_total_col_list,
          p_master_region_source => l_master_region_source,
          p_join_master_region => l_join_master_region,
          p_master_select_list => l_master_select_list,
          p_IG => l_IG
        );

        l_regionAttr := RegionAttr(
          r_apr.region_name,
          l_IRAttr,
          l_breakAttr,
          l_grpbyAttr,
          l_max_rows_IR,
          r_apr.maximum_row_count,
          l_aggr_col_list is not null,
          p_html_cols_attr => l_html_cols_attr,
          p_img_cols_attr => l_img_cols_attr,
          po_max_row => l_max_row
        );

        pak_xslt_log.WriteLog('Before Query2Report.AddQuery l_regionAttr: '||l_regionAttr||' l_max_row '||l_max_row,
                              p_procedure => 'GetSourceQueriesAndXML' );
        Query2Report.AddQuery(l_regionAttr, r_apr.region_source, ReportTypesTable(t_cols), l_max_row, po_regionAttrs, l_selectQueries, po_reportTypes, l_maxRows);
      else
         pak_xslt_log.WriteLog('Region '||l_regions(i).region_name||' not found! ',
                              p_log_type => pak_xslt_log.g_warning,
                              p_procedure => 'GetSourceQueriesAndXML' );
      end if;
      close c_apr;
    end if;
  end loop;
  pak_xslt_log.WriteLog('source SQL prepared', p_procedure => 'GetSourceQueriesAndXML', p_start_time => l_start_time);

  if p_dwld_type <> query2report.g_dwld_suorce then
    l_start_time := dbms_utility.get_time();
    po_xml := Query2Report.Query2Xml(po_regionAttrs, l_selectQueries, po_reportTypes, l_maxRows);

    if po_Xml is null then
      pak_xslt_log.WriteLog(
        'po_Xml is null',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'GetSourceQueriesAndXML'
      );
    else
        pak_xslt_log.WriteLog(
          'Query2Report.Query2Xml finished'
          ,p_procedure => 'GetSourceQueriesAndXML'
          , p_start_time => l_start_time
        );
        /*
        l_start_time := dbms_utility.get_time();
        --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug4.xml');
        query2report.xmlConvert(po_Xml);--, pio_endOffset => l_offset);
        --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug5.xml');
        pak_xslt_log.WriteLog(
          'Query2Report.ConvertXml finished'
          ,p_procedure => 'GetSourceQueriesAndXML'
          , p_start_time => l_start_time
        );
        */
    end if;
  end if;
  po_source_queries := tab_string2Clob(l_selectQueries);
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_page_id '||to_char(p_page_id)||
    ' p_use_filters_hidPK '||p_use_filters_hidPK, --||' last region '||l_region_name,
    p_log_type => pak_xslt_log.g_error, p_procedure => 'GetSourceQueriesAndXML', p_sqlerrm => sqlerrm );
  raise;
end GetSourceQueriesAndXML;

function prepareFilename(p_filename varchar2, p_page_id number)
return varchar2
as
    l_filename varchar2(400) := p_filename;
    l_page_name                varchar2(256);
    l_page_title               varchar2(256);
    l_page_alias               varchar2(256);
begin
  if instr(l_filename, '#PAGE_') > 0 then
      select page_name, page_title, page_alias
      into l_page_name, l_page_title, l_page_alias
      from apex_application_pages
      where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = p_page_id;

      l_filename := replace(l_filename, '#PAGE_NAME#', BindSSApexItem(l_page_name));
      l_filename := replace(l_filename, '#PAGE_TITLE#', BindSSApexItem(l_page_title));
      l_filename := replace(l_filename, '#PAGE_ALIAS#', l_page_alias);
  end if;
  
  l_filename := trim(substr(translate(l_filename,'?,''":;?*+()/\|&%$#! '||query2report.g_crlf,'______________________'),1, 255));
  l_filename := replace(l_filename, '__','_');
  l_filename := replace(l_filename, '_.','.');
  return l_filename;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_filename: '||p_filename||', p_page_id: '||p_page_id,
    p_log_type => pak_xslt_log.g_error, p_procedure => 'prepareFilename', p_sqlerrm => sqlerrm );
  rollback;
  raise;
end;

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
return BLOB
as

l_xml CLOB;
l_ret BLOB;
l_source_queries CLOB;
l_start_time PLS_INTEGER;
l_regionAttrs query2report.tab_string;
l_reportTypes query2report.t_coltype_tables;
begin

  if p_log_level is not null then
    pak_xslt_log.SetLevel(p_log_level);
  end if;

  pak_xslt_log.WriteLog( 'GetApexReport started ',
                                p_procedure => 'GetApexReport'
                              );

  if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.g_dwld_xml_copyto_xpm, Query2Report.g_dwld_transformed, Query2Report.g_dwld_suorce) then
    GetSourceQueriesAndXML(
      p_region_name => p_region_name,
      p_page_id => p_page_id,
      p_use_filters_hidPK => p_use_filters_hidPK,
      p_html_cols => p_html_cols,
      p_dwld_type => p_dwld_type,
      po_xml => l_xml,
      po_source_queries => l_source_queries,
      po_regionAttrs    => l_regionAttrs,
      po_reportTypes => l_reportTypes
    );
    if p_dwld_type <> Query2Report.g_dwld_suorce 
       and (l_Xml is null or nvl(instr(l_Xml, '<ROW>'), 0) = 0) --
    then
        pak_xslt_log.WriteLog(
          'l_Xml is null or empty',
          p_log_type => pak_xslt_log.g_error,
          p_procedure => 'GetApexReport'
        );
        return null;
    end if;

    pak_xslt_log.WriteLog( p_description => 'GetApexReport started - l_reportTypes: '||PAK_XML_CONVERT.LogColTypes(l_reportTypes),
                                p_procedure => 'GetApexReport'
                              );

    pak_xslt_log.WriteLog( p_description => 'GetApexReport started - l_regionAttrs(1): '||l_regionAttrs(1),
                                p_procedure => 'GetApexReport'
                              );


    if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.g_dwld_xml_copyto_xpm) then
      p_filename := Query2Report.XMLOrSourceFilename(p_page_id, l_regionAttrs);
      l_start_time := dbms_utility.get_time();
      --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug4.xml');
      pak_xslt_log.WriteLog( p_description => 'Before query2report.xmlConvert - l_regionAttrs(1): '||l_regionAttrs(1),
                                p_procedure => 'GetApexReport'
                              );
      pak_xml_convert.xmlConvert(l_Xml, p_filename, l_regionAttrs, l_reportTypes);--, pio_endOffset => l_offset);
      --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug5.xml');
      pak_xslt_log.WriteLog(
        'Query2Report.ConvertXml finished'
        ,p_procedure => 'GetApexReport'
        , p_start_time => l_start_time
      );
      l_ret := pak_blob_util.clob2blob(l_xml);
      if p_dwld_type = Query2Report.g_dwld_xml_copyto_xpm then
        Query2Report.insert_xpm_xml(p_filename, l_xml);
      end if;
    elsif p_dwld_type = Query2Report.g_dwld_suorce then
      p_filename := Query2Report.XMLOrSourceFilename(p_page_id, l_regionAttrs);
      l_ret := pak_blob_util.clob2blob(l_source_queries);
    else
		p_filename := prepareFilename(p_filename, p_page_id);													 
        l_ret := Query2Report.XslTransform(
          p_Xml => l_xml,
          p_xsltStaticFile => p_xsltStaticFile,
          p_page_id => p_page_id,
          p_region_name => p_region_name,
          p_filename => p_filename,
          pi_regionAttrs => l_regionAttrs,
          pi_reportTypes => l_reportTypes,
          p_format => p_format,
          p_templateStaticFile => p_templateStaticFile, --default null,
          p_external_params => p_external_params,
          p_second_XsltStaticFile => p_second_XsltStaticFile,
          p_second_external_params => p_second_external_params --,
          --p_convertblob_param => p_convertblob_param
        );


        pak_xslt_log.WriteLog( 'Query2Report.XslTransform finished ',
                                  p_procedure => 'GetApexReport',
                                  p_start_time => l_start_time
                                );
    end if;
    --if p_dwld_type in (Query2Report.g_dwld_xslt, Query2Report.g_dwld_second_xslt) do nothing, return null.
  end if;

  pak_xslt_log.WriteLog( 'GetApexReport finished ',
                                p_procedure => 'GetApexReport'
                              );
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_use_filters_hidPK '||p_use_filters_hidPK,
    p_log_type => pak_xslt_log.g_error, p_procedure => 'GetApexReport', p_sqlerrm => sqlerrm );
  rollback;
  raise;
end;


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
procedure DownloadApexReport(
  p_xsltStaticFile            IN  varchar2,
  p_filename                  in  VARCHAR2,
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
  p_run_in_background         IN  boolean default false,
  p_log_level                 IN  number default null,
  p_convertblob_param       IN varchar2 default null
)
as

l_second_file_id number;
l_xml CLOB;
l_source_queries CLOB;
l_start_time PLS_INTEGER;
l_regionAttrs query2report.tab_string;
l_reportTypes query2report.t_coltype_tables;
l_filename varchar2(4000);
l_plsql varchar2(4000);
l_id_temporary_xml number;
l_job_exists number;
begin

  if p_log_level is not null then
    pak_xslt_log.SetLevel(p_log_level);
  end if;

  pak_xslt_log.WriteLog( 'DownloadApexReport started ',
                                p_procedure => 'DownloadApexReport'
                              );

  if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.g_dwld_xml_copyto_xpm, Query2Report.g_dwld_transformed, Query2Report.g_dwld_suorce) then
    GetSourceQueriesAndXML(
      p_region_name => p_region_name,
      p_page_id => p_page_id,
      p_use_filters_hidPK => p_use_filters_hidPK,
      p_html_cols => p_html_cols,
      p_dwld_type => p_dwld_type,
      po_xml => l_xml,
      po_source_queries => l_source_queries,
      po_regionAttrs    => l_regionAttrs,
      po_reportTypes => l_reportTypes
    );
    if p_dwld_type <> Query2Report.g_dwld_suorce and l_Xml is null then
    pak_xslt_log.WriteLog(
      'l_Xml is null',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'DownloadApexReport'
    );
    end if;

    pak_xslt_log.WriteLog( p_description => 'DownloadApexReport started - l_reportTypes: '||PAK_XML_CONVERT.LogColTypes(l_reportTypes),
                                p_procedure => 'DownloadApexReport'
                              );

    pak_xslt_log.WriteLog( p_description => 'DownloadApexReport started',
                                p_procedure => 'DownloadApexReport'
                              );


    if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.g_dwld_xml_copyto_xpm) then
      l_filename := Query2Report.XMLOrSourceFilename(p_page_id, l_regionAttrs);
      l_start_time := dbms_utility.get_time();
      --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug4.xml');
      pak_xslt_log.WriteLog( p_description => 'Before query2report.xmlConvert',
                                p_procedure => 'DownloadApexReport'
                              );
      pak_xml_convert.xmlConvert(l_Xml, p_filename, l_regionAttrs, l_reportTypes);--, pio_endOffset => l_offset);
      --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug5.xml');
      pak_xslt_log.WriteLog(
        'Query2Report.ConvertXml finished'
        ,p_procedure => 'DownloadApexReport'
        , p_start_time => l_start_time
      );
      Query2Report.DownloadConvertOutput(APEX_APPLICATION.G_FLOW_ID,  pak_blob_util.clob2blob(l_xml), l_filename||'.xml', 'text/xml');
      if p_dwld_type = Query2Report.g_dwld_xml_copyto_xpm then
        Query2Report.insert_xpm_xml(l_filename, l_xml);
      end if;
    elsif p_dwld_type = Query2Report.g_dwld_suorce then
      l_filename := Query2Report.XMLOrSourceFilename(p_page_id, l_regionAttrs);
      Query2Report.DownloadConvertOutput(APEX_APPLICATION.G_FLOW_ID, pak_blob_util.clob2blob(l_source_queries), l_filename||'.sql', 'text/plain');
    else
      select count(*) into l_job_exists
      from user_scheduler_jobs
      where upper(job_name) = 'JOB_XSLTRANSFORMANDDOWNLOAD'
      and upper(program_name) = 'PROG_XSLTRANSFORMANDDOWNLOAD';

      if p_run_in_background and l_job_exists = 1 then
        insert into temporary_xml (XMLCLOB) values(l_xml)
        returning id_temporary_xml into l_id_temporary_xml;
        commit;

        Query2Report.XslTransformAndDownloadJob(
          p_id_temporary_xml => l_id_temporary_xml,
          p_xsltStaticFile => p_xsltStaticFile,
          p_page_id => p_page_id,
          p_region_name => p_region_name,
          p_filename => p_filename,
          p_regionAttrs => l_regionAttrs,
          p_reportTypes => l_reportTypes,
          p_format => p_format,
          p_templateStaticFile => p_templateStaticFile, --default null,
          p_external_params => p_external_params,
          p_second_XsltStaticFile => p_second_XsltStaticFile,
          p_second_external_params => p_second_external_params,
          p_convertblob_param => p_convertblob_param,
          p_log_level => p_log_level
        );
      else
        l_start_time := dbms_utility.get_time();
        if p_run_in_background then
           pak_xslt_log.WriteLog( 'Job JOB_XSLTRANSFORMANDDOWNLOAD is not installed! Can not run in background.',
           p_log_type => pak_xslt_log.g_warning,
           p_procedure => 'DownloadApexReport');
        end if;
        Query2Report.XslTransformAndDownload(
          p_Xml => l_xml,
          p_xsltStaticFile => p_xsltStaticFile,
          p_page_id => p_page_id,
          p_region_name => p_region_name,
          p_filename => p_filename,
          pi_regionAttrs => l_regionAttrs,
          pi_reportTypes => l_reportTypes,
          p_format => p_format,
          p_templateStaticFile => p_templateStaticFile, --default null,
          p_external_params => p_external_params,
          p_second_XsltStaticFile => p_second_XsltStaticFile,
          p_second_external_params => p_second_external_params,
          p_convertblob_param => p_convertblob_param
        );



        pak_xslt_log.WriteLog( 'Query2Report.XslTransformAndDownload finished ',
                                  p_procedure => 'DownloadApexReport',
                                  p_start_time => l_start_time
                                );
      end if;
    end if;
  else
    Query2Report.DownloadStaticFile(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      --p_BBFile,
      --p_BB_no_esc_sc,
      p_dwld_type,
      --p_mime,
      p_format
    );
  end if;

  pak_xslt_log.WriteLog( 'DownloadApexReport finished ',
                                p_procedure => 'DownloadApexReport'
                              );
  commit;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error p_use_filters_hidPK '||p_use_filters_hidPK,
    p_log_type => pak_xslt_log.g_error, p_procedure => 'DownloadApexReport', p_sqlerrm => sqlerrm );
  rollback;
  raise;
end;

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
  * @param  p_process.attribute_13 Template Static File
  * @param p_process.attribute_14 Log level
  * @param p_process.attribute_15 P_PARAM Parameter of ConvertCLOB procedure
  */
function Region2XSLTReport(
    p_process in apex_plugin.t_process,
    p_plugin  in apex_plugin.t_plugin )
    return apex_plugin.t_process_exec_result
AS
  l_xsltStaticFile          varchar2(256);
  l_filename               varchar2(256);
  l_page_id                 number;
  l_dwld_type               number  ;
  l_use_filters_hidPK       number  ;
  l_html_cols               number;
  l_region_name             varchar2(32000);
  l_format                  number  ;
  l_external_params         varchar2(1000);
  l_second_XsltStaticFile    varchar2(256);
  l_second_external_params   varchar2(1000);
  l_run_in_background        boolean;
  l_log_level                number;
  l_convertclob_param        varchar2(4000);
  l_templateStaticFile       varchar2(256);
  
  l_ret apex_plugin.t_process_exec_result;
begin

  l_xsltStaticFile        := p_process.attribute_01;      --Text
  l_filename             := p_process.attribute_02;      --text
  l_page_id               := p_process.attribute_11;      --Number

  l_filename := prepareFilename(l_filename, l_page_id);

  l_dwld_type             := p_process.attribute_03;      --LOV   default Query2Report.g_dwld_transformed (0)
  l_use_filters_hidPK     := p_process.attribute_04;      --LOV   default g_filters (2)
  l_html_cols             := p_process.attribute_05;      --number  default 0
  l_region_name           := p_process.attribute_06;      --text  default null means current region
  l_format                := p_process.attribute_07;      --LOV   default Query2Report.F_TEXT (0)
  l_external_params       := p_process.attribute_08;      --text  default null means no params
  if p_process.attribute_09 is not null then
    l_second_XsltStaticFile  := p_process.attribute_09;    --text  default null means no second XSLT
  end if;
  l_second_external_params := p_process.attribute_10;      --text default null means no params for second XSLT
  l_run_in_background      := (upper(p_process.attribute_12) = 'Y');      --Y/N default N if Y means XSL process and ConvertBlob will run in separate job

  l_templateStaticFile     := p_process.attribute_13;

  l_log_level              := p_process.attribute_14;      --Number
  l_convertclob_param      := p_process.attribute_15;      --text

  DownloadApexReport(
    p_xsltStaticFile => l_xsltStaticFile,
    p_filename => l_filename,
    p_page_id => l_page_id,
    p_dwld_type => l_dwld_type,
    p_use_filters_hidPK => l_use_filters_hidPK,
    p_html_cols => l_html_cols,
    p_region_name => l_region_name,
    p_format => l_format,
    p_templateStaticFile => l_templateStaticFile,
    p_external_params => l_external_params,
    p_second_XsltStaticFile => l_second_XsltStaticFile,
    p_second_external_params => l_second_external_params,
    p_log_level => l_log_level,
    p_run_in_background => l_run_in_background,
    p_convertblob_param => l_convertclob_param
  );

  l_ret.success_message := p_process.success_message;
  return l_ret;
exception
    when others then
    if l_second_XsltStaticFile is null then
      l_ret.success_message := 'Error when transforming on region '||V('REGION')||
        ' with '||l_xsltStaticFile;
    else
      l_ret.success_message := 'Error when transforming on region '||V('REGION')||
        ' with '||l_xsltStaticFile ||' and then with '||l_second_xsltStaticFile;
    end if;

    pak_xslt_log.WriteLog(l_ret.success_message, p_log_type => pak_xslt_log.g_error, p_procedure => 'Region2XSLTReport', p_sqlerrm => sqlerrm );

    l_ret.success_message := l_ret.success_message||' SQLERR: '||sqlerrm;

    return l_ret;
END Region2XSLTReport;

END APEXREP2REPORT;
/
