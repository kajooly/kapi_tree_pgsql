-- Copyright 2022 Rolando Lucio 

-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at

--     https://www.apache.org/licenses/LICENSE-2.0

-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.


-- FUNCION: public.kapi_tablefunc_updatedat
-- DESCRIPTION: This Trigger Function is used to update the date of the last update of the table.
-- USAGE: 
-- SELECT public.kapi_tablefunc_updatedat('categories','brands','node_updated_at')
-- SELECT public.kapi_tablefunc_updatedat('categories','brands')

CREATE OR REPLACE FUNCTION public.kapi_tablefunc_updatedat(
    _schema varchar, 
    _table varchar,
    _updatedat_column varchar DEFAULT 'updated_at',
)
LANGUAGE plpgsql
VOLATILE
COST 100
RETURNS VOID
AS
$$
DECLARE
    _table_name varchar default  _table;
    _table_name_full varchar default _schema || '.' || _table;
BEGIN
    EXECUTE '
	CREATE OR REPLACE FUNCTION ' || _schema || '.' || _table || '_trg_fn_b4_update_updatedat()
	RETURNS trigger 
	AS 
	$BODY$ 
	BEGIN
      -- Now epoch time in milliseconds or default to current time
	  NEW.' || _updatedat_column || ' =  public.kapi_time_epoch_now();
	  RETURN NEW;
	END;
	$BODY$ 
    LANGUAGE plpgsql
	;
	';

    EXECUTE	'
	DROP TRIGGER IF EXISTS trg_updatedat ON ' || _table_name_full || ';
	CREATE TRIGGER trg_updatedat
	BEFORE UPDATE 
	ON ' || _table_name_full || '
	FOR EACH STATEMENT
	EXECUTE PROCEDURE ' || _schema || '.' || _table || '_trg_fn_b4_update_updatedat();
	';
END;
$$;

