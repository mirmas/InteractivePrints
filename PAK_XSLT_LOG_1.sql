--------------------------------------------------------
--  DDL for Package Body PAK_XSLT_LOG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PAK_XSLT_LOG" AS


/* set level of logging:
      1 - log just errors
      2 - log errors and warnings (default)
      3 - log all (informations, errors and warnings)*/
PROCEDURE SetLevel(P_LEVEL NUMBER) is
begin
   g_level:= P_LEVEL;
end;

function GetProcedure(p_call_stack varchar2)
return varchar2
as
l_start number;
l_end number;
begin
  l_start := instr(p_call_stack,chr(10),1,5);
  l_end := instr(p_call_stack,chr(10),1,6);
  if nvl(l_start, 0) = 0 then
    return null;
  end if;
  if l_end > 0 then
    return substr(p_call_stack, l_start, l_end-l_start);
  else
    return substr(p_call_stack, l_start);
  end if;
  return null;
end;

/* Write to PAK_XSLT_LOG */
PROCEDURE WriteLog
   ( P_DESCRIPTION               VARCHAR2 DEFAULT 'Information'
   , P_LOG_TYPE                  VARCHAR2 DEFAULT g_information
   , p_apex_debug_level          NUMBER DEFAULT 7
   , P_PROCEDURE                 VARCHAR2 DEFAULT NULL
   , P_SQLERRM                   VARCHAR2 DEFAULT NULL
   , P_ERR_NUM                   NUMBER DEFAULT NULL
   , p_start_time                PLS_INTEGER DEFAULT NULL
   )  IS

PRAGMA AUTONOMOUS_TRANSACTION;

l_WriteLog boolean;
l_apex_debug_level number;
l_secs number;
l_description varchar2(4000) := substr(p_description,1,3900);
BEGIN
  l_apex_debug_level := p_apex_debug_level;

   l_WriteLog:=false;

   if g_level = 1 and P_LOG_TYPE = g_error then
      l_WriteLog:=true;
   elsif g_level = 2 and P_LOG_TYPE in (g_error, g_warning) then
      l_WriteLog:=true;
    elsif g_level = 3 then
      l_WriteLog:=true;
   end if;

   if l_WriteLog then
      if p_start_time is not null then
        l_secs := (dbms_utility.get_time() - p_start_time) / 100;
        l_description := l_description||' time: '||to_char(l_secs);
      end if;

      if p_log_type = g_error then
        l_apex_debug_level := 1; --If error then set most important APEX debug level
        apex_debug_message.log_message( substr(dbms_utility.format_error_stack,1,3900), p_level => l_apex_debug_level );
        apex_debug_message.log_message( substr(dbms_utility.format_error_backtrace,1,3900), p_level => l_apex_debug_level );
       end if;
       apex_debug_message.log_message(substr(substr(GetProcedure(DBMS_UTILITY.FORMAT_CALL_STACK),1,200)
                                      ||' '||l_description,1,3900), p_level => l_apex_debug_level);

      insert into XSLT_LOG
         ( ID_XSLT_LOG
         , LOG_TYPE
         , DESCRIPTION
         , LOG_DATE
         , DBUSER
         , APPUSER
         , APP_ID
         , PAGE_ID
         , APEX_WORKSPACE
         , PROCEDURE
         , ERROR_MESSAGE
         , ERR_NUM
         )
      values
         ( XSLT_LOG_seq.nextval
         , p_log_type
         , l_description
         , sysdate
         , user
         , V('APP_USER')
         , V('APP_ID')
         , V('APP_PAGE_ID')
         , APEX_UTIL.FIND_WORKSPACE(apex_application.get_security_group_id)
         , substr(nvl(p_procedure, GetProcedure(DBMS_UTILITY.FORMAT_CALL_STACK)),1,200)
         , substr(P_SQLERRM, 1, 1024)
         , P_ERR_NUM
         );
   end if;

   commit;
exception
   when others then

      rollback;
      raise_application_error(-20001, sqlerrm);

end WriteLog;

/**Shrink XSLT_LOG table to p_max_XSLT_LOG_recs records with deleting the oldest records or if
* number of records is greater than nvl(p_trunc_XSLT_LOG_recs, 10 * p_max_XSLT_LOG_recs)
* truncate table xslt_log.
*
* @param p_max_XSLT_LOG_recs See procedure description above
* @param p_trunc_XSLT_LOG_recs See procedure description above
*/
PROCEDURE ClearLog(
  p_max_XSLT_LOG_recs number default 10000,
  p_trunc_XSLT_LOG_recs number default null
)
  AS
    l_XSLT_LOG_recs number;
    l_max_procedures varchar2(1000);

    cursor c_cur is
      select count_recs, procedure_name from
      (
      select count(*) count_recs, procedure procedure_name from XSLT_LOG group by procedure order by count(*) desc
      )
      where rownum <= 5;
  BEGIN
    select count(*) into l_XSLT_LOG_recs from XSLT_LOG;

    if l_XSLT_LOG_recs between p_max_XSLT_LOG_recs and nvl(p_trunc_XSLT_LOG_recs, 10 * p_max_XSLT_LOG_recs) then
      delete from XSLT_LOG where id_XSLT_LOG in
      (
        select id_XSLT_LOG from
        (
        select id_XSLT_LOG from XSLT_LOG order by id_XSLT_LOG
        )
        where rownum <= l_XSLT_LOG_recs - p_max_XSLT_LOG_recs
      );
      WriteLog(
        P_DESCRIPTION       => 'Deleted '||to_char(l_XSLT_LOG_recs - p_max_XSLT_LOG_recs)||' oldest records.'
        , P_LOG_TYPE     => g_warning
        , P_procedure  => 'PAK_XSLT_LOG.ClearLog'
      );
     commit;
    elsif l_XSLT_LOG_recs > nvl(p_trunc_XSLT_LOG_recs, 10 * p_max_XSLT_LOG_recs) then
       for r_cur in c_cur loop
          l_max_procedures := l_max_procedures||r_cur.procedure_name||':'||r_cur.count_recs||', ';
       end loop;
       l_max_procedures := rtrim(l_max_procedures, ', ');

       EXECUTE IMMEDIATE 'truncate table xslt_log';

       WriteLog(
        P_DESCRIPTION       => 'Log truncated ('||to_char(l_XSLT_LOG_recs)||' records). Check procedures: '||l_max_procedures
        , P_LOG_TYPE     => g_warning
        , P_procedure  => 'PAK_XSLT_LOG.ClearLog'
       );

       commit;
    end if;

  exception
    when others then
    WriteLog
     ( P_DESCRIPTION       => 'Error'
     , P_LOG_TYPE      => PAK_XSLT_LOG.g_error
     , P_PROCEDURE  => 'PAK_XSLT_LOG.ClearLog'
     , P_SQLERRM   =>  sqlerrm
     );
    rollback;
  END ClearLog;

begin

   -- constructor set level to log errors and warnings
   g_level:= 2;


END PAK_XSLT_LOG;

/
