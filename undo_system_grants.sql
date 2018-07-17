declare PARSING_SCHEMA VARCHAR2(30) := :PARSING_SCHEMA;
l_apex_version VARCHAR2(6);

begin
  SELECT '0'||substr(version_no, 1, instr(version_no, '.', 1, 1)-1) ||
  '0'||substr(version_no, instr(version_no, '.', 1, 1)+1, instr(version_no, '.', 1, 2)-instr(version_no, '.', 1, 1)-1)||'00' 
  INTO l_apex_version
  FROM apex_release;
  
  EXECUTE IMMEDIATE 'REVOKE SELECT on "'||'APEX_'||l_apex_version||'"."WWV_FLOW_REGION_REPORT_COLUMN" from "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'REVOKE SELECT on "'||'APEX_'||l_apex_version||'"."WWV_FLOW_WORKSHEET_COLUMNS" from "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'REVOKE SELECT on '||'APEX_'||l_apex_version||'.wwv_flow_page_plugs from "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'REVOKE CREATE JOB from "'||PARSING_SCHEMA||'"' ;
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_LOB                  FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_SQL                  FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_UTILITY              FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on DBMS_XMLDOM               FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_XMLGEN               FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on DBMS_XSLPROCESSOR         FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_OBFUSCATION_TOOLKIT  FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.DBMS_SCHEDULER            FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.UTL_FILE                  FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.UTL_RAW                   FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.UTL_COMPRESS              FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.UTL_I18N                  FROM "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'REVOKE execute on SYS.UTL_ENCODE                FROM "'||PARSING_SCHEMA||'"';
end;
/