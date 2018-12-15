



  CREATE OR REPLACE PACKAGE BODY "l1IIl0lI" is
$if CCOMPILING.g_IG_exists $then

 


 
procedure ll10Il( 
  Ol0I1l number,
  IIl11l number,  
  O0II0I11 number,  
  Il10l1 out varchar2,
  Ol1II1 out varchar2  
) 
as 



cursor O0l0I0I0 is 
    select  col.NAME||case rcol.report_id when O0II0I11 then '_MASTER' end as column_alias, 
        case rcol.report_id when O0II0I11 then nvl(rcol.sort_order - 1000, 0) else rcol.break_order end sort_order, 
        case rcol.report_id when O0II0I11 then nvl(rcol.sort_direction, 'ASC') else rcol.break_sort_direction end sort_direction,
        case rcol.report_id when O0II0I11 then nvl(rcol.sort_nulls, 'last') else nvl(rcol.break_sort_nulls, 'last') end sort_nulls
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (Ol0I1l, O0II0I11)
        where rcol.break_order is not null or rcol.report_id = O0II0I11
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and (IIl11l = 0 
        			or (IIl11l = 1 and (((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        																				or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN')
        					) 
        			or (IIl11l = 2 and ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        																			  and nvl(col.IS_PRIMARY_KEY, 'No') = 'No' and col.item_type != 'NATIVE_HIDDEN'
        																			)
        					)
        																			  
        		)
        order by sort_order;

cursor Il0Ill is
    select  col.HEADING as fullname,
        col.NAME as column_alias, 
        0 BREAK,
        rcol.sort_order,
        rcol.sort_direction,
        rcol.sort_nulls
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id = Ol0I1l
        where rcol.sort_order is not null
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and (IIl11l = 0 
        			or (IIl11l = 1 and (((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        																				or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN')
        					) 
        			or (IIl11l = 2 and ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        																			  and nvl(col.IS_PRIMARY_KEY, 'No') = 'No' and col.item_type != 'NATIVE_HIDDEN'
        																			)
        					)
        																			  
        		)
        order by sort_order;
    

begin 

  Il10l1 := null;
  Ol1II1 := null;
  
  for r_cur_break in O0l0I0I0 loop
      if Ol1II1 is null then
          Ol1II1 := ' "' || r_cur_break.column_alias || '" ' || rtrim(r_cur_break.sort_direction, 'ending') || ' nulls '|| r_cur_break.sort_nulls ; 
      else
          Ol1II1 := Ol1II1 || ', "' || r_cur_break.column_alias || '" ' || rtrim(r_cur_break.sort_direction, 'ending') || ' nulls '|| r_cur_break.sort_nulls ; 
      end if;
  end loop;
  
  for r_cur in Il0Ill loop
      if Il10l1 is null then
          Il10l1 := ' "' || r_cur.column_alias || '" ' || rtrim(r_cur.sort_direction, 'ending') || ' nulls '|| r_cur.sort_nulls ; 
      else
          Il10l1 := Il10l1 || ', "' || r_cur.column_alias || '" ' || rtrim(r_cur.sort_direction, 'ending') || ' nulls '|| r_cur.sort_nulls ; 
      end if;
  end loop;
  pak_xslt_log.WriteLog( 'Ol0I1l: '||Ol0I1l||' O0II0I11: '||O0II0I11||
                        ' return Il10l1: '||Il10l1||' Ol1II1: '||
                        Ol1II1, p_procedure => '"l1IIl0lI".ll10Il'); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => '"l1IIl0lI".ll10Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 

 
function ll01Il( 
   Ol01Il in number, 
   IIl1I0 in number 
) 
return apex_appl_page_ig_rpts%rowtype 
as 
  Il01l0 number; 
  ll01l0 varchar2(200); 
  ll0II0 number; 
  Il01l1 apex_appl_page_ig_rpts%rowtype; 
begin 
  
  
  
  

  pak_xslt_log.WriteLog( 'Start for Ol01Il : '||Ol01Il||
                        ' IIl1I0 : '||IIl1I0, p_procedure => '"l1IIl0lI".ll01Il'); 
  ll01l0 := apex_util.get_preference( 'APEX_IG_' || to_char(Ol01Il) || '_CURRENT_REPORT'); 
 
  if ll01l0 is null then 
    pak_xslt_log.WriteLog( 'User preference ll01l0 is null', p_procedure => '"l1IIl0lI".ll01Il'); 
 
    select * 
    into Il01l1 
    from 
    ( 
      select * 
      from apex_appl_page_ig_rpts Ol01lI 
      where Ol01lI.application_id = APEX_APPLICATION.G_FLOW_ID 
      and   Ol01lI.page_id = IIl1I0 
      and   nvl(Ol01lI.APPLICATION_USER, V('APP_USER'))  = V('APP_USER') 
      and   nvl(Ol01lI.session_id, V('SESSION')) = V('SESSION') 
      order by Ol01lI.report_id desc 
    ) where rownum = 1; 
  else 
    ll0II0 := rtrim(ll01l0, ':GRID'); 
 
    pak_xslt_log.WriteLog( 'User preference ll01l0 is NOT null ll0II0 '||ll0II0, p_procedure => '"l1IIl0lI".ll01Il'); 
 
    select * 
    into Il01l1 
    from apex_appl_page_ig_rpts Ol01lI 
    where Ol01lI.application_id = APEX_APPLICATION.G_FLOW_ID 
    and   Ol01lI.page_id = IIl1I0 
    and   nvl(Ol01lI.APPLICATION_USER, V('APP_USER'))  = V('APP_USER') 
    and   Ol01lI.report_id = ll0II0 
    and   nvl(Ol01lI.session_id, V('SESSION')) = V('SESSION'); 
  end if; 
 
  return Il01l1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".ll01Il', p_sqlerrm => sqlerrm ); 
  raise; 
end ll01Il; 

function OIl1Il( 
  IIl1Il number, 
  OIl1l0 varchar2, 
  I0I110l APEX_APPL_PAGE_IG_COLUMNS.LOV_ID%type, 
  ll0O0II APEX_APPL_PAGE_IG_COLUMNS.LOV_SOURCE%type 
) 
return varchar2 
as 
Il01I1 varchar2(32000); 
Il1ll0 varchar2(32000); 
ll1ll0 varchar2(20); 
Ol1ll1 varchar2(32000); 
Il1ll1 varchar2(4000); 
ll1llI number; 
Ol1llI number; 
Il1lll boolean default false; 
 
begin 
  if I0I110l is not null then 
    select list_of_values_query, lov_type 
    into Il1ll0, ll1ll0 
    from apex_application_lovs 
    where application_id = IIl1Il 
    and lov_id = I0I110l; 
 
    if ll1ll0 = 'Static' and IIl1Il is not null then 
      Il1ll0 := 'select display_value Il1lII, trim(ll10I1) v from APEX_APPLICATION_LOV_ENTRIES where application_id = '|| 
        IIl1Il||' and lov_id = '||I0I110l; 
      Il1lll := true; 
    end if; 
  elsif ll0O0II is not null then 
    if substr(upper(trim(ll0O0II)),1,6) = 'SELECT' then 
      Il1ll0 := ll0O0II; 
    elsif substr(upper(trim(ll0O0II)),1,6) = 'STATIC'  
          and instr(ll0O0II,';') > 0 
          and instr(ll0O0II,':') > 0 
    then 
      Ol1ll1 := substr(ll0O0II, instr(ll0O0II,':')+1); 
      Ol1ll1 := Ol1ll1||','; 
      loop 
        ll1llI := nvl(instr(Ol1ll1,','), 0); 
        exit when ll1llI = 0; 
        Il1ll1 := substr(Ol1ll1, 1, ll1llI-1); 
        Ol1llI := nvl(instr(Il1ll1,';'),0); 
        exit when Ol1llI = 0; 
        if Il1ll0 is null then 
          Il1ll0 := 'select '''||substr(Il1ll1,1,Ol1llI - 1)||''' Il1lII, '''|| 
          substr(Il1ll1, Ol1llI + 1)||''' v from dual'; 
        else 
          Il1ll0 := Il1ll0||' union select '''|| 
            substr(Il1ll1,1,Ol1llI - 1)||''' Il1lII, '''|| 
            substr(Il1ll1, Ol1llI + 1)||''' v from dual'; 
        end if; 
        Ol1ll1 := substr(Ol1ll1, ll1llI+1);
      end loop; 
      Il1lll := true; 
    end if; 
  end if; 
  if not Il1lll then 
                       
    Il1ll0 := APEXREP2REPORT.ll1lI1(Il1ll0); 
  end if; 
  return Il1ll0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".OIl1Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 

function O0IOOII0(
    O0OO0I0I APEX_APPL_PAGE_IG_COLUMNS.NAME%type,
    l110Ol0 APEX_APPL_PAGE_IG_RPT_FILTERS.TYPE_CODE%type,
    IlO00OI APEX_APPL_PAGE_IG_RPT_FILTERS.EXPRESSION%type,
    II0O1I0 APEX_APPL_PAGE_IG_RPT_FILTERS.OPERATOR%type,
    Il1I0I APEX_APPL_PAGE_IG_COLUMNS.DATA_TYPE%type,
    O0I0I11O1 APEX_APPL_PAGE_IG_RPT_FILTERS.IS_CASE_SENSITIVE%type,
    ll01ll APEXREP2REPORT.Ol0110 default null
)
return varchar2
as
    OOlIOI1 varchar2(4000);
    l0l1I00 varchar2(4000);
    l10l1lI1 varchar2(32000);
    O0IOIO1I varchar2(32000);
    IllIO0l varchar2(10);
    O0IIOOI0 varchar2(1);
    Il101I0 varchar2(4000);
begin

    if l110Ol0 = 'COLUMN' then
        if II0O1I0 = 'REGEXP' then
            if O0I0I11O1 = 'No' then
                O0IIOOI0 := 'll01I1';
            end if;
            l0l1I00 := ' REGEXP_LIKE ( '||O0OO0I0I||', '''||IlO00OI||''', ''m'||O0IIOOI0||''')';
        else
            if II0O1I0 = 'N' then
                l0l1I00 := 'is null';
            else
                if II0O1I0 != 'NEXT' and substr(II0O1I0, 1, 1) = 'N' then  
                    IllIO0l := 'not';
                    OOlIOI1 := substr(II0O1I0, 2);
                else 
                    OOlIOI1 := II0O1I0;
                end if;
                if OOlIOI1 = 'N' then
                    OOlIOI1 := 'is null';
                elsif OOlIOI1 = 'BETWEEN' then
                    if Il1I0I = 'VARCHAR2' then
                        l0l1I00 := ''''||replace(IlO00OI, '~',''' AND ''')||'''' ; 
                    elsif Il1I0I = 'DATE' then
                        l0l1I00 := 'to_date('''||replace(IlO00OI, '~',''',''YYYYMMDDhh24miss'') AND to_date(''')||''',''YYYYMMDDhh24miss'')' ;
                    else
                        l0l1I00 := replace(IlO00OI, '~',' AND ');
                    end if;
                elsif OOlIOI1 = 'Illl11' then
                    OOlIOI1 := 'like';
                    l0l1I00 := ''''||IlO00OI||'%''';
                elsif OOlIOI1 = 'Ol1011' then
                    OOlIOI1 := 'like';
                    l0l1I00 := '''%'||IlO00OI||'%''';
                elsif OOlIOI1 = 'IN' then
                    if Il1I0I = 'DATE' then
                        l0l1I00 := 'to_date('''||replace(replace(IlO00OI, CHR(13) || CHR(10) ,
                                                             ''',''YYYYMMDDhh24miss'') , to_date('''), CHR(10) ,''',''YYYYMMDDhh24miss'') AND to_date(''')||
                                                             ''',''YYYYMMDDhh24miss'')';
                    else 
                        l0l1I00 := '('''||replace(replace(replace(IlO00OI, CHR(13) || CHR(10) ,''' , '''), CHR(10) ,''' , '''), CHR(1) ,''' , ''')||''')';
                    
                    end if;
                elsif OOlIOI1 in ('GTE', 'LTE', 'GT', 'LT') then
                    if Il1I0I = 'VARCHAR2' then
                        l0l1I00 := ''''||IlO00OI||'''';
                    elsif Il1I0I = 'DATE' then
                        l0l1I00 := 'to_date('''||IlO00OI||''',''YYYYMMDDhh24miss'')';
                    else
                        l0l1I00 := IlO00OI;
                    end if;
                    OOlIOI1 := case OOlIOI1 when 'GTE' then '>=' when 'GT' then '>' when 'LTE' then '<=' when 'LT' then '<' end;
                elsif OOlIOI1 in ('NEXT', 'LAST') then
                    Il101I0 := replace(replace(replace(replace(replace(replace(replace(IlO00OI, '~', '*'),'Il1lII','1'),'H','1/24'),'MI','1/(24*60)'),'W','7'), 'M', '30'),'Y', '365');
                    if OOlIOI1 = 'NEXT' then
                        l0l1I00 := 'SYSDATE AND SYSDATE + '||Il101I0;
                    elsif OOlIOI1 = 'LAST' then
                        l0l1I00 := 'SYSDATE - '||Il101I0||' AND SYSDATE ';
                    end if;
                    OOlIOI1 := 'BETWEEN';
                end if;
            end if;

            if O0I0I11O1 = 'No' and ((Il1I0I = 'VARCHAR2' and OOlIOI1 != 'IN') or OOlIOI1 = 'like') then
                l0l1I00 := 'lower('||O0OO0I0I||') '||OOlIOI1||' '||lower(l0l1I00);
            else
                l0l1I00 := O0OO0I0I||' '||OOlIOI1||' '||l0l1I00;
            end if;

            pak_xslt_log.WriteLog('l0l1I00: '||l0l1I00||' O0OO0I0I: '||O0OO0I0I||' IlO00OI: '||
                                  IlO00OI||' II0O1I0: '||II0O1I0, p_procedure => '"l1IIl0lI".O0IOOII0');
        end if; 

    elsif l110Ol0 = 'ROW' then
        
        for ll01I1 in 1..ll01ll.count loop
          if ll01ll(ll01I1).col_type != 'VARCHAR2' then
              if l10l1lI1 is null then
                  l10l1lI1 := 'lower('||ll01ll(ll01I1).alias||')';
                  O0IOIO1I := ll01ll(ll01I1).alias;
              else
                  l10l1lI1 := l10l1lI1||'||'',''||lower('||ll01ll(ll01I1).alias||')';
                  O0IOIO1I := O0IOIO1I||'||'',''||'||ll01ll(ll01I1).alias;
              end if;
          elsif ll01ll(ll01I1).col_type != 'NUMBER' then
              if l10l1lI1 is null then
                  l10l1lI1 := 'to_char('||ll01ll(ll01I1).alias||')';
                  O0IOIO1I := 'to_char('||ll01ll(ll01I1).alias||')';
              else
                  l10l1lI1 := l10l1lI1||'||'',''||to_char('||ll01ll(ll01I1).alias||')';
                  O0IOIO1I := O0IOIO1I||'||'',''||to_char('||ll01ll(ll01I1).alias||')';
              end if;
          end if;
        end loop;

        if O0I0I11O1 = 'No' then
          l0l1I00 := 'instr('||l10l1lI1||','''||lower(IlO00OI)||''') > 0'; 
        else
          l0l1I00 := 'instr('||O0IOIO1I||','''||IlO00OI||''') > 0'; 
        end if;
    end if;

    return IllIO0l||' '||l0l1I00;

exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O0IOOII0', p_sqlerrm => sqlerrm ); 
  raise; 
end O0IOOII0;

 
procedure lIlOOl1( 
    Ol01Il number, 
    IIl1I0 number, 
    IIl11l number,
    l10I0OI0 number,
    ll01ll APEXREP2REPORT.Ol0110,
    Il10l1 out varchar2, 
    Ol1II1 out varchar2,
    ll10lI out varchar2 
) 
as 
  Ol01l1 number; 
  ll01l0 varchar2(32767); 
  
  Ol10lI varchar2(32767); 
  
 ll0II0 number;
 O01llO01 number;
  
  
  
  cursor Il10ll(ll101I number) is 
  select  col.NAME as column_alias,
        col.data_type as column_type, 
        ll1lIl.OPERATOR, ll1lIl.IS_CASE_SENSITIVE,
        ll1lIl.EXPRESSION, ll1lIl.IS_ENABLED
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id  
        join APEX_APPL_PAGE_IG_RPT_FILTERS ll1lIl on ll1lIl.report_id = rcol.report_id and ll1lIl.column_id = rcol.column_id 
  where ll1lIl.report_id = ll101I and ll1lIl.TYPE_CODE = 'COLUMN';
  
  cursor Il0lOl0(ll101I number) is 
  select ll1lIl.IS_CASE_SENSITIVE,
        ll1lIl.EXPRESSION, ll1lIl.IS_ENABLED
        from APEX_APPL_PAGE_IG_RPT_FILTERS ll1lIl 
        where ll1lIl.report_id = ll101I and ll1lIl.TYPE_CODE = 'ROW';
        
 l0l1I00 varchar2(4000);
 
begin 
  
  pak_xslt_log.WriteLog( 'Start for Ol01Il : '||Ol01Il||
                        ' IIl1I0 : '||IIl1I0, p_procedure => '"l1IIl0lI".lIlOOl1'); 
  ll10lI := ''; 
  Il10l1 := ''; 
  ll0II0 := ll01Il(Ol01Il, IIl1I0).report_id;
  
  if l10I0OI0 is not null then
      O01llO01 := ll01Il(l10I0OI0, IIl1I0).report_id;
  end if;
  
  if IIl11l > 0 then
      for ll1101 in Il10ll(ll0II0) 
      loop
          l0l1I00 := O0IOOII0(
                ll1101.column_alias,
                'COLUMN',
                ll1101.expression,
                ll1101.operator,
                ll1101.column_type,
                ll1101.is_case_sensitive
          );
          
          if ll10lI is null then 
              ll10lI := l0l1I00;
          else 
              ll10lI := ll10lI ||' and '|| l0l1I00; 
          end if; 
      end loop;

      for r_con_row in Il0lOl0(ll0II0) 
      loop 
          l0l1I00 := O0IOOII0(
                null,
                'ROW',
                r_con_row.expression,
                null,
                null,
                r_con_row.is_case_sensitive,
                ll01ll
          );

          if ll10lI is null then 
              ll10lI := l0l1I00;
          else 
              ll10lI := ll10lI ||' and '||l0l1I00; 
          end if; 
      end loop;
  end if;
 
  ll10Il(ll0II0, IIl11l, O01llO01, Il10l1, Ol1II1); 
 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".lIlOOl1', p_sqlerrm => sqlerrm ); 
  raise; 
end lIlOOl1; 

 
function Il1000( 
  O0OO0I0I APEX_APPL_PAGE_IG_COLUMNS.NAME%type,
  O0O0O1lO1 APEX_APPL_PAGE_IG_COLUMNS.HEADING%type,
  l110Ol0 APEX_APPL_PAGE_IG_RPT_FILTERS.TYPE_CODE%type,
  IlO00OI APEX_APPL_PAGE_IG_RPT_FILTERS.EXPRESSION%type,
  II0O1I0 APEX_APPL_PAGE_IG_RPT_FILTERS.OPERATOR%type,
  Il1I0I APEX_APPL_PAGE_IG_COLUMNS.DATA_TYPE%type,
  O0I0I11O1 APEX_APPL_PAGE_IG_RPT_FILTERS.IS_CASE_SENSITIVE%type,
  ll1000 APEX_APPL_PAGE_IG_RPT_HIGHLTS.NAME%type,
  Il1I0OO1 APEX_APPL_PAGE_IG_RPT_HIGHLTS.COLUMN_ID%type,
  lI0O1lO1 APEX_APPL_PAGE_IG_RPT_HIGHLTS.BACKGROUND_COLOR%type,
  l1O11OlI APEX_APPL_PAGE_IG_RPT_HIGHLTS.TEXT_COLOR%type,
  ll01ll APEXREP2REPORT.Ol0110 default null  
) 
return varchar2 
as
l0l1I00 varchar2(32000);
begin 
  l0l1I00 := O0IOOII0(
    O0OO0I0I,
    l110Ol0,
    IlO00OI,
    II0O1I0,
    Il1I0I,
    O0I0I11O1,
    ll01ll
 );
 
 return 
  ' (case when '||l0l1I00||
  ' then ''highlight_name="'||ll1000||'" '|| 
  'highlight_col="'||Query2Report.IIlIll(O0O0O1lO1)||'" '|| 
  'highlight_cell="'|| 
 case when Il1I0OO1 is not null then 'true' else 'false' end||'" '|| 
  'highlight_bkg_color="'||lI0O1lO1||'" '|| 
  'highlight_font_color="'||l1O11OlI||'"'' end) '; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'Il1000', p_sqlerrm => sqlerrm ); 
  raise; 
end Il1000; 

 
function Il1l01( 
  IIl1I0 number, 
  Ol01Il number, 
  Ol1II0 boolean,
  ll01ll APEXREP2REPORT.Ol0110 default null    
) 
return varchar2 
as 
Il1010 varchar2(32767); 
ll0II0 number; 
 
cursor ll1l0I(ll101I number) is 
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
    and h.region_id = Ol01Il
    and h.report_id = ll101I
    and h.page_id = IIl1I0
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
    and h.region_id = Ol01Il
    and h.report_id = ll101I
    and h.page_id = IIl1I0
    and h.IS_ENABLED = 'Yes'
    order by execution_seq; 
 
begin 
  ll0II0 := ll01Il(Ol01Il, IIl1I0).report_id; 
 
  for Il1l0l in ll1l0I(ll0II0) loop 
    Il1010 := Il1010|| 
                        Il1000( 
                          Il1l0l.column_alias,
                          Il1l0l.column_heading,
                          Il1l0l.condition_type_code,
                          Il1l0l.condition_expression,
                          Il1l0l.condition_operator,
                          Il1l0l.column_type,
                          Il1l0l.condition_is_case_sensitive,
                          Il1l0l.name,
                          Il1l0l.column_id,
                          Il1l0l.background_color,
                          Il1l0l.text_color,
                          ll01ll
                        )||query2report.g_crlf; 
  end loop; 
  if Il1010 is not null then 
    Il1010:=replace(Il1010, '(case',''); 
    Il1010:=replace(Il1010, 'end)',''); 
    if Ol1II0 then 
      Il1010:=replace(Il1010, 'when','when REGION_AGGREGATES is null and '); 
    end if; 
    Il1010:='(case '||Il1010||' end)'; 
  end if; 
  return Il1010; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error IIl1I0 '||to_char(IIl1I0)||' ll0II0 '||to_char(ll0II0), 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => '"l1IIl0lI".Il1l01', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end Il1l01;


function l010lII(p_attribute_01 varchar2) 
return varchar2 
as 
ll1l0l varchar2(50); 
Ol1l10 number; 
Il1l10 varchar2(50); 
ll1l11 varchar2(50); 
Il01I1 varchar2(400); 
begin 
  Il01I1 := p_attribute_01; 
  
  
  loop 
    Ol1l10 := regexp_instr(Il01I1, '&([Ol0lI0-zA-Z0-9_]*).'); 
     exit when nvl(Ol1l10, 0) = 0; 
    ll1l0l := regexp_substr(Il01I1, '&([Ol0lI0-zA-Z0-9_]*).'); 
    exit when length(ll1l0l) = 0; 
 
    ll1l11 := ltrim(rtrim(ll1l0l,'.'),'&'); 
 
    
      
 
    if V(ll1l11) is not null then 
      Il01I1 := substr(Il01I1, 1, Ol1l10 - 1)||V(ll1l11)||substr(Il01I1, Ol1l10 + length(ll1l0l)); 
    else 
      Il01I1 := substr(Il01I1, 1, Ol1l10 - 1)||'x26'||ll1l11||'x2e'||substr(Il01I1, Ol1l10 + length(ll1l0l)); 
    end if; 
  end loop; 
 
  
      
  return Il01I1; 
exception 
	when others then 
  pak_xslt_log.WriteLog( 'Error: '||p_attribute_01, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'l010lII', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end l010lII; 



function II0I1IO1(
   Ol01Il            in number,
   IIl1I0              in number,
   IIl11l    in number,
   l101lO1O1             out varchar2,
   O0Il1I0I         out number  
   
)
return APEXREP2REPORT.Ol0110
as
Ol01I0 APEXREP2REPORT.Ol0110;
Il0l10 apex_appl_page_ig_rpts%rowtype;
ll0II0 number;
IlIlIOl number;
O01llO01 number;
begin
    pak_xslt_log.WriteLog( 'Start for Ol01Il : '||Ol01Il||
                        ' IIl1I0 : '||IIl1I0, p_procedure => '"l1IIl0lI".II0I1IO1'); 
                        
    Il0l10 := ll01Il(Ol01Il, IIl1I0);
    ll0II0 := Il0l10.report_id;
    
    select nvl(max_row_count, 100000) 
    into O0Il1I0I
    from APEX_APPL_PAGE_IGS 
    where application_id = APEX_APPLICATION.G_FLOW_ID 
    and page_id = IIl1I0 
    and region_id = Ol01Il;
    
    select MASTER_REGION_ID into IlIlIOl from APEX_APPLICATION_PAGE_REGIONS where region_id = Ol01Il;
    
    if IlIlIOl is not null then
        O01llO01 := ll01Il(IlIlIOl, IIl1I0).report_id;
    end if;
    
    if Il0l10.name is not null then                                                                                                      
      l101lO1O1 := 'IR_name="'||Il0l10.name||'"';                                                                                       
    end if;                                                                                                                                        
    if Il0l10.description is not null then                                                                                               
      l101lO1O1 := l101lO1O1||' IR_description="'||Il0l10.description||'"';                                                            
    end if;                                                                                                                                        

    pak_xslt_log.WriteLog( 'll0l0l: '||l101lO1O1, p_log_type => pak_xslt_log.g_information, p_procedure => '"l1IIl0lI".II0I1IO1');               

    
    if IIl11l = 0 then 
        select report_label, fullname, column_alias, column_type, 
        format_mask, PRINT_COLUMN_WIDTH, display_seq, 
        Ol0101, query_id, IIl10I,
        LOV_SQL, ll010I, item_type
        bulk collect into Ol01I0 
        from
        (
        select APEXREP2REPORT.OIl1ll(regexp_replace(col.HEADING, '<[^>]+>'))||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as report_label, 
        regexp_replace(col.HEADING, '<[^>]+>')||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as fullname,
        col.NAME||case when col.region_id = nvl(IlIlIOl, 0) then '_MASTER' end as column_alias, 
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq, 
        case when col.region_id != nvl(IlIlIOl, 0) then substr(Ol0lI0.show_grand_total,1,1) end Ol0101,  
        null query_id,
        APEXREP2REPORT.IIl10I(col.item_type, col.attribute_01, col.format_mask) IIl10I,
        "l1IIl0lI".OIl1Il(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = IlIlIOl or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else Ol0lI0.function end ll010I, 
        col.item_type,    
        case when col.region_id = IlIlIOl then IlIlIOl end MASTER_REGION_ID, 
        rank() over (partition by col.NAME order by Ol0lI0.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (ll0II0, O01llO01)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS Ol0lI0 on Ol0lI0.column_id = rcol.column_id and Ol0lI0.report_id = rcol.report_id and Ol0lI0.is_enabled = 'Yes'
        where col.page_id = IIl1I0 
        and col.region_id in (Ol01Il, IlIlIOl) 
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        )
        where rank_num = 1
        order by master_region_id, display_seq; 
        
        
    elsif  IIl11l = 1 then 
        select report_label, fullname, column_alias, column_type, 
        format_mask, PRINT_COLUMN_WIDTH, display_seq, 
        Ol0101, query_id, IIl10I,
        LOV_SQL, ll010I, item_type
        bulk collect into Ol01I0 
        from
        (
        select APEXREP2REPORT.OIl1ll(regexp_replace(col.HEADING, '<[^>]+>'))||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as report_label, 
        regexp_replace(col.HEADING, '<[^>]+>')||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as fullname,
        col.NAME||case when col.region_id = nvl(IlIlIOl, 0) then '_MASTER' end as column_alias, 
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq, 
        substr(Ol0lI0.show_grand_total,1,1) Ol0101,  
        null query_id,
        APEXREP2REPORT.IIl10I(col.item_type, col.attribute_01, col.format_mask) IIl10I,
        "l1IIl0lI".OIl1Il(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = IlIlIOl or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else Ol0lI0.function end ll010I, 
        col.item_type,    
        case when col.region_id = IlIlIOl then IlIlIOl end MASTER_REGION_ID, 
        rank() over (partition by col.NAME order by Ol0lI0.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (ll0II0, O01llO01)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS Ol0lI0 on Ol0lI0.column_id = rcol.column_id and Ol0lI0.report_id = rcol.report_id and Ol0lI0.is_enabled = 'Yes'
        where col.page_id = IIl1I0 
        and col.region_id in (Ol01Il, IlIlIOl) 
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        and 
        ((rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes')
        or col.IS_PRIMARY_KEY = 'Yes' or col.item_type = 'NATIVE_HIDDEN'
        )
        where rank_num = 1
        order by master_region_id, display_seq; 
    elsif  IIl11l = 2 then 
        select report_label, fullname, column_alias, column_type, 
        format_mask, PRINT_COLUMN_WIDTH, display_seq, 
        Ol0101, query_id, IIl10I,
        LOV_SQL, ll010I, item_type
        bulk collect into Ol01I0 
        from
        (    
        select APEXREP2REPORT.OIl1ll(regexp_replace(col.HEADING, '<[^>]+>'))||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as report_label, 
        regexp_replace(col.HEADING, '<[^>]+>')||case when col.region_id = nvl(IlIlIOl, 0) then ' Master' end as fullname,
        col.NAME||case when col.region_id = nvl(IlIlIOl, 0) then '_MASTER' end as column_alias, 
        case when col.LOV_ID is not null or col.LOV_SOURCE is not null then 'VARCHAR2' else col.data_type end column_type,
        col.format_mask,
        null as PRINT_COLUMN_WIDTH,
        rcol.display_seq, 
        substr(Ol0lI0.show_grand_total,1,1) Ol0101,  
        null query_id,
        APEXREP2REPORT.IIl10I(col.item_type, col.attribute_01, col.format_mask) IIl10I,
        "l1IIl0lI".OIl1Il(col.application_id, col.NAME, col.LOV_ID, col.LOV_SOURCE) LOV_SQL,
        case when col.region_id = IlIlIOl or rcol.break_is_enabled = 'Yes' then 'GROUP BY' else Ol0lI0.function end ll010I, 
        col.item_type,    
        case when col.region_id = IlIlIOl then IlIlIOl end MASTER_REGION_ID, 
        rank() over (partition by col.NAME order by Ol0lI0.aggregate_id desc) rank_num
        from APEX_APPL_PAGE_IG_COLUMNS col  
        join APEX_APPL_PAGE_IG_RPT_COLUMNS rcol on col.column_id = rcol.column_id and rcol.report_id in (ll0II0, O01llO01)
        left outer join APEX_APPL_PAGE_IG_RPT_AGGS Ol0lI0 on Ol0lI0.column_id = rcol.column_id and Ol0lI0.report_id = rcol.report_id and Ol0lI0.is_enabled = 'Yes'
        where col.page_id = IIl1I0 
        and col.region_id in (Ol01Il, IlIlIOl) 
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR', 'NATIVE_HIDDEN')
        and (rcol.is_visible = 'Yes' or rcol.break_is_enabled ='Yes') and col.INCLUDE_IN_EXPORT = 'Yes'
        and nvl(col.IS_PRIMARY_KEY, 'No') = 'No'
        )
        where rank_num = 1
        order by master_region_id, display_seq; 
    end if;
    
    APEXREP2REPORT.Il01ll(p_procedure => '"l1IIl0lI".II0I1IO1', ll01ll => Ol01I0 ); 
    
    return Ol01I0;
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".II0I1IO1', p_sqlerrm => sqlerrm ); 
  raise;     
end;


function O0IlO1OO1(
  
  ll01ll            APEXREP2REPORT.Ol0110,
  llI010 boolean,
  ll11I0 out varchar2,
  O0llOlOl  out varchar2
)
return boolean
as
 Il11l0 varchar2(4000);
 O1IlOll   varchar2(4000);
 llOOl1I         varchar2(4000);
 ll11l1 boolean default false;
 Ol11l1 varchar2(4000) default null;
 begin
  pak_xslt_log.WriteLog( 'Start', p_procedure => '"l1IIl0lI".O0IlO1OO1');
  for ll01I1 in 1..ll01ll.count loop
      pak_xslt_log.WriteLog( ll01ll(ll01I1).alias||' :sum total: '||ll01ll(ll01I1).Ol0101, p_procedure => '"l1IIl0lI".O0IlO1OO1');
      if ll01ll(ll01I1).Ol0101 = 'Y' then
        if ll01ll(ll01I1).col_type = 'NUMBER' then
            O1IlOll := 'round('||ll01ll(ll01I1).ll010I||'('||ll01ll(ll01I1).alias||'),3)';
        else
            O1IlOll := 'to_char('||ll01ll(ll01I1).ll010I||'("'||ll01ll(ll01I1).alias||'")) ';
        end if;
        if ll01ll(ll01I1).lov_sql is not null then
          O1IlOll := 'to_char('||O0llOlOl||') ';
        end if;
        Il11l0 := Il11l0 || ll01ll(ll01I1).ll010I||','||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||',';
        ll11l1 := true;
      else 
        O1IlOll := 'null "'||ll01ll(ll01I1).alias||'" ';
      end if;
      
      if nvl(instr(ll11I0, '"'||ll01ll(ll01I1).alias||'"'), 0) = 0 then
          llOOl1I := ' "'||ll01ll(ll01I1).alias||'" ';
      end if;
      
      if ll01I1 = 1 then
          O0llOlOl := O1IlOll;
          ll11I0 := llOOl1I;
      else
          O0llOlOl := O0llOlOl || ', ' || O1IlOll;
          ll11I0 := ll11I0 || ', ' || llOOl1I;
      end if;     
  end loop;
  if ll11l1 then
    APEXREP2REPORT.Ol11I1(
      Il11I1 => ll11I0,
      ll11II => O0llOlOl,
      Ol11II => Ol11l1, 
      pio_grand_total_col_list => O0llOlOl,  
      Il11Il => Il11l0,
      p_break_in_grand_total => llI010 
    );
  else
    O0llOlOl := null;
  end if;
  APEXREP2REPORT.Il01ll(
    '"l1IIl0lI".O0IlO1OO1',
    null,
    null,
    Ol0I00 => ll11I0,
    p_grand_total_col_list => O0llOlOl
  );
  
  pak_xslt_log.WriteLog( 'Il11l0: '||Il11l0, p_procedure => '"l1IIl0lI".O0IlO1OO1');
  
  return ll11l1;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O0IlO1OO1', p_sqlerrm => sqlerrm );
  raise;
end;

 
procedure Il1l00( 
  ll01ll in APEXREP2REPORT.Ol0110,
  Ol1IIl out varchar2, 
  ll11I0 out varchar2, 
  Ol11l0 out varchar2, 
  Il1IIl out varchar2, 
  llllOI0 in out varchar2, 
  ll1Il0 out varchar2,
  O0llOlOl  out varchar2
)  
as 
Ol1Il0 varchar2(50); 
Il1Il1 boolean; 
ll1Il1 boolean; 
O01I110l boolean default false; 
Ol1I00 boolean default false; 
Ol1IlI boolean default false; 
Il1IlI number default 0; 
Il11l0 varchar2(4000); 
O0O11IIO1 varchar2(4000); 
O1IlOll   varchar2(4000);

 


begin 
  
  
 
  for ll01I1 in 1..ll01ll.count loop 
    Il1Il1 := ll01ll(ll01I1).ll010I is not null; 
    ll1Il1 := false; 
    if ll01ll(ll01I1).ll010I = 'GROUP BY' then 
       Ol1IlI := true; 
       
       O1IlOll := ' null "'||ll01ll(ll01I1).alias||'" ';
       if Ol11l0 is null then 
          Ol11l0 := ' '||ll01ll(ll01I1).alias; 
       else 
          Ol11l0 := Ol11l0||', '||ll01ll(ll01I1).alias; 
       end if; 
 
      if Il1IIl is null then 
        Il1IIl := ' distinct '||ll01ll(ll01I1).alias; 
      else 
        Il1IIl := Il1IIl||', '||ll01ll(ll01I1).alias; 
      end if; 
 
      if ll1Il0 is null then 
        ll1Il0 := ll01ll(ll01I1).alias; 
      else 
        ll1Il0 := ll1Il0||', '||ll01ll(ll01I1).alias; 
      end if; 
      Il1IlI := Il1IlI + 1; 
      Ol1IIl := Ol1IIl||'break_on_col'||to_char(Il1IlI)|| 
                    '="'||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||'" '; 
 
    else 
        if Il1Il1 then 
          Ol1I00 := true; 
          if ll01ll(ll01I1).ll010I = 'COUNT_DISTINCT' then 
            Ol1Il0 := 'round(COUNT(DISTINCT '||ll01ll(ll01I1).alias||'),3)'; 
          else 
            Ol1Il0 := 'round('||ll01ll(ll01I1).ll010I||'('||ll01ll(ll01I1).alias||'),3)'; 
          end if; 
          Il11l0 := Il11l0 || ll01ll(ll01I1).ll010I||','||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||','; 
          if ll01ll(ll01I1).ll010I like 'COUNT%' 
            
          then 
            ll1Il1 := true; 
            Ol1Il0 := 'to_char('||Ol1Il0||')'; 
          end if; 
          if Ol11l0 is null then 
            Ol11l0 := ' '||Ol1Il0||' '||ll01ll(ll01I1).alias; 
          else 
            Ol11l0 := Ol11l0||', '||Ol1Il0||' '||ll01ll(ll01I1).alias; 
          end if; 

          if Il1IIl is null then 
            Il1IIl := ' distinct null '||ll01ll(ll01I1).alias; 
          else 
            Il1IIl := Il1IIl||', null '||ll01ll(ll01I1).alias; 
          end if; 
        end if; 
      
      
      if ll01ll(ll01I1).Ol0101 = 'Y' then
        O01I110l := true;
        if ll01ll(ll01I1).col_type = 'NUMBER' then
            O1IlOll := 'round('||ll01ll(ll01I1).ll010I||'('||ll01ll(ll01I1).alias||'),3)';
        else
            O1IlOll := 'to_char('||ll01ll(ll01I1).ll010I||'("'||ll01ll(ll01I1).alias||'")) ';
        end if;
        if ll01ll(ll01I1).lov_sql is not null then
          O1IlOll := 'to_char('||O1IlOll||') ';
        end if;
        O0O11IIO1 := O0O11IIO1 || ll01ll(ll01I1).ll010I||','||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||',';
      else 
        O1IlOll := 'null "'||ll01ll(ll01I1).alias||'" ';
      end if;
    end if; 
    
    if ll01I1 = 1 then
        O0llOlOl := O1IlOll;
    else
        O0llOlOl := O0llOlOl || ', ' || O1IlOll;
    end if;
    
    
    if not Il1Il1 then 
      if Ol11l0 is null then 
        Ol11l0 := ' null '||ll01ll(ll01I1).alias; 
      else 
        Ol11l0 := Ol11l0||', null '||ll01ll(ll01I1).alias; 
      end if; 
 
      if Il1IIl is null then 
        Il1IIl := ' distinct null '||ll01ll(ll01I1).alias; 
      else 
        Il1IIl := Il1IIl||', null '||ll01ll(ll01I1).alias; 
      end if; 
    end if; 
    
    if ll11I0 is null then 
      if ll1Il1 then 
        ll11I0 := ' to_char('||ll01ll(ll01I1).alias||') '||ll01ll(ll01I1).alias; 
      else 
        ll11I0 := ' '||ll01ll(ll01I1).alias; 
      end if; 
    else 
      if ll1Il1 then 
        ll11I0 := ll11I0||', to_char('||ll01ll(ll01I1).alias||') '||ll01ll(ll01I1).alias; 
      else 
        ll11I0 := ll11I0||', '||ll01ll(ll01I1).alias; 
      end if; 
    end if; 
  end loop; 
  
  if not O01I110l or not Ol1IlI then
      O0llOlOl := null;
  end if;
 
  if Ol11l0 is not null then 
    if Ol1I00 then 
 
        if Ol1IlI then 
          llllOI0 := llllOI0||', BREAKROW, REGION_AGGREGATES desc '; 
          APEXREP2REPORT.Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => O0llOlOl,
            Il11Il => Il11l0,
            p_grand_total_aggregates => O0O11IIO1
          ); 
        else 
          llllOI0 := 'REGION_AGGREGATES desc '; 
          Il1IIl := null; 
          APEXREP2REPORT.Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => O0llOlOl,
            Il11Il => Il11l0,
            p_grand_total_aggregates => O0O11IIO1  
          ); 
        end if; 
    elsif Ol1IlI then
      pak_xslt_log.WriteLog( 'No ll010I just break', p_procedure => '"l1IIl0lI".Il1l00'); 
      Ol11l0 := null; 
      APEXREP2REPORT.Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => O0llOlOl,
            Il11Il => Il11l0 
          ); 
      llllOI0 := llllOI0||', '||' BREAKROW'; 
    else 
      pak_xslt_log.WriteLog( 'No ll010I or break', p_procedure => '"l1IIl0lI".Il1l00'); 
      Ol11l0 := null; 
      Il1IIl := null; 
    end if; 
  end if; 
  
  APEXREP2REPORT.Il01ll(
    '"l1IIl0lI".Il1l00',
    Ol0I10 => Ol1IIl, 
    Ol0I00 => ll11I0, 
    Il0I00 => Ol11l0, 
    ll0I01 => Il1IIl, 
    OIlI0I => llllOI0, 
    Ol0I0l => ll1Il0,
    p_grand_total_col_list => O0llOlOl
  );
 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".Il1l00', p_sqlerrm => sqlerrm ); 
  raise; 
end Il1l00; 


procedure O01lIlI0( 
  Ol01Il number,  
  ll10l10 out varchar2,
  l10100Il out varchar2,
  O00I00Il out varchar2,
  lI111lO1 out number  
)
as 
  cursor O01l1000 is 
     select Ol1011.source_expression col, mc.source_expression parent_col from APEX_APPL_PAGE_IG_COLUMNS Ol1011 
    join APEX_APPL_PAGE_IG_COLUMNS mc on Ol1011.parent_column_id = mc.column_id
    where Ol1011.region_id = Ol01Il 
    and Ol1011.source_type_code = 'DB_COLUMN' 
    and mc.source_type_code = 'DB_COLUMN' ;  
  
  cursor c_col_list(c_master_region_id number) is 
        select column_alias
        from
        (
        select 
        col.NAME||case when col.region_id = nvl(c_master_region_id, 0) then '_MASTER' end as column_alias, 
        col.display_sequence, 
        case when col.region_id = c_master_region_id then c_master_region_id end MASTER_REGION_ID 
        from APEX_APPL_PAGE_IG_COLUMNS col  
        where col.region_id in (Ol01Il, c_master_region_id) 
        and col.source_type_code = 'DB_COLUMN'
        and col.item_type not in ('NATIVE_PASSWORD', 'NATIVE_ROW_SELECTOR')
        )
        order by master_region_id, display_sequence; 
        
  
begin
  ll10l10 := null;
  l10100Il := null;
  O00I00Il := null;
  lI111lO1 := null;
  
  select mr.region_source, mr.region_id 
  into ll10l10, lI111lO1
  from APEX_APPLICATION_PAGE_REGIONS I1001Il 
  left outer join APEX_APPLICATION_PAGE_REGIONS mr on I1001Il.master_region_id = mr.region_id
  where I1001Il.region_id = Ol01Il;
  
  if ll10l10 is not null then
      for r_join in O01l1000 loop
          if l10100Il is null then
              l10100Il := 'master_region_src.'||r_join.parent_col||' = region_src.'||r_join.col;
          else
              l10100Il := l10100Il||' and master_region_src.'||r_join.parent_col||' = region_src.'||r_join.col;
          end if;
      end loop;
      if l10100Il is null then
          ll10l10 := null;
          pak_xslt_log.WriteLog( 'Cannot compose master region join' , p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O01lIlI0', p_sqlerrm => sqlerrm );  
      end if;
  else
     pak_xslt_log.WriteLog( 'Cannot find master region source' , p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O01lIlI0', p_sqlerrm => sqlerrm );  
  end if;
  
  O00I00Il := '(';
  for r_col_list in c_col_list(lI111lO1) loop
      O00I00Il := O00I00Il || r_col_list.column_alias||',';
  end loop;
  
  if O00I00Il is not null then
      O00I00Il := rtrim(O00I00Il,',')||')';
  else
      pak_xslt_log.WriteLog( 'Cannot compose alias list' , p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O01lIlI0', p_sqlerrm => sqlerrm );  
  end if;
  
  if ll10l10 is null then
      O00I00Il := null;
  end if;
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => '"l1IIl0lI".O01lIlI0', p_sqlerrm => sqlerrm ); 
  raise; 
end;
$end
end "l1IIl0lI";

/
