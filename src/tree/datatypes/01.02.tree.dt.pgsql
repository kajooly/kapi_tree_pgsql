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

-- Reflect the underlying type of a structure. for defaults
-- if you customize the structure, Alter/duplicate the type so you can use this to get the underlying base
-- and use the proper functions to access the fields of the structure

DROP TYPE IF EXISTS public.kapi_dt_tree_tree;
CREATE TYPE public.kapi_dt_tree_tree AS(
    -- Node Fields
    node_id uuid,
    node_group_id uuid,
    node_path kapi_dtd_ltree,
    node_key citext,
    node_alias citext,
    node_path_to ltree,
    node_name ltree,
    node_depth bigint,
    node_weight integer,
    node_metadata jsonb,
    node_data jsonb,
    node_link_weight integer,
    node_link_metadata jsonb,
    node_link_data jsonb,
    node_inserted_at bigint,
    node_updated_at bigint,
    -- Data Fields
    data_id uuid,
    data_node_id uuid,
    data_value text,
    data_note text,
    data_details text,
    data_inserted_at bigint,
    data_updated_at bigint
    -- View Fields
    -- ...
);

DROP TYPE IF EXISTS public.kapi_dt_tree_node;
CREATE TYPE public.kapi_dt_tree_node AS(
    id uuid,
    node_group_id uuid,
    node_path kapi_dtd_ltree,
    node_key citext,
    node_alias citext,
    node_path_to ltree,
    node_name ltree,
    node_depth bigint,
    node_weight integer,
    node_metadata jsonb,
    node_data jsonb,
    node_link_weight integer,
    node_link_metadata jsonb,
    node_link_data jsonb,
    node_inserted_at bigint,
    node_updated_at bigint
);

DROP TYPE IF EXISTS public.kapi_dt_tree_data;
CREATE TYPE public.kapi_dt_tree_data AS(
    id uuid,
    data_node_id uuid,
    data_value text,
    data_note text,
    data_details text,
    data_inserted_at bigint,
    data_updated_at bigint
);
