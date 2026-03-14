-- Table: public.address

-- DROP TABLE IF EXISTS public.address;

CREATE TABLE IF NOT EXISTS public.address
(
    id bigint NOT NULL DEFAULT nextval('address_id_seq'::regclass),
    customer_id bigint NOT NULL,
    street character varying(255) COLLATE pg_catalog."default" NOT NULL,
    city character varying(100) COLLATE pg_catalog."default" NOT NULL,
    state character varying(100) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT address_pkey PRIMARY KEY (id),
    CONSTRAINT "FK_customer_address" FOREIGN KEY (customer_id)
        REFERENCES public.customers (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE tbl_spc_eventdb;

ALTER TABLE IF EXISTS public.address
    OWNER to event_db_user;