drop table "XSLT_LOG" cascade constraints PURGE;
drop table "XSLTSWKEY" cascade constraints PURGE;

DROP SEQUENCE "XSLT_LOG_SEQ";

DROP TABLE "XPM_XML"; 
DROP SEQUENCE XPM_XML_SEQ;

DROP PACKAGE "PAK_XSLT_LOG";

drop PROCEDURE ConvertBLOB;

DROP PACKAGE "PAK_BLOB_UTIL";
DROP PACKAGE "ZIP_UTIL_PKG";
DROP PACKAGE "PAK_ZIP";
DROP PACKAGE "FLAT_OPC_PKG";
DROP PACKAGE "PAK_XSLTPROCESSOR";
drop PACKAGE "QUERY2REPORT";
drop PACKAGE "APEXREP2REPORT";
DROP PACKAGE "PAK_XSLT_REPLACESTR";
DROP PACKAGE "IG2REPORT";
DROP PACKAGE "PAK_XML_CONVERT";
DROP PACKAGE "CCOMPILING";



DROP TABLE TEMPORARY_XML;
DROP SEQUENCE TEMPORARY_XML_SEQ;

drop type t_coltype_table;
drop type t_coltype_row; 
drop type t_string_table;
drop type t_string_row; 
DROP TYPE WORD_COLOR;


declare 
l_exists NUMBER;

begin
  select count(*) into l_exists from user_objects where object_name = 'APEX_APPLICATION_PAGE_IR_COLID';
  if l_exists = 1 then
    EXECUTE IMMEDIATE 'DROP VIEW APEX_APPLICATION_PAGE_IR_COLID';
  end if;
  
  select count(*) into l_exists from user_objects where object_name = 'APEX_RPT_COLS_QUERY_ID';
  if l_exists = 1 then
    EXECUTE IMMEDIATE 'DROP VIEW APEX_RPT_COLS_QUERY_ID';
  end if;
  
  select count(*) into l_exists from user_objects where object_name = 'APEX_APPLICATION_PAGE_RPT_EX';
  if l_exists = 1 then
    EXECUTE IMMEDIATE 'DROP VIEW APEX_APPLICATION_PAGE_RPT_EX';
  end if;
  
  select count(*) into l_exists from user_scheduler_jobs where job_name = upper('job_XslTransformAndDownload');
  if l_exists = 1 then
    DBMS_SCHEDULER.DROP_JOB ('job_XslTransformAndDownload');
  end if;
  
  select count(*) into l_exists from user_scheduler_programs where program_name = upper('prog_XslTransformAndDownload');
  if l_exists = 1 then
    DBMS_SCHEDULER.DROP_PROGRAM ('prog_XslTransformAndDownload');
  end if;
  commit;
end; 
/




  
  
