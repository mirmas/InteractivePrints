
CREATE OR REPLACE package body IG2REPORT is

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
  
$IF CCOMPILING.g_IG_exists $THEN

/**Procedure adds columns with same aggregation function (SUM, AVG...) to the table of aggregation columns
* for later use .TODO preveri ali je sploh potrebna
*
* @param pio_t_cols_aggr table of of aggregation columns
* @param p_aggr_cols Aggregation columns separated with :
* @param p_aggregation Aggregation function (SUM, AVG...)
*/
/*
procedure FillAggrColsTable
(
  pio_t_cols_aggr in out APEXREP2REPORT.tp_cols_aggr
  ,p_aggr_col in varchar2
  ,p_aggregation in varchar2
)
as
t_strtbl APEXREP2REPORT.tp_strtbl := APEXREP2REPORT.tp_strtbl();
begin
  if p_aggr_col is not null then
      pio_t_cols_aggr.extend;
      pio_t_cols_aggr(pio_t_cols_aggr.count).column_alias := p_aggr_col;
      pio_t_cols_aggr(pio_t_cols_aggr.count).aggregation := p_aggregation;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.FillAggrColsTable', p_sqlerrm => sqlerrm );
  raise;
end FillAggrColsTable;
*/

/** Bind (compose) sort statement for use in ORDER BY statement in IR suorce in ordinary (non GOUP BY) mode
*
* @param p_apr row of current report in apex_application_page_ir_rpt view
* @param p_already_order_by true if ORDER BY already exists
*/
procedure BindSort(
  p_report_id number,
  p_use_filters_hidPK number,
  p_master_report_id number,
  po_order_by_list out varchar2,
  po_aggr_order_by_list out varchar2
)
as
--l_sort varchar2(4000);
--l_break boolean := false;

cursor c_cur_break is
    select  case rcol.report_id when p_master_report_id then substr(col.NAME,1,30-length('_MASTER'))||'_MASTER' else col.NAME end as column_alias,
        case rcol.report_id when p_master_report_id then nvl(rcol.sort_order - 1000, 0) else rcol.break_order end sort_order,
        case rcol.report_id when p_master_report_id then nvl(rcol.sort_direction, 'ASC') else rcol.break_sort_direction end sort_direction,
        case rcol.report_id when p_master_report_id then nvl(rcol.sort_nulls, 'last') else nvl(rcol.break_sort_nulls, 'last') end sort_nulls
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (p_report_id, p_master_report_id)
        where rcol.break_order is not null or rcol.report_id = p_master_report_id
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and (p_use_filters_hidPK = 0
        			or (p_use_filters_hidPK = 1 and (((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        																				/*or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN'*/)
        					)
        			or (p_use_filters_hidPK = 2 and ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        																			  /*and nvl(col.IS_PRIMARY_KEY, 'No') = 'No'*/ and col.item_type != 'NATIVE_HIDDEN'
        																			)
        					)

        		)
        order by sort_order;

cursor c_cur is
    select  col.HEADING as fullname,
        col.NAME as column_alias,
        0 BREAK,
        rcol.sort_order,
        rcol.sort_direction,
        rcol.sort_nulls
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id = p_report_id
        where rcol.sort_order is not null
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and (p_use_filters_hidPK = 0
        			or (p_use_filters_hidPK = 1 and (((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        																				/*or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN'*/)
        					)
        			or (p_use_filters_hidPK = 2 and ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        																			  /*and nvl(col.IS_PRIMARY_KEY, 'No') = 'No'*/ and col.item_type != 'NATIVE_HIDDEN'
        																			)
        					)

        		)
        order by sort_order;


begin
--add sorting in source
  po_order_by_list := null;
  po_aggr_order_by_list := null;

  for r_cur_break in c_cur_break loop
      if po_aggr_order_by_list is null then
          po_aggr_order_by_list := ' "' || r_cur_break.column_alias || '" ' || rtrim(r_cur_break.sort_direction, 'ending') || ' nulls '|| r_cur_break.sort_nulls ;
      else
          po_aggr_order_by_list := po_aggr_order_by_list || ', "' || r_cur_break.column_alias || '" ' || rtrim(r_cur_break.sort_direction, 'ending') || ' nulls '|| r_cur_break.sort_nulls ;
      end if;
  end loop;

  for r_cur in c_cur loop
      if po_order_by_list is null then
          po_order_by_list := ' "' || r_cur.column_alias || '" ' || rtrim(r_cur.sort_direction, 'ending') || ' nulls '|| r_cur.sort_nulls ;
      else
          po_order_by_list := po_order_by_list || ', "' || r_cur.column_alias || '" ' || rtrim(r_cur.sort_direction, 'ending') || ' nulls '|| r_cur.sort_nulls ;
      end if;
  end loop;
  pak_xslt_log.WriteLog( 'p_report_id: '||p_report_id||' p_master_report_id: '||p_master_report_id||
                        ' return po_order_by_list: '||po_order_by_list||' po_aggr_order_by_list: '||
                        po_aggr_order_by_list, p_procedure => 'IG2Report.BindSort');
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'IG2Report.BindSort', p_sqlerrm => sqlerrm );
  raise;
end;

/** Returns row from apex_appl_page_ig_rpts table which describe user current report of region p_region_id.
*
* @param p_region_id Region ID.
* @param p_page_id APEX Page ID.
* @return Row from apex_application_page_ir_rpt table which describe current report of region p_region_id.
*/
function Get_current_report_row(
   p_region_id in number,
   p_page_id in number
)
return apex_appl_page_ig_rpts%rowtype
as
  t_pref varchar2(200);
  l_report_id number;
  t_apr apex_appl_page_ig_rpts%rowtype;
begin
  /*
  select api.interactive_report_id
  into t_interactive_report_id
  from apex_application_page_ir api
  where api.application_id = APEX_APPLICATION.G_FLOW_ID
  and   api.page_id = p_page_id
  and   api.region_id = p_region_id;
  */

  --APEX_IG_3172633674777884571_CURRENT_REPORT	6100670905189984406:GRID
  --APEX_IG_9160334486836517512_CURRENT_REPORT	5384892718947538237:GRID
--
  pak_xslt_log.WriteLog( 'Start for p_region_id : '||p_region_id||
                        ' p_page_id : '||p_page_id, p_procedure => 'IG2Report.Get_current_report_row');
  t_pref := apex_util.get_preference( 'APEX_IG_' || to_char(p_region_id) || '_CURRENT_REPORT');

  if t_pref is null then
    pak_xslt_log.WriteLog( 'User preference t_pref is null', p_procedure => 'IG2Report.Get_current_report_row');

    select *
    into t_apr
    from
    (
      select *
      from apex_appl_page_ig_rpts apr
      where apr.application_id = APEX_APPLICATION.G_FLOW_ID
      and   apr.page_id = p_page_id
      and   nvl(apr.APPLICATION_USER, V('APP_USER'))  = V('APP_USER')
      and   nvl(apr.session_id, V('SESSION')) = V('SESSION')
      and   apr.region_id = p_region_id
      order by apr.report_id desc
    ) where rownum = 1;
  else
    l_report_id := rtrim(t_pref, ':GRID');

    pak_xslt_log.WriteLog( 'User preference t_pref is NOT null l_report_id '||l_report_id, p_procedure => 'IG2Report.Get_current_report_row');

    select *
    into t_apr
    from apex_appl_page_ig_rpts apr
    where apr.application_id = APEX_APPLICATION.G_FLOW_ID
    and   apr.page_id = p_page_id
    and   nvl(apr.APPLICATION_USER, V('APP_USER'))  = V('APP_USER')
    and   apr.region_id = p_region_id
    and   apr.report_id = l_report_id
    and   nvl(apr.session_id, V('SESSION')) = V('SESSION');
  end if;

  return t_apr;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.Get_current_report_row', p_sqlerrm => sqlerrm );
  raise;
end Get_current_report_row;

function GetLOVSelect(
  p_app_id number,
  p_col_alias varchar2,
  p_LOV_ID APEX_APPL_PAGE_IG_COLUMNS.LOV_ID%type,
  p_LOV_SOURCE APEX_APPL_PAGE_IG_COLUMNS.LOV_SOURCE%type
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
  if p_LOV_ID is not null then --named LOV
    select list_of_values_query, lov_type
    into l_LOV_query, l_LOV_type
    from apex_application_lovs
    where application_id = p_app_id
    and lov_id = p_LOV_ID;

    if l_lov_type = 'Static' and p_app_id is not null then --static named LOV
      l_LOV_query := 'select display_value d, trim(return_value) v from APEX_APPLICATION_LOV_ENTRIES where application_id = '||
        p_app_id||' and lov_id = '||p_LOV_ID;
      l_static := true;
    end if;
  elsif p_LOV_SOURCE is not null then --not named LOV
    if substr(upper(trim(p_LOV_SOURCE)),1,6) = 'SELECT' then --dynamic named LOV
      l_LOV_query := p_LOV_SOURCE;
    elsif substr(upper(trim(p_LOV_SOURCE)),1,6) = 'STATIC'  --static named LOV
          and instr(p_LOV_SOURCE,';') > 0
          and instr(p_LOV_SOURCE,':') > 0
    then --STATIC:President;1,Member;0
      l_static_LOV := substr(p_LOV_SOURCE, instr(p_LOV_SOURCE,':')+1); --President;1,Member;0
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
    l_LOV_query := APEXREP2REPORT.LOVSuperSelect(l_LOV_query);
  end if;
  return l_LOV_query;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2REPORT.GetLOVSelect', p_sqlerrm => sqlerrm );
  raise;
end;

function BuildCondition(
    p_column_alias APEX_APPL_PAGE_IG_COLUMNS.NAME%type,
    p_type_code APEX_APPL_PAGE_IG_RPT_FILTERS.TYPE_CODE%type,
    p_expression APEX_APPL_PAGE_IG_RPT_FILTERS.EXPRESSION%type,
    p_operator APEX_APPL_PAGE_IG_RPT_FILTERS.OPERATOR%type,
    p_column_type APEX_APPL_PAGE_IG_COLUMNS.DATA_TYPE%type,
    p_is_case_sensitive APEX_APPL_PAGE_IG_RPT_FILTERS.IS_CASE_SENSITIVE%type,
    p_cols APEXREP2REPORT.tp_cols default null
)
return varchar2
as
    l_operator varchar2(4000);
    l_expression varchar2(4000);
    l_row_string varchar2(32000);
    l_row_string_cs varchar2(32000);
    l_not varchar2(10);
    l_cs varchar2(1);
    l_limit_date varchar2(4000);
begin

    if p_type_code = 'COLUMN' then
        if p_operator = 'REGEXP' then
            if p_is_case_sensitive = 'No' then
                l_cs := 'i';
            end if;
            l_expression := ' REGEXP_LIKE ( '||p_column_alias||', '''||p_expression||''', ''m'||l_cs||''')';
        else
            if p_operator = 'N' then
                l_expression := 'is null';
            else
                if p_operator != 'NEXT' and substr(p_operator, 1, 1) = 'N' then
                    l_not := 'not';
                    l_operator := substr(p_operator, 2);
                else
                    l_operator := p_operator;
                end if;
                if l_operator = 'N' then
                    l_operator := 'is null';
                elsif l_operator = 'BETWEEN' then
                    if p_column_type = 'VARCHAR2' then
                        l_expression := ''''||replace(p_expression, '~',''' AND ''')||'''' ;
                    elsif p_column_type = 'DATE' then
                        l_expression := 'to_date('''||replace(p_expression, '~',''',''YYYYMMDDhh24miss'') AND to_date(''')||''',''YYYYMMDDhh24miss'')' ;
                    else
                        l_expression := replace(p_expression, '~',' AND ');
                    end if;
                elsif l_operator = 'S' then
                    l_operator := 'like';
                    l_expression := ''''||p_expression||'%''';
                elsif l_operator = 'C' then
                    l_operator := 'like';
                    l_expression := '''%'||p_expression||'%''';
                elsif l_operator = 'IN' then
                    if p_column_type = 'DATE' then
                        l_expression := 'to_date('''||replace(replace(p_expression, CHR(13) || CHR(10) ,
                                                             ''',''YYYYMMDDhh24miss'') , to_date('''), CHR(10) ,''',''YYYYMMDDhh24miss'') AND to_date(''')||
                                                             ''',''YYYYMMDDhh24miss'')';
                    else
                        l_expression := '('''||replace(replace(replace(p_expression, CHR(13) || CHR(10) ,''' , '''), CHR(10) ,''' , '''), CHR(1) ,''' , ''')||''')';
                    /*
                    else
                        l_expression := '('||replace(replace(replace(p_expression, CHR(13) || CHR(10) ,' , '), CHR(10) ,' , '), CHR(1) ,' , ')||')';
                    */
                    end if;
                elsif l_operator in ('GTE', 'LTE', 'GT', 'LT', 'EQ') then
                    if p_column_type = 'VARCHAR2' then
                        l_expression := ''''||p_expression||'''';
                    elsif p_column_type = 'DATE' then
                        l_expression := 'to_date('''||p_expression||''',''YYYYMMDDhh24miss'')';
                    else
                        l_expression := p_expression;
                    end if;
                    l_operator := case l_operator when 'GTE' then '>=' when 'GT' then '>' when 'LTE' then '<=' when 'LT' then '<' when 'EQ' then '=' end;
                elsif l_operator in ('NEXT', 'LAST') then
                    l_limit_date := replace(replace(replace(replace(replace(replace(replace(p_expression, '~', '*'),'D','1'),'H','1/24'),'MI','1/(24*60)'),'W','7'), 'M', '30'),'Y', '365');
                    if l_operator = 'NEXT' then
                        l_expression := 'SYSDATE AND SYSDATE + '||l_limit_date;
                    elsif l_operator = 'LAST' then
                        l_expression := 'SYSDATE - '||l_limit_date||' AND SYSDATE ';
                    end if;
                    l_operator := 'BETWEEN';
                end if;
            end if;

            if p_is_case_sensitive = 'No' and ((p_column_type = 'VARCHAR2' and l_operator != 'IN') or l_operator = 'like') then
                l_expression := 'lower('||p_column_alias||') '||l_operator||' '||lower(l_expression);
            else
                l_expression := p_column_alias||' '||l_operator||' '||l_expression;
            end if;

            pak_xslt_log.WriteLog('l_expression: '||l_expression||' p_column_alias: '||p_column_alias||' p_expression: '||
                                  p_expression||' p_operator: '||p_operator, p_procedure => 'IG2Report.BuildCondition');
        end if; --Not REGEXP

    elsif p_type_code = 'ROW' then
        --row filter
        for i in 1..p_cols.count loop
          if p_cols(i).col_type != 'VARCHAR2' then
              if l_row_string is null then
                  l_row_string := 'lower('||p_cols(i).alias||')';
                  l_row_string_cs := p_cols(i).alias;
              else
                  l_row_string := l_row_string||'||'',''||lower('||p_cols(i).alias||')';
                  l_row_string_cs := l_row_string_cs||'||'',''||'||p_cols(i).alias;
              end if;
          elsif p_cols(i).col_type != 'NUMBER' then
              if l_row_string is null then
                  l_row_string := 'to_char('||p_cols(i).alias||')';
                  l_row_string_cs := 'to_char('||p_cols(i).alias||')';
              else
                  l_row_string := l_row_string||'||'',''||to_char('||p_cols(i).alias||')';
                  l_row_string_cs := l_row_string_cs||'||'',''||to_char('||p_cols(i).alias||')';
              end if;
          end if;
        end loop;

        if p_is_case_sensitive = 'No' then
          l_expression := 'instr('||l_row_string||','''||lower(p_expression)||''') > 0';
        else
          l_expression := 'instr('||l_row_string_cs||','''||p_expression||''') > 0';
        end if;
    end if;

    return l_not||' '||l_expression;

exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2REPORT.BuildCondition', p_sqlerrm => sqlerrm );
  raise;
end BuildCondition;

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
)
as
  t_base_report_id number;
  t_pref varchar2(32767);
  --po_where varchar2(32767);
  t_search varchar2(32767);
  --t_break_cols tp_strtbl;
 l_report_id number;
 l_master_report_id number;

  --filters or searches (conditions) for this versions of IG

  cursor c_con(c_report_id number) is
  select  col.NAME as column_alias,
        col.data_type as column_type,
        f.OPERATOR, f.IS_CASE_SENSITIVE,
        f.EXPRESSION, f.IS_ENABLED
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id
        join APEX_APPL_PAGE_IG_RPT_FILTERS f on f.report_id = rcol.report_id and f.column_id = rcol.column_id
  where f.report_id = c_report_id and f.TYPE_CODE = 'COLUMN';

  cursor c_con_row(c_report_id number) is
  select f.IS_CASE_SENSITIVE,
        f.EXPRESSION, f.IS_ENABLED
        from APEX_APPL_PAGE_IG_RPT_FILTERS f
        where f.report_id = c_report_id and f.TYPE_CODE = 'ROW';

 l_expression varchar2(4000);

begin
  --build where sentence from Filter and Search--
  pak_xslt_log.WriteLog( 'Start for p_region_id : '||p_region_id||
                        ' p_page_id : '||p_page_id, p_procedure => 'IG2Report.IGUseFilters');
  po_where := '';
  po_order_by_list := '';
  l_report_id := Get_current_report_row(p_region_id, p_page_id).report_id;

  if p_master_region_id is not null then
      l_master_report_id := Get_current_report_row(p_master_region_id, p_page_id).report_id;
  end if;

  if p_use_filters_hidPK > 0 then
      for r_con in c_con(l_report_id)
      loop
          l_expression := BuildCondition(
                r_con.column_alias,
                'COLUMN',
                r_con.expression,
                r_con.operator,
                r_con.column_type,
                r_con.is_case_sensitive
          );

          if po_where is null then
              po_where := l_expression;
          else
              po_where := po_where ||' and '|| l_expression;
          end if;
      end loop;

      for r_con_row in c_con_row(l_report_id)
      loop
          l_expression := BuildCondition(
                null,
                'ROW',
                r_con_row.expression,
                null,
                null,
                r_con_row.is_case_sensitive,
                p_cols
          );

          if po_where is null then
              po_where := l_expression;
          else
              po_where := po_where ||' and '||l_expression;
          end if;
      end loop;
  end if;

  BindSort(l_report_id, p_use_filters_hidPK, l_master_report_id, po_order_by_list, po_aggr_order_by_list);

exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.IGUseFilters', p_sqlerrm => sqlerrm );
  raise;
end IGUseFilters; --end of block Use of filters in select

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
  p_column_alias APEX_APPL_PAGE_IG_COLUMNS.NAME%type,
  p_column_heading APEX_APPL_PAGE_IG_COLUMNS.HEADING%type,
  p_type_code APEX_APPL_PAGE_IG_RPT_FILTERS.TYPE_CODE%type,
  p_expression APEX_APPL_PAGE_IG_RPT_FILTERS.EXPRESSION%type,
  p_operator APEX_APPL_PAGE_IG_RPT_FILTERS.OPERATOR%type,
  p_column_type APEX_APPL_PAGE_IG_COLUMNS.DATA_TYPE%type,
  p_is_case_sensitive APEX_APPL_PAGE_IG_RPT_FILTERS.IS_CASE_SENSITIVE%type,
  p_condition_name APEX_APPL_PAGE_IG_RPT_HIGHLTS.NAME%type,
  p_column_id APEX_APPL_PAGE_IG_RPT_HIGHLTS.COLUMN_ID%type,
  p_background_color APEX_APPL_PAGE_IG_RPT_HIGHLTS.BACKGROUND_COLOR%type,
  p_text_color APEX_APPL_PAGE_IG_RPT_HIGHLTS.TEXT_COLOR%type,
  p_cols APEXREP2REPORT.tp_cols default null
)
return varchar2
as
l_expression varchar2(32000);
begin
  l_expression := BuildCondition(
    p_column_alias,
    p_type_code,
    p_expression,
    p_operator,
    p_column_type,
    p_is_case_sensitive,
    p_cols
 );

 return
  ' (case when '||l_expression||
  ' then ''highlight_name="'||p_condition_name||'" '||
  'highlight_col="'||Query2Report.ConvertColName2XmlName(p_column_heading)||'" '||
  'highlight_cell="'||
 case when p_column_id is not null then 'true' else 'false' end||'" '||
  'highlight_bkg_color="'||p_background_color||'" '||
  'highlight_font_color="'||p_text_color||'"'' end) ';
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'GetHighlightCase', p_sqlerrm => sqlerrm );
  raise;
end GetHighlightCase;

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
return varchar2
as
l_highlight_case varchar2(32767);
l_report_id number;

cursor c_highlights(c_report_id number) is
  select col.NAME as column_alias,
        col.heading as column_heading,
        col.data_type as column_type,
    h.name, h.column_id, h.execution_seq,
    h.BACKGROUND_COLOR, h.TEXT_COLOR, h.CONDITION_TYPE, h.CONDITION_TYPE_CODE, h.CONDITION_COLUMN_ID,
    h.CONDITION_OPERATOR, h.CONDITION_IS_CASE_SENSITIVE, h.CONDITION_EXPRESSION
    from APEX_APPL_PAGE_IG_COLUMNS col
    join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id
    join APEX_APPL_PAGE_IG_RPT_HIGHLTS h on h.report_id = rcol.report_id and h.condition_column_id = rcol.column_id
    where h.CONDITION_TYPE_CODE = 'COLUMN'
    and h.region_id = p_region_id
    and h.report_id = c_report_id
    and h.page_id = p_page_id
    and h.IS_ENABLED = 'Yes'
    union
    select null as column_alias,
           null as column_heading,
           null as column_type,
    h.name, h.column_id, h.execution_seq,
    h.BACKGROUND_COLOR, h.TEXT_COLOR, h.CONDITION_TYPE, h.CONDITION_TYPE_CODE, h.CONDITION_COLUMN_ID,
    h.CONDITION_OPERATOR, h.CONDITION_IS_CASE_SENSITIVE, h.CONDITION_EXPRESSION
    from APEX_APPL_PAGE_IG_RPT_HIGHLTS h
    where h.CONDITION_TYPE_CODE = 'ROW'
    and h.region_id = p_region_id
    and h.report_id = c_report_id
    and h.page_id = p_page_id
    and h.IS_ENABLED = 'Yes'
    order by execution_seq;

begin
  l_report_id := Get_current_report_row(p_region_id, p_page_id).report_id;

  for r_highlights in c_highlights(l_report_id) loop
    l_highlight_case := l_highlight_case||
                        GetHighlightCase(
                          r_highlights.column_alias,
                          r_highlights.column_heading,
                          r_highlights.condition_type_code,
                          r_highlights.condition_expression,
                          r_highlights.condition_operator,
                          r_highlights.column_type,
                          r_highlights.condition_is_case_sensitive,
                          r_highlights.name,
                          r_highlights.column_id,
                          r_highlights.background_color,
                          r_highlights.text_color,
                          p_cols
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
    p_procedure => 'IG2REPORT.GetHighlightCaseAll',
    p_sqlerrm => sqlerrm );
  raise;
end GetHighlightCaseAll;

/* TODO future, if we want to display pictures*/
function HtmlBindColumn(p_attribute_01 varchar2)
return varchar2
as
l_replacment_string varchar2(50);
l_replacment_strpos number;
l_replace_with varchar2(50);
l_item_id varchar2(50);
l_ret varchar2(400);
begin
  l_ret := p_attribute_01;
  --pak_xslt_log.WriteLog( 'start l_ret: '||l_ret,
  --    p_procedure => 'BindSSApexItem');
  loop
    l_replacment_strpos := regexp_instr(l_ret, '&([a-zA-Z0-9_]*).'); --bind session state values
     exit when nvl(l_replacment_strpos, 0) = 0;
    l_replacment_string := regexp_substr(l_ret, '&([a-zA-Z0-9_]*).'); --bind session state values
    exit when length(l_replacment_string) = 0;

    l_item_id := ltrim(rtrim(l_replacment_string,'.'),'&');

    --pak_xslt_log.WriteLog( 'l_item_id: '||l_item_id||' V(l_item_id): '||V(l_item_id),
      --p_procedure => 'BindSSApexItem');

    if V(l_item_id) is not null then
      l_ret := substr(l_ret, 1, l_replacment_strpos - 1)||V(l_item_id)||substr(l_ret, l_replacment_strpos + length(l_replacment_string));
    else
      l_ret := substr(l_ret, 1, l_replacment_strpos - 1)||'x26'||l_item_id||'x2e'||substr(l_ret, l_replacment_strpos + length(l_replacment_string));
    end if;
  end loop;

  --pak_xslt_log.WriteLog( 'return l_ret: '||l_ret,
      --p_procedure => 'BindSSApexItem');
  return l_ret;
exception
	when others then
  pak_xslt_log.WriteLog( 'Error: '||p_attribute_01,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'HtmlBindColumn',
    p_sqlerrm => sqlerrm );
  raise;
end HtmlBindColumn;


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
return APEXREP2REPORT.tp_cols
as
t_cols APEXREP2REPORT.tp_cols;
l_rpt_row apex_appl_page_ig_rpts%rowtype;
l_report_id number;
l_master_region_id number;
l_master_report_id number;
begin
    pak_xslt_log.WriteLog( 'Start for p_region_id : '||p_region_id||
                        ' p_page_id : '||p_page_id, p_procedure => 'IG2Report.CollectIGColumns');

    l_rpt_row := Get_current_report_row(p_region_id, p_page_id);
    l_report_id := l_rpt_row.report_id;

    select nvl(max_row_count, 100000)
    into po_max_rows_IG
    from APEX_APPL_PAGE_IGS
    where application_id = APEX_APPLICATION.G_FLOW_ID
    and page_id = p_page_id
    and region_id = p_region_id;

    select MASTER_REGION_ID into l_master_region_id from APEX_APPLICATION_PAGE_REGIONS where region_id = p_region_id;

    if l_master_region_id is not null then
        l_master_report_id := Get_current_report_row(l_master_region_id, p_page_id).report_id;
    end if;

    if l_rpt_row.name is not null then
      po_IG_Attr := 'IR_name="'||l_rpt_row.name||'"';
    end if;
    if l_rpt_row.description is not null then
      po_IG_Attr := po_IG_Attr||' IR_description="'||l_rpt_row.description||'"';
    end if;

    pak_xslt_log.WriteLog( 'po_IR_Attr: '||po_IG_Attr, p_log_type => pak_xslt_log.g_information, p_procedure => 'IG2Report.CollectIGColumns');
    pak_xslt_log.WriteLog( 'Before bulk collect selects l_master_region_id: '||l_master_region_id||
                           ' l_master_report_id: '||l_master_report_id||
                           ' l_report_id: '||l_report_id||
                           ' p_page_id: '||p_page_id||
                           ' p_region_id: '||p_region_id, 
                           p_procedure => 'IG2Report.CollectIGColumns');


    if p_use_filters_hidPK = 0 then --0 - All columns,
        select report_label, fullname, 
        column_alias, master_alias, 
        column_type,
        format_mask, PRINT_COLUMN_WIDTH, display_seq,
        sum_total, query_id, html_img_included,
        LOV_SQL, aggregation, item_type
        bulk collect into t_cols
        from
        (
        select APEXREP2REPORT.PrepareColumnHeader(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as report_label,
        APEXREP2REPORT.RemoveLineBreak(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as fullname,
        case when col.region_id = nvl(l_master_region_id, 0) then substr(col.NAME,1,30-length('_MASTER'))||'_MASTER' else col.NAME end as column_alias,
        col.NAME as master_alias,
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq,
        case when col.region_id != nvl(l_master_region_id, 0) then substr(a.show_grand_total,1,1) end sum_total,
        null query_id,
        APEXREP2REPORT.Html_img_included(col.item_type, col.attribute_01, col.format_mask) html_img_included,
        IG2Report.GetLOVSelect(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = l_master_region_id or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else a.function end aggregation, --show master region cols as break cols
        col.item_type,
        case when col.region_id = l_master_region_id then l_master_region_id end MASTER_REGION_ID, --master region
        rank() over (partition by col.NAME order by a.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (l_report_id, l_master_report_id)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS a on a.column_id = rcol.column_id and a.report_id = rcol.report_id and a.is_enabled = 'Yes'
        where col.page_id = p_page_id --2 --30 --2
        and col.region_id in (p_region_id, l_master_region_id) --adds master region cols
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        )
        where rank_num = 1
        order by master_region_id, display_seq, column_alias; --master region cols first
        /*
        where
        rcol.is_visible, --Yes/No
        col.INCLUDE_IN_EXPORT , --Yes/No
        col.IS_PRIMARY_KEY,  --Yes/No
        */

    elsif  p_use_filters_hidPK = 1 then --1 - just included in export columns,
        select report_label, fullname, 
        column_alias, master_alias, 
        column_type,
        format_mask, PRINT_COLUMN_WIDTH, display_seq,
        sum_total, query_id, html_img_included,
        LOV_SQL, aggregation, item_type
        bulk collect into t_cols
        from
        (
        select APEXREP2REPORT.PrepareColumnHeader(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as report_label,
        APEXREP2REPORT.RemoveLineBreak(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as fullname,
        case when col.region_id = nvl(l_master_region_id, 0) then substr(col.NAME,1,30-length('_MASTER'))||'_MASTER' else col.NAME end as column_alias,
        col.NAME master_alias,
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq,
        substr(a.show_grand_total,1,1) sum_total,
        null query_id,
        APEXREP2REPORT.Html_img_included(col.item_type, col.attribute_01, col.format_mask) html_img_included,
        IG2Report.GetLOVSelect(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = l_master_region_id or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else a.function end aggregation, --show master region cols as break cols
        col.item_type,
        case when col.region_id = l_master_region_id then l_master_region_id end MASTER_REGION_ID, --master region
        rank() over (partition by col.NAME order by a.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (l_report_id, l_master_report_id)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS a on a.column_id = rcol.column_id and a.report_id = rcol.report_id and a.is_enabled = 'Yes'
        where col.page_id = p_page_id --2 --30 --2
        and col.region_id in (p_region_id, l_master_region_id) --adds master region cols
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and
        ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        --or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN'
        )
        where rank_num = 1
        order by master_region_id, display_seq, column_alias; --master region cols first
    elsif  p_use_filters_hidPK = 2 then --2 - just included in export and visible columns 
        select report_label, fullname, 
        column_alias, master_alias, 
        column_type,
        format_mask, PRINT_COLUMN_WIDTH, display_seq,
        sum_total, query_id, html_img_included,
        LOV_SQL, aggregation, item_type
        bulk collect into t_cols
        from
        (
        select APEXREP2REPORT.PrepareColumnHeader(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as report_label,
        APEXREP2REPORT.RemoveLineBreak(col.HEADING)||
        case when col.region_id = nvl(l_master_region_id, 0) then ' Master' end as fullname,
        case when col.region_id = nvl(l_master_region_id, 0) then substr(col.NAME,1,30-length('_MASTER'))||'_MASTER' else col.NAME end as column_alias,        
        col.NAME master_alias,
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq,
        substr(a.show_grand_total,1,1) sum_total,
        null query_id,
        APEXREP2REPORT.Html_img_included(col.item_type, col.attribute_01, col.format_mask) html_img_included,
        IG2Report.GetLOVSelect(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = l_master_region_id or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else a.function end aggregation, --show master region cols as break cols
        col.item_type,
        case when col.region_id = l_master_region_id then l_master_region_id end MASTER_REGION_ID, --master region
        rank() over (partition by col.NAME order by a.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (l_report_id, l_master_report_id)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS a on a.column_id = rcol.column_id and a.report_id = rcol.report_id and a.is_enabled = 'Yes'
        where col.page_id = p_page_id --2 --30 --2
        and col.region_id in (p_region_id, l_master_region_id) --adds master region cols
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR', 'NATIVE_HIDDEN')
        and (rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        --and nvl(col.IS_PRIMARY_KEY, 'No') = 'No'
        )
        where rank_num = 1
        order by master_region_id, display_seq, column_alias; --master region cols first
    end if;

    APEXREP2REPORT.LogComposeSelectAndAttr(p_procedure => 'IG2Report.CollectIGColumns', p_cols => t_cols );

    return t_cols;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.CollectIGColumns', p_sqlerrm => sqlerrm );
  raise;
end;

/** Function Check p_cols array for any SUM total and compose select statement.
* Used for IG with Show Grand Total turned on.
*
* @param p_cols table of columns (also aggregation function is there)
* @param po_basic_col_list basic column list
* @param po_grand_total_col_list
*/
function GrandTotalSelect(
  --pio_region_source in out nocopy clob,
  p_cols            APEXREP2REPORT.tp_cols,
  p_break boolean,
  po_basic_col_list out varchar2,
  po_grand_total_col_list  out varchar2
)
return boolean
as
 l_region_aggregates varchar2(4000);
 l_col_grand_total   varchar2(4000);
 l_col_basic         varchar2(4000);
 l_aggregate boolean default false;
 l_break_col_list varchar2(4000) default null;
 begin
  pak_xslt_log.WriteLog( 'Start', p_procedure => 'IG2Report.GrandTotalSelect');
  for i in 1..p_cols.count loop
      pak_xslt_log.WriteLog( p_cols(i).alias||' :sum total: '||p_cols(i).sum_total, p_procedure => 'IG2Report.GrandTotalSelect');
      if p_cols(i).sum_total = 'Y' then
        if p_cols(i).col_type = 'NUMBER' then
            l_col_grand_total := 'round('||p_cols(i).aggregation||'('||p_cols(i).alias||'),3)';
        else
            l_col_grand_total := 'to_char('||p_cols(i).aggregation||'("'||p_cols(i).alias||'")) ';
        end if;
        if p_cols(i).lov_sql is not null then
          l_col_grand_total := 'to_char('||po_grand_total_col_list||') ';
        end if;
        l_region_aggregates := l_region_aggregates || p_cols(i).aggregation||','||Query2Report.ConvertColName2XmlName(p_cols(i).label)||',';
        l_aggregate := true;
      else --sum_total <> 'Y'
        l_col_grand_total := 'null "'||p_cols(i).alias||'" ';
      end if;
      --Add column if doesn't already exists in col list. It can exists in IG with Show Grand Total turned on.
      if nvl(instr(po_basic_col_list, '"'||p_cols(i).alias||'"'), 0) = 0 then
          l_col_basic := ' "'||p_cols(i).alias||'" ';
      end if;

      if i = 1 then
          po_grand_total_col_list := l_col_grand_total;
          po_basic_col_list := l_col_basic;
      else
          po_grand_total_col_list := po_grand_total_col_list || ', ' || l_col_grand_total;
          po_basic_col_list := po_basic_col_list || ', ' || l_col_basic;
      end if;
  end loop;
  if l_aggregate then
    APEXREP2REPORT.AddAggregateColumns(
      pio_basic_col_list => po_basic_col_list,
      pio_aggr_col_list => po_grand_total_col_list,
      pio_break_col_list => l_break_col_list, --dummy, always null
      pio_grand_total_col_list => po_grand_total_col_list,
      p_region_aggregates => l_region_aggregates,
      p_break_in_grand_total => p_break
    );
  else
    po_grand_total_col_list := null;
  end if;
  APEXREP2REPORT.LogComposeSelectAndAttr(
    'IG2REPORT.GrandTotalSelect',
    null,
    null,
    p_basic_col_list => po_basic_col_list,
    p_grand_total_col_list => po_grand_total_col_list
  );

  pak_xslt_log.WriteLog( 'l_region_aggregates: '||l_region_aggregates, p_procedure => 'IG2Report.GrandTotalSelect');

  return l_aggregate;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.GrandTotalSelect', p_sqlerrm => sqlerrm );
  raise;
end;

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
)
as
l_aggregated_col varchar2(50);
l_found boolean;
l_count boolean;
l_grand_total boolean default false;
l_aggregation boolean default false;
l_break_enabled boolean default false;
l_break_count number default 0;
l_region_aggregates varchar2(4000);
l_grand_total_aggregates varchar2(4000);
l_col_grand_total   varchar2(4000);
--t_cols_aggr APEXREP2REPORT.tp_cols_aggr := APEXREP2REPORT.tp_cols_aggr();

/*
cursor c_cols(c_report_id number) is
  select column_alias
       , display_order
       , column_type
       , report_label
    from apex_application_page_ir_col col
    where page_id = p_page_id
    and region_id = p_region_id
     --commented out 14.2.2013
    $IF apexrep2report.g_views_granted $THEN
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
*/

begin
  --l_rpt_row := Get_current_report_row(p_region_id, p_page_id);
  /*
  FillAggrColsTable(t_cols_aggr, p_rpt_row.SUM_COLUMNS_ON_BREAK, 'SUM');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.AVG_COLUMNS_ON_BREAK, 'AVG');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MAX_COLUMNS_ON_BREAK, 'MAX');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MIN_COLUMNS_ON_BREAK, 'MIN');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.MEDIAN_COLUMNS_ON_BREAK, 'MEDIAN');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.COUNT_COLUMNS_ON_BREAK, 'COUNT');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.COUNT_DISTNT_COL_ON_BREAK, 'COUNT_DISTINCT');
  FillAggrColsTable(t_cols_aggr, p_rpt_row.BREAK_ENABLED_ON, 'GROUP BY');
  */

  for i in 1..p_cols.count loop
    l_found := p_cols(i).aggregation is not null;
    l_count := false;
    if p_cols(i).aggregation = 'GROUP BY' then
       l_break_enabled := true;

       l_col_grand_total := ' null "'||p_cols(i).alias||'" ';
       if po_aggr_col_list is null then
          po_aggr_col_list := ' '||p_cols(i).alias;
       else
          po_aggr_col_list := po_aggr_col_list||', '||p_cols(i).alias;
       end if;

      if po_break_col_list is null then
        po_break_col_list := ' distinct '||p_cols(i).alias;
      else
        po_break_col_list := po_break_col_list||', '||p_cols(i).alias;
      end if;

      if po_break_group_by_list is null then
        po_break_group_by_list := p_cols(i).alias;
      else
        po_break_group_by_list := po_break_group_by_list||', '||p_cols(i).alias;
      end if;
      l_break_count := l_break_count + 1;
      po_breakAttr := po_breakAttr||'break_on_col'||to_char(l_break_count)||
                    '="'||Query2Report.ConvertColName2XmlName(p_cols(i).label)||'" ';

    else
        if l_found then --not group by
          l_aggregation := true;
          if p_cols(i).aggregation = 'COUNT_DISTINCT' then
            l_aggregated_col := 'round(COUNT(DISTINCT '||p_cols(i).alias||'),3)';
          else
            l_aggregated_col := 'round('||p_cols(i).aggregation||'('||p_cols(i).alias||'),3)';
          end if;
          l_region_aggregates := l_region_aggregates || p_cols(i).aggregation||','||Query2Report.ConvertColName2XmlName(p_cols(i).label)||',';
          if p_cols(i).aggregation like 'COUNT%'
            --and p_cols(i).column_type <> 'NUMBER'
          then
            l_count := true;
            l_aggregated_col := 'to_char('||l_aggregated_col||')';
          end if;
          if po_aggr_col_list is null then
            po_aggr_col_list := ' '||l_aggregated_col||' '||p_cols(i).alias;
          else
            po_aggr_col_list := po_aggr_col_list||', '||l_aggregated_col||' '||p_cols(i).alias;
          end if;

          if po_break_col_list is null then
            po_break_col_list := ' distinct null '||p_cols(i).alias;
          else
            po_break_col_list := po_break_col_list||', null '||p_cols(i).alias;
          end if;
        end if; --l_found

      -----------------------------grand total-----------------
      if p_cols(i).sum_total = 'Y' then
        l_grand_total := true;
        if p_cols(i).col_type = 'NUMBER' then
            l_col_grand_total := 'round('||p_cols(i).aggregation||'('||p_cols(i).alias||'),3)';
        else
            l_col_grand_total := 'to_char('||p_cols(i).aggregation||'("'||p_cols(i).alias||'")) ';
        end if;
        if p_cols(i).lov_sql is not null then
          l_col_grand_total := 'to_char('||l_col_grand_total||') ';
        end if;
        l_grand_total_aggregates := l_grand_total_aggregates || p_cols(i).aggregation||','||Query2Report.ConvertColName2XmlName(p_cols(i).label)||',';
      else --sum_total <> 'Y'
        l_col_grand_total := 'null "'||p_cols(i).alias||'" ';
      end if;
    end if;

    if i = 1 then
        po_grand_total_col_list := l_col_grand_total;
    else
        po_grand_total_col_list := po_grand_total_col_list || ', ' || l_col_grand_total;
    end if;
    -----------------------------end of grand total-------------------------------------

    if not l_found then
      if po_aggr_col_list is null then
        po_aggr_col_list := ' null '||p_cols(i).alias;
      else
        po_aggr_col_list := po_aggr_col_list||', null '||p_cols(i).alias;
      end if;

      if po_break_col_list is null then
        po_break_col_list := ' distinct null '||p_cols(i).alias;
      else
        po_break_col_list := po_break_col_list||', null '||p_cols(i).alias;
      end if;
    end if;

    if po_basic_col_list is null then
      if l_count then
        po_basic_col_list := ' to_char('||p_cols(i).alias||') '||p_cols(i).alias;
      else
        po_basic_col_list := ' '||p_cols(i).alias;
      end if;
    else
      if l_count then
        po_basic_col_list := po_basic_col_list||', to_char('||p_cols(i).alias||') '||p_cols(i).alias;
      else
        po_basic_col_list := po_basic_col_list||', '||p_cols(i).alias;
      end if;
    end if;
  end loop;

  if not l_grand_total or not l_break_enabled then
      po_grand_total_col_list := null;
  end if;

  if po_aggr_col_list is not null then
    if l_aggregation then

        if l_break_enabled then
          pio_aggr_order_by_list := pio_aggr_order_by_list||', BREAKROW, REGION_AGGREGATES desc ';
          APEXREP2REPORT.AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => po_grand_total_col_list,
            p_region_aggregates => l_region_aggregates,
            p_grand_total_aggregates => l_grand_total_aggregates
          );
        else
          pio_aggr_order_by_list := 'REGION_AGGREGATES desc ';
          po_break_col_list := null;
          APEXREP2REPORT.AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => po_grand_total_col_list,
            p_region_aggregates => l_region_aggregates,
            p_grand_total_aggregates => l_grand_total_aggregates
          );
        end if;
    elsif l_break_enabled then--not aggregation
      pak_xslt_log.WriteLog( 'No aggregation just break', p_procedure => 'IG2Report.AggregateSelect');
      po_aggr_col_list := null;
      APEXREP2REPORT.AddAggregateColumns(
            pio_basic_col_list => po_basic_col_list,
            pio_aggr_col_list => po_aggr_col_list,
            pio_break_col_list => po_break_col_list,
            pio_grand_total_col_list => po_grand_total_col_list,
            p_region_aggregates => l_region_aggregates
          );
      pio_aggr_order_by_list := pio_aggr_order_by_list||', '||' BREAKROW';
    else --no aggregation or break
      pak_xslt_log.WriteLog( 'No aggregation or break', p_procedure => 'IG2Report.AggregateSelect');
      po_aggr_col_list := null;
      po_break_col_list := null;
    end if;
  end if;

  APEXREP2REPORT.LogComposeSelectAndAttr(
    'IG2REPORT.AggregateSelect',
    p_breakAttr => po_breakAttr,
    p_basic_col_list => po_basic_col_list,
    p_aggr_col_list => po_aggr_col_list,
    p_break_col_list => po_break_col_list,
    p_aggr_order_by_list => pio_aggr_order_by_list,
    p_break_group_by_list => po_break_group_by_list,
    p_grand_total_col_list => po_grand_total_col_list
  );
 -- return l_aggregation;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.AggregateSelect', p_sqlerrm => sqlerrm );
  raise;
end AggregateSelect;

/**Returns Master Region select and join to Details region
*
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
)
as
  cursor c_join is
     select c.source_expression col, mc.source_expression parent_col from APEX_APPL_PAGE_IG_COLUMNS c
    join APEX_APPL_PAGE_IG_COLUMNS mc on c.parent_column_id = mc.column_id
    where c.region_id = p_region_id
    and c.source_type_code = 'DB_COLUMN'
    and mc.source_type_code = 'DB_COLUMN' ;

  /*
  cursor c_col_list(c_master_region_id number) is
        select column_alias
        from
        (
        select
        case when col.region_id = nvl(c_master_region_id, 0) then substr(col.NAME,1,30-length('_MASTER'))||'_MASTER' else col.NAME end as column_alias,
        rcol.display_seq,
        case when col.region_id = c_master_region_id then c_master_region_id end MASTER_REGION_ID --master region
        from APEX_APPL_PAGE_IG_COLUMNS col
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id
        where col.region_id in (p_region_id, c_master_region_id) --adds master region cols
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        )
        order by master_region_id, display_seq, column_alias; --master region cols first
  */

begin
  po_master_region_source := null;
  po_join_master_region := null;
  po_master_select_list := null;
  po_master_region_id := null;

  select mr.region_source, mr.region_id
  into po_master_region_source, po_master_region_id
  from APEX_APPLICATION_PAGE_REGIONS r
  left outer join APEX_APPLICATION_PAGE_REGIONS mr on r.master_region_id = mr.region_id
  where r.region_id = p_region_id;

  if po_master_region_source is not null then
      for r_join in c_join loop
          if po_join_master_region is null then
              po_join_master_region := 'master_region_src.'||r_join.parent_col||' = region_src.'||r_join.col;
          else
              po_join_master_region := po_join_master_region||' and master_region_src.'||r_join.parent_col||' = region_src.'||r_join.col;
          end if;
      end loop;
      if po_join_master_region is null then
          po_master_region_source := null;
          pak_xslt_log.WriteLog( 'Cannot compose master region join - p_region_id: '||p_region_id , 
                                p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.MasterRegionSelect', p_sqlerrm => sqlerrm );
      end if;
      
      for i in t_cols.first..t_cols.last loop
          if t_cols(i).master_alias != t_cols(i).alias then
            po_master_select_list := po_master_select_list || ' master_region_src.'||t_cols(i).master_alias||' '||t_cols(i).alias||', ';
          end if;
      end loop;

      if po_master_select_list is null then
          pak_xslt_log.WriteLog( 'Cannot compose alias list' , p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.MasterRegionSelect', p_sqlerrm => sqlerrm );
      end if;
      
  else
     pak_xslt_log.WriteLog( 'Cannot find master region source - p_region_id: '||p_region_id , 
                             p_procedure => 'IG2Report.MasterRegionSelect');
  end if;

  
  if po_master_region_source is null then
      po_master_select_list := null;
  end if;
  
  exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'IG2Report.MasterRegionSelect', p_sqlerrm => sqlerrm );
  raise;
end;

$END

end IG2REPORT;
/
