

CREATE OR REPLACE package PAK_XML_CONVERT as

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


function SerializeColTypes (p_reportTypes Query2Report.t_coltype_tables)
return varchar2;

function DeserializeColTypes (p_reportTypes varchar2)
return  Query2Report.t_coltype_tables;

function LogColType (p_reportType  t_coltype_table)
return varchar2;

function LogColTypes (p_reportTypes  Query2Report.t_coltype_tables)
return varchar2;

function SerializeRegionAttrs (p_regionAttrs Query2Report.tab_string)
return varchar2;

function DeserializeRegionAttrs (p_regionAttrs varchar2)
return  Query2Report.tab_string;

/** Delete null elements REGION_AGGREGATES and REGION_HIGHLIGHTS and then replace
* not null elements REGION_AGGREGATES and REGION_HIGHLIGHTS to attributes in XML pio_clob.
*
* @param pio_clob XML to convert
*/
PROCEDURE xmlConvert(
  pio_clob        IN OUT NOCOPY CLOB,
  p_filename      IN VARCHAR2,
  pi_regionAttrs  in Query2Report.tab_string,
  pi_reportTypes  IN OUT Query2Report.t_coltype_tables
);

/* function returns Word highlight name of the most similar color from upper list to p_color.
   Parameter p_color is in RGB HEX format
*/
function findWordColor(p_color varchar2)
return varchar2;

end;
/
