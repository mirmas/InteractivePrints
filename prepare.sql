CREATE OR REPLACE VIEW ORATYPE_CODES ("ORA_TYPE", "ORA_CODE") AS 
  select   substr(trim(text), instr(trim(text),'TYPECODE_')+length('TYPECODE_'),instr(trim(text),' ')-instr(trim(text),'TYPECODE_')-length('TYPECODE_')) ora_type,
  to_number(substr(trim(text), instr(trim(text),'PLS_INTEGER := ')+length('PLS_INTEGER := '),instr(trim(text),';')-instr(trim(text),'PLS_INTEGER := ')-length('PLS_INTEGER := '))) ora_code 
  from   all_source where   owner = 'SYS' and name = 'DBMS_TYPES' and type = 'PACKAGE' and text like '%TYPECODE_%';

--------------------------------------------------------
--  DDL for Table XSLT_LOG
--------------------------------------------------------

  CREATE TABLE "XSLT_LOG" 
   (	"ID_XSLT_LOG" NUMBER, 
	"LOG_TYPE" VARCHAR2(10 BYTE), 
	"DESCRIPTION" VARCHAR2(4000 CHAR), 
	"LOG_DATE" TIMESTAMP (6) DEFAULT sysdate, 
	"DBUSER" VARCHAR2(30 BYTE) DEFAULT user, 
	"PROCEDURE" VARCHAR2(200 BYTE), 
	"ERROR_MESSAGE" VARCHAR2(1024 BYTE), 
	"APPUSER" VARCHAR2(256 BYTE), 
	"APP_ID" NUMBER, 
	"PAGE_ID" NUMBER, 
	"APEX_WORKSPACE" VARCHAR2(20 BYTE), 
	"ERR_NUM" NUMBER(10,0)
   ) ;

   COMMENT ON COLUMN "XSLT_LOG"."ID_XSLT_LOG" IS 'Primary key';
   COMMENT ON COLUMN "XSLT_LOG"."LOG_TYPE" IS 'E - error, W - warning, I - information';
   COMMENT ON COLUMN "XSLT_LOG"."DESCRIPTION" IS 'Log description';
   COMMENT ON COLUMN "XSLT_LOG"."LOG_DATE" IS 'Log date';
   COMMENT ON COLUMN "XSLT_LOG"."DBUSER" IS 'Database user';
   COMMENT ON COLUMN "XSLT_LOG"."APP_ID" IS 'Apex application ID.';
   COMMENT ON COLUMN "XSLT_LOG"."PAGE_ID" IS 'Apex Page ID.';
   COMMENT ON COLUMN "XSLT_LOG"."ERR_NUM" IS 'ORA error number';
   COMMENT ON TABLE "XSLT_LOG"  IS 'Tabel for logging errors, warnings and other events of si.mirmas.Region2XSLTReport. plugin and helper packages ApexRep2Report and Query2Report';
--------------------------------------------------------
--  DDL for Index XSLT_LOG_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "XSLT_LOG_PK" ON "XSLT_LOG" ("ID_XSLT_LOG");
--------------------------------------------------------
--  DDL for Index XSLT_LOG_LOG_DATE_X1
--------------------------------------------------------

  CREATE INDEX "XSLT_LOG_LOG_DATE_X1" ON "XSLT_LOG" ("LOG_DATE");
--------------------------------------------------------
--  Constraints for Table XSLT_LOG
--------------------------------------------------------

  ALTER TABLE "XSLT_LOG" MODIFY ("ID_XSLT_LOG" NOT NULL ENABLE);
  ALTER TABLE "XSLT_LOG" MODIFY ("LOG_TYPE" NOT NULL ENABLE);
  ALTER TABLE "XSLT_LOG" MODIFY ("LOG_DATE" NOT NULL ENABLE);
  ALTER TABLE "XSLT_LOG" MODIFY ("DBUSER" NOT NULL ENABLE);
  ALTER TABLE "XSLT_LOG" ADD CONSTRAINT "XSLT_LOG_PK" PRIMARY KEY ("ID_XSLT_LOG");
  
--------------------------------------------------------
--  DDL for Table XSLTSWKEY
--------------------------------------------------------

  
  CREATE TABLE "XSLTSWKEY" 
   (	"SWKEY" VARCHAR2(20 BYTE), 
	"CODED" VARCHAR2(4000 BYTE),
  "DBIDWSID" VARCHAR2(4000 BYTE)
   ) ;
   
  ALTER TABLE "XSLTSWKEY" MODIFY ("CODED" NOT NULL ENABLE);
  ALTER TABLE "XSLTSWKEY" MODIFY ("SWKEY" NOT NULL ENABLE);
   
CREATE SEQUENCE  "XSLT_LOG_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 1 CACHE 20 NOORDER  NOCYCLE ;

CREATE TABLE TEMPORARY_XML 
(
  ID_TEMPORARY_XML NUMBER NOT NULL 
, XMLCLOB CLOB NOT NULL 
, CONSTRAINT TEMPORARY_XML_PK PRIMARY KEY 
  (
    ID_TEMPORARY_XML 
  )
  ENABLE 
);

CREATE SEQUENCE TEMPORARY_XML_SEQ;


  create or replace trigger TEMPORARY_XML_PK_TRG
  before insert on "TEMPORARY_XML"
  for each row
  begin
    if inserting then
      if :NEW."ID_TEMPORARY_XML" is null then
        select TEMPORARY_XML_SEQ.nextval into :NEW."ID_TEMPORARY_XML" from dual; 
      end if;
    end if;
	end;
	/

CREATE OR REPLACE type "WORD_COLOR" is OBJECT(color VARCHAR(6), name VARCHAR2(20));
/

CREATE OR REPLACE TYPE "T_COLTYPE_ROW" as object (
  colname varchar2(64),
  coltype varchar2(30),
  formatmask varchar2(400),
  columnwidth number,
  fullname varchar2(200),
  position number,
  excelcol varchar2(2),
  break_on_col number,
  breakrow     number,
  value varchar2(4000),
  excelval varchar2(4000),
  aggregate varchar2(400),
  formula varchar2(400),
  highlight_name varchar2(400),
  highlight_bkg_color varchar2(6),
  highlight_font_color varchar2(6),
  format number,
  ps_format number
);
/


CREATE OR REPLACE type t_coltype_table as table of t_coltype_row;
/

CREATE OR REPLACE type t_string_row as object (col varchar2(400));
/

CREATE OR REPLACE type t_string_table as table of t_string_row;
/


--------------------------------------------------------
--  DDL for Table XPM_XML
--------------------------------------------------------
  CREATE SEQUENCE XPM_XML_SEQ;

  CREATE TABLE "XPM_XML" 
   (	"ID_XML" NUMBER, 
	"FNAME" VARCHAR2(255 BYTE), 
	"FNAME1" VARCHAR2(255 BYTE), 
	"LAST_UPDATED" DATE DEFAULT sysdate, 
	"XML_CHARSET" VARCHAR2(200 BYTE) DEFAULT 'utf-8', 
	"XMLBLOB" BLOB
   ) ;

   COMMENT ON COLUMN "XPM_XML"."XMLBLOB" IS 'BLOB representing XML.';
--------------------------------------------------------
--  DDL for Index XPM_XML_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "XPM_XML_PK" ON "XPM_XML" ("ID_XML");
--------------------------------------------------------
--  DDL for Index XPM_XML_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "XPM_XML_UK1" ON "XPM_XML" ("FNAME");
--------------------------------------------------------
--  Constraints for Table XPM_XML
--------------------------------------------------------

  ALTER TABLE "XPM_XML" MODIFY ("ID_XML" NOT NULL ENABLE);
  ALTER TABLE "XPM_XML" MODIFY ("LAST_UPDATED" NOT NULL ENABLE);
  ALTER TABLE "XPM_XML" MODIFY ("XMLBLOB" NOT NULL ENABLE);
  ALTER TABLE "XPM_XML" ADD CONSTRAINT "XPM_XML_PK" PRIMARY KEY ("ID_XML") ENABLE;
  ALTER TABLE "XPM_XML" ADD CONSTRAINT "XPM_XML_UK1" UNIQUE ("FNAME") ENABLE;
  ALTER TABLE "XPM_XML" MODIFY ("XML_CHARSET" NOT NULL ENABLE);
--------------------------------------------------------
--  DDL for Trigger XPM_XML_PK_TRG
--------------------------------------------------------

create or replace TRIGGER "XPM_XML_PK_TRG"  
   before insert or update on "XPM_XML" 
   for each row 
begin   
   if inserting then 
      if :NEW."ID_XML" is null then 
         select XPM_XML_SEQ.nextval into :NEW."ID_XML" from dual; 
      end if; 
   end if;
   if inserting or updating then 
      if :NEW."FNAME" is null then 
         :NEW."FNAME" := :NEW."FNAME1";
      end if; 
   end if; 
end;
/

ALTER TRIGGER "XPM_XML_PK_TRG" ENABLE;

declare 
l_apex_version VARCHAR2(6);
l_exists1 NUMBER;
l_exists2 NUMBER;
l_exists3 NUMBER;
l_existsIG NUMBER;
l_exists_logger NUMBER;
l_exists_utl_file NUMBER;
l_createjob NUMBER;
l_existsIGstr VARCHAR2(5);
l_views_granted VARCHAR2(5);
l_utl_file_privilege VARCHAR2(5);
l_utl_http_privilege VARCHAR2(5);
l_logger_exists VARCHAR2(5);
begin
  SELECT lpad(substr(version_no, 1, instr(version_no, '.', 1, 1)-1), 2, '0') ||
  lpad(substr(version_no, instr(version_no, '.', 1, 1)+1, instr(version_no, '.', 1, 2)-instr(version_no, '.', 1, 1)-1), 2, '0')||'00' 
  INTO l_apex_version
  FROM apex_release;
  
  select count(*) into l_exists1 from all_objects where object_name = 'WWV_FLOW_WORKSHEET_COLUMNS' and OWNER = 'APEX_'||l_apex_version;
  if l_exists1 = 1 then
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW APEX_APPLICATION_PAGE_IR_COLID AS select id column_id, column_identifier from "APEX_'||l_apex_version||'"."WWV_FLOW_WORKSHEET_COLUMNS"';
  end if;
  
  select count(*) into l_exists2 from all_objects where object_name = 'WWV_FLOW_REGION_REPORT_COLUMN' and OWNER = 'APEX_'||l_apex_version;
  if l_exists2 = 1 then
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW APEX_RPT_COLS_QUERY_ID AS select id region_report_column_id, column_alias, query_column_id, flow_id application_id, region_id from "APEX_'
    ||l_apex_version||'"."WWV_FLOW_REGION_REPORT_COLUMN"';
  end if;
  
  select count(*) into l_exists3 from all_objects where object_name = 'WWV_FLOW_PAGE_PLUGS' and OWNER = 'APEX_'||l_apex_version;
  if l_exists3 = 1 then
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW APEX_APPLICATION_PAGE_RPT_EX AS
		select
		id,
		flow_id application_id,
		page_id, 
		plug_name REGION_NAME         ,
		PRN_PAPER_SIZE								PAPER_SIZE								,                   
		PRN_ORIENTATION               ORIENTATION               ,                   
		PRN_UNITS          						PAPER_SIZE_UNITS          ,                   
		PRN_BORDER_WIDTH							BORDER_WIDTH							,                   
		PRN_BORDER_COLOR							BORDER_COLOR							,                   
		PRN_HEIGHT										HEIGHT								,                           
		PRN_WIDTH											PAPER_SIZE_WIDTH								,       
		PRN_PAGE_HEADER_FONT_COLOR 		PAGE_HEADER_FONT_COLOR 		,                   
		PRN_PAGE_HEADER_FONT_FAMILY 	PAGE_HEADER_FONT_FAMILY 	,                   
		PRN_PAGE_HEADER_FONT_SIZE 		PAGE_HEADER_FONT_SIZE 		,                   
		PRN_PAGE_HEADER_FONT_WEIGHT 	PAGE_HEADER_FONT_WEIGHT 	,                   
		PRN_PAGE_HEADER_ALIGNMENT			PAGE_HEADER_ALIGNMENT			,                   
		PRN_PAGE_HEADER								PAGE_HEADER								    ,           
		PRN_HEADER_FONT_SIZE					HEADER_FONT_SIZE					,                   
		PRN_HEADER_FONT_FAMILY				HEADER_FONT_FAMILY				,                   
		PRN_HEADER_FONT_WEIGHT				HEADER_FONT_WEIGHT				,                   
		PRN_HEADER_BG_COLOR						HEADER_BACKGROUND_COLOR						,   
		PRN_HEADER_FONT_COLOR					HEADER_FONT_COLOR					,                   
		PRN_BODY_FONT_FAMILY 					BODY_FONT_FAMILY 					,                   
		PRN_BODY_FONT_SIZE 						BODY_FONT_SIZE 						,                   
		PRN_BODY_FONT_WEIGHT 					BODY_FONT_WEIGHT 					,                   
		PRN_BODY_BG_COLOR							BODY_BACKGROUND_COLOR							,   
		PRN_BODY_FONT_COLOR						BODY_FONT_COLOR						,                   
		PRN_PAGE_FOOTER_FONT_COLOR 		FOOTER_FONT_COLOR 		,                           
		PRN_PAGE_FOOTER_FONT_FAMILY 	FOOTER_FONT_FAMILY 	,                               
		PRN_PAGE_FOOTER_FONT_SIZE 		FOOTER_FONT_SIZE 		,                               
		PRN_PAGE_FOOTER_FONT_WEIGHT 	FOOTER_FONT_WEIGHT 	,                               
		PRN_PAGE_FOOTER_ALIGNMENT			FOOTER_ALIGNMENT			,                           
		PRN_PAGE_FOOTER			          FOOTER								            
    from "APEX_'
    ||l_apex_version||'"."WWV_FLOW_PAGE_PLUGS"';
  end if;
  
  select count(*) into l_existsIG from APEX_DICTIONARY where APEX_VIEW_NAME like 'APEX_APPL_PAGE_IG_RPT%' and column_id = 0;
  if l_existsIG >= 8 then
      l_existsIGstr := 'true';
  else
      l_existsIGstr := 'false';
  end if;
  
  if l_exists1 = 1 and l_exists2 = 1 and l_exists3 = 1 then
      l_views_granted := 'true';
  else
      l_views_granted := 'false';
  end if;
  
  select count(*) into l_exists_utl_file from all_objects where owner = 'SYS' and object_name = 'UTL_FILE' and object_type = 'PACKAGE' and status = 'VALID';
  if l_exists_utl_file = 1 then
      l_utl_file_privilege := 'true';
  else
      l_utl_file_privilege := 'false';
  end if;
  
  select count(*) into l_exists_logger from all_objects where object_name = 'LOGGER' and object_type = 'PACKAGE' and status = 'VALID';
  if l_exists_logger = 1 then
      l_logger_exists := 'true';
  else
      l_logger_exists := 'false';
  end if;
    
  EXECUTE IMMEDIATE 'create or replace PACKAGE "CCOMPILING" AS 
    g_views_granted constant boolean := '||l_views_granted||'; 
    g_IG_exists constant boolean := '||l_existsIGstr||'; 
    g_utl_file_privilege constant boolean := '||l_utl_file_privilege||';
	g_logger_exists constant boolean := '||l_logger_exists||';
  END CCOMPILING;';
  
  --install job - current user must have CREATE ANY JOB privilege
  SELECT COUNT(*) INTO l_createjob FROM USER_SYS_PRIVS where PRIVILEGE = 'CREATE JOB'; 
  
  if l_createjob > 0 then
    dbms_scheduler.create_program(program_name      => 'prog_XslTransformAndDownload',
                                  program_type        => 'STORED_PROCEDURE',                                                          
                                  program_action      => 'Query2Report.XslTransformAndDownloadXMLID', 
                                  number_of_arguments => 18,
                                  enabled             => false,
                                  comments            => 'Running XslTransformAndDownload in background');
  
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_id_temporary_xml',
                                         argument_position => 1,
                                         argument_type     => 'NUMBER');
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_xsltStaticFile',
                                         argument_position => 2,
                                         argument_type     => 'VARCHAR2');                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_page_id',
                                         argument_position => 3,
                                         argument_type     => 'NUMBER');
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_region_name',
                                         argument_position => 4,
                                         argument_type     => 'VARCHAR2');
                                           
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_filename',
                                         argument_position => 5,
                                         argument_type     => 'VARCHAR2');         
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_reportTypes',
                                         argument_position => 6,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                                                                                                                                                                                    
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_regionAttrs',
                                         argument_position => 7,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                                                                                                                                     
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_mime',
                                         argument_position => 8,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => 'application/octet');
                                         
    dbms_scheduler.define_program_argument(program_name    => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_format',
                                         argument_position => 9,
                                         argument_type     => 'NUMBER',
                                         default_value     => 0);
                                         
    dbms_scheduler.define_program_argument(program_name    => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_templateStaticFile',
                                         argument_position =>  10,
                                         argument_type     => 'VARCHAR2');                                        
    
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_external_params',
                                         argument_position => 11,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_second_XsltStaticFile',
                                         argument_position => 12,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_second_external_params',
                                         argument_position => 13,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_convertblob_param',
                                         argument_position => 14,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_log_level',
                                         argument_position => 15,
                                         argument_type     => 'NUMBER',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_security_group_id',
                                         argument_position => 16,
                                         argument_type     => 'NUMBER',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_app_user',
                                         argument_position => 17,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_run_in_background',
                                         argument_position => 18,
                                         argument_type     => 'NUMBER',
                                         default_value     => 1);                                          
                                                                              
    dbms_scheduler.enable (name => 'prog_XslTransformAndDownload');
  
  
    
    dbms_scheduler.create_job(job_name        => 'job_XslTransformAndDownload',
                              program_name    => 'prog_XslTransformAndDownload',
                              start_date      => sysdate,
                              end_date        => null);
    commit;
    
  end if;                            
end; 
/