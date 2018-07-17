--------------------------------------------------------
--  DDL for Package PAK_XPM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_XPM" AS 
  g_dwld_xml          constant integer := 0;
  g_dwld_output       constant integer := 1;
  g_dwld_template     constant integer := 2;
  g_dwld_mx_template  constant integer := 3;
  
  procedure XSLTFromTemplate(
    p_id_project number, 
    p_on_demand boolean default false);
  
  procedure Download(p_id_project number, 
    p_dwld_type number,
    p_match_templates varchar2 default null,
    p_name_templates varchar2 default null,
    p_xml_procinstr varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||Query2Report.g_crlf,
    p_replace_otag varchar2 default '&lt;',
    p_replace_ctag varchar2 default '&gt;'
  );  
  
  procedure SaveAsXML(p_id_project number);
  
  function LoggedUserIsDeveloper
  return boolean;
  
  function CanRefreshStaticFile(p_fname varchar2)
  return boolean;
  
  procedure RefreshXSLTStaticFile(p_id_project number, p_app_id number);
  
  procedure InsertXSLTIntoStaticFiles(p_id_project number, p_app_id number);
  
  procedure RefreshFlatOPCStaticFile(p_id_project number, p_app_id number);
  
  procedure InsertFlatOPCIntoStaticFiles(p_id_project number, p_app_id number);
  
  function GetTemplateMatchesLOV(p_id_project number)
  return varchar2;
  
  function GetTemplateNamesLOV(p_id_project number)
  return varchar2;
  
  function GetTemplateNamesTable(p_id_project number)
  return t_string_table;
  
  function GetTemplateMatchesTable(p_id_project number)
  return t_string_table;
  
  procedure FlatOPCFromTemplate(p_id_project number); 
  
  procedure FlatOPCTransfromedOnly(
    p_id_project number, 
    p_partsToTransform varchar2
  );
END PAK_XPM;

/
