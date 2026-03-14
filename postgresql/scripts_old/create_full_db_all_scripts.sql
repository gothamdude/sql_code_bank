-- Database: eventdb

-- DROP DATABASE IF EXISTS eventdb;

CREATE DATABASE eventdb
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

GRANT TEMPORARY, CONNECT ON DATABASE eventdb TO PUBLIC;

GRANT TEMPORARY ON DATABASE eventdb TO event_db_user;

GRANT ALL ON DATABASE eventdb TO postgres;