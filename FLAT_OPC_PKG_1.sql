



  CREATE OR REPLACE PACKAGE BODY "i1lIlII11" AS

  TYPE OlIl0l IS TABLE OF VARCHAR2(400) INDEX BY VARCHAR2(256);
  TYPE IlIl0l IS TABLE OF varchar2(400);

  llIl10 constant varchar(200) := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||chr(13)||chr(10);

  function OlIl10(IlIl11 IlIl0l)
  return varchar2
  as
  Il01I1 varchar2(32000);
  begin
    for ll01I1 in 1..IlIl11.count loop
      Il01I1 := Il01I1||IlIl11(ll01I1)||',';
    end loop;
    if Il01I1 is not null then
      Il01I1 := rtrim(Il01I1,',');
    end if;
    return Il01I1;
  end;

  function llIl11(OlIl1I OlIl0l)
  return varchar2
  as
  Il01I1 varchar2(32000);
  IlIl1I varchar2(256);
  begin
    IlIl1I := OlIl1I.FIRST;
    if IlIl1I is not null then
      Il01I1 := IlIl1I||':'||OlIl1I(IlIl1I)||',';
    end if;
    while IlIl1I is not null loop
      IlIl1I := OlIl1I.NEXT(IlIl1I);
      if IlIl1I is not null then
        Il01I1 := Il01I1||IlIl1I||':'||OlIl1I(IlIl1I)||',';
      end if;
    end loop;
    if Il01I1 is not null then
      Il01I1 := rtrim(Il01I1,',');
    end if;
    return Il01I1;
  end;

  


  function llIl1l(
    OlIl1l         CLOB,
    IlIlI0             varchar2,
    llIlI0            varchar2
  )
  return OlIl0l
  as
  OlIlI1 number := 1;
  IlIlI1 number;
  llIlII number;
  OlIlII number;
  IlIlIl number;
  llIlIl number;
  OlIll0 number;
  IlIll0 varchar2(256);
  llIll1 varchar2(400);

  Il01I1 OlIl0l;
  begin
    loop
      IlIlI1 := dbms_lob.instr(OlIl1l, '<'||IlIlI0||' ', OlIlI1);
      exit when nvl(IlIlI1, 0) = 0;
      llIlII := dbms_lob.instr(OlIl1l, '>', IlIlI1);
      exit when nvl(llIlII, 0) = 0;
      OlIlII := dbms_lob.instr(OlIl1l, llIlI0||'="', IlIlI1);
      exit when nvl(OlIlII, 0) = 0;
      OlIlII := OlIlII + length(llIlI0||'="');
      IlIlIl := dbms_lob.instr(OlIl1l, '"', OlIlII);
      exit when nvl(IlIlIl, 0) = 0;
      llIlIl := dbms_lob.instr(OlIl1l, 'ContentType="', IlIlI1);
      exit when nvl(llIlIl, 0) = 0;
      llIlIl := llIlIl + length('ContentType="');
      OlIll0 := dbms_lob.instr(OlIl1l, '"', llIlIl);
      exit when nvl(IlIlIl, 0) = 0;
      IlIll0 := dbms_lob.substr(OlIl1l, IlIlIl - OlIlII, OlIlII);
      llIll1 := dbms_lob.substr(OlIl1l, OlIll0 - llIlIl, llIlIl);
      Il01I1(IlIll0) := llIll1;
      OlIlI1 := llIlII;
    end loop;
    return Il01I1;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'i1lIlII11.llIl1l'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end llIl1l;


  procedure OlIll1(
    OlIl1l         CLOB,
    IlIllI  OUT OlIl0l,
    llIllI       OUT OlIl0l
  )
  as
  begin
    IlIllI := llIl1l(OlIl1l, 'Default', 'Extension');
    llIllI := llIl1l(OlIl1l, 'Override', 'PartName');
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'i1lIlII11.OlIll1'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end OlIll1;

  function GetProcessingInstruction(IIlI10 varchar2)
  return varchar2
  as
  Il01I1 varchar2(400);
  begin
    if upper(IIlI10) = 'DOCX' then
      Il01I1:='<?mso-application progid="Word.Document"?>'||chr(13)||chr(10);
    elsif upper(IIlI10) = 'PPTX' then
      Il01I1:='<?mso-application progid="PowerPoint.Show"?>'||chr(13)||chr(10);
    elsif upper(IIlI10) = 'XLSX' then
      Il01I1:='<?mso-application progid="Excel.Sheet"?>'||chr(13)||chr(10);
    end if;
    return Il01I1;
  end;



  function OlIlll(
    p_filename varchar2,
    IlIlll OlIl0l,
    lll000 OlIl0l
  )
  return varchar2
  as
  Oll000 varchar2(5);
  begin
    if lll000.EXISTS(p_filename) then
      return lll000(p_filename);
    else
      Oll000 := substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1) );
      if Oll000 is not null then
        return IlIlll(Oll000);
      end if;
    end if;
    
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error p_filename: '||p_filename
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OlIlll'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end OlIlll;


  function Ill001(p_xml BLOB, p_encoding number)
  return CLOB
  as
  Il01I1 CLOB;
  Ol0l11 CLOB;
  
  OlIlI1 number := 1;

  begin
    Ol0l11 := pak_blob_util.BLOB2CLOB(p_xml, NLS_CHARSET_ID(p_encoding));
    

    OlIlI1 := dbms_lob.instr(Ol0l11, '<', OlIlI1);
    if nvl(OlIlI1, 0) = 0 then
      return null;
    end if;
    if dbms_lob.substr(Ol0l11, 5, OlIlI1+1) = '?xml ' then
      OlIlI1 := dbms_lob.instr(Ol0l11, '<', OlIlI1 + 1);
      if nvl(OlIlI1, 0) = 0 then
        return null;
      end if;
    end if;
    dbms_lob.CreateTemporary(Il01I1, false);
    
    dbms_lob.Copy(Il01I1, Ol0l11, dbms_lob.getlength(Ol0l11) - OlIlI1 + 1, 1, OlIlI1);
    return Il01I1;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.Ill001'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end Ill001;



  function OOXML2FlatOPC(
    OIlI10 BLOB,
    IIlI10 varchar2,
    OIlI11 OUT varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding in varchar2 := null
  )
  return CLOB AS
  Il01I1 CLOB;
  lll001 varchar2(400);
  Oll00I zip_util_pkg.t_file_list;
  Ill00I blob;
  IlII1l clob;
  

  lll00l OlIl0l;
  Oll00l OlIl0l;
  Ill010 varchar2(400);
  lll010 varchar2(4000);
  Oll011 varchar2(4000);
  BEGIN
    dbms_lob.CreateTemporary(Il01I1, false);
    if IIlI10 is not null then
      lll001 := GetProcessingInstruction(IIlI10);
      dbms_lob.WriteAppend(Il01I1, length(lll001), lll001);
    end if;

    Oll00I := zip_util_pkg.get_file_list(OIlI10);
    IlII1l := pak_blob_util.BLOB2CLOB(
      zip_util_pkg.GET_FILE( OIlI10, '[Content_Types].xml' ), NLS_CHARSET_ID(p_encoding));

    OlIll1(IlII1l, Oll00l, lll00l);

    if Oll00I.count() > 0
    then
      dbms_lob.WriteAppend(Il01I1, length('<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'||chr(13)||chr(10)),
      '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'||chr(13)||chr(10));
      for ll01I1 in Oll00I.first .. Oll00I.last
      loop
        
        if substr(Oll00I(ll01I1), length(Oll00I(ll01I1)), 1 ) != '/' then 
          Ill00I := zip_util_pkg.GET_FILE( OIlI10, Oll00I( ll01I1 ) );
          if Oll00I( ll01I1 ) != '[Content_Types].xml' then
            Ill010 := OlIlll('/'||Oll00I( ll01I1 ), Oll00l, lll00l);
            OIlI11:=OIlI11||Oll00I( ll01I1 )||':';
            if substr(Ill010, length(Ill010)-3)='+xml' then
              lll010 := '<pkg:part pkg:name="/'||Oll00I( ll01I1 )||'" pkg:contentType="'||Ill010||'">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);
              
              dbms_lob.WriteAppend(Il01I1, length('<pkg:xmlData>'||chr(13)||chr(10)), '<pkg:xmlData>'||chr(13)||chr(10));
                
                IlII1l := Ill001(Ill00I, p_encoding);
                dbms_lob.Copy(Il01I1, IlII1l, dbms_lob.getlength(IlII1l), dbms_lob.getlength(Il01I1)+1, 1);
              dbms_lob.WriteAppend(Il01I1, length('</pkg:xmlData>'||chr(13)||chr(10)), '</pkg:xmlData>'||chr(13)||chr(10));
            elsif p_unzip_embeedeings and
                  (
                    (Oll00I( ll01I1 ) like 'word/embeddings/%.xlsx' and Ill010='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
                    (Oll00I( ll01I1 ) like 'xl/embeddings/%.docx' and Ill010='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                  )
            then
              lll010 := '<pkg:part pkg:name="/'||Oll00I( ll01I1 )||'" pkg:contentType="'||Ill010||'">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);
              
              dbms_lob.WriteAppend(Il01I1, length('<pkg:xmlData>'||chr(13)||chr(10)), '<pkg:xmlData>'||chr(13)||chr(10));
                
                IlII1l := OOXML2FlatOPC(Ill00I, null, Oll011, false,  p_encoding);
                dbms_lob.Copy(Il01I1, IlII1l, dbms_lob.getlength(IlII1l), dbms_lob.getlength(Il01I1)+1, 1);
              dbms_lob.WriteAppend(Il01I1, length('</pkg:xmlData>'||chr(13)||chr(10)), '</pkg:xmlData>'||chr(13)||chr(10));
            else
              lll010 := '<pkg:part pkg:name="/'||Oll00I( ll01I1 )||'" pkg:contentType="'||Ill010||'" pkg:compression="store">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);
              
              dbms_lob.WriteAppend(Il01I1, length('<pkg:binaryData>'||chr(13)||chr(10)), '<pkg:binaryData>'||chr(13)||chr(10));
                
                IlII1l := pak_blob_util.base64_encode(Ill00I);
                dbms_lob.Copy(Il01I1, IlII1l, dbms_lob.getlength(IlII1l), dbms_lob.getlength(Il01I1)+1, 1);
              dbms_lob.WriteAppend(Il01I1, length('</pkg:binaryData>'||chr(13)||chr(10)), '</pkg:binaryData>'||chr(13)||chr(10));
            end if;
            dbms_lob.WriteAppend(Il01I1, length('</pkg:part>'||chr(13)||chr(10)), '</pkg:part>'||chr(13)||chr(10));
          end if;
        end if;
        
        
      end loop;
      OIlI11 := rtrim(OIlI11, ':');
      dbms_lob.WriteAppend(Il01I1, length('</pkg:package>'), '</pkg:package>');
    end if;

    RETURN Il01I1;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OOXML2FlatOPC (BLOB ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END OOXML2FlatOPC;

$if CCOMPILING.g_utl_file_privilege $then  
  
  procedure OOXML2FlatOPC(
    p_OOXMLDir  varchar2,
    p_OOXMLFile varchar2,
    p_FlatOPCDir  varchar2,
    p_FlatOPCFile varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding    varchar2 := null
  ) AS
  lll11I CLOB;
  l_FlatOPCDir  varchar2(400);
  l_FlatOPCFile varchar2(400);
  Oll011 varchar2(4000);
  Oll0ll varchar2(5);
  BEGIN
    Oll0ll := upper(substr(p_OOXMLFile, nullif( instr(p_OOXMLFile,'.', -1) +1, 1) ));
    l_FlatOPCDir := nvl(p_FlatOPCDir, p_OOXMLDir);
    l_FlatOPCFile := nvl(p_FlatOPCFile, p_OOXMLFile||'.xml');
    lll11I := OOXML2FlatOPC(pak_blob_util.GetBlob(p_OOXMLDir, p_OOXMLFile),Oll0ll, Oll011, p_unzip_embeedeings, p_encoding);
    ZIP_UTIL_PKG.save_blob_to_file(l_FlatOPCDir, l_FlatOPCFile, pak_blob_util.Clob2Blob(lll11I, p_encoding));
    dbms_lob.freetemporary(lll11I);
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OOXML2FlatOPC (file ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END OOXML2FlatOPC;
$end

  


  function Ill011(
    IlIlll  OlIl0l,
    lll000       OlIl0l
  )
  return CLOB
  as
  Il01I1 CLOB;
  lll01I varchar2(4000);
  IlIll0 varchar2(256);
  lll010 varchar2(4000);
  ll01I1 number;
  begin
    dbms_lob.CreateTemporary(Il01I1, false);
    dbms_lob.WriteAppend(Il01I1, length(llIl10), llIl10);
    lll010 := '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">';
    dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);

    IlIll0 := IlIlll.FIRST;
    while IlIll0 is not null loop
      lll010 := '<Default Extension="'||IlIll0||'" ContentType="'||IlIlll(IlIll0)||'"/>';
      dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);
      IlIll0 := IlIlll.NEXT(IlIll0);
    end loop;

    IlIll0 := lll000.FIRST;
    while IlIll0 is not null loop
      lll010 := '<Override PartName="'||IlIll0||'" ContentType="'||lll000(IlIll0)||'"/>';
      dbms_lob.WriteAppend(Il01I1, length(lll010), lll010);
      IlIll0 := lll000.NEXT(IlIll0);
    end loop;

    dbms_lob.WriteAppend(Il01I1, length('</Types>'), '</Types>');
    return Il01I1;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'i1lIlII11.Ill011'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end Ill011;




  function Oll01I(
    Ill01l IlIl0l,
    lll01l varchar2
  )
  return boolean
  as
  begin
    for ll01I1 in 1..Ill01l.count loop
      if Ill01l(ll01I1) = lll01l then
        return true;
      end if;
    end loop;
    return false;
  end;


  procedure Oll0I0(
    p_zipped_blob in out blob
    ,p_filename        IN varchar2
    ,Ill0I0 IN OUT IlIl0l
  )
  as
  IlIII1 varchar2(400);
  lll0I1 varchar2(400);
  ll01I1 integer := 1;
  Oll0I1 integer;

  begin
    IlIII1 := ltrim(p_filename,'/');
    loop
      Oll0I1 := instr(IlIII1,'/', 1, ll01I1);
      exit when nvl(Oll0I1, 0) = 0;
      lll0I1 := substr(IlIII1, 1, Oll0I1);
      if not Oll01I(Ill0I0, lll0I1) then
        Ill0I0.extend;
        Ill0I0(Ill0I0.count) := lll0I1;
        zip_util_pkg.add_folder(p_zipped_blob, lll0I1);
      end if;
      ll01I1:=ll01I1+1;
    end loop;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'i1lIlII11.Oll0I0'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end;


  procedure Ill0II(
    p_FlatOPC IN OUT NOCOPY CLOB
  )
  as
  lll0II number;
  Oll0I1 number;
  Oll0Il varchar2(400);
  begin
    if nvl(dbms_lob.instr(p_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'), 0) = 0 then
      lll0II := dbms_lob.instr(p_FlatOPC, '<pkg:package>');
      if nvl(lll0II, 0) = 0 then
        pak_xslt_log.WriteLog
           ( p_description => 'Cannot find pkg:package element'
           , p_log_type    => pak_xslt_log.g_error
           , p_procedure   => 'i1lIlII11.AddPackageNamespace'
           );
        return;
      end if;
      pak_blob_util.ClobReplace(p_FlatOPC, lll0II, lll0II+length('<pkg:package>')-1,
      '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">');
    end if;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'i1lIlII11.AddPackageNamespace'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end;


  Procedure Ill0Il(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  lll0l0 SYS.XMLType;
  Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
  Ill0l1 DBMS_XMLDOM.DOMNODELIST;
  lll0l1 DBMS_XMLDOM.DOMNODE;
  Oll0lI DBMS_XMLDOM.DOMNODE;
  Ill0lI DBMS_XMLDOM.DOMNODE;
  lll0ll DBMS_XMLDOM.DOMNODE;
  IlIII1 varchar2(400);
  Oll0ll varchar2(5);
  Ill100 varchar2(400);
  lll100 number default 1;
  Oll101 number;
  Ill101 number default 1;
  lll10I number;
  Ill010 varchar2(400);
  Oll00l  OlIl0l;
  lll00l       OlIl0l;
  Oll000 varchar2(5);
  Oll10I varchar2(400);
  IlII1l CLOB;
  Ol0l11 CLOB;
  

  BEGIN
    lll0l0 := XMLType(p_FlatOPC);

    if lll0l0.getRootElement() = 'package'
      and lll0l0.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      Ill0l1 := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(lll0l0), 'part');

      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);

        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');
        Ill010 := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'contentType'));

        if (IlIII1 like 'word/embeddings/%.xlsx' and Ill010='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (IlIII1 like 'xl/embeddings/%.docx' and Ill010='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
          Oll0lI := DBMS_XMLDOM.GETFIRSTCHILD(lll0l1);
          Oll10I := DBMS_XMLDOM.GETNODENAME(Oll0lI);
          if Oll10I = 'pkg:xmlData' then
            dbms_lob.CreateTemporary(IlII1l, false);
            dbms_lob.CreateTemporary(Ol0l11, false);
            Ill100 := GetProcessingInstruction(upper(substr(IlIII1, instr(IlIII1,'.',-1, 1) + 1)));

            
            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||IlIII1||'"');
            exit when nvl(lll100, 0) = 0;

            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:xmlData>', lll100);
            exit when nvl(lll100, 0) = 0;
            Ill101 := lll100 + length('<pkg:xmlData>');

            lll10I := dbms_lob.instr(p_FlatOPC, '</pkg:package>', Ill101);
            exit when nvl(lll10I, 0) = 0;
            lll10I := lll10I + length('</pkg:package>');

            Oll101 := dbms_lob.instr(p_FlatOPC, '</pkg:xmlData>', lll10I);
            exit when nvl(Oll101, 0) = 0;
            Oll101 := Oll101 + length('</pkg:xmlData>');

            
            dbms_lob.writeappend(IlII1l, length(Ill100), Ill100);
            dbms_lob.copy(IlII1l, p_FlatOPC, lll10I - Ill101, dbms_lob.getlength(IlII1l) +1, Ill101);


            
            dbms_lob.trim(Ol0l11, 0);
            dbms_lob.writeappend(Ol0l11, length('<pkg:binaryData>'),'<pkg:binaryData>');
            Ill0II(IlII1l);
            dbms_lob.append(Ol0l11, pak_blob_util.base64_encode(FlatOPC2OOXML(IlII1l)));
            dbms_lob.writeappend(Ol0l11, length('</pkg:binaryData>'), '</pkg:binaryData>');

            
            
            pak_blob_util.ClobReplace(p_FlatOPC, lll100, Oll101 - 1, Ol0l11);

            
            
            
            dbms_lob.FreeTemporary(Ol0l11);
            dbms_lob.FreeTemporary(IlII1l);
          end if;
        end if;
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.OIlIII'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OIlIII'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end Ill0Il;

  
  Procedure OIlIII(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  lll0l0 SYS.XMLType;
  
  IlIII1 varchar2(400);
  Oll0ll varchar2(5);
  Ill100 varchar2(400);
  lll100 number default 1;
  Oll101 number;
  Ill101 number default 1;
  lll10I number;
  Ill010 varchar2(400);
  Oll00l  OlIl0l;
  lll00l       OlIl0l;
  Oll000 varchar2(5);
  Oll10I varchar2(400);
  IlII1l CLOB;
  Ol0l11 CLOB;
  Ill10l number default 1;
  

  BEGIN
    if dbms_lob.instr(p_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">') < 200
    then
      loop
        Ill10l := dbms_lob.instr(p_FlatOPC, '<pkg:part ', Ill10l);
        exit when nvl(Ill10l, 0) = 0;

         
        IlIII1 := OIlI1l(p_FlatOPC, Ill10l, 'pkg:name');
        exit when IlIII1 is null;

        Ill010 := OIlI1l(p_FlatOPC, Ill10l, 'pkg:contentType');
        exit when Ill010 is null;

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||IlIII1
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'i1lIlII11.OIlIII'
         );

        if (IlIII1 like 'word/embeddings/%.xlsx' and Ill010='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (IlIII1 like 'xl/embeddings/%.docx' and Ill010='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
            
            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||IlIII1||'"');
            exit when nvl(lll100, 0) = 0;
            Ill10l := lll100 + length('<pkg:part pkg:name="/'||IlIII1||'"');

            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:xmlData>', lll100);
            exit when nvl(lll100, 0) = 0 or lll100 - Ill10l > 100;
            Ill101 := lll100 + length('<pkg:xmlData>');

            lll10I := dbms_lob.instr(p_FlatOPC, '</pkg:package>', Ill101);
            exit when nvl(lll10I, 0) = 0;
            lll10I := lll10I + length('</pkg:package>');

            Oll101 := dbms_lob.instr(p_FlatOPC, '</pkg:xmlData>', lll10I);
            exit when nvl(Oll101, 0) = 0;
            Oll101 := Oll101 + length('</pkg:xmlData>');

            dbms_lob.CreateTemporary(IlII1l, false);
            dbms_lob.CreateTemporary(Ol0l11, false);
            Ill100 := GetProcessingInstruction(upper(substr(IlIII1, instr(IlIII1,'.',-1, 1) + 1)));

            
            dbms_lob.writeappend(IlII1l, length(Ill100), Ill100);
            dbms_lob.copy(IlII1l, p_FlatOPC, lll10I - Ill101, dbms_lob.getlength(IlII1l) +1, Ill101);

            
            dbms_lob.trim(Ol0l11, 0);
            dbms_lob.writeappend(Ol0l11, length('<pkg:binaryData>'),'<pkg:binaryData>');
            Ill0II(IlII1l);
            dbms_lob.append(Ol0l11, pak_blob_util.base64_encode(FlatOPC2OOXML(IlII1l)));
            dbms_lob.writeappend(Ol0l11, length('</pkg:binaryData>'), '</pkg:binaryData>');

            
            
            pak_blob_util.ClobReplace(p_FlatOPC, lll100, Oll101 - 1, Ol0l11);

            
            
            
            dbms_lob.FreeTemporary(Ol0l11);
            dbms_lob.FreeTemporary(IlII1l);

        end if;
        Ill10l := dbms_lob.instr(p_FlatOPC, '</pkg:part>', Ill10l);
        exit when nvl(Ill10l, 0) = 0;
        Ill10l := Ill10l + length('</pkg:part>');
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.OIlIII'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OIlIII'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end OIlIII;



  Procedure IIlIII(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  lll0l0 SYS.XMLType;
  Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
  Ill0l1 DBMS_XMLDOM.DOMNODELIST;
  lll0l1 DBMS_XMLDOM.DOMNODE;
  lll10l DBMS_XMLDOM.DOMNODE;
  
  IlIII1 varchar2(400);
  Oll0ll varchar2(5);
  
  lll100 number default 1;
  Oll101 number;
  Oll110 number default 1;
  Ill110 number;
  Ill010 varchar2(400);
  
  
  
  lll111 varchar2(400);
  Oll111 CLOB;
  Ol0l11 CLOB;
  Oll011 varchar2(4000);
  

  BEGIN
    lll0l0 := XMLType(p_FlatOPC);

    if lll0l0.getRootElement() = 'package'
      and lll0l0.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      Ill0l1 := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(lll0l0), 'part');

      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);

        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');
        Ill010 := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'contentType'));

        if (IlIII1 like 'word/embeddings/%.xlsx' and Ill010='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (IlIII1 like 'xl/embeddings/%.docx' and Ill010='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
          lll10l := DBMS_XMLDOM.GETFIRSTCHILD(lll0l1);
          lll111 := DBMS_XMLDOM.GETNODENAME(lll10l);
          if lll111 = 'pkg:binaryData' then
            
            dbms_lob.CreateTemporary(Oll111, false);
            dbms_lob.CreateTemporary(Ol0l11, false);

            
            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||IlIII1||'"');
            exit when nvl(lll100, 0) = 0;

            lll100 := dbms_lob.instr(p_FlatOPC, '<pkg:binaryData>', lll100);
            exit when nvl(lll100, 0) = 0;
            Oll110 := lll100 + length('<pkg:binaryData>');

            Ill110 := dbms_lob.instr(p_FlatOPC, '</pkg:binaryData>', Oll110);
            exit when nvl(Ill110, 0) = 0;
            

            Oll101 := Ill110 + length('</pkg:binaryData>');

            

            dbms_lob.copy(Oll111, p_FlatOPC, Ill110 - Oll110, 1, Oll110);
            
            Oll111 := OOXML2FlatOPC(
              pak_blob_util.base64_decode(Oll111),
              IIlI10 => null,
              OIlI11 => Oll011,
              p_unzip_embeedeings => false,
              p_encoding => p_encoding
            );

            dbms_lob.writeappend(Ol0l11, length('<pkg:xmlData>'), '<pkg:xmlData>');
            dbms_lob.append(Ol0l11, Oll111);
            dbms_lob.writeappend(Ol0l11, length('</pkg:xmlData>'), '</pkg:xmlData>');

            
            pak_blob_util.ClobReplace(p_FlatOPC, lll100, Oll101 - 1, Ol0l11);
            dbms_lob.FreeTemporary(Oll111);
            dbms_lob.FreeTemporary(Ol0l11);
          end if;
        end if;
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.IIlIII'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.IIlIII'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end IIlIII;



  function Ill11I(
    p_FlatOPC             IN CLOB
  ) return varchar2
  as
  lll11I SYS.XMLType;
  Ill0l1 DBMS_XMLDOM.DOMNODELIST;
  lll0l1 DBMS_XMLDOM.DOMNODE;
  Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
  IlIII1 varchar2(400);
  Il01I1 varchar2(32000);

  BEGIN
    lll11I := XMLType(p_FlatOPC);
    if lll11I.getRootElement() = 'package'
      and lll11I.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      Ill0l1 := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(lll11I))));

      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);
        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');

        if Il01I1 is null then
          Il01I1 := IlIII1;
        else
          Il01I1 := Il01I1||':'||IlIII1;
        end if;
      end loop;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.Ill11I'
       );
    end if;
    return Il01I1;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description       => 'Error'
         , p_log_type      => pak_xslt_log.g_error
         , p_procedure  => 'i1lIlII11.Ill11I'
         , P_SQLERRM   =>  sqlerrm
         );
      raise;
  END Ill11I;



  function MergeFlatOPC(
    p_FlatOPC             IN CLOB,
    p_second_FlatOPC      IN CLOB,
    p_encoding            varchar2 default null
  ) return CLOB
  as
  Il01I1 CLOB;
  Oll11l SYS.XMLType;
  Ill0l1 DBMS_XMLDOM.DOMNODELIST;
  lll0l1 DBMS_XMLDOM.DOMNODE;
  Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
  IlIII1 varchar2(400);
  Ill11l varchar2(400);
  lll1I0 DBMS_XMLDOM.DOMNODE;
  Oll1I0  DBMS_XMLDOM.DOMDOCUMENT;

  BEGIN
    Oll1I0 := DBMS_XMLDOM.NEWDOMDOCUMENT(p_flatOPC);
    lll1I0 := DBMS_XMLDOM.GETLASTCHILD(DBMS_XMLDOM.MAKENODE(Oll1I0));
    Ill11l := Ill11I(p_flatOPC);
    Oll11l := XMLType(p_second_FlatOPC);
    dbms_lob.CreateTemporary(Il01I1, false);
    if Oll11l.getRootElement() = 'package'
      and Oll11l.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      Ill0l1 := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(Oll11l))));
      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);
        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||IlIII1
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'i1lIlII11.MergeFlatOPC'
         );

        if Ill11l is null or nvl(instr(Ill11l, ':'||IlIII1||':'),0) = 0 then

          pak_xslt_log.WriteLog
           ( p_description => 'Start append child '||IlIII1
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.MergeFlatOPC'
           );

          lll0l1 := DBMS_XMLDOM.IMPORTNODE(Oll1I0, lll0l1, deep => true);
          lll0l1 := DBMS_XMLDOM.APPENDCHILD(lll1I0, lll0l1);

          pak_xslt_log.WriteLog
           ( p_description => 'Finish append child '||IlIII1
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.MergeFlatOPC'
           );
        end if;

        pak_xslt_log.WriteLog
        ( p_description => 'File '||IlIII1||' processed '
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'i1lIlII11.MergeFlatOPC'
        );
      end loop;
      DBMS_XMLDOM.WRITETOCLOB(Oll1I0, Il01I1);
      return Il01I1;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.MergeFlatOPC'
       );
       dbms_lob.FreeTemporary(Il01I1);
      return p_FlatOPC;
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.MergeFlatOPC'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END MergeFlatOPC;

$if CCOMPILING.g_utl_file_privilege $then  

  procedure MergeFlatOPC(
    p_FlatOPCDir              varchar2,
    p_FlatOPCFile             varchar2,
    p_second_FlatOPCDir       varchar2,
    p_second_FlatOPCFile      varchar2,
    p_merged_FlatOPCDir       varchar2,
    p_merged_FlatOPCFile      varchar2,
    p_encoding                varchar2 default null
  )
  as
  Ill1I1  CLOB;
  lll11I         CLOB;
  Oll11l  CLOB;
  begin
    lll11I := pak_blob_util.Read2CLOB(p_FlatOPCDir, p_FlatOPCFile, p_encoding);
    Oll11l := pak_blob_util.Read2CLOB(p_second_FlatOPCDir, p_second_FlatOPCFile, p_encoding);
    Ill1I1 := MergeFlatOPC(lll11I, Oll11l, p_encoding);
    dbms_xslprocessor.clob2file(Ill1I1, p_merged_FlatOPCDir, p_merged_FlatOPCFile, nvl(NLS_CHARSET_ID(p_encoding), 0));
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.MergeFlatOPC (file ver.)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end;
$end

  procedure lll1I1(
    Oll1II                 IN OUT NOCOPY BLOB,
    pio_FlatOPC               IN OUT NOCOPY CLOB,
    Ill1II IN OUT OlIl0l,
    lll1Il      IN OUT OlIl0l,
    Ill0I0       IN OUT IlIl0l,
    Oll1Il           IN OUT IlIl0l,
    Ill1l0               boolean,
    p_encoding                varchar2 default null
  )
  as
  lll0l0 SYS.XMLType;
  Ill0l1 DBMS_XMLDOM.DOMNODELIST;
  lll0l1 DBMS_XMLDOM.DOMNODE;
  lll1l0 DBMS_XMLDOM.DOMNODE;
  Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
  IlIII1 varchar2(400);
  lll100 number default 1;
  Oll101 number;
  Ill010 varchar2(400);
  Oll000 varchar2(5);
  Oll1l1 varchar2(400);
  IlII1l CLOB;
  Ill1l1 CLOB;
  lll1lI boolean := false;
  Oll1lI varchar2(400);

  BEGIN
    
    if Ill0I0 is null then
      Ill0I0 := IlIl0l();
    end if;

    if Oll1Il is null then
      Oll1Il := IlIl0l();
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-extensionContentTypes: '||llIl11(Ill1II)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-fileContentTypes: '||llIl11(lll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-existingFolders: '||OlIl10(Ill0I0)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-nonXMLFiles: '||OlIl10(Oll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    OIlIII(pio_FlatOPC, p_encoding);
    lll0l0 := XMLType(pio_FlatOPC);
    
    if lll0l0.getRootElement() = 'package'
      and lll0l0.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      
      
      Ill0l1 := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(lll0l0))));
      dbms_lob.CreateTemporary(Ill1l1, false);
      dbms_lob.CreateTemporary(IlII1l, false);
      
      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);

         
        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');

        if IlIII1 is not null then 
          Ill010 := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'contentType'));

          pak_xslt_log.WriteLog
           ( p_description => 'Start processing file '||IlIII1
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlI1I'
           );

          
          Oll0I0(Oll1II, IlIII1, Ill0I0);
          lll1lI := false;

          
          if substr(IlIII1, length(IlIII1)-3) = '.xml' and substr(Ill010, length(Ill010)-3) = '+xml' then
            if lll1Il.exists(IlIII1) then 
              lll1lI := true;
            else
              lll1Il(IlIII1) := Ill010; 
            end if;
          else 
            Oll000 := substr(IlIII1, nullif( instr(IlIII1,'.', -1) +1, 1) );
            if Oll000 is not null and not Ill1II.exists(Oll000) then
              Ill1II(Oll000) := Ill010;
            end if;
            
            if Oll01I(Oll1Il, IlIII1) then
              lll1lI := true;
            else
              Oll1Il.extend;
              Oll1Il(Oll1Il.count) := IlIII1;
            end if;
          end if;

          lll1l0 := DBMS_XMLDOM.GETFIRSTCHILD(lll0l1); 
          Oll1l1 := DBMS_XMLDOM.GETNODENAME(lll1l0);

          if Oll1l1 = 'pkg:xmlData' then
            lll100 := dbms_lob.instr(pio_FlatOPC, '<pkg:xmlData>', lll100);
            exit when nvl(lll100, 0) = 0;
            lll100 := lll100 + length('<pkg:xmlData>');
            lll100 := dbms_lob.instr(pio_FlatOPC, '<', lll100);
            exit when nvl(lll100, 0) = 0;
            Oll101 := dbms_lob.instr(pio_FlatOPC, '</pkg:xmlData>', lll100);
            exit when nvl(Oll101, 0) = 0;

            if not lll1lI then
              dbms_lob.Trim(IlII1l, 0);
              dbms_lob.WriteAppend(IlII1l, length(llIl10), llIl10);
              dbms_lob.Copy(IlII1l, pio_FlatOPC, Oll101-lll100, dbms_lob.getlength(IlII1l)+1, lll100);
              zip_util_pkg.add_file(Oll1II, IlIII1, pak_blob_util.Clob2Blob(IlII1l, p_encoding));
              Oll1lI:='FlatOPC offset '||lll100||' - '||Oll101;
            end if;
            lll100 := Oll101 + length('</pkg:xmlData>');
          elsif Oll1l1 = 'pkg:binaryData' then
            
            if not lll1lI then
              dbms_lob.Trim(Ill1l1, 0);
              DBMS_XMLDOM.WRITETOCLOB(DBMS_XMLDOM.GETFIRSTCHILD(lll1l0), Ill1l1);
              zip_util_pkg.add_file(Oll1II, IlIII1, pak_blob_util.base64_decode(Ill1l1));
              Oll1lI:='Binary part';
            end if;
          end if;
          if lll1lI then
            pak_xslt_log.WriteLog
             ( p_description => 'File '||IlIII1||' skipped '
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'i1lIlII11.IIlI1I'
             );
          else
            pak_xslt_log.WriteLog
             ( p_description => 'File '||IlIII1||' processed. '||Oll1lI
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'i1lIlII11.IIlI1I'
             );
          end if;
        end if;
      end loop;
      dbms_lob.FreeTemporary(Ill1l1);
      dbms_lob.FreeTemporary(IlII1l);

      if Ill1l0 then
        
        Ill1II('xml') := 'application/xml'; 
        zip_util_pkg.add_file(Oll1II, '[Content_Types].xml',
            pak_blob_util.Clob2Blob(Ill011(Ill1II, lll1Il), p_encoding)
        );
        zip_util_pkg.finish_zip(Oll1II);

        pak_xslt_log.WriteLog
           ( p_description => 'Zip completed'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlI1I'
           );
      end if;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.IIlI1I'
       );
      Oll1II := pak_blob_util.Clob2Blob(pio_FlatOPC, p_encoding);
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-extensionContentTypes: '||llIl11(Ill1II)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-fileContentTypes: '||llIl11(lll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-existingFolders: '||OlIl10(Ill0I0)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-nonXMLFiles: '||OlIl10(Oll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.IIlI1I'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END lll1I1;

  function OIlI1l(p_Xml CLOB, IIlI1l number, OIlII0 varchar2)
  return varchar2
  as
  Ill1ll number;
  lll1ll number;
  Il01I1 varchar2(4000);
  begin
    Ill1ll := dbms_lob.instr(p_Xml, OIlII0||'="', IIlI1l);
    if Ill1ll > 0 then
      Ill1ll := Ill1ll + length(OIlII0||'="');
      lll1ll := dbms_lob.instr(p_Xml, '"', Ill1ll);
      if lll1ll > 0 then
        Il01I1 := dbms_lob.substr(p_Xml, lll1ll - Ill1ll, Ill1ll);
      end if;
    end if;

    return Il01I1;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.OIlI1l'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end OIlI1l;

  procedure IIlI1I(
    Oll1II                 IN OUT NOCOPY BLOB,
    pio_FlatOPC               IN OUT NOCOPY CLOB,
    Ill1II IN OUT OlIl0l,
    lll1Il      IN OUT OlIl0l,
    Ill0I0       IN OUT IlIl0l,
    Oll1Il           IN OUT IlIl0l,
    Ill1l0               boolean,
    p_encoding                varchar2 default null
  )
  as
  
  
  lll0l1 varchar2(4000);
  lll1l0 CLOB;
  
  IlIII1 varchar2(400);
  Ill10l number default 1;

  lll100 number default 1;
  Oll101 number;
  OllI00 number default 1;
  IllI00 number;

  Ill010 varchar2(400);
  Oll000 varchar2(5);
  Oll1l1 varchar2(400);
  lllI01 number;
  OllI01 number;
  IlII1l CLOB;
  Ill1l1 CLOB;
  lll1lI boolean := false;
  Oll1lI varchar2(400);

  BEGIN
    
    if Ill0I0 is null then
      Ill0I0 := IlIl0l();
    end if;

    if Oll1Il is null then
      Oll1Il := IlIl0l();
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-extensionContentTypes: '||llIl11(Ill1II)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-fileContentTypes: '||llIl11(lll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-existingFolders: '||OlIl10(Ill0I0)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-nonXMLFiles: '||OlIl10(Oll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    OIlIII(pio_FlatOPC, p_encoding);
    
    
    if dbms_lob.instr(pio_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">') < 200
    then
      
      
      
      dbms_lob.CreateTemporary(Ill1l1, false);
      dbms_lob.CreateTemporary(IlII1l, false);
      
      
      loop
        Ill10l := dbms_lob.instr(pio_FlatOPC, '<pkg:part ', Ill10l);
        exit when nvl(Ill10l, 0) = 0;

         
        IlIII1 := OIlI1l(pio_FlatOPC, Ill10l, 'pkg:name');
        exit when IlIII1 is null;

        Ill010 := OIlI1l(pio_FlatOPC, Ill10l, 'pkg:contentType');
        exit when Ill010 is null;

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||IlIII1
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'i1lIlII11.IIlI1I'
         );

        
        Oll0I0(Oll1II, IlIII1, Ill0I0);
        lll1lI := false;

        
        if substr(IlIII1, length(IlIII1)-3) = '.xml' and substr(Ill010, length(Ill010)-3) = '+xml' then
          if lll1Il.exists(IlIII1) then 
            lll1lI := true;

            pak_xslt_log.WriteLog
             ( p_description => 'Skip file '||IlIII1
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'i1lIlII11.IIlI1I'
             );
          else
            pak_xslt_log.WriteLog
             ( p_description => 'Include file '||IlIII1
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'i1lIlII11.IIlI1I'
             );
            lll1Il(IlIII1) := Ill010; 
          end if;
        else 
          Oll000 := substr(IlIII1, nullif( instr(IlIII1,'.', -1) +1, 1) );
          if Oll000 is not null and not Ill1II.exists(Oll000) then
            Ill1II(Oll000) := Ill010;
          end if;
          
          if Oll01I(Oll1Il, IlIII1) then
            lll1lI := true;
          else
            Oll1Il.extend;
            Oll1Il(Oll1Il.count) := IlIII1;
          end if;
        end if;

        
        

        lll100 := nvl(dbms_lob.instr(pio_FlatOPC, '<pkg:xmlData>', Ill10l), 0);
        OllI00 := nvl(dbms_lob.instr(pio_FlatOPC, '<pkg:binaryData>', Ill10l), 0);

        if lll100 > 0 and (lll100 < OllI00 or OllI00 = 0) then
          
          
          lll100 := lll100 + length('<pkg:xmlData>');
          lll100 := dbms_lob.instr(pio_FlatOPC, '<', lll100);
          exit when nvl(lll100, 0) = 0;
          Oll101 := dbms_lob.instr(pio_FlatOPC, '</pkg:xmlData>', lll100);
          exit when nvl(Oll101, 0) = 0;

          if not lll1lI then
            dbms_lob.Trim(IlII1l, 0);
            dbms_lob.WriteAppend(IlII1l, length(llIl10), llIl10);
            dbms_lob.Copy(IlII1l, pio_FlatOPC, Oll101-lll100, dbms_lob.getlength(IlII1l)+1, lll100);
            zip_util_pkg.add_file(Oll1II, ltrim(IlIII1,'/'), pak_blob_util.Clob2Blob(IlII1l, p_encoding));
            Oll1lI:='FlatOPC offset '||lll100||' - '||Oll101;
          end if;
          lll100 := Oll101 + length('</pkg:xmlData>');
        elsif OllI00 > 0 and (OllI00 < lll100 or lll100 = 0) then
          
          OllI00 := OllI00 + length('<pkg:binaryData>');
          OllI00 := dbms_lob.instr(pio_FlatOPC, '<', OllI00);
          exit when nvl(OllI00, 0) = 0;
          IllI00 := dbms_lob.instr(pio_FlatOPC, '</pkg:binaryData>', OllI00);
          exit when nvl(OllI00, 0) = 0;
          if not lll1lI then
            
            dbms_lob.Trim(Ill1l1, 0);
            
            dbms_lob.Copy(Ill1l1, pio_FlatOPC, IllI00-OllI00, dbms_lob.getlength(Ill1l1)+1, OllI00);
            zip_util_pkg.add_file(Oll1II, ltrim(IlIII1,'/'), pak_blob_util.base64_decode(Ill1l1));
            Oll1lI:='Binary part';
          end if;
        end if;
        if lll1lI then
          pak_xslt_log.WriteLog
           ( p_description => 'File '||IlIII1||' skipped '
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlI1I'
           );
        else
          pak_xslt_log.WriteLog
           ( p_description => 'File '||IlIII1||' processed. '||Oll1lI
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlI1I'
           );
        end if;
        Ill10l := dbms_lob.instr(pio_FlatOPC, '</pkg:part>', Ill10l);
        exit when nvl(Ill10l, 0) = 0;
        Ill10l := Ill10l + length('</pkg:part>');
      end loop;
      dbms_lob.FreeTemporary(Ill1l1);
      dbms_lob.FreeTemporary(IlII1l);

      if Ill1l0 then
        
        Ill1II('xml') := 'application/xml'; 
        zip_util_pkg.add_file(Oll1II, '[Content_Types].xml',
            pak_blob_util.Clob2Blob(Ill011(Ill1II, lll1Il), p_encoding)
        );
        zip_util_pkg.finish_zip(Oll1II);

        pak_xslt_log.WriteLog
           ( p_description => 'Zip completed'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlI1I'
           );
      end if;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'i1lIlII11.IIlI1I'
       );
      Oll1II := pak_blob_util.Clob2Blob(pio_FlatOPC, p_encoding);
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-extensionContentTypes: '||llIl11(Ill1II)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-fileContentTypes: '||llIl11(lll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-existingFolders: '||OlIl10(Ill0I0)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-nonXMLFiles: '||OlIl10(Oll1Il)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'i1lIlII11.IIlI1I'
     );
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.IIlI1I'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END IIlI1I;

  
  function IIlI1I(
    pio_FlatOPC IN OUT NOCOPY CLOB,
    pio_staticParts IN OUT NOCOPY CLOB,
    p_encoding varchar2 default null
  )
  return BLOB AS

  Il01I1 BLOB;
  Oll00l  OlIl0l;
  lll00l       OlIl0l;
  IllI0I IlIl0l := IlIl0l();
  lllI0I     IlIl0l := IlIl0l();
  BEGIN
    if pio_staticParts is not null then
      
      IIlI1I(
        Il01I1,
        pio_FlatOPC,
        Oll00l,
        lll00l,
        IllI0I,
        lllI0I,
        Ill1l0 => false,
        p_encoding => p_encoding
      );

      IIlI1I(
        Il01I1,
        pio_staticParts,
        Oll00l,
        lll00l,
        IllI0I,
        lllI0I,
        Ill1l0 => true,
        p_encoding => p_encoding
      );
    else 
      IIlI1I(
        Il01I1,
        pio_FlatOPC,
        Oll00l,
        lll00l,
        IllI0I,
        lllI0I,
        Ill1l0 => true,
        p_encoding => p_encoding
      );
    end if;

    
    

  RETURN Il01I1;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.IIlI1I(BLOB ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END IIlI1I;


  
  function FlatOPC2OOXML(
    p_FlatOPC CLOB,
    p_staticParts CLOB default null,
    p_encoding varchar2 := null
  )
  return BLOB AS
  lll11I CLOB := p_FlatOPC;
  OllI0l CLOB := p_staticParts;
  begin
    return IIlI1I(lll11I, OllI0l, p_encoding);
  end;


$if CCOMPILING.g_utl_file_privilege $then  
   
  procedure FlatOPC2OOXML(
    p_FlatOPCDir  varchar2,
    p_FlatOPCFile varchar2,
    p_OOXMLDir  varchar2 := null,
    p_OOXMLFile varchar2 := null,
    p_FlatOPCValidDir  varchar2 := null,
    p_FlatOPCValidFile varchar2 := null,
    p_staticPartsDir varchar2 := null,
    p_staticPartsFile varchar2 := null,
    p_encoding    varchar2 := null
  ) AS
  lll11I     CLOB;
  OllI0l  CLOB;
  l_OOXMLDir  varchar2(400);
  l_OOXMLFile varchar2(400);
  I100IlI BLOB;

  BEGIN
    l_OOXMLDir := nvl(p_OOXMLDir, p_FlatOPCDir);
    l_OOXMLFile := nvl(p_OOXMLFile, p_FlatOPCFile||'.zip');
    lll11I := pak_blob_util.Read2CLOB(p_FlatOPCDir, p_FlatOPCFile, p_encoding);

    if p_staticPartsDir is not null and p_staticPartsFile is not null then
      OllI0l := pak_blob_util.Read2CLOB(p_staticPartsDir, p_staticPartsFile, p_encoding);
    end if;

    I100IlI := IIlI1I(lll11I, OllI0l,  p_encoding);
    ZIP_UTIL_PKG.save_blob_to_file (l_OOXMLDir, l_OOXMLFile, FlatOPC2OOXML(lll11I, p_encoding));

    if p_FlatOPCValidDir is not null and p_FlatOPCValidFile is not null then
      lll11I := MergeFlatOPC(lll11I, OllI0l, p_encoding);
      ZIP_UTIL_PKG.save_blob_to_file (p_FlatOPCValidDir, p_FlatOPCValidFile, pak_blob_util.Clob2Blob(lll11I, p_encoding));
    end if;
    dbms_lob.freetemporary(lll11I);
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.FlatOPC2OOXML (file ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END FlatOPC2OOXML;
$end

  
  procedure IIlII1(
    pio_FlatOPC IN OUT CLOB,
    p_partsToTransform varchar2
  )
  as
    Ill0l1 DBMS_XMLDOM.DOMNODELIST;
    lll0l1 DBMS_XMLDOM.DOMNODE;
    IllI0l DBMS_XMLDOM.DOMNODE;
    Oll0l0 DBMS_XMLDOM.DOMNAMEDNODEMAP;
    lllI10 DBMS_XMLDOM.DOMDOCUMENT;
    IlIII1 varchar2(400);

    lll0l0 SYS.XMLType;
  begin
    
    lll0l0 := XMLType(pio_FlatOPC);
       
    if lll0l0.getRootElement() = 'package'
      and lll0l0.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      lllI10 := DBMS_XMLDOM.NEWDOMDOCUMENT(lll0l0);
      
      Ill0l1 := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(lllI10)));
      
      
      for ll01I1 in 0..DBMS_XMLDOM.GETLENGTH(Ill0l1)-1 loop
        lll0l1 := DBMS_XMLDOM.ITEM(Ill0l1, ll01I1);

        Oll0l0 := DBMS_XMLDOM.GETATTRIBUTES(lll0l1);
        IlIII1 := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(Oll0l0, 'name')),'/');

        if  nvl(instr(':'||p_partsToTransform||':', ':'||IlIII1||':'), 0)=0 then
          IllI0l := DBMS_XMLDOM.REMOVECHILD(DBMS_XMLDOM.MAKENODE(lllI10), lll0l1);
          pak_xslt_log.WriteLog
           ( p_description => 'Deleting part '||IlIII1
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlII1'
           );
        else
          pak_xslt_log.WriteLog
           ( p_description => 'Part '||IlIII1||' left in OPC'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'i1lIlII11.IIlII1'
           );
        end if;
      end loop;
      dbms_lob.trim(pio_FlatOPC, 0);
      DBMS_XMLDOM.WRITETOCLOB(DBMS_XMLDOM.MAKENODE(lllI10), pio_FlatOPC);
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'i1lIlII11.IIlII1'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end IIlII1;

END "i1lIlII11";

/
