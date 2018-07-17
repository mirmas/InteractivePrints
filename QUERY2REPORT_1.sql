






  CREATE OR REPLACE PACKAGE BODY "SDA1"."QUERY2REPORT" as
 


 

OllI10 constant varchar2(100) := 'L+6d771+m5m4K274TYj2w3dntYOK7weoT151DTxW0o8=';
 
IllI11 constant varchar2(4) := '5EC1';

 
--'<?xml version="1.0" encoding="'||p_encoding||'"?>'|| g_crlf||
lllI11 constant varchar2(400):=
  '<?xml version="1.0" encoding="utf-8"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="html"/>'||g_crlf||
    '<xsl:template match="/">'|| g_crlf|| g_crlf;
 
 
OllI1I constant varchar2(400):=
  '<?xml version="1.0" encoding="utf-8"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="text"/>'||g_crlf||
    '<xsl:template match="/">'|| g_crlf|| g_crlf;
 
 
IllI1I constant varchar2(200):=
  g_crlf||'</xsl:template>'||g_crlf||
                '</xsl:stylesheet>'||g_crlf;
 
lllI1l constant varchar2(200):= g_crlf||'<xsl:text disable-output-escaping="yes">'||g_crlf||'<![CDATA[';
OllI1l constant varchar2(200):=  ']]>'||g_crlf||'</xsl:text>'||g_crlf;
 
IllII0 constant varchar2(200):= '<xsl:text disable-output-escaping="yes"><![CDATA[';
lllII0 constant varchar2(200):=  ']]></xsl:text>';
 
 
OllII1 constant varchar2(200):= '<xsl:text>';
IllII1 constant varchar2(200):=  '</xsl:text>'||g_crlf;
 

function lllIII (OllIII in varchar2)
return varchar2
is
begin
 return upper(dbms_obfuscation_toolkit.md5(
          input => utl_i18n.string_to_raw(OllIII)));
end lllIII;
 
function IllIIl
return raw
is
Il01I1 raw(200);
 
cursor lllIIl is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE' and name = 'QUERY2REPORT' order by line;
 
cursor OllIl0 is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE BODY' and name = 'QUERY2REPORT' order by line;
 
cursor IllIl0 is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE' and name = 'APEXREP2REPORT' order by line;
 
cursor lllIl1 is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE BODY' and name = 'APEXREP2REPORT' order by line;
 
begin
 for OllIl1 in OllIl0 loop
  if length(OllIl1.text) > 0 then
    Il01I1 := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(Il01I1,UTL_I18N.STRING_TO_RAW(OllIl1.text,  'AL32UTF8')));
  end if;
 end loop;
 
 for IllIlI in lllIIl loop
  if length(IllIlI.text) > 0 and nvl(instr(lower(IllIlI.text), 'g_selectenc constant varchar2'), 0)=0 then
    Il01I1 := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(Il01I1,UTL_I18N.STRING_TO_RAW(trim(IllIlI.text),  'AL32UTF8')));
  end if;
 end loop;
 
 for lllIlI in lllIl1 loop
  if length(lllIlI.text) > 0 then
    Il01I1 := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(Il01I1,UTL_I18N.STRING_TO_RAW(lllIlI.text,  'AL32UTF8')));
  end if;
 end loop;
 
 for OllIll in IllIl0 loop
  if nvl(instr(lower(OllIll.text), 'g_views_granted constant boolean'), 0)=0 and length(OllIll.text)>0 then
    Il01I1 := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(Il01I1,UTL_I18N.STRING_TO_RAW(OllIll.text,  'AL32UTF8')));
  end if;
 end loop;
 
 
 return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'IllIIl', p_sqlerrm => sqlerrm );
  raise;
end IllIIl;
 

function BlockXOR(IIlIl1 RAW, OIlIlI RAW)
return RAW
as
IllIll RAW(32000);
llll00 number;
Olll00 number;
begin
  llll00 := utl_raw.length(IIlIl1);
  Olll00 := utl_raw.length(OIlIlI);
  while llll00 > 0 loop
    if llll00 >= Olll00 then
      IllIll:=utl_raw.concat(IllIll, OIlIlI);
    else
      IllIll:=utl_raw.concat(IllIll, utl_raw.substr(OIlIlI, 1, llll00));
    end if;
    llll00 := llll00 - Olll00;
  end loop;
  return utl_raw.bit_xor(IIlIl1, IllIll);
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BlockXOR', p_sqlerrm => sqlerrm );
  raise;
end;
 
 
function Illl01(OIll0l varchar2)
return boolean
as
llll01 varchar2(20);
Olll0I varchar2(32);
Illl0I varchar2(4);
begin
   if OIll0l = OIlIl1 then
     return true;
   end if;
   llll01 := trim(replace(upper(OIll0l),'-',''));
   Illl0I := substr(llll01,17,4);
   Olll0I := lllIII(substr(llll01,1,16)||OllI10);
   return substr(Olll0I, 5, 1)||substr(Olll0I, 16, 1)||substr(Olll0I, 30, 1)||substr(Olll0I, 13, 1) = nvl(Illl0I,' ');
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'Illl01', p_sqlerrm => sqlerrm );
  return false;
end Illl01;
 


function OIll01(IIll0I varchar2, OIll0l varchar2)
return varchar2 AS
llll0l  RAW(16); 
Olll0l  RAW(16);
BEGIN
  if OIll0l is null then
    llll0l := IllIIl;
  else
    if not Illl01(OIll0l) then
      pak_xslt_log.WriteLog( 'INV'||OIll0l, p_log_type => pak_xslt_log.g_error,
      p_procedure => 'OIll01', p_sqlerrm => sqlerrm );
      return null;
    end if;
 
    llll0l := UTL_I18N.STRING_TO_RAW (substr(OIll0l,1,16),  'AL32UTF8');
    Olll0l := UTL_I18N.STRING_TO_RAW (substr(OllI10,1,16),  'AL32UTF8');
    llll0l := BlockXOR(llll0l, Olll0l);
  end if;
  return
  UTL_I18N.RAW_TO_CHAR(
    DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT
    (
       input => UTL_ENCODE.BASE64_DECODE(UTL_I18N.STRING_TO_RAW(IIll0I,  'AL32UTF8')),
       key => llll0l
    ),
    'AL32UTF8'
  );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'OIll01', p_sqlerrm => sqlerrm );
  raise;
END OIll01;
 

 
procedure SetLicenceKey(p_licence_key varchar2, p_coded varchar2, IIll0l varchar2)
as
Illl10 varchar2(20);
ll1Il1 number;
begin
  select count(*) into ll1Il1 from xsltswkey;
  if ll1Il1 = 1 then
    select swkey into Illl10 from xsltswkey;
  end if;
  if not Illl01(p_licence_key) or nvl(Illl10,' ') = OIlIl1 or ll1Il1 = 0 then
    delete from xsltswkey;
    insert into xsltswkey(swkey, coded, dbidwsid) values(trim(upper(p_licence_key)), p_coded, IIll0l);
    commit;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'SetLicenceKey', p_sqlerrm => sqlerrm );
  rollback;
  raise;
end;
 
 

 
 

function html2str ( line in varchar2 ) return varchar2 is
    llll10       varchar2(32767) := null;
    Olll11 boolean         := FALSE;
    Illl11       varchar2(4);
  begin
    if line is null then
      return line;
    end if;
    
    for ll01I1 in 1 .. length( line ) loop
      Illl11 := substr( line, ll01I1, 1 );
      if Olll11 then
        if Illl11 = '>' then
          Olll11 := FALSE;
          if substr(llll10,length(llll10),1)<>' ' then
            llll10:=llll10||' ';
          end if;
        end if;
      else
        if Illl11 = '<' then
          Olll11 := TRUE;
        end if;
      end if;
      if not Olll11 and Illl11 != '>' then
        llll10 := llll10|| Illl11;
      end if;
    end loop;
    llll10:=trim(llll10);
    return llll10;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error: '||line, p_log_type => pak_xslt_log.g_error, p_procedure => 'html2str', p_sqlerrm => sqlerrm );
  raise;
end html2str;
 

function RemoveSpecialChars (p_inputstr varchar2)
return varchar2
as
llll1I varchar2(32);
Olll1I varchar2(32);
begin
  for ll01I1 in 0..31 loop
    if ll01I1 not in (9,10,13) then
      llll1I := llll1I||chr(ll01I1);
      Olll1I := Olll1I||' ';
    end if;
  end loop;
  return translate(p_inputstr, llll1I, Olll1I);
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'RemoveSpecialChars', p_sqlerrm => sqlerrm );
  raise;
end RemoveSpecialChars;
 
 

function Illl1l(
  llll1l varchar2,
  OlllI0 varchar2
)
return varchar2
as
Il01I1 varchar2(32000);
lll0II number default 1;
Oll0I1 number default 1;
IlllI0 varchar2(32000);
llllI1 varchar2(32000);
begin
  Il01I1 := llll1l;
  loop
    IlllI0 :='';
    llllI1 :='';
    lll0II := instr(Il01I1, '<'||OlllI0||'>');
    exit when nvl(lll0II, 0) = 0;
    Oll0I1 := instr(Il01I1, '</'||OlllI0||'>');
    exit when nvl(Oll0I1, 0) = 0;
    Oll0I1 := Oll0I1 + length('</'||OlllI0||'>');
    if lll0II > 1 then
      IlllI0 := substr(Il01I1, 1, lll0II - 1);
    end if;
    if Oll0I1 <= length(Il01I1) then
      llllI1 := substr(Il01I1, Oll0I1);
    end if;
    Il01I1 := IlllI0||llllI1;
  end loop;
  return Il01I1;
end;
 
function OlllI1(
  Il00I0 varchar2,
  IIll00 varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
Il01I1 varchar2(4000);
begin
  Il01I1 := Il00I0;
  
  for ll01I1 in 1..length(IIll00) loop
    Il01I1:= replace(Il01I1, '_x'||trim(to_char(ascii(substr(IIll00,ll01I1, 1)),'xx')), '_x005F_x'||trim(to_char(ascii(substr(IIll00,ll01I1, 1)),'xx')));
  end loop;
  return Il01I1;
end OlllI1;
 

function OIll1I(
  p_xml varchar2
)
return varchar2
as
IlllII  number default 1;
llllII    number default 1;
 
OlllIl number default 1;
IlllIl number default 1;
lllll0 varchar2(4000);
ll11l1 varchar2(30);
 
Ollll0 number default 1;
Illll1 number default 1;
lllll1 varchar2(4000);
 
OllllI varchar2(30);
IllllI number default 1;
OlII11 PLS_INTEGER := dbms_utility.get_time();
llllll number default 1;
Olllll number default 1;
Il01I1 varchar2(32000);
I100000 varchar2(32000);
Il1ll1 varchar2(32000);
l100000 number default 1;
O100001 number default 1;
l_start_of_rowset boolean default false;
begin
  
  I100000 := replace(p_xml, '<REGION_AGGREGATES/>','');
  I100000 := replace(I100000, '<REGION_HIGHLIGHTS/>','');
  I100000 := replace(I100000, '<BREAKROW/>','');
  loop
    
    
    
    
    l100000 := instr(I100000, '<ROWSET ', IlllII);
    l_start_of_rowset := l100000 > 0;
    O100001 := instr(I100000, '</ROWSET>', IlllII);
    IlllII := instr(I100000, '<ROW>', IlllII);
    if nvl(l100000, 0) = 0 then
      l100000 := IlllII;
    end if;
    if nvl(O100001, 0) = 0 then
      O100001 := IlllII;
    end if;
    pak_xslt_log.WriteLog(
      'Before least: IlllII: '||IlllII||' l100000: '||l100000||' O100001: '||O100001,
      p_procedure => 'OIll1I (VARCHAR2)'
    );
    IlllII := least(IlllII, l100000, O100001);
    pak_xslt_log.WriteLog(
      'After least: IlllII: '||IlllII||' l100000: '||l100000||' O100001: '||O100001,
      p_procedure => 'OIll1I (VARCHAR2)'
    );
    exit when nvl(IlllII, 0)=0;
    llllII := instr(I100000, '</ROW>', IlllII);
    exit when nvl(llllII, 0) = 0;
    llllII := llllII + length('</ROW>');
    Il1ll1 := substr(I100000, IlllII, llllII - IlllII);
    
 
    OlllIl := instr(Il1ll1, '<REGION_AGGREGATES>');
    IlllIl := instr(Il1ll1, '</REGION_AGGREGATES>', OlllIl);
    if nvl(OlllIl, 0) > 0 and nvl(IlllIl, 0) > 0 then
      OlllIl := OlllIl + length('<REGION_AGGREGATES>');
      lllll0 := substr(Il1ll1, OlllIl, IlllIl-OlllIl);
      IllllI := 1;
      loop
        llllll := instr(lllll0, ',', IllllI, 1);
        exit when nvl(llllll, 0)=0;
        Olllll := instr(lllll0, ',', IllllI, 2);
        exit when nvl(Olllll, 0)=0;
        ll11l1 := substr(lllll0, IllllI, llllll - IllllI);
        OllllI := substr(lllll0, llllll+1, Olllll - llllll - 1);
        IllllI := Olllll+1;
        
        Il1ll1 := replace(Il1ll1, '<'||OllllI||' TYPE="','<'||OllllI||' aggr_function="'||ll11l1||'" TYPE="');
        if instr(OllllI, '_x') > 0 then
          OllllI := OlllI1(OllllI);
          Il1ll1 := replace(Il1ll1, '<'||OllllI||' TYPE="','<'||OllllI||' aggr_function="'||ll11l1||'" TYPE="');
        end if;
        
      end loop;
      if l_start_of_rowset then
        Il1ll1 := replace(Il1ll1, '<ROW>','<ROW ll010I="1">');
        Il1ll1 := replace(Il1ll1, '<ROW ','<ROW ll010I="1" ');
      else
        Il1ll1 := replace(Il1ll1, '<ROW','<ROW ll010I="1"');
      end if;
    end if;
 
    if instr(Il1ll1, '<BREAKROW>1</BREAKROW>') > 0
  
    then
      if l_start_of_rowset then
        Il1ll1 := replace(Il1ll1, '<ROW ','<ROW breakrow="1" ');
        Il1ll1 := replace(Il1ll1, '<ROW>','<ROW breakrow="1">');
      else
        Il1ll1 := replace(Il1ll1, '<ROW','<ROW breakrow="1"');
      end if;
      Il1ll1 := replace(Il1ll1, '<BREAKROW>1</BREAKROW>','');
    end if;
 
     if instr(Il1ll1, '<BREAKROW>2</BREAKROW>') > 0
   
    then
      if l_start_of_rowset then
        Il1ll1 := replace(Il1ll1, '<ROW ','<ROW breakrow="2" ');
        Il1ll1 := replace(Il1ll1, '<ROW>','<ROW breakrow="2">');
      else
        Il1ll1 := replace(Il1ll1, '<ROW','<ROW breakrow="2"');
      end if;
      Il1ll1 := replace(Il1ll1, '<BREAKROW>2</BREAKROW>','');
    end if;
 
    Ollll0 := instr(Il1ll1, '<REGION_HIGHLIGHTS>');
    Illll1 := instr(Il1ll1, '</REGION_HIGHLIGHTS>', Ollll0);
    if nvl(Ollll0, 0) > 0 and nvl(Illll1, 0) > 0 then
      Ollll0 := Ollll0 + length('<REGION_HIGHLIGHTS>');
      lllll1 := substr(Il1ll1, Ollll0, Illll1-Ollll0);
      
      lllll1 := replace(lllll1,'&quot;','"');
      
      if l_start_of_rowset then
        Il1ll1 := replace(Il1ll1, '<ROW ','<ROW '||lllll1||' ');
        Il1ll1 := replace(Il1ll1, '<ROW>','<ROW '||lllll1||'>');
      else
        Il1ll1 := replace(Il1ll1, '<ROW','<ROW '||lllll1);
      end if;
      
    end if;
 
    IlllII := llllII;
    
    Il01I1 := Il01I1||chr(10)||Il1ll1;
  end loop;
  
  Il01I1 := Illl1l(Il01I1, 'REGION_AGGREGATES');
  Il01I1 := Illl1l(Il01I1, 'REGION_HIGHLIGHTS');
  
  return Il01I1;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'OIll1I (VARCHAR2)',
      p_sqlerrm => sqlerrm
    );
    raise;
end OIll1I;
 

PROCEDURE OIll1I(
  pio_clob        IN OUT NOCOPY CLOB
)
as
I100001 varchar2(32000);
l10000I constant number := 20000;
 
O10000I number default 0;
I10000l  constant VARCHAR2(100) := '<ROW>';
l10000l    constant VARCHAR2(100) := '</ROW>';
lll0II number default 1;
Oll0I1 number default 0;
O100010 number default 1;
I100010 number;
l100011 number;
OlII11 PLS_INTEGER := dbms_utility.get_time();
O100011 PLS_INTEGER;
I10001I number;
Ol0l11 clob;
l10001I boolean default true;
begin
  if  dbms_lob.instr(pio_clob, '<REGION_AGGREGATES') > 0 or
    dbms_lob.instr(pio_clob, '<REGION_HIGHLIGHTS') >0 or
    dbms_lob.instr(pio_clob, '<BREAKROW')>0
  then 
    dbms_lob.createtemporary(Ol0l11, false);
    loop
      O10000I := 0;
      lll0II := dbms_lob.instr(pio_clob, I10000l, greatest(Oll0I1, 1));
      
      exit when nvl(lll0II, 0) = 0;
      Oll0I1 := lll0II + length(I10000l);
      if l10001I then
        I10001I := lll0II - 1;
        dbms_lob.read(pio_clob, I10001I, 1, I100001);
        dbms_lob.writeappend(Ol0l11, length(I100001), I100001);
        l10001I := false;
      end if;
 
      O100010 := dbms_lob.instr(pio_clob, l10000l, Oll0I1 + l10000I);
 
      if nvl(O100010, 0) = 0 then
        loop
          O100010 := dbms_lob.instr(pio_clob, l10000l, Oll0I1);
          exit when nvl(O100010, 0) = 0;
          O100010 := O100010 + length(l10000l);
          exit when O100010 - lll0II > l10000I;
          Oll0I1 := O100010;
          
        end loop;
      else
        Oll0I1 := O100010 + length(l10000l);
      end if;
      l100011 := Oll0I1 - lll0II;
      dbms_lob.read(pio_clob, l100011, lll0II, I100001);
 
      I100001 := OIll1I(I100001);
      dbms_lob.writeappend(Ol0l11, length(I100001), I100001);
      
    end loop;
    
    I10001I := dbms_lob.getlength(pio_clob)- Oll0I1;
    pak_xslt_log.WriteLog(
        'Last read amount '||I10001I||' offset '||Oll0I1,
        p_procedure => 'OIll1I');
    dbms_lob.read(pio_clob, I10001I, Oll0I1 + 1, I100001);
    dbms_lob.writeappend(Ol0l11, length(I100001), I100001);
    pio_clob := Ol0l11;
 
    dbms_lob.freetemporary(Ol0l11);
  end if;
  pak_xslt_log.WriteLog(
      'OIll1I (CLOB) finished. ',
      p_procedure => 'OIll1I (CLOB)',
      p_start_time => OlII11
  );
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'OIll1I (CLOB)',
      p_sqlerrm => sqlerrm
    );
    raise;
end OIll1I;
 
 
procedure O10001l
(
  p_clob          IN OUT NOCOPY CLOB
)
IS
I10001l CLOB;
l1000I0 number;
O1000I0 varchar2(4000);
I1000I1 number;
l1000I1 number;
O1000II number;
I1000II number;
l1000Il number;
O1000Il varchar2(32000);
ll01I1 number default 1;
begin
  
  I1000I1 := dbms_lob.instr(p_clob, 'boundary="');
  if nvl(I1000I1, 0) = 0 then
    
    return;
  end if;
  I1000I1 := I1000I1 + length('boundary="');
  l1000I0 := dbms_lob.instr(p_clob, '"', I1000I1);
  if nvl(l1000I0, 0) = 0 then
    
    return;
  end if;
  O1000I0 := dbms_lob.substr(p_clob, l1000I0 - I1000I1, I1000I1);
  if instr(O1000I0, '_NextPart_') = 0 then
    
    return;
  end if;
  I1000I1 := l1000I0;
  loop
    I1000II := dbms_lob.instr(p_clob, O1000I0, l1000I0, ll01I1);
    exit when nvl(I1000II, 0) = 0;
    l1000Il := dbms_lob.instr(p_clob, O1000I0, l1000I0, ll01I1 + 1);
    exit when nvl(l1000Il, 0) = 0;
    
    l1000I1 := dbms_lob.instr(p_clob, 'Content-Type: ', I1000II);
    if l1000I1 > 0 and l1000I1 < l1000Il then
      l1000I1 := l1000I1 + length('Content-Type: ');
      O1000II:= dbms_lob.instr(p_clob, ';', l1000I1);
      if O1000II > 0 and l1000I1 < l1000Il then
        O1000Il := dbms_lob.substr(p_clob, O1000II-l1000I1, l1000I1);
        if O1000Il = 'text/html' then
          
          pak_blob_util.clobReplace(p_clob, '='||chr(10), '='||chr(13)||chr(10), I1000II, l1000Il);
          
          null;
        end if;
      end if;
    end if;
    ll01I1 := ll01I1 + 1;
  end loop;
  pak_blob_util.clobReplaceAll(p_clob, chr(10)||chr(10), g_crlf);
  
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'O10001l',
      p_sqlerrm => sqlerrm
    );
    raise;
end O10001l;
 
 
 

 
 
procedure I1000l0(
pio_xml IN OUT NOCOPY CLOB,
p_encoding varchar2 default 'utf-8'
)
as
  ll1l1I varchar2(200);
begin
  if p_encoding is null then
    ll1l1I := '<?xml version="1.0"?>'||g_crlf||'<DOCUMENT>';
  else
    ll1l1I := '<?xml version="1.0" encoding="'||p_encoding||'"?>'||g_crlf||'<DOCUMENT>';
  end if;
  DBMS_LOB.CREATETEMPORARY (pio_xml, false);
  DBMS_LOB.WRITE (pio_xml, lengthb(ll1l1I), 1, ll1l1I);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'I1000l0',
      p_sqlerrm => sqlerrm
    );
    raise;
end I1000l0;
 
procedure l1000l0(
pio_xml IN OUT NOCOPY CLOB
)
as
  Ol1l1l constant varchar2(40) := '</DOCUMENT>';
begin
  DBMS_LOB.WRITEAPPEND (pio_xml, lengthb(Ol1l1l), Ol1l1l);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'l1000l0',
      p_sqlerrm => sqlerrm
    );
    raise;
end l1000l0;
 
 
function IIlIll(
  OIll00 varchar2,
  IIll00 varchar2 default '#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
Il01I1 varchar2(4000);
begin
  Il01I1 := OIll00;
  Il01I1:= replace(Il01I1,' ','_');
  for ll01I1 in 1..length(IIll00) loop
    Il01I1:= substr(replace(Il01I1, substr(IIll00,ll01I1, 1), 'llll10'||trim(to_char(ascii(substr(IIll00,ll01I1, 1)),'xx'))),1,30);
  end loop;
  return Il01I1;
end;
 
procedure O1000l1
(
  I1000l1 IN varchar2
  ,l1000lI IN OUT tab_string
)
as
begin
  l1000lI.extend;
  l1000lI(l1000lI.count) := I1000l1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O1000l1',
    p_sqlerrm => sqlerrm
  );
  raise;
end O1000l1;
 
procedure O1000lI
(
  I1000ll IN t_coltype_table
  ,l1000ll IN OUT t_coltype_tables
)
as
begin
  l1000ll.extend;
  l1000ll(l1000ll.count) := I1000ll;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O1000lI',
    p_sqlerrm => sqlerrm
  );
  raise;
end O1000lI;
 

function OIllll
(
  IIllll  IN varchar2
)
return t_coltype_table
as
  Ol1011           NUMBER;
  col_cnt     INTEGER;
  Ol1lIl     DBMS_SQL.DESC_TAB;
  O100100  varchar2(40);
  I100100      varchar2(40);
  
  Il01I1       t_coltype_table := t_coltype_table();
  Il01II   varchar2(4000);
 
  cursor Il0Ill(l100101 number) is
    select ora_type
    from oratype_codes where ora_code = l100101;
begin
  pak_xslt_log.WriteLog(
    'Start OIllll(IIllll): '||IIllll ,
    p_procedure => 'OIllll'
  );
 
  if IIllll is null then
    return Il01I1;
  end if;
 
  Ol1011 := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(Ol1011, IIllll, DBMS_SQL.NATIVE);
  DBMS_SQL.DESCRIBE_COLUMNS(Ol1011, col_cnt, Ol1lIl);
  DBMS_SQL.CLOSE_CURSOR(Ol1011);
 
  for ll01I1 in 1..Ol1lIl.count loop
    I100100 := 'STRING';
    if Ol1lIl(ll01I1).col_name not in ('REGION_HIGHLIGHTS') then
      Il01II := IIlIll(Ol1lIl(ll01I1).col_name);
      open Il0Ill(Ol1lIl(ll01I1).col_type);
      fetch Il0Ill into O100100;
      if Il0Ill%notfound then
        pak_xslt_log.WriteLog(
          'Can''Il0lI0 find data type with ID: '||Ol1lIl(ll01I1).col_type||' in ORATYPE_CODES view, using ID instead ',
          p_log_type => pak_xslt_log.g_warning,
          p_procedure => 'OIllll'
        );
      end if;
 
      if Ol1lIl(ll01I1).col_type = 231 or O100100 = 'DATE' or O100100 like 'TIMESTAMP%' then
        I100100 := 'DATE';
      elsif O100100 = 'NUMBER' then
        I100100 := 'NUMBER';
      end if;
      Il01I1.extend;
      Il01I1(Il01I1.count) := t_coltype_row(Il01II, I100100, null, null, replace(Il01II, '_', ' '));
      
      close Il0Ill;
    end if;
  end loop;
  
  return Il01I1;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'OIllll(IIllll)',
      p_sqlerrm => sqlerrm
    );
    raise;
end OIllll;
 

 

 
function O100101
(
  pi_selectQueries  IN tab_string
)
return t_coltype_tables
as
Il01I1 t_coltype_tables := t_coltype_tables();
begin
  for ll01I1 in 1..pi_selectQueries.count loop
    O1000lI(OIllll(pi_selectQueries(ll01I1)), Il01I1);
  end loop;
  return Il01I1;
end;
 
 

procedure I10010I(
  pio_clob IN OUT NOCOPY CLOB,
  l10010I varchar2,
  IIlI1l number
)
as
Ol0l11 CLOB;
begin
  dbms_lob.createtemporary(Ol0l11, false);
  dbms_lob.copy(Ol0l11, pio_clob, IIlI1l - 1);
  dbms_lob.writeappend(Ol0l11, length(l10010I), l10010I);
  dbms_lob.copy(Ol0l11, pio_clob, dbms_lob.getlength(pio_clob) - IIlI1l + 1, dbms_lob.getlength(Ol0l11) + 1, IIlI1l);
  dbms_lob.trim(pio_clob, 0);
  pio_clob := Ol0l11;
  dbms_lob.freetemporary(Ol0l11);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I10010I',
    p_sqlerrm => sqlerrm
  );
  raise;
end I10010I;
 
 
function O10010l(I10010l CLOB)
return t_string_table
as
lll0II number;
Oll0I1 number;
l100110 varchar2(32000);
Oll0Il varchar2(200);
Il01I1 t_string_table:= t_string_table();
begin
  lll0II := dbms_lob.instr(I10010l, '<ROW>');
  if lll0II > 0 then
    lll0II := lll0II + length('<ROW>');
    Oll0I1 := dbms_lob.instr(I10010l, '</ROW>');
    if Oll0I1 > 0 then
      l100110 := dbms_lob.substr(I10010l, Oll0I1 - lll0II, lll0II);
      pak_xslt_log.WriteLog('l100110: '||l100110, p_procedure => 'O10010l');
      lll0II := 1;
      loop
        lll0II := instr(l100110,'<', lll0II);
        exit when nvl(lll0II, 0) = 0;
        Oll0I1 := instr(l100110,'>', lll0II);
        exit when nvl(Oll0I1, 0) = 0;
        Oll0Il := substr(l100110, lll0II + 1, Oll0I1 - (lll0II+1));
        lll0II := instr(l100110, '</'||Oll0Il||'>', Oll0I1);
        exit when nvl(lll0II, 0) = 0;
        lll0II := lll0II + length('</'||Oll0Il||'>');
        Il01I1.extend;
        Il01I1(Il01I1.count) := t_string_row(Oll0Il);
        pak_xslt_log.WriteLog(Oll0Il||' added', p_procedure => 'O10010l');
      end loop;
    end if;
  end if;
  return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O10010l',
    p_sqlerrm => sqlerrm
  );
  raise;
end O10010l;
 
function Ol00I0(
  Il00I0 varchar2,
  IIll00 varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
Il01I1 varchar2(4000);
begin
  Il01I1 := Il00I0;
  
  for ll01I1 in 1..length(IIll00) loop
    Il01I1:= replace(Il01I1, '_x00'||trim(to_char(ascii(substr(IIll00,ll01I1, 1)),'xx'))||'_', substr(IIll00, ll01I1, 1));
    Il01I1:= replace(Il01I1, '_x00'||trim(to_char(ascii(substr(IIll00,ll01I1, 1)),'XX'))||'_', substr(IIll00, ll01I1, 1));
  end loop;
  return Il01I1;
end Ol00I0;
 


 

procedure O100110(
  I100111 IN OUT CLOB,
  l100111 t_coltype_table,
  O10011I varchar2
)
as
OlIlI1 number;

I10011I t_string_table;
IlI0ll varchar2(64);
l10011l varchar2(30);
O10011l varchar2(60);
l_width number;
I1001I0 varchar2(200);
l1001I0 varchar2(32000);
ll01I1 number := 0;
Il0Ill sys_refcursor; 
O1001I1 CLOB;
I100001 varchar2(32000);
I1001I1 number := 4000;
l1001II boolean := true;
O1001II number;
 
 
begin
  pak_xslt_log.WriteLog(
      'Start procedure I100111 size: '||dbms_lob.getlength(I100111),
      p_procedure => 'O100110'
    );
 
  
 
  OlIlI1 := dbms_lob.instr(I100111, '<ROWSET>');
  if nvl(OlIlI1, 0) > 0 then
    
    pak_xslt_log.WriteLog(
      'Start O10010l',
      p_procedure => 'O100110'
    );
    I10011I := O10010l(I100111);
    pak_xslt_log.WriteLog(
      'End O10010l',
      p_procedure => 'O100110'
    );
 
 
    dbms_lob.createtemporary(O1001I1, false);
    OlIlI1 := 1;
 
    loop
      exit when nvl(OlIlI1, 0) = 0;
      O1001II := OlIlI1;
      loop
        OlIlI1 := dbms_lob.instr(I100111, '<ROW>', OlIlI1);
        exit when nvl(OlIlI1, 0) = 0;
        OlIlI1 := OlIlI1 + length('<ROW>');
        exit when OlIlI1 - O1001II > I1001I1;
      end loop;
 
 
      
      
      
     
 
 
      if nvl(OlIlI1, 0) = 0 then
        I100001 := dbms_lob.substr(I100111, I1001I1 + 1000, O1001II);
      else
        OlIlI1 := OlIlI1 - length('<ROW>');
        I100001 := dbms_lob.substr(I100111, OlIlI1 - O1001II, O1001II);
      end if;
      if l1001II then
        I100001 := replace(I100001, '<ROWSET>', '<ROWSET '||O10011I||'>');
      end if;
 
 
      
      
      
      
 
 
      open Il0Ill for
      select nvl(I1001Il.col, Il0lI0.colname), Il0lI0.coltype, Il0lI0.formatmask, Il0lI0.columnwidth, Il0lI0.fullname from table(l100111) Il0lI0
      left outer join table(I10011I) I1001Il on Ol00I0(I1001Il.col) = Ol00I0(Il0lI0.colname);
 
      loop
        fetch Il0Ill into IlI0ll, l10011l, O10011l, l_width, I1001I0;
        exit when Il0Ill%notfound;
        
        
        I100001 := replace(I100001, '<'||IlI0ll||'>',
          '<'||IlI0ll||' TYPE="'||l10011l||'" '||
          case when O10011l is not null then 'FORMAT_MASK="'||O10011l||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          'FULL_NAME="'||replace(I1001I0,'_',' ')||'">');
 
        I100001 := replace(I100001, '<'||IlI0ll||'/>',
          '<'||IlI0ll||' TYPE="'||l10011l||'" '||
          case when O10011l is not null then 'FORMAT_MASK="'||O10011l||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          'FULL_NAME="'||replace(I1001I0,'_',' ')||'"/>');
 
        ll01I1 := ll01I1 + 1;
      end loop;
      close Il0Ill;
 
 
      
      
      
      
 
      dbms_lob.writeappend(O1001I1, length(I100001), I100001);
 
 
      l1001II:= false;
    end loop;
    
    dbms_lob.trim(I100111, 0);
    dbms_lob.copy(I100111, O1001I1, dbms_lob.getlength(O1001I1));
    
    dbms_lob.freetemporary(O1001I1);
 
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O100110',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
procedure l1001Il
(
  pio_xml in out nocopy clob
  ,ll000l in varchar2
  ,IIllll  IN varchar2
  ,Ol000l IN t_coltype_table
  ,Ol001I  IN PLS_INTEGER
) as
Ol0l11 CLOB;
O1001l0 number;
I1001l0 constant varchar2(40) := '<?xml version="1.0"?>';
l1001l1 constant varchar2(4000) := '<ROWSET '||ll000l||'></ROWSET>';
llIII1 varchar2(32000);
Illl10 varchar2(20);
O1001l1 varchar2(4000);
OlIlI1 number;
ctx DBMS_XMLGEN.ctxHandle;
 
l_region_src varchar2(32000);
l_start_region_src number;
l_end_region_src number;
 

begin
    pak_xslt_log.WriteLog(
      'Start procedure ll000l '||ll000l,
      p_procedure => 'l1001Il(varchar2)'
    );
 
    if IIllll is null then
      pak_xslt_log.WriteLog(
        'IIllll is null',
        p_procedure => 'l1001Il(varchar2)'
      );
    else
      pak_xslt_log.WriteLog(
        'IIllll '||IIllll,
        p_procedure => 'l1001Il(varchar2)'
      );
 
    end if;
 
    if ll000l is null then
      pak_xslt_log.WriteLog(
        'll000l is null',
        p_procedure => 'l1001Il(varchar2)'
      );
    else
      pak_xslt_log.WriteLog(
        'll000l '||ll000l,
        p_procedure => 'l1001Il(varchar2)'
      );
    end if;
 
    
    BEGIN
        ctx := DBMS_XMLGEN.NEWCONTEXT(IIllll);
 
        
 
        DBMS_XMLGEN.SETMAXROWS (ctx, Ol001I);
        DBMS_XMLGEN.SETROWSETTAG (ctx, 'ROWSET');
        DBMS_XMLGEN.SETROWTAG(ctx, 'ROW');
        DBMS_XMLGEN.SETNULLHANDLING(ctx, DBMS_XMLGEN.EMPTY_TAG);
        
        
        pak_xslt_log.WriteLog(
          'Start DBMS_XMLGEN.GETXML Ol001I: '||Ol001I,
          p_procedure => 'l1001Il(varchar2)'
        );
        Ol0l11:= DBMS_XMLGEN.GETXML (ctx);
      exception
        when others then
          pak_xslt_log.WriteLog(
            'Select statement is not properly composed. Statement: '||IIllll,
            p_log_type => pak_xslt_log.g_error,
            p_procedure => 'l1001Il(varchar2)',
            p_sqlerrm => sqlerrm
          );
          l_start_region_src := instr(IIllll, APEXREP2REPORT.g_start_region_src);
          l_end_region_src   := instr(IIllll, APEXREP2REPORT.g_end_region_src);
          if l_start_region_src > 0 and l_end_region_src > 0 then
              l_region_src := substr(IIllll, l_start_region_src + length(APEXREP2REPORT.g_start_region_src),
                                     l_end_region_src - l_start_region_src - length(APEXREP2REPORT.g_start_region_src) - 1);
              pak_xslt_log.WriteLog(
                'Trying with region select: '||l_region_src,
                p_log_type => pak_xslt_log.g_warning,
                p_procedure => 'l1001Il(varchar2)'
              );
              ctx := DBMS_XMLGEN.NEWCONTEXT(l_region_src);
              DBMS_XMLGEN.SETMAXROWS (ctx, Ol001I);
              DBMS_XMLGEN.SETROWSETTAG (ctx, 'ROWSET');
              DBMS_XMLGEN.SETROWTAG(ctx, 'ROW');
              DBMS_XMLGEN.SETNULLHANDLING(ctx, DBMS_XMLGEN.EMPTY_TAG);
              
              
              pak_xslt_log.WriteLog(
                  'Start DBMS_XMLGEN.GETXML with region source. Ol001I: '||Ol001I,
                  p_procedure => 'l1001Il(varchar2)'
              );
              Ol0l11:= DBMS_XMLGEN.GETXML (ctx);
          else
              raise;
          end if;
    END;
 
    pak_xslt_log.WriteLog(
      'Stop DBMS_XMLGEN.GETXML',
      p_procedure => 'l1001Il(varchar2)'
    );
 
    
 
    
    
 
    
    
    if Ol0l11 is null then
      dbms_lob.writeappend(pio_xml, length(l1001l1),l1001l1);
      pak_xslt_log.WriteLog(
        'Empty region ll000l '||ll000l,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'l1001Il(varchar2)'
      );
 
    else
      
      
      if l_region_src is null then
          O100110(Ol0l11, Ol000l, ll000l);
      else
          O100110(Ol0l11, OIllll(l_region_src), ll000l);
      end if;
 
      
      
 
 
 
       
      pak_xslt_log.WriteLog(
        'DBMS_XMLGEN.GETXML Ol0l11 size '||to_char(dbms_lob.getlength(Ol0l11)),
        p_procedure => 'l1001Il(varchar2)'
      );
 
      O1001l0 := lengthb(I1001l0);
      DBMS_LOB.ERASE(Ol0l11, O1001l0);
      pak_xslt_log.WriteLog(
        'Start DBMS_LOB.APPEND',
        p_procedure => 'l1001Il(varchar2)'
      );
 
      DBMS_LOB.APPEND(pio_xml, Ol0l11);
      pak_xslt_log.WriteLog(
        'DBMS_LOB.APPEND',
        p_procedure => 'l1001Il(varchar2)'
      );
 
      
      DBMS_LOB.FREETEMPORARY (Ol0l11);
      pak_xslt_log.WriteLog(
        'DBMS_LOB.FREETEMPORARY',
        p_procedure => 'l1001Il(varchar2)'
      );
      
    end if;
  exception
    when others then
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'l1001Il(varchar2)',
        p_sqlerrm => sqlerrm
      );
      raise;
end l1001Il;
 
procedure l1001Il
(
  pio_xml in out nocopy clob
  ,ll000l in varchar2
  ,IIllll  IN SYS_REFCURSOR
  ,Ol000l IN t_coltype_table
  ,Ol001I  IN PLS_INTEGER
) as
Ol0l11 CLOB;
O1001l0 number;
I1001l0 constant varchar2(40) := '<?xml version="1.0"?>';
l1001l1 constant varchar2(4000) := '<ROWSET '||ll000l||'></ROWSET>';
Illl10 varchar2(20);
O1001l1 varchar2(4000);
llIII1 varchar2(32000);
OlIlI1 number;
 


begin
     pak_xslt_log.WriteLog(
      'Start procedure',
      p_procedure => 'l1001Il(SYS_REFCURSOR)'
    );
 
    
    
 
    
    select swkey, coded into Illl10, O1001l1 from xsltswkey;
 
    llIII1 := OIll01(O1001l1, Illl10);
 
    EXECUTE IMMEDIATE llIII1 USING IN IIllll, IN Ol001I, OUT Ol0l11;
 
    
 
    if Ol0l11 is null then
      dbms_lob.writeappend(pio_xml, length(l1001l1),l1001l1);
      pak_xslt_log.WriteLog(
        'Empty region ll000l '||ll000l,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'l1001Il(SYS_REFCURSOR)'
      );
    else
      O100110(Ol0l11, Ol000l, ll000l);
 
      pak_xslt_log.WriteLog(
        'Start DBMS_XMLGEN.GETXML',
        p_procedure => 'l1001Il(SYS_REFCURSOR)'
      );
      O1001l0 := lengthb(I1001l0);
      DBMS_LOB.ERASE(Ol0l11, O1001l0);
 
      pak_xslt_log.WriteLog(
        'Start Append',
        p_procedure => 'l1001Il(SYS_REFCURSOR)'
      );
      DBMS_LOB.APPEND(pio_xml, Ol0l11);
      pak_xslt_log.WriteLog(
        'Append',
        p_procedure => 'l1001Il(SYS_REFCURSOR)'
      );
      DBMS_LOB.FREETEMPORARY (Ol0l11);
      
    end if;
 
exception
    when others then
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'l1001Il(varchar2)',
        p_sqlerrm => sqlerrm
      );
      raise;
end l1001Il;
 
 
function ll001I
(
  pi_regionAttrs in tab_string
  ,pi_selectQueries   IN tab_string
  ,Ol000l     IN t_coltype_tables
  ,Ol001I        in tab_integer
 
) return clob as
I1001lI number;
IlII1l CLOB;
Illl10 varchar2(20);
O1001l1 varchar2(4000);
 
begin
  I1001lI := least(pi_selectQueries.count, pi_regionAttrs.count);
  
  pak_xslt_log.WriteLog(
    'Start procedure',
    p_procedure => 'll001I(tab_string)'
  );
  I1000l0(IlII1l);
  pak_xslt_log.WriteLog(
    'I1000l0',
    p_procedure => 'll001I(tab_string)'
  );
 
  for ll01I1 in 1..I1001lI loop
    pak_xslt_log.WriteLog(
      'Loop Start l1001Il '||to_char(ll01I1),
      p_procedure => 'll001I(tab_string)'
    );
    l1001Il(IlII1l, pi_regionAttrs(ll01I1), pi_selectQueries(ll01I1), Ol000l(ll01I1), Ol001I(ll01I1));
 
    
 
    pak_xslt_log.WriteLog(
      'Loop End l1001Il '||to_char(ll01I1),
      p_procedure => 'll001I(tab_string)'
    );
  end loop;
 
  l1000l0(IlII1l);
 
  
 
  pak_xslt_log.WriteLog(
    'l1000l0',
    p_procedure => 'll001I(tab_string)'
  );
 
  return IlII1l;
  exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'll001I(tab_string)',
    p_sqlerrm => sqlerrm
  );
  raise;
end ll001I;
 
 
 
procedure l1001lI
(
  O1001ll IN varchar2
  ,I1001ll IN OUT tab_integer
)
as
begin
  I1001ll.extend;
  I1001ll(I1001ll.count) := O1001ll;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l1001lI',
    p_sqlerrm => sqlerrm
  );
  raise;
end l1001lI;
 
 
procedure Il000I
(
  ll000l    IN varchar2
  ,IIllll     IN varchar2
  ,Ol000l     IN t_coltype_table
  ,pi_maxRows         IN PLS_INTEGER
  ,Il0010 IN OUT tab_string
  ,ll0010  IN OUT tab_string
  ,Ol0011  IN OUT t_coltype_tables
  ,Il0011        IN OUT tab_integer
)
as
begin
  if ll000l is not null and IIllll is not null then
    O1000l1(IIllll, ll0010);
    O1000lI(Ol000l, Ol0011);
    O1000l1(ll000l, Il0010);
    l1001lI(nvl(pi_maxRows, 100000), Il0011);
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Il000I',
    p_sqlerrm => sqlerrm
  );
  raise;
end Il000I;
 
 
 
function ll001I
(
  pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,l100I00   IN t_coltype_table default null
  ,pi_maxRows1       IN PLS_INTEGER default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,O100I00   IN t_coltype_table default null
  ,pi_maxRows2       IN PLS_INTEGER default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,I100I01   IN t_coltype_table default null
  ,pi_maxRows3       IN PLS_INTEGER default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,l100I01   IN t_coltype_table default null
  ,pi_maxRows4       IN PLS_INTEGER default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,O100I0I   IN t_coltype_table default null
  ,pi_maxRows5       IN PLS_INTEGER default 20
) return clob as
OlIII0 tab_string := tab_string();
IlI1II  tab_string := tab_string();
llI1II    t_coltype_tables := t_coltype_tables();
OlI1Il        tab_integer := tab_integer();
 
begin
  Il000I(pi_regionAttr1, pi_selectQuery1, l100I00, pi_maxRows1, OlIII0, IlI1II, llI1II, OlI1Il);
  Il000I(pi_regionAttr2, pi_selectQuery2, O100I00, pi_maxRows2, OlIII0, IlI1II, llI1II, OlI1Il);
  Il000I(pi_regionAttr3, pi_selectQuery3, I100I01, pi_maxRows3, OlIII0, IlI1II, llI1II, OlI1Il);
  Il000I(pi_regionAttr4, pi_selectQuery4, l100I01, pi_maxRows4, OlIII0, IlI1II, llI1II, OlI1Il);
  Il000I(pi_regionAttr5, pi_selectQuery5, O100I0I, pi_maxRows5, OlIII0, IlI1II, llI1II, OlI1Il);
 
  return ll001I(OlIII0, IlI1II, llI1II, OlI1Il);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'll001I(varchar2)',
    p_sqlerrm => sqlerrm
  );
  raise;
 
end ll001I;
 
function ll001I
(
   pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,l100I00   IN t_coltype_table default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,O100I00   IN t_coltype_table default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,I100I01   IN t_coltype_table default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,l100I01   IN t_coltype_table default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,O100I0I   IN t_coltype_table default null
  ,pi_maxRows5       IN pls_integer default 20
) return clob as
IlII1l CLOB;
begin
  I1000l0(IlII1l);
  if pi_regionAttr1 is not null and pi_selectQuery1 is not null then
     l1001Il(IlII1l, pi_regionAttr1, pi_selectQuery1, l100I00, pi_maxRows1);
  end if;
  if pi_regionAttr2 is not null and pi_selectQuery2 is not null then
     l1001Il(IlII1l, pi_regionAttr2, pi_selectQuery2, O100I00, pi_maxRows2);
  end if;
  if pi_regionAttr3 is not null and pi_selectQuery3 is not null then
     l1001Il(IlII1l, pi_regionAttr3, pi_selectQuery3, I100I01, pi_maxRows3);
  end if;
  if pi_regionAttr4 is not null and pi_selectQuery4 is not null then
     l1001Il(IlII1l, pi_regionAttr4, pi_selectQuery4, l100I01, pi_maxRows4);
  end if;
  if pi_regionAttr5 is not null and pi_selectQuery5 is not null then
     l1001Il(IlII1l, pi_regionAttr5, pi_selectQuery5, O100I0I, pi_maxRows5);
  end if;
 
  
  l1000l0(IlII1l);
  
 
 
  return IlII1l;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'll001I (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  raise;
end ll001I;
 
procedure I100I0I(
  pio_clob IN OUT NOCOPY CLOB,
  p_format number
)
as
begin
  if p_format = F_MHT then
    O10001l(pio_clob);
  
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I100I0I',
    p_sqlerrm => sqlerrm
  );
  raise;
end I100I0I;
 
 function l100I0l(p_filename varchar2)
 return boolean
 as
 begin
  return upper(substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1))) in ('DOCX', 'XLSX', 'PPTX');
 end;
 

 
 
function XslTransform
(
p_Xml               IN    CLOB,
p_Xslt              IN    CLOB,
p_format            IN    number,
po_error            OUT   boolean,
p_template          IN    CLOB default null,
p_external_params   IN    varchar2 default null
) return BLOB
as
 
 
p           DBMS_XSLPROCESSOR.Processor;
ss          DBMS_XSLPROCESSOR.Stylesheet;
xmldoc      DBMS_XMLDOM.DOMDOCUMENT;
xsltDoc      DBMS_XMLDOM.DOMDOCUMENT;
 
O100I0l     CLOB;
I100I10     BLOB;
 
IlIIl1 varchar2(1000);
 
I100lII number;
l_first_quote_pos number;
l_second_quote_pos number;
l_end_name_value number;
 
l_start_name_value number default 1;
l_name_value varchar2(100);
l_equal_sign_pos number;
l101I1I varchar2(100);
llIll1 varchar2(100);
l_external_params_count number default 1;
OlII11 PLS_INTEGER;
 
 
begin
  if p_Xml is null then
    pak_xslt_log.WriteLog(
      'p_Xml is null',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'XslTransform - function with XSLT CLOB'
    );
  end if;
      
  po_error := false;    
 
  p:= DBMS_XSLPROCESSOR.NEWPROCESSOR;
  xmldoc := DBMS_XMLDOM.NEWDOMDOCUMENT(p_Xml);
  DBMS_LOB.CREATETEMPORARY(O100I0l, false);
  xsltDoc := DBMS_XMLDOM.NEWDOMDOCUMENT(p_Xslt);
  ss:= DBMS_XSLPROCESSOR.NEWSTYLESHEET(xsltDoc, null);
  DBMS_XSLPROCESSOR.RESETPARAMS(ss);
 
  
  if p_external_params is not null then
    IlIIl1 := trim(p_external_params);
    l_end_name_value := 1;
 
    while nvl(l_end_name_value, 0) > 0 and l_external_params_count < 100
    loop
      I100lII := instr(IlIIl1,' ',l_start_name_value);
      l_first_quote_pos := instr(IlIIl1,'''',l_start_name_value, 1);
      l_second_quote_pos := instr(IlIIl1,'''',l_start_name_value, 2);
 
      if I100lII not between l_first_quote_pos and l_second_quote_pos
      then
        l_end_name_value := I100lII - 1;
      else
        l_end_name_value := l_second_quote_pos;
      end if;
      if nvl(l_end_name_value, 0) <= 0 then
        l_name_value := trim(substr(IlIIl1, l_start_name_value));
      else
        l_name_value := trim(substr(IlIIl1, l_start_name_value, l_end_name_value-l_start_name_value+1));
      end if;
      l_equal_sign_pos := instr(l_name_value, '=');
 
      if nvl(l_equal_sign_pos, 0)  > 0 then
        l101I1I := trim(substr(l_name_value, 1, l_equal_sign_pos - 1));
        llIll1 := trim(substr(l_name_value, l_equal_sign_pos + 1));
        if l101I1I is not null and llIll1 is not null then
          if substr(llIll1,1,1) != '''' or substr(llIll1,length(llIll1),1)!= '''' then
             pak_xslt_log.WriteLog(
             'Wrapping '||to_char(llIll1)||' with quotes before sending to DBMS_XSLPROCESSOR.SETPARAM',
             p_procedure => 'XslTransform - function with XSLT CLOB');
             llIll1 := ''''||llIll1||'''';
          end if;
          pak_xslt_log.WriteLog(
            'DBMS_XSLPROCESSOR.SETPARAM(l101I1I='||to_char(l101I1I)||', llIll1='||to_char(llIll1)||')',
            p_procedure => 'XslTransform - function with XSLT CLOB'
          );
          DBMS_XSLPROCESSOR.SETPARAM(ss, l101I1I, llIll1);
 
          pak_xslt_log.WriteLog(
            'Finished DBMS_XSLPROCESSOR.SETPARAM(l101I1I='||to_char(l101I1I)||', llIll1='||to_char(llIll1)||')',
            p_procedure => 'XslTransform - function with XSLT CLOB'
          );
        end if;
      end if;
      l_start_name_value := l_end_name_value + 2;
      l_external_params_count := l_external_params_count + 1;
    end loop;
  end if;
  
  OlII11 := dbms_utility.get_time;
  pak_xslt_log.WriteLog(
      'DBMS_XSLPROCESSOR.PROCESSXSL started',
      p_procedure => 'XslTransform - function with XSLT CLOB',
      p_start_time => OlII11
    );
 
  DBMS_XSLPROCESSOR.PROCESSXSL(p, ss, xmldoc, O100I0l);
  pak_xslt_log.WriteLog(
      'DBMS_XSLPROCESSOR.PROCESSXSL finished',
      p_procedure => 'XslTransform - function with XSLT CLOB',
      p_start_time => OlII11
  );
  DBMS_XMLDOM.FREEDOCUMENT(xsltDoc);
  DBMS_XMLDOM.FREEDOCUMENT(xmldoc);
  DBMS_XSLPROCESSOR.FREESTYLESHEET(ss);
  DBMS_XSLPROCESSOR.FREEPROCESSOR(p);
 
  
 
  
 
  
 
  
  
  
  
 
  
  if p_format = f_ooxml then
      if O100I0l is not null and p_template is not null then 
          I100I10 := "i1lIlII11".FlatOPC2OOXML(O100I0l, p_template);
      else
          pak_xslt_log.WriteLog(
              'Error O100I0l is null or p_template is null',
              p_log_type => pak_xslt_log.g_error,
              p_procedure => 'XslTransform - function with XSLT BLOB'
          );
      end if;
  else
      I100I10 := pak_blob_util.clob2blob(O100I0l);
  end if;
  return I100I10;
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - function with XSLT BLOB',
    P_SQLERRM => sqlerrm
  );
  
  raise;
end XslTransform;
 
 
$if CCOMPILING.g_utl_file_privilege $then

function XslTransform
(
p_Xml             IN    CLOB,
p_xsltDir         IN    varchar2,
p_xsltFile        IN    varchar2,
p_format          IN    number,
po_error          OUT   boolean,
p_Template          IN    CLOB, 
P_NLS_CHARSET     IN    VARCHAR2 default null,
p_external_params IN    varchar2 default null
) return BLOB
as
 
l100I10        CLOB;
 
begin
  l100I10 := pak_blob_util.READ2CLOB(p_xsltDir, p_xsltFile, P_NLS_CHARSET);
  return XslTransform(
    p_Xml => p_Xml,
    p_Xslt => l100I10,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params
  );
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - function with XSLT file',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
$end
 
 

function O100I11
(
p_Xml                   IN    CLOB,
p_Xslt                  IN OUT  CLOB,
IIl1Il                IN    number,
IIl1I0               IN    number,
OIl11I           IN    varchar2,
p_format                IN    number,  
p_fileext               IN    varchar2, 
po_error                OUT   boolean,
p_template              IN OUT CLOB, 
p_external_params       IN    varchar2 default null
) return BLOB
as
begin
  pak_xslt_replacestr.SmartReplaceReportAttr(p_Xslt, IIl1Il, IIl1I0, OIl11I, p_format, p_fileext);
  pak_xslt_replacestr.SmartReplaceReportAttr(p_template, IIl1Il, IIl1I0, OIl11I, p_format, p_fileext);
  
 
  return XslTransform(
    p_Xml => p_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params
  );
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O100I11 (CLOB)',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
 
$if CCOMPILING.g_utl_file_privilege $then

procedure O100I11
(
p_xmlDir                IN    varchar2,
p_xmlFile               IN    varchar2,
p_xsltDir                IN    varchar2,
p_xsltFile               IN    varchar2,
p_xsltReplacedFile       IN    varchar2,
IIl1Il                IN    number,
IIl1I0               IN    number,
OIl11I           IN    varchar2,
p_format                IN    number,  
po_error                OUT   boolean,
p_templateDir                IN    varchar2,
p_templateFile               IN    varchar2,
p_templateReplacedFile       IN    varchar2,
p_outDir                IN    varchar2,
p_outFile               IN    varchar2,
p_external_params       IN    varchar2 default null
)
as
 
IlII1l         CLOB;
l100I10        CLOB;
I100I11    CLOB;
l_out         BLOB;
l_fileext varchar2(10);
 
begin
  l_fileext := lower(substr(p_outFile, nullif( instr(p_outFile,'.', -1) +1, 1) ));
  IlII1l := pak_blob_util.READ2CLOB(p_xmlDir, p_xmlFile);
  l100I10 := pak_blob_util.READ2CLOB(p_xsltDir, p_xsltFile);
  if p_format = f_ooxml then
    I100I11 := pak_blob_util.READ2CLOB(p_templateDir, p_templateFile);
  end if;
 
  pak_xslt_replacestr.SmartReplaceReportAttr(l100I10, IIl1Il, IIl1I0, OIl11I, p_format, l_fileext);
  dbms_xslprocessor.clob2file(l100I10, p_xsltDir, p_xsltReplacedFile);
  if p_format = f_ooxml then
    pak_xslt_replacestr.SmartReplaceReportAttr(I100I11, IIl1Il, IIl1I0, OIl11I, p_format, l_fileext);
    dbms_xslprocessor.clob2file(I100I11, p_templateDir, p_templateReplacedFile);
  end if;
 
  l_out := XslTransform(
    p_Xml => IlII1l,
    p_Xslt => l100I10,
    p_format => p_format,
    po_error => po_error,
    p_template => I100I11,
    p_external_params => p_external_params
  );
 
  pak_blob_util.Blob2File(p_outDir, p_outFile, l_out);
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O100I11 (file)',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
$end
 

function O100I11
(
  p_Xml                   IN    CLOB,
  p_xsltStaticFile        IN    varchar2,
  IIl1I0               IN    number,
  OIl11I           IN    varchar2,
  po_file_csid            OUT   number,
  p_format                IN    number,  
  p_fileext               IN    varchar2,
  po_error                OUT   boolean,
  p_templateStaticFile    IN    varchar2, 
  p_external_params       IN    varchar2 default null
) return BLOB
as
 
l100I10        CLOB;
I100I11    CLOB;
 
begin
  l100I10 := pak_blob_util.StaticFile2CLOB(p_xsltStaticFile, po_file_csid);
  
  if p_templateStaticFile is not null then
    I100I11 := pak_blob_util.StaticFile2CLOB(p_templateStaticFile, po_file_csid);
  end if;
 
  return O100I11
  (
    p_Xml => p_Xml,
    p_Xslt => l100I10,
    IIl1Il => V('APP_ID'),
    IIl1I0 => IIl1I0,
    OIl11I => OIl11I,
    p_format => p_format,  
    p_fileext => p_fileext,
    po_error => po_error,
    p_template => I100I11, 
    p_external_params => p_external_params
  );
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O100I11',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
 
$if CCOMPILING.g_utl_file_privilege $then

Procedure XslTransform
(
p_Xml                   IN    CLOB,
p_xsltDir               IN    varchar2,
p_xsltFile              IN    varchar2,
p_out_dir               IN    VARCHAR2,
p_out_fileName          IN    VARCHAR2,
p_format                IN    number, 
p_TemplateDir           IN    VARCHAR2, 
p_TemplateFile          IN    VARCHAR2, 
P_NLS_CHARSET           IN    VARCHAR2 default null,
p_external_params       IN    varchar2 default null
) as
 

l_output    BLOB;

l100II1    number;
l100Ill     boolean;
 
begin
  DBMS_LOB.CREATETEMPORARY(l_output, false);
  l_output := XslTransform(
    p_Xml => p_Xml,
    p_xsltDir => p_xsltDir,
    p_xsltFile => p_xsltFile,
    p_format => p_format,
    po_error => l100Ill,
    p_Template => pak_blob_util.READ2CLOB(p_TemplateDir, p_TemplateFile, nvl(NLS_CHARSET_ID(P_NLS_CHARSET), 0)),
    P_NLS_CHARSET => P_NLS_CHARSET,
    p_external_params => p_external_params
  );
 
 
  if l_output is null then
    pak_xslt_log.WriteLog(
      'XslTransform finished output null',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'XslTransform - XML as CLOB'
    );
  else
    l100II1 := dbms_lob.getlength(l_output);
    if l100II1 = 0 then
      pak_xslt_log.WriteLog(
        'XslTransform finished output zero length',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'XslTransform - XML as CLOB'
      );
    else
      pak_xslt_log.WriteLog(
        'XslTransform finished OK output CLOB length '||to_char(l100II1),
        p_procedure => 'XslTransform - XML as CLOB'
      );
    end if;
  end if;
 
  pak_blob_util.Blob2File(p_out_dir, p_out_fileName, l_output);
 
  
 
  
  pak_xslt_log.WriteLog(
      'dbms_xslprocessor.clob2file finished OK',
      p_procedure => 'XslTransform - XML as CLOB'
    );
  DBMS_LOB.FREETEMPORARY(l_output);
exception
  when others then
  DBMS_LOB.FREETEMPORARY(l_output);
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - XML as CLOB',
    P_SQLERRM => sqlerrm
  );
  raise;
end XslTransform;
$end
 

  function I100I1l(
    P_FILENAME VARCHAR2
  )
  return varchar2
  AS
  Il01I1 varchar2(20);
  l100I1l number;
  BEGIN
 
    l100I1l := INSTR(P_FILENAME, '.', -1, 1);
    if l100I1l > 0 then
      Il01I1 := lower(SUBSTR(P_FILENAME, l100I1l + 1));
    end if;
 
    return Il01I1;
  end;
 
  function O100II0(
    P_FILENAME VARCHAR2
  )
  return varchar2
  AS
  BEGIN
 
    return
    case I100I1l(P_FILENAME)
      when 'doc'  then 'application/msword'
      when 'docx' then 'application/msword'
      when 'rtf'  then 'application/rtf'
      when 'xls'  then 'application/excel'
      when 'xlsx' then 'application/excel'
      else 'application/octet'
    end;
  END O100II0;
 
 
procedure DownloadBlob(
    IIl1Il IN NUMBER,
    OIll1l IN OUT BLOB,
    P_FILENAME VARCHAR2,
    IIllI0 boolean default true,
    OIllI1 varchar2 default 'application/octet'
  )
  as
    I100II0 varchar2(50);
    l100II1 number;
    O100II1 number;
  begin
   apex_application.g_flow_id := IIl1Il;
 
    IF NOT nvl(wwv_flow_custom_auth_std.is_session_valid, false) then
      htp.p('Unauthorized access - file will not be downloaded. app_id '||to_char(IIl1Il));
 
      pak_xslt_log.WriteLog(
        'Unauthorized access from : '|| sys_context('userenv','ip_address') ,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'DownloadBlob'
      );
 
      RETURN;
    END IF;
 
    I100II0 := nvl(OIllI1, O100II0(p_filename));
    l100II1 := DBMS_LOB.GETLENGTH(OIll1l);
 
    
  
  
      
      
      
 
  owa_util.mime_header( nvl(I100II0,'application/octet'), FALSE );
 
  
  htp.p('Content-length: ' || l100II1);
  
  htp.p('Content-Disposition: attachment; filename="'||p_filename||'"');
  
  owa_util.http_header_close;
 
  
 
  wpg_docload.download_file(OIll1l);
  if IIllI0 then
    DBMS_LOB.FREETEMPORARY(OIll1l);
  end if;
 
  pak_xslt_log.WriteLog(
        'Downloaded : '||p_filename||' MIME '||nvl(I100II0,'application/octet') ,
        p_procedure => 'DownloadBlob'
  );
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadBlob',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
 
procedure DownloadConvertOutput
(
IIl1Il        number
,OIllII    BLOB
,p_file_name   VARCHAR2
,p_mime         VARCHAR2 default 'application/octet'
,IIllIl        boolean default false
,p_blob_csid    number default NLS_CHARSET_ID('UTF8')
,IIlll0 boolean default false
,p_convertblob_param varchar2 default null
,OIlll1    varchar2 default V('APP_USER')
,IIlllI number default 0
)
as
I100III BLOB;
l100III NUMBER;
O100IIl number default 0;
I100IIl number;
l100Il0 number default 1;
O100Il0 number default 1;
l100Ill varchar(10);
l_convertblob varchar(10);
 

 
begin
  if IIlll0 = true then 
    l_convertblob := 'true'; 
  elsif  IIlll0 = true then 
    l_convertblob := 'false'; 
  end if;
  
  if IIllIl = true then 
    l100Ill := 'true'; 
  elsif IIllIl = false then 
    l100Ill := 'false'; 
  end if;
  
  pak_xslt_log.WriteLog(
        'Start IIl1Il: '||IIl1Il||' OIllII lenght: '||dbms_lob.getlength(OIllII)||
        ' p_file_name: ' ||p_file_name||' p_mime '||p_mime||
        ' IIlll0: '||l_convertblob||' IIllIl: '||l100Ill
        --' OOXML length: '||dbms_lob.getlength(OIlI10),
 
        ,p_procedure => 'DownloadConvertOutput'
  );
 
 
  
  
  I100III := OIllII;
  I100IIl := nvl(p_blob_csid, NLS_CHARSET_ID('UTF8'));
 
  pak_xslt_log.WriteLog(
        'CLOB OIllII lenght: '||dbms_lob.getlength(OIllII)||
        ' converted to I100III length: '||dbms_lob.getlength(I100III),
 
        p_procedure => 'DownloadConvertOutput'
  );
 
  pak_xslt_log.WriteLog(
        'Start ConvertBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to I100III length: '||dbms_lob.getlength(I100III)||
        ' IIlll0: '||l_convertblob||' IIllIl: '||l100Ill,
 
        p_procedure => 'DownloadConvertOutput'
  );
 
  if IIlll0 = true and nvl(IIllIl, false) = false then
    ConvertBLOB(I100III, p_convertblob_param, I100IIl, OIlll1, IIlllI);
  else
      pak_xslt_log.WriteLog(
        'NOT starting ConvertBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to I100III length: '||dbms_lob.getlength(I100III)||
        ' IIlll0: '||l_convertblob||' IIllIl: '||l100Ill ,
        p_procedure => 'DownloadConvertOutput');
  end if;
 
  pak_xslt_log.WriteLog(
        'Finish ConverBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to I100III length: '||dbms_lob.getlength(I100III),
 
        p_procedure => 'DownloadConvertOutput'
  );
 
  
  if I100III is not null then
    
      
    
      DownloadBlob(IIl1Il, I100III, p_file_name, OIllI1 => p_mime);
    
  end if;
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadConvertOutput',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
procedure OIll10(
  IIll11            IN  varchar2,
  p_mime                 in  VARCHAR2 default 'application/octet'
)
as
I100Il1 number;
l100Il1 varchar2(10);
begin
  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
  into l100Il1
  FROM apex_release;
 
  select id into I100Il1
  from wwv_flow_files
  where (file_type = 'STATIC_FILE' or l100Il1 = '4.1') and filename = IIll11;
 
  apex_util.get_file(I100Il1, p_mime);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'OIll10',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
$if CCOMPILING.g_utl_file_privilege $then

Procedure XslTransform
(
p_xmlDir          IN  VARCHAR2,
p_xmlFname        IN  VARCHAR2,
p_xsltDir         IN  varchar2,
p_xsltFile        IN  varchar2,
p_outDir          IN  VARCHAR2,
p_outFname        IN  VARCHAR2,
P_NLS_CHARSET     IN  VARCHAR2 default null,
p_format          IN  number  default F_TEXT,
p_TemplateDir     IN  VARCHAR2 default null,
p_TemplateFile    IN  VARCHAR2 default null,
p_external_params IN    varchar2 default null
) as
IlII1l         CLOB;
 
 
begin

 
  IlII1l := pak_blob_util.READ2CLOB(p_xmlDir, p_xmlFname); 
  XslTransform
  (
    p_Xml               => IlII1l,
    p_xsltDir           => p_xsltDir,
    p_xsltFile          => p_xsltFile,
    p_out_dir           => p_outDir,
    p_out_fileName      => p_outFname,
    p_format            => p_format, 
    p_TemplateDir       => p_TemplateDir, 
    p_TemplateFile      => p_TemplateFile, 
    P_NLS_CHARSET       => P_NLS_CHARSET,
    p_external_params   => p_external_params
  );
  dbms_lob.freetemporary(IlII1l);
exception
  when others then
  dbms_lob.freetemporary(IlII1l);
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - XML as file',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransform;
$end
 

Procedure XslTransformAndDownload
(
p_Xml                   IN OUT CLOB,
p_xsltStaticFile        IN  varchar2,
IIl1I0               IN number,
OIl11I           IN varchar2,
p_filename              in  VARCHAR2,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null,
ll0000              IN  number   default null,
Ol0000      IN  number   default null,
OIlll1               IN  varchar2 default V('APP_USER'),
IIlllI      IN  number default 0
) as
IlII1l       CLOB;
O100IlI  BLOB;
I100IlI      BLOB;
l100Ill     boolean default false;

O100Ill number;

OlII11 PLS_INTEGER;
l_fileext varchar2(10);
 
begin
 
  l_fileext := lower(substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1) ));
 
  if ll0000 is not null then
    pak_xslt_log.SetLevel(ll0000);
  end if;
 
  if Ol0000 is not null then
    wwv_flow_api.set_security_group_id(Ol0000);
  end if;
 
  OlII11 := dbms_utility.get_time();
  
  query2report.OIll1I(p_Xml);
  
  pak_xslt_log.WriteLog(
    'Query2Report.ConvertXml finished'
    ,p_procedure => 'XslTransformAndDownload'
    , p_start_time => OlII11
  );
 
  OlII11 := dbms_utility.get_time();
 
  pak_xslt_log.WriteLog( p_description => 'XslTransformAndDownload started length(p_xml) '||dbms_lob.getlength(p_xml)||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' IIl1I0: '||IIl1I0||
                                ' OIl11I: '||OIl11I||
                                ' p_filename: '||p_filename||
                                ' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                ' p_convertblob_param: '||p_convertblob_param||
                                ' ll0000: '||ll0000||
                                ' Ol0000: '||Ol0000||
                                ' OIlll1: '||OIlll1||
                                ' IIlllI: '||IIlllI,
                                p_procedure => 'XslTransformAndDownload'
                              );
 
  if p_second_XsltStaticFile is not null then
    O100IlI := O100I11(
      p_Xml => p_Xml,
      p_xsltStaticFile => p_XsltStaticFile,
      IIl1I0 => IIl1I0,
      OIl11I => OIl11I,
      po_file_csid => O100Ill,
      p_format => F_XML,
      p_fileext => 'xml',
      po_error => l100Ill,
      p_templateStaticFile => null, 
      p_external_params => p_external_params
    );
 
 
      if not nvl(l100Ill, false) then
      O100IlI := O100I11( 
        p_Xml => pak_blob_util.blob2clob(O100IlI),
        p_xsltStaticFile => p_second_XsltStaticFile,
        IIl1I0 => IIl1I0,
        OIl11I => OIl11I,
        po_file_csid => O100Ill,
        p_format => p_format,
        p_fileext => l_fileext,
        po_error => l100Ill,
        p_templateStaticFile => p_templateStaticFile, 
        p_external_params => p_second_external_params
      );
    end if;
  else
    O100IlI := O100I11(
      p_Xml => p_Xml,
      p_xsltStaticFile => p_XsltStaticFile,
      IIl1I0 => IIl1I0,
      OIl11I => OIl11I,
      po_file_csid => O100Ill,
      p_format => p_format,
      p_fileext => l_fileext,
      po_error => l100Ill,
      p_templateStaticFile => p_templateStaticFile, 
      p_external_params => p_external_params
    );
  end if;
  DownloadConvertOutput(V('APP_ID'), O100IlI, p_filename,
              IIllIl => l100Ill,
              p_blob_csid => O100Ill,
              p_mime => p_mime,
              IIlll0 => true,
              p_convertblob_param => p_convertblob_param,
              OIlll1 => OIlll1,
              IIlllI => IIlllI
              );
 
  pak_xslt_log.WriteLog( 'XslTransformAndDownload finished ',
                                p_procedure => 'XslTransformAndDownload',
                                p_start_time => OlII11
                              );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownload',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownload;
 

Procedure XslTransformAndDownloadXMLID
(
Il0001      IN  NUMBER,
p_xsltStaticFile        IN  varchar2,
IIl1I0               IN NUMBER,
OIl11I           IN VARCHAR2,
p_filename              in  VARCHAR2,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null,
ll0000              IN  number   default null,
Ol0000      IN  number   default null,
OIlll1               IN  varchar2 default V('APP_USER'),
IIlllI      IN  number default 0
) as
I100l00 CLOB;
OlII11 PLS_INTEGER;
begin
  pak_xslt_log.Setlevel(ll0000);
 
  OlII11 := dbms_utility.get_time();
 
  pak_xslt_log.WriteLog( p_description => 'Background XslTransformAndDownloadXMLID started Il0001 '||Il0001||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' IIl1I0: '||IIl1I0||
                                ' OIl11I: '||OIl11I||
                                ' p_filename: '||p_filename||
                                ' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                ' p_convertblob_param: '||p_convertblob_param||
                                ' ll0000: '||ll0000||
                                ' Ol0000: '||Ol0000||
                                ' OIlll1: '||OIlll1||
                                ' IIlllI: '||IIlllI,
                                p_procedure => 'XslTransformAndDownloadXMLID'
                              );
 
  select xmlclob into I100l00
  from temporary_xml
  where id_temporary_xml = Il0001;
 
  XslTransformAndDownload
  (
    I100l00,
    p_xsltStaticFile,
    IIl1I0,
    OIl11I,
    p_filename  ,
    p_mime,
    p_format,
    p_templateStaticFile,
    p_external_params,
    p_second_XsltStaticFile ,
    p_second_external_params,
    p_convertblob_param     ,
    ll0000             ,
    Ol0000     ,
    OIlll1              ,
    IIlllI
  );
 
  delete from temporary_xml
  where id_temporary_xml = Il0001;
  commit;
 
  pak_xslt_log.WriteLog( 'Background XslTransformAndDownloadXMLID finished ',
                                p_procedure => 'XslTransformAndDownloadXMLID',
                                p_start_time => OlII11
                              );
exception when others then
  rollback;
  delete from temporary_xml
  where id_temporary_xml = Il0001;
  commit;
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownloadXMLID',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownloadXMLID;
 
 

 
Procedure ll0001
(
Il0001    IN  number,
p_xsltStaticFile        IN  varchar2,
IIl1I0               IN number,
OIl11I           IN varchar2,
p_filename              in  VARCHAR2,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null,
ll0000              IN  number   default null
) as
begin
  pak_xslt_log.WriteLog( 'll0001 started Il0001 '||Il0001||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' IIl1I0: '||IIl1I0||
                                ' OIl11I: '||OIl11I||
                                ' p_filename: '||p_filename||
                                ' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                ' p_convertblob_param: '||p_convertblob_param||
                                ' ll0000: '||ll0000,
 
                                p_procedure => 'll0001'
                              );
 
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 1,
                                        argument_value    => Il0001);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 2,
                                        argument_value    => p_xsltStaticFile);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 3,
                                        argument_value    => IIl1I0);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 4,
                                        argument_value    => OIl11I);
 
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 5,
                                        argument_value    => p_filename);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 6,
                                        argument_value    => p_mime);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 7,
                                        argument_value    => p_format);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 8,
                                        argument_value    => p_templateStaticFile);
 
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 9,
                                        argument_value    => p_external_params);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 10,
                                        argument_value    => p_second_XsltStaticFile);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 11,
                                        argument_value    => p_second_external_params);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 12,
                                        argument_value    => p_convertblob_param);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 13,
                                        argument_value    => ll0000);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 14,
                                        argument_value    => apex_custom_auth.get_security_group_id);
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 15,
                                        argument_value    => V('APP_USER'));
 
  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 16,
                                        argument_value    => 1);
 
  dbms_scheduler.run_job(job_name => 'job_XslTransformAndDownload', use_current_session => false);
 
  pak_xslt_log.WriteLog( 'Query2Report.ll0001 finished ',
                                p_procedure => 'll0001'
                              );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'll0001',
    p_sqlerrm => sqlerrm
  );
  raise;
end ll0001;
 
 

function l100l00
(
p_Xml                   IN  CLOB,
p_Xslt                  IN  CLOB,
p_format                IN  number default null,
po_error                OUT boolean,
p_Template              IN    CLOB default null,
p_external_params       IN  varchar2 default null,
p_second_Xslt           IN  CLOB default null,
p_second_external_params IN  varchar2 default null
)
return BLOB
as
O100IlI  BLOB;
 
begin
 
  if p_second_Xslt is not null then
 
    O100IlI := XslTransform(
      p_Xml => p_Xml,
      p_Xslt => p_Xslt,
      p_format => F_XML,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params
    );
 
    if not po_error then
      O100IlI := XslTransform( 
        p_Xml => pak_blob_util.blob2clob(O100IlI),
        p_Xslt => p_second_Xslt,
        p_format => p_format,
        po_error => po_error,
        p_template => p_template,
        p_external_params => p_second_external_params
      );
    end if;
  else
    O100IlI := XslTransform(
      p_Xml => p_Xml,
      p_Xslt => p_Xslt,
      p_format => p_format,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params
    );
  end if;
  return O100IlI;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l100l00 (both XSLT)',
    p_sqlerrm => sqlerrm
  );
  raise;
end l100l00;
 
 

Procedure XslTransformAndDownload
(
p_Xml                   IN  CLOB,
p_Xslt                  IN  BLOB,
p_filename              in  VARCHAR2,
p_XSLT_CS               in  varchar2 default null,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_template              IN  BLOB  default null,
p_template_CS           IN  varchar2 default null,
p_external_params       IN  varchar2 default null,
p_second_Xslt           IN  BLOB default null,
Ol000I        in  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null
) as
O100IlI BLOB;

 



 
l100I10 CLOB;
O100l01 CLOB;
I100I11 CLOB;
l100Ill boolean;
 
begin
  l100I10:=pak_blob_util.BLOB2CLOB(p_Xslt, NLS_CHARSET_ID(p_XSLT_CS));
  if p_second_Xslt is not null then
    O100l01:=pak_blob_util.BLOB2CLOB(p_second_Xslt, NLS_CHARSET_ID(Ol000I));
  end if;
 
  if p_template is not null then
    I100I11 := pak_blob_util.BLOB2CLOB(p_template, NLS_CHARSET_ID(p_template_CS));
  end if;
 
  O100IlI := l100l00
  (
    p_Xml => p_Xml,
    p_Xslt => l100I10,
    p_format => p_format,
    po_error => l100Ill,
    p_template => I100I11,
    p_external_params => p_external_params,
    p_second_Xslt => O100l01,
    p_second_external_params => p_second_external_params
  );
 
  DownloadConvertOutput(V('APP_ID'), O100IlI, p_filename,
    IIllIl => l100Ill,
    p_blob_csid => nvl(NLS_CHARSET_ID(Ol000I), NLS_CHARSET_ID(p_XSLT_CS)),
    p_mime => p_mime,
    IIlll0 => true,
    p_convertblob_param => p_convertblob_param
  );
  
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownload',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownload;
 

 procedure I100l01(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
l100I10 CLOB;
l100l0I number default 1;
O100l0I boolean;
l10000I constant number := 4000;
 
begin
  dbms_lob.createtemporary(l100I10, false);
  DBMS_LOB.WRITEAPPEND(l100I10, length(OllI1I), OllI1I);
  O100l0I := dbms_lob.instr(pio_rtf, '<') > 0 or dbms_lob.instr(pio_rtf, '>') > 0
            or dbms_lob.instr(pio_rtf, '"') > 0 or dbms_lob.instr(pio_rtf, '&') > 0;
 
  while l100l0I <= dbms_lob.getlength(pio_rtf)
  loop 
    if O100l0I then
      dbms_lob.writeappend(l100I10, length(lllI1l), lllI1l);
    else
      dbms_lob.writeappend(l100I10, length(OllII1), OllII1);
    end if;
 
    dbms_lob.copy(l100I10, pio_rtf, l10000I, dbms_lob.getlength(l100I10)+1, l100l0I);
 
    l100l0I := l100l0I + l10000I;
 
    
 
    if O100l0I then
      dbms_lob.writeappend(l100I10, length(OllI1l), OllI1l);
    else
      dbms_lob.writeappend(l100I10, length(IllII1), IllII1);
    end if;
  end loop;
  DBMS_LOB.WRITEAPPEND(l100I10, length(IllI1I), IllI1I);
  pio_rtf := l100I10; 
 
  
  
  dbms_lob.freetemporary(l100I10);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I100l01 CLOB',
    p_sqlerrm => sqlerrm
  );
  raise;
end I100l01;
 

 procedure I100l0l(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
begin
  
  I100l01(pio_rtf);
end;
 
 

 procedure l100l0l(
  pio_mht     IN OUT NOCOPY CLOB
)
as
begin
  I100l01(pio_mht);
end;
 
 

 

procedure O100l10(
  pio_clob IN OUT NOCOPY CLOB,
  I100l10 number,
  l100l11 number,
  O100l11 varchar2)
as
Ol0l11 clob;
begin
  dbms_lob.createtemporary(Ol0l11, false);
  dbms_lob.copy(Ol0l11, pio_clob, I100l10 - 1);
  dbms_lob.writeappend(Ol0l11, length(O100l11), O100l11);
  dbms_lob.copy(
    Ol0l11,
    pio_clob,
    dbms_lob.getlength(pio_clob) - l100l11 + 1,
    dbms_lob.getlength(Ol0l11)+1,
    l100l11
  );
  pio_clob := Ol0l11;
  dbms_lob.freetemporary(Ol0l11);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O100l10',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure I100l1I(
  pio_xml IN OUT NOCOPY CLOB
)
as
l100l1I varchar2(32000);
I1000I1 number default 1;
O100l1l number;
I100l1l number;
l100lI0 number;
O100lI0 varchar2(4000);
I100lI1 varchar2(4000);
Oll0Il varchar2(32000);
l100lI1 number;
O100lII number;
 
I100lII number;

l100lIl number;
O100lIl number;
I100ll0 number;
l100ll0 number;
O100ll1 number;
I100ll1 varchar2(20);
 
begin
  loop
    I1000I1:= dbms_lob.instr(pio_xml, '<', I1000I1);
    exit when dbms_lob.substr(pio_xml, 1, I1000I1+1) <> '?';
    I1000I1 := dbms_lob.instr(pio_xml, '?>', I1000I1) + length('?>');
    if I1000I1 = 0 then
      pak_xslt_log.WriteLog(
        'Can''Il0lI0 find closing tag ?> of XML processing instruction',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'I100l1I'
      );
      return;
    end if;
  end loop;
  O100l1l:= dbms_lob.instr(pio_xml, '>', I1000I1);
  l100l1I := dbms_lob.substr(pio_xml, O100l1l - I1000I1 + 1, I1000I1 + 1);
  I1000I1 := O100l1l;
  loop
    I1000I1 := dbms_lob.instr(pio_xml, '<', I1000I1);
    exit when nvl(I1000I1, 0) = 0;
    I100lII := dbms_lob.instr(pio_xml, ' ', I1000I1);
    O100l1l := dbms_lob.instr(pio_xml, '>', I1000I1);
    l100lIl := dbms_lob.instr(pio_xml, '/>', I1000I1);
 
    if I100lII = 0 then I100lII := dbms_lob.LOBMAXSIZE; end if;
    if O100l1l = 0 then O100l1l := dbms_lob.LOBMAXSIZE; end if;
    if l100lIl = 0 then l100lIl := dbms_lob.LOBMAXSIZE; end if;
 
    l100lI0 := least(I100lII, O100l1l, l100lIl);
 
    exit when O100l1l = dbms_lob.LOBMAXSIZE or l100lI0 = dbms_lob.LOBMAXSIZE;
    O100lI0 := dbms_lob.substr(pio_xml, l100lI0 - I1000I1 -1, I1000I1 + 1);
 
    if substr(O100lI0, 1, 1)<>'/' then 
      if l100lIl + 1 = O100l1l then
        I100l1l := l100lIl + length('/>');
      else
        I100l1l := dbms_lob.instr(pio_xml, '</'||O100lI0||'>', I1000I1);
        exit when I100l1l = 0;
        I100l1l := I100l1l + length('</'||O100lI0||'>');
      end if;
 
      if instr(dbms_lob.substr(pio_xml, O100l1l - I1000I1 + 1, I1000I1),'xmlns="') > 0 then 
        Oll0Il := dbms_lob.substr(pio_xml, I100l1l - I1000I1 + 1, I1000I1);
        l100lI1 := instr(Oll0Il, 'xmlns=') + length('xmlns=');
        O100lII := instr(Oll0Il, '"', l100lI1 , 2);
        exit when O100lII = 0;
        I100lI1 := substr(Oll0Il, l100lI1, O100lII - l100lI1 + 1);
        O100lIl := instr(l100l1I, I100lI1);
        if O100lIl > 0 then 
          I100ll0 := instr(l100l1I, 'xmlns:', O100lIl - length(l100l1I), 1);
          exit when I100ll0 = 0;
          l100ll0 := I100ll0 + length('xmlns:');
          O100ll1 := instr(l100l1I, '=', l100ll0);
          I100ll1 := substr(l100l1I, l100ll0, O100ll1 - l100ll0);
          Oll0Il := replace(Oll0Il, ' xmlns='||I100lI1);
          Oll0Il := replace(Oll0Il, '<', '<'||I100ll1||':');
          Oll0Il := replace(Oll0Il, '<'||I100ll1||':/', '</'||I100ll1||':');
          
          O100l10(pio_xml, I1000I1, I100l1l, Oll0Il);
          I1000I1 := I1000I1 + length(Oll0Il) + 1;
        else
          I1000I1 := I100l1l +1;
        end if;  
 
      else
        I1000I1 := O100l1l +1;
      end if;
    else 
      I1000I1 := O100l1l +1; 
    end if;
  end loop;
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I100l1I',
    p_sqlerrm => sqlerrm
  );
  raise;
 
end;
 
function l100llI(
  p_xml IN CLOB
  ,O100llI varchar2
)
return varchar2
as
Il01I1 varchar2(4000);
lll0II number;
Oll0I1 number;
I100lll number;
begin
  lll0II := dbms_lob.instr(p_xml, '<'||O100llI);
  Oll0I1 :=  dbms_lob.instr(p_xml, '>', lll0II);
 
  if nvl(lll0II, 0) = 0 or nvl(Oll0I1, 0) = 0
  then
    return null;
  end if;
  I100lll := Oll0I1 - lll0II + 1;
  dbms_lob.read(p_xml, I100lll, lll0II, Il01I1);
  return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l100llI',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
FUNCTION l100lll (llI0Il VARCHAR2, O101000 out boolean) RETURN tab_string
  IS
 
  ll01I1       number :=0;
  IlI0l0     number :=0;
  llI0l1  varchar2(32000) := replace(llI0Il,'>');
 
  OlI0l1 tab_string := tab_string();
 
  BEGIN
      
      O101000 := false;
      IlI0l0 := instr(llI0l1,' ',1,1);
      
      WHILE ( IlI0l0 != 0) LOOP
         ll01I1 := ll01I1 + 1;
         
         IF llI0l1 like 'xmlns:%' and llI0l1 not like 'xmlns:xsl=%' THEN
           OlI0l1.extend;
           OlI0l1(OlI0l1.count) := trim(substr(llI0l1,1,IlI0l0));
         ELSIF llI0l1 like 'xmlns=%' THEN
            O101000 := true;
         END IF;
         
         llI0l1 := substr(llI0l1,IlI0l0+1,length(llI0l1));
         
         IlI0l0 := instr(llI0l1,' ',1,1);
         
         IF IlI0l0 = 0 and llI0l1 like 'xmlns:%' and llI0l1 not like 'xmlns:xsl=%' THEN
            OlI0l1.extend;
            OlI0l1(OlI0l1.count) := trim(llI0l1);
         END IF;
      END LOOP;
      
      RETURN OlI0l1;
  exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l100lll',
    p_sqlerrm => sqlerrm
  );
  raise;
END l100lll;
 
procedure I101000(pio_xml IN OUT NOCOPY CLOB)
as
l101001 number;
O101001   number;
OlIlI1 number := 1;
I10100I number;
IlIlI1 number;
llIlII number;
l10100I number;
O10100l number;
O100lI0 varchar2(400);
I10100l varchar2(400);
Oll0Il varchar2(32000);
begin
  loop
    l101001 := dbms_lob.instr(pio_xml,'="{', OlIlI1);
    exit when nvl(l101001, 0) = 0;
    O101001 := dbms_lob.instr(pio_xml,'}"', l101001);
    exit when nvl(O101001, 0) = 0;
    I10100I :=  dbms_lob.instr(pio_xml,'<', OlIlI1);
    exit when nvl(I10100I, 0) = 0;
    IlIlI1 := I10100I;
    while I10100I < l101001 loop
      IlIlI1 := I10100I;
      I10100I :=  dbms_lob.instr(pio_xml,'<', I10100I + 1);
      if nvl(I10100I, 0)=0 then
        return;
      end if;
    end loop;
    
    l10100I := dbms_lob.instr(pio_xml,'>', IlIlI1);
    exit when nvl(l10100I, 0) = 0;
    O10100l := dbms_lob.instr(pio_xml,' ', IlIlI1);
    if O10100l > 0 and O10100l < l10100I then
      l10100I := O10100l;
    end if;
    O100lI0 := dbms_lob.substr(pio_xml, l10100I - IlIlI1 - 1, IlIlI1 + 1);
    I10100l :='</'||O100lI0||'>';
    llIlII := dbms_lob.instr(pio_xml, I10100l, IlIlI1);
    if llIlII > 0 then
      llIlII := llIlII + length(I10100l);
    else
      llIlII := dbms_lob.instr(pio_xml, '/>', IlIlI1);
      exit when nvl(llIlII, 0) = 0;
      llIlII := llIlII + length('/>');
    end if;
    pak_blob_util.clobReplace(
      pio_xml,
      IlIlI1,
      llIlII - 1,
      lllI1l||
      dbms_lob.substr(pio_xml, llIlII - IlIlI1, IlIlI1)||
      OllI1l
    );
    OlIlI1 := llIlII + length(lllI1l) + length(OllI1l);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I101000',
    p_sqlerrm => sqlerrm
  );
end;
 
 
procedure l101010(O101010 IN OUT NOCOPY CLOB)
as
Ol0l11 CLOB;
I101011  constant number := 210*66;
I100lll      number;
OlIlI1      number := 1;
I100001      varchar2(32000);
l101011   number;
O10101I    number;
begin
  dbms_lob.CreateTemporary(Ol0l11, false);
  dbms_lob.WriteAppend(Ol0l11, length(IllII0), IllII0);
  I100lll := I101011;
  loop
    exit when OlIlI1 > dbms_lob.getlength(O101010) or I100lll = 0;
    dbms_lob.read(O101010, I100lll, OlIlI1, I100001);
    l101011 := length(I100001);
    I100001 := replace(I100001, chr(13)||chr(10), lllII0||chr(13)||chr(10)||IllII0);
    if length(I100001) = l101011 then
      I100001 := replace(I100001, chr(10), lllII0||chr(10)||IllII0);
    end if;
    dbms_lob.WriteAppend(Ol0l11, length(I100001), I100001);
    OlIlI1 := OlIlI1 + I100lll;
  end loop;
  
  
  dbms_lob.WriteAppend(Ol0l11, length(lllII0), lllII0);
  O101010 := Ol0l11;
  dbms_lob.freeTemporary(Ol0l11);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l101010',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
 
procedure I10101I(pio_xml IN OUT NOCOPY CLOB)
as
l10101l varchar2(40);
O10101l varchar2(40);
OlIlI1 number := 1;
I101011 constant number := 210*66;
I100001 varchar2(32000);
I1010I0 number;
l1010I0 number;
O1010I1 CLOB;
begin
  if dbms_lob.instr(pio_xml,'<pkg:package ') > 0 then
    l10101l := '<pkg:binaryData';
  else
    l10101l := '<w:binData';
  end if;
  O10101l := '</'||substr(l10101l,2)||'>';
  loop
    
    I1010I0 := dbms_lob.instr(pio_xml, l10101l, OlIlI1);
    exit when nvl(I1010I0, 0) = 0;
    I1010I0 := dbms_lob.instr(pio_xml, '>', I1010I0 + length(l10101l));
    exit when nvl(I1010I0, 0) = 0;
    I1010I0 := I1010I0 + 1;
    
    l1010I0 := dbms_lob.instr(pio_xml, O10101l, I1010I0);
    exit when nvl(l1010I0, 0) = 0;
    if l1010I0 - I1010I0 > I101011 then
      dbms_lob.CreateTemporary(O1010I1, false);
      dbms_lob.Copy(O1010I1, pio_xml, l1010I0-I1010I0, 1, I1010I0);
      l101010(O1010I1);
      pak_blob_util.clobReplace(pio_xml, I1010I0, l1010I0 - 1, O1010I1);
      OlIlI1 := I1010I0 + dbms_lob.getlength(O1010I1) + length(O10101l);
      dbms_lob.freeTemporary(O1010I1);
    else
      OlIlI1 := l1010I0 + length(O10101l);
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I10101I',
    p_sqlerrm => sqlerrm
  );
  RAISE;
end;
 

procedure I1010I1(
  pio_xml IN OUT NOCOPY CLOB,
  l1010II varchar2,
  O1010II varchar2 default 'xsl:stylesheet'
)
as
I1010Il varchar2(4000);
l1010Il varchar2(4000);
O1010l0 varchar2(4000);
I1010l0 varchar2(4000);
I100lI1 tab_string;
l1010l1 boolean;
 
begin
  O1010l0 := l100llI(pio_xml, l1010II);--'w:wordDocument'
  I1010Il := l100llI(pio_xml, O1010II);
  if O1010l0 is null or I1010Il is null then
    return;
  end if;
  I100lI1 := l100lll(O1010l0, l1010l1);
  I1010l0 := O1010l0;
  l1010Il := I1010Il;
  for ll01I1 in 1..I100lI1.count loop
    pak_xslt_log.WriteLog('I100lI1(ll01I1): '||I100lI1(ll01I1)||'#', p_procedure => 'I1010I1');
    I1010l0 := replace(I1010l0, ' '||I100lI1(ll01I1));
    l1010Il := replace(l1010Il,'>',' '||I100lI1(ll01I1)||'>');
  end loop;
  pak_xslt_log.WriteLog(
    'O1010l0: '||O1010l0||' I1010l0: '||I1010l0,
    p_procedure => 'I1010I1'
  );
 
  pak_xslt_log.WriteLog(
    'I1010Il: '||I1010Il||' l1010Il: '||l1010Il,
    p_procedure => 'I1010I1'
  );
  if l1010l1 then 
    I1010l0 := lllI1l||I1010l0||OllI1l;
    pak_blob_util.clobReplaceAll(pio_xml, '</'||l1010II||'>', lllI1l||'</'||l1010II||'>'||OllI1l);
  end if;
  pak_blob_util.clobReplaceAll(pio_xml, O1010l0, I1010l0);
  pak_blob_util.clobReplaceAll(pio_xml, I1010Il, l1010Il);
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I1010I1',
    p_sqlerrm => sqlerrm
  );
  raise;
end I1010I1;
 

procedure O1010l1(
  pio_xml IN OUT NOCOPY CLOB
)
as
I1000I1 number;
I1010lI number;
l1010lI varchar2(4000);
O1010ll varchar2(4000);
I1010ll varchar2(4000);
l101100 number;
O101100 varchar2(4000):=
  '<?xml version="1.0"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="xml" ';
ll01I1 number default 0;
Ol0l11 CLOB;
 
begin
  
  
  I100l1I(pio_xml);
  
  I1000I1 := dbms_lob.instr(pio_xml, '<?');
  if I1000I1 > 0 then
    I1000I1 := I1000I1 + length('<?');
    I1010lI := dbms_lob.instr(pio_xml, '?>', I1000I1)-1;
    l1010lI := dbms_lob.substr(pio_xml,  I1010lI - I1000I1 + 1, I1000I1);
    if substr(l1010lI, 1, 4) = 'xml ' then
      O101100 := O101100||substr(l1010lI, 4)||'/>'||g_crlf||
      '<xsl:template match="/">'|| g_crlf|| g_crlf;
      I1000I1 := I1010lI + length('?>') + 1;
    else
      O101100 := O101100||'version="1.0"/>'||g_crlf||
      '<xsl:template match="/">'|| g_crlf|| g_crlf;
      I1000I1 :=1;
    end if;
 
    loop
      I1000I1 := dbms_lob.instr(pio_xml, '<?', I1000I1);
      exit when I1000I1 = 0;
      ll01I1 := ll01I1 + 1;
      I1000I1 := I1000I1 + length('<?');
      I1010lI := dbms_lob.instr(pio_xml, '?>', I1000I1)-1;
      l1010lI := dbms_lob.substr(pio_xml,  I1010lI - I1000I1 + 1, I1000I1);
      l101100 := instr(l1010lI, ' ');
      if l101100 > 0 then
        O101100 := O101100||g_crlf||
        '<xsl:processing-instruction name="'||substr(l1010lI, 1, l101100 -1)||'">'||substr(l1010lI, l101100 + 1)||'</xsl:processing-instruction>'||g_crlf;
      else
        O101100 := O101100||g_crlf||
        '<xsl:processing-instruction name="'||l1010lI||'"/>'||g_crlf;
      end if;
    end loop;
    dbms_lob.createtemporary(Ol0l11, false);
    DBMS_LOB.WRITEAPPEND(Ol0l11, length(O101100), O101100);
    
    DBMS_LOB.COPY (
      Ol0l11,
      pio_xml,
      dbms_lob.getlength(pio_xml) - I1010lI - 2,
      dbms_lob.getlength(Ol0l11)+1,
      I1010lI + 3
    );
    DBMS_LOB.WRITEAPPEND(Ol0l11, length(IllI1I), IllI1I);
    
    I1010I1(Ol0l11, 'w:wordDocument');
    I1010I1(Ol0l11, 'Workbook');
    
    I101000(Ol0l11);
    
    I10101I(Ol0l11);
    pio_xml := Ol0l11;
    dbms_lob.freetemporary(Ol0l11);
  else
    pak_xslt_log.WriteLog(
    'Input document is not XML',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XMLWrap CLOB'
  );
  end if;
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O1010l1 CLOB',
    p_sqlerrm => sqlerrm
  );
  raise;
end O1010l1;
 

 

procedure I101101(
  l101101 IN OUT NOCOPY CLOB
)
as
l100I10 CLOB;
O10110I number default 0;
I10110I number default 0;
l10110l number default 0;
O10110l number;
I101110 varchar2(1);
l101110 number default 0;
I100lII number default 0;
O101111 number default 0;
I101111 number default 1;
l10111I varchar2(32767);
 
begin
  dbms_lob.createtemporary(l100I10, false);
 
  DBMS_LOB.WRITEAPPEND(l100I10, length(lllI11), lllI11);
 
  loop
    O10110I := dbms_lob.instr(l101101, '=', O10110I + 1);
    exit when nvl(O10110I, 0) = 0;
    O10110l := O10110I + 1;
    I101110 := dbms_lob.substr(l101101, 1, O10110l);
    if I101110 in ('''', '"') then
      l101110 := dbms_lob.instr(l101101, I101110, O10110l + 1);
      O10110I := l101110; 
    else  
      I10110I := dbms_lob.instr(l101101, '=', O10110l);
      l10110l := dbms_lob.instr(l101101, '>', O10110l);
 
      if I10110I < l10110l and I10110I > 0 then
        
        l101110 := O10110l;
        while I100lII <  I10110I and l101110 > 0
        loop
          I100lII := dbms_lob.instr(l101101, ' ', l101110 +1);
          O101111 := dbms_lob.instr(l101101, Query2Report.g_crlf, l101110 +1);
          if nvl(I100lII,0) = 0 and nvl(O101111, 0) = 0 then
            I100lII := 0;
          elsif nvl(I100lII,0) = 0 then
            I100lII := O101111;
          elsif nvl(O101111, 0) = 0 then
            null; 
          else
            I100lII := least(I100lII, O101111);
          end if;
          exit when I100lII > I10110I or nvl(I100lII,0) = 0;
          l101110 := I100lII;
        end loop;
        if nvl(l101110,0) > 0 then
          l101110 := l101110 - 1;
          while dbms_lob.substr(l101101, 1, l101110) in (' ',chr(13), chr(10))
          loop
            exit when l101110 <= O10110l;
            l101110 := l101110 - 1;
          end loop;
        end if;
      end if;
 
      if (l10110l < I10110I or I10110I = 0) and l10110l > 0 then
        
        l101110 := l10110l - 1;
        while dbms_lob.substr(l101101, 1, l101110) in (' ','/','>',chr(13), chr(10))
        loop
          exit when l101110 <= O10110l;
          l101110 := l101110 - 1;
        end loop;
 
        
      end if;
    end if; 
    pak_xslt_log.WriteLog('Attribute: '||to_char(O10110l)||' - '||to_char(l101110)||' : '||
      dbms_lob.substr(l101101, l101110 - O10110l + 1, O10110l), p_procedure => 'I101101' );
      
      
      DBMS_LOB.COPY(l100I10, l101101, O10110l - I101111, dbms_lob.getlength(l100I10)+1, I101111);
      I101110 := dbms_lob.substr(l101101, 1, O10110l);
      if I101110 not in ('''','"') then 
        DBMS_LOB.WRITEAPPEND(l100I10, 1, '"');
      else 
        l101110 := dbms_lob.instr(l101101, I101110, O10110l + 1);
      end if;
      
      
      DBMS_LOB.COPY(l100I10, l101101, l101110 - O10110l + 1, dbms_lob.getlength(l100I10)+1, O10110l);
      if dbms_lob.substr(l101101, 1, l101110) not in ('''','"') then 
        DBMS_LOB.WRITEAPPEND(l100I10, 1, '"');
      end if;
      I101111 := l101110 + 1;
  end loop;
  l10111I := dbms_lob.substr(l101101, offset => I101111);
  DBMS_LOB.WRITEAPPEND(l100I10, length(l10111I), l10111I);
 
  DBMS_LOB.WRITEAPPEND(l100I10, length(IllI1I), IllI1I);
  l101101 := l100I10;
 
  dbms_lob.freetemporary(l100I10);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I101101',
    p_sqlerrm => sqlerrm
  );
  raise;
end I101101;
 
 

procedure O10111I(
  pio_clob IN OUT NOCOPY CLOB,
  I10111l in out number,
  l10111l varchar2,
  O1011I0 varchar2,
  I1011I0 varchar2
)
as
begin
  if I10111l > 0 then
    I10010I(pio_clob, O1011I0, I10111l);
    I10111l := I10111l + length(O1011I0) + length(l10111l);
    I10010I(pio_clob, I1011I0, I10111l);
    I10111l := I10111l + length(I1011I0);
  end if;
end;
 

procedure O10111I(
  pio_clob IN OUT NOCOPY CLOB,
  l10111l varchar2,
  O1011I0 varchar2,
  I1011I0 varchar2
)
as
 I1000I1 number default 1;
begin
  loop
    I1000I1 := dbms_lob.instr(pio_clob, l10111l, I1000I1);
    exit when I1000I1 = 0;
    O10111I(pio_clob, I1000I1, l10111l, O1011I0, I1011I0);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O10111I',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure l1011I1(
  pio_clob IN OUT NOCOPY CLOB,
  l10111l varchar2
)
as
begin
  O10111I(pio_clob, l10111l, lllI1l, OllI1l);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l1011I1 (all)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure l1011I1(
  pio_clob IN OUT NOCOPY CLOB,
  I10111l in out number,
  l10111l varchar2
)
as
begin
  O10111I(pio_clob, I10111l, l10111l, lllI1l, OllI1l);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l1011I1 (one)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure O1011I1(
  pio_clob IN OUT NOCOPY CLOB
)
as
  I1000I1 number default 1;
begin
  loop
    I1000I1 := dbms_lob.instr(pio_clob, '<!--', I1000I1);
    exit when I1000I1 = 0;
    I10010I(pio_clob, lllI1l, I1000I1);
    I1000I1 := I1000I1 + length(lllI1l);
    I1000I1 := dbms_lob.instr(pio_clob, '-->', I1000I1);
    if I1000I1 = 0 then
      pak_xslt_log.WriteLog(
        'There is no closing tag --> for comment',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'O1011I1'
      );
      exit;
    end if;
    I1000I1 := I1000I1 + length('-->');
    I10010I(pio_clob, OllI1l, I1000I1);
    I1000I1 := I1000I1 + length(OllI1l);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'O1011I1',
    p_sqlerrm => sqlerrm
  );
  raise;
end O1011I1;
 
 

procedure I1011II(
  pio_clob IN OUT NOCOPY CLOB
)
as
  I1000I1 number default 1;
  I100l1l number;
  O100lI0 varchar2(200);
 
  l1011II number;
  I100lII number;
  O101111 number;
  O1011Il number;
  l100lIl number;
begin
  I1000I1 := length(lllI11) + 1;
  loop
    I1000I1 := dbms_lob.instr(pio_clob, '<', I1000I1);
    exit when I1000I1 = 0;
    I100lII := dbms_lob.instr(pio_clob, ' ', I1000I1);
    O101111 := dbms_lob.instr(pio_clob, Query2Report.g_crlf, I1000I1);
 
    if nvl(I100lII,0) = 0 and nvl(O101111, 0) = 0 then
      I100lII := 0;
    elsif nvl(I100lII,0) = 0 then
      I100lII := O101111;
    elsif nvl(O101111, 0) = 0 then
      null; 
    else
      I100lII := least(I100lII, O101111);
    end if;
 
    O1011Il := dbms_lob.instr(pio_clob, '>', I1000I1);
    l100lIl := dbms_lob.instr(pio_clob, '/>', I1000I1);
 
    if I100lII = 0 then I100lII := dbms_lob.LOBMAXSIZE; end if;
    if O1011Il = 0 then O1011Il := dbms_lob.LOBMAXSIZE; end if;
    if l100lIl = 0 then l100lIl := dbms_lob.LOBMAXSIZE; end if;
 
    I100l1l := least(I100lII, O1011Il, l100lIl);
 
    exit when I100l1l = dbms_lob.LOBMAXSIZE;
    O100lI0 := dbms_lob.substr(pio_clob, I100l1l - I1000I1 -1, I1000I1 + 1);
    if substr(O100lI0, 1,1) = '/' then
      I1000I1 := dbms_lob.instr(pio_clob, '>', I1000I1) + 1;
    else
      if O100lI0 like '![CDATA[%' then 
        I1000I1 := dbms_lob.instr(pio_clob, ']]>', I1000I1);
        if I1000I1 = 0 then
          pak_xslt_log.WriteLog(
            'There is no closing tag ]]> for CDATA',
            p_log_type => pak_xslt_log.g_error,
            p_procedure => 'I1011II'
          );
          exit;
        else
          I1000I1 := I1000I1 + length(']]>') + 1;
        end if;
      else 
        
        if O100lI0 like '!--%' then
          I1000I1 := dbms_lob.instr(pio_clob, '-->', I1000I1);
          if I1000I1 = 0 then
            pak_xslt_log.WriteLog(
              'There is no closing tag --> for comment',
              p_log_type => pak_xslt_log.g_error,
              p_procedure => 'I1011II'
            );
            exit;
          else
            I1000I1 := I1000I1 + length('-->') + 1;
          end if;
        else 
          l1011II := dbms_lob.instr(pio_clob, '>', I1000I1);
          exit when l1011II = 0;
          if dbms_lob.substr(pio_clob, 2, l1011II - 1) = '/>' then 
            I1000I1 := l1011II + 1;
          else 
            if lower(O100lI0) in ('meta','link','br')
              and dbms_lob.instr(pio_clob, '</'||O100lI0||'>', I1000I1) = 0
            then 
              
              I10010I(pio_clob, lllI1l, I1000I1);
              l1011II := l1011II + length(lllI1l);
              I10010I(pio_clob, OllI1l, l1011II + 1);
              I1000I1 := l1011II + length(OllI1l);
            else 
              I1000I1 := l1011II + 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I1011II',
    p_sqlerrm => sqlerrm
  );
  raise;
end I1011II;
 

function I1011Il(
  l1011l0 varchar2
)
return boolean
as
O1011l0 number;
begin
  if substr(l1011l0,1,1) <> '&' then return false; end if; 
  O1011l0 := length(l1011l0);
  if substr(l1011l0,O1011l0,O1011l0) <> ';' then return false; end if; 
  if substr(l1011l0, 2, 1) = '#' then 
    for ll01I1 in 3..O1011l0-1
    loop
      if ascii(substr(l1011l0, ll01I1, 1)) not between ascii('0') and ascii('9') then
        return false;
      end if;
    end loop;
  else
    for ll01I1 in 2..O1011l0-1
    loop
      if ascii(substr(l1011l0, ll01I1, 1)) not between ascii('0') and ascii('9') and
         ascii(substr(l1011l0, ll01I1, 1)) not between ascii('Ol0lI0') and ascii('z') and
         ascii(substr(l1011l0, ll01I1, 1)) not between ascii('Ol0lI0') and ascii('Z')
      then
        return false;
      end if;
    end loop;
  end if;
  return true;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I1011Il',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure I1011l1(
  pio_clob IN OUT NOCOPY CLOB
)
as
I1000I1 number default 1;
l1011l1 number;
O1011lI varchar2(8);
I1011lI number default 1;
l1011ll number default 1;
O1011ll number;
begin
  loop
    I1000I1 := dbms_lob.instr(pio_clob, '&', I1000I1);
    while nvl(I1011lI, 0) > 0 and nvl(l1011ll, 0) > 0
    loop
      I1011lI := dbms_lob.instr(pio_clob, '<!--', I1011lI);
      l1011ll := dbms_lob.instr(pio_clob, '-->', l1011ll);
      exit when l1011ll > I1000I1 or I1011lI = 0 or l1011ll = 0;
      l1011ll := l1011ll + length('-->');
      I1011lI := l1011ll;
    end loop;
 
    exit when I1000I1 = 0;
    if I1000I1 between I1011lI and l1011ll then 
      I1000I1 := l1011ll + length('-->');
    else
      l1011l1 := dbms_lob.instr(pio_clob, ';', I1000I1);
      exit when l1011l1 = 0;
      if l1011l1 - I1000I1 <= 7 then 
        O1011lI := dbms_lob.substr(pio_clob, l1011l1 - I1000I1 + 1, I1000I1);
        if I1011Il(O1011lI) then
          l1011I1(pio_clob, I1000I1, O1011lI);
        end if;
      else
        I1000I1 := I1000I1 + 8;
      end if;
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I1011l1',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure I101I00(
  pio_clob IN OUT NOCOPY CLOB
)
as
begin
  I101101(pio_clob);
  I1011l1(pio_clob);
  O1011I1(pio_clob);
  I1011II(pio_clob);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I101I00(CLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure l101I00(
  p_BBFile                  IN varchar2,
  O101I01                IN number
)
as
I101I01 CLOB;
O100Ill number;
begin
  I101I01 := pak_blob_util.StaticFile2CLOB(p_BBFile, O100Ill);
  if O101I01 = F_MHT then
    l100l0l(I101I01);
  elsif O101I01 = F_RTF then
    I100l0l(I101I01);
  elsif O101I01 = F_TEXT then
    I100l01(I101I01);
  elsif O101I01 = F_HTML then
    I101I00(I101I01);
  elsif O101I01 = F_XML then
    O1010l1(I101I01);
  end if;
  DownloadConvertOutput(V('APP_ID'), pak_blob_util.clob2blob(I101I01, O100Ill), p_BBFile||'.Starter.xslt',
    IIllIl => false,
    p_mime => 'application/xslt+xml',
    p_blob_csid => O100Ill
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l101I00',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

 
procedure OIll10(
  p_xsltStaticFile          IN varchar2,
  p_second_XsltStaticFile   IN varchar2 default null,
  
  
  p_dwld_type               in number,
  p_mime                    in VARCHAR2 default 'application/octet'
)
as
begin
  if p_dwld_type = g_dwld_xslt then
    OIll10(p_xsltStaticFile, 'application/xslt+xml');
  elsif p_dwld_type = g_dwld_second_xslt then
    if p_second_xsltStaticFile is not null then
      OIll10(p_second_xsltStaticFile, 'application/xslt+xml');
    end if;
  
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'OIll10',
    p_sqlerrm => sqlerrm
  );
  raise;
end OIll10;
 
function l101I0I(
  O101I0I varchar2,
  p_name varchar2
)
return varchar2
as
lll0II number;
Oll0I1 number;
begin
  lll0II := instr(O101I0I,p_name||'="');
  if lll0II > 0 then
    lll0II := lll0II + length(p_name||'="');
    Oll0I1 := instr(O101I0I,'"', lll0II + 1);
    if Oll0I1 > lll0II then
      return substr(O101I0I, lll0II, Oll0I1 - lll0II);
    end if;
  end if;
  return null;
end;
 
function I101I0l(
    P_FILENAME VARCHAR2,
    IlI110 VARCHAR2
  )
  return varchar2
  AS
  l101I0l number;
  BEGIN
    if IlI110 is null then
      return P_FILENAME;
    end if;
    l101I0l := INSTR(P_FILENAME, '.', -1, 1);
    if l101I0l > 0 then
      return SUBSTR(P_FILENAME, 1, l101I0l-1)||'_'||IlI110||SUBSTR(P_FILENAME, l101I0l);
    else
      return P_FILENAME||'_'||IlI110;
    end if;
  END I101I0l;
 
  function O101I10(IlI110 varchar2)
  return boolean
  as
  begin
    if LENGTH(TRIM(TRANSLATE(IlI110, '0123456789', ' '))) is null then return true;
    else return false; end if;
  end;
 
  function I101I10(
    P_FILENAME VARCHAR2,
    l101I11 NUMBER
  )
  return varchar2
  AS
  l101I0l number(5);
  O101I11 number(5);
  IlIII1 varchar2(300);
  I101I1I varchar2(50);
  BEGIN
    
    l101I0l := INSTR(P_FILENAME, '.', -1, 1);
    O101I11 := INSTR(P_FILENAME, '_', -1, 1);
 
    if O101I11 >0 and l101I0l > 0 then
      I101I1I := substr(p_filename, O101I11+1, l101I0l - O101I11 -1);
      if O101I10(I101I1I) then
        IlIII1 := replace(p_filename, '_'||I101I1I||'.', '_'||to_char(l101I11)||'.');
      else
        IlIII1 := I101I0l(P_FILENAME, to_char(l101I11));
      end if;
    elsif O101I11 >0 then
      I101I1I := substr(p_filename, O101I11+1);
      if O101I10(I101I1I) then
        IlIII1 := replace(p_filename, '_'||I101I1I, '_'||to_char(l101I11));
      else
        IlIII1 := I101I0l(P_FILENAME, to_char(l101I11));
      end if;
    else
      IlIII1 := I101I0l(P_FILENAME, to_char(l101I11));
    end if;
    return IlIII1;
  END I101I10;
 
function Il001l(
  IIl1I0 number,
  pi_regionAttrs tab_string
)
return varchar2
as
Il01I1 varchar2(4000);
l101I1I varchar2(4000);
O101I1l varchar2(4000);
begin
  if IIl1I0 = V('APP_PAGE_ID') then
    Il01I1 := 'Ol0lI0'||V('APP_ID')||'_Q'||IIl1I0;
  else
    Il01I1 :=  'Ol0lI0'||V('APP_ID')||'_P'||IIl1I0;
  end if;
  for ll01I1 in 1..pi_regionAttrs.count loop
    if pi_regionAttrs(ll01I1) is not null then
      l101I1I := l101I0I(pi_regionAttrs(ll01I1),'name');
      O101I1l := l101I0I(pi_regionAttrs(ll01I1),'IR_name');
      if l101I1I is not null then
        Il01I1:= Il01I1||'_'||l101I1I;
      end if;
      if O101I1l is not null then
        Il01I1:= Il01I1||'_IR_'||O101I1l;
      end if;
    end if;
  end loop;
  Il01I1 := trim(substr(translate(Il01I1,'?,''":;?*+()/\|&%$#! '||query2report.g_crlf,'______________________'),1, 255));
  return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Il001l',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
function Il001l(
  IIl1I0 number,
  pi_regionAttr1 varchar2,
  pi_regionAttr2 varchar2,
  pi_regionAttr3 varchar2,
  pi_regionAttr4 varchar2,
  pi_regionAttr5 varchar2
)
return varchar2
as
OlIII0 tab_string := tab_string();
begin
  if pi_regionAttr1 is not null then
    OlIII0.extend;
    OlIII0(OlIII0.count) := pi_regionAttr1;
  end if;
  if pi_regionAttr2 is not null then
    OlIII0.extend;
    OlIII0(OlIII0.count) := pi_regionAttr2;
  end if;
  if pi_regionAttr3 is not null then
    OlIII0.extend;
    OlIII0(OlIII0.count) := pi_regionAttr3;
  end if;
  if pi_regionAttr4 is not null then
    OlIII0.extend;
    OlIII0(OlIII0.count) := pi_regionAttr4;
  end if;
  if pi_regionAttr5 is not null then
    OlIII0.extend;
    OlIII0(OlIII0.count) := pi_regionAttr5;
  end if;
  return Il001l(IIl1I0, OlIII0);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Il001l varchar2 ver.',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
procedure ll001l(
  p_filename varchar2,
  p_xml clob
)as
IlIII1 varchar2(400);
ll1Il1 number;
I101I1I number := 0;
IlII1l BLOB;
begin
  IlIII1 := p_filename;
  loop
    select count(*) into ll1Il1 from xpm_xml where fname = IlIII1||'.xml';
    if ll1Il1 = 0 then
      IlII1l := pak_blob_util.CLOB2BLOB(p_xml);
      insert into xpm_xml(fname, xmlblob) values(IlIII1||'.xml', IlII1l);
      dbms_lob.freetemporary(IlII1l);
      return;
    else
      I101I1I := I101I1I + 1;
      IlIII1 := I101I10(IlIII1,I101I1I);
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'll001l',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

 

procedure Query2DownloadReport
(
  p_xsltStaticFile          IN varchar2,
  p_filename                in VARCHAR2,
  pi_regionAttrs            in tab_string,
  pi_selectQueries          IN tab_string,
  pi_maxRows                IN tab_integer,
  IIl1I0                 IN number default V('APP_PAGE_ID'),
  p_dwld_type               in number default g_dwld_transformed,
  p_mime                    in VARCHAR2 default 'application/octet',
  p_format                  IN number default null,
  p_templateStaticFile      in  VARCHAR2, 
  p_external_params         IN varchar2 default null,
  p_second_XsltStaticFile   IN varchar2 default null,
  p_second_external_params  IN varchar2 default null,
  
  
  p_convertblob_param       IN varchar2 default null
)
as
IlII1l CLOB;
IlIII1 varchar2(400);
 
begin
 
  if p_dwld_type in (g_dwld_xml, IIlIl0, g_dwld_transformed) then
    IlII1l := ll001I(pi_regionAttrs, pi_selectQueries, O100101(pi_selectQueries), pi_maxRows);
    
    if p_dwld_type in (g_dwld_xml, IIlIl0) then
      IlIII1 := Il001l(IIl1I0, pi_regionAttrs);
      DownloadConvertOutput(V('APP_ID'), pak_blob_util.clob2blob(IlII1l), IlIII1||'.xml',
          IIllIl => false,
          p_mime => 'text/xml');
      if p_dwld_type = IIlIl0 then
        ll001l(IlIII1, IlII1l);
      end if;
    else
      
      XslTransformAndDownload(
        p_Xml => IlII1l,
        p_xsltStaticFile => p_xsltStaticFile,
        IIl1I0  => null,
        OIl11I => null,
        p_filename => p_filename,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, 
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );
 
    end if;
    dbms_lob.freetemporary(IlII1l);
  else
    OIll10(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      
      
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure =>'Query2DownloadReport (tab_string)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;
 

procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
   pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,IIl1I0         IN number default V('APP_PAGE_ID')
  ,p_format                IN  number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN  varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  
  
  p_convertblob_param       IN varchar2 default null
)
as
IlII1l CLOB;
IlIII1 varchar2(400);
begin
  if p_dwld_type in (g_dwld_xml, IIlIl0, g_dwld_transformed) then
    IlII1l := ll001I
    (
      pi_regionAttr1
      ,pi_selectQuery1
      ,OIllll(pi_selectQuery1)
      ,pi_maxRows1
      ,pi_regionAttr2
      ,pi_selectQuery2
      ,OIllll(pi_selectQuery2)
      ,pi_maxRows2
      ,pi_regionAttr3
      ,pi_selectQuery3
      ,OIllll(pi_selectQuery3)
      ,pi_maxRows3
      ,pi_regionAttr4
      ,pi_selectQuery4
      ,OIllll(pi_selectQuery4)
      ,pi_maxRows4
      ,pi_regionAttr5
      ,pi_selectQuery5
      ,OIllll(pi_selectQuery5)
      ,pi_maxRows5
    );
    
    if p_dwld_type in (g_dwld_xml, IIlIl0) then
      IlIII1 := Il001l(IIl1I0, pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5);
      DownloadConvertOutput(V('APP_ID'),  pak_blob_util.clob2blob(IlII1l), IlIII1||'.xml',
                            IIllIl => false,
                            p_mime => 'text/xml');
      if p_dwld_type = IIlIl0 then
        ll001l(IlIII1, IlII1l);
      end if;
    else
      XslTransformAndDownload(
        p_Xml => IlII1l,
        p_xsltStaticFile => p_xsltStaticFile,
        IIl1I0 => null,
        OIl11I => null,
        p_filename => p_filename,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, 
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );
    end if;
    dbms_lob.freetemporary(IlII1l);
  else
    OIll10(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      
      
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2DownloadReport (varchar2)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;
 

procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
  pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,IIl1I0         IN number default V('APP_PAGE_ID')
  ,p_format                IN    number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN    varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  
  
  p_convertblob_param       IN varchar2 default null
)
as
IlII1l CLOB;
IlIII1 varchar2(400);
begin
  if p_dwld_type in (g_dwld_xml, IIlIl0, g_dwld_transformed) then
 
    IlII1l := ll001I
    (
      pi_regionAttr1
      ,pi_selectQuery1
      ,null
      ,pi_maxRows1
      ,pi_regionAttr2
      ,pi_selectQuery2
      ,null
      ,pi_maxRows2
      ,pi_regionAttr3
      ,pi_selectQuery3
      ,null
      ,pi_maxRows3
      ,pi_regionAttr4
      ,pi_selectQuery4
      ,null
      ,pi_maxRows4
      ,pi_regionAttr5
      ,pi_selectQuery5
      ,null
      ,pi_maxRows5
    );
    
    if p_dwld_type in (g_dwld_xml, IIlIl0) then
      IlIII1 := Il001l(IIl1I0, pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5);
      DownloadConvertOutput(V('APP_ID'),  pak_blob_util.clob2blob(IlII1l), IlIII1||'.xml',
                            IIllIl => false,
                            p_mime => 'text/xml');
      if p_dwld_type = IIlIl0 then
        ll001l(IlIII1, IlII1l);
      end if;
    else
      XslTransformAndDownload(
        p_Xml => IlII1l,
        p_xsltStaticFile => p_xsltStaticFile,
        IIl1I0 => null,
        OIl11I => null,
        p_filename => p_filename,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, 
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );
    end if;
    dbms_lob.freetemporary(IlII1l);
  else
    OIll10(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      
      
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2DownloadReport (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;
 

function Query2ClobReport
(
  p_Xslt                    IN CLOB,
  pi_regionAttrs            in tab_string,
  pi_selectQueries          IN tab_string,
  pi_maxRows                IN tab_integer,
  p_format                  IN number default null,
  po_error                  OUT boolean,
  p_Template                IN CLOB default null,
  p_external_params         IN varchar2 default null,
  p_second_Xslt             IN CLOB default null,
  p_second_external_params  IN varchar2 default null,
  po_xml                    OUT CLOB
)
return BLOB
as
 
begin
    po_xml := ll001I(pi_regionAttrs, pi_selectQueries, O100101(pi_selectQueries), pi_maxRows);
    
    return l100l00
    (
      p_Xml => po_Xml,
      p_Xslt => p_Xslt,
      p_format => p_format,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params,
      p_second_Xslt => p_second_Xslt,
      p_second_external_params => p_second_external_params
    );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure =>'Query2ClobReport (tab_string)',
    p_sqlerrm => sqlerrm
  );
  raise;
end Query2ClobReport;
 

function Query2ClobReport
(
  p_Xslt              IN CLOB,
   pi_regionAttr1     in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format                  IN number default null
  ,po_error                  OUT boolean
  ,p_Template                IN CLOB default null
  ,p_external_params       IN  varchar2 default null
  ,p_second_Xslt           IN CLOB default null
  ,p_second_external_params IN  varchar2 default null
  ,po_xml                   OUT CLOB
)
return BLOB
as
 
begin
  po_xml := ll001I
  (
    pi_regionAttr1
    ,pi_selectQuery1
    ,OIllll(pi_selectQuery1)
    ,pi_maxRows1
    ,pi_regionAttr2
    ,pi_selectQuery2
    ,OIllll(pi_selectQuery2)
    ,pi_maxRows2
    ,pi_regionAttr3
    ,pi_selectQuery3
    ,OIllll(pi_selectQuery3)
    ,pi_maxRows3
    ,pi_regionAttr4
    ,pi_selectQuery4
    ,OIllll(pi_selectQuery4)
    ,pi_maxRows4
    ,pi_regionAttr5
    ,pi_selectQuery5
    ,OIllll(pi_selectQuery5)
    ,pi_maxRows5
  );
  
  return l100l00
  (
    p_Xml => po_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params,
    p_second_Xslt => p_second_Xslt,
    p_second_external_params => p_second_external_params
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2ClobReport (varchar2)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

function Query2ClobReport
(
  p_Xslt            IN CLOB,
  pi_regionAttr1    in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2    in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3     in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4     in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format                  IN number default null
  ,po_error                  OUT boolean
  ,p_Template                IN CLOB default null
  ,p_external_params         IN    varchar2 default null
  ,p_second_Xslt             IN CLOB default null
  ,p_second_external_params  IN  varchar2 default null
  ,po_Xml                    OUT CLOB
)
return BLOB
as
begin
  po_xml := ll001I
  (
    pi_regionAttr1
    ,pi_selectQuery1
    ,null
    ,pi_maxRows1
    ,pi_regionAttr2
    ,pi_selectQuery2
    ,null
    ,pi_maxRows2
    ,pi_regionAttr3
    ,pi_selectQuery3
    ,null
    ,pi_maxRows3
    ,pi_regionAttr4
    ,pi_selectQuery4
    ,null
    ,pi_maxRows4
    ,pi_regionAttr5
    ,pi_selectQuery5
    ,null
    ,pi_maxRows5
  );
  
  return l100l00
  (
    p_Xml => po_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params,
    p_second_Xslt => p_second_Xslt,
    p_second_external_params => p_second_external_params
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2ClobReport (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

 
 
 procedure I101I1l(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
I1011lI number := 1;
l1011ll   number;
l101II0 CLOB;
begin
  dbms_lob.createtemporary(l101II0, false);
  loop
    I1011lI := dbms_lob.instr(pio_rtf, '{\*\', I1011lI);
    l1011ll := dbms_lob.instr(pio_rtf, ';}', I1011lI);
    exit when nvl(I1011lI, 0) = 0 or nvl(l1011ll, 0) = 0;
    dbms_lob.copy(l101II0, pio_rtf, I1011lI - 1);
    dbms_lob.copy(l101II0, pio_rtf, dbms_lob.getlength(pio_rtf) - l1011ll - length(';}') + 1,
                  dbms_lob.getlength(l101II0) + 1, l1011ll + length(';}'));
    pio_rtf := l101II0;
    dbms_lob.trim(l101II0, 0);
  end loop;
  if ascii(dbms_lob.substr(pio_rtf, 1, dbms_lob.getlength(pio_rtf))) = 0 then
    dbms_lob.trim(pio_rtf, dbms_lob.getlength(pio_rtf)-1);
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'I101I1l',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
 

procedure Template2XSLT(
  Ol00I1     IN OUT NOCOPY BLOB,
  p_format      number,
  p_nls_charset varchar2,
  p_partsToTransform varchar2 default null
)
as
I101I01      CLOB;

OlIIl1    number := p_format;
Oll0ll  varchar2(5);
Oll011     varchar2(4000);
 
 
begin
 
  pak_xslt_log.WriteLog(
    'Start Ol00I1: '||dbms_lob.getlength(Ol00I1)||' p_format: '||p_format||' p_nls_charset: '||p_nls_charset,
    p_procedure => 'Template2XSLT (BLOB)'
  );
 
  I101I01 := pak_blob_util.BLOB2CLOB(Ol00I1, NLS_CHARSET_ID(p_nls_charset));
 
  Template2XSLT(I101I01, p_format, p_partsToTransform);
 
  pak_xslt_log.WriteLog(
    'Finish Ol00I1: '||dbms_lob.getlength(Ol00I1),
    p_procedure => 'Template2XSLT (BLOB)'
  );
 
  Ol00I1 := pak_blob_util.CLOB2BLOB(I101I01,  NLS_CHARSET_ID(p_nls_charset));
 
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (BLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure Template2XSLT(
  Ol00I1 IN OUT NOCOPY CLOB,
  p_format  IN number,
  p_partsToTransform IN VARCHAR2
)
as
begin
 
  pak_xslt_log.WriteLog(
    'Start Ol00I1: '||dbms_lob.getlength(Ol00I1)||' p_format: '||p_format,
    p_procedure => 'Query2Report.Template2XSLT (CLOB)',
    p_log_type => pak_xslt_log.g_warning
  );
 
  if p_format = f_ooxml then
    "i1lIlII11".IIlII1(Ol00I1, p_partsToTransform);
    O1010l1(Ol00I1);
  end if;
 
  if p_format = f_html then
    I101I00(Ol00I1);
  end if;
  if p_format = f_rtf then
    I100l0l(Ol00I1);
  end if;
  if p_format = f_mht then
    l100l0l(Ol00I1);
  end if;
  if p_format = f_text then
    I100l01(Ol00I1);
  end if;
  if p_format = f_xml then
    O1010l1(Ol00I1);
  end if;
 
  pak_xslt_log.WriteLog(
    'Finish Ol00I1: '||dbms_lob.getlength(Ol00I1),
    p_procedure => 'Template2XSLT (CLOB)'
  );
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (CLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
$if CCOMPILING.g_utl_file_privilege $then

procedure Template2XSLT(
  p_format number,
  Il00II varchar2,
  ll00II varchar2,
  p_xsltDir varchar2,
  p_xsltFile varchar2,
  p_nls_charset varchar2,
  p_partsToTransform varchar2 default null
)as
O101II0 CLOB;
 
begin
  O101II0 := pak_blob_util.READ2CLOB(Il00II, ll00II, p_nls_charset);
  Template2XSLT(O101II0, p_format, p_partsToTransform);
 
  
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (file)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
$end
 
function I101II1(
  p_xslt CLOB,
  OlllI0 varchar2,
  l101II1 varchar2
)
return tab_string
as
Il01I1 tab_string := tab_string();
O101III number;
I101III number := 1;
l101IIl number;
O101IIl number;
I101Il0 varchar(400);
l101Il0 varchar(400);
 
function O101Il1(I101Il1 tab_string, p_value varchar2)
return boolean
as
begin
  for ll01I1 in 1..I101Il1.count loop
    if I101Il1(ll01I1)=p_value then
      return true;
    end if;
  end loop;
  return false;
end;
 
begin
  loop
    O101III := dbms_lob.instr(p_xslt, '<'||OlllI0, I101III);
    exit when nvl(O101III, 0) = 0;
    I101III := dbms_lob.instr(p_xslt, '>', O101III);
    exit when nvl(I101III, 0) = 0;
    l101IIl := dbms_lob.instr(p_xslt, ' '||l101II1, O101III);
    if l101IIl between O101III and I101III then
      O101IIl := dbms_lob.instr(p_xslt, '"', l101IIl, 2);
      if O101IIl between O101III and I101III then
        I101Il0 := dbms_lob.substr(p_xslt, O101IIl - l101IIl + 1, l101IIl);
        I101Il0 := replace(I101Il0, ' ');
        I101Il0 := replace(I101Il0, chr(13)||chr(10));
        I101Il0 := replace(I101Il0, chr(10));
        if I101Il0 like l101II1||'="%"' then 
          l101Il0 := substr(I101Il0, length(l101II1||'="')+1, length(I101Il0) - length(l101II1||'="')-1);
          if not O101Il1(Il01I1, l101Il0) then
            Il01I1.extend;
            Il01I1(Il01I1.count) := l101Il0;
          end if;
        end if;
      end if;
    end if;
  end loop;
  return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error OlllI0: '||OlllI0||' l101II1: '||l101II1,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.I101II1',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 
function l101IlI(
  p_xslt          IN CLOB,
  OlllI0       IN varchar2,
  l101II1     IN varchar2,
  p_value         IN varchar2,
  O101IlI      OUT number,
  I101Ill   IN OUT number
)
return number
as
O101III number;
l101Ill number;
l101IIl number;
O101IIl number;
I101Il0 varchar(400);
l101Il0 varchar(400);
O101l00 number;
 
begin
  loop
    O101III := dbms_lob.instr(p_xslt, '<'||OlllI0, I101Ill);
    exit when nvl(O101III, 0) = 0;
    O101IlI := dbms_lob.instr(p_xslt, '>', O101III + length('<'||OlllI0));
    I101Ill := dbms_lob.instr(p_xslt, '/>', O101III + length('<'||OlllI0));
    O101l00 := length('/>');
    l101Ill := dbms_lob.instr(p_xslt, '<', O101III + length('<'||OlllI0));
    if l101Ill < I101Ill then
      I101Ill := dbms_lob.instr(p_xslt, '</'||OlllI0||'>', O101III + length('<'||OlllI0));
      O101l00 := length('</'||OlllI0||'>');
    end if;
    exit when nvl(I101Ill, 0) = 0;
    I101Ill := I101Ill + O101l00;
    l101IIl := dbms_lob.instr(p_xslt, ' '||l101II1, O101III);
    if l101IIl between O101III and I101Ill then
      O101IIl := dbms_lob.instr(p_xslt, '"', l101IIl, 2);
      if O101IIl between O101III and O101IlI then
        I101Il0 := dbms_lob.substr(p_xslt, O101IIl - l101IIl + 1, l101IIl);
        I101Il0 := replace(I101Il0, ' ');
        I101Il0 := replace(I101Il0, chr(13)||chr(10));
        I101Il0 := replace(I101Il0, chr(10));
        if I101Il0 like l101II1||'="%"' then 
          l101Il0 := substr(I101Il0, length(l101II1||'="')+1, length(I101Il0) - length(l101II1||'="')-1);
          if upper(l101Il0) = upper(p_value) then
            return O101III;
          elsif lower(l101II1) = 'match' then 
            if substr(l101Il0, 1, 1) != '/' then
              l101Il0 := '/'||l101Il0;
            end if;
            if substr(l101Il0, length(l101Il0), 1) != '/' then
              l101Il0 := l101Il0||'/';
            end if;
            if instr('/'||p_value||'/', l101Il0) > 0 then
              return O101III;
            end if;
          end if;
        end if;
      end if;
    end if;
  end loop;
  return null;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error OlllI0: '||OlllI0||' l101II1: '||l101II1,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.l101IlI',
    p_sqlerrm => sqlerrm
  );
  raise;
end l101IlI;
 
 
function GetTemplateMatches(p_xslt CLOB)
return tab_string
as
begin
  return I101II1(p_xslt, 'xsl:apply-templates', 'select');
end;
 
function GetTemplateNames(p_xslt CLOB)
return tab_string
as
begin
  return I101II1(p_xslt, 'xsl:call-template', 'name');
end;
 
procedure I101l00(p_xslt IN CLOB, l101l01 OUT NUMBER, O101l01 OUT NUMBER)
as
I101l0I constant varchar2(40):= '<xsl:template match="/">';
l101l0I constant varchar2(40):= '</xsl:template>';
O101l0l number;
begin
  l101l01:= dbms_lob.instr(p_xslt, I101l0I)+length(I101l0I);
  O101l0l:= dbms_lob.instr(p_xslt, I101l0I||g_crlf)+length(I101l0I||g_crlf);
  if nvl(O101l0l, 0) > l101l01 then
    l101l01 := O101l0l;
  end if;
  O101l01:= dbms_lob.instr(p_xslt, l101l0I, l101l01);
  
end;
 
procedure AppendModifiedElelmentTag(
  I101l0l IN OUT NOCOPY CLOB,
  l101l10 CLOB,
  O101l10 number,
  IIlI1l number,
  ll00l1 varchar2,
  Ol00lI varchar2
)
as
I101l11 varchar2(4000);
begin
  I101l11 := dbms_lob.substr(l101l10, O101l10, IIlI1l);
  I101l11 := replace(I101l11,'<', ll00l1);
  I101l11 := substr(I101l11, 1, length(I101l11)-1)|| Ol00lI;
  dbms_lob.writeappend(I101l0l, length(I101l11), I101l11); 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error O101l10: '||O101l10||' IIlI1l: '||IIlI1l,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.AppendModifiedElelmentTag',
    p_sqlerrm => sqlerrm
  );
  raise;
end AppendModifiedElelmentTag;
 
function l101l11(
  l101l10 CLOB,
  O101l10 number,
  IIlI1l number,
  ll00l1 varchar2 default null,
  Ol00lI varchar2 default null
)
return varchar2
as
Il01I1 varchar2(400);
begin
  Il01I1 := dbms_lob.substr(l101l10, O101l10, IIlI1l);
  if ll00l1 is null or Ol00lI is null or
    Il01I1 like '<xsl:processing-instruction name="%'
  then 
    Il01I1 := replace(Il01I1, '<xsl:processing-instruction name="','<?');
    Il01I1 := replace(Il01I1, '</xsl:processing-instruction>','?>');
    Il01I1 := replace(Il01I1, '">',' ');
  else
    Il01I1 := replace(Il01I1,'<', ll00l1);
    Il01I1 := substr(Il01I1, 1, length(Il01I1)-1)|| Ol00lI;
  end if;
  return Il01I1;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error O101l10: '||O101l10||' IIlI1l: '||IIlI1l,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.l101l11',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
 

procedure O101l1I(
  Ol00Il IN OUT NOCOPY CLOB,
  OlllI0       IN varchar2,
  l101II1     IN varchar2,
  p_value         IN varchar2,
  ll00l1 varchar2 default '&lt;',
  Ol00lI varchar2 default '&gt;'
)
as
I101l1I    number;
l101l1l      number;
I101III   number := 1;
l10100I       number;
O101III number;
O101l1l number;
I101lI0  number;
I101Il0 varchar2(400);

Ol0l11 CLOB;
begin
  pak_xslt_log.WriteLog(
    'Start O101l1I OlllI0 '||OlllI0||' l101II1 '||l101II1||
    ' p_value '||p_value||
    ' ll00l1 '||ll00l1||' Ol00lI '||Ol00lI,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );
 
  if l101II1 = 'select' and OlllI0 = 'xsl:apply-templates' then
    I101Il0 := 'match';
  else
    I101Il0 := l101II1;
  end if;
 
  dbms_lob.createTemporary(Ol0l11, false);
  loop
    I101l00(Ol00Il, I101l1I, l101l1l); 
 
    if nvl(I101l1I, 0) = 0 or nvl(l101l1l, 0) = 0 then
      return;
    end if;
    I101lI0 := l101l1l;
    
    O101III := l101IlI(Ol00Il, OlllI0, l101II1, p_value, l10100I, I101III);
    exit when nvl(O101III, 0) = 0;
 
    dbms_lob.copy(Ol0l11, Ol00Il, O101III - 1, 1, 1); 
 
     
    AppendModifiedElelmentTag(
      Ol0l11,
      Ol00Il,
      l10100I - O101III + 1,
      O101III,
      ll00l1,
      Ol00lI
    );
 
    
    
    O101l1l := l101IlI(Ol00Il, 'xsl:template', I101Il0, p_value, l10100I, I101lI0);
    if O101l1l > 0 then 
 
      
      AppendModifiedElelmentTag(
        Ol0l11,
        Ol00Il,
        l10100I - O101l1l + 1,
        O101l1l,
        ll00l1,
        Ol00lI
      );
 
      dbms_lob.copy(Ol0l11, Ol00Il, I101lI0 - length('</xsl:template>') - l10100I - 1, dbms_lob.getlength(Ol0l11) + 1, l10100I + 1); 
      dbms_lob.writeappend(Ol0l11, length(ll00l1||'/xsl:template'||Ol00lI), ll00l1||'/xsl:template'||Ol00lI); 
 
      
      
      dbms_lob.copy(Ol0l11, Ol00Il, dbms_lob.getlength(Ol00Il) - I101III +1, dbms_lob.getlength(Ol0l11) + 1, I101III);
      Ol00Il := Ol0l11;
      dbms_lob.trim(Ol0l11, 0);
      
    else
      
      dbms_lob.copy(Ol0l11, Ol00Il, dbms_lob.getlength(Ol00Il) - I101III, dbms_lob.getlength(Ol0l11) + 1, I101III);
      Ol00Il := Ol0l11;
      dbms_lob.trim(Ol0l11, 0);
      
      exit;
    end if;
    
 
  end loop;
  dbms_lob.freeTemporary(Ol0l11);
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.O101l1I',
    p_sqlerrm => sqlerrm
  );
  raise;
end O101l1I;
 
procedure l101lI0(
  pio_clob IN OUT NOCOPY CLOB
)
as
  I1011lI number default 1;
  l1011ll number default 1;
  Ol0l11 CLOB;
begin
  dbms_lob.createtemporary(Ol0l11, false);
  loop
    I1011lI := dbms_lob.instr(pio_clob, '<!--', I1011lI);
    exit when nvl(I1011lI, 0) = 0;
    l1011ll := dbms_lob.instr(pio_clob, '-->', I1011lI);
    exit when nvl(l1011ll, 0) = 0;
    l1011ll := l1011ll + length('-->');
    dbms_lob.copy(Ol0l11, pio_clob, I1011lI - 1, 1, 1);
    dbms_lob.copy(Ol0l11, pio_clob, dbms_lob.GetLength(pio_clob) - l1011ll + 1, dbms_lob.GetLength(Ol0l11) + 1 , l1011ll);
    pio_clob := Ol0l11;
    dbms_lob.trim(Ol0l11, 0);
  end loop;
  dbms_lob.freetemporary(Ol0l11);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'l101lI0',
    p_sqlerrm => sqlerrm
  );
  raise;
end l101lI0;
 

procedure O101lI1(
  Ol00Il IN OUT NOCOPY CLOB,
  ll00l0 tab_string,
  Ol00l0 tab_string,
  ll00l1 varchar2 default '&lt;',
  Ol00lI varchar2 default '&gt;'
)
as
 
begin
  pak_xslt_log.WriteLog(
    'Start O101lI1 match templates '||ll00l0.count||' name templates '||Ol00l0.count||
    ' ll00l1 '||ll00l1||' Ol00lI '||Ol00lI,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );
 
  l101lI0(Ol00Il);
 
  for ll01I1 in 1..ll00l0.count loop
    
    O101l1I(Ol00Il, 'xsl:apply-templates', 'select', ll00l0(ll01I1), ll00l1, Ol00lI);
    
  end loop;
 
  
  for ll01I1 in 1..Ol00l0.count loop
    
    O101l1I(Ol00Il, 'xsl:call-template', 'name', Ol00l0(ll01I1), ll00l1, Ol00lI);
    
  end loop;
  
 
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.O101lI1',
    p_sqlerrm => sqlerrm
  );
  raise;
end O101lI1;
 

procedure XSLT2Document(
  Ol00Il IN OUT NOCOPY CLOB,
  Il00Il varchar2,
  ll00l0 tab_string,
  Ol00l0 tab_string,
  Il00l1 varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf,
  ll00l1 varchar2 default '&lt;',
  Ol00lI varchar2 default '&gt;'
)
as
I101l1I number;
l101l1l number;
 
I101lI1 constant varchar2(400):='<xsl:text disable-output-escaping="yes">'||g_crlf||
'<![CDATA[';
 
l101lII constant varchar2(400):=']]>'||g_crlf||
'</xsl:text>';
 
O101lII constant varchar2(400):='<xsl:text disable-output-escaping="yes">'||chr(10)||
'<![CDATA[';
 
I101lIl constant varchar2(400):=']]>'||chr(10)||
'</xsl:text>';
 
l101lIl varchar2(20);
O101ll0 boolean;
I101ll0 number;
l101ll1 number;
O101ll1 number;
I101llI number;
l101llI number;
O101lll number;
Ol0l11 CLOB;
I101lll varchar2(32000);
l10I000 number;
O10I000 number;
begin
  pak_xslt_log.WriteLog(
    'Start XSLT2Document Il00Il '||Il00Il||' Il00l1 '||Il00l1||
    ' match templates '||ll00l0.count||' name templates '||Ol00l0.count||
    ' ll00l1 '||ll00l1||' Ol00lI '||Ol00lI,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );
 
  O101lI1(
    Ol00Il,
    ll00l0,
    Ol00l0,
    ll00l1,
    Ol00lI
  );
 
  
 
  I1010I1(Ol00Il, 'xsl:stylesheet', 'w:wordDocument');
  I1010I1(Ol00Il, 'xsl:stylesheet', 'Workbook');
 
 
  if dbms_lob.instr(Ol00Il, I101lI1||'<Workbook')> 0 or
    dbms_lob.instr(Ol00Il, O101lII||'<Workbook')> 0
  then
    pak_blob_util.clobReplaceAll(Ol00Il, I101lI1||'<Workbook', '<Workbook');
    pak_blob_util.clobReplaceAll(Ol00Il, O101lII||'<Workbook', '<Workbook');
 
    
    l10I000 := dbms_lob.instr(Ol00Il,']]>');
    O10I000 := dbms_lob.instr(Ol00Il,'</xsl:text>');
    if l10I000 > 0 and O10I000 > 0 and O10I000 > l10I000 then
      pak_blob_util.clobReplace(Ol00Il, ']]>', '', l10I000, O10I000);
      pak_blob_util.clobReplace(Ol00Il, '</xsl:text>', '', l10I000, O10I000);
    end if;
  end if;
 
  pak_blob_util.clobReplaceAll(Ol00Il, I101lI1||'</Workbook>'||l101lII, '</Workbook>');
  pak_blob_util.clobReplaceAll(Ol00Il, O101lII||'</Workbook>'||I101lIl, '</Workbook>');
 
  if Il00Il = 'mht' then
    pak_blob_util.clobReplaceAll(Ol00Il, chr(13)||g_crlf, g_crlf);
    
 
    pak_blob_util.clobReplaceAll(Ol00Il, '</xsl:text>'||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(Ol00Il, g_crlf||'<xsl:text', '<xsl:text');
    pak_blob_util.clobReplaceAll(Ol00Il, g_crlf||'<![CDATA[', '');
    pak_blob_util.clobReplaceAll(Ol00Il, ']]>'||g_crlf, '');
 
  elsif Il00Il != 'xml' then
    pak_blob_util.clobReplaceAll(Ol00Il, '</xsl:text>'||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(Ol00Il, g_crlf||'<xsl:text', '<xsl:text');
  end if;
 
  pak_blob_util.clobReplaceAll(Ol00Il, '<![CDATA[', '');
  pak_blob_util.clobReplaceAll(Ol00Il, ']]>', '');
 
  
  I101l00(Ol00Il, I101l1I, l101l1l);
 
  if nvl(I101l1I, 0) = 0 or nvl(l101l1l, 0) = 0 then
    return;
  end if;
 
 
 
  dbms_lob.createtemporary(Ol0l11, false);
 
  pak_xslt_log.WriteLog(
        'Start Il00Il: '||Il00Il||' Il00l1: '||Il00l1,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
  if Il00l1 is not null and Il00Il = 'xml' then
    DBMS_LOB.WRITEAPPEND(Ol0l11, length(Il00l1),Il00l1);
  end if;
  I101ll0 := I101l1I;
  I101llI := I101l1I;
  l101llI := I101l1I;
  loop
    pak_xslt_log.WriteLog(
        'start loop I101llI: '||I101llI,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
    I101ll0 := dbms_lob.instr(Ol00Il, '<xsl:', I101llI);
    l101ll1 := dbms_lob.instr(Ol00Il, '</xsl:', I101llI);
 
    pak_xslt_log.WriteLog(
        'start loop I101ll0: '||I101ll0||' l101ll1: '||l101ll1,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
    if l101ll1 > 0 and I101ll0 > 0 then
      I101ll0 := least(I101ll0, l101ll1);
    elsif l101ll1 > 0 and nvl(I101ll0, 0) = 0 then
      I101ll0 := l101ll1;
    end if;
    exit when nvl(I101ll0, 0) = 0 or I101ll0 >= l101l1l;
    if I101ll0 = l101ll1 then
      l101lIl := '</xsl:text>';
    else
      l101lIl := '<xsl:text';
    end if;
 
    O101ll0 := dbms_lob.substr(Ol00Il, length(l101lIl), I101ll0) = l101lIl;
 
    if I101ll0 > I101llI then
      pak_xslt_log.WriteLog(
        'start copy to end of Ol0l11 from '||I101llI||' and new '||I101ll0,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
      DBMS_LOB.COPY (Ol0l11, Ol00Il, I101ll0 - I101llI, nvl(DBMS_LOB.GETLENGTH(Ol0l11),0)+1, I101llI); 
 
     pak_xslt_log.WriteLog(
        'finsih copy to end of Ol0l11 from '||I101llI||' and new '||I101ll0,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
    end if;
 
    l101llI :=dbms_lob.instr(Ol00Il, '<xsl:processing-instruction', I101ll0);
    if l101llI = I101ll0 then 
 
 
      I101llI := dbms_lob.instr(Ol00Il, '</xsl:processing-instruction>', l101llI);
 
      pak_xslt_log.WriteLog(
        'xsl:processing-instruction: '||l101llI||'-'||I101llI,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
      exit when nvl(I101llI, 0) = 0;
      I101llI := I101llI + length('</xsl:processing-instruction>');
      
      I101lll := l101l11(Ol00Il, I101llI - I101ll0, I101ll0);
 
      
      
      
 
      pak_xslt_log.WriteLog(
        'xsl:processing-instruction I101lll: '||I101lll,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
    else 
      I101llI := dbms_lob.instr(Ol00Il, '>', I101ll0);
      exit when nvl(I101llI, 0) = 0;
      I101llI := I101llI + length('>');
 
      pak_xslt_log.WriteLog(
        'xsl: '||I101ll0||'-'||I101llI,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
 
 
      if not O101ll0 or Il00Il = 'xml' then
        
        
        
        I101lll := l101l11(Ol00Il, I101llI - I101ll0, I101ll0, ll00l1, Ol00lI);
 
        pak_xslt_log.WriteLog(
          'xsl: I101lll: '||I101lll,
          p_log_type => pak_xslt_log.g_warning,
          p_procedure => 'XSLT2Document' );
      end if;
    end if;
    if I101lll is not null and I101ll0 < l101l1l and
      (not O101ll0 or Il00Il = 'xml')
    then
      DBMS_LOB.WRITEAPPEND(Ol0l11, length(I101lll),I101lll);
 
      pak_xslt_log.WriteLog(
        'WRITEAPPEND '||I101lll||' to Ol0l11 ',
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
    end if;
  end loop;
  if I101llI > 0 then 
    DBMS_LOB.COPY (Ol0l11, Ol00Il, l101l1l - I101llI, nvl(DBMS_LOB.GETLENGTH(Ol0l11),0)+1, I101llI);
 
    pak_xslt_log.WriteLog(
        'copy the rest to end of Ol0l11 from '||I101llI||' and end of template '||l101l1l,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );
 
  end if;
 
  if Il00Il = 'mht' then 
    dbms_lob.trim(Ol00Il, 0);
    dbms_lob.copy(
      Ol00Il, Ol0l11,
      dbms_lob.getlength(Ol0l11) - dbms_lob.instr(Ol0l11, 'MIME-Version'),
      1, dbms_lob.instr(Ol0l11, 'MIME-Version')
    );
  else
    Ol00Il := Ol0l11;
  end if;
 
  dbms_lob.freetemporary(Ol0l11);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XSLT2Document',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLT2Document;
 
$if CCOMPILING.g_utl_file_privilege $then

procedure XSLT2Document(
  p_xsltDir          IN  VARCHAR2,
  Il00lI        IN  VARCHAR2,
  ll00ll         IN  varchar2,
  Ol00ll        IN  varchar2,
  Il00Il varchar2,
  ll00l0 tab_string,
  Ol00l0 tab_string,
  Il00l1 varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf,
  ll00l1 varchar2 default '&lt;',
  Ol00lI varchar2 default '&gt;'
)
as
l100I10 CLOB;
begin
  l100I10 := pak_blob_util.READ2CLOB(p_xsltDir, Il00lI);
  XSLT2Document(
    l100I10,
    Il00Il,
    ll00l0,
    Ol00l0,
    Il00l1,
    ll00l1,
    Ol00lI
  );
  
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XSLT2Document',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLT2Document;
 

procedure RefreshStaticFile(
  p_ws varchar2,
  p_static_Filename varchar2,
  p_filedir varchar2,
  p_filename varchar2
)
as
O100II1 number;
I100IlI BLOB;
l100Il1 varchar2(10);
begin
    select workspace_id
    into O100II1
    from apex_workspaces
    where workspace = upper(p_ws);
 
    wwv_flow_api.set_security_group_id(O100II1);
 
    I100IlI := pak_blob_util.GetBlob(p_filedir, p_filename);
 
    SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
    into l100Il1
    FROM apex_release;
 
    update wwv_flow_files set
    blob_content = I100IlI,
    doc_size = dbms_lob.getlength(I100IlI)
    where (file_type = 'STATIC_FILE' or l100Il1 = '4.1')
    and filename = p_static_filename;
    commit;
exception
  when others then
  pak_xslt_log.WriteLog('Error RefreshStaticFile '||p_static_Filename||' with content of file '||p_filedir||'\'||P_FILENAME,
                  p_log_type => pak_xslt_log.g_error, p_procedure => 'RefreshStaticFile' );
  rollback;
  raise;
end;
$end
 

procedure RefreshStaticFile(
  p_ws varchar2,
  p_static_Filename varchar2,
  p_clob clob,
  p_clob_csid    number
)
as
O100II1 number;
I100IlI BLOB;
l100III NUMBER;
O100IIl number default 0;

l100Il0 number default 1;
O100Il0 number default 1;
l100Il1 varchar2(10);
 
begin
  DBMS_LOB.CREATETEMPORARY(I100IlI, true);
 
  DBMS_LOB.OPEN (I100IlI, DBMS_LOB.LOB_READWRITE);
 
    
 
    
  DBMS_LOB.CONVERTTOBLOB(
    I100IlI,
    p_clob,
    DBMS_LOB.LOBMAXSIZE,
    l100Il0,
    O100Il0,
    p_clob_csid,
    O100IIl,
    l100III
  );
 
  select workspace_id
  into O100II1
  from apex_workspaces
  where workspace = upper(p_ws);
 
  wwv_flow_api.set_security_group_id(O100II1);
 
  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
  into l100Il1
  FROM apex_release;
 
  update wwv_flow_files set
  blob_content = I100IlI,
  doc_size = dbms_lob.getlength(I100IlI)
  where (file_type = 'STATIC_FILE' or l100Il1 = '4.1')
  and filename = p_static_filename;
 
  DBMS_LOB.FREETEMPORARY(I100IlI);
  commit;
exception
  when others then
  pak_xslt_log.WriteLog('Error RefreshStaticFile CLOB ',
                  p_log_type => pak_xslt_log.g_error, p_procedure => 'RefreshStaticFile' );
  rollback;
  raise;
end;
 
end QUERY2REPORT;

/
