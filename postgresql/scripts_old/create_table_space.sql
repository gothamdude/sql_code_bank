-- Tablespace: tbl_spc_eventdb

-- DROP TABLESPACE IF EXISTS tbl_spc_eventdb;

CREATE TABLESPACE tbl_spc_eventdb
  OWNER event_db_user
  LOCATION C:\SQLData\PostgreSQL\tbl_spc\eventdb;

ALTER TABLESPACE tbl_spc_eventdb
  OWNER TO event_db_user;