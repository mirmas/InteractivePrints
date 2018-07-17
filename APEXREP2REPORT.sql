



  CREATE OR REPLACE PACKAGE "APEXREP2REPORT" AS 

OIl100      constant number := 0; 
IIl101  constant number := 1; 
OIl10I         constant number := 2; 
 
 
g_start_region_src constant varchar2(200) := ' region_src as ( '; 
g_end_region_src constant varchar2(200)   := ')'; 
 
  
type Il0100 is record  
    ( ll0100     apex_application_page_ir_col.report_label%type  
    , fullname  apex_application_page_ir_col.report_label%type  
    , alias     apex_application_page_ir_col.column_alias%type  
    , col_type  apex_application_page_ir_col.column_type%type  
    , format_mask varchar2(400)  
    , PRINT_COLUMN_WIDTH number  
    , display_sequence number  
    , Ol0101 varchar2(1) 
    , query_id number  
    , IIl10I number 
    , lov_sql varchar2(4000)  
    , ll010I varchar(20) 
    , item_type varchar(400)  
    );  
     
  
type Il0101 is record  
(  
  column_alias apex_application_page_ir_col.column_alias%type  
  ,ll010I varchar2(30)  
  ,column_type varchar2(30)  
);    
 
  
type Ol0110 is table of Il0100;  
  
  
type Il0110 is table of varchar2(30);  
  
  
type ll0111 is table of Il0101;  
 
  
function Ol10I0(Il10I1 in varchar2)  
return Il0110;  
 
function IIl10I( 
  OIl10l          varchar2 
  ,IIl110   varchar2 
  ,OIl111        varchar2 
) 
return number; 
 
function ll1lI1(Ol1lII varchar2)  
return varchar2;  
 
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
  p_master_region_source      varchar2 default null,    
  p_join_master_region        varchar2 default null,   
  p_alias_list                varchar2 default null 
);  
 
  
procedure Ol11I1(  
  
  Il11I1  in out varchar2,  
  ll11II   in out varchar2,  
  Ol11II  in out varchar2,  
  pio_grand_total_col_list in out varchar2,  
  Il11Il in varchar2 default null,  
  p_grand_total_aggregates in varchar2 default null, 
  p_break_in_grand_total in boolean default false   
);  
 
 
procedure IIl111( 
    OIl11I         in varchar2 default null, 
    IIl11l   in number default OIl10I, 
    OIl1I0           in number default 0, 
    IIl1I0             in number default null, 
    p_dwld_type           in number, 
    po_xml                out CLOB, 
    OIl1I1     out CLOB, 
    IIl1II        out query2report.tab_string 
); 
function OIl1Il( 
  IIl1Il number, 
  OIl1l0 varchar2, 
  IIl1l1 varchar2, 
  OIl1lI varchar2 
) 
return varchar2; 
function IIl1lI(p_name varchar2) 
return varchar2; 
function OIl1ll(IIlI00 varchar2) 
return varchar2; 
 
function OIlI01( 
  OIl111 varchar2 
) 
return varchar2; 
 
function IIlI01( 
  OIlI0I varchar2, 
  IIlI0l varchar2, 
  p_IG boolean default false   
) 
return varchar2; 
 
 
function Region2XSLTReport( 
    p_process in apex_plugin.t_process, 
    p_plugin  in apex_plugin.t_plugin 
) 
return apex_plugin.t_process_exec_result; 
END APEXREP2REPORT; 

/
