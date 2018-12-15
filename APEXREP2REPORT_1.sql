



  CREATE OR REPLACE PACKAGE BODY "APEXREP2REPORT" AS 
 

 
 
type Ol010I is record 
( 
  region_name varchar2(32000), 
  Il010l varchar2(32000), 
  ll010l number 
); 
  
 
type Ol0111 is table of Ol010I; 
 
 
TYPE Il011I IS TABLE OF varchar2(30) INDEX BY VARCHAR2(2); 
 
type ll011I is table of varchar2(40) index by binary_integer; 
 
 

 
procedure Ol011l( 
  lob_loc IN OUT NOCOPY CLOB CHARACTER SET ANY_CS, 
   Il011l  IN            VARCHAR2 CHARACTER SET lob_loc%CHARSET 
) 
as 
begin 
  dbms_lob.writeappend(lob_loc, length(Il011l), Il011l); 
end; 
 
function ll01I0(Ol01I0 Ol0110) 
return varchar2 
as 
Il01I1 varchar2(32000); 
begin 
  for ll01I1 in 1..Ol01I0.count loop 
    Il01I1:=Il01I1||ll01I1||'.'||Ol01I0(ll01I1).query_id||'.'||Ol01I0(ll01I1).display_sequence||','||Ol01I0(ll01I1).alias||','||Ol01I0(ll01I1).ll0100||'|'; 
  end loop; 
  return Il01I1; 
end; 
 
 
 
 
 
function Ol01II(Ol01I0 Ol0110) 
return t_coltype_table 
as 
Il01I1     t_coltype_table := t_coltype_table(); 
Il01II varchar2(100); 
begin 
  for ll01I1 in 1..Ol01I0.count loop 
    Il01II := Query2Report.IIlIll(Ol01I0(ll01I1).ll0100); 
    
    Il01I1.extend; 
    Il01I1(Il01I1.count) := t_coltype_row(Il01II, Ol01I0(ll01I1).col_type, Ol01I0(ll01I1).format_mask, Ol01I0(ll01I1).PRINT_COLUMN_WIDTH, 
    replace(htf.escape_sc(IIl1lI(Ol01I0(ll01I1).fullname)),'''','&#39;')); 
     
  end loop; 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Ol01II', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol01II; 
 
 
function ll01Il( 
   Ol01Il in number, 
   IIl1I0 in number 
) 
return apex_application_page_ir_rpt%rowtype 
as 
  Il01l0 number; 
  ll01l0 varchar2(200); 
  Ol01l1 number; 
  Il01l1 apex_application_page_ir_rpt%rowtype; 
begin 
 
  select ll01lI.interactive_report_id 
  into Il01l0 
  from apex_application_page_ir ll01lI 
  where ll01lI.application_id = APEX_APPLICATION.G_FLOW_ID
  and   ll01lI.page_id = IIl1I0 
  and   ll01lI.region_id = Ol01Il; 

  ll01l0 := apex_util.get_preference( 'FSP_IR_' || to_char(APEX_APPLICATION.G_FLOW_ID) || '_P' || IIl1I0 || '_W' || Il01l0, v( 'APP_USER') ); 
 
  if ll01l0 is null then 
    pak_xslt_log.WriteLog( 'User preference ll01l0 is null', p_procedure => 'll01Il'); 
 
    select * 
    into Il01l1 
    from 
    ( 
      select * 
      from apex_application_page_ir_rpt Ol01lI 
      where Ol01lI.application_id = APEX_APPLICATION.G_FLOW_ID 
      and   Ol01lI.page_id = IIl1I0 
      and   Ol01lI.APPLICATION_USER  = V('APP_USER') 
      and   Ol01lI.session_id = V('SESSION') 
      order by Ol01lI.report_id desc 
    ) where rownum = 1; 
  else 
    Ol01l1 := substr( ll01l0, 1, instr( ll01l0, '_' ) - 1 ); 
 
    pak_xslt_log.WriteLog( 'User preference ll01l0 is NOT null Ol01l1 '||Ol01l1, p_procedure => 'll01Il'); 
 
    select * 
    into Il01l1 
    from apex_application_page_ir_rpt Ol01lI 
    where Ol01lI.application_id = APEX_APPLICATION.G_FLOW_ID 
    and   Ol01lI.page_id = IIl1I0 
    and   Ol01lI.APPLICATION_USER  = V('APP_USER') 
    and   Ol01lI.base_report_id = Ol01l1 
    and   Ol01lI.session_id = V('SESSION'); 
  end if; 
 
  
 
  return Il01l1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll01Il', p_sqlerrm => sqlerrm ); 
  raise; 
end ll01Il; 
 
procedure Il01ll( 
  p_procedure           varchar2, 
  Ol01Il           number default null, 
  IIl11l   number default null, 
  ll01ll                Ol0110 default null, 
  Ol0I00      varchar2 default null, 
  Il0I00       varchar2 default null, 
  ll0I01      varchar2 default null, 
  Ol0I01               varchar2 default null, 
  Il0I0I       varchar2 default null, 
  IIlI0l       varchar2 default null, 
  OIlI0I  varchar2 default null, 
  ll0I0I   varchar2 default null, 
  Ol0I0l varchar2 default null, 
  Il0I0l         varchar2 default null, 
  ll0I10              varchar2 default null, 
  Ol0I10           varchar2 default null, 
  Il0I11           varchar2 default null, 
  ll0I11         varchar2 default null, 
  Ol0I1I    varchar2 default null,
  p_grand_total_col_list varchar2 default null,
  p_master_region_source varchar2 default null,   
  p_join_master_region   varchar2 default null,
  p_alias_list           varchar2 default null
) 
as 
Il01I1 varchar(32000); 
begin 
  if Ol01Il is not null then 
    Il01I1 := 'Ol01Il: '||Ol01Il; 
  end if; 
 
  if IIl11l is not null then 
    Il01I1 := Il01I1|| 
    case IIl11l 
      when OIl100 then ' No filters ' 
      when IIl101 then ' Hidden PK ' 
      when OIl10I then ' Use filters ' 
    end; 
  end if; 
  if ll01ll is not null then 
    Il01I1 := Il01I1 ||' ll01ll: '||ll01I0(ll01ll); 
  end if; 
  if Ol0I00 is not null then 
    Il01I1 := Il01I1 ||' Ol0I00: '||Ol0I00; 
  end if; 
  if Il0I00 is not null then 
    Il01I1 := Il01I1 ||' Il0I00: '||Il0I00; 
  end if; 
  if ll0I01 is not null then 
    Il01I1 := Il01I1 ||' ll0I01: '||ll0I01; 
  end if; 
  if Il0I0l is not null then 
    Il01I1 := Il01I1 ||' Il0I0l: '||Il0I0l; 
  end if; 
  if Ol0I01 is not null then 
    Il01I1 := Il01I1 ||' Ol0I01: '||Ol0I01; 
  end if; 
  if Il0I0I is not null then 
    Il01I1 := Il01I1 ||' Il0I0I: '||Il0I0I; 
  end if; 
   if Ol0I0l is not null then 
    Il01I1 := Il01I1 ||' Ol0I0l: '||Ol0I0l; 
  end if; 
  if IIlI0l is not null then 
    Il01I1 := Il01I1 ||' IIlI0l: '||IIlI0l; 
  end if; 
  if OIlI0I is not null then 
    Il01I1 := Il01I1 ||' OIlI0I: '||OIlI0I; 
  end if; 
  if ll0I0I is not null then 
    Il01I1 := Il01I1 ||' ll0I0I: '||ll0I0I; 
  end if; 
  if ll0I10 is not null then 
    Il01I1 := Il01I1 ||' ll0I10: '||ll0I10; 
  end if; 
  if Ol0I10 is not null then 
    Il01I1 := Il01I1 ||' Ol0I10: '||Ol0I10; 
  end if; 
  if Il0I11 is not null then 
    Il01I1 := Il01I1 ||' Il0I11: '||Il0I11; 
  end if; 
  if ll0I11 is not null then 
    Il01I1 := Il01I1 ||' ll0I11: '||ll0I11; 
  end if; 
  if Ol0I1I is not null then 
    Il01I1 := Il01I1 ||' Ol0I1I: '||Ol0I1I; 
  end if;
  if p_grand_total_col_list is not null then 
    Il01I1 := Il01I1 ||' p_grand_total_col_list: '||p_grand_total_col_list; 
  end if;
  if p_master_region_source is not null then 
    Il01I1 := Il01I1 ||' p_master_region_source: '||p_master_region_source; 
  end if;
  if p_join_master_region is not null then 
    Il01I1 := Il01I1 ||' p_join_master_region: '||p_join_master_region; 
  end if;
  if p_alias_list is not null then 
    Il01I1 := Il01I1 ||' p_alias_list: '||p_alias_list; 
  end if;
  
  pak_xslt_log.WriteLog( Il01I1, p_procedure => p_procedure); 
end; 
 
function Il0I1I( 
   Ol01Il            in number, 
   IIl1I0              in number 
) 
return pls_integer 
as 
Il01I1 pls_integer; 
begin 
  select max_row_count into Il01I1 
  from apex_application_page_ir 
  where page_id = IIl1I0 
  and region_id = Ol01Il; 
 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il0I1I', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
function IIl10I( 
  OIl10l          varchar2 
  ,IIl110   varchar2 
  ,OIl111        varchar2 
) 
return number 
as 
begin 
  if OIl10l in ('WITHOUT_MODIFICATION', 'NATIVE_HTML_EXPRESSION') then 
    if IIl110 like '%<img %' or OIl111 like 'IMAGE%' then 
      return 2; 
    else 
      return 1; 
    end if; 
  end if; 
  return 0; 
end IIl10I; 
 
 
function ll0I1l( 
   Ol01Il            in number, 
   IIl1I0              in number, 
   Ol0I1l            in number, 
   IIl11l    in number, 
   Il0II0  in varchar2 default null 
) 
return Ol0110 
as 
Ol01I0 Ol0110; 
ll0II0 number; 
begin 
  pak_xslt_log.WriteLog( 'Start Ol0I1l '||Ol0I1l||' Ol01Il '||Ol01Il|| 
                        ' IIl11l '||IIl11l|| 
                        ' Il0II0 '||Il0II0, 
                        p_procedure => 'll0I1l'); 
 
  if IIl11l = 0 then 
    select report_label 
           , column_alias 
           , column_fullname 
           , column_type 
           , format_mask 
           , PRINT_COLUMN_WIDTH 
           , display_order 
           , null Ol0101 
           , null query_id 
           , IIl10I(display_text_as, column_linktext, format_mask) IIl10I 
           , OIl1Il(application_id, column_alias, named_LOV, null) LOV_SQL 
           , null as ll010I
           , null as item_type
    bulk collect into Ol01I0 
    from 
    ( 
      select OIl1ll(report_label) report_label
           , report_label column_fullname 
           , column_alias 
           , case when col.named_LOV is not null then 'STRING' else col.column_type end column_type
           , format_mask 
           , null as PRINT_COLUMN_WIDTH 
           , display_order 
           , display_text_as 
           , column_linktext 
           , named_LOV 
           , application_id 
        from apex_application_page_ir_col col 
        where region_id = Ol01Il 
        and   upper(col.column_alias) <> 'ROWID' 
 
        $IF CCOMPILING.g_views_granted $THEN 
        union 
 
        select 
        OIl1ll(Ol0II1.computation_report_label) report_label, 
        Ol0II1.computation_report_label column_fullname, 
        Ol0II1.computation_column_alias column_alias, 
        Ol0II1.computation_column_type column_type, 
        Ol0II1.computation_format_mask format_mask, 
        null as print_column_width, 
        999 display_order, 
        null display_text_as, 
        null column_link_test, 
         null named_LOV, 
         Ol0II1.application_id 
         from apex_application_page_regions Ol01lI 
         join apex_application_page_ir Il0II1 on Ol01lI.region_id = Il0II1.region_id 
         join apex_application_page_ir_rpt ll0III on ll0III.interactive_report_id = Il0II1.interactive_report_id 
         join apex_application_page_ir_comp Ol0II1 on Ol0II1.report_id = ll0III.report_id 
         where Ol01lI.region_id = Ol01Il 
         and ll0III.report_id = Ol0I1l 
         order by display_order, column_alias 
         $END 
     ); 
  elsif Il0II0 is not null then 
    if  IIl11l = 1 then 
      select report_label 
           , column_fullname 
           , column_alias 
           , column_type 
           , format_mask 
           , PRINT_COLUMN_WIDTH 
           , Ol0III display_sequence 
           , null Ol0101 
           , null query_id 
           , IIl10I(display_text_as, column_linktext, format_mask) IIl10I 
           , OIl1Il(application_id, column_alias, named_LOV, null) LOV_SQL 
           , null as ll010I
           , null as item_type
      bulk collect into Ol01I0 
      from 
      ( 
        select OIl1ll(col.report_label) report_label 
             , col.report_label column_fullname 
             , col.column_alias 
             , case when col.named_LOV is not null then 'STRING' else col.column_type end column_type
             , col.format_mask 
             , null as PRINT_COLUMN_WIDTH 
             , 0 Ol0III 
             , col.display_text_as 
             , col.column_linktext 
             , col.named_LOV 
             , col.application_id 
        from apex_application_page_ir_col col 
        where col.application_id = APEX_APPLICATION.G_FLOW_ID
        and   col.page_id = IIl1I0 
        and   col.region_id = Ol01Il 
        
        and   col.display_text_as = 'HIDDEN' 
        and   upper(col.column_alias) <> 'ROWID' 
        and   (col.report_label , col.column_alias , col.format_mask) not in 
        
        ( 
           select OIl1ll(col.report_label) report_label 
               , col.column_alias 
               
               , col.format_mask 
          from apex_application_page_ir_col col 
             , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                      , level Ol0III 
                 from ( select Il0II0 Il0IIl 
                             , ':' ll0IIl from dual ) 
                 connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
               ) Ol0Il0 
          where col.application_id = APEX_APPLICATION.G_FLOW_ID
          and   col.page_id = IIl1I0 
          and   col.region_id = Ol01Il 
          and   col.column_alias = Ol0Il0.col 
 
          $IF CCOMPILING.g_views_granted $THEN 
          union 
 
          select  
          OIl1ll(Ol0II1.computation_report_label) report_label, 
          Ol0II1.computation_column_alias column_alias, 
          
          Ol0II1.computation_format_mask  format_mask
          
          from apex_application_page_regions Ol01lI 
          , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                  , level Ol0III 
             from ( select Il0II0 Il0IIl 
                         , ':' ll0IIl from dual ) 
             connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
           ) Ol0Il0, 
          apex_application_page_ir Il0II1, 
          apex_application_page_ir_rpt ll0III, 
          apex_application_page_ir_comp Ol0II1 
          where Ol01lI.region_id = Ol01Il 
          and Ol01lI.region_id = Il0II1.region_id 
          and ll0III.interactive_report_id = Il0II1.interactive_report_id 
          and ll0III.report_id = Ol0I1l 
          and Ol0II1.computation_column_alias = Ol0Il0.col 
          and Ol0II1.report_id = ll0III.report_id 
          $END 
        ) 
 
        union 
 
        select OIl1ll(col.report_label) report_label 
             , col.report_label column_fullname 
             , col.column_alias 
             , col.column_type 
             , col.format_mask 
             , NULL AS PRINT_COLUMN_WIDTH 
             , Ol0Il0.Ol0III 
             , col.display_text_as 
             , col.column_linktext 
             , col.named_LOV 
             , col.application_id 
        from apex_application_page_ir_col col 
           , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                    , level Ol0III 
               from ( select Il0II0 Il0IIl 
                           , ':' ll0IIl from dual ) 
               connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
             ) Ol0Il0 
        where col.application_id = APEX_APPLICATION.G_FLOW_ID 
        and   col.page_id = IIl1I0 
        and   col.region_id = Ol01Il 
        and   col.column_alias = Ol0Il0.col 
        and   upper(col.column_alias) <> 'ROWID' 
 
        $IF CCOMPILING.g_views_granted $THEN 
        union 
 
        select 
        OIl1ll(Ol0II1.computation_report_label) report_label, 
        Ol0II1.computation_report_label column_fullname, 
        Ol0II1.computation_column_alias column_alias, 
        Ol0II1.computation_column_type  column_type, 
        Ol0II1.computation_format_mask format_mask, 
        null as_print_column_width, 
        Ol0Il0.Ol0III, 
        null display_text_as, 
        null column_linktext, 
        null named_LOV, 
        Ol0II1.application_id 
        from apex_application_page_regions Ol01lI 
        , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                , level Ol0III 
           from ( select Il0II0 Il0IIl 
                       , ':' ll0IIl from dual ) 
           connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
         ) Ol0Il0, 
        apex_application_page_ir Il0II1, 
        apex_application_page_ir_rpt ll0III, 
        apex_application_page_ir_comp Ol0II1 
        where Ol01lI.region_id = Ol01Il 
        and Ol01lI.region_id = Il0II1.region_id 
        and ll0III.interactive_report_id = Il0II1.interactive_report_id 
        and ll0III.report_id = Ol0I1l 
        and Ol0II1.computation_column_alias = Ol0Il0.col 
        and Ol0II1.report_id = ll0III.report_id 
        $END 
      ) 
      order by Ol0III; 
    elsif  IIl11l = 2 then 
      select report_label 
           , fullname 
           , column_alias 
           , column_type 
           , format_mask 
           , PRINT_COLUMN_WIDTH 
           , Ol0III display_sequence 
           , null Ol0101 
           , null query_id 
           , IIl10I(display_text_as, column_linktext, format_mask) IIl10I 
           , OIl1Il(application_id, column_alias, named_LOV, null) LOV_SQL 
           , null as ll010I
           , null as item_type
      bulk collect into Ol01I0 
      from 
      ( 
        select OIl1ll(col.report_label) report_label 
             , col.report_label fullname 
             , col.column_alias 
             , case when col.named_LOV is not null then 'STRING' else col.column_type end column_type
             , col.format_mask 
             , null as PRINT_COLUMN_WIDTH 
             , Ol0Il0.Ol0III 
             , col.display_text_as 
             , col.column_linktext 
             , col.named_LOV 
             , col.application_id 
        from apex_application_page_ir_col col 
           , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                    , level Ol0III 
               from ( select Il0II0 Il0IIl 
                           , ':' ll0IIl from dual ) 
               connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
             ) Ol0Il0 
        where col.application_id = APEX_APPLICATION.G_FLOW_ID 
        and   col.page_id = IIl1I0 
        and   col.region_id = Ol01Il 
        and   col.column_alias = Ol0Il0.col 
        and   col.display_text_as <> 'HIDDEN' 
        and   upper(col.column_alias) <> 'ROWID' 
 
        $IF CCOMPILING.g_views_granted $THEN 
        union 
 
        select 
        OIl1ll(Ol0II1.computation_report_label) report_label, 
        Ol0II1.computation_report_label fullname, 
        Ol0II1.computation_column_alias column_alias, 
        Ol0II1.computation_column_type column_type, 
        Ol0II1.computation_format_mask format_mask, 
        null as print_column_width, 
        Ol0Il0.Ol0III, 
        null display_text_as, 
        null column_link_text, 
        null named_LOV, 
        Ol0II1.application_id 
        from apex_application_page_regions Ol01lI 
        , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                , level Ol0III 
           from ( select Il0II0 Il0IIl 
                       , ':' ll0IIl from dual ) 
           connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
         ) Ol0Il0, 
        apex_application_page_ir Il0II1, 
        apex_application_page_ir_rpt ll0III, 
        apex_application_page_ir_comp Ol0II1 
        where Ol01lI.region_id = Ol01Il 
        and Ol01lI.region_id = Il0II1.region_id 
        and ll0III.interactive_report_id = Il0II1.interactive_report_id 
        and ll0III.report_id = Ol0I1l 
        and Ol0II1.computation_column_alias = Ol0Il0.col 
        and Ol0II1.report_id = ll0III.report_id 
        $END 
      ) 
      order by Ol0III; 
    end if; 
  end if; 
 
  return Ol01I0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll0I1l', p_sqlerrm => sqlerrm ); 
  raise; 
end ll0I1l; 
 
 
function Il0Il0( 
  Ol01Il         number, 
  IIl1I0           number, 
  Ol0I1l         number, 
  ll0Il1     varchar2, 
  Ol0Il1   varchar2 
) 
return varchar2 
as 
Il0IlI varchar2(200); 
begin 
  pak_xslt_log.WriteLog( 'Start IIl1I0 '||IIl1I0||' Ol01Il '||Ol01Il|| 
                        ' Ol0Il1 '||Ol0Il1, 
                        p_procedure => 'Il0Il0'); 
 
  select ll0100 into Il0IlI from 
  ( 
    select nvl(report_label, column_alias) ll0100 
    from apex_application_page_ir_col 
    where page_id = IIl1I0 
    and region_id = Ol01Il 
    and column_alias = Ol0Il1 
 
    $IF CCOMPILING.g_views_granted $THEN 
    union 
    select Ol0II1.computation_column_alias ll0100 
    from apex_application_page_regions Ol01lI 
    join apex_application_page_ir Il0II1 on Ol01lI.region_id = Il0II1.region_id 
    join apex_application_page_ir_rpt ll0III on ll0III.interactive_report_id = Il0II1.interactive_report_id 
    join apex_application_page_ir_comp Ol0II1 on Ol0II1.report_id = ll0III.report_id 
    where Ol01lI.region_id = Ol01Il 
    and ll0III.report_id = Ol0I1l 
    and Ol0II1.computation_column_alias = Ol0Il1 
    $END 
  ); 
 
  Il0IlI := 
  case ll0Il1 
    when 'AVG' then 'Average' 
    when 'MAX' then 'Maximum' 
    when 'MIN' then 'Minimum' 
    when 'RATIO_TO_REPORT_SUM' then 'Percent of Total Sum' 
    when 'RATIO_TO_REPORT_COUNT' then 'Percent of Total Count' 
    else initcap(lower(ll0Il1)) 
  end ||' '|| Il0IlI; 
 
  return Il0IlI; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il0Il0', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
function ll0IlI( 
  Ol0I1l  in  apex_application_page_ir_rpt.report_id%type, 
  Ol0Ill out apex_application_page_ir_grpby%rowtype 
) 
return boolean 
as 
  Il01I1 boolean default false; 
 
  cursor Il0Ill is 
  select * from apex_application_page_ir_grpby 
  where report_id = Ol0I1l; 
 
begin 
  open Il0Ill; 
  fetch Il0Ill into Ol0Ill; 
  Il01I1 := Il0Ill%found; 
  close Il0Ill; 
  if Il01I1 then 
    pak_xslt_log.WriteLog( 'Group by mode : '||to_char(Ol0I1l), p_procedure => 'll0IlI'); 
  else 
    pak_xslt_log.WriteLog( 'Report mode', p_procedure => 'll0IlI'); 
  end if; 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll0IlI', p_sqlerrm => sqlerrm ); 
  raise; 
end ll0IlI; 
 
 
 
 
function ll0l00( 
   Ol01Il            in number, 
   IIl1I0              in number, 
   Ol0l00              apex_application_page_ir_rpt%rowtype, 
   Il0l01          out varchar2 
) 
return Ol0110 
as 
Ol01I0 Ol0110; 
ll0l01 Il0100; 
Ol0l0I apex_application_page_ir_grpby%rowtype; 
begin 
    select report_label 
         , fullname 
         , column_alias 
         , column_type 
         , format_mask 
         , PRINT_COLUMN_WIDTH 
         , Ol0III 
         , null Ol0101 
         , null query_id 
         , IIl10I(display_text_as, column_linktext, format_mask) IIl10I 
         , OIl1Il(application_id, column_alias, named_LOV, null) LOV_SQL 
         , null as ll010I
         , null as item_type
         bulk collect into Ol01I0 
    from 
    ( 
      select OIl1ll(col.report_label) report_label 
           , col.report_label fullname 
           , col.column_alias 
           , case when col.named_LOV is not null then 'STRING' else col.column_type end column_type 
           , col.format_mask 
           , null as PRINT_COLUMN_WIDTH 
           , Ol0Il0.Ol0III 
           , col.display_text_as 
           , col.column_linktext 
           , col.named_LOV 
           , col.application_id 
      from apex_application_page_ir_col col 
         , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
                  , level Ol0III 
             from ( select group_by_columns Il0IIl, ':' ll0IIl from apex_application_page_ir_grpby Il0IIl 
                    where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = IIl1I0 and report_id = Ol0l00.report_id 
                  ) 
             connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
           ) Ol0Il0 
      where col.application_id = APEX_APPLICATION.G_FLOW_ID 
      and   col.page_id = IIl1I0 
      and   col.region_id = Ol01Il 
      and   col.column_alias = Ol0Il0.col 
 
      $IF CCOMPILING.g_views_granted $THEN 
      union 
 
      select 
      OIl1ll(Ol0II1.computation_report_label) report_label, 
      Ol0II1.computation_report_label fullname, 
      Ol0II1.computation_column_alias column_alias, 
      Ol0II1.computation_column_type column_type, 
      Ol0II1.computation_format_mask format_mask, 
      null as PRINT_COLUMN_WIDTH, 
      Ol0Il0.Ol0III, 
      null display_text_as, 
      null column_link_text, 
      null named_LOV, 
      Ol0II1.application_id 
      from apex_application_page_regions Ol01lI 
      , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
              , level Ol0III 
         from ( select group_by_columns Il0IIl, ':' ll0IIl from apex_application_page_ir_grpby Il0IIl 
                    where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = IIl1I0 and report_id = Ol0l00.report_id ) 
         connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
       ) Ol0Il0, 
      apex_application_page_ir Il0II1, 
      apex_application_page_ir_rpt ll0III, 
      apex_application_page_ir_comp Ol0II1 
      where Ol01lI.region_id = Ol01Il 
      and Ol01lI.region_id = Il0II1.region_id 
      and ll0III.interactive_report_id = Il0II1.interactive_report_id 
      and ll0III.report_id = Ol0l00.report_id 
      and Ol0II1.computation_column_alias = Ol0Il0.col 
      and Ol0II1.report_id = ll0III.report_id 
      $END 
    ) 
    order by Ol0III; 
 
    
    for ll01I1 in 1..Ol01I0.count loop 
      Il0l01 := Il0l01||' grpby_col'||to_char(ll01I1)||'="'||Query2Report.IIlIll(Ol01I0(ll01I1).ll0100)||'"'; 
    end loop; 
 
    select * into Ol0l0I 
    from apex_application_page_ir_grpby Il0IIl 
    where application_id = APEX_APPLICATION.G_FLOW_ID 
    and page_id = IIl1I0 
    and report_id = Ol0l00.report_id; 
 
    if Ol0l0I.function_01 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_01, Ol0l0I.function_column_01))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_01, Ol0l0I.function_column_01)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_01; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_01; 
      ll0l01.display_sequence := 991; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_01; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
 
     if Ol0l0I.function_02 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_02, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_02, Ol0l0I.function_column_02))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_02, Ol0l0I.function_column_02)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_02; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_02; 
      ll0l01.display_sequence := 992; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_02; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
 
    if Ol0l0I.function_03 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_03, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_03, Ol0l0I.function_column_03))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_03, Ol0l0I.function_column_03)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_03; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_03; 
      ll0l01.display_sequence := 993; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_03; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
 
    if Ol0l0I.function_04 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_04, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_04, Ol0l0I.function_column_04))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_04, Ol0l0I.function_column_04)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_04; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_04; 
      ll0l01.display_sequence := 994; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_04; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
 
    if Ol0l0I.function_05 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_05, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_05, Ol0l0I.function_column_05))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_05, Ol0l0I.function_column_05)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_05; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_05; 
      ll0l01.display_sequence := 995; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_05; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
 
    if Ol0l0I.function_06 is not null then 
      ll0l01.ll0100 := OIl1ll(nvl(Ol0l0I.function_label_06, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_06, Ol0l0I.function_column_06))); 
      ll0l01.fullname := nvl(Ol0l0I.function_label_01, 
        Il0Il0(Ol01Il, IIl1I0, Ol0l00.report_id, Ol0l0I.function_06, Ol0l0I.function_column_06)); 
      ll0l01.col_type := 'NUMBER'; 
      ll0l01.alias := Ol0l0I.function_db_column_name_06; 
      ll0l01.format_mask := Ol0l0I.function_format_mask_06; 
      ll0l01.display_sequence := 996; 
      ll0l01.Ol0101 := Ol0l0I.function_sum_06; 
      Ol01I0.extend; 
      Ol01I0(Ol01I0.count) := ll0l01; 
    end if; 
return Ol01I0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll0l00', p_sqlerrm => sqlerrm ); 
  raise; 
end ll0l00; 
 
 
function Il0l0I( 
   Ol01Il            in number, 
   IIl1I0              in number, 
   IIl11l    in number, 
   Il0II0  in varchar2 default null, 
   ll0l0l             out varchar2, 
   Ol0l0l           out varchar2 
) 
return Ol0110 
as 
Il0l10 apex_application_page_ir_rpt%rowtype; 
begin 
  Ol0l0l := null; 
  ll0l0l := null; 
  Il0l10 := ll01Il(Ol01Il, IIl1I0); 
  if Il0l10.report_name is not null then 
    ll0l0l := 'IR_name="'||Il0l10.report_name||'"'; 
  end if; 
  if Il0l10.report_description is not null then 
    ll0l0l := ll0l0l||' IR_description="'||Il0l10.report_description||'"'; 
  end if; 
 
  pak_xslt_log.WriteLog( 'll0l0l: '||ll0l0l, p_log_type => pak_xslt_log.g_information, p_procedure => 'Il0l0I'); 
 
  if Il0l10.report_view_mode = 'GROUP_BY' then 
    return ll0l00(Ol01Il, IIl1I0, Il0l10, Ol0l0l); 
  else 
    return ll0I1l( 
       Ol01Il, 
       IIl1I0, 
       Il0l10.report_id, 
       IIl11l, 
       Il0II0 
    ); 
  end if; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il0l0I', p_sqlerrm => sqlerrm ); 
  raise; 
end Il0l0I; 
 
 
function OIlI01( 
  OIl111 varchar2 
) 
return varchar2 
as 
  function ll0l10(OIl111 varchar2) 
  return boolean 
  as 
  Ol0l11 varchar2(200); 
  begin 
    Ol0l11 := to_char(sysdate, OIl111); 
    return true; 
  exception 
    when others then 
    return false; 
  end; 
 
  function Il0l11(OIl111 varchar2) 
  return boolean 
  as 
  Ol0l11 varchar2(200); 
  begin 
    Ol0l11 := to_char(12345.45, OIl111); 
    return true; 
  exception 
    when others then 
    return false; 
  end; 
begin 
  if OIl111 is null then 
    return 'STRING'; 
  elsif Il0l11(OIl111) then 
    return 'NUMBER'; 
  elsif ll0l10(OIl111) then 
    return 'DATE'; 
  else 
    return 'STRING'; 
  end if; 
end; 
 
function  OIllll(Ol01Il in number) 
return t_coltype_table 
as 
ll0l1I  varchar2(32000); 
Il01I1            t_coltype_table; 
begin 
  select region_source 
  into ll0l1I 
  from apex_application_page_regions 
  where region_id = Ol01Il; 
 
  return Query2Report.OIllll(ll0l1I); 
end; 
 
 
function Ol0l1I( 
   Ol01Il in number, 
   IIl11l number 
) 
return Ol0110 
as 
Ol01I0 Ol0110; 
ll0l1I   varchar2(32000); 
Il0l1l     number default 1; 
ll0l1l        t_coltype_table; 
begin 
  pak_xslt_log.WriteLog( 'Ol01Il: '||to_char(Ol01Il)|| 
                         ' IIl11l: '||to_char(IIl11l), 
                          p_procedure => 'Ol0l1I'); 
 
  ll0l1l := OIllll(Ol01Il); 
 
  if IIl11l = 0 then 
    select OIl1ll(nvl(Ol0lI0.heading, Ol0lI0.column_alias)) heading 
         , nvl(Ol0lI0.heading, Ol0lI0.column_alias) fullname 
         , Ol0lI0.column_alias 
         
         , case when nvl(Ol0lI0.format_mask, nvl(Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values)) is not null then OIlI01(Ol0lI0.format_mask) else Il0lI0.coltype end column_type 
         , Ol0lI0.format_mask 
         , Ol0lI0.PRINT_COLUMN_WIDTH 
         , Ol0lI0.display_sequence 
         , substr(Ol0lI0.sum_column,1,1) Ol0101 
 
         $IF CCOMPILING.g_views_granted $THEN 
         , ll0lI1.query_column_id query_id 
         $ELSE 
         , null query_id 
         $END 
 
         , IIl10I(Ol0lI0.display_as_code, Ol0lI0.column_link_text, Ol0lI0.format_mask) IIl10I 
         , OIl1Il(Ol0lI0.application_id, Ol0lI0.column_alias, Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values) LOV_SQL 
         , null as ll010I
         , null as item_type
    bulk collect into Ol01I0 
    from apex_application_page_rpt_cols Ol0lI0 
    join table(ll0l1l) Il0lI0 on Ol0lI0.column_alias = Il0lI0.colname 
 
    $IF CCOMPILING.g_views_granted $THEN 
    join APEX_RPT_COLS_QUERY_ID ll0lI1 on Ol0lI0.region_report_column_id = ll0lI1.region_report_column_id 
    $END 
 
    where Ol0lI0.region_id = Ol01Il 
    
    and Ol0lI0.column_alias not like 'CHECK$__' 
    and Ol0lI0.column_alias not like 'DERIVED$__' 
    and   upper(Ol0lI0.column_alias) <> 'ROWID' 
    order by Ol0lI0.display_sequence; 
  elsif IIl11l = 2 then 
    select OIl1ll(nvl(Ol0lI0.heading, Ol0lI0.column_alias)) heading 
     , nvl(Ol0lI0.heading, Ol0lI0.column_alias) fullname 
     , Ol0lI0.column_alias 
     , case when nvl(Ol0lI0.format_mask, nvl(Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values)) is not null then OIlI01(Ol0lI0.format_mask) else Il0lI0.coltype end column_type 
     , Ol0lI0.format_mask 
     , Ol0lI0.PRINT_COLUMN_WIDTH 
     , Ol0lI0.display_sequence 
     , substr(Ol0lI0.sum_column,1,1) Ol0101 
 
     $IF CCOMPILING.g_views_granted $THEN 
     , ll0lI1.query_column_id query_id 
     $ELSE 
     , null query_id 
     $END 
 
     , IIl10I(Ol0lI0.display_as_code, Ol0lI0.column_link_text, Ol0lI0.format_mask) IIl10I 
     , OIl1Il(Ol0lI0.application_id, Ol0lI0.column_alias, Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values) LOV_SQL 
     , null as ll010I
     , null as item_type
    bulk collect into Ol01I0 
    from apex_application_page_rpt_cols Ol0lI0 
    join table(ll0l1l) Il0lI0 on Ol0lI0.column_alias = Il0lI0.colname 
 
    $IF CCOMPILING.g_views_granted $THEN 
    join APEX_RPT_COLS_QUERY_ID ll0lI1 on Ol0lI0.region_report_column_id = ll0lI1.region_report_column_id 
    $END 
 
    where Ol0lI0.region_id = Ol01Il 
    and   nvl( Ol0lI0.include_in_export, 'Yes') = 'Yes' 
    and   Ol0lI0.COLUMN_IS_HIDDEN <>'Yes' 
    and   nvl(Ol0lI0.Primary_key_column_source_type, 'N') <> 'Il0lI0' 
    and   Ol0lI0.display_as_code <> 'HIDDEN' 
    and   Ol0lI0.column_alias not like 'CHECK$__' 
    and   Ol0lI0.column_alias not like 'DERIVED$__' 
    and   upper(Ol0lI0.column_alias) <> 'ROWID' 
    
    order by Ol0lI0.display_sequence; 
  elsif IIl11l = 1 then 
    select OIl1ll(nvl(Ol0lI0.heading, Ol0lI0.column_alias)) heading 
         , nvl(Ol0lI0.heading, Ol0lI0.column_alias) fullname 
         , Ol0lI0.column_alias 
         , case when nvl(Ol0lI0.format_mask, nvl(Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values)) is not null then OIlI01(Ol0lI0.format_mask) else Il0lI0.coltype end column_type 
         , Ol0lI0.format_mask 
         , Ol0lI0.PRINT_COLUMN_WIDTH 
         , Ol0lI0.display_sequence 
         , substr(Ol0lI0.sum_column,1,1) Ol0101 
 
         $IF CCOMPILING.g_views_granted $THEN 
         , ll0lI1.query_column_id query_id 
         $ELSE 
         , null query_id 
         $END 
 
         , IIl10I(Ol0lI0.display_as_code, Ol0lI0.column_link_text, Ol0lI0.format_mask) IIl10I 
         , OIl1Il(Ol0lI0.application_id, Ol0lI0.column_alias, Ol0lI0.named_list_of_values, Ol0lI0.inline_list_of_values) LOV_SQL 
         , null as ll010I
         , null as item_type
    bulk collect into Ol01I0 
    from apex_application_page_rpt_cols Ol0lI0 
    join table(ll0l1l) Il0lI0 on Ol0lI0.column_alias = Il0lI0.colname 
 
    $IF CCOMPILING.g_views_granted $THEN 
    join APEX_RPT_COLS_QUERY_ID ll0lI1 on Ol0lI0.region_report_column_id = ll0lI1.region_report_column_id 
    $END 
 
    where Ol0lI0.region_id = Ol01Il 
    and   nvl( Ol0lI0.include_in_export, 'Yes') = 'Yes' 
    and   Ol0lI0.column_alias not like 'CHECK$__' 
    and   Ol0lI0.column_alias not like 'DERIVED$__' 
    and   upper(Ol0lI0.column_alias) <> 'ROWID' 
    
    
    order by Ol0lI0.display_sequence; 
  end if; 
  return Ol01I0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Ol0l1I', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol0l1I; 
 
 
 
function Ol0lI1( 
  Il0lII varchar2, 
  Ol01I0 Il011I 
) return varchar2 
as 
Il01I1 varchar2(1000); 
ll0lII Il0110 := Il0110(); 
Ol0lIl varchar2(20); 
begin 
  Il01I1 := Il0lII; 
  pak_xslt_log.WriteLog( 'Il0lII '||Il0lII, 
   p_procedure => 'Ol0lI1'); 
  for ll01I1 in 1..length(Il0lII) loop 
    if substr(Il0lII,ll01I1,1) between 'A' and 'Z' then 
      Ol0lIl := Ol0lIl || substr(Il0lII,ll01I1,1); 
      
      
    else 
      if length(Ol0lIl) in (1,2) and Ol01I0.exists(Ol0lIl) then 
        
        ll0lII.extend; 
        ll0lII(ll0lII.count) := Ol0lIl; 
        pak_xslt_log.WriteLog( 'Added to table at '|| ll0lII.count||' Ol0lIl '||Ol0lIl, 
        p_procedure => 'Ol0lI1'); 
      end if; 
      Ol0lIl := ''; 
    end if; 
  end loop; 
  
 
  pak_xslt_log.WriteLog( 'end loop Il0lII Ol0lIl '||Ol0lIl, 
    p_procedure => 'Ol0lI1'); 
 
  if length(Ol0lIl) in (1,2) then 
    
    ll0lII.extend; 
    ll0lII(ll0lII.count) := Ol0lIl; 
    pak_xslt_log.WriteLog( 'Added to table at '|| ll0lII.count||' Ol0lIl '||Ol0lIl, 
    p_procedure => 'Ol0lI1'); 
  end if; 
 
  
 
  for ll01I1 in 1..ll0lII.count loop 
    
    pak_xslt_log.WriteLog( 'Before regexp_replace ll01I1 '||ll01I1|| ' Ol01I0(ll0lII(ll01I1)) '||Ol01I0(ll0lII(ll01I1))|| 
                          ' ll0lII(ll01I1) '||ll0lII(ll01I1), 
                            p_procedure => 'Ol0lI1'); 
 
    Il01I1 := regexp_replace(Il01I1, '(^|\W)('||ll0lII(ll01I1)||')(\W|$)', '\1'||Ol01I0(ll0lII(ll01I1))||'\3'); 
    
    pak_xslt_log.WriteLog( 'After regexp_replace Il01I1 '||Il01I1, p_procedure => 'Ol0lI1'); 
  end loop; 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'Ol0lI1', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol0lI1; 
 
 
function Il0lIl( 
  ll0ll0 varchar2, 
  Ol0ll0 varchar2, 
  Il0ll1 varchar2 
) 
return varchar2 
as 
  ll0ll1 pls_integer; 
  Ol0llI pls_integer; 
  Il0llI pls_integer; 
  ll0lll varchar2(32767); 
  Ol0lll varchar2(32767); 
 
begin 
  Ol0lll := ll0ll0; 
  if instr( Ol0lll, '#APXWS_EXPR#' ) > 0 
  then 
    Ol0lll := replace( Ol0lll, '#APXWS_EXPR#', '''' || replace( Ol0ll0, '''', '''''' ) || '''' ); 
  end if; 
  if instr( Ol0lll, '#APXWS_EXPR2#' ) > 0 
  then 
    Ol0lll := replace( Ol0lll, '#APXWS_EXPR2#', '''' || replace( Il0ll1, '''', '''''' ) || '''' ); 
  end if; 
  
  Ol0llI := 1; 
  ll0ll1 := 1; 
  while instr( Ol0lll, '#APXWS_EXPR_VAL' || ll0ll1 || '#' ) > 0 
  loop 
    Il0llI := instr( Ol0ll0 || ',', ',', Ol0llI ); 
    ll0lll := trim( substr( Ol0ll0, Ol0llI, Il0llI - Ol0llI ) ); 
    if ll0lll is null 
    then 
      Ol0lll := replace( Ol0lll, ', #APXWS_EXPR_VAL' || ll0ll1 || '#' ); 
      Ol0lll := replace( Ol0lll, '#APXWS_EXPR_VAL' || ll0ll1 || '# ,' ); 
    else 
      Ol0lll := replace( Ol0lll, '#APXWS_EXPR_VAL' || ll0ll1 || '#', '''' || replace( ll0lll, '''', '''''' ) || '''' ); 
    end if; 
    ll0ll1 := ll0ll1 + 1; 
    Ol0llI := Il0llI + 1; 
  end loop; 
  return Ol0lll; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'Il0lIl', p_sqlerrm => sqlerrm ); 
  raise; 
end Il0lIl; 
 
 
 
 
function Il1000( 
  ll0ll0 varchar2, 
  Ol0ll0 varchar2, 
  Il0ll1 varchar2, 
  ll1000 varchar2, 
  Ol1001 varchar2, 
  Il1001 varchar2, 
  ll100I varchar2, 
  Ol100I varchar2, 
  Il100l varchar2
) 
return varchar2 
as 
begin 
  return 
  replace(apexrep2report.Il0lIl(ll0ll0, Ol0ll0, Il0ll1), '#APXWS_HL_ID#', 
  '''highlight_name="'||ll1000||'" '|| 
  'highlight_col="'||Query2Report.IIlIll(Il100l)||'" '|| 
  'highlight_cell="'|| 
  case when nvl(Ol1001, Il1001)  is not null then 'true' else 'false' end||'" '|| 
  'highlight_bkg_color="'||nvl(ll100I, Ol1001)||'" '|| 
  'highlight_font_color="'||nvl(Ol100I, Il1001)||'"'''); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'Il1000', p_sqlerrm => sqlerrm ); 
  raise; 
end Il1000; 
 
 
 
$IF CCOMPILING.g_views_granted $THEN 
function ll100l( 
    IIl1I0 number, 
    Ol01Il number 
) 
return varchar2 
as 
ll0II0 number; 
Ol1010 varchar2(32767); 
Il1010 varchar2(4000); 
Ol01I0 Il011I; 
 
cursor ll1011 is 
  select Ol1011.column_alias 
        , Ol1011.display_order 
        , cid.column_identifier 
    from apex_application_page_ir_col Ol1011 
    join apex_application_page_ir_colid cid on Ol1011.column_id = cid.column_id 
    where Ol1011.region_id = Ol01Il; 
 
cursor Il101I(ll101I number) is 
 select 
    Ol0II1.computation_column_alias column_alias, 
    Ol0II1.COMPUTATION_EXPRESSION Ol101l 
   from apex_application_page_regions Ol01lI 
   join apex_application_page_ir Il0II1 on Ol01lI.region_id = Il0II1.region_id 
   join apex_application_page_ir_rpt ll0III on ll0III.interactive_report_id = Il0II1.interactive_report_id 
   join apex_application_page_ir_comp Ol0II1 on Ol0II1.report_id = ll0III.report_id 
   where Ol01lI.region_id = Ol01Il 
   and ll0III.report_id = ll101I 
   order by column_alias; 
 
begin 
  for Il101l in ll1011 loop 
    Ol01I0(Il101l.column_identifier) := Il101l.column_alias; 
  end loop; 
 
  ll0II0 := ll01Il(Ol01Il, IIl1I0).report_id; 
  for ll10I0 in Il101I(ll0II0) loop 
    Ol1010 := Ol1010||', '||Ol0lI1(ll10I0.Ol101l, Ol01I0)|| 
                      ' "'||ll10I0.column_alias||'"'; 
 
  end loop; 
 
  pak_xslt_log.WriteLog( ' Ol01Il '||Ol01Il|| ' Ol1010: '||Ol1010, 
                          p_procedure => 'll100l' 
                        ); 
 
  
   
   return Ol1010; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error IIl1I0 '||IIl1I0||' Ol01Il '||Ol01Il, 
                          p_log_type => pak_xslt_log.g_error, 
                          p_procedure => 'll100l', 
                          p_sqlerrm => sqlerrm 
                        ); 
  raise; 
end; 
$END 
 
function Ol10I0(Il10I1 in varchar2) 
return Il0110 
AS 
ll10I1         Il0110 := Il0110(); 
Ol10II            VARCHAR2(4000) default Il10I1 || ':'; 
ll01I1                    number; 
Il10II          varchar2(30); 
begin 
loop 
ll01I1 := instr(Ol10II, ':'); 
exit when nvl(ll01I1,0) = 0; 
Il10II := trim(substr(Ol10II, 1, ll01I1-1)); 
if Il10II <>'0' then 
  ll10I1.extend; 
  ll10I1(ll10I1.count) := trim(substr(Ol10II, 1, ll01I1-1)); 
END IF; 
Ol10II := substr(Ol10II, ll01I1 + length(':')); 
end loop; 
return ll10I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'Ol10I0', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol10I0; 
 
 
function ll10Il( 
  Ol10Il apex_application_page_ir_rpt%rowtype 
) 
return varchar2 
as 
Il10l0 varchar2(4000); 
begin 

  if nvl(Ol10Il.sort_column_1, '0') <> '0' 
  then 
    Il10l0 := ' "' || Ol10Il.sort_column_1 || '" ' || Ol10Il.sort_direction_1; 
    if nvl(Ol10Il.sort_column_2, '0') <> '0' 
    then 
      Il10l0 := Il10l0 || ', "' || Ol10Il.sort_column_2 || '" ' || Ol10Il.sort_direction_2; 
    end if; 
    if nvl(Ol10Il.sort_column_3, '0') <> '0' 
    then 
      Il10l0 := Il10l0 || ', "' || Ol10Il.sort_column_3 || '" ' || Ol10Il.sort_direction_3; 
    end if; 
    if nvl(Ol10Il.sort_column_4, '0') <> '0' 
    then 
      Il10l0 := Il10l0 || ', "' || Ol10Il.sort_column_4 || '" ' || Ol10Il.sort_direction_4; 
    end if; 
    if nvl(Ol10Il.sort_column_5, '0') <> '0' 
    then 
      Il10l0 := Il10l0 || ', "' || Ol10Il.sort_column_5 || '" ' || Ol10Il.sort_direction_5; 
    end if; 
    if nvl(Ol10Il.sort_column_6, '0') <> '0' 
    then 
      Il10l0 := Il10l0 || ', "' || Ol10Il.sort_column_6 || '" ' || Ol10Il.sort_direction_6; 
    end if; 
  end if; 
  pak_xslt_log.WriteLog( 'return '||Il10l0, p_procedure => 'll10Il' ); 
  return Il10l0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'll10Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
function ll10Il( 
  Ol10Il apex_application_page_ir_grpby%rowtype, 
  ll10l0 varchar2 
) 
return varchar2 
as 
Il10l0 varchar2(4000); 
begin 

  if nvl(Ol10Il.sort_column_01, '0') <> '0' and regexp_instr(ll10l0,'(:|^)'||Ol10Il.sort_column_01||'(:|$)') > 0 
  then 
    Il10l0 := ' ' || Ol10Il.sort_column_01 || ' ' || Ol10Il.sort_direction_01; 
 
    if nvl(Ol10Il.sort_column_02, '0') <> '0' and regexp_instr(ll10l0,'(:|^)'||Ol10Il.sort_column_02||'(:|$)') > 0 
    then 
      Il10l0 := Il10l0 || ', ' || Ol10Il.sort_column_02 || ' ' || Ol10Il.sort_direction_02; 
    end if; 
    if nvl(Ol10Il.sort_column_03, '0') <> '0' and regexp_instr(ll10l0,'(:|^)'||Ol10Il.sort_column_03||'(:|$)') > 0 
    then 
      Il10l0 := Il10l0 || ', ' || Ol10Il.sort_column_03 || ' ' || Ol10Il.sort_direction_03; 
    end if; 
    if nvl(Ol10Il.sort_column_04, '0') <> '0' and regexp_instr(ll10l0,'(:|^)'||Ol10Il.sort_column_04||'(:|$)') > 0 
    then 
      Il10l0 := Il10l0 || ', ' || Ol10Il.sort_column_04 || ' ' || Ol10Il.sort_direction_04; 
    end if; 
  end if; 
  pak_xslt_log.WriteLog( 'return '||Il10l0, p_procedure => 'll10Il(group_by)' ); 
  return Il10l0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, 
  p_procedure => 'll10Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure Ol10l1( 
    Ol01Il number, 
    IIl1I0 number, 
    Ol10Il apex_application_page_ir_rpt%rowtype, 
    Il10l1 out varchar2, 
    ll10lI out varchar2 
) 
as 
  Ol01l1 number; 
  ll01l0 varchar2(32767); 
  
  Ol10lI varchar2(32767); 
  
 
  
  
  cursor Il10ll is 
  select replace(ll10ll.condition_sql, '#APXWS_CC_EXPR#',ll10ll.condition_column_name) condition_sql 
        , ll10ll.condition_type 
        , ll10ll.condition_expr_type 
        , ll10ll.condition_expression 
        , ll10ll.condition_expression2 
   from apex_application_page_ir_cond ll10ll 
   where ll10ll.application_id = APEX_APPLICATION.G_FLOW_ID
   and   ll10ll.page_id = IIl1I0 
   and   ll10ll.report_id = Ol10Il.report_id 
   and   ll10ll.condition_enabled = 'Yes' 
   and   ll10ll.condition_type in ( 'Filter', 'Search' ); 
 
 
   cursor Ol1100(Il1100 varchar2) is 
   select col.column_alias 
   from apex_application_page_ir_col col 
      , ( select substr( Il0IIl, instr( ll0IIl || Il0IIl, ll0IIl, 1, level ), instr( Il0IIl || ll0IIl, ll0IIl, 1, level ) - instr( ll0IIl || Il0IIl, ll0IIl, 1, level ) ) col 
               , level Ol0III 
         from ( select Il1100 Il0IIl 
                     , ':' ll0IIl from dual ) 
         connect by level <= length( Il0IIl ) - nvl( length( replace( Il0IIl, ll0IIl ) ), 0 ) + 1 
        ) Ol0Il0 
  where col.application_id = APEX_APPLICATION.G_FLOW_ID 
  and   col.page_id = IIl1I0 
  and   col.region_id = Ol01Il 
  and   col.column_alias = Ol0Il0.col 
  and   col.allow_filtering = 'Yes' 
  and   col.column_type in ( 'STRING', 'NUMBER', 'CLOB' ); 
 
begin 
  
  ll10lI := ''; 
  Il10l1 := ''; 
  for ll1101 in Il10ll 
  loop 
    if (   ll1101.condition_type = 'Filter' 
       and ll1101.condition_sql is not null 
       ) 
    then 
      if ll1101.condition_expr_type = 'ROW' 
      then 
        if ll10lI is null then 
          ll10lI := '(' || ll1101.condition_sql || ')'; 
        else 
          ll10lI := ll10lI ||' and (' || ll1101.condition_sql || ')'; 
        end if; 
      else 
        if ll10lI is null then 
          ll10lI := Il0lIl(ll1101.condition_sql, ll1101.condition_expression, ll1101.condition_expression2); 
        else 
          ll10lI := ll10lI ||' and '|| Il0lIl(ll1101.condition_sql, ll1101.condition_expression, ll1101.condition_expression2); 
        end if; 
      end if; 
    end if; 

    if ll1101.condition_type = 'Search' 
    then 
      for Ol1101 in Ol1100(Ol10Il.report_columns) 
      loop 
        Ol10lI := Ol10lI || 'or instr( upper( "' || Ol1101.column_alias || '" ), upper( ''' || replace( ll1101.condition_expression, '''', '''''' ) || ''' ) ) > 0 '; 
      end loop; 
      if Ol10lI is not null 
      then 
        if length(trim(ll10lI)) > 0 then 
          ll10lI := ll10lI||' and ( ' || ltrim( Ol10lI, 'or' ) || ' )'; 
        else 
          ll10lI := ll10lI||' ( ' || ltrim( Ol10lI, 'or' ) || ' )'; 
        end if; 
      end if; 
    end if; 
  end loop; 

   
 
  Il10l1 := ll10Il(Ol10Il); 
   
 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Ol10l1', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol10l1; 
 
function Il110I( 
  ll110I varchar2, 
  Ol0Il1 varchar2 
  
) 
return varchar2 
as 
Ol110l varchar2(30); 
begin 
  pak_xslt_log.WriteLog( 'Starting ll110I '||ll110I||' Ol0Il1 '||Ol0Il1, 
                        p_procedure => 'Il110I'); 
  
  if ll110I like 'RATIO_TO_REPORT_%' then 
    Ol110l := substr(ll110I, instr(ll110I, '_', -1) + 1); 
    
    return '100 * RATIO_TO_REPORT('||Ol110l||'('||Ol0Il1||')) OVER() '; 
  elsif ll110I = 'COUNT_DISTINCT' then 
    return 'COUNT(DISTINCT '||Ol0Il1||') '; 
  else 
    return ll110I||'('||Ol0Il1||') '; 
  end if; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il110I', p_sqlerrm => sqlerrm ); 
  raise; 
end Il110I; 
 
 
procedure Il110l( 
  ll1110         in out varchar2, 
  Ol1110  in out varchar2, 

  ll110I varchar2, 
  Ol0Il1 varchar2, 
  Il1111 varchar2 
) 
as 

 
begin 
  if ll110I is not null then 
    ll1110 := ll1110 || ', ' || 
    Il110I(ll110I, Ol0Il1) || 
    Il1111; 
    Ol1110 := Ol1110|| ':' ||Ol0Il1; 
    
  end if; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il110l', p_sqlerrm => sqlerrm ); 
  raise; 
end Il110l; 
 
 
procedure ll1111( 
    IIl1I0 number, 
    Ol10Il apex_application_page_ir_rpt%rowtype, 
    Ol111I     out varchar2, 
    Il111I  out varchar2, 
    Il10l1      out varchar2 
) 
as 
ll111l apex_application_page_ir_grpby%rowtype; 
Ol111l varchar2(4000); 
 
begin 
  select * into ll111l 
  from apex_application_page_ir_grpby 
  where  page_id=IIl1I0 and report_id = Ol10Il.report_id; 
  Il111I := replace(ll111l.group_by_columns,':',', ');
  Ol111l := ll111l.group_by_columns; 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_01, 
        ll111l.function_column_01, 
        ll111l.function_db_column_name_01 
      ); 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_02, 
        ll111l.function_column_02, 
        ll111l.function_db_column_name_02 
      ); 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_03, 
        ll111l.function_column_03, 
        ll111l.function_db_column_name_03 
      ); 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_04, 
        ll111l.function_column_04, 
        ll111l.function_db_column_name_04 
      ); 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_05, 
        ll111l.function_column_05, 
        ll111l.function_db_column_name_05 
      ); 
      Il110l( 
        Il111I, 
        Ol111l, 
        ll111l.function_06, 
        ll111l.function_column_06, 
        ll111l.function_db_column_name_06 
      ); 
 
       
      Ol111I := replace(ll111l.group_by_columns,':',', '); 
      Il10l1 := ll10Il(ll111l, Ol111l); 
      Il01ll( 
        'll1111', 
        Il0I0I => Ol111I, 
        IIlI0l => Il10l1, 
        ll0I0I => Il111I 
      ); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll1111', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure Il11I0( 
    Ol01Il number, 
    IIl1I0 number, 
    IIl11l number, 
    ll11I0 out varchar2, 
    Ol111I out varchar2, 
    Il10l1 out varchar2, 
    ll10lI out varchar2, 
    Il111I out varchar2 
) 
as 
Il01l1 apex_application_page_ir_rpt%rowtype; 
 
begin 
  Il10l1 := null; 
  Il01l1 := ll01Il(Ol01Il, IIl1I0); 
 
  if IIl11l > 0 then 
    Ol10l1( 
      Ol01Il, 
      IIl1I0, 
      Il01l1, 
      Il10l1 => Il10l1, 
      ll10lI => ll10lI 
    ); 
  end if; 
 
  if Il01l1.report_view_mode = 'GROUP_BY' then 
    ll1111( 
        IIl1I0, 
        Il01l1, 
        Ol111I => Ol111I, 
        Il111I => Il111I, 
        Il10l1 => Il10l1 
    ); 
  else 
    
    ll11I0 :=Il01l1.report_columns; 
  end if; 
  Il01ll( 
    'Il11I0', 
    Ol01Il, 
    IIl11l, 
    Ol0I00 => ll11I0, 
    Il0I0I => Ol111I, 
    ll0I0I => Il111I, 
    IIlI0l => Il10l1, 
    Ol0I01 => ll10lI 
  ); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il11I0', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure Ol11I1( 
  
  Il11I1  in out varchar2, 
  ll11II   in out varchar2, 
  Ol11II  in out varchar2, 
  pio_grand_total_col_list in out varchar2,
  Il11Il in varchar2 default null, 
  p_grand_total_aggregates in varchar2 default null,   
  p_break_in_grand_total in boolean default false  
) 
as 
 
begin 
  Il11I1 := Il11I1|| 
    case when Ol11II is not null then ', null BREAKROW ' else '' end|| 
    case when ll11II is not null then ', null REGION_AGGREGATES ' else '' end; 
 
  if ll11II is not null then 
    ll11II := ll11II|| 
    case when Ol11II is not null then ', null BREAKROW ' else '' end|| 
    ', '''||Il11Il||''' REGION_AGGREGATES '; 
  end if; 
 
  if Ol11II is not null then 
    Ol11II := Ol11II||', 1 BREAKROW '|| 
    case when ll11II is not null then ', null REGION_AGGREGATES ' else '' end; 
  end if; 
  
  if pio_grand_total_col_list is not null then 
    pio_grand_total_col_list := pio_grand_total_col_list||', 2 BREAKROW '|| 
    case when pio_grand_total_col_list is not null then ', '''||p_grand_total_aggregates||''' REGION_AGGREGATES ' else '' end; 
  end if; 
 
   
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Ol11I1', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
 
function ll11Il( 
  
  ll01ll            Ol0110, 
  ll11I0 out varchar2, 
  Ol11l0  out varchar2 
) 
return boolean 
as 
 Il11l0 varchar2(4000); 
 ll11l1 boolean default false; 
 Ol11l1 varchar2(4000) default null; 
 III0110 varchar2(4000) default null; 
 begin 
  for ll01I1 in 1..ll01ll.count loop 
    if ll01I1 = 1 then 
      if ll01ll(ll01I1).Ol0101 = 'Y' then 
        Ol11l0 := 'SUM("'||ll01ll(ll01I1).alias||'") '; 
        if ll01ll(ll01I1).lov_sql is not null then 
          Ol11l0 := 'to_char('||Ol11l0||') '; 
        end if; 
        Il11l0 := Il11l0 || 'SUM,'||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||','; 
        ll11l1 := true; 
      else 
        Ol11l0 := 'null "'||ll01ll(ll01I1).alias||'" '; 
      end if; 
      ll11I0 := ' "'||ll01ll(ll01I1).alias||'" '; 
    else 
      if ll01ll(ll01I1).Ol0101 = 'Y' then 
        if ll01ll(ll01I1).lov_sql is not null then 
          Ol11l0 := Ol11l0||', to_char(SUM("'||ll01ll(ll01I1).alias||'")) '; 
        else 
          Ol11l0 := Ol11l0||', SUM("'||ll01ll(ll01I1).alias||'") '; 
        end if; 
        Il11l0 := Il11l0 || 'SUM,'||Query2Report.IIlIll(ll01ll(ll01I1).ll0100)||','; 
        ll11l1 := true; 
      else 
        Ol11l0 := Ol11l0||',null "'||ll01ll(ll01I1).alias||'"'; 
      end if; 
      ll11I0 := ll11I0||', "'||ll01ll(ll01I1).alias||'" '; 
    end if; 
  end loop; 
 
  if ll11l1 then 
    Ol11I1( 
      Il11I1 => ll11I0, 
      ll11II => Ol11l0, 
      Ol11II => Ol11l1, 
      pio_grand_total_col_list => III0110, 
      Il11Il => Il11l0 
    ); 
  else 
    Ol11l0 := null; 
  end if; 
 
  Il01ll( 
    'll11Il', 
    null, 
    null, 
    Ol0I00 => ll11I0, 
    Il0I00 => Ol11l0 
  ); 
 
  return ll11l1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll11Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
function Il11lI( 
  Ol01I0 Ol0110, 
  ll11lI varchar2 
) 
return varchar2 
as 
Ol11ll number; 
begin 
  pak_xslt_log.WriteLog( 'll11lI '||ll11lI||' Ol01I0: '||ll01I0(Ol01I0), p_procedure => 'Il11lI'); 
  Ol11ll := to_number(ll11lI); 
  for ll01I1 in 1..Ol01I0.count loop 
    if Ol01I0(ll01I1).query_id = Ol11ll then 
      return Ol01I0(ll01I1).alias; 
    end if; 
  end loop; 
  return ll11lI; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il11lI', p_sqlerrm => sqlerrm ); 
  return ll11lI; 
end; 
 
 
 
procedure Il11ll( 
    Ol01Il number, 
    IIl1I0 number, 
    IIl11l number, 
    ll1I00 out Ol0110, 
    ll11I0 out varchar2, 
    Ol11l0 out varchar2, 
    Il10l1 out varchar2 
    
    
) 
as 
  
  ll01l0 varchar2(32767); 
  Ol1I00 boolean default false; 
  
begin 
 
  ll1I00 :=  Ol0l1I(Ol01Il, IIl11l => IIl11l); 
  pak_xslt_log.WriteLog( 'Ol0l1I: '||ll01I0(ll1I00), p_procedure => 'Il11ll'); 
 
  if IIl11l > 0 
  then 
    ll01l0 := apex_util.get_preference( 'FSP' || to_char(APEX_APPLICATION.G_FLOW_ID) || '_P' || IIl1I0 || '_R' || Ol01Il || '_SORT', v('APP_USER')); 
    if instr( ll01l0, 'fsp_sort_' ) = 1 
    then 
      Il10l1 := substr( ll01l0, 10 ); 
      pak_xslt_log.WriteLog( 'Il10l1(1): '||Il10l1, p_procedure => 'Il11ll'); 
      if instr( Il10l1, 'desc' ) > 0 
      then 
        Il10l1 := substr( Il10l1, 1, instr( Il10l1, '_' ) - 1 ); 
        Il10l1 := Il11lI(ll1I00, Il10l1) || ' asc'; 
 
      else 
        Il10l1 := Il11lI(ll1I00, Il10l1) || ' desc'; 
      end if; 
      pak_xslt_log.WriteLog( 'Il10l1(2): '||Il10l1, p_procedure => 'Il11ll'); 
    end if; 
    if Il10l1 is null 
    then 
      Il10l1 := replace( substr( ll01l0, 10 ), '_', ' ' ); 
      pak_xslt_log.WriteLog( 'Il10l1(3): '||Il10l1, p_procedure => 'Il11ll'); 
      Il10l1 := Il11lI(ll1I00, Il10l1); 
      pak_xslt_log.WriteLog( 'Il10l1(4): '||Il10l1, p_procedure => 'Il11ll'); 
    end if; 
  end if; 
 
  Ol1I00 := ll11Il( 
    ll1I00, 
    ll11I0 => ll11I0, 
    Ol11l0 => Ol11l0 
  ); 
 
  if Ol1I00 then 
    if Il10l1 is null then 
      Il10l1 := 'REGION_AGGREGATES desc '; 
    else 
      $IF CCOMPILING.g_views_granted $THEN 
        Il10l1 := 'REGION_AGGREGATES desc, '||Il10l1; 
      $ELSE 
        Il10l1 := 'REGION_AGGREGATES desc '; 
      $END 
 
    end if; 
  end if; 
 
  Il01ll( 
    'Il11ll', 
    Ol01Il, 
    IIl11l, 
    Ol0I00 => ll11I0, 
    Il0I00 => Ol11l0, 
    IIlI0l => Il10l1 
  ); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il11ll', p_sqlerrm => sqlerrm ); 
  raise; 
end Il11ll; 
 
function Il1I01( 
  ll1I01 query2report.tab_string 
) 
return CLOB 
as 
ll01I1 number default 1; 
Il01I1 CLOB; 
begin 
  dbms_lob.CreateTemporary(Il01I1, false); 
  for ll01I1 in 1..ll1I01.count() loop 
    dbms_lob.writeappend(Il01I1, length(ll1I01(ll01I1)), ll1I01(ll01I1)); 
    if ll01I1 < ll1I01.count() then 
      dbms_lob.writeappend(Il01I1, 3, ';'||query2report.g_crlf); 
    else 
      dbms_lob.writeappend(Il01I1, 1, ';'); 
    end if; 
  end loop; 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il1I01', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
function Ol1I0I(OIl111 varchar2, Il1I0I varchar2) 
return boolean 
as 
ll1I0l    varchar2(50); 
Ol1I0l  varchar2(50); 
begin 
  if Il1I0I = 'STRING' then 
    return Ol1I0I(OIl111, 'DATE') or Ol1I0I(OIl111, 'NUMBER'); 
  elsif Il1I0I = 'DATE' then 
    ll1I0l := to_char(sysdate, OIl111); 
  elsif Il1I0I = 'NUMBER' then 
    Ol1I0l := to_char(9999999.99, OIl111); 
  end if; 
  RETURN TRUE; 
EXCEPTION 
    WHEN OTHERS THEN 
        RETURN FALSE; 
end Ol1I0I; 
 
 
function Il1I10( 
  ll1I10 Il0100, 
  OIl1I0 number, 
  Ol1I11 in out varchar2, 
  Il1I11 in out varchar2 
) 
return varchar2 
as 
Il01I1 varchar2(256); 
Il0IlI varchar2(256); 
ll1I1I varchar2(256); 
begin 
  if (ll1I10.IIl10I > 0 and OIl1I0 = 1) 
  or (ll1I10.IIl10I = 2 and OIl1I0 in (0,2)) 
  then 
    return null; 
  end if; 
  if ll1I10.display_sequence = 0 or ll1I10.ll0100 is null or length(ll1I10.ll0100) = 0 then 
    Il0IlI := '"'||ll1I10.alias||'"'; 
  else 
    Il0IlI := '"'||Query2Report.IIlIll(ll1I10.ll0100)||'"'; 
  end if; 
  if (ll1I10.format_mask is not null and Ol1I0I(ll1I10.format_mask, ll1I10.col_type))
      or ll1I10.item_type = 'NATIVE_YES_NO'
  then 
    
    if ll1I10.item_type = 'NATIVE_YES_NO' then
       ll1I1I  := ' decode("'||ll1I10.alias||'", ''Y'', ''Yes'', ''N'', ''No'')';
    else
        if ll1I10.col_type = 'NUMBER' then 
          ll1I1I := ' trim(to_char("'||ll1I10.alias||'", '''||ll1I10.format_mask||'''))'; 
        else 
          ll1I1I := ' to_char("'||ll1I10.alias||'", '''||ll1I10.format_mask||''')'; 
        end if; 
    end if;
  else 
    ll1I1I := ' "'||ll1I10.alias||'" '; 
  end if; 
  if (ll1I10.IIl10I > 0 and OIl1I0 in (0,4)) then 
    ll1I1I := ' query2report.html2str('||ll1I1I||')'; 
  end if; 
  Il01I1 := ll1I1I||' '||Il0IlI||','; 
 
  Il0IlI := trim('"' from Il0IlI); 
 
  if (ll1I10.IIl10I = 1 and OIl1I0 in (2,3)) then 
    if Ol1I11 is null then 
      Ol1I11 := 'html_cols="'||Il0IlI ; 
    else 
      Ol1I11 := Ol1I11||','||Il0IlI ; 
    end if; 
  end if; 
 
  if (ll1I10.IIl10I = 2 and OIl1I0 = 3) then 
    if Il1I11 is null then 
      Il1I11 := 'img_cols="'||Il0IlI ; 
    else 
      Il1I11 := Il1I11||','||Il0IlI ; 
    end if; 
  end if; 
 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Il1I10', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure Ol1I1I 
( 
  Il1I1l in out ll0111 
  ,ll1I1l in varchar2 
  ,Ol1II0 in varchar2 
) 
as 
Il1II0 Il0110 := Il0110(); 
begin 
  if ll1I1l is not null then 
    Il1II0:=Ol10I0(ll1I1l); 
    for ll01I1 in 1..Il1II0.count loop 
      Il1I1l.extend; 
      Il1I1l(Il1I1l.count).column_alias := Il1II0(ll01I1); 
      Il1I1l(Il1I1l.count).ll010I := Ol1II0; 
    end loop; 
  end if; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'Ol1I1I', p_sqlerrm => sqlerrm ); 
  raise; 
end Ol1I1I; 
 
 
function ll1II1( 
  IIl1I0         number, 
  Ol0l00         apex_application_page_ir_rpt%rowtype, 
  ll01ll            Ol0110, 
  ll11I0 out varchar2, 
  Ol11l0  out varchar2, 
  Ol1II1  out varchar2 
) 
return boolean 
as 
 
 ll11l1 boolean default false; 
 Il1III varchar2(32000); 
begin 
  ll11l1 := ll11Il( 
    ll01ll, 
    ll11I0 => ll11I0, 
    Ol11l0 => Ol11l0 
  ); 
  if ll11l1 then 
     
    Ol1II1 := 'REGION_AGGREGATES desc '; 
  end if; 
 
  return ll11l1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll1II1', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
function ll1III( 
  Ol01Il in number, 
  IIl1I0 in number, 
  Ol0l00 apex_application_page_ir_rpt%rowtype, 
  Ol1IIl out varchar2, 
  ll11I0 out varchar2, 
  Ol11l0 out varchar2, 
  Il1IIl out varchar2, 
  Ol1II1 out varchar2, 
  ll1Il0 out varchar2 
) 
return boolean 
as 
Ol1Il0 varchar2(50); 
Il1Il1 boolean; 
ll1Il1 boolean; 
Ol1I00 boolean default false; 
Ol1IlI boolean default false; 
Il1IlI number default 0; 
Il11l0 varchar2(4000); 
III0110 varchar2(4000) default null;  
ll1Ill ll0111 := ll0111(); 
 
 
cursor ll1011(ll101I number) is 
  select column_alias 
       , display_order 
       , column_type 
       , report_label 
    from apex_application_page_ir_col col 
    where page_id = IIl1I0 
    and region_id = Ol01Il 
     
    $IF CCOMPILING.g_views_granted $THEN 
    union 
 
    select 
    Ol0II1.computation_column_alias column_alias, 
    999 display_order, 
    Ol0II1.computation_column_type column_type, 
    Ol0II1.computation_report_label report_label 
   from apex_application_page_regions Ol01lI 
   join apex_application_page_ir Il0II1 on Ol01lI.region_id = Il0II1.region_id 
   join apex_application_page_ir_rpt ll0III on ll0III.interactive_report_id = Il0II1.interactive_report_id 
   join apex_application_page_ir_comp Ol0II1 on Ol0II1.report_id = ll0III.report_id 
   where Ol01lI.region_id = Ol01Il 
   and ll0III.report_id = ll101I 
   $END 
 
   order by display_order, column_alias; 
 
begin 
  
  Ol1I1I(ll1Ill, Ol0l00.SUM_COLUMNS_ON_BREAK, 'SUM'); 
  Ol1I1I(ll1Ill, Ol0l00.AVG_COLUMNS_ON_BREAK, 'AVG'); 
  Ol1I1I(ll1Ill, Ol0l00.MAX_COLUMNS_ON_BREAK, 'MAX'); 
  Ol1I1I(ll1Ill, Ol0l00.MIN_COLUMNS_ON_BREAK, 'MIN'); 
  Ol1I1I(ll1Ill, Ol0l00.MEDIAN_COLUMNS_ON_BREAK, 'MEDIAN'); 
  Ol1I1I(ll1Ill, Ol0l00.COUNT_COLUMNS_ON_BREAK, 'COUNT'); 
  Ol1I1I(ll1Ill, Ol0l00.COUNT_DISTNT_COL_ON_BREAK, 'COUNT_DISTINCT'); 
  Ol1I1I(ll1Ill, Ol0l00.BREAK_ENABLED_ON, 'GROUP BY'); 
 
  for Ol1Ill in ll1011(Ol0l00.report_id) loop 
    Il1Il1 := false; 
    ll1Il1 := false; 
    for ll01I1 in 1..ll1Ill.count loop 
      if Ol1Ill.column_alias = ll1Ill(ll01I1).column_alias then 
        Il1Il1 := true; 
        if ll1Ill(ll01I1).ll010I = 'GROUP BY' then 
          Ol1IlI := true; 
          if Ol11l0 is null then 
            Ol11l0 := ' '||Ol1Ill.column_alias; 
          else 
            Ol11l0 := Ol11l0||', '||Ol1Ill.column_alias; 
          end if; 
 
          if Il1IIl is null then 
            Il1IIl := ' distinct '||Ol1Ill.column_alias; 
          else 
            Il1IIl := Il1IIl||', '||Ol1Ill.column_alias; 
          end if; 
 
          if ll1Il0 is null then 
            ll1Il0 := ll1Ill(ll01I1).column_alias; 
          else 
            ll1Il0 := ll1Il0||', '||ll1Ill(ll01I1).column_alias; 
          end if; 
          Il1IlI := Il1IlI + 1; 
          Ol1IIl := Ol1IIl||'break_on_col'||to_char(Il1IlI)|| 
                        '="'||Query2Report.IIlIll(Ol1Ill.report_label)||'" '; 
 
 
        else 
          Ol1I00 := true; 
          if ll1Ill(ll01I1).ll010I = 'COUNT_DISTINCT' then 
            Ol1Il0 := 'round(COUNT(DISTINCT '||ll1Ill(ll01I1).column_alias||'),3)'; 
          else 
            Ol1Il0 := 'round('||ll1Ill(ll01I1).ll010I||'('||ll1Ill(ll01I1).column_alias||'),3)'; 
          end if; 
          Il11l0 := Il11l0 || ll1Ill(ll01I1).ll010I||','||Query2Report.IIlIll(Ol1Ill.report_label)||','; 
          if ll1Ill(ll01I1).ll010I like 'COUNT%' 
            
          then 
            ll1Il1 := true; 
            Ol1Il0 := 'to_char('||Ol1Il0||')'; 
          end if; 
          if Ol11l0 is null then 
            Ol11l0 := ' '||Ol1Il0||' '||ll1Ill(ll01I1).column_alias; 
          else 
            Ol11l0 := Ol11l0||', '||Ol1Il0||' '||ll1Ill(ll01I1).column_alias; 
          end if; 
 
          if Il1IIl is null then 
            Il1IIl := ' distinct null '||Ol1Ill.column_alias; 
          else 
            Il1IIl := Il1IIl||', null '||Ol1Ill.column_alias; 
          end if; 
 
        end if; 
      end if; 
    end loop; 
    if not Il1Il1 then 
      if Ol11l0 is null then 
        Ol11l0 := ' null '||Ol1Ill.column_alias; 
      else 
        Ol11l0 := Ol11l0||', null '||Ol1Ill.column_alias; 
      end if; 
 
      if Il1IIl is null then 
        Il1IIl := ' distinct null '||Ol1Ill.column_alias; 
      else 
        Il1IIl := Il1IIl||', null '||Ol1Ill.column_alias; 
      end if; 
    end if; 
 
    if ll11I0 is null then 
      if ll1Il1 then 
        ll11I0 := ' to_char('||Ol1Ill.column_alias||') '||Ol1Ill.column_alias; 
      else 
        ll11I0 := ' '||Ol1Ill.column_alias; 
      end if; 
    else 
      if ll1Il1 then 
        ll11I0 := ll11I0||', to_char('||Ol1Ill.column_alias||') '||Ol1Ill.column_alias; 
      else 
        ll11I0 := ll11I0||', '||Ol1Ill.column_alias; 
      end if; 
    end if; 
  end loop; 
 
  if Ol11l0 is not null then 
    if Ol1IlI then 
      
      Ol1II1 := trim(both ',' from ll1Il0); 
    end if; 
 
    if Ol1I00 then 
 
        if Ol1IlI then 
          Ol1II1 := Ol1II1||', BREAKROW, REGION_AGGREGATES desc '; 
          Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => III0110, 
            Il11Il => Il11l0 
          ); 
        else 
          Ol1II1 := 'REGION_AGGREGATES desc '; 
          Il1IIl := null; 
          Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => III0110, 
            Il11Il => Il11l0 
          ); 
        end if; 
    elsif Ol1IlI then
      pak_xslt_log.WriteLog( 'No ll010I just break', p_procedure => 'll1III'); 
      Ol11l0 := null; 
      Ol11I1( 
            Il11I1 => ll11I0, 
            ll11II => Ol11l0, 
            Ol11II => Il1IIl, 
            pio_grand_total_col_list => III0110, 
            Il11Il => Il11l0 
          ); 
      Ol1II1 := Ol1II1||', '||' BREAKROW'; 
    else 
      pak_xslt_log.WriteLog( 'No ll010I or break', p_procedure => 'll1III'); 
      Ol11l0 := null; 
      Il1IIl := null; 
    end if; 
  end if; 
  return Ol1I00; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'll1III', p_sqlerrm => sqlerrm ); 
  raise; 
end ll1III; 
 
 
procedure Il1l00( 
  
  Ol01Il             in number, 
  IIl1I0               in number, 
  IIl11l     in number, 
  Il11I1      in out varchar2, 
  Ol11l0        out varchar2, 
  Il1IIl       out varchar2, 
  ll1Il0  out varchar2, 
  Ol1II1   out varchar2, 
  ll1l00               out varchar2, 
  Ol1IIl            out varchar2, 
  Il0l01            out varchar2, 
  Ol1l01          out number, 
  ll1I00                 out Ol0110 
) 
as 
Il0l10 apex_application_page_ir_rpt%rowtype; 
 
Ol1I00 boolean; 
 
begin 
  ll1I00 := Il0l0I(Ol01Il, IIl1I0, IIl11l, Il11I1, ll1l00, Il0l01); 
  Il01ll( 
    'Il1l00 after Il0l0I', 
    Ol01Il, 
    IIl11l, 
    ll01ll => ll1I00 
  ); 
 
  Ol1l01 := Il0I1I(Ol01Il, IIl1I0); 
 
  Il0l10 := ll01Il(Ol01Il, IIl1I0); 
  if Il0l10.report_view_mode = 'GROUP_BY' then 
    Ol1IIl := null; 
    Ol1I00 := ll1II1( 
      
      IIl1I0, 
      Il0l10, 
      ll1I00, 
      
      ll11I0 => Il11I1, 
      Ol11l0 => Ol11l0, 
      Ol1II1 => Ol1II1 
    ); 
  else 
    Ol1I00 := ll1III( 
      
      Ol01Il, 
      IIl1I0, 
      Il0l10, 
      Ol1IIl => Ol1IIl, 
      ll11I0 => Il11I1, 
      Ol11l0 => Ol11l0, 
      Il1IIl => Il1IIl, 
      Ol1II1 => Ol1II1, 
      ll1Il0 => ll1Il0 
    ); 
  end if; 
  if not Ol1I00 then 
    Ol11l0 := null; 
  end if; 
  Il01ll( 
    'Il1l00', 
    Ol01Il, 
    IIl11l, 
    ll01ll => ll1I00, 
    Ol0I00 => Il11I1, 
    Il0I00 => Ol11l0, 
    ll0I01 => Il1IIl, 
    Ol0I0l => ll1Il0, 
    OIlI0I => Ol1II1, 
    ll0I10 => ll1l00, 
    Ol0I10 => Ol1IIl, 
    Il0I11 => Il0l01 
  ); 
 
end Il1l00; 
 
 
function Il1l01( 
  IIl1I0 number, 
  Ol01Il number, 
  Ol1II0 boolean 
) 
return varchar2 
as 
Il1010 varchar2(32767); 
ll0II0 number; 
 
cursor ll1l0I(ll101I number) is 
  select  Ol1l0I.condition_sql, 
          Ol1l0I.condition_expression, 
          Ol1l0I.condition_expression2, 
          Ol1l0I.condition_name, 
          Ol1l0I.highlight_cell_color, 
          Ol1l0I.highlight_cell_font_color, 
          Ol1l0I.highlight_row_color, 
          Ol1l0I.highlight_row_font_color, 
          col.report_label 
  from 
  apex_application_page_ir_cond Ol1l0I 
  join apex_application_page_ir_col col on 
  Ol1l0I.application_id = col.application_id 
  and Ol1l0I.page_id = col.page_id 
  and col.column_alias = Ol1l0I.condition_column_name 
   where Ol1l0I.page_id = IIl1I0 
   and Ol1l0I.report_id = ll101I 
   and Ol1l0I.condition_type = 'Highlight' 
   and Ol1l0I.condition_enabled = 'Yes' 
   order by Ol1l0I.highlight_sequence desc; 
 
 
begin 
  ll0II0 := ll01Il(Ol01Il, IIl1I0).report_id; 
 
  for Il1l0l in ll1l0I(ll0II0) loop 
    Il1010 := Il1010|| 
                        Il1000( 
                          Il1l0l.condition_sql, 
                          Il1l0l.condition_expression, 
                          Il1l0l.condition_expression2, 
                          Il1l0l.condition_name, 
                          Il1l0l.highlight_cell_color, 
                          Il1l0l.highlight_cell_font_color, 
                          Il1l0l.highlight_row_color, 
                          Il1l0l.highlight_row_font_color, 
                          Il1l0l.report_label 
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
    p_procedure => 'Il1l01', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end Il1l01; 
 
function IIl1lI(p_name varchar2) 
return varchar2 
as 
ll1l0l varchar2(50); 
Ol1l10 number := 1; 
Il1l10 varchar2(50); 
ll1l11 varchar2(50); 
Il01I1 varchar2(400); 

begin 
  Il01I1 := p_name; 
  
  
  loop 
    Ol1l10 := regexp_instr(Il01I1, '&([Ol0lI0-zA-Z0-9_]*).', Ol1l10); 
    exit when nvl(Ol1l10, 0) = 0; 
    ll1l0l := regexp_substr(Il01I1, '&([Ol0lI0-zA-Z0-9_]*).', Ol1l10); 
    exit when length(ll1l0l) = 0; 
    
    if substr(ll1l0l, length(ll1l0l), 1) = '.' then
        ll1l11 := ltrim(rtrim(ll1l0l,'.'),'&'); 

        
          

        if V(ll1l11) is not null then 
          Il01I1 := substr(Il01I1, 1, Ol1l10 - 1)||V(ll1l11)||substr(Il01I1, Ol1l10 + length(ll1l0l));    
          
        end if; 
    end if;    
    
    Ol1l10 := Ol1l10 + length(ll1l0l);
  end loop; 
  
 
  
      
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error: '||p_name, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'IIl1lI', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end IIl1lI; 
 
function OIl1ll(IIlI00 varchar2) 
return varchar2 
as 
Il01I1 varchar2(400); 
begin 
  Il01I1 := IIl1lI(IIlI00); 
  
  Il01I1 := Query2Report.IIlIll(Il01I1); 
  
  pak_xslt_log.WriteLog( 'Il01I1: '||Il01I1, 
      p_procedure => 'OIl1ll'); 
  return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error: '||IIlI00, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'OIl1ll', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end OIl1ll; 
 
function Ol1l11(Il1l1I varchar2) 
return varchar2 
as 
ll1l1I number; 
Ol1l1l number; 
ll0l1I varchar2(32767); 
Il1l1l varchar2(32767); 
 
begin 
  ll1l1I := instr(Il1l1I, ''''); 
  Ol1l1l := instr(Il1l1I, '''', 1, 2); 
 
  if nvl(ll1l1I, 0) = 0 or nvl(Ol1l1l, 0) = 0 then 
    ll0l1I := replace(Il1l1I, '#OWNER#', V('OWNER')); 
    ll0l1I := replace(ll0l1I, '#owner#', V('OWNER')); 
    ll0l1I := replace(ll0l1I, '#FLOW_OWNER#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER); 
    ll0l1I := replace(ll0l1I, '#flow_owner#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER); 
    return regexp_replace(ll0l1I, ':([Ol0lI0-zA-Z0-9_]*)','v(''\1'')'); 
  else 
    Il1l1l := substr(Il1l1I, 1 , ll1l1I - 1); 
    Il1l1l := replace(Il1l1l, '#OWNER#', V('OWNER')); 
    Il1l1l := replace(Il1l1l, '#owner#', V('OWNER')); 
    Il1l1l := replace(Il1l1l, '#FLOW_OWNER#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER); 
    Il1l1l := replace(Il1l1l, '#flow_owner#', APEX_APPLICATION.G_FLOW_SCHEMA_OWNER); 
    Il1l1l := regexp_replace(Il1l1l, ':([Ol0lI0-zA-Z0-9_]*)','v(''\1'')'); 
    ll0l1I := Il1l1l||
                       substr(Il1l1I, ll1l1I, Ol1l1l - ll1l1I+1); 
    if Ol1l1l < length(Il1l1I) then 
      ll0l1I := ll0l1I||Ol1l11(substr(Il1l1I, Ol1l1l + 1)); 
    end if; 
    RETURN ll0l1I; 
  end if; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'Ol1l11', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end Ol1l11; 
 
procedure ll1lI0( 
  Il0I0l           in varchar2, 
  Ol0I01                 in varchar2, 
  l10I0OI0      in number,   
  ll0I0I     in varchar2, 
  Ol1lI0               out varchar2, 
  Il1lI1 out varchar2 
) 
as 
 
begin 
  Il01ll( 
    p_procedure         =>  'll1lI0 start', 
    Il0I0l       => Il0I0l, 
    ll0I0I => ll0I0I, 
    Ol0I01             => Ol0I01 
  ); 
  if l10I0OI0 is not null then
      Ol1lI0 := 'region_src_joined_master'; 
      Il1lI1 := 'region_src_joined_master'; 
  else
      Ol1lI0 := 'region_src'; 
      Il1lI1 := 'region_src'; 
  end if;
 
  if Il0I0l is not null then 
    Il1lI1 := 'region_src_cc'; 
  end if; 
 
  if ll0I0I is not null then 
    Ol1lI0 := 'region_src_grpby'; 
  elsif Ol0I01 is not null then 
    Ol1lI0 := 'region_src_filtered'; 
  elsif Il0I0l is not null then 
    Ol1lI0 := 'region_src_cc'; 
  end if; 
 
  pak_xslt_log.WriteLog( 'Finished Ol1lI0 '||Ol1lI0|| 
                         ' Il1lI1 '||Il1lI1, 
  p_procedure => 'll1lI0'); 
end; 
 
function ll1lI1(Ol1lII varchar2) 
return varchar2 
as 
  Ol1011           NUMBER; 
  Il1lII           NUMBER; 
  col_cnt     INTEGER; 
  ll1lIl           BOOLEAN; 
  Ol1lIl     DBMS_SQL.DESC_TAB; 
  col_num    NUMBER; 
begin 
  if Ol1lII is null then 
    return null; 
  end if; 
 
  Ol1011 := DBMS_SQL.OPEN_CURSOR; 
  
  DBMS_SQL.PARSE(Ol1011, Ol1l11(Ol1lII), DBMS_SQL.NATIVE); 
  Il1lII := DBMS_SQL.EXECUTE(Ol1011); 
  DBMS_SQL.DESCRIBE_COLUMNS(Ol1011, col_cnt, Ol1lIl); 
  DBMS_SQL.CLOSE_CURSOR(Ol1011); 
  if col_cnt <> 2 then 
    return null; 
  end if; 
  return 'select '||Ol1lIl(1).col_name||' Il1lII, '||Ol1lIl(2).col_name||' v from ('||Ol1lII||')'; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error Ol1lII: '||Ol1lII, p_log_type => pak_xslt_log.g_error, p_procedure => 'll1lI1', p_sqlerrm => sqlerrm ); 
  raise; 
end ll1lI1; 
 
function OIl1Il( 
  IIl1Il number, 
  OIl1l0 varchar2, 
  IIl1l1 varchar2, 
  OIl1lI varchar2 
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
  if IIl1l1 is not null then 
    select list_of_values_query, lov_type 
    into Il1ll0, ll1ll0 
    from apex_application_lovs 
    where application_id = IIl1Il 
    and list_of_values_name = IIl1l1; 
 
    if ll1ll0 = 'Static' and IIl1Il is not null then 
      Il1ll0 := 'select display_value Il1lII, trim(ll10I1) v from APEX_APPLICATION_LOV_ENTRIES where application_id = '|| 
        IIl1Il||' and list_of_values_name = '''||IIl1l1||''''; 
      Il1lll := true; 
    end if; 
  elsif OIl1lI is not null then 
    if substr(upper(trim(OIl1lI)),1,6) = 'SELECT' then 
      Il1ll0 := OIl1lI; 
    elsif substr(upper(trim(OIl1lI)),1,6) = 'STATIC'  
          and instr(OIl1lI,';') > 0 
          and instr(OIl1lI,':') > 0 
    then 
      Ol1ll1 := substr(OIl1lI, instr(OIl1lI,':')+1); 
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
                       
    Il1ll0 := ll1lI1(Il1ll0); 
  end if; 
  return Il1ll0; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'OIl1Il', p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure ll1lll(                   
      Il0I0l                 IN varchar2,     
      Ol0I01                       IN varchar2,         
      ll01ll                        IN Ol0110,      
      l10I0OI0            IN integer,          
      pio_group_by_col_list           IN OUT varchar2, 
      Il11I1            IN OUT varchar2, 
      ll11II             IN OUT varchar2,
      pio_break_group_by_list       IN OUT varchar2,
      OlI000                     IN OUT varchar2, 
      Ol11II            IN OUT varchar2, 
      IlI000                OUT varchar2,    
      llI001           OUT varchar2,    
      OlI001         OUT varchar2     
)                                                
as 
IlI00I                varchar2(100); 
llI00I  varchar2(100); 
begin 
  Il01ll( 
    p_procedure         =>  'll1lll start', 
    ll01ll              => ll01ll, 
    Il0I0l       => Il0I0l, 
    ll0I0I => pio_group_by_col_list, 
    Ol0I00    => Il11I1, 
    Il0I00   => ll11II,
    Ol0I0l => pio_break_group_by_list,  
    Ol0I01             => OlI000, 
    ll0I01    => Ol11II, 
    ll0I11       => IlI000, 
    Ol0I1I  => llI001 
  ); 
  ll1lI0(Il0I0l, Ol0I01, l10I0OI0, pio_group_by_col_list, IlI00I, llI00I); 
  
  for ll01I1 in 1..ll01ll.count loop 
    if ll01ll(ll01I1).lov_sql is not null then 
      Il11I1 := regexp_replace(Il11I1, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)', 
                            '\1'||ll01ll(ll01I1).alias||'_LOV.Il1lII \2'||ll01ll(ll01I1).alias||'\3\4'); 
      
      if pio_group_by_col_list is not null then
          pio_group_by_col_list := regexp_replace(pio_group_by_col_list, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)',     
                            '\1'||ll01ll(ll01I1).alias||'_LOV.Il1lII \2'||ll01ll(ll01I1).alias||'\3\4');                       
      end if;                                              
      
      if nvl(instr(ll11II, 'null '||ll01ll(ll01I1).alias), 0) = 0 
         and nvl(instr(ll11II, 'null "'||ll01ll(ll01I1).alias||'"'), 0) = 0    
      then 
          ll11II := regexp_replace(ll11II, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)',     
                            '\1'||ll01ll(ll01I1).alias||'_LOV.Il1lII \2'||ll01ll(ll01I1).alias||'\3\4');                       
      end if;                                              
                            
      if pio_break_group_by_list is not null then
          pio_break_group_by_list := replace(pio_break_group_by_list, ll01ll(ll01I1).alias, ll01ll(ll01I1).alias||'_LOV.Il1lII '); 
      end if;
      
      if nvl(instr(Ol11II, 'null '||ll01ll(ll01I1).alias), 0) = 0 
         and nvl(instr(Ol11II, 'null "'||ll01ll(ll01I1).alias||'"'), 0) = 0    
      then 
          Ol11II := regexp_replace(Ol11II, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)', 
                                '\1'||ll01ll(ll01I1).alias||'_LOV.Il1lII \2'||ll01ll(ll01I1).alias||'\3\4'); 
      end if;
      
      
      
      if OlI000 is not null then 
        OlI000 := regexp_replace(OlI000, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)', 
                              '\1\2'||ll01ll(ll01I1).alias||'_LOV\3.Il1lII\4 '); 
      end if; 
      if IlI000 is null then 
        IlI000 := ll01ll(ll01I1).alias||'_LOV as ('||ll01ll(ll01I1).lov_sql||')'; 
      else 
        IlI000 := IlI000||query2report.g_crlf||','||ll01ll(ll01I1).alias||'_LOV as ('||ll01ll(ll01I1).lov_sql||')'; 
      end if; 
      OlI001 := OlI001||query2report.g_crlf||'left outer join '||ll01ll(ll01I1).alias||'_LOV on '|| 
                             ll01ll(ll01I1).alias||'_LOV.v = '||llI00I||'.'||ll01ll(ll01I1).alias; 
 
      llI001 := llI001||query2report.g_crlf||'left outer join '||ll01ll(ll01I1).alias||'_LOV on '|| 
                             ll01ll(ll01I1).alias||'_LOV.v = '||IlI00I||'.'||ll01ll(ll01I1).alias; 
    else 
      Il11I1 := regexp_replace(Il11I1, '(\W|^)("?)'||ll01ll(ll01I1).alias||'("?)(\W|$)', 
                            '\1'||IlI00I||'.\2'||ll01ll(ll01I1).alias||'\3\4'); 
      
      
      Il11I1 := replace(Il11I1, 
                                    'to_char('||IlI00I||'.'||ll01ll(ll01I1).alias||') '||IlI00I||'.'||ll01ll(ll01I1).alias||',', 
                                    'to_char('||IlI00I||'.'||ll01ll(ll01I1).alias||') '||ll01ll(ll01I1).alias||','); 
    end if; 
  end loop; 
 
  Il01ll( 
    p_procedure         =>  'll1lll end', 
    ll01ll              => ll01ll, 
    Il0I0l       => Il0I0l, 
    ll0I0I => pio_group_by_col_list, 
    Ol0I00    => Il11I1, 
    Il0I00   => ll11II,
    Ol0I0l => pio_break_group_by_list,  
    Ol0I01             => OlI000, 
    ll0I01    => Ol11II, 
    ll0I11       => IlI000, 
    Ol0I1I  => llI001 
  ); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'll1lll', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end ll1lll; 
 
 
function OlI00l( 
  IIl1I0 number, 
  Ol01Il number, 
  IlI00l varchar2, 
  ll01ll Ol0110, 
  OIl1I0 number, 
  llI010 boolean default false, 
  Ol1II0 boolean default false, 
  OlI010 boolean default false, 
  IlI011 out varchar2, 
  llI011 out varchar2 
) 
return varchar2 
as 
OlI01I varchar2(32767); 
IlI01I varchar2(32767); 
Il1010 varchar2(32767); 
begin 
  
  for cc in 1 .. ll01ll.count() loop 
    OlI01I := OlI01I || 
                  Il1I10( 
                    ll01ll(cc), 
                    OIl1I0, 
                    IlI011, 
                    llI011 
                  ); 
    IlI01I:= IlI01I||ll01ll( cc ).alias||'|'||ll01ll( cc ).ll0100||', '; 
  end loop; 
 
  if OlI01I is not null then 
    if llI010 then 
      OlI01I := OlI01I||' BREAKROW,'; 
    end if; 
    if Ol1II0 then 
      OlI01I := OlI01I||' REGION_AGGREGATES,'; 
    end if; 
    OlI01I := rtrim(OlI01I, ','); 
 
    if IlI00l = 'DYNAMIC_QUERY' and not OlI010 then 
      Il1010 := Il1l01(IIl1I0, Ol01Il, Ol1II0); 
      if Il1010 is not null then 
        OlI01I := OlI01I||', '||query2report.g_crlf||Il1010||' REGION_HIGHLIGHTS'; 
      end if; 
    end if; 
    
    $if CCOMPILING.g_IG_exists $then        
    if IlI00l = 'NATIVE_IG' then 
      Il1010 := "l1IIl0lI".Il1l01(IIl1I0, Ol01Il, Ol1II0, ll01ll); 
      if Il1010 is not null then 
        OlI01I := OlI01I||', '||query2report.g_crlf||Il1010||' REGION_HIGHLIGHTS'; 
      end if; 
    end if; 
    $end        
 
    if IlI011 is not null then 
      IlI011 := IlI011||'"'; 
    end if; 
    if llI011 is not null then 
      llI011 := llI011||'"'; 
    end if; 
  end if; 
  pak_xslt_log.WriteLog( 'Ol01Il: '||Ol01Il||' OlI00l: '||OlI01I, 
                          p_procedure => 'OlI00l'); 
 
  return OlI01I; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'OlI00l', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end OlI00l; 
 
function llI01l( 
  OIl11I varchar2, 
  ll0I10      varchar2, 
  Ol0I10   varchar2, 
  OlI01l  varchar2, 
  IlI0I0 number, 
  llI0I0 number, 
  Ol1II0 boolean, 
  OlI0I1 varchar2, 
  IlI0I1 varchar2, 
  llI0II    out number 
) 
return varchar2 
as 
OlI0II varchar2(4000); 
 
begin 
  OlI0II := IIl1lI(OIl11I); 
  OlI0II := 'name="'||htf.escape_sc(OlI0II)||'"'; 
  
  if ll0I10 is not null then 
    OlI0II := OlI0II||' '||ll0I10; 
  end if; 
  if Ol0I10 is not null then 
    OlI0II := OlI0II||' '||Ol0I10; 
  end if; 
  if OlI01l is not null then 
    OlI0II := OlI0II||' '||OlI01l; 
  end if; 
  if OlI0I1 is not null then 
    OlI0II := OlI0II||' '||OlI0I1; 
  end if; 
  if IlI0I1 is not null then 
    OlI0II := OlI0II||' '||IlI0I1; 
  end if; 
  
  llI0II := nvl(IlI0I0, llI0I0); 
  if Ol1II0 then 
    if Ol0I10 is not null then 
      llI0II := llI0II * 1.3; 
    end if; 
    llI0II := llI0II + 1; 
  end if; 
  return OlI0II; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'llI01l', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end llI01l; 
 
FUNCTION IlI0Il (llI0Il VARCHAR2, OlI0l0 VARCHAR2 default ',') RETURN ll011I 
IS 
  ll01I1       number :=0; 
  IlI0l0     number :=0; 
  llI0l1  varchar2(4000) := llI0Il; 
  OlI0l1 ll011I; 
   BEGIN 
      
      IlI0l0 := instr(llI0l1,OlI0l0,1,1); 
      
      WHILE ( IlI0l0 != 0) LOOP 
         
         ll01I1 := ll01I1 + 1; 
         
         OlI0l1(ll01I1) := trim(substr(llI0l1,1,IlI0l0-length(OlI0l0))); 
         
         llI0l1 := substr(llI0l1,IlI0l0+1,length(llI0l1)); 
         
         IlI0l0 := instr(llI0l1,OlI0l0,1,1); 
         
         IF IlI0l0 = 0 THEN 
            OlI0l1(ll01I1+1) := trim(llI0l1); 
         END IF; 
      END LOOP; 
 
      
      RETURN OlI0l1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'IlI0Il', 
    p_sqlerrm => sqlerrm ); 
  raise; 
END IlI0Il; 
 
function IIlI01( 
  OIlI0I varchar2, 
  IIlI0l varchar2,
  p_IG boolean default false  
) 
return varchar2 
as 
Il01I1 varchar2(4000); 
IlI0lI ll011I; 
llI0lI ll011I; 
OlI0ll ll011I; 
IlI0ll varchar2(40); 
Ol0l11 varchar2(40); 
llI100 integer; 
OlI100 integer := 0; 
begin 
  if p_IG then
      Il01I1 := ltrim(rtrim(OIlI0I||','||IIlI0l,','),','); 
  else
      if nvl(instr(OIlI0I, 'BREAKROW'),0) = 0 then 
        Il01I1 := trim( both ',' from OIlI0I||','||IIlI0l); 
      else 
        IlI0lI := IlI0Il(trim( both ',' from OIlI0I)); 
        llI0lI := IlI0Il(trim( both ',' from IIlI0l)); 
        for ll01I1 in 1..llI0lI.count loop 
          
          IlI0ll := trim(replace(rtrim(rtrim(llI0lI(ll01I1),'DESC'),'ASC'),'"')); 
          llI100 := 0; 
          
          for IlI101 in 1..IlI0lI.count loop 
            if IlI0lI(IlI101) = IlI0ll then 
              llI100 := IlI101; 
              OlI100 := OlI100 +1; 
              exit; 
            end if; 
          end loop; 
          if llI100 > 0 then 
            
            OlI0ll(OlI100) :=  llI0lI(ll01I1); 
            
            IlI0lI(llI100) := 'ORDER BY'; 
            llI0lI(ll01I1):='ORDER BY'; 
          end if; 
        end loop; 
        
        for ll01I1 in 1..OlI0ll.count loop 
          Il01I1 := Il01I1||OlI0ll(ll01I1)||', '; 
        end loop; 
        for ll01I1 in 1..IlI0lI.count loop 
          if IlI0lI(ll01I1) != 'ORDER BY' then 
            Il01I1 := Il01I1||IlI0lI(ll01I1)||', '; 
          end if; 
        end loop; 
        for ll01I1 in 1..llI0lI.count loop 
          if llI0lI(ll01I1) != 'ORDER BY' then 
            Il01I1 := Il01I1||llI0lI(ll01I1)||', '; 
          end if; 
        end loop; 
        Il01I1 := rtrim(Il01I1,', '); 
      end if;
  end if;
return Il01I1; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error OIlI0I '||OIlI0I||' IIlI0l '||IIlI0l, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'IIlI01', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
function llI101( 
  Il1l1I             varchar2, 
  OlI10I varchar2, 
  Ol0I01                     varchar2, 
  Ol0I00            varchar2, 
  Il0I00             varchar2, 
  ll0I01            varchar2, 
  Ol0I0l       varchar2, 
  Il0I0l               varchar2, 
  Il0I0I             varchar2, 
  OIlI0I        varchar2, 
  IIlI0l             varchar2, 
  ll0I0I         varchar2, 
  ll0I11               varchar2, 
  Ol0I1I          varchar2, 
  IlI10I        varchar2,
  p_grand_total_col_list      varchar2,
  p_IG                        boolean default false,
  p_master_region_source      varchar2 default null,   
  p_join_master_region        varchar2 default null,
  p_alias_list                varchar2 default null
) 
return varchar2 
as 
ll0l1I varchar2(32767); 
IlI00I varchar2(100); 
llI10l boolean default false; 
begin 
  Il01ll( 
    p_procedure => 'llI101', 
    Ol0I00 => Ol0I00, 
    Il0I00 =>  Il0I00, 
    ll0I01 => ll0I01, 
    Ol0I01 => Ol0I01, 
    Il0I0I => Il0I0I, 
    IIlI0l =>  IIlI0l, 
    OIlI0I => OIlI0I, 
    ll0I0I => ll0I0I, 
    Ol0I0l => Ol0I0l, 
    Il0I0l => Il0I0l, 
    ll0I11 => ll0I11, 
    Ol0I1I => Ol0I1I,
    p_grand_total_col_list => p_grand_total_col_list,
    p_master_region_source => p_master_region_source,  
    p_join_master_region => p_join_master_region,
    p_alias_list => p_alias_list  
  ); 
 
  ll0l1I := 'with ';
  if ll0I11 is not null then 
    ll0l1I := ll0l1I||ll0I11||query2report.g_crlf||',';
  end if; 
  if p_master_region_source is not null then 
    ll0l1I := ll0l1I||'master_region_src as ( '||rtrim(trim(p_master_region_source),';')||')'||query2report.g_crlf||',';
  end if; 
    
  ll0l1I := ll0l1I||g_start_region_src||query2report.g_crlf||rtrim(trim(Il1l1I),';')||query2report.g_crlf||g_end_region_src||query2report.g_crlf; 
  
  if p_join_master_region is not null and p_master_region_source is not null and p_alias_list is not null then 
      ll0l1I := ll0l1I||', region_src_joined_master '||p_alias_list||' as ( select master_region_src.*, region_src.* from master_region_src join region_src on '||
      p_join_master_region||')'||query2report.g_crlf;
      IlI00I := 'region_src_joined_master'; 
  else
      IlI00I := 'region_src'; 
  end if;
  if Il0I0l is not null then 
    ll0l1I := ll0l1I|| 
      ',region_src_cc as ( select '||IlI00I||'.* '||Il0I0l||' from '||IlI00I||')'||query2report.g_crlf; 
      IlI00I := 'region_src_cc'; 
  end if; 
  if Ol0I01 is not null then 
    ll0l1I := ll0l1I|| 
      ',region_src_filtered as ( select '||IlI00I||'.* from '||IlI00I|| 
      IlI10I|| 
      query2report.g_crlf||'where '||Ol0I01||')'||query2report.g_crlf; 
      IlI00I := 'region_src_filtered'; 
  end if; 
  if ll0I0I is not null then 
    ll0l1I := ll0l1I||',region_src_grpby as (select '||ll0I0I|| 
                      ' from '||IlI00I||' group by '||Il0I0I||')'||query2report.g_crlf; 
    IlI00I := 'region_src_grpby'; 
    llI10l := true; 
  end if; 
  ll0l1I := ll0l1I||'select '||nvl(OlI10I,'*')||' from '||query2report.g_crlf||'('||query2report.g_crlf|| 
  'select '||nvl(Ol0I00,'*')||' from '||IlI00I||query2report.g_crlf; 
  if Ol0I1I is not null then 
    ll0l1I := ll0l1I||Ol0I1I||query2report.g_crlf; 
  end if; 
   
  if Il0I00 is not null then 
    ll0l1I := ll0l1I ||' union '||query2report.g_crlf|| 
                       'select '||Il0I00||' from '||IlI00I||' '; 
                       
    if Ol0I1I is not null then 
        ll0l1I := ll0l1I||Ol0I1I||query2report.g_crlf; 
    end if; 
    
    if Ol0I0l is not null and ll0I01 is not null then 
      ll0l1I := ll0l1I ||query2report.g_crlf||'group by '||Ol0I0l; 
    end if; 
  end if; 
  if ll0I01 is not null then 
    ll0l1I := ll0l1I||query2report.g_crlf||'union '||query2report.g_crlf|| 
                       'select '||ll0I01||' from '||IlI00I||' '; 
    if Ol0I1I is not null then 
        ll0l1I := ll0l1I||Ol0I1I||query2report.g_crlf; 
    end if; 
  end if;
  if p_grand_total_col_list is not null then 
    ll0l1I := ll0l1I||query2report.g_crlf||'union '||query2report.g_crlf|| 
                       'select '||p_grand_total_col_list||' from '||IlI00I||' '; 
  end if;
  
  
  ll0l1I := ll0l1I ||query2report.g_crlf||')'; 
  if nvl(IIlI0l, OIlI0I) is not null then 
    ll0l1I := ll0l1I ||query2report.g_crlf|| 
            ' order by '||IIlI01(OIlI0I, IIlI0l, p_IG); 
  end if; 
  return Ol1l11(ll0l1I); 
end llI101; 
 
function OlI10l(IlI110 varchar2) 
return number 
as 
Il01I1 number; 
begin 
  Il01I1 := to_number(IlI110); 
  if abs(floor(Il01I1)) = Il01I1 then 
    return Il01I1; 
  else 
    return 0; 
  end if; 
exception 
  when others then 
    return 0; 
end; 
 
function llI110(OlI111 Ol0111) 
return varchar2 
as 
Il01I1 varchar2(4000); 
begin 
  for ll01I1 in 1..OlI111.count loop 
    Il01I1 := Il01I1 || OlI111(ll01I1).region_name||';'; 
    if  OlI111(ll01I1).Il010l is not null then 
      Il01I1 := Il01I1||' select'||ll01I1||';'; 
    end if; 
    if  OlI111(ll01I1).ll010l is not null then 
      Il01I1 := Il01I1||' '||OlI111(ll01I1).ll010l||';'; 
    end if; 
     Il01I1 := Il01I1||' | '; 
  end loop; 
  return Il01I1; 
end; 
 
function IlI111( 
  llI11I varchar2, 
  IIl1I0 number 
) 
return Ol0111 
as 
OlI11I Ol0111 := Ol0111(); 
IlI11l number := 1; 
llI11l varchar2(32000); 
OlI1I0 varchar2(32000); 
IlI1I0 number; 
 
cursor llI1I1 is 
select IIl1lI(region_name) region_name 
 from apex_application_page_regions 
 where application_id = APEX_APPLICATION.G_FLOW_ID
 and   page_id = IIl1I0 
 
 and  lower(trim(region_source))  like 'select%from%'
 order by display_sequence; 
begin 
  pak_xslt_log.WriteLog( 'Parse regions starts llI11I: '||llI11I||' IIl1I0: '||IIl1I0, p_procedure => 'IlI111'); 
  if llI11I is not null then 
    llI11l := llI11I||';'; 
    loop 
      IlI11l := instr(llI11l,';'); 
      exit when nvl(IlI11l, 0) = 0; 
      OlI1I0 := substr(llI11l, 1, IlI11l-1); 
      OlI1I0 := trim(leading chr(13) from trim(OlI1I0)); 
      OlI1I0 := trim(leading chr(10) from OlI1I0); 
      OlI1I0 := trim(trailing chr(10) from OlI1I0); 
      OlI1I0 := trim(trailing chr(13) from OlI1I0); 
      OlI1I0 := trim(OlI1I0); 
      IlI1I0 := OlI10l(OlI1I0); 
 
      pak_xslt_log.WriteLog( 
        'OlI1I0: '||OlI1I0, 
        p_procedure => 'IlI111' 
      ); 
 
      if OlI11I.count > 0 
         and OlI11I(OlI11I.count).region_name is not null 
         and lower(OlI1I0) like 'select%' 
         and instr(lower(OlI1I0),'from') > 0 
         then 
        OlI11I(OlI11I.count).Il010l := OlI1I0; 
      elsif OlI11I.count > 0 
            and OlI11I(OlI11I.count).region_name is not null 
            and OlI11I(OlI11I.count).Il010l is not null 
            and IlI1I0 > 0 
      then 
        OlI11I(OlI11I.count).ll010l := IlI1I0; 
      elsif length(OlI1I0) > 0 then 
        OlI11I.extend; 
        OlI11I(OlI11I.count).region_name := OlI1I0; 
      end if; 
      llI11l := substr(llI11l, IlI11l+1); 
    end loop; 
  else 
    pak_xslt_log.WriteLog( 'Parse regions starts with llI11I is null, IIl1I0: '||IIl1I0, p_procedure => 'IlI111'); 
    for OlI1I1 in llI1I1 loop 
      OlI11I.extend; 
      OlI11I(OlI11I.count).region_name := OlI1I1.region_name; 
      pak_xslt_log.WriteLog( 'Parse regions find region: '||OlI1I1.region_name, p_procedure => 'IlI111'); 
    end loop; 
  end if; 
  pak_xslt_log.WriteLog( 'Parse regions finished: '||llI110(OlI11I), p_procedure => 'IlI111'); 
  return OlI11I; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error', 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'IlI111', 
    p_sqlerrm => sqlerrm ); 
  raise; 
end; 
 
 
procedure IIl111( 
    OIl11I         in varchar2 default null, 
    IIl11l   in number default OIl10I, 
    OIl1I0           in number default 0, 
    IIl1I0             in number default null, 
    p_dwld_type           in number, 
    po_xml                out CLOB, 
    OIl1I1     out CLOB, 
    IIl1II        out query2report.tab_string 
) 
as 

Ol01I0 Ol0110; 
 

 
IlI1II  query2report.tab_string := query2report.tab_string(); 
llI1II  query2report.t_coltype_tables := query2report.t_coltype_tables(); 
OlI1Il  query2report.tab_integer := query2report.tab_integer(); 
 


IlI1Il varchar2(32767); 
Il1III varchar2(32767); 
llI1l0  varchar2(32767); 
Ol11l1  varchar2(32767); 
OlI1l0  varchar2(4000); 
Il1010 varchar2(4000); 
 

IlI1l1 varchar2(32767); 
llI1l1 varchar2(32767); 
OlI1lI varchar2(32767); 
 

IlI1lI  varchar2(32767); 
llI1ll  varchar2(32767); 
OlI1ll varchar2(32767); 
IlII00  varchar2(32767); 
llII00 varchar2(32767); 
III0110 varchar2(32767); 
OlII01          varchar2(32767); 

l_master_region_source varchar2(32767); 
l_join_master_region varchar2(32767); 
l_alias_list varchar2(32767); 
IlIlIOl number;

 


OlI0II varchar2(4000); 
IlII01 varchar2(4000); 
llII0I varchar2(4000); 
OlII0I varchar2(400); 
IlII0l varchar2(4000); 
llII0l varchar2(4000); 
l_IG boolean := false;
 

OlII10 number; 
IlII10 PLS_INTEGER; 
llII11 number;  
OlII11 PLS_INTEGER; 
OlI11I Ol0111; 
 
cursor llI1I1(IlII1I varchar2) is 
select * from 
( 
  select region_id 
        , IIl1lI(region_name) region_name 
        , region_source 
        , source_type_code 
        , report_column_source_type 
        , page_name 
        , maximum_row_count 
  from apex_application_page_regions 
  where application_id = APEX_APPLICATION.G_FLOW_ID
  and   page_id = IIl1I0 
  
  and  lower(trim(region_source))  like 'select%from%'
) 
where region_name = IlII1I; 
 
 OlI1I1 llI1I1%rowtype; 
 
begin 
  OlII11 := dbms_utility.get_time(); 
  OlII10 := nvl(IIl1I0, V('PAGE_ID')); 
  IIl1II := query2report.tab_string(); 
 
  OlI11I := IlI111(OIl11I, IIl1I0); 
 
  for ll01I1 in 1..OlI11I.count loop 
    if OlI11I(ll01I1).Il010l is not null then 
      pak_xslt_log.WriteLog( 'Direct Query2Report.Il000I region name: '|| OlI11I(ll01I1).region_name || ' query: ' || OlI11I(ll01I1).Il010l, p_procedure => 'IIl111' ); 
      Query2Report.Il000I( 
        'name="'||htf.escape_sc(OlI11I(ll01I1).region_name)||'"', 
        OlI11I(ll01I1).Il010l, 
        Query2Report.OIllll(OlI11I(ll01I1).Il010l), 
        llII11, 
        IIl1II, 
        IlI1II, 
        llI1II, 
        OlI1Il 
      ); 
    else 
      
      
      
      open llI1I1(OlI11I(ll01I1).region_name); 
      fetch llI1I1 into OlI1I1; 
      if llI1I1%found then 
        pak_xslt_log.WriteLog( 'found ' || OlI1I1.source_type_code || ' ' || OlI1I1.region_name, p_procedure => 'IIl111' ); 
        
        Il1III := null; 
        llI1l0  := null; 
        Ol11l1  := null; 
        
        OlI1l0  := null; 
        Il1010 := null; 
 
        
        IlI1l1 := null; 
        llI1l1 := null; 
        OlI1lI := null; 
 
        
        IlI1lI  := null; 
        llI1ll  := null; 
        OlI1ll := null; 
        IlII00  := null; 
        llII00 := null; 
        III0110 := null;
        OlII01          := null; 
        
 
        
        
        OlI0II := null; 
        IlII01 := null; 
        llII0I := null; 
        OlII0I := null; 
        IlII10 := null; 
        llII11 := null; 
        IlII0l := null; 
        llII0l := null; 
        
        
        l_master_region_source := null; 
        l_join_master_region := null; 
        l_alias_list := null; 
        IlIlIOl := null;
        
        
        l_IG := false;
 
 
        if OlI1I1.source_type_code = 'FUNCTION_RETURNING_SQL_QUERY' 
        then 
          OlI1I1.region_source := apex_plugin_util.get_plsql_function_result( OlI1I1.region_source ); 
          pak_xslt_log.WriteLog( OlI1I1.region_name||' (FUNCTION_RETURNING_SQL_QUERY): ', p_procedure => 'IIl111' ); 
        elsif OlI1I1.source_type_code = 'DYNAMIC_QUERY' 
        then 
 
          Il11I0( 
            OlI1I1.region_id, 
            OlII10, 
            IIl11l, 
            ll11I0 => Il1III, 
            Il10l1 => IlI1lI, 
            ll10lI => OlII01, 
            Il111I => OlI1ll, 
            Ol111I => IlII00 
          ); 
 
           
          Il1l00( 
            OlI1I1.region_id, 
            OlII10, 
            IIl11l, 
            Il11I1 => Il1III   , 
            Ol11l0 => llI1l0    , 
            Il1IIl => Ol11l1   , 
            ll1Il0 => llII00    , 
            Ol1II1 => llI1ll    , 
            ll1l00 => llII0I           , 
            Ol1IIl => IlII01        , 
            Il0l01 => OlII0I       , 
            Ol1l01 => IlII10      , 
            ll1I00 => Ol01I0 
          ); 
 
          $IF CCOMPILING.g_views_granted $THEN 
          OlI1l0 := ll100l(OlII10, OlI1I1.region_id); 
          $END 
        
            
          $IF CCOMPILING.g_IG_exists $THEN 
          elsif OlI1I1.source_type_code = 'NATIVE_IG' then
            l_IG := true;
            Ol01I0 := "l1IIl0lI".II0I1IO1(
               OlI1I1.region_id, 
               OlII10, 
               IIl11l, 
               l101lO1O1 => llII0I,
               O0Il1I0I => IlII10   
            );
            
            "l1IIl0lI".O01lIlI0( 
                   OlI1I1.region_id, 
                   ll10l10 => l_master_region_source,
                   l10100Il => l_join_master_region,
                   O00I00Il => l_alias_list, 
                   lI111lO1 => IlIlIOl
               );
            "l1IIl0lI".lIlOOl1(  
                OlI1I1.region_id, 
                OlII10, 
                IIl11l,
                IlIlIOl,
                ll01ll => Ol01I0,
                Il10l1 => IlI1lI, 
                Ol1II1 => llI1ll, 
                ll10lI => OlII01
              );
              
                              
              "l1IIl0lI".Il1l00( 
                  ll01ll => Ol01I0,
                  Ol1IIl => IlII01, 
                  ll11I0 => Il1III  , 
                  Il1IIl => Ol11l1, 
                  Ol11l0 => llI1l0    , 
                  llllOI0 => llI1ll, 
                  ll1Il0 => llII00, 
                  O0llOlOl => III0110
               ); 
          $END     
               
        
        else 
          Il11ll( 
            OlI1I1.region_id, 
            OlII10, 
            IIl11l, 
            Ol01I0, 
            Il1III, 
            llI1l0, 
            IlI1lI 
            
          ); 
        end if; 
 
        ll1lll( 
          Il0I0l => OlI1l0, 
          Ol0I01 => OlII01, 
          ll01ll => Ol01I0,  
          l10I0OI0 => IlIlIOl,  
          pio_group_by_col_list  => OlI1ll, 
          Il11I1 => Il1III, 
          ll11II => llI1l0,
          pio_break_group_by_list => llII00,  
          OlI000 => OlII01, 
          Ol11II    => Ol11l1, 
          IlI000 => IlI1l1, 
          llI001 => llI1l1, 
          OlI001 => OlI1lI 
        ); 
 
        IlI1Il := 
        OlI00l( 
          OlII10, 
          OlI1I1.region_id, 
          OlI1I1.source_type_code, 
          Ol01I0, 
          OIl1I0, 
          IlII01 is not null, 
          llI1l0 is not null, 
          OlII0I is not null, 
          IlI011 => IlII0l, 
          llI011 => llII0l 
        ); 
 
        
        OlI1I1.region_source := 
        llI101( 
          OlI1I1.region_source          , 
          OlI10I => IlI1Il , 
          Ol0I01 => OlII01  , 
          Ol0I00 => Il1III, 
          Il0I00 => llI1l0, 
          ll0I01 => Ol11l1            , 
          Ol0I0l => llII00, 
          Il0I0l => OlI1l0               , 
          Il0I0I => IlII00             , 
          OIlI0I => llI1ll, 
          IIlI0l => IlI1lI, 
          ll0I0I => OlI1ll, 
          ll0I11 => IlI1l1, 
          Ol0I1I => llI1l1, 
          IlI10I => OlI1lI, 
          p_grand_total_col_list => III0110, 
          p_master_region_source => l_master_region_source,
          p_join_master_region => l_join_master_region,  
          p_alias_list => l_alias_list,  
          p_IG => l_IG   
        ); 
 
        OlI0II := llI01l( 
          OlI1I1.region_name, 
          llII0I, 
          IlII01, 
          OlII0I, 
          IlII10, 
          OlI1I1.maximum_row_count, 
          llI1l0 is not null, 
          OlI0I1 => IlII0l, 
          IlI0I1 => llII0l, 
          llI0II => llII11 
        ); 
 
        pak_xslt_log.WriteLog('Before Query2Report.Il000I OlI0II: '||OlI0II||' llII11 '||llII11, 
                              p_procedure => 'IIl111' ); 
        Query2Report.Il000I(OlI0II, OlI1I1.region_source, Ol01II(Ol01I0), llII11, IIl1II, IlI1II, llI1II, OlI1Il); 
      else 
         pak_xslt_log.WriteLog('Region '||OlI11I(ll01I1).region_name||' not found! ', 
                              p_log_type => pak_xslt_log.g_warning, 
                              p_procedure => 'IIl111' ); 
      end if; 
      close llI1I1; 
    end if; 
  end loop; 
  pak_xslt_log.WriteLog('source SQL prepared', p_procedure => 'IIl111', p_start_time => OlII11); 
 
  if p_dwld_type <> query2report.g_dwld_suorce then 
    OlII11 := dbms_utility.get_time(); 
    po_xml := Query2Report.ll001I(IIl1II, IlI1II, llI1II, OlI1Il); 
 
    if po_Xml is null then 
      pak_xslt_log.WriteLog( 
        'po_Xml is null', 
        p_log_type => pak_xslt_log.g_error, 
        p_procedure => 'IIl111' 
      ); 
    else 
        pak_xslt_log.WriteLog( 
          'Query2Report.ll001I finished' 
          ,p_procedure => 'IIl111' 
          , p_start_time => OlII11 
        ); 
         
    end if; 
  end if; 
  OIl1I1 := Il1I01(IlI1II); 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error IIl1I0 '||to_char(IIl1I0)|| 
    ' IIl11l '||IIl11l, 
    p_log_type => pak_xslt_log.g_error, p_procedure => 'IIl111', p_sqlerrm => sqlerrm ); 
  raise; 
end IIl111; 
 
 
procedure llII1I( 
  p_xsltStaticFile            IN  varchar2, 
  p_filename                  in  VARCHAR2, 
  IIl1I0                   in  number, 
  p_dwld_type                 in  number default Query2Report.g_dwld_transformed, 
  IIl11l         in  number default OIl10I, 
  OIl1I0                 in  number default 0, 
  OIl11I               in  varchar2 default null, 
  p_format                    IN  number default null, 
  p_templateStaticFile        in  VARCHAR2 default null, 
  p_external_params           IN  varchar2 default null, 
  p_second_XsltStaticFile      IN  varchar2 default null, 
  p_second_external_params     IN  varchar2 default null, 
  IIlllI         IN  boolean default false, 
  ll0000                 IN  number default null, 
  p_convertblob_param       IN varchar2 default null 
) 
as 
 
OlII1l number; 
IlII1l CLOB; 
llIII0 CLOB; 
OlII11 PLS_INTEGER; 
OlIII0 query2report.tab_string; 
IlIII1 varchar2(4000); 
llIII1 varchar2(4000); 
OlIIII number; 
IlIIII number; 
begin 
 
  if ll0000 is not null then 
    pak_xslt_log.SetLevel(ll0000); 
  end if; 
 
  pak_xslt_log.WriteLog( 'llII1I started ', 
                                p_procedure => 'llII1I' 
                              ); 
 
  if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.IIlIl0, Query2Report.g_dwld_transformed, Query2Report.g_dwld_suorce) then 
    IIl111( 
      OIl11I => OIl11I, 
      IIl1I0 => IIl1I0, 
      IIl11l => IIl11l, 
      OIl1I0 => OIl1I0, 
      p_dwld_type => p_dwld_type, 
      po_xml => IlII1l, 
      OIl1I1 => llIII0, 
      IIl1II    => OlIII0 
    ); 
    if p_dwld_type <> Query2Report.g_dwld_suorce and IlII1l is null then 
    pak_xslt_log.WriteLog( 
      'IlII1l is null', 
      p_log_type => pak_xslt_log.g_error, 
      p_procedure => 'llII1I' 
    ); 
    end if; 
 
    if p_dwld_type in (Query2Report.g_dwld_xml, Query2Report.IIlIl0) then 
      IlIII1 := Query2Report.Il001l(IIl1I0, OlIII0); 
      OlII11 := dbms_utility.get_time(); 
      
      query2report.OIll1I(IlII1l);
      
      pak_xslt_log.WriteLog( 
        'Query2Report.ConvertXml finished' 
        ,p_procedure => 'llII1I' 
        , p_start_time => OlII11 
      ); 
      Query2Report.DownloadConvertOutput(APEX_APPLICATION.G_FLOW_ID,  pak_blob_util.clob2blob(IlII1l), IlIII1||'.xml', 'text/xml'); 
      if p_dwld_type = Query2Report.IIlIl0 then 
        Query2Report.ll001l(IlIII1, IlII1l); 
      end if; 
    elsif p_dwld_type = Query2Report.g_dwld_suorce then 
      IlIII1 := Query2Report.Il001l(IIl1I0, OlIII0); 
      Query2Report.DownloadConvertOutput(APEX_APPLICATION.G_FLOW_ID, pak_blob_util.clob2blob(llIII0), IlIII1||'.sql', 'text/plain'); 
    else 
      select count(*) into IlIIII 
      from user_scheduler_jobs 
      where upper(job_name) = 'JOB_XSLTRANSFORMANDDOWNLOAD' 
      and upper(program_name) = 'PROG_XSLTRANSFORMANDDOWNLOAD'; 
 
      if IIlllI and IlIIII = 1 then 
        insert into temporary_xml (XMLCLOB) values(IlII1l) 
        returning id_temporary_xml into OlIIII; 
        commit; 
 
        Query2Report.ll0001( 
          Il0001 => OlIIII, 
          p_xsltStaticFile => p_xsltStaticFile, 
          IIl1I0 => IIl1I0, 
          OIl11I => OIl11I, 
          p_filename => p_filename, 
          p_format => p_format, 
          p_templateStaticFile => p_templateStaticFile, 
          p_external_params => p_external_params, 
          p_second_XsltStaticFile => p_second_XsltStaticFile, 
          p_second_external_params => p_second_external_params, 
          p_convertblob_param => p_convertblob_param, 
          ll0000 => ll0000 
        ); 
      else 
        OlII11 := dbms_utility.get_time(); 
        if IIlllI then 
           pak_xslt_log.WriteLog( 'Job JOB_XSLTRANSFORMANDDOWNLOAD is not installed! Can not run in background.', 
           p_log_type => pak_xslt_log.g_warning, 
           p_procedure => 'llII1I'); 
        end if; 
        Query2Report.XslTransformAndDownload( 
          p_Xml => IlII1l, 
          p_xsltStaticFile => p_xsltStaticFile, 
          IIl1I0 => IIl1I0, 
          OIl11I => OIl11I, 
          p_filename => p_filename, 
          p_format => p_format, 
          p_templateStaticFile => p_templateStaticFile, 
          p_external_params => p_external_params, 
          p_second_XsltStaticFile => p_second_XsltStaticFile, 
          p_second_external_params => p_second_external_params, 
          p_convertblob_param => p_convertblob_param 
        ); 
 
 
 
        pak_xslt_log.WriteLog( 'Query2Report.XslTransformAndDownload finished ', 
                                  p_procedure => 'llII1I', 
                                  p_start_time => OlII11 
                                ); 
      end if; 
    end if; 
  else 
    Query2Report.OIll10( 
      p_xsltStaticFile, 
      p_second_XsltStaticFile, 
      
      
      p_dwld_type, 
      
      p_format 
    ); 
  end if; 
 
  pak_xslt_log.WriteLog( 'llII1I finished ', 
                                p_procedure => 'llII1I' 
                              ); 
  commit; 
exception 
  when others then 
  pak_xslt_log.WriteLog( 'Error IIl11l '||IIl11l, 
    p_log_type => pak_xslt_log.g_error, p_procedure => 'llII1I', p_sqlerrm => sqlerrm ); 
  rollback; 
  raise; 
end; 
 
 
function Region2XSLTReport( 
    p_process in apex_plugin.t_process, 
    p_plugin  in apex_plugin.t_plugin ) 
    return apex_plugin.t_process_exec_result 
AS 
  llIIIl          varchar2(256); 
  IlIII1               varchar2(256); 
  OlII10                 number; 
  OlIIIl               number  ; 
  IlIIl0       number  ; 
  llIIl0               number; 
  OlI1I0             varchar2(32000); 
  OlIIl1                  number  ; 
  IlIIl1         varchar2(1000); 
  llIIlI    varchar2(256); 
  OlIIlI   varchar2(1000); 
  IlIIll        boolean; 
  llIIll                number; 
  OlIl00        varchar2(4000); 
  IlIl00                varchar2(256); 
  llIl01               varchar2(256); 
  OlIl01               varchar2(256); 
  IlIl0I       varchar2(256); 
  llIl0I              number; 
 
  Il01I1 apex_plugin.t_process_exec_result; 
begin 
 
  llIIIl        := p_process.attribute_01;      
  IlIII1             := p_process.attribute_02;      
  OlII10               := p_process.attribute_11;      
 
  select page_name, page_title, page_alias 
  into IlIl00, llIl01, OlIl01 
  from apex_application_pages 
  where application_id = APEX_APPLICATION.G_FLOW_ID and page_id = OlII10; 
 
  IlIII1 := replace(IlIII1, '#PAGE_NAME#', IIl1lI(IlIl00)); 
  IlIII1 := replace(IlIII1, '#PAGE_TITLE#', IIl1lI(llIl01)); 
  IlIII1 := replace(IlIII1, '#PAGE_ALIAS#', OlIl01); 
  IlIII1 := trim(substr(translate(IlIII1,'?,''":;?*+()/\|&%$#! '||query2report.g_crlf,'______________________'),1, 255)); 
 
  OlIIIl             := p_process.attribute_03;      
  IlIIl0     := p_process.attribute_04;      
  llIIl0             := p_process.attribute_05;      
  OlI1I0           := p_process.attribute_06;      
  OlIIl1                := p_process.attribute_07;      
  IlIIl1       := p_process.attribute_08;      
  if p_process.attribute_09 is not null then 
    llIIlI  := p_process.attribute_09;    
  end if; 
  OlIIlI := p_process.attribute_10;      
  IlIIll      := (upper(p_process.attribute_12) = 'Y');      
 
  IlIl0I     := p_process.attribute_13; 
 
  llIIll              := p_process.attribute_14;      
  OlIl00      := p_process.attribute_15;      
 
  llII1I( 
    p_xsltStaticFile => llIIIl, 
    p_filename => IlIII1, 
    IIl1I0 => OlII10, 
    p_dwld_type => OlIIIl, 
    IIl11l => IlIIl0, 
    OIl1I0 => llIIl0, 
    OIl11I => OlI1I0, 
    p_format => OlIIl1, 
    p_templateStaticFile => IlIl0I, 
    p_external_params => IlIIl1, 
    p_second_XsltStaticFile => llIIlI, 
    p_second_external_params => OlIIlI, 
    ll0000 => llIIll, 
    IIlllI => IlIIll, 
    p_convertblob_param => OlIl00 
  ); 
 
  Il01I1.success_message := p_process.success_message; 
  return Il01I1; 
exception 
    when others then 
    if llIIlI is null then 
      Il01I1.success_message := 'Error when transforming on region '||V('REGION')|| 
        ' with '||llIIIl; 
    else 
      Il01I1.success_message := 'Error when transforming on region '||V('REGION')|| 
        ' with '||llIIIl ||' and then with '||llIIlI; 
    end if; 
 
    pak_xslt_log.WriteLog(Il01I1.success_message, p_log_type => pak_xslt_log.g_error, p_procedure => 'Region2XSLTReport', p_sqlerrm => sqlerrm ); 
 
    Il01I1.success_message := Il01I1.success_message||' SQLERR: '||sqlerrm; 
 
    return Il01I1; 
END Region2XSLTReport; 
 
END APEXREP2REPORT;

/
