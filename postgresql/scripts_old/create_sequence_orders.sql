-- SEQUENCE: public.orders_id_seq

-- DROP SEQUENCE IF EXISTS public.orders_id_seq;

CREATE SEQUENCE IF NOT EXISTS public.orders_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.orders_id_seq
    OWNED BY public.orders.id;

ALTER SEQUENCE public.orders_id_seq
    OWNER TO event_db_user;