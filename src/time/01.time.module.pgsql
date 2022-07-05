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

/*
@module kapi_time
Functions for Date & Time management
context: Common functions
*/


-- @function kapi_time_epoch_to_timestamp
-- @description Convert Epoch in Milliseconds to Timestamp Without Timezone in Milliseconds
-- @param _epoch_milliseconds bigint, Epoch in Milliseconds ( 13 digits )
-- @return _timestamp timestamp, Timestamp withour timezone in Milliseconds ( YYYY-MM-DD HH24:MI:SS.MS )
-- @usage
-- Epoch of CurrentTimestamp in milliseconds
-- SELECT kapi_time_epoch_to_timestamp( (date_part('epoch'::text, CURRENT_TIMESTAMP) * (1000)::double precision)::bigint );
-- Epoch in milliseconds to Timestamp in milliseconds
-- SELECT kapi_time_epoch_to_timestamp( 1656632664923 );  -- Timestamp in milliseconds = '2022-06-30 23:44:24.923'

DROP FUNCTION IF EXISTS public.kapi_time_epoch_to_timestamp;
CREATE OR REPLACE FUNCTION public.kapi_time_epoch_to_timestamp(
        _epoch_milliseconds bigint 
    )
RETURNS timestamp
AS
$$
DECLARE
    _timezone varchar default 'UTC';
    _timestamp timestamp;
    _divisor int default 1000;
BEGIN 
    _timestamp = (to_timestamp(TO_CHAR(TO_TIMESTAMP(_epoch_milliseconds / _divisor), 'YYYY-MM-DD HH24:MI:SS') || '.' || (_epoch_milliseconds % _divisor), 'YYYY-MM-DD HH24:MI:SS.MS')) AT TIME ZONE _timezone;
    RETURN _timestamp::timestamp;
END;
$$
LANGUAGE plpgsql;

-- @function kapi_time_timestamp_to_epoch
-- @description Convert Timestamp Without Timezone in Milliseconds to Epoch in Milliseconds
-- @param _timestamp timestamp, Timestamp withour timezone in Milliseconds ( YYYY-MM-DD HH24:MI:SS.MS )
-- @return _epoch_milliseconds bigint, Epoch in Milliseconds ( 13 digits )
-- @usage
-- epoch of CurrentTimestamp in milliseconds
-- SELECT kapi_time_timestamp_to_epoch(  CURRENT_TIMESTAMP::timestamp );
-- Timestamp in milliseconds to Epoch in milliseconds
-- SELECT kapi_time_timestamp_to_epoch( '2022-06-30 23:44:24.923' );  -- epoch in milliseconds = 1656632664923

DROP FUNCTION IF EXISTS public.kapi_time_timestamp_to_epoch;
CREATE OR REPLACE FUNCTION public.kapi_time_timestamp_to_epoch(
        _timestamp timestamp 
    )
RETURNS bigint
AS
$$
DECLARE
    _timezone varchar default 'UTC';
    _epoch_milliseconds bigint;
    _divisor int default 1000;
BEGIN
    _epoch_milliseconds = ((date_part('epoch'::text, _timestamp AT TIME ZONE _timezone) * (_divisor)::double precision))::bigint;
    RETURN _epoch_milliseconds;
END;
$$
LANGUAGE plpgsql;


---------------------------------------------------------------
-- TimeStamp Functions get or format timestamp
-- Default timestamp in milliseconds & UTC timezone
-- MAIN FUNCTION: public.kapi_time_timestamp
---------------------------------------------------------------

-- FUNCTION: public.kapi_time_timestamp_seconds
-- i.e: 2022-07-05 14:45:08
-- SELECT public.kapi_time_timestamp_seconds('2022-07-05 14:45:08.471898');
-- SELECT public.kapi_time_timestamp_seconds();
DROP FUNCTION IF EXISTS public.kapi_time_timestamp_seconds;
CREATE OR REPLACE FUNCTION public.kapi_time_timestamp_seconds(
    _timestamp timestamp DEFAULT CURRENT_TIMESTAMP
    )
    RETURNS timestamp
    LANGUAGE plpgsql
AS $BODY$
DECLARE
	_result timestamp;
BEGIN
    _result = TO_CHAR((_timestamp AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH24:MI:SS')::timestamp ;
    RETURN _result;
END;
$BODY$;

-- FUNCTION: public.kapi_time_timestamp_milliseconds
-- i.e: 2022-07-05 14:45:08.471
-- SELECT public.kapi_time_timestamp_milliseconds('2022-07-05 14:45:08.471898');
-- SELECT public.kapi_time_timestamp_milliseconds();
DROP FUNCTION IF EXISTS public.kapi_time_timestamp_milliseconds;
CREATE OR REPLACE FUNCTION public.kapi_time_timestamp_milliseconds(
    _timestamp timestamp DEFAULT CURRENT_TIMESTAMP
    )
    RETURNS timestamp
    LANGUAGE plpgsql
AS $BODY$
DECLARE
	_result timestamp;
BEGIN
    _result = TO_CHAR((_timestamp AT TIME ZONE 'UTC'), 'YYYY-MM-DD HH24:MI:SS.MS')::timestamp;
    RETURN _result;
END;
$BODY$;

-- FUNCTION: public.kapi_time_timestamp_naive
-- i.e: 2022-07-05 14:45:08.471898
-- SELECT public.kapi_time_timestamp_naive('2022-07-05 14:45:08.471898');
-- SELECT public.kapi_time_timestamp_naive();
DROP FUNCTION IF EXISTS public.kapi_time_timestamp_naive;
CREATE OR REPLACE FUNCTION public.kapi_time_timestamp_naive(
    _timestamp timestamp DEFAULT CURRENT_TIMESTAMP
    )
    RETURNS timestamp
    LANGUAGE plpgsql
AS $BODY$
DECLARE
	_result timestamp;
BEGIN
    _result = (_timestamp AT TIME ZONE 'UTC')::timestamp ;
    RETURN _result;
END;
$BODY$;

-- @description: Default timestamp in milliseconds & UTC timezone
-- FUNCTION: public.kapi_time_timestamp
-- SELECT public.kapi_time_timestamp('2022-07-05 14:45:08.471898');
-- SELECT public.kapi_time_timestamp();
DROP FUNCTION IF EXISTS public.kapi_time_timestamp;
CREATE OR REPLACE FUNCTION public.kapi_time_timestamp(
    _timestamp timestamp DEFAULT CURRENT_TIMESTAMP
    )
    RETURNS timestamp
    LANGUAGE plpgsql
AS $BODY$
DECLARE
	_result timestamp;
BEGIN
    _result = public.kapi_time_timestamp_milliseconds(_timestamp);
    RETURN _result;
END;
$BODY$;