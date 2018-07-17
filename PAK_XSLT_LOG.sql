--------------------------------------------------------
--  DDL for Package PAK_XSLT_LOG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_XSLT_LOG" AS

g_error      constant varchar2(1) := 'E';
g_warning    constant varchar2(1) := 'W';
g_information constant varchar2(1) := 'I';

g_level number;

function GetProcedure(p_call_stack varchar2)
return varchar2;

/** Set level of logging
*
*/
PROCEDURE SetLevel(P_LEVEL NUMBER);

/** Write to XSLT_LOG table and to APEX log
*
*@param P_DESCRIPTION  Short description
*@param P_LOG_TYPE values g_information, g_warning, g_error
*@param p_apex_debug_level  APEX debug level
*@param P_PROCEDURE Name of procedure or function
*@param P_SQLERRM Oracle SQLERRM
*@param P_ERR_NUM Oracle Error number
*@param p_start_time If set current_time - p_start_tiume will be displayed
*/
PROCEDURE WriteLog
   ( P_DESCRIPTION                      VARCHAR2 DEFAULT 'Information'
   , P_LOG_TYPE                     VARCHAR2 DEFAULT g_information
   , p_apex_debug_level          NUMBER DEFAULT 7
   , P_PROCEDURE                 VARCHAR2 DEFAULT NULL
   , P_SQLERRM                   VARCHAR2 DEFAULT NULL
   , P_ERR_NUM                   NUMBER DEFAULT NULL
   , p_start_time                PLS_INTEGER DEFAULT NULL
   );

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
);

END PAK_XSLT_LOG;

/
