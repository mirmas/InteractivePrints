declare PARSING_SCHEMA VARCHAR2(30) := :PARSING_SCHEMA;
l_apex_version VARCHAR2(6);

begin
  SELECT '0'||substr(version_no, 1, instr(version_no, '.', 1, 1)-1) ||
  '0'||substr(version_no, instr(version_no, '.', 1, 1)+1, instr(version_no, '.', 1, 2)-instr(version_no, '.', 1, 1)-1)||'00' 
  INTO l_apex_version
  FROM apex_release;
  
  EXECUTE IMMEDIATE 'GRANT SELECT on "'||'APEX_'||l_apex_version||'"."WWV_FLOW_REGION_REPORT_COLUMN" to "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'GRANT SELECT on "'||'APEX_'||l_apex_version||'"."WWV_FLOW_WORKSHEET_COLUMNS" to "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'GRANT SELECT on '||'APEX_'||l_apex_version||'.wwv_flow_page_plugs to "'||PARSING_SCHEMA||'"'; 
  EXECUTE IMMEDIATE 'GRANT CREATE JOB TO "'||PARSING_SCHEMA||'"' ;
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_LOB                  TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_SQL                  TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_UTILITY              TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on DBMS_XMLDOM               TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_XMLGEN               TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on DBMS_XSLPROCESSOR         TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_OBFUSCATION_TOOLKIT  TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.DBMS_SCHEDULER            TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.UTL_FILE                  TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.UTL_RAW                   TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.UTL_COMPRESS              TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.UTL_I18N                  TO "'||PARSING_SCHEMA||'"';
  EXECUTE IMMEDIATE 'GRANT execute on SYS.UTL_ENCODE                TO "'||PARSING_SCHEMA||'"';
end;
/
