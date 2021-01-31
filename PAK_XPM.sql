--------------------------------------------------------
--  DDL for Package PAK_XPM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_XPM" AS 
  
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
