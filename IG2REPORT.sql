



  CREATE OR REPLACE PACKAGE "l1IIl0lI" as
$if CCOMPILING.g_IG_exists $then
function OIl1Il( 
  IIl1Il number, 
  OIl1l0 varchar2, 
  I0I110l APEX_APPL_PAGE_IG_COLUMNS.LOV_ID%type, 
  ll0O0II APEX_APPL_PAGE_IG_COLUMNS.LOV_SOURCE%type 
) 
return varchar2;

 
procedure lIlOOl1( 
    Ol01Il number, 
    IIl1I0 number, 
    IIl11l number,
    l10I0OI0 number,
    ll01ll APEXREP2REPORT.Ol0110,
    Il10l1 out varchar2, 
    Ol1II1 out varchar2,
    ll10lI out varchar2 
); 

 
function Il1l01( 
  IIl1I0 number, 
  Ol01Il number, 
  Ol1II0 boolean,
  ll01ll APEXREP2REPORT.Ol0110 default null    
) 
return varchar2;


function II0I1IO1(
   Ol01Il            in number,
   IIl1I0              in number,
   IIl11l    in number,
   l101lO1O1             out varchar2,
   O0Il1I0I         out number   
   
)
return APEXREP2REPORT.Ol0110;

 
procedure Il1l00( 
  ll01ll in APEXREP2REPORT.Ol0110,
  Ol1IIl out varchar2, 
  ll11I0 out varchar2, 
  Ol11l0 out varchar2, 
  Il1IIl out varchar2, 
  llllOI0 in out varchar2, 
  ll1Il0 out varchar2,
  O0llOlOl  out varchar2  
) ; 


procedure O01lIlI0( 
  Ol01Il number,  
  ll10l10 out varchar2,
  l10100Il out varchar2,
  O00I00Il out varchar2,
  lI111lO1 out number
);
$end
end;

/
