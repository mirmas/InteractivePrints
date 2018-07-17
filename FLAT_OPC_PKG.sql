



  CREATE OR REPLACE PACKAGE "i1lIlII11" AS




  function OOXML2FlatOPC(
    OIlI10 BLOB,
    IIlI10 varchar2,
    OIlI11 OUT varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding varchar2 := null
  )
  return CLOB;
  
$if CCOMPILING.g_utl_file_privilege $then  

  procedure OOXML2FlatOPC(
    p_OOXMLDir  varchar2,
    p_OOXMLFile varchar2,
    p_FlatOPCDir  varchar2,
    p_FlatOPCFile varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding varchar2 := null
  );
$end


  function IIlI1I(
    pio_FlatOPC IN OUT NOCOPY CLOB,
    pio_staticParts IN OUT NOCOPY CLOB,
    p_encoding varchar2 default null
  )
  return BLOB;


  function FlatOPC2OOXML(
    p_FlatOPC CLOB,
    p_staticParts CLOB default null,
    p_encoding varchar2 default null
  )
  return BLOB;

  function OIlI1l(p_Xml CLOB, IIlI1l number, OIlII0 varchar2)
  return varchar2;

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
    p_encoding varchar2 := null
  );
$end


  procedure IIlII1(
    pio_FlatOPC IN OUT CLOB,
    p_partsToTransform varchar2
  );


  function MergeFlatOPC(
    p_FlatOPC             IN CLOB,
    p_second_FlatOPC      IN CLOB,
    p_encoding            varchar2 default null
  ) return CLOB;

$if CCOMPILING.g_utl_file_privilege $then  

  procedure MergeFlatOPC(
    p_FlatOPCDir              varchar2,
    p_FlatOPCFile             varchar2,
    p_second_FlatOPCDir       varchar2,
    p_second_FlatOPCFile      varchar2,
    p_merged_FlatOPCDir       varchar2,
    p_merged_FlatOPCFile      varchar2,
    p_encoding                varchar2 default null
  ) ;
$end


Procedure OIlIII(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
);

Procedure IIlIII(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
);


END "i1lIlII11";

/
