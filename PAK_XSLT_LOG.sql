
CREATE OR REPLACE PACKAGE "PAK_XSLT_LOG" AS

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
