--
-- PostgreSQL database dump
--

-- Dumped from database version 10.18 (Ubuntu 10.18-0ubuntu0.18.04.1)
-- Dumped by pg_dump version 10.18 (Ubuntu 10.18-0ubuntu0.18.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(100),
    active boolean,
    phone character varying(255) NOT NULL,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    image character varying
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_id_seq OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_id_seq OWNED BY public.admin.id;


--
-- Name: admin_otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin_otp (
    id integer NOT NULL,
    "isVerified" boolean,
    counter integer,
    otp integer NOT NULL
);


ALTER TABLE public.admin_otp OWNER TO postgres;

--
-- Name: admin_otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.admin_otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.admin_otp_id_seq OWNER TO postgres;

--
-- Name: admin_otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.admin_otp_id_seq OWNED BY public.admin_otp.id;


--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: blacklist_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blacklist_tokens (
    id integer NOT NULL,
    token character varying(500) NOT NULL,
    blacklisted_on timestamp without time zone NOT NULL
);


ALTER TABLE public.blacklist_tokens OWNER TO postgres;

--
-- Name: blacklist_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blacklist_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blacklist_tokens_id_seq OWNER TO postgres;

--
-- Name: blacklist_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blacklist_tokens_id_seq OWNED BY public.blacklist_tokens.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    image character varying(255) NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    deleted_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.categories OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO postgres;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cities (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    status integer NOT NULL,
    help_number character varying(255) NOT NULL,
    whats_app_number character varying(255),
    created_at timestamp without time zone,
    deleted_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.cities OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cities_id_seq OWNER TO postgres;

--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cities_id_seq OWNED BY public.cities.id;


--
-- Name: city_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.city_categories (
    id integer NOT NULL,
    city_id integer,
    category_id integer,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.city_categories OWNER TO postgres;

--
-- Name: city_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.city_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.city_categories_id_seq OWNER TO postgres;

--
-- Name: city_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.city_categories_id_seq OWNED BY public.city_categories.id;


--
-- Name: citymisdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.citymisdetail (
    id integer NOT NULL,
    mis_id integer,
    city_id integer,
    date timestamp without time zone NOT NULL,
    order_canceled integer NOT NULL,
    new_locality integer NOT NULL,
    new_stores_created integer NOT NULL,
    average_order_value double precision NOT NULL,
    total_order_value double precision NOT NULL,
    total_discount_value double precision NOT NULL,
    delivery_fees double precision NOT NULL,
    commision double precision NOT NULL,
    turnover double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    order_delivered integer NOT NULL,
    total_tax double precision NOT NULL
);


ALTER TABLE public.citymisdetail OWNER TO postgres;

--
-- Name: citymisdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.citymisdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.citymisdetail_id_seq OWNER TO postgres;

--
-- Name: citymisdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.citymisdetail_id_seq OWNED BY public.citymisdetail.id;


--
-- Name: coupon_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_categories (
    id integer NOT NULL,
    category_id integer NOT NULL,
    coupon_id integer NOT NULL,
    status smallint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.coupon_categories OWNER TO postgres;

--
-- Name: coupon_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupon_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupon_categories_id_seq OWNER TO postgres;

--
-- Name: coupon_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupon_categories_id_seq OWNED BY public.coupon_categories.id;


--
-- Name: coupon_cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_cities (
    id integer NOT NULL,
    city_id integer NOT NULL,
    coupon_id integer NOT NULL,
    status smallint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coupon_cities OWNER TO postgres;

--
-- Name: coupon_cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupon_cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupon_cities_id_seq OWNER TO postgres;

--
-- Name: coupon_cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupon_cities_id_seq OWNED BY public.coupon_cities.id;


--
-- Name: coupon_merchants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_merchants (
    id integer NOT NULL,
    coupon_id integer NOT NULL,
    merchant_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coupon_merchants OWNER TO postgres;

--
-- Name: coupon_merchants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupon_merchants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupon_merchants_id_seq OWNER TO postgres;

--
-- Name: coupon_merchants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupon_merchants_id_seq OWNED BY public.coupon_merchants.id;


--
-- Name: coupon_stores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupon_stores (
    id integer NOT NULL,
    store_id integer NOT NULL,
    coupon_id integer NOT NULL,
    status smallint NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coupon_stores OWNER TO postgres;

--
-- Name: coupon_stores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupon_stores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupon_stores_id_seq OWNER TO postgres;

--
-- Name: coupon_stores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupon_stores_id_seq OWNED BY public.coupon_stores.id;


--
-- Name: coupons; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.coupons (
    id integer NOT NULL,
    code character varying(255) NOT NULL,
    title character varying(255),
    description text NOT NULL,
    banner_1 character varying(255),
    banner_2 character varying(255),
    level smallint NOT NULL,
    target smallint NOT NULL,
    deduction_type character varying(255) NOT NULL,
    deduction_amount double precision NOT NULL,
    min_order_value double precision NOT NULL,
    max_deduction double precision,
    user_id integer,
    previous_order_track integer NOT NULL,
    max_user_usage_limit integer NOT NULL,
    expired_at character varying(255),
    status smallint NOT NULL,
    order_id integer,
    is_display smallint,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.coupons OWNER TO postgres;

--
-- Name: coupons_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.coupons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.coupons_id_seq OWNER TO postgres;

--
-- Name: coupons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.coupons_id_seq OWNED BY public.coupons.id;


--
-- Name: delivery_agent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.delivery_agent (
    id integer NOT NULL,
    name character varying NOT NULL,
    api_link character varying NOT NULL,
    api_key character varying NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.delivery_agent OWNER TO postgres;

--
-- Name: delivery_agent_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.delivery_agent_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.delivery_agent_id_seq OWNER TO postgres;

--
-- Name: delivery_agent_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.delivery_agent_id_seq OWNED BY public.delivery_agent.id;


--
-- Name: distributor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.distributor (
    id integer NOT NULL,
    email character varying NOT NULL,
    name character varying NOT NULL,
    password_hash character varying,
    active boolean,
    phone character varying(255) NOT NULL,
    image character varying,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.distributor OWNER TO postgres;

--
-- Name: distributor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.distributor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.distributor_id_seq OWNER TO postgres;

--
-- Name: distributor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.distributor_id_seq OWNED BY public.distributor.id;


--
-- Name: hub; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hub (
    id integer NOT NULL,
    distributor_id integer,
    name character varying NOT NULL,
    slug character varying NOT NULL,
    image character varying(255),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    hub_latitude double precision,
    hub_longitude double precision,
    radius integer,
    status integer,
    city_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.hub OWNER TO postgres;

--
-- Name: hub_bank_details; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hub_bank_details (
    id integer NOT NULL,
    hub_id integer NOT NULL,
    beneficiary_name character varying(255),
    name_of_bank character varying(100),
    ifsc_code character varying(55),
    vpa character varying(255),
    account_number character varying(100),
    status integer,
    confirmed integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.hub_bank_details OWNER TO postgres;

--
-- Name: hub_bank_details_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hub_bank_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hub_bank_details_id_seq OWNER TO postgres;

--
-- Name: hub_bank_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hub_bank_details_id_seq OWNED BY public.hub_bank_details.id;


--
-- Name: hub_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hub_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hub_id_seq OWNER TO postgres;

--
-- Name: hub_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hub_id_seq OWNED BY public.hub.id;


--
-- Name: hub_order_lists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hub_order_lists (
    id integer NOT NULL,
    hub_order_id integer NOT NULL,
    store_item_id integer NOT NULL,
    store_item_variable_id integer NOT NULL,
    quantity integer NOT NULL,
    removed_by integer NOT NULL,
    status integer NOT NULL,
    product_mrp double precision,
    product_selling_price double precision,
    product_quantity double precision,
    product_quantity_unit integer,
    product_name character varying(255),
    product_brand_name character varying(255),
    product_image character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.hub_order_lists OWNER TO postgres;

--
-- Name: hub_order_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hub_order_lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hub_order_lists_id_seq OWNER TO postgres;

--
-- Name: hub_order_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hub_order_lists_id_seq OWNED BY public.hub_order_lists.id;


--
-- Name: hub_order_tax; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hub_order_tax (
    id integer NOT NULL,
    hub_order_id integer,
    tax_id integer,
    tax_name character varying NOT NULL,
    tax_type integer NOT NULL,
    amount double precision NOT NULL,
    calculated double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.hub_order_tax OWNER TO postgres;

--
-- Name: hub_order_tax_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hub_order_tax_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hub_order_tax_id_seq OWNER TO postgres;

--
-- Name: hub_order_tax_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hub_order_tax_id_seq OWNED BY public.hub_order_tax.id;


--
-- Name: hub_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hub_orders (
    id integer NOT NULL,
    merchant_id integer NOT NULL,
    hub_id integer NOT NULL,
    order_total double precision,
    total_tax double precision,
    delivery_fee double precision,
    grand_order_total double precision,
    initial_paid double precision,
    order_created timestamp without time zone,
    order_confirmed timestamp without time zone,
    ready_to_pack timestamp without time zone,
    order_paid timestamp without time zone,
    order_pickedup timestamp without time zone,
    order_delivered timestamp without time zone,
    delivery_date timestamp without time zone,
    user_address_id integer,
    delivery_slot_id integer,
    da_id integer,
    status integer,
    distributor_transfer_at character varying(255),
    distributor_transaction_id integer,
    txnid integer,
    gateway character varying(255),
    transaction_status character varying(255),
    cancelled_by_id integer,
    cancelled_by_role character varying,
    commision double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    remove_by_role character varying(255),
    remove_by_id integer
);


ALTER TABLE public.hub_orders OWNER TO postgres;

--
-- Name: hub_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hub_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hub_orders_id_seq OWNER TO postgres;

--
-- Name: hub_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hub_orders_id_seq OWNED BY public.hub_orders.id;


--
-- Name: hubtaxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.hubtaxes (
    id integer NOT NULL,
    hub_id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    tax_type integer NOT NULL,
    amount double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.hubtaxes OWNER TO postgres;

--
-- Name: hubtaxes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.hubtaxes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hubtaxes_id_seq OWNER TO postgres;

--
-- Name: hubtaxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.hubtaxes_id_seq OWNED BY public.hubtaxes.id;


--
-- Name: item_order_lists; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_order_lists (
    id integer NOT NULL,
    item_order_id integer NOT NULL,
    store_item_id integer NOT NULL,
    store_item_variable_id integer NOT NULL,
    product_packaged character varying(255),
    quantity integer NOT NULL,
    removed_by integer NOT NULL,
    status integer NOT NULL,
    product_mrp double precision,
    product_selling_price double precision,
    product_quantity_unit integer,
    product_name character varying(255),
    product_brand_name character varying(255),
    product_image character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    product_quantity double precision
);


ALTER TABLE public.item_order_lists OWNER TO postgres;

--
-- Name: item_order_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_order_lists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_order_lists_id_seq OWNER TO postgres;

--
-- Name: item_order_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_order_lists_id_seq OWNED BY public.item_order_lists.id;


--
-- Name: item_order_tax; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_order_tax (
    id integer NOT NULL,
    item_order_id integer,
    tax_id integer,
    tax_name character varying NOT NULL,
    tax_type integer NOT NULL,
    amount double precision NOT NULL,
    calculated double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.item_order_tax OWNER TO postgres;

--
-- Name: item_order_tax_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_order_tax_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_order_tax_id_seq OWNER TO postgres;

--
-- Name: item_order_tax_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_order_tax_id_seq OWNED BY public.item_order_tax.id;


--
-- Name: item_orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.item_orders (
    id integer NOT NULL,
    user_id integer NOT NULL,
    store_id integer NOT NULL,
    slug character varying(255),
    order_total double precision,
    coupon_id integer,
    order_total_discount double precision,
    final_order_total double precision,
    delivery_fee double precision,
    grand_order_total double precision,
    initial_paid double precision,
    order_created timestamp without time zone,
    order_confirmed timestamp without time zone,
    ready_to_pack timestamp without time zone,
    order_paid timestamp without time zone,
    order_pickedup timestamp without time zone,
    order_delivered timestamp without time zone,
    delivery_date timestamp without time zone,
    user_address_id integer,
    delivery_slot_id integer,
    da_id integer,
    status integer,
    merchant_transfer_at character varying(255),
    merchant_transaction_id integer,
    txnid integer,
    gateway character varying(255),
    transaction_status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    remove_by_role character varying(255),
    cancelled_by_id integer,
    cancelled_by_role character varying,
    remove_by_id integer,
    total_tax double precision,
    commision double precision,
    walk_in_order integer
);


ALTER TABLE public.item_orders OWNER TO postgres;

--
-- Name: item_orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.item_orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_orders_id_seq OWNER TO postgres;

--
-- Name: item_orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.item_orders_id_seq OWNED BY public.item_orders.id;


--
-- Name: localities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.localities (
    id integer NOT NULL,
    city_id integer,
    name character varying(255) NOT NULL,
    code character varying(255) NOT NULL,
    pin character varying(255) NOT NULL,
    delivery_fee character varying(255),
    start_time character varying(255),
    end_time character varying(255),
    status integer NOT NULL,
    created_at timestamp without time zone,
    deleted_at timestamp without time zone,
    updated_at timestamp without time zone
);


ALTER TABLE public.localities OWNER TO postgres;

--
-- Name: localities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.localities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.localities_id_seq OWNER TO postgres;

--
-- Name: localities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.localities_id_seq OWNED BY public.localities.id;


--
-- Name: menu_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menu_categories (
    id integer NOT NULL,
    category_id integer,
    name character varying(255) NOT NULL,
    image character varying(255),
    slug character varying(255) NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.menu_categories OWNER TO postgres;

--
-- Name: menu_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.menu_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_categories_id_seq OWNER TO postgres;

--
-- Name: menu_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.menu_categories_id_seq OWNED BY public.menu_categories.id;


--
-- Name: merchant; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchant (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(100),
    active boolean,
    phone character varying(255) NOT NULL,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    image character varying
);


ALTER TABLE public.merchant OWNER TO postgres;

--
-- Name: merchant_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.merchant_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_id_seq OWNER TO postgres;

--
-- Name: merchant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.merchant_id_seq OWNED BY public.merchant.id;


--
-- Name: merchant_otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchant_otp (
    id integer NOT NULL,
    "isVerified" boolean,
    counter integer,
    otp integer NOT NULL
);


ALTER TABLE public.merchant_otp OWNER TO postgres;

--
-- Name: merchant_otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.merchant_otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_otp_id_seq OWNER TO postgres;

--
-- Name: merchant_otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.merchant_otp_id_seq OWNED BY public.merchant_otp.id;


--
-- Name: merchant_transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.merchant_transactions (
    id integer NOT NULL,
    store_id integer NOT NULL,
    user_email character varying(255),
    user_phone character varying(255),
    merchant_ref_id character varying(255),
    payable_amount double precision,
    gst double precision,
    tcs double precision,
    commission double precision,
    benf_name character varying(255),
    bank_name character varying(100),
    ifsc character varying(55),
    vpa character varying(255),
    total_order_amount character varying(255),
    account_number character varying(100),
    status character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.merchant_transactions OWNER TO postgres;

--
-- Name: merchant_transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.merchant_transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.merchant_transactions_id_seq OWNER TO postgres;

--
-- Name: merchant_transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.merchant_transactions_id_seq OWNED BY public.merchant_transactions.id;


--
-- Name: misdetail; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.misdetail (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    daily_new_user integer NOT NULL,
    order_canceled integer NOT NULL,
    new_items_added integer NOT NULL,
    new_stores_created integer NOT NULL,
    average_order_value double precision NOT NULL,
    total_order_value double precision NOT NULL,
    total_discount_value double precision NOT NULL,
    delivery_fees double precision NOT NULL,
    commision double precision NOT NULL,
    turnover double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    order_delivered integer NOT NULL,
    total_tax double precision NOT NULL
);


ALTER TABLE public.misdetail OWNER TO postgres;

--
-- Name: misdetail_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.misdetail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.misdetail_id_seq OWNER TO postgres;

--
-- Name: misdetail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.misdetail_id_seq OWNED BY public.misdetail.id;


--
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    user_id integer NOT NULL,
    uid character varying(255) NOT NULL,
    target character varying(255) NOT NULL,
    text text NOT NULL,
    not_type character varying(255) NOT NULL,
    message text,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_id_seq OWNER TO postgres;

--
-- Name: notification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_id_seq OWNED BY public.notification.id;


--
-- Name: notification_templates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification_templates (
    id integer NOT NULL,
    dlt_template_id character varying(255) NOT NULL,
    template text NOT NULL,
    name character varying(255) NOT NULL,
    t_type character varying(255) NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.notification_templates OWNER TO postgres;

--
-- Name: notification_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notification_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_templates_id_seq OWNER TO postgres;

--
-- Name: notification_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notification_templates_id_seq OWNED BY public.notification_templates.id;


--
-- Name: progress; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.progress (
    id integer NOT NULL,
    user_id integer,
    uid character varying(255) NOT NULL,
    store_id integer,
    total integer,
    success integer,
    skipped integer,
    status integer NOT NULL,
    created_at character varying NOT NULL,
    updated_at character varying,
    deleted_at character varying
);


ALTER TABLE public.progress OWNER TO postgres;

--
-- Name: progress_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.progress_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.progress_id_seq OWNER TO postgres;

--
-- Name: progress_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.progress_id_seq OWNED BY public.progress.id;


--
-- Name: quantity_unit; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quantity_unit (
    id integer NOT NULL,
    name character varying(255),
    short_name character varying(255),
    conversion character varying(255) NOT NULL,
    type_details character varying(255) NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.quantity_unit OWNER TO postgres;

--
-- Name: quantity_unit_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.quantity_unit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quantity_unit_id_seq OWNER TO postgres;

--
-- Name: quantity_unit_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.quantity_unit_id_seq OWNED BY public.quantity_unit.id;


--
-- Name: refund; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refund (
    id integer NOT NULL,
    order_id integer,
    txnid integer NOT NULL,
    amount character varying(255),
    refund_method character varying(255) NOT NULL,
    gateway character varying(255),
    issued_by integer,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.refund OWNER TO postgres;

--
-- Name: refund_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.refund_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.refund_id_seq OWNER TO postgres;

--
-- Name: refund_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.refund_id_seq OWNED BY public.refund.id;


--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    id integer NOT NULL,
    user_id integer NOT NULL,
    auth_token_hash character varying,
    session_start_time timestamp without time zone,
    session_end_time timestamp without time zone,
    os character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.session_id_seq OWNER TO postgres;

--
-- Name: session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.session_id_seq OWNED BY public.session.id;


--
-- Name: store; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(255) NOT NULL,
    owner_name character varying(255),
    shopkeeper_name character varying(255),
    image character varying(255),
    address_line_1 character varying(255),
    address_line_2 character varying(255),
    store_latitude double precision,
    store_longitude double precision,
    pay_later integer NOT NULL,
    delivery_mode integer NOT NULL,
    delivery_start_time character varying(255),
    delivery_end_time character varying(255),
    radius integer,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    city_id integer,
    commision double precision,
    walkin_order_tax integer,
    da_id integer,
    self_delivery_price double precision
);


ALTER TABLE public.store OWNER TO postgres;

--
-- Name: store_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_categories (
    id integer NOT NULL,
    store_id integer NOT NULL,
    category_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_categories OWNER TO postgres;

--
-- Name: store_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_categories_id_seq OWNER TO postgres;

--
-- Name: store_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_categories_id_seq OWNED BY public.store_categories.id;


--
-- Name: store_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_id_seq OWNER TO postgres;

--
-- Name: store_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_id_seq OWNED BY public.store.id;


--
-- Name: store_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_item (
    id integer NOT NULL,
    store_id integer NOT NULL,
    menu_category_id integer NOT NULL,
    name character varying(255) NOT NULL,
    brand_name character varying(255),
    image character varying(255),
    packaged integer,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_item OWNER TO postgres;

--
-- Name: store_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_item_id_seq OWNER TO postgres;

--
-- Name: store_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_item_id_seq OWNED BY public.store_item.id;


--
-- Name: store_item_uploads; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_item_uploads (
    id integer NOT NULL,
    store_id integer NOT NULL,
    user_id integer NOT NULL,
    file_name character varying(255) NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_item_uploads OWNER TO postgres;

--
-- Name: store_item_uploads_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_item_uploads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_item_uploads_id_seq OWNER TO postgres;

--
-- Name: store_item_uploads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_item_uploads_id_seq OWNED BY public.store_item_uploads.id;


--
-- Name: store_item_variable; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_item_variable (
    id integer NOT NULL,
    store_item_id integer,
    quantity integer,
    quantity_unit integer,
    mrp integer,
    selling_price integer,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    stock integer
);


ALTER TABLE public.store_item_variable OWNER TO postgres;

--
-- Name: store_item_variable_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_item_variable_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_item_variable_id_seq OWNER TO postgres;

--
-- Name: store_item_variable_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_item_variable_id_seq OWNED BY public.store_item_variable.id;


--
-- Name: store_localities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_localities (
    id integer NOT NULL,
    store_id integer NOT NULL,
    locality_id integer NOT NULL,
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_localities OWNER TO postgres;

--
-- Name: store_localities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_localities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_localities_id_seq OWNER TO postgres;

--
-- Name: store_localities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_localities_id_seq OWNED BY public.store_localities.id;


--
-- Name: store_menu_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_menu_categories (
    id integer NOT NULL,
    store_id integer NOT NULL,
    menu_category_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_menu_categories OWNER TO postgres;

--
-- Name: store_menu_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_menu_categories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_menu_categories_id_seq OWNER TO postgres;

--
-- Name: store_menu_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_menu_categories_id_seq OWNED BY public.store_menu_categories.id;


--
-- Name: store_merchants; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_merchants (
    id integer NOT NULL,
    store_id integer NOT NULL,
    merchant_id integer NOT NULL,
    status integer NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_merchants OWNER TO postgres;

--
-- Name: store_merchants_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_merchants_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_merchants_id_seq OWNER TO postgres;

--
-- Name: store_merchants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_merchants_id_seq OWNED BY public.store_merchants.id;


--
-- Name: store_mis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_mis (
    id integer NOT NULL,
    date timestamp without time zone NOT NULL,
    order_delivered integer,
    order_canceled integer NOT NULL,
    new_items_added integer NOT NULL,
    average_order_value double precision NOT NULL,
    total_order_value double precision NOT NULL,
    total_discount_value double precision NOT NULL,
    delivery_fees double precision NOT NULL,
    commision double precision,
    turnover double precision NOT NULL,
    total_tax double precision,
    store_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.store_mis OWNER TO postgres;

--
-- Name: store_mis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_mis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_mis_id_seq OWNER TO postgres;

--
-- Name: store_mis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_mis_id_seq OWNED BY public.store_mis.id;


--
-- Name: store_payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.store_payments (
    id integer NOT NULL,
    store_id integer NOT NULL,
    beneficiary_name character varying(255),
    name_of_bank character varying(100),
    ifsc_code character varying(55),
    vpa character varying(255),
    account_number character varying(100),
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    confirmed integer
);


ALTER TABLE public.store_payments OWNER TO postgres;

--
-- Name: store_payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.store_payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.store_payments_id_seq OWNER TO postgres;

--
-- Name: store_payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.store_payments_id_seq OWNED BY public.store_payments.id;


--
-- Name: storetaxes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.storetaxes (
    id integer NOT NULL,
    store_id integer NOT NULL,
    name character varying NOT NULL,
    description character varying,
    tax_type integer NOT NULL,
    amount double precision NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.storetaxes OWNER TO postgres;

--
-- Name: storetaxes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.storetaxes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.storetaxes_id_seq OWNER TO postgres;

--
-- Name: storetaxes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.storetaxes_id_seq OWNED BY public.storetaxes.id;


--
-- Name: super_admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.super_admin (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(100),
    active boolean,
    phone character varying(255) NOT NULL,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    image character varying
);


ALTER TABLE public.super_admin OWNER TO postgres;

--
-- Name: super_admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.super_admin_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.super_admin_id_seq OWNER TO postgres;

--
-- Name: super_admin_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.super_admin_id_seq OWNED BY public.super_admin.id;


--
-- Name: supervisor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supervisor (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(100),
    active boolean,
    phone character varying(255) NOT NULL,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    image character varying
);


ALTER TABLE public.supervisor OWNER TO postgres;

--
-- Name: supervisor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supervisor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supervisor_id_seq OWNER TO postgres;

--
-- Name: supervisor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supervisor_id_seq OWNED BY public.supervisor.id;


--
-- Name: supervisor_otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.supervisor_otp (
    id integer NOT NULL,
    "isVerified" boolean,
    counter integer,
    otp integer NOT NULL
);


ALTER TABLE public.supervisor_otp OWNER TO postgres;

--
-- Name: supervisor_otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.supervisor_otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.supervisor_otp_id_seq OWNER TO postgres;

--
-- Name: supervisor_otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.supervisor_otp_id_seq OWNED BY public.supervisor_otp.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    txnid integer NOT NULL,
    amount character varying(255),
    productinfo character varying(255),
    firstname character varying(255),
    email character varying(255),
    phone character varying(255),
    url character varying(255),
    hash_ character varying(255),
    key character varying(255),
    salt character varying(255),
    open_payment_token text,
    open_payment_data text,
    payu_gateway_response text,
    status character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transactions_id_seq OWNER TO postgres;

--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    password_hash character varying(100),
    active boolean,
    phone character varying(255) NOT NULL,
    role character varying(255),
    email_verified_at timestamp without time zone,
    phone_verified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    image character varying
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_address (
    id integer NOT NULL,
    user_id integer NOT NULL,
    address1 character varying(255),
    address2 character varying(255),
    address3 character varying(255),
    landmark character varying(255),
    phone character varying(255),
    latitude character varying(255),
    longitude character varying(255),
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    city_id integer
);


ALTER TABLE public.user_address OWNER TO postgres;

--
-- Name: user_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_address_id_seq OWNER TO postgres;

--
-- Name: user_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_address_id_seq OWNED BY public.user_address.id;


--
-- Name: user_cities; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_cities (
    id integer NOT NULL,
    user_id integer NOT NULL,
    city_id integer NOT NULL,
    role character varying(255),
    status integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone
);


ALTER TABLE public.user_cities OWNER TO postgres;

--
-- Name: user_cities_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_cities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_cities_id_seq OWNER TO postgres;

--
-- Name: user_cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_cities_id_seq OWNED BY public.user_cities.id;


--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_otp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_otp (
    id integer NOT NULL,
    "isVerified" boolean,
    counter integer,
    otp integer NOT NULL
);


ALTER TABLE public.user_otp OWNER TO postgres;

--
-- Name: user_otp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_otp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_otp_id_seq OWNER TO postgres;

--
-- Name: user_otp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_otp_id_seq OWNED BY public.user_otp.id;


--
-- Name: admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin ALTER COLUMN id SET DEFAULT nextval('public.admin_id_seq'::regclass);


--
-- Name: admin_otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_otp ALTER COLUMN id SET DEFAULT nextval('public.admin_otp_id_seq'::regclass);


--
-- Name: blacklist_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens ALTER COLUMN id SET DEFAULT nextval('public.blacklist_tokens_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities ALTER COLUMN id SET DEFAULT nextval('public.cities_id_seq'::regclass);


--
-- Name: city_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_categories ALTER COLUMN id SET DEFAULT nextval('public.city_categories_id_seq'::regclass);


--
-- Name: citymisdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citymisdetail ALTER COLUMN id SET DEFAULT nextval('public.citymisdetail_id_seq'::regclass);


--
-- Name: coupon_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_categories ALTER COLUMN id SET DEFAULT nextval('public.coupon_categories_id_seq'::regclass);


--
-- Name: coupon_cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_cities ALTER COLUMN id SET DEFAULT nextval('public.coupon_cities_id_seq'::regclass);


--
-- Name: coupon_merchants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_merchants ALTER COLUMN id SET DEFAULT nextval('public.coupon_merchants_id_seq'::regclass);


--
-- Name: coupon_stores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_stores ALTER COLUMN id SET DEFAULT nextval('public.coupon_stores_id_seq'::regclass);


--
-- Name: coupons id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons ALTER COLUMN id SET DEFAULT nextval('public.coupons_id_seq'::regclass);


--
-- Name: delivery_agent id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_agent ALTER COLUMN id SET DEFAULT nextval('public.delivery_agent_id_seq'::regclass);


--
-- Name: distributor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distributor ALTER COLUMN id SET DEFAULT nextval('public.distributor_id_seq'::regclass);


--
-- Name: hub id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub ALTER COLUMN id SET DEFAULT nextval('public.hub_id_seq'::regclass);


--
-- Name: hub_bank_details id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_bank_details ALTER COLUMN id SET DEFAULT nextval('public.hub_bank_details_id_seq'::regclass);


--
-- Name: hub_order_lists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_lists ALTER COLUMN id SET DEFAULT nextval('public.hub_order_lists_id_seq'::regclass);


--
-- Name: hub_order_tax id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_tax ALTER COLUMN id SET DEFAULT nextval('public.hub_order_tax_id_seq'::regclass);


--
-- Name: hub_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_orders ALTER COLUMN id SET DEFAULT nextval('public.hub_orders_id_seq'::regclass);


--
-- Name: hubtaxes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hubtaxes ALTER COLUMN id SET DEFAULT nextval('public.hubtaxes_id_seq'::regclass);


--
-- Name: item_order_lists id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_lists ALTER COLUMN id SET DEFAULT nextval('public.item_order_lists_id_seq'::regclass);


--
-- Name: item_order_tax id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_tax ALTER COLUMN id SET DEFAULT nextval('public.item_order_tax_id_seq'::regclass);


--
-- Name: item_orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_orders ALTER COLUMN id SET DEFAULT nextval('public.item_orders_id_seq'::regclass);


--
-- Name: localities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localities ALTER COLUMN id SET DEFAULT nextval('public.localities_id_seq'::regclass);


--
-- Name: menu_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_categories ALTER COLUMN id SET DEFAULT nextval('public.menu_categories_id_seq'::regclass);


--
-- Name: merchant id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant ALTER COLUMN id SET DEFAULT nextval('public.merchant_id_seq'::regclass);


--
-- Name: merchant_otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_otp ALTER COLUMN id SET DEFAULT nextval('public.merchant_otp_id_seq'::regclass);


--
-- Name: merchant_transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_transactions ALTER COLUMN id SET DEFAULT nextval('public.merchant_transactions_id_seq'::regclass);


--
-- Name: misdetail id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.misdetail ALTER COLUMN id SET DEFAULT nextval('public.misdetail_id_seq'::regclass);


--
-- Name: notification id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification ALTER COLUMN id SET DEFAULT nextval('public.notification_id_seq'::regclass);


--
-- Name: notification_templates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates ALTER COLUMN id SET DEFAULT nextval('public.notification_templates_id_seq'::regclass);


--
-- Name: progress id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress ALTER COLUMN id SET DEFAULT nextval('public.progress_id_seq'::regclass);


--
-- Name: quantity_unit id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantity_unit ALTER COLUMN id SET DEFAULT nextval('public.quantity_unit_id_seq'::regclass);


--
-- Name: refund id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund ALTER COLUMN id SET DEFAULT nextval('public.refund_id_seq'::regclass);


--
-- Name: session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session ALTER COLUMN id SET DEFAULT nextval('public.session_id_seq'::regclass);


--
-- Name: store id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store ALTER COLUMN id SET DEFAULT nextval('public.store_id_seq'::regclass);


--
-- Name: store_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_categories ALTER COLUMN id SET DEFAULT nextval('public.store_categories_id_seq'::regclass);


--
-- Name: store_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item ALTER COLUMN id SET DEFAULT nextval('public.store_item_id_seq'::regclass);


--
-- Name: store_item_uploads id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_uploads ALTER COLUMN id SET DEFAULT nextval('public.store_item_uploads_id_seq'::regclass);


--
-- Name: store_item_variable id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_variable ALTER COLUMN id SET DEFAULT nextval('public.store_item_variable_id_seq'::regclass);


--
-- Name: store_localities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_localities ALTER COLUMN id SET DEFAULT nextval('public.store_localities_id_seq'::regclass);


--
-- Name: store_menu_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_menu_categories ALTER COLUMN id SET DEFAULT nextval('public.store_menu_categories_id_seq'::regclass);


--
-- Name: store_merchants id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_merchants ALTER COLUMN id SET DEFAULT nextval('public.store_merchants_id_seq'::regclass);


--
-- Name: store_mis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_mis ALTER COLUMN id SET DEFAULT nextval('public.store_mis_id_seq'::regclass);


--
-- Name: store_payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_payments ALTER COLUMN id SET DEFAULT nextval('public.store_payments_id_seq'::regclass);


--
-- Name: storetaxes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storetaxes ALTER COLUMN id SET DEFAULT nextval('public.storetaxes_id_seq'::regclass);


--
-- Name: super_admin id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.super_admin ALTER COLUMN id SET DEFAULT nextval('public.super_admin_id_seq'::regclass);


--
-- Name: supervisor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor ALTER COLUMN id SET DEFAULT nextval('public.supervisor_id_seq'::regclass);


--
-- Name: supervisor_otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor_otp ALTER COLUMN id SET DEFAULT nextval('public.supervisor_otp_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: user_address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address ALTER COLUMN id SET DEFAULT nextval('public.user_address_id_seq'::regclass);


--
-- Name: user_cities id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_cities ALTER COLUMN id SET DEFAULT nextval('public.user_cities_id_seq'::regclass);


--
-- Name: user_otp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_otp ALTER COLUMN id SET DEFAULT nextval('public.user_otp_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, email, name, password_hash, active, phone, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at, image) FROM stdin;
1	singharanajeet32@gmail.com	Ranajeet Singha	$2b$12$.zkUbHiqpaR3s0t3NoqCG.TEqg7p.t96VAex6QuMaaEznCjkN.FxG	f	7001438619	admin	\N	\N	2021-07-27 02:36:37.508824	2021-07-27 02:36:37.504325	\N	\N
2	r@email.cog	Saam	$2b$12$0cOaT0T/ndGZNtO9W57jC..M7mgMRSyDrkbx7CCmEbDAuc99Pwhly	f	54633543	admin	\N	\N	2021-07-27 05:39:20.232108	2021-07-27 05:39:20.227251	\N	\N
3	test@gmail.com	test1	$2b$12$10gp5oRLnxxlR9vatzY06.2U4fBXr1Io4xD5f6RR8ucccU2f37VQ2	f	764545	admin	\N	\N	2021-07-27 10:43:15.136258	2021-07-27 10:43:15.131549	\N	\N
4	rfn@email.com	fgxj	$2b$12$QkqsZ.CZAFnbYPkwSauF7OxQtltEapK2KOmd4LsbHpjXys/sRmGPC	f	700143864534	admin	\N	\N	2021-07-27 10:46:25.584697	2021-07-27 10:46:25.579861	\N	\N
5	rnc@email.com	bhgkvh	$2b$12$EEvtmcpW2TL5hPYUKT4Gvef0Y5x2sQ3tnnSpt.KAM.pe.7MAn.p1O	f	70014386	admin	\N	\N	2021-07-27 10:46:43.754415	2021-07-27 10:46:43.749882	\N	\N
6	rzdfa@email.com	nxngxzn	$2b$12$s6kYeOyD46rWVxNzkIekUOCGNJ1WKlJWOsTSdChMJOf5P9Yz3acp2	f	7001438653	admin	\N	\N	2021-07-27 10:47:31.254556	2021-07-27 10:47:31.249927	\N	\N
7	jjer@email.com	jee	$2b$12$VA0.TgVoEFxGcfDEo4dwd./lbkMWKxWRTkaFNqWKYhrB9.FMixhha	f	7001	admin	\N	\N	2021-07-28 14:41:42.96776	2021-07-28 14:41:42.963308	\N	\N
8	rrrr@email.com	rrrr	$2b$12$x9QP6nQBKlBZUd33spiDUuoZik./XtlZWftKIBHoIxOJwtN.uz68u	f	432432435	admin	\N	\N	2021-08-05 11:51:06.393016	2021-08-05 11:51:06.386961	\N	\N
9	fafylity@demo.com	foy	$2b$12$Iyd7VDZEomf2bCtCBSMZy.AC0p7H2vu8hQ9UfMc08bXuX5xEO.58i	f	55	admin	\N	\N	2021-08-25 02:39:47.484775	2021-08-25 02:39:47.480029	\N	\N
10	Ghjjojihhuououoc	Fgghhjjjjj	$2b$12$yMwIh/kdw7b42Uo9lLG9lu7qr7Q.Bu2L6sOyKqB6Z544N8Mr1kDIa	f	7654323677	admin	\N	\N	2021-08-25 13:07:01.112205	2021-08-25 13:07:01.107205	\N	\N
11	roadmin@gmail.com	ro admin	$2b$12$p.mh8LVm0wAhqOB5DyDjgumsW3rZfBZhNxNq6uM0wz0.4deBS4k2S	f	1234567890	admin	\N	\N	2021-08-31 10:05:23.53658	2021-08-31 10:05:23.531003	\N	\N
12	anuraj	Anuraj	$2b$12$SiPMKQ5Nb1Llq54mtlUOjex3rNvtKOZmDcknZHFIhHc62e21V/NQ6	f	9007712266	admin	\N	\N	2021-09-04 05:10:11.178619	2021-09-04 05:10:11.172155	\N	\N
13	r	r	$2b$12$zk53q5HAlDEYWLlCTtbkNueOHschYj2q8Sj4ooQ5VIe7e4Qik5pkG	f	1	admin	\N	\N	2021-09-06 07:57:04.705691	2021-09-06 07:57:04.70067	\N	\N
14	praja.ritika.94@gmail.com	uvdui	$2b$12$flRvYzFPwg8uQkA80cNzoO.43wwSwGeNQuQ8RhsfK1AktbISuyChG	f	08757445651	admin	\N	\N	2021-09-30 09:04:03.104165	2021-09-30 09:04:03.097892	\N	\N
15	jkd@gmail.com	xdwcwed	$2b$12$oJAeiQhN1DQYfB.gqoZv4ebO0Rhl6eAc6/nXahE5Ml.4mZHq8i6v2	f	08757445655	admin	\N	\N	2021-09-30 09:08:12.379456	2021-09-30 09:08:12.37425	\N	\N
16	pra.ritika.94@gmail.com	dwed prajapati	$2b$12$0W5IKb8ph56UJ46p.F0lDOR2yffqV0/uHlmIvwk9uLsNsTSqCUHTC	f	08757445653	admin	\N	\N	2021-09-30 09:10:06.659464	2021-09-30 09:10:06.654538	\N	\N
17	nups@gmail.com	Nupur Pandey	$2b$12$176VzvfvRVKxoOI7Yr0v7eNnLZGKH.7SdciTB.q/grX3z.1cxkcn2	f	477687979665	admin	\N	\N	2021-09-30 09:16:32.115681	2021-09-30 09:16:32.108971	\N	\N
\.


--
-- Data for Name: admin_otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin_otp (id, "isVerified", counter, otp) FROM stdin;
\.


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
f0b235a0aedf
\.


--
-- Data for Name: blacklist_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.blacklist_tokens (id, token, blacklisted_on) FROM stdin;
1	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODMxNTEsImlhdCI6MTYyNjA5Njc0Niwic3ViIjoyNn0.W9P7v431snqCbn8lR8nkXSmmu9p7HygMsE31MYj9c6Q	2021-07-12 13:32:46.388534
2	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODI4MzksImlhdCI6MTYyNjA5NjQzNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.I-qJHtE76efcr-tFRYcsnEkPxukBNKfMr7LjReJ9V8k	2021-07-12 13:33:23.040687
3	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxNjkxMTAsImlhdCI6MTYyNjA4MjcwNSwic3ViIjo2LCJyb2xlIjoibWVyY2hhbnQifQ.bK8B3BD0Zt43x7YNoBkp1edGasZDrDQH5zwD0jo81QE	2021-07-12 14:34:32.138516
4	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODY5MjYsImlhdCI6MTYyNjEwMDUyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.80_CUA1wXuntCnAymTI9IOS1qrkyxbck9yTqVsP-VxM	2021-07-12 14:37:22.203048
5	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODcwNTEsImlhdCI6MTYyNjEwMDY0Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ceGe_0LwdH8X5tW_UGM9ywBAePkhfp6UxNxS3-A3OI0	2021-07-12 14:42:26.646329
6	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODgyNjAsImlhdCI6MTYyNjEwMTg1NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.tSqN5-8AqNrxne0AbTXB2PVRIdL2WEcXTEKggs7RDEk	2021-07-12 17:10:05.151375
7	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODM1ODUsImlhdCI6MTYyNjA5NzE4MCwic3ViIjoxfQ.pHmo6jK2TcwL8PX38BI4ubZbdWPV1TR7IT-F9ANDIQI	2021-07-13 07:16:36.236888
8	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNDgzMjQsImlhdCI6MTYyNjE2MTkxOSwic3ViIjoyfQ.9-AwzAhw5i9-lvREz14GAMxvTYp8nRsOdU3YW9d-uFU	2021-07-13 07:39:19.571503
9	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYxODczNTYsImlhdCI6MTYyNjEwMDk1MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ameEc5isgWq9WglbJbvExKM3UrR0rsnItuMlvDEf6tI	2021-07-13 07:42:12.820301
10	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNDgzNzgsImlhdCI6MTYyNjE2MTk3Mywic3ViIjoyfQ.bjcf7UWO_871ftEWghrKS-r9IpSRtJICovCNSJ77qZU	2021-07-13 07:50:38.819047
11	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNDg1NDYsImlhdCI6MTYyNjE2MjE0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.31g7LXoTmZNC51wAxFM7CaPeHs5dVMX27ZL2xWexNN4	2021-07-13 08:05:26.561948
12	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNDk5MzUsImlhdCI6MTYyNjE2MzUzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FwippLcjUjndOkyNOsNLowjEqud09PvGFFJVSaI-YwA	2021-07-13 08:17:41.014047
13	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNTA2NzMsImlhdCI6MTYyNjE2NDI2OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.zOnkeRri52ifs4m34nLx5zCnEk5QLDxyjvepPZa-LHE	2021-07-13 12:42:01.760384
14	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNjY4NDgsImlhdCI6MTYyNjE4MDQ0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QHmXR88N-g1lakSw8Q3S_9sbHhLXpSD19g-mpPTKBJM	2021-07-13 13:25:56.821636
15	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNjkxNjYsImlhdCI6MTYyNjE4Mjc2MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.E6VZS4IFzxV-IzRLxi7XlnetqvJ5R0MsRvnJaTVkPDQ	2021-07-13 13:57:41.741238
16	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNDkwOTksImlhdCI6MTYyNjE2MjY5NCwic3ViIjoyfQ.GRrrf4VuueiMyAe9VjVxLkZCZb52LJfC0rbCCPjDpvw	2021-07-13 18:50:17.162976
17	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYyNzEwODgsImlhdCI6MTYyNjE4NDY4Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.GB76G3nUNlIrtIxh9sEz3VbpreX2ECLS651lUrDMJQc	2021-07-14 05:09:10.495806
18	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjU3NTksImlhdCI6MTYyNjIzOTM1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.wcUeR3tQ-bvJYofoZLsxZ47hLCcpX6pUDxmfhzuo2sI	2021-07-14 05:12:46.952257
19	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjU5NzcsImlhdCI6MTYyNjIzOTU3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mGWJokFeIoBjQdPwcXC9ov-SxjG3KvMf1_up3ZNEFpw	2021-07-14 05:17:18.644316
20	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjY2MjYsImlhdCI6MTYyNjI0MDIyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.PDmSGEE_p6G7BWIj5Jmb5d2F9Ys08nodE9JbU4Yxlg8	2021-07-14 05:59:40.274906
21	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjg3ODksImlhdCI6MTYyNjI0MjM4NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.aezUBExDTYaQEq7QNUuDW6xA-Le8edmxHQCEAgRzDoc	2021-07-14 06:28:44.362764
22	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjg5NDcsImlhdCI6MTYyNjI0MjU0Miwic3ViIjoyfQ.BIWaKAqjdm3J0MGd3LfyMm2-gFa2nd3zuj2VgnHkZgo	2021-07-14 07:41:51.944445
23	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMjk4NzUsImlhdCI6MTYyNjI0MzQ3MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.QSG4FxHDsQAHviwegiyQv7xfcSYhSna3w9-2D7pT8UU	2021-07-14 07:49:18.975553
24	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzMzA1NjAsImlhdCI6MTYyNjI0NDE1NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YwMOAHkr6IloW1OFQU0yp5I6CS3lX6Hd2mrks_XF20E	2021-07-14 10:07:46.950537
25	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzNDM2NzYsImlhdCI6MTYyNjI1NzI3MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Xgfy3Iso1t9Nic9dD4C8Kb3MUavfqimzYG1TqbCDYKo	2021-07-14 10:10:08.162899
26	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzNDM4MTcsImlhdCI6MTYyNjI1NzQxMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9u4cSYatmlkLYbLZD91dAw_SBelC-0I-JJF61iZeTa4	2021-07-14 13:48:51.102778
27	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzNTc1NDAsImlhdCI6MTYyNjI3MTEzNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mmgIbEkgXZINIufyn9dRmp0eJIqIOm0OsoSUug7mVpI	2021-07-14 14:03:04.198427
28	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzNTc3OTYsImlhdCI6MTYyNjI3MTM5MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.QNIEJn_XLaTuH335SvSOOCjMK3a5i6y-yNeia9xeP3k	2021-07-14 14:03:37.348177
29	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjYzNTc4MzAsImlhdCI6MTYyNjI3MTQyNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.koMskAkSV3zxmAKz7oxzoBbAMhdvmppWEc_fEmnmj-M	2021-07-15 05:28:04.205658
30	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0MTMyOTYsImlhdCI6MTYyNjMyNjg5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.IKZXlh9stmlOk20KrjctUBCFRhW4FY5kM39hX444ly4	2021-07-15 07:23:29.086644
31	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0MjAyMjIsImlhdCI6MTYyNjMzMzgxNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bwhXwB8nOBsCQAbRSuI8JZ-GXRxZRJJqMyQzqP_5C14	2021-07-15 07:24:16.371887
32	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0MjAzMDksImlhdCI6MTYyNjMzMzkwNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.JY9PKGj5VgCfqWVkT0MY1rSsemienNlng06AUGt6iJQ	2021-07-15 07:25:26.778529
33	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0MjAzMzYsImlhdCI6MTYyNjMzMzkzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kS7ktiDi9FxFD376zkeW7IFWbsSPgiZc7g1YimtD85g	2021-07-15 09:05:02.02415
34	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0Mjc0OTcsImlhdCI6MTYyNjM0MTA5Miwic3ViIjoyfQ.UScxwOb-I3dQeINWOFAxdQR4mCjxYo9yYqliSsxuwXk	2021-07-15 09:24:59.160222
35	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0MjYzMTEsImlhdCI6MTYyNjMzOTkwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.By_8CXmzW2SlyjQeDOxdMevrFoRTYZfZKmxRpD7Dxic	2021-07-15 14:01:44.840389
36	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY0NDQxMTQsImlhdCI6MTYyNjM1NzcwOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.j8nC7y-c-6UPuZpktTlQUlxV1qXMrXICWMm-HBKrtrU	2021-07-16 06:45:08.084194
37	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MDQzMTksImlhdCI6MTYyNjQxNzkxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cgj0fnVli56b06JYD6pFJ18tAYtbHhrexGs5HH-4s64	2021-07-16 07:29:39.468086
38	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MDY5ODgsImlhdCI6MTYyNjQyMDU4Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Rq3d0CbTkUlhpGDtQ7KH4vmeiZAbJNuAKd_mfhIJa7I	2021-07-16 07:40:33.137756
39	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MDc2NDMsImlhdCI6MTYyNjQyMTIzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YvUoRDgPTHl2vqATW0G9bf6AP-4NkwPMk40PQrsedV8	2021-07-16 12:45:02.892233
40	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MjU5MTIsImlhdCI6MTYyNjQzOTUwNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.vpbGyOvMMrFPqNZOWJZVi_35kOJJWvYjmBzgNXGZUrA	2021-07-16 12:47:15.067928
41	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MjYwNDUsImlhdCI6MTYyNjQzOTY0MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SN7QAg5vpVZ94XykaaCq-khltyLXysofH9CiKCdcLNI	2021-07-16 12:52:16.495623
42	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MjYzNDYsImlhdCI6MTYyNjQzOTk0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KzA8zLvx3R4sk_2d_0ZqZ_yZ5r3LkhGL0xUgOYQdj0U	2021-07-16 13:23:07.129477
43	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MjgyMTksImlhdCI6MTYyNjQ0MTgxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.igmmEuqlkkqrU-sCfGrqgrRq0-N9GyPPxx61r_I2mKM	2021-07-16 13:24:20.867347
44	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY1MjgyNzAsImlhdCI6MTYyNjQ0MTg2NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.jYVmv2gUVj8ilD4uupXRbLbViWyDfewof7XPrm3-7Ps	2021-07-16 15:47:45.925928
45	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY2MDIxMTEsImlhdCI6MTYyNjUxNTcwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.j2q8zEjvtnfbdnEApXY4gpVE7YnM9GmiCM3ZwNAOAwY	2021-07-17 09:56:11.455034
46	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY2MDIxODIsImlhdCI6MTYyNjUxNTc3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LdX7f1FwFKJTfoGpBu4Z5F8rJ-TGSnuFFEDz5M8DKlM	2021-07-17 10:18:49.341857
47	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY2MDM1NDEsImlhdCI6MTYyNjUxNzEzNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Hqp8s9FiLEZFE8dAsGnxBnqHqkleeR6wZkKFnJAFbjQ	2021-07-17 12:04:56.773652
48	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NTc1MDUsImlhdCI6MTYyNjY3MTEwMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.K_z2KvCglm-NBd1gSUt4umTify2tH4erskkQWHhCcI0	2021-07-19 05:44:32.20006
49	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NTk4ODIsImlhdCI6MTYyNjY3MzQ3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.wUsvjGbRzSTMhO_qOFTywNg7aQtnfv9Vj4rt6KF4nAQ	2021-07-19 06:09:27.39411
50	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NjEzNzcsImlhdCI6MTYyNjY3NDk3Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.v59Vzafth1K6KLztRj8IgR03WBT85xGReZYaMj5bRXk	2021-07-19 06:36:57.630032
51	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NjMwMjgsImlhdCI6MTYyNjY3NjYyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FjGTI9gzXb_PH1a7p_5OVjG8qhoJH26kPOKeOp6MQpo	2021-07-19 06:43:23.554902
52	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NjM0MTIsImlhdCI6MTYyNjY3NzAwNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gk93I4b3EL5Dz2nrsHfEeQP1Vs833XiafYdOn4K5Ffg	2021-07-19 07:26:42.159429
53	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NjYwMTYsImlhdCI6MTYyNjY3OTYxMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XIxeG1wBjDLpYi-CgucAf4LTd4QMyBMcdRlUH6jXGj0	2021-07-19 08:59:58.776977
54	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NzE2MDksImlhdCI6MTYyNjY4NTIwNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.1G8GcZSSvZFB5NyziUuunPwb_47qEtJjo1E8IAwodB8	2021-07-19 09:06:45.102703
55	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NzIwMTUsImlhdCI6MTYyNjY4NTYxMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4CEI8iqdQ7ydMUGEU2sRkn3CjDcln4CKwfLbFuCwzyE	2021-07-19 09:07:17.10312
56	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY2OTQ0NTAsImlhdCI6MTYyNjYwODA0NSwic3ViIjoyfQ.59_Ri1aaB2sfFIuZPp3TK_7Dc_dJHML2cR9HuRdti8s	2021-07-19 10:37:58.76692
57	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3NzIwNDksImlhdCI6MTYyNjY4NTY0NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XtnuR4cy0hTUhdhPcHDAF6ZduqmUFhSwc46CcNiiLGc	2021-07-19 10:42:01.439115
58	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3Nzc1NjAsImlhdCI6MTYyNjY5MTE1NSwic3ViIjoyfQ.nPaV83hdMWWjjg3XhwNCpxO-GgKZsvdBtMn5AWpot0s	2021-07-19 11:30:32.065446
59	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3Nzc3MzAsImlhdCI6MTYyNjY5MTMyNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Oxtou33d4h2tgENRwYKEaQhIkTebtNHXwpLm_aocQYo	2021-07-19 14:04:58.244721
60	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3ODk5MDcsImlhdCI6MTYyNjcwMzUwMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.nXPZfQdD7H1bbLbPQJi0NczxeaTFo02CNEAaH6lxzWk	2021-07-19 14:37:33.173761
61	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3OTE4NjMsImlhdCI6MTYyNjcwNTQ1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.z-ygwCBjygDK_OgPvvPFIDmNzwLrDFKkTW2BA4fuvM4	2021-07-19 17:17:37.761781
62	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4MDE0NjgsImlhdCI6MTYyNjcxNTA2Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RUy4WfJsWHnUtpcxIIRj7tbuMyFj_BmDbwNRfHtB_7k	2021-07-19 17:19:07.123376
63	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4MDE1NTYsImlhdCI6MTYyNjcxNTE1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RBwJJBJWiFzafvS5mu_pXByR-OZa00dUepSKmCrWjOs	2021-07-19 17:38:59.240754
64	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4MDI3NTIsImlhdCI6MTYyNjcxNjM0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.pLjYNMCDu_iZj_7fI-oMAjNLzPez23SqH8q3OY6AHTE	2021-07-20 05:33:13.257188
65	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4NDU2MDUsImlhdCI6MTYyNjc1OTIwMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sZXeudv71VkdcT16ZG8drgmyo5NedCsTfcvtU8HfTis	2021-07-20 05:34:47.537856
66	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4NDU2OTgsImlhdCI6MTYyNjc1OTI5Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.zgAU1NybJnvPlQl_ahsTWDPUPLt7XB03FUngUTT3nOE	2021-07-20 09:22:46.248306
67	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY3ODA2NTEsImlhdCI6MTYyNjY5NDI0Niwic3ViIjoyfQ.DF6FGjzghNtPrRd93-PKvkkBggKQ1br-YzaifTEZ3FE	2021-07-20 10:26:01.209031
68	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4NjMxOTMsImlhdCI6MTYyNjc3Njc4OCwic3ViIjoyfQ.5zjAZcajZAMk36M7iEzzorHAzOyWWxDxWZWhHh8NejI	2021-07-20 12:16:58.947734
69	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY4NzAyODYsImlhdCI6MTYyNjc4Mzg4MSwic3ViIjo0fQ.g4R3s4xxwxxtpAxPaYBG-d-8v_5lF3TOdp6p6JNHbsw	2021-07-20 12:25:35.126785
70	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NDU0NjksImlhdCI6MTYyNjg1OTA2NCwic3ViIjoyfQ.KqKNZAjMRwzoDiNUL2_FRMU8xNWfxPriUco6NC-lMMs	2021-07-21 09:20:54.11555
71	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NDU2NzcsImlhdCI6MTYyNjg1OTI3Miwic3ViIjoyfQ.o5ffmClfU9_6VcDKYYT4wkP11-MJpue3DS8Ezu7wLos	2021-07-21 09:21:40.888532
72	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NDU3MzksImlhdCI6MTYyNjg1OTMzNCwic3ViIjo0fQ.53VLJUC5RPXmviSt8xInSU6d5e09fu8ZeMkkbkwj0dU	2021-07-21 09:23:25.19255
73	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NTEwMDAsImlhdCI6MTYyNjg2NDU5NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.uPREP1mv4ERzc_-CSwwa7mkn3ETs2rwjuoCuEe4MDb0	2021-07-21 10:50:05.200672
74	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NDY0MTMsImlhdCI6MTYyNjg2MDAwOCwic3ViIjoyfQ.dPI8lGcGkdPolR9zDEoOW7n-7Rs-21WUvjUXoTbbPpo	2021-07-21 11:42:41.458358
75	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NTY5NDEsImlhdCI6MTYyNjg3MDUzNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.80WXZbXyyWUFisKwRdpWomhfQcS5WxNCbKqxTBR-fFc	2021-07-21 13:46:04.35087
76	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NTQxOTQsImlhdCI6MTYyNjg2Nzc4OSwic3ViIjoyfQ.NcqaRT1wCfGdAwAJfbzMqFp7tANvRAfG7Q7T3kNft5g	2021-07-21 15:30:21.186639
77	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5Njc4NjcsImlhdCI6MTYyNjg4MTQ2Miwic3ViIjoyfQ.BY3Ia-7mz_yEnVDybYDu5l-UXnksvUU8DF41OsWVsyw	2021-07-21 15:45:56.981044
78	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NzI0ODksImlhdCI6MTYyNjg4NjA4NCwic3ViIjoyfQ.Aq84c8cj5KQcstTGicZGhZF6n1tbiGLZn_UXOj90ltw	2021-07-21 17:13:27.708966
79	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NzQwNzMsImlhdCI6MTYyNjg4NzY2OCwic3ViIjoyfQ.b207POUsMSkDoyYBskxjwGurno_o60N8m3uWhFZVvgo	2021-07-21 17:38:35.56713
80	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NzU1NDAsImlhdCI6MTYyNjg4OTEzNSwic3ViIjoyfQ.lCPj6k1W3HGcWrnLNiljXL28_SIKjg2i0kzjn6RlA2M	2021-07-21 18:05:35.011029
81	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NzcxNjIsImlhdCI6MTYyNjg5MDc1Nywic3ViIjoyfQ.HJs9gMNcegpBWmvA1hFtKKQXMR9jZRbdqFXFnYTOSRQ	2021-07-21 18:31:39.297228
82	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5Nzg3MjMsImlhdCI6MTYyNjg5MjMxOCwic3ViIjoyfQ.6FGdu8sf0gOLmwWRYHWl5y6O_rEFtU9StccRPq0bqKY	2021-07-21 18:49:56.946868
83	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5Nzk4MTUsImlhdCI6MTYyNjg5MzQxMCwic3ViIjoyfQ.jeyIddfzHAZmP2rXmS6d3_KoIbgz3DfYNvNMRKQ-xjg	2021-07-22 05:57:40.004314
84	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMTk4OTMsImlhdCI6MTYyNjkzMzQ4OCwic3ViIjoyfQ.JVXaZJq7BHrMnQ-xd4NdYN774N4cr-hjY_tF2FDioB8	2021-07-22 06:12:00.638787
85	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjY5NjE2MzQsImlhdCI6MTYyNjg3NTIyOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.rkA6_zUoDIiphRLO1EOM_q90OKdXP2EUXsw89jruM94	2021-07-22 09:52:56.467386
86	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMzM5ODcsImlhdCI6MTYyNjk0NzU4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.A93le8eI2ASPL3LM6Ay3lAODNj88t2foWpMmMibCRvs	2021-07-22 10:16:47.788613
87	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMzU0MTgsImlhdCI6MTYyNjk0OTAxMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cJO16CwQg6dugdWv0Z3AjSQmK2vQQU06upGUGuVyirs	2021-07-22 10:21:08.019642
88	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMDQ0MjEsImlhdCI6MTYyNjkxODAxNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9p8CoGrxYvUhvmSnmsG5rY1LWdvO67UPMQWebMdfUXI	2021-07-22 11:02:28.360499
89	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMzU2NzcsImlhdCI6MTYyNjk0OTI3Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.5NusPFRz7j5bJ5cJ6wg4tBaBKgjM9RG1rCsjMVQ9xC0	2021-07-22 11:03:12.542746
90	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMjA3NDAsImlhdCI6MTYyNjkzNDMzNSwic3ViIjoyfQ.daqmWBbDD6nkxzb3oicEpq8qnZvbk12bEU_v9fAcEuk	2021-07-22 11:56:04.305425
91	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwNDYxNzMsImlhdCI6MTYyNjk1OTc2OCwic3ViIjoyfQ.TbOBz55Kan0BOP3DDzJK-EpPJ-RuPh84FFRyqxVXYO4	2021-07-22 13:17:19.944503
92	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwNDQ3NzAsImlhdCI6MTYyNjk1ODM2NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qIkHs4-NnbhGiqIlJWWyAcFFTqzwNA_bWhFFyOVo4sM	2021-07-22 13:53:27.690713
93	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwNDczMDcsImlhdCI6MTYyNjk2MDkwMiwic3ViIjoyfQ.4v_C14BxPs9CvTg7O7_34cZVSZ8r7ulI9FIy1kybCkI	2021-07-22 14:41:27.006379
94	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwMzgyMTksImlhdCI6MTYyNjk1MTgxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.UsF-aIZ3_R0NWbefm-uYpFxFrDC1AiT7VeNe6ENiV5Y	2021-07-22 15:00:56.348884
95	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwNTEzMjMsImlhdCI6MTYyNjk2NDkxOCwic3ViIjoyfQ.irhsFYjxSWd9wK6Jstr7uCdzqleum2kMAHdQCpI5PpU	2021-07-23 02:47:14.550749
96	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwOTQ4NjgsImlhdCI6MTYyNzAwODQ2Mywic3ViIjoyfQ.ktDWDgTJvRBZIy0mRa_Ao0RHSyVgiqdyjwsefgYaxn4	2021-07-23 03:19:02.440552
97	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwOTY3NjUsImlhdCI6MTYyNzAxMDM2MCwic3ViIjoyfQ.ScGS0C-BrBsymBltZOu_DD8Lx0zCrRPx0Rwu3u49UV8	2021-07-23 03:47:36.109083
98	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcwOTg0ODAsImlhdCI6MTYyNzAxMjA3NSwic3ViIjoyfQ.18sbvVF58uAqQexYb3ZS7ZnbBDoPS3z-2bOwiLQpP5k	2021-07-23 09:25:17.602354
99	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMTg3NjIsImlhdCI6MTYyNzAzMjM1Nywic3ViIjoyfQ.pQGZiERE5Kbil0xtf_rWxRMkUgR7BsBxQwDwQx6UOAg	2021-07-23 09:50:10.170773
100	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMjAzNzUsImlhdCI6MTYyNzAzMzk3MCwic3ViIjo1fQ.zT6QongE7uvItDHuBz73GiVKcT2AtxYOHhhbTxhPeEc	2021-07-23 10:00:59.989255
101	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMjEwMTIsImlhdCI6MTYyNzAzNDYwNywic3ViIjo2fQ.e1mjl7trhgkL2sl3-nqE8Ilx3YRRgJUccY_T91THatg	2021-07-23 10:08:55.858912
102	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMjEzNTksImlhdCI6MTYyNzAzNDk1NCwic3ViIjo2fQ.vrN583qw4hFgYgB0aNcY3MEl1J7EopCbLgvPtg-Gg8U	2021-07-23 10:10:18.921662
103	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMjE0MzQsImlhdCI6MTYyNzAzNTAyOSwic3ViIjo2fQ.jqo_JCQM1JWw6xrPfupn9h2Mh5dFytNfp9S5zSBYhQk	2021-07-23 13:28:52.405034
104	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMjg2ODQsImlhdCI6MTYyNzA0MjI3OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.PkQFkRLEiStAmafny7d5mGwzwMHjAG6XDn6OjMQco60	2021-07-23 13:35:43.250242
105	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcxMzMzNTgsImlhdCI6MTYyNzA0Njk1Mywic3ViIjo2fQ.hRLHPUkrsTQ7ar2kdjsBJJw4uBz220Dmv8o5AaEDStQ	2021-07-24 08:09:06.608794
106	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcyMDA3MTgsImlhdCI6MTYyNzExNDMxMywic3ViIjo2fQ.BsGxYi1e-91TN9Y0FQKdvNDKrztfGIp6L0c2FOefDwQ	2021-07-24 08:44:32.21289
107	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjcyMDI4MzEsImlhdCI6MTYyNzExNjQyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dU-GRwtAbUdO62J-eZLhYrD7aFjelOGqexRZfOod858	2021-07-24 08:47:26.859977
108	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczNjYzOTYsImlhdCI6MTYyNzI3OTk5MSwic3ViIjo2fQ.BIaIOLMykR802gmWujRaiGfs8awPLSv5AGSN2WctuWU	2021-07-26 06:14:09.346528
109	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczNzk2MjMsImlhdCI6MTYyNzI5MzIxOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KiIZIenKKv2t2_DSL2boThw5e5rW4Sr5r2ZwLivKqlM	2021-07-26 10:20:39.49967
110	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODEyNjcsImlhdCI6MTYyNzI5NDg2Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XF-xRJvEKjigjpvke65dPzRnhymA9cGjIwrnV8gh_lk	2021-07-26 10:24:38.822845
111	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODE0ODcsImlhdCI6MTYyNzI5NTA4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jzua1qz5-9EfmPfT3HkmMP-oVLdfhdv1HPqa-Cs-L9s	2021-07-26 10:44:33.819173
112	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODMyNzksImlhdCI6MTYyNzI5Njg3NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KFPWPuH-4GtXU49_Z7VLHIdccN-KjLZQzPNuQDYsDZ0	2021-07-26 10:56:58.95475
113	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODM0MzcsImlhdCI6MTYyNzI5NzAzMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xBdjbE0f0pn9IfTDiUyrg0UQ8b8ingEwFo5SeLxGkNI	2021-07-26 10:57:19.053188
114	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODM1ODYsImlhdCI6MTYyNzI5NzE4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.HAmw_lfjYWk9sGpgKX-u1zTV53c9ycpCZvgYXoQcbAU	2021-07-26 10:59:46.900687
115	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODM3MzgsImlhdCI6MTYyNzI5NzMzMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ioDXZd_IHR-XfD728HXB-_Aio6f2n6Ea2xQ0_vTx-Rk	2021-07-26 11:02:16.563553
116	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczODM3OTYsImlhdCI6MTYyNzI5NzM5MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.T6G4MhrH9-EziUbZoQjqj7BdE2niAlwW7LNKQZx7WKo	2021-07-26 11:03:15.089637
117	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczNjI5MjgsImlhdCI6MTYyNzI3NjUyMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3FPhu7qAwLVkVIqFu8ylwAOcTs7Bv8RPZyIXHgB1l5U	2021-07-26 15:49:54.385669
118	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0MzY3NTUsImlhdCI6MTYyNzM1MDM1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mBweOV53uWlOI8JIiDC-qFlt8TvjDDBh_cb0ueFPAsw	2021-07-27 06:49:48.813149
119	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NTUwMDEsImlhdCI6MTYyNzM2ODU5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.iMokntpILLonq54mBnzPuoSulCMDagzDXkqugn9w-gc	2021-07-27 06:55:09.260545
120	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NTUzMTksImlhdCI6MTYyNzM2ODkxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9u3CE1Et6crnhqfFiDkqjHLMi-rSE-jVB7wSyKd-Ics	2021-07-27 06:56:19.740579
121	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NTUzODksImlhdCI6MTYyNzM2ODk4NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.sP45uEbC8BaksYR91PnhdU0XSWFdBUQbiiaPIoJW4LA	2021-07-27 07:17:34.108132
122	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjczOTczNDcsImlhdCI6MTYyNzMxMDk0Miwic3ViIjo2fQ.pkELz-I37jKMGS7yHxAyVkMa7EjKzyo_xFcWbfGDwGM	2021-07-27 09:38:28.851871
123	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0MDEwNjAsImlhdCI6MTYyNzMxNDY1NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ZxNBxqgQyZ5Kmzr25CmGmuEOt6QO3YEL3JaFknc4MuA	2021-07-27 10:08:59.798202
124	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NjUxMTgsImlhdCI6MTYyNzM3ODcxMywic3ViIjo2fQ.obNTj7Jf4lvTSPXBAz-eVtPOOM8svONoz1HuQICAytw	2021-07-27 10:12:09.092609
125	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NjcxNjgsImlhdCI6MTYyNzM4MDc2Mywic3ViIjo2fQ.dFcpRcpJeb155sNfFAperRJBRJZQxb0YvUqiL0JqUzg	2021-07-27 12:10:27.499117
126	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc0NjY5NDgsImlhdCI6MTYyNzM4MDU0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gK60ZoqsYNLRCCX9AH_PE5SnOfQztsX5Z3oG0ljqZ3M	2021-07-27 12:17:24.928536
127	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc1NjQ1MTEsImlhdCI6MTYyNzQ3ODEwNiwic3ViIjo2fQ.bbTwDxYnIjn-1OWIll3Z8e8z7jq0_ViPwvN6qaq9EeQ	2021-07-28 13:40:57.228521
128	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MTU2MjYsImlhdCI6MTYyNzYyOTIyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.4XRxEmxb18PldGrSNHXJdKRkPTxE4fk16ba6WQZ7t8k	2021-07-30 07:16:15.691661
129	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MTU3ODUsImlhdCI6MTYyNzYyOTM4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.0C5DuoeLkPcPfUvEtmP04WZVJ-rs_eDY0OA_hDWMIQ4	2021-07-30 07:24:34.624585
130	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MTYyODUsImlhdCI6MTYyNzYyOTg4MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.nA5vtYEZnyaiQ_J6UhLvIc-JAXSX6xzZSORusSTi0a8	2021-07-30 09:02:51.174833
131	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MjIxODMsImlhdCI6MTYyNzYzNTc3OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Rs--Q7Tc_PuMkrJhKv-De7Z6LxQKAOLq6CwkYFql7FE	2021-07-30 09:06:55.810066
132	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3NDQ4NzIsImlhdCI6MTYyNzY1ODQ2Nywic3ViIjo2fQ.xeaTgZHyUV22RJtZ3nwXv70UsDmnapyDbDToMv4t0hU	2021-07-30 15:36:19.460521
133	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3NDU4MTYsImlhdCI6MTYyNzY1OTQxMSwic3ViIjo0fQ.7A80nihMouIuYlxRpWiMwmYConbD90icHOS79oDHGAg	2021-07-30 15:39:12.444996
134	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3NDU5NjMsImlhdCI6MTYyNzY1OTU1OCwic3ViIjo2fQ.9n082ApUPsN3tDkBbhyMUwQBgjkjnclBRu8R74aHmAg	2021-07-31 07:30:41.480224
135	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc3MjI0MzcsImlhdCI6MTYyNzYzNjAzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.lrUcX5GBB2RmJS_P0jREhMVpnOdOgvVNTB-yjaFyKiA	2021-07-31 08:13:09.174126
136	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc4MDMwNTAsImlhdCI6MTYyNzcxNjY0NSwic3ViIjo2fQ.uV_kcSKhD8wOEhfD9y4Sa45hZBSlNcscVRVkuzBTEIg	2021-07-31 08:33:09.108655
137	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc4MDY3OTgsImlhdCI6MTYyNzcyMDM5Mywic3ViIjo2fQ.gyptfoa4cZwoFQZWiRkV5iJgBnuETcDKzbEutPE3RhI	2021-07-31 08:34:34.073411
138	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc4MDY4ODYsImlhdCI6MTYyNzcyMDQ4MSwic3ViIjo0fQ.oyPFzN0-7o19oYOswkPhKXrOkovnfocmzcNWtVsuOME	2021-07-31 08:37:31.827583
139	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc4MDcwNjMsImlhdCI6MTYyNzcyMDY1OCwic3ViIjo2fQ.6Oq5hIRogAKfW7ATgYSL2jWRT9ecu1z1Yl172hw-cw4	2021-07-31 08:38:37.220709
140	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5NjUxNTYsImlhdCI6MTYyNzg3ODc1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AmjjzgKTioZ0ND9P_BmpnjopQSVAXN5MfMjBCUEP-qc	2021-08-02 05:33:30.405639
141	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5Njk2NjUsImlhdCI6MTYyNzg4MzI2MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XTDrtZsRhPdB0sx47ETj4X0tJPZXnhOjoHNhit09hP4	2021-08-02 05:47:45.798262
142	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5Njk2ODAsImlhdCI6MTYyNzg4MzI3NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Hr-XfodiMFrPc39il233ACBXwTtCz8BaKy71BwK8BFc	2021-08-02 05:59:04.775408
143	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5NzAzNTUsImlhdCI6MTYyNzg4Mzk1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KFyVlm7SE8CJ375-6ZVxLq_eMyz1KQfr_mb2nLPKFDE	2021-08-02 06:12:33.477054
144	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5Njg4MjAsImlhdCI6MTYyNzg4MjQxNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.UBOxR-OCTePa1mjdMswxvyRtHuiulWZKO7mGPQUy2fA	2021-08-02 06:47:11.854774
145	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5NzAxMzEsImlhdCI6MTYyNzg4MzcyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.b_GqiB5iZDxcJDJdejirQFDdA5htFIfa0_V10FTko90	2021-08-02 10:11:34.731455
146	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5NzExNjMsImlhdCI6MTYyNzg4NDc1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.fvkcyrgVVBg9Lh1kD3LRridOZATC15uxAOczXK1oG5Q	2021-08-02 10:11:53.718368
147	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjc5OTUwODIsImlhdCI6MTYyNzkwODY3Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.q-kp_uida79et2HK3V3T81ePhLn7cACuh-puUs-CPpw	2021-08-02 14:59:36.164521
148	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwMDI3OTMsImlhdCI6MTYyNzkxNjM4OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._MwG3wls-zB3-tRSIzFOZmAC0T82w0S0urtbOswC9IQ	2021-08-02 15:02:32.830154
149	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwMDI5NjIsImlhdCI6MTYyNzkxNjU1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.eYwEDclCUDtOiH8to_BayHML1xQ75ikFlx8LxRMQApc	2021-08-02 15:34:59.298592
150	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwMDQ5MDgsImlhdCI6MTYyNzkxODUwMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.WK9KJ3y0VPxRqAxKGFQcDRxhBEJ-JSGpxvxXeL41a3w	2021-08-02 16:27:38.065729
151	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwMDgwNjcsImlhdCI6MTYyNzkyMTY2Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ._ISM-dHPPBi8ZudXWELjrrXy3d74ez_YnTnPfwC0puY	2021-08-03 05:39:46.68878
152	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNTU1OTcsImlhdCI6MTYyNzk2OTE5Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hUMIDuKSJ5t0kxJf0S7a80lRnimJEPAuIpz--dc7HNc	2021-08-03 06:01:50.652917
153	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNTY5MjAsImlhdCI6MTYyNzk3MDUxNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.dBB2X4TV8zfKZCZatLVs50F9XHv3q9JnIix8-If0QEw	2021-08-03 06:05:10.159616
154	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwMDAzMzksImlhdCI6MTYyNzkxMzkzNCwic3ViIjo2fQ.e5pUvuxPOqYxlEIwLrH2bc9ueHsWVuBi_fVRTi30yi0	2021-08-03 06:14:34.034959
155	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNTc2ODIsImlhdCI6MTYyNzk3MTI3Nywic3ViIjo2fQ.LOdBdBcdGMHcCPdZhFoBLeW80KqygrywJBB5lFuXTCQ	2021-08-03 06:22:27.72799
156	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNTcxMjAsImlhdCI6MTYyNzk3MDcxNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Sve80LC3tB7rYWzZFBnbbcuM90_AYoleNWmzhaetUxE	2021-08-03 07:50:22.091488
157	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNTkyNDEsImlhdCI6MTYyNzk3MjgzNiwic3ViIjo2fQ._24K9TqUxR9dH4OsOsKbrv93UGhNm147PlSkEMqyLEA	2021-08-03 12:25:40.696875
158	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNzk5NTEsImlhdCI6MTYyNzk5MzU0Niwic3ViIjo0fQ.3ynmmXxmGqlSzRCPRx4iS2sxxCCUINM4gGOa5ZFeApc	2021-08-03 12:48:19.468516
159	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgwNjM0MzEsImlhdCI6MTYyNzk3NzAyNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.smJhsf2XK-9-d3tPbhu0r_hB-4_wPAwaXx78JHSg47o	2021-08-03 14:00:46.742356
160	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgxNzEzMDMsImlhdCI6MTYyODA4NDg5OCwic3ViIjo2fQ.-JEhkxX_xYWDnrlyuGOHN1Pcro3TcDAZQlK7wWciIvY	2021-08-05 04:56:48.803028
161	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyMzEyNTQsImlhdCI6MTYyODE0NDg0OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XS7TMpjxTU6rP8Futh_v5u1QIyWZRNEejT71_XoZJqE	2021-08-05 08:21:06.307846
162	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyMzgwNzcsImlhdCI6MTYyODE1MTY3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.q4BNRuNJdJul8-vtQ55Cg-vWQ84dgqDzJtyL1U5AFRw	2021-08-05 08:22:16.745492
163	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyMzgxNDcsImlhdCI6MTYyODE1MTc0Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QhcYuzWsTr64RUxRkw3U5hTdCpkWkPAV3UMG54c0NCc	2021-08-05 10:00:38.377394
164	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNDQwNDcsImlhdCI6MTYyODE1NzY0Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.A6U0ldFOxGT6MGF2B0Hd4YAa7G-0fIwVmFjeVMMlEQ4	2021-08-05 10:35:57.440686
165	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNDYxNjcsImlhdCI6MTYyODE1OTc2Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.3CJdakpsuV27ia9x8OG9c6qcmTBs0yGGBpRJaZT00ow	2021-08-05 10:38:28.197238
166	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyMTcxMzIsImlhdCI6MTYyODEzMDcyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UPpR0tW-riP6Yi8o-O4Kf5mMRHung5hEZuaBpp7XHM8	2021-08-05 12:20:10.807673
167	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyMjU4MjMsImlhdCI6MTYyODEzOTQxOCwic3ViIjo2fQ.mT9L96mEppBod8QLzuvyv2e9kAzIx_cHaMPcj7Tmegs	2021-08-05 12:52:13.406466
168	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNTQzNDMsImlhdCI6MTYyODE2NzkzOCwic3ViIjo2fQ.zK_g015vukCDGuU1C9gLY_XyYmXacxPCe62wjokVMRo	2021-08-05 12:52:53.926768
169	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNTQzODQsImlhdCI6MTYyODE2Nzk3OSwic3ViIjo0fQ.JTFhdWathPDDBHg04DT1KMSOlMI_fuR0TP-k3_VIVTU	2021-08-05 12:57:34.002922
170	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNDYzMTgsImlhdCI6MTYyODE1OTkxMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.M2bE1RU3YjmfEFTWi2F0dP89BcjuUjv1LECYk8dRtJk	2021-08-05 13:49:06.46669
171	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNTQ2NjYsImlhdCI6MTYyODE2ODI2MSwic3ViIjo2fQ.mpV7iFa-QNHwucsm49JUaZQAprI0oFhyUF2vEyzEsm8	2021-08-05 14:43:38.460784
172	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNjEwNjYsImlhdCI6MTYyODE3NDY2MSwic3ViIjo2fQ.FkpbZp2IbEHysVzT9rzL0aOSkndXqAqDYq9TyzEf0Kw	2021-08-05 15:43:39.001779
173	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNjQ2MjcsImlhdCI6MTYyODE3ODIyMiwic3ViIjo2fQ.lE-LAP-5NcxKxlXoJ0kMUh4M1TjPC2lk5Q1bZKPkUh8	2021-08-05 15:45:20.941457
174	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNjQ3MzAsImlhdCI6MTYyODE3ODMyNSwic3ViIjo2fQ.87W02BBHXa-FRKKvejdXAlaHUmRPhRgHLJx5sK3EfP4	2021-08-05 15:48:42.654463
175	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNjQ5MzksImlhdCI6MTYyODE3ODUzNCwic3ViIjo0fQ.N8174QX7imfsXcTsH--UVMar5sWhQi95ywcUXTZq_xI	2021-08-05 15:55:04.20222
176	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgyNjUzMTQsImlhdCI6MTYyODE3ODkwOSwic3ViIjo2fQ.WfW-fHr4evv1skn4iQM5yTjn4Or6GVx9ks2plQck4H4	2021-08-05 15:55:49.941671
177	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgzNDUzNzcsImlhdCI6MTYyODI1ODk3Miwic3ViIjo2fQ.TFylIQ8Ua7n0mFPNM0hYGnvWSzKvRwTOndzadA3UL98	2021-08-06 14:10:36.522124
178	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgzNDU0NDgsImlhdCI6MTYyODI1OTA0Mywic3ViIjo2fQ._1oRW6kagWm3mDcc7NwR9V0wi9UJ8DSth1D5WSu2wNk	2021-08-06 14:11:04.133233
179	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgzNDU0NzUsImlhdCI6MTYyODI1OTA3MCwic3ViIjo0fQ.xNXujuTySfOpXHwLks-e3ByvZCpkktU1v9OiJByhnxg	2021-08-06 14:22:50.737264
180	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg0MDQzODgsImlhdCI6MTYyODMxNzk4Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.76_xDt87FsigB3M3ht5ZBC59ILhX5dzd2F5gOZtX-JU	2021-08-07 06:42:01.765821
181	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg0MDQ5MzIsImlhdCI6MTYyODMxODUyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qMBNET1giAhIbo8QqS4vUjSfKXkV_hu1YaorK3be4hI	2021-08-07 06:44:19.654409
182	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MjgzNDYxODUsImlhdCI6MTYyODI1OTc4MCwic3ViIjo0fQ.xwhxBfAxguf8pvkEae6QU6xPFYEghurm1ch-Ij3U-6w	2021-08-07 07:49:19.225252
183	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg0MjY3MDIsImlhdCI6MTYyODM0MDI5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.WIUbnr0NePKTy4raglRF-SJkr1SKCSOLdeqO6MjRTYk	2021-08-07 12:47:11.705852
184	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg0MDg5NjksImlhdCI6MTYyODMyMjU2NCwic3ViIjo0fQ.PobO8JfQmDrs6lX-O8ijR1T_1D10pgjsk454tllhbXo	2021-08-08 07:02:46.189954
185	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg0OTI1NzcsImlhdCI6MTYyODQwNjE3Miwic3ViIjo0fQ.__lEz-GFrBLhS0VcC8i5B85HumSRcrVMKJZ1GtsGCfA	2021-08-09 05:22:05.384877
186	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg1NzI5MzYsImlhdCI6MTYyODQ4NjUzMSwic3ViIjo0fQ.BF2ZlpuJkqn4hxoYcmxVnRPzbsZq0emAEHTgqN7hHm0	2021-08-09 12:54:50.555182
187	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg2MDAwOTksImlhdCI6MTYyODUxMzY5NCwic3ViIjo0fQ.BXOLT0mRs4hCniACb6tp00NVAjsG3gFaJlAF_WM6sx8	2021-08-09 18:56:20.993228
188	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg2NjM1MTIsImlhdCI6MTYyODU3NzEwNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.5aTE2I8eNFeDRkrdzu-EZNW8BhKF9wqw_7hPJBh5QAc	2021-08-10 06:38:52.858389
189	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg2NjQxNTUsImlhdCI6MTYyODU3Nzc1MCwic3ViIjo0fQ.XN5ogRmL_UMfnZvz3hK-qBXg940Ko8f9dux-VL87ngQ	2021-08-10 16:08:51.874726
190	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg2OTgyNDUsImlhdCI6MTYyODYxMTg0MCwic3ViIjo0fQ.pgk8ni95tlDKhOqm17PRCskh3UW6Lm0Gm41XZ1Gde6Y	2021-08-10 16:29:57.631618
191	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg2OTk0MDYsImlhdCI6MTYyODYxMzAwMSwic3ViIjo0fQ.mD3wX8QkE8CA3gt_wSWis-cqIfbva-CKbhcpWOYlS9c	2021-08-11 09:04:56.403761
192	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg3NTkxMDQsImlhdCI6MTYyODY3MjY5OSwic3ViIjo0fQ.v2KY1mcdPXHOMEDWIGAoF1K4UMoq-uk6un7RxA9JsJw	2021-08-11 09:11:47.183017
193	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg3NjAwMzAsImlhdCI6MTYyODY3MzYyNSwic3ViIjoxM30.DPWDp2l853ZIi2ogSJ0s00cp8JRXCG9vkXec3LSwKdk	2021-08-11 09:26:57.63423
194	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg3NjA0MzEsImlhdCI6MTYyODY3NDAyNiwic3ViIjoxM30.2KnAhVhW8Gk07q3YxVcl7LfQHtJ65l2QhPBxFVq19CI	2021-08-11 10:07:59.98868
195	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg3NjI4ODgsImlhdCI6MTYyODY3NjQ4Mywic3ViIjoxM30.08TH0f3x08RTc9-GZZELgyW8N-DeqY3HScK-l-Tbt50	2021-08-11 10:08:38.825585
196	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg3NjI5NjIsImlhdCI6MTYyODY3NjU1Nywic3ViIjoxM30.TqFSfRq6-mB8EN4Pu8VAzCt4z8ybbOBrjTpZs0diXUc	2021-08-11 13:16:39.092863
197	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg4NjM5NjQsImlhdCI6MTYyODc3NzU1OSwic3ViIjoxNH0.q4IQvv-mbrEB1gfVFpIS1iBBtKHaZHoxXLfiR3Bui28	2021-08-12 14:44:23.043688
198	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg4NjU4NzgsImlhdCI6MTYyODc3OTQ3Mywic3ViIjo0fQ.mr53mAuYPqNj8M1Eqgz9hVfQGDgEnqljyzwwDYn5a3k	2021-08-12 19:27:32.949482
199	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg4ODI4NzQsImlhdCI6MTYyODc5NjQ2OSwic3ViIjo2fQ.fE1ThvRgWs50b_dIiVPVuk1zvttcjXIa8eKpPQIFmmc	2021-08-12 19:31:03.14527
200	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg4ODMwNzcsImlhdCI6MTYyODc5NjY3Miwic3ViIjoxNH0.Va0s0NySiKeidbs2ePrZZvXZwIyN_QT64fOxAp2c5FM	2021-08-13 07:07:23.388385
201	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5MjQ4NTQsImlhdCI6MTYyODgzODQ0OSwic3ViIjoxNH0.wcBrpOE1oJr3AgexK9O_TE9PbbKUq3LT9G4KEdVr4sY	2021-08-13 09:25:27.507547
202	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5MzMxMzksImlhdCI6MTYyODg0NjczNCwic3ViIjoxMn0.sdKaTMzRBDXArx5a_XbTje3jyfyqMvEf_1A5aT52XIY	2021-08-13 09:26:01.015515
203	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5MzMxNzQsImlhdCI6MTYyODg0Njc2OSwic3ViIjo2fQ.IMLV6pqUSXwHDdNP6ZePXQoGZeu-B8vyo0uueZ9YDs8	2021-08-13 09:26:35.630204
204	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5MzMyMTIsImlhdCI6MTYyODg0NjgwNywic3ViIjo2fQ.b8hvzDrzTKqsVNF1dJwBeYanepvlS8cNVuf4aMTsPqk	2021-08-13 09:31:09.728011
205	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5MzM1MTksImlhdCI6MTYyODg0NzExNCwic3ViIjoxM30.URITm9tZXnZCVWDcJ-nL9EwDyXWb98dFn1I0lCO3FM0	2021-08-13 11:23:46.777193
206	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDAyMzksImlhdCI6MTYyODg1MzgzNCwic3ViIjoxNH0.zcixqD_dK2N7-AH-g-_hZtTmzl0pAu59m9rzGFwVBt0	2021-08-13 11:35:15.728764
207	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDA5MjcsImlhdCI6MTYyODg1NDUyMiwic3ViIjoxNH0.U-dgbIj2dvvh4-n-4FcC7VGLCnkFDtsTEf15-4a4tBA	2021-08-13 11:45:24.246395
208	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDE1MzMsImlhdCI6MTYyODg1NTEyOCwic3ViIjoxNH0.J0wfD0qSO7MAin37gJQusWQA4q5PoCF-lMgDVrIttYc	2021-08-13 11:49:55.071172
209	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDE4MTEsImlhdCI6MTYyODg1NTQwNiwic3ViIjoxM30.TBwmRBBArpiBoJCBieqxxK8H_TwUhWjAkQq_VP1wAnQ	2021-08-13 12:14:25.177001
210	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDMyNzgsImlhdCI6MTYyODg1Njg3Mywic3ViIjoxNH0.SHQXCq0dSgMLO4hwUtOcE_dHiTd1Y4Ho3DojYBEG0W8	2021-08-13 12:14:45.671647
211	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjg5NDMyOTYsImlhdCI6MTYyODg1Njg5MSwic3ViIjo0fQ.NS9niO_JlKO3FD2oUj0d5-MUElvDYWJJvBPWYDneHSA	2021-08-13 13:03:56.303088
212	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk3OTk2NDksImlhdCI6MTYyOTcxMzI0NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Rf224lY-wDiClDCAO7DOPbslICnGixS3IH0mA8RB53o	2021-08-23 10:10:02.908004
213	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0Mzk4MTIsImlhdCI6MTYyOTcxMzQwNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xxJuL-VWDoXlovxy1hu9bJfeqS9fiRENlQozy1CgG4M	2021-08-23 10:28:58.432059
214	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MTE4NzksImlhdCI6MTYyOTcyNTQ3NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gHuJ5XcQcmwRYVfTxXOAIUaONyvmU9yonp4zR_Dtwow	2021-08-23 13:31:26.897895
215	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0MzM5NDksImlhdCI6MTYyOTcwNzU0NCwic3ViIjoxM30.Y_pNSy1kweSSlk3YMsxo4T8YG9n0XGlnKVfXaghzbY8	2021-08-23 13:53:14.890279
216	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NTE4OTYsImlhdCI6MTYyOTcyNTQ5MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.QEAMg_6l1YfYNfZJ2qzB1bsLh7LCHlC0ZR7t3x-TToY	2021-08-23 14:21:39.172792
217	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NTQ4MjAsImlhdCI6MTYyOTcyODQxNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4mpOlSESqPFOu11lGYz3oOukNxwF8Dp0eMX-BoTAPJ8	2021-08-23 14:27:44.255593
218	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MTUyNzYsImlhdCI6MTYyOTcyODg3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9._-pErR7OtIWwTkjmQR5I2J0FpBsPCKgGKTjl6LUzKUM	2021-08-23 14:28:18.456071
219	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MTQ5MDgsImlhdCI6MTYyOTcyODUwMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.r09fS-oBQGse7vJVi3H5a2hpZx5krPaf27NpXhjN-f0	2021-08-23 14:44:58.545888
220	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MTYzMTEsImlhdCI6MTYyOTcyOTkwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.2-yIHdkn49-NGMtoZiuHtA2tNcZThXZdW90aPvTqAQU	2021-08-23 16:47:58.514928
221	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NjM2ODgsImlhdCI6MTYyOTczNzI4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MqRE4xcmJo5vaU4vFaSBXS1xeH0RSDGs2HeVBzd8mtc	2021-08-23 16:51:17.250955
222	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MjM4OTAsImlhdCI6MTYyOTczNzQ4NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QirUqfEcGTuEzmnCWImwjIVl8YisO4UBct9TOG7NeoM	2021-08-23 16:55:23.302953
223	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NzMyNTMsImlhdCI6MTYyOTc0Njg0OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.JrrydhnadN9U46ue43k0i12hW0wgycGRb9nGG_W6I94	2021-08-23 20:03:06.99209
224	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4MzUzOTYsImlhdCI6MTYyOTc0ODk5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.uJOBnw3Il4ft4Mtr7FEkQwKBLOUe7QmLHvf7hVQv_jI	2021-08-23 20:09:58.515797
225	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0OTY4ODAsImlhdCI6MTYyOTc3MDQ3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Dq1nSAJ1yiu4WW_vs1-o70pv18f1SJSBgG_PCcF0Dv0	2021-08-24 02:05:30.554501
226	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NTcxNDUsImlhdCI6MTYyOTc3MDc0MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.PubFUwGHeyIXiIDe-p71FUZ9oSn59C-3dENr26y4lN4	2021-08-24 02:22:50.29747
227	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0OTgxODEsImlhdCI6MTYyOTc3MTc3Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.BxA6zVl9Hpj5oF9Cj1AMGXc18UQsfCVEwjy2D6khU9c	2021-08-24 02:39:03.270121
228	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NTkxNTQsImlhdCI6MTYyOTc3Mjc0OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.UDy60MQjvIVqqSRoZ8TTc5_hBSzt33ue5DD_Uz6ifho	2021-08-24 02:54:26.414043
229	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MDAwNzgsImlhdCI6MTYyOTc3MzY3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mVY2XF-vdHhzzLtCadC97PJ9N0ZO8A2qJsNgzzUrLXY	2021-08-24 02:54:51.061905
230	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NjAxMDEsImlhdCI6MTYyOTc3MzY5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.luhIRInfv9iwZLpdqkMJfvaixCoGfLHsiY_zg05fwak	2021-08-24 04:53:32.782042
231	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MDcyMjIsImlhdCI6MTYyOTc4MDgxNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.w13mYuTZ7bQZ-jXQnUgLOtL_r9uXt7sWkERFVEO8M-M	2021-08-24 04:54:03.271928
232	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4Njk4OTAsImlhdCI6MTYyOTc4MzQ4NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.D_iwN36WTAlExew5a7Vm-vV5DQjNgzEXtreorHfgPog	2021-08-24 06:36:55.652239
233	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MTM0MjYsImlhdCI6MTYyOTc4NzAyMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.DV5zuTtUbBS1Goo9fH0GP5a9FZ_D-aiAy9eRrtHtRKw	2021-08-24 06:38:06.4244
234	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NzM0OTUsImlhdCI6MTYyOTc4NzA5MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.NexcYG5mXz-Ror3WaPFXaH30gfbnKiliOza-c9w_b-c	2021-08-24 06:39:07.660616
235	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MTM1NTgsImlhdCI6MTYyOTc4NzE1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jOsA6nFUhYkGf3ogpUTRFk-UvxMMSyw5E-TbQBYuTW4	2021-08-24 06:42:40.531513
236	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NjcyNTQsImlhdCI6MTYyOTc4MDg0OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.jyrPWhAgteJphH03JkCcKw5REts7wttdjBi_fFDaJ-Y	2021-08-24 07:17:22.925555
237	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MTU4NTMsImlhdCI6MTYyOTc4OTQ0OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AvAs-KqPOpUx8ZkcEuVp_xoEO0xe4nds7QBFOV4KKZ8	2021-08-24 07:18:33.032533
238	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MjIyOTAsImlhdCI6MTYyOTc5NTg4NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sZ_4dWnOniooL4DvDZwQqgplwwbHCrKEP8H9h7_wOjM	2021-08-24 09:16:20.272134
239	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NzM3NzAsImlhdCI6MTYyOTc4NzM2NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mEyu_ZE9UGnlIIWWmwn93s-z14AxW7RtfRUlyAv8cFs	2021-08-24 09:43:13.573051
240	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MjQ2MjEsImlhdCI6MTYyOTc5ODIxNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.G9Ycy4mCoAFiLrhEI9KynA82kRGd3FL-snZKHAsmMCw	2021-08-24 09:48:52.976959
241	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4NzU5MjQsImlhdCI6MTYyOTc4OTUxOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.iowypUspqFb4wq5Yu4IlKQGuxeg079cqVSQikb2G-qo	2021-08-24 10:39:49.649885
242	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4ODQ5NDMsImlhdCI6MTYyOTc5ODUzOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QHc1v85q5YMhHn-QBJrpqGtDNl0rHwGBFkmapPDbLP4	2021-08-24 12:06:43.353881
243	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzMyMTMsImlhdCI6MTYyOTgwNjgwOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LOW3mjT34mMgIhpxNda0pqyDOPoW9e9oEipBYhEIhCM	2021-08-24 12:09:12.756214
244	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzMzNjIsImlhdCI6MTYyOTgwNjk1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ftUOK_aGc8juERFERNLSXeBVvJUf91KKRHOOpCnsr6w	2021-08-24 12:15:41.331635
245	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTM3NTEsImlhdCI6MTYyOTgwNzM0Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gv4sSecuv-hYnIDJuET4R0muKJfHjP6CLZP-4iOS_tU	2021-08-24 12:18:37.186781
246	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4ODI5ODksImlhdCI6MTYyOTc5NjU4NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.s75jAjescMbc6Reeh_surQ29URMs_y8lHnxerRH9q6Y	2021-08-24 12:20:17.372783
247	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzQyNTUsImlhdCI6MTYyOTgwNzg1MCwic3ViIjo0fQ.TabMu2K4-9p9D5EB6wGmx4u-HMnDuBWiaviSfr7qsU8	2021-08-24 12:24:42.405357
248	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzU3NDEsImlhdCI6MTYyOTgwOTMzNiwic3ViIjo3fQ.fmdqhZfOM0WAFrKGbb8-l5to5eG8A4cdXjdeKIsw0Ws	2021-08-24 12:53:46.803398
249	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzQwMjYsImlhdCI6MTYyOTgwNzYyMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.b4RNSwI3uVgQOyyX-hp5JvmM1OKtKLWcEEj5KzBvhHE	2021-08-24 13:01:53.203592
250	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTY1MjMsImlhdCI6MTYyOTgxMDExOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.dkUrvz5PWJzU6nG5C1h8JfDM31UQeinTeZjWh4anonI	2021-08-24 13:02:55.347511
251	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzY1ODcsImlhdCI6MTYyOTgxMDE4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VE06EEWUk_smUu-p1MHtHwj2gU0q9opEvX-PFJvu19w	2021-08-24 13:03:31.637395
252	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzM5MjksImlhdCI6MTYyOTgwNzUyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jeR405n6Q3GERcMU3DSEoRGAuIIT5nTzbD2-etvDJ70	2021-08-24 13:07:32.841055
253	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTY2MjIsImlhdCI6MTYyOTgxMDIxNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.kIj3QZgvpddvqATdg9KwH5f5RTxd2bxhimgooM4KMyY	2021-08-24 13:20:40.79101
254	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzc2NTAsImlhdCI6MTYyOTgxMTI0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xH8q1GBg1-y0kW0gjLlWOmeL-qLZ6eOf2DkT7Qk9LVQ	2021-08-24 13:21:28.154626
255	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTY4NjIsImlhdCI6MTYyOTgxMDQ1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.oXa_7332gf4na708yTS88NMH09CteROqR03I_l-QbM0	2021-08-24 13:22:18.225927
256	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzc4MzYsImlhdCI6MTYyOTgxMTQzMSwic3ViIjo2fQ.utt-vrWuGttQpzYLSDZ1ZdLY9E0ZYKVgiK9PpxFtB_Q	2021-08-24 13:29:49.663503
257	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzgzNTIsImlhdCI6MTYyOTgxMTk0Nywic3ViIjo3fQ.oLSV8EX-5mJislMp_ks7xvpEpghpo4GMKgizA8AKItM	2021-08-24 13:33:01.762693
258	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzgzOTQsImlhdCI6MTYyOTgxMTk4OSwic3ViIjo3fQ.KYrUuAa_Vn3D2bN7qQZ8GsRlelWhSBr3YcTaykkUPbQ	2021-08-24 13:33:11.622445
259	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzg1NTIsImlhdCI6MTYyOTgxMjE0Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bX-zxK1gTBWQKcXwsrJAoxMHNEV5xqfX1WwPDVLCeM0	2021-08-24 13:37:22.211531
260	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NTMyMDMsImlhdCI6MTYyOTcyNjc5OCwic3ViIjoxM30.suK6sqGtAo-20A8gp3zMdgJNWbzq-S5uMzMRVebj4L8	2021-08-24 13:37:36.212459
261	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzg1ODMsImlhdCI6MTYyOTgxMjE3OCwic3ViIjo2fQ.ZHxeCIbpOFCkxcBG1dzgAH-g4b7AF2ge69dOWsk99ws	2021-08-24 13:40:19.540855
262	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTg4MDYsImlhdCI6MTYyOTgxMjQwMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.uYiPhBYqitUK7b9lZzNWHHlTFq6Q8Ij39WpNDRTGHWw	2021-08-24 13:40:48.811881
263	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzc3NDgsImlhdCI6MTYyOTgxMTM0Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GpbcDTHWAdk0YFSygW_KUqX9vq-I6PKLIJOsXcsLzGk	2021-08-24 13:45:08.555926
264	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzg4NjgsImlhdCI6MTYyOTgxMjQ2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.M0h0SmQtH8bziG7OHviEIRn2EASYvDhZl9vUkBPCqCc	2021-08-24 13:47:09.315638
265	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzk0NzksImlhdCI6MTYyOTgxMzA3NCwic3ViIjo3fQ.Dg06WdWOfjPeEJ7ne6e4xzEd-K_wUX2JFhdlkiGBidE	2021-08-24 13:52:20.056869
266	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MzkzODEsImlhdCI6MTYyOTgxMjk3Niwic3ViIjo2fQ.zkKiBeP_MYptF8kNOTq_we86LNDn3tw_mD2hgzC3s9c	2021-08-24 13:57:32.888357
267	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzk4NzAsImlhdCI6MTYyOTgxMzQ2NSwic3ViIjoxM30.-Roo15AC5tdGaPdrWWpibFv7hdADZXcjieU4xYkrGb8	2021-08-24 14:02:58.400018
268	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDAxOTAsImlhdCI6MTYyOTgxMzc4NSwic3ViIjoxM30.wm7OBD5tzE-hST393p4LtJ0ibonm5Q8NQrvt4JrU0yk	2021-08-24 14:03:09.381206
269	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTc2OTcsImlhdCI6MTYyOTgxMTI5Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.CihfuwTtceJdsBKqwpuecnyJtGwxrWwYFZ0OQsShqiE	2021-08-24 14:04:33.26278
270	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzk4NzQsImlhdCI6MTYyOTgxMzQ2OSwic3ViIjo2fQ.sp_Xi_T-M63mN9qxCda5hoj3eg6IBZ6MKCqDsG01u9c	2021-08-24 14:04:35.182733
271	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDAzMzgsImlhdCI6MTYyOTgxMzkzMywic3ViIjoxM30.A-G9CPl55lFPlUFlC-t6m6N9f4AsY-58vaUx08CRvz0	2021-08-24 14:05:42.180882
272	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTg1MjIsImlhdCI6MTYyOTgxMjExNywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.tG_qSOTu-7O1ZeabRkoReHzgCchsF4AMaf6bKCRiQIM	2021-08-24 14:14:27.425564
273	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MDEwNDAsImlhdCI6MTYyOTgxNDYzNSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.c2G3FJ0zqwfwsVhgJRkI-GKT-rlTtiI8PyEGv78ZTOc	2021-08-24 14:33:34.97741
274	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MDIwNjIsImlhdCI6MTYyOTgxNTY1Nywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.skwCY2Z12wi_chp-qjafxFl8xh6pUGh7ehHTL8qTf7k	2021-08-24 14:37:31.791221
275	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDAyODcsImlhdCI6MTYyOTgxMzg4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.oXMZmiQ5amwwyEPFjyWCFbSOH8W0trBDeEUtfhmD_F8	2021-08-24 14:39:57.947422
276	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk4OTkxMTksImlhdCI6MTYyOTgxMjcxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tSO1soDnexB4zO602g9hM9Ff1LPgO41QLaApelYwPpE	2021-08-24 14:56:24.556441
277	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MDI0MjgsImlhdCI6MTYyOTgxNjAyMywic3ViIjoxMywicm9sZSI6Im1lcmNoYW50In0.-ZKJYlkIu_zFtF3HfaYZe1IhBtdha9HUNg3xze1TbUA	2021-08-24 14:58:45.33276
278	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDQ2MDcsImlhdCI6MTYyOTgxODIwMiwic3ViIjo3fQ.hUzCUxnQa_Z3dMy_hkLaQUPV3YsW4C4u2hwlKUtLzm0	2021-08-24 15:19:01.553112
279	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDUzMTAsImlhdCI6MTYyOTgxODkwNSwic3ViIjo3fQ.zjrIOPkNR02SrVTOQu7ecXp5Tftz-YQHjwIoll9JjfY	2021-08-24 15:39:38.459496
280	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1MjgwMDEsImlhdCI6MTYyOTgwMTU5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.eU8MeQRN1CW5X0gdSMGb0gj7V1sDXK4wmXoxipci3pA	2021-08-24 16:17:09.290797
281	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDMzOTQsImlhdCI6MTYyOTgxNjk4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FvdmV4Fuu5Lbks6rf6oPBoO3pVgW6Ld4KtwZZ0OlP9c	2021-08-24 16:50:10.063837
282	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MTAyMTksImlhdCI6MTYyOTgyMzgxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.zqHrVMhbJCSB_1vVt4fZo3PvnColfuKNAXkJ1Lx3IBg	2021-08-24 16:50:40.12975
283	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MTAyNTAsImlhdCI6MTYyOTgyMzg0NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.2M8B-s9VEa3z1LbNtefWeOIR4NAdcysXFixeo4zarcw	2021-08-24 16:50:48.671854
284	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTAyNTgsImlhdCI6MTYyOTgyMzg1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Y_GsyOySUVtOxa_7YjUP7lJajxF-6J4oFKVKXiA9vyc	2021-08-24 17:01:08.060446
285	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTA4NzksImlhdCI6MTYyOTgyNDQ3NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TngiKyDnXLrZ7bakdeMGJZhTWi0-zzZdY_TMx8GKIN8	2021-08-24 17:23:04.057284
286	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MTIxOTMsImlhdCI6MTYyOTgyNTc4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XlHp6FsHU00ke6UvLU27nNp1L6OfCGJeQ073oej4WlY	2021-08-24 17:24:50.740176
287	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDUzOTYsImlhdCI6MTYyOTgxODk5MSwic3ViIjoxM30.HzFa0ZND674X7ewQxTmmCIz2Onw8Rd7KjWckJ0jav_o	2021-08-24 17:35:25.71749
288	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTIzMDEsImlhdCI6MTYyOTgyNTg5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ZzhTSW7bl7e4i1EX695ab-2MyKJn4hv7NhatzBQBF3g	2021-08-24 18:14:30.322749
289	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTMwNjMsImlhdCI6MTYyOTgyNjY1OCwic3ViIjoxM30.cCf5QfMM5pUDfw4rnWsLc-P0JwqDlGreA7SPaozfVBI	2021-08-24 18:30:45.729867
290	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTY5MzYsImlhdCI6MTYyOTgzMDUzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._9MAsMXlz_eMyMSrGSL4McCqq6_iUa-xcKdffqZlUas	2021-08-24 18:42:43.522649
291	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NjQxMzEsImlhdCI6MTYyOTgzNzcyNiwic3ViIjoxM30.P6EF0gP9EFrh2eiiu-W8LRdRu4F8NT393sVxFmRrU9k	2021-08-24 20:46:05.699261
292	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NjQzOTMsImlhdCI6MTYyOTgzNzk4OCwic3ViIjo3fQ.zqCi9Kl22DqVA-m0LijBEq6mPxqWpb5LYrRHt1fFzzI	2021-08-24 20:49:06.819337
293	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NDM1MzQsImlhdCI6MTYyOTgxNzEyOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.btkchp0E5pgY--NbXouqJek3TgUo7FEGdyMe1--fD8g	2021-08-24 21:18:16.221216
294	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MjYzMDYsImlhdCI6MTYyOTgzOTkwMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.EX_lVYIMQs0mOfrD4YVfF-_-vUpf6hp_uu172tviUPo	2021-08-24 21:21:42.670163
295	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NjY1MTMsImlhdCI6MTYyOTg0MDEwOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.y2xKnSKlU3fiWEHCusub-Yly9NGEZE7Q6v9_FMAAbbw	2021-08-24 21:22:46.236419
296	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MjY1NzUsImlhdCI6MTYyOTg0MDE3MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Y5KmwmdEvz3efJmJsUqy7-j6z5KB-1UuGjHDWjqiOcU	2021-08-24 21:30:53.555825
297	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MjcwNjUsImlhdCI6MTYyOTg0MDY2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.bia78YtFpw5ciCp7Vm5uHtbXw-CMIrOXdJ7Bz76eO2A	2021-08-24 21:31:30.205635
298	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NjcxMDIsImlhdCI6MTYyOTg0MDY5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RJwxFdfpTkD_Z3NfcVz0HsO648zdS3gA_hUcKO9ra1o	2021-08-24 21:52:22.117228
299	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Nzg4NjMsImlhdCI6MTYyOTg1MjQ1OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.nZJ0rwq0BWJK5lviMuz-fjM6R-xnuQ-nmd1L3WlW0gY	2021-08-25 00:53:31.152793
300	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Nzk0NjMsImlhdCI6MTYyOTg1MzA1OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.faaC8lk8AXb2_V_y9kpXF1_c2ILKeHNNoI7n_D1_ceU	2021-08-25 01:10:41.954451
301	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NDAyNTIsImlhdCI6MTYyOTg1Mzg0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.DjdVCugnPozwTl9TKEoXknaHioaoN4phO9PIyU8mj0E	2021-08-25 01:20:44.03287
302	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NjI4MDIsImlhdCI6MTYyOTgzNjM5Nywic3ViIjoxM30.g9rEEvwgdcxghdhT0T5jtCP1SME2m1cL4nE9Pbqv_pE	2021-08-25 01:34:16.420567
303	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODE2NzYsImlhdCI6MTYyOTg1NTI3MSwic3ViIjoxM30.lw2l0ME0QZHhVbIwp1LzOWgpSUNpnAdjL1hR1JP5ChE	2021-08-25 01:34:49.29
304	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODE2OTksImlhdCI6MTYyOTg1NTI5NCwic3ViIjoxM30.1xA-vKAbwNwBwPSKgLfpLzpNQQbRk1xs0x-UtuP77a8	2021-08-25 01:48:05.520428
305	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODI1MDAsImlhdCI6MTYyOTg1NjA5NSwic3ViIjoxM30.E838AaA6A_MZqGOk0hlmie13THgLby6MoEq7PXRbayM	2021-08-25 01:52:46.245117
306	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODMyMzIsImlhdCI6MTYyOTg1NjgyNywic3ViIjoxM30.DeEZZHnp9t0rNSb4syGrzZ92B4gl3bdhxOIxNU1J3EY	2021-08-25 02:00:35.543793
307	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODM0NjYsImlhdCI6MTYyOTg1NzA2MSwic3ViIjoxM30.aRx4V8tyyMnD495yOyrGraaahvOG47PDtbrwqjriV8E	2021-08-25 02:04:38.515231
308	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODM2MTQsImlhdCI6MTYyOTg1NzIwOSwic3ViIjoxM30.B0ARtFVXR7VmfoAKh6w0etHyZwIF7wN45NvjLXq32-8	2021-08-25 02:06:57.685638
309	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODM2OTEsImlhdCI6MTYyOTg1NzI4Niwic3ViIjoxM30.QgjrWEYZTrOff5zoqo0pxpDCdivuami7-ysXBxDYWF8	2021-08-25 02:17:16.577221
310	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODU5MzMsImlhdCI6MTYyOTg1OTUyOCwic3ViIjoxM30.lwUsAgzChK-qvorSD5qy8YhXCBla7LsUAjxhN7LjGBA	2021-08-25 02:48:29.126199
311	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODYxMjMsImlhdCI6MTYyOTg1OTcxOCwic3ViIjoxM30.F8bPCCFEvng9ZtTUHhJCb_t2f1O4XzAVQIAELs1DS_Y	2021-08-25 02:48:59.002847
312	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODYxNTIsImlhdCI6MTYyOTg1OTc0Nywic3ViIjoxM30.Nnoq_rcw8wXAx2V2dBpjZNHd0uO-fHjy2uU9SMftOLw	2021-08-25 02:50:59.924055
313	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODYzMzEsImlhdCI6MTYyOTg1OTkyNiwic3ViIjoxM30.hBlYGZx1AIrdVIDCE3AXKzkG5dG9ajk2bB_-ZLls488	2021-08-25 02:52:44.742636
314	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODYzODEsImlhdCI6MTYyOTg1OTk3Niwic3ViIjoxM30.I_4yTd2Y0XKW9vOrMhvxOZIM8NOQQ0st-JAyv_ZnxuE	2021-08-25 02:54:26.712356
315	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODY0NzcsImlhdCI6MTYyOTg2MDA3Miwic3ViIjoxM30.T_6ZNsZqP0SXJeEN2g-O8s9j3pJllBiqLfdfk9NE96I	2021-08-25 02:55:15.982574
316	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODgyODcsImlhdCI6MTYyOTg2MTg4Miwic3ViIjoxM30.0pc3_jZJ6EobnYg8SetuCwMNmWYWGgRdec-24_qRNEw	2021-08-25 03:30:01.06826
317	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODg2NDUsImlhdCI6MTYyOTg2MjI0MCwic3ViIjoxM30.aXN5x23ysxgZma_KHjq5UbaM60amlUK6j6vmCOJyLDo	2021-08-25 03:38:26.660316
318	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODk0NjgsImlhdCI6MTYyOTg2MzA2Mywic3ViIjoxM30.y2F4lSCtu_BY3laH-rlnQBbnNycgFmziFhcOdHuPvDw	2021-08-25 03:44:41.247643
319	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODk2NDEsImlhdCI6MTYyOTg2MzIzNiwic3ViIjoxM30.nBnTtGHVehXPSdGKbZ6WBuvNPqG-SIBNL2amCK-9WkI	2021-08-25 03:47:24.93012
320	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODk2OTYsImlhdCI6MTYyOTg2MzI5MSwic3ViIjoxM30.5ok4Z74AqzfpsOD6lIWszm9EaMUNfoFc7UoWNSWbLuM	2021-08-25 03:48:16.342994
321	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODk3MzEsImlhdCI6MTYyOTg2MzMyNiwic3ViIjoxM30.O-uPyxdZiBcBDTnNPLtK8i39H0qMik4LTod3_rygPMU	2021-08-25 03:48:50.344122
322	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODk4MTYsImlhdCI6MTYyOTg2MzQxMSwic3ViIjoxM30.G1L6-U0kQfU-oQin6Z8ZAijaOWh8lp_Cwb7UKvjdELk	2021-08-25 03:50:15.990008
323	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTAwMzksImlhdCI6MTYyOTg2MzYzNCwic3ViIjoxM30.nALWu6-ZpnBypTAIpt1vvHTgOPRj5y49aSG2MfxsNC4	2021-08-25 03:53:59.188132
324	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTE1ODIsImlhdCI6MTYyOTg2NTE3Nywic3ViIjoxM30.zEHMoPuVzMqQgOV6qtdfSVpXSjJ_36vEt3q3aZhFf8Y	2021-08-25 04:23:12.850738
325	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTIwNTYsImlhdCI6MTYyOTg2NTY1MSwic3ViIjoxM30.ix5ucRfqRXU4-LPMK_ObpmG9R5mnArwlzUST7xzxrnQ	2021-08-25 04:27:35.015757
327	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTIxNzYsImlhdCI6MTYyOTg2NTc3MSwic3ViIjoxM30.FtHbP6IPzWcYMRm9U8OgeQ_JbxmCdZTt8SJyqEkkwGs	2021-08-25 04:29:45.876184
333	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTM5MDAsImlhdCI6MTYyOTg2NzQ5NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.LfoY_MTGveeKzyHAbEw01OJwC5Zkb2TkThsIszn86lo	2021-08-25 04:59:39.122514
326	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTIxMDIsImlhdCI6MTYyOTg2NTY5Nywic3ViIjoxM30.35BOldgFEk6yKO0gaT6pi1sGJDifDDGVpJIJ_tvIjvU	2021-08-25 04:28:35.735581
328	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTIxOTgsImlhdCI6MTYyOTg2NTc5Mywic3ViIjoxM30.SMu6rlWGn2fphiWkywLtgYtpAkhhzQKOlyrhX1cXxnA	2021-08-25 04:30:05.160548
329	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTI1MjYsImlhdCI6MTYyOTg2NjEyMSwic3ViIjoxM30.dChCtjzRRHKHUNB5l6xpUlPQUxjVxfvrYhhtN2zHFOA	2021-08-25 04:36:04.230148
330	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTMwNDMsImlhdCI6MTYyOTg2NjYzOCwic3ViIjoxM30.TU0hevca9vQA2LEbxPjmk6OuQSTWG_HIusFBxLW0cPM	2021-08-25 04:55:48.594128
335	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTM5OTMsImlhdCI6MTYyOTg2NzU4OCwic3ViIjoxM30.KlHFFcXKdMM1VfX9g_5hTrHhLUB9C-5nHfpTL31YFkI	2021-08-25 04:59:53.532246
336	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTQwMDMsImlhdCI6MTYyOTg2NzU5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Fd5Ner0u3CD-d7nGy17AxzxopEMKccB_dzHm9cVK2XM	2021-08-25 05:01:41.272684
331	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5MTUyODAsImlhdCI6MTYyOTgyODg3NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.c31QuxvgdWH-e7DKgEOLBtQ2kEbSLkaKEvQ4Cix13j0	2021-08-25 04:57:57.612755
332	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1ODA4NTQsImlhdCI6MTYyOTg1NDQ0OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KpZdSGbi4NmbSrLaHtdW8ET2mpjsw-_REWCqC0Utv_Y	2021-08-25 04:58:02.307933
334	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTM3NjgsImlhdCI6MTYyOTg2NzM2Mywic3ViIjoxM30.1iEN8UuvA0Wq2kPanL5Z0d0TMz597dK2P8WvDCO4RtY	2021-08-25 04:59:40.481738
337	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTQxMTAsImlhdCI6MTYyOTg2NzcwNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.kg6r3FadZYFNMCL7-Ik6VtXenSE57lrC1HZxRoaITYg	2021-08-25 05:04:32.512662
338	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTM4ODksImlhdCI6MTYyOTg2NzQ4NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.T9In3lnoIrrF8-RCuA24Hm7APfRrhccTs1vvjdtxSCE	2021-08-25 05:05:03.711438
339	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTQyODMsImlhdCI6MTYyOTg2Nzg3OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.E9r29e-LjVbsWQDNM-AuD_T5_rJF1xIFqR2Ig2m23iM	2021-08-25 05:16:20.138087
340	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTUzNzAsImlhdCI6MTYyOTg2ODk2NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1SZ7X6bRE77zMSG27zSvRQyNsxgs-1D5E1BHR8YNtW4	2021-08-25 05:23:09.289676
341	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTQ5OTEsImlhdCI6MTYyOTg2ODU4Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.BfTDXRViMih0h8WWYDhzmYBonfexUMaaNr1o9CWZ-a8	2021-08-25 05:30:51.849931
342	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTU4NjIsImlhdCI6MTYyOTg2OTQ1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SgL0jXT1L6BsH3vcM4FXldKAqVongSglrVMoG3fzVd0	2021-08-25 05:54:17.348278
343	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTcyNjcsImlhdCI6MTYyOTg3MDg2Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tWPLYWkcMAkNSEtWwmDSjs_aaR5IdhX5zwZ8fOuUO9E	2021-08-25 05:54:41.698233
344	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTU0NTgsImlhdCI6MTYyOTg2OTA1Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8GYV6qNRF65WtfjiQCIBdpLfU3iMkA7xroe1aMyaiHQ	2021-08-25 06:31:46.800985
345	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTcyOTIsImlhdCI6MTYyOTg3MDg4Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bvoBLENYJc2j5T_72gjnXVHH1JVkEmXGuP_HrtwHTYM	2021-08-25 06:34:19.755873
346	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTQwMTksImlhdCI6MTYyOTg2NzYxNCwic3ViIjoxM30.Cszgz1WWg3BbFhY16Tc6CtlffJDwk37XX6WjcF2P1wk	2021-08-25 06:35:58.865746
347	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NTk2NjksImlhdCI6MTYyOTg3MzI2NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3VMrtQ-1JvIJElnOWMk4Ab7zvUPpMus-PPHcbmOZ4JM	2021-08-25 06:36:10.205728
348	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDEwMTUsImlhdCI6MTYyOTg3NDYxMCwic3ViIjoxM30.ks7hm1ZLA24sMsjSoKHhJjMILspg1px0JhpFbF1ksUo	2021-08-25 06:57:03.081174
349	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1OTk1MTUsImlhdCI6MTYyOTg3MzExMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4AyZehHHV2fUG9P-Qp1SSVzFUfJSxu2bDHQ9fXVDsOc	2021-08-25 06:57:06.325883
350	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDEwMzUsImlhdCI6MTYyOTg3NDYzMCwic3ViIjoxM30.s9kxwRiDazhroIDeOsjb-78VUL1fGphEuFru0ryVS8Y	2021-08-25 06:58:11.921578
351	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDEwODUsImlhdCI6MTYyOTg3NDY4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kiPCRftRJtxOiV01XYts-4gHb26HjGvodYPSOAKQ5wk	2021-08-25 07:05:37.175599
352	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDE1NDcsImlhdCI6MTYyOTg3NTE0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dCh1KEMVMdGGNa-Gj10DSlROk-J03WhaCQCDe68spk4	2021-08-25 07:05:54.415598
353	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjE2MTEsImlhdCI6MTYyOTg3NTIwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.UmlyrlzkeIb_aCMELlDmPzNdlTavtlwcEU27nC-E2aA	2021-08-25 07:07:36.22965
354	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDE2NjcsImlhdCI6MTYyOTg3NTI2Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ZJ-NeFFoO2kVzChT3CUFmliwn8WFcu13uPK8YeQW_SU	2021-08-25 07:14:16.019725
355	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjIwNzEsImlhdCI6MTYyOTg3NTY2Niwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.netQ5MZDLSNrHHVPUMhSZx3bpJlq0Vc2Juz0bAIWBKs	2021-08-25 07:15:01.879844
356	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjIxMTUsImlhdCI6MTYyOTg3NTcxMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.quSLbcPuDV8OFceTwnq4kKs7CuOOrm7IwPKI20jqQ08	2021-08-25 07:24:23.277814
357	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjEwMzcsImlhdCI6MTYyOTg3NDYzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.OrF0_6ju8cMdN3E9-oBBymdhHGxU6zoikqeF7mWc9Yw	2021-08-25 07:29:50.679409
358	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDMwMDAsImlhdCI6MTYyOTg3NjU5NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.iCF48C2jriwAtWavJTUUrnso2E6uxoy5H3vIG8zM3BQ	2021-08-25 07:30:36.508255
359	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDA3NjEsImlhdCI6MTYyOTg3NDM1Niwic3ViIjo3fQ.l3IJ5mA1h3lut5MCLUwoECpXgpiR9bk0aT4k44uxc7Y	2021-08-25 07:31:19.405886
360	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjI2NzMsImlhdCI6MTYyOTg3NjI2OCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.DFLU7J3MiYunF0hSSigNVRXK-8eQDfGDv8v23_el03M	2021-08-25 07:31:44.311673
361	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDMxMTUsImlhdCI6MTYyOTg3NjcxMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RfSb3kOWJplAyijnRzQv3uHNZzo4fEhbfDYPmP8yTy8	2021-08-25 07:35:31.37597
362	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjMwNDYsImlhdCI6MTYyOTg3NjY0MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.UGbws-ruBXRXlN7VTtntNclcwIkU_ve_2-o4r-Vdx-Q	2021-08-25 07:38:09.587356
363	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDMyOTUsImlhdCI6MTYyOTg3Njg5MCwic3ViIjoxM30.ql-fiM_CRT9UE-GPDh7Z0QkwyeJzqjDsvnnyXD7XnK0	2021-08-25 08:12:19.897669
364	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDU1NTYsImlhdCI6MTYyOTg3OTE1MSwic3ViIjoxM30.6iifqR-zzk54jIhHir5MOaNR__meAOtsEeVMmLQQ_MA	2021-08-25 08:17:46.48361
365	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDU4NzcsImlhdCI6MTYyOTg3OTQ3Miwic3ViIjo0fQ.2CJsGmEBIJxoX8N6MiMpENcXCVtsCzVt2kC5nQV3COY	2021-08-25 08:18:02.760944
366	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDY3MzYsImlhdCI6MTYyOTg4MDMzMSwic3ViIjo3fQ.NKepNkNZxH498WJQb-JhVzxz9Pkrfa5isxdtUjpZxbc	2021-08-25 08:32:35.598439
367	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDU4OTcsImlhdCI6MTYyOTg3OTQ5Miwic3ViIjoxM30.TrJULXHqbcx6M8TYF5Xk9nUn86V41S8C18kP_vJ7lN0	2021-08-25 08:34:39.24467
368	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDY4OTAsImlhdCI6MTYyOTg4MDQ4NSwic3ViIjoxNH0.gSRXKFCybPxvzV0fGlJu85bN4PoqOwF7v6HDueOEkjw	2021-08-25 08:35:04.108966
369	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDY5MjAsImlhdCI6MTYyOTg4MDUxNSwic3ViIjoxM30.91Om0CGAm4qWxEDQdVjejKzXYZjQeScGoN4D8357o_Q	2021-08-25 08:39:01.120663
370	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDgyNjUsImlhdCI6MTYyOTg4MTg2MCwic3ViIjoxM30.lQG_40p4vNAfduyTb0JK6FF8uviGVtvV2cJ1pIA999c	2021-08-25 08:57:58.967566
371	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDY3NjUsImlhdCI6MTYyOTg4MDM2MCwic3ViIjo3fQ.DNP32u9IuyaT7Byb9b0wQPyr-X1m771tAa7bMQ2xqzk	2021-08-25 09:01:32.081503
372	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDgzNzgsImlhdCI6MTYyOTg4MTk3Mywic3ViIjoxM30.8FKm_ustH9d31QDL30VpUDY4Os6bXCJe6HOFtOQFWZc	2021-08-25 09:13:16.702489
373	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDM0OTksImlhdCI6MTYyOTg3NzA5NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YsqSk-O0E-Y1AVQrSdh7SeQQgnjV-fa_Pyd23270Y3M	2021-08-25 09:14:14.186279
374	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjkyNjQsImlhdCI6MTYyOTg4Mjg1OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.bx4yUi9WDsB-XH65bW5A8OR13PuKBmSwpjx0qLVMrq4	2021-08-25 09:15:22.716283
375	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDk2NDYsImlhdCI6MTYyOTg4MzI0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1m5KFAdgNAJU-4vkZCSqhP925Oj_SlRC7MJFzKerA5Q	2021-08-25 09:20:47.399894
376	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTAwNDksImlhdCI6MTYyOTg4MzY0NCwic3ViIjoxM30.UY96-0weSC0GTa6SRs7oXnvWLXBcN1q5ppsQ56EziHI	2021-08-25 09:29:43.048713
377	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzAxNzMsImlhdCI6MTYyOTg4Mzc2OCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.ODefz1eHZKx4xMpBwnyQcADOREQ0dL5_mu4x8DXSzeY	2021-08-25 09:30:39.663898
378	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MDk2NjMsImlhdCI6MTYyOTg4MzI1OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bCPtXLBSv_lnNg7hcYSFknH4jyD1LT0oVlJnb_AcH0I	2021-08-25 09:33:01.626988
379	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzAzOTEsImlhdCI6MTYyOTg4Mzk4Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hXxJeErvKN_Bwv_dfWN1qw_5gZc9MGkMYkkg2k_wAdA	2021-08-25 09:33:10.816816
380	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzA0MDAsImlhdCI6MTYyOTg4Mzk5NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Izo4JKIaLaI4ius3E9AV7XN4DNV4utOtKQ38pWqaIjI	2021-08-25 09:33:55.566842
381	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTA0NDYsImlhdCI6MTYyOTg4NDA0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.BvNQfPcIHr_UooDV0t-Est8F8ADE-R2Hp4Uejs-yg8w	2021-08-25 09:46:39.926819
382	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzEyMzYsImlhdCI6MTYyOTg4NDgzMSwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0._8EJBpPLo3FZaxQa2TyBNJBWyOaKKWfncZYwIE5Ftis	2021-08-25 09:54:20.643612
383	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTE2NzEsImlhdCI6MTYyOTg4NTI2Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bZQBRP0WHYnkWITo1D8BlvEidEsxDSxhUEyNeAUsxiw	2021-08-25 09:54:43.883067
384	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzE2OTUsImlhdCI6MTYyOTg4NTI5MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mq6Ynt2lobQfEDEUjapB51I7H3TvVyyZ6J6E-Uu0Jwk	2021-08-25 09:59:19.546043
385	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTAyNTYsImlhdCI6MTYyOTg4Mzg1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LnZUsuadZGLlXKzSTWPOXu3P2bG3brr-Iz9TwpA1FMw	2021-08-25 10:00:56.702881
386	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTE5NjgsImlhdCI6MTYyOTg4NTU2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7KWOq-Ck9oKCUyx2_d80zWrLVZx-aL_OXnzaO5DsApM	2021-08-25 10:07:44.227489
387	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzI0NzQsImlhdCI6MTYyOTg4NjA2OSwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.dF6btrKjyTuBSRgN1xGZRm76VuvqLjlEto8YGQYSFfY	2021-08-25 10:08:06.742562
388	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTAyNTMsImlhdCI6MTYyOTg4Mzg0OCwic3ViIjoxM30.JzD3BZ39bdOJJVi-B2YBg-AyOwY6wibE-9Qh7RxA4qc	2021-08-25 10:09:03.549167
389	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzI0OTcsImlhdCI6MTYyOTg4NjA5Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3iiH41VnFzpENa8fcewdH-ObIy0Ph3cBpS3uN1rGAc8	2021-08-25 10:13:08.883469
390	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzIwNjksImlhdCI6MTYyOTg4NTY2NCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.xsvYc45xzTlj4Amsdc37rEM6fKC12JvTrSkcslI0Alg	2021-08-25 10:13:11.128996
391	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTI3OTksImlhdCI6MTYyOTg4NjM5NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.yqmoeF68Q6FVVAUbnAdHI8-s2NvH-nMlpRGKf91ujgE	2021-08-25 10:14:54.882285
392	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzI5MDUsImlhdCI6MTYyOTg4NjUwMCwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.bb3NK_wZ3uLa3p9ljojocH2zUwUWYyYb-5LAa-uh2BU	2021-08-25 10:22:44.692681
393	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTMzNzUsImlhdCI6MTYyOTg4Njk3MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.-MwK20jcr8ybsp6pDKnxcnhEV2YR5jhnR-0qODFEQ_Y	2021-08-25 10:25:03.182547
394	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTAxMzQsImlhdCI6MTYyOTg4MzcyOSwic3ViIjo3fQ.Yx_1B5hGvfTkE4MFNmvxnVnILLnyoRNHVRsCCBXt2mQ	2021-08-25 10:38:09.752491
395	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTM2OTksImlhdCI6MTYyOTg4NzI5NCwic3ViIjoxM30.p9WcLRgexm-yG5ZedrbXri9ZoKbl1fZu71KJm5OpKZU	2021-08-25 10:50:00.870222
396	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTUyNDIsImlhdCI6MTYyOTg4ODgzNywic3ViIjoxM30.unzIwsaq6bR6YPg0kR7EkIxMRHRXegQqoBFSpqERGhU	2021-08-25 10:58:59.144886
397	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NjMzNDIsImlhdCI6MTYyOTg3NjkzNywic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.GZQD5tV10IPFqOyClheDDp2jeY3EKlLH9Ja9quJoExc	2021-08-25 10:59:41.337331
398	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTU1OTIsImlhdCI6MTYyOTg4OTE4Nywic3ViIjoxM30.mIhz2wjYm30dhgGs13p702EIIGGzQujwtMsQ_c2JXFE	2021-08-25 11:00:09.888722
399	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTU2MjQsImlhdCI6MTYyOTg4OTIxOSwic3ViIjoxM30.DMH9bohC4w49Z_vdNbi_qDK5HnZMprJBfxxNTsZv_N8	2021-08-25 11:03:45.03364
400	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTY2MTMsImlhdCI6MTYyOTg5MDIwOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.tq24sOztQS55VLr_rYhPIKZ0_syOOQa26FdUwPUZS3g	2021-08-25 11:25:39.089159
401	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzcxNDgsImlhdCI6MTYyOTg5MDc0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.BvXoVVVtOVOtHjgXioM7ggnsxIM3GOxVLThcCIBQI5U	2021-08-25 11:27:32.432222
402	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzcyNjksImlhdCI6MTYyOTg5MDg2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.NmbBkyE5MkKxYa1WfbRLd9N96A4A_XfiSNQq5NG_y24	2021-08-25 11:28:27.581321
403	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzM1MTQsImlhdCI6MTYyOTg4NzEwOSwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.0Vf5CYNON9UCbrRo2ys_RhneQKg6-UDsCOHeNmGxYyo	2021-08-25 11:36:51.814048
404	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTU1OTEsImlhdCI6MTYyOTg4OTE4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ZBB3y5sJOrV168ApMCFuFaeMESfD9G9jvn_qRlz4BtE	2021-08-25 11:37:06.857975
405	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5Nzc4MzgsImlhdCI6MTYyOTg5MTQzMywic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.O6Mz2WQ2_HUXppyS2k_KfvN1x511iybZ1RfJCNJt5pg	2021-08-25 11:38:06.540159
406	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTc5MDEsImlhdCI6MTYyOTg5MTQ5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._1PvK2YsvgCVt8LDLbPp8sQ4nZEzcB4WUOKDqsFyRp8	2021-08-25 11:39:57.858073
407	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzgwMDcsImlhdCI6MTYyOTg5MTYwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.gvDlukVFie5g39l_Jul4oozaNuE_tM9puZr8nNtyg24	2021-08-25 11:40:17.006218
408	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTY2MTUsImlhdCI6MTYyOTg5MDIxMCwic3ViIjo2fQ.Hp6lXhCHlNTaHuL1Czy_roJg0Q4B9N0XpNW5UwLBxPw	2021-08-25 11:41:35.988588
409	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzgwMjcsImlhdCI6MTYyOTg5MTYyMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.yGMCQwYR1x2FdI8MfP-3iF4tC-SNDOcxIHfvdj7_-zk	2021-08-25 11:43:18.702919
410	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTc4MjEsImlhdCI6MTYyOTg5MTQxNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.y1SePF-euPrrnPeFnnjvPHS7V4_EiNTHLOEtGvbnBuI	2021-08-25 11:53:15.468437
411	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5Nzg4MDcsImlhdCI6MTYyOTg5MjQwMiwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.TdQmdr-8mq6DhazE3knw_OEqqRS3tpkS558u2-rOnqM	2021-08-25 11:53:46.09355
412	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5Nzg4MzYsImlhdCI6MTYyOTg5MjQzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.9_Sg-Om_a6byEa6hw5pA6BaDZq7KJq3N-xee-AnYxFE	2021-08-25 12:03:32.990405
413	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5NzczMDMsImlhdCI6MTYyOTg5MDg5OCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.eo7QEgMqwbQ2VbDjJBKasvyZtL8W1iS01RMWq11HWIA	2021-08-25 12:16:08.037894
414	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODAxNzcsImlhdCI6MTYyOTg5Mzc3Miwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.kvDt09BCZqS8K1dAe2SGu2c4mEihTjMO_S08lw0-HDU	2021-08-25 12:17:29.193783
415	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODA2NTEsImlhdCI6MTYyOTg5NDI0Niwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.Hn_oT1vSTpku1ApCB5JQWMnFqBR6GfHhLAvEP6s5wjE	2021-08-25 12:42:22.114469
416	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MjI0MTEsImlhdCI6MTYyOTg5NjAwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.G_-I0BEIzpB5tO0ucqwkIvdEEb_UzROi1avU4pGJylg	2021-08-25 13:30:58.503168
417	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODQ3NTMsImlhdCI6MTYyOTg5ODM0OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KpU1rtNwrsXVueRkWVCn1iy_R8LQEOtXxOlfwWU4_g8	2021-08-25 13:38:33.52748
418	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5Nzk0MjMsImlhdCI6MTYyOTg5MzAxOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.aQwFkB_L1WRO_mD2MhsEX9Rn5oF7t8Cy7BWdbbs1VLw	2021-08-25 13:58:10.795873
419	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODYyNDYsImlhdCI6MTYyOTg5OTg0MSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.3QaK7hRVpB8TFFVu4BMD9o65ZgDWqzBf4rAnFWQwxhc	2021-08-25 14:57:06.787042
420	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODk4NzIsImlhdCI6MTYyOTkwMzQ2Nywic3ViIjo3LCJyb2xlIjoibWVyY2hhbnQifQ.qrJ9EoSC-ytRYj6GBOKnY2v243VMnMIKjUVlr0Ljtu4	2021-08-25 15:00:09.879588
427	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MzEwMDksImlhdCI6MTYyOTkwNDYwNCwic3ViIjo5fQ.yB51A8E2HX9fy1XHToVDY6pDI5_0B4xYt037FVUYvP0	2021-08-25 17:33:45.310609
428	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDA1NzIsImlhdCI6MTYyOTkxNDE2Nywic3ViIjoxOSwicm9sZSI6Im1lcmNoYW50In0.3GuhhMiecS5tM7YOX6tNawrJFhCLvGIAfDiHUnu3KKU	2021-08-25 18:04:31.411377
421	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MjYzMDIsImlhdCI6MTYyOTg5OTg5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.3osbBnvJ6zItxFRCkvIYg6SXJKtGKdEJQASY5hHgrVE	2021-08-25 15:05:49.931013
422	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5OTAwMjAsImlhdCI6MTYyOTkwMzYxNSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.NIWy1Fx8U0pxjQCbnN-krZFjYcHV8DHeJDOU5CRSnF0	2021-08-25 15:10:24.250812
423	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5OTAzNzgsImlhdCI6MTYyOTkwMzk3Mywic3ViIjo3LCJyb2xlIjoibWVyY2hhbnQifQ.g1AgwYfVBTiXG58Fvmy1wl9MvpIfCWfxp70dinxo0Lo	2021-08-25 15:10:25.27829
424	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MzA2MzUsImlhdCI6MTYyOTkwNDIzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vPvfRjOCRUMm4k9iYnpUfRXFiKewT4P_ynFmfCc-0Rs	2021-08-25 15:15:03.523658
429	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDA4OTQsImlhdCI6MTYyOTkxNDQ4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kKChZUfWEWf5E_C5Y2qZ9uk-JIB-rY6dt_Djo_9TrVk	2021-08-25 18:05:00.23604
425	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5OTA5MTYsImlhdCI6MTYyOTkwNDUxMSwic3ViIjo3LCJyb2xlIjoibWVyY2hhbnQifQ.zX4ArbKOuk91R10i1lp_Xqr88CzBrKGnBWz5nOUtDZc	2021-08-25 15:19:01.891284
426	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5ODg0MzksImlhdCI6MTYyOTkwMjAzNCwic3ViIjo3LCJyb2xlIjoibWVyY2hhbnQifQ.4Ghqe55EgEO17ZHAVNWyKDlgkY7DraR4Ip1qwRGU0Tg	2021-08-25 16:02:55.575421
430	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDEwODUsImlhdCI6MTYyOTkxNDY4MCwic3ViIjo3fQ.FKWqjcNtuiboWK01RYNyfphebraQwIAAiaBm3fjieBU	2021-08-25 18:10:37.708911
431	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTcxODksImlhdCI6MTYyOTgzMDc4NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ajuI0XLNvwgD24ksap61j4TxfTk57ggKnPQ845RGFHA	2021-08-25 18:33:00.574702
432	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDI1MjAsImlhdCI6MTYyOTkxNjExNSwic3ViIjo3fQ.71VN2_YLRjGkyjDJFhhBaZN2DwRQKcyzWA_vsoDGq5g	2021-08-25 18:35:36.496876
433	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDMyMjIsImlhdCI6MTYyOTkxNjgxNywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.8BKb78Ucu7mJocYpf1a0ECSfNHIZdybHT1ZaY9AjX5M	2021-08-25 18:40:21.356178
434	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDEwODYsImlhdCI6MTYyOTkxNDY4MSwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.CdE_yox9XwkFRGA-V_T79GgpVVl5AESVwlFm4I63gjk	2021-08-25 18:40:52.521858
435	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDM0NTcsImlhdCI6MTYyOTkxNzA1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sKOqJDuFO3YaIRUmiFjBULGvI9NfOULajzFzjio6jRM	2021-08-25 18:44:19.244298
436	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDI4MTksImlhdCI6MTYyOTkxNjQxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.T1WaBD0wXgNv0PWspJBUbqKvi0zm6i7X3h-MViTypPA	2021-08-25 18:45:10.929625
437	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDMzNTksImlhdCI6MTYyOTkxNjk1NCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ._GMypQVe02yNG8ltA9f2sQmVMIfd6kH7fg2QDGR3F3I	2021-08-25 18:46:20.780927
438	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDQzODYsImlhdCI6MTYyOTkxNzk4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9Ch5WHyX1CseE8dpqkWoNWQOmg1A2i7pR01Mkvfk6c0	2021-08-25 19:08:29.860315
439	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDIwOTcsImlhdCI6MTYyOTkxNTY5Miwic3ViIjo5fQ.Hrky6iMWY8kMULtO7Wc2yvVzli0vp5VSwEFc6njOrsU	2021-08-25 19:17:49.453402
440	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDU3MjQsImlhdCI6MTYyOTkxOTMxOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.m2cIcZdxhsmVadz-QEs4N5dq5m_gsLeCLqtRc7O36zQ	2021-08-25 19:22:09.180907
441	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDU5MDQsImlhdCI6MTYyOTkxOTQ5OSwic3ViIjo5fQ.ZsLoFDoppfSriRb707VbwQ_Ig1liMij2Tiua5WyYG9o	2021-08-25 19:25:05.883202
442	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMDM1NDEsImlhdCI6MTYyOTkxNzEzNiwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.jK4d2dU-gkQVri21Con2aD6yoZuUK9Tt26Umb3mQrKA	2021-08-25 19:28:28.178907
443	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDY0MzksImlhdCI6MTYyOTkyMDAzNCwic3ViIjo5fQ.4H28k0gw8Jap_ySudP96AllayVQvYMSMWJwamvMKjz0	2021-08-25 19:38:06.829097
444	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMTI5NDMsImlhdCI6MTYyOTkyNjUzOCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.l9W_SjC9Nd_09rhG49EwrsMNIzD4QshZw3AmWLQMzAA	2021-08-25 21:22:53.113419
445	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NTMxMzksImlhdCI6MTYyOTkyNjczNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.cZPOnjyq1BkREmkFqW_EZ3VflKq4cQs5Lqn4JP2XG7I	2021-08-25 21:31:02.168813
446	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NDYxMTgsImlhdCI6MTYyOTkxOTcxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CvoUiHqS9jkbE1KfFvzGt2IsZq-JrmAQlgTAImKi8Eg	2021-08-25 21:47:39.28899
447	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMTQ0NzEsImlhdCI6MTYyOTkyODA2Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.e12oLt1--YpM2L29ZE_3l5IHKTWbDEAFSoo6p-hsc4o	2021-08-25 21:49:39.755434
448	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NTQ1OTEsImlhdCI6MTYyOTkyODE4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.IMeo3hOaRuwsNsAx0LjEfaH8MXqXsoJxkXBsQkKL2WE	2021-08-25 22:02:55.254608
449	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMTUzODksImlhdCI6MTYyOTkyODk4NCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.1zmDQg1rYsp8Yy28PpcNCvg9T7mCfi2RPAXp6qT1WOw	2021-08-25 22:10:24.389023
450	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NTU4MzUsImlhdCI6MTYyOTkyOTQzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SfmSGPzCm1oKQixu1sg8ouIrpEV4hcE6klcJuAiFPNU	2021-08-25 22:12:55.676634
451	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTcxMDQsImlhdCI6MTYyOTg5MDY5OSwic3ViIjoxM30.s-CEAZU3L2xYBAWtUan9EuGSbW8tWVIm_WRNN5iqga4	2021-08-25 22:19:30.228374
452	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTU5MTAsImlhdCI6MTYyOTg4OTUwNSwic3ViIjoxM30.W6bHz4SPmwVsMWlSgw50VFh9XT5HCheBvjkydCEacTs	2021-08-26 02:34:06.177246
453	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2MTgxMTQsImlhdCI6MTYyOTg5MTcwOSwic3ViIjo2fQ.x_28-MR5GWd6sKmiAC_KpkNgnFMDGlg99eE_alHb6W0	2021-08-26 02:49:20.964014
454	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NzI1NjksImlhdCI6MTYyOTk0NjE2NCwic3ViIjo2fQ.Gqwk8ioXYNY4cD88AqXTrYpKGkCbpzJNDMkI2fTP9uM	2021-08-26 03:00:48.536798
455	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NzE3NjIsImlhdCI6MTYyOTk0NTM1Nywic3ViIjoxM30.vZvOlxElnELp6SPdvbpK5_2bC5PFOJSYiShoIGrL0ik	2021-08-26 03:09:26.61345
456	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2NzUxOTIsImlhdCI6MTYyOTk0ODc4Nywic3ViIjoxM30.QcxNkEO0AKwvWEdEKo8klZofxXG5_o1F34p7Nl0u4ts	2021-08-26 04:44:26.092899
457	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2Nzk2MDYsImlhdCI6MTYyOTk1MzIwMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.6pxPe3HYf1k35JSXAUxQSG6jIDo2g9KR3kWfXw1KCl0	2021-08-26 04:51:15.655035
458	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mjk5OTExNTIsImlhdCI6MTYyOTkwNDc0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.0VKxylHCwEB5hbVt3hKOYTf0SpiRjRHzOjali2h1rgk	2021-08-26 05:09:35.281636
459	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODEzMTAsImlhdCI6MTYyOTk1NDkwNSwic3ViIjo0fQ.AJeDj5z6m6N43qw_jY5MDa0zYVOONSGYvLR6YFmZhOs	2021-08-26 05:15:22.180638
460	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODE3MjMsImlhdCI6MTYyOTk1NTMxOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.g4r9UMboNIJ_uW44eFHbAmaFWbJIDm5T-IzfNzUPvxo	2021-08-26 05:27:49.024302
461	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODEzMzgsImlhdCI6MTYyOTk1NDkzMywic3ViIjo0fQ.Mqar6FRyXotnihCotJl3BrkGs8Y7VOLB92Q-nSJFaxM	2021-08-26 05:31:44.986729
462	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDA5ODYsImlhdCI6MTYyOTk1NDU4MSwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.TEyYR4_m7v2fFPATOeTIFSdOwaK4JOck6CB5vZ6_1Ro	2021-08-26 05:45:14.718742
463	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwMTU5ODcsImlhdCI6MTYyOTkyOTU4Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.JtBHr1-hzYqbpbT-K6FSD7ap0m1RPqwCxGSetzVg7M0	2021-08-26 05:54:41.324576
464	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODMxMjYsImlhdCI6MTYyOTk1NjcyMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7Dy6hEAzlDW9FcnSUWzrtiQpcWTspUV-_IgXySFghpc	2021-08-26 05:59:33.659552
465	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODM2OTEsImlhdCI6MTYyOTk1NzI4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8iDkgf_PDQJtQxQCvZDYEhJNKJNLN7MsbmmUh9CjndA	2021-08-26 06:43:43.931193
466	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODA1MTksImlhdCI6MTYyOTk1NDExNCwic3ViIjoxM30.W21sYQziDFI27o4LjyOOXS4b9NS4e0sDK7nly3K5QsQ	2021-08-26 06:44:13.488783
467	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODY4NTQsImlhdCI6MTYyOTk2MDQ0OSwic3ViIjoxM30.OmegsbuSPTdQlhw_HohhTXxo14ZwBqyO-TtarGPGNpI	2021-08-26 06:47:51.990718
468	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDM5ODMsImlhdCI6MTYyOTk1NzU3OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.j7XbNQ-qIf5mNKK2ic90t7IKqQ98AbHN6kpvHl7ugao	2021-08-26 06:49:17.469952
469	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDY4ODcsImlhdCI6MTYyOTk2MDQ4Miwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.F5UF6l2Jb3QkwFPzCaEdiOpK8G4YBQSdK4Fp0E09gQE	2021-08-26 06:52:26.888343
470	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODY5NzYsImlhdCI6MTYyOTk2MDU3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.duvaSQ8MtCtgR9D1J9SYeffJweNDMpJ1v2qPusj3HyM	2021-08-26 06:53:00.667148
471	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODY4OTcsImlhdCI6MTYyOTk2MDQ5Miwic3ViIjoxM30.U9p9cWgzwQei65vMFBtbT3dcy-mlN__BeFupRiYHl1U	2021-08-26 06:56:57.682064
472	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODcxNTgsImlhdCI6MTYyOTk2MDc1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Bye2HtYi9B-V-yPBwzp4s0AiVpkG8dh5EEqMQS-Z924	2021-08-26 06:58:04.851772
473	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODc4ODIsImlhdCI6MTYyOTk2MTQ3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TuDgJpeUCGRllfvVFcOqwJ1SdKIicEhKRl2EMWGppZg	2021-08-26 07:05:55.140118
475	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDc5ODAsImlhdCI6MTYyOTk2MTU3NSwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.laQ69xvZdpnUDvxVL8dbtHDyFO-q_1yC7Xt_h4avosM	2021-08-26 07:06:36.275606
482	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNzE4NTUsImlhdCI6MTYyOTk4NTQ1MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.idgO7eDcy3arP5aKB4l6lf7RKJT22bCedAFjVbKYK0M	2021-08-26 13:45:47.258557
484	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3MTYzNjQsImlhdCI6MTYyOTk4OTk1OSwic3ViIjo5fQ.qYegI6iXOekNfFEau3BCQDP1B_tPwzJdD13wgVN8Yh0	2021-08-26 15:26:58.932251
474	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODc2MTcsImlhdCI6MTYyOTk2MTIxMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zLnTi0XHTzDUHRKkj2b05lx0j8V1noLOyc6wDVGz2Kw	2021-08-26 07:06:27.134114
476	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDIwODcsImlhdCI6MTYyOTk1NTY4Miwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.pwDYWttOs6ARoKsFJL29wrfgpwTMDJY9UsP-XvIpNro	2021-08-26 07:11:14.72869
477	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODgyOTQsImlhdCI6MTYyOTk2MTg4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kd5tSxetjnYDOdxQnuhgKjCTfyUwBloxdthyzp1lBBQ	2021-08-26 07:13:01.181458
478	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNDgzODksImlhdCI6MTYyOTk2MTk4NCwic3ViIjoxNiwicm9sZSI6Im1lcmNoYW50In0.OUxWfCIVrepYeuMBNJFwE-ZuxJn5f_3tM1cEOh026Tc	2021-08-26 07:35:24.234104
479	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3MDI1MzcsImlhdCI6MTYyOTk3NjEzMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7R30zkvtL7Ak7I1NR13VpvVOy1ljghCtERlqJ-6iqF4	2021-08-26 11:21:24.299822
480	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNjMyOTQsImlhdCI6MTYyOTk3Njg4OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.lvMrnUCdXdk8Ogz1UitKgPKAJhncst6gDqSnNi932bY	2021-08-26 11:22:18.62625
481	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3MDc5MTEsImlhdCI6MTYyOTk4MTUwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.milOt3jfk_58wj2TM0IpbVrKg8C7BZI_yslIKGjMhAg	2021-08-26 13:44:05.940254
483	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3MTM1ODksImlhdCI6MTYyOTk4NzE4NCwic3ViIjo3fQ.RPmYEp2xakHp86xtETduv7aZBQ0TtnYKom9WUoJgN9c	2021-08-26 14:40:11.024059
485	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAwNzEyMzAsImlhdCI6MTYyOTk4NDgyNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.6LrcC_8-WofOScf0H3hQgTurbC4zwEa9kyGys_vbl9g	2021-08-27 04:56:34.055379
486	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAxMjY2MDMsImlhdCI6MTYzMDA0MDE5OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.amlC0DbeSrc9y0iZwOfcZrbX27wkxV8P0ikC6FrY0gM	2021-08-27 06:20:10.477704
487	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3NzE2MjAsImlhdCI6MTYzMDA0NTIxNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9HL7zGd40nY-rYjnCSZdKTU-K425EgBwh1fR8s0pBi0	2021-08-27 06:20:41.718245
488	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3NjUwNDMsImlhdCI6MTYzMDAzODYzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.gDCeTYZdv5A_N4kzCSp4oQZLjA08nGir_Uxz7LHho48	2021-08-27 06:59:22.952834
489	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAxMzM5NzgsImlhdCI6MTYzMDA0NzU3Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.B43ItsrCSulTfCVqoT2f9vm5P7zJLv7dmRHSHVjWdRw	2021-08-27 07:07:15.673002
490	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3NzUyODIsImlhdCI6MTYzMDA0ODg3Nywic3ViIjoxM30.MYv7qisF3u-swUctjbRvZJ3pom_xmzrlwm_WaHEslgg	2021-08-27 07:30:10.63417
491	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3NzU4MTksImlhdCI6MTYzMDA0OTQxNCwic3ViIjoxM30.SwntbUkg2OfE3izcdEXUXCNQvubnuGg2-iEZCng6csQ	2021-08-27 07:57:02.942019
492	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3Nzc1MzUsImlhdCI6MTYzMDA1MTEzMCwic3ViIjoxM30.3Gq_fLlqxgsHloq_zPCk2gCksyp9F6XCAiYaGjwQY1Q	2021-08-27 07:59:40.250686
493	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3Nzc1OTEsImlhdCI6MTYzMDA1MTE4Niwic3ViIjoxM30.PIBTVQUQJrp9pXmtzTMz-6mTABtHQwikaHNMVLLp27c	2021-08-27 08:00:08.618295
494	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3Nzc2NzYsImlhdCI6MTYzMDA1MTI3MSwic3ViIjoxM30.Kxb9z9sZDXq0dPONufrJBLyS5983pqmZiQnxW5dQSHQ	2021-08-27 08:01:31.968534
495	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3Nzc3MTQsImlhdCI6MTYzMDA1MTMwOSwic3ViIjoxM30.dA4rIQ-XZ2LF_-DidI38I3LYieI1dK_6KVDr1VFFsNk	2021-08-27 10:35:08.070766
496	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3ODY5MTcsImlhdCI6MTYzMDA2MDUxMiwic3ViIjoxM30.MLZo9lsP9W2p9Y3V8NanXSicdF0YE0pC0bKpO6A3yYE	2021-08-27 10:53:02.493104
497	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3ODc5OTQsImlhdCI6MTYzMDA2MTU4OSwic3ViIjo0fQ.q_7w9Y1fncNJhugwbM3cMykU8XhImJyCT1wUssb3fhU	2021-08-27 10:53:40.212888
498	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3NzQ0NDcsImlhdCI6MTYzMDA0ODA0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._zjmD26Q6FgEbKU-EDibwh9HqNX3r6cp49n6HlX8SCY	2021-08-27 11:11:38.48056
499	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAxNDkxMTIsImlhdCI6MTYzMDA2MjcwNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.uiE0QfwQVdcungiZuMDjSZ6o4KQiCBZ6EC5HHgtVF5w	2021-08-27 11:12:25.482629
500	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3ODkxNTYsImlhdCI6MTYzMDA2Mjc1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.fJDsXA42KsUE8h9-0CN7bzf9gmXA_LZx50r9h6deuN0	2021-08-27 11:17:02.422994
501	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAxNDk0MzMsImlhdCI6MTYzMDA2MzAyOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.h82xw_hEn_qMkTSPJW4ESTwrVlDC7skWuOfZ_LfYpLU	2021-08-27 11:17:41.033238
502	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3ODk0NzYsImlhdCI6MTYzMDA2MzA3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UzNuMDBmJo5sGq4eJzIZYyAhR7Bro9vlU55depjv0-8	2021-08-27 11:19:00.103278
503	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAxMzE2NTIsImlhdCI6MTYzMDA0NTI0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ._0y2aM643qfFdAfWvrP0b8eoCQKlBFm7h-uyXTyFI6w	2021-08-27 11:45:34.100823
504	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg4MTM2MjIsImlhdCI6MTYzMDA4NzIxNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.NZmcq4GGTIoKFcTXh9CVLtf_Tcpd5QkuPfUaSuj7h3o	2021-08-27 19:17:13.348168
505	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg2ODc3OTAsImlhdCI6MTYyOTk2MTM4NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.v6ahImDooTs4awojLVAoAEf_mIyCqm1rbV_9DE3vMho	2021-08-28 07:03:49.640313
506	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5Mjg1MDQsImlhdCI6MTYzMDIwMjA5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AKFlh9j0ywG648871FNsEQIpaoYFMfTGuNTsWLVA4Qc	2021-08-29 06:33:26.81594
507	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDUyMTYsImlhdCI6MTYzMDIxODgxMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.9DzUh5Y8Nx9zXn7o7wG6NIEc2uUeyq6_Ue2jcPoa8n0	2021-08-29 06:56:01.502937
508	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NDY1NzQsImlhdCI6MTYzMDIyMDE2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1ePYwXSOcZq0-T1MO9-SdmONfvU8m5RiTeUS7j6-ZT0	2021-08-29 06:57:36.242965
509	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDY2NjYsImlhdCI6MTYzMDIyMDI2MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Jt5AYQ5gdKm_dOhs9jGuCahk0-GyTIRmm6QXNGtELzI	2021-08-29 07:01:26.423028
510	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NDY5MDMsImlhdCI6MTYzMDIyMDQ5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.QhUN4ynzbTnh_sCA7nW89yTgEWZme9smzKeAWxqTzu0	2021-08-29 07:02:56.862269
511	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDY5ODYsImlhdCI6MTYzMDIyMDU4MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.lhRx_SMF7rjcUuwrhqCy7vthOsezfk9pS4NGPhKXp5o	2021-08-29 07:03:28.792495
512	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NDcwMjAsImlhdCI6MTYzMDIyMDYxNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7Itqz1UrZpLc7exwX6Fd_xCJC60yVShkr5x-hu7pSYI	2021-08-29 07:16:16.075835
513	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDc3ODcsImlhdCI6MTYzMDIyMTM4Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.nzxOYmpxNhP5ogploq4lZOiJ0AA6KIuXDA-_gbaG4KA	2021-08-29 07:26:14.723119
514	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NDgzOTcsImlhdCI6MTYzMDIyMTk5Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ihwd3wGcpdJGADQZqKVXwL1or2vsI13MLt8KJS-lVx0	2021-08-29 07:26:44.113053
515	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDg0MTUsImlhdCI6MTYzMDIyMjAxMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RWDWWwYoSi8cUFnTLM9SjTrkNyWGxEgAoAk2eMq6EXc	2021-08-29 07:47:00.054478
516	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NDk2MzEsImlhdCI6MTYzMDIyMzIyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.yZYrO-TX_cG9snuKwvdtBSQy80sH16daDh8VU4fBhO4	2021-08-29 07:47:44.478704
517	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMDk2NzQsImlhdCI6MTYzMDIyMzI2OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.bC9Sq3jViQAcffZ1_aNybrbcR3UEQBpveHOT9wYuuzk	2021-08-29 08:56:47.08427
518	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTM4MTgsImlhdCI6MTYzMDIyNzQxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dDgbwtnR1aOXZ6pjenPOhl8tu3QoMWoV5vkfumrO88U	2021-08-29 08:57:14.884268
519	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTM4NDMsImlhdCI6MTYzMDIyNzQzOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.SXHkU8LRua7fD0LzEZzj47Neimi0mn8NhpBJILhhMok	2021-08-29 09:08:13.468986
520	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTQ1MTEsImlhdCI6MTYzMDIyODEwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.JGmcDzqr86BxcQwB1YJoXBjNifeGun5D6L4_P5dbxjM	2021-08-29 10:10:59.669207
521	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTgyNzMsImlhdCI6MTYzMDIzMTg2OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.t-YzGkCmn91d8fShsgnQ4dtzT47EGbN90Wc1HgV3yZY	2021-08-29 10:12:05.363978
527	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTk0MzEsImlhdCI6MTYzMDIzMzAyNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.m8t-rb0EsQbcSBqXeniU1OkM5YXVlWw1D4soJ-ztD7s	2021-08-29 10:31:45.014256
522	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTgzMzYsImlhdCI6MTYzMDIzMTkzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sCYbaaCYp7Z_ygSDMDkkOzuAQqrY1M9ToEUvKB204fc	2021-08-29 10:12:24.924409
523	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTgzNTQsImlhdCI6MTYzMDIzMTk0OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.B6Jhbp2uCS5T0XdwtFsNwGYDes7QmQuRoaIxmDmlz80	2021-08-29 10:15:23.421596
524	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTg1MzYsImlhdCI6MTYzMDIzMjEzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.yaWdIg1mBmTkQuOFx-ncSWBXpz1oK56w2WPOb1gx-Jk	2021-08-29 10:15:52.256287
531	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NjA0MzcsImlhdCI6MTYzMDIzNDAzMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qhb-DqfITj4ihu0lYDBwzzj4cO9TVpyTRkdSoL2Q-OA	2021-08-29 10:47:30.70191
525	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTg1NjIsImlhdCI6MTYzMDIzMjE1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-JjYxiPdo2dywdtaz59cclF5TccSZFVuEKPlrQWsBBE	2021-08-29 10:24:19.705895
529	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMTk1NzEsImlhdCI6MTYzMDIzMzE2Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.NDfNWXpgSTPz7MVeprHwIYNHQ8iXG2nPGcHDIgG-8Zw	2021-08-29 10:34:22.215933
526	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTkwNzAsImlhdCI6MTYzMDIzMjY2NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mvk9pMGPS5ZzJJ7NpA52rDU1Jg-98ofK_HeGboaUKqw	2021-08-29 10:30:20.558912
528	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTk1MTQsImlhdCI6MTYzMDIzMzEwOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bsWaN1CeoPf_J54NDbAO8PimT8lizhY2D1m_7b6Uo6E	2021-08-29 10:32:40.689424
530	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NTk2NzgsImlhdCI6MTYzMDIzMzI3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.i5tO_Tpr1IKWH5ZlQrxiC3KWkPoOc7UT7Y1wAYYMmAU	2021-08-29 10:46:59.100045
532	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMjQ4NTIsImlhdCI6MTYzMDIzODQ0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ey-c5a6TKpiPyF8dRYcpS13foNAcS2GB99jzfU5Wx8A	2021-08-29 12:05:23.453328
533	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg5NjUxMzMsImlhdCI6MTYzMDIzODcyOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.K-hfMuag-TeWLwgy5TQN-mQUmbBm_tX1KXlxqUXHmTo	2021-08-29 12:08:15.423956
534	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzNzQyMTcsImlhdCI6MTYzMDI4NzgxMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.oLwEgW-uWzRb7zFI81QVDM1pgEsUR223MDCbEYzCDio	2021-08-30 02:55:40.582991
535	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMTg1NjEsImlhdCI6MTYzMDI5MjE1Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Z--rwxxwR8k-SyMr1sIC8EREcvsPrrajd47Tl0mo_y0	2021-08-30 03:00:58.247263
536	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzNzg4NjgsImlhdCI6MTYzMDI5MjQ2Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.IVavvmjBM-XwSSH2Y9CHTXIn6ipGuyNglBPFE58OzBo	2021-08-30 03:01:19.707464
537	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMTg5NDMsImlhdCI6MTYzMDI5MjUzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.h6uNbmombaJeXEU8NXv3N0RnpAYA8-309GHUHdqh_Uk	2021-08-30 03:03:04.045324
538	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzNzkxNzksImlhdCI6MTYzMDI5Mjc3NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.DdlW7-37z0wljxCw4RCA-8Iu1nxB2GjiCBolyC6id50	2021-08-30 03:06:50.93636
539	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzMjg4MzcsImlhdCI6MTYzMDI0MjQzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XPWkgc5MLGjzIrWtPUJZHAeUoFOR-e0WaMzRNaDC5RA	2021-08-30 05:03:28.045624
540	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzNTkxNDQsImlhdCI6MTYzMDI3MjczOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KjqtwZ7EWEgrX5_N5NJ6pP7NEbxg-asWWu7bMIVbrZ4	2021-08-30 05:44:33.41963
541	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMjg2ODMsImlhdCI6MTYzMDMwMjI3OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4ktg3SmaaUtSItLVWeGwCPre28uWQPTWbnmxkfK2j7I	2021-08-30 05:48:04.13907
542	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzODg4OTksImlhdCI6MTYzMDMwMjQ5NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.7aivCkeeFVc758ZzGeg95nG4fjpPVlY_RMpbI2JIlVU	2021-08-30 05:48:57.685671
543	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzODYyMTgsImlhdCI6MTYzMDI5OTgxMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.qTHQ3cPqQAou0XrsVHeGyNKCtUpXZZzBfzoGdc_x-4w	2021-08-30 06:40:08.187636
544	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMjg5NDcsImlhdCI6MTYzMDMwMjU0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.pqe4Hk5HXPVeNFFwKJHzOMOU-V4OqUhIQJjgPnbXcBo	2021-08-30 06:40:17.322549
545	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMzIwMTksImlhdCI6MTYzMDMwNTYxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xGvSFp4Le-HjQnh1hH4l3isoSu6Vl2zEz7-9yvmQSOo	2021-08-30 07:23:13.019995
546	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzOTQ2MDMsImlhdCI6MTYzMDMwODE5OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.MTvl6eEnPt6cKwGcuO_egX9J7SBpbn1J02GYExlodVs	2021-08-30 07:23:44.803345
547	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzOTIwMjksImlhdCI6MTYzMDMwNTYyNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Ec2-tjymTqCodPUR3PTMc6W8vr-mAwxZ1RdYq9znzUI	2021-08-30 08:16:23.398767
548	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMzQ2MzksImlhdCI6MTYzMDMwODIzNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GSht8XeCFYFpPiVM-JE2DN1loQBndSYAYtE2COlZleU	2021-08-30 08:51:23.152194
549	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzAzOTk4OTQsImlhdCI6MTYzMDMxMzQ4OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.aro8kWvTUpabw2rZ7YWY_vD9zQF077YjpaMsoSoX7zc	2021-08-30 08:52:26.217923
550	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMzk5NTUsImlhdCI6MTYzMDMxMzU1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.J73IEpfahm2CEQUqr5eP448lKdhbNA8-mqLlZ79H_DM	2021-08-30 08:56:07.200243
551	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MDAxNzksImlhdCI6MTYzMDMxMzc3NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mEa9cZizU6T85mbuqzOej0svIqnIbBE-PMyyE_T-WS4	2021-08-30 09:01:33.423637
552	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMTkyMjIsImlhdCI6MTYzMDI5MjgxNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YYW_fIDmZZwcNSwo8ezEOyBetXCsbjr7zpWokUgvUvw	2021-08-30 10:15:51.315114
553	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MDQ5NjMsImlhdCI6MTYzMDMxODU1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Cc7BszKtX1LiMdYXREbiT73llO4aFCtthmf6lWrqwxg	2021-08-30 10:20:27.290497
554	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwMzc3OTUsImlhdCI6MTYzMDMxMTM5MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1endNro6hxZ9SNox-0qA39nrUsju9ODIJgTWzeEHHH4	2021-08-30 10:29:35.00908
555	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MDU1NzYsImlhdCI6MTYzMDMxOTE3MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QSR8SYUMK6vXQTjZUSymFk3wWkkpiDWVgsTIUnQYrlY	2021-08-30 10:37:55.005333
556	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwNDYyODUsImlhdCI6MTYzMDMxOTg4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.rX4lKHkOdzN24f_FiZjSd28WXftFekn60zxUbsNeIxs	2021-08-30 10:40:58.905101
557	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MDY0NjksImlhdCI6MTYzMDMyMDA2NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XOJsZ_Ny6NGaa9zORvXHti5R4mttR5hBvPX_Zx276F0	2021-08-30 10:46:54.524805
558	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwNTUzOTgsImlhdCI6MTYzMDMyODk5Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.baTh5Ljoltj57FMZNRRlUu7JWftmvDzanFlmCZPWPCQ	2021-08-30 13:23:58.567688
559	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MTYyNDgsImlhdCI6MTYzMDMyOTg0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.O1WnMr2DTLH-YDrIOeSxsesQenqVt-GuEjn0L0YcOko	2021-08-30 13:39:49.181879
560	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwNTcyMDAsImlhdCI6MTYzMDMzMDc5NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.rIJQVRYx0vKGA8GEOlvxPhK1A2IKuHv3PaT8ObHg8O0	2021-08-30 13:50:28.760852
561	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTY0NjksImlhdCI6MTYzMDM5MDA2NCwic3ViIjo3fQ.wHE1om1yZehaoEQGPbx-MOyLUzzmoM8w3M1XJ5IF_NI	2021-08-31 06:11:26.240325
562	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTY2OTgsImlhdCI6MTYzMDM5MDI5Mywic3ViIjo3fQ.DrqL_fCOBi6gQm_cUZTCGpE6BBMVgx0oY01aGqwfQMU	2021-08-31 06:21:18.852703
563	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzk2NjcsImlhdCI6MTYyOTgxMzI2Miwic3ViIjoxM30.m2vf_tdMaX7Eml9JHtiQGix6SUXnpwBmtHd4XaQSzBM	2021-08-31 06:22:54.869561
564	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0MDU3OTMsImlhdCI6MTYzMDMxOTM4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.1hyXe7sve_m2wiXtK3fs0CVBSIiw6OtjWVD6PaU0pK8	2021-08-31 06:43:26.177459
565	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3ODgwMjgsImlhdCI6MTYzMDA2MTYyMywic3ViIjo0fQ.tfa1G56SWF_SqlizenwpVfMvHO6ywUlLFp6QCq8M49w	2021-08-31 06:49:42.571227
566	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTczMzgsImlhdCI6MTYzMDM5MDkzMywic3ViIjoxM30.el-vLGWUPbR4_RDQ1t9CpEz1rI3x3yGw7HAwk_iwaIc	2021-08-31 06:53:14.171504
567	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkwNDY4MjQsImlhdCI6MTYzMDMyMDQxOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.740-z6Gdu9nFChZcDbZMRGZd3AEKDbMfFGcGIk4CdiM	2021-08-31 07:10:23.06683
568	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTU2NzQsImlhdCI6MTYzMDM4OTI2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Od5HpnpDDjcgUkjAeGCNkVGvcy0Zz3QPrhfMxDNOqhE	2021-08-31 07:37:19.917262
569	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTg5OTksImlhdCI6MTYzMDM5MjU5NCwic3ViIjoxM30.ahTbm-TZFZMtm43V5SMKoZLelBNpGzv7WFD-RSBs_6g	2021-08-31 07:37:33.169686
570	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjE4NzEsImlhdCI6MTYzMDM5NTQ2Niwic3ViIjoxM30.Ak8uvAjW1RHYUZ6MMVdvicANG6d6SF4bYfFjlHbe8bQ	2021-08-31 07:42:04.66989
571	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjg4ODgsImlhdCI6MTYzMDQwMjQ4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XG4IeOZEBfBgIUNyinyGfflq_nVNO4_pYKPU0ikkJ8c	2021-08-31 09:37:53.70078
572	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0ODkwOTUsImlhdCI6MTYzMDQwMjY5MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hM0xRWz6BikrZ0tAhEHE_axL2aCcEAuisM0-MkDMSRg	2021-08-31 09:41:04.093415
573	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjE4ODUsImlhdCI6MTYzMDM5NTQ4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.aENZYXyAotF2olyRd-Agcclg9xgYrH2VjTI_Jkj_Nfc	2021-08-31 09:51:58.921196
574	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0ODk5MzIsImlhdCI6MTYzMDQwMzUyNywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.4NVuucs-MOswnG7rkQjBH4mAqHqAN00Ytw2zvWg2SWY	2021-08-31 09:53:10.490157
575	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjA1NjMsImlhdCI6MTYzMDM5NDE1OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.X00jQea-8nu5EQq0F0CQPHoPcoToGNfAC1IW5eLpFo4	2021-08-31 09:55:26.728025
576	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzAwMDQsImlhdCI6MTYzMDQwMzU5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.T7tlJkixMA3NXszSI41JhL53A9IR4RBfRBvp_aoEcHY	2021-08-31 09:58:51.855613
577	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTAzNDQsImlhdCI6MTYzMDQwMzkzOSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.DVq3-gh6IeXNlwEODWqw6hMHs9V-4vW4kRVxXwIGLXg	2021-08-31 10:00:29.284469
578	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTAxMzYsImlhdCI6MTYzMDQwMzczMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QC8rxkjfqRDJlqHJI6-4X9MranJM7aNIVEkZ2QkAAps	2021-08-31 10:04:36.704824
579	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjkyNzQsImlhdCI6MTYzMDQwMjg2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mFSY4i47J6NRIeQ1QR4pbDDR4oNNX0ie4wkzZT60-x0	2021-08-31 10:09:42.763794
580	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTA5OTIsImlhdCI6MTYzMDQwNDU4Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.6gQj9MR9st1_dqsOW8xGptXuM-RaRSOcoIUPpMyiR68	2021-08-31 10:13:02.189081
581	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzExOTMsImlhdCI6MTYzMDQwNDc4OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8jxQVZROQHycWr5pVu1pEoeiDwFKxhMVqDxavnNFkD0	2021-08-31 10:17:09.848001
582	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTE0NjEsImlhdCI6MTYzMDQwNTA1Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.wsBO66-ASI8wilP0XOZSZK08OHvcjsU_OyNtfk4KPXw	2021-08-31 10:19:20.914344
583	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzE1NzEsImlhdCI6MTYzMDQwNTE2Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xf-VHqPIp5kJRHYpgyTlV0MNBF5AfvfWtZZqzBEdr8M	2021-08-31 10:22:41.737895
584	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTE3NzUsImlhdCI6MTYzMDQwNTM3MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.VmPqBCy5T27TBilwbtAnI-XV3hwGQNLYnd7VXdd4kTc	2021-08-31 10:24:05.709586
585	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzE4NTUsImlhdCI6MTYzMDQwNTQ1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kKVq8-giPtUtnHsH_UqGnquj58c17AXy-AODUNgg2Sk	2021-08-31 10:34:00.714124
586	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzA2OTAsImlhdCI6MTYzMDQwNDI4NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YNkiTzz52v3wElFo9lH3snmoB_Qu7kdRvb2CX2a1gPk	2021-08-31 10:41:44.111839
587	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA0OTI5MTQsImlhdCI6MTYzMDQwNjUwOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.kT0DUqEPV6Bpttx2JSMGgbbRVyEFoPBMLHwR76I-gV0	2021-08-31 13:06:00.246553
588	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNDE1NzEsImlhdCI6MTYzMDQxNTE2Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CTjTYOe-MIVYZoHoBAAbKsq5kalEVLmSJSiuqAEtBZM	2021-08-31 13:06:48.569524
589	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDE2MTgsImlhdCI6MTYzMDQxNTIxMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.45UjaRpf_NnQKDex4MER9aqOBNaDTG_YPD2ZmDSlUWA	2021-08-31 13:07:52.728093
590	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTg2MTcsImlhdCI6MTYzMDM5MjIxMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SfUi8VpBl1JOlrMLKIMzLkN4_hkhagarSFtBuKM8sAY	2021-08-31 14:08:08.409539
591	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMzI1NTcsImlhdCI6MTYzMDQwNjE1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8yvlMRUvQiBTI6hEstvPIZFoawlqTWIWbNU4hp9ls1o	2021-08-31 14:39:04.000611
592	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDcxNTMsImlhdCI6MTYzMDQyMDc0OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gIuz3QPIG80-VKmsGvZMG5oH0sTjrtiW_woUvkoH1ps	2021-08-31 14:39:20.151144
593	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNDMyMDcsImlhdCI6MTYzMDQxNjgwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GxHC2BrfcbLN62B-JQvnTcpF6oIM3yFggzpkZ4vhe9c	2021-08-31 14:46:21.688255
594	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNDE2ODIsImlhdCI6MTYzMDQxNTI3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.3abgY4uJ1IQ5vKxmxJuFPWc69SeRqjwuaX5g1Ud7qeI	2021-08-31 14:49:39.30843
595	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDc3OTAsImlhdCI6MTYzMDQyMTM4NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tpU7I-IREGRdYasgCY9_EQUu-0Q5RBFn3nyeEhx5ZYQ	2021-08-31 14:53:54.180525
596	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNDgwNDQsImlhdCI6MTYzMDQyMTYzOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9NJy7Qkg3qingu2BDl4u2CTosSNr3Pchsxou_fFZEzQ	2021-08-31 14:58:49.020802
597	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDgzNDAsImlhdCI6MTYzMDQyMTkzNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.FAJc5V_-U359MFVnakxH1DwM0-8JECvWHW3i6OmwUx0	2021-08-31 15:05:55.511266
598	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNDg3NjUsImlhdCI6MTYzMDQyMjM2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.10v4sX9CVqUPoRnKrCwAkTuILUtUCErWIFdEqPUA2G8	2021-08-31 16:07:33.197386
599	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNTIxNzgsImlhdCI6MTYzMDQyNTc3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UlUIUes7CHG3nMPzzevkGLIvPP-NjuZeOQlgPL6jFus	2021-08-31 16:10:57.207386
600	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNTI3MDAsImlhdCI6MTYzMDQyNjI5NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.l9KPjn1kqpj5rliNsXTi63m8u6kOR3cCD9qk8ZGghTQ	2021-08-31 16:11:43.22276
601	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNTI3MTgsImlhdCI6MTYzMDQyNjMxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.tACaiBKOnCsENfHhyh-Fa_Jbka-AAGD0w8zduWfiIus	2021-08-31 16:11:57.157411
602	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg3MTgwNzIsImlhdCI6MTYyOTk5MTY2Nywic3ViIjo5fQ.dz5Ei6dxlJwSzVBfaPU_jAT-BCw2jxHqEMzVH0p8tE4	2021-08-31 18:57:42.453964
603	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNjQ1NzYsImlhdCI6MTYzMDQzODE3MSwic3ViIjo5fQ.-SNZ0V900TBbMUQuME2l2UXNHxbfBATfXWfpzd-5c4Q	2021-08-31 20:02:27.871046
604	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDcyNTksImlhdCI6MTYzMDQyMDg1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KMKNy6Whth5vAhF64LjX_bhddNLA7ubfdQedBytVVhU	2021-09-01 00:43:53.235199
605	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxODM0NDMsImlhdCI6MTYzMDQ1NzAzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dXqz5DlQp6ResB5oiCf8NbPHLIDyFYOKIPEuK8BiitU	2021-09-01 01:02:08.637704
606	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NDQ1MzgsImlhdCI6MTYzMDQ1ODEzMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.9FNwEgrF_B_2jPhTJy0Vjr87bUCoJuoPx3hrrvAr4Gg	2021-09-01 01:10:06.072656
607	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxODUwMTYsImlhdCI6MTYzMDQ1ODYxMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LQipxNY7gjnuh9GfCHorT_CvQXTavz9A8vbU90T_rT0	2021-09-01 01:10:38.677657
608	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NDUwNDgsImlhdCI6MTYzMDQ1ODY0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.FI7Oxkd0ZC9MhvLnto9A7nNq39X580w9_8PhnUsJCZg	2021-09-01 02:04:52.920843
609	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxODgzMDQsImlhdCI6MTYzMDQ2MTg5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.-MULLzUyHPcBz6jtIuCF4nvDGY9M3lx5yUtP7jHrcho	2021-09-01 02:10:26.749732
610	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NDg2MzYsImlhdCI6MTYzMDQ2MjIzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.06l5eAZIFxeJOWjibtWhTMp7KSjASrWiAHlDMdFvYN0	2021-09-01 02:16:37.809449
623	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NzMzMTEsImlhdCI6MTYzMDQ4NjkwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RKH5Pcgb0JafNBIrS8W1LSgt0dd4X59zQljgYgKPR20	2021-09-01 09:14:28.926417
624	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NzUyODcsImlhdCI6MTYzMDQ4ODg4Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.nc1dAQClIeGvTUJYoLWqHtVBcbEZIKJjCaeF1BTkK3s	2021-09-01 09:34:45.279563
627	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1Nzc1NzIsImlhdCI6MTYzMDQ5MTE2Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.P8dTnL--tf-S_Demn92Hfuhm8-5yUdZH0deoBTkWEVo	2021-09-02 05:16:09.827178
636	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMjE1NzgsImlhdCI6MTYzMDU5NTE3Mywic3ViIjoxM30.zmvgq306-4bd7s1EGQj0UzIJNgyxnvkSKat8tzPi0vI	2021-09-02 17:50:09.482393
611	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxODkwMDcsImlhdCI6MTYzMDQ2MjYwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hBs1IeMs5EVmYrDC5vuAoOY0_sa078Yi3J0xWvzmKw8	2021-09-01 02:22:29.449521
612	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NDkzNTksImlhdCI6MTYzMDQ2Mjk1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.6GaugU5q3BnMKeoxJ5dUv6ZIIB7rzR_SYSAud0RlsHY	2021-09-01 04:29:51.31799
613	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxOTcwMDIsImlhdCI6MTYzMDQ3MDU5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SDKhawDY58eEq45Rtzj8KYapXvwGwFunPeTxjnUtFVs	2021-09-01 04:34:12.02158
615	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MDUyOTksImlhdCI6MTYzMDQxODg5NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.zie892YSuvldxCKeto5q5bWaQZ3l0iBqGgc7wfs0suk	2021-09-01 06:08:15.159614
616	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyMDI5MTQsImlhdCI6MTYzMDQ3NjUwOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.HtAL0dXQvmmFDdv5h4jHvz8RayuwyqAquOJgZ8fop1g	2021-09-01 06:08:37.674757
622	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyMTA4NjksImlhdCI6MTYzMDQ4NDQ2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RVk7ZZ_MT4e-SzRz0iRLqP6vlbuEBJKe4AfSo7VM3-g	2021-09-01 09:01:40.769199
626	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyMTQwODAsImlhdCI6MTYzMDQ4NzY3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LnlT9b6mKqdPVjDGqS8sJyJqxfFxNU-MHm6pV140WdA	2021-09-01 10:12:41.554411
614	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NTcyNjMsImlhdCI6MTYzMDQ3MDg1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.GL37F8mvQvM_Dkp4ufvknl1nuJEONvZCh4ZtkZdeZh8	2021-09-01 04:35:42.083739
617	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NjI5MjgsImlhdCI6MTYzMDQ3NjUyMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.0UDdw65QBTM3HmIOzyNZi520WuUQs3GKtoy8-fjPY4E	2021-09-01 06:08:56.024726
618	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NTczOTIsImlhdCI6MTYzMDQ3MDk4Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8j9VWqc6mFq2iAR3VMamZHuWUy-F5SyVqzc-yGSe8vM	2021-09-01 06:17:15.762063
619	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyMDM0NDUsImlhdCI6MTYzMDQ3NzA0MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.M3u0SRa7HlvTMMcVNvgWFvMe5cWynqa-xd5pnY2C_zk	2021-09-01 06:53:04.807285
620	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyMDI5NDYsImlhdCI6MTYzMDQ3NjU0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.D3zwH-Y7wfFRa_nPm4PaaKWnjxTCs1sgQopfbFJMvVY	2021-09-01 08:09:20.648157
621	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1MTI0NjIsImlhdCI6MTYzMDQyNjA1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.x45FoLwk4iJEv-LjXsAIKTZM5rZbrKN8au1L9DAYEjU	2021-09-01 08:20:55.824393
632	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMDg0NzMsImlhdCI6MTYzMDU4MjA2OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.APMWzkWVKhuH6iHLkJUXPg7NEMbi4AljKt1QAVjjwYM	2021-09-02 13:38:01.40979
633	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA2NjI1NjgsImlhdCI6MTYzMDU3NjE2Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mNS-kbevGoN3Ep0mk2LkAztR6BKFcY5JV2QZZBAX0Ak	2021-09-02 14:27:33.765991
625	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA1NzU0MjIsImlhdCI6MTYzMDQ4OTAxNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.HmwaZ1xVXUjPH04De2i8thLy72Gs7mbLGKGPAFXzbwg	2021-09-01 09:41:17.387262
628	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyODYxODAsImlhdCI6MTYzMDU1OTc3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FwWLdKtDhSBEy3x48BPN5oCGHzq4JM9F39ivLo4a1A0	2021-09-02 10:39:50.380896
629	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMDU2MDQsImlhdCI6MTYzMDU3OTE5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.IRAWqTeEkn0g6pzoxIgeSzOqO6qdLTf99BeY98BxtzA	2021-09-02 10:50:41.110992
630	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkyOTU5MDUsImlhdCI6MTYzMDU2OTUwMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.s0lHC_BG7YUfPSMx0hM9pQH0Q-whoiPAgvhSLhMvek8	2021-09-02 11:27:53.398718
631	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMDg2MDQsImlhdCI6MTYzMDU4MjE5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.R0DPz8x7iHoHdesiPj2qR1ulqjSCTudztHdXIPb7JFg	2021-09-02 11:34:44.458525
634	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMTkyNjMsImlhdCI6MTYzMDU5Mjg1OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.IrIPUYdVK36StXpVmlGOqQhl41RaJbR2tg234qF0YPQ	2021-09-02 14:30:02.803455
635	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMjIxNDUsImlhdCI6MTYzMDM5NTc0MCwic3ViIjoxM30.zhtMVVyp7sE-yEBzD-uJZ_S5pVJ2_prd1n580frWLKs	2021-09-02 15:06:05.669567
637	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg0NTUwOTksImlhdCI6MTYyOTcyODY5NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.BXMGsFHvN3rvN4iMmgLuEjQccFzokOnRtYei3oiJtbg	2021-09-02 18:46:30.622493
638	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA2Nzk0MTQsImlhdCI6MTYzMDU5MzAwOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.g_PvZYCuFpv5r_sTqc7MQHL_mGdXjD-08lNkc4R8jpg	2021-09-03 01:47:57.33486
639	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzNjAwODcsImlhdCI6MTYzMDYzMzY4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5oVa3INGJZ-eUYzW7kj5zjQyJwOT_5cMsmCtD2hw9PQ	2021-09-03 01:59:14.701229
640	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzMjEyNzksImlhdCI6MTYzMDU5NDg3NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ncdHE7zqgZOOwh5fy4Plolu5QfY3N0Z-usfnzonpIZ8	2021-09-03 05:12:00.870359
641	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzNzIzMzEsImlhdCI6MTYzMDY0NTkyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.aNgHQkeTX0KVZoPqKHuWBK-ojxML4lJTWitCFGLVH8Y	2021-09-03 06:38:04.996651
642	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzNzc3MDEsImlhdCI6MTYzMDY1MTI5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.coDC80p7u0zKrc2vzSLKI_cttajF5Z-LrRzK_hzQBiw	2021-09-03 08:36:56.850232
643	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTAxMTIsImlhdCI6MTYzMDY2MzcwNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Em6kmmYZrIr-fhqZI_5hnpQ6i1BeGPiXB1d_CvgauGA	2021-09-03 10:09:31.375609
644	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTA0MTksImlhdCI6MTYzMDY2NDAxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.aTDpZ0NGuJ-fwFUisyUCGReWh3J99y_zsNWlArmhwIs	2021-09-03 10:13:39.191429
645	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTA0NjUsImlhdCI6MTYzMDY2NDA2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VBKFU0ELv-C8ndPijJ2nv0FUzZa7KIMMrPL8g9mlRwU	2021-09-03 10:14:28.970379
646	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTA1NTIsImlhdCI6MTYzMDY2NDE0Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.0YMahrJXr3xbmTwBJ5cBRRVFxrfP6gcWKeYOgu1ZEg0	2021-09-03 10:23:11.301159
647	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTEwOTQsImlhdCI6MTYzMDY2NDY4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.d2N08zhK3dxRP35Zxx9RsJl_r4LVioZAnNVTqXlR3EU	2021-09-03 10:24:52.102569
648	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTEyMjcsImlhdCI6MTYzMDY2NDgyMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.pRHHt8vSwR867n9-Gz245eiMYOKDc0DRmqc-5dcOYGs	2021-09-03 10:45:07.710234
649	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA3NTI3NTMsImlhdCI6MTYzMDY2NjM0OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.OCzvs8Mdc0XDaY_VWN72fKKh_-YGNRrLz9sma0wmT2w	2021-09-03 10:55:27.577015
650	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTI5NDYsImlhdCI6MTYzMDY2NjU0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zkbdR04pKRZhgfoKQDktbwiIqeWcw3M7sUiCuFOd3EY	2021-09-03 11:25:05.612897
651	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA3MjA3NzMsImlhdCI6MTYzMDYzNDM2OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QsikspeG96mSVQY_YLx2HUsWdtoSD5_rJIDiUqlwPMI	2021-09-03 11:59:00.933885
652	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkzOTY3NTIsImlhdCI6MTYzMDY3MDM0Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.tA0wjV217QF0K0Dz9xnGve7fwiZ4jh0fDyMA3inN_MY	2021-09-03 12:03:43.72383
653	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA4MTU5MzUsImlhdCI6MTYzMDcyOTUzMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.mN1wMiPWbqIbwOF10R5lQpZ4yab-GUaI9gkAt1CzORA	2021-09-04 04:29:23.61298
654	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxMTc0MTYsImlhdCI6MTYzMDM5MTAxMSwic3ViIjo3fQ.p5efwHDbCtI70kX6NGfU_7wh9BF_43P8q0bi4JvDSgc	2021-09-04 14:37:32.769518
655	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk0NTYxNzgsImlhdCI6MTYzMDcyOTc3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8a1bvc9kdLUFhRply2rojHSwWuamxP30zKNI3ookQZ8	2021-09-04 14:38:12.567949
656	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1NTE3MjMsImlhdCI6MTYyOTgyNTMxOCwic3ViIjo2fQ.fqX9yhly_uzFWvdEuEaftEfoCzAecn-mCi8vBxsbozI	2021-09-05 08:08:47.083447
657	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk1NTU3MzUsImlhdCI6MTYzMDgyOTMzMCwic3ViIjo2fQ.M8O8EQI2uswwM2n_SIavgdp_6rlxudWOcDxR24HF1CQ	2021-09-05 17:16:14.273239
658	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk1ODg3NDUsImlhdCI6MTYzMDg2MjM0MCwic3ViIjoxOX0.6ZlK9fcYbdQa1mzh7P88GB0Z6xHSgHvLeOBR7Ohc5VM	2021-09-05 17:19:13.137764
659	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2MzM5ODQsImlhdCI6MTYzMDkwNzU3OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jRWfizekGvxIYeloJFF9maFxgZfP-N_3L4o1_J2T2wc	2021-09-06 06:33:00.541225
660	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA5Nzc4NzUsImlhdCI6MTYzMDg5MTQ3MCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.R6KADsvuVbLGRLNZ_GNUknKSVk3iJ0HGkCnYb7p-DrI	2021-09-06 06:56:16.572149
661	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2Mzc3ODcsImlhdCI6MTYzMDkxMTM4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.yZgoxC9-cQoqYx3cUjDHpVOO22oIi62hfdXiN7lhq2E	2021-09-06 06:56:39.672011
662	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA5OTc4MTEsImlhdCI6MTYzMDkxMTQwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.A6KhXtG4mvqIdGscgxJ7ABl3gPUSSNNxy3RWPh36C38	2021-09-06 06:59:40.411929
663	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzA5OTc5OTAsImlhdCI6MTYzMDkxMTU4NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RoU1PEn7OaJ2VyeBg-A7Xqm_cOC_AiRt_x6Y3q2s3co	2021-09-06 07:05:55.278468
664	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDAxMDMsImlhdCI6MTYzMDkxMzY5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.-pC3OkyMCqu_WzDTgdEojx9PGOCfdInRrODrNoKzeSs	2021-09-06 07:35:56.485688
665	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDAxODEsImlhdCI6MTYzMDkxMzc3Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YqSOdOsteAx7a29ulWJSlaQZ6QwOmeHzIjLSbpI6lKY	2021-09-06 07:37:00.200966
666	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDAyMjksImlhdCI6MTYzMDkxMzgyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.io7Y86jQbxRw7bA7R09ZBTodr9ovokx65kC7EcRpvEk	2021-09-06 07:37:28.748997
667	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2Mzc2ODIsImlhdCI6MTYzMDkxMTI3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.22m0WhTBUmzJCwSw-SRxysJ46T4N9LiL-jf6v1ezMR4	2021-09-06 07:48:11.090055
668	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzEwMDA5MDQsImlhdCI6MTYzMDkxNDQ5OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Ud70NZrIXNVYrso9AnnakgSgbE9cUXXBbSkau8oT87Q	2021-09-06 07:49:37.815751
669	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDAyNjUsImlhdCI6MTYzMDkxMzg2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.NidgewaDWpKNvOwSzX0vgUvRpahkAldfSZYeotcXXbc	2021-09-06 07:57:02.542914
680	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQxNDYsImlhdCI6MTYzMDkxNzc0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7VVIhZMtO85A1g641bLADTB-wwvzOy_c6Kk0-hJpg0g	2021-09-06 08:42:36.788438
681	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQxNjksImlhdCI6MTYzMDkxNzc2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KtrxbQhzs6JmMEvYJReR6PwE_MN1urae5o-KSE6jLWI	2021-09-06 08:43:57.431066
670	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzEwMDE0MzcsImlhdCI6MTYzMDkxNTAzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Q2cgZncnEFf7aXCKfPTybNkuPija4KX0766JnYLPhz0	2021-09-06 08:18:25.922213
671	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDI3NDQsImlhdCI6MTYzMDkxNjMzOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RctbTHGdIPaEWW-sGm245llt-Kf2UlMHXPlGwyx2LiU	2021-09-06 08:19:45.250053
672	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDI5MzIsImlhdCI6MTYzMDkxNjUyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YNzM6Mbin1e5w6snSev_F2xO7eNnh1GsIPGcW6iuDQ4	2021-09-06 08:23:45.135371
673	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDMwMzUsImlhdCI6MTYzMDkxNjYzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.6SudGHplRqWKjzaz-rGR77i4YFmoQS139G1tvpsvWC8	2021-09-06 08:25:09.499674
674	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDMxMTksImlhdCI6MTYzMDkxNjcxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.EcXlpkPM97EgLG_oi3A1SD-20AF7wr7gzMDCcTJshTA	2021-09-06 08:25:21.617726
675	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDMxMzAsImlhdCI6MTYzMDkxNjcyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Ai7czyK93QsZnxDu3n7M6DPtRuPeBPJh5z6BhMLLdB4	2021-09-06 08:25:36.506994
676	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDMyNjksImlhdCI6MTYzMDkxNjg2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KdWvHLZhDksaOY6gpyazffCZV-cngXzWnzaxfYh7evo	2021-09-06 08:37:29.584608
677	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDM4NzAsImlhdCI6MTYzMDkxNzQ2NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hgAFx5lvsWXUdAZYMWLt4yxuox5JvBPj4KXYAaQtDZQ	2021-09-06 08:40:08.304871
683	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQyODUsImlhdCI6MTYzMDkxNzg4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.q7V6A9Gv4g3JA3HrdcLu3DqM7keDlxTLSsVi7EdLQsE	2021-09-06 09:33:12.50957
684	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NTA3MzEsImlhdCI6MTYzMDkyNDMyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hhEGQl7B0LI0JCjwzzv2NnhZcBdUzgOdydZzPZEZQ8k	2021-09-06 10:33:02.404559
685	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzEwMTA3OTQsImlhdCI6MTYzMDkyNDM4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.DcpRTxSMsPzpR5qa3vC4mPn04QWirDsg4oeobBkbAw0	2021-09-06 10:33:16.447503
686	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzEwMTA4MTIsImlhdCI6MTYzMDkyNDQwNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.79DJwRs49gSsEOFcU-9GDvjCosb-sgdGV1rTknwLDuA	2021-09-06 10:33:40.298584
678	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQwMzksImlhdCI6MTYzMDkxNzYzNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TmWaq_33xYuhjV7zMIPIEBFywmgb-l3eQ5vF9h5kEsg	2021-09-06 08:41:28.693579
679	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQxMzAsImlhdCI6MTYzMDkxNzcyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Ss3Boh8HrADU4xsedP5-SG-y-4WqwOHJshNu-n70k3Q	2021-09-06 08:42:15.096004
682	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk2NDQyNDcsImlhdCI6MTYzMDkxNzg0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.BBoDNHacL9UEEexgKXSkaXpN03XOO5_KmlWbUC4GIuA	2021-09-06 08:44:31.706989
687	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjA3MDUsImlhdCI6MTYzMDkyODcwNSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.c02rOEH38S8FWFDzbc58NQ8dpIQRkd6O_pCoVYQQZxk	2021-09-06 11:59:10.570324
688	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjE1ODAsImlhdCI6MTYzMDkyOTU4MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.E6ym_eHGMNCzlCxTgGbkNbN1WVJIarLFFSJKyV_P_Fc	2021-09-06 12:00:10.323737
689	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzEwMDcyMDIsImlhdCI6MTYzMDkyMDc5Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hJziBe8GDAd1sSWlDkXI-7sDwh4e9F9pVN1gWxsYjCw	2021-09-06 12:03:22.434562
690	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjI0OTUsImlhdCI6MTYzMDkzMDQ5NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tFPKa8JhnBTxus4D7YgknRbVh4UMW6pq9vIb2vCmgl4	2021-09-06 12:16:18.606846
691	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjI1ODQsImlhdCI6MTYzMDkzMDU4NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.biSd8eMFJ4j_J_ue6VaPVUEuHrdCpa335bFR_edeAJ4	2021-09-06 12:19:14.152219
692	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjI3NjIsImlhdCI6MTYzMDkzMDc2Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4G8srvSw5t6KCn6V37f-yMX568oIGgVoDqf2OedJS-k	2021-09-06 12:22:45.551428
693	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjI5NzIsImlhdCI6MTYzMDkzMDk3Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.2xziGaOKr0fxWfO3X42PFys5CJYot-MzJW03m0PXekI	2021-09-06 12:26:01.382639
694	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjMxNjgsImlhdCI6MTYzMDkzMTE2OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ZnrGau8gczRDCVYB67w_Zv71VA3t10XHVODdM4H2VdI	2021-09-06 12:37:27.573197
695	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjM4NTQsImlhdCI6MTYzMDkzMTg1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.TxIxbBDHi40vmXVJBVu_W0PxcwiFprFg4-LC8AeI8yU	2021-09-06 12:39:56.825718
696	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1NzMzOTksImlhdCI6MTYzMDk4MTM5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UPgjuvSbGPNWFc72_OqTE0WjhrAh6oqGm_XbUS9INkA	2021-09-07 02:26:42.229415
697	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1MjQwMDEsImlhdCI6MTYzMDkzMjAwMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.HRo-Y7RhTDz_H-cMHXlKFs3ptEv9ky0N7JFVAVeGWpc	2021-09-07 05:26:03.838994
698	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1ODQzNjksImlhdCI6MTYzMDk5MjM2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vWwQ6o1hegwzXmzb1VaTaJZLj83xKPyexdqdUxlNOv0	2021-09-07 06:16:48.866179
699	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1ODc0MTUsImlhdCI6MTYzMDk5NTQxNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.pHkuKD5y_6BkOqHLKilDR5BqX_SgH56rGaipzBIiRbI	2021-09-07 09:17:21.092259
700	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1OTk1MjcsImlhdCI6MTYzMTAwNzUyNywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.DWfADcPFosiKG0voQJXT-bYRS4NN67qCuNe1tlx24co	2021-09-07 09:39:52.314272
701	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1NzM2MDgsImlhdCI6MTYzMDk4MTYwOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.l4qNhiWrknFqrmGpgZSXz9aTlky29Ws3cAL9kX0GNCw	2021-09-07 10:22:49.836071
702	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MDIxNzcsImlhdCI6MTYzMTAxMDE3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.gMlzbE03Q9UzyAeOr_Mlp58QSgQXUZSfB9Qu-dy8qEY	2021-09-07 10:27:23.376773
703	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1OTgyNDYsImlhdCI6MTYzMTAwNjI0Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MkzmrGOPKdlpWLBPbj3Ibt2HDAj7E14ivHOTm5lrr6M	2021-09-07 11:48:18.371492
704	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM1ODc3NDUsImlhdCI6MTYzMDk5NTc0NSwic3ViIjoxM30.bVbQVJhjsHGntyH1SCossrYE4_9nP0Wc84KNv_pivUQ	2021-09-07 13:21:23.032584
705	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MTI4ODcsImlhdCI6MTYzMTAyMDg4Nywic3ViIjoxM30.xrEEuVFg1jtTeW8zzSF9vIgm_usEzxvN_bstoS-XQhY	2021-09-07 13:21:38.170435
706	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MDczMDIsImlhdCI6MTYzMTAxNTMwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zzrVl8WOD4KhFymjT9QWr99kGutmg27vH5nVd_PKF_Q	2021-09-07 18:10:22.154228
707	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MzAyMjcsImlhdCI6MTYzMTAzODIyNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-lFUeR4WZ99em2QDZX8iLAbiNJB7HGaW-djSOpRL0fw	2021-09-07 18:17:55.296356
708	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MzA2ODAsImlhdCI6MTYzMTAzODY4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.NFSsKWqS60cQyrFbJh_35lgnRvtLKFYNldKPXOVCCOE	2021-09-08 09:05:16.501934
709	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2ODM5MjksImlhdCI6MTYzMTA5MTkyOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zm2OekOn1nmqKgChRXZjOs0mfeqQ00H9rWpNS3XSKpg	2021-09-08 09:09:21.196452
710	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2ODQxNjksImlhdCI6MTYzMTA5MjE2OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.sWUvD3_R8B9mXTs4FFE8DVrN1GUS92WthxkMLypvcZo	2021-09-08 09:23:43.659981
711	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2ODUwMzAsImlhdCI6MTYzMTA5MzAzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.QDulRPrfokSntbKxp9v9tyfMn3EIBRR6MPO-cRliLbw	2021-09-08 09:47:34.583901
712	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2NzczMjYsImlhdCI6MTYzMTA4NTMyNiwic3ViIjoyfQ.APZJAEeVCTMSN4cQi4xxxIKfNcOQdvVNDUrHK5fY8Pk	2021-09-08 10:02:35.374378
713	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2OTE2NDIsImlhdCI6MTYzMTA5OTY0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KHXohmqYWaIJ68bpwKPz1gXbVjTbNzLoHQ-bAP2OY3M	2021-09-08 11:14:52.309821
714	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2OTE2OTYsImlhdCI6MTYzMTA5OTY5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.1CXaLyyRJw-ILAzBM66yXvzkYDVgD8IPKL60zJk_Utc	2021-09-08 12:46:25.714188
715	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2OTcxOTksImlhdCI6MTYzMTEwNTE5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9_uyJUsSZj-TpWnC7fSC9NmTGVVKyr1bc_11nHBCWvc	2021-09-08 13:01:51.260428
716	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2OTgxMTYsImlhdCI6MTYzMTEwNjExNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.vrin2aUP7jQuXBNUvP7-oXO7vmx7q2Ydm4VqMnqv8_s	2021-09-08 13:02:25.23728
717	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2OTgxNTQsImlhdCI6MTYzMTEwNjE1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ryi_T408AuRIAv7ASawqdbKTq_Y2Wy6c6JFI0BzPJ4k	2021-09-08 13:08:04.394779
718	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3MTMzOTYsImlhdCI6MTYzMTEyMTM5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Q8iukA25ajybvquIiZiwqEoQF7aRWUUKwblZeUxkYX8	2021-09-08 17:19:50.830555
719	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzk1ODg3NjQsImlhdCI6MTYzMDg2MjM1OSwic3ViIjoxOX0.VEowNEywdGG6B5vr7mopj8dADUqnI7PUgSJznla4NV0	2021-09-09 06:35:49.94054
720	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3NjEzOTksImlhdCI6MTYzMTE2OTM5OSwic3ViIjoxOX0.OQDBnzd2-b3aWRahb5e0t9iqUBWHYJupCfzTQfT4BiA	2021-09-09 06:40:52.304586
721	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3NjE4ODgsImlhdCI6MTYzMTE2OTg4OCwic3ViIjo3fQ.0rL1UiEFhYFANhr0wMDcM2hoph_wyuBYQBbj8RWcego	2021-09-09 06:45:00.771959
722	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3NjE3ODAsImlhdCI6MTYzMTE2OTc4MCwic3ViIjo3fQ.fdcLZjuMzKCPfrHCiVppjiXx4NXn4gJteTFzzyNpGjY	2021-09-09 07:00:20.107038
723	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3NjE2NjIsImlhdCI6MTYzMTE2OTY2Miwic3ViIjo2fQ.uKektFZL8mrh0Acn6uaCgbHYrdAy6s-NmJcKtm1s_OI	2021-09-09 08:31:37.823038
724	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2MTI5MzEsImlhdCI6MTYzMTAyMDkzMSwic3ViIjoxM30.Me36K_kNrvbuuk3avgvPntlrbynsPrlsytPHzRI3jq8	2021-09-09 12:25:58.956591
725	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3OTc0NDEsImlhdCI6MTYzMTIwNTQ0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Pj2saSvuVQc8LsgSWLVYufXySlEwyKvyiQqHDLe_eYw	2021-09-09 16:46:30.170775
726	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM2ODgzOTAsImlhdCI6MTYzMTA5NjM5MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RzG3oiTAG5mG_cw11zUKpd8CytDMVXOf2sAkInTqxvg	2021-09-09 16:48:38.147696
727	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3OTc5OTksImlhdCI6MTYzMTIwNTk5OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KRo4hn2_yW_N_DUeyXw7pSWUq5HcAO8hnHHGkyftRyQ	2021-09-09 17:09:08.05821
728	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3OTkzNTIsImlhdCI6MTYzMTIwNzM1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.WhVW_XN3wb-gYt7maYoSrpjvkbLFTWK_ZuIdnpHEfaE	2021-09-09 17:11:07.947546
729	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM4MDA3NDIsImlhdCI6MTYzMTIwODc0Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RwnTxoHgOE4u8MS_KnKm4EDc7weBO998jTqSOQU-eQk	2021-09-09 18:17:36.614534
730	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM4MzU1NzgsImlhdCI6MTYzMTI0MzU3OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.xnFnWdrERNv5Ae5-HaEhlns14BGuKW1fmoGmWDhisQk	2021-09-10 06:50:26.657514
731	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM4NDg2MzIsImlhdCI6MTYzMTI1NjYzMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mRPTK6yaGlTr0RpMK8vWWdjH6sSE643a739nKq1jsZ0	2021-09-10 06:53:47.597261
732	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQwMDI1NDcsImlhdCI6MTYzMTQxMDU0Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._wOVySJ3_Qiueti_QKDh8GjD3Ws1ctpjGO40c5H4paA	2021-09-12 01:37:42.43836
733	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM5MzQ5NDEsImlhdCI6MTYzMTM0Mjk0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.WVb3Wt59tC_L63U95e8wdjy1o0kUAsWGSUjtAgL83GA	2021-09-13 06:01:01.582798
734	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMDg4ODgsImlhdCI6MTYzMTUxNjg4OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7s-4qMYNnpWsioE8T5rvXVuxMG5PEFWoTFvi3su8ANg	2021-09-13 07:12:39.710037
735	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3ODMyMzIsImlhdCI6MTYzMTE5MTIzMiwic3ViIjoxNH0.2VgR67km5RBxMBwXlADRPrMUPnA6hQMSQBo4VtGVuIg	2021-09-13 07:13:12.662418
736	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMDkxNzAsImlhdCI6MTYzMTUxNzE3MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.9u9_7JGKDvzBnk04O79ZS8Mw_HeDhoIoEqxlGKJiNfs	2021-09-13 07:15:06.290038
737	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMDkzMTQsImlhdCI6MTYzMTUxNzMxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.WjBE2F-zSUK03DW4ST_gikjGTicHz9cQaAe5XgE8VXA	2021-09-13 14:11:56.57338
738	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMzQzMjMsImlhdCI6MTYzMTU0MjMyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.eQfIblQwpyXxryR2TnFeMraBjTs0lqsqe88ZvZP0rJQ	2021-09-13 14:15:31.912634
739	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxNDAxNDEsImlhdCI6MTYzMTU0ODE0MSwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.EFq0xQb4lKRcR1us1ILXK6HJysXdjR3PpQSn0dvLEwg	2021-09-13 15:49:07.546488
740	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxNDAyNDIsImlhdCI6MTYzMTU0ODI0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.q6gtlYsnTE_YBxXd_w2czM-FnhGbEU97jimwh3Ydnsc	2021-09-13 15:51:34.718004
741	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzkxNjM2MDQsImlhdCI6MTYzMDQzNzE5OSwic3ViIjo5fQ.6JMPKb6kuTxH-VreEVIFc1cK49OLiqxVpVQXM3VtAJg	2021-09-13 15:58:28.629248
742	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMDU3MzcsImlhdCI6MTYzMTUxMzczNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hGaon1nWbSJgu6xBl4-SPdpMsvRl9xEe7exTKNmjJEM	2021-09-13 16:10:44.605339
743	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxODc3ODQsImlhdCI6MTYzMTU5NTc4NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.oLE9kEeQg-y-E2cv8rKSL2CJYgfte7Yi4L_zQ6yA6mI	2021-09-14 05:08:36.746268
744	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxODgxMjIsImlhdCI6MTYzMTU5NjEyMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4mCST1baMhv-q61PaQhNBeZiMJrYbDO6e28svrtrVOU	2021-09-14 05:09:09.097134
745	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxODgxNTQsImlhdCI6MTYzMTU5NjE1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.sEp9FNAx9M-WiVbznbkQPYyn5cC1aXlgaRWrY00FGdY	2021-09-14 05:24:22.549684
746	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxODkwNjksImlhdCI6MTYzMTU5NzA2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.eyds67fBIgjgCv_3PFVffqndnUzl30oQSalFXOP7tCI	2021-09-14 05:29:43.085239
747	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxOTE3MTQsImlhdCI6MTYzMTU5OTcxNCwic3ViIjo3fQ.YLKfj2LcrkYbGAofmQmzxXmiLFjS10d2Dp9VSgDAxJg	2021-09-14 06:08:37.413511
748	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxOTExNjEsImlhdCI6MTYzMTU5OTE2MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Ibrydj3_YnQDcqcl7Zf-SbJDfO762M2qfTe3NGtw6YI	2021-09-14 08:22:02.001617
749	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxOTk3MjcsImlhdCI6MTYzMTYwNzcyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.84j6gIykRvJDw4UkCBV3M32jbdvIu8jXHB-Y3P4B7pw	2021-09-14 08:23:06.477057
750	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxOTk3OTEsImlhdCI6MTYzMTYwNzc5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.T-9EL0Min6glx--rs6WLkYRqCYONET_BzuPVlPxk4KY	2021-09-14 09:13:37.88513
751	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDI4MjMsImlhdCI6MTYzMTYxMDgyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.3alenIpBohp26otvyzu1zrl4hV-m5vRbfDJ4sFW1_h8	2021-09-14 09:19:09.760457
752	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDMxNTUsImlhdCI6MTYzMTYxMTE1NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.GJkeeZYKwIu0kNeNBt94327Kc4dkpUJgz95tUJk5CGk	2021-09-14 09:19:52.926106
753	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDMxOTcsImlhdCI6MTYzMTYxMTE5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zepJ_0jsWPapF9XsvALnLDabxGKy6gMRGV7wRO-OgKA	2021-09-14 09:20:52.007126
754	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDMyNTYsImlhdCI6MTYzMTYxMTI1Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Cf2jPi9p1jWOdwSBWX31dMw1EQerncElRkgEzJMHygI	2021-09-14 09:21:39.09714
755	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDMzMDMsImlhdCI6MTYzMTYxMTMwMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AvgZkY3dnBvqCu12ctm_xwLQAP1kQZne4qKJtOQyjCo	2021-09-14 09:35:29.139163
756	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDQxMzUsImlhdCI6MTYzMTYxMjEzNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.yTJQVmSiT4ZG5ni7lntd8rQfonkPrW7A3wwtxxQq7jQ	2021-09-14 09:47:46.660491
757	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDQ4NzQsImlhdCI6MTYzMTYxMjg3NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Nuqsc3x2_0rurV6Li2jLal7-jA3NQqxo9HEsU7qyizU	2021-09-14 10:40:08.243377
758	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDg0NjIsImlhdCI6MTYzMTYxNjQ2Miwic3ViIjo3fQ.zU1sAZxPQJGJrmYFgVUvMNKRraigUN7ZlDxHT6cv-FE	2021-09-14 10:47:46.095474
759	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDE2NDAsImlhdCI6MTYzMTYwOTY0MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.1TlU1F8rIXviadUpuY8pETxzi0bLbBJ5lhBbgDhU3wk	2021-09-14 10:55:16.663795
760	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDgwMTQsImlhdCI6MTYzMTYxNjAxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.h7uodp9r7w9i1P25KlfwWXfEybM3dfPoHWse4aHWe7c	2021-09-14 11:04:48.509927
761	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDg5MjUsImlhdCI6MTYzMTYxNjkyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.EXMaHHBIFuTzFzVaT9ExVcn1wPAckmM-J1v-B-ZUAaU	2021-09-14 11:15:55.873311
762	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMDk0OTMsImlhdCI6MTYzMTYxNzQ5Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8z8pMqTnUTpqgSoJoBPmcBMLyHe1y6Nhfs6Rx0MH-qQ	2021-09-14 13:49:49.515826
763	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMTk5MjcsImlhdCI6MTYzMTYyNzkyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RvrgXDuG2HIOn6d5fKSseadCUKLv5tSh1_4Y6cbJG5c	2021-09-14 15:19:27.11678
764	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMjQ3NzIsImlhdCI6MTYzMTYzMjc3Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.uwnAAppWM9ntLrHVnAG0j5GEx-eGilCJqpdhBuSYcKk	2021-09-14 19:18:42.136988
765	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyNDE0ODAsImlhdCI6MTYzMTY0OTQ4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5rSzvGw685ygqX-9uV_6fUbJvj_9PTd2r-99apj-3p0	2021-09-14 20:01:06.575727
766	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMzkxMzIsImlhdCI6MTYzMTY0NzEzMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.so9c3sOAMLDJAyD98uU-yuJFn4nvpNgCf2znGWta_wo	2021-09-14 20:01:28.523191
767	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyNDE3MTYsImlhdCI6MTYzMTY0OTcxNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XO2_9XszaNobnQuBKpQnCK_FYaYlxcpEcxZQxxyPSJE	2021-09-14 20:02:33.601838
768	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyMTkzOTUsImlhdCI6MTYzMTYyNzM5NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XGJsXVn-Nz115hA98kelnOLYduFGTRk5ksRWtltnpgQ	2021-09-15 05:15:06.418466
769	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyNzcyNTIsImlhdCI6MTYzMTY4NTI1Miwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.tMcym-r5l703xDRqB16RDGxy9zSlF60LgAB7rb6C_qQ	2021-09-15 05:55:25.57622
770	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyNzU4MTgsImlhdCI6MTYzMTY4MzgxOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.F5VbcVM1UwMz6AZpRLRaaLZXDu1b752jmaqv6X8wons	2021-09-15 07:28:25.017434
771	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyNzczODIsImlhdCI6MTYzMTY4NTM4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xO17lnlHZayFHfOS3mwFt_qrYXSc72tB2aHoEmpC41M	2021-09-15 08:04:34.55903
772	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODUwOTksImlhdCI6MTYzMTY5MzA5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9VyuMMGrw4d1jK642P9J9PSs_Rn12_zT_byQ4MU37k0	2021-09-15 08:08:37.304746
773	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODUwOTAsImlhdCI6MTYzMTY5MzA5MCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.hi85uynyaE8_gMPjwWW72KfE7cg6nckRQoL6qr5NmO8	2021-09-15 08:08:41.71362
774	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODUzMzEsImlhdCI6MTYzMTY5MzMzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CXD8dvaTAM97O4_Exc_pDIIwGADqu_GSPotYq10XWhc	2021-09-15 08:09:12.574553
775	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODUzNTcsImlhdCI6MTYzMTY5MzM1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vHr_4GxeTrBM3ShtSteOLq1IymKPTuhHzZpMi0siUew	2021-09-15 08:09:47.082094
776	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODI5MTcsImlhdCI6MTYzMTY5MDkxNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YVMNWvmJj3dBYuUCA511Ndq-0HqAg8vow1FHzX1lDYg	2021-09-15 09:05:13.541333
777	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODk1MjIsImlhdCI6MTYzMTY5NzUyMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.WVwG2ybuEuaF1y-gqFTeG5wjKF5_4sd5d15GKR4dwMs	2021-09-15 09:25:04.837356
778	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODk5MTUsImlhdCI6MTYzMTY5NzkxNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-nW0dHhsZBoNfrYY2OU0CS0m1CDfGcVFDEHLSXiCZ34	2021-09-15 09:29:13.916986
779	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTAxODMsImlhdCI6MTYzMTY5ODE4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.T6ZzRTLb3iXmhDZasjw79VW_HLkWbiJSgzkvdZqQf_U	2021-09-15 09:32:13.857564
780	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTAzNTcsImlhdCI6MTYzMTY5ODM1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.qW4f-J8eNy939ikeMiO-dRzVN4P5Y9Uqu4vRYro9HJ0	2021-09-15 09:41:38.148102
781	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTA5MTAsImlhdCI6MTYzMTY5ODkxMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FfPWwpk4BtBJFPPS0WJi71M6lbCDcsjEKEXFpt9V6Yo	2021-09-15 09:43:25.128108
782	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTEwMTIsImlhdCI6MTYzMTY5OTAxMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.rwKoA2Zfh99GuBl1YoVxhGhafQGC2fbpLRoJKqLGtfc	2021-09-15 09:49:11.5268
783	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTEzNjEsImlhdCI6MTYzMTY5OTM2MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.q5ILSM558qgaUUIJLloAwTPeusTUkuHoMccZfMg3ZQ0	2021-09-15 10:15:36.46555
784	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTMzODIsImlhdCI6MTYzMTcwMTM4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ER4j-cFzHuQZ7KZKSUKFIk1CcAADEZ5g5Xd-rAJeLKw	2021-09-15 10:33:11.438814
785	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTM5OTYsImlhdCI6MTYzMTcwMTk5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.CKSAr8ImdajnxOf1KO-7x_TOCDKkknvKvk74BPI0Utw	2021-09-15 10:41:44.994157
786	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTI5NTEsImlhdCI6MTYzMTcwMDk1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.HvYNAvdSah9WIpsaM4Esx09V40hxmNRXwUhaY6Xjg38	2021-09-15 10:55:36.667719
787	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTU4MTAsImlhdCI6MTYzMTcwMzgxMCwic3ViIjo3fQ.fXqzSx7SoxuEuVVLTBbJygGUdrY-6dEwo3qEvcdA3HQ	2021-09-15 11:03:41.166501
788	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTU4MzEsImlhdCI6MTYzMTcwMzgzMSwic3ViIjo3fQ.VP-vfYPYLJi1J-Ylf5G1PFoQ6ceLvDmvQ2XaXbdFAXI	2021-09-15 11:12:24.896664
789	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTYzNTEsImlhdCI6MTYzMTcwNDM1MSwic3ViIjo3fQ.FRfynWgl_rK5XXLFXXbsAo766YmTlccb6hReVv6GeG0	2021-09-15 11:12:34.881357
790	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyODY2MTYsImlhdCI6MTYzMTY5NDYxNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MUG5VSWmf7xpviiOHvFaWcHHDR9le9uM-4dCTavuyfw	2021-09-15 11:38:17.499416
791	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzMDQ4MDcsImlhdCI6MTYzMTcxMjgwNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CzIfvquSxlW3VIDsDS8nh9-77HEeptAvzT70WIBfe78	2021-09-15 13:37:29.418041
792	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTc5MjMsImlhdCI6MTYzMTcwNTkyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AFHPKKVovUuSxj5XDqijbNJB8PBJ6ZbT4XUQK_HHkdU	2021-09-16 04:36:49.44147
793	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNTkwMTMsImlhdCI6MTYzMTc2NzAxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.lhierAHQVyfmXuzGDiB71918F26oUQ_aU1z0fiDWG4I	2021-09-16 04:48:57.885314
794	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQyOTUzNDMsImlhdCI6MTYzMTcwMzM0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.a6CtkNmkeewiaDQT9LX9ra5BTkBOeK1JJcW2L9XQJQk	2021-09-16 04:51:53.380208
795	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNTk5MjMsImlhdCI6MTYzMTc2NzkyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.6IixLxO2hTGiCXdF80leCt852XyTKQigA9VzxDuIXV8	2021-09-16 04:55:26.811116
796	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNTk3NDIsImlhdCI6MTYzMTc2Nzc0Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Ar22UncsQ35_HkLb2CoQjoY1Y44hTB_RyC6WVyX_YVY	2021-09-16 05:10:09.433282
797	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjEwMTQsImlhdCI6MTYzMTc2OTAxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.HEQRmmZM-g9hJFWl0QnhPtgyUrKVmq_fmtmXxA_TzFg	2021-09-16 05:53:27.731602
798	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjM2MTMsImlhdCI6MTYzMTc3MTYxMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.r5tuJLeXxPPdxKxVQX37hyBZMFGjArsHchvby_aTEA8	2021-09-16 05:59:03.767571
799	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjM5NTEsImlhdCI6MTYzMTc3MTk1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.z81UyvcFP4lCRXquYaN9cQbAYuKEiVYrLk6En0AMTiI	2021-09-16 06:05:47.695004
800	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjQzNTIsImlhdCI6MTYzMTc3MjM1Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8CjkN9SUiLrTrUYcShHQZItis6WgYOg8Hx22yMZXob0	2021-09-16 06:43:19.991295
801	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjY2MDQsImlhdCI6MTYzMTc3NDYwNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hko2_AtTW8CxbMqnxwOp-ANRd9AJS1OGN4G4bdjwm5U	2021-09-16 06:53:27.475494
802	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjcyMTIsImlhdCI6MTYzMTc3NTIxMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.13425TNQqr2nH8oiHF627r4lhvLn14bOXfYrcytMKdM	2021-09-16 07:21:51.144818
803	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjg5MTYsImlhdCI6MTYzMTc3NjkxNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RuJgD3769Gsem1CpvO05xqBiHUtGV0cUXleAPItNSlM	2021-09-16 07:25:38.449873
804	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjQ5MzIsImlhdCI6MTYzMTc3MjkzMiwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.G9JIrfeRYV82Vy_5UsnAjjSZoMUs1SNSgpnnaWz63As	2021-09-16 07:50:24.421036
805	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjkxNDUsImlhdCI6MTYzMTc3NzE0NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hUvBE-fkON5CeGPL0flNXrNu26aAg29zV3-QKuapF7U	2021-09-16 09:12:57.828939
806	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzU1ODIsImlhdCI6MTYzMTc4MzU4Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.b-aybuRVzyAxwDEhv7RombAaGaX-Fyn96Xq-1vBRroE	2021-09-16 09:30:13.566849
808	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzc0NDUsImlhdCI6MTYzMTc4NTQ0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.OSZB9nVOWq4PL-Z4xNoIZGmwIgaUJBuC-dDVFKNKoCw	2021-09-16 09:47:28.741584
807	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzY2MTgsImlhdCI6MTYzMTc4NDYxOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.XAQKTenTHHd26_szZCBo07xZm00TJ8j25LW8gjhQnXw	2021-09-16 09:40:51.749258
809	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzc2NTMsImlhdCI6MTYzMTc4NTY1Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.fLp2iV9X24k0laD5DFoaCszQEa5rKIkhLTEPWYTLrlQ	2021-09-16 09:47:45.153605
810	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzc2NzEsImlhdCI6MTYzMTc4NTY3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AMD7fVCJ_xAwy59fBow3MZgC7Dfw4kwEO5eBqHLDcbA	2021-09-16 10:23:53.773505
811	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNjAxMzMsImlhdCI6MTYzMTc2ODEzMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.w5N1CRBOsE1ZPDuX_yGfUOfqGFL_FgagF1yaa5E_E0Y	2021-09-16 11:10:47.075217
812	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODI2NTMsImlhdCI6MTYzMTc5MDY1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Pz07PPsD3Y7eQtwm2jTo30rx5zIRLiceoF5fb6_NjC0	2021-09-16 11:11:59.40495
813	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzNzk4NDEsImlhdCI6MTYzMTc4Nzg0MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.F8dnkRPWWd2nS6eZT53E9fr7bSrYDWXZB1GSo4LfXZ0	2021-09-16 11:16:16.582284
814	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODI5ODMsImlhdCI6MTYzMTc5MDk4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.umG17slcs4fzbk1VCnIrKV3hlGx06ehxqMeqp43BWKI	2021-09-16 12:02:31.228231
815	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODI3MjcsImlhdCI6MTYzMTc5MDcyNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.f0Rfw3N8spzeaAKOhndgPz0ZPebV9BHbsZ8iHlJMh4I	2021-09-16 12:24:05.472837
816	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODc0ODcsImlhdCI6MTYzMTc5NTQ4Nywic3ViIjoxM30.11RjfhOu0LcMI6WC3ubmjyojMiExcGhDrwzviiHhx9E	2021-09-16 12:35:42.167242
817	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDgxMzQsImlhdCI6MTYzMTgxNjEzNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.2jCqgQvb5IbbwMIQ0tQonhN5-2buMQRxn_UW2Ti200Y	2021-09-16 18:17:16.1312
818	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDgwNTYsImlhdCI6MTYzMTgxNjA1Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Nv8WVOwWgQnEePiiE5ZICwPNVHo0GJS4ULWsAUUMtFc	2021-09-16 18:17:58.934628
819	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDg0NjcsImlhdCI6MTYzMTgxNjQ2Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hmHAmOc1TGohXEiUDSq-WztjG2gLU5XvT_RCU7je3Rw	2021-09-16 18:21:50.168945
820	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDg1NDMsImlhdCI6MTYzMTgxNjU0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.HJZr14Uwg8bSVEx3_qInnbBD4EvfzU9Zkj3IcId7Kcc	2021-09-16 18:24:59.723669
821	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDkwNTMsImlhdCI6MTYzMTgxNzA1Mywic3ViIjoxOSwicm9sZSI6Im1lcmNoYW50In0.b2BqFeIyITopcKxbK7gNoWdne238uRHgrxQbHh2QyvE	2021-09-16 18:31:09.885483
822	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDg3ODAsImlhdCI6MTYzMTgxNjc4MCwic3ViIjoxOSwicm9sZSI6Im1lcmNoYW50In0.rRHJOn4NWHAfM1TDg4PWS0FFN6r_pJ18azB-YrQBjnM	2021-09-16 18:34:21.44353
823	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODcwNTcsImlhdCI6MTYzMTc5NTA1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.eE7nmnX0kwqU4TTzallpIR50ExLe_ulmBqsRF4n0XoA	2021-09-17 00:36:47.749483
824	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MzEwMTQsImlhdCI6MTYzMTgzOTAxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.GRxhVYzitktBgvKvAxVduP-dMcl0H95LoyL4ICPpqCY	2021-09-17 01:31:36.465446
825	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MzQzMDIsImlhdCI6MTYzMTg0MjMwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jrtedHCj1CvvfEVmtLhqc0UNGXCeReav92zRsKtJGb4	2021-09-17 01:44:15.100898
826	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQzODU3NTcsImlhdCI6MTYzMTc5Mzc1Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.jAYC1ANBdIcjobvZSzb3q3BkiTQCfCxkSanI20SmkyE	2021-09-17 05:43:03.467491
827	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NDkzODcsImlhdCI6MTYzMTg1NzM4Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.DrOOm7YCdLKCHkaQtTDVmfrDDId7-1ikpLUr01mq3VY	2021-09-17 06:34:00.085551
828	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTI0NDQsImlhdCI6MTYzMTg2MDQ0NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Jomymxg2hFrlEHaPDjGZZ0dOcG-axGAQMENdgfzBwCM	2021-09-17 06:35:28.827564
829	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTI1MzQsImlhdCI6MTYzMTg2MDUzNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.PkHYdL1hZkubzn9zst7kg8W2_tF4P8GNrgZDu_tOYeQ	2021-09-17 06:37:31.307241
830	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTI2NTgsImlhdCI6MTYzMTg2MDY1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cVrGD4pu02mZ8ZAh-Li4z9eRbBBkeBrKqCGHYY4tTJs	2021-09-17 06:51:50.256292
831	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTM1MTQsImlhdCI6MTYzMTg2MTUxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xn_gSzphlf1qVYON3R_WzXsZwQFOqjumnrfrCCKfQ4Q	2021-09-17 06:54:43.150255
832	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTM2ODgsImlhdCI6MTYzMTg2MTY4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Nl0FHa2CyQPbdVU-LJiiUCl73gGCDTmr0Sf7GQdtsj4	2021-09-17 06:55:07.381815
833	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MzUwNjcsImlhdCI6MTYzMTg0MzA2Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Sac-S9Zh5H4ywNrPXknYMpfCM9rDbHWqoQAN1yqTlcE	2021-09-17 07:07:18.016702
834	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTM3MTIsImlhdCI6MTYzMTg2MTcxMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.lItCjeTGburWJcKDCvFXVhvriytU0418X7qC9-JaUqM	2021-09-17 08:05:06.381996
835	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTc5MTMsImlhdCI6MTYzMTg2NTkxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LuSVOUk4DGMlVG9M_RP4XmkjnvCRWsRIiYVxM6a-Cls	2021-09-17 11:21:27.536375
836	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0Njk2OTMsImlhdCI6MTYzMTg3NzY5Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ZJy7ZROA36Ay1c9wdI5U6nc1qixMdmoDVoGJ_IR0FT8	2021-09-17 11:33:12.634038
837	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NTQ0NDQsImlhdCI6MTYzMTg2MjQ0NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SveNdQ_V8KInJql3qLTWJSKlrDZbvBr1fkuxvkEM7tI	2021-09-17 12:42:27.760777
838	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzAzOTgsImlhdCI6MTYzMTg3ODM5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LbGD3m1BIxBG6OrdTVXuiSjp6Y42nyw-7G10RWc-8pY	2021-09-17 12:45:58.426912
839	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzQ3NjQsImlhdCI6MTYzMTg4Mjc2NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KS6C1Wd55YZzvmA42rbAAn-CvCiLh8OwVDNbrPDZmPI	2021-09-17 12:46:58.591939
840	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzQ4MjQsImlhdCI6MTYzMTg4MjgyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9yTN2Axe939KlBiDuO92hiMqhNKiEj2tR63IHmi5nkc	2021-09-17 12:48:20.940352
841	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzQ5MDYsImlhdCI6MTYzMTg4MjkwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Y8GJYAPmyAtWw6sPlikofSAer-Z8SibV_JIpsqm0PAw	2021-09-17 12:49:09.672474
842	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzQ1NTUsImlhdCI6MTYzMTg4MjU1NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ._wVnBO8RFbOtsfGudx6CNQYILbE46AC9hh_p-5EuT00	2021-09-17 12:56:23.380567
843	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzUzODksImlhdCI6MTYzMTg4MzM4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VoBsAaJJZdU1cHHOASCHA7XLFZo9hw50TKMrjempxEA	2021-09-17 12:56:49.610227
844	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzU0MjMsImlhdCI6MTYzMTg4MzQyMywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3jR5ObY6yREPBz5uKrDtsIpjsUqP0lLigjKv7avH7xQ	2021-09-17 13:01:51.812151
845	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzU3MjIsImlhdCI6MTYzMTg4MzcyMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sTnFmPQYjKvd7QN0gTAUiJzzrERmkNwX_YtgcHH8gIY	2021-09-17 13:03:10.752385
846	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzU3OTksImlhdCI6MTYzMTg4Mzc5OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-0Do1jCSYNFvEqpay-LYCChhV5uV-wCWvdpmyeUu-no	2021-09-17 13:36:22.443157
847	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0Nzc3ODksImlhdCI6MTYzMTg4NTc4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8wS29Y9x5lBon7c-XByA_yxwQ1rCs08Je4K1EhWwrPU	2021-09-17 13:58:24.142809
848	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzkxMTQsImlhdCI6MTYzMTg4NzExNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.9_jlc611jNGCeD_rY5mzNkODbTAg246NiVRmdH6_VkE	2021-09-17 13:59:16.479945
849	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzkxNjMsImlhdCI6MTYzMTg4NzE2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.caBZH5b8mbeZR9_3gZUfQnfW939lCKuFFb4qWlwC4PU	2021-09-17 13:59:43.92007
850	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzkxOTAsImlhdCI6MTYzMTg4NzE5MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.pE46fig2Bmpg-Z6Lzj62cK-lfM_6wOkUDdK3ULdLSZI	2021-09-17 14:02:29.985045
851	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzkzNTYsImlhdCI6MTYzMTg4NzM1Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.38fyVo9DjER0xmFodt-DaQwYorg2obgLiSSWRLIgBMM	2021-09-17 14:03:05.590492
852	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0Nzk0MDIsImlhdCI6MTYzMTg4NzQwMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8eXhEUviA596YUQhGnz56Xyw_qcqC0GZGqDlpzIa_rU	2021-09-17 14:04:51.81792
853	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0NzQ5NTQsImlhdCI6MTYzMTg4Mjk1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7pUBSPza4qNexRJO45Y1nFV54xt8D-Nm_c-8X-VKito	2021-09-20 05:02:01.112824
854	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MDYxMzcsImlhdCI6MTYzMjExNDEzNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Qi1GtpdNHkG-WZAvYVhXRoHX8_xAcDvb5wQCGkDaho4	2021-09-20 05:15:29.497666
855	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MDY5MzQsImlhdCI6MTYzMjExNDkzNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.jQy37Piegm_Lt63QoKBBdNUaKbD-z6sS-BfeV-9GHwk	2021-09-20 08:57:49.281941
856	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MjAyNzQsImlhdCI6MTYzMjEyODI3NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GPIfffyQzWmIlMJ92vMSQoxibYZinTicKQIWwbX3DDQ	2021-09-20 08:59:26.978118
857	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzM3NjgzMDksImlhdCI6MTYzMTE3NjMwOSwic3ViIjoxOX0.4D9-CcQevZ64LRG2Zk58RCoR5QTPaYJUAC518ItkGio	2021-09-20 10:15:00.01019
858	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MjAzNzksImlhdCI6MTYzMjEyODM3OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.1dUVBbokhdB2oxoBTCib8IZfBivcOG37toXmS49pEvI	2021-09-20 10:24:57.635047
859	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MjU1MDIsImlhdCI6MTYzMjEzMzUwMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1IRMgdQRT06lKvt_cmbz4T4pY477KRUXHQmkISU2yA4	2021-09-20 13:04:52.464311
860	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MzM4NjAsImlhdCI6MTYzMjE0MTg2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.EfWw6vbP7jqXbibXeFOAzyPxE8vTe8Tc_UvfJE8mTH0	2021-09-20 13:04:57.399915
861	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MzUxMDIsImlhdCI6MTYzMjE0MzEwMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cPnkMVNLhlb8OlBsalvjr-A58ZQ9p2ywG9Kd9uuNKiY	2021-09-20 13:05:25.700026
862	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MzUxMzMsImlhdCI6MTYzMjE0MzEzMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bdUejKnJgMwJXssP1DBiD11h_TFMULq2GBK5FFcUPxQ	2021-09-20 13:06:35.559908
863	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MzUxNTksImlhdCI6MTYzMjE0MzE1OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9lLwb19O_oDjMZ46flpdHjoxIHPvamKuBzIV9ag7oNI	2021-09-20 13:07:21.660667
864	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxNDA3MjIsImlhdCI6MTYzMTU0ODcyMiwic3ViIjo5fQ.DP9YkH7fHgk4Jzn9pPOd86QjPiGg6u5mpJDaWGEjzpQ	2021-09-20 15:50:16.527178
865	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MzUyNDYsImlhdCI6MTYzMjE0MzI0Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.6PRRAkU-2Q-P_mJdibl8pexCyU7J-FH3PcJw80EKRP4	2021-09-21 08:38:03.640396
866	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDc1ODYsImlhdCI6MTYzMjIxNTU4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.uMYtoUVMhcTIpjkBrIF0_7980CnCVwVAyLtU2SMCptw	2021-09-21 09:36:14.925395
867	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDg5ODEsImlhdCI6MTYzMjIxNjk4MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.pe7BJ5YBCWYzCBLP1lDlwCMZi96SHGy8tcGgG4DHuYo	2021-09-21 09:42:26.785567
868	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDkzNTMsImlhdCI6MTYzMjIxNzM1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.s4ax1F6ihP6Kh27tbZwkzyMBJM46kmJ2pkegc8L01RQ	2021-09-21 09:44:05.185662
869	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDk0NTMsImlhdCI6MTYzMjIxNzQ1Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.UhEwAd7agaVewrX07VAMhk7AF67QwmY1ocIA8FXdCNU	2021-09-21 10:05:38.926517
870	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MTA3NzYsImlhdCI6MTYzMjIxODc3Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MRrzT3xNRoRPUknmSkByTUx7lLR8J3weRiEyOxXROAA	2021-09-21 10:13:58.420121
871	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MDU0ODksImlhdCI6MTYzMjIxMzQ4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.rO0R5iOcbk_7wKbPoTZD8yzBriSW30jskrEzZCyifdQ	2021-09-21 11:43:00.694306
872	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjUxMTUsImlhdCI6MTYzMjIzMzExNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._oG7zfE05LrX1HCIC9qo1YmnOlnjRnFy2ycJM0JJVj0	2021-09-21 14:05:33.339015
873	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3MjQ5MDksImlhdCI6MTYzMjEzMjkwOSwic3ViIjo2fQ.RUgCBSgPYc0zKfNaCsSoKn-GxFOR0D4a2Cr6hLjL0W4	2021-09-21 14:08:29.89309
874	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjU4MDUsImlhdCI6MTYzMjIzMzgwNSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.izA4OYlhPPEfolBymQHB7d0zH2EAu8vVqoVRf34OnQs	2021-09-21 14:17:03.209628
875	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MTY1ODYsImlhdCI6MTYzMjIyNDU4Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.4cw0hgVxbTb0ZTEkQ4LQLDq9sdghm4XaWNiDvRsBeUs	2021-09-21 14:28:35.073446
876	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjY1MjAsImlhdCI6MTYzMjIzNDUyMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.v7wQq_HeXGTb-0MDBkWrH2VLlvv92B1-zdrAz63Jvbc	2021-09-21 14:29:31.248088
877	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjUxMzksImlhdCI6MTYzMjIzMzEzOSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.gnwNhSIXsSUUQvUqXqiRkO2hqBCGJWQb82-7Pqwsrh8	2021-09-21 14:30:45.044103
878	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjUzMTgsImlhdCI6MTYzMjIzMzMxOCwic3ViIjoxM30.xfHOYIgo4maarygUxla_oGZnZaa0TVUo-uiadJJUWFc	2021-09-21 14:31:21.188562
879	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjY2ODUsImlhdCI6MTYzMjIzNDY4NSwic3ViIjoxM30.2NlPFcQyWk5_fq74Xf24mCgADpuYN0MrAHrlGhU_HxA	2021-09-21 14:31:50.280698
880	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjY3NTgsImlhdCI6MTYzMjIzNDc1OCwic3ViIjoxM30.IrBLEaZocne-NeOHwUPxFFQRa5Dn2puMK3ZWFrsNY0Q	2021-09-21 14:43:44.094606
881	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4Mjc0NzcsImlhdCI6MTYzMjIzNTQ3Nywic3ViIjoxM30.s4FtlTzcKGo4UHS2AszQb7Ckq9y8BiPpfEn0H9E8ByQ	2021-09-21 14:50:36.899387
882	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MjY5MTUsImlhdCI6MTYzMjIzNDkxNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.6W8bs_J19GB7E8OVzaq6wjE5iFfd6RH_Y4N3waVyyN4	2021-09-21 14:54:42.054443
883	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4Mjg0MTMsImlhdCI6MTYzMjIzNjQxMywic3ViIjoxM30.Z2vQgQUVHj-ZIzM8XCS0xLw2qGxZ0awOnnU93Op8q8M	2021-09-21 15:00:22.015867
884	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4Mjc3MDMsImlhdCI6MTYzMjIzNTcwMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.FGNqwtesr423YJsN9lVLLQPHIcVnaEeu8OqYfP3OnOk	2021-09-21 17:08:46.750563
885	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4NjY5ODgsImlhdCI6MTYzMjI3NDk4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.aikmy5MdJcw-eEysXMxvF6Xznw8c4QVF2M6ZbR6RtKE	2021-09-22 01:47:52.421645
886	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4NjcyOTAsImlhdCI6MTYzMjI3NTI5MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7Gp91Whapvf0LdTrSIBlvBKBRyr4NS5pTmVpJVbR2NM	2021-09-22 01:48:27.459825
887	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4Nzg0NTgsImlhdCI6MTYzMjI4NjQ1OCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.NZIO3shuoaysnMmaHlOY-kTtX-NR27NVItFxluoMNVE	2021-09-22 05:27:15.047823
888	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODA0NDIsImlhdCI6MTYzMjI4ODQ0Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.szHO7Z7kURRJ3J45FXvv4OampzV2biGRDXa15rDL-7k	2021-09-22 05:28:07.938143
889	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4MzYxMzEsImlhdCI6MTYzMjI0NDEzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QmZsZK-DF4HY7bO9EryM9Ghi7ERpaEDgQMd_tu1GU10	2021-09-22 05:29:10.080267
890	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODA1NTQsImlhdCI6MTYzMjI4ODU1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.NvepeEhPSb_VgI802mUfaJCZ8t8pfDElH3FzMjPCpJk	2021-09-22 05:43:46.923594
891	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODE0MzYsImlhdCI6MTYzMjI4OTQzNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.DTfmN9Nw6ZzrLcrffW1VJXDr-CF00mVcoJhUKMgaMWU	2021-09-22 06:12:44.900963
892	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODMxNjksImlhdCI6MTYzMjI5MTE2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.k2mIC_Qf9swdh1Zil7veHmmsmE1RI8RhYrU1c2jr6NA	2021-09-22 06:15:39.26661
893	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODgzMDYsImlhdCI6MTYzMjI5NjMwNiwic3ViIjoxM30.VilTEiFkVyhJnB4u_-nl9yCSzu9gzyReN_PYXCUrDM8	2021-09-22 08:36:47.410561
894	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4OTE4NjAsImlhdCI6MTYzMjI5OTg2MCwic3ViIjoxM30.oLzMmww5G2vpYkw5wXMYMkp4Hepf5mi_nyBM-XjSCWE	2021-09-22 09:08:32.707075
895	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4ODMzNDUsImlhdCI6MTYzMjI5MTM0NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.rY4M_evzpZDxd9LXCSSckEi1Bn3ARVOP1CLevDn-JvM	2021-09-22 13:45:47.454247
896	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MDcyNDUsImlhdCI6MTYzMjMxNTI0NSwic3ViIjo3fQ.c_mxIHD0zly82CSPhBPEZFoMfO-WiEf-nzjZA0Bfwkc	2021-09-22 13:47:08.008888
897	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTA0NzQsImlhdCI6MTYzMjMxODQ3NCwic3ViIjo3fQ.Ws2NE7Lao-ubky_yagQJhfQ5lh0Khp_9B75hFA-_os8	2021-09-22 13:48:03.838689
898	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MDgxOTIsImlhdCI6MTYzMjMxNjE5Miwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.7oxlwgY_eTL1xNgnZFV_JxaUx9aCpmxq5NP2-uDE8QM	2021-09-22 15:12:20.590883
899	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ0MDkyNzUsImlhdCI6MTYzMTgxNzI3NSwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.HHnYs2gGwn2rLluDEvbMSNvfaJlUV-sdodupOLLZa9M	2021-09-22 15:40:58.99855
900	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTcyNzIsImlhdCI6MTYzMjMyNTI3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4Nk5IYC0vRWuArnV3RxXyK5lyC_5I33-QVQmQjCHobw	2021-09-22 16:01:22.482963
901	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5Mjg3MTQsImlhdCI6MTYzMjMzNjcxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CUMy3z6MPy6Lk04cGm3KOEzrUKLf4PuIlN8sLfutOps	2021-09-22 18:52:53.672422
902	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTg0OTIsImlhdCI6MTYzMjMyNjQ5Miwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.HzueeRgXpGtFuaooR0IcNsOuR4czBpK7HrYYGfo-SmY	2021-09-22 19:34:22.768134
903	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NDU3MzgsImlhdCI6MTYzMjM1MzczOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5tdHH41x-2-HkU_syAHPrIBtv3_qAd095uV-TSsTeD8	2021-09-22 23:36:23.91953
904	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTAzNTIsImlhdCI6MTYzMjMxODM1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.2IWXeeACHTyfGbRWU_Jjl6i417POgnDSRx3SDWyoIUY	2021-09-23 05:37:41.523536
905	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5Njc0NjcsImlhdCI6MTYzMjM3NTQ2Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.kGC381sPMRXd6f3JpPPH-sh5Sifxo4GnzrCtHvTcQ-0	2021-09-23 06:22:01.049858
906	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzAxMzAsImlhdCI6MTYzMjM3ODEzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qNsKDF9U8ijJr4R_pU0IYKRAAR1Vmx8himTPCTyQikc	2021-09-23 06:32:58.460991
907	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzA3ODIsImlhdCI6MTYzMjM3ODc4Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8mPX4nuafJj4j_tcXOBq5JTU8ObNOEMEGzTrTO4UmeM	2021-09-23 06:34:25.891385
908	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzA4NzIsImlhdCI6MTYzMjM3ODg3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XRZayXArjtXZz5u_4sHXmnTD1ZvMRqfTpC2IqAlMaTs	2021-09-23 06:45:06.874605
909	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4NjczMTgsImlhdCI6MTYzMjI3NTMxOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.OIk18vAE8pHUhfXwaoOTLdMT0ngs-PQX9GTiFGXOZ3M	2021-09-23 06:53:25.818336
910	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzE1MTIsImlhdCI6MTYzMjM3OTUxMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.qujEmHP-_owO7PZ4gAsB1xxMIJ9O3yFg44dMCclBSaU	2021-09-23 06:55:44.354594
911	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzIxNTAsImlhdCI6MTYzMjM4MDE1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5CdYdaWXu8AiCO0WLAiCfgqpmYoU0357MIUghm09csc	2021-09-23 07:08:08.259202
912	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTA0OTAsImlhdCI6MTYzMjMxODQ5MCwic3ViIjo3fQ.CiaBNtMw3zmQNyBL620_WQv6_J5SS0r9-_-WBAWwHL8	2021-09-23 07:14:20.414862
913	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5MTU1NTIsImlhdCI6MTYzMjMyMzU1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ZlFtFFhHLcNW4QhWyEsgqaxVWdX34L421Cj_viZgYJM	2021-09-23 07:14:45.065008
914	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzMyMTQsImlhdCI6MTYzMjM4MTIxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.j3xFHH-S6Inwzq_nuH2ZA3yOsaNIEjCozaXLWJ33VlI	2021-09-23 07:17:03.522727
915	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzM0MjcsImlhdCI6MTYzMjM4MTQyNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tE-g4zuUvwL_o-wjCGwHQtP2iQSF14yMN828lbEncRU	2021-09-23 07:18:40.044244
916	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzIwMTQsImlhdCI6MTYzMjM4MDAxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Rxr94Teol5y1iHi2NwZwyJ7WprPquajyX_1xjWMfe6s	2021-09-23 07:24:52.025341
917	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzM4ODksImlhdCI6MTYzMjM4MTg4OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ZHyEovlN5e0ijC9kTj6d8OHxZMZ_c8pxq_2mixbZTtE	2021-09-23 07:41:22.48625
918	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzQ4ODcsImlhdCI6MTYzMjM4Mjg4Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TMSvkHAjyVDNZjpvyOYSC_ha1FfMaYe-y36iFzy1Rv0	2021-09-23 07:42:12.155484
919	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzQ5MzgsImlhdCI6MTYzMjM4MjkzOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.U3O-AvPkMuef9ZJOQeV3IEz2OO0nVlt1kLCHetnsPiE	2021-09-23 07:44:28.194375
920	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzUwNzMsImlhdCI6MTYzMjM4MzA3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7xC45VvggPscKe51XN0UdG3w1QaEHG-Y0KoxidWDK_o	2021-09-23 07:47:00.695238
921	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzMyNjYsImlhdCI6MTYzMjM4MTI2Niwic3ViIjo3fQ.Mffm4UnyQy0zCGodZXIOSTww5O0MdqSdzYdTCSdAuuY	2021-09-23 08:43:48.420619
922	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzM4OTgsImlhdCI6MTYzMjM4MTg5OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.5_W9l34gtrB_Z5uDHLOx0uN3VyX_kktRZMqN5YBW60w	2021-09-23 09:34:05.825734
923	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5ODE2NTMsImlhdCI6MTYzMjM4OTY1Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Pfu9MrKZ3Opma4PH4V9RVJ81lWwz1NMcaR2PI61WbVg	2021-09-23 09:39:38.84576
924	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5ODIwNjQsImlhdCI6MTYzMjM5MDA2NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.vLdKuxtUv5VvlQvOeKvrLFy1Lq0nGoynpijnkzNjISo	2021-09-23 12:00:57.77401
925	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTA0NzIsImlhdCI6MTYzMjM5ODQ3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7gwWEocW7CKhJWqjUdxICduR2jNYE0JR9RsOzueCeJM	2021-09-23 12:30:35.402763
926	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5ODc1ODEsImlhdCI6MTYzMjM5NTU4MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.fHmwhwCUNUTydT2vFcrKW21pzhV_tDver6ArrexHCUw	2021-09-23 12:40:36.695212
927	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTM0ODMsImlhdCI6MTYzMjQwMTQ4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xoiUdOpDUj4Av57ZBdSTyYZnRvtmaxOiySRJ5h64QCI	2021-09-23 12:55:02.299814
928	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTI4NDUsImlhdCI6MTYzMjQwMDg0NSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.mL-gn6UJe4H_q_qWd1Iv2SKsnykVOnNiEMHvmZ-JDUE	2021-09-23 13:02:34.252469
929	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTI0MzAsImlhdCI6MTYzMjQwMDQzMCwic3ViIjo3fQ.x88PE-uBaP2GBncV9vsgGtnFC9eRNMqy-t_rQWwQW6E	2021-09-23 13:04:57.55365
930	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5Mjg3OTEsImlhdCI6MTYzMjMzNjc5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.WziR6j7ZW-EjkDOmgBMMZ76F_TngB7OYjcMdRA_jgNc	2021-09-23 13:05:56.000403
933	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTIyNDQsImlhdCI6MTYzMjQwMDI0NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ceWym6Uvt8NkaYXSBna4cu9kcxiuKR3HdUfjBygS_Q4	2021-09-23 13:08:05.822955
934	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTQ0OTIsImlhdCI6MTYzMjQwMjQ5Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Pv16cx8H4qeeoqFr_o6HTEeV-uqXVTGqNUpdjEMGg9E	2021-09-23 13:09:13.622038
935	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTQ1NTksImlhdCI6MTYzMjQwMjU1OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.GMlkZUxE_pTinPbXZfwpE_YlwmfX4VM9PrO4QkxhsH0	2021-09-23 13:16:55.802043
936	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTUwMjEsImlhdCI6MTYzMjQwMzAyMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.fgW66SSwRtWyog8XUWiuHNVFeUfos7BhNY3Hx6-t2o8	2021-09-23 13:23:20.954087
937	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTU0MDgsImlhdCI6MTYzMjQwMzQwOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.W7cmjiuWpX_hxBukO8aX_qrj3ShaUhhT4m5SsKtAkNU	2021-09-23 13:50:19.365545
938	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5NzUyMjUsImlhdCI6MTYzMjM4MzIyNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.jRkmtSyoEb1FPcOV6HKClt0L0i-nRzR5WKVrzA8YHqI	2021-09-23 14:02:08.508037
939	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTg0MzcsImlhdCI6MTYzMjQwNjQzNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.-_UP8JOaGjOeLK1MFdzj6LtPJauH88HsruYqX-5nPR0	2021-09-23 14:18:39.793287
940	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTQ2NzEsImlhdCI6MTYzMjQwMjY3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.rdujDW1eec2ch11N2WtAIlfHrrz42Qn2Zchz-faUxxQ	2021-09-23 15:08:10.569116
942	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTc3MzgsImlhdCI6MTYzMjQwNTczOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.h9VK-ummwPPwLSo0k7FW4G-K-0iV_U5GlEakQUrsFlo	2021-09-23 15:11:26.74832
943	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQxMDkyMDAsImlhdCI6MTYzMTUxNzIwMCwic3ViIjoxM30.Td8sujLGHOTIq_wzvg1tXw0edeHfM7MlMo_NYhpRGxI	2021-09-23 17:12:03.001586
944	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMTA3NDgsImlhdCI6MTYzMjQxODc0OCwic3ViIjoxM30.GPk_iLicflvbLc0io2j9FrbTyI1UZdhN724bOxu5Qws	2021-09-23 17:39:17.169822
945	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMTg3NTQsImlhdCI6MTYzMjQyNjc1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7IYHjvybrn3fLpS_J6rLwoIR8cgZmha2hUqaolVa5GE	2021-09-23 19:53:09.855516
946	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMTk4MzUsImlhdCI6MTYzMjQyNzgzNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.RbmYI-bx5Z-KqVQZV3F1tsC29fHkwpt2qxAI1BN7I1A	2021-09-23 20:17:30.388402
947	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMjAyNjAsImlhdCI6MTYzMjQyODI2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hU8gfMk1TrK24--9Z2EWhVb1oLl3HeSbrZPa2Eiy1Dw	2021-09-23 20:17:47.862984
948	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMjAyNzEsImlhdCI6MTYzMjQyODI3MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.C5EDtg42errqLtPGcr0LdnNN4mhCcpxZFJYE-5ges2c	2021-09-23 20:19:04.06052
949	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNTMyOTYsImlhdCI6MTYzMjQ2MTI5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.IauHwi88MiRiLgFFWfcqcfd6SXJZKAdOBRz6B_yPEQk	2021-09-24 05:28:39.677958
950	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMDE4OTIsImlhdCI6MTYzMjQwOTg5Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hZdI2Zexy0dVLfUeCueHdjX0of751r0p2QdIgEuGiMg	2021-09-24 06:18:34.54859
951	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwMTA3NjAsImlhdCI6MTYzMjQxODc2MCwic3ViIjoxM30.mgg3Ouu4fiwXI3zupIdSkr96uOWWrt2zXKQmt7V9SSQ	2021-09-24 07:13:40.587729
952	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ5OTQxNjAsImlhdCI6MTYzMjQwMjE2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.S8L-nuQ_CJthhFA7YNvK09grdOhBfjTiL0qGjveWJW0	2021-09-24 07:33:25.075563
953	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjA4ODMsImlhdCI6MTYzMjQ2ODg4Mywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.64I7s-8mQocLWS0rRkyPore7qCZet7uZYgdEl9kwU5Q	2021-09-24 07:43:50.642815
954	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjE1NTEsImlhdCI6MTYzMjQ2OTU1MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.YyEAMEMKVJSZ-qgVe2omyhXRod7g9BW2u1pgoVN_hkc	2021-09-24 07:46:31.282322
955	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNTYzOTYsImlhdCI6MTYzMjQ2NDM5Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.eioz5aeBJGKIemyJ2Z8KY5w6AvA7s1Jt_1O-6w8bVUI	2021-09-24 07:51:30.414551
956	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNTMzMzksImlhdCI6MTYzMjQ2MTMzOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.m7vh1NWaapw3fzxk4SEtQ9OFXXY8Z92Jsn2Q6PofI9g	2021-09-24 07:51:52.93554
957	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjAxODIsImlhdCI6MTYzMjQ2ODE4Miwic3ViIjo2fQ._SRfARdvl45fMzGeSYQuRuyEx-Ak2Du7b3O8ZfEC3a8	2021-09-24 08:02:47.340585
958	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjI1ODcsImlhdCI6MTYzMjQ3MDU4Nywic3ViIjo2fQ._ui2LN5QGUc_LNnyCBMDY0M37UhLBBuG5d6vicGfx6s	2021-09-24 08:14:13.097912
959	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjMzMDYsImlhdCI6MTYzMjQ3MTMwNiwic3ViIjo2fQ.z4s9Mp2x7ZedGGc39Z5VaQG2lmTr_0f4oxNldTp2NRE	2021-09-24 08:15:09.696474
960	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjMzNzIsImlhdCI6MTYzMjQ3MTM3Miwic3ViIjo2fQ.1ZJMRnWZjVJPq3IeqrATRrFADPSogXcq_ogZykKRqV8	2021-09-24 08:17:28.722832
961	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjM2MDEsImlhdCI6MTYzMjQ3MTYwMSwic3ViIjo0fQ.zRLR8XlDeiyO7ZtiKKtFfVbwFP_KRybVkYTvGZ7Ipw8	2021-09-24 08:25:00.694345
962	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ4Mjg0MzgsImlhdCI6MTYzMjIzNjQzOCwic3ViIjoxM30.jrjGJ31pOQeqZGcK4XlY8Pfidvz5LNGBU1YG-qe2k0c	2021-09-24 08:45:45.76931
963	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjUxNTQsImlhdCI6MTYzMjQ3MzE1NCwic3ViIjoxOX0.sSf0KrVHoR6wXGLm2D86gG_MuvFT-GH0pJ3IYqLbPME	2021-09-24 08:46:06.439812
964	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjUxNzQsImlhdCI6MTYzMjQ3MzE3NCwic3ViIjoxOX0.StRw2e1e5eORCz3-4TVz5NIWHVidhPwVSElFTI8jMZc	2021-09-24 08:49:29.19927
965	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjU0NzAsImlhdCI6MTYzMjQ3MzQ3MCwic3ViIjoxOX0.v3d8ZQVH1vF5ACJJN8VWhRj2_OugNyPXzZzvKqthRsE	2021-09-24 08:56:13.573836
966	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjgyOTAsImlhdCI6MTYzMjQ3NjI5MCwic3ViIjo0fQ.fww-_zHnKixSV86nZGLT9BWXO1Wx7DOQAKqAG-8IcQk	2021-09-24 09:38:25.522346
967	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNzAwMTcsImlhdCI6MTYzMjQ3ODAxNywic3ViIjo0fQ.5miNXkKJbAW9zKlAr6VtD5c4RqHZOHuDWK0s_lTgwrw	2021-09-24 10:07:16.199743
968	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNzAwNDEsImlhdCI6MTYzMjQ3ODA0MSwic3ViIjo0fQ.qaAsoyuKQR0eUlRgEEWimOND9O8DbVAaKJIYnbP1D68	2021-09-24 10:07:24.880568
969	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNzE0MTgsImlhdCI6MTYzMjQ3OTQxOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.M1g0Ir-Ea1FNMcKnu5ZAEKS9WCBqetLgwGbYT4Q7ZKM	2021-09-24 10:39:39.658165
970	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjU3OTEsImlhdCI6MTYzMjQ3Mzc5MSwic3ViIjoxOX0.ecGqDhAsFpzR_SCLZ32_giLTJMDQnhX3w4U0y5LdvY0	2021-09-24 12:10:24.286786
971	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNzc0NDMsImlhdCI6MTYzMjQ4NTQ0Mywic3ViIjo0fQ.kc5lsrysxzWA9702v42ojdwwHR5gchGixaNHtvCSPys	2021-09-24 12:11:02.049915
972	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODAxMDUsImlhdCI6MTYzMjQ4ODEwNSwic3ViIjo0fQ.dULOonMq_59w7gKogfh_GACRaS5O8SYZLcOBSj20cwI	2021-09-24 12:55:26.386929
973	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODIxODIsImlhdCI6MTYzMjQ5MDE4Miwic3ViIjo0fQ.w1mJLRRF5eHmWBhR8od0UY4EQEKW1wduFAQ80Qk8rKo	2021-09-24 13:35:42.548151
974	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODI2MzEsImlhdCI6MTYzMjQ5MDYzMSwic3ViIjo0fQ.C9zKWBgdYaA9z1zRSVrCrhVmGWO7KlEn-nTcbE8jeXk	2021-09-24 13:42:00.610748
975	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODI5MzMsImlhdCI6MTYzMjQ5MDkzMywic3ViIjo0fQ.16POuXxhDiW1pzd94ihL0OZNrRCYHuIW1rHvgzrRY1A	2021-09-24 13:42:19.935924
976	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjE4OTQsImlhdCI6MTYzMjQ2OTg5NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ORpLSDTVii2pDiSMn_mUueTo4pbh6km3YUXzQk-aRS4	2021-09-24 14:06:44.480072
977	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUxMjU3NzUsImlhdCI6MTYzMjUzMzc3NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3Gu7uDmoXL-pAPvwkVlVfU5W5I7lBs-Or1omrD6EML0	2021-09-25 02:12:34.874778
978	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODQ0MDksImlhdCI6MTYzMjQ5MjQwOSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Wi_yAmPDe6OfzYGJauLkexthfrZ6_pJiQCygiRWv4vI	2021-09-27 04:49:16.039762
979	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMTQyNzIsImlhdCI6MTYzMjcyMjI3Miwic3ViIjo0fQ.uAbz6xMA3RWyEUMCDLiM1gsG3OTxFICssZAen5WPg40	2021-09-27 05:58:02.607494
980	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwODMwMTMsImlhdCI6MTYzMjQ5MTAxMywic3ViIjo0fQ.MOwXjZ2tOMVtnDSmQcy_9PHQTqISU7An0AXjzn6pAFA	2021-09-27 05:59:08.585225
981	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjM3ODcsImlhdCI6MTYzMjczMTc4Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.41yYb7y31AT00wa5CMl3l4vQiguDR5K2454L3B138xI	2021-09-27 09:55:58.155634
982	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjYyNDEsImlhdCI6MTYzMjczNDI0MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.A22y3HJ_UMKWYv7Mwt4HMitTXVdgocBr1wLNyqZeyxY	2021-09-27 10:03:48.341647
983	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjkwNjksImlhdCI6MTYzMjczNzA2OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.T6hCacuKAKXnN7_ePrtXP4lEmMA37a3vmBVN8jg7FQM	2021-09-27 10:13:17.240879
984	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMzIwOTksImlhdCI6MTYzMjc0MDA5OSwic3ViIjo0fQ.c6O0JCL2-8Ix7Lq2rdlEcNO9yVaSxdc49f3PdPnUV48	2021-09-27 11:06:37.48557
985	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjk0MjcsImlhdCI6MTYzMjczNzQyNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vyvzTC5ECnWviHM_JeDguHN4KDFYXYQi8Xjg1z6ojf0	2021-09-27 11:20:27.809596
986	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMzM2MzEsImlhdCI6MTYzMjc0MTYzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.7pA-fK-U6mawBNVZUZHqT5xItMxl8uTP1QmyXgo_HCM	2021-09-27 11:32:53.564519
987	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjg1NjMsImlhdCI6MTYzMjczNjU2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.PpTViM_U8FflpBhSM04p2C2f6H7yWsx1oSM7aWhvPSg	2021-09-27 13:45:46.435417
988	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMjk2MTMsImlhdCI6MTYzMjczNzYxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.EPWoCfUI3IaNtxnm31IpwzZJiQ4gfgjZIEJT4jz1Cbg	2021-09-27 14:14:40.023335
989	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzNDQwODksImlhdCI6MTYzMjc1MjA4OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.LCpkv7udOEtTAukjMYSyPVGrtdbt24JzYMDC1O4fENQ	2021-09-27 14:15:13.546819
990	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzNDk4OTcsImlhdCI6MTYzMjc1Nzg5Nywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.engB-tmGr0k1bP274LYpH3ooCqKHfbcAjZC54EdlwjI	2021-09-27 16:00:23.294391
991	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzNTA0MzAsImlhdCI6MTYzMjc1ODQzMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XH07yxf21BEQODwYc3kHijXgI2ilKIEEVy5MsuB3_m8	2021-09-27 16:29:41.452755
992	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzNDIzNTQsImlhdCI6MTYzMjc1MDM1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.4b8ziSneW0KjHyHLYW5Exgeh9J0oYee0Q4SN99Mbpbc	2021-09-28 06:53:03.320892
993	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MDM5OTEsImlhdCI6MTYzMjgxMTk5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.lJeOOreaMMVTXemxpEGJLnBVAsgFgyvGO3D609OSi7Y	2021-09-28 07:02:37.588605
994	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUwNjE5MTcsImlhdCI6MTYzMjQ2OTkxNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RhBGKntm5yKc68WJOqcNGUHG2r4YJk9SMIj3_Z62OPA	2021-09-28 07:03:50.970739
995	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MTM0NjMsImlhdCI6MTYzMjgyMTQ2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MJZZq8oUw0tEXeeP3hFlsOFQI3JfjeE_9dHZh-obnGI	2021-09-28 09:31:32.135115
996	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MDQ1NjMsImlhdCI6MTYzMjgxMjU2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.gkoPa9MZlw0yLSfbdO7IcfJVWoJYfeEwUyUmvx_QB7E	2021-09-28 10:34:27.781954
997	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MTM1MDUsImlhdCI6MTYzMjgyMTUwNSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.8KOiiZTTl-KOzM-mxba_se4icvkoqpQzFnAx2hFfh2s	2021-09-28 10:41:10.30005
998	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MTc3NzEsImlhdCI6MTYzMjgyNTc3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.cTTfsC4RZCYrkx0W860gNoobJ8m9hEXeL69cTvPE61A	2021-09-28 10:48:30.396909
999	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MTcyODEsImlhdCI6MTYzMjgyNTI4MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.y-p_puVjbWiBnzV8u_6c3GOO_bZMVeiYp2cPAt56K6Q	2021-09-28 11:19:13.861571
1000	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MTk5NTksImlhdCI6MTYzMjgyNzk1OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.BfZV7UdUqoNWh_ozCO_0QqV6ls_sPjEehrmrs3Ba1_M	2021-09-28 11:24:19.41144
1001	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MDcwMjgsImlhdCI6MTYzMjgxNTAyOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vOxBH9dMangNnOz6XlKZTZzmJBgcRY7QoYQFXS7RRFk	2021-09-28 11:24:33.167262
1002	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjAyODIsImlhdCI6MTYzMjgyODI4Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.YlM6YLB8dN4ApCTd4p1zAfCO6PtsNijLPxYal1ZZnA8	2021-09-28 11:29:30.903736
1003	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjA1NzUsImlhdCI6MTYzMjgyODU3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.hsvxGfUDD9kToBU2dQCaR7Ax3gDRzw7c8yOrRAVJjNY	2021-09-28 11:30:11.502124
1004	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjA2MTYsImlhdCI6MTYzMjgyODYxNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.G5CV8h5Csb9jvZXYKZHi7WSx0F7wUeF1zZfbgOUZBQY	2021-09-28 11:50:32.343294
1005	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjE4MzcsImlhdCI6MTYzMjgyOTgzNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LT1QnNtipKIWxFZignRMNhVWXb_p2QMOuiDXlD5W1ls	2021-09-28 12:03:10.457031
1006	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjI1OTYsImlhdCI6MTYzMjgzMDU5Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.o-Lcw2x_4WTehMRWLF9PIPQCvH-cQjqm_io6XzaE8vI	2021-09-28 12:06:04.398513
1007	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjcwODYsImlhdCI6MTYzMjgzNTA4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5lh2WrvHK0r0hfxKMmW0niLLgvtEJ1u3m_VhfZBhniw	2021-09-28 13:30:42.314522
1008	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0Mjc4NDcsImlhdCI6MTYzMjgzNTg0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-3uowPytdJ5mwINBQp_ZKHjoFENY4LBpJlVmGejK7pA	2021-09-28 13:46:39.455356
1009	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjI2MzEsImlhdCI6MTYzMjgzMDYzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.A98bxApgY9sFfcQAAL_MRFBF3gNPckcFGs6lwiCtPyo	2021-09-28 13:46:44.511679
1010	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0Mjg4MDUsImlhdCI6MTYzMjgzNjgwNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Nnhy5dantgRcSGDVUqkP0X4zdLkftHb6vjf8wNzGcYU	2021-09-28 13:50:53.976458
1011	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0NDE1OTksImlhdCI6MTYzMjg0OTU5OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.CfJ5cGf35AmUSPZuZKkTpd6UQSlcWe512-iEnm-4b5c	2021-09-28 17:20:37.603868
1012	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MDE2MjMsImlhdCI6MTYzMjkwOTYyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.-fLAwbdClgPg7hJ-U5Af55F9iEQAj2NRTylFcVvZcXY	2021-09-29 10:00:35.522872
1013	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MDYxODEsImlhdCI6MTYzMjkxNDE4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.gGGcvLEtF_342jzK6w_cm78nfrVMY50jw57RBls8x-4	2021-09-29 11:28:36.209128
1014	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MDY5MjEsImlhdCI6MTYzMjkxNDkyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.u8rqytjXPH6k0m2igJRWv-bwPXHIupI9nEkInwUCdlw	2021-09-29 11:32:34.420657
1015	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MTg4ODAsImlhdCI6MTYzMjkyNjg4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.KdCBlaUvYZawGfs8b6TAj25CfXLsFpnJAWRSfH-L0_0	2021-09-29 14:54:06.03121
1016	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MTkyNjAsImlhdCI6MTYzMjkyNzI2MCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.sqyCBjpEFD6GJ-4Zbp7NDhku0DUbhwE-Ecg_nk_ncfY	2021-09-29 14:57:17.477336
1018	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MjAyMjEsImlhdCI6MTYzMjkyODIyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.auhowIf_4kYr5PgPDdMGTOyI6ctYRjayC7FRRWaI4sI	2021-09-29 15:11:00.748073
1019	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1MDc4NTAsImlhdCI6MTYzMjkxNTg1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.WbAb5Fjw_K4DFdJQptfudfKXmfIwedwk5dbz_U3RDlc	2021-09-30 06:09:56.34997
1020	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzQwNzYsImlhdCI6MTYzMjk4MjA3Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ttrfOy3jgUTO40PqfIspvPk2Eyl77wIaHyRbt__wWds	2021-09-30 06:28:41.568579
1021	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzUzMzMsImlhdCI6MTYzMjk4MzMzMywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.aYIkDsTnS-5dxpBXwmvB0KmzlJnDy_XaiqWlaSlpSYc	2021-09-30 06:29:09.523705
1022	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU0MjI3OTcsImlhdCI6MTYzMjgzMDc5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.09iG9MviXv6r-KUhB6RxfyLbRvKqxfl5I9Fg-dakhiM	2021-09-30 06:38:51.236836
1023	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzU5MzcsImlhdCI6MTYzMjk4MzkzNywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cS07-xSagKdQQ0CC4rIJSGen6Kaj5qwqyFYaJEPgDnA	2021-09-30 06:46:56.16374
1024	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzQyMDEsImlhdCI6MTYzMjk4MjIwMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3iJbel67eQxUZ7KKiUABIjLXuL7QZP0UIfnbwJGAsXM	2021-09-30 07:12:29.925215
1025	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzY0MjQsImlhdCI6MTYzMjk4NDQyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.vx9z4rRE5tx_0wVrFue0i3l1glVuIxCnQizp_obqhIQ	2021-09-30 07:32:29.187612
1026	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1NzkxNTYsImlhdCI6MTYzMjk4NzE1Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.bZxcn04_Un14Y_LX_5OtivkVxpEyM_XlnD_Twbf5i0o	2021-09-30 07:41:39.984535
1027	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1Nzk3MDcsImlhdCI6MTYzMjk4NzcwNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UYn-xXefcS1UvOfENQteOItZQdnj29VRqBbnulAAWU0	2021-09-30 07:42:28.355395
1028	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1Nzc1OTUsImlhdCI6MTYzMjk4NTU5NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ErmlvaL8l1EsjFBT3u0kaq1jajXtwV7fEIF9ET6zIWY	2021-09-30 08:28:38.361634
1029	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODI1MjgsImlhdCI6MTYzMjk5MDUyOCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.k2uFPZkVjZawOJr-QHU8tHyH-Eh84FJXGi9jZ1VgcYY	2021-09-30 08:30:40.921981
1030	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1Nzk3NTMsImlhdCI6MTYzMjk4Nzc1Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.bnMJcg4oNuFU97_2pIso2_r5DxXIqGk5bYNjyyALLi8	2021-09-30 09:09:31.532899
1031	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODQ5ODEsImlhdCI6MTYzMjk5Mjk4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1ZBbip--zIrMEJYHltf1SwuA9zisbYQsOHuywmEoT04	2021-09-30 09:53:28.268411
1032	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODc2MTQsImlhdCI6MTYzMjk5NTYxNCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.cvIHuihmYm-jRXUI16vKO0qCFUo57FrkUdeRVS65nUE	2021-09-30 10:04:28.037455
1033	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODkzOTEsImlhdCI6MTYzMjk5NzM5MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MFYYA2FtLmD9UKarFjgPEBb79n3hmpR-7U7iCiSuGJ4	2021-09-30 10:27:51.340642
1034	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzMzI4MDMsImlhdCI6MTYzMjc0MDgwMywic3ViIjoxM30.iGOSIG2NRgTRQUTW7VwhgurUKKwCKx-J0bVX2NTrV8E	2021-09-30 12:31:00.706815
1035	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU2MTQ1NDUsImlhdCI6MTYzMzAyMjU0NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.Uw_xNbdCh9P2HdnAg6nToKMhQboXop48BpwnDUflOJc	2021-09-30 19:10:45.874472
1036	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODcwMzUsImlhdCI6MTYzMjk5NTAzNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TMmaB7hbnOySpIzxMtphN2GTd-q2Akt-qQhsy0O5Mdc	2021-10-01 08:16:12.434887
1037	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU2NzA4NjQsImlhdCI6MTYzMzA3ODg2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1tTJDrnBMoebMagb8qZ2wRmlsGMkZ0EKI92JfR6hK48	2021-10-01 09:01:44.710973
1038	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU2OTAxNDYsImlhdCI6MTYzMzA5ODE0Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.5OwNqjhMHEnlOTZpJvseF_f8YEXem-rqIqL0FvoxnBE	2021-10-01 14:25:47.228249
1039	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU3MDY2NDgsImlhdCI6MTYzMzExNDY0OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.nKKbxi3bzZB0utQMs8yHYDbbHNzDrEb8kQGgKmvXhcg	2021-10-01 18:57:38.17787
1040	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MDY3NTUsImlhdCI6MTYzMzMxNDc1NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.7hrBRaIXEK1qfDrRR5fbu71rY8rgPeLEIyuj4oFIUv4	2021-10-04 02:41:02.915447
1041	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1ODgyNzMsImlhdCI6MTYzMjk5NjI3Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.9NEU-ZkXj03JvoeFQ-FXVnlJW-OZYxR8HRyK7Eu5Bi8	2021-10-04 06:12:01.542718
1042	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5Mjg5MTIsImlhdCI6MTYzMzMzNjkxMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8SpsZiAKlP-Vw8IEdtzIYr3IXXMKhg5Nmrtzkr6D4aA	2021-10-04 08:42:07.258938
1043	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MTk5MjUsImlhdCI6MTYzMzMyNzkyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.G5tW1RaFLCotVBT8tevhV8OeylxJ_1O2m_zAEEMu_IA	2021-10-04 09:12:14.393351
1044	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzA5MDEsImlhdCI6MTYzMzMzODkwMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.uIiNMRBF0C5xHzgwOM1p1i-VzC59DKlzPCBr0TAARMo	2021-10-04 09:15:12.463353
1045	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzA3NDEsImlhdCI6MTYzMzMzODc0MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.wg_HDXskhYvqMOXLLxnE7UMd_v9noHw5eMjown2Vtww	2021-10-04 09:56:47.753697
1046	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzI1MDYsImlhdCI6MTYzMzM0MDUwNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ._DyZJhFEqIWbqD60atR1ZyAxV5bS2XkS9PP0fItZHFw	2021-10-04 09:56:56.572704
1047	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzM0MjQsImlhdCI6MTYzMzM0MTQyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.MUPz7dycqpwquxKXY91yADnbrDI2OH80MV4vu6uf5us	2021-10-04 09:58:21.415272
1048	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzM1MTEsImlhdCI6MTYzMzM0MTUxMSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.Zy61XRc2lTz4MxbhBez0CA7WqAfw2OyFyJeRug76Jd4	2021-10-04 10:03:32.111251
1049	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzM1MTQsImlhdCI6MTYzMzM0MTUxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.pf5fXYVDODXphvTIKUQ1dE9pwjQT3b0o3IZYO2AmRjg	2021-10-04 10:13:52.508832
1050	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzM5MjUsImlhdCI6MTYzMzM0MTkyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VxB8trIdPtzTBSx9B2pD7TyhcZijBb1Eja0ySEznxZE	2021-10-04 10:17:54.338637
1051	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzQ0NDIsImlhdCI6MTYzMzM0MjQ0Miwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.bjtBRvPTX_lKb_4QGrE9dl2PXuMxhTZAlHO_lWtQbiA	2021-10-04 10:18:51.907114
1052	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzQ3MzksImlhdCI6MTYzMzM0MjczOSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.UJT9nyccdYZFkSPAOoG5TE9ILkfMZ0efvzA3nxUWmQA	2021-10-04 10:30:22.077265
1053	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MDcyNzEsImlhdCI6MTYzMzMxNTI3MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ygF1OZef5lH2asCsxVZAznB_ZOr9-y5H8hXcsDeWgWY	2021-10-04 10:34:23.142868
1054	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzQ2NzksImlhdCI6MTYzMzM0MjY3OSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.1b2_X5QB745K0yOKUQRbCIqjAq72ao2qb17JTC21U8I	2021-10-04 10:37:13.24143
1055	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzU2NjksImlhdCI6MTYzMzM0MzY2OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.iHktCINzjuAzdDozhlob9ZBuYwW6vrzd4bdv_XxGTm0	2021-10-04 10:39:29.042767
1056	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzU0MjgsImlhdCI6MTYzMzM0MzQyOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.TGBKFjUQMrXMV28oGv1lrLB5QafY5ApKId8LlTfU4yY	2021-10-04 11:30:45.763126
1057	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzkwNTAsImlhdCI6MTYzMzM0NzA1MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QQbw-qcgkhTrsGDhqvk_6_fiIB3mSXJN8hPHoiqPdVY	2021-10-04 12:26:20.418853
1058	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU1OTcwNjQsImlhdCI6MTYzMzAwNTA2NCwic3ViIjoxM30.4CvhfVgLFCk9jXV8p5Lgf-a1QUENfYrMhO-p-Z-ePgc	2021-10-04 12:29:49.558245
1059	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5NDI1OTMsImlhdCI6MTYzMzM1MDU5Mywic3ViIjoxM30.vxvy93vtSGh34d2-MSsKQpLqGXV9Gv5y9Xn0b618wRc	2021-10-04 12:29:56.434904
1060	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5NDI5NDksImlhdCI6MTYzMzM1MDk0OSwic3ViIjoxM30._WemCHLNrfQfNg0LjSGN4-xiNe49DLV9g52jlunvwXQ	2021-10-04 12:36:23.06135
1061	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5NDQ2NDEsImlhdCI6MTYzMzM1MjY0MSwic3ViIjoxM30.SBlBL1gCSvQRRnHH-JGvxdwMSMLXbKmdfurics4LGfQ	2021-10-04 13:58:46.748158
1062	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzU4NDAsImlhdCI6MTYzMzM0Mzg0MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.MGo32lMMWEqqsk_KH342agoBPphaN2njpRyvrzDA12k	2021-10-05 05:37:20.796711
1063	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5Mjk5ODUsImlhdCI6MTYzMzMzNzk4NSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.IVpjt6eWv_J_iOq-9Rfcg1SQPyCvccVX8hgupMme3Vc	2021-10-05 05:57:23.736413
1064	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MjkxNTYsImlhdCI6MTYzMzMzNzE1Niwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.iN8bg8RN7lpCjvk5CFUYoRE2bFTtWCEnzJ41ydyQYnA	2021-10-05 06:26:10.096011
1065	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMDcxNzcsImlhdCI6MTYzMzQxNTE3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.jH_77lv17vALXOWddX3AFU3Ee-nCQ53wgNeM0rIPVX8	2021-10-05 06:30:49.212647
1066	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjAyOTEsImlhdCI6MTYzMzQyODI5MSwic3ViIjoxM30.80gMU1EKpAg-Ab61Dg8bRvUJAoCzx415HUmjJQH_C_A	2021-10-05 10:05:10.131211
1067	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMDQyNDUsImlhdCI6MTYzMzQxMjI0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.TE0ekGBPNJJSHsbA_PKFCPFxumdYNI13dyq4w1b31oQ	2021-10-05 10:33:43.317656
1069	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjg4ODQsImlhdCI6MTYzMzQzNjg4NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.ajKMhdjdHHBQHyqd__v_qc6uiBhN5K96sSO4Ta8NdAY	2021-10-05 12:28:26.383589
1068	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjIwMzEsImlhdCI6MTYzMzQzMDAzMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hORnJnb92ui2PgiYixTi9sw_7i4JEY9VgvkZTsJKJGE	2021-10-05 12:09:48.308582
1070	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMTk3NTEsImlhdCI6MTYzMzQyNzc1MSwic3ViIjoxM30.KmAUje-abAWjLJbZP2z65Gekp9ORgj_GaCRFBK8h4rk	2021-10-05 12:36:30.529352
1071	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjc3OTQsImlhdCI6MTYzMzQzNTc5NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.nkxHQSwW7GDNiGhmzQlqqN5cTOPjzTYkEe6Wg8GSwtA	2021-10-05 12:47:16.61212
1072	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjkzOTQsImlhdCI6MTYzMzQzNzM5NCwic3ViIjoxM30.Bnf3ThB-e3PLqyvaCxOzsXrypLSKSSiTiIZEUgopcq4	2021-10-05 13:07:41.598506
1073	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzEyNzAsImlhdCI6MTYzMzQzOTI3MCwic3ViIjoxM30.tNyUC1obdzoZWzRrSd0nJPIKefshyrdBTPcSx07BBDA	2021-10-05 13:09:52.75654
1074	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzEzOTgsImlhdCI6MTYzMzQzOTM5OCwic3ViIjoxM30.gAn-BTZhZ_QI2skgaUAWj87Gk4I1sFvaQwpbob8lXMA	2021-10-05 13:43:08.225355
1075	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzM0MjAsImlhdCI6MTYzMzQ0MTQyMCwic3ViIjoxM30.Ri5HhlvwW3naHwS01HjWqvn4TlPaBZLBdV2vy28ydpg	2021-10-05 13:46:05.265315
1076	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzI4NzcsImlhdCI6MTYzMzQ0MDg3Nywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.hIRPg7ODnHCNssvDH2gMRfcGOr-0UBRhyDN6Bxd5Ve0	2021-10-05 14:11:53.359311
1077	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzUxMjEsImlhdCI6MTYzMzQ0MzEyMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.DqQU71cC19uoRVYbhfL5jewrFI4g3LAhTLYwakZnd00	2021-10-05 14:22:32.221148
1078	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzU3NTgsImlhdCI6MTYzMzQ0Mzc1OCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.QnZXManTbd5Sf1_EPIQDxq4SnxyKq-4qXjNr1KePtVw	2021-10-05 14:27:17.893818
1079	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzM1NzAsImlhdCI6MTYzMzQ0MTU3MCwic3ViIjoxM30.6gJ-DH-3-IjjlDOtUV7we7CvXZ5vQrh1oKpKRlVwkz0	2021-10-05 14:28:55.334101
1080	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzAwNDEsImlhdCI6MTYzMzQzODA0MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.2jz5V7sNn8kYsB-yP6MtRq5zlBj1ngqZarxK6GS-8BM	2021-10-05 14:37:05.588855
1081	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzY2MzEsImlhdCI6MTYzMzQ0NDYzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.606XNn19Ft9n0aswykEd8xhXEyDZvNBpa0Le6rkMboc	2021-10-05 14:42:22.111429
1082	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzYwNDQsImlhdCI6MTYzMzQ0NDA0NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.AJ-khkWCoyLLN482uShlN3kdlz0mGcYXy-rkAhF4OJw	2021-10-05 14:43:13.296192
1083	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzI2MTIsImlhdCI6MTYzMzQ0MDYxMiwic3ViIjo3fQ.gSTIwwzOea6xLY5G_Txd4AQsT6iQ9mbAv5HXZXpyb7w	2021-10-05 14:56:13.162473
1084	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzY3NjMsImlhdCI6MTYzMzQ0NDc2Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.DbwVRPQAbSmh71BsykKwpJz20o8gd-1Bgm11UIvGVRs	2021-10-05 15:06:01.889225
1085	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzg2NzcsImlhdCI6MTYzMzQ0NjY3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.1eMKv80qXMvSJ5kJPozzIHG9uTd_s8gN2z8JkP_pHwg	2021-10-05 15:16:23.558342
1086	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzgwNTksImlhdCI6MTYzMzQ0NjA1OSwic3ViIjoxM30.gV-2B2MMU69pxNWs-xbfV5boM-GEzWczCIX-La_xf_Y	2021-10-05 15:24:14.712899
1087	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzY5NDcsImlhdCI6MTYzMzQ0NDk0Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.tVxl7QW3dNqB8zPKi87pa4EqAZngX5_d-1AYJaWavWs	2021-10-05 15:24:39.210762
1088	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzk1NzAsImlhdCI6MTYzMzQ0NzU3MCwic3ViIjoxM30.fUomxJmdOcrCX8J2KS1-suGSBZY8ChGZfp1mQx59AOE	2021-10-05 15:26:27.405428
1089	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzk1OTAsImlhdCI6MTYzMzQ0NzU5MCwic3ViIjoxM30.aa1PAP_JRc5CvQUzZIyLQxj9db0A9LVFjC_00CQPePA	2021-10-05 15:30:55.962921
1090	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzk0ODMsImlhdCI6MTYzMzQ0NzQ4Mywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.SU01qs2OtTCX19mJu8ydiK-452S21CRwMUh7F_zz2gA	2021-10-05 15:31:01.851849
1091	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMzk4NjcsImlhdCI6MTYzMzQ0Nzg2Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.CwOIJahkDEAf_P85GgVGik4bJVZVCeyDzwmvAswqQl4	2021-10-05 15:51:45.922689
1092	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU5MzU5ODEsImlhdCI6MTYzMzM0Mzk4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.fHhGXVbxBYxqFF_PPCKaf2YC3LONbU7EkuZG989RhKc	2021-10-05 15:59:01.500548
1093	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDE1NTEsImlhdCI6MTYzMzQ0OTU1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.E8dnV2aYmw_ERvRerqt8xYc-S66dj3tp09BytrG3wO8	2021-10-05 15:59:38.018426
1094	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDExMTEsImlhdCI6MTYzMzQ0OTExMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.y1NRSo7HvZCcwA7TxJUYGISyX9vEGA-4IrgdyvtbdII	2021-10-05 16:14:42.793679
1095	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDI0ODgsImlhdCI6MTYzMzQ1MDQ4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.MsnWyaCef66SoWeUaFsbTxyrbyn1Xc-N-SVIj9sTocY	2021-10-05 16:19:12.484963
1096	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDE1ODksImlhdCI6MTYzMzQ0OTU4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.8xtc0ldgX4-jGxl6e-ink7fZz-NuiXv5cH-4SmSoveo	2021-10-05 16:40:43.849856
1097	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDQwNTAsImlhdCI6MTYzMzQ1MjA1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.GrWe2UsyZvF0msEE7dxRx3B_jjpj97by7erA1n7CDmw	2021-10-05 16:46:22.319329
1098	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDQzODgsImlhdCI6MTYzMzQ1MjM4OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.368ybVd_sTeF0JKp6_HCvG_6qK_ZwfqUzvMMhIamRfs	2021-10-05 16:50:29.922932
1099	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDQ2MzgsImlhdCI6MTYzMzQ1MjYzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.5fBVttVW0VTmLN5SJqxrJJafgy-giwkVy8fyO8dWfDE	2021-10-05 16:52:18.712603
1100	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDQ3NDUsImlhdCI6MTYzMzQ1Mjc0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.uGxhwx_WI45YUpKrd_lprThysayxWGXtua6DQeNZDKk	2021-10-05 16:56:43.992738
1101	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDUwMTAsImlhdCI6MTYzMzQ1MzAxMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ysFwt6rY6OMvXb6lPJID1xt_tZp4galxa6zoKzd3f44	2021-10-05 16:57:01.952776
1102	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDUwMzksImlhdCI6MTYzMzQ1MzAzOSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.N2VPDmtqSyC1PMweX49bSVfaSPt33xe5lop4CWy3iHc	2021-10-05 17:13:26.667575
1103	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDYwMjUsImlhdCI6MTYzMzQ1NDAyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.lyoEak0Y9hAQpNEiU8-r-1mGdq7wykXDwgmFumlyq10	2021-10-05 17:19:15.065277
1104	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDYzNjIsImlhdCI6MTYzMzQ1NDM2Miwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.UChtaeQ0b9mI5L3RsdLzZ6PNlH2aXqoBT0m0PWj-sI0	2021-10-05 17:59:49.272382
1105	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDg3OTcsImlhdCI6MTYzMzQ1Njc5Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.uyPEb9QpFtrHrvkyc2XXa4Hkjtko-wCv8Mdc_RU9aqU	2021-10-05 18:14:00.963313
1106	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDk2NTYsImlhdCI6MTYzMzQ1NzY1Niwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.NTycPsIHkK6zj-65Ke9uJLfuKgHtD2Beajqpj4vnh3g	2021-10-05 18:46:40.235955
1107	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTE2MTUsImlhdCI6MTYzMzQ1OTYxNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VgM0BJH1rYfXwCQVPS4rZzeO3pe1H21bGtPXQQiKTOk	2021-10-05 18:48:00.585197
1108	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTE2ODgsImlhdCI6MTYzMzQ1OTY4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.3FMhNRXuznZdJgKioYTHAxyw0Jwt8mf9GcImZfLaNn8	2021-10-05 18:49:03.217634
1109	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTE3NjgsImlhdCI6MTYzMzQ1OTc2OCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.IEfJEPPj8QcU28PjjOvqlmYQPTi6QShKKPfzGu4a4iw	2021-10-05 19:03:33.219829
1110	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTI5NzIsImlhdCI6MTYzMzQ2MDk3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.0YwyrDeB7keleuK70_OPdis8so0M0I7wVT_nMOIqbuk	2021-10-05 19:10:09.097667
1111	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTQ4NzYsImlhdCI6MTYzMzQ2Mjg3Niwic3ViIjo5fQ.DG4lZpD1bdzHtfRg_HZ9YxxBAfD3C6WFSDnPgWh2dZg	2021-10-05 19:43:06.344996
1112	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDg0NjcsImlhdCI6MTYzMzQ1NjQ2Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.W6-OVgjCFYTmuj6Lxml8b0CBFWVQiq7fhgOt-V7Na_0	2021-10-05 19:47:04.407393
1113	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNTMwMjUsImlhdCI6MTYzMzQ2MTAyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.ccRFdqq0C2uffrq_eUApzZnKZjaX6ImbwSQXXn_1NY4	2021-10-06 05:50:33.234829
1114	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTE0NDAsImlhdCI6MTYzMzQ5OTQ0MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.K70l-nsmybs4TqljzxxH4rhL1vo3GatE7jpnBcJC0Tc	2021-10-06 05:51:38.274813
1115	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwNDI3NTksImlhdCI6MTYzMzQ1MDc1OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.h26QM1yJ7IWNIyexIUxuYgHVDSpOilMkNUfozKqczoI	2021-10-06 06:22:12.683987
1116	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTE1MDUsImlhdCI6MTYzMzQ5OTUwNSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.H50tPQI8POpyoVGBih1DgXpTwnPrdH93pVxRINMTjHw	2021-10-06 06:37:43.805998
1117	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTMzMzgsImlhdCI6MTYzMzUwMTMzOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.iswShlCdiv0Fm9mhlnDSoe-PF1-dZa-rT6_xInlqCog	2021-10-06 06:51:02.295718
1118	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTM5MzgsImlhdCI6MTYzMzUwMTkzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.igyV7s2oVwkI7hvuGoCTkf7NyyGdtVldEcEl3REOkzE	2021-10-06 07:14:07.84543
1119	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTY0NjksImlhdCI6MTYzMzUwNDQ2OSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.39h7r3lzMOcyZatG0tmjo9kgUTWGZuaNwbGufWe3aUs	2021-10-06 07:17:16.74514
1120	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTUwNjgsImlhdCI6MTYzMzUwMzA2OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.zmh5y8u_5aXDFvmpAnyGNOviOU4Bt8PprafhtNxgcME	2021-10-06 07:28:46.633079
1121	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTU0NzMsImlhdCI6MTYzMzUwMzQ3Mywic3ViIjoxM30.MjVcTJjZoj85yZC-TbP7G_AneL9yEenyJ8pY8A0Hixc	2021-10-06 07:44:15.208768
1122	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTY5ODUsImlhdCI6MTYzMzUwNDk4NSwic3ViIjo3fQ.T5YvhGkDnucTKmPp0ahfQ7xJHEFciqIizj8FeM91qnc	2021-10-06 08:01:44.37209
1123	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTczMzIsImlhdCI6MTYzMzUwNTMzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.e2YdDsjfuCizmpUSD202NOFM5Vm42rSFCi7x_TODw5k	2021-10-06 08:02:56.469242
1124	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTk5NDMsImlhdCI6MTYzMzUwNzk0Mywic3ViIjo3fQ.NtnNgffj7hYPdLhLoFgrpR1wFIGR8_gaABVJB0iSVSU	2021-10-06 08:12:27.526496
1125	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTk4NTksImlhdCI6MTYzMzUwNzg1OSwic3ViIjoxM30.evU7KEeCETxEz3Nvt27fi0nksU3tQmo-vyVi8Z6ZjUM	2021-10-06 08:14:13.394058
1126	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMDAxOTEsImlhdCI6MTYzMzUwODE5MSwic3ViIjo3fQ.I99GDQb3fk9YW7VB8cx7i-5E75XYWNXEhyMGp5X7Gfg	2021-10-06 08:28:53.779574
1127	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMDEwMDgsImlhdCI6MTYzMzUwOTAwOCwic3ViIjo3fQ.XJN6nlSGYJlfx9SiPR7CsnUi7Ay_3ZvCZo-VKfJV85Q	2021-10-06 08:30:44.05932
1128	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTkzODEsImlhdCI6MTYzMzUwNzM4MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XtO6eIc7GgehdtOfUGwnS1MD3yMH3JRrTE-1BbqP5HU	2021-10-06 09:33:04.849706
1129	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMDQ3OTEsImlhdCI6MTYzMzUxMjc5MSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.hNoz0dFN85T_EdI4Csr9KnWlRmO2aFVliacLpOYgSW0	2021-10-06 10:34:20.544624
1130	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMDg0NjUsImlhdCI6MTYzMzUxNjQ2NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.mu2s8hI4WPlXIdZYhzc1PiMIUe-msWdrSlzzDsbYfho	2021-10-06 10:40:27.92472
1131	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTEwNTYsImlhdCI6MTYzMzUxOTA1Niwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8MUv1FSQglZ_nKLwTFKhvraWfmBG_ZgN05eDuQopGSo	2021-10-06 11:38:45.68437
1132	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwOTQyNzEsImlhdCI6MTYzMzUwMjI3MSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.9ai-Z2XwhBbzrCsX4jrUfRYloZSzkuln8UtwxEKosAA	2021-10-06 11:46:20.944847
1133	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTI3ODcsImlhdCI6MTYzMzUyMDc4Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.octg5sWt9vVmfeIyn9WBJ3MSYHnZ4QnawV8G6egJVzs	2021-10-06 11:46:33.529795
1134	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTI4MDUsImlhdCI6MTYzMzUyMDgwNSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QsZ6gyNrzA1F7LXpnRqls5bhTrknaKl-MJUgMew0aNw	2021-10-06 11:49:43.057747
1135	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTMwMTMsImlhdCI6MTYzMzUyMTAxMywic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.DpQeMW4J3QarCXuvI2Cask3ve1Q_v1D9C8OoTAvWo4g	2021-10-06 11:53:28.676959
1136	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTMyMTQsImlhdCI6MTYzMzUyMTIxNCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.Iy8UTZGNjR3fqKRB304NIKrn38UmAaE3Jw__KUVfIfs	2021-10-06 12:17:09.377275
1137	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTQ2NDMsImlhdCI6MTYzMzUyMjY0Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.o8Nqf39c6D7UIc64yodCRoDfYtnAbB815QJ_w8FuaC0	2021-10-06 12:26:09.248279
1138	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMDg4MzIsImlhdCI6MTYzMzUxNjgzMiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.8dVNXUR4HllBG20JDEZmFWX9TxvJz5q6Vj91iUnxbZM	2021-10-06 12:27:12.642223
1139	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTUxNzcsImlhdCI6MTYzMzUyMzE3Nywic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.S-W_W81H_ux_lib6pZKtsb8B3J26UTPkTex368lcL_E	2021-10-06 12:42:24.855236
1140	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTYxNTAsImlhdCI6MTYzMzUyNDE1MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.YDf4oqeJ-AOcbV63P7XUxwWh9VwCE9nTPNZ308v4XWQ	2021-10-06 12:43:31.260789
1141	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTUyMzcsImlhdCI6MTYzMzUyMzIzNywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GXznODKqykIQE44IVaODznMaRt7oA08sAZBZwxGMFRY	2021-10-06 15:57:54.789154
1142	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMjc4ODAsImlhdCI6MTYzMzUzNTg4MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.ors_7xgNv8VvPRn6kLuQ_49uSQh_L0W794FRK8Vm7Ks	2021-10-06 15:58:32.69703
1143	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTQwNTIsImlhdCI6MTYzMzUyMjA1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Et3wd1Fpb4WpzS953g9vyqHOQd0RrSK1FRqRs_uRWDo	2021-10-06 16:19:59.322093
1144	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMjkyMDksImlhdCI6MTYzMzUzNzIwOSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.GYDeX72il3GKMdd_QrVXyLMSsVYCM8x0H3zNXTDKjmM	2021-10-06 16:32:02.433061
1145	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMjk5MzEsImlhdCI6MTYzMzUzNzkzMSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.sjp35mLopr-YS_KBE6bMz5Jk6ke4IN99oGGVIdGLZ1s	2021-10-06 16:50:21.844278
1146	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMzEwMjksImlhdCI6MTYzMzUzOTAyOSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.j5vRGHpkaeZO8UtkI8YcrJIQB9-E6VzfV0Qqq33nWso	2021-10-06 17:24:44.423306
1147	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMjMzMTksImlhdCI6MTYzMzUzMTMxOSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.Kv9Psp-i2yEhICECXKG7WhO2LhQqZgO3U98tJjijzUI	2021-10-06 17:59:13.381832
1148	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNDA3NTAsImlhdCI6MTYzMzU0ODc1MCwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.mOgcC5WXvgUyrNXsd85CzqaFLI_jbGUfy6xpUHjjhr0	2021-10-06 19:41:23.34497
1149	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMzk5NTQsImlhdCI6MTYzMzU0Nzk1NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.S51sLHSRdCsrjFWwgB6lNAUeouQF7GypTYzQWOqZeWo	2021-10-06 19:42:48.053019
1150	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzI3ODMsImlhdCI6MTYzMzU4MDc4Mywic3ViIjoxM30.BNn9iB93NuhalI8YIk8nXMQKMq-iuQbNwqb8NhTBSKk	2021-10-07 04:44:14.803772
1151	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzM5NDYsImlhdCI6MTYzMzU4MTk0Niwic3ViIjoxM30.X-DzQCItMUqnflqrquYz1OjVsuSGzWUWOLBvw-n3aqw	2021-10-07 04:45:59.899537
1152	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzM5ODMsImlhdCI6MTYzMzU4MTk4Mywic3ViIjoxM30.4Mo7Dyu5b1cZ5JxJz3-f9Wi2UvJsDjR67TdWKRuNyCQ	2021-10-07 04:46:37.146223
1153	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzQwMDIsImlhdCI6MTYzMzU4MjAwMiwic3ViIjoxM30.5q3jNzivJq_xDnjA_3UrRqjXpYYSbZAlAP9k5ZYs3i8	2021-10-07 04:46:50.481396
1154	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzQ3MDcsImlhdCI6MTYzMzU4MjcwNywic3ViIjoxM30.FQ5p9DbfKM9QP9w6xDw9Sxgg76jrvrPxu1w_978cWuA	2021-10-07 04:58:44.614075
1155	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzQ3MzMsImlhdCI6MTYzMzU4MjczMywic3ViIjoxM30.9h8asgu6NnHB6QwEJbowasr74LzJ-Ffwq9FBrENnnZo	2021-10-07 05:03:40.443491
1156	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzUwMjYsImlhdCI6MTYzMzU4MzAyNiwic3ViIjoxM30.QNlDF_DDFSWTo5ZcoiQ6t70cSylVWlZ4CF0RfYBSHQ8	2021-10-07 05:04:07.095638
1157	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzUwNTUsImlhdCI6MTYzMzU4MzA1NSwic3ViIjoxM30.g395XDvIl4p9T4L1qlqjvIAv8Ixt7U8tB6hYoCfGlP0	2021-10-07 05:04:20.916986
1158	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzUwNjQsImlhdCI6MTYzMzU4MzA2NCwic3ViIjoxM30.rplysVy56wiZOpWyZgrDOJ5EBJllLaPn-Jy66Mfjvsc	2021-10-07 05:04:44.084406
1159	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzUzNzUsImlhdCI6MTYzMzU4MzM3NSwic3ViIjoxM30.RYLZr6gKsWFts8JT1llkrzfG3O8pSfL8w0YvXojPHd4	2021-10-07 05:09:47.404074
1160	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzU0MDYsImlhdCI6MTYzMzU4MzQwNiwic3ViIjoxM30.0jytOpiX152nwSrKebETAtH6TCZ6QtMj1V9bMzK0CPM	2021-10-07 05:12:49.7374
1161	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNzU1NzgsImlhdCI6MTYzMzU4MzU3OCwic3ViIjoxM30.IH3CV--uyAfFtgctMwyraAQHDDYhlPe9zLgVbByg0vo	2021-10-07 05:13:33.172775
1162	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2Mzg1Mzk4ODIsImlhdCI6MTYyOTgxMzQ3Nywic3ViIjoxM30.uLtnu9V4l6xFxi2MN9wwRBr05gTOqx5TG73ZSDdWltI	2021-10-07 07:19:31.442277
1163	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxODMxOTEsImlhdCI6MTYzMzU5MTE5MSwic3ViIjoxM30.WW6PE4kShTihobVvYpWjuV7-IPMBkc7dE4FdaCm8_cU	2021-10-07 07:20:40.873246
1164	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxODQyODIsImlhdCI6MTYzMzU5MjI4Miwic3ViIjoxM30.-2KTm9yN7fG0OyrIKmIWs-xp2xVfKpq7-8bQ1v4Q1H0	2021-10-07 08:33:38.458237
1165	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxODc2MjksImlhdCI6MTYzMzU5NTYyOSwic3ViIjoxM30.RZVeTwkn4QrDX9A6c1BceGbc860mk4db4Eh-AMj-498	2021-10-07 09:07:50.611516
1166	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxODk2NzMsImlhdCI6MTYzMzU5NzY3Mywic3ViIjoxM30.4coUAKoq1C4Pncxs3kuIljnNS_2INot-rsUqXC7xm24	2021-10-07 09:21:50.348743
1167	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTA1MTMsImlhdCI6MTYzMzU5ODUxMywic3ViIjoxM30.GAyrm1B2C3IYM9rSfIyuL-86EmrcyIYw1B1YxMNzdE0	2021-10-07 09:42:07.11668
1168	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTE3MzgsImlhdCI6MTYzMzU5OTczOCwic3ViIjoxM30.IPDBScncUnLlyNUWvAQtTiwFsT2sZfB0d0B35cKmClg	2021-10-07 09:42:24.983645
1169	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMjc5MTgsImlhdCI6MTYzMzUzNTkxOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.6m5o_w8x6gf_QGR_XFI_Q2Yyj8TL3-SaKBjv1Mem7vw	2021-10-07 09:44:42.01009
1170	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTE4ODgsImlhdCI6MTYzMzU5OTg4OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.pX1jhqNqJ4vXn4wgtQLoQ_7VT07N40UJ86qOSAVE7tw	2021-10-07 09:57:03.062456
1171	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTIwNTIsImlhdCI6MTYzMzYwMDA1Miwic3ViIjoxM30.cbMbPq1Fkr4ICJQYad09kWjHeKelka4qBvCdmhAzSrA	2021-10-07 10:26:22.58324
1172	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTQzODcsImlhdCI6MTYzMzYwMjM4Nywic3ViIjoxM30.DQ1fIGmyQx_Hc7M4AA3NQJTeXdkasXPuNGbNfe33pK8	2021-10-07 10:28:08.579903
1173	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTQ1MDUsImlhdCI6MTYzMzYwMjUwNSwic3ViIjoxM30.xWlkfYUkQzFP2Mu2auHPAONJyxH5KsYa_voPTSYhFlA	2021-10-07 10:30:48.163601
1174	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU1NDYsImlhdCI6MTYzMzYwMzU0Niwic3ViIjoxM30.U7yq0qD5lbCZSyU-8tNtBe0C1ANvUYvpJOzbuNvgRcg	2021-10-07 10:45:48.029961
1175	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU1NjAsImlhdCI6MTYzMzYwMzU2MCwic3ViIjo0fQ.v0Guc8BP_LA4NdoRl0FaUBDYDmrufGEbVh9tjAEhGr0	2021-10-07 10:46:06.104446
1176	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU1NzcsImlhdCI6MTYzMzYwMzU3Nywic3ViIjo0fQ.8IXp44hXrGU9lcVFfxXIpoN8vpA9jwWKgN6_qTHov-Y	2021-10-07 10:46:23.946978
1177	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU3MDgsImlhdCI6MTYzMzYwMzcwOCwic3ViIjo0fQ.LEtcQdi3b3_i2Cb7nbMYDQZ8DJGn8K6LSQFHFFvOUzA	2021-10-07 10:48:31.852909
1178	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU3MTcsImlhdCI6MTYzMzYwMzcxNywic3ViIjo0fQ.Uh6Ll-InHudabf62wfskW5vCChJeZ4kBE3cEVoIrPvw	2021-10-07 10:48:43.235889
1179	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU3MjcsImlhdCI6MTYzMzYwMzcyNywic3ViIjo0fQ.PZn68f-ZjAWoiBDZglyn7LKrhm55bzkpC4PfcTvjSro	2021-10-07 10:48:49.668963
1180	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTI2MjgsImlhdCI6MTYzMzYwMDYyOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.fRbUDDQ-QP6agGT06fWJaF_m8PeKaQOzUxI0CQoPDpY	2021-10-07 10:50:20.623324
1181	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU4ODksImlhdCI6MTYzMzYwMzg4OSwic3ViIjoxMn0.vOKX7fq3hvrw9YyzitfgtqDQcBrBzF_QV8YCCsoK39E	2021-10-07 10:51:34.105017
1182	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTYwMTAsImlhdCI6MTYzMzYwNDAxMCwic3ViIjoxMn0.WZCh82beVcfRUqFeR5ugMpwAf60GWtgZ4agbRN85ROw	2021-10-07 10:53:33.183817
1183	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYwMjg5NTgsImlhdCI6MTYzMzQzNjk1OCwic3ViIjoxM30.momKVCnogavuRBJsc9-TJeQVJiT2e7wNET9iXc83N8Y	2021-10-07 11:11:43.641966
1184	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTYxMTgsImlhdCI6MTYzMzYwNDExOCwic3ViIjoxMn0.Qdcm4cISjdjN9CmojnZmI1wVUY-3mScgjd1vM6QOESQ	2021-10-07 11:13:07.204214
1185	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTcxOTgsImlhdCI6MTYzMzYwNTE5OCwic3ViIjoxM30.SLJEMJP7URSGawqf6zwC2aZP_qyyUCucx526xSFXNKU	2021-10-07 11:42:27.847534
1186	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxOTU4MjYsImlhdCI6MTYzMzYwMzgyNiwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-NbwlZGj74d-eguQHxyJ5nzHkCnEU8PYNghYqCw9vrw	2021-10-07 12:53:37.553885
1187	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDM0MzcsImlhdCI6MTYzMzYxMTQzNywic3ViIjoxMn0.EKSzc_tjBsOuzKpAwsDLQilIf9faa3-HeK9fBWjAqJc	2021-10-07 13:00:00.768611
1188	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDM4OTQsImlhdCI6MTYzMzYxMTg5NCwic3ViIjoxMn0.kthKTDi0D6hz9Jo828e9lS9YWm5nNIAoXXs0f8EsTek	2021-10-07 13:04:57.224775
1189	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDUyMDIsImlhdCI6MTYzMzYxMzIwMiwic3ViIjoxMn0.vpkKibKmLrHbmQs-0Sr0Dsz4WFDFSHsNaOFKdmnRYPA	2021-10-07 13:27:33.499683
1190	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDU2ODEsImlhdCI6MTYzMzYxMzY4MSwic3ViIjoxMn0.nHpk2xQH_ntQcAeNUylg6297-BMwmlhcUPDeywRWdOo	2021-10-07 13:34:55.574887
1191	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDU4MzcsImlhdCI6MTYzMzYxMzgzNywic3ViIjoxNH0.xvSW4JrxVD2g74jumhwfTnTza4SNCNUt4NK55p4eXdY	2021-10-07 13:37:22.332887
1192	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDU4NjcsImlhdCI6MTYzMzYxMzg2Nywic3ViIjo0fQ.DKLR2kRN3fyRapfbahEuHfZO0Kw0QSq8OuwsOF5G6dQ	2021-10-07 13:50:48.300219
1193	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDY4MjIsImlhdCI6MTYzMzYxNDgyMiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.2MfvRjKd3HGPQm6fgEXfsOBYjxPZayDf0iQwk3uaHgA	2021-10-07 14:01:52.677163
1194	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDczMTgsImlhdCI6MTYzMzYxNTMxOCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.g0YPo_tmDNd0jqweqjJ_s3iGMS5KrU6SRWDUt4o5K90	2021-10-07 14:12:19.397232
1195	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDczOTcsImlhdCI6MTYzMzYxNTM5Nywic3ViIjo0fQ.RsKgQV4jJX87wTJmeMYjDyco-naKs5LM5lyiHGc3KfE	2021-10-07 14:14:09.861462
1196	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDMyMjMsImlhdCI6MTYzMzYxMTIyMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qNoJaHY1B6TGC4Q0Z5lx8cwI_XIvyKvMA8yEFKuFTSU	2021-10-07 14:20:09.15386
1197	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDY4MDUsImlhdCI6MTYzMzYxNDgwNSwic3ViIjo3fQ.UGUjmeuOHd9MJFXL8umNuR9-HPaHtjP1ccLbvjGhPdE	2021-10-07 14:22:08.880957
1198	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDc5NDUsImlhdCI6MTYzMzYxNTk0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.yclsGgyd8I9pdoM1-4QH0jM3Ae802HHE4KwvahI_VaY	2021-10-07 14:25:33.818212
1199	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDgyODcsImlhdCI6MTYzMzYxNjI4Nywic3ViIjo0fQ.hjZQFSBGlM817VZn3ZMdMGHrlDWdn9AQOXDvurDM9M8	2021-10-07 14:28:56.404662
1200	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDg5ODksImlhdCI6MTYzMzYxNjk4OSwic3ViIjo0fQ.33scRgu6XEL25-5UaH8Miy3gjYKL9YKdd0iypvq5Fuk	2021-10-07 14:29:58.268051
1201	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDkwNjYsImlhdCI6MTYzMzYxNzA2Niwic3ViIjo0fQ.-ZcIc5D8FuXKW1wxVyxv0a-7twlBS_jlTpvy8Q3X5qs	2021-10-07 14:31:11.83684
1202	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDg3NDMsImlhdCI6MTYzMzYxNjc0Mywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.KqeB0Y7rsYhPe86K6wN7JLm4WC8XnvehTE7On7X-txk	2021-10-07 14:59:38.294091
1203	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxMTYyMTcsImlhdCI6MTYzMzUyNDIxNywic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.CKGiRMiiwNffyPYHb3Ul1fkl6--amapJBPIKZ0BaDm0	2021-10-08 04:50:15.687497
1204	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNjA2MjgsImlhdCI6MTYzMzY2ODYyOCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.QnRi-3cNeW-S-XiFz2lQCHOUcJB8eiK63ugaxEjjdv8	2021-10-08 04:51:00.897016
1205	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzI1MTMsImlhdCI6MTYzMzY4MDUxMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.UDzp8Eb_ZRt5Siuu0bqUkXMKxujNB3jn7xJ-JS-VkRk	2021-10-08 08:14:46.123178
1206	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzQxOTUsImlhdCI6MTYzMzY4MjE5NSwic3ViIjo3fQ.Oss7Il_87qhLeSrSar2JFwhuQUSIYaWkqWeqA7xKRG8	2021-10-08 08:36:48.61357
1207	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzQyMjQsImlhdCI6MTYzMzY4MjIyNCwic3ViIjo3fQ.8UVZHCyZhuHCXRNT-sdRQhvlvWWs_n45bQmqepZvBQQ	2021-10-08 08:37:11.852587
1208	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzMzNjIsImlhdCI6MTYzMzY4MTM2Miwic3ViIjo3fQ.0SSvA878gQZDyOqZ50_Svs9PiURgL5pzCK-znwRb3oc	2021-10-08 08:46:26.330122
1209	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyMDg0MzMsImlhdCI6MTYzMzYxNjQzMywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.oVdpmvaYlL32IDc6S4Y6IMTL7M3iCGQvHBIPl1Z2Bgw	2021-10-08 09:27:38.66766
1210	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzQ3OTgsImlhdCI6MTYzMzY4Mjc5OCwic3ViIjo3fQ.IJ_2BLQAti5PC7dHzFlUC5l3brDoLBUMLp5ZpK54Nyo	2021-10-08 09:34:56.904169
1211	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzcyNjQsImlhdCI6MTYzMzY4NTI2NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.l6_8jjeIkzD7HEhGHsnwXWyHU88mICzWgF9buhWvLqA	2021-10-08 09:40:33.539573
1212	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzg3MzgsImlhdCI6MTYzMzY4NjczOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.05FHX3q-E7yEFMJlfRwUHSJf16Du3A-Q8PLDEPoj7Ms	2021-10-08 09:53:16.08087
1213	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzA4NzQsImlhdCI6MTYzMzY3ODg3NCwic3ViIjo0fQ.gel3z7mJDuZzDbUuY4cbHy0LtlZpdhaQ-RSfio6z9sE	2021-10-08 10:18:14.875599
1214	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODAzMDIsImlhdCI6MTYzMzY4ODMwMiwic3ViIjo0fQ.eJqUCRqUTF7_SY7Rgpsn-86FwbJ6Pu6hfnhi0FtMhRQ	2021-10-08 10:21:34.051745
1215	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNjYwNjMsImlhdCI6MTYzMzY3NDA2Mywic3ViIjoxM30.ioQ3uei_IMbKXxw9Q_DFLNoXNjpjHQNgfJ1IIQBhd58	2021-10-08 10:22:18.712933
1216	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzc3MDYsImlhdCI6MTYzMzY4NTcwNiwic3ViIjo3fQ.IC47yHFFr_FvglV9jgdFq7vZebX4EhJGu5tcp_RVZBM	2021-10-08 10:25:22.819654
1217	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA4NDAsImlhdCI6MTYzMzY4ODg0MCwic3ViIjo3fQ.i-Tjg9kycF1dadw2nl8DY01MIgD8UvfVQe51b7qggCg	2021-10-08 10:27:47.276898
1218	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA5MTEsImlhdCI6MTYzMzY4ODkxMSwic3ViIjo3fQ.k1SzDd1DxgOP2vNyudvL5N60L8vVP27eJI2tx4APXpg	2021-10-08 10:28:40.63096
1219	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA5MjQsImlhdCI6MTYzMzY4ODkyNCwic3ViIjo3fQ.qJt5f8qGc1PQnTkOZGmIZq25LHZcsS8IA_UBcKmM9nM	2021-10-08 10:28:55.712484
1220	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA1NTUsImlhdCI6MTYzMzY4ODU1NSwic3ViIjo0fQ.d6t0t0qcWEpf3x0Hyo4sSsasxUVSavez9DLJWLW8ntE	2021-10-08 10:32:43.632758
1221	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA0OTgsImlhdCI6MTYzMzY4ODQ5OCwic3ViIjo0fQ.7chGx8nBaQJfKMD6waPjHHyIqlQaFCREGNAMUwJQ4uw	2021-10-08 10:49:49.048523
1222	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzI4OTIsImlhdCI6MTYzMzY4MDg5Miwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.ojreGWbNLTulR-U7htMhupJ4Qc9t4GZdKFq3sEOQ1Ao	2021-10-08 11:07:46.200733
1223	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODIyMDAsImlhdCI6MTYzMzY5MDIwMCwic3ViIjo0fQ.vcssvjNkBIyYhj51T__B8yYAZ4FWE9dPPKLPAJiQCDc	2021-10-08 11:09:01.377395
1224	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODMyNzIsImlhdCI6MTYzMzY5MTI3Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.VWgopeEUh4LWfrjffBPcakNStyrqwnDGVgmA90t5s_A	2021-10-08 11:09:02.388813
1225	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODMzNDYsImlhdCI6MTYzMzY5MTM0Niwic3ViIjo0fQ.qsyHxSp1caDnBmyacPma0u3qy01ULQo0y6RxWpTH2MM	2021-10-08 11:09:18.697136
1226	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODMzNDksImlhdCI6MTYzMzY5MTM0OSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.5sEeCIt7XRd7PnXRjbfTDhVFlV-rp9IPR6jJo5yG-n8	2021-10-08 11:16:18.694006
1227	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODM3OTAsImlhdCI6MTYzMzY5MTc5MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.6hjYPnbSnazQpos549QdFuegXHJRl3PRP0YcSDuTzDo	2021-10-08 11:17:53.902677
1228	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNzgwMzgsImlhdCI6MTYzMzY4NjAzOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.LXiSquWFilu0xju6Wb97RG7ZdtF8IMDPNcx9AOo08PA	2021-10-08 11:42:34.700037
1229	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODMzNjQsImlhdCI6MTYzMzY5MTM2NCwic3ViIjoxM30.lfAroOVoALSVcB5rzK8JciAARXz0CLoIbuSTR_YTK-s	2021-10-08 11:45:30.295068
1230	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODU1MzMsImlhdCI6MTYzMzY5MzUzMywic3ViIjoxM30.H0l7ItpCvvkixmkBTDjcstzcCpAlDglEor9Pl7AzjNM	2021-10-08 11:59:05.451582
1231	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODg5NjIsImlhdCI6MTYzMzY5Njk2Miwic3ViIjoxM30.jMKCXW5kCzZSpS86CY9IfnRmbBQTZnSnkMHWIkrO4T4	2021-10-08 12:43:02.045525
1232	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODkwODEsImlhdCI6MTYzMzY5NzA4MSwic3ViIjoxM30.j3TskEhRjjYIcvoHfJ9dGrAMCeXi8XJAbOWE3AAdUtk	2021-10-08 12:53:05.472127
1233	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODM4NzksImlhdCI6MTYzMzY5MTg3OSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.EycJxyMLq9Y82wgMiJrjctcv3o0KcUelWCX_8pi5fmQ	2021-10-08 12:55:50.964242
1234	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODExNzEsImlhdCI6MTYzMzY4OTE3MSwic3ViIjo0fQ.ASscsnzMa-k7z3Gb58N5ci93_Pn4vFHXurVK8Q5Spb4	2021-10-08 13:01:15.143719
1235	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODk3NjAsImlhdCI6MTYzMzY5Nzc2MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qEhMbDjrYwhS0fC8i8xv6rNZmRZ8C9aTcfEHCgg1S_A	2021-10-08 13:09:51.696705
1236	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODA5MzksImlhdCI6MTYzMzY4ODkzOSwic3ViIjo3fQ.JQBz7pF3Wib1hZ0T3UNXdlkI3MPwGdXBOreXV81-iQM	2021-10-08 13:20:14.106301
1237	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyOTEzNTIsImlhdCI6MTYzMzY5OTM1Miwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.H8twxplczBjCs9I7c271UJIu8s3Fh_TE89G9LwZBuRA	2021-10-08 13:37:24.44931
1238	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyOTIyNjcsImlhdCI6MTYzMzcwMDI2Nywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.dS4JkFwnQL2Oi-XUgvvIF77D4BD6d81XK3K4z67tvgc	2021-10-08 13:47:47.282941
1239	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyOTI4ODYsImlhdCI6MTYzMzcwMDg4Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.52OB-dkWHVJwo6kPzWuxFboXEyh4nWNSBOhf7sNOuFw	2021-10-08 13:48:35.327159
1240	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxNDEzNzUsImlhdCI6MTYzMzU0OTM3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kzCwz60UZjvbp74q071p68kSJ51_D2QwpiZ4666TIdc	2021-10-08 20:51:23.528547
1241	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyNjE1ODgsImlhdCI6MTYzMzY2OTU4OCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.dZYO1rcVI88IsEhg_I8ViEe7he-HwjSyiqtcRINYL-M	2021-10-11 02:00:53.548556
1242	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MDk2NzUsImlhdCI6MTYzMzkxNzY3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.R7q4I1aU6Tmhunm3tPaEJoQFXLVWD8giNsmJvsVtyVU	2021-10-11 02:24:08.643345
1243	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MTEwNTYsImlhdCI6MTYzMzkxOTA1Niwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.uI_g4RJwMEJr5o2e8GtVHk-saxp_Hzb8lK1nSWi3j_k	2021-10-11 02:24:57.533057
1244	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MTExMDYsImlhdCI6MTYzMzkxOTEwNiwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.dktrN0dt4SVXAXFvraWGLviPMNLRrX0Y8sJEh11jmpM	2021-10-11 02:25:27.783231
1245	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MTExNDUsImlhdCI6MTYzMzkxOTE0NSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.8FFT4eNxNu_5UCEBV_6luvd50tSkW22gO1apYL2mSqs	2021-10-11 05:14:51.307235
1246	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MjEwNTAsImlhdCI6MTYzMzkyOTA1MCwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.vgGHRHUw2jy2zwr0Kn03ayvqKO93w73bdis2Qvq0n84	2021-10-11 05:19:46.650235
1247	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyODUzNTksImlhdCI6MTYzMzY5MzM1OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.skC7AIqO1vHfenxTH0Ic8PNr1Z2lsbw8-xoPd2YLYlE	2021-10-11 05:24:10.224138
1248	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYxODM2MzcsImlhdCI6MTYzMzU5MTYzNywic3ViIjoxM30.ME2JZe4dC7lgEsWS3963maxbxjx8lghxJTkTEQ9j6A4	2021-10-11 05:27:37.873926
1249	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MzIwMjYsImlhdCI6MTYzMzk0MDAyNiwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.APOaHrF8YpfyMZ_5r7yTgP823xPD4iMpvYwxisyCgpw	2021-10-11 08:15:05.462912
1250	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MjE4NTcsImlhdCI6MTYzMzkyOTg1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ._9ypj8GBMa-TLCnVyPDxXbjsVC2QUGmZz8RUhklY0ZA	2021-10-11 09:46:30.605231
1251	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1Mzc1OTUsImlhdCI6MTYzMzk0NTU5NSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.KrL1MwIj3Yy7dar0-xj9JfiggPmX_-h3B-MuAPYHQWE	2021-10-11 09:56:54.360719
1252	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzQ3NDU1MTQsImlhdCI6MTYzMjE1MzUxNCwic3ViIjo5fQ.VESuguLQEm2zDKJga9fP9Gx8uz4D58KtILTPQ3PeQ74	2021-10-11 15:54:19.436522
1253	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1NjE4NTEsImlhdCI6MTYzMzk2OTg1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.xLD5YzvXpg9AxjdXz2A2YLG-H-hCaskqLVPeN7yLuWw	2021-10-11 16:31:18.325875
1254	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzUzNjAyNzMsImlhdCI6MTYzMjc2ODI3Mywic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.DLwC6z1OVA1U0B_979mj8_BlK_xQkTBNPl5EF0pxDr8	2021-10-11 18:19:30.329308
1255	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1NjgzOTgsImlhdCI6MTYzMzk3NjM5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.C-9aTdhEzEX221A88HXu-i4kcxLbMuh8j3EyQkBlhuk	2021-10-11 20:13:58.44567
1256	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MDY5NzUsImlhdCI6MTYzNDAxNDk3NSwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.CdFl02UwJDaYo9nO1y-b-b9slI-PZNis5ZG9N3an7_s	2021-10-12 05:17:30.158004
1257	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MDc4NTQsImlhdCI6MTYzNDAxNTg1NCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.BtEog9tpKOwSYTiF99LdYKxkVA4_G9uU6aES86wsrHw	2021-10-12 05:51:04.341468
1258	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MDk4NzAsImlhdCI6MTYzNDAxNzg3MCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.AFdCNvom5a_W-5LDlUfzdlZG4UurKCMkFZNkmTwuxQk	2021-10-12 05:51:54.547546
1259	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MDk5MjQsImlhdCI6MTYzNDAxNzkyNCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.ItMPHalW-0CbP5N6b5oGrZjY7xi11Wq-0x84Hdg0aHE	2021-10-12 06:24:20.031307
1260	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MTE4NjQsImlhdCI6MTYzNDAxOTg2NCwic3ViIjoxLCJyb2xlIjoic3VwZXJ2aXNvciJ9.K-cau-NHj5R-IY5an7pkpFB97OKJjvh6PPux73_SOUg	2021-10-12 06:55:32.230363
1261	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MTM3NTEsImlhdCI6MTYzNDAyMTc1MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.et2G-3xZIzYaahsGrB8npe2Np0hOEGVaom5ghwXNRpw	2021-10-12 06:57:56.350778
1262	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MTM4ODQsImlhdCI6MTYzNDAyMTg4NCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.7D7J1pxwerYYpLHykJ1_6l5ksTacrIkcungobcEExFw	2021-10-12 06:59:50.470779
1263	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2Mzg5NzcsImlhdCI6MTYzNDA0Njk3Nywic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.-Z_-RLaFmvAFiZkIm1jgVkgqsX3BBQ9CXAmbYciH2Do	2021-10-12 13:59:51.986222
1264	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2MzkxOTgsImlhdCI6MTYzNDA0NzE5OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.bpuxwX17DH-JyQQPg-wGPhfwvD05F05oOqdqv5ra1tU	2021-10-12 14:05:28.317033
1265	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1MzgyMjAsImlhdCI6MTYzMzk0NjIyMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.0WT5cpDnH7cPkr-oaRpt_T3qR3o15hzJj6XT3-yyXsA	2021-10-12 14:49:11.627431
1266	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NDIxNTgsImlhdCI6MTYzNDA1MDE1OCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ._dkno9WtLRqufhBqcO8PQiKRNx4REmADpo9tS-re5GU	2021-10-12 14:50:38.755591
1267	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY1NzUyNTUsImlhdCI6MTYzMzk4MzI1NSwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.cNnJnllqGDgODSnVxgPrvcFHUNqOouQCI3MNVA9Y-Ws	2021-10-12 16:50:21.486428
1268	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTQyNjMsImlhdCI6MTYzNDA2MjI2Mywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.RYOrgOK72QmOdM5_8rQv_Umsfd0_1Ti5MdagERwV_dk	2021-10-12 18:24:18.340199
1269	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NDk2MzEsImlhdCI6MTYzNDA1NzYzMSwic3ViIjoyNiwicm9sZSI6Im1lcmNoYW50In0.2miuBxHgWn1cdXUrP3QGbHk_jlEAUla4SFpzV9G0cEU	2021-10-12 18:50:54.51836
1270	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTY2NjAsImlhdCI6MTYzNDA2NDY2MCwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.nLQb1o78RP7N2mzGFoV6p31lmscFlrpJpAW-6CDrMMY	2021-10-12 19:16:05.822248
1271	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTUwODgsImlhdCI6MTYzNDA2MzA4OCwic3ViIjoxOCwicm9sZSI6Im1lcmNoYW50In0.sg0pa9RceB6F4CkFc5z1wnOuAzP12mbuouvROFqk_GE	2021-10-12 19:16:46.552344
1272	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTgxNzcsImlhdCI6MTYzNDA2NjE3Nywic3ViIjoxOSwicm9sZSI6Im1lcmNoYW50In0.aj6wS9X5c0KL_sRDgb4a2QjIwiUfZNgxCbo7ZwHjKfs	2021-10-12 19:16:52.575444
1273	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTgyMTAsImlhdCI6MTYzNDA2NjIxMCwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.-Vf_gtVqe7AYyN8CFli-myQgjwfjpW5sZu-MfK47nsM	2021-10-12 19:34:18.941003
1274	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NTc4ODcsImlhdCI6MTYzNDA2NTg4Nywic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.P1Np1ikbzloq0rR2N3fQs4NDEGBpC1T94J1WJzMDeUA	2021-10-12 20:03:24.306532
1275	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2NjEwMTAsImlhdCI6MTYzNDA2OTAxMCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dYi_Qp_jzI6o2kUED3mbXBxV-iDafsjXqrB0aPj10_A	2021-10-12 20:06:12.765391
1276	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY2OTc2NDAsImlhdCI6MTYzNDEwNTY0MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.A5kvSXitQyu86cm3ExHTgM11IxVVJkbfR7tLgLGxQ8E	2021-10-13 09:23:12.415216
1277	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3MDg5OTksImlhdCI6MTYzNDExNjk5OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.SEhvTkpnlDHk0RfDK_g21m9SQCs-Hg9LEzgGy-rRcWY	2021-10-13 09:24:46.634613
1278	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyOTAyOTAsImlhdCI6MTYzMzY5ODI5MCwic3ViIjoxM30.ROLpF-DAas1GaAhjatsHSEy-0He_zgh8xzZLxPS2Iq4	2021-10-13 12:40:13.625349
1279	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzU2NjgxNzksImlhdCI6MTYzMzA3NjE3OSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.4Iu9R4jzJvcTBmvryB_mEdRb9In24F6Rn9NCi_VC0Wc	2021-10-13 14:00:55.420794
1280	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3MjU2NjEsImlhdCI6MTYzNDEzMzY2MSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.2FcW2gHh9Y6DlN8yptrKd3EW4KG4DcLrm_DgatJ4PE8	2021-10-13 14:10:30.835492
1281	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3MDkwOTQsImlhdCI6MTYzNDExNzA5NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.22Z0wl6FNhKcYo-O6pweH6TGWVI65e0yrcWh-k5SGFs	2021-10-13 16:28:24.476446
1282	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3MzQ1MjEsImlhdCI6MTYzNDE0MjUyMSwic3ViIjoxLCJyb2xlIjoibWVyY2hhbnQifQ.W30HrTpg487rEc-ouM0QX14fRJzO-3Y8VB13nHUUpyw	2021-10-14 06:12:53.411859
1283	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3ODE4MjUsImlhdCI6MTYzNDE4OTgyNSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.IHL8sYYYt_4fRLXr5fr6KplJeZKvpGIIrkCCpEFjLIo	2021-10-14 06:40:58.133827
1284	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3ODU3NDUsImlhdCI6MTYzNDE5Mzc0NSwic3ViIjoyNywicm9sZSI6Im1lcmNoYW50In0.GkMSiuow1nexdYQySFIN4bHMYLy2i2tanvGqb7P7JWY	2021-10-14 06:42:53.689741
1285	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3ODM5ODAsImlhdCI6MTYzNDE5MTk4MCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.wY-EPfRArMTKs8XA_KolammVgWaiJZ8Acu2Wy3yvpj8	2021-10-14 10:49:23.71718
1286	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY4MTI0ODEsImlhdCI6MTYzNDIyMDQ4MSwic3ViIjo1LCJyb2xlIjoibWVyY2hhbnQifQ.swGRGWSmNip6QBy1BpJ6vkIGpINY3ZuchUYVJfl7TzI	2021-10-14 14:08:32.723977
1287	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY4ODIxNTcsImlhdCI6MTYzNDI5MDE1Nywic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.GSBnlS0geSiqSBovjMM6SuvTT8Ho17AD57BlfboxBhM	2021-10-15 09:57:49.750106
1288	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY4ODQwMDEsImlhdCI6MTYzNDI5MjAwMSwic3ViIjoxLCJyb2xlIjoiZGlzdHJpYnV0b3IifQ.2mbEOQnr9OtTohjQtWFF_80Cgh1nbOBPUPFbZN1WfXo	2021-10-15 10:09:55.575154
1289	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY5ODIxODksImlhdCI6MTYzNDM5MDE4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.qx953-6535I8cVyKCNU9DJoNNUiGkbo9-KuThWFgU3E	2021-10-16 13:16:40.946773
1290	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY5ODQwMjgsImlhdCI6MTYzNDM5MjAyOCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.XoaGQOxzZ0NIfj3InF9T8ghbmWuoZpcedmtmofhBXEE	2021-10-16 13:47:16.41569
1291	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY5ODQwNDQsImlhdCI6MTYzNDM5MjA0NCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.kGQ3Ozcn1Yy20aljSQIhFJoKboQpeoFZyWM3XBrMvRE	2021-10-16 13:47:34.133418
1292	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY5ODQxNDgsImlhdCI6MTYzNDM5MjE0OCwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.dS8BaTMpX62xEOpmK6k0eok5MEAdvXzPCip1J2hWPzM	2021-10-16 13:49:22.41795
1293	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY5ODQzODksImlhdCI6MTYzNDM5MjM4OSwic3ViIjoxLCJyb2xlIjoic3VwZXJfYWRtaW4ifQ.Od0QECUUFhXGCNh0Z4zZL6D9vIsi0GW56d0JKrCc8O0	2021-10-16 13:53:16.248901
1294	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzYyOTgwMjAsImlhdCI6MTYzMzcwNjAyMCwic3ViIjoxM30.j18dlDlmc-GX7maQ68P8ATvw7_lQi_01HyEMfQ-poC0	2021-10-17 15:18:59.286784
1295	eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJleHAiOjE2MzY3MjA4MTYsImlhdCI6MTYzNDEyODgxNiwic3ViIjoxM30.c3go5sclp853Cq1GElJmyq9AjqX4qWum_Uoa3tAcSkI	2021-10-17 15:21:38.786642
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categories (id, name, image, status, created_at, deleted_at, updated_at) FROM stdin;
14	Meat & SeaFish	saas/category/default.png	1	2021-08-25 09:29:14.023915	\N	2021-09-02 19:18:17.635953
23	Generic Category	saas/category/default.png	0	2021-09-23 13:07:48.008992	\N	\N
3	Home & Decor	saas/category/default.png	0	2021-07-12 14:38:26.49094	2021-07-13 01:30:44.975928	\N
5	fh	saas/category/default.png	1	2021-07-25 01:29:07.711839	2021-07-25 02:32:32.722119	2021-07-25 02:31:02.481255
22	Clothe	saas/category/default.png	1	2021-09-16 18:31:57.927248	\N	2021-09-29 10:49:52.225083
6	dummy	saas/category/default.png	0	2021-08-01 17:05:58.792802	2021-08-22 14:31:45.034745	2021-08-07 08:36:27.481896
8	cosmetics	saas/category/default.png	0	2021-08-02 07:32:29.798076	2021-08-23 18:09:35.426883	2021-08-07 18:26:47.666211
10	Test2	saas/category/default.png	0	2021-08-24 09:14:10.008971	2021-08-24 09:14:22.680586	2021-08-24 09:14:18.720872
4	Fruits & Vegetable	saas/category/category_icon_Vql3i05tbO_1620316476.png	1	2021-07-14 06:02:48.418681	\N	2021-09-23 14:11:39.443902
19	Electric Product	saas/category/default.png	1	2021-08-27 05:33:52.479449	\N	2021-08-30 06:23:37.416324
26	Toys	saas/category/default.png	0	2021-09-30 06:37:58.105643	\N	2021-09-30 06:38:16.815327
12	test	saas/category/default.png	0	2021-08-24 20:53:10.427356	2021-08-24 20:53:16.161714	\N
2	Meat & Fish	saas/category/category_icon_0SjK6FvnB5_1620316485.png	1	2021-07-12 14:38:11.677763	2021-07-21 15:10:36.295791	2021-07-14 05:14:31.540556
11	Meat & Fish	saas/category/category_icon_0SjK6FvnB5_1620316485.png	0	2021-08-24 12:09:34.452799	2021-08-24 12:10:12.532726	\N
20	Just now	saas/category/default.png	1	2021-08-27 18:02:09.432124	\N	2021-08-31 07:05:41.722675
15	Electric Products	saas/category/default.png	0	2021-08-27 05:07:35.916427	2021-08-27 05:24:20.169527	2021-08-27 05:24:12.69798
16	ioio	catImage	0	2021-08-27 05:29:34.609642	2021-08-27 05:29:40.434555	\N
18	bbbf	catImage	0	2021-08-27 05:32:46.359751	2021-08-27 05:33:27.932379	\N
17	hkkhhkh	catImage	0	2021-08-27 05:31:04.030034	2021-08-27 05:33:36.932073	\N
24	new oneTwo	saas/category/default.png	0	2021-09-28 05:11:15.032763	\N	2021-09-28 07:45:10.487401
9	Gifts	saas/category/category_icon_kLPNBz68KW_1620316515.png	1	2021-08-23 18:09:47.988788	\N	2021-08-30 06:23:41.506201
13	Restuarants	saas/category/category_icon_6lVVCnE1aG_1627119080.png	1	2021-08-25 09:27:54.563653	\N	2021-08-30 06:23:52.80813
21	abc	saas/category/default.png	0	2021-09-01 09:39:18.709278	2021-09-01 09:39:36.17526	\N
7	Books	saas/category/default.png	1	2021-08-02 07:27:44.154073	\N	2021-08-30 06:23:33.576001
25	NewCate	saas/category/default.png	1	2021-09-28 07:05:08.759454	2021-10-06 13:07:12.680284	2021-09-29 10:54:44.325623
1	Daily Groceries	saas/category/category_icon_SqytizT8b9_1620316463.png	1	2021-07-12 14:37:59.225095	\N	2021-10-12 17:07:48.302354
\.


--
-- Data for Name: cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cities (id, name, code, status, help_number, whats_app_number, created_at, deleted_at, updated_at) FROM stdin;
4	gj	gkc	0	44	44	2021-07-19 02:51:09.987484	2021-07-19 02:52:45.881251	\N
3	ggd	gds	0	4545	4345	2021-07-19 02:51:00.647209	2021-07-19 02:53:58.89176	\N
5	Be	Ben	0	07	55	2021-07-24 02:23:34.868726	2021-07-24 05:09:25.239924	2021-07-24 02:24:16.530084
6	Beng	Bengalu	0	070014386	744	2021-07-25 14:51:38.948862	2021-07-25 14:52:35.822328	\N
7	newchange	newcha	0	no	no	2021-07-31 10:44:51.187819	2021-07-31 12:17:08.544594	2021-07-31 12:07:31.12382
11	Chennai	Chennai	1	9998887779	9998887779	2021-08-08 13:40:35.561703	\N	\N
12	Patna	Pat	0	08757445651	9843562136	2021-08-24 12:11:16.237742	2021-08-24 12:12:13.315463	\N
13			0			2021-08-25 01:21:49.139257	2021-08-25 01:21:54.078607	\N
14		af	0	aaag	ag	2021-08-25 01:28:32.349188	2021-08-25 01:28:36.933084	\N
15			0			2021-08-25 01:32:13.328627	2021-08-25 01:32:17.061076	\N
16			0			2021-08-25 01:34:58.252181	2021-08-25 01:35:01.772524	\N
17			0			2021-08-25 02:47:04.310618	2021-08-25 02:47:07.354134	\N
18			0			2021-08-25 02:47:52.660766	2021-08-25 02:47:56.185531	\N
1	Mumbai	MUM	1	8757445651	9843562136	2021-07-12 14:38:49.868337	\N	\N
9	nah	nahhh	0	45	21	2021-08-05 13:33:27.109287	2021-08-06 07:34:18.340474	2021-08-05 13:36:26.546745
19	Kolkata	KOL	1	6567868756	5476576653	2021-08-25 09:35:51.033106	\N	2021-08-25 09:44:01.849164
8	Cuddalore	CUDD	1	123	456	2021-07-31 10:48:29.092766	\N	2021-09-06 07:04:34.292326
22	123	123	0	string	string	2021-09-08 03:43:52.692162	2021-09-08 13:07:40.746375	\N
23	123	123	0	string	string	2021-09-08 03:43:56.343953	2021-09-08 13:07:43.70624	\N
24	123	123	0	string	string	2021-09-08 03:44:51.935368	2021-09-08 13:07:47.192383	\N
2	Bengaluru	bengaluru	1	1234567899	1234567899	2021-07-18 02:57:45.653743	\N	2021-08-11 15:23:05.100585
10	Mysore	mysore	1	9998887779	9998887779	2021-08-05 13:33:29.697664	2021-10-06 13:09:18.862417	\N
25	Mysuru	MYSURu	0	9519519511	9519519511	2021-10-06 13:09:43.750788	\N	2021-10-06 13:12:28.79767
\.


--
-- Data for Name: city_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.city_categories (id, city_id, category_id, status, created_at, updated_at, deleted_at) FROM stdin;
10	6	1	1	\N	\N	\N
12	8	6	1	\N	\N	\N
17	2	4	1	\N	\N	\N
20	1	1	1	\N	\N	\N
21	1	4	1	\N	\N	\N
22	1	6	1	\N	\N	\N
24	8	8	1	\N	\N	\N
25	2	8	1	\N	\N	\N
26	1	8	1	\N	\N	\N
27	2	7	1	\N	\N	\N
28	11	6	1	\N	\N	\N
29	11	7	1	\N	\N	\N
30	11	8	1	\N	\N	\N
23	8	7	1	\N	2021-08-24 09:15:06.664893	2021-08-24 09:15:06.664866
31	12	1	1	\N	\N	\N
32	12	4	1	\N	\N	\N
33	1	9	1	\N	\N	\N
34	1	7	1	\N	\N	\N
35	19	1	1	\N	\N	\N
36	19	13	1	\N	\N	\N
37	19	9	1	\N	\N	\N
38	19	4	1	\N	\N	\N
39	19	14	1	\N	\N	\N
40	2	9	1	\N	\N	\N
42	2	20	1	\N	2021-08-31 06:12:30.072015	2021-08-31 06:12:30.071993
13	2	1	1	\N	2021-08-31 06:40:50.563835	2021-08-31 06:40:50.563813
43	2	13	1	\N	2021-08-31 07:00:21.07603	2021-08-31 07:00:21.076007
44	11	1	1	\N	2021-08-31 07:35:49.938902	2021-08-31 07:35:49.938881
45	8	4	1	\N	\N	\N
46	1	20	1	\N	2021-09-01 09:40:54.355512	2021-09-01 09:40:54.355491
47	1	13	1	\N	2021-09-01 09:41:55.657195	2021-09-01 09:41:55.657175
48	11	4	1	\N	2021-09-01 09:43:16.883153	2021-09-01 09:43:16.883132
41	1	14	1	\N	2021-09-04 04:44:43.516092	2021-09-04 04:44:43.51607
49	2	20	1	2021-09-27 16:00:50.455937	\N	\N
51	10	22	1	2021-09-27 17:47:44.135904	2021-09-27 17:47:49.55207	2021-09-27 17:47:49.55205
50	10	7	1	2021-09-27 17:47:44.128262	2021-09-28 11:19:30.985617	2021-09-28 11:19:30.985598
54	10	7	1	2021-09-27 17:48:01.737775	2021-09-28 11:19:35.761032	2021-09-28 11:19:35.761012
56	10	7	1	2021-09-28 07:34:27.285578	2021-09-28 11:19:40.46907	2021-09-28 11:19:40.469051
59	10	19	1	2021-09-28 11:20:01.389566	\N	\N
60	11	19	1	2021-09-30 08:44:45.683135	\N	\N
61	1	22	1	2021-09-30 09:15:30.401094	\N	\N
62	10	9	1	2021-09-30 09:20:52.135546	\N	\N
63	11	22	1	2021-09-30 09:22:20.868966	\N	\N
52	10	1	1	2021-09-27 17:47:44.140589	2021-09-30 09:39:53.774337	2021-09-30 09:39:53.774318
53	10	22	1	2021-09-27 17:47:55.193667	2021-09-27 17:47:49	2021-09-27 17:47:49
55	10	22	1	2021-09-27 17:48:01.742827	2021-09-27 17:47:49	2021-09-27 17:47:49
57	10	22	1	2021-09-28 07:36:30.526104	2021-09-27 17:47:49	2021-09-27 17:47:49
58	10	7	1	2021-09-28 07:44:14.070386	2021-09-27 17:47:49	2021-09-27 17:47:49
64	10	1	1	2021-09-30 09:42:21.879969	\N	\N
65	10	13	1	2021-09-30 09:48:54.81341	\N	\N
66	11	9	1	2021-10-06 07:21:43.431799	\N	\N
67	11	1	1	2021-10-06 07:22:10.761495	\N	\N
68	11	25	1	2021-10-06 13:06:52.040205	\N	\N
69	25	22	1	2021-10-06 13:10:54.145332	\N	\N
\.


--
-- Data for Name: citymisdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.citymisdetail (id, mis_id, city_id, date, order_canceled, new_locality, new_stores_created, average_order_value, total_order_value, total_discount_value, delivery_fees, commision, turnover, created_at, updated_at, deleted_at, order_delivered, total_tax) FROM stdin;
7	4	1	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.689441	\N	\N	0	0
8	4	2	2021-09-23 00:00:00	1	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.72888	\N	\N	0	0
9	4	8	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.766358	\N	\N	0	0
10	4	10	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.802095	\N	\N	0	0
11	4	11	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.838011	\N	\N	0	0
12	4	19	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.877132	\N	\N	0	0
1	3	1	2021-08-26 00:00:00	0	0	0	3930	3930	80	150	0	4000	2021-08-27 03:10:30.997633	2021-08-27 03:11:19.886103	\N	0	0
2	3	2	2021-08-26 00:00:00	1	0	0	1470	1470	0	150	0	1620	2021-08-27 03:10:31.028335	2021-08-27 03:11:19.915071	\N	0	0
3	3	8	2021-08-26 00:00:00	0	0	0	0	0	0	0	0	0	2021-08-27 03:10:31.05637	2021-08-27 03:11:19.942594	\N	0	0
4	3	10	2021-08-26 00:00:00	0	0	0	0	0	0	0	0	0	2021-08-27 03:10:31.085927	2021-08-27 03:11:19.970721	\N	0	0
5	3	11	2021-08-26 00:00:00	0	0	0	0	0	0	0	0	0	2021-08-27 03:10:31.113173	2021-08-27 03:11:19.996796	\N	0	0
6	3	19	2021-08-26 00:00:00	2	0	0	530	530	0	50	0	580	2021-08-27 03:10:31.140993	2021-08-27 03:11:20.026024	\N	0	0
\.


--
-- Data for Name: coupon_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_categories (id, category_id, coupon_id, status, created_at, updated_at) FROM stdin;
23	1	32	1	2021-08-23 10:27:54.009532	\N
24	4	32	1	2021-08-23 10:27:54.014473	\N
25	1	33	1	2021-08-23 13:52:04.717749	\N
26	4	33	1	2021-08-23 13:52:04.722701	\N
27	1	34	1	2021-08-25 10:14:38.310014	\N
28	14	34	1	2021-08-25 10:14:38.315408	\N
29	9	34	1	2021-08-25 10:14:38.319374	\N
30	4	34	1	2021-08-25 10:14:38.323359	\N
31	13	34	1	2021-08-25 10:14:38.326782	\N
32	7	34	1	2021-08-25 10:14:38.330134	\N
33	1	35	1	2021-08-25 10:16:13.196923	\N
34	14	35	1	2021-08-25 10:16:13.201804	\N
35	9	35	1	2021-08-25 10:16:13.205726	\N
36	4	35	1	2021-08-25 10:16:13.209491	\N
37	13	35	1	2021-08-25 10:16:13.212925	\N
38	7	35	1	2021-08-25 10:16:13.216454	\N
39	13	36	1	2021-08-25 19:00:37.337334	\N
40	1	36	1	2021-08-25 19:00:37.342819	\N
41	7	36	1	2021-08-25 19:00:37.347034	\N
42	4	36	1	2021-08-25 19:00:37.351025	\N
43	14	36	1	2021-08-25 19:00:37.354541	\N
44	9	36	1	2021-08-25 19:00:37.358221	\N
45	13	37	1	2021-08-25 19:05:36.239882	\N
46	1	37	1	2021-08-25 19:05:36.243441	\N
47	9	37	1	2021-08-25 19:05:36.246972	\N
48	7	37	1	2021-08-25 19:05:36.250487	\N
49	4	37	1	2021-08-25 19:05:36.25398	\N
50	14	37	1	2021-08-25 19:05:36.25738	\N
51	7	38	1	2021-08-25 20:42:45.81478	\N
52	9	39	1	2021-08-25 20:46:54.774974	\N
53	1	40	1	2021-09-21 17:09:29.165334	\N
54	4	40	1	2021-09-21 17:09:29.17003	\N
55	7	40	1	2021-09-21 17:09:29.17371	\N
56	9	40	1	2021-09-21 17:09:29.17751	\N
57	14	40	1	2021-09-21 17:09:29.181124	\N
58	13	40	1	2021-09-21 17:09:29.184726	\N
59	19	40	1	2021-09-21 17:09:29.188436	\N
60	20	40	1	2021-09-21 17:09:29.192316	\N
61	22	40	1	2021-09-21 17:09:29.196124	\N
62	1	41	1	2021-09-22 15:47:08.728078	\N
63	4	41	1	2021-09-22 15:47:08.733499	\N
64	7	41	1	2021-09-22 15:47:08.737951	\N
65	9	41	1	2021-09-22 15:47:08.742532	\N
66	14	41	1	2021-09-22 15:47:08.746187	\N
67	13	41	1	2021-09-22 15:47:08.74994	\N
68	19	41	1	2021-09-22 15:47:08.753712	\N
69	20	41	1	2021-09-22 15:47:08.757686	\N
70	22	41	1	2021-09-22 15:47:08.761542	\N
71	14	42	1	2021-09-22 19:25:45.121601	\N
72	14	43	1	2021-09-22 19:28:27.575606	\N
73	14	44	1	2021-09-22 19:30:01.334332	\N
74	14	45	1	2021-09-22 19:36:24.042992	\N
75	4	45	1	2021-09-22 19:36:24.047668	\N
76	7	46	1	2021-10-06 15:23:31.226188	\N
77	1	46	1	2021-10-06 15:23:31.232539	\N
78	4	46	1	2021-10-06 15:23:31.236788	\N
79	13	46	1	2021-10-06 15:23:31.240496	\N
80	7	48	1	2021-10-06 19:43:15.00535	\N
81	22	48	1	2021-10-06 19:43:15.01154	\N
82	1	48	1	2021-10-06 19:43:15.016081	\N
83	19	48	1	2021-10-06 19:43:15.019973	\N
84	4	48	1	2021-10-06 19:43:15.023834	\N
85	9	48	1	2021-10-06 19:43:15.02763	\N
86	20	48	1	2021-10-06 19:43:15.03139	\N
87	14	48	1	2021-10-06 19:43:15.035165	\N
88	13	48	1	2021-10-06 19:43:15.03902	\N
89	7	49	1	2021-10-06 19:54:05.748948	\N
90	22	49	1	2021-10-06 19:54:05.754321	\N
91	1	49	1	2021-10-06 19:54:05.758428	\N
92	19	49	1	2021-10-06 19:54:05.76229	\N
93	4	49	1	2021-10-06 19:54:05.766284	\N
94	9	49	1	2021-10-06 19:54:05.76995	\N
95	20	49	1	2021-10-06 19:54:05.774156	\N
96	14	49	1	2021-10-06 19:54:05.77795	\N
97	13	49	1	2021-10-06 19:54:05.78188	\N
98	22	57	1	2021-10-11 18:37:09.76807	\N
99	7	57	1	2021-10-11 18:37:09.773058	\N
100	1	57	1	2021-10-11 18:37:09.777157	\N
101	19	57	1	2021-10-11 18:37:09.781251	\N
102	9	57	1	2021-10-11 18:37:09.784897	\N
103	20	57	1	2021-10-11 18:37:09.788628	\N
104	4	57	1	2021-10-11 18:37:09.792304	\N
105	14	57	1	2021-10-11 18:37:09.795935	\N
106	13	57	1	2021-10-11 18:37:09.799549	\N
107	22	58	1	2021-10-11 19:05:39.942945	\N
108	7	58	1	2021-10-11 19:05:39.948041	\N
109	1	58	1	2021-10-11 19:05:39.952009	\N
110	19	58	1	2021-10-11 19:05:39.955749	\N
111	9	58	1	2021-10-11 19:05:39.959344	\N
112	20	58	1	2021-10-11 19:05:39.96303	\N
113	4	58	1	2021-10-11 19:05:39.966728	\N
114	14	58	1	2021-10-11 19:05:39.970487	\N
115	13	58	1	2021-10-11 19:05:39.974128	\N
116	22	59	1	2021-10-11 19:17:48.061152	\N
117	7	59	1	2021-10-11 19:17:48.06621	\N
118	1	59	1	2021-10-11 19:17:48.06994	\N
119	19	59	1	2021-10-11 19:17:48.073642	\N
120	9	59	1	2021-10-11 19:17:48.077272	\N
121	20	59	1	2021-10-11 19:17:48.08082	\N
122	4	59	1	2021-10-11 19:17:48.08444	\N
123	14	59	1	2021-10-11 19:17:48.087985	\N
124	13	59	1	2021-10-11 19:17:48.09161	\N
125	22	60	1	2021-10-11 19:51:50.735736	\N
126	7	60	1	2021-10-11 19:51:50.741241	\N
127	1	60	1	2021-10-11 19:51:50.74541	\N
128	19	60	1	2021-10-11 19:51:50.749306	\N
129	9	60	1	2021-10-11 19:51:50.753128	\N
130	20	60	1	2021-10-11 19:51:50.757014	\N
131	4	60	1	2021-10-11 19:51:50.760731	\N
132	14	60	1	2021-10-11 19:51:50.764665	\N
133	13	60	1	2021-10-11 19:51:50.768573	\N
134	1	61	1	2021-10-12 14:02:35.309578	\N
135	4	61	1	2021-10-12 14:02:35.314589	\N
\.


--
-- Data for Name: coupon_cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_cities (id, city_id, coupon_id, status, created_at, updated_at, deleted_at) FROM stdin;
16	1	32	1	2021-08-23 10:27:54.018082	\N	\N
17	1	33	1	2021-08-23 13:52:04.726378	\N	\N
18	19	34	1	2021-08-25 10:14:38.333594	\N	\N
19	10	35	1	2021-08-25 10:16:13.219961	\N	\N
20	1	35	1	2021-08-25 10:16:13.224517	\N	\N
21	11	35	1	2021-08-25 10:16:13.228249	\N	\N
22	2	35	1	2021-08-25 10:16:13.23199	\N	\N
23	8	35	1	2021-08-25 10:16:13.235455	\N	\N
24	19	35	1	2021-08-25 10:16:13.239074	\N	\N
25	1	37	1	2021-08-25 19:05:36.260894	\N	\N
26	10	37	1	2021-08-25 19:05:36.265667	\N	\N
27	11	37	1	2021-08-25 19:05:36.269329	\N	\N
28	8	37	1	2021-08-25 19:05:36.273053	\N	\N
29	2	37	1	2021-08-25 19:05:36.276545	\N	\N
30	19	37	1	2021-08-25 19:05:36.280014	\N	\N
31	11	38	1	2021-08-25 20:42:45.819553	\N	\N
32	11	39	1	2021-08-25 20:46:54.779742	\N	\N
33	10	40	1	2021-09-21 17:09:29.199686	\N	\N
34	11	40	1	2021-09-21 17:09:29.204531	\N	\N
35	2	40	1	2021-09-21 17:09:29.208316	\N	\N
36	8	40	1	2021-09-21 17:09:29.212083	\N	\N
37	19	40	1	2021-09-21 17:09:29.215679	\N	\N
38	1	40	1	2021-09-21 17:09:29.219399	\N	\N
39	2	41	1	2021-09-22 15:47:08.765313	\N	\N
40	2	42	1	2021-09-22 19:25:45.127548	\N	\N
41	8	42	1	2021-09-22 19:25:45.132665	\N	\N
42	19	42	1	2021-09-22 19:25:45.136644	\N	\N
43	2	43	1	2021-09-22 19:28:27.580693	\N	\N
44	1	43	1	2021-09-22 19:28:27.585695	\N	\N
45	2	44	1	2021-09-22 19:30:01.418186	\N	\N
46	1	44	1	2021-09-22 19:30:01.424141	\N	\N
47	2	45	1	2021-09-22 19:36:24.052267	\N	\N
48	1	45	1	2021-09-22 19:36:24.056503	\N	\N
49	2	46	1	2021-10-06 15:23:31.244364	\N	\N
50	11	46	1	2021-10-06 15:23:31.24968	\N	\N
51	19	46	1	2021-10-06 15:23:31.253782	\N	\N
52	2	48	1	2021-10-06 19:43:15.04286	\N	\N
53	2	49	1	2021-10-06 19:54:05.785677	\N	\N
54	1	53	1	2021-10-08 12:19:14.589642	\N	\N
55	2	56	1	2021-10-08 13:32:24.298431	\N	\N
56	2	57	1	2021-10-11 18:37:09.803414	\N	\N
57	2	58	1	2021-10-11 19:05:39.977889	\N	\N
58	2	59	1	2021-10-11 19:17:48.095064	\N	\N
59	2	60	1	2021-10-11 19:51:50.772508	\N	\N
60	2	61	1	2021-10-12 14:02:35.31896	\N	\N
\.


--
-- Data for Name: coupon_merchants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_merchants (id, coupon_id, merchant_id, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: coupon_stores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupon_stores (id, store_id, coupon_id, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: coupons; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.coupons (id, code, title, description, banner_1, banner_2, level, target, deduction_type, deduction_amount, min_order_value, max_deduction, user_id, previous_order_track, max_user_usage_limit, expired_at, status, order_id, is_display, created_at, updated_at, deleted_at) FROM stdin;
45	CHECK3	check	check	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	2	2	50	100	50	1	0	5	2021-09-30	0	\N	0	2021-09-22 19:36:24.036858	2021-09-23 14:03:23.515978	\N
43	CHECK1	check	check	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	2	2	50	100	50	1	1	5	2021-09-30	0	\N	1	2021-09-22 19:28:27.568425	2021-09-23 14:03:24.291721	\N
40	HELLO75	75	75 % oFF	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	1	75	200	100	1	0	5000	2021-09-25	0	\N	1	2021-09-21 17:09:29.157777	2021-09-23 14:03:25.413655	\N
51	rajnikant	test coupon	for testing	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	10	100	10	1	0	1000	2021-12-31	1	\N	1	2021-10-08 11:10:04.336011	\N	\N
42	CHECK	check	check	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	30	100	30	1	0	4	2021-09-30	0	\N	0	2021-09-22 19:25:45.114054	2021-10-05 19:37:55.205247	\N
38	DEMo	adsf	asdf	saas/coupon/banner2/default.png	saas/coupon/banner2/default.png	3	2	1	34	31	314	\N	0	123	2021-09-15	0	\N	0	2021-08-25 20:42:45.808718	2021-10-05 19:37:56.139277	\N
39	ITE50	ISoft 	50% off on iProducts	saas/coupon/banner2/default.png	saas/coupon/banner2/default.png	1	1	2	123	12313	123	\N	0	123	2021-08-26	0	\N	0	2021-08-25 20:46:54.769196	2021-10-05 19:37:56.876705	\N
44	CHECK2	check	check	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	2	2	50	100	50	1	0	5	2021-09-30	0	\N	0	2021-09-22 19:30:01.326942	2021-10-05 19:37:57.965523	\N
41	NEXTTOP	Top offer	on minimum purchase of 500 FLAT 25 OFF	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	25	500	75	1	2	5	2021-09-30	0	\N	1	2021-09-22 15:47:08.721097	2021-10-05 19:37:59.368062	\N
35	Offer	Offer	Offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	1	40	100	99	\N	100	100	2021-09-30	0	\N	0	2021-08-25 10:16:13.19158	2021-10-05 19:38:00.135534	\N
34	TEST1	Test coupon	This is test coupon	saas/coupon/banner2/default.png	saas/coupon/banner2/default.png	1	1	1	10	100	50	\N	5	5	2021-08-31	0	\N	0	2021-08-25 10:14:38.304327	2021-10-05 19:38:00.910116	\N
36	XYX	Reduce 40	Reduce 40	saas/coupon/banner2/default.png	saas/coupon/banner2/default.png	1	2	2	40	200	50	\N	1234	10	2021-08-31	0	\N	1	2021-08-25 19:00:37.331954	2021-10-05 19:38:01.662638	\N
32	ritika-4	Test coupon	This is test coupon	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	100	100	100	\N	9	1000	2021-08-31	0	\N	1	2021-08-23 10:27:54.001437	2021-10-05 19:38:02.28075	\N
33	simpi-1	Test coupon	This is test coupon	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	100	50	\N	8	1000	2021-08-31	0	\N	1	2021-08-23 13:52:04.712058	2021-10-05 19:38:02.902034	\N
46	Only3	new offer	Offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	40	2	45	1	3	3	2021-10-13	1	\N	0	2021-10-06 15:23:31.218379	2021-10-06 16:32:56.398498	\N
47	Limit60	gg	g	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	40	60	89	1	0	3	2021-10-08	1	\N	1	2021-10-06 16:35:45.512302	\N	\N
60	NEW45	Flat 45	Welcome new user	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	100	50	\N	1	1	2021-10-12	1	\N	0	2021-10-11 19:51:50.729275	2021-10-11 19:54:27.272105	\N
53	rajnikant-125	Test coupon	This is test coupon	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	300	50	\N	20	20	2021-10-31	1	\N	0	2021-10-08 12:19:14.582983	2021-10-17 15:16:01.441132	\N
37	newoffer	new	offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	80	100	89	\N	137	1000	2021-10-07	1	\N	1	2021-08-25 19:05:36.23561	2021-10-06 20:22:26.221603	\N
50	Ritika-6	Test coupon	This is test coupon	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	500	50	1	0	5	2021-10-31	1	\N	1	2021-10-07 07:26:37.878299	\N	\N
52	rajnikant-124	Test coupon	This is test coupon	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	200	50	13	5	20	2021-10-31	1	\N	1	2021-10-08 11:46:46.843007	2021-10-17 15:16:06.043785	\N
49	WEB	Only for web users	Only for web users	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	2	1	2	80	300	80	1	3	3	2021-10-28	1	\N	0	2021-10-06 19:54:05.740885	2021-10-08 17:40:23.753045	\N
57	NEW25	Flat 25	Welcome new user	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	25	100	25	\N	1	1	2021-10-12	1	\N	0	2021-10-11 18:37:09.76152	2021-10-11 19:02:26.185695	\N
55	Bang	Off	Offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	45	2	100	\N	0	15	2021-10-12	1	\N	1	2021-10-08 13:32:10.578726	\N	\N
54	R127	Off	Offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	40	2	89	\N	0	5	2021-10-13	1	\N	1	2021-10-08 13:30:53.510123	2021-10-08 13:32:34.199866	\N
61	NewCoup	new	new	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	80	10	99	\N	5	100	2021-10-20	1	\N	1	2021-10-12 14:02:35.303164	2021-10-17 15:26:39.090106	\N
56	Bang1	Off	Offer	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	45	2	100	\N	2	15	2021-10-12	1	\N	1	2021-10-08 13:32:24.292148	2021-10-11 07:45:09.843846	\N
48	MOBILE	Only for app users	Only for app users	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	3	1	2	80	300	80	1	3	3	2021-10-28	1	\N	0	2021-10-06 19:43:14.997111	2021-10-12 13:59:40.643173	\N
58	NEW30	Flat 25	Welcome new user	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	30	100	30	\N	1	1	2021-10-12	1	\N	0	2021-10-11 19:05:39.936752	2021-10-11 19:14:46.565988	\N
59	NEW50	Flat 50	Welcome new user	saas/coupon/banner1/default.png	saas/coupon/banner2/default.png	1	1	2	50	100	50	\N	1	1	2021-10-12	1	\N	0	2021-10-11 19:17:48.054632	2021-10-11 19:22:38.706555	\N
\.


--
-- Data for Name: delivery_agent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.delivery_agent (id, name, api_link, api_key, status, created_at, updated_at, deleted_at) FROM stdin;
2	Last Mile	dbdsbvdk	dcm s sd	1	2021-09-20 05:14:01.627446	\N	\N
1	Self Delivery			1	2021-09-14 11:02:44.575162	\N	\N
\.


--
-- Data for Name: distributor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.distributor (id, email, name, password_hash, active, phone, image, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at) FROM stdin;
1	distributor@gmail.com	distributor	$2b$12$QigWrSE54LuJq8Vi7.6R8.Exn4ouRorQu5/YfZDQLAlXtrDcRk0iG	f	1234567890	saas/user/default.png	distributor	\N	\N	2021-10-15 09:38:34.200617	2021-10-15 09:38:34.19305	\N
\.


--
-- Data for Name: hub; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hub (id, distributor_id, name, slug, image, address_line_1, address_line_2, hub_latitude, hub_longitude, radius, status, city_id, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: hub_bank_details; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hub_bank_details (id, hub_id, beneficiary_name, name_of_bank, ifsc_code, vpa, account_number, status, confirmed, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: hub_order_lists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hub_order_lists (id, hub_order_id, store_item_id, store_item_variable_id, quantity, removed_by, status, product_mrp, product_selling_price, product_quantity, product_quantity_unit, product_name, product_brand_name, product_image, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: hub_order_tax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hub_order_tax (id, hub_order_id, tax_id, tax_name, tax_type, amount, calculated, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: hub_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hub_orders (id, merchant_id, hub_id, order_total, total_tax, delivery_fee, grand_order_total, initial_paid, order_created, order_confirmed, ready_to_pack, order_paid, order_pickedup, order_delivered, delivery_date, user_address_id, delivery_slot_id, da_id, status, distributor_transfer_at, distributor_transaction_id, txnid, gateway, transaction_status, cancelled_by_id, cancelled_by_role, commision, created_at, updated_at, deleted_at, remove_by_role, remove_by_id) FROM stdin;
\.


--
-- Data for Name: hubtaxes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.hubtaxes (id, hub_id, name, description, tax_type, amount, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: item_order_lists; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_order_lists (id, item_order_id, store_item_id, store_item_variable_id, product_packaged, quantity, removed_by, status, product_mrp, product_selling_price, product_quantity_unit, product_name, product_brand_name, product_image, created_at, updated_at, deleted_at, product_quantity) FROM stdin;
1254	505	85	145	\N	2	0	1	180	140	3	Beans	fresh	saas/itemicon/default.png	2021-09-28 13:23:11.863905	2021-09-28 13:23:23.751012	\N	2
1260	515	26	47	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-29 09:58:36.460786	\N	2021-09-29 09:58:49.834383	\N
1155	467	80	135	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:30:51.548339	\N	2021-09-22 16:31:50.921545	\N
1146	464	54	98	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 14:12:51.193391	2021-09-22 15:04:25.568361	2021-09-23 04:48:02.654684	\N
1172	475	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 04:48:13.411541	\N	2021-09-23 04:48:18.355049	\N
1186	482	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:43:47.326786	\N	2021-09-23 12:50:23.897956	\N
1128	459	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-21 10:26:09.62942	\N	2021-09-23 15:27:19.352006	\N
1187	483	26	46	\N	1	0	11	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 12:50:11.483553	2021-09-24 09:09:23.766894	\N	250
1200	486	27	57	\N	1	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-23 12:53:27.536951	2021-09-23 12:53:35.089467	\N	50
1192	484	82	139	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:40.991265	\N	2021-09-23 13:01:36.457414	\N
1190	484	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:38.09518	\N	2021-09-23 13:01:36.457414	\N
1153	466	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:24:04.427275	\N	2021-09-22 16:25:06.21578	\N
1152	466	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:24:03.093345	\N	2021-09-22 16:25:06.21578	\N
1157	467	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:30:57.349841	\N	2021-09-22 16:31:50.921545	\N
1247	505	76	130	\N	1	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-09-28 11:28:46.612674	2021-09-28 13:23:23.751012	\N	500
1226	498	56	100	\N	1	0	11	30	20	5	Cookies	amul	saas/itemicon/default.png	2021-09-24 09:09:51.846014	2021-09-24 09:11:12.669271	\N	250
1211	491	26	47	\N	2	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 15:29:13.279325	2021-09-28 12:03:45.441337	\N	500
1259	515	24	222	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-29 09:58:35.761235	\N	2021-09-29 09:58:49.834383	\N
1258	514	24	222	\N	2	0	1	300	285	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-29 09:58:35.752639	2021-09-29 09:59:12.776604	\N	5
1262	516	26	56	\N	8	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-29 10:00:53.976855	2021-09-30 11:16:13.709194	\N	1
1162	468	76	130	\N	14	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:32:56.996256	2021-09-22 16:35:15.725679	2021-09-22 16:56:45.163518	\N
1147	464	67	152	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 15:03:04.368786	\N	2021-09-23 04:48:02.654684	\N
1173	476	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 04:58:21.650723	\N	2021-09-23 04:58:40.134912	\N
1198	486	24	221	\N	1	0	1	60	55	5	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 12:53:26.066826	2021-09-23 12:53:35.089467	\N	750
1199	486	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 12:53:26.619035	2021-09-23 12:53:35.089467	\N	500
1242	505	54	98	\N	10	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-28 11:28:11.823187	2021-09-28 13:23:23.751012	\N	200
1156	467	85	145	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:30:54.642517	\N	2021-09-22 16:31:50.921545	\N
1255	511	66	125	\N	9	0	1	\N	\N	\N	\N	\N	\N	2021-09-29 05:42:31.073363	\N	2021-09-29 07:25:30.41664	\N
1566	662	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:35:19.416305	2021-10-13 12:35:38.846806	2021-10-13 12:35:39.783813	\N
1160	468	53	97	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:32:51.59031	2021-09-22 16:33:24.039405	2021-09-22 16:56:45.163518	\N
1148	464	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 15:03:05.546704	2021-09-23 04:47:03.419947	2021-09-23 04:48:02.654684	\N
1174	477	87	148	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 04:58:28.439931	2021-09-23 04:58:37.224152	2021-09-23 04:58:38.679626	\N
1197	485	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 12:51:07.582897	2021-09-23 12:51:13.639367	\N	250
1191	484	85	145	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:40.05025	\N	2021-09-23 13:01:36.457414	\N
1193	484	76	130	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:42.052902	2021-09-23 13:00:21.722314	2021-09-23 13:01:36.457414	\N
1210	488	76	130	\N	2	0	11	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-09-23 15:16:37.470952	2021-09-24 07:19:17.513347	\N	500
1216	493	51	114	\N	1	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-24 07:26:43.36463	2021-09-24 07:27:37.108733	\N	11
1227	499	87	148	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-25 05:00:02.627986	\N	2021-09-27 13:51:37.962071	\N
313	132	26	56	\N	10	0	1	\N	\N	\N	\N	\N	\N	2021-08-23 10:09:17.947288	2021-08-23 13:33:42.214246	2021-08-23 13:33:45.442009	\N
315	133	24	29	\N	2	0	11	58	55	3	Mango	farm-fresh	string	2021-08-23 13:33:49.45704	2021-08-24 06:36:31.84807	\N	\N
314	132	27	50	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-23 10:09:20.165957	2021-08-23 13:33:39.291958	2021-08-23 13:33:45.442009	\N
311	131	27	50	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-22 15:50:39.111921	\N	2021-08-24 04:34:12.195767	\N
312	131	28	65	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-22 15:50:42.047673	\N	2021-08-24 04:34:12.195767	\N
317	133	27	50	\N	6	0	11	120	115	5	Butter	Amul	string	2021-08-23 13:33:52.290041	2021-08-24 06:36:31.845604	\N	\N
310	130	28	65	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-22 03:03:24.119608	\N	2021-08-25 06:07:55.950776	\N
309	130	27	50	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-22 03:03:22.719323	\N	2021-08-25 06:07:55.950776	\N
337	144	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:20:08.524848	\N	2021-08-24 09:20:45.606775	\N
366	156	27	92	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:36:11.150107	\N	2021-08-24 15:37:59.130817	\N
339	145	26	56	\N	2	0	11	200	180	3	Apple	farm-fresh	string	2021-08-24 09:20:52.348429	2021-08-25 12:14:21.175837	\N	\N
330	141	26	56	\N	6	0	11	200	180	3	Apple	farm-fresh	string	2021-08-24 06:28:32.750483	2021-08-25 14:55:35.288777	\N	\N
324	136	27	50	\N	1	0	11	120	115	5	Butter	Amul	string	2021-08-23 14:25:37.226273	2021-08-25 05:53:27.923307	\N	\N
342	130	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 12:25:04.04484	\N	2021-08-25 06:07:55.950776	\N
341	146	27	50	\N	1	0	11	120	115	5	Butter	Amul	saas/itemicon/default.png	2021-08-24 09:36:29.98751	2021-08-25 11:59:58.323501	\N	\N
318	134	26	56	\N	3	0	10	200	180	3	Apple	farm-fresh	string	2021-08-23 14:01:40.818625	2021-08-23 15:16:58.987321	\N	\N
345	148	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 13:24:53.05797	2021-09-20 10:15:37.292103	2021-09-20 10:16:12.899257	\N
326	138	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-23 14:26:43.779857	\N	2021-08-24 05:35:47.039027	\N
364	156	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:35:39.819208	\N	2021-08-24 15:37:59.130817	\N
385	164	26	56	\N	20	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 05:00:42.675087	2021-08-25 05:42:19.040505	2021-08-25 21:09:57.321634	\N
328	140	26	56	\N	0	1	10	200	180	3	Apple	farm-fresh	string	2021-08-24 06:19:23.776476	2021-08-24 11:15:41.482599	\N	\N
331	142	27	50	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 08:14:11.313287	\N	2021-08-24 12:51:58.441964	\N
355	154	24	29	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:18:52.772425	\N	2021-08-24 15:29:28.51635	\N
329	140	24	29	\N	4	0	1	58	55	3	Mango	farm-fresh	string	2021-08-24 06:19:25.1813	2021-08-24 06:28:28.17836	\N	\N
371	157	49	89	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:35:02.134702	\N	2021-08-25 06:53:02.24625	\N
357	154	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:28:31.95968	\N	2021-08-24 15:29:28.51635	\N
359	154	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:28:33.436039	\N	2021-08-24 15:29:28.51635	\N
316	133	26	56	\N	8	0	11	200	180	3	Apple	farm-fresh	string	2021-08-23 13:33:50.699447	2021-08-24 06:36:31.851959	\N	\N
319	135	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	string	2021-08-23 14:25:12.982187	2021-08-24 08:51:21.057257	\N	\N
320	135	27	50	\N	2	0	11	120	115	5	Butter	Amul	string	2021-08-23 14:25:14.121052	2021-08-24 08:51:21.05973	\N	\N
1239	504	51	114	\N	1	5	10	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-28 11:02:34.148521	2021-10-01 06:15:57.45883	\N	11
1240	504	53	97	\N	1	5	10	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-28 11:02:37.307367	2021-10-01 06:15:57.462647	\N	1
1257	513	67	113	\N	2	0	11	500	100	7	a	b	saas/itemicon/default.png	2021-09-29 07:26:30.251174	2021-10-05 13:34:58.542335	\N	1
1274	521	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 09:29:25.458384	\N	2021-10-01 13:05:30.23616	\N
1275	521	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 09:29:27.397495	\N	2021-10-01 13:05:30.23616	\N
321	135	24	29	\N	1	0	11	58	55	3	Mango	farm-fresh	string	2021-08-23 14:25:16.929741	2021-08-24 08:51:21.063379	\N	\N
358	153	49	89	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:28:33.127263	\N	2021-08-24 15:29:35.811146	\N
354	153	24	29	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:18:52.770999	\N	2021-08-24 15:29:35.811146	\N
327	139	27	50	\N	1	0	11	120	115	5	Butter	Amul	string	2021-08-24 04:35:12.474422	2021-08-25 14:59:25.53577	\N	\N
356	153	27	92	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:28:30.970291	\N	2021-08-24 15:29:35.811146	\N
344	147	27	92	\N	7	0	1	120	100	5	Butter	Amul	string	2021-08-24 13:24:03.932709	2021-08-24 13:24:36.217794	\N	\N
368	157	56	100	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:05:39.60841	\N	2021-08-25 06:53:02.24625	\N
346	149	55	99	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 13:45:01.067516	\N	2021-08-24 13:58:46.986128	\N
347	149	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 13:56:44.666442	\N	2021-08-24 13:58:46.986128	\N
322	136	24	29	\N	1	0	11	58	55	3	Mango	farm-fresh	string	2021-08-23 14:25:34.749115	2021-08-25 05:53:27.915905	\N	\N
333	143	27	50	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:17:43.673325	\N	2021-08-24 09:19:59.482453	\N
334	143	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:17:44.495324	\N	2021-08-24 09:19:59.482453	\N
332	143	26	56	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:05:34.11285	2021-08-24 09:19:15.399514	2021-08-24 09:19:59.482453	\N
336	144	27	50	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:20:05.640277	\N	2021-08-24 09:20:45.606775	\N
335	144	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 09:20:04.204929	\N	2021-08-24 09:20:45.606775	\N
340	146	26	56	\N	5	0	11	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-24 09:28:55.456166	2021-08-25 11:59:58.325874	\N	\N
343	146	27	92	\N	1	0	11	120	100	5	Butter	Amul	saas/itemicon/default.png	2021-08-24 13:23:22.971542	2021-08-25 11:59:58.3291	\N	\N
360	155	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:29:42.031073	\N	2021-08-24 15:30:14.864929	\N
362	155	27	92	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:29:44.183365	\N	2021-08-24 15:30:14.864929	\N
363	155	56	100	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:29:46.808022	\N	2021-08-24 15:30:14.864929	\N
361	155	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:29:42.975743	\N	2021-08-24 15:30:14.864929	\N
351	152	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:17:11.954208	\N	2021-08-24 15:18:46.521295	\N
349	151	24	29	\N	17	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:16:52.609177	\N	2021-08-24 15:17:05.225031	\N
350	152	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:17:09.311722	2021-08-24 15:17:30.350332	2021-08-24 15:18:46.521295	\N
352	152	27	92	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:17:15.138915	2021-08-24 15:17:39.942021	2021-08-24 15:18:46.521295	\N
353	152	27	92	\N	11	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:17:41.957986	2021-08-24 15:18:29.640349	2021-08-24 15:18:46.521295	\N
374	158	27	92	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 20:42:12.989617	\N	2021-08-25 01:34:45.562131	\N
383	162	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 03:44:32.481427	\N	2021-08-25 04:29:41.077286	\N
375	158	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 20:42:13.458451	2021-08-24 20:44:11.096362	2021-08-25 01:34:45.562131	\N
373	157	24	29	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:46:11.443239	\N	2021-08-25 06:53:02.24625	\N
365	156	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:36:10.250923	\N	2021-08-24 15:37:59.130817	\N
367	156	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 15:36:12.444509	\N	2021-08-24 15:37:59.130817	\N
369	157	27	92	\N	11	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:34:36.254352	\N	2021-08-25 06:53:02.24625	\N
384	163	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 05:00:25.145161	2021-08-25 05:00:30.713663	2021-08-25 05:00:35.832196	\N
380	160	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 02:48:21.770984	\N	2021-08-25 02:48:51.02376	\N
381	160	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 02:48:26.40842	\N	2021-08-25 02:48:51.02376	\N
372	157	26	56	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:43:19.856822	\N	2021-08-25 06:53:02.24625	\N
388	166	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 06:13:05.756791	\N	2021-08-25 06:53:10.868048	\N
376	158	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 20:42:14.146935	\N	2021-08-25 01:34:45.562131	\N
377	158	56	100	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 20:42:14.67724	\N	2021-08-25 01:34:45.562131	\N
379	159	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 01:42:12.309661	\N	2021-08-25 02:48:53.791101	\N
378	158	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 20:42:15.721801	\N	2021-08-25 01:34:45.562131	\N
382	161	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 02:50:51.197104	\N	2021-08-25 02:50:54.97543	\N
323	136	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	string	2021-08-23 14:25:35.566509	2021-08-25 05:53:27.918922	\N	\N
348	150	24	29	\N	2	0	11	58	55	3	Mango	farm-fresh	string	2021-08-24 13:58:52.150457	2021-08-25 05:15:30.215294	\N	\N
1149	465	87	148	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:07:32.227632	\N	2021-09-22 16:30:29.137862	\N
387	165	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 06:08:02.551363	\N	2021-08-25 11:19:16.430061	\N
370	157	27	50	\N	13	0	1	\N	\N	\N	\N	\N	\N	2021-08-24 17:34:55.089474	\N	2021-08-25 06:53:02.24625	\N
389	167	54	98	\N	7	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 06:54:17.160465	2021-08-25 06:55:38.268785	2021-08-25 06:56:09.874755	\N
390	167	66	112	\N	7	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 06:54:18.779258	\N	2021-08-25 06:56:09.874755	\N
391	167	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 06:54:20.273763	2021-08-25 06:55:34.889485	2021-08-25 06:56:09.874755	\N
393	168	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 07:00:35.269937	2021-08-25 07:00:47.772982	2021-08-25 07:01:09.874589	\N
392	168	51	96	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 07:00:28.295742	2021-08-25 07:01:00.913089	2021-08-25 07:01:09.874589	\N
395	169	66	112	\N	1	0	1	2000	500	7	Apple	Apple	saas/itemicon/default.png	2021-08-25 07:08:17.78616	2021-08-25 07:08:34.253696	\N	\N
386	164	27	92	\N	18	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 05:00:43.285459	2021-08-25 08:31:53.461064	2021-08-25 21:09:57.321634	\N
325	137	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	string	2021-08-23 14:25:53.527091	2021-08-25 11:08:12.177009	\N	\N
467	195	27	92	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 12:04:54.463101	\N	2021-08-25 12:05:18.199577	\N
1218	494	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-24 07:31:00.388585	2021-09-24 07:31:31.376921	2021-09-24 07:31:31.376921	\N
394	169	54	98	\N	1	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 07:08:16.759651	2021-08-25 07:08:34.253696	\N	\N
396	169	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 07:08:19.292538	2021-08-25 07:08:34.253696	\N	\N
398	170	66	112	\N	1	0	1	2000	500	7	Apple	Apple	saas/itemicon/default.png	2021-08-25 07:10:09.432508	2021-08-25 10:02:46.769757	\N	\N
431	183	69	116	\N	3	0	10	60	55	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 10:35:50.607405	2021-08-26 05:11:27.765429	\N	\N
397	170	54	98	\N	3	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 07:10:06.166324	2021-08-25 07:10:30.175399	\N	\N
401	171	54	98	\N	1	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 07:14:42.716565	2021-08-25 07:19:49.977087	\N	\N
402	171	66	112	\N	1	0	1	2000	500	7	Apple	Apple	saas/itemicon/default.png	2021-08-25 07:14:43.940148	2021-08-25 07:19:49.977087	\N	\N
403	172	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 07:30:43.887881	2021-08-25 07:31:08.478617	2021-08-25 07:31:39.569788	\N
418	179	51	114	\N	3	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-08-25 10:05:32.171893	2021-08-25 11:28:00.479798	\N	\N
422	179	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-08-25 10:11:09.473135	2021-08-25 11:28:00.479798	\N	\N
411	175	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:34:52.710589	\N	\N	\N
406	164	56	100	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:06:10.017888	\N	2021-08-25 21:09:57.321634	\N
423	179	54	98	\N	3	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 10:12:04.563486	2021-08-25 11:28:00.479798	\N	\N
410	174	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:34:23.043908	\N	2021-08-25 08:40:18.042245	\N
408	174	66	112	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:34:18.827726	2021-08-25 08:35:51.493426	2021-08-25 08:40:18.042245	\N
409	174	67	113	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:34:21.431887	\N	2021-08-25 08:40:18.042245	\N
424	179	66	112	\N	2	0	1	2000	500	7	Apple	Apple	saas/itemicon/default.png	2021-08-25 10:12:05.796507	2021-08-25 11:28:00.479798	\N	\N
433	165	56	100	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 10:55:16.51831	\N	2021-08-25 11:19:16.430061	\N
434	165	27	92	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 10:55:19.077852	\N	2021-08-25 11:19:16.430061	\N
419	180	71	118	\N	2	0	11	120	115	5	chicken legg	xyz	saas/itemicon/default.png	2021-08-25 10:10:37.788	2021-08-25 11:30:08.583068	\N	\N
450	189	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:42:43.563139	\N	2021-08-25 11:43:11.198303	\N
436	165	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:19:10.206056	\N	2021-08-25 11:19:16.430061	\N
435	165	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 10:55:37.027708	\N	2021-08-25 11:19:16.430061	\N
420	180	70	120	\N	6	0	11	60	55	5	Chips	Lays	saas/itemicon/default.png	2021-08-25 10:10:58.141892	2021-08-25 11:30:08.585452	\N	\N
425	181	71	118	\N	0	16	10	120	115	5	chicken legg	xyz	saas/itemicon/default.png	2021-08-25 10:18:58.772873	2021-08-25 10:20:32.436912	\N	\N
1151	456	85	145	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:08:15.395072	2021-09-22 16:17:40.336578	2021-09-22 16:17:49.962829	\N
421	180	70	117	\N	2	0	11	30	20	7	Chips	Lays	saas/itemicon/default.png	2021-08-25 10:11:04.780167	2021-08-25 11:30:08.588876	\N	\N
1137	453	77	131	\N	2	0	11	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-09-22 05:11:06.272348	2021-09-23 07:05:23.608226	\N	500
427	182	69	116	\N	2	0	11	60	55	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 10:28:22.330368	2021-08-25 10:34:35.835611	\N	\N
400	171	67	113	\N	-1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 07:14:41.741543	2021-08-25 09:12:26.853911	\N	\N
414	176	51	114	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 09:09:52.436867	\N	2021-08-25 09:13:10.488004	\N
412	176	53	97	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 09:09:36.904931	2021-08-25 09:10:09.564496	2021-08-25 09:13:10.488004	\N
413	176	51	96	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 09:09:42.005699	2021-08-25 09:10:10.963314	2021-08-25 09:13:10.488004	\N
428	182	68	115	\N	2	0	11	60	55	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 10:28:25.625387	2021-08-25 10:34:35.837822	\N	\N
407	173	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:12:10.389787	\N	2021-08-25 21:09:55.272953	\N
426	182	68	119	\N	3	0	11	35	30	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 10:28:17.663515	2021-08-25 10:34:35.841023	\N	\N
416	177	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-08-25 09:30:19.899389	2021-08-25 09:43:37.386033	\N	\N
415	177	51	114	\N	3	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-08-25 09:30:18.800804	2021-08-25 09:43:37.386033	\N	\N
399	170	67	113	\N	0	5	10	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 07:10:10.39179	2021-08-25 10:02:33.985151	\N	\N
444	187	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:30:19.386505	\N	2021-08-25 11:30:27.075643	\N
438	185	73	124	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:25:38.961177	2021-08-25 11:25:49.931102	2021-08-25 11:25:59.710813	\N
445	187	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-08-25 11:30:20.798433	2021-08-25 11:31:35.307942	\N	\N
447	189	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 11:42:26.138027	2021-08-25 11:43:18.73395	\N	\N
437	184	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:21:27.167166	\N	2021-08-25 11:31:52.440039	\N
442	184	27	92	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:30:11.922388	\N	2021-08-25 11:31:52.440039	\N
443	184	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:30:16.228154	\N	2021-08-25 11:31:52.440039	\N
441	179	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:26:44.796102	\N	2021-08-25 11:27:16.201474	\N
439	186	72	121	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:26:31.872641	\N	2021-08-25 11:27:16.380621	\N
440	186	72	123	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:26:34.039338	\N	2021-08-25 11:27:16.380621	\N
417	178	71	118	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 09:56:43.428059	\N	2021-08-25 11:32:34.954761	\N
448	189	74	126	\N	1	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-25 11:42:27.199123	2021-08-25 11:43:18.73395	\N	\N
449	189	66	112	\N	1	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 11:42:30.889453	2021-08-25 11:43:18.73395	\N	\N
451	190	71	118	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:44:11.012668	\N	2021-08-25 11:44:15.117394	\N
446	188	66	112	\N	2	0	1	2000	500	7	Apple	Apple	saas/itemicon/default.png	2021-08-25 11:33:38.845073	2021-08-25 11:34:01.266593	\N	\N
453	191	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:47:40.458632	\N	2021-08-25 11:47:48.941628	\N
452	191	54	98	\N	1	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 11:47:39.594587	2021-08-25 11:47:55.550027	\N	\N
454	191	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 11:47:41.473128	2021-08-25 11:47:55.550027	\N	\N
455	191	74	126	\N	1	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-25 11:47:43.10219	2021-08-25 11:47:55.550027	\N	\N
456	192	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 11:49:39.785582	\N	2021-08-25 11:50:12.851791	\N
457	192	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-08-25 11:49:41.753433	2021-08-25 11:50:18.995609	\N	\N
458	193	24	29	\N	2	0	10	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 11:53:50.701143	2021-08-25 12:12:36.750862	\N	\N
460	193	27	92	\N	1	0	10	120	100	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 11:53:52.724511	2021-08-25 12:12:36.754344	\N	\N
405	164	49	89	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:06:08.519131	\N	2021-08-25 21:09:57.321634	\N
462	194	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 12:04:06.678645	2021-08-25 12:06:21.149916	\N	\N
459	193	26	56	\N	1	0	10	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 11:53:51.706949	2021-08-25 12:12:36.74807	\N	\N
404	164	24	29	\N	7	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 08:06:05.555636	\N	2021-08-25 21:09:57.321634	\N
466	195	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 12:04:53.57583	\N	2021-08-25 12:05:18.199577	\N
1150	456	80	135	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:08:08.520491	\N	2021-09-22 16:29:49.470197	\N
701	262	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-31 07:15:41.008339	2021-09-23 07:45:59.819408	\N	1
1196	485	24	221	\N	1	0	1	60	55	5	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 12:51:06.549922	2021-09-23 12:51:13.639367	\N	750
1214	492	54	98	\N	1	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-24 07:21:15.181349	2021-09-24 07:21:37.799161	\N	200
1277	523	49	89	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 11:16:38.750021	\N	2021-09-30 11:18:22.473624	\N
1230	500	81	138	\N	2	0	1	15	9	7	Cauliflower	fresh	saas/itemicon/default.png	2021-09-25 05:55:56.126801	2021-09-27 07:17:40.572052	\N	1
1228	500	54	98	\N	13	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-25 05:55:51.293963	2021-09-27 07:17:40.572052	\N	200
1222	469	27	50	\N	1	0	1	120	115	5	Butter	Amul	saas/itemicon/default.png	2021-09-24 07:38:37.697099	2021-09-27 09:51:09.842321	\N	500
465	194	66	112	\N	1	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 12:04:11.208809	2021-08-25 12:06:21.149916	\N	\N
461	194	54	98	\N	2	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 12:04:04.244663	2021-08-25 12:06:21.149916	\N	\N
463	194	74	126	\N	1	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-25 12:04:07.491191	2021-08-25 12:06:21.149916	\N	\N
464	194	67	113	\N	2	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 12:04:08.570554	2021-08-25 12:06:21.149916	\N	\N
338	145	27	50	\N	1	0	11	120	115	5	Butter	Amul	string	2021-08-24 09:20:50.671418	2021-08-25 12:14:21.172875	\N	\N
497	203	77	131	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:17:14.744406	2021-08-25 15:46:32.182235	2021-08-25 15:52:24.915962	\N
502	203	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:18:09.599252	2021-08-25 15:47:00.395136	2021-08-25 15:52:24.915962	\N
490	201	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 15:13:06.402884	2021-08-25 15:14:13.318578	\N	\N
468	196	51	114	\N	2	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-08-25 12:20:33.175941	2021-08-25 12:24:16.418757	\N	\N
469	196	53	97	\N	2	0	11	50	45	7	Book 15	new	saas/itemicon/default.png	2021-08-25 12:20:34.442944	2021-08-25 12:24:16.42193	\N	\N
614	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:05:43.777782	\N	2021-08-26 04:05:46.613941	\N
1567	662	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:35:21.29704	\N	2021-10-13 12:35:42.056602	\N
1606	675	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:15:34.371279	\N	\N	\N
470	196	54	98	\N	2	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 12:23:43.804658	2021-08-25 12:24:16.425399	\N	\N
471	197	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 12:55:39.627336	\N	2021-08-25 12:55:44.180511	\N
472	197	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 12:55:40.606323	\N	2021-08-25 12:55:45.543958	\N
491	201	27	57	\N	1	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 15:13:07.095449	2021-08-25 15:14:13.320848	\N	\N
473	198	75	128	\N	1	0	11	50	50	3	Basumati rice	Itc	saas/itemicon/default.png	2021-08-25 13:47:40.292545	2021-08-25 13:51:29.117176	\N	\N
492	201	49	89	\N	1	0	11	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 15:13:07.80909	2021-08-25 15:14:13.324116	\N	\N
475	197	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 14:15:54.79362	2021-08-25 14:17:54.044332	\N	\N
476	197	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 14:15:56.349252	2021-08-25 14:17:54.044332	\N	\N
477	197	74	126	\N	1	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-25 14:15:57.933504	2021-08-25 14:17:54.044332	\N	\N
478	197	66	112	\N	1	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 14:16:03.252565	2021-08-25 14:17:54.044332	\N	\N
474	197	54	98	\N	2	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 14:15:51.608696	2021-08-25 14:17:54.044332	\N	\N
493	201	75	127	\N	1	0	11	76	75	3	Basumati rice	Itc	saas/itemicon/default.png	2021-08-25 15:13:09.687053	2021-08-25 15:14:13.327288	\N	\N
494	201	56	100	\N	1	0	11	30	20	5	Cookies	amul	saas/itemicon/default.png	2021-08-25 15:13:10.738936	2021-08-25 15:14:13.330289	\N	\N
489	201	24	29	\N	1	0	11	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 15:13:05.826452	2021-08-25 15:14:13.333373	\N	\N
481	199	54	98	\N	2	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 14:19:16.886852	2021-08-25 14:26:37.717842	\N	\N
479	199	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 14:19:01.845649	2021-08-25 14:26:37.717842	\N	\N
480	199	67	113	\N	2	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 14:19:12.061203	2021-08-25 14:26:37.717842	\N	\N
482	200	76	132	\N	1	0	1	40	35	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 15:11:33.944723	2021-08-25 15:12:15.973915	\N	\N
483	200	76	130	\N	1	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 15:11:37.584314	2021-08-25 15:12:15.973915	\N	\N
484	200	77	131	\N	1	0	1	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-08-25 15:11:38.858395	2021-08-25 15:12:15.973915	\N	\N
485	200	79	134	\N	1	0	1	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-08-25 15:11:40.054552	2021-08-25 15:12:15.973915	\N	\N
486	200	80	135	\N	1	0	1	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-08-25 15:11:42.4756	2021-08-25 15:12:15.973915	\N	\N
487	200	81	138	\N	1	0	1	15	9	7	Cauliflower	fresh	saas/itemicon/default.png	2021-08-25 15:11:43.265441	2021-08-25 15:12:15.973915	\N	\N
488	200	82	139	\N	1	0	1	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-08-25 15:11:44.422063	2021-08-25 15:12:15.973915	\N	\N
522	210	24	29	\N	9	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 17:53:09.223508	2021-08-31 07:42:46.699189	\N	1
495	202	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:16:51.957565	2021-08-25 15:17:12.247081	2021-08-25 15:17:14.806027	\N
524	208	79	134	\N	1	0	10	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-08-25 18:04:42.896422	2021-08-25 18:25:00.676537	\N	\N
521	209	24	29	\N	9	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 16:59:53.855894	\N	2021-08-25 17:53:01.439037	\N
520	209	26	56	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 16:59:51.954469	\N	2021-08-25 17:53:01.439037	\N
515	206	81	138	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:46.140032	\N	2021-08-25 16:09:02.102751	\N
516	206	82	139	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:47.060651	\N	2021-08-25 16:09:02.102751	\N
511	206	77	131	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:41.279374	\N	2021-08-25 16:09:02.102751	\N
499	203	80	135	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:17:16.049075	\N	2021-08-25 15:52:24.915962	\N
498	203	79	134	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:17:15.373254	2021-08-25 15:46:36.007935	2021-08-25 15:52:24.915962	\N
496	203	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:17:13.268727	\N	2021-08-25 15:52:24.915962	\N
501	203	66	112	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:18:01.019499	\N	2021-08-25 15:52:24.915962	\N
512	206	79	134	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:42.600724	\N	2021-08-25 16:09:02.102751	\N
529	212	74	126	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 18:17:39.090387	\N	2021-08-25 18:56:59.409059	\N
517	207	87	147	\N	3	0	1	10	5	3	Mutton	Nandu's	saas/itemicon/default.png	2021-08-25 16:05:53.210908	2021-08-25 18:27:58.093476	\N	\N
510	206	76	130	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:36.237095	\N	2021-08-25 16:09:02.102751	\N
514	206	85	144	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:45.209675	\N	2021-08-25 16:09:02.102751	\N
513	206	80	135	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:52:43.585095	\N	2021-08-25 16:09:02.102751	\N
519	208	77	131	\N	2	0	10	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-08-25 16:09:26.251395	2021-08-25 18:25:00.679874	\N	\N
525	208	80	135	\N	1	0	10	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-08-25 18:04:43.997012	2021-08-25 18:25:00.682934	\N	\N
500	204	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:17:45.08751	2021-08-25 16:06:04.103577	2021-08-25 18:27:21.900914	\N
527	211	66	112	\N	1	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 18:09:24.366221	2021-08-25 18:17:26.412025	\N	\N
526	211	74	126	\N	2	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-25 18:09:21.767073	2021-08-25 18:17:26.412025	\N	\N
528	211	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-08-25 18:09:25.771145	2021-08-25 18:17:26.412025	\N	\N
503	205	76	130	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:25.313818	\N	2021-08-30 14:51:51.715232	\N
504	205	77	131	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:26.451835	\N	2021-08-30 14:51:51.715232	\N
506	205	80	135	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:29.431168	\N	2021-08-30 14:51:51.715232	\N
507	205	81	138	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:31.771158	\N	2021-08-30 14:51:51.715232	\N
509	205	85	144	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:34.17638	\N	2021-08-30 14:51:51.715232	\N
505	205	79	134	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:27.997448	\N	2021-08-30 14:51:51.715232	\N
518	208	76	130	\N	2	0	10	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 16:09:25.163945	2021-08-25 18:25:00.673287	\N	\N
576	225	24	150	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:16:12.601918	\N	2021-08-25 21:17:39.907292	\N
530	212	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 18:17:39.746223	\N	2021-08-25 18:56:59.409059	\N
534	215	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 18:57:44.552049	\N	2021-08-25 18:57:48.955017	\N
533	215	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 18:57:43.844781	\N	2021-08-25 18:57:49.996904	\N
540	215	82	139	\N	1	0	1	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-08-25 19:06:02.210975	2021-08-25 19:08:18.247067	\N	\N
537	215	79	134	\N	2	0	1	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-08-25 19:05:59.645302	2021-08-25 19:08:18.247067	\N	\N
538	215	80	135	\N	2	0	1	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-08-25 19:06:00.109707	2021-08-25 19:08:18.247067	\N	\N
536	215	77	131	\N	2	0	1	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-08-25 19:05:58.842617	2021-08-25 19:08:18.247067	\N	\N
539	215	81	138	\N	2	0	1	15	9	7	Cauliflower	fresh	saas/itemicon/default.png	2021-08-25 19:06:01.759773	2021-08-25 19:08:18.247067	\N	\N
535	215	76	130	\N	3	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 19:05:58.13929	2021-08-25 19:08:18.247067	\N	\N
584	227	49	89	\N	1	0	1	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 21:18:55.970288	2021-08-25 21:22:09.85305	\N	\N
583	227	26	56	\N	2	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 21:18:55.174779	2021-08-25 21:22:09.85305	\N	\N
590	229	26	56	\N	2	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 22:11:50.2452	2021-08-25 22:12:31.416852	\N	\N
542	216	54	98	\N	2	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-25 19:09:26.213431	2021-08-25 19:09:38.323084	\N	\N
594	230	49	89	\N	1	0	10	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 22:13:40.281997	2021-08-25 22:14:19.861928	\N	\N
541	216	66	112	\N	-2	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-25 19:09:25.39455	2021-08-25 19:09:59.425076	\N	\N
581	226	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:15.043134	\N	2021-08-25 21:18:46.618339	\N
595	230	56	100	\N	1	0	10	30	20	5	Cookies	amul	saas/itemicon/default.png	2021-08-25 22:13:40.930362	2021-08-25 22:14:19.865205	\N	\N
591	229	27	57	\N	2	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 22:11:50.86312	2021-08-25 22:12:31.416852	\N	\N
554	164	75	129	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:09:30.068394	\N	2021-08-25 21:09:57.321634	\N
555	164	24	150	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:09:34.016359	\N	2021-08-25 21:09:57.321634	\N
532	214	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 18:46:19.214379	2021-08-25 19:10:16.900945	2021-08-25 19:11:46.467693	\N
544	217	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 19:11:38.451553	\N	2021-08-25 19:15:35.460531	\N
543	217	66	112	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 19:11:35.317851	\N	2021-08-25 19:15:35.460531	\N
545	218	76	130	\N	1	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 19:16:02.427173	2021-08-25 19:16:09.255894	\N	\N
547	220	77	131	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 19:20:05.431104	\N	2021-08-25 19:20:13.828234	\N
548	220	76	130	\N	1	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-25 19:20:06.373383	2021-08-25 19:20:18.015628	\N	\N
549	220	79	134	\N	1	0	1	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-08-25 19:20:07.600461	2021-08-25 19:20:18.015628	\N	\N
550	221	77	131	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 19:26:14.441614	\N	2021-08-25 19:26:51.326262	\N
531	213	87	147	\N	1	0	10	10	5	3	Mutton	Nandu's	saas/itemicon/default.png	2021-08-25 18:29:22.508305	2021-08-25 19:29:51.391621	\N	\N
582	226	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:15.716824	\N	2021-08-25 21:18:46.618339	\N
577	226	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:12.643176	\N	2021-08-25 21:18:46.618339	\N
578	226	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:12.987342	\N	2021-08-25 21:18:46.618339	\N
579	226	75	127	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:13.864074	\N	2021-08-25 21:18:46.618339	\N
580	226	56	100	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:18:14.291912	2021-08-25 21:18:24.75682	2021-08-25 21:18:46.618339	\N
559	223	27	92	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:10:54.904883	\N	2021-08-25 21:14:36.751178	\N
558	223	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:10:51.967999	\N	2021-08-25 21:14:36.751178	\N
557	223	56	100	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:10:49.368845	\N	2021-08-25 21:14:36.751178	\N
556	223	75	129	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:10:47.673815	\N	2021-08-25 21:14:36.751178	\N
561	223	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:28.818631	\N	2021-08-25 21:14:36.751178	\N
562	223	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:29.512423	\N	2021-08-25 21:14:36.751178	\N
563	223	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:30.117391	\N	2021-08-25 21:14:36.751178	\N
564	223	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:30.636699	\N	2021-08-25 21:14:36.751178	\N
565	223	75	127	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:31.59357	\N	2021-08-25 21:14:36.751178	\N
566	223	56	100	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:32.612312	\N	2021-08-25 21:14:36.751178	\N
560	224	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:14:15.800763	\N	2021-08-25 21:15:28.349398	\N
571	225	75	127	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:42.345691	\N	2021-08-25 21:17:39.907292	\N
573	225	75	129	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:16:00.751454	\N	2021-08-25 21:17:39.907292	\N
572	225	56	100	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:43.419382	2021-08-25 21:16:24.790789	2021-08-25 21:17:39.907292	\N
567	225	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:37.418581	2021-08-25 21:16:26.485402	2021-08-25 21:17:39.907292	\N
570	225	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:41.593314	2021-08-25 21:16:28.349592	2021-08-25 21:17:39.907292	\N
568	225	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:39.109959	2021-08-25 21:16:47.426678	2021-08-25 21:17:39.907292	\N
574	225	27	92	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:16:06.38984	\N	2021-08-25 21:17:39.907292	\N
569	225	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:15:39.835792	2021-08-25 21:16:54.271251	2021-08-25 21:17:39.907292	\N
575	225	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:16:09.895678	\N	2021-08-25 21:17:39.907292	\N
588	222	72	121	\N	3	0	11	100	85	5	Cheese	Ananda	saas/itemicon/default.png	2021-08-25 21:43:08.239365	2021-08-26 05:10:54.314512	\N	\N
552	222	70	120	\N	0	0	11	\N	\N	\N	\N	\N	\N	2021-08-25 19:57:49.810955	2021-08-26 05:10:54.31801	2021-08-25 21:26:41.664487	\N
553	222	68	115	\N	0	0	11	\N	\N	\N	\N	\N	\N	2021-08-25 20:52:55.066468	2021-08-26 05:10:54.321567	2021-08-25 21:27:03.283989	\N
551	222	70	117	\N	0	0	11	\N	\N	\N	\N	\N	\N	2021-08-25 19:57:44.021123	2021-08-26 05:10:54.325086	2021-08-25 21:27:37.400686	\N
546	219	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 19:17:38.075187	\N	2021-08-26 15:24:34.002947	\N
620	236	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:27:51.992327	\N	2021-08-26 05:36:42.018486	\N
1158	467	76	130	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:30:59.104101	\N	2021-09-22 16:31:50.921545	\N
592	229	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 22:11:51.437679	2021-08-25 22:11:59.950393	2021-08-25 22:12:00.600028	\N
589	229	24	29	\N	2	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 22:11:49.453579	2021-08-25 22:12:31.416852	\N	\N
596	230	24	150	\N	1	0	10	100	90	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 22:13:43.601279	2021-08-25 22:14:19.868467	\N	\N
593	230	27	57	\N	1	0	10	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 22:13:39.684056	2021-08-25 22:14:19.859454	\N	\N
599	231	27	57	\N	1	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 22:16:08.3841	2021-08-25 22:16:54.319249	\N	\N
597	231	24	29	\N	1	0	11	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-25 22:16:07.3869	2021-08-25 22:16:54.314034	\N	\N
604	234	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:57:08.63193	\N	2021-08-26 03:52:56.204611	\N
605	234	27	57	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:57:09.325769	\N	2021-08-26 03:52:56.204611	\N
585	228	87	148	\N	70	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 21:19:27.594788	\N	2021-08-31 09:55:53.697372	\N
598	231	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 22:16:07.87096	2021-08-25 22:16:54.315987	\N	\N
600	231	49	89	\N	1	0	11	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 22:16:08.817547	2021-08-25 22:16:54.322464	\N	\N
654	247	75	127	\N	1	0	1	76	75	3	Basumati rice	Itc	saas/itemicon/default.png	2021-08-26 15:19:23.737911	2021-08-26 15:21:14.908481	\N	\N
601	232	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:36:07.412632	\N	2021-08-26 02:36:17.913719	\N
655	248	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 15:24:15.583626	\N	\N	\N
602	233	26	56	\N	3	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-26 02:36:23.902153	2021-08-26 02:52:45.668072	\N	\N
603	234	24	29	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:53:03.081375	\N	2021-08-26 03:52:56.204611	\N
606	234	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:57:24.492531	\N	2021-08-26 03:52:56.204611	\N
607	234	56	100	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:57:25.42657	\N	2021-08-26 03:52:56.204611	\N
608	234	75	127	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 02:57:26.840683	\N	2021-08-26 03:52:56.204611	\N
609	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 03:53:01.290536	2021-08-26 03:53:29.652895	2021-08-26 03:53:30.63257	\N
640	242	76	130	\N	1	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-26 06:46:39.177998	2021-08-26 06:47:09.091178	\N	\N
610	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 03:57:23.115007	2021-08-26 03:57:25.873986	2021-08-26 03:57:55.79298	\N
611	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 03:59:20.794302	\N	2021-08-26 03:59:23.780823	\N
641	242	76	132	\N	1	0	1	40	35	5	Onion	fresh	saas/itemicon/default.png	2021-08-26 06:46:43.246589	2021-08-26 06:47:09.091178	\N	\N
631	236	79	134	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:35:54.022589	\N	2021-08-26 05:36:42.018486	\N
612	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:02:25.200055	2021-08-26 04:02:28.177944	2021-08-26 04:02:28.852455	\N
629	236	53	97	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:35:47.046232	\N	2021-08-26 05:36:42.018486	\N
630	236	77	131	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:35:52.936592	2021-08-26 05:36:11.835796	2021-08-26 05:36:42.018486	\N
613	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:04:15.647145	2021-08-26 04:04:18.182293	2021-08-26 04:04:19.126714	\N
615	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:08:23.813531	\N	2021-08-26 04:08:26.186123	\N
616	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:09:29.434756	\N	2021-08-26 04:09:33.76999	\N
624	236	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:24:15.16828	\N	2021-08-26 05:36:42.018486	\N
617	235	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:10:12.836624	2021-08-26 04:10:15.944721	2021-08-26 04:10:17.222525	\N
618	235	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 04:10:23.490585	\N	2021-08-26 04:10:26.97306	\N
586	222	68	115	\N	0	0	11	\N	\N	\N	\N	\N	\N	2021-08-25 21:43:07.109971	2021-08-26 05:10:54.307745	2021-08-25 21:46:06.977261	\N
587	222	69	116	\N	3	0	11	60	55	4	Milk	Amul	saas/itemicon/default.png	2021-08-25 21:43:07.663853	2021-08-26 05:10:54.310729	\N	\N
432	183	68	115	\N	2	0	10	60	55	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 10:35:53.606196	2021-08-26 05:11:27.767862	\N	\N
623	183	72	121	\N	1	0	10	100	85	5	Cheese	Ananda	saas/itemicon/default.png	2021-08-26 05:09:55.719541	2021-08-26 05:11:27.771217	\N	\N
430	183	68	119	\N	1	0	10	35	30	5	Butter	Amul	saas/itemicon/default.png	2021-08-25 10:35:49.418105	2021-08-26 05:11:27.77457	\N	\N
429	183	71	118	\N	3	0	10	120	115	5	chicken legg	xyz	saas/itemicon/default.png	2021-08-25 10:29:04.628148	2021-08-26 05:11:27.777585	\N	\N
642	242	80	135	\N	1	0	1	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-08-26 06:46:44.297425	2021-08-26 06:47:09.091178	\N	\N
643	242	80	137	\N	1	0	1	300	260	3	Tomato	fresh	saas/itemicon/default.png	2021-08-26 06:46:47.321564	2021-08-26 06:47:09.091178	\N	\N
644	242	82	139	\N	1	0	1	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-08-26 06:46:48.796052	2021-08-26 06:47:09.091178	\N	\N
656	248	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 15:24:49.277239	\N	\N	\N
647	243	69	116	\N	3	0	1	60	55	4	Milk	Amul	saas/itemicon/default.png	2021-08-26 07:14:49.134787	2021-08-26 07:16:47.05072	\N	\N
645	242	81	138	\N	1	0	1	15	9	7	Cauliflower	fresh	saas/itemicon/default.png	2021-08-26 06:46:49.246721	2021-08-26 06:47:09.091178	\N	\N
636	239	72	121	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:37:24.066969	\N	2021-08-26 06:55:11.402589	\N
637	239	68	115	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:37:24.824642	\N	2021-08-26 06:55:11.402589	\N
628	237	72	121	\N	2	0	11	100	85	5	Cheese	Ananda	saas/itemicon/default.png	2021-08-26 05:32:19.154364	2021-08-26 07:06:30.365114	\N	\N
627	237	72	123	\N	3	0	11	500	450	3	Cheese	Ananda	saas/itemicon/default.png	2021-08-26 05:32:12.484032	2021-08-26 07:06:30.367872	\N	\N
625	237	88	157	\N	1	0	11	450	440	3	Basmati Rice 	India gate	saas/itemicon/default.png	2021-08-26 05:32:02.379833	2021-08-26 07:06:30.37136	\N	\N
626	237	68	115	\N	1	0	11	60	55	5	Butter	Amul	saas/itemicon/default.png	2021-08-26 05:32:09.781496	2021-08-26 07:06:30.374819	\N	\N
646	243	68	115	\N	2	0	1	60	55	5	Butter	Amul	saas/itemicon/default.png	2021-08-26 07:14:48.403098	2021-08-26 07:16:47.05072	\N	\N
657	249	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 15:46:49.40801	\N	\N	\N
648	243	72	121	\N	3	0	1	100	85	5	Cheese	Ananda	saas/itemicon/default.png	2021-08-26 07:14:49.607767	2021-08-26 07:17:08.415067	\N	\N
633	238	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 05:37:17.23855	2021-08-26 05:37:43.237109	2021-08-26 05:37:45.689049	\N
635	238	54	98	\N	4	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-26 05:37:19.936576	2021-08-26 05:37:48.238581	\N	\N
632	238	66	112	\N	3	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-08-26 05:37:16.161395	2021-08-26 05:37:48.238581	\N	\N
634	238	74	126	\N	0	5	10	170	150	5	Banana	new	saas/itemicon/default.png	2021-08-26 05:37:18.599836	2021-08-26 05:39:15.383636	\N	\N
619	235	24	29	\N	2	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-26 04:15:27.493096	2021-08-26 21:25:24.287521	\N	\N
653	246	87	164	\N	1	0	1	10	1	3	Mutton	Nandu's	saas/itemicon/default.png	2021-08-26 15:02:19.20801	2021-08-26 15:02:34.954524	\N	\N
621	235	49	89	\N	2	0	1	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-26 05:02:45.484123	2021-08-26 21:25:24.287521	\N	\N
660	235	75	127	\N	1	0	1	76	75	3	Basumati rice	Itc	saas/itemicon/default.png	2021-08-26 21:24:34.997947	2021-08-26 21:25:24.287521	\N	\N
639	241	7	4	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 06:29:02.278887	\N	2021-08-26 21:24:44.750049	\N
659	235	89	166	\N	1	0	1	3000	2499	7	Magnum	Icecream	saas/itemicon/default.png	2021-08-26 21:24:34.448128	2021-08-26 21:25:24.287521	\N	\N
658	235	27	57	\N	1	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-26 21:24:30.212219	2021-08-26 21:25:24.287521	\N	\N
622	235	26	56	\N	3	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-26 05:02:50.481119	2021-08-26 21:25:24.287521	\N	\N
661	235	56	100	\N	1	0	1	30	20	5	Cookies	amul	saas/itemicon/default.png	2021-08-26 21:24:35.514055	2021-08-26 21:25:24.287521	\N	\N
652	245	76	130	\N	0	5	10	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-08-26 14:14:30.947521	2021-08-26 21:26:53.339361	\N	\N
650	244	69	116	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 08:11:56.480596	2021-08-27 23:08:57.421864	2021-08-27 23:10:43.160281	\N
662	250	90	168	\N	1	0	11	24999	23000	7	OnePlus	Mobile	saas/itemicon/default.png	2021-08-26 21:28:25.425466	2021-08-26 21:29:32.667853	\N	\N
1154	467	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:30:50.05931	\N	2021-09-22 16:31:50.921545	\N
651	244	68	115	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 08:11:57.328241	\N	2021-08-27 23:10:43.160281	\N
649	244	72	121	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-26 08:11:56.015438	2021-08-27 23:09:27.168134	2021-08-27 23:10:43.160281	\N
719	273	51	114	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 10:03:03.970227	\N	2021-08-31 10:03:36.770445	\N
684	257	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:11:26.65153	\N	2021-08-31 06:58:25.770558	\N
685	257	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:11:27.760468	\N	2021-08-31 06:58:25.770558	\N
686	257	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:11:28.506043	\N	2021-08-31 06:58:25.770558	\N
665	244	71	118	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-27 22:49:23.248593	\N	2021-08-27 23:10:43.160281	\N
666	244	69	116	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-08-27 23:09:06.93827	\N	2021-08-27 23:10:43.160281	\N
693	259	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-31 07:11:33.426088	2021-09-23 09:31:31.626257	\N	1
694	259	27	57	\N	1	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-08-31 07:11:35.927531	2021-09-23 09:31:31.632188	\N	50
695	259	49	89	\N	1	0	11	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-08-31 07:11:39.327125	2021-09-23 09:31:31.638113	\N	1
704	264	26	56	\N	1	0	11	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-31 07:22:59.330294	2021-09-23 10:21:57.289436	\N	1
688	252	80	135	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:19:30.955345	\N	2021-08-31 07:12:45.39842	\N
664	252	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-27 15:20:47.079597	2021-08-28 16:05:21.429609	2021-08-31 07:12:45.39842	\N
670	252	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-28 16:05:47.017529	\N	2021-08-31 07:12:45.39842	\N
671	252	66	125	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-28 16:05:48.481976	2021-08-28 17:39:19.977414	2021-08-31 07:12:45.39842	\N
669	252	54	98	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-28 16:05:45.962893	\N	2021-08-31 07:12:45.39842	\N
681	252	67	113	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:08:43.185913	\N	2021-08-31 07:12:45.39842	\N
682	252	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:09:21.726027	\N	2021-08-31 07:12:45.39842	\N
683	252	85	144	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:09:25.611	\N	2021-08-31 07:12:45.39842	\N
668	253	87	148	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-28 16:05:36.051439	\N	2021-08-31 07:12:54.690172	\N
692	259	24	29	\N	1	0	11	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-08-31 07:11:31.680609	2021-09-23 09:31:31.620156	\N	1
729	254	62	108	\N	10	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 14:13:27.35917	\N	2021-09-11 11:13:08.466075	\N
663	251	89	166	\N	17	0	1	3000	2499	7	Magnum	Icecream	saas/itemicon/default.png	2021-08-27 11:42:46.660407	2021-08-29 16:35:56.394494	\N	10
678	256	75	127	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 16:48:10.253876	\N	2021-09-06 15:42:00.908065	\N
508	205	82	139	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-25 15:29:33.011072	\N	2021-08-30 14:51:51.715232	\N
696	260	54	98	\N	1	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-08-31 07:13:09.642156	2021-08-31 07:14:01.865645	\N	200
638	240	71	118	\N	3	0	1	120	115	5	chicken legg	xyz	saas/itemicon/default.png	2021-08-26 05:38:36.136106	2021-08-30 15:19:19.755971	\N	250
680	240	70	117	\N	1	0	1	30	20	7	Chips	Lays	saas/itemicon/default.png	2021-08-30 15:18:02.625727	2021-08-30 15:19:19.755971	\N	1
679	240	69	116	\N	2	0	1	60	55	4	Milk	Amul	saas/itemicon/default.png	2021-08-30 15:17:59.168917	2021-08-30 15:19:19.755971	\N	1
697	260	79	134	\N	1	0	1	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-08-31 07:13:18.202516	2021-08-31 07:14:01.865645	\N	1
674	210	89	166	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 16:27:19.401359	\N	2021-08-31 07:42:24.359617	\N
673	210	56	100	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 15:58:58.521958	\N	2021-08-31 07:42:25.42785	\N
667	210	24	150	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-28 06:35:19.935086	\N	2021-08-31 07:42:26.187878	\N
698	260	81	138	\N	1	0	1	15	9	7	Cauliflower	fresh	saas/itemicon/default.png	2021-08-31 07:13:19.777901	2021-08-31 07:14:01.865645	\N	1
699	260	80	135	\N	1	0	1	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-08-31 07:13:20.134625	2021-08-31 07:14:01.865645	\N	2
523	210	26	56	\N	14	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-25 17:53:10.440594	2021-08-31 07:42:46.699189	\N	1
700	261	26	56	\N	2	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-31 07:14:03.941377	2021-08-31 07:14:12.260128	\N	1
702	263	54	98	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:22:00.641451	\N	2021-08-31 07:23:36.342149	\N
703	263	66	125	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:22:05.468309	\N	2021-08-31 07:23:36.342149	\N
720	274	66	125	\N	10	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-08-31 10:24:23.206054	2021-08-31 10:24:33.472326	\N	5
711	268	26	56	\N	0	1	10	\N	\N	\N	\N	\N	\N	2021-08-31 08:27:37.295855	2021-08-31 10:43:33.803604	2021-08-31 08:37:51.445596	\N
726	276	77	131	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:24:14.336126	\N	2021-08-31 13:13:03.211706	\N
712	269	62	108	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 08:33:58.563905	\N	2021-08-31 09:43:53.656571	\N
713	269	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 08:33:59.679972	\N	2021-08-31 09:43:53.656571	\N
709	266	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:45:00.472427	2021-08-31 08:10:24.974861	2021-08-31 08:19:23.411605	\N
714	268	89	167	\N	0	1	10	\N	\N	\N	\N	\N	\N	2021-08-31 09:43:37.689644	2021-08-31 10:43:33.806373	2021-08-31 09:44:15.585331	\N
716	270	89	167	\N	10	0	11	600	500	7	Magnum	Icecream	saas/itemicon/default.png	2021-08-31 09:47:48.691976	2021-09-01 04:35:26.134161	\N	2
710	267	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 08:19:30.155022	2021-08-31 08:24:47.984825	2021-08-31 08:27:29.997062	\N
705	265	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:23:47.641043	\N	2021-08-31 09:47:38.736795	\N
706	265	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:23:49.11108	\N	2021-08-31 09:47:38.736795	\N
707	265	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:23:50.377099	\N	2021-08-31 09:47:38.736795	\N
715	268	26	56	\N	2	1	10	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-08-31 09:44:02.593753	2021-08-31 10:43:33.810159	\N	1
708	265	82	139	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 07:23:55.386377	\N	2021-08-31 09:47:38.736795	\N
727	276	90	168	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:24:25.070209	\N	2021-08-31 13:13:03.211706	\N
718	272	51	114	\N	10	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-08-31 09:57:46.344974	2021-08-31 09:58:16.015934	\N	11
1159	467	74	126	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:31:33.086773	\N	2021-09-22 16:31:50.921545	\N
687	258	54	98	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:15:00.418944	2021-08-31 06:16:31.185342	2021-08-31 09:55:56.676163	\N
689	258	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:22:33.858973	\N	2021-08-31 09:55:56.676163	\N
690	258	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:22:36.02698	\N	2021-08-31 09:55:56.676163	\N
691	258	90	168	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 06:29:20.027222	\N	2021-08-31 09:55:56.676163	\N
723	276	54	98	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:13:56.666642	\N	2021-08-31 13:13:03.211706	\N
724	276	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:19:21.216813	\N	2021-08-31 13:13:03.211706	\N
722	276	66	125	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:06:04.638348	\N	2021-08-31 13:13:03.211706	\N
725	276	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:23:38.267695	\N	2021-08-31 13:13:03.211706	\N
728	276	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 11:40:24.733555	\N	2021-08-31 13:13:03.211706	\N
1178	462	26	47	\N	6	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 10:33:28.432052	2021-09-23 10:34:06.245876	\N	500
730	277	87	148	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 16:54:25.046595	2021-08-31 19:35:53.205248	2021-08-31 19:36:26.055252	\N
731	278	87	148	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:37:30.89615	\N	2021-08-31 19:39:32.632594	\N
732	279	87	148	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:40:25.080424	\N	2021-08-31 19:41:05.863019	\N
733	280	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:47:24.453238	\N	2021-08-31 19:47:42.510967	\N
734	280	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:47:33.808019	\N	2021-08-31 19:47:42.510967	\N
746	286	79	134	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-02 07:39:18.348032	\N	2021-09-02 07:58:39.472082	\N
677	256	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 16:48:00.869193	\N	2021-09-06 15:42:00.908065	\N
675	255	62	108	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 16:46:00.619727	\N	2021-09-06 15:41:58.926441	\N
676	256	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 16:47:58.91321	\N	2021-09-06 15:42:00.908065	\N
717	271	51	114	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 09:57:26.895087	\N	2021-09-09 06:50:56.154983	\N
1161	468	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:32:56.992533	\N	2021-09-22 16:56:45.163518	\N
1176	462	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 10:33:27.58561	2021-09-23 10:33:42.139638	2021-09-23 10:33:43.755919	\N
1177	462	24	29	\N	3	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 10:33:27.587598	2021-09-23 10:34:06.245876	\N	1
1182	481	24	221	\N	7	0	1	60	55	5	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 10:50:32.709015	2021-09-23 10:50:39.438464	\N	750
1201	487	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 13:00:00.514971	2021-09-23 13:00:06.391546	\N	500
1217	493	53	97	\N	1	0	11	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-24 07:26:46.009093	2021-09-24 07:27:37.113134	\N	1
736	281	87	164	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:48:04.325054	2021-08-31 19:50:26.935183	2021-08-31 20:02:14.273195	\N
735	281	87	148	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 19:47:51.816851	2021-08-31 19:51:01.611263	2021-08-31 20:02:14.273195	\N
1229	500	82	139	\N	2	0	1	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-09-25 05:55:54.366651	2021-09-27 07:17:40.572052	\N	500
1248	505	77	131	\N	7	0	1	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-09-28 11:28:48.451752	2021-09-28 13:23:23.751012	\N	500
739	283	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 00:58:21.192171	2021-09-01 06:18:52.44442	\N	\N
1245	505	74	126	\N	9	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-09-28 11:28:41.41176	2021-09-28 13:23:23.751012	\N	500
1261	514	27	50	\N	3	0	1	120	115	5	Butter	Amul	saas/itemicon/default.png	2021-09-29 09:58:37.225861	2021-09-29 09:59:12.776604	\N	500
743	284	51	114	\N	5	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-01 11:04:10.837945	2021-09-01 17:35:11.08598	\N	11
749	287	90	168	\N	10	0	1	24999	23000	7	OnePlus	Mobile	saas/itemicon/default.png	2021-09-02 08:03:53.144628	2021-09-02 08:04:07.334806	\N	1
742	283	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 05:58:04.030989	2021-09-13 09:58:03.458375	\N	\N
738	283	66	125	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 00:58:11.040594	2021-09-01 06:18:50.214406	\N	\N
737	282	54	153	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-08-31 20:00:13.294206	\N	2021-09-13 15:57:56.47631	\N
740	283	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 00:58:22.639107	\N	\N	\N
741	283	66	112	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 04:29:01.677185	\N	\N	\N
745	255	63	109	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-01 17:36:08.655988	\N	2021-09-06 15:41:58.926441	\N
1246	505	53	97	\N	2	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-28 11:28:43.732646	2021-09-28 13:23:23.751012	\N	1
1219	495	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-24 07:34:32.270697	2021-10-01 06:47:29.683918	2021-10-01 06:47:37.471579	\N
1179	479	24	29	\N	7	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 10:48:14.627069	2021-09-23 10:48:29.09031	\N	1
1194	484	79	134	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:43.943623	\N	2021-09-23 13:01:36.457414	\N
1215	493	67	152	\N	1	0	11	100	50	7	a	b	saas/itemicon/default.png	2021-09-24 07:26:42.344147	2021-09-24 07:27:37.119393	\N	2
1163	469	26	47	\N	2	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-22 16:36:37.701345	2021-09-27 09:51:09.842321	\N	500
1232	469	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-27 09:50:42.734772	2021-09-27 09:51:09.842321	\N	1
1233	501	76	130	\N	2	0	1	75	65	5	Onion	fresh	saas/itemicon/default.png	2021-09-27 09:57:00.59821	2021-09-27 16:32:16.253137	\N	500
1263	517	26	47	\N	4	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-30 06:01:13.692527	2021-09-30 06:01:26.102401	\N	500
721	275	54	153	\N	10	0	11	120	110	5	Orange	new	saas/itemicon/default.png	2021-08-31 10:51:39.268077	2021-09-01 04:30:20.512428	\N	400
744	285	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-01 13:33:32.089591	2021-09-01 13:33:38.653427	\N	250
771	300	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:55:02.272037	\N	2021-09-15 14:47:22.004988	\N
770	300	26	56	\N	9	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:54:59.482294	\N	2021-09-15 14:47:22.004988	\N
775	302	70	117	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 07:15:37.662608	\N	\N	\N
776	302	71	118	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 07:15:41.256966	\N	\N	\N
777	302	72	121	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 07:18:57.629096	\N	\N	\N
795	310	70	117	\N	1	0	1	120	100	7	Chips	Lays	saas/itemicon/default.png	2021-09-09 10:59:40.392272	2021-09-09 11:07:53.45127	\N	1
747	286	54	153	\N	10	0	1	120	110	5	Orange	new	saas/itemicon/default.png	2021-09-02 07:58:33.901489	2021-09-02 07:58:49.956255	\N	400
780	304	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 14:52:23.403996	\N	2021-09-08 15:30:44.141752	\N
778	303	62	108	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 14:44:12.954006	\N	2021-09-08 15:30:45.631803	\N
779	303	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 14:44:15.949382	\N	2021-09-08 15:30:45.631803	\N
781	305	62	108	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 15:31:07.408399	\N	2021-09-08 15:31:19.042049	\N
782	305	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 15:31:12.354292	\N	2021-09-08 15:31:19.042049	\N
748	287	67	113	\N	10	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-09-02 08:03:21.830878	2021-09-02 08:04:07.334806	\N	1
783	306	62	108	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 15:32:49.606884	\N	2021-09-08 15:32:57.212108	\N
784	307	62	108	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 15:34:19.900434	\N	2021-09-08 15:34:24.293086	\N
803	315	70	117	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:05:26.687054	\N	2021-09-09 15:05:42.483609	\N
796	311	70	117	\N	2	0	1	120	100	7	Chips	Lays	saas/itemicon/default.png	2021-09-09 11:13:23.025296	2021-09-09 11:13:55.310061	\N	1
761	294	67	152	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:04:24.402458	2021-09-07 12:06:28.323539	2021-09-07 12:06:37.033089	\N
786	298	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:06:47.84438	\N	2021-09-10 02:25:02.292419	\N
750	288	80	137	\N	10	0	1	300	260	3	Tomato	fresh	saas/itemicon/default.png	2021-09-02 12:48:11.560023	2021-09-02 12:48:21.65631	\N	3
751	289	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-02 14:58:14.171929	\N	\N	\N
810	298	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:22:58.419076	\N	2021-09-10 02:25:02.292419	\N
814	320	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:26:39.255985	\N	2021-09-10 02:27:22.575276	\N
788	309	89	167	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:38:49.475504	\N	2021-09-09 12:17:06.554077	\N
789	309	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:39:12.986832	\N	2021-09-09 12:17:06.554077	\N
791	309	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:41:36.526651	\N	2021-09-09 12:17:06.554077	\N
792	309	89	166	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:42:40.968004	\N	2021-09-09 12:17:06.554077	\N
762	295	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:06:42.228847	2021-09-07 12:08:09.437343	2021-09-07 12:10:31.357244	\N
754	291	26	56	\N	4	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-04 14:45:20.091995	2021-09-04 14:45:33.253506	\N	1
755	291	27	57	\N	3	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-04 14:45:21.322113	2021-09-04 14:45:33.253506	\N	50
756	291	49	89	\N	2	0	1	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-09-04 14:45:22.36259	2021-09-04 14:45:33.253506	\N	1
790	309	26	46	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:39:18.117776	\N	2021-09-09 12:17:06.554077	\N
757	292	80	135	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 07:24:23.606066	2021-09-07 09:36:47.844881	2021-09-07 09:36:53.785597	\N
758	292	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 07:46:21.986873	\N	2021-09-07 09:36:53.785597	\N
759	292	66	112	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 09:36:42.776314	2021-09-07 09:36:50.900298	2021-09-07 09:36:53.785597	\N
793	271	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:50:49.529195	\N	2021-09-09 06:50:56.154983	\N
811	298	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:23:00.181731	\N	2021-09-10 02:25:02.292419	\N
752	290	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-04 14:37:04.418303	\N	2021-09-09 07:02:33.414839	\N
760	293	66	112	\N	10	0	1	250	225	3	Apple	Apple	saas/itemicon/default.png	2021-09-07 09:38:22.601658	2021-09-07 09:38:34.5766	\N	2
753	290	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-04 14:37:09.263441	\N	2021-09-09 07:02:33.414839	\N
802	315	69	116	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:05:23.834481	\N	2021-09-09 15:05:42.483609	\N
763	296	67	152	\N	3	0	1	100	50	7	a	b	saas/itemicon/default.png	2021-09-07 12:10:37.578569	2021-09-09 08:35:00.641718	\N	2
794	309	75	127	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 07:43:08.858408	\N	2021-09-09 12:17:06.554077	\N
797	312	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 12:18:30.82967	\N	2021-09-09 12:22:52.45603	\N
768	299	72	121	\N	1	0	1	100	85	5	Cheese	Ananda	saas/itemicon/default.png	2021-09-07 12:54:45.064028	2021-09-09 10:50:37.782465	\N	500
769	299	71	118	\N	1	0	1	120	115	5	chicken legg	xyz	saas/itemicon/default.png	2021-09-07 12:54:48.513286	2021-09-09 10:50:37.782465	\N	250
767	299	70	117	\N	1	0	1	30	15	7	Chips	Lays	saas/itemicon/default.png	2021-09-07 12:54:35.337303	2021-09-09 10:50:37.782465	\N	1
798	312	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 12:18:34.604431	\N	2021-09-09 12:22:52.45603	\N
808	319	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:47:23.451018	\N	2021-09-09 15:47:32.734528	\N
799	313	26	56	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 12:26:02.1479	\N	2021-09-09 12:27:27.114768	\N
800	313	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 12:27:10.580403	\N	2021-09-09 12:27:27.114768	\N
809	319	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:47:25.007966	\N	2021-09-09 15:47:32.734528	\N
787	297	89	166	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 06:15:59.718703	\N	2021-09-10 01:52:51.858933	\N
765	297	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:36:40.993839	\N	2021-09-10 01:52:51.858933	\N
806	317	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:46:33.607703	\N	2021-09-09 15:46:47.630748	\N
805	317	66	125	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:46:31.793246	\N	2021-09-09 15:46:47.630748	\N
772	300	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:55:15.284161	\N	2021-09-15 14:47:22.004988	\N
807	318	87	148	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:47:06.350637	\N	2021-09-09 15:47:10.206365	\N
764	298	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:36:40.992383	\N	2021-09-10 02:25:02.292419	\N
766	298	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 12:46:00.839105	\N	2021-09-10 02:25:02.292419	\N
812	298	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:23:01.950314	\N	2021-09-10 02:25:02.292419	\N
813	298	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:24:30.952541	\N	2021-09-10 02:25:02.292419	\N
815	321	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:29:35.59905	\N	2021-09-10 02:29:41.611591	\N
816	322	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:31:45.84333	\N	2021-09-10 02:31:54.128775	\N
817	323	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:35:18.398548	\N	2021-09-10 02:35:28.967633	\N
821	324	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:40:34.454238	\N	2021-09-10 03:05:07.78457	\N
819	324	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:38:51.824691	\N	2021-09-10 03:05:07.78457	\N
820	324	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:39:14.581347	\N	2021-09-10 03:05:07.78457	\N
785	308	62	108	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-08 15:36:17.123243	\N	2021-10-07 13:38:08.073013	\N
818	324	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 02:38:34.064187	\N	2021-09-10 03:05:07.78457	\N
822	325	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 03:05:38.789249	\N	2021-09-10 03:06:11.808509	\N
823	326	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:32:05.136166	\N	2021-09-10 06:38:27.988118	\N
824	326	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:36:12.47353	\N	2021-09-10 06:38:27.988118	\N
825	326	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:37:52.312106	\N	2021-09-10 06:38:27.988118	\N
774	301	63	109	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 13:14:55.358308	\N	2021-09-16 10:58:18.896133	\N
773	301	62	108	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-07 13:14:54.452975	\N	2021-09-16 10:58:18.896133	\N
826	326	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:38:04.681478	\N	2021-09-10 06:38:27.988118	\N
827	327	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:42:24.010116	\N	2021-09-10 06:56:08.77819	\N
829	327	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:42:24.961731	\N	2021-09-10 06:56:08.77819	\N
832	328	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:28:07.003904	\N	2021-09-10 07:34:16.874087	\N
1165	470	74	126	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:57:58.454477	\N	2021-09-22 19:36:55.322004	\N
1264	518	26	47	\N	2	1	10	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-30 06:08:31.841646	2021-09-30 07:35:11.256608	\N	500
1180	480	26	46	\N	3	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 10:50:13.521303	2021-09-23 10:50:27.142346	\N	250
839	335	51	114	\N	4	5	10	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-10 15:38:30.882036	2021-09-22 05:33:00.286207	\N	11
841	335	79	134	\N	2	5	10	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-09-10 17:11:15.468962	2021-09-22 05:33:00.288503	\N	1
1203	489	24	221	\N	1	0	1	60	55	5	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 13:10:58.224898	2021-09-23 13:11:04.909287	\N	750
1205	490	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 13:16:13.571064	2021-09-23 13:16:20.435784	\N	500
1206	490	27	57	\N	1	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-23 13:16:14.674165	2021-09-23 13:16:20.435784	\N	50
1231	469	24	222	\N	1	0	1	300	285	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-27 09:50:41.214197	2021-09-27 09:51:09.842321	\N	5
1164	469	24	29	\N	3	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-22 16:36:38.849482	2021-09-27 09:51:09.842321	\N	1
1220	491	49	89	\N	2	0	1	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-09-24 07:35:46.521536	2021-09-28 12:03:45.441337	\N	1
1268	520	67	113	\N	2	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-09-30 07:43:43.04835	2021-09-30 08:28:28.924336	\N	1
828	327	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 06:42:24.365171	\N	2021-09-10 06:56:08.77819	\N
836	332	87	148	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 15:24:57.679072	\N	2021-09-10 15:25:31.905245	\N
1166	470	80	135	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:58:01.629937	2021-09-22 19:36:45.332777	2021-09-22 19:36:55.322004	\N
1265	519	26	46	\N	1	0	11	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-30 06:37:09.22972	2021-09-30 07:37:08.602501	\N	250
1181	480	27	50	\N	4	0	1	120	115	5	Butter	Amul	saas/itemicon/default.png	2021-09-23 10:50:14.289929	2021-09-23 10:50:27.142346	\N	500
1204	490	24	222	\N	1	0	1	300	285	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-23 13:16:12.95279	2021-09-23 13:16:20.435784	\N	5
1221	496	67	152	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-09-24 07:37:28.757783	\N	2021-09-24 07:39:23.682016	\N
1234	501	77	131	\N	1	0	1	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-09-27 09:57:06.733987	2021-09-27 16:32:16.253137	\N	500
1235	501	85	145	\N	1	0	1	180	140	3	Beans	fresh	saas/itemicon/default.png	2021-09-27 13:51:33.254288	2021-09-27 16:32:16.253137	\N	2
1250	508	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-28 11:47:31.700264	2021-09-28 11:47:38.154233	\N	500
830	328	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:28:05.736049	\N	2021-09-10 07:34:16.874087	\N
1167	470	85	145	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 16:58:03.995225	\N	2021-09-22 19:36:55.322004	\N
1183	478	67	152	\N	1	0	1	100	50	7	a	b	saas/itemicon/default.png	2021-09-23 12:34:07.637412	2021-09-23 12:40:03.882904	\N	2
1266	520	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 07:43:39.261812	\N	2021-09-30 07:43:49.31185	\N
1202	488	54	98	\N	2	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-23 13:06:02.27301	2021-09-24 07:19:17.518831	\N	200
1223	497	24	222	\N	4	0	11	300	285	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-24 07:48:31.549605	2021-09-24 07:48:59.874147	\N	5
1189	483	89	165	\N	1	0	11	300	280	7	Magnum	Icecream	saas/itemicon/default.png	2021-09-23 12:50:15.228572	2021-09-24 09:09:23.772453	\N	1
1236	502	54	98	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-28 04:47:10.082105	\N	2021-09-28 04:47:20.225098	\N
1251	509	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-28 12:02:53.330577	2021-09-28 12:02:59.26152	\N	500
1213	491	26	46	\N	2	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 15:29:15.874246	2021-09-28 12:03:45.441337	\N	250
831	328	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:28:06.389767	\N	2021-09-10 07:34:16.874087	\N
1267	520	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-09-30 07:43:40.170356	2021-09-30 08:28:28.924336	\N	5
1184	478	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:34:08.265121	2021-09-23 12:35:42.403592	2021-09-23 12:35:53.575307	\N
1195	484	77	131	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 12:50:44.772817	\N	2021-09-23 13:01:36.457414	\N
1207	488	51	114	\N	2	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-23 15:16:31.950372	2021-09-24 07:19:17.524728	\N	11
1209	488	53	97	\N	4	0	11	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-23 15:16:35.235395	2021-09-24 07:19:17.530568	\N	1
1224	497	26	47	\N	4	0	11	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-24 07:48:32.857662	2021-09-24 07:48:59.878879	\N	500
1237	502	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-28 04:47:15.597611	\N	2021-09-28 04:47:20.225098	\N
1252	509	27	50	\N	1	0	1	120	115	5	Butter	Amul	saas/itemicon/default.png	2021-09-28 12:02:54.140865	2021-09-28 12:02:59.26152	\N	500
1212	491	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-23 15:29:13.841198	2021-09-28 12:03:45.441337	\N	1
833	329	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:34:53.918375	\N	2021-09-10 07:34:58.875081	\N
834	330	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:40:32.766762	\N	2021-09-10 07:40:36.720125	\N
835	331	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 07:41:25.752153	\N	2021-09-10 07:41:29.720163	\N
837	333	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 15:25:27.141937	\N	2021-09-10 15:25:33.51514	\N
838	334	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 15:25:55.435306	\N	2021-09-10 15:26:00.672357	\N
1169	472	71	118	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 19:26:44.618894	\N	\N	\N
1185	478	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-23 12:34:09.485179	2021-09-23 12:40:03.882904	\N	1
1244	505	51	114	\N	2	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-28 11:28:39.493494	2021-09-28 13:23:23.751012	\N	11
1208	488	74	126	\N	2	0	11	170	150	5	Banana	new	saas/itemicon/default.png	2021-09-23 15:16:34.170515	2021-09-24 07:19:17.536444	\N	500
846	336	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 17:12:34.819839	\N	2021-09-11 11:13:09.890785	\N
1269	521	27	50	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 08:02:40.465606	\N	2021-10-01 13:05:30.23616	\N
1253	510	26	47	\N	0	1	10	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-28 12:16:09.153935	2021-10-09 18:06:53.24725	\N	500
1568	662	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:35:22.511365	2021-10-13 12:36:12.013841	2021-10-13 12:36:13.045991	\N
1225	483	26	47	\N	1	0	11	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-24 09:08:06.565401	2021-09-24 09:09:23.77859	\N	500
1188	483	27	57	\N	1	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-23 12:50:13.029893	2021-09-24 09:09:23.784826	\N	50
844	335	76	130	\N	0	5	10	\N	\N	\N	\N	\N	\N	2021-09-10 17:11:20.178655	2021-09-22 05:33:00.292328	2021-09-13 17:28:32.352245	\N
840	335	53	97	\N	10	5	10	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-10 15:38:31.816147	2021-09-22 05:33:00.295733	\N	1
842	335	80	135	\N	1	5	10	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-09-10 17:11:17.173634	2021-09-22 05:33:00.299092	\N	2
1238	503	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-28 04:47:23.202829	\N	2021-09-28 04:47:26.945034	\N
672	254	63	109	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-08-29 14:59:40.956141	2021-08-29 16:27:29.633017	2021-09-11 11:13:08.466075	\N
847	254	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-11 11:13:02.949596	\N	2021-09-11 11:13:08.466075	\N
845	336	24	150	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-10 17:12:25.024207	\N	2021-09-11 11:13:09.890785	\N
848	337	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 01:46:00.528104	\N	2021-09-12 01:46:10.082898	\N
849	338	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 01:58:49.780134	\N	2021-09-12 01:59:03.724083	\N
850	339	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:07:16.850791	\N	2021-09-12 02:25:58.029188	\N
851	339	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:07:53.866636	\N	2021-09-12 02:25:58.029188	\N
852	339	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:20:03.204807	\N	2021-09-12 02:25:58.029188	\N
853	340	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:26:15.361936	\N	2021-09-12 02:26:58.598809	\N
854	340	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:26:23.518726	\N	2021-09-12 02:26:58.598809	\N
855	341	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:29:37.540509	\N	2021-09-12 02:31:15.808489	\N
856	341	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:29:39.816049	\N	2021-09-12 02:31:15.808489	\N
857	341	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:29:40.78576	\N	2021-09-12 02:31:15.808489	\N
858	342	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:33:34.433474	\N	2021-09-12 02:33:41.820393	\N
859	343	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:38:02.719795	\N	2021-09-12 02:38:15.805671	\N
860	343	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:38:04.893335	\N	2021-09-12 02:38:15.805671	\N
861	343	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:38:07.525393	\N	2021-09-12 02:38:15.805671	\N
862	344	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:55:43.080322	\N	2021-09-12 02:56:16.735206	\N
863	344	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:55:45.227946	\N	2021-09-12 02:56:16.735206	\N
864	344	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:55:46.376951	\N	2021-09-12 02:56:16.735206	\N
890	352	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:05:35.652267	\N	2021-09-13 09:21:49.775048	\N
869	314	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:11:17.32745	2021-09-13 06:11:20.175118	2021-09-13 06:11:21.451296	\N
871	346	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:12:10.31207	\N	2021-09-13 06:12:17.343118	\N
893	353	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:22:12.354723	\N	2021-09-13 09:22:13.020714	\N
870	314	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:12:07.662152	2021-09-13 06:12:34.144667	2021-09-13 06:12:46.550391	\N
872	347	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:13:08.320561	\N	2021-09-13 06:13:12.563531	\N
873	314	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:13:19.457162	2021-09-13 06:13:23.412527	2021-09-13 06:13:26.93296	\N
875	348	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:14:45.486497	\N	2021-09-13 06:14:52.261186	\N
874	314	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:13:35.80334	2021-09-13 06:17:20.842496	2021-09-13 06:17:26.573543	\N
894	354	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:22:20.375533	\N	2021-09-13 09:22:20.885052	\N
895	355	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:22:26.008618	\N	2021-09-13 09:22:26.544105	\N
801	314	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 12:42:29.286069	2021-09-13 06:05:39.596987	2021-09-13 06:05:52.252755	\N
868	314	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:08:00.075672	2021-09-13 06:09:36.597723	2021-09-13 06:09:40.049148	\N
876	349	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:17:34.061946	\N	2021-09-13 06:19:39.475716	\N
866	345	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:56:35.084823	\N	2021-09-13 06:10:08.219859	\N
867	345	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:56:35.926627	\N	2021-09-13 06:10:08.219859	\N
865	345	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-12 02:56:33.949457	\N	2021-09-13 06:10:08.219859	\N
879	349	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:17:35.984312	\N	2021-09-13 06:19:39.475716	\N
877	349	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:17:34.946124	\N	2021-09-13 06:19:39.475716	\N
880	349	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:19:22.548197	\N	2021-09-13 06:19:39.475716	\N
901	357	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 10:54:52.516138	\N	2021-09-13 11:05:16.093365	\N
902	357	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:04:38.674353	2021-09-13 11:04:59.103363	2021-09-13 11:05:16.093365	\N
903	357	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:05:10.72439	\N	2021-09-13 11:05:16.093365	\N
900	357	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 10:54:47.530852	\N	2021-09-13 11:05:16.093365	\N
878	314	67	152	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:17:35.292297	2021-09-13 07:06:54.473243	\N	\N
888	351	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:36:25.448441	\N	2021-09-13 09:04:51.022279	\N
889	351	26	47	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:46:31.377811	\N	2021-09-13 09:04:51.022279	\N
887	351	26	56	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:36:10.863451	\N	2021-09-13 09:04:51.022279	\N
885	351	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:34:08.447964	\N	2021-09-13 09:04:51.022279	\N
884	351	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:34:08.144423	\N	2021-09-13 09:04:51.022279	\N
886	351	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:34:09.064438	\N	2021-09-13 09:04:51.022279	\N
883	350	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:24:27.434879	\N	2021-09-13 06:33:54.739111	\N
881	350	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:23:33.11218	2021-09-13 06:33:40.264777	2021-09-13 06:33:54.739111	\N
882	350	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 06:23:33.703797	\N	2021-09-13 06:33:54.739111	\N
904	358	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:18:52.868713	\N	2021-09-13 11:24:18.608787	\N
905	358	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:18:55.153407	\N	2021-09-13 11:24:18.608787	\N
909	361	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:47:43.849237	\N	2021-09-13 14:43:14.042201	\N
911	361	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:48:34.656881	\N	2021-09-13 14:43:14.042201	\N
898	356	26	47	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:26:20.434032	2021-09-13 09:41:34.73789	2021-09-13 10:51:41.852587	\N
907	359	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:28:01.119445	\N	2021-09-13 11:39:47.440382	\N
891	352	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:05:37.949108	\N	2021-09-13 09:21:49.775048	\N
892	352	26	47	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:05:42.766356	2021-09-13 09:15:49.353127	2021-09-13 09:21:49.775048	\N
896	356	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:26:19.187079	2021-09-13 09:41:37.292944	2021-09-13 10:51:41.852587	\N
897	356	26	56	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 09:26:19.810212	2021-09-13 09:44:20.312715	2021-09-13 10:51:41.852587	\N
899	356	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 10:24:51.371936	\N	2021-09-13 10:51:41.852587	\N
906	359	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 11:27:19.254423	2021-09-13 11:39:29.33997	2021-09-13 11:39:47.440382	\N
910	361	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:47:44.027608	\N	2021-09-13 14:43:14.042201	\N
917	361	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:09:01.745273	\N	2021-09-13 14:43:14.042201	\N
914	362	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:54:46.494949	2021-09-13 13:55:06.961758	2021-09-13 13:55:07.954958	\N
908	360	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:44:00.485961	2021-09-13 13:54:16.101015	2021-09-13 13:54:39.60435	\N
912	361	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 13:48:57.777512	\N	2021-09-13 14:43:14.042201	\N
929	368	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:56:54.283495	\N	2021-09-14 03:00:45.722456	\N
915	361	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:08:31.712776	\N	2021-09-13 14:43:14.042201	\N
918	363	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:44:22.521295	\N	2021-09-13 14:48:53.037179	\N
916	361	26	47	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:08:42.789929	\N	2021-09-13 14:43:14.042201	\N
921	363	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:48:43.990303	\N	2021-09-13 14:48:53.037179	\N
919	363	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:48:36.855615	\N	2021-09-13 14:48:53.037179	\N
920	363	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:48:37.530803	\N	2021-09-13 14:48:53.037179	\N
922	364	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 14:57:07.050763	\N	2021-09-13 15:02:06.646652	\N
923	364	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:01:40.505391	\N	2021-09-13 15:02:06.646652	\N
924	365	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:07:38.740719	\N	2021-09-13 15:13:47.91677	\N
926	366	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:26:20.895536	\N	2021-09-13 15:30:00.114425	\N
925	366	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:26:15.788913	\N	2021-09-13 15:30:00.114425	\N
927	366	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 15:26:24.79439	\N	2021-09-13 15:30:00.114425	\N
1170	473	87	148	\N	36	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 19:33:18.781654	\N	2021-10-05 16:19:58.161239	\N
931	367	63	109	\N	15	0	1	25	20	7	Cookies	Amul	saas/itemicon/default.png	2021-09-13 16:22:56.001997	2021-09-13 16:25:41.906634	\N	1
928	367	62	108	\N	15	0	1	45	20	4	Milk	Amul	saas/itemicon/default.png	2021-09-13 15:43:01.845524	2021-09-13 16:25:41.906634	\N	1
932	370	26	56	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 16:33:13.736989	\N	2021-09-22 04:32:56.648428	\N
933	370	89	165	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 16:33:17.014392	\N	2021-09-22 04:32:56.648428	\N
913	362	54	98	\N	2	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-13 13:54:44.611969	2021-09-13 18:28:43.053142	\N	200
966	381	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:47:27.310139	2021-09-14 05:47:40.831669	2021-09-14 05:48:00.491777	\N
992	388	89	166	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:03:50.131757	2021-09-14 10:18:33.84371	2021-09-14 10:30:08.342637	\N
967	381	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:47:55.659574	\N	2021-09-14 05:48:00.491777	\N
937	368	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 02:55:15.951301	\N	2021-09-14 03:00:45.722456	\N
938	368	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 02:58:14.803219	\N	2021-09-14 03:00:45.722456	\N
993	388	89	167	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:03:53.77025	2021-09-14 10:18:34.733747	2021-09-14 10:30:08.342637	\N
986	388	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:02:40.364015	2021-09-14 10:19:42.254268	2021-09-14 10:30:08.342637	\N
994	388	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:21:35.074617	\N	2021-09-14 10:30:08.342637	\N
939	372	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 03:11:45.832143	\N	2021-09-14 04:36:05.287075	\N
941	372	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 03:13:55.65429	\N	2021-09-14 04:36:05.287075	\N
940	372	26	46	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 03:11:46.566763	\N	2021-09-14 04:36:05.287075	\N
942	373	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:39:05.479918	\N	2021-09-14 04:45:13.374332	\N
943	373	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:39:18.990438	\N	2021-09-14 04:45:13.374332	\N
944	373	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:41:51.168356	\N	2021-09-14 04:45:13.374332	\N
945	373	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:43:06.41794	\N	2021-09-14 04:45:13.374332	\N
946	374	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:57:28.543025	\N	2021-09-14 04:57:36.471953	\N
947	375	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 04:57:48.734584	\N	2021-09-14 05:02:25.90615	\N
948	375	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:02:21.846415	\N	2021-09-14 05:02:25.90615	\N
949	376	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:03:40.24042	\N	2021-09-14 05:25:42.830307	\N
950	376	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:04:39.616364	\N	2021-09-14 05:25:42.830307	\N
951	377	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:31:49.556942	\N	2021-09-14 05:32:11.826367	\N
952	377	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:31:54.249384	\N	2021-09-14 05:32:11.826367	\N
953	377	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:31:56.041085	\N	2021-09-14 05:32:11.826367	\N
954	378	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:34:04.925745	\N	2021-09-14 05:34:09.847687	\N
955	379	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:34:19.821316	\N	2021-09-14 05:35:55.777861	\N
957	379	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:35:45.059789	\N	2021-09-14 05:35:55.777861	\N
958	379	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:35:49.414183	\N	2021-09-14 05:35:55.777861	\N
956	379	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:35:41.669532	\N	2021-09-14 05:35:55.777861	\N
959	380	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:35:58.291994	\N	2021-09-14 05:39:04.252352	\N
960	380	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:36:35.48784	\N	2021-09-14 05:39:04.252352	\N
961	380	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:36:52.101962	\N	2021-09-14 05:39:04.252352	\N
962	380	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:38:53.699939	\N	2021-09-14 05:39:04.252352	\N
963	380	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:38:55.739536	\N	2021-09-14 05:39:04.252352	\N
964	380	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:38:57.475103	\N	2021-09-14 05:39:04.252352	\N
995	388	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:30:00.640261	\N	2021-09-14 10:30:08.342637	\N
965	381	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:39:06.585	\N	2021-09-14 05:48:00.491777	\N
968	382	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:48:06.242421	2021-09-14 05:49:07.842758	2021-09-14 06:12:15.705951	\N
970	382	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:49:58.205925	\N	2021-09-14 06:12:15.705951	\N
969	382	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 05:49:55.781789	2021-09-14 06:08:56.81046	2021-09-14 06:12:15.705951	\N
972	382	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:12:00.961115	\N	2021-09-14 06:12:15.705951	\N
976	384	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:23:21.891466	2021-09-14 06:23:41.596593	2021-09-14 06:23:47.953398	\N
982	385	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 09:06:24.455403	2021-09-14 09:07:05.945266	2021-09-14 09:11:11.12485	\N
979	385	26	47	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 08:56:31.986085	2021-09-14 09:07:15.995149	2021-09-14 09:11:11.12485	\N
983	385	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 09:11:04.516022	\N	2021-09-14 09:11:11.12485	\N
1009	387	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:58:48.045808	2021-09-14 13:58:58.234291	2021-09-16 11:31:48.315476	\N
978	385	26	46	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:25:34.664384	2021-09-14 08:54:55.649652	2021-09-14 09:11:11.12485	\N
1002	390	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:45:20.318633	\N	2021-09-14 13:50:07.514018	\N
977	385	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:25:34.001292	2021-09-14 08:56:24.835788	2021-09-14 09:11:11.12485	\N
981	385	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 08:56:33.286718	2021-09-14 08:56:53.589212	2021-09-14 09:11:11.12485	\N
1001	390	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:45:18.488642	2021-09-14 10:52:00.539466	2021-09-14 13:50:07.514018	\N
980	385	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 08:56:32.662345	2021-09-14 08:57:02.619279	2021-09-14 09:11:11.12485	\N
984	386	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 09:12:01.650053	\N	2021-09-14 09:12:04.905327	\N
936	371	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 18:34:42.087187	2021-09-14 09:13:10.009403	2021-09-14 09:13:31.375687	\N
1175	478	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-23 07:06:31.405419	\N	2021-09-23 12:34:35.487149	\N
987	388	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:02:56.779063	2021-09-14 10:18:24.161949	2021-09-14 10:30:08.342637	\N
988	388	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:02:58.390559	2021-09-14 10:18:25.708966	2021-09-14 10:30:08.342637	\N
989	388	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:03:05.298284	2021-09-14 10:18:30.567619	2021-09-14 10:30:08.342637	\N
990	388	75	127	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:03:11.960524	2021-09-14 10:18:31.723784	2021-09-14 10:30:08.342637	\N
991	388	75	128	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:03:34.840912	2021-09-14 10:18:32.8339	2021-09-14 10:30:08.342637	\N
1000	390	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:45:16.502358	\N	2021-09-14 13:50:07.514018	\N
1003	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 11:15:41.705273	2021-09-14 13:57:25.726444	2021-09-16 11:31:48.315476	\N
998	389	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:41:09.952112	2021-09-14 10:41:21.488653	2021-09-14 10:43:42.279369	\N
997	389	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:41:09.329914	2021-09-14 10:41:36.85851	2021-09-14 10:43:42.279369	\N
996	389	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:41:09.108706	2021-09-14 10:42:20.478699	2021-09-14 10:43:42.279369	\N
999	389	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 10:43:29.178886	\N	2021-09-14 10:43:42.279369	\N
1004	391	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:50:14.959388	2021-09-14 14:10:47.415992	2021-09-14 14:11:27.73796	\N
1011	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 14:32:59.988326	2021-09-15 05:02:14.460195	2021-09-16 11:31:48.315476	\N
1006	391	24	222	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:50:16.624696	2021-09-14 14:10:38.351611	2021-09-14 14:11:27.73796	\N
1013	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 06:15:38.759522	2021-09-15 06:16:04.777161	2021-09-16 11:31:48.315476	\N
1005	391	24	221	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:50:15.702894	2021-09-14 14:10:40.702612	2021-09-14 14:11:27.73796	\N
1007	391	24	150	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:50:18.656743	2021-09-14 14:01:56.462303	2021-09-14 14:11:27.73796	\N
1016	392	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 08:54:31.142641	\N	2021-09-15 08:54:54.018868	\N
1015	387	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 06:35:58.126859	2021-09-15 14:27:02.754141	2021-09-16 11:31:48.315476	\N
1014	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 06:35:57.178196	2021-09-15 14:26:44.295782	2021-09-16 11:31:48.315476	\N
934	370	75	127	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 16:33:18.113927	2021-09-19 06:05:55.563903	2021-09-22 04:32:56.648428	\N
971	383	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:11:58.546055	\N	2021-09-16 06:05:25.40664	\N
1010	392	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 14:11:45.438652	2021-09-14 15:37:48.526276	2021-09-15 08:54:54.018868	\N
1018	393	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:01:40.964723	2021-09-15 09:06:30.833656	2021-09-15 09:28:34.521123	\N
1019	393	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:06:51.604343	2021-09-15 09:07:29.02849	2021-09-15 09:28:34.521123	\N
935	335	66	112	\N	0	5	10	\N	\N	\N	\N	\N	\N	2021-09-13 17:28:19.428787	2021-09-22 05:33:00.302382	2021-09-13 17:28:30.917177	\N
973	383	74	126	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:12:11.130165	\N	2021-09-16 06:05:25.40664	\N
974	383	85	144	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:12:12.140677	\N	2021-09-16 06:05:25.40664	\N
975	383	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 06:12:13.606168	\N	2021-09-16 06:05:25.40664	\N
1012	383	90	168	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 15:33:25.206344	\N	2021-09-16 06:05:25.40664	\N
1171	474	74	126	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 19:37:09.790699	\N	2021-10-05 19:32:19.089814	\N
1008	387	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 13:57:43.754363	\N	2021-09-16 11:31:48.315476	\N
1046	399	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:47:29.153591	2021-09-15 15:28:32.693044	2021-09-15 15:28:33.7617	\N
1017	393	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:00:40.201729	2021-09-15 09:28:10.901664	2021-09-15 09:28:34.521123	\N
1072	420	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 08:48:30.516776	2021-09-16 08:48:43.403709	\N	1
1071	419	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 08:06:21.356598	2021-09-16 08:25:31.700471	2021-09-16 08:55:46.971837	\N
1062	410	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:58:41.008067	2021-09-16 07:03:21.848026	2021-09-16 07:03:26.561615	\N
1020	394	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:33:38.059573	2021-09-15 09:34:01.179955	2021-09-15 09:37:13.252285	\N
1021	394	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:33:38.718236	2021-09-15 09:34:14.671775	2021-09-15 09:37:13.252285	\N
1022	394	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:33:39.79302	2021-09-15 09:34:26.127205	2021-09-15 09:37:13.252285	\N
1023	394	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:35:08.568254	\N	2021-09-15 09:37:13.252285	\N
1063	411	26	56	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 07:03:35.472214	\N	2021-09-16 07:22:34.248639	\N
1025	395	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:37:48.165274	\N	2021-09-15 09:46:36.661901	\N
1024	395	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:37:46.605076	\N	2021-09-15 09:46:36.661901	\N
1026	395	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:37:49.581186	\N	2021-09-15 09:46:36.661901	\N
1027	395	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:46:30.321879	\N	2021-09-15 09:46:36.661901	\N
1028	396	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:46:44.106242	2021-09-15 09:47:47.604967	2021-09-15 09:48:27.096918	\N
1030	397	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:57:15.190524	2021-09-15 09:57:37.279614	2021-09-15 09:57:37.279614	\N
1029	397	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:57:14.449171	2021-09-15 09:57:44.289743	2021-09-15 09:57:44.289743	\N
1031	397	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 09:58:28.149473	2021-09-15 09:59:17.437148	2021-09-15 09:59:17.437148	\N
1032	397	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 10:01:07.539473	2021-09-15 10:05:37.946926	2021-09-15 10:05:37.946926	\N
1065	413	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 07:29:12.892469	2021-09-16 07:29:24.848202	\N	1
1048	400	27	57	\N	5	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-15 15:28:39.776013	2021-09-15 20:10:18.947969	\N	50
1035	398	75	129	\N	1	0	1	500	500	3	Basumati rice	Itc	saas/itemicon/default.png	2021-09-15 10:09:07.318871	2021-09-16 04:48:23.216605	\N	10
1037	398	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-15 10:09:14.376358	2021-09-16 04:48:23.216605	\N	250
1038	398	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-15 10:09:15.15787	2021-09-16 04:48:23.216605	\N	500
1039	398	89	166	\N	1	0	1	3000	2499	7	Magnum	Icecream	saas/itemicon/default.png	2021-09-15 10:09:34.107078	2021-09-16 04:48:23.216605	\N	10
1043	387	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:30:31.81258	2021-09-15 14:30:38.688843	2021-09-16 11:31:48.315476	\N
1040	398	89	167	\N	1	0	1	600	500	7	Magnum	Icecream	saas/itemicon/default.png	2021-09-15 10:09:34.957046	2021-09-16 04:48:23.216605	\N	2
1034	398	75	127	\N	2	0	1	76	75	3	Basumati rice	Itc	saas/itemicon/default.png	2021-09-15 10:09:04.886551	2021-09-16 04:48:23.216605	\N	2
1044	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:31:22.361146	2021-09-15 14:31:50.870396	2021-09-16 11:31:48.315476	\N
1036	398	75	128	\N	2	0	1	50	50	3	Basumati rice	Itc	saas/itemicon/default.png	2021-09-15 10:09:08.343455	2021-09-16 04:48:23.216605	\N	1
1033	398	26	56	\N	3	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-15 10:07:18.005406	2021-09-16 04:48:23.216605	\N	1
1049	401	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 04:58:50.916142	2021-09-16 05:46:35.292962	\N	1
1045	387	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:32:35.905924	2021-09-15 14:40:32.032565	2021-09-16 11:31:48.315476	\N
1050	402	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:51:47.926606	2021-09-16 05:52:09.037246	\N	1
1058	408	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:05:41.084437	\N	2021-09-18 06:30:59.277853	\N
1051	402	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:51:49.173256	2021-09-16 05:52:09.037246	\N	250
1052	403	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:52:38.879037	2021-09-16 05:53:05.169564	\N	1
1053	404	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:54:32.307913	2021-09-16 05:54:38.649966	\N	1
1041	300	24	29	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 13:39:23.357244	2021-09-15 14:47:20.039583	2021-09-15 14:47:22.004988	\N
1054	405	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:56:06.643019	2021-09-16 05:56:13.537395	\N	1
1055	406	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 05:57:17.126131	2021-09-16 05:57:29.821903	\N	1
1047	399	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:54:39.641234	\N	2021-09-15 15:23:04.761668	\N
1056	407	87	148	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:02:50.758636	\N	2021-09-16 06:02:59.391126	\N
1066	414	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 07:33:34.92808	2021-09-16 07:33:54.269545	\N	1
1061	409	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 06:40:59.142451	2021-09-16 06:41:09.187973	\N	1
1077	424	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 09:06:36.013909	2021-09-16 09:06:48.961334	\N	1
1067	415	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 07:37:59.532246	2021-09-16 07:38:04.5694	\N	1
1068	416	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 07:42:01.284831	2021-09-16 07:42:06.258617	\N	1
1069	417	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 07:47:36.716279	2021-09-16 07:47:45.940317	\N	250
1064	412	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 07:22:39.340009	\N	2021-09-16 07:54:31.31668	\N
1070	418	26	56	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 07:54:36.223176	2021-09-16 08:06:08.832029	2021-09-16 08:06:10.031692	\N
1073	421	26	56	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 08:55:51.790954	\N	2021-09-16 09:03:41.072979	\N
1078	425	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 09:08:38.844319	2021-09-16 09:08:48.850526	\N	1
1076	423	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 09:05:54.993754	2021-09-16 09:06:00.830824	\N	1
1080	426	26	46	\N	3	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:01:24.83705	2021-09-16 10:03:44.850757	\N	250
1079	426	26	56	\N	3	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:01:24.261817	2021-09-16 10:03:44.850757	\N	1
1081	426	26	47	\N	2	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:01:25.413375	2021-09-16 10:03:44.850757	\N	500
1082	427	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:04:30.172385	2021-09-16 10:04:40.606519	\N	1
1083	428	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:07:32.05953	2021-09-16 10:10:21.176935	\N	1
1042	387	82	139	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-15 14:28:16.040187	2021-09-15 14:29:36.073604	2021-09-16 11:31:48.315476	\N
1074	422	26	56	\N	4	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 09:03:45.785032	2021-09-16 10:07:34.850268	\N	1
1057	408	54	98	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:05:39.737633	\N	2021-09-18 06:30:59.277853	\N
1059	408	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:05:42.256855	\N	2021-09-18 06:30:59.277853	\N
1060	408	51	114	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 06:05:43.008547	\N	2021-09-18 06:30:59.277853	\N
1075	422	27	57	\N	4	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-16 09:03:46.637627	2021-09-16 10:07:34.850268	\N	50
1084	429	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:20:49.298884	2021-09-16 10:20:55.214946	\N	1
1085	430	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:23:03.632691	2021-09-16 10:24:12.451923	\N	1
1138	453	74	126	\N	1	0	11	170	150	5	Banana	new	saas/itemicon/default.png	2021-09-22 05:30:42.074188	2021-09-23 07:05:23.613875	\N	500
1086	431	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:38:38.803017	2021-09-16 10:42:11.0897	\N	1
1087	431	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:38:39.639506	2021-09-16 10:42:11.0897	\N	250
1088	431	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:38:42.079337	2021-09-16 10:42:11.0897	\N	500
1119	451	85	144	\N	1	0	11	90	75	3	Beans	fresh	saas/itemicon/default.png	2021-09-18 10:44:52.031927	2021-09-21 16:28:32.569392	\N	1
1113	447	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 10:23:20.204181	2021-09-17 10:31:02.650417	2021-09-17 10:31:03.02598	\N
1104	441	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 15:57:24.067432	2021-09-16 15:57:39.21526	2021-09-16 15:58:21.251911	\N
1090	432	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:45:20.689599	2021-09-16 10:45:30.066477	\N	1
1091	433	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:49:59.431301	2021-09-16 10:50:07.609697	\N	1
1092	433	26	46	\N	1	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:49:59.945316	2021-09-16 10:50:07.609697	\N	250
1093	434	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 10:51:42.024096	2021-09-16 10:51:47.690717	\N	1
1089	301	63	109	\N	10	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 10:40:59.135887	\N	2021-09-16 10:58:18.896133	\N
1094	435	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 10:58:24.362818	\N	2021-09-16 10:58:41.792214	\N
1095	435	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 10:58:24.945258	\N	2021-09-16 10:58:41.792214	\N
1127	458	87	148	\N	1	0	1	7	3	5	Mutton	Nandu's	saas/itemicon/default.png	2021-09-20 17:36:32.96921	2021-09-20 18:01:47.525077	\N	500
1116	450	26	56	\N	1	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-17 13:11:51.973221	2021-09-21 09:41:59.858803	\N	1
1097	437	26	56	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 11:00:55.399762	\N	2021-09-16 11:13:35.050992	\N
1098	437	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 11:00:56.030873	\N	2021-09-16 11:13:35.050992	\N
1099	437	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 11:00:57.055429	\N	2021-09-16 11:13:35.050992	\N
1105	442	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 15:58:41.898956	2021-09-16 15:58:49.455704	2021-09-16 15:58:52.366057	\N
1130	436	62	108	\N	1	0	1	45	20	4	Milk	Amul	saas/itemicon/default.png	2021-09-21 12:40:46.380362	2021-09-21 13:52:15.237105	\N	1
985	387	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-14 09:13:36.088533	2021-09-14 11:15:28.362965	2021-09-16 11:31:48.315476	\N
1096	436	63	109	\N	8	0	1	25	20	7	Cookies	Amul	saas/itemicon/default.png	2021-09-16 10:58:46.090103	2021-09-21 13:52:15.237105	\N	1
1106	443	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 15:59:57.957891	2021-09-16 16:00:07.007222	2021-09-16 16:00:07.746423	\N
1107	444	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 16:00:14.482311	2021-09-17 07:09:35.191311	2021-09-17 07:09:49.99652	\N
1139	462	27	50	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 09:01:12.187096	\N	2021-09-23 10:33:39.193967	\N
1100	438	26	56	\N	8	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-16 11:13:40.611258	2021-09-16 11:34:48.138527	\N	1
1133	453	51	114	\N	2	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-21 16:32:03.312059	2021-09-23 07:05:23.619929	\N	11
1122	453	79	134	\N	7	0	11	85	80	3	Radish	fresh	saas/itemicon/default.png	2021-09-18 11:26:10.225358	2021-09-23 07:05:23.625914	\N	1
1101	439	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 13:34:28.897979	2021-09-16 15:53:50.976513	2021-09-16 15:53:55.731021	\N
1123	454	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-20 10:14:52.960164	\N	\N	\N
1103	440	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 15:56:21.870325	2021-09-16 15:56:28.302206	2021-09-16 15:56:31.750216	\N
1108	445	63	109	\N	14	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 02:46:30.065662	\N	2021-09-22 04:32:57.888703	\N
1124	455	63	109	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-20 10:15:14.709449	\N	\N	\N
1117	451	54	98	\N	1	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-18 10:44:46.639037	2021-09-21 16:28:32.559159	\N	200
1141	464	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 12:54:16.270834	2021-09-22 13:48:44.483637	2021-09-23 04:48:02.654684	\N
1110	446	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 07:10:09.793929	2021-09-17 07:12:51.028787	2021-09-17 10:23:15.481375	\N
1120	452	54	98	\N	4	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-18 11:20:05.396905	2021-09-22 05:32:37.119355	\N	200
1112	446	54	98	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 07:17:38.070365	\N	2021-09-17 10:23:15.481375	\N
1111	446	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 07:10:11.015894	2021-09-17 07:17:55.860056	2021-09-17 10:23:15.481375	\N
930	369	87	148	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-13 16:06:46.959294	2021-09-20 17:33:13.978486	2021-09-20 17:33:18.015782	\N
1109	445	62	108	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 02:47:05.770337	\N	2021-09-22 04:32:57.888703	\N
1102	408	67	152	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-16 15:44:18.710787	\N	2021-09-18 06:30:59.277853	\N
1121	452	51	114	\N	2	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-18 11:20:06.570649	2021-09-22 05:32:37.124187	\N	11
843	335	77	131	\N	1	5	10	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-09-10 17:11:18.303754	2021-09-22 05:33:00.305895	\N	500
1126	457	87	148	\N	1	0	1	7	3	5	Mutton	Nandu's	saas/itemicon/default.png	2021-09-20 17:34:09.364128	2021-09-20 17:34:52.380513	\N	500
1118	451	51	114	\N	1	0	11	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-09-18 10:44:48.839837	2021-09-21 16:28:32.563767	\N	11
1135	461	87	148	\N	2	0	1	7	3	5	Mutton	Nandu's	saas/itemicon/default.png	2021-09-22 04:57:42.229199	2021-09-22 04:58:02.957853	\N	500
1134	453	67	152	\N	1	0	11	100	50	7	a	b	saas/itemicon/default.png	2021-09-21 16:34:15.072057	2021-09-23 07:05:23.631987	\N	2
1136	461	87	164	\N	1	0	1	10	1	3	Mutton	Nandu's	saas/itemicon/default.png	2021-09-22 04:57:51.984124	2021-09-22 04:58:02.957853	\N	1
1131	460	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-21 14:34:31.934009	2021-09-22 08:38:50.490752	2021-09-22 08:38:51.15468	\N
1132	453	54	98	\N	1	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-09-21 16:25:38.86612	2021-09-23 07:05:23.638079	\N	200
1115	449	27	57	\N	11	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-09-17 10:32:34.433594	2021-09-23 09:36:27.520706	\N	50
1142	464	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 12:54:44.498558	2021-09-22 13:49:31.637834	2021-09-23 04:48:02.654684	\N
1143	464	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 12:54:46.006212	2021-09-22 14:12:54.867706	2021-09-23 04:48:02.654684	\N
1144	464	85	145	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 12:54:52.793096	\N	2021-09-23 04:48:02.654684	\N
1125	456	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-20 16:47:30.461059	2021-09-22 16:30:03.313688	2021-09-22 16:30:03.618527	\N
1145	464	82	139	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 12:54:54.127156	\N	2021-09-23 04:48:02.654684	\N
1140	463	62	108	\N	1	0	1	45	20	4	Milk	Amul	saas/itemicon/default.png	2021-09-22 11:41:13.317425	2021-09-23 12:50:48.110618	\N	1
1129	459	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-21 10:26:14.500316	\N	2021-09-23 15:27:19.352006	\N
1276	448	76	130	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 11:16:09.071152	\N	2021-09-30 11:44:52.452334	\N
1114	448	54	98	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-09-17 10:31:14.443076	\N	2021-09-30 11:44:52.452334	\N
1279	448	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 11:44:44.617007	\N	2021-09-30 11:44:52.452334	\N
1569	663	54	98	\N	15	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:36:19.649179	2021-10-13 12:37:14.459929	2021-10-13 12:37:31.627152	\N
1278	524	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 11:18:36.136388	2021-09-30 11:45:42.725989	2021-09-30 11:45:42.725989	\N
1272	521	56	100	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 08:02:58.343526	\N	2021-10-01 13:05:30.23616	\N
1571	664	66	125	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:38:57.990176	2021-10-13 12:40:02.211027	\N	\N
1299	534	26	46	\N	3	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-10-04 02:42:20.559823	2021-10-04 02:44:10.01871	\N	250
1298	534	26	47	\N	2	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-10-04 02:42:18.217635	2021-10-04 02:44:10.01871	\N	500
1301	535	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 02:49:16.589866	\N	2021-10-04 02:49:53.495466	\N
1283	526	27	50	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 11:46:34.098014	2021-09-30 12:32:08.548994	2021-09-30 12:32:08.548994	\N
1302	532	67	113	\N	3	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-10-04 08:46:54.16416	2021-10-04 08:47:15.857047	\N	1
1291	532	54	98	\N	1	0	1	60	55	5	Orange	new	saas/itemicon/default.png	2021-10-01 07:38:24.134983	2021-10-04 08:47:15.857047	\N	200
1310	542	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 09:56:10.609044	2021-10-04 09:56:22.348222	2021-10-04 10:14:32.218786	\N
1309	542	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 09:44:40.022374	2021-10-04 09:55:55.866378	2021-10-04 10:14:32.218786	\N
1284	527	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 12:32:19.834835	2021-09-30 18:16:58.32259	2021-09-30 18:40:45.309751	\N
1285	527	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 18:26:24.964886	\N	2021-09-30 18:40:45.309751	\N
1286	528	49	89	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 18:46:32.529105	\N	2021-09-30 18:46:41.251998	\N
1287	529	27	50	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 18:47:19.282699	\N	2021-09-30 18:47:22.819388	\N
1288	530	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 18:50:58.983778	\N	2021-09-30 18:51:25.717571	\N
1282	525	90	168	\N	1	5	10	24999	23000	7	OnePlus	Mobile	saas/itemicon/default.png	2021-09-30 11:45:08.260663	2021-10-01 06:15:21.578974	\N	1
1280	525	53	97	\N	1	5	10	50	45	7	Book 15	new	saas/itemicon/default.png	2021-09-30 11:45:02.657657	2021-10-01 06:15:21.58176	\N	1
1281	525	74	126	\N	1	5	10	170	150	5	Banana	new	saas/itemicon/default.png	2021-09-30 11:45:06.074913	2021-10-01 06:15:21.585287	\N	500
1256	512	67	113	\N	3	0	11	500	100	7	a	b	saas/itemicon/default.png	2021-09-29 07:25:36.756718	2021-10-01 06:15:40.89199	\N	1
1241	504	80	135	\N	1	5	10	200	170	3	Tomato	fresh	saas/itemicon/default.png	2021-09-28 11:02:39.935871	2021-10-01 06:15:57.456348	\N	2
1289	531	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-01 07:37:16.637445	2021-10-01 07:37:30.365818	\N	5
1290	531	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-10-01 07:37:22.412882	2021-10-01 07:37:30.365818	\N	1
1292	533	26	47	\N	1	0	1	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-10-01 08:16:44.304902	2021-10-01 08:17:21.733188	\N	500
1293	533	75	128	\N	1	0	1	50	50	3	Basumati rice	Itc	saas/itemicon/default.png	2021-10-01 08:16:51.242036	2021-10-01 08:17:21.733188	\N	1
1294	533	75	129	\N	1	0	1	500	500	3	Basumati rice	Itc	saas/itemicon/default.png	2021-10-01 08:16:52.817958	2021-10-01 08:17:21.733188	\N	10
1168	471	63	109	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-09-22 17:12:15.382298	\N	2021-10-01 13:05:28.516056	\N
1271	521	89	166	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 08:02:45.842183	\N	2021-10-01 13:05:30.23616	\N
1270	521	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-09-30 08:02:41.53201	\N	2021-10-01 13:05:30.23616	\N
1295	521	26	47	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-01 13:05:24.648009	\N	2021-10-01 13:05:30.23616	\N
1323	546	51	114	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 06:23:52.79754	\N	2021-10-05 06:31:10.949104	\N
1304	537	67	113	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 08:55:41.662513	\N	2021-10-04 08:56:04.449827	\N
1303	536	67	113	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 08:55:41.65272	\N	2021-10-04 08:56:08.650208	\N
1313	545	75	128	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 13:04:23.828254	\N	2021-10-04 13:58:12.501856	\N
1329	552	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:23:51.715098	\N	2021-10-05 10:23:57.775788	\N
1297	522	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-01 18:58:12.700983	2021-10-01 18:58:19.295831	2021-10-01 18:58:19.478736	\N
1273	522	26	56	\N	2	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-09-30 08:57:34.376571	2021-10-01 18:58:44.904755	\N	1
1296	522	24	149	\N	3	0	1	35	30	5	Mango	farm-fresh	saas/itemicon/default.png	2021-10-01 18:58:11.926304	2021-10-01 18:58:44.904755	\N	1
1305	538	67	113	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 08:56:20.134003	\N	2021-10-04 08:57:02.098593	\N
1324	547	66	125	\N	2	0	11	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-05 06:31:20.653656	2021-10-05 06:31:50.530521	\N	5
1300	534	26	56	\N	2	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-10-04 02:42:25.27937	2021-10-04 02:44:10.01871	\N	1
1307	540	74	126	\N	2	0	1	170	150	5	Banana	new	saas/itemicon/default.png	2021-10-04 09:04:30.118973	2021-10-04 09:04:40.84379	\N	500
1311	543	66	125	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 10:46:32.748348	\N	2021-10-04 16:26:30.480794	\N
1314	543	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:02.129047	\N	2021-10-04 16:26:30.480794	\N
1308	541	26	47	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 09:33:43.912562	\N	2021-10-04 09:37:43.623392	\N
1315	543	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:05.010112	\N	2021-10-04 16:26:30.480794	\N
1316	543	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:06.588557	\N	2021-10-04 16:26:30.480794	\N
1317	543	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:08.708703	\N	2021-10-04 16:26:30.480794	\N
1318	543	74	126	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:10.344016	\N	2021-10-04 16:26:30.480794	\N
1320	543	77	131	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:14.668433	\N	2021-10-04 16:26:30.480794	\N
1321	543	79	134	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:17.218531	\N	2021-10-04 16:26:30.480794	\N
1322	543	80	135	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:20.693249	\N	2021-10-04 16:26:30.480794	\N
1319	543	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 16:26:12.9888	\N	2021-10-04 16:26:30.480794	\N
1306	539	74	126	\N	5	0	11	170	150	5	Banana	new	saas/itemicon/default.png	2021-10-04 08:57:21.771209	2021-10-05 05:09:59.586832	\N	500
1312	544	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-04 12:29:23.425602	\N	2021-10-05 09:58:50.701413	\N
1335	556	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:30:23.553556	\N	2021-10-05 10:32:00.347603	\N
1327	550	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 09:58:57.979181	2021-10-05 09:59:04.414275	2021-10-05 09:59:05.457407	\N
1332	554	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:24:39.735545	2021-10-05 10:24:45.553274	2021-10-05 10:24:47.852284	\N
1331	553	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:24:07.421849	2021-10-05 10:24:18.717879	2021-10-05 10:24:19.945458	\N
1328	551	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 09:59:36.833065	2021-10-05 10:17:55.238396	2021-10-05 10:17:57.462473	\N
1334	555	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:25:01.882371	\N	2021-10-05 10:25:06.338292	\N
1333	555	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:25:01.39797	\N	2021-10-05 10:25:20.753302	\N
1330	553	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:24:04.777043	2021-10-05 10:24:26.869399	2021-10-05 10:24:28.179847	\N
1336	556	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:30:24.300081	\N	2021-10-05 10:30:28.851679	\N
1338	557	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:32:06.303415	\N	2021-10-05 10:32:13.433451	\N
1337	557	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:32:05.256944	\N	2021-10-05 10:32:22.438693	\N
1339	558	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:33:38.415695	\N	2021-10-05 10:33:45.047357	\N
1340	558	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:33:39.187037	2021-10-05 10:34:02.448408	2021-10-05 10:34:06.901405	\N
1341	558	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:33:57.240067	\N	2021-10-05 10:34:10.675863	\N
1342	559	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:36:14.799781	2021-10-05 10:37:31.625562	2021-10-05 10:37:36.224965	\N
1344	559	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:37:55.174961	\N	2021-10-05 10:38:11.495439	\N
1343	559	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:36:16.474564	2021-10-05 10:48:55.53328	2021-10-05 10:49:02.103468	\N
1346	560	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:51:58.339881	\N	2021-10-05 10:52:03.877293	\N
1347	560	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:51:58.999916	\N	2021-10-05 10:53:54.493019	\N
1348	560	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:54:06.359241	\N	2021-10-05 10:56:55.313483	\N
1349	560	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:54:06.959052	\N	2021-10-05 10:57:46.25276	\N
1326	549	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 09:57:45.179033	\N	2021-10-05 12:29:25.829791	\N
1351	560	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:54:10.05658	\N	2021-10-05 10:56:41.577834	\N
1564	661	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:29:28.732471	2021-10-13 12:29:56.491835	2021-10-13 12:29:56.932937	\N
1548	645	66	125	\N	0	5	10	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-12 13:57:28.394349	2021-10-12 14:17:07.960873	\N	5
1355	561	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:57:58.195624	2021-10-05 10:59:00.059989	2021-10-05 10:59:28.449354	\N
1357	561	77	131	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:58:00.356074	2021-10-05 10:59:10.07791	2021-10-05 10:59:28.449354	\N
1570	663	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:36:20.483512	2021-10-13 12:37:09.959104	2021-10-13 12:37:31.627152	\N
1572	664	54	98	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:39:00.186019	\N	\N	\N
1554	657	26	46	\N	8	0	1	\N	\N	\N	\N	\N	\N	2021-10-12 18:58:03.021657	2021-10-13 12:41:41.189186	2021-10-13 12:41:43.492828	\N
1249	507	26	47	\N	0	1	10	120	115	5	Apple	farm-fresh	saas/itemicon/default.png	2021-09-28 11:45:57.777847	2021-10-13 21:59:48.949947	\N	500
1609	676	51	114	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:25:40.087794	\N	\N	\N
1608	676	67	152	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:25:39.1932	\N	\N	\N
1352	560	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:54:11.083233	\N	2021-10-05 10:55:54.67106	\N
1565	661	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:29:31.890912	\N	2021-10-13 12:29:57.60249	\N
1354	561	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:57:57.326009	\N	2021-10-05 10:59:28.449354	\N
1573	657	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:40:46.962319	\N	2021-10-13 12:41:43.492828	\N
1555	658	152	243	\N	2	0	1	375	350	4	Blue Chequered Men Shirt Cotton light coloured printed full sleeve Chinese collar	Pepe Jeans	saas/itemicon/default.png	2021-10-12 19:25:49.491627	2021-10-13 18:19:15.036635	\N	1
1243	506	24	222	\N	0	1	10	300	285	3	Mango	farm-fresh	saas/itemicon/default.png	2021-09-28 11:28:20.491882	2021-10-13 22:00:22.484022	\N	5
1607	676	66	125	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:25:38.515033	2021-10-17 15:26:56.763046	\N	\N
1350	560	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:54:09.631937	\N	2021-10-05 10:54:16.446993	\N
1345	560	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:49:28.488141	2021-10-05 10:57:43.97899	2021-10-05 10:57:44.502603	\N
1574	657	27	50	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:40:47.97598	\N	2021-10-13 12:41:43.492828	\N
1556	643	27	50	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-12 19:32:39.988927	\N	\N	\N
1575	665	24	29	\N	10	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:41:57.498691	\N	2021-10-13 12:43:46.414488	\N
1576	665	27	50	\N	9	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:41:58.149878	\N	2021-10-13 12:43:46.414488	\N
1578	666	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:43:53.299251	2021-10-13 13:04:15.764175	2021-10-13 13:04:16.131261	\N
1383	567	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:31:09.290731	\N	2021-10-05 13:41:49.383207	\N
1353	561	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:57:56.662029	\N	2021-10-05 10:59:28.449354	\N
1356	561	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:57:59.709476	\N	2021-10-05 10:59:28.449354	\N
1358	562	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:59:52.183325	\N	2021-10-05 10:59:57.739042	\N
1361	562	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:00:30.017441	\N	2021-10-05 11:00:36.394479	\N
1398	577	24	29	\N	0	1	10	\N	\N	\N	\N	\N	\N	2021-10-05 15:08:32.284514	2021-10-05 16:03:57.887219	2021-10-05 15:08:44.357356	\N
1359	562	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:59:52.798308	2021-10-05 11:00:40.158993	2021-10-05 11:00:43.028608	\N
1399	577	26	47	\N	0	1	10	\N	\N	\N	\N	\N	\N	2021-10-05 15:08:32.84725	2021-10-05 16:03:57.89042	2021-10-05 15:54:23.489817	\N
1360	562	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 10:59:53.56334	2021-10-05 11:00:57.530335	2021-10-05 11:00:58.8915	\N
1400	577	26	56	\N	7	1	10	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-10-05 15:54:11.956507	2021-10-05 16:03:57.893983	\N	1
1372	563	82	139	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:16.786967	\N	2021-10-05 11:02:58.424488	\N
1389	568	90	168	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:42:11.603114	\N	2021-10-05 13:42:30.247515	\N
1362	563	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:03.876155	2021-10-05 11:05:09.421846	2021-10-05 11:05:13.749777	\N
1363	563	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:05.859501	\N	2021-10-05 11:05:23.130232	\N
1364	563	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:07.102858	\N	2021-10-05 11:05:25.712368	\N
1365	563	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:08.33435	\N	2021-10-05 11:05:32.639613	\N
1371	563	81	138	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:15.843867	\N	2021-10-05 11:05:40.924462	\N
1370	563	80	135	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:15.168421	\N	2021-10-05 11:05:43.445295	\N
1366	563	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:09.965947	\N	2021-10-05 11:05:50.266966	\N
1388	569	90	168	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:42:11.599404	\N	2021-10-05 13:42:34.33616	\N
1369	563	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:13.674256	\N	2021-10-05 11:07:52.48249	\N
1367	563	77	131	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:11.201198	2021-10-05 11:07:40.311907	2021-10-05 11:08:04.118064	\N
1368	563	79	134	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:01:12.633856	2021-10-05 11:07:46.440175	2021-10-05 11:08:07.836874	\N
1423	587	76	132	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 07:23:06.990499	\N	2021-10-06 07:23:11.075343	\N
1407	581	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 19:59:25.819871	\N	2021-10-05 20:38:09.769856	\N
1390	571	90	168	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:42:42.05937	\N	2021-10-05 13:44:08.619079	\N
1391	570	90	168	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:42:42.061597	\N	2021-10-05 13:44:12.149081	\N
1411	581	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:39:20.766984	\N	2021-10-05 20:39:24.069959	\N
1413	582	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:40:06.618443	2021-10-06 20:39:36.140187	2021-10-11 16:18:08.495979	\N
1401	578	26	46	\N	7	0	1	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-10-05 16:04:08.608198	2021-10-05 16:04:18.8968	\N	250
1418	584	24	29	\N	12	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 05:36:43.228464	\N	2021-10-06 05:38:21.037247	\N
1393	573	66	125	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 14:23:47.63145	\N	2021-10-05 14:26:50.732251	\N
1377	564	77	131	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:22.298782	\N	2021-10-05 11:16:03.083353	\N
1378	564	79	134	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:23.93298	\N	2021-10-05 11:16:03.083353	\N
1374	564	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:18.285411	\N	2021-10-05 11:16:03.083353	\N
1373	564	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:17.465517	2021-10-05 11:09:06.600654	2021-10-05 11:16:03.083353	\N
1375	564	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:19.742557	2021-10-05 11:10:31.398882	2021-10-05 11:16:03.083353	\N
1376	564	76	130	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:08:21.440877	2021-10-05 11:14:52.842528	2021-10-05 11:16:03.083353	\N
1379	565	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:16:13.147231	\N	2021-10-05 11:16:19.265078	\N
1380	565	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 11:16:13.695048	\N	2021-10-05 11:16:19.265078	\N
1414	582	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:40:16.203624	\N	2021-10-11 16:18:08.495979	\N
1384	567	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:31:10.350652	\N	2021-10-05 13:41:49.383207	\N
1385	567	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:31:12.213148	\N	2021-10-05 13:41:49.383207	\N
1386	567	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:31:13.834812	\N	2021-10-05 13:41:49.383207	\N
1387	567	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:31:16.138236	\N	2021-10-05 13:41:49.383207	\N
1394	574	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 14:28:19.174585	\N	2021-10-05 14:28:22.78008	\N
1416	583	26	46	\N	27	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 04:19:24.302861	\N	2021-10-06 05:35:54.445511	\N
1325	548	63	109	\N	15	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 09:30:26.681938	\N	2021-10-06 05:35:55.375824	\N
1421	575	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 06:58:24.504382	\N	2021-10-07 04:46:46.285219	\N
1382	566	26	47	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:02:43.850293	\N	2021-10-05 15:07:47.518541	\N
1402	579	26	56	\N	4	0	1	200	180	3	Apple	farm-fresh	saas/itemicon/default.png	2021-10-05 16:04:57.780903	2021-10-05 16:06:32.818303	\N	1
1381	566	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 13:02:42.119516	2021-10-05 15:08:11.942943	2021-10-05 15:08:17.643852	\N
1409	581	53	97	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:04:23.303605	2021-10-05 20:39:54.555093	2021-10-05 20:39:54.988763	\N
1408	581	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 19:59:33.545045	2021-10-05 20:38:31.89664	2021-10-05 20:38:32.581269	\N
1403	474	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 16:19:45.103551	\N	2021-10-05 19:32:19.089814	\N
1404	474	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 19:32:01.236589	\N	2021-10-05 19:32:19.089814	\N
1405	474	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 19:32:03.807986	2021-10-05 19:32:13.440706	2021-10-05 19:32:19.089814	\N
1417	584	26	46	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 05:36:39.402207	\N	2021-10-06 05:38:21.037247	\N
1406	580	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 19:32:23.649683	\N	2021-10-05 19:59:08.721645	\N
1419	585	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 05:36:55.280897	\N	2021-10-06 05:38:25.508041	\N
1412	581	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:39:42.950815	2021-10-05 20:40:03.177705	2021-10-05 20:40:05.13749	\N
1420	586	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 05:48:44.62749	\N	2021-10-06 05:49:05.743826	\N
1424	588	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 07:23:22.24348	\N	2021-10-06 07:23:29.40046	\N
1425	588	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 07:23:22.970174	\N	2021-10-06 07:23:36.255684	\N
1410	581	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:38:11.606011	2021-10-05 20:38:58.659116	2021-10-05 20:39:05.502086	\N
1397	576	63	109	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 15:08:25.28015	2021-10-06 06:57:57.79356	2021-10-06 06:57:58.719496	\N
1427	590	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 08:32:07.7221	\N	2021-10-06 08:32:12.978469	\N
1395	575	67	152	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 14:28:30.217629	2021-10-05 14:28:35.715596	2021-10-07 04:46:46.285219	\N
1422	575	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 06:58:25.326255	2021-10-06 06:59:39.557288	2021-10-07 04:46:46.285219	\N
1396	575	66	125	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 14:28:31.100692	\N	2021-10-07 04:46:46.285219	\N
1430	591	26	46	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 13:33:15.747377	2021-10-07 08:35:25.853417	2021-10-07 08:53:01.987099	\N
1426	589	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 07:58:27.160512	2021-10-06 08:31:57.637188	2021-10-06 08:31:58.326138	\N
1429	590	51	114	\N	2	0	1	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-10-06 08:32:09.639244	2021-10-06 16:19:46.015748	\N	11
1433	590	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-10-06 16:16:12.037646	2021-10-06 16:19:46.015748	\N	1
1428	590	67	152	\N	2	0	1	100	50	7	a	b	saas/itemicon/default.png	2021-10-06 08:32:08.663246	2021-10-06 16:19:46.015748	\N	2
1392	572	66	125	\N	6	0	11	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-05 14:22:58.552004	2021-10-06 16:46:46.257021	\N	5
1435	594	82	139	\N	2	0	1	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-10-06 16:29:21.2411	2021-10-06 16:29:29.85942	\N	500
1434	593	67	152	\N	4	0	11	100	50	7	a	b	saas/itemicon/default.png	2021-10-06 16:28:44.431699	2021-10-06 16:30:03.341358	\N	2
1432	592	63	109	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 13:33:46.479844	\N	2021-10-07 08:53:08.977093	\N
1437	595	85	145	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 17:09:30.902842	\N	2021-10-06 17:09:38.340005	\N
1436	595	54	98	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 16:29:37.280051	\N	2021-10-06 17:09:38.340005	\N
1415	582	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-05 20:40:17.263861	2021-10-05 20:40:24.522711	2021-10-11 16:18:08.495979	\N
1440	597	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 05:04:01.279835	\N	2021-10-07 05:04:05.327404	\N
1441	598	53	97	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 05:04:18.74829	\N	2021-10-07 05:04:28.205255	\N
1442	599	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 05:04:36.697862	\N	2021-10-07 05:04:42.468937	\N
1459	605	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:33:38.360765	2021-10-07 09:35:40.498781	2021-10-08 13:04:57.761945	\N
1445	601	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 06:59:42.580763	\N	2021-10-07 06:59:48.247761	\N
1446	602	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-07 06:59:59.993424	2021-10-07 07:06:35.525247	\N	5
1438	596	66	125	\N	1	5	10	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-06 17:09:45.06013	2021-10-07 07:15:51.765751	\N	5
1449	316	88	156	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 07:28:02.271331	\N	\N	\N
804	316	70	117	\N	7	0	1	\N	\N	\N	\N	\N	\N	2021-09-09 15:06:06.249299	\N	\N	\N
1431	591	24	220	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 13:33:19.991059	\N	2021-10-07 08:52:56.516102	\N
1447	591	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 07:27:27.261767	\N	2021-10-07 08:53:04.250896	\N
1448	591	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 07:27:28.04097	\N	2021-10-07 08:53:05.782114	\N
1465	607	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 12:57:26.332296	\N	\N	\N
1463	607	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 12:57:24.35747	\N	2021-10-07 12:57:31.046094	\N
1464	607	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 12:57:25.295891	\N	2021-10-07 12:57:39.503054	\N
1451	603	27	50	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:02:27.894703	\N	2021-10-07 09:03:45.043808	\N
1452	603	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:25:43.339041	\N	2021-10-07 09:25:56.467981	\N
1453	603	24	29	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:25:44.319793	\N	2021-10-07 09:26:21.102008	\N
1455	603	89	167	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:25:46.931743	\N	2021-10-07 09:28:40.006599	\N
1454	603	75	128	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:25:46.232284	\N	2021-10-07 09:29:33.840737	\N
1450	603	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 08:53:20.301337	2021-10-07 09:29:41.218338	2021-10-07 09:30:03.159629	\N
1458	605	24	29	\N	9	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:30:15.374692	2021-10-07 09:41:20.096178	2021-10-08 13:04:57.761945	\N
1466	608	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 13:38:13.963537	\N	2021-10-07 13:42:12.55693	\N
1469	608	27	92	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 13:38:20.707996	\N	2021-10-07 13:42:15.351178	\N
1491	619	90	168	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 09:48:40.636615	\N	2021-10-08 11:07:36.721581	\N
1486	619	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 08:47:10.483944	2021-10-08 09:48:59.664995	2021-10-08 11:07:36.721581	\N
1485	619	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 08:47:03.619536	2021-10-08 08:54:05.704837	2021-10-08 11:07:36.721581	\N
1456	604	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:30:10.780812	\N	2021-10-07 09:33:45.409243	\N
1460	605	49	89	\N	6	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:33:38.783929	2021-10-07 09:41:21.995272	2021-10-08 13:04:57.761945	\N
1471	610	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:37.951654	\N	2021-10-07 14:03:43.926179	\N
1482	617	51	114	\N	0	5	10	123	122	7	Book 1	super book	saas/itemicon/default.png	2021-10-07 14:56:50.18187	2021-10-07 14:57:28.995965	\N	11
1472	610	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:38.866348	2021-10-07 14:03:45.765498	2021-10-07 14:03:46.448075	\N
1473	610	51	114	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:40.492101	\N	2021-10-07 14:03:50.23356	\N
1467	608	27	57	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 13:38:15.458961	\N	2021-10-07 14:13:54.357407	\N
1468	608	27	50	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 13:38:18.069361	\N	2021-10-07 14:13:55.997868	\N
1476	611	85	145	\N	2	0	1	180	140	3	Beans	fresh	saas/itemicon/default.png	2021-10-07 14:31:08.952577	2021-10-07 14:31:15.06265	\N	2
1477	612	67	113	\N	1	0	1	500	100	7	a	b	saas/itemicon/default.png	2021-10-07 14:31:43.831127	2021-10-07 14:31:50.449964	\N	1
1478	613	82	139	\N	2	0	11	50	35	5	carrot	fresh	saas/itemicon/default.png	2021-10-07 14:32:17.321951	2021-10-07 14:33:09.82365	\N	500
1501	627	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:33:02.521472	\N	2021-10-08 13:43:24.875202	\N
1462	605	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:47:39.50484	\N	2021-10-08 13:04:57.761945	\N
1479	614	67	152	\N	1	0	11	100	50	7	a	b	saas/itemicon/default.png	2021-10-07 14:39:19.624671	2021-10-07 14:39:49.362481	\N	2
1461	606	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:42:04.490526	\N	2021-10-08 13:04:59.468268	\N
1480	615	85	144	\N	2	5	10	90	75	3	Beans	fresh	saas/itemicon/default.png	2021-10-07 14:40:32.958797	2021-10-07 14:40:50.080779	\N	1
1481	616	90	168	\N	1	0	11	24999	23000	7	OnePlus	Mobile	saas/itemicon/default.png	2021-10-07 14:45:54.128753	2021-10-07 14:46:44.949176	\N	1
1484	618	27	57	\N	1	0	11	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-10-07 18:27:30.972592	2021-10-08 21:04:20.810345	\N	50
1500	626	85	144	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:31:09.858491	\N	2021-10-11 07:48:16.317961	\N
1492	621	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-10-08 10:32:30.583036	2021-10-08 10:32:33.956321	\N	1
1493	622	53	97	\N	1	0	1	50	45	7	Book 15	new	saas/itemicon/default.png	2021-10-08 10:39:36.202884	2021-10-08 10:39:39.661627	\N	1
1474	609	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:41.160587	\N	2021-10-08 10:55:55.419446	\N
1443	600	66	125	\N	2	5	10	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-07 05:12:45.449593	2021-10-08 11:09:46.795149	\N	5
1475	609	51	114	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:41.930271	\N	2021-10-08 10:55:55.419446	\N
1470	609	66	125	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 14:03:25.439268	2021-10-07 14:03:33.99979	2021-10-08 10:55:55.419446	\N
1494	609	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 10:55:50.1199	\N	2021-10-08 10:55:55.419446	\N
1495	623	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 10:56:00.707391	\N	\N	\N
1496	623	90	168	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 11:01:58.027721	\N	2021-10-08 11:02:18.616053	\N
1444	600	54	98	\N	1	5	10	60	55	5	Orange	new	saas/itemicon/default.png	2021-10-07 05:13:01.787778	2021-10-08 11:09:46.79778	\N	200
1487	619	67	113	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 08:47:13.635185	2021-10-08 08:54:14.85164	2021-10-08 11:07:36.721581	\N
1497	624	66	125	\N	1	0	1	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-08 11:35:27.63524	2021-10-08 11:35:45.353252	\N	5
1457	605	49	89	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-07 09:30:14.538098	\N	2021-10-08 13:04:57.761945	\N
1439	582	67	113	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-06 20:40:14.001692	\N	2021-10-11 16:18:08.495979	\N
1498	625	90	168	\N	1	0	1	24999	23000	7	OnePlus	Mobile	saas/itemicon/default.png	2021-10-08 13:06:10.994721	2021-10-08 13:42:56.295033	\N	1
1499	625	85	144	\N	1	0	1	90	75	3	Beans	fresh	saas/itemicon/default.png	2021-10-08 13:06:12.382947	2021-10-08 13:42:56.295033	\N	1
1503	627	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:33:07.72606	\N	2021-10-08 13:43:24.875202	\N
1502	627	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:33:03.800656	\N	2021-10-08 13:43:24.875202	\N
1506	629	49	89	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:43:31.585245	\N	\N	\N
1507	629	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:43:32.632822	\N	\N	\N
1488	620	144	231	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 09:28:07.355425	\N	2021-10-08 20:53:27.861424	\N
1510	631	80	135	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:48:41.336357	\N	2021-10-08 15:51:23.996605	\N
1509	631	90	168	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:48:38.788648	\N	2021-10-08 15:51:23.996605	\N
1511	632	90	168	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:51:34.479416	2021-10-08 15:51:51.831068	2021-10-08 15:51:54.30746	\N
1512	632	82	139	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:51:35.161642	\N	2021-10-08 15:51:54.30746	\N
1489	620	141	227	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 09:28:29.860932	\N	2021-10-08 20:53:27.861424	\N
1504	628	49	89	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:38:23.056079	2021-10-08 15:55:44.200718	2021-10-08 17:59:28.999396	\N
1490	620	141	228	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 09:28:30.530232	\N	2021-10-08 20:53:27.861424	\N
1508	630	54	98	\N	1	0	11	60	55	5	Orange	new	saas/itemicon/default.png	2021-10-08 13:58:23.350951	2021-10-12 10:20:01.133494	\N	200
1514	633	82	139	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:52:04.512489	\N	2021-10-08 15:53:34.932386	\N
1513	633	90	168	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:52:03.797693	\N	2021-10-08 15:53:34.932386	\N
1515	634	90	168	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:55:57.39032	\N	2021-10-08 15:56:55.131206	\N
1516	634	82	139	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 15:55:58.181726	\N	2021-10-08 15:56:55.131206	\N
1518	635	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 17:40:12.992097	\N	\N	\N
1517	635	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 17:40:12.540824	2021-10-08 17:41:00.307175	2021-10-08 17:41:02.953091	\N
1577	666	24	29	\N	2	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-10-13 12:43:52.731947	2021-10-13 16:23:21.682703	\N	1
1505	628	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 13:38:24.431412	2021-10-08 15:55:45.103634	2021-10-08 17:59:28.999396	\N
1536	644	63	109	\N	16	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 12:57:55.549126	\N	2021-10-13 12:41:51.014932	\N
1519	620	143	230	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 20:51:51.416035	\N	2021-10-08 20:53:27.861424	\N
1520	636	143	230	\N	1	0	1	35	30	5	ketchup	nestle	saas/itemicon/default.png	2021-10-08 20:53:35.866806	2021-10-08 20:53:39.12457	\N	250
1547	653	77	131	\N	3	0	1	50	43	5	Potato	fresh	saas/itemicon/default.png	2021-10-11 19:52:08.182251	2021-10-11 20:13:25.605391	\N	500
1521	637	143	230	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-08 20:57:22.543319	\N	2021-10-08 21:04:00.668715	\N
1483	618	49	89	\N	1	0	11	60	28	4	Milk	Amul	saas/itemicon/default.png	2021-10-07 18:27:29.919279	2021-10-08 21:04:20.803959	\N	1
1526	638	143	230	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:23:32.959499	\N	2021-10-11 05:39:06.257957	\N
1527	638	75	128	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:23:33.828251	\N	2021-10-11 05:39:06.257957	\N
1528	639	63	109	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:23:44.721913	\N	2021-10-11 05:39:08.643545	\N
1522	626	81	138	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:22:53.53156	\N	2021-10-11 07:48:16.317961	\N
1525	626	81	141	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:23:01.830245	\N	2021-10-11 07:48:16.317961	\N
1524	626	81	140	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:22:58.153242	\N	2021-10-11 07:48:16.317961	\N
1523	626	82	139	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:22:54.589903	\N	2021-10-11 07:48:16.317961	\N
1529	640	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:39:15.628238	\N	2021-10-11 09:24:24.096032	\N
1530	640	24	29	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 05:39:16.42585	\N	2021-10-11 09:24:24.096032	\N
1531	641	143	230	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 09:26:24.368228	\N	2021-10-11 09:26:48.475139	\N
1532	641	75	128	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 09:26:25.006639	\N	2021-10-11 09:26:48.475139	\N
1538	646	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 16:19:02.534103	\N	2021-10-11 16:19:22.157017	\N
1539	647	54	98	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 16:19:33.049377	\N	2021-10-11 16:19:59.454418	\N
1540	648	74	126	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 18:37:35.653488	\N	2021-10-11 18:42:49.899498	\N
1534	642	24	29	\N	2	1	10	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-10-11 09:27:31.274632	2021-10-12 14:42:15.685957	\N	1
1533	642	26	46	\N	1	1	10	60	55	5	Apple	farm-fresh	saas/itemicon/default.png	2021-10-11 09:27:30.791216	2021-10-12 14:42:15.688741	\N	250
1541	649	77	131	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 18:46:29.888517	2021-10-11 19:03:46.996112	2021-10-11 19:05:59.818818	\N
1537	645	54	98	\N	0	5	10	60	55	5	Orange	new	saas/itemicon/default.png	2021-10-11 13:35:07.264796	2021-10-14 07:33:08.858938	\N	200
1542	650	53	97	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 19:06:10.808937	2021-10-11 19:13:37.41306	2021-10-11 19:15:33.030883	\N
1544	651	80	135	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 19:18:19.990993	2021-10-11 19:19:25.485729	2021-10-11 19:19:26.854694	\N
1584	668	53	97	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-14 07:36:20.721611	\N	\N	\N
1543	643	24	221	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 19:09:35.383165	2021-10-11 19:30:03.577941	2021-10-11 19:30:03.577941	\N
1535	643	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 09:47:22.231286	2021-10-11 19:30:03.582387	2021-10-11 19:30:03.582387	\N
1545	652	77	131	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 19:19:38.419292	\N	2021-10-11 19:51:58.965891	\N
1546	652	74	126	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-11 19:22:19.142825	\N	2021-10-11 19:51:58.965891	\N
1583	668	158	249	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-14 07:36:19.677804	\N	\N	\N
1579	666	27	50	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:43:55.460632	\N	2021-10-13 13:04:16.507996	\N
1585	668	51	114	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-14 07:36:22.521069	\N	\N	\N
1549	645	67	152	\N	1	0	11	100	50	7	Green Banana	Green Banana	saas/itemicon/default.png	2021-10-12 13:57:29.520381	2021-10-14 07:34:45.803286	\N	2
1586	655	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-14 09:36:38.552189	\N	2021-10-16 04:49:36.426808	\N
1587	669	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:24:01.644588	\N	2021-10-17 10:24:09.026354	\N
1588	669	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:24:02.234464	\N	2021-10-17 10:24:09.026354	\N
1590	670	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:25:07.518444	\N	2021-10-17 10:25:16.50073	\N
1593	671	89	167	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:26:00.663443	\N	2021-10-17 10:26:42.746929	\N
1594	671	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:26:01.756074	\N	2021-10-17 10:26:42.746929	\N
1597	672	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:27:40.767707	\N	2021-10-17 10:33:23.65036	\N
1601	673	26	46	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:35:52.85267	\N	2021-10-17 10:36:14.462003	\N
1603	674	27	57	\N	2	0	1	20	15	5	Butter	Amul	saas/itemicon/default.png	2021-10-17 15:13:08.496803	2021-10-17 15:14:37.588686	\N	50
1550	654	66	125	\N	0	5	10	500	450	3	Apple	Apple	saas/itemicon/default.png	2021-10-12 14:26:19.633749	2021-10-12 14:26:56.529519	\N	5
1589	670	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:25:06.646048	\N	2021-10-17 10:25:16.50073	\N
1595	672	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:27:39.28037	\N	2021-10-17 10:33:23.65036	\N
1561	660	54	98	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:25:31.419332	\N	2021-10-13 12:29:21.140426	\N
1557	659	66	125	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 11:41:28.146639	2021-10-13 12:24:33.443625	2021-10-13 12:24:49.21854	\N
1581	667	148	248	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 19:05:28.043705	\N	2021-10-13 19:05:36.140875	\N
1551	654	54	98	\N	0	5	10	60	55	5	Orange	new	saas/itemicon/default.png	2021-10-12 14:26:35.351	2021-10-14 14:08:19.963034	\N	200
1591	671	24	29	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:25:59.114006	\N	2021-10-17 10:26:42.746929	\N
1580	666	75	128	\N	1	0	1	50	50	3	Basumati rice	Itc	saas/itemicon/default.png	2021-10-13 16:23:12.905558	2021-10-13 16:23:21.682703	\N	1
1592	671	27	57	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:25:59.815657	\N	2021-10-17 10:26:42.746929	\N
1598	672	89	167	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:27:41.629922	\N	2021-10-17 10:33:23.65036	\N
1596	672	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:27:39.869976	\N	2021-10-17 10:33:23.65036	\N
1600	673	27	57	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:35:52.033009	\N	2021-10-17 10:36:14.462003	\N
1605	675	26	46	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:15:33.081421	\N	\N	\N
1559	659	51	114	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 11:41:31.564347	2021-10-13 12:24:28.172491	2021-10-13 12:24:49.21854	\N
1558	659	67	152	\N	1	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 11:41:29.7892	2021-10-13 12:24:31.911399	2021-10-13 12:24:49.21854	\N
1604	675	24	29	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 15:15:32.410413	\N	\N	\N
1582	667	149	236	\N	2	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 19:05:30.39105	2021-10-13 19:05:35.808861	\N	\N
1552	655	82	139	\N	5	0	1	\N	\N	\N	\N	\N	\N	2021-10-12 16:14:38.592264	\N	2021-10-16 04:49:36.426808	\N
1599	673	24	29	\N	4	0	1	\N	\N	\N	\N	\N	\N	2021-10-17 10:35:51.254349	\N	2021-10-17 10:36:14.462003	\N
1560	660	66	125	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:25:08.74295	2021-10-13 12:26:24.994502	2021-10-13 12:29:21.140426	\N
1553	656	26	223	\N	0	0	1	\N	\N	\N	\N	\N	\N	2021-10-12 18:49:44.428839	2021-10-12 18:50:30.899468	2021-10-12 18:50:32.633475	\N
1602	674	24	29	\N	2	0	1	58	55	3	Mango	farm-fresh	saas/itemicon/default.png	2021-10-17 15:13:07.779289	2021-10-17 15:14:37.588686	\N	1
1562	660	51	114	\N	3	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:25:32.341194	\N	2021-10-13 12:29:21.140426	\N
1563	660	53	97	\N	14	0	1	\N	\N	\N	\N	\N	\N	2021-10-13 12:25:33.318895	2021-10-13 12:26:44.065373	2021-10-13 12:29:21.140426	\N
\.


--
-- Data for Name: item_order_tax; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_order_tax (id, item_order_id, tax_id, tax_name, tax_type, amount, calculated, created_at, updated_at, deleted_at) FROM stdin;
13	421	8	CGST	1	8	57.6000000000000014	2021-09-16 08:55:51.804449	2021-09-16 09:03:36.847194	\N
14	421	9	GST	1	9	64.7999999999999972	2021-09-16 08:55:51.813262	2021-09-16 09:03:36.863142	\N
5	411	8	CGST	1	8	20.879999999999999	2021-09-16 07:03:35.485343	2021-09-16 07:22:02.455477	\N
6	411	9	GST	1	9	23.4899999999999984	2021-09-16 07:03:35.493714	2021-09-16 07:22:02.474137	\N
33	148	8	CGST	1	8	36.8000000000000043	2021-09-20 10:15:18.342857	2021-09-20 10:16:02.811247	\N
39	462	9	GST	1	9	72.4500000000000028	2021-09-22 09:01:12.212255	2021-09-23 10:34:06.285841	\N
34	148	9	GST	1	9	41.3999999999999986	2021-09-20 10:15:18.358356	2021-09-20 10:16:02.828638	\N
45	468	10	new	2	40	40	2021-09-22 16:32:51.603251	2021-09-22 16:56:37.499171	\N
37	453	10	new	2	40	40	2021-09-22 05:30:42.094602	2021-09-22 05:33:51.993061	\N
11	419	8	CGST	1	8	51.2000000000000028	2021-09-16 08:06:21.369214	2021-09-16 08:52:15.328679	\N
1	400	8	CGST	1	8	6	2021-09-15 20:06:56.918495	2021-09-15 20:10:06.370032	\N
2	400	9	GST	1	9	6.75	2021-09-15 20:06:56.935785	2021-09-15 20:10:06.37765	\N
12	419	9	GST	1	9	57.5999999999999943	2021-09-16 08:06:21.37669	2021-09-16 08:52:15.347956	\N
56	479	9	GST	1	9	34.6499999999999986	2021-09-23 10:48:14.658793	2021-09-23 10:48:29.119922	\N
3	410	8	CGST	1	8	13.2000000000000011	2021-09-16 06:58:41.022458	2021-09-16 06:58:45.125942	\N
4	410	9	GST	1	9	14.8499999999999996	2021-09-16 06:58:41.031151	2021-09-16 06:58:45.143164	\N
17	431	8	CGST	1	8	28	2021-09-16 10:38:38.820566	2021-09-16 10:41:03.779269	\N
18	431	9	GST	1	9	31.5	2021-09-16 10:38:38.829846	2021-09-16 10:41:03.78763	\N
19	432	8	CGST	1	8	14.4000000000000004	2021-09-16 10:45:20.703889	2021-09-16 10:45:21.441289	\N
20	432	9	GST	1	9	16.1999999999999993	2021-09-16 10:45:20.712928	2021-09-16 10:45:21.449031	\N
29	370	8	CGST	1	8	236.400000000000006	2021-09-17 02:45:19.581166	2021-09-20 04:37:50.357071	\N
30	370	9	GST	1	9	265.949999999999989	2021-09-17 02:45:19.590435	2021-09-20 04:37:50.364682	\N
7	412	8	CGST	1	8	2.39999999999999991	2021-09-16 07:22:39.353315	2021-09-16 07:53:58.774448	\N
8	412	9	GST	1	9	2.69999999999999973	2021-09-16 07:22:39.360854	2021-09-16 07:53:58.80265	\N
21	433	8	CGST	1	8	18.8000000000000007	2021-09-16 10:49:59.447998	2021-09-16 10:50:07.64808	\N
22	433	9	GST	1	9	21.1499999999999986	2021-09-16 10:49:59.457119	2021-09-16 10:50:07.656503	\N
49	473	11	Custom	2	30	30	2021-09-22 19:33:18.797376	2021-09-22 19:33:50.888204	\N
48	470	10	new	2	40	40	2021-09-22 16:57:58.467766	2021-09-22 19:36:32.495106	\N
61	482	10	new	2	40	40	2021-09-23 12:43:47.340776	2021-09-23 12:45:57.688443	\N
23	435	8	CGST	1	8	18.8000000000000007	2021-09-16 10:58:24.37738	2021-09-16 10:58:27.846042	\N
24	435	9	GST	1	9	21.1499999999999986	2021-09-16 10:58:24.386535	2021-09-16 10:58:27.860953	\N
44	467	10	new	2	40	40	2021-09-22 16:30:50.073505	2021-09-22 16:31:40.950876	\N
35	460	8	CGST	1	8	13.2000000000000011	2021-09-21 14:34:31.947338	2021-09-22 08:37:45.844918	\N
25	437	8	CGST	1	8	24.4000000000000021	2021-09-16 11:00:55.413238	2021-09-16 11:13:20.752722	\N
26	437	9	GST	1	9	27.4499999999999993	2021-09-16 11:00:55.420933	2021-09-16 11:13:20.761531	\N
36	460	9	GST	1	9	14.8499999999999996	2021-09-21 14:34:31.955749	2021-09-22 08:37:45.858994	\N
9	418	8	CGST	1	8	8	2021-09-16 07:54:36.236408	2021-09-16 08:06:09.049915	\N
10	418	9	GST	1	9	9	2021-09-16 07:54:36.244894	2021-09-16 08:06:09.066193	\N
40	464	10	new	2	40	40	2021-09-22 12:54:16.289175	2021-09-23 04:47:58.876521	\N
51	475	10	new	2	40	40	2021-09-23 04:48:13.426594	2021-09-23 04:48:13.41628	\N
52	476	10	new	2	40	40	2021-09-23 04:58:21.664192	2021-09-23 04:58:21.655086	\N
53	477	11	Custom	2	30	30	2021-09-23 04:58:28.45413	2021-09-23 04:58:34.030201	\N
15	422	8	CGST	1	8	62.3999999999999986	2021-09-16 09:03:45.798028	2021-09-16 10:07:28.183914	\N
16	422	9	GST	1	9	70.2000000000000028	2021-09-16 09:03:45.805744	2021-09-16 10:07:28.191678	\N
31	449	8	CGST	1	8	6.79999999999999982	2021-09-17 10:32:34.446857	2021-09-21 14:13:31.568555	\N
27	438	8	CGST	1	8	115.200000000000003	2021-09-16 11:13:40.624751	2021-09-16 11:34:48.16018	\N
28	438	9	GST	1	9	129.599999999999994	2021-09-16 11:13:40.633604	2021-09-16 11:34:48.167645	\N
32	449	9	GST	1	9	7.64999999999999947	2021-09-17 10:32:34.455519	2021-09-21 14:13:31.576456	\N
68	486	9	GST	1	9	16.6499999999999986	2021-09-23 12:53:26.089418	2021-09-23 12:53:35.13649	\N
57	480	8	CGST	1	8	50	2021-09-23 10:50:13.548075	2021-09-23 10:50:27.172004	\N
42	466	8	CGST	1	8	22.4000000000000021	2021-09-22 16:24:03.107399	2021-09-22 16:24:19.331057	\N
43	466	9	GST	1	9	25.1999999999999993	2021-09-22 16:24:03.116474	2021-09-22 16:24:19.338274	\N
58	480	9	GST	1	9	56.25	2021-09-23 10:50:13.563924	2021-09-23 10:50:27.179674	\N
46	469	8	CGST	1	8	71.6000000000000085	2021-09-22 16:36:37.715174	2021-09-27 09:51:09.899442	\N
41	456	10	new	2	40	40	2021-09-22 16:08:05.825782	2021-09-22 16:30:00.310996	\N
64	484	10	value	2	40	40	2021-09-23 12:50:38.108438	2021-09-23 13:00:26.051825	\N
54	478	10	new	2	40	40	2021-09-23 07:06:31.418807	2021-09-23 12:40:03.922967	\N
59	481	8	CGST	1	8	30.8000000000000007	2021-09-23 10:50:32.723339	2021-09-23 10:50:39.460733	\N
60	481	9	GST	1	9	34.6499999999999986	2021-09-23 10:50:32.744633	2021-09-23 10:50:39.468216	\N
65	485	8	CGST	1	8	8.80000000000000071	2021-09-23 12:51:06.563691	2021-09-23 12:51:13.671108	\N
62	483	8	CGST	1	8	37.2000000000000028	2021-09-23 12:50:11.497054	2021-09-24 09:08:38.756872	\N
55	479	8	CGST	1	8	30.8000000000000007	2021-09-23 10:48:14.640259	2021-09-23 10:48:29.112292	\N
63	483	9	GST	1	9	41.8500000000000014	2021-09-23 12:50:11.505979	2021-09-24 09:08:38.764232	\N
38	462	8	CGST	1	8	64.4000000000000057	2021-09-22 09:01:12.202796	2021-09-23 10:34:06.277816	\N
66	485	9	GST	1	9	9.90000000000000036	2021-09-23 12:51:06.572187	2021-09-23 12:51:13.679625	\N
72	489	8	CGST	1	8	4.40000000000000036	2021-09-23 13:10:58.239228	2021-09-23 13:11:04.933013	\N
69	487	8	CGST	1	8	9.20000000000000107	2021-09-23 13:00:00.529002	2021-09-23 13:00:06.413079	\N
73	489	9	GST	1	9	4.95000000000000018	2021-09-23 13:10:58.247604	2021-09-23 13:11:04.940939	\N
67	486	8	CGST	1	8	14.8000000000000007	2021-09-23 12:53:26.080714	2021-09-23 12:53:35.128601	\N
70	487	9	GST	1	9	10.3499999999999996	2021-09-23 13:00:00.538042	2021-09-23 13:00:06.420357	\N
74	490	8	CGST	1	8	33.2000000000000028	2021-09-23 13:16:12.96764	2021-09-23 13:16:20.475373	\N
75	490	9	GST	1	9	37.3500000000000014	2021-09-23 13:16:12.976732	2021-09-23 13:16:20.485201	\N
71	488	10	value	2	40	40	2021-09-23 13:06:02.289657	2021-09-24 07:18:41.817767	\N
77	492	10	value	2	40	40	2021-09-24 07:21:15.195462	2021-09-24 07:21:22.071568	\N
78	493	10	value	2	40	40	2021-09-24 07:26:42.357381	2021-09-24 07:26:55.297314	\N
79	496	10	value	2	40	40	2021-09-24 07:37:28.772245	2021-09-24 07:39:16.564645	\N
80	497	8	CGST	1	8	128	2021-09-24 07:48:31.574887	2021-09-24 07:48:41.84179	\N
81	497	9	GST	1	9	144	2021-09-24 07:48:31.590309	2021-09-24 07:48:41.849128	\N
83	498	9	GST	1	9	1.79999999999999982	2021-09-24 09:09:51.869638	2021-09-24 09:09:59.437956	\N
82	498	8	CGST	1	8	1.60000000000000009	2021-09-24 09:09:51.860735	2021-09-24 09:09:59.428973	\N
47	469	9	GST	1	9	80.5499999999999972	2021-09-22 16:36:37.723379	2021-09-27 09:51:09.907448	\N
84	499	11	Custom	2	30	30	2021-09-25 05:00:02.679612	2021-09-27 13:51:19.267801	\N
94	507	8	CGST	1	8	0	2021-09-28 11:45:57.792585	2021-10-13 21:59:48.962571	\N
130	522	12	VAT	2	30	30	2021-09-30 08:57:34.432305	2021-10-01 18:58:44.949565	\N
50	474	10	value	2	40	40	2021-09-22 19:37:09.807721	2021-10-05 19:32:15.463883	\N
95	507	9	GST	1	9	0	2021-09-28 11:45:57.801665	2021-10-13 21:59:48.969863	\N
96	507	12	VAT	2	30	30	2021-09-28 11:45:57.809575	2021-10-13 21:59:48.976792	\N
85	500	10	value	2	40	40	2021-09-25 05:55:51.307318	2021-09-27 07:17:40.610319	\N
110	515	8	CGST	1	8	73.2000000000000028	2021-09-29 09:58:35.786114	2021-09-29 09:58:36.845858	\N
97	508	8	CGST	1	8	9.20000000000000107	2021-09-28 11:47:31.717815	2021-09-28 11:47:38.177407	\N
98	508	9	GST	1	9	10.3499999999999996	2021-09-28 11:47:31.726623	2021-09-28 11:47:38.184348	\N
99	508	12	VAT	2	30	30	2021-09-28 11:47:31.733717	2021-09-28 11:47:38.193314	\N
86	501	10	value	2	40	40	2021-09-27 09:57:00.623903	2021-09-27 16:32:16.295999	\N
112	515	9	GST	1	9	82.3499999999999943	2021-09-29 09:58:35.800578	2021-09-29 09:58:36.853042	\N
87	502	10	value	2	40	40	2021-09-28 04:47:10.097174	2021-09-28 04:47:15.612686	\N
88	503	10	value	2	40	40	2021-09-28 04:47:23.217173	2021-09-28 04:47:23.207559	\N
114	515	12	VAT	2	30	30	2021-09-29 09:58:35.814213	2021-09-29 09:58:36.860067	\N
121	519	8	CGST	1	8	4.40000000000000036	2021-09-30 06:37:09.243508	2021-09-30 06:38:32.027613	\N
122	519	9	GST	1	9	4.95000000000000018	2021-09-30 06:37:09.251958	2021-09-30 06:38:32.034957	\N
123	519	12	VAT	2	30	30	2021-09-30 06:37:09.259593	2021-09-30 06:38:32.042263	\N
89	504	10	value	2	40	40	2021-09-28 11:02:34.166284	2021-09-28 11:03:32.192236	\N
115	517	8	CGST	1	8	36.8000000000000043	2021-09-30 06:01:13.705945	2021-09-30 06:01:26.125459	\N
116	517	9	GST	1	9	41.3999999999999986	2021-09-30 06:01:13.714067	2021-09-30 06:01:26.134071	\N
117	517	12	VAT	2	30	30	2021-09-30 06:01:13.721692	2021-09-30 06:01:26.141827	\N
90	505	10	value	2	40	40	2021-09-28 11:28:11.841897	2021-09-28 13:23:23.821998	\N
100	509	8	CGST	1	8	18.4000000000000021	2021-09-28 12:02:53.348008	2021-09-28 12:02:59.293222	\N
101	509	9	GST	1	9	20.6999999999999993	2021-09-28 12:02:53.356646	2021-09-28 12:02:59.300629	\N
102	509	12	VAT	2	30	30	2021-09-28 12:02:53.363808	2021-09-28 12:02:59.307749	\N
106	511	10	value	2	40	40	2021-09-29 05:42:31.087381	2021-09-29 05:42:41.246064	\N
103	510	8	CGST	1	8	9.20000000000000107	2021-09-28 12:16:09.167626	2021-09-28 12:16:18.25901	\N
109	514	8	CGST	1	8	66.7999999999999972	2021-09-29 09:58:35.782084	2021-09-29 09:59:12.806816	\N
104	510	9	GST	1	9	10.3499999999999996	2021-09-28 12:16:09.176729	2021-09-28 12:16:18.266491	\N
105	510	12	VAT	2	30	30	2021-09-28 12:16:09.184694	2021-09-28 12:16:18.273632	\N
111	514	9	GST	1	9	75.1499999999999915	2021-09-29 09:58:35.797532	2021-09-29 09:59:12.814527	\N
107	512	10	value	2	40	40	2021-09-29 07:25:36.77217	2021-09-29 07:25:59.978165	\N
113	514	12	VAT	2	30	30	2021-09-29 09:58:35.811222	2021-09-29 09:59:12.822082	\N
108	513	10	value	2	40	40	2021-09-29 07:26:30.264283	2021-09-29 07:26:36.919095	\N
124	520	10	value	2	40	40	2021-09-30 07:43:39.274608	2021-09-30 08:28:28.953604	\N
118	518	8	CGST	1	8	18.4000000000000021	2021-09-30 06:08:31.855169	2021-09-30 06:08:59.859632	\N
119	518	9	GST	1	9	20.6999999999999993	2021-09-30 06:08:31.862888	2021-09-30 06:08:59.86706	\N
120	518	12	VAT	2	30	30	2021-09-30 06:08:31.870128	2021-09-30 06:08:59.874284	\N
76	448	10	value	2	40	40	2021-09-24 07:13:32.465781	2021-09-30 11:44:44.636939	\N
129	522	9	GST	1	9	40.5	2021-09-30 08:57:34.41774	2021-10-01 18:58:44.942333	\N
157	558	10	value	2	40	40	2021-10-05 10:33:38.428908	2021-10-05 10:33:57.25522	\N
142	545	9	GST	1	9	9	2021-10-04 13:04:23.850015	2021-10-04 13:57:46.742224	\N
143	545	12	VAT	2	30	30	2021-10-04 13:04:23.857827	2021-10-04 13:57:46.755685	\N
138	540	10	value	2	40	40	2021-10-04 09:04:30.132926	2021-10-04 09:04:40.865667	\N
125	521	8	CGST	1	8	432.079999999999984	2021-09-30 08:02:40.478832	2021-10-01 13:05:24.669757	\N
126	521	9	GST	1	9	486.089999999999975	2021-09-30 08:02:40.486345	2021-10-01 13:05:24.677905	\N
131	525	10	value	2	40	40	2021-09-30 11:45:02.674401	2021-09-30 11:45:43.57948	\N
127	521	12	VAT	2	30	30	2021-09-30 08:02:40.493898	2021-10-01 13:05:24.685053	\N
133	532	10	value	2	40	40	2021-10-01 07:38:24.149941	2021-10-04 08:47:15.887457	\N
132	531	10	value	2	40	40	2021-10-01 07:37:16.651213	2021-10-01 07:37:30.395633	\N
145	547	10	value	2	40	40	2021-10-05 06:31:20.666944	2021-10-05 06:31:27.992213	\N
135	537	10	value	2	40	40	2021-10-04 08:55:41.698613	2021-10-04 08:55:48.50287	\N
134	536	10	value	2	40	40	2021-10-04 08:55:41.691342	2021-10-04 08:55:48.726525	\N
153	554	10	value	2	40	40	2021-10-05 10:24:39.748653	2021-10-05 10:24:44.424478	\N
150	551	10	value	2	40	40	2021-10-05 09:59:36.845881	2021-10-05 09:59:50.887975	\N
158	559	10	value	2	40	40	2021-10-05 10:36:14.813818	2021-10-05 10:48:47.271564	\N
136	538	10	value	2	40	40	2021-10-04 08:56:20.152429	2021-10-04 08:56:24.772077	\N
139	543	10	value	2	40	40	2021-10-04 10:46:32.761944	2021-10-04 16:26:20.719723	\N
146	549	8	CGST	1	8	9.20000000000000107	2021-10-05 09:57:45.192457	2021-10-05 10:06:11.267823	\N
147	549	9	GST	1	9	10.3499999999999996	2021-10-05 09:57:45.200982	2021-10-05 10:06:11.276502	\N
140	544	10	value	2	40	40	2021-10-04 12:29:23.440253	2021-10-05 09:58:12.395193	\N
148	549	12	VAT	2	30	30	2021-10-05 09:57:45.208983	2021-10-05 10:06:11.283871	\N
137	539	10	value	2	40	40	2021-10-04 08:57:21.784561	2021-10-04 08:58:22.297394	\N
144	546	10	value	2	40	40	2021-10-05 06:23:52.810584	2021-10-05 06:23:58.426305	\N
128	522	8	CGST	1	8	36	2021-09-30 08:57:34.403324	2021-10-01 18:58:44.934734	\N
149	550	10	value	2	40	40	2021-10-05 09:58:57.992025	2021-10-05 09:59:00.16327	\N
141	545	8	CGST	1	8	8	2021-10-04 13:04:23.841626	2021-10-04 13:57:46.728061	\N
154	555	10	value	2	40	40	2021-10-05 10:25:01.411618	2021-10-05 10:25:18.594314	\N
151	552	10	value	2	40	40	2021-10-05 10:23:51.728464	2021-10-05 10:23:56.450178	\N
156	557	10	value	2	40	40	2021-10-05 10:32:05.270946	2021-10-05 10:32:20.19982	\N
152	553	10	value	2	40	40	2021-10-05 10:24:04.791163	2021-10-05 10:24:16.408893	\N
155	556	10	value	2	40	40	2021-10-05 10:30:23.56756	2021-10-05 10:31:58.993843	\N
160	561	10	value	2	40	40	2021-10-05 10:57:56.676211	2021-10-05 10:59:21.505814	\N
159	560	10	value	2	40	40	2021-10-05 10:49:28.502074	2021-10-05 10:57:44.165312	\N
161	562	10	value	2	40	40	2021-10-05 10:59:52.196945	2021-10-05 11:00:31.563145	\N
164	565	10	value	2	40	40	2021-10-05 11:16:13.16063	2021-10-05 11:16:16.619149	\N
162	563	10	value	2	40	40	2021-10-05 11:01:03.889966	2021-10-05 11:07:35.235394	\N
163	564	10	value	2	40	40	2021-10-05 11:08:17.479114	2021-10-05 11:08:24.113254	\N
167	566	12	VAT	2	30	30	2021-10-05 13:02:42.150095	2021-10-05 15:06:47.955786	\N
165	566	8	CGST	1	8	26.8000000000000007	2021-10-05 13:02:42.134161	2021-10-05 15:06:47.940852	\N
91	506	8	CGST	1	8	0	2021-09-28 11:28:20.506971	2021-10-13 22:00:22.49696	\N
169	569	10	value	2	40	40	2021-10-05 13:42:11.642866	2021-10-05 13:42:11.609414	\N
168	567	10	value	2	40	40	2021-10-05 13:31:09.309679	2021-10-05 13:31:16.156852	\N
170	568	10	value	2	40	40	2021-10-05 13:42:11.652741	2021-10-05 13:42:12.07014	\N
172	570	10	value	2	40	40	2021-10-05 13:42:42.089704	2021-10-05 13:43:48.898042	\N
171	571	10	value	2	40	40	2021-10-05 13:42:42.087724	2021-10-05 13:43:55.888903	\N
92	506	9	GST	1	9	0	2021-09-28 11:28:20.515924	2021-10-13 22:00:22.504897	\N
93	506	12	VAT	2	30	30	2021-09-28 11:28:20.524115	2021-10-13 22:00:22.512576	\N
191	583	12	VAT	2	30	30	2021-10-06 04:19:24.332758	2021-10-06 05:35:48.686139	\N
188	582	10	value	2	40	40	2021-10-05 20:40:06.63161	2021-10-06 20:40:14.019535	\N
228	614	10	value	2	40	40	2021-10-07 14:39:19.637738	2021-10-07 14:39:39.053727	\N
176	575	10	value	2	40	40	2021-10-05 14:28:30.230815	2021-10-07 04:45:53.69763	\N
173	572	10	value	2	40	40	2021-10-05 14:22:58.565332	2021-10-05 14:23:10.091889	\N
207	597	10	value	2	40	40	2021-10-07 05:04:01.293918	2021-10-07 05:04:01.284339	\N
208	598	10	value	2	40	40	2021-10-07 05:04:18.762416	2021-10-07 05:04:18.752882	\N
209	599	10	value	2	40	40	2021-10-07 05:04:36.71149	2021-10-07 05:04:36.701833	\N
205	595	10	value	2	40	40	2021-10-06 16:29:37.293423	2021-10-06 17:09:34.681573	\N
211	603	8	CGST	1	8	55.4399999999999977	2021-10-07 08:53:20.31473	2021-10-07 09:25:46.95011	\N
174	573	10	value	2	40	40	2021-10-05 14:23:47.644916	2021-10-05 14:26:47.970968	\N
175	574	10	value	2	40	40	2021-10-05 14:28:19.188777	2021-10-05 14:28:19.178955	\N
183	579	8	CGST	1	8	86.4000000000000057	2021-10-05 16:04:57.794366	2021-10-05 16:05:05.893833	\N
184	579	9	GST	1	9	97.2000000000000028	2021-10-05 16:04:57.802605	2021-10-05 16:05:05.901837	\N
185	579	12	VAT	2	30	30	2021-10-05 16:04:57.809663	2021-10-05 16:05:05.909446	\N
177	577	8	CGST	1	8	94.4000000000000057	2021-10-05 15:08:32.298509	2021-10-05 15:55:07.916617	\N
178	577	9	GST	1	9	106.200000000000003	2021-10-05 15:08:32.306436	2021-10-05 15:55:07.924429	\N
179	577	12	VAT	2	30	30	2021-10-05 15:08:32.313736	2021-10-05 15:55:07.931834	\N
212	603	9	GST	1	9	62.3699999999999974	2021-10-07 08:53:20.322816	2021-10-07 09:25:46.957301	\N
213	603	12	VAT	2	30	30	2021-10-07 08:53:20.330707	2021-10-07 09:25:46.964263	\N
206	596	10	value	2	40	40	2021-10-06 17:09:45.074943	2021-10-07 07:15:38.262912	\N
192	584	8	CGST	1	8	70.4000000000000057	2021-10-06 05:36:39.415457	2021-10-06 05:38:11.658415	\N
193	584	9	GST	1	9	79.2000000000000028	2021-10-06 05:36:39.4239	2021-10-06 05:38:11.666149	\N
186	580	10	value	2	40	40	2021-10-05 19:32:23.664997	2021-10-05 19:42:54.395709	\N
194	584	12	VAT	2	30	30	2021-10-06 05:36:39.431421	2021-10-06 05:38:11.673952	\N
195	586	10	value	2	40	40	2021-10-06 05:48:44.640586	2021-10-06 05:48:44.631351	\N
214	605	8	CGST	1	8	57.4399999999999977	2021-10-07 09:30:14.555115	2021-10-08 12:45:42.396438	\N
215	605	9	GST	1	9	64.6200000000000045	2021-10-07 09:30:14.564948	2021-10-08 12:45:42.410996	\N
166	566	9	GST	1	9	30.1499999999999986	2021-10-05 13:02:42.142796	2021-10-05 15:06:47.948649	\N
187	581	10	value	2	40	40	2021-10-05 19:59:25.833142	2021-10-05 20:40:01.95165	\N
216	605	12	VAT	2	30	30	2021-10-07 09:30:14.572731	2021-10-08 12:45:42.42126	\N
196	587	10	value	2	40	40	2021-10-06 07:23:07.00411	2021-10-06 07:23:06.994479	\N
199	590	10	value	2	40	40	2021-10-06 08:32:07.735624	2021-10-06 16:19:46.055892	\N
197	588	10	value	2	40	40	2021-10-06 07:23:22.256408	2021-10-06 07:23:27.197394	\N
225	611	10	value	2	40	40	2021-10-07 14:31:08.968082	2021-10-07 14:31:15.088695	\N
180	578	8	CGST	1	8	30.8000000000000007	2021-10-05 16:04:08.625754	2021-10-05 16:04:18.921105	\N
181	578	9	GST	1	9	34.6499999999999986	2021-10-05 16:04:08.635591	2021-10-05 16:04:18.929253	\N
182	578	12	VAT	2	30	30	2021-10-05 16:04:08.642679	2021-10-05 16:04:18.936165	\N
220	608	8	CGST	1	8	10.4000000000000004	2021-10-07 13:38:13.981865	2021-10-07 13:42:25.676479	\N
221	608	9	GST	1	9	11.6999999999999993	2021-10-07 13:38:13.991328	2021-10-07 13:42:25.68439	\N
222	608	12	VAT	2	30	30	2021-10-07 13:38:13.999264	2021-10-07 13:42:25.691725	\N
200	591	8	CGST	1	8	14.6400000000000006	2021-10-06 13:33:15.762742	2021-10-07 07:27:30.875723	\N
201	591	9	GST	1	9	16.4699999999999989	2021-10-06 13:33:15.771474	2021-10-07 07:27:30.891588	\N
203	593	10	value	2	40	40	2021-10-06 16:28:44.445108	2021-10-06 16:28:58.448403	\N
202	591	12	VAT	2	30	30	2021-10-06 13:33:15.778609	2021-10-07 07:27:30.905107	\N
198	589	10	value	2	40	40	2021-10-06 07:58:27.177782	2021-10-06 08:31:51.571627	\N
231	617	10	value	2	40	40	2021-10-07 14:56:50.205447	2021-10-07 14:56:57.74087	\N
204	594	10	value	2	40	40	2021-10-06 16:29:21.254111	2021-10-06 16:29:29.881567	\N
189	583	8	CGST	1	8	118.799999999999997	2021-10-06 04:19:24.316492	2021-10-06 05:35:48.671456	\N
190	583	9	GST	1	9	133.650000000000006	2021-10-06 04:19:24.325274	2021-10-06 05:35:48.678975	\N
226	612	10	value	2	40	40	2021-10-07 14:31:43.844787	2021-10-07 14:31:50.472525	\N
217	607	8	CGST	1	8	4.40000000000000036	2021-10-07 12:57:24.374873	2021-10-07 12:57:39.703073	\N
229	615	10	value	2	40	40	2021-10-07 14:40:32.977534	2021-10-07 14:40:43.088307	\N
218	607	9	GST	1	9	4.95000000000000018	2021-10-07 12:57:24.383221	2021-10-07 12:57:39.722104	\N
219	607	12	VAT	2	30	30	2021-10-07 12:57:24.390302	2021-10-07 12:57:39.748612	\N
240	609	16	TNNN	2	10	10	2021-10-08 10:55:50.146264	2021-10-08 10:55:50.142419	\N
232	618	8	CGST	1	8	3.43999999999999995	2021-10-07 18:27:29.932994	2021-10-08 10:10:45.56326	\N
224	610	10	value	2	40	40	2021-10-07 14:03:37.964961	2021-10-07 14:03:48.14675	\N
230	616	10	value	2	40	40	2021-10-07 14:45:54.142361	2021-10-07 14:46:05.180763	\N
227	613	10	value	2	40	40	2021-10-07 14:32:17.336401	2021-10-07 14:32:24.546323	\N
233	618	9	GST	1	9	3.86999999999999966	2021-10-07 18:27:29.941595	2021-10-08 10:10:45.571192	\N
234	618	12	VAT	2	30	30	2021-10-07 18:27:29.949168	2021-10-08 10:10:45.578423	\N
248	626	10	value	2	40	40	2021-10-08 13:31:09.952855	2021-10-11 07:45:13.014763	\N
237	620	8	CGST	1	8	22	2021-10-08 09:28:07.370422	2021-10-08 20:52:22.569765	\N
238	620	9	GST	1	9	24.75	2021-10-08 09:28:07.379391	2021-10-08 20:52:22.577297	\N
236	619	16	TNNN	2	10	10	2021-10-08 08:47:03.644811	2021-10-08 11:07:31.198255	\N
210	600	10	value	2	40	40	2021-10-07 05:12:45.464589	2021-10-08 11:09:39.580546	\N
223	609	10	value	2	40	40	2021-10-07 14:03:25.455519	2021-10-08 10:55:50.138213	\N
243	600	16	TNNN	2	10	10	2021-10-08 11:09:32.006647	2021-10-08 11:09:39.587924	\N
250	627	8	CGST	1	8	5.44000000000000039	2021-10-08 13:33:02.535123	2021-10-08 13:43:01.426684	\N
244	624	10	value	2	40	40	2021-10-08 11:35:27.649018	2021-10-08 11:35:45.381171	\N
241	623	10	value	2	40	40	2021-10-08 10:56:00.720371	2021-10-08 11:09:12.777004	\N
242	623	16	TNNN	2	10	10	2021-10-08 10:56:00.728087	2021-10-08 11:09:12.79212	\N
235	619	10	value	2	40	40	2021-10-08 08:47:03.635872	2021-10-08 11:07:31.17903	\N
245	624	16	TNNN	2	10	10	2021-10-08 11:35:27.659448	2021-10-08 11:35:45.38905	\N
246	625	10	value	2	40	40	2021-10-08 13:06:11.0094	2021-10-08 13:42:56.325334	\N
249	626	16	TNNN	2	10	10	2021-10-08 13:31:09.963762	2021-10-11 07:45:13.022844	\N
252	627	12	VAT	2	30	30	2021-10-08 13:33:02.55135	2021-10-08 13:43:01.442539	\N
239	620	12	VAT	2	30	30	2021-10-08 09:28:07.387664	2021-10-08 20:52:22.584236	\N
251	627	9	GST	1	9	6.12000000000000011	2021-10-08 13:33:02.543262	2021-10-08 13:43:01.434758	\N
247	625	16	TNNN	2	10	10	2021-10-08 13:06:11.017847	2021-10-08 13:42:56.332433	\N
253	628	8	CGST	1	8	12.4000000000000004	2021-10-08 13:38:23.069708	2021-10-08 17:59:26.31252	\N
254	628	9	GST	1	9	13.9499999999999993	2021-10-08 13:38:23.078138	2021-10-08 17:59:26.325648	\N
293	645	16	TNNN	2	10	10	2021-10-11 13:35:07.287335	2021-10-12 14:05:22.140994	\N
304	651	10	value	2	40	40	2021-10-11 19:18:20.006009	2021-10-11 19:19:25.819911	\N
305	651	16	TNNN	2	10	10	2021-10-11 19:18:20.014761	2021-10-11 19:19:25.827694	\N
308	653	10	value	2	40	40	2021-10-11 19:52:08.196149	2021-10-11 20:13:25.627295	\N
309	653	16	TNNN	2	10	10	2021-10-11 19:52:08.206056	2021-10-11 20:13:25.634699	\N
302	650	10	value	2	40	40	2021-10-11 19:06:10.82185	2021-10-11 19:14:46.694237	\N
303	650	16	TNNN	2	10	10	2021-10-11 19:06:10.829343	2021-10-11 19:14:46.701445	\N
300	649	10	value	2	40	40	2021-10-11 18:46:29.901506	2021-10-11 19:03:47.912109	\N
265	633	10	value	2	40	40	2021-10-08 15:52:03.811815	2021-10-08 15:53:31.28869	\N
266	633	16	TNNN	2	10	10	2021-10-08 15:52:03.819857	2021-10-08 15:53:31.306978	\N
301	649	16	TNNN	2	10	10	2021-10-11 18:46:29.910222	2021-10-11 19:03:47.919898	\N
274	637	8	CGST	1	8	7.20000000000000018	2021-10-08 20:57:22.560868	2021-10-08 20:57:23.782335	\N
275	637	9	GST	1	9	8.09999999999999964	2021-10-08 20:57:22.570071	2021-10-08 20:57:23.79187	\N
276	637	12	VAT	2	30	30	2021-10-08 20:57:22.577165	2021-10-08 20:57:23.799387	\N
277	638	8	CGST	1	8	6.40000000000000036	2021-10-11 05:23:32.973826	2021-10-11 05:23:33.843135	\N
278	638	9	GST	1	9	7.19999999999999929	2021-10-11 05:23:32.982631	2021-10-11 05:23:33.850744	\N
279	638	12	VAT	2	30	30	2021-10-11 05:23:32.990074	2021-10-11 05:23:33.857861	\N
256	629	8	CGST	1	8	6.64000000000000057	2021-10-08 13:43:31.598245	2021-10-08 13:46:01.117168	\N
257	629	9	GST	1	9	7.46999999999999975	2021-10-08 13:43:31.606328	2021-10-08 13:46:01.12476	\N
258	629	12	VAT	2	30	30	2021-10-08 13:43:31.613827	2021-10-08 13:46:01.132261	\N
261	631	10	value	2	40	40	2021-10-08 15:48:38.802232	2021-10-08 15:51:22.319219	\N
262	631	16	TNNN	2	10	10	2021-10-08 15:48:38.810683	2021-10-08 15:51:22.327157	\N
280	640	8	CGST	1	8	8.80000000000000071	2021-10-11 05:39:15.641267	2021-10-11 05:39:16.441311	\N
281	640	9	GST	1	9	9.90000000000000036	2021-10-11 05:39:15.649252	2021-10-11 05:39:16.451339	\N
282	640	12	VAT	2	30	30	2021-10-11 05:39:15.656599	2021-10-11 05:39:16.458941	\N
259	630	10	value	2	40	40	2021-10-08 13:58:23.36588	2021-10-08 15:23:38.365422	\N
260	630	16	TNNN	2	10	10	2021-10-08 13:58:23.375176	2021-10-08 15:23:38.372607	\N
317	657	8	CGST	1	8	31.1999999999999993	2021-10-12 18:58:03.038201	2021-10-13 12:41:41.321128	\N
327	661	16	TNNN	2	10	10	2021-10-13 12:29:28.754817	2021-10-13 12:29:57.128446	\N
283	641	8	CGST	1	8	6.40000000000000036	2021-10-11 09:26:24.384697	2021-10-11 09:26:30.980988	\N
298	648	10	value	2	40	40	2021-10-11 18:37:35.666929	2021-10-11 18:42:43.486476	\N
299	648	16	TNNN	2	10	10	2021-10-11 18:37:35.674865	2021-10-11 18:42:43.494077	\N
284	641	9	GST	1	9	7.19999999999999929	2021-10-11 09:26:24.393019	2021-10-11 09:26:30.999775	\N
285	641	12	VAT	2	30	30	2021-10-11 09:26:24.40045	2021-10-11 09:26:31.01438	\N
263	632	10	value	2	40	40	2021-10-08 15:51:34.492248	2021-10-08 15:51:52.05901	\N
264	632	16	TNNN	2	10	10	2021-10-08 15:51:34.499675	2021-10-08 15:51:52.074576	\N
267	634	10	value	2	40	40	2021-10-08 15:55:57.403877	2021-10-08 15:56:50.492261	\N
268	634	16	TNNN	2	10	10	2021-10-08 15:55:57.413247	2021-10-08 15:56:50.499746	\N
269	635	10	value	2	40	40	2021-10-08 17:40:12.554032	2021-10-08 17:41:08.932873	\N
270	635	16	TNNN	2	10	10	2021-10-08 17:40:12.561942	2021-10-08 17:41:08.940625	\N
324	660	10	value	2	40	40	2021-10-13 12:25:08.757113	2021-10-13 12:29:14.821479	\N
255	628	12	VAT	2	30	30	2021-10-08 13:38:23.085745	2021-10-08 17:59:26.338917	\N
325	660	16	TNNN	2	10	10	2021-10-13 12:25:08.765591	2021-10-13 12:29:14.837545	\N
312	655	10	value	2	40	40	2021-10-12 16:14:38.615574	2021-10-16 04:49:29.747901	\N
271	636	8	CGST	1	8	2.39999999999999991	2021-10-08 20:53:35.880895	2021-10-08 20:53:39.152754	\N
272	636	9	GST	1	9	2.69999999999999973	2021-10-08 20:53:35.888929	2021-10-08 20:53:39.160474	\N
273	636	12	VAT	2	30	30	2021-10-08 20:53:35.896182	2021-10-08 20:53:39.167852	\N
310	654	10	value	2	40	40	2021-10-12 14:26:19.65141	2021-10-14 14:08:19.97712	\N
286	642	8	CGST	1	8	13.2000000000000011	2021-10-11 09:27:30.804571	2021-10-12 14:40:44.401535	\N
287	642	9	GST	1	9	14.8499999999999996	2021-10-11 09:27:30.812236	2021-10-12 14:40:44.408911	\N
294	646	10	value	2	40	40	2021-10-11 16:19:02.548524	2021-10-11 16:19:02.539121	\N
295	646	16	TNNN	2	10	10	2021-10-11 16:19:02.55875	2021-10-11 16:19:02.554946	\N
296	647	10	value	2	40	40	2021-10-11 16:19:33.063146	2021-10-11 16:19:33.053779	\N
297	647	16	TNNN	2	10	10	2021-10-11 16:19:33.071429	2021-10-11 16:19:33.067613	\N
288	642	12	VAT	2	30	30	2021-10-11 09:27:30.819457	2021-10-12 14:40:44.416126	\N
322	659	10	value	2	40	40	2021-10-13 11:41:28.163967	2021-10-13 12:24:43.838073	\N
311	654	16	TNNN	2	10	10	2021-10-12 14:26:19.660349	2021-10-14 14:08:19.986305	\N
313	655	16	TNNN	2	10	10	2021-10-12 16:14:38.625155	2021-10-16 04:49:29.81943	\N
323	659	16	TNNN	2	10	10	2021-10-13 11:41:28.172367	2021-10-13 12:24:43.845534	\N
306	652	10	value	2	40	40	2021-10-11 19:19:38.431944	2021-10-11 19:22:39.100825	\N
289	643	8	CGST	1	8	18.4000000000000021	2021-10-11 09:47:22.245327	2021-10-12 19:55:20.775268	\N
307	652	16	TNNN	2	10	10	2021-10-11 19:19:38.439242	2021-10-11 19:22:39.108482	\N
290	643	9	GST	1	9	20.6999999999999993	2021-10-11 09:47:22.253585	2021-10-12 19:55:20.783846	\N
314	656	8	CGST	1	8	26.4000000000000021	2021-10-12 18:49:44.45722	2021-10-12 18:50:31.18208	\N
292	645	10	value	2	40	40	2021-10-11 13:35:07.278948	2021-10-12 14:05:22.133052	\N
291	643	12	VAT	2	30	30	2021-10-11 09:47:22.260888	2021-10-12 19:55:20.791109	\N
315	656	9	GST	1	9	29.6999999999999993	2021-10-12 18:49:44.478497	2021-10-12 18:50:31.196786	\N
316	656	12	VAT	2	30	30	2021-10-12 18:49:44.493521	2021-10-12 18:50:31.213601	\N
320	658	14	aa	2	30	30	2021-10-12 19:25:49.50548	2021-10-13 18:19:15.058898	\N
319	657	12	VAT	2	30	30	2021-10-12 18:58:03.054715	2021-10-13 12:41:41.345493	\N
329	662	16	TNNN	2	10	10	2021-10-13 12:35:19.437741	2021-10-13 12:36:12.158795	\N
326	661	10	value	2	40	40	2021-10-13 12:29:28.74638	2021-10-13 12:29:57.114937	\N
328	662	10	value	2	40	40	2021-10-13 12:35:19.429549	2021-10-13 12:36:12.147756	\N
330	663	10	value	2	40	40	2021-10-13 12:36:19.662799	2021-10-13 12:37:28.588926	\N
331	663	16	TNNN	2	10	10	2021-10-13 12:36:19.670815	2021-10-13 12:37:28.597389	\N
318	657	9	GST	1	9	35.1000000000000014	2021-10-12 18:58:03.047245	2021-10-13 12:41:41.33543	\N
332	664	10	value	2	40	40	2021-10-13 12:38:58.003585	2021-10-13 12:40:02.359902	\N
333	664	16	TNNN	2	10	10	2021-10-13 12:38:58.011554	2021-10-13 12:40:02.369421	\N
334	665	8	CGST	1	8	126.799999999999997	2021-10-13 12:41:57.516989	2021-10-13 12:43:43.107441	\N
336	665	12	VAT	2	30	30	2021-10-13 12:41:57.531606	2021-10-13 12:43:43.122136	\N
335	665	9	GST	1	9	142.650000000000006	2021-10-13 12:41:57.524335	2021-10-13 12:43:43.115063	\N
338	666	9	GST	1	9	14.3999999999999986	2021-10-13 12:43:52.752335	2021-10-13 16:23:21.72405	\N
321	658	15	aaa	2	20	20	2021-10-12 19:25:49.51352	2021-10-13 18:19:15.067267	\N
345	670	9	GST	1	9	12.5999999999999996	2021-10-17 10:25:06.663184	2021-10-17 10:25:13.822538	\N
346	670	12	VAT	2	30	30	2021-10-17 10:25:06.672399	2021-10-17 10:25:13.832285	\N
347	670	8	CGST	1	8	11.2000000000000011	2021-10-17 10:25:06.679795	2021-10-17 10:25:13.839407	\N
348	671	9	GST	1	9	61.1999999999999957	2021-10-17 10:25:59.127699	2021-10-17 10:26:20.35817	\N
337	666	8	CGST	1	8	12.8000000000000007	2021-10-13 12:43:52.744943	2021-10-13 16:23:21.715704	\N
339	666	12	VAT	2	30	30	2021-10-13 12:43:52.759483	2021-10-13 16:23:21.731276	\N
349	671	12	VAT	2	30	30	2021-10-17 10:25:59.135919	2021-10-17 10:26:20.366258	\N
350	671	8	CGST	1	8	54.3999999999999986	2021-10-17 10:25:59.143327	2021-10-17 10:26:20.373995	\N
357	674	9	GST	1	9	12.5999999999999996	2021-10-17 15:13:07.7936	2021-10-17 15:14:37.619568	\N
358	674	12	VAT	2	30	30	2021-10-17 15:13:07.802512	2021-10-17 15:14:37.627204	\N
340	667	14	aa	2	30	30	2021-10-13 19:05:28.058207	2021-10-13 19:05:38.071633	\N
341	667	15	aaa	2	20	20	2021-10-13 19:05:28.066921	2021-10-13 19:05:38.079419	\N
359	674	8	CGST	1	8	11.2000000000000011	2021-10-17 15:13:07.810545	2021-10-17 15:14:37.634702	\N
360	675	9	GST	1	9	22.9499999999999993	2021-10-17 15:15:32.423515	2021-10-17 15:17:01.618751	\N
361	675	12	VAT	2	30	30	2021-10-17 15:15:32.430969	2021-10-17 15:17:01.626833	\N
362	675	8	CGST	1	8	20.4000000000000021	2021-10-17 15:15:32.438202	2021-10-17 15:17:01.634336	\N
342	669	9	GST	1	9	11.25	2021-10-17 10:24:01.66036	2021-10-17 10:24:06.427796	\N
343	669	12	VAT	2	30	30	2021-10-17 10:24:01.669622	2021-10-17 10:24:06.435417	\N
344	669	8	CGST	1	8	10	2021-10-17 10:24:01.677788	2021-10-17 10:24:06.442652	\N
354	673	9	GST	1	9	27.4499999999999993	2021-10-17 10:35:51.267977	2021-10-17 10:36:12.513804	\N
355	673	12	VAT	2	30	30	2021-10-17 10:35:51.276254	2021-10-17 10:36:12.521528	\N
356	673	8	CGST	1	8	24.4000000000000021	2021-10-17 10:35:51.283576	2021-10-17 10:36:12.529136	\N
363	676	10	value	2	40	40	2021-10-17 15:25:38.531986	2021-10-17 15:26:56.957976	\N
364	676	16	TNNN	2	10	10	2021-10-17 15:25:38.540494	2021-10-17 15:26:56.972666	\N
351	672	9	GST	1	9	66.1499999999999915	2021-10-17 10:27:39.29339	2021-10-17 10:33:20.920351	\N
352	672	12	VAT	2	30	30	2021-10-17 10:27:39.301277	2021-10-17 10:33:20.928115	\N
353	672	8	CGST	1	8	58.8000000000000043	2021-10-17 10:27:39.308515	2021-10-17 10:33:20.935141	\N
\.


--
-- Data for Name: item_orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.item_orders (id, user_id, store_id, slug, order_total, coupon_id, order_total_discount, final_order_total, delivery_fee, grand_order_total, initial_paid, order_created, order_confirmed, ready_to_pack, order_paid, order_pickedup, order_delivered, delivery_date, user_address_id, delivery_slot_id, da_id, status, merchant_transfer_at, merchant_transaction_id, txnid, gateway, transaction_status, created_at, updated_at, deleted_at, remove_by_role, cancelled_by_id, cancelled_by_role, remove_by_id, total_tax, commision, walk_in_order) FROM stdin;
165	4	1	\N	873	\N	\N	873	\N	873	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 06:08:02.544775	2021-08-25 11:19:12.54631	2021-08-25 11:19:16.430061	\N	\N	\N	\N	\N	\N	\N
170	7	11	\N	665	\N	\N	665	50	715	\N	2021-08-25 07:10:30.175399	2021-08-25 10:02:57.233946	2021-08-25 10:03:00.053855	\N	\N	\N	\N	9	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 07:10:06.15997	2021-08-25 10:03:00.053875	\N	\N	\N	\N	\N	\N	\N	\N
142	7	1	\N	115	\N	\N	115	50	165	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 08:14:11.30753	2021-08-24 08:14:23.548309	2021-08-24 12:51:58.441964	\N	\N	\N	\N	\N	\N	\N
133	13	1	\N	2240	\N	\N	2240	50	2290	\N	2021-08-23 13:54:06.563568	2021-08-23 14:45:18.878166	2021-08-23 15:10:48.40302	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-23 13:33:49.450561	2021-08-24 06:36:31.855408	\N	\N	\N	\N	\N	\N	\N	\N
173	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 08:12:10.384002	2021-08-25 08:12:10.396897	2021-08-25 21:09:55.272953	\N	\N	\N	\N	\N	\N	\N
134	13	1	\N	540	\N	\N	540	50	590	\N	2021-08-23 14:25:03.960657	\N	\N	\N	\N	\N	\N	19	\N	\N	10	\N	\N	\N	\N	\N	2021-08-23 14:01:40.812019	2021-08-23 15:16:58.990117	\N	\N	\N	\N	\N	\N	\N	\N
131	7	1	\N	1115	\N	\N	1115	50	1165	\N	\N	\N	\N	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-22 15:50:39.106087	2021-08-22 15:50:53.687643	2021-08-24 04:34:12.195767	\N	\N	\N	\N	\N	\N	\N
152	7	1	\N	1210	32	100	1110	\N	1110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:17:09.304699	2021-08-24 15:18:35.572456	2021-08-24 15:18:46.521295	\N	\N	\N	\N	\N	\N	\N
135	13	1	\N	465	\N	\N	465	50	515	\N	2021-08-23 14:25:26.345708	2021-08-24 06:26:52.135639	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-23 14:25:12.975869	2021-08-24 08:51:21.066762	\N	\N	\N	\N	\N	\N	\N	\N
138	13	1	\N	180	\N	\N	180	50	230	\N	\N	\N	\N	\N	\N	\N	\N	19	\N	\N	1	\N	\N	\N	\N	\N	2021-08-23 14:26:43.774172	2021-08-23 14:27:41.939388	2021-08-24 05:35:47.039027	\N	\N	\N	\N	\N	\N	\N
156	7	1	\N	521	33	50	471	\N	471	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:35:39.814166	2021-08-24 15:37:52.603334	2021-08-24 15:37:59.130817	\N	\N	\N	\N	\N	\N	\N
132	13	1	\N	2210	\N	\N	2210	\N	2210	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-23 10:09:17.940553	2021-08-23 13:33:40.943283	2021-08-23 13:33:45.442009	\N	\N	\N	\N	\N	\N	\N
144	13	1	\N	825	\N	\N	825	\N	825	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 09:20:04.199048	2021-08-24 09:20:35.033763	2021-08-24 09:20:45.606775	\N	\N	\N	\N	\N	\N	\N
161	13	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 02:50:51.192385	2021-08-25 02:50:51.203717	2021-08-25 02:50:54.97543	\N	\N	\N	\N	\N	\N	\N
157	7	1	\N	4294	32	100	4194	50	4244	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 17:05:39.603646	2021-08-24 20:47:39.79289	2021-08-25 06:53:02.24625	\N	\N	\N	\N	\N	\N	\N
139	7	1	\N	115	\N	\N	115	50	165	\N	2021-08-24 04:36:12.680623	2021-08-24 06:08:32.837631	2021-08-24 07:24:47.265043	\N	\N	\N	\N	9	\N	\N	11	\N	\N	\N	\N	\N	2021-08-24 04:35:12.468351	2021-08-25 14:59:25.538095	\N	\N	\N	\N	\N	\N	\N	\N
166	7	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 06:13:05.749724	2021-08-25 06:13:05.765414	2021-08-25 06:53:10.868048	\N	\N	\N	\N	\N	\N	\N
162	13	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 03:44:32.47559	2021-08-25 03:44:32.489184	2021-08-25 04:29:41.077286	\N	\N	\N	\N	\N	\N	\N
183	7	21	\N	735	\N	\N	735	50	785	\N	2021-08-26 05:10:16.696997	\N	\N	\N	\N	\N	\N	23	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 10:29:04.623377	2021-08-26 05:11:27.780792	\N	\N	\N	\N	\N	\N	\N	\N
172	15	11	\N	90	\N	\N	90	\N	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 07:30:43.883111	2021-08-25 07:30:50.25548	\N	\N	\N	\N	\N	\N	\N	\N
164	13	1	\N	6499	\N	\N	6499	\N	6499	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 05:00:42.669218	2021-08-25 21:09:34.031305	2021-08-25 21:09:57.321634	\N	\N	\N	\N	\N	\N	\N
184	4	1	\N	445	\N	\N	445	\N	445	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:21:27.156012	2021-08-25 11:30:16.238059	2021-08-25 11:31:52.440039	\N	\N	\N	\N	\N	\N	\N
182	13	21	\N	310	34	31	279	50	329	\N	2021-08-25 10:32:48.277707	2021-08-25 10:34:15.839504	2021-08-25 10:34:22.448998	\N	\N	\N	\N	22	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 10:28:17.658439	2021-08-25 10:34:35.844206	\N	\N	\N	\N	\N	\N	\N	\N
147	6	1	\N	700	33	50	650	50	700	\N	2021-08-24 13:24:36.217794	2021-08-25 11:37:58.577722	2021-08-30 02:18:06.687453	\N	\N	\N	\N	5	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 13:24:03.926727	2021-08-30 02:18:06.687474	\N	\N	\N	\N	\N	\N	\N	\N
392	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 14:11:45.431614	2021-09-15 08:54:31.154721	2021-09-15 08:54:54.018868	\N	\N	\N	\N	0	\N	1
181	13	21	\N	0	\N	\N	0	50	50	\N	2021-08-25 10:19:31.748518	\N	\N	\N	\N	\N	\N	22	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 10:18:58.767267	2021-08-25 10:20:32.451947	\N	\N	\N	\N	\N	\N	\N	\N
155	7	1	\N	890	\N	\N	890	50	940	\N	\N	\N	\N	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:29:42.026537	2021-08-24 15:30:08.221009	2021-08-24 15:30:14.864929	\N	\N	\N	\N	\N	\N	\N
168	7	11	\N	628	\N	\N	628	\N	628	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 07:00:28.289153	2021-08-25 07:00:44.683133	2021-08-25 07:01:09.874589	\N	\N	\N	\N	\N	\N	\N
163	13	1	\N	720	\N	\N	720	\N	720	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 05:00:25.13964	2021-08-25 05:00:32.410223	2021-08-25 05:00:35.832196	\N	\N	\N	\N	\N	\N	\N
140	13	1	\N	220	\N	\N	220	50	270	\N	2021-08-24 06:28:28.17836	\N	\N	\N	\N	\N	\N	19	\N	\N	10	\N	\N	\N	\N	\N	2021-08-24 06:19:23.771884	2021-08-24 11:16:09.309676	\N	\N	\N	\N	\N	\N	\N	\N
158	13	1	\N	483	\N	\N	663	\N	663	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 20:42:12.983838	2021-08-24 20:42:16.711138	2021-08-25 01:34:45.562131	\N	\N	\N	\N	\N	\N	\N
146	13	1	\N	1115	32	100	1015	50	1065	\N	2021-08-24 20:20:32.501801	2021-08-25 11:58:29.068414	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-24 09:28:55.450358	2021-08-25 11:59:58.332238	\N	\N	\N	\N	\N	\N	\N	\N
149	7	1	\N	170	\N	\N	170	\N	170	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 13:45:01.061067	2021-08-24 13:56:44.676354	2021-08-24 13:58:46.986128	\N	\N	\N	\N	\N	\N	\N
151	7	1	\N	935	\N	\N	935	\N	935	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:16:52.604391	2021-08-24 15:16:56.630016	2021-08-24 15:17:05.225031	\N	\N	\N	\N	\N	\N	\N
143	13	1	\N	1195	32	100	1095	\N	1095	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 09:05:34.106817	2021-08-24 09:19:46.572101	2021-08-24 09:19:59.482453	\N	\N	\N	\N	\N	\N	\N
189	7	11	\N	825	\N	\N	825	50	875	\N	2021-08-25 11:43:18.73395	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:42:26.132334	2021-08-25 11:43:16.750436	\N	\N	\N	\N	\N	\N	\N	\N
137	13	1	\N	180	\N	\N	180	50	230	\N	2021-08-23 14:26:00.580287	2021-08-24 06:10:57.803621	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-23 14:25:53.521477	2021-08-25 11:08:12.180168	\N	\N	\N	\N	\N	\N	\N	\N
150	7	1	\N	110	\N	\N	110	50	160	\N	2021-08-24 13:59:14.053326	\N	\N	\N	\N	\N	\N	9	\N	\N	11	\N	\N	\N	\N	\N	2021-08-24 13:58:52.144177	2021-08-25 05:15:30.217742	\N	\N	\N	\N	\N	\N	\N	\N
154	7	1	\N	456	33	50	406	50	456	\N	\N	\N	\N	\N	\N	\N	\N	10	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:18:52.764569	2021-08-24 15:29:19.353667	2021-08-24 15:29:28.51635	\N	\N	\N	\N	\N	\N	\N
153	7	1	\N	459	\N	\N	459	\N	459	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 15:18:52.762908	2021-08-24 15:29:21.199201	2021-08-24 15:29:35.811146	\N	\N	\N	\N	\N	\N	\N
171	7	11	\N	455	\N	\N	455	50	505	\N	2021-08-25 07:19:49.977087	2021-08-25 09:12:48.258433	2021-08-25 09:12:50.609575	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 07:14:41.735815	2021-08-25 09:12:50.609596	\N	\N	\N	\N	\N	\N	\N	\N
176	7	11	\N	1372	\N	\N	1372	50	1422	\N	\N	\N	\N	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 09:09:36.898241	2021-08-25 09:10:17.237891	2021-08-25 09:13:10.488004	\N	\N	\N	\N	\N	\N	\N
175	14	1	\N	360	\N	\N	360	\N	360	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 08:34:52.704988	2021-08-25 08:34:52.832636	\N	\N	\N	\N	\N	\N	\N	\N
160	13	1	\N	415	\N	\N	415	\N	415	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 02:48:21.764416	2021-08-25 02:48:26.417197	2021-08-25 02:48:51.02376	\N	\N	\N	\N	\N	\N	\N
159	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 01:42:12.303013	2021-08-25 01:42:12.318181	2021-08-25 02:48:53.791101	\N	\N	\N	\N	\N	\N	\N
169	7	11	\N	655	\N	\N	655	50	705	\N	2021-08-25 07:08:34.253696	\N	\N	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 07:08:16.75271	2021-08-25 07:08:27.045981	\N	\N	\N	\N	\N	\N	\N	\N
179	7	11	\N	1576	35	99	1477	50	1527	\N	2021-08-25 11:28:00.479798	2021-08-25 11:29:14.500964	2021-08-25 11:29:26.611404	\N	\N	\N	\N	9	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 10:05:32.164678	2021-08-25 11:29:26.611427	\N	\N	\N	\N	\N	\N	\N	\N
136	13	1	\N	350	\N	\N	350	50	400	\N	2021-08-23 14:25:43.50994	2021-08-24 06:16:57.110785	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-23 14:25:34.74283	2021-08-25 05:53:27.926924	\N	\N	\N	\N	\N	\N	\N	\N
130	4	1	\N	1410	\N	\N	1410	50	1460	\N	\N	\N	\N	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-08-22 03:03:22.712874	2021-08-24 12:35:08.499225	2021-08-25 06:07:55.950776	\N	\N	\N	\N	\N	\N	\N
186	13	21	\N	535	34	50	485	50	535	\N	\N	\N	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:26:31.867461	2021-08-25 11:26:49.800687	2021-08-25 11:27:16.380621	\N	\N	\N	\N	\N	\N	\N
167	7	11	\N	3885	\N	\N	3885	\N	3885	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 06:54:17.154648	2021-08-25 06:56:01.698319	2021-08-25 06:56:09.874755	\N	\N	\N	\N	\N	\N	\N
180	13	21	\N	600	34	50	550	50	600	\N	2021-08-25 10:16:42.331915	2021-08-25 10:17:32.944221	2021-08-25 10:18:02.618824	\N	\N	\N	\N	22	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 10:10:37.781411	2021-08-25 11:30:08.592266	\N	\N	\N	\N	\N	\N	\N	\N
185	13	21	\N	3000	\N	\N	3000	\N	3000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:25:38.954227	2021-08-25 11:25:54.635588	2021-08-25 11:25:59.710813	\N	\N	\N	\N	\N	\N	\N
178	6	21	\N	115	35	46	69	50	119	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 09:56:43.421384	2021-08-25 11:17:29.491179	2021-08-25 11:32:34.954761	\N	\N	\N	\N	\N	\N	\N
174	7	11	\N	1355	\N	\N	1355	\N	1355	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 08:34:18.820923	2021-08-25 08:36:54.585737	2021-08-25 08:40:18.042245	\N	\N	\N	\N	\N	\N	\N
177	7	11	\N	411	\N	\N	411	50	461	\N	2021-08-25 09:43:37.386033	2021-08-25 10:44:10.755818	\N	\N	\N	\N	\N	9	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 09:30:18.794065	2021-08-25 10:44:10.755837	\N	\N	\N	\N	\N	\N	\N	\N
187	7	11	\N	45	\N	\N	45	50	95	\N	2021-08-25 11:31:35.307942	\N	\N	\N	\N	\N	\N	23	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 11:30:19.381023	2021-08-25 11:30:29.931629	\N	\N	\N	\N	\N	\N	\N	\N
188	7	11	\N	1000	\N	\N	1000	50	1050	\N	2021-08-25 11:34:01.266593	2021-08-25 11:34:11.911633	\N	\N	\N	\N	\N	23	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 11:33:38.840107	2021-08-25 11:34:11.911655	\N	\N	\N	\N	\N	\N	\N	\N
190	4	21	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:44:11.00681	2021-08-25 11:44:11.020941	2021-08-25 11:44:15.117394	\N	\N	\N	\N	\N	\N	\N
191	7	11	\N	305	\N	\N	305	50	355	\N	2021-08-25 11:47:55.550027	2021-08-25 12:16:19.87375	2021-08-25 12:16:20.761891	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:47:39.589882	2021-08-25 12:16:20.761908	\N	\N	\N	\N	\N	\N	\N	\N
192	7	11	\N	45	\N	\N	45	50	95	\N	2021-08-25 11:50:18.995609	2021-08-25 12:14:31.704224	2021-08-25 12:14:33.113527	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 11:49:39.780396	2021-08-25 12:14:33.113549	\N	\N	\N	\N	\N	\N	\N	\N
145	13	1	\N	475	33	50	425	50	475	\N	2021-08-24 09:21:28.27943	2021-08-24 10:51:28.098743	2021-08-24 13:48:11.64669	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-24 09:20:50.665862	2021-08-25 12:14:21.180102	\N	\N	\N	\N	\N	\N	\N	\N
194	7	11	\N	1135	35	99	1036	50	1086	\N	2021-08-25 12:06:21.149916	2021-08-25 12:07:58.586054	2021-08-25 12:08:00.123297	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 12:04:04.238037	2021-08-25 12:08:00.123319	\N	\N	\N	\N	\N	\N	\N	\N
193	7	1	\N	390	\N	\N	390	50	440	\N	2021-08-25 11:54:01.925849	\N	\N	\N	\N	\N	\N	10	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 11:53:50.696613	2021-08-25 12:12:36.75737	\N	\N	\N	\N	\N	\N	\N	\N
141	13	1	\N	1080	33	50	1030	50	1080	\N	2021-08-24 09:05:01.588241	\N	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-24 06:28:32.744935	2021-08-25 14:55:35.291455	\N	\N	\N	\N	\N	\N	\N	\N
195	7	1	\N	280	35	99	181	\N	181	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 12:04:53.570317	2021-08-25 12:05:01.97215	2021-08-25 12:05:18.199577	\N	\N	\N	\N	\N	\N	\N
386	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 09:12:01.642895	2021-09-14 09:12:01.662077	2021-09-14 09:12:04.905327	\N	\N	\N	\N	0	\N	1
434	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:51:47.690717	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:51:42.017077	2021-09-16 10:51:47.714154	\N	\N	\N	\N	\N	0	\N	1
421	13	1	\N	720	\N	\N	720	60	902.399999999999977	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 08:55:51.784382	2021-09-16 08:58:12.080682	2021-09-16 09:03:41.072979	\N	\N	\N	\N	122.400000000000006	\N	0
503	7	11	\N	55	\N	\N	55	\N	95	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-28 04:47:23.196083	2021-09-28 04:47:23.223256	2021-09-28 04:47:26.945034	\N	\N	\N	\N	40	\N	0
393	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 09:00:40.194869	2021-09-15 09:28:11.659208	2021-09-15 09:28:34.521123	\N	\N	\N	\N	0	\N	1
481	13	1	\N	385	\N	\N	385	40	490.449999999999989	\N	2021-09-23 10:50:39.438464	2021-09-23 11:36:24.336044	2021-09-23 11:36:37.624467	\N	2021-09-23 11:39:03.497757	2021-09-23 11:40:43.856895	2021-09-23 11:40:43.856919	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 10:50:32.70206	2021-09-23 11:40:43.856914	\N	\N	\N	\N	\N	65.4500000000000028	\N	0
425	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 09:08:48.850526	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 09:08:38.838764	2021-09-16 09:08:38.855904	\N	\N	\N	\N	\N	0	\N	1
396	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 09:46:44.100641	2021-09-15 09:46:44.119824	2021-09-15 09:48:27.096918	\N	\N	\N	\N	0	\N	1
438	13	1	\N	1440	\N	\N	1440	60	1744.79999999999995	\N	2021-09-16 11:34:48.138527	2021-09-21 10:18:10.547573	2021-09-21 10:18:17.777828	\N	2021-09-23 11:50:13.798282	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 11:13:40.605094	2021-09-23 11:50:13.7983	\N	\N	\N	\N	\N	244.800000000000011	\N	0
400	13	1	\N	75	\N	\N	75	60	135	\N	2021-09-15 20:10:18.947969	2021-09-15 20:11:31.074193	2021-09-15 20:19:55.970247	\N	2021-09-15 20:20:16.688982	2021-09-15 20:20:33.570094	2021-09-15 20:20:33.57012	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-15 15:28:39.763102	2021-09-15 20:20:33.570114	\N	\N	\N	\N	\N	0	\N	0
398	1	1	\N	4459	\N	\N	4459	\N	4459	\N	2021-09-16 04:48:23.216605	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 10:07:17.997086	2021-09-15 10:34:11.764154	\N	\N	\N	\N	\N	0	\N	1
391	1	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 13:50:14.95187	2021-09-14 14:10:41.013822	2021-09-14 14:11:27.73796	\N	\N	\N	\N	0	\N	1
429	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:20:55.214946	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:20:49.292346	2021-09-16 10:20:49.311495	\N	\N	\N	\N	\N	0	\N	1
401	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 05:46:35.292962	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 04:58:50.908931	2021-09-16 04:58:50.928861	\N	\N	\N	\N	\N	0	\N	1
467	9	11	\N	1060	41	25	1035	\N	1075	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 16:30:50.052434	2021-09-22 16:31:40.956328	2021-09-22 16:31:50.921545	\N	\N	\N	\N	40	\N	0
461	7	23	\N	7	\N	\N	7	50	57	\N	2021-09-22 04:58:02.957853	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 04:57:42.221147	2021-09-22 04:58:02.98732	\N	\N	\N	\N	\N	0	\N	0
405	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 05:56:13.537395	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 05:56:06.636088	2021-09-16 05:56:06.655089	\N	\N	\N	\N	\N	0	\N	1
447	13	11	\N	385	37	80	305	50	355	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-17 10:23:20.198241	2021-09-17 10:31:03.02598	2021-09-17 10:31:03.02598	\N	\N	\N	\N	0	\N	0
301	13	18	\N	200	37	80	120	50	170	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 13:14:54.445214	2021-09-16 10:57:53.375201	2021-09-16 10:58:18.896133	\N	\N	\N	\N	0	\N	0
450	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-21 09:41:59.858803	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-17 13:11:51.966563	2021-09-21 09:41:59.88282	\N	\N	\N	\N	\N	0	\N	1
410	13	1	\N	165	\N	\N	165	\N	193.050000000000011	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 06:58:41.001247	2021-09-16 07:03:26.561615	2021-09-16 07:03:26.561615	\N	\N	\N	\N	28.0500000000000007	\N	0
414	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 07:33:54.269545	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:33:34.922316	2021-09-16 07:33:34.939779	\N	\N	\N	\N	\N	0	\N	1
444	13	11	\N	150	37	80	70	\N	70	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 16:00:14.476804	2021-09-17 07:09:49.99652	2021-09-17 07:09:49.99652	\N	\N	\N	\N	0	\N	0
499	7	23	\N	9	\N	\N	9	\N	39	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-25 05:00:02.618066	2021-09-27 13:51:19.272614	2021-09-27 13:51:37.962071	\N	\N	\N	\N	30	\N	0
418	13	1	\N	180	37	80	100	60	177	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 07:54:36.217143	2021-09-16 08:06:10.031692	2021-09-16 08:06:10.031692	\N	\N	\N	\N	17	\N	0
484	7	11	\N	309	\N	\N	309	50	399	\N	\N	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 12:50:38.088666	2021-09-23 13:00:26.05707	2021-09-23 13:01:36.457414	\N	\N	\N	\N	40	\N	0
496	7	11	\N	300	37	80	220	50	310	\N	\N	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-24 07:37:28.751002	2021-09-24 07:39:16.571477	2021-09-24 07:39:23.682016	\N	\N	\N	\N	40	\N	0
487	13	1	\N	115	\N	\N	115	40	174.550000000000011	\N	2021-09-23 13:00:06.391546	2021-09-23 13:00:53.628165	2021-09-23 13:03:19.453093	\N	2021-09-23 13:04:14.434686	2021-09-23 13:04:55.965494	2021-09-23 13:04:55.965521	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 13:00:00.50909	2021-09-23 13:04:55.965515	\N	\N	\N	\N	\N	19.5500000000000007	\N	0
493	7	11	\N	217	\N	\N	217	50	307	\N	2021-09-24 07:26:55.259302	2021-09-24 07:27:25.419244	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-24 07:26:42.338462	2021-09-24 07:27:37.125089	\N	\N	\N	\N	\N	40	\N	0
478	7	11	\N	95	\N	\N	95	50	185	\N	2021-09-23 12:40:03.882904	2021-09-23 12:40:50.384972	2021-09-24 07:30:21.326541	\N	\N	\N	\N	40	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 07:06:31.399947	2021-09-24 07:30:21.326561	\N	\N	\N	\N	\N	40	\N	0
458	9	23	\N	3	\N	\N	3	50	53	\N	2021-09-20 17:36:45.777202	\N	\N	\N	\N	\N	\N	37	\N	\N	1	\N	\N	\N	\N	\N	2021-09-20 17:36:32.963432	2021-09-20 18:01:47.546192	\N	\N	\N	\N	\N	0	\N	0
490	13	1	\N	415	\N	\N	415	40	525.549999999999955	\N	2021-09-23 13:16:20.435784	2021-09-23 13:16:32.038092	2021-09-23 13:16:35.211348	\N	2021-09-23 13:16:43.092934	2021-09-24 09:06:03.018772	2021-09-24 09:06:03.0188	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 13:16:12.945345	2021-09-24 09:06:03.018794	\N	\N	\N	\N	\N	70.5499999999999972	\N	0
441	13	11	\N	110	\N	\N	110	\N	110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 15:57:24.060244	2021-09-16 15:58:21.251911	2021-09-16 15:58:21.251911	\N	\N	\N	\N	0	\N	0
148	6	1	\N	540	37	80	460	50	588.200000000000045	\N	\N	\N	\N	\N	\N	\N	\N	5	\N	\N	1	\N	\N	\N	\N	\N	2021-08-24 13:24:53.052509	2021-09-20 10:16:02.838249	2021-09-20 10:16:12.899257	\N	\N	\N	\N	78.2000000000000028	\N	\N
464	7	11	\N	525	\N	\N	525	\N	565	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 12:54:16.262471	2021-09-23 04:47:58.881745	2021-09-23 04:48:02.654684	\N	\N	\N	\N	40	\N	0
453	7	11	\N	1145	37	80	1065	50	1155	\N	2021-09-22 05:33:51.928914	2021-09-22 05:38:54.584894	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-18 11:26:10.218168	2021-09-23 07:05:23.644101	\N	\N	\N	\N	\N	40	\N	0
523	1	1	\N	140	\N	\N	140	\N	140	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 11:16:38.743536	2021-09-30 11:18:14.645342	2021-09-30 11:18:22.473624	\N	\N	\N	\N	0	\N	1
261	13	1	\N	360	\N	\N	360	50	410	\N	2021-08-31 07:14:12.260128	2021-09-23 09:29:23.019653	2021-09-23 09:29:26.30128	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:14:03.93483	2021-09-23 09:29:26.3013	\N	\N	\N	\N	\N	0	\N	\N
516	1	1	\N	1440	\N	\N	1440	\N	1440	\N	2021-09-30 11:16:13.709194	2021-09-30 11:16:13.709194	2021-09-30 11:16:13.709194	\N	2021-09-30 11:16:13.709194	2021-09-30 11:16:13.709194	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-29 10:00:53.970254	2021-09-30 11:16:13.731589	\N	\N	\N	\N	\N	0	\N	1
500	7	11	\N	803	\N	\N	803	\N	843	\N	2021-09-27 07:17:40.572052	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-25 05:55:51.288429	2021-09-27 07:17:40.615151	\N	\N	\N	\N	\N	40	\N	0
520	7	11	\N	650	\N	\N	650	50	740	\N	2021-09-30 08:28:28.924336	2021-09-30 08:28:57.420786	2021-09-30 08:29:24.890745	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 07:43:39.256242	2021-09-30 08:29:24.890765	\N	\N	\N	\N	\N	40	\N	0
236	7	11	\N	170	\N	99	170	50	220	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 04:27:51.986257	2021-08-26 05:36:16.573194	2021-08-26 05:36:42.018486	\N	\N	\N	\N	\N	\N	\N
199	7	11	\N	760	\N	\N	760	50	810	\N	2021-08-25 14:26:37.717842	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 14:19:01.839888	2021-08-25 14:26:36.297187	\N	\N	\N	\N	\N	\N	\N	\N
212	7	11	\N	250	\N	\N	250	50	300	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 18:17:39.085417	2021-08-25 18:17:45.124852	2021-08-25 18:56:59.409059	\N	\N	\N	\N	\N	\N	\N
214	9	11	\N	0	37	80	0	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 18:46:19.209352	2021-08-25 19:10:19.499128	2021-08-25 19:11:46.467693	\N	\N	\N	\N	\N	\N	\N
229	13	1	\N	500	35	99	401	50	451	\N	2021-08-25 22:12:31.416852	2021-08-25 22:13:12.407344	2021-08-25 22:13:23.530256	\N	\N	\N	\N	19	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 22:11:49.446756	2021-08-25 22:13:23.530279	\N	\N	\N	\N	\N	\N	\N	\N
242	7	11	\N	574	\N	\N	574	50	624	\N	2021-08-26 06:47:09.091178	2021-08-26 06:48:06.848322	2021-08-26 06:48:12.284582	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 06:46:39.172556	2021-08-26 06:48:12.284602	\N	\N	\N	\N	\N	\N	\N	\N
246	9	23	\N	1	\N	\N	1	50	51	\N	2021-08-26 15:02:34.954524	2021-09-02 16:08:25.778346	\N	\N	\N	\N	\N	16	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 15:02:19.202742	2021-09-02 16:08:25.778367	\N	\N	\N	\N	\N	\N	\N	\N
196	7	11	\N	444	35	99	345	50	395	\N	2021-08-25 12:23:51.132282	2021-08-25 12:24:12.915161	2021-08-25 12:24:13.773939	\N	\N	\N	\N	23	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 12:20:33.169179	2021-08-25 12:24:16.428645	\N	\N	\N	\N	\N	\N	\N	\N
221	7	11	\N	129	37	80	49	50	99	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:26:14.43422	2021-08-25 19:26:42.1178	2021-08-25 19:26:51.326262	\N	\N	\N	\N	\N	\N	\N
213	9	23	\N	5	\N	\N	5	50	55	\N	2021-08-25 19:15:55.551769	\N	\N	\N	\N	\N	\N	16	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 18:29:22.502095	2021-08-25 19:29:51.394693	\N	\N	\N	\N	\N	\N	\N	\N
217	7	11	\N	775	\N	\N	775	50	825	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:11:35.312084	2021-08-25 19:14:57.999982	2021-08-25 19:15:35.460531	\N	\N	\N	\N	\N	\N	\N
200	7	11	\N	437	\N	\N	437	50	487	\N	2021-08-25 15:12:15.973915	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:11:33.939377	2021-08-25 15:12:14.153779	\N	\N	\N	\N	\N	\N	\N	\N
227	13	1	\N	388	32	100	288	50	338	\N	2021-08-25 21:22:09.85305	2021-08-25 21:48:13.145399	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:18:55.169974	2021-08-25 21:48:13.145419	\N	\N	\N	\N	\N	\N	\N	\N
211	7	11	\N	625	\N	\N	625	50	675	\N	2021-08-25 18:17:26.412025	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 18:09:21.762234	2021-08-25 18:17:24.728521	\N	\N	\N	\N	\N	\N	\N	\N
216	7	11	\N	-340	\N	\N	-340	50	-290	\N	2021-08-25 19:09:38.323084	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:09:25.38892	2021-08-25 19:09:59.440133	\N	\N	\N	\N	\N	\N	\N	\N
471	7	18	\N	160	\N	\N	160	\N	160	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 17:12:15.375324	2021-09-30 05:38:36.213651	2021-10-01 13:05:28.516056	\N	\N	\N	\N	0	\N	0
474	9	11	\N	777	\N	\N	777	\N	817	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 19:37:09.78263	2021-10-05 19:32:15.469676	2021-10-05 19:32:19.089814	\N	\N	\N	\N	40	\N	0
509	13	1	\N	230	\N	\N	230	40	339.100000000000023	\N	2021-09-28 12:02:59.26152	2021-10-13 14:10:46.562846	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-28 12:02:53.323269	2021-10-13 14:10:46.562866	\N	\N	\N	\N	\N	69.0999999999999943	\N	0
506	13	1	\N	0	\N	\N	0	40	70	\N	2021-09-28 11:28:27.59136	\N	\N	\N	\N	\N	\N	31	\N	1	10	\N	\N	\N	\N	\N	2021-09-28 11:28:20.481814	2021-10-13 22:00:22.526669	\N	\N	\N	\N	\N	30	\N	0
225	13	1	\N	0	\N	\N	0	50	50	\N	\N	\N	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:15:37.41265	2021-08-25 21:17:06.061317	2021-08-25 21:17:39.907292	\N	\N	\N	\N	\N	\N	\N
223	13	1	\N	373	\N	\N	373	\N	373	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:10:47.668186	2021-08-25 21:14:32.630461	2021-08-25 21:14:36.751178	\N	\N	\N	\N	\N	\N	\N
198	4	1	\N	50	\N	\N	50	50	100	\N	2021-08-25 13:48:15.104185	2021-08-25 13:51:08.775144	2021-08-25 13:51:13.195133	\N	\N	\N	\N	14	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 13:47:40.287501	2021-08-25 13:51:29.119573	\N	\N	\N	\N	\N	\N	\N	\N
224	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:14:15.795917	2021-08-25 21:14:15.807753	2021-08-25 21:15:28.349398	\N	\N	\N	\N	\N	\N	\N
220	7	11	\N	145	\N	\N	145	50	195	\N	2021-08-25 19:20:18.015628	2021-08-25 22:10:03.435518	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:20:05.425035	2021-08-25 22:10:03.435541	\N	\N	\N	\N	\N	\N	\N	\N
208	7	11	\N	466	35	43.2000000000000028	422.800000000000011	50	472.800000000000011	\N	2021-08-25 18:04:51.843894	\N	\N	\N	\N	\N	\N	23	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 16:09:25.159116	2021-08-25 18:25:00.686086	\N	\N	\N	\N	\N	\N	\N	\N
204	9	11	\N	90	\N	\N	90	\N	90	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:17:45.082648	2021-08-25 16:05:59.811009	2021-08-25 18:27:21.900914	\N	\N	\N	\N	\N	\N	\N
201	7	1	\N	373	\N	\N	373	50	423	\N	2021-08-25 15:13:22.428534	\N	\N	\N	\N	\N	\N	23	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 15:13:05.821811	2021-08-25 15:14:13.336637	\N	\N	\N	\N	\N	\N	\N	\N
243	13	21	\N	530	\N	\N	530	50	580	\N	2021-08-26 07:16:47.05072	2021-08-26 07:17:12.839355	2021-08-26 07:17:30.637914	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 07:14:48.397431	2021-08-26 07:17:30.637932	\N	\N	\N	\N	\N	\N	\N	\N
206	7	11	\N	770	35	99	671	50	721	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:52:36.232522	2021-08-25 16:02:15.924405	2021-08-25 16:09:02.102751	\N	\N	\N	\N	\N	\N	\N
197	7	11	\N	1035	\N	\N	1035	50	1085	\N	2021-08-25 14:17:54.044332	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 12:55:39.621437	2021-08-25 14:16:29.683543	\N	\N	\N	\N	\N	\N	\N	\N
209	7	1	\N	1575	32	100	1475	50	1525	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 16:59:51.949423	2021-08-25 17:52:54.985234	2021-08-25 17:53:01.439037	\N	\N	\N	\N	\N	\N	\N
245	7	11	\N	0	\N	\N	0	50	50	\N	2021-08-26 14:37:39.066896	\N	\N	\N	\N	\N	\N	23	\N	\N	10	\N	\N	\N	\N	\N	2021-08-26 14:14:30.942308	2021-08-26 21:26:53.353993	\N	\N	\N	\N	\N	\N	\N	\N
207	9	23	\N	15	\N	\N	15	50	65	\N	2021-08-25 18:27:58.093476	2021-08-25 18:28:25.711576	2021-08-25 18:28:31.283547	\N	\N	\N	\N	16	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 16:05:53.205066	2021-08-25 18:28:31.283571	\N	\N	\N	\N	\N	\N	\N	\N
218	7	11	\N	65	\N	\N	65	50	115	\N	2021-08-25 19:16:09.255894	2021-08-25 19:17:37.315413	2021-08-25 19:18:07.998301	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:16:02.422164	2021-08-25 19:18:07.998323	\N	\N	\N	\N	\N	\N	\N	\N
247	9	1	\N	75	\N	\N	75	50	125	\N	2021-08-26 15:21:14.908481	\N	\N	\N	\N	\N	\N	16	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 15:19:23.733045	2021-08-26 15:20:56.98816	\N	\N	\N	\N	\N	\N	\N	\N
203	7	11	\N	0	35	99	0	50	50	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:17:13.263803	2021-08-25 15:47:07.071349	2021-08-25 15:52:24.915962	\N	\N	\N	\N	\N	\N	\N
202	9	11	\N	610	\N	\N	610	\N	610	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:16:51.952054	2021-08-25 15:17:06.90027	2021-08-25 15:17:14.806027	\N	\N	\N	\N	\N	\N	\N
222	13	21	\N	420	35	99	321	50	371	\N	2021-08-25 21:47:26.838081	2021-08-26 05:10:46.537354	2021-08-26 05:10:51.048709	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 19:57:44.01498	2021-08-26 05:10:54.32837	\N	\N	\N	\N	\N	\N	\N	\N
231	13	1	\N	278	35	99	179	50	229	\N	2021-08-25 22:16:20.365566	2021-08-25 22:16:36.763229	\N	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-25 22:16:07.381261	2021-08-25 22:16:54.325713	\N	\N	\N	\N	\N	\N	\N	\N
240	4	21	\N	475	37	80	395	50	445	\N	2021-08-30 15:19:19.755971	\N	\N	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 05:38:36.130319	2021-08-30 15:19:17.544108	\N	\N	\N	\N	\N	0	\N	\N
255	4	18	\N	80	\N	\N	80	\N	80	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-29 16:46:00.614356	2021-09-06 15:41:52.037978	2021-09-06 15:41:58.926441	\N	\N	\N	\N	0	\N	\N
215	7	11	\N	834	37	80	754	50	804	\N	2021-08-25 19:08:18.247067	2021-08-25 19:08:57.318714	2021-08-25 19:09:10.85692	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 18:57:43.83892	2021-08-25 19:09:10.856943	\N	\N	\N	\N	\N	\N	\N	\N
233	13	1	\N	540	\N	\N	540	50	590	\N	2021-08-26 02:52:45.668072	\N	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 02:36:23.896341	2021-08-26 02:52:42.239676	\N	\N	\N	\N	\N	\N	\N	\N
232	13	1	\N	540	\N	\N	540	\N	540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 02:36:07.407192	2021-08-26 02:36:12.562486	2021-08-26 02:36:17.913719	\N	\N	\N	\N	\N	\N	\N
230	13	1	\N	153	32	100	53	50	103	\N	2021-08-25 22:14:11.216833	\N	\N	\N	\N	\N	\N	19	\N	\N	10	\N	\N	\N	\N	\N	2021-08-25 22:13:39.677315	2021-08-25 22:14:38.218601	\N	\N	\N	\N	\N	\N	\N	\N
226	13	1	\N	663	\N	\N	663	\N	663	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:18:12.638452	2021-08-25 21:18:18.648873	2021-08-25 21:18:46.618339	\N	\N	\N	\N	\N	\N	\N
235	13	1	\N	3315	37	80	3235	50	3285	\N	2021-08-26 21:25:24.287521	\N	\N	\N	\N	\N	\N	19	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 03:53:01.284866	2021-08-26 21:25:01.742752	\N	\N	\N	\N	\N	\N	\N	\N
234	13	1	\N	1106	\N	\N	1106	\N	1106	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 02:53:03.07595	2021-08-26 02:57:27.037156	2021-08-26 03:52:56.204611	\N	\N	\N	\N	\N	\N	\N
248	9	1	\N	43	\N	\N	43	50	93	\N	\N	\N	\N	\N	\N	\N	\N	26	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 15:24:15.57688	2021-08-26 15:38:46.068949	\N	\N	\N	\N	\N	\N	\N	\N
238	7	11	\N	895	\N	\N	895	50	945	\N	2021-08-26 05:37:48.238581	2021-08-26 05:39:21.090272	2021-08-26 05:39:22.672384	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 05:37:16.155674	2021-08-26 05:39:22.672406	\N	\N	\N	\N	\N	\N	\N	\N
239	13	21	\N	615	\N	\N	615	50	665	\N	\N	\N	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 05:37:24.057254	2021-08-26 06:54:58.598379	2021-08-26 06:55:11.402589	\N	\N	\N	\N	\N	\N	\N
237	13	21	\N	2015	\N	\N	2015	50	2065	\N	2021-08-26 05:33:09.133784	2021-08-26 05:33:46.803587	2021-08-26 05:33:59.113677	\N	\N	\N	\N	22	\N	\N	11	\N	\N	\N	\N	\N	2021-08-26 05:32:02.373836	2021-08-26 07:06:30.378751	\N	\N	\N	\N	\N	\N	\N	\N
219	9	11	\N	122	\N	\N	122	\N	122	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 19:17:38.070207	2021-08-25 19:17:38.081966	2021-08-26 15:24:34.002947	\N	\N	\N	\N	\N	\N	\N
241	13	2	\N	75	\N	\N	75	\N	75	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 06:29:02.27144	2021-08-26 06:29:02.287619	2021-08-26 21:24:44.750049	\N	\N	\N	\N	\N	\N	\N
249	9	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 15:46:49.403003	2021-08-26 15:46:49.414738	\N	\N	\N	\N	\N	\N	\N	\N
250	13	11	\N	23000	\N	\N	23000	50	23050	\N	2021-08-26 21:28:42.116948	2021-08-26 21:28:53.146854	2021-08-26 21:29:08.519183	\N	\N	\N	\N	19	\N	\N	11	\N	\N	\N	\N	\N	2021-08-26 21:28:25.420561	2021-08-26 21:29:32.670174	\N	\N	\N	\N	\N	\N	\N	\N
251	4	1	\N	42483	32	100	42383	50	42433	\N	2021-08-29 16:35:56.394494	2021-08-30 15:20:04.663483	2021-08-30 15:20:06.694097	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-08-27 11:42:46.653153	2021-08-30 15:20:06.694119	\N	\N	\N	\N	\N	0	\N	\N
244	13	21	\N	990	\N	\N	990	50	1040	\N	\N	\N	\N	\N	\N	\N	\N	22	\N	\N	1	\N	\N	\N	\N	\N	2021-08-26 08:11:56.007045	2021-08-27 23:10:28.684497	2021-08-27 23:10:43.160281	\N	\N	\N	\N	0	\N	\N
228	13	23	\N	210	\N	\N	210	\N	210	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 21:19:27.58994	2021-08-25 21:20:25.814067	2021-08-31 09:55:53.697372	\N	\N	\N	\N	\N	\N	\N
253	7	23	\N	3	\N	\N	3	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-28 16:05:36.045	2021-08-28 16:05:36.060826	2021-08-31 07:12:54.690172	\N	\N	\N	\N	0	\N	\N
256	4	1	\N	745	\N	99	745	50	795	\N	\N	\N	\N	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-08-29 16:47:58.906788	2021-09-06 15:35:27.284952	2021-09-06 15:42:00.908065	\N	\N	\N	\N	0	\N	\N
254	7	18	\N	220	\N	\N	220	\N	220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-29 14:59:40.948882	2021-09-11 11:13:02.9672	2021-09-11 11:13:08.466075	\N	\N	\N	\N	0	\N	\N
205	4	11	\N	557	\N	\N	557	50	607	\N	\N	\N	\N	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 15:29:25.309203	2021-08-30 14:51:46.559506	2021-08-30 14:51:51.715232	\N	\N	\N	\N	0	\N	\N
252	7	11	\N	3092	37	80	3012	50	3062	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-27 15:20:47.073533	2021-08-31 06:42:33.774218	2021-08-31 07:12:45.39842	\N	\N	\N	\N	0	\N	\N
257	13	1	\N	223	\N	\N	223	\N	223	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 06:11:26.643399	2021-08-31 06:11:28.516856	2021-08-31 06:58:25.770558	\N	\N	\N	\N	0	\N	\N
285	13	1	\N	55	\N	\N	55	50	105	\N	2021-09-01 13:33:38.653427	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-01 13:33:32.082702	2021-09-01 13:33:36.55587	\N	\N	\N	\N	\N	0	\N	\N
273	13	11	\N	244	\N	\N	244	\N	244	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 10:03:03.964886	2021-08-31 10:03:04.684613	2021-08-31 10:03:36.770445	\N	\N	\N	\N	0	\N	\N
296	13	11	\N	150	\N	\N	150	50	200	\N	2021-09-09 08:35:00.641718	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:10:37.573188	2021-09-09 08:34:51.247044	\N	\N	\N	\N	\N	0	\N	0
210	7	1	\N	3015	35	99	2916	50	2966	\N	2021-08-31 07:42:46.699189	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-25 17:53:09.21883	2021-08-31 07:42:34.97842	\N	\N	\N	\N	\N	0	\N	\N
264	13	1	\N	180	\N	\N	180	50	230	\N	2021-08-31 07:23:15.83019	2021-09-23 10:21:51.712457	\N	\N	\N	\N	\N	31	\N	\N	11	\N	\N	\N	\N	\N	2021-08-31 07:22:59.322587	2021-09-23 10:21:57.296876	\N	\N	\N	\N	\N	0	\N	\N
263	7	11	\N	1065	37	80	985	\N	985	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:22:00.636165	2021-08-31 07:22:40.836235	2021-08-31 07:23:36.342149	\N	\N	\N	\N	0	\N	\N
294	13	11	\N	250	35	99	151	\N	151	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:04:24.394295	2021-09-07 12:06:28.436873	2021-09-07 12:06:37.033089	\N	\N	\N	\N	0	\N	0
287	13	11	\N	231000	35	99	230901	50	230951	\N	2021-09-02 08:04:07.334806	2021-09-02 09:15:51.279958	2021-09-02 09:15:53.278895	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-02 08:03:21.823555	2021-09-02 09:15:53.278916	\N	\N	\N	\N	\N	0	\N	\N
286	13	11	\N	1100	35	99	1001	50	1051	\N	2021-09-02 07:58:49.956255	2021-09-02 09:15:59.061793	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-02 07:39:18.342327	2021-09-02 09:15:59.061811	\N	\N	\N	\N	\N	0	\N	\N
291	13	1	\N	821	35	99	722	50	772	\N	2021-09-04 14:45:33.253506	2021-09-04 14:45:57.662548	2021-09-04 14:47:38.561452	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-04 14:45:20.085364	2021-09-04 14:47:38.561471	\N	\N	\N	\N	\N	0	\N	0
284	4	11	\N	610	37	80	530	50	580	\N	2021-09-01 17:35:11.08598	2021-09-02 09:16:03.713233	2021-09-02 09:16:04.776209	\N	\N	\N	\N	14	\N	\N	1	\N	\N	\N	\N	\N	2021-09-01 11:04:10.831467	2021-09-02 09:16:04.776229	\N	\N	\N	\N	\N	0	\N	\N
275	13	11	\N	1100	\N	\N	1100	50	1150	\N	2021-08-31 10:51:49.425778	2021-08-31 10:58:28.338112	\N	\N	\N	\N	\N	32	\N	\N	11	\N	\N	\N	\N	\N	2021-08-31 10:51:39.262084	2021-09-01 04:30:20.517993	\N	\N	\N	\N	\N	0	\N	\N
293	13	11	\N	2250	35	99	2151	50	2201	\N	2021-09-07 09:38:34.5766	2021-09-07 09:59:02.372235	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 09:38:22.595079	2021-09-07 09:59:02.372255	\N	\N	\N	\N	\N	0	\N	0
288	13	11	\N	2600	\N	\N	2600	50	2650	\N	2021-09-02 12:48:21.65631	2021-09-02 12:48:47.718961	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-02 12:48:11.554582	2021-09-02 12:48:47.718981	\N	\N	\N	\N	\N	0	\N	\N
258	13	11	\N	46660	\N	\N	46660	\N	46660	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 06:15:00.412442	2021-08-31 06:29:40.494164	2021-08-31 09:55:56.676163	\N	\N	\N	\N	0	\N	\N
290	7	1	\N	885	35	99	786	\N	786	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-04 14:37:04.41025	2021-09-09 07:02:11.234984	2021-09-09 07:02:33.414839	\N	\N	\N	\N	0	\N	0
259	13	1	\N	278	\N	\N	278	50	328	\N	2021-08-31 07:12:06.852364	2021-09-23 09:31:28.229539	\N	\N	\N	\N	\N	31	\N	\N	11	\N	\N	\N	\N	\N	2021-08-31 07:11:31.674166	2021-09-23 09:31:31.643715	\N	\N	\N	\N	\N	0	\N	\N
260	7	11	\N	314	\N	\N	314	50	364	\N	2021-08-31 07:14:01.865645	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:13:09.636843	2021-08-31 07:13:30.287791	\N	\N	\N	\N	\N	0	\N	\N
270	13	1	\N	5000	\N	\N	5000	50	5050	\N	2021-08-31 09:48:03.60453	2021-09-01 04:34:51.769983	2021-09-01 04:35:03.312015	\N	\N	\N	\N	31	\N	\N	11	\N	\N	\N	\N	\N	2021-08-31 09:47:48.68718	2021-09-01 04:35:26.139574	\N	\N	\N	\N	\N	0	\N	\N
277	9	23	\N	18	\N	\N	18	50	68	\N	\N	\N	\N	\N	\N	\N	\N	16	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 16:54:25.041417	2021-08-31 19:36:00.578502	2021-08-31 19:36:26.055252	\N	\N	\N	\N	0	\N	\N
267	13	1	\N	540	35	99	441	50	491	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 08:19:30.148579	2021-08-31 08:25:19.49982	2021-08-31 08:27:29.997062	\N	\N	\N	\N	0	\N	\N
289	6	11	\N	122	\N	\N	122	\N	122	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-02 14:58:14.165081	2021-09-02 14:58:14.182485	\N	\N	\N	\N	\N	0	\N	\N
269	13	18	\N	40	\N	\N	40	\N	40	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 08:33:58.558845	2021-08-31 08:33:59.689539	2021-08-31 09:43:53.656571	\N	\N	\N	\N	0	\N	\N
274	13	11	\N	4500	\N	\N	4500	50	4550	\N	2021-08-31 10:24:33.472326	2021-08-31 10:29:10.003213	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 10:24:23.199464	2021-08-31 10:29:10.003236	\N	\N	\N	\N	\N	0	\N	\N
262	13	1	\N	180	\N	\N	180	50	230	\N	2021-08-31 07:15:59.345708	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:15:41.002375	2021-09-23 07:45:59.841111	\N	\N	\N	\N	\N	0	\N	\N
268	13	1	\N	360	35	72	288	50	338	\N	2021-08-31 09:44:46.796444	\N	\N	\N	\N	\N	\N	31	\N	\N	10	\N	\N	\N	\N	\N	2021-08-31 08:27:37.291073	2021-08-31 10:43:33.813439	\N	\N	\N	\N	\N	0	\N	\N
310	13	21	\N	15	\N	\N	15	50	65	\N	2021-09-09 11:07:53.45127	\N	\N	\N	\N	\N	\N	33	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 10:59:40.384617	2021-09-09 11:07:23.881887	\N	\N	\N	\N	\N	0	\N	0
402	1	1	\N	235	\N	\N	235	\N	235	\N	2021-09-16 05:52:09.037246	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 05:51:47.919475	2021-09-16 05:51:49.187616	\N	\N	\N	\N	\N	0	\N	1
265	7	11	\N	640	\N	\N	640	50	690	\N	\N	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:23:47.635498	2021-08-31 08:16:32.964207	2021-08-31 09:47:38.736795	\N	\N	\N	\N	0	\N	\N
283	2	11	\N	2697	\N	\N	2697	50	2747	\N	\N	\N	\N	\N	\N	\N	\N	3	\N	\N	1	\N	\N	\N	\N	\N	2021-09-01 00:58:11.03369	2021-09-13 09:58:15.302533	\N	\N	\N	\N	\N	0	\N	\N
278	9	23	\N	9	\N	\N	9	\N	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 19:37:30.888506	2021-08-31 19:38:02.234258	2021-08-31 19:39:32.632594	\N	\N	\N	\N	0	\N	\N
266	13	1	\N	540	35	99	441	50	491	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 07:45:00.465945	2021-08-31 08:11:00.899904	2021-08-31 08:19:23.411605	\N	\N	\N	\N	0	\N	\N
302	2	21	\N	220	\N	\N	220	\N	220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 07:15:37.654917	2021-09-08 07:18:57.643698	\N	\N	\N	\N	\N	0	\N	0
279	9	23	\N	9	\N	\N	9	\N	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 19:40:25.073648	2021-08-31 19:40:55.310084	2021-08-31 19:41:05.863019	\N	\N	\N	\N	0	\N	\N
272	13	11	\N	1220	\N	\N	1220	50	1270	\N	2021-08-31 09:58:16.015934	2021-08-31 09:59:11.838808	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 09:57:46.338386	2021-08-31 09:59:11.838834	\N	\N	\N	\N	\N	0	\N	\N
406	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 05:57:29.821903	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 05:57:17.118508	2021-09-16 05:57:17.138928	\N	\N	\N	\N	\N	0	\N	1
299	13	21	\N	215	\N	\N	215	50	265	\N	2021-09-09 10:50:37.782465	\N	\N	\N	\N	\N	\N	33	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:54:35.330508	2021-09-09 10:50:29.447101	\N	\N	\N	\N	\N	0	\N	0
280	9	11	\N	550	\N	\N	550	\N	550	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 19:47:24.445766	2021-08-31 19:47:33.820478	2021-08-31 19:47:42.510967	\N	\N	\N	\N	0	\N	\N
276	13	11	\N	26206	\N	\N	26206	\N	26206	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 11:06:04.632018	2021-08-31 13:12:59.756566	2021-08-31 13:13:03.211706	\N	\N	\N	\N	0	\N	\N
307	4	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 15:34:19.892955	2021-09-08 15:34:19.913351	2021-09-08 15:34:24.293086	\N	\N	\N	\N	0	\N	0
281	9	23	\N	6	\N	\N	6	\N	6	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 19:47:51.809447	2021-08-31 20:01:57.517812	2021-08-31 20:02:14.273195	\N	\N	\N	\N	0	\N	\N
282	9	11	\N	110	\N	\N	110	\N	110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 20:00:13.288834	2021-08-31 20:00:13.303819	2021-09-13 15:57:56.47631	\N	\N	\N	\N	0	\N	\N
292	13	11	\N	1455	\N	\N	1455	\N	1455	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 07:24:23.598395	2021-09-07 09:36:43.934583	2021-09-07 09:36:53.785597	\N	\N	\N	\N	0	\N	0
305	4	18	\N	60	\N	\N	60	\N	60	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 15:31:07.401714	2021-09-08 15:31:12.368264	2021-09-08 15:31:19.042049	\N	\N	\N	\N	0	\N	0
295	13	11	\N	50	\N	\N	50	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:06:42.223143	2021-09-07 12:10:03.267221	2021-09-07 12:10:31.357244	\N	\N	\N	\N	0	\N	0
304	4	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 14:52:23.396567	2021-09-08 14:52:23.416244	2021-09-08 15:30:44.141752	\N	\N	\N	\N	0	\N	0
303	4	18	\N	40	\N	\N	40	\N	40	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 14:44:12.946824	2021-09-08 14:44:15.964559	2021-09-08 15:30:45.631803	\N	\N	\N	\N	0	\N	0
271	7	11	\N	694	\N	\N	694	\N	694	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-08-31 09:57:26.887906	2021-09-09 06:50:51.780687	2021-09-09 06:50:56.154983	\N	\N	\N	\N	0	\N	\N
306	4	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 15:32:49.60183	2021-09-08 15:32:49.618168	2021-09-08 15:32:57.212108	\N	\N	\N	\N	0	\N	0
309	1	1	\N	3502	\N	\N	3502	\N	3502	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 06:38:49.467838	2021-09-09 07:43:08.878839	2021-09-09 12:17:06.554077	\N	\N	\N	\N	0	\N	1
312	1	1	\N	235	\N	\N	235	\N	235	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 12:18:30.822281	2021-09-09 12:18:34.617036	2021-09-09 12:22:52.45603	\N	\N	\N	\N	0	\N	1
311	13	21	\N	200	\N	\N	200	50	250	\N	2021-09-09 11:13:55.310061	\N	\N	\N	\N	\N	\N	33	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 11:13:23.017555	2021-09-09 11:13:55.330424	\N	\N	\N	\N	\N	0	\N	0
313	1	1	\N	655	\N	\N	655	\N	655	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 12:26:02.140993	2021-09-09 12:27:10.630605	2021-09-09 12:27:27.114768	\N	\N	\N	\N	0	\N	1
298	1	1	\N	378	\N	\N	378	\N	378	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:36:40.985027	2021-09-10 02:24:30.967983	2021-09-10 02:25:02.292419	\N	\N	\N	\N	0	\N	1
314	14	11	\N	200	35	99	101	\N	101	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 12:42:29.279846	2021-09-13 07:06:54.666259	\N	\N	\N	\N	\N	0	\N	0
315	13	21	\N	265	\N	\N	265	\N	265	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 15:05:23.827803	2021-09-09 15:05:29.82805	2021-09-09 15:05:42.483609	\N	\N	\N	\N	0	\N	0
317	7	11	\N	955	\N	\N	955	\N	955	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 15:46:31.785898	2021-09-09 15:46:35.529638	2021-09-09 15:46:47.630748	\N	\N	\N	\N	0	\N	0
297	1	1	\N	3219	\N	\N	3219	\N	3219	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:36:40.982722	2021-09-09 06:15:59.732885	2021-09-10 01:52:51.858933	\N	\N	\N	\N	0	\N	1
350	1	1	\N	208	\N	\N	208	\N	208	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:23:33.106418	2021-09-13 06:33:43.969286	2021-09-13 06:33:54.739111	\N	\N	\N	\N	0	\N	1
318	7	23	\N	3	\N	\N	3	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 15:47:06.344334	2021-09-09 15:47:06.362104	2021-09-09 15:47:10.206365	\N	\N	\N	\N	0	\N	0
328	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 07:28:05.728895	2021-09-10 07:28:07.01806	2021-09-10 07:34:16.874087	\N	\N	\N	\N	0	\N	1
347	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:13:08.314225	2021-09-13 06:13:08.332004	2021-09-13 06:13:12.563531	\N	\N	\N	\N	0	\N	1
341	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:29:37.533847	2021-09-12 02:29:40.800143	2021-09-12 02:31:15.808489	\N	\N	\N	\N	0	\N	1
319	7	11	\N	177	\N	\N	177	\N	177	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 15:47:23.445903	2021-09-09 15:47:25.021211	2021-09-09 15:47:32.734528	\N	\N	\N	\N	0	\N	0
329	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 07:34:53.913052	2021-09-10 07:34:53.930323	2021-09-10 07:34:58.875081	\N	\N	\N	\N	0	\N	1
320	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 02:26:39.249162	2021-09-10 02:26:39.267191	2021-09-10 02:27:22.575276	\N	\N	\N	\N	0	\N	1
321	1	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 02:29:35.59244	2021-09-10 02:29:35.612261	2021-09-10 02:29:41.611591	\N	\N	\N	\N	0	\N	1
330	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 07:40:32.76137	2021-09-10 07:40:32.778295	2021-09-10 07:40:36.720125	\N	\N	\N	\N	0	\N	1
322	1	1	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 02:31:45.836487	2021-09-10 02:31:45.856614	2021-09-10 02:31:54.128775	\N	\N	\N	\N	0	\N	1
342	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:33:34.426373	2021-09-12 02:33:34.444737	2021-09-12 02:33:41.820393	\N	\N	\N	\N	0	\N	1
323	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 02:35:18.391723	2021-09-10 02:35:18.409661	2021-09-10 02:35:28.967633	\N	\N	\N	\N	0	\N	1
331	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 07:41:25.746509	2021-09-10 07:41:25.763689	2021-09-10 07:41:29.720163	\N	\N	\N	\N	0	\N	1
365	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 15:07:38.73498	2021-09-13 15:07:38.752684	2021-09-13 15:13:47.91677	\N	\N	\N	\N	0	\N	1
348	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:14:45.481156	2021-09-13 06:14:45.49747	2021-09-13 06:14:52.261186	\N	\N	\N	\N	0	\N	1
332	7	23	\N	3	\N	\N	3	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 15:24:57.672418	2021-09-10 15:24:57.690842	2021-09-10 15:25:31.905245	\N	\N	\N	\N	0	\N	0
333	7	11	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 15:25:27.135559	2021-09-10 15:25:27.153317	2021-09-10 15:25:33.51514	\N	\N	\N	\N	0	\N	0
324	1	1	\N	433	\N	\N	433	\N	433	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 02:38:34.058849	2021-09-10 02:40:34.469725	2021-09-10 03:05:07.78457	\N	\N	\N	\N	0	\N	1
394	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 09:33:38.052665	2021-09-15 09:35:08.580099	2021-09-15 09:37:13.252285	\N	\N	\N	\N	0	\N	1
325	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 03:05:38.78327	2021-09-10 03:05:38.800726	2021-09-10 03:06:11.808509	\N	\N	\N	\N	0	\N	1
334	7	11	\N	450	\N	\N	450	\N	450	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 15:25:55.429964	2021-09-10 15:25:55.446574	2021-09-10 15:26:00.672357	\N	\N	\N	\N	0	\N	0
363	1	1	\N	558	\N	\N	558	\N	558	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 14:44:22.515895	2021-09-13 14:48:44.006403	2021-09-13 14:48:53.037179	\N	\N	\N	\N	0	\N	1
308	4	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-08 15:36:17.117658	2021-09-08 15:36:17.137967	2021-10-07 13:38:08.073013	\N	\N	\N	\N	0	\N	0
343	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:38:02.71378	2021-09-12 02:38:07.539605	2021-09-12 02:38:15.805671	\N	\N	\N	\N	0	\N	1
336	7	1	\N	145	\N	\N	145	\N	145	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 17:12:25.017477	2021-09-10 17:12:34.832881	2021-09-11 11:13:09.890785	\N	\N	\N	\N	0	\N	0
326	1	1	\N	378	\N	\N	378	\N	378	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 06:32:05.130327	2021-09-10 06:38:04.697474	2021-09-10 06:38:27.988118	\N	\N	\N	\N	0	\N	1
352	1	1	\N	575	\N	\N	575	\N	575	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 09:05:35.64673	2021-09-13 09:15:53.688701	2021-09-13 09:21:49.775048	\N	\N	\N	\N	0	\N	1
337	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 01:46:00.521328	2021-09-12 01:46:00.540503	2021-09-12 01:46:10.082898	\N	\N	\N	\N	0	\N	1
359	1	1	\N	415	\N	\N	415	\N	415	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 11:27:19.247105	2021-09-13 11:28:05.521914	2021-09-13 11:39:47.440382	\N	\N	\N	\N	0	\N	1
327	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-10 06:42:24.003644	2021-09-10 06:42:24.976307	2021-09-10 06:56:08.77819	\N	\N	\N	\N	0	\N	1
338	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 01:58:49.773149	2021-09-12 01:58:49.791948	2021-09-12 01:59:03.724083	\N	\N	\N	\N	0	\N	1
353	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 09:22:12.349075	2021-09-13 09:22:12.365892	2021-09-13 09:22:13.020714	\N	\N	\N	\N	0	\N	1
344	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:55:43.074598	2021-09-12 02:55:46.391357	2021-09-12 02:56:16.735206	\N	\N	\N	\N	0	\N	1
351	1	1	\N	2010	\N	\N	2010	\N	2010	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:34:08.138291	2021-09-13 06:56:57.269157	2021-09-13 09:04:51.022279	\N	\N	\N	\N	0	\N	1
339	1	1	\N	323	\N	\N	323	\N	323	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:07:16.845164	2021-09-12 02:20:03.220854	2021-09-12 02:25:58.029188	\N	\N	\N	\N	0	\N	1
360	13	11	\N	50	35	99	0	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 13:44:00.479431	2021-09-13 13:54:16.22947	2021-09-13 13:54:39.60435	\N	\N	\N	\N	0	\N	0
349	1	1	\N	225	\N	\N	225	\N	225	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:17:34.056137	2021-09-13 06:19:22.560965	2021-09-13 06:19:39.475716	\N	\N	\N	\N	0	\N	1
340	1	1	\N	170	\N	\N	170	\N	170	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:26:15.356342	2021-09-12 02:26:23.531928	2021-09-12 02:26:58.598809	\N	\N	\N	\N	0	\N	1
354	1	1	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 09:22:20.36972	2021-09-13 09:22:20.387291	2021-09-13 09:22:20.885052	\N	\N	\N	\N	0	\N	1
345	1	1	\N	170	\N	\N	170	\N	170	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-12 02:56:33.944184	2021-09-13 06:09:49.101414	2021-09-13 06:10:08.219859	\N	\N	\N	\N	0	\N	1
361	1	1	\N	313	\N	\N	313	\N	313	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 13:47:43.842488	2021-09-13 14:09:01.759947	2021-09-13 14:43:14.042201	\N	\N	\N	\N	0	\N	1
346	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 06:12:10.305302	2021-09-13 06:12:10.323654	2021-09-13 06:12:17.343118	\N	\N	\N	\N	0	\N	1
357	1	1	\N	208	\N	\N	208	\N	208	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 10:54:47.523767	2021-09-13 11:05:10.73847	2021-09-13 11:05:16.093365	\N	\N	\N	\N	0	\N	1
355	1	1	\N	0	\N	\N	0	\N	0	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 09:22:26.003192	2021-09-13 09:22:26.566051	2021-09-13 09:22:26.544105	\N	\N	\N	\N	0	\N	1
369	9	23	\N	9	\N	\N	9	\N	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 16:06:46.95364	2021-09-20 17:33:08.832347	2021-09-20 17:33:18.015782	\N	\N	\N	\N	0	\N	0
367	7	18	\N	600	\N	99	600	50	650	\N	2021-09-13 16:25:41.906634	\N	\N	\N	\N	\N	\N	23	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 15:43:01.838806	2021-09-13 16:25:29.774192	\N	\N	\N	\N	\N	0	\N	0
356	1	1	\N	1613	\N	\N	1613	\N	1613	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 09:26:19.181176	2021-09-13 10:24:51.388608	2021-09-13 10:51:41.852587	\N	\N	\N	\N	0	\N	1
358	1	1	\N	235	\N	\N	235	\N	235	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 11:18:52.86157	2021-09-13 11:18:55.166375	2021-09-13 11:24:18.608787	\N	\N	\N	\N	0	\N	1
364	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 14:57:07.044837	2021-09-13 15:01:47.298471	2021-09-13 15:02:06.646652	\N	\N	\N	\N	0	\N	1
366	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 15:26:15.783143	2021-09-13 15:26:24.808912	2021-09-13 15:30:00.114425	\N	\N	\N	\N	0	\N	1
370	7	1	\N	2955	\N	\N	2955	50	3507.34999999999991	\N	\N	\N	\N	\N	\N	\N	\N	36	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 16:33:13.731594	2021-09-20 04:37:50.369027	2021-09-22 04:32:56.648428	\N	\N	\N	\N	502.350000000000023	\N	0
368	1	1	\N	405	\N	\N	405	\N	405	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 15:56:54.278105	2021-09-14 02:58:14.819058	2021-09-14 03:00:45.722456	\N	\N	\N	\N	0	\N	1
362	13	11	\N	110	35	44	66	50	116	\N	2021-09-13 18:28:43.053142	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 13:54:44.605452	2021-09-13 18:27:53.964098	\N	\N	\N	\N	\N	0	\N	0
373	1	1	\N	235	\N	\N	235	\N	235	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 04:39:05.474622	2021-09-14 04:43:06.430653	2021-09-14 04:45:13.374332	\N	\N	\N	\N	0	\N	1
372	1	1	\N	1000	\N	\N	1000	\N	1000	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 03:11:45.824646	2021-09-14 03:14:48.247906	2021-09-14 04:36:05.287075	\N	\N	\N	\N	0	\N	1
374	1	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 04:57:28.536043	2021-09-14 04:57:28.554833	2021-09-14 04:57:36.471953	\N	\N	\N	\N	0	\N	1
375	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 04:57:48.729349	2021-09-14 04:57:48.745639	2021-09-14 05:02:25.90615	\N	\N	\N	\N	0	\N	1
376	1	1	\N	290	\N	\N	290	\N	290	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:03:40.233462	2021-09-14 05:04:43.022706	2021-09-14 05:25:42.830307	\N	\N	\N	\N	0	\N	1
377	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:31:49.549617	2021-09-14 05:32:08.50396	2021-09-14 05:32:11.826367	\N	\N	\N	\N	0	\N	1
378	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:34:04.918439	2021-09-14 05:34:04.938238	2021-09-14 05:34:09.847687	\N	\N	\N	\N	0	\N	1
379	1	1	\N	55	\N	\N	55	\N	55	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:34:19.815655	2021-09-14 05:35:51.620305	2021-09-14 05:35:55.777861	\N	\N	\N	\N	0	\N	1
335	7	11	\N	1311	\N	99	1311	50	1361	\N	2021-09-14 06:09:26.173837	\N	\N	\N	\N	\N	\N	35	\N	\N	10	\N	\N	\N	\N	\N	2021-09-10 15:38:30.876846	2021-09-22 05:33:00.309357	\N	\N	\N	\N	\N	0	\N	0
491	1	1	\N	576	\N	\N	576	\N	576	\N	2021-09-28 12:03:45.441337	2021-09-28 12:03:45.441337	2021-09-28 12:03:45.441337	\N	2021-09-28 12:03:45.441337	2021-09-28 12:03:45.441337	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 15:29:13.272503	2021-09-28 12:03:45.487741	\N	\N	\N	\N	\N	0	\N	1
403	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 05:53:05.169564	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 05:52:38.871654	2021-09-16 05:52:38.891404	\N	\N	\N	\N	\N	0	\N	1
439	13	11	\N	244	37	80	164	50	214	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 13:34:28.892215	2021-09-16 15:53:55.731021	2021-09-16 15:53:55.731021	\N	\N	\N	\N	0	\N	0
407	7	23	\N	3	\N	\N	3	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 06:02:50.751661	2021-09-16 06:02:50.771767	2021-09-16 06:02:59.391126	\N	\N	\N	\N	0	\N	0
380	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:35:58.286862	2021-09-14 05:39:01.229315	2021-09-14 05:39:04.252352	\N	\N	\N	\N	0	\N	1
494	5	11	\N	45	\N	\N	45	\N	45	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-24 07:31:00.381538	2021-09-24 07:31:31.376921	2021-09-24 07:31:31.376921	\N	\N	\N	\N	0	\N	1
477	7	23	\N	9	\N	\N	9	\N	39	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 04:58:28.434574	2021-09-23 04:58:38.679626	2021-09-23 04:58:38.679626	\N	\N	\N	\N	30	\N	0
387	13	11	\N	55	\N	\N	55	50	105	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 09:13:36.081465	2021-09-16 11:31:29.748372	2021-09-16 11:31:48.315476	\N	\N	\N	\N	0	\N	0
419	13	1	\N	720	37	80	640	60	808.799999999999955	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 08:06:21.351211	2021-09-16 08:43:31.206552	2021-09-16 08:55:46.971837	\N	\N	\N	\N	108.799999999999997	\N	0
381	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:39:06.578151	2021-09-14 05:47:41.573932	2021-09-14 05:48:00.491777	\N	\N	\N	\N	0	\N	1
456	9	11	\N	450	41	25	425	50	515	\N	\N	\N	\N	\N	\N	\N	\N	37	\N	\N	1	\N	\N	\N	\N	\N	2021-09-20 16:47:30.453305	2021-09-22 16:30:03.618527	2021-09-22 16:30:03.618527	\N	\N	\N	\N	40	\N	0
300	13	1	\N	2005	35	99	1906	50	1956	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-07 12:54:59.477212	2021-09-15 14:47:15.472613	2021-09-15 14:47:22.004988	\N	\N	\N	\N	0	\N	0
430	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:24:12.451923	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:23:03.624628	2021-09-16 10:23:03.645651	\N	\N	\N	\N	\N	0	\N	1
465	9	23	\N	3	\N	\N	3	\N	3	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 16:07:32.220546	2021-09-22 16:07:32.239841	2021-09-22 16:30:29.137862	\N	\N	\N	\N	0	\N	0
411	13	1	\N	360	35	99	261	\N	305.370000000000005	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:03:35.465848	2021-09-16 07:13:51.871947	2021-09-16 07:22:34.248639	\N	\N	\N	\N	44.3699999999999974	\N	0
388	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 10:02:40.357835	2021-09-14 10:18:35.263934	2021-09-14 10:30:08.342637	\N	\N	\N	\N	0	\N	1
442	13	11	\N	150	\N	\N	150	\N	150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 15:58:41.891633	2021-09-16 15:58:52.366057	2021-09-16 15:58:52.366057	\N	\N	\N	\N	0	\N	0
517	13	1	\N	460	\N	\N	460	50	618.200000000000045	\N	2021-09-30 06:01:26.102401	2021-09-30 09:53:44.239109	2021-09-30 09:53:47.217286	\N	2021-09-30 09:53:50.094844	2021-09-30 09:53:53.198706	2021-09-30 09:53:53.198739	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-30 06:01:13.686887	2021-09-30 09:53:53.198733	\N	\N	\N	\N	\N	108.200000000000003	\N	0
415	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 07:38:04.5694	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:37:59.526882	2021-09-16 07:37:59.54357	\N	\N	\N	\N	\N	0	\N	1
462	13	1	\N	855	43	50	805	40	981.850000000000023	\N	2021-09-23 10:34:06.245876	2021-09-23 10:34:26.577997	2021-09-23 10:35:01.222034	\N	2021-09-23 11:27:42.245208	2021-09-23 11:27:53.47574	2021-09-23 11:27:53.475767	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-22 09:01:12.179313	2021-09-23 11:27:53.475761	\N	\N	\N	\N	\N	136.849999999999994	\N	0
479	13	1	\N	385	\N	\N	385	40	490.449999999999989	\N	2021-09-23 10:48:29.09031	2021-09-23 10:48:55.148572	2021-09-23 10:49:06.428252	\N	2021-09-23 11:59:53.882276	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 10:48:14.620024	2021-09-23 11:59:53.882296	\N	\N	\N	\N	\N	65.4500000000000028	\N	0
416	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 07:42:06.258617	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:42:01.279395	2021-09-16 07:42:01.298032	\N	\N	\N	\N	\N	0	\N	1
501	7	11	\N	313	\N	\N	313	50	403	\N	2021-09-27 16:32:16.253137	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-27 09:57:00.591239	2021-09-27 16:32:16.300948	\N	\N	\N	\N	\N	40	\N	0
382	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 05:48:06.237108	2021-09-14 06:08:57.190029	2021-09-14 06:12:15.705951	\N	\N	\N	\N	0	\N	1
412	13	1	\N	30	\N	\N	30	60	95.0999999999999943	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 07:22:39.334399	2021-09-16 07:53:17.744224	2021-09-16 07:54:31.31668	\N	\N	\N	\N	5.09999999999999964	\N	0
422	13	1	\N	780	37	80	700	60	760	\N	2021-09-16 10:07:34.850268	2021-09-22 09:24:58.649979	2021-09-22 09:25:32.869735	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-16 09:03:45.779254	2021-09-22 09:25:32.869757	\N	\N	\N	\N	\N	0	\N	0
424	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 09:06:48.961334	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 09:06:36.008521	2021-09-16 09:06:36.02541	\N	\N	\N	\N	\N	0	\N	1
432	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:45:30.066477	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:45:20.682534	2021-09-16 10:45:30.099848	\N	\N	\N	\N	\N	0	\N	1
395	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 09:37:46.598539	2021-09-15 09:46:30.339557	2021-09-15 09:46:36.661901	\N	\N	\N	\N	0	\N	1
435	13	1	\N	235	\N	\N	235	\N	274.949999999999989	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:58:24.355792	2021-09-16 10:58:27.866075	2021-09-16 10:58:41.792214	\N	\N	\N	\N	39.9500000000000028	\N	0
408	7	11	\N	1054	37	80	974	50	1024	\N	\N	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 06:05:39.726316	2021-09-18 06:30:50.603287	2021-09-18 06:30:59.277853	\N	\N	\N	\N	0	\N	0
426	1	1	\N	935	\N	\N	935	\N	935	\N	2021-09-16 10:03:44.850757	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:01:24.254045	2021-09-16 10:01:39.63636	\N	\N	\N	\N	\N	0	\N	1
469	7	1	\N	975	37	80	895	40	1087.15000000000009	\N	2021-09-27 09:51:09.842321	2021-09-28 11:39:53.262364	2021-09-28 11:39:57.54746	\N	2021-09-28 11:40:00.540463	2021-09-28 11:40:03.938246	2021-09-28 11:40:03.938278	36	\N	1	1	\N	\N	\N	\N	\N	2021-09-22 16:36:37.695574	2021-09-28 11:40:03.938271	\N	\N	\N	\N	\N	152.150000000000006	\N	0
485	13	1	\N	110	\N	\N	110	40	168.699999999999989	\N	2021-09-23 12:51:13.639367	2021-09-23 12:51:28.988073	2021-09-23 12:51:46.434315	\N	2021-09-23 12:51:54.590415	2021-09-23 12:59:46.138845	2021-09-23 12:59:46.138869	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 12:51:06.543325	2021-09-23 12:59:46.138864	\N	\N	\N	\N	\N	18.6999999999999993	\N	0
472	9	21	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 19:26:44.611111	2021-09-22 19:26:49.794553	\N	\N	\N	\N	\N	0	\N	0
451	7	11	\N	252	37	80	172	50	222	\N	2021-09-18 11:16:45.034085	2021-09-21 16:28:23.940516	2021-09-21 16:28:26.706066	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-18 10:44:46.631541	2021-09-21 16:28:32.575324	\N	\N	\N	\N	\N	0	\N	0
482	7	11	\N	50	\N	\N	50	50	140	\N	\N	\N	\N	\N	\N	\N	\N	43	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 12:43:47.319002	2021-09-23 12:50:23.897956	2021-09-23 12:50:23.897956	\N	\N	\N	\N	40	\N	0
445	7	18	\N	340	37	80	260	\N	260	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-17 02:46:30.058081	2021-09-22 04:32:52.692168	2021-09-22 04:32:57.888703	\N	\N	\N	\N	0	\N	0
475	7	11	\N	55	\N	\N	55	\N	95	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 04:48:13.403815	2021-09-23 04:48:18.355049	2021-09-23 04:48:18.355049	\N	\N	\N	\N	40	\N	0
488	7	11	\N	964	\N	25	964	50	1054	\N	2021-09-24 07:18:41.762486	2021-09-24 07:18:56.573016	2021-09-24 07:19:05.730198	\N	\N	\N	\N	40	\N	\N	11	\N	\N	\N	\N	\N	2021-09-23 13:06:02.265287	2021-09-24 07:19:17.54221	\N	\N	\N	\N	\N	40	\N	0
459	1	1	\N	295	\N	\N	295	\N	295	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-21 10:26:09.622865	2021-09-23 15:27:15.976506	2021-09-23 15:27:19.352006	\N	\N	\N	\N	0	\N	1
497	13	1	\N	1600	\N	\N	1600	40	1912	\N	2021-09-24 07:48:41.811016	2021-09-24 07:48:56.808044	\N	\N	\N	\N	\N	31	\N	1	11	\N	\N	\N	\N	\N	2021-09-24 07:48:31.543057	2021-09-24 07:48:59.884661	\N	\N	\N	\N	\N	272	\N	0
518	13	1	\N	230	\N	\N	230	50	349.100000000000023	\N	2021-09-30 06:08:59.837555	\N	\N	\N	\N	\N	\N	31	\N	1	10	\N	\N	\N	\N	\N	2021-09-30 06:08:31.836143	2021-09-30 07:35:11.262301	\N	\N	\N	\N	\N	69.0999999999999943	\N	0
404	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 05:54:38.649966	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 05:54:32.300114	2021-09-16 05:54:32.323373	\N	\N	\N	\N	\N	0	\N	1
383	7	11	\N	23370	\N	\N	23370	\N	23370	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 06:11:58.539605	2021-09-14 15:33:25.225572	2021-09-16 06:05:25.40664	\N	\N	\N	\N	0	\N	0
492	7	11	\N	55	\N	\N	55	50	145	\N	2021-09-24 07:21:22.049338	2021-09-24 07:21:35.955665	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-24 07:21:15.174553	2021-09-24 07:21:37.80441	\N	\N	\N	\N	\N	40	\N	0
437	13	1	\N	305	\N	\N	305	\N	356.850000000000023	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 11:00:55.393538	2021-09-16 11:13:20.766075	2021-09-16 11:13:35.050992	\N	\N	\N	\N	51.8500000000000014	\N	0
409	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 06:41:09.187973	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 06:40:59.135596	2021-09-16 06:40:59.154466	\N	\N	\N	\N	\N	0	\N	1
397	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 09:57:14.442453	2021-09-15 10:05:37.946926	2021-09-15 10:05:37.946926	\N	\N	\N	\N	0	\N	1
511	7	11	\N	4050	\N	\N	4050	\N	4090	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-29 05:42:31.066339	2021-09-29 05:42:41.250791	2021-09-29 07:25:30.41664	\N	\N	\N	\N	40	\N	0
384	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 06:23:21.884811	2021-09-14 06:23:42.066516	2021-09-14 06:23:47.953398	\N	\N	\N	\N	0	\N	1
413	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 07:29:24.848202	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:29:12.887052	2021-09-16 07:29:12.903824	\N	\N	\N	\N	\N	0	\N	1
498	2	1	\N	20	\N	\N	20	40	63.3999999999999986	\N	2021-09-24 09:09:59.407183	2021-09-24 09:11:06.740993	2021-09-24 09:11:09.791066	\N	\N	\N	\N	44	\N	1	11	\N	\N	\N	\N	\N	2021-09-24 09:09:51.838845	2021-09-24 09:11:12.674975	\N	\N	\N	\N	\N	3.39999999999999991	\N	0
466	7	1	\N	280	\N	\N	280	\N	327.600000000000023	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 16:24:03.086227	2021-09-22 16:24:19.34273	2021-09-22 16:25:06.21578	\N	\N	\N	\N	47.6000000000000014	\N	0
417	1	1	\N	55	\N	\N	55	\N	55	\N	2021-09-16 07:47:45.940317	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 07:47:36.709923	2021-09-16 07:47:36.727998	\N	\N	\N	\N	\N	0	\N	1
483	2	1	\N	465	\N	\N	465	40	584.049999999999955	\N	2021-09-24 09:08:38.710029	2021-09-24 09:09:15.444299	\N	\N	\N	\N	\N	44	\N	1	11	\N	\N	\N	\N	\N	2021-09-23 12:50:11.476504	2021-09-24 09:09:23.790902	\N	\N	\N	\N	\N	79.0499999999999972	\N	0
420	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 08:48:43.403709	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 08:48:30.511198	2021-09-16 08:48:30.528047	\N	\N	\N	\N	\N	0	\N	1
423	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 09:06:00.830824	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 09:05:54.988375	2021-09-16 09:05:55.005285	\N	\N	\N	\N	\N	0	\N	1
371	13	11	\N	0	\N	\N	0	50	50	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-13 18:34:42.080574	2021-09-14 09:13:10.788723	2021-09-14 09:13:31.375687	\N	\N	\N	\N	0	\N	0
452	7	11	\N	464	\N	\N	464	50	514	\N	2021-09-18 11:25:20.433088	2021-09-22 05:32:20.386224	2021-09-22 05:32:25.128538	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-18 11:20:05.389169	2021-09-22 05:32:37.130139	\N	\N	\N	\N	\N	0	\N	0
385	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 06:25:33.994373	2021-09-14 09:11:04.529671	2021-09-14 09:11:11.12485	\N	\N	\N	\N	0	\N	1
489	13	1	\N	55	\N	\N	55	40	104.349999999999994	\N	2021-09-23 13:11:04.909287	2021-09-23 13:11:16.219896	2021-09-23 13:11:23.52987	\N	2021-09-23 13:11:26.450766	2021-09-23 13:13:01.54488	2021-09-23 13:13:01.544907	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 13:10:58.217239	2021-09-23 13:13:01.544901	\N	\N	\N	\N	\N	9.34999999999999964	\N	0
427	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:04:40.606519	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:04:30.165154	2021-09-16 10:04:30.185237	\N	\N	\N	\N	\N	0	\N	1
399	13	1	\N	1135	35	99	1036	50	1086	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-15 14:47:29.146713	2021-09-15 15:28:33.7617	2021-09-15 15:28:33.7617	\N	\N	\N	\N	0	\N	0
436	13	18	\N	180	37	80	100	50	150	\N	2021-09-21 13:52:15.237105	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:58:46.082573	2021-09-21 13:52:15.265242	\N	\N	\N	\N	\N	0	\N	0
440	13	11	\N	110	\N	\N	110	\N	110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 15:56:21.863484	2021-09-16 15:56:31.750216	2021-09-16 15:56:31.750216	\N	\N	\N	\N	0	\N	0
428	1	1	\N	180	\N	\N	180	\N	180	\N	2021-09-16 10:10:21.176935	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:07:32.054266	2021-09-16 10:07:32.070698	\N	\N	\N	\N	\N	0	\N	1
389	1	1	\N	180	\N	\N	180	\N	180	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 10:41:09.10064	2021-09-14 10:41:37.377797	2021-09-14 10:43:42.279369	\N	\N	\N	\N	0	\N	1
468	9	11	\N	1000	\N	\N	1000	50	1090	\N	\N	\N	\N	\N	\N	\N	\N	37	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 16:32:51.584969	2021-09-22 16:56:37.504886	2021-09-22 16:56:45.163518	\N	\N	\N	\N	40	\N	0
446	13	11	\N	110	37	80	30	50	80	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-09-17 07:10:09.787998	2021-09-17 10:23:04.90139	2021-09-17 10:23:15.481375	\N	\N	\N	\N	0	\N	0
443	13	11	\N	110	\N	\N	110	\N	110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 15:59:57.952367	2021-09-16 16:00:07.746423	2021-09-16 16:00:07.746423	\N	\N	\N	\N	0	\N	0
390	1	1	\N	350	\N	\N	350	\N	350	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-14 10:45:16.496959	2021-09-14 10:52:01.680521	2021-09-14 13:50:07.514018	\N	\N	\N	\N	0	\N	1
431	1	1	\N	350	\N	\N	350	\N	350	\N	2021-09-16 10:42:11.0897	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:38:38.795297	2021-09-16 10:42:11.132401	\N	\N	\N	\N	\N	0	\N	1
470	9	11	\N	780	\N	\N	780	50	870	\N	\N	\N	\N	\N	\N	\N	\N	37	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 16:57:58.449048	2021-09-22 19:36:32.499785	2021-09-22 19:36:55.322004	\N	\N	\N	\N	40	\N	0
448	13	11	\N	550	\N	\N	550	50	640	\N	\N	\N	\N	\N	\N	\N	\N	39	\N	\N	1	\N	\N	\N	\N	\N	2021-09-17 10:31:14.437306	2021-09-30 11:44:44.643651	2021-09-30 11:44:52.452334	\N	\N	\N	\N	40	\N	0
504	7	11	\N	337	\N	\N	337	50	427	\N	2021-09-28 11:03:32.143891	\N	\N	\N	\N	\N	\N	35	\N	\N	10	\N	\N	\N	\N	\N	2021-09-28 11:02:34.14099	2021-10-01 06:15:57.466125	\N	\N	\N	\N	\N	40	\N	0
473	9	23	\N	108	\N	\N	108	\N	138	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 19:33:18.773882	2021-09-22 19:33:50.89334	2021-10-05 16:19:58.161239	\N	\N	\N	\N	30	\N	0
521	7	1	\N	5481	37	80	5401	\N	6349.17000000000007	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 08:02:40.460011	2021-10-01 13:05:24.689312	2021-10-01 13:05:30.23616	\N	\N	\N	\N	948.169999999999959	\N	0
513	7	11	\N	200	\N	\N	200	50	290	\N	2021-09-29 07:26:36.89711	2021-10-01 06:15:29.776748	2021-10-01 06:15:33.01945	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-29 07:26:30.244431	2021-10-05 13:34:58.547679	\N	\N	\N	\N	\N	40	\N	0
510	2	1	\N	0	\N	\N	0	40	40	\N	2021-09-28 12:16:18.236619	\N	\N	\N	\N	\N	\N	44	\N	1	10	\N	\N	\N	\N	\N	2021-09-28 12:16:09.146893	2021-10-09 18:06:53.268591	\N	\N	\N	\N	\N	0	\N	0
507	13	1	\N	0	\N	\N	0	40	70	\N	2021-09-28 11:46:02.860362	\N	\N	\N	\N	\N	\N	31	\N	1	10	\N	\N	\N	\N	\N	2021-09-28 11:45:57.769702	2021-10-13 21:59:48.990593	\N	\N	\N	\N	\N	30	\N	0
454	19	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-20 10:14:52.954397	2021-10-17 15:25:14.576131	\N	\N	\N	\N	\N	0	\N	0
486	13	1	\N	185	\N	\N	185	40	256.449999999999989	\N	2021-09-23 12:53:35.089467	2021-09-23 12:53:45.18408	2021-09-23 12:56:31.180193	\N	2021-09-23 12:56:32.520422	2021-09-23 12:56:33.800918	2021-09-23 12:56:33.800944	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 12:53:26.060888	2021-09-23 12:56:33.800939	\N	\N	\N	\N	\N	31.4499999999999993	\N	0
455	6	18	\N	40	\N	\N	40	\N	40	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-20 10:15:14.703251	2021-09-20 10:15:15.222307	\N	\N	\N	\N	\N	0	\N	0
433	1	1	\N	235	\N	\N	235	\N	274.949999999999989	\N	2021-09-16 10:50:07.609697	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-16 10:49:59.42294	2021-09-16 10:50:07.660837	\N	\N	\N	\N	\N	39.9500000000000028	\N	1
476	7	11	\N	55	\N	\N	55	\N	95	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-23 04:58:21.643906	2021-09-23 04:58:40.134912	2021-09-23 04:58:40.134912	\N	\N	\N	\N	40	\N	0
449	13	1	\N	165	37	80	85	40	139.449999999999989	\N	2021-09-21 14:13:31.5466	2021-09-22 06:48:47.708462	2021-09-22 06:49:04.106591	\N	\N	\N	\N	31	\N	1	11	\N	\N	\N	\N	\N	2021-09-17 10:32:34.427945	2021-09-23 09:36:27.526049	\N	\N	\N	\N	\N	14.4499999999999993	\N	0
460	13	1	\N	165	\N	\N	165	40	233.050000000000011	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-21 14:34:31.928082	2021-09-22 08:38:51.15468	2021-09-22 08:38:51.15468	\N	\N	\N	\N	28.0500000000000007	\N	0
463	13	18	\N	20	\N	\N	20	50	70	\N	2021-09-23 12:50:48.110618	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-09-22 11:41:13.310694	2021-09-23 12:50:48.130447	\N	\N	\N	\N	\N	0	\N	0
505	7	11	\N	2880	37	80	2800	50	2890	\N	2021-09-28 13:23:23.751012	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-09-28 11:28:11.815251	2021-09-28 13:23:23.826756	\N	\N	\N	\N	\N	40	\N	0
457	9	23	\N	3	\N	\N	3	50	53	\N	2021-09-20 17:34:52.380513	\N	\N	\N	\N	\N	\N	37	\N	\N	1	\N	\N	\N	\N	\N	2021-09-20 17:34:09.35685	2021-09-20 17:34:52.400663	\N	\N	\N	\N	\N	0	\N	0
480	13	1	\N	625	\N	\N	625	40	771.25	\N	2021-09-23 10:50:27.142346	2021-09-23 11:29:21.300916	2021-09-23 11:29:22.990919	\N	2021-09-23 11:29:26.923777	2021-09-23 11:29:29.723297	2021-09-23 11:29:29.723323	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-23 10:50:13.507162	2021-09-23 11:29:29.723317	\N	\N	\N	\N	\N	106.25	\N	0
502	7	11	\N	232	\N	\N	232	\N	272	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-28 04:47:10.075163	2021-09-28 04:47:15.617347	2021-09-28 04:47:20.225098	\N	\N	\N	\N	40	\N	0
519	13	1	\N	55	\N	\N	55	50	144.349999999999994	\N	2021-09-30 06:38:32.006085	2021-09-30 06:39:07.043979	\N	\N	\N	\N	\N	31	\N	1	11	\N	\N	\N	\N	\N	2021-09-30 06:37:09.223193	2021-09-30 07:37:08.608194	\N	\N	\N	\N	\N	39.3500000000000014	\N	0
515	13	1	\N	915	\N	\N	915	\N	1100.54999999999995	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-29 09:58:35.749172	2021-09-29 09:58:36.86427	2021-09-29 09:58:49.834383	\N	\N	\N	\N	185.550000000000011	\N	0
527	1	1	\N	58	\N	\N	58	\N	58	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 12:32:19.828261	2021-09-30 18:39:52.253103	2021-09-30 18:40:45.309751	\N	\N	\N	\N	0	\N	1
531	7	11	\N	550	\N	\N	550	50	640	\N	2021-10-01 07:37:30.365818	2021-10-01 07:37:52.934162	2021-10-01 07:37:54.642932	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-10-01 07:37:16.630799	2021-10-01 07:37:54.642952	\N	\N	\N	\N	\N	40	\N	0
534	1	1	\N	755	\N	\N	755	\N	755	\N	2021-10-04 02:44:10.01871	2021-10-04 02:44:10.01871	2021-10-04 02:44:10.01871	\N	2021-10-04 02:44:10.01871	2021-10-04 02:44:10.01871	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 02:42:18.209838	2021-10-04 02:44:10.059822	\N	\N	\N	\N	\N	0	\N	1
542	1	1	\N	86	\N	\N	86	\N	86	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 09:44:40.015211	2021-10-04 10:14:07.584182	2021-10-04 10:14:32.218786	\N	\N	\N	\N	0	\N	1
528	1	1	\N	56	\N	\N	56	\N	56	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 18:46:32.522387	2021-09-30 18:46:36.662582	2021-09-30 18:46:41.251998	\N	\N	\N	\N	0	\N	1
526	1	1	\N	230	\N	\N	230	\N	230	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 11:46:34.091025	2021-09-30 12:32:08.548994	2021-09-30 12:32:08.548994	\N	\N	\N	\N	0	\N	1
538	7	11	\N	600	\N	\N	600	\N	640	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 08:56:20.126156	2021-10-04 08:56:24.77674	2021-10-04 08:57:02.098593	\N	\N	\N	\N	40	\N	0
529	1	1	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 18:47:19.276173	2021-09-30 18:47:19.874937	2021-09-30 18:47:22.819388	\N	\N	\N	\N	0	\N	1
535	1	1	\N	115	\N	\N	115	\N	115	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 02:49:16.583162	2021-10-04 02:49:17.214958	2021-10-04 02:49:53.495466	\N	\N	\N	\N	0	\N	1
550	13	11	\N	100	\N	\N	100	\N	140	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 09:58:57.973961	2021-10-05 09:59:05.457407	2021-10-05 09:59:05.457407	\N	\N	\N	\N	40	\N	0
524	1	1	\N	56	\N	\N	56	\N	56	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 11:18:36.129672	2021-09-30 11:45:42.725989	2021-09-30 11:45:42.725989	\N	\N	\N	\N	0	\N	1
530	1	1	\N	28	\N	\N	28	\N	28	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-30 18:50:58.97668	2021-09-30 18:50:59.426894	2021-09-30 18:51:25.717571	\N	\N	\N	\N	0	\N	1
555	13	11	\N	45	\N	\N	45	\N	85	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:25:01.392394	2021-10-05 10:25:20.753302	2021-10-05 10:25:20.753302	\N	\N	\N	\N	40	\N	0
525	13	11	\N	23195	37	80	23115	50	23205	\N	2021-09-30 11:45:43.526083	\N	\N	\N	\N	\N	\N	32	\N	\N	10	\N	\N	\N	\N	\N	2021-09-30 11:45:02.649663	2021-10-01 06:15:21.5889	\N	\N	\N	\N	\N	40	\N	0
512	7	11	\N	300	\N	\N	300	50	390	\N	2021-09-29 07:25:59.956104	2021-10-01 06:15:39.334425	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-09-29 07:25:36.748932	2021-10-01 06:15:40.896871	\N	\N	\N	\N	\N	40	\N	0
554	13	11	\N	900	\N	\N	900	\N	940	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:24:39.730127	2021-10-05 10:24:47.852284	2021-10-05 10:24:47.852284	\N	\N	\N	\N	40	\N	0
495	5	11	\N	450	\N	\N	450	\N	450	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-24 07:34:32.263983	2021-10-01 06:47:29.833521	2021-10-01 06:47:37.471579	\N	\N	\N	\N	0	\N	1
544	13	11	\N	122	\N	\N	122	\N	162	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 12:29:23.418872	2021-10-05 09:58:50.701413	2021-10-05 09:58:50.701413	\N	\N	\N	\N	40	\N	0
543	7	11	\N	2580	37	80	2500	50	2590	\N	\N	\N	\N	\N	\N	\N	\N	41	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 10:46:32.742026	2021-10-04 16:26:20.724727	2021-10-04 16:26:30.480794	\N	\N	\N	\N	40	\N	0
539	7	11	\N	750	\N	\N	750	50	840	\N	2021-10-04 08:58:22.275404	2021-10-04 08:59:54.237702	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-10-04 08:57:21.765844	2021-10-05 05:09:59.592141	\N	\N	\N	\N	\N	40	\N	0
537	7	11	\N	300	\N	\N	300	\N	340	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 08:55:41.645757	2021-10-04 08:55:48.508176	2021-10-04 08:56:04.449827	\N	\N	\N	\N	40	\N	0
533	1	1	\N	665	\N	\N	665	\N	665	\N	2021-10-01 08:17:21.733188	2021-10-01 08:17:21.733188	2021-10-01 08:17:21.733188	\N	2021-10-01 08:17:21.733188	2021-10-01 08:17:21.733188	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-01 08:16:44.299451	2021-10-01 08:17:21.772218	\N	\N	\N	\N	\N	0	\N	1
514	13	1	\N	915	37	80	835	50	1056.95000000000005	\N	2021-09-29 09:59:12.776604	2021-10-01 08:17:53.303016	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-29 09:58:35.742936	2021-10-01 08:17:53.303037	\N	\N	\N	\N	\N	171.949999999999989	\N	0
536	7	11	\N	400	\N	\N	400	\N	440	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 08:55:41.639102	2021-10-04 08:55:48.731127	2021-10-04 08:56:08.650208	\N	\N	\N	\N	40	\N	0
540	7	11	\N	300	\N	\N	300	50	390	\N	2021-10-04 09:04:40.84379	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 09:04:30.112239	2021-10-04 09:04:40.87083	\N	\N	\N	\N	\N	40	\N	0
522	13	1	\N	450	\N	\N	450	50	606.5	\N	2021-10-01 18:58:44.904755	2021-10-01 19:02:14.117777	2021-10-01 19:02:15.26869	\N	2021-10-01 19:02:16.580475	2021-10-01 19:02:18.332942	2021-10-01 19:02:18.332969	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-30 08:57:34.365089	2021-10-01 19:02:18.332963	\N	\N	\N	\N	\N	106.5	\N	0
546	7	11	\N	366	\N	\N	366	50	456	\N	\N	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 06:23:52.790824	2021-10-05 06:23:58.431227	2021-10-05 06:31:10.949104	\N	\N	\N	\N	40	\N	0
532	7	11	\N	355	\N	\N	355	50	445	\N	2021-10-04 08:47:15.857047	2021-10-04 08:47:24.27444	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-10-01 07:38:24.128568	2021-10-04 08:47:24.274463	\N	\N	\N	\N	\N	40	\N	0
545	13	1	\N	100	\N	\N	100	\N	147	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 13:04:23.822613	2021-10-04 13:57:46.76311	2021-10-04 13:58:12.501856	\N	\N	\N	\N	47	\N	0
541	1	1	\N	690	\N	\N	690	\N	690	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-04 09:33:43.904554	2021-10-04 09:37:05.110837	2021-10-04 09:37:43.623392	\N	\N	\N	\N	0	\N	1
553	13	11	\N	1910	37	80	1830	50	1920	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:24:04.771301	2021-10-05 10:24:28.179847	2021-10-05 10:24:28.179847	\N	\N	\N	\N	40	\N	0
547	7	11	\N	900	\N	\N	900	50	990	\N	2021-10-05 06:31:27.969581	2021-10-05 06:31:34.505312	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-10-05 06:31:20.648262	2021-10-05 06:31:50.535864	\N	\N	\N	\N	\N	40	\N	0
548	7	18	\N	300	\N	\N	300	\N	300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 09:30:26.675544	2021-10-06 05:16:55.380433	2021-10-06 05:35:55.375824	\N	\N	\N	\N	0	\N	0
508	13	1	\N	115	\N	\N	115	40	204.550000000000011	\N	2021-09-28 11:47:38.154233	2021-10-12 06:58:40.309691	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-09-28 11:47:31.692637	2021-10-12 06:58:40.309711	\N	\N	\N	\N	\N	49.5499999999999972	\N	0
551	13	11	\N	900	\N	\N	900	\N	940	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 09:59:36.827663	2021-10-05 10:17:57.462473	2021-10-05 10:17:57.462473	\N	\N	\N	\N	40	\N	0
552	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:23:51.709591	2021-10-05 10:23:57.775788	2021-10-05 10:23:57.775788	\N	\N	\N	\N	40	\N	0
557	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:32:05.251333	2021-10-05 10:32:22.438693	2021-10-05 10:32:22.438693	\N	\N	\N	\N	40	\N	0
556	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:30:23.548124	2021-10-05 10:32:00.347603	2021-10-05 10:32:00.347603	\N	\N	\N	\N	40	\N	0
558	13	11	\N	155	\N	\N	155	\N	195	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:33:38.41029	2021-10-05 10:34:10.675863	2021-10-05 10:34:10.675863	\N	\N	\N	\N	40	\N	0
559	13	11	\N	110	\N	\N	110	\N	150	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:36:14.793513	2021-10-05 10:49:02.103468	2021-10-05 10:49:02.103468	\N	\N	\N	\N	40	\N	0
560	13	11	\N	505	37	80	425	\N	465	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:49:28.482241	2021-10-05 10:57:46.25276	2021-10-05 10:57:46.25276	\N	\N	\N	\N	40	\N	0
561	13	11	\N	43	\N	\N	43	50	133	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:57:56.656559	2021-10-05 10:59:21.511106	2021-10-05 10:59:28.449354	\N	\N	\N	\N	40	\N	0
562	13	11	\N	660	\N	\N	660	\N	700	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 10:59:52.17807	2021-10-05 11:00:58.8915	2021-10-05 11:00:58.8915	\N	\N	\N	\N	40	\N	0
563	13	11	\N	311	\N	\N	311	\N	351	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 11:01:03.87071	2021-10-05 11:08:07.836874	2021-10-05 11:08:07.836874	\N	\N	\N	\N	40	\N	0
549	13	1	\N	115	\N	\N	115	50	214.550000000000011	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-05 09:57:45.172191	2021-10-05 12:29:25.829791	2021-10-05 12:29:25.829791	\N	\N	\N	\N	49.5499999999999972	\N	0
596	7	11	\N	450	\N	\N	450	20	510	\N	2021-10-07 07:15:38.240124	\N	\N	\N	\N	\N	\N	40	\N	1	10	\N	\N	\N	\N	\N	2021-10-06 17:09:45.053365	2021-10-07 07:15:51.768316	\N	\N	\N	\N	\N	40	\N	0
594	7	11	\N	70	46	40	30	50	120	\N	2021-10-06 16:29:29.85942	\N	\N	\N	\N	\N	\N	40	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 16:29:21.235618	2021-10-06 16:29:29.886349	\N	\N	\N	\N	\N	40	\N	0
573	7	11	\N	1800	\N	\N	1800	50	1890	\N	\N	\N	\N	\N	\N	\N	\N	35	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 14:23:47.62586	2021-10-05 14:26:47.979409	2021-10-05 14:26:50.732251	\N	\N	\N	\N	40	\N	0
568	7	11	\N	92000	\N	\N	92000	\N	92040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:42:11.576761	2021-10-05 13:42:12.07514	2021-10-05 13:42:30.247515	\N	\N	\N	\N	40	\N	0
569	7	11	\N	23000	\N	\N	23000	\N	23040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:42:11.585103	2021-10-05 13:42:11.65095	2021-10-05 13:42:34.33616	\N	\N	\N	\N	40	\N	0
595	7	11	\N	305	\N	\N	305	50	395	\N	\N	\N	\N	\N	\N	\N	\N	40	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 16:29:37.274591	2021-10-06 17:09:34.686298	2021-10-06 17:09:38.340005	\N	\N	\N	\N	40	\N	0
574	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 14:28:19.167632	2021-10-05 14:28:22.78008	2021-10-05 14:28:22.78008	\N	\N	\N	\N	40	\N	0
592	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 13:33:46.471806	2021-10-07 08:53:08.977093	2021-10-07 08:53:08.977093	\N	\N	\N	\N	0	\N	0
589	7	11	\N	2250	\N	\N	2250	50	2340	\N	\N	\N	\N	\N	\N	\N	\N	49	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 07:58:27.153051	2021-10-06 08:31:58.326138	2021-10-06 08:31:58.326138	\N	\N	\N	\N	40	\N	0
587	7	11	\N	35	\N	\N	35	\N	75	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 07:23:06.984948	2021-10-06 07:23:11.075343	2021-10-06 07:23:11.075343	\N	\N	\N	\N	40	\N	0
571	7	11	\N	69000	\N	\N	69000	\N	69040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:42:42.051631	2021-10-05 13:43:55.893762	2021-10-05 13:44:08.619079	\N	\N	\N	\N	40	\N	0
570	7	11	\N	46000	\N	\N	46000	\N	46040	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:42:42.04822	2021-10-05 13:43:48.902834	2021-10-05 13:44:12.149081	\N	\N	\N	\N	40	\N	0
600	13	11	\N	955	48	80	875	20	945	\N	2021-10-08 11:09:39.550913	\N	\N	\N	\N	\N	\N	32	\N	1	10	\N	\N	\N	\N	\N	2021-10-07 05:12:45.442694	2021-10-08 11:09:46.80638	\N	\N	\N	\N	\N	50	\N	0
564	13	11	\N	1027	\N	\N	1027	\N	1067	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 11:08:17.459754	2021-10-05 11:08:24.118034	2021-10-05 11:16:03.083353	\N	\N	\N	\N	40	\N	0
610	7	11	\N	122	\N	\N	122	\N	162	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 14:03:37.94484	2021-10-07 14:03:50.23356	2021-10-07 14:03:50.23356	\N	\N	\N	\N	40	\N	0
588	7	11	\N	500	\N	\N	500	\N	540	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 07:23:22.238239	2021-10-06 07:23:36.255684	2021-10-06 07:23:36.255684	\N	\N	\N	\N	40	\N	0
565	13	11	\N	505	\N	\N	505	\N	545	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 11:16:13.141737	2021-10-05 11:16:16.627259	2021-10-05 11:16:19.265078	\N	\N	\N	\N	40	\N	0
575	13	11	\N	2250	\N	\N	2250	\N	2290	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 14:28:30.212438	2021-10-07 04:45:53.703823	2021-10-07 04:46:46.285219	\N	\N	\N	\N	40	\N	0
604	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 09:30:10.77411	2021-10-07 09:30:10.792573	2021-10-07 09:33:45.409243	\N	\N	\N	\N	0	\N	0
579	13	1	\N	720	\N	\N	720	50	770	\N	2021-10-05 16:05:05.870688	2021-10-05 16:06:34.834109	2021-10-06 11:30:27.500127	\N	2021-10-06 11:30:30.501807	2021-10-06 11:30:32.051573	2021-10-06 11:30:32.051601	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-05 16:04:57.773692	2021-10-06 11:30:32.051594	\N	\N	\N	\N	\N	0	\N	0
608	4	1	\N	130	\N	\N	130	50	233	\N	\N	\N	\N	\N	\N	\N	\N	30	\N	1	1	\N	\N	\N	\N	\N	2021-10-07 13:38:13.955173	2021-10-07 14:13:55.997868	2021-10-07 14:13:55.997868	\N	\N	\N	\N	52.1000000000000014	\N	0
577	13	1	\N	1260	37	80	1180	50	1460.59999999999991	\N	2021-10-05 15:55:07.893336	\N	\N	\N	\N	\N	\N	31	\N	1	10	\N	\N	\N	\N	\N	2021-10-05 15:08:32.27792	2021-10-05 16:03:57.897368	\N	\N	\N	\N	\N	230.599999999999994	\N	0
583	7	1	\N	1485	\N	\N	1485	\N	1767.45000000000005	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 04:19:24.295998	2021-10-06 05:35:48.690491	2021-10-06 05:35:54.445511	\N	\N	\N	\N	282.449999999999989	\N	0
578	13	1	\N	385	\N	\N	385	50	530.450000000000045	\N	2021-10-05 16:04:18.8968	2021-10-05 16:04:27.492439	2021-10-06 11:35:23.752584	\N	2021-10-06 11:36:24.358603	2021-10-06 11:36:27.688328	2021-10-06 11:36:27.68835	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-05 16:04:08.599752	2021-10-06 11:36:27.688345	\N	\N	\N	\N	\N	95.4500000000000028	\N	0
601	5	11	\N	450	\N	\N	450	\N	450	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 06:59:42.574617	2021-10-07 06:59:43.279387	2021-10-07 06:59:48.247761	\N	\N	\N	\N	0	\N	1
566	13	1	\N	335	\N	\N	335	\N	421.949999999999989	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:02:42.111712	2021-10-05 15:08:17.643852	2021-10-05 15:08:17.643852	\N	\N	\N	\N	86.9500000000000028	\N	0
603	13	1	\N	693	\N	\N	693	50	891	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-07 08:53:20.295866	2021-10-07 09:30:03.159629	2021-10-07 09:30:03.159629	\N	\N	\N	\N	147.810000000000002	\N	0
567	7	11	\N	722	\N	\N	722	\N	762	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 13:31:09.281927	2021-10-05 13:31:16.161633	2021-10-05 13:41:49.383207	\N	\N	\N	\N	40	\N	0
597	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 05:04:01.273024	2021-10-07 05:04:01.299937	2021-10-07 05:04:05.327404	\N	\N	\N	\N	40	\N	0
590	7	11	\N	389	46	40	349	50	439	\N	2021-10-06 16:19:46.015748	\N	\N	\N	\N	\N	\N	40	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 08:32:07.716192	2021-10-06 16:19:46.060299	\N	\N	\N	\N	\N	40	\N	0
584	7	1	\N	880	\N	\N	880	\N	1059.59999999999991	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 05:36:39.395738	2021-10-06 05:38:11.67864	2021-10-06 05:38:21.037247	\N	\N	\N	\N	179.599999999999994	\N	0
585	7	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 05:36:55.275402	2021-10-06 05:36:55.292338	2021-10-06 05:38:25.508041	\N	\N	\N	\N	0	\N	0
581	9	11	\N	100	\N	\N	100	\N	140	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 19:59:25.813304	2021-10-05 20:40:05.13749	2021-10-05 20:40:05.13749	\N	\N	\N	\N	40	\N	0
580	9	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 19:32:23.642007	2021-10-05 19:42:54.400562	2021-10-05 19:59:08.721645	\N	\N	\N	\N	40	\N	0
593	7	11	\N	200	46	40	160	50	250	\N	2021-10-06 16:28:58.424928	2021-10-06 16:29:04.505951	2021-10-06 16:29:12.583442	\N	\N	\N	\N	40	\N	\N	11	\N	\N	\N	\N	\N	2021-10-06 16:28:44.42482	2021-10-06 16:30:03.347041	\N	\N	\N	\N	\N	40	\N	0
586	7	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 05:48:44.621879	2021-10-06 05:48:44.645578	2021-10-06 05:49:05.743826	\N	\N	\N	\N	40	\N	0
576	13	18	\N	40	\N	\N	40	\N	40	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 15:08:25.273256	2021-10-06 06:57:58.719496	2021-10-06 06:57:58.719496	\N	\N	\N	\N	0	\N	0
572	7	11	\N	2700	\N	\N	2700	50	2790	\N	2021-10-05 14:23:10.069418	2021-10-05 14:23:16.860996	\N	\N	\N	\N	\N	35	\N	\N	11	\N	\N	\N	\N	\N	2021-10-05 14:22:58.546582	2021-10-06 16:46:46.26238	\N	\N	\N	\N	\N	40	\N	0
598	13	11	\N	45	\N	\N	45	\N	85	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 05:04:18.741012	2021-10-07 05:04:18.768574	2021-10-07 05:04:28.205255	\N	\N	\N	\N	40	\N	0
599	13	11	\N	450	\N	\N	450	\N	490	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 05:04:36.69101	2021-10-07 05:04:36.717146	2021-10-07 05:04:42.468937	\N	\N	\N	\N	40	\N	0
602	5	11	\N	450	\N	\N	450	\N	450	\N	2021-10-07 07:06:35.525247	2021-10-07 07:06:35.525247	2021-10-07 07:06:35.525247	\N	2021-10-07 07:06:35.525247	2021-10-07 07:06:35.525247	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 06:59:59.986389	2021-10-07 07:06:35.547687	\N	\N	\N	\N	\N	0	\N	1
613	7	11	\N	70	\N	\N	70	20	90	\N	2021-10-07 14:32:24.524556	2021-10-07 14:33:06.941351	\N	\N	\N	\N	\N	40	\N	1	11	\N	\N	\N	\N	\N	2021-10-07 14:32:17.315329	2021-10-07 14:33:09.828525	\N	\N	\N	\N	\N	0	\N	0
612	7	11	\N	100	\N	\N	100	20	160	\N	2021-10-07 14:31:50.449964	2021-10-07 14:31:56.413798	2021-10-07 14:31:58.697505	\N	2021-10-07 14:32:01.845834	2021-10-07 14:32:05.600897	2021-10-07 14:32:05.600924	40	\N	1	1	\N	\N	\N	\N	\N	2021-10-07 14:31:43.824629	2021-10-07 14:32:05.600918	\N	\N	\N	\N	\N	40	\N	0
620	1	1	\N	275	\N	\N	275	\N	352	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 09:28:07.348264	2021-10-08 20:52:22.58871	2021-10-08 20:53:27.861424	\N	\N	\N	\N	76.75	\N	1
607	12	1	\N	55	\N	\N	55	\N	95	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 12:57:24.349154	2021-10-07 12:57:39.756864	\N	\N	\N	\N	\N	39.3500000000000014	\N	0
582	9	11	\N	272	37	80	192	\N	232	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-05 20:40:06.61197	2021-10-06 20:40:14.02441	2021-10-11 16:18:08.495979	\N	\N	\N	\N	40	\N	0
591	13	1	\N	183	\N	\N	183	\N	244.110000000000014	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-06 13:33:15.740166	2021-10-07 08:53:05.782114	2021-10-07 08:53:05.782114	\N	\N	\N	\N	61.1099999999999994	\N	0
606	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 09:42:04.484034	2021-10-08 12:44:45.469527	2021-10-08 13:04:59.468268	\N	\N	\N	\N	0	\N	0
605	13	1	\N	718	\N	\N	718	\N	871	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 09:30:14.530085	2021-10-08 12:45:42.425796	2021-10-08 13:04:57.761945	\N	\N	\N	\N	152.060000000000002	\N	0
611	7	11	\N	280	\N	\N	280	20	340	\N	2021-10-07 14:31:15.06265	2021-10-07 14:31:21.877305	2021-10-07 14:31:23.369686	\N	2021-10-07 14:31:26.272483	2021-10-07 14:31:29.879712	2021-10-07 14:31:29.879738	40	\N	1	1	\N	\N	\N	\N	\N	2021-10-07 14:31:08.944648	2021-10-07 14:31:29.879733	\N	\N	\N	\N	\N	40	\N	0
614	7	11	\N	50	\N	\N	50	20	110	\N	2021-10-07 14:39:39.029324	2021-10-07 14:39:47.288332	\N	\N	\N	\N	\N	40	\N	1	11	\N	\N	\N	\N	\N	2021-10-07 14:39:19.619339	2021-10-07 14:39:49.367906	\N	\N	\N	\N	\N	40	\N	0
615	7	11	\N	150	\N	\N	150	20	210	\N	2021-10-07 14:40:43.066675	\N	\N	\N	\N	\N	\N	40	\N	1	10	\N	\N	\N	\N	\N	2021-10-07 14:40:32.95031	2021-10-07 14:40:50.08388	\N	\N	\N	\N	\N	40	\N	0
616	7	11	\N	23000	\N	\N	23000	20	23060	\N	2021-10-07 14:46:05.159297	2021-10-07 14:46:42.144311	2021-10-07 14:46:43.565028	\N	\N	\N	\N	40	\N	1	11	\N	\N	\N	\N	\N	2021-10-07 14:45:54.121866	2021-10-07 14:46:44.953939	\N	\N	\N	\N	\N	40	\N	0
617	7	11	\N	0	\N	\N	0	20	20	\N	2021-10-07 14:56:57.718506	\N	\N	\N	\N	\N	\N	40	\N	1	10	\N	\N	\N	\N	\N	2021-10-07 14:56:50.176715	2021-10-07 14:57:29.015578	\N	\N	\N	\N	\N	0	\N	0
618	4	1	\N	43	\N	\N	43	50	131	\N	2021-10-08 10:10:45.532068	2021-10-08 21:04:19.506773	\N	\N	\N	\N	\N	30	\N	1	11	\N	\N	\N	\N	\N	2021-10-07 18:27:29.912329	2021-10-08 21:04:20.816174	\N	\N	\N	\N	\N	37.3100000000000023	\N	0
609	4	11	\N	1627	\N	\N	1627	\N	1677	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-07 14:03:25.43226	2021-10-08 10:55:50.151699	2021-10-08 10:55:55.419446	\N	\N	\N	\N	50	\N	0
316	13	21	\N	799	\N	\N	799	\N	799	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-09-09 15:06:06.242254	2021-10-08 12:19:25.57391	2021-10-08 12:19:25	\N	\N	\N	\N	0	\N	0
628	13	1	\N	155	\N	\N	155	50	262	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 13:38:23.049136	2021-10-08 17:59:26.345449	2021-10-08 17:59:28.999396	\N	\N	\N	\N	56.3500000000000014	\N	0
663	13	11	\N	825	61	80	745	\N	795	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:36:19.642691	2021-10-13 12:37:28.601918	2021-10-13 12:37:31.627152	\N	\N	\N	\N	50	\N	0
621	5	11	\N	45	\N	\N	45	\N	45	\N	2021-10-08 10:32:33.956321	2021-10-08 10:32:33.956321	2021-10-08 10:32:33.956321	\N	2021-10-08 10:32:33.956321	2021-10-08 10:32:33.956321	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 10:32:30.576591	2021-10-08 10:32:33.978275	\N	\N	\N	\N	\N	0	\N	1
641	13	1	\N	80	\N	\N	80	\N	124	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 09:26:24.361378	2021-10-11 09:26:31.023612	2021-10-11 09:26:48.475139	\N	\N	\N	\N	43.6000000000000014	\N	0
636	1	1	\N	30	\N	\N	30	\N	66	\N	2021-10-08 20:53:39.12457	2021-10-08 20:53:39.12457	2021-10-08 20:53:39.12457	\N	2021-10-08 20:53:39.12457	2021-10-08 20:53:39.12457	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 20:53:35.859864	2021-10-08 20:53:39.172338	\N	\N	\N	\N	\N	35.1000000000000014	\N	1
622	5	11	\N	45	\N	\N	45	\N	45	\N	2021-10-08 10:39:39.661627	2021-10-08 10:39:39.661627	2021-10-08 10:39:39.661627	\N	2021-10-08 10:39:39.661627	2021-10-08 10:39:39.661627	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 10:39:36.197677	2021-10-08 10:39:39.699123	\N	\N	\N	\N	\N	0	\N	1
665	13	1	\N	1585	\N	\N	1585	\N	1885	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:41:57.493439	2021-10-13 12:43:43.126507	2021-10-13 12:43:46.414488	\N	\N	\N	\N	299.449999999999989	\N	0
646	9	11	\N	55	\N	\N	55	\N	105	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 16:19:02.527218	2021-10-11 16:19:02.563941	2021-10-11 16:19:22.157017	\N	\N	\N	\N	50	\N	0
632	13	11	\N	23000	49	80	22920	\N	22970	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 15:51:34.474093	2021-10-08 15:51:52.081799	2021-10-08 15:51:54.30746	\N	\N	\N	\N	50	\N	0
637	1	1	\N	90	\N	\N	90	\N	136	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 20:57:22.536026	2021-10-08 20:57:23.803846	2021-10-08 21:04:00.668715	\N	\N	\N	\N	45.2999999999999972	\N	1
638	13	1	\N	80	\N	\N	80	\N	124	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 05:23:32.952164	2021-10-11 05:23:33.862095	2021-10-11 05:39:06.257957	\N	\N	\N	\N	43.6000000000000014	\N	0
639	13	18	\N	20	\N	\N	20	\N	20	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 05:23:44.715496	2021-10-11 05:23:44.733317	2021-10-11 05:39:08.643545	\N	\N	\N	\N	0	\N	0
655	7	11	\N	625	\N	\N	625	\N	675	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-12 16:14:38.584226	2021-10-16 04:49:29.824151	2021-10-16 04:49:36.426808	\N	\N	\N	\N	50	\N	0
647	9	11	\N	55	\N	\N	55	\N	105	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 16:19:33.042772	2021-10-11 16:19:33.07611	2021-10-11 16:19:59.454418	\N	\N	\N	\N	50	\N	0
648	9	11	\N	150	57	25	125	\N	175	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 18:37:35.647782	2021-10-11 18:42:49.899498	2021-10-11 18:42:49.899498	\N	\N	\N	\N	50	\N	0
619	7	11	\N	50	49	80	0	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 08:47:03.611839	2021-10-08 11:07:31.207654	2021-10-08 11:07:36.721581	\N	\N	\N	\N	50	\N	0
625	13	11	\N	23075	\N	\N	23075	20	23145	\N	2021-10-08 13:42:56.295033	\N	\N	\N	\N	\N	\N	32	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 13:06:10.987911	2021-10-08 13:42:56.336834	\N	\N	\N	\N	\N	50	\N	0
623	4	11	\N	55	\N	\N	55	\N	105	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 10:56:00.701097	2021-10-08 11:09:12.799398	\N	\N	\N	\N	\N	50	\N	0
660	13	11	\N	996	52	50	946	\N	996	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:25:08.735513	2021-10-13 12:29:14.843106	2021-10-13 12:29:21.140426	\N	\N	\N	\N	50	\N	0
650	9	11	\N	135	\N	\N	135	\N	185	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 19:06:10.803619	2021-10-11 19:14:46.705694	2021-10-11 19:15:33.030883	\N	\N	\N	\N	50	\N	0
627	7	1	\N	113	56	45	68	\N	110	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 13:33:02.515399	2021-10-08 13:43:01.447427	2021-10-08 13:43:24.875202	\N	\N	\N	\N	41.5600000000000023	\N	0
634	13	11	\N	70	49	80	0	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 15:55:57.383777	2021-10-08 15:56:50.504035	2021-10-08 15:56:55.131206	\N	\N	\N	\N	50	\N	0
642	13	1	\N	165	\N	\N	165	50	274	\N	2021-10-12 14:40:44.366875	\N	\N	\N	\N	\N	\N	31	\N	1	10	\N	\N	\N	\N	\N	2021-10-11 09:27:30.785044	2021-10-12 14:42:15.692755	\N	\N	\N	\N	\N	58.0499999999999972	\N	0
661	13	11	\N	55	61	80	0	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:29:28.725378	2021-10-13 12:29:57.60249	2021-10-13 12:29:57.60249	\N	\N	\N	\N	50	\N	0
624	13	11	\N	450	48	80	370	20	440	\N	2021-10-08 11:35:45.353252	\N	\N	\N	\N	\N	\N	32	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 11:35:27.628509	2021-10-08 11:35:45.393608	\N	\N	\N	\N	\N	50	\N	0
633	13	11	\N	35	48	80	0	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 15:52:03.790857	2021-10-08 15:53:31.314573	2021-10-08 15:53:34.932386	\N	\N	\N	\N	50	\N	0
651	9	11	\N	170	\N	\N	170	\N	220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 19:18:19.984012	2021-10-11 19:19:26.854694	2021-10-11 19:19:26.854694	\N	\N	\N	\N	50	\N	0
626	7	11	\N	475	\N	\N	475	20	545	\N	\N	\N	\N	\N	\N	\N	\N	40	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 13:31:09.850358	2021-10-11 07:45:13.027626	2021-10-11 07:48:16.317961	\N	\N	\N	\N	50	\N	0
640	13	1	\N	110	\N	\N	110	\N	159	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 05:39:15.621503	2021-10-11 05:39:16.463334	2021-10-11 09:24:24.096032	\N	\N	\N	\N	48.7000000000000028	\N	0
629	7	1	\N	83	\N	\N	83	50	178	\N	\N	\N	\N	\N	\N	\N	\N	50	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 13:43:31.579397	2021-10-08 13:46:01.137017	\N	\N	\N	\N	\N	44.1099999999999994	\N	0
635	13	11	\N	50	\N	\N	50	20	120	\N	\N	\N	\N	\N	\N	\N	\N	32	\N	1	1	\N	\N	\N	\N	\N	2021-10-08 17:40:12.5355	2021-10-08 17:41:08.945027	2021-10-08 17:41:08	\N	\N	\N	\N	50	\N	0
631	13	11	\N	170	\N	\N	170	\N	220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-08 15:48:38.78176	2021-10-08 15:51:22.331652	2021-10-08 15:51:23.996605	\N	\N	\N	\N	50	\N	0
653	9	11	\N	129	\N	\N	129	20	199	\N	2021-10-11 20:13:25.605391	\N	\N	\N	\N	\N	\N	47	\N	1	1	\N	\N	\N	\N	\N	2021-10-11 19:52:08.175486	2021-10-11 20:13:25.639182	\N	\N	\N	\N	\N	50	\N	0
649	9	11	\N	43	\N	\N	43	\N	93	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 18:46:29.88301	2021-10-11 19:03:47.924438	2021-10-11 19:05:59.818818	\N	\N	\N	\N	50	\N	0
657	13	1	\N	440	53	50	390	\N	487	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-12 18:58:03.013723	2021-10-13 12:41:41.34979	2021-10-13 12:41:43.492828	\N	\N	\N	\N	96.2999999999999972	\N	0
652	9	11	\N	193	\N	\N	193	\N	243	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 19:19:38.414189	2021-10-11 19:22:39.11298	2021-10-11 19:51:58.965891	\N	\N	\N	\N	50	\N	0
630	13	11	\N	55	56	45	10	20	80	\N	2021-10-08 15:23:38.34332	\N	\N	\N	\N	\N	\N	32	\N	1	11	\N	\N	\N	\N	\N	2021-10-08 13:58:23.344028	2021-10-12 10:20:01.139119	\N	\N	\N	\N	\N	50	\N	0
645	7	11	\N	555	\N	\N	555	20	625	\N	2021-10-12 14:05:22.094414	\N	\N	\N	\N	\N	\N	40	\N	1	11	\N	\N	\N	\N	\N	2021-10-11 13:35:07.257913	2021-10-14 07:34:45.810161	\N	\N	\N	\N	\N	50	\N	0
666	13	1	\N	160	\N	\N	160	50	268	\N	2021-10-13 16:23:21.682703	2021-10-13 16:24:10.606182	2021-10-13 16:25:07.237991	\N	2021-10-13 16:25:52.719444	2021-10-13 16:26:25.018536	2021-10-13 16:26:25.018563	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-13 12:43:52.726602	2021-10-13 16:26:25.018558	\N	\N	\N	\N	\N	57.2000000000000028	\N	0
658	9	32	\N	700	\N	\N	700	50	800	\N	2021-10-13 18:19:15.036635	\N	\N	\N	\N	\N	\N	47	\N	\N	1	\N	\N	\N	\N	\N	2021-10-12 19:25:49.482727	2021-10-13 18:19:15.071917	\N	\N	\N	\N	\N	50	\N	0
656	13	1	\N	380	53	50	330	50	467	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-12 18:49:44.417748	2021-10-12 18:50:32.633475	2021-10-12 18:50:32.633475	\N	\N	\N	\N	86.0999999999999943	\N	0
659	13	11	\N	744	52	50	694	\N	744	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 11:41:28.139317	2021-10-13 12:24:43.849802	2021-10-13 12:24:49.21854	\N	\N	\N	\N	50	\N	0
643	1	1	\N	230	\N	\N	230	\N	300	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 09:47:22.224565	2021-10-12 19:55:20.795867	\N	\N	\N	\N	\N	69.0999999999999943	\N	1
664	13	11	\N	1175	61	80	1095	\N	1145	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:38:57.98436	2021-10-13 12:40:02.374429	\N	\N	\N	\N	\N	50	\N	0
654	7	11	\N	0	\N	\N	0	20	70	\N	2021-10-12 14:26:42.350314	\N	\N	\N	\N	\N	\N	40	\N	1	10	\N	\N	\N	\N	\N	2021-10-12 14:26:19.626015	2021-10-14 14:08:20.000548	\N	\N	\N	\N	\N	50	\N	0
662	13	11	\N	50	61	80	0	\N	50	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 12:35:19.409309	2021-10-13 12:36:13.045991	2021-10-13 12:36:13.045991	\N	\N	\N	\N	50	\N	0
644	13	18	\N	320	\N	\N	320	50	370	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	\N	1	\N	\N	\N	\N	\N	2021-10-11 12:57:55.5423	2021-10-13 12:41:47.623538	2021-10-13 12:41:51.014932	\N	\N	\N	\N	0	\N	0
670	13	1	\N	140	\N	\N	140	\N	194	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 10:25:06.638876	2021-10-17 10:25:13.848387	2021-10-17 10:25:16.50073	\N	\N	\N	\N	53.7999999999999972	\N	0
668	5	11	\N	549	\N	\N	549	\N	549	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-14 07:36:19.670343	2021-10-14 07:37:17.63616	\N	\N	\N	\N	\N	0	\N	1
667	9	32	\N	550	\N	\N	550	\N	600	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-13 19:05:28.036674	2021-10-13 19:05:38.083868	\N	\N	\N	\N	\N	50	\N	0
669	13	1	\N	125	\N	\N	125	\N	177	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 10:24:01.637539	2021-10-17 10:24:06.447127	2021-10-17 10:24:09.026354	\N	\N	\N	\N	51.25	\N	0
672	13	1	\N	735	\N	\N	735	\N	890	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 10:27:39.274897	2021-10-17 10:33:20.939674	2021-10-17 10:33:23.65036	\N	\N	\N	\N	154.949999999999989	\N	0
671	13	1	\N	680	\N	\N	680	\N	826	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 10:25:59.108443	2021-10-17 10:26:20.378555	2021-10-17 10:26:42.746929	\N	\N	\N	\N	145.599999999999994	\N	0
673	13	1	\N	305	\N	\N	305	\N	387	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 10:35:51.247705	2021-10-17 10:36:12.533736	2021-10-17 10:36:14.462003	\N	\N	\N	\N	81.8499999999999943	\N	0
674	13	1	\N	140	\N	\N	140	50	244	\N	2021-10-17 15:14:37.588686	\N	\N	\N	\N	\N	\N	38	\N	1	1	\N	\N	\N	\N	\N	2021-10-17 15:13:07.772389	2021-10-17 15:14:37.63897	\N	\N	\N	\N	\N	53.7999999999999972	\N	0
675	13	1	\N	305	52	50	255	50	379	\N	\N	\N	\N	\N	\N	\N	\N	31	\N	1	1	\N	\N	\N	\N	\N	2021-10-17 15:15:32.404873	2021-10-17 15:17:01.638939	\N	\N	\N	\N	\N	73.3499999999999943	\N	0
676	19	11	\N	1816	61	80	1736	\N	1786	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N	\N	\N	\N	2021-10-17 15:25:38.507638	2021-10-17 15:26:56.977108	\N	\N	\N	\N	\N	50	\N	0
\.


--
-- Data for Name: localities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.localities (id, city_id, name, code, pin, delivery_fee, start_time, end_time, status, created_at, deleted_at, updated_at) FROM stdin;
1	1	Chor Bazar	cbz	797979	100	2021-07-15T02:30:48.000Z	2021-07-15T10:30:48.000Z	0	2021-07-15 02:19:02.777328	2021-07-21 07:38:45.209084	\N
2	2	rana	dh	44	44	2021-07-2119:44:40	2021-07-2119:44:40	0	2021-07-21 14:14:51.247262	2021-07-21 14:14:57.66834	\N
4	1	ra	HH	114	113	2021-07-21T03:30:03.000Z	2021-07-21T14:30:03.000Z	0	2021-07-24 02:14:29.599559	2021-07-24 02:15:14.961955	2021-07-24 02:15:07.902613
5	1	rana	hh	55	55	2021-07-21T02:30:03.000Z	2021-07-21T14:30:03.000Z	0	2021-07-24 02:19:03.7389	2021-07-24 02:19:19.190787	\N
7	1	uhd	tdj	743	73	2021-07-2507:14:23	2021-07-2507:14:23	0	2021-07-25 01:44:42.603797	2021-07-25 01:45:48.44565	\N
9	1	gvg	g	57	77	2021-07-2507:47:26	2021-07-2507:47:26	0	2021-07-25 02:17:45.511069	2021-07-25 02:28:24.27994	\N
10	6	Ranajeet Singha	n	41	41	2021-07-2520:21:57	2021-07-2520:21:57	0	2021-07-25 14:52:11.948791	2021-07-25 14:52:19.499739	\N
11	8	Nlc	nlc	607803	0	10:00	20:00	20	2021-07-31 12:32:35.371699	\N	\N
15	8	haha	haha	123412	0	10:00	20:00	0	2021-07-31 12:43:45.866108	2021-07-31 12:53:59.373631	2021-07-31 12:48:29.434091
16	2	BTM	BTM	0	string	string	23:00:00	0	2021-08-05 05:36:16.412369	\N	2021-08-05 09:22:56.61196
18	1	fff	fff	444	11	2021-08-0519:12:00	2021-08-0519:12:00	0	2021-08-05 13:42:15.08943	2021-08-05 13:46:33.170331	\N
22	12	frazer road	fr	800001	21	2021-08-24T03:30:29.000Z	2021-08-2417:41:29	0	2021-08-24 12:12:01.894856	2021-08-24 12:12:05.874655	\N
23	19	Park street	pk	678845	20	2021-08-25T03:30:54.000Z	2021-08-25T13:30:54.000Z	0	2021-08-25 09:36:53.439715	\N	\N
24	2	Majestic	majestic	560001	2	2021-08-31T04:30:24.000Z	2021-08-31T14:00:24.000Z	0	2021-08-31 08:22:23.516471	\N	\N
21	2	Koramangala	kor	0	2	9:00	18:00	0	2021-08-06 14:06:58.347972	2021-08-31 08:23:16.36209	\N
25	2	Kormangala	kor	0	2	9:00	18:00	0	2021-08-31 08:25:15.659014	\N	\N
26	2	Kormangala	KOR	0	2	9:00	18:00	0	2021-08-31 08:25:27.17503	2021-08-31 08:26:55.518161	\N
6	1	rana	gg	55	string	2021-07-21T02:30:03.000Z	2021-07-21T02:30:03.000Z	0	2021-07-25 01:28:07.820889	\N	2021-10-04 10:23:27.256315
8	1	fhfh	ffx	5	string	2021-07-21T02:30:03.000Z	2021-07-21T02:30:03.000Z	0	2021-07-25 02:16:41.610786	\N	2021-10-04 10:23:27.259149
19	1	rana	et	74	string	2021-07-21T02:30:03.000Z	2021-07-21T02:30:03.000Z	0	2021-08-05 13:46:53.292201	\N	2021-10-04 10:23:27.262296
3	1	J.k Road	JKR	788955	string	2021-07-21T02:30:03.000Z	2021-07-21T02:30:03.000Z	0	2021-07-21 14:16:01.71676	\N	2021-10-04 10:23:27.265406
17	10	gbxdf	fgxdh	434	44	2021-08-0519:11:16	2021-08-0519:11:16	0	2021-08-05 13:41:31.938716	2021-10-06 13:09:12.314242	\N
27	25	sri	sri	123123	15	2021-10-06T05:01:07.000Z	2021-10-06T12:24:07.000Z	0	2021-10-06 13:11:42.507914	\N	\N
\.


--
-- Data for Name: menu_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menu_categories (id, category_id, name, image, slug, status, created_at, updated_at, deleted_at) FROM stdin;
27	13	Veg	saas/menucategory/default.png	V-340	1	2021-08-25 09:28:37.099998	2021-08-25 09:28:45.526808	\N
30	14	Chicken	saas/menucategory/default.png	C-489	1	2021-08-25 09:29:32.585017	2021-08-25 09:29:37.76729	\N
29	14	Egg	saas/menucategory/default.png	E-415	1	2021-08-25 09:29:26.545512	2021-08-25 09:29:38.766405	\N
31	14	Meat	saas/menucategory/default.png	M-321	1	2021-08-25 09:29:36.625026	2021-08-25 09:29:39.871301	\N
22	1	Dry Fruits	saas/menucategory/menu_category_icon_7PoJhWvchQ_1609860662.png	DF-332	0	2021-08-24 14:38:51.278805	2021-09-20 12:45:07.186034	\N
14	7	Friction books	saas/menucategory/default.png	FB-454	1	2021-08-07 19:35:01.255057	2021-08-25 09:34:33.87132	\N
15	7	Non-Friction book	saas/menucategory/default.png	NB-943	0	2021-08-07 19:35:29.943783	2021-09-23 14:00:32.341375	\N
42	20	jn2	saas/menucategory/default.png	jn2	0	2021-09-28 06:29:32.574731	\N	\N
35	7		saas/menucategory/default	-160	0	2021-08-31 07:09:49.452408	2021-08-31 07:35:29.883505	2021-08-31 09:34:20.04836
43	20		saas/menucategory/default.png		0	2021-09-28 06:29:39.53986	\N	2021-09-28 06:29:59.098536
1	1	Snacks	saas/menucategory/menu_category_icon_4TWQEdQGf2_1609860625.png	S-935	1	2021-07-13 01:31:53.813458	2021-08-25 10:03:08.318898	\N
41	23	gc1	saas/menucategory/default.png	G-513	0	2021-09-28 06:29:21.617341	2021-09-28 06:46:09.04675	\N
21	1	dsd	saas/menucategory/menu_category_icon_M6Essb9yX4_1609860602.png	D-177	1	2021-08-24 14:38:42.577325	2021-09-28 07:33:01.237159	\N
33	1	rice	saas/menucategory/default.png	R-504	1	2021-08-25 13:01:06.521181	2021-09-01 09:46:21.405252	\N
5	2	Fish	saas/menucategory/default.png	F-856	0	2021-07-14 05:15:36.699238	\N	2021-07-16 12:53:13.101848
2	1	Milk	saas/menucategory/default.png	M-401	1	2021-07-13 09:38:01.208217	2021-07-14 06:00:57.561258	2021-07-21 14:56:54.71483
4	2	Eggg	saas/menucategory/default.png	E-894	0	2021-07-14 05:15:26.718491	\N	2021-07-21 15:00:10.729296
3	2	chicken	saas/menucategory/default.png	C-302	1	2021-07-14 05:15:13.244773	2021-07-21 15:10:18.24513	2021-07-21 15:10:30.614584
6	4	vegetable	saas/menucategory/default.png	V-788	0	2021-07-14 06:03:40.098598	2021-07-22 01:42:51.573476	2021-07-22 01:43:21.092602
8	4	Organic	saas/menucategory/default.png	O-570	1	2021-07-26 09:58:59.553341	2021-07-26 09:59:01.421025	2021-07-26 09:59:31.829007
12	5	Meat	saas/menucategory/default.png	meat	1	2021-08-05 17:12:30.703164	2021-08-05 18:48:22.210999	\N
13	5	Fish	saas/menucategory/default.png	fish	1	2021-08-05 19:06:03.184098	\N	\N
53	1	gdfg	saas/menucategory/default.png	gdfg	0	2021-09-28 10:05:10.857922	\N	2021-09-28 10:06:40.877456
45	23	new gc	saas/menucategory/default.png	NG-830	1	2021-09-28 06:46:24.92834	2021-09-28 09:16:10.275187	\N
32	4	veggies	saas/menucategory/default.png	V-147	1	2021-08-25 12:42:59.78269	2021-09-01 09:49:54.59997	\N
18	11	egg	saas/menucategory/default.png	E-408	1	2021-08-24 12:09:46.374016	2021-08-24 12:09:48.176063	2021-08-24 12:10:07.60907
46	23		saas/menucategory/default.png		0	2021-09-28 06:46:28.582095	\N	2021-09-28 09:16:26.665114
48	23	new gc	saas/menucategory/default.png	new-gc	0	2021-09-28 09:16:35.69645	\N	2021-09-28 09:16:44.796653
54	1	he	saas/menucategory/default.png	he	0	2021-09-28 10:06:49.056822	\N	2021-09-28 10:09:53.907553
23	9	asd	saas/menucategory/default.png	asd	0	2021-08-24 20:52:53.431645	\N	2021-08-24 20:52:56.992952
24	9	sdf	saas/menucategory/default.png	sdf	0	2021-08-24 21:32:22.230902	\N	2021-08-24 21:32:27.161818
44	23		saas/menucategory/default.png		0	2021-09-28 06:45:32.488834	\N	2021-09-28 09:16:49.305956
47	23		saas/menucategory/default.png		0	2021-09-28 09:16:28.789368	\N	2021-09-28 09:16:56.384373
28	13	Non-veg	saas/menucategory/default.png	N-763	1	2021-08-25 09:28:43.316607	2021-08-25 09:28:44.787073	\N
49	1	hello	saas/menucategory/default.png	hello	0	2021-09-28 10:01:59.92908	\N	2021-09-28 10:02:51.670807
50	1	curry	saas/menucategory/default.png	curry	0	2021-09-28 10:03:03.022912	\N	2021-09-28 10:03:11.936985
36	7	Kanti sweets	saas/menucategory/default	kanti-sweets	0	2021-08-31 07:09:50.267707	\N	2021-08-31 07:09:59.969502
26	9	Booee	saas/menucategory/default.png	B-110	1	2021-08-25 09:28:23.025321	2021-09-01 10:10:35.807777	\N
17	7	Comic books	saas/menucategory/default.png	CB-66	1	2021-08-07 19:38:29.854599	2021-09-01 10:10:44.036824	\N
39	22	Jeans for women	saas/menucategory/default.png	jeans-for-women	0	2021-09-16 18:33:26.950169	\N	\N
40	22	Jeans for men	saas/menucategory/default.png	jeans-for-men	0	2021-09-16 18:33:36.355328	\N	\N
51	1	hello	saas/menucategory/default.png	hello	0	2021-09-28 10:03:52.782218	\N	2021-09-28 10:04:34.105681
52	1	gg	saas/menucategory/default.png	gg	0	2021-09-28 10:04:39.051428	\N	2021-09-28 10:04:56.885498
56	1	h	saas/menucategory/default.png	h	0	2021-09-28 10:10:40.732248	\N	2021-09-28 10:14:15.758827
55	1	he	saas/menucategory/default.png	he	0	2021-09-28 10:09:58.635024	\N	2021-09-28 10:14:21.045016
57	1	ayush	saas/menucategory/default.png	ayush	0	2021-09-28 10:14:31.449006	\N	2021-09-28 10:14:36.558404
58	1	hello	saas/menucategory/default.png	hello	0	2021-09-28 10:23:19.339999	\N	2021-09-28 10:23:32.780688
59	1	h	saas/menucategory/default.png	h	0	2021-09-28 10:24:21.375237	\N	2021-09-28 10:26:09.204693
60	1	hdschsfg	saas/menucategory/default.png	hdschsfg	0	2021-09-28 10:25:01.931392	\N	2021-09-28 10:26:14.329828
34	20	jn1	saas/menucategory/default	jn1	0	2021-08-31 06:38:43.266863	\N	2021-09-29 18:00:17.004898
61	9	giftsss	saas/menucategory/default.png	G-274	0	2021-09-30 09:32:09.273135	2021-09-30 09:32:29.165661	\N
19	1	Soaps & Toothpaste	saas/menucategory/menu_category_icon_XwoPs6kh9y_1609860640.png	S&-143	0	2021-08-24 14:38:25.343374	2021-10-05 15:12:17.371205	\N
20	1	Dairy & Bread	saas/menucategory/menu_category_icon_sSGxafigGY_1609860588.png	D&-671	1	2021-08-24 14:38:32.33503	2021-10-05 15:12:18.753876	\N
7	4	fruits	saas/menucategory/default.png	F-885	1	2021-07-14 06:03:46.447162	2021-10-08 11:17:30.098921	\N
25	9	stationary	saas/menucategory/default.png	S-216	0	2021-08-25 09:28:14.305055	2021-10-08 13:26:02.299202	\N
37	22	T-shirt for men	saas/menucategory/default.png	t-shirt-for-men	1	2021-09-16 18:33:09.208777	\N	\N
38	22	T-shirt for women	saas/menucategory/default.png	t-shirt-for-women	1	2021-09-16 18:33:15.946272	\N	\N
\.


--
-- Data for Name: merchant; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchant (id, email, name, password_hash, active, phone, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at, image) FROM stdin;
2	simpi@gmail.com	simpi	$2b$12$Uy9rRNFuw1/nS4O1xXbwdekk1u63W1uRb8RUznvImGyVHtP4p5aS6	f	6546578687	merchant	\N	\N	2021-07-13 07:43:37.026858	2021-07-13 07:43:37.020632	\N	\N
3	sing@gmail.com	ranajeet	$2b$12$aijdFqjqfQ3N8R6A3YV7ae764K6ozXGD6.2KQvZIJDPjo7ovoCi/K	f	1234567890	merchant	\N	\N	2021-07-13 09:28:01.152507	2021-07-13 09:28:01.146182	\N	\N
1	merchant@gmail.com	Ritika prajapati	$2b$12$YDe8MXqsA9tsRWu4Q4jrh.6KWtWWPXiXM8mZFC3H2N5weQPZL5hxC	f	8757445651	merchant	\N	\N	2021-07-12 13:41:36.042155	2021-07-15 09:22:40.362303	\N	\N
4	merchant 1@gmail.com	merchant	$2b$12$KZMs34koA9v2y8vCTxzuH.NYWrTNd5USAKs9j7KhQhJ/h0FE78dz6	f	123456789	merchant	\N	\N	2021-07-16 18:16:48.471016	2021-07-16 18:16:48.46904	\N	\N
5	rohini@isl.net.in	Rohini Merchant	$2b$12$GI9BOlMZ.8wwQQ5GqoRBO.aZafPIwbusohl7dtby4/L/2cFp39Dga	f	987	merchant	\N	\N	2021-07-30 08:01:45.769067	2021-07-30 08:32:40.567721	\N	\N
6	check123@gmail.com	test1234	$2b$12$yS0u.g2nuKAGNAW.eLuJEezQJ9owErvQGO/WO1QopFPzCVDqIdn/C	f	0987654321	merchant	\N	\N	2021-07-30 13:24:22.167243	2021-07-30 13:24:22.165272	\N	\N
7	testandgohome@gmail.com	Parthib Ghosh	$2b$12$r5Yf/fKTxxwavaEl1y9S5emZYBEFqOBq9PvEGjQz652fXDRizfHa2	f	1111111111	merchant	\N	\N	2021-08-02 19:37:53.164267	2021-08-02 19:37:53.162343	\N	\N
8	testing@gmail.com	Testing	$2b$12$AVgLTSO0H86tcSopuj3TveOxXyjwhT3B5IC/F2ShykC/s5E7hg6Ji	f	2222222222	merchant	\N	\N	2021-08-05 16:37:33.811532	2021-08-05 16:37:33.804071	\N	\N
9	merchant2@gmail.com	The Merchant	$2b$12$AwBbtNOH5ZK65YvTSrStLeF9dydhOQL2Q.OxNN0iEAmPVXsrhAk5S	f	9876543210	merchant	\N	\N	2021-08-23 21:13:44.211112	2021-08-23 21:13:44.203414	\N	\N
10	xfbhzz@gmail.com	hhhh	$2b$12$SHJzH53S3YzO49tCaMaNXuTtoDbltISw6xSP.sc5pXtZn/h9V0Xb6	f	745242343	merchant	\N	\N	2021-08-24 10:41:45.657282	2021-08-24 10:41:45.649774	\N	\N
11	jjker@email.com	cccc	$2b$12$8Ii85jKFkyvhl4s9O.c/8.M49eLfktgXUVh.4USKQ6JJc6/RXTWAS	f	453434343	merchant	\N	\N	2021-08-24 10:48:17.175389	2021-08-24 10:48:17.167929	\N	\N
12	r@email.com	Mmmm	$2b$12$BWgp61qyOToFMt5B6q.ATuN2upyQGfHKFeXUz6HMpK1BfGam602N6	f	706464386	merchant	\N	\N	2021-08-24 13:42:38.108892	2021-08-24 13:42:38.101354	\N	\N
13	pm@go.com	Rana	$2b$12$7E/xI28DsuQjLsXWl1CO3OMBq8d1r4dfrK1LxkMSFslToObUGtKNu	f	9876543310	merchant	\N	\N	2021-08-24 14:13:19.005429	2021-08-24 14:13:18.998013	\N	\N
14	jjkhiluer@email.com	ramm	$2b$12$.P3l9.KcuJUQja9WTBITD.Iz31l7wgqeVbl77a4Ge5VLXeIVtVIGK	f	653535	merchant	\N	\N	2021-08-25 04:34:03.504974	2021-08-25 04:34:03.497295	\N	\N
15	iuytyjty@demo.com	eeeeeguk	$2b$12$WG5CIjvAGap9/ekYsQLp8ObBWCkjD5m.9t7PfGJW9/VbeVkNvVtbW	f	5638525432543	merchant	\N	\N	2021-08-25 04:35:37.772866	2021-08-25 04:35:37.765237	\N	\N
16	merchant1@gmail.com	Ritika	$2b$12$GvZSDQ037IIPxYQPbip1X.GF3yA3ivPvzw6VAv9fsRjWR6iKkvqxi	f	08757445651	merchant	\N	\N	2021-08-25 09:45:31.294784	2021-08-25 09:45:31.285712	\N	\N
17	rs@email.com	Rs	$2b$12$QtfGbtsTQOO9fahYP6c2kuLPFDnt6Hnuu39GJOaQ4VN5tiEA62p8W	f	5465863586	merchant	\N	\N	2021-08-25 13:25:52.215861	2021-08-25 13:25:52.208236	\N	\N
18	testandgohome1@gmail.com	Parthib Ghosh	$2b$12$JiF37lEOhhyG6maZjlqWfuYEfq1zX4C.zPy0tZ7BqEJufAByN6hXm	f	2323232323	merchant	\N	\N	2021-08-25 15:59:33.781352	2021-08-25 15:59:33.773842	\N	\N
19	testandgohome2@gmail.com	Parthib Ghosh	$2b$12$kGVrFn.AXleo0HaU4.miG.R9MFvtfvokFc0snyZ.tKrAMExIhy9sO	f	2345678901	merchant	\N	\N	2021-08-25 17:54:30.928375	2021-08-25 17:54:30.920898	\N	\N
20	ramm@gmail.com	ramm	$2b$12$3TdQX3j2369qn0q.I4AKoeMiM.qv29gGhLrCxcgC9V6UJNGJA4Q1e	f	7043825417	merchant	\N	\N	2021-08-29 02:19:48.161165	2021-08-29 02:19:48.153508	\N	\N
21	sssr@email.com	eeeee	$2b$12$UTn07OgDUSl.vHxldlhBK.2UTQBZDrdqdKn8ojXyV7ND6FpEFKIMK	f	2222222	merchant	\N	\N	2021-08-29 06:29:18.574848	2021-08-29 06:29:18.566831	\N	\N
22	sdcscd	wdwed	$2b$12$ENizEn.gn2RbbGJuPzPsmetbSFDtor92IlXAKXt6v4/g7NvYUL4CO	f	32435	merchant	\N	\N	2021-08-30 08:43:13.497782	2021-08-30 08:43:13.49005	\N	\N
23	hf	abc	$2b$12$6mU1uUkLarJdMTWBFU4Iyepeged.6JKkCvsbAEqD0As7YRaptH8Wu	f	6537245865	merchant	\N	\N	2021-09-16 09:19:53.397282	2021-09-16 09:19:53.388813	\N	\N
24	rohini@gmail.com	Ro	$2b$12$CAdR6qdlXYUW33AVLeAtc.XXB91w9jeDu8g2vEn/CcEWBWUGyGUae	f	1111111110	merchant	\N	\N	2021-10-08 13:20:01.040332	2021-10-08 13:20:01.038139	\N	saas/user/default.png
25	rohinipatilrp20@gmail.com	Ro	$2b$12$g3RmSFCYCedYGttX9TUzFe4I84iot5w2dQCjbhHn4tpMfcLSW1OMm	f	1234567891	merchant	\N	\N	2021-10-08 13:21:02.781007	2021-10-08 13:21:02.778806	\N	saas/user/default.png
26	testandgohome3@gmail.com	Parthib	$2b$12$SHzeDAgGGhhJwbRX5P4TuuVHoG0tM5llsF1K25mCuNPTGkvdaijjO	f	0000000000	merchant	\N	\N	2021-10-12 16:53:36.073367	2021-10-12 16:53:36.071111	\N	saas/user/default.png
27	rp@gmail.com	RP	$2b$12$.H3bZiqYCJv4A1GObbTz/.rcOrJBeMWXn5DJXiuvBx6IRdmmly2lO	f	1234567899	merchant	\N	\N	2021-10-14 06:16:06.898345	2021-10-14 06:16:06.886042	\N	saas/user/default.png
\.


--
-- Data for Name: merchant_otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchant_otp (id, "isVerified", counter, otp) FROM stdin;
\.


--
-- Data for Name: merchant_transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.merchant_transactions (id, store_id, user_email, user_phone, merchant_ref_id, payable_amount, gst, tcs, commission, benf_name, bank_name, ifsc, vpa, total_order_amount, account_number, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: misdetail; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.misdetail (id, date, daily_new_user, order_canceled, new_items_added, new_stores_created, average_order_value, total_order_value, total_discount_value, delivery_fees, commision, turnover, created_at, updated_at, deleted_at, order_delivered, total_tax) FROM stdin;
4	2021-09-23 00:00:00	0	1	0	0	0	0	0	0	0	0	2021-09-23 09:04:52.64766	\N	\N	0	0
1	2021-08-19 00:00:00	0	0	0	0	0	0	0	0	0	0	2021-08-23 21:49:15.543365	\N	\N	0	0
2	2021-08-09 00:00:00	2	0	0	0	0	0	0	0	0	0	2021-08-23 21:50:03.834886	\N	\N	0	0
3	2021-08-26 00:00:00	0	3	3	0	5930	5930	80	350	0	6200	2021-08-27 03:10:30.961773	2021-08-27 03:11:19.852224	\N	0	0
\.


--
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, user_id, uid, target, text, not_type, message, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: notification_templates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification_templates (id, dlt_template_id, template, name, t_type, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: progress; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.progress (id, user_id, uid, store_id, total, success, skipped, status, created_at, updated_at, deleted_at) FROM stdin;
3	1	0db65af9-c25e-44df-b9fb-1a123fb5a622	1	80	71	9	0	2021-08-31 19:06:48.491074	2021-08-31 19:06:49.658153	\N
2	1	fed7c821-cd8e-4694-a4d8-1d6083dc45eb	1	80	71	9	0	2021-08-31 19:00:18.904089	2021-08-31 19:00:20.124126	\N
1	1	5c44c423-058d-448e-b25c-17f653fb4b46	1	80	71	9	0	2021-08-31 18:59:49.442988	2021-08-31 18:59:50.624701	\N
\.


--
-- Data for Name: quantity_unit; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.quantity_unit (id, name, short_name, conversion, type_details, status, created_at, updated_at, deleted_at) FROM stdin;
2	Liter	Ltr	string	volume	1	2021-07-12 19:46:16.379499	2021-07-12 19:47:34.890652	2021-07-12 20:26:10.638858
1	Kilogram	kg	string	string	1	2021-07-12 19:38:03.262881	\N	2021-07-12 20:29:55.905193
3	Kilogram	kg	string	weight	1	2021-07-12 20:30:06.276082	\N	\N
4	litre	LT	string	weight	1	2021-07-19 17:37:38.146626	\N	\N
5	gram	GM	string	weight	1	2021-07-19 17:37:59.578998	\N	\N
7	Piece	pc	string	piece	1	2021-08-01 13:48:52.81921	\N	\N
6	new	no	string	haha	0	2021-07-19 17:38:32.042137	2021-08-01 13:59:58.355896	2021-08-01 16:15:32.560125
8	Dummy	dummy	string	dummy	1	2021-08-01 13:59:24.281986	\N	2021-08-01 16:16:24.809863
\.


--
-- Data for Name: refund; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refund (id, order_id, txnid, amount, refund_method, gateway, issued_by, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.session (id, user_id, auth_token_hash, session_start_time, session_end_time, os, created_at, updated_at, deleted_at) FROM stdin;
1	13	e173c5062bae03fb9dd01ecf1334c4d04135d19e2a66939edf435127138e6ccd	2021-10-06 13:33:03.935254	\N	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:92.0) Gecko/20100101 Firefox/92.0	\N	\N	\N
2	7	92cc9a4f4606ed9186b8646dd73c3250fe8844e1b9dea6c8777def806965c02a	2021-10-06 16:16:04.082192	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
3	13	1ce7ffe0555232244fb102ebc90fdd6bd1c25749d01cf8510891e0d81924668f	2021-10-06 16:52:54.853044	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
4	9	3631cfea7923b5c677fce4c15d76a1124eca138cb421c11ab8f55ec6a0388567	2021-10-06 18:29:41.353752	\N	Ktor client	\N	\N	\N
5	9	75761cd7bae196b0a876316deabd1c5b41096b748f595374077ffa64715f5c5c	2021-10-06 19:43:55.477156	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
7	13	9e1cc5f8ea01bf618891c824040303ed0822bb659eac278a8c293951103bbf44	2021-10-07 04:43:33.188975	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
6	13	02c8fd138452929cf498ca44f0511b3a351c7e6f14ba1f6536c62d4c2158cc7a	2021-10-07 04:26:23.105346	2021-10-07 04:44:14.809166	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
8	13	00f0db8137ca6b59cf8433e2cd6f9c33307b15c549d80d752f9ee138896dc3b7	2021-10-07 04:45:46.444597	2021-10-07 04:45:59.905428	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
9	13	8cf7d5523693111999499f0d3e610d5aec4fd8c93f9b49afd24f919ba3a0b477	2021-10-07 04:46:23.742849	2021-10-07 04:46:37.150609	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
10	13	83994e3b540904a50286b1e9e5490ac8547d8d34404f54d5e132349da87c802a	2021-10-07 04:46:42.180558	2021-10-07 04:46:50.485208	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
11	13	3daec60933f616443091a5584889bb31492ca90cb55fe77634edf282676cfa09	2021-10-07 04:58:27.099054	2021-10-07 04:58:44.619371	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
12	13	e850d1e383e4afcff264dcc432ce81bfb7c68fe3ae09c3b6ace9f9b68fc0500e	2021-10-07 04:58:53.962284	2021-10-07 05:03:40.447575	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
13	13	482a4df0651cab52708ab7a7b7fc0c7b40262ce2dc8354a631c801f5c39e8fa2	2021-10-07 05:03:46.482579	2021-10-07 05:04:07.099716	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
14	13	cf954ffa9b40b9bceddff2cc9d82b411a5cb0df924e005eb0406295867a29e43	2021-10-07 05:04:15.61038	2021-10-07 05:04:20.921644	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
15	13	4d1996d17837776154388da94fb70b9bb3646f8cdcc0f27b7932427355b20671	2021-10-07 05:04:24.958308	2021-10-07 05:04:44.089447	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
16	13	ca53567c003275479e8813257541068a80cd4339602bb96e7616d1824bbd15bf	2021-10-07 05:09:35.997387	2021-10-07 05:09:47.409158	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
17	13	f9a41acfac32762104ae614f163cb9e8d404ceb7053b4df6247ae264fe56b800	2021-10-07 05:10:06.366786	2021-10-07 05:12:49.741307	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
18	13	9fe3f2200baa2ec8dc524d6d71c0aefafc1353d51cde58100fefcfe00cd2c44a	2021-10-07 05:12:58.442466	2021-10-07 05:13:33.176797	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
19	7	ad88872c12187456a8770e4fb0c8d4d419e38506970445c06abd62aaee7dea17	2021-10-07 07:14:59.114205	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
20	13	6d5d090089c28df082d17b5d375bfc603242bcbb8831c06c955dd8400eb46890	2021-10-07 07:19:51.049698	2021-10-07 07:20:40.877364	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
22	13	655581f8027a1432a40990bd410df7558bb3e3407182ad28efea08fa5c7c6569	2021-10-07 07:38:02.069397	2021-10-07 08:33:38.462511	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
23	13	f56d0ac920b92bbd03c41ce012e03c3b5af43df35ecbe5fe8d26f07e55d1b94c	2021-10-07 08:33:49.400092	2021-10-07 09:07:50.615701	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
24	13	1d94cbe0c44063eb17897191e15ba78da4e3fd0ea0cbbd6376bc1b3669c08dcd	2021-10-07 09:07:53.808573	2021-10-07 09:21:50.354467	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
25	13	46c65a60fd91497941421cdcc8c7315ec809a65be9eae1dbbbbff62a59f94ac7	2021-10-07 09:21:53.056243	2021-10-07 09:42:07.12258	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
26	13	d1a92010dd60904f34eba49a11ec488f83942a67790ac59da2e51387ea22cc4f	2021-10-07 09:42:18.264182	2021-10-07 09:42:24.989336	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
27	13	fc7f9eddcdedc10826415349ad605bc865411224af273a7027891aad0e984796	2021-10-07 09:47:32.649477	2021-10-07 10:26:22.589588	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
28	13	98b9fb1f6e1af2790efd0614044f1206725406c62b450751b32cc80adeb54878	2021-10-07 10:26:27.725714	2021-10-07 10:28:08.586356	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
29	13	5f7c524db44483f0c92d119410c92ae5ba0a00d5e7a59429ede6c1056c1461c2	2021-10-07 10:28:25.396942	2021-10-07 10:30:48.168626	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
30	13	8bbd08e7f8235305ed0b8ede5f85cb34f3ce340bed770f487a2957680373061c	2021-10-07 10:45:46.164798	2021-10-07 10:45:48.034256	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
31	4	49a45b3ed36bbfea06dab06ba17cfc545b7a0dbc5bb5ae4473e32545fce32144	2021-10-07 10:46:00.55929	2021-10-07 10:46:06.108112	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
21	13	32f638ee145aba3f91acd921cad91bb67a1be78a71fa47bb1379f5040bd78f88	2021-10-07 07:27:17.498514	2021-10-11 05:27:37.880643	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
32	4	db86586c88ff55bc4434c7156293164ded06a73726ac761e2ea59c9aa1b8cb7b	2021-10-07 10:46:17.318588	2021-10-07 10:46:23.952397	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
33	4	fe66c98397761588e967c0aaa67944ab9e41a98a60d21441aab57abe2fe9f31b	2021-10-07 10:48:28.971772	2021-10-07 10:48:31.859136	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
34	4	8c3e569147aa306f8fcfcb35ec44305f26a7a74950d5756a5e4781a55c699b95	2021-10-07 10:48:37.127648	2021-10-07 10:48:43.242264	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
35	4	7ea1c2229db44d3f24116f990e4a9427a80b114d0969de667f94cb699ea8065d	2021-10-07 10:48:47.316327	2021-10-07 10:48:49.673201	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
36	12	9a48515dd68a4ad7ad00874bf04a9f82ec035082738b45235df0156072f2d067	2021-10-07 10:51:29.599412	2021-10-07 10:51:34.109489	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
37	12	72e03e1d90af92b1f8aa246eb4448797ac6a328c217919e9b383df49abe36bf7	2021-10-07 10:53:30.710419	2021-10-07 10:53:33.189046	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
39	13	36a471ef9db64c4aa9643f79c4fe1fb67606e1902e7a1ce74e2f9d1c93529ff3	2021-10-07 11:11:51.847067	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
38	12	87f1089d62a5d44c6c12ecb4ab88ab8556f35965af013c37070feafb01edd03b	2021-10-07 10:55:18.061779	2021-10-07 11:13:07.208398	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
40	13	2c28d57be3eda7270df983d0b6588ddb8920db8abc54bdae5b732b0f7aaa9bea	2021-10-07 11:13:18.568901	2021-10-07 11:42:27.852639	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
41	12	bc84c90aa60d96a516d420495c9a9c763c58b6ed328055ae60d01548a5183c9b	2021-10-07 12:16:06.302324	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
42	12	bee86201ad99b35cb650100a55328fe3e9d1ff8427ed3e01c7cea073b033331a	2021-10-07 12:21:48.329358	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
43	12	8be50bea5ff44b761eef0d6845b368812a0d31bb738e749b0f56af410f931589	2021-10-07 12:57:17.187958	2021-10-07 13:00:00.774278	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
44	12	b00dcbd49d6b85bbdc74b5f2e0a205e2d7137fe966c1bda842a993183f66057e	2021-10-07 13:04:54.946565	2021-10-07 13:04:57.228541	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
45	12	59752218cef7f00b6464abd2944d1f4ebd453c85202f7babf953bcd1330e09cf	2021-10-07 13:05:00.95173	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
46	12	130d8ebfa07b3e032c630555e10b32ad76fa74e7a9dd270d4b1f0cee6e8ef738	2021-10-07 13:26:42.751034	2021-10-07 13:27:33.505148	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
47	12	154b452478adda4bc9983a09206238f3acf6a6006664b43146691b08c5042b45	2021-10-07 13:33:39.215403	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
48	12	baea75b48370658b53cb69b7566c4bb39659ee3c10ce399bf62f6d491c027c57	2021-10-07 13:34:41.51583	2021-10-07 13:34:55.580729	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
49	14	4e68be8e2fd4342e7efeb41fe335c89f100c0531afdf87fa25518bf86e91c678	2021-10-07 13:37:17.826634	2021-10-07 13:37:22.338409	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
50	4	56fa51b45c719a93d1e3dcea9c09af39cfebc7ef79ba53dd481c0954fe86bc9d	2021-10-07 13:37:47.291454	2021-10-07 13:50:48.305861	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
52	4	8d2497942f3f33a56d15fc46b9461ccf56dd5a75f7856ab7247f116b4217c594	2021-10-07 14:03:17.840602	2021-10-07 14:14:09.867118	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
51	7	ae86bca0422352898eef58d607e33ae8cb781535e23d59edb9bba70b62c742e4	2021-10-07 13:53:25.150979	2021-10-07 14:22:08.887427	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
54	7	3f676ad72fbb9a26bfd00db3a8f0248f42d74338a1496ddf0765450209f62f75	2021-10-07 14:23:05.649455	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
53	4	77a056654a7e7be086cba0a580c52757fe4ae86cdc425cdd89b1b71cfdf9d447	2021-10-07 14:18:07.394683	2021-10-07 14:28:56.410839	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
55	4	febee4aacd6d57a2eb87c5baf040458d629892ab139d7ae733bf5bbb9c8e012c	2021-10-07 14:29:49.367444	2021-10-07 14:29:58.271905	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
56	4	890001258aebea82fe7f923281633343b034b92474d3202d65c5b8aed970a223	2021-10-07 14:31:06.161299	2021-10-07 14:31:11.859496	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
57	4	a1f2cf41bbafa420546e140e0ff46c9c0fc8ef878c34443b15baf1a92d287c52	2021-10-07 14:31:27.742774	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
61	7	f190aec14d0ce2bc0887e6e4b87693bb0f2fb696f6b5eeaa96a4d1488064b10e	2021-10-08 08:36:35.28574	2021-10-08 08:36:48.619665	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
60	7	5ab95090149a65e288b971f5183e01e3879ab82a167094dee9445392b77d8a05	2021-10-08 08:22:42.007819	2021-10-08 08:46:26.335615	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
59	4	8212aa83206e4f98e4980e70a0d1a89961e7667f46585ca23b7a3aeb6df7ec2f	2021-10-08 07:41:14.276486	2021-10-08 10:18:14.88105	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
58	13	a6bc2a8aba04731724f44bc8288d109f19c695459ad72f30414716fa9eae66de	2021-10-08 06:21:03.793718	2021-10-08 10:22:18.716942	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
62	7	97284eda610f8fd22a304ff4b1c8fd19f1940a9f15c6712ec771284ff60c7859	2021-10-08 08:37:04.672253	2021-10-08 08:37:11.856325	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
63	7	11532b5b800cf4446959bdbf14dcae14447a1e2432e86bfb14e4c19ff54c9655	2021-10-08 08:46:38.407056	2021-10-08 09:34:56.908224	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
65	4	b5b9de8aa075b43b5bd37cfe0ed473f2d8e7b6e198d8d5ebe7b3306ef1f3cb33	2021-10-08 10:18:22.356492	2021-10-08 10:21:34.055576	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
64	7	4fd359091d971bd2f10cc1de0d637b20a7e8d6e3ec78bb42f17d9b053b4cd700	2021-10-08 09:35:06.24126	2021-10-08 10:25:22.823543	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
68	7	4408be0691378092e0522ad4d3e6a7a69243c6db98774ca718b2fd10f125418b	2021-10-08 10:27:20.61138	2021-10-08 10:27:47.280974	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
69	7	2131a84adca7147688435f64d0836b77ea01cd53b552776ae69eea7d2f8b5e29	2021-10-08 10:28:31.338571	2021-10-08 10:28:40.635502	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
70	7	560664cae96bd132cda504a83e0f26c89b8f19cf6a9ea2259c66ad2fac6f2796	2021-10-08 10:28:44.448693	2021-10-08 10:28:55.716708	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
67	4	ff1134a9ebb58dde92181273199d35e3371ff614784a6ba005ce9856c2ed37d1	2021-10-08 10:22:35.130431	2021-10-08 10:32:43.636694	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
66	4	e90dba723f67b54e48bfacbd84ecb0c44432be96284624c5eba4984dec5e130a	2021-10-08 10:21:38.287305	2021-10-08 10:49:49.053628	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
73	4	f52b000d8b49e4cac5a9ee8047ae8db3048c63dcd71bea41dc5dad7ddef4a758	2021-10-08 10:50:00.110511	2021-10-08 11:09:01.381172	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
74	4	3bae007118f47dba31cf24eb5691494cdb037aec0271ed6e10aa8a0ef2fd361c	2021-10-08 11:09:06.90922	2021-10-08 11:09:18.700946	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
75	13	5db79222372eaa0c751f86f92cc7c6af96c204e5c39a2a010e38711b0e593a59	2021-10-08 11:09:24.824994	2021-10-08 11:45:30.299865	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
76	13	cbc5b0eeaa3ae7d29bf9fa402b17eda5b97c513156e433b6bbef56b95baed2a5	2021-10-08 11:45:33.221926	2021-10-08 11:59:05.459514	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
77	13	6f36c36f18606b370cff8cc0f232addd00c697722958d48ec1f7aaf71b96ff41	2021-10-08 12:38:27.391796	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
78	13	cc4c17638aebd8f69ce47ef4e0f8b97c4a3cb01d7cb3ce2ce0a027e27aaac9b8	2021-10-08 12:42:42.841691	2021-10-08 12:43:02.051247	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
79	13	2535e25e45967769ded5dba21c4d14e0d477bfcd98372573650070fbafc49620	2021-10-08 12:44:41.598173	2021-10-08 12:53:05.478729	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
72	4	25cabbb57c8f8bfceaaba0ecfa10272d981022a64c95bb1b2dcf2fcb6daa292d	2021-10-08 10:32:51.031409	2021-10-08 13:01:15.150005	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
71	7	c3841ce351d916c51b15e3076189178327a9884ab9fd9c53849417912e96a25e	2021-10-08 10:28:59.00028	2021-10-08 13:20:14.114932	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
81	7	ccd7b6fa12f21545e1f753f8bd0ef88db73de9164db61bde6590b1d54f44c5ce	2021-10-08 13:31:08.159343	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
82	13	01568b6f91d09c1db3eb125473ed922316b614c0ee7feabf08c6002130ac06de	2021-10-08 13:43:35.150552	\N	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4515.159 Safari/537.36	\N	\N	\N
84	7	dcd80ccbb8b1ad0bb3e6951e9eb9d5045f0aa3242b18458675838d8687ba3df3	2021-10-11 05:22:45.844829	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
85	13	6e7b26471fe8bfb8a9919dcc5cbcbf28f65f93a0d1daeb3c34b7bcab3344c9a8	2021-10-11 05:27:46.300954	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
86	9	42a4b9f4b2031729331128186213d98a546c4bf997483758c51fe00fe7639c7d	2021-10-11 15:54:45.001766	\N	Mozilla/5.0 (Windows NT 6.2; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36	\N	\N	\N
87	9	61319ac4857cab650dbe56b77ee62d75dadbbc3dd76e4ae776db2cc0b82eea92	2021-10-11 16:17:53.91009	\N	Mozilla/5.0 (Windows NT 6.2; Win64; x64; rv:91.0) Gecko/20100101 Firefox/91.0	\N	\N	\N
88	7	a299e61d4df2bbec1393d8ebeb845507f30e2b7e71ff8bca78d2bd864846bc0f	2021-10-12 13:57:26.832084	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
89	13	d5dcdbd7e8769c1890b419a894f0a39dee1f1a7671e3c28d9601d9da251d65dc	2021-10-13 09:37:36.899602	\N	Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:93.0) Gecko/20100101 Firefox/93.0	\N	\N	\N
80	13	c430dffd595a382e05c5d16353424360f71167bfa237827835022690b7061f98	2021-10-08 13:04:50.228693	2021-10-13 12:40:13.631011	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
91	9	9d80429381c1b9a3ec78cd1271b75f21d754160efd1860fb1f24af3afaac6af7	2021-10-13 17:57:05.808476	\N	Mozilla/5.0 (Linux; Android 9; SNE-LX1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.85 Mobile Safari/537.36	\N	\N	\N
92	7	56e426436cf4db07d2e145f0d52cc5cd3459d4466ab064587815b9bad82ceb10	2021-10-14 06:50:06.630678	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36	\N	\N	\N
83	13	6a25223c886f4e434d6b9f5d96658e796bb6d33cfb90426f9afdc426a1f73534	2021-10-08 15:13:40.113816	2021-10-17 15:18:59.291793	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
90	13	f0ea169d2737b48d2ad9b573243cfdc3c7c3b97154c6450440b6a7b2b0af658b	2021-10-13 12:40:16.843726	2021-10-17 15:21:38.792283	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36	\N	\N	\N
93	19	6c1baa2bf0504062623a78fb03b0d96613765f2c30c0c498725a6eac309a3c95	2021-10-17 15:23:56.155109	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36	\N	\N	\N
94	19	1b9b59373042b6d6d8a0ad13fa48bd1487e100671b24cbc0082a370122fb3de4	2021-10-17 15:24:57.984824	\N	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.81 Safari/537.36	\N	\N	\N
\.


--
-- Data for Name: store; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store (id, name, slug, owner_name, shopkeeper_name, image, address_line_1, address_line_2, store_latitude, store_longitude, pay_later, delivery_mode, delivery_start_time, delivery_end_time, radius, status, created_at, updated_at, deleted_at, city_id, commision, walkin_order_tax, da_id, self_delivery_price) FROM stdin;
31	xyz	xyz	abc	djdvbv	saas/store/default.png	28, Dumra Rd, Sharif Colony	Chak Rajopatti, Bihar 843302, India	26.5895133000000001	85.5007503000000071	1	1	2021-09-16T03:30:46.000Z	2021-09-16T15:30:46.000Z	10	1	2021-09-16 09:19:53.394373	\N	2021-09-16 09:50:27.041847	19	\N	0	\N	0
33	Test Store	Test Store	Atrayan	Nobody	saas/store/default.png	CF59+WXR নিমাই নস্কর এর বাগান, Bhanta	West Bengal 700150, India	22.410007199999999	88.4694440999999898	1	1	2021-09-2300:22:53	2021-09-2300:22:53	50	0	2021-09-22 18:54:22.048512	2021-09-28 06:53:27.182556	\N	19	\N	0	\N	0
36	Test Store 2	test-store-2-9a592ca2-294f-48e4-9c86-dfd8c4c7d6bb	AtrayanM	MAtrayan	saas/store/default.png	CF59+WXR নিমাই নস্কর এর বাগান, Bhanta	West Bengal 700150, India	22.410007199999999	88.469444100000004	1	1	2021-09-2301:05:40	2021-09-2301:05:40	20	1	2021-09-22 19:37:54.206965	2021-09-23 12:31:18.12428	\N	19	\N	0	\N	0
34	Test Store	lower(:lower_1)-7a7d8854-bc21-4712-99f8-186d788ba19a	Atrayan	Mukherjee	saas/store/default.png	CF59+WXR নিমাই নস্কর এর বাগান, Bhanta	West Bengal 700150, India	22.410007199999999	88.469444100000004	1	1	2021-09-2300:55:57	2021-09-2300:55:57	200	0	2021-09-22 19:29:43.2009	2021-09-25 01:40:37.468906	\N	19	\N	0	\N	0
22	Rs store	rs-store	Rs	Rs	saas/store/default.png	Kolkata	Kolkata	23.3980628999999993	87.1105270000000047	0	1	2021-08-25T04:30:26.000Z	2021-08-25T10:30:26.000Z	20	0	2021-08-25 13:25:52.213177	2021-09-17 13:49:15.745198	\N	19	10	0	\N	\N
14	afaf	afaf	bgbb	b	saas/store/default.png	bankura	bankura	55	555	1	0	2021-08-2415:39:00	2021-08-2415:39:00	6	1	2021-08-24 10:09:26.942695	2021-08-24 10:40:14.578541	2021-08-24 10:50:18.421362	2	\N	0	\N	\N
13	hgg	hgg	bgbb	b	saas/store/default.png	bankura	bankura	55	555	1	0	2021-08-2415:21:00	2021-08-2415:21:00	6	1	2021-08-24 09:52:43.810293	2021-08-24 10:40:11.488826	2021-08-24 10:50:21.163428	2	\N	0	\N	\N
15	hhhhh	hhhhh	hhhhhh	hhhhh	saas/store/default.png	bankura	bankura	55	555	0	0	2021-08-2416:10:47	2021-08-2416:10:47	6	1	2021-08-24 10:41:45.654628	\N	2021-08-24 10:50:23.933356	2	\N	0	\N	\N
16	r	r	r	b	saas/store/default.png	bankura	bankura	22.9867568999999996	87.8549754999999948	0	1	2021-08-2416:11:58	2021-08-2416:11:58	4	1	2021-08-24 10:48:17.172795	\N	2021-08-24 10:50:27.023389	2	\N	0	\N	\N
17	Mmmm	mmmm	Mmmm	Mmmmm	saas/store/default.png	bankura	bankura	23.3980135000000011	87.110640900000007	1	1	2021-08-2419:11:04	2021-08-2419:11:04	1000	1	2021-08-24 13:42:38.106252	\N	2021-08-24 13:45:10.083127	2	\N	0	\N	\N
24	Parthib clothes	parthib-clothes	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1, 15th Cross Rd, NGR Layout, Roopena Agrahara	Bommanahalli, Bengaluru, Karnataka 560068, India	12.9097897132476103	77.6254553974199837	1	1	2021-08-25T03:30:19.000Z	2021-08-25T18:29:19.000Z	20	0	2021-08-25 17:54:30.925801	2021-09-17 13:49:30.536652	\N	2	\N	0	\N	\N
9	ParthibStore	parthibstore	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1st Cross	BTM	12.9282981567824375	77.6090234107554551	0	1	09:00:00	22:00:00	10	1	2021-08-03 16:26:56.528969	\N	2021-08-25 15:18:11.620773	2	\N	0	\N	\N
6	string	string	string	string	saas/store/default.png	string	string	0	0	0	0	string	string	0	1	2021-08-02 19:48:48.599045	\N	2021-08-25 15:18:20.931601	1	\N	0	\N	\N
7	ParthibStore	parthibstore	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1st Cross	BTM	12.9282981567824375	77.6090234107554551	0	0	string	string	0	1	2021-08-02 20:01:46.8945	\N	2021-08-06 16:46:11.436713	\N	\N	0	\N	\N
28	qsuh	qsuh	jusuq	qjsu	saas/store/default.png	Unnamed Road, Bazar Samiti, Bhabdepur	undefined, undefined, undefined	26.5965384	85.509712499999992	0	1	2021-08-3011:35:18	2021-08-30T18:05:18.000Z	9	0	2021-08-30 06:06:24.008878	2021-09-17 12:46:35.855518	2021-09-20 13:05:44.179301	19	\N	0	\N	\N
3	rana store	rana-store	Ranajeet	Ranajeet 	saas/store/default.png	mumbai	mumbai	19.0759836999999983	72.8776558999999935	1	1	2021-07-13T02:30:14.000Z	2021-07-13T10:30:14.000Z	1000	1	2021-07-13 09:28:01.149813	\N	2021-07-21 14:31:53.887794	\N	\N	0	\N	\N
5	Rohini book store	rohini-book-store	myself	me	saas/store/default.png	book1	book2	11.6122271304238769	79.4857814064076962	1	0	9:00	21:30	20	1	2021-07-30 09:39:06.508165	\N	2021-07-30 09:47:54.643623	\N	\N	0	\N	\N
4	Rohini book store	rohini-book-store	myself	me	saas/store/default.png	book1	book2	11.6122271304238769	79.4857814064076962	1	0	9:00	21:30	20	1	2021-07-30 09:30:43.821632	\N	2021-08-25 15:53:51.91668	2	\N	0	\N	\N
12	The Store	the-store	The Owner	The keeper	saas/store/default.png	string	string	21	22	0	0	string	string	10	1	2021-08-23 21:13:44.208399	2021-10-08 04:37:37.920179	\N	1	\N	0	\N	\N
30	qwere	qwere	vdfd	ddc	saas/store/default.png	28, Dumra Rd, Sharif Colony	Chak Rajopatti, Bihar 843302, India	26.5897381999999993	85.5009536000000026	1	1	2021-08-29T20:42:21.000Z	2021-08-3014:12:21	8	1	2021-08-30 08:43:13.495119	\N	2021-08-30 08:45:24.884387	19	\N	0	\N	\N
8	ParthibStore	parthibstore	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1st Cross	BTM	12.9282981567824375	77.6090234107554551	0	1	09:00:00	22:00:00	10	1	2021-08-03 16:26:40.593946	\N	2021-08-06 16:43:09.575365	2	\N	0	\N	\N
2	Simpi's	simpi-s	simpi	simpi	saas/store/default.png	Lokhandwala	Mumbai	19.1435999999999993	72.8246000000000038	1	1	2021-07-13T01:42:24.000Z	2021-07-1313:12:24	6	1	2021-07-13 07:43:37.024039	\N	\N	1	\N	0	\N	\N
19	iiiiii	iiiiii	bgbb	g	saas/store/default.png	Bengaluru	Bengaluru	19.0759836999999983	555	1	1	2021-08-2510:01:11	2021-08-2510:01:11	1000	1	2021-08-25 04:34:03.502249	\N	2021-08-31 15:09:20.742082	2	\N	0	\N	\N
29	jhkjd	jhkjd	fjbj	fdg	saas/store/default.png	Unnamed Road, Bazar Samiti, Bhabdepur	undefined, undefined, undefined	26.5965384	85.509712499999992	1	1	2021-08-29T18:33:02.000Z	2021-08-3012:03:02	10	1	2021-08-30 06:33:59.154178	2021-08-30 10:33:03.232052	2021-08-31 15:09:32.231885	1	\N	0	\N	\N
26	xfhdz	xfhdz	dfnxf	dzgnd	saas/store/default.png	Bengaluru	Bengaluru	26.7271011999999999	88.395286100000007	1	0	2021-08-2911:58:32	2021-08-2911:58:32	1000	1	2021-08-29 06:29:18.571872	\N	2021-09-16 10:20:23.057024	2	\N	0	\N	\N
25	ranaaaa store	ranaaaa-store	ramm	ramm	saas/store/default.png	Mavalli, Bengaluru, Karnataka 560004	Mavalli, Bengaluru, Karnataka 560004	26.7271011999999999	88.395286100000007	0	1	2021-08-2907:45:24	2021-08-29T14:15:24.000Z	1000	1	2021-08-29 02:19:48.158527	2021-09-18 02:08:26.52805	\N	2	5	0	\N	\N
21	kolkata store	kolkata-store	Ritika	Ritika Prajapati	saas/store/default.png	Ground Floor, 25B, Park St, Road, 	Kolkata, West Bengal 700016	22.5534503999999991	88.3530063000000041	0	1	2021-08-25T03:30:03.000Z	2021-08-25T15:30:03.000Z	10	1	2021-08-25 09:45:31.291017	2021-09-27 10:13:51.489134	\N	19	10	0	\N	\N
20	dfgssg	dfgssg	sgs	sgsg	saas/store/default.png	Bengaluru	Bengaluru	19.0759836999999983	555	1	1	2021-08-2510:04:16	2021-08-2510:04:16	1000	1	2021-08-25 04:35:37.77017	\N	2021-08-31 15:09:16.545316	2	5	0	\N	\N
27	Meat & Fish	Meat & Fish	Test	Test	saas/store/default.png	string	string	0	0	1	1	string	string	0	1	2021-08-30 03:43:53.442205	2021-09-17 13:58:57.833064	2021-09-17 14:02:48.593475	19	\N	0	\N	\N
10	Testing	testing	Testing	Testing	saas/store/default.png	BTM	1st cross	12.9282508861864098	77.6090361260974362	0	0	0	11:00:00	5	0	2021-08-05 16:37:33.808651	2021-09-17 13:51:49.576357	\N	2	1	0	\N	\N
18	Test Store	test-store	Pallab	Pallab	saas/store/default.png	Sahar Airport Rd	Navpada, Marol, Andheri East,	19.1038247000000005	72.8746064000000047	1	0	2021-08-24T02:04:47.000Z	2021-08-24T14:17:47.000Z	10	1	2021-08-24 14:13:19.002877	\N	\N	1	5	0	\N	\N
40	Parthib Meat Shop	parthib-meat-shop-bengaluru	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1st Cross Rd	BTM	12.9283358420645893	77.6090110262565105	1	1	2021-10-11T18:31:27.000Z	2021-10-12T18:29:27.000Z	10	1	2021-10-12 17:03:27.747993	2021-10-12 18:46:18.176402	\N	2	\N	1	1	20
38	Nilgris	nilgris-kolkata	anuraj	anuraj	saas/store/default.png	28, Dumra Rd, Sharif Colony	Chak Rajopatti, Bihar 843302, India	26.5894818999999991	85.5007776000000064	0	1	2021-10-07T03:30:10.000Z	2021-10-07T13:29:10.000Z	40	1	2021-10-07 10:50:11.344185	\N	\N	19	\N	1	1	40
35	New Test Store	lower(:lower_1)-1e9e43ba-2954-4c38-88d2-4e06f6f75c4c	Mukherjee	Atrayan	saas/store/default.png	CF59+WXR নিমাই নস্কর এর বাগান, Bhanta	West Bengal 700150, India	22.4100083999999988	88.4695765000000023	1	1	2021-09-2300:59:43	2021-09-2300:59:43	20	1	2021-09-22 19:36:01.859797	2021-10-05 15:51:18.055386	\N	19	\N	0	\N	0
1	Ritika's Store	Ritika's Store	Ritika	Ritika Prajapati	saas/store/default.png	Lokhandwala	Mumbai	19.1435999999999993	72.8246000000000038	1	0	2021-09-17T03:30:21.000Z	2021-09-17T15:30:21.000Z	50	1	2021-07-12 14:36:14.249351	2021-10-05 15:54:57.832582	\N	1	5	0	1	50
37	Anuraj	anuraj-a029342d-0120-4c1c-bd7d-84b996a84cee	Anuraj	Anuraj	saas/store/default.png	3B,3A, Lebutala, Bowbazar	Kolkata, West Bengal 700014, India	22.5655000000000001	88.3653000000000048	1	1	2021-09-28T03:30:44.000Z	2021-09-28T15:30:44.000Z	10	1	2021-09-28 17:21:52.998467	2021-10-08 08:10:27.157159	\N	19	5	0	\N	0
23	ParthibStationary	ParthibStationary	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	1, 15th Cross Rd, NGR Layout, Roopena Agrahara	Bommanahalli, Bengaluru, Karnataka 560068, India	12.9095599000000014	77.6254787000000022	1	0	2021-08-24T19:35:00.000Z	2021-08-25T18:29:00.000Z	20	1	2021-08-25 15:59:33.778731	2021-10-12 16:46:01.177366	\N	2	25	0	\N	\N
32	Parthib Garments	parthib-garments	Parthib Ghosh	Parthib Ghosh	saas/store/default.png	96, 1st Cross Rd, Tavarekere, Krishna Murthi Layout	S.G. Palya, Bengaluru, Karnataka 560029, India	12.9280740999999999	77.6090513000000044	1	1	2021-09-16T18:31:38.000Z	2021-09-17T18:29:38.000Z	30	1	2021-09-16 18:39:42.837381	2021-10-11 16:24:21.12311	\N	2	10	0	\N	0
11	Rohini store	rohini-store	Rohini	Me	saas/store/default.png	Koramangala	Bangalore	12.9321839999999941	77.6228108306871007	1	1	2021-10-06T03:50:34.403Z	2021-10-06T16:11:34.404Z	20	1	2021-08-11 11:33:47.063253	2021-10-11 05:19:19.129266	\N	2	5	0	1	20
41	RP store	rp-store-bengaluru	RP	RP	saas/store/default.png	3-B, Chamundeshwari Layout, Doddabommasandra	Bengaluru, Karnataka 560013, India	12.9339666306521295	77.6215302724208698	1	0	2021-10-14T05:00:46.000Z	2021-10-14T14:30:46.000Z	20	1	2021-10-14 06:16:06.895324	\N	\N	2	\N	1	1	30
39	Rohini Grocery	rohini-grocery-bengaluru	Patil	Patil	saas/store/default.png	45, HRBR Layout 1st Block, HRBR Layout, Ramamurthy Nagar	undefined, undefined, undefined, undefined	13.0206268000000005	77.6478852000000046	1	1	2021-10-11T04:00:22.000Z	2021-10-11T17:30:22.000Z	30	1	2021-10-11 05:15:07.505284	2021-10-11 05:19:23.706806	\N	2	\N	1	1	25
\.


--
-- Data for Name: store_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_categories (id, store_id, category_id, status, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	1	2021-07-12 14:39:10.618814	\N	2021-07-13 01:45:42.776789
2	1	1	1	2021-07-13 01:45:51.415816	\N	2021-07-13 02:13:14.631337
3	1	2	1	2021-07-13 01:45:51.418909	\N	2021-07-13 02:13:18.773899
6	2	1	1	2021-07-13 09:13:58.39545	\N	\N
7	2	2	1	2021-07-13 09:13:58.399495	\N	\N
8	3	1	1	2021-07-13 09:28:16.508865	\N	2021-07-14 02:25:43.091551
9	3	2	1	2021-07-13 09:28:16.512049	\N	2021-07-14 02:25:44.488295
4	1	1	1	2021-07-13 02:13:35.903529	\N	2021-07-14 07:02:10.325925
5	1	2	1	2021-07-13 02:13:35.907072	\N	2021-07-14 07:02:11.069507
13	1	2	1	2021-07-14 07:02:24.720192	\N	2021-07-14 07:05:57.221762
12	1	1	1	2021-07-14 07:02:24.716159	\N	2021-07-14 07:05:58.072086
15	1	2	1	2021-07-14 07:06:48.946111	\N	2021-07-14 07:08:59.085745
14	1	1	1	2021-07-14 07:06:10.024064	\N	2021-07-14 07:08:59.899733
16	1	1	1	2021-07-14 07:09:50.893004	\N	2021-07-14 07:16:16.167701
17	1	2	1	2021-07-14 07:09:50.896649	\N	2021-07-14 07:16:17.00705
20	1	4	1	2021-07-14 07:17:26.225199	\N	2021-07-14 07:17:42.041478
19	1	2	1	2021-07-14 07:17:26.22243	\N	2021-07-14 07:25:40.014908
18	1	1	1	2021-07-14 07:17:26.219428	\N	2021-07-14 07:28:05.220712
22	1	4	1	2021-07-14 07:28:24.975722	\N	2021-07-14 07:28:57.922485
23	1	2	1	2021-07-14 07:30:18.24167	\N	2021-07-14 07:36:03.561933
21	1	1	1	2021-07-14 07:28:24.972307	\N	2021-07-14 07:36:10.423408
25	1	4	1	2021-07-14 07:36:28.990164	\N	2021-07-14 07:49:38.748222
24	1	1	1	2021-07-14 07:36:28.98703	\N	2021-07-14 08:15:28.79749
26	1	2	1	2021-07-14 08:02:54.305348	\N	2021-07-14 08:15:31.396968
28	1	4	1	2021-07-14 08:15:37.205601	\N	2021-07-14 13:46:13.305993
11	3	2	1	2021-07-14 02:25:50.203876	\N	2021-07-15 02:05:25.694774
10	3	1	1	2021-07-14 02:25:50.199271	\N	2021-07-15 02:05:26.424152
31	3	2	1	2021-07-15 02:05:41.869106	\N	2021-07-15 02:05:59.143735
30	3	1	1	2021-07-15 02:05:41.864361	\N	2021-07-16 02:25:56.83225
34	3	4	1	2021-07-16 02:36:13.723109	\N	2021-07-16 02:36:19.698541
32	3	1	1	2021-07-16 02:36:13.714835	\N	2021-07-16 02:48:25.396858
33	3	2	1	2021-07-16 02:36:13.719645	\N	2021-07-18 01:36:00.827621
35	3	4	1	2021-07-18 01:18:49.146141	\N	2021-07-18 01:48:33.130609
37	3	2	1	2021-07-18 01:39:37.363031	\N	2021-07-18 01:49:27.953147
36	3	1	1	2021-07-18 01:18:49.150815	\N	2021-07-18 02:13:02.355205
38	3	1	1	2021-07-18 02:13:35.414871	\N	2021-07-18 02:52:35.884571
42	3	1	1	2021-07-19 09:41:25.201291	\N	2021-07-19 09:41:45.443014
39	3	2	1	2021-07-18 02:13:35.418177	\N	2021-07-19 09:52:19.743493
40	3	4	1	2021-07-18 02:13:35.421101	\N	2021-07-21 07:44:46.569098
44	3	2	1	2021-07-21 07:46:42.813395	\N	\N
43	3	1	1	2021-07-21 07:46:42.808818	\N	2021-07-21 07:47:31.260927
29	1	1	1	2021-07-14 08:15:37.208729	\N	2021-07-24 04:33:08.292705
41	1	4	1	2021-07-19 09:07:04.094878	\N	2021-07-24 04:33:36.632676
27	1	2	1	2021-07-14 08:15:37.202476	\N	2021-07-24 04:33:43.052831
45	1	1	1	2021-07-24 04:33:53.537971	\N	2021-07-24 04:40:45.4517
46	1	4	1	2021-07-24 04:33:53.542507	\N	2021-07-24 04:40:47.831882
49	1	5	1	2021-07-25 02:08:56.990996	\N	2021-07-25 02:30:34.551304
47	1	1	1	2021-07-24 05:09:36.770552	\N	2021-07-25 02:30:38.446604
48	1	4	1	2021-07-24 05:09:36.773918	\N	2021-07-25 02:30:42.441427
50	1	4	1	2021-07-25 02:31:16.250639	\N	2021-07-25 02:31:39.250814
51	1	5	1	2021-07-25 02:31:16.254591	\N	2021-07-25 02:32:17.340808
53	1	4	1	2021-07-25 02:32:05.600797	\N	2021-07-25 02:35:23.302564
52	1	1	1	2021-07-25 02:31:16.257551	\N	2021-07-25 14:54:39.101222
54	1	1	1	2021-07-25 14:57:17.519993	\N	\N
55	1	4	1	2021-07-25 14:58:11.289797	\N	\N
56	1	6	1	2021-08-05 12:24:58.769756	\N	2021-08-05 13:02:17.684506
57	1	6	1	2021-08-05 13:02:24.51431	\N	\N
58	11	7	1	2021-08-11 11:37:08.139412	\N	\N
59	11	8	1	2021-08-11 11:37:08.143673	\N	\N
62	11	6	1	2021-08-11 12:17:36.471057	\N	2021-08-11 12:28:54.921622
63	11	6	1	2021-08-22 14:13:28.868814	\N	\N
64	9	1	1	2021-08-24 02:02:16.375773	\N	\N
65	9	4	1	2021-08-24 02:02:16.388537	\N	\N
66	1	7	1	2021-08-24 12:14:41.470519	2021-08-24 12:14:47.395664	2021-08-24 12:14:47.395641
67	11	4	1	2021-08-24 13:16:48.061087	\N	\N
68	18	1	1	2021-08-24 14:39:13.232241	2021-08-24 19:56:11.178998	2021-08-24 19:56:11.178974
69	18	1	1	2021-08-24 20:10:22.526675	2021-08-24 20:10:28.19462	2021-08-24 20:10:28.194598
70	18	1	1	2021-08-24 20:17:18.039487	2021-08-24 20:17:24.545526	2021-08-24 20:17:24.545503
71	18	4	1	2021-08-24 20:17:59.080268	2021-08-24 20:18:50.194697	2021-08-24 20:18:50.194656
72	18	4	1	2021-08-24 20:25:13.726024	2021-08-24 20:26:01.738301	2021-08-24 20:26:01.73828
73	18	1	1	2021-08-24 20:25:33.829885	2021-08-24 20:26:28.952353	2021-08-24 20:26:28.952333
74	18	1	1	2021-08-24 20:26:36.084044	2021-08-24 20:26:40.292908	2021-08-24 20:26:40.292889
75	18	1	1	2021-08-24 20:30:00.748824	2021-08-24 20:30:05.134276	2021-08-24 20:30:05.134255
76	18	1	1	2021-08-24 20:32:19.578642	2021-08-24 20:32:23.465089	2021-08-24 20:32:23.46507
77	18	1	1	2021-08-24 21:36:05.892162	2021-08-24 21:36:16.11122	2021-08-24 21:36:16.1112
78	18	1	1	2021-08-24 21:36:25.933693	2021-08-24 21:36:36.216091	2021-08-24 21:36:36.216072
79	10	1	1	2021-08-25 00:59:55.354086	2021-08-25 01:00:25.929818	2021-08-25 01:00:25.929796
80	11	9	1	2021-08-25 09:38:53.764565	\N	\N
81	21	1	1	2021-08-25 09:46:04.956605	\N	\N
82	21	14	1	2021-08-25 09:46:04.968158	\N	\N
83	9	14	1	2021-08-25 14:44:53.831951	\N	\N
84	9	13	1	2021-08-25 14:48:05.654752	\N	\N
85	9	7	1	2021-08-25 14:48:26.854069	\N	\N
86	9	9	1	2021-08-25 14:48:26.864149	\N	\N
88	25	20	1	2021-08-29 02:54:49.634699	2021-08-29 02:54:56.072406	2021-08-29 02:54:56.072384
89	25	9	1	2021-08-29 02:55:00.716783	\N	\N
91	1	14	1	2021-09-21 09:24:02.282726	2021-09-21 09:24:07.1577	2021-09-21 09:24:07.157679
94	1	9	1	2021-09-27 09:52:58.977033	2021-09-27 09:53:19.557788	2021-09-27 09:53:19.557767
93	1	19	1	2021-09-27 09:52:58.970501	2021-09-27 09:53:23.877584	2021-09-27 09:53:23.877563
92	1	22	1	2021-09-27 09:52:58.962729	2021-09-27 09:53:27.828034	2021-09-27 09:53:27.828012
95	32	1	1	2021-09-27 18:20:09.957109	\N	\N
96	32	22	1	2021-09-27 18:20:09.965176	\N	\N
97	32	7	1	2021-09-27 18:20:09.971852	\N	\N
98	32	19	1	2021-09-27 18:20:09.978083	\N	\N
99	32	4	1	2021-09-27 18:20:09.984887	\N	\N
100	32	9	1	2021-09-27 18:20:09.991406	\N	\N
101	32	14	1	2021-09-27 18:20:09.998365	\N	\N
102	32	13	1	2021-09-27 18:20:10.005456	\N	\N
90	23	4	1	2021-09-02 15:39:08.22487	2021-09-27 18:33:59.849936	2021-09-27 18:33:59.849914
87	23	14	1	2021-08-25 16:03:52.427124	2021-09-27 18:34:02.691821	2021-09-27 18:34:02.691802
103	23	7	1	2021-09-27 18:34:19.262415	\N	\N
104	23	9	1	2021-09-27 18:34:19.269699	\N	\N
105	1	9	1	2021-10-04 02:36:42.376849	\N	\N
106	1	7	1	2021-10-04 02:37:03.65828	\N	\N
107	21	7	1	2021-10-04 10:06:22.653073	\N	\N
\.


--
-- Data for Name: store_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_item (id, store_id, menu_category_id, name, brand_name, image, packaged, status, created_at, updated_at, deleted_at) FROM stdin;
61	18	20	Ghee	ananda	saas/itemicon/default.png	0	1	2021-08-24 15:01:20.986877	\N	2021-08-24 15:22:27.940579
62	18	20	Milk	Amul	saas/itemicon/default.png	0	1	2021-08-24 16:44:10.979006	\N	\N
63	18	22	Cookies	Amul	saas/itemicon/default.png	0	1	2021-08-24 16:46:07.74914	\N	\N
9	3	1	Paneer	amul	saas/itemicon/default.png	0	1	2021-07-13 09:28:39.809156	\N	\N
10	3	1	amul	amul	saas/itemicon/default.png	0	1	2021-07-13 09:32:26.769276	\N	\N
4	1	1	string	string	saas/itemicon/default.png	0	1	2021-07-13 01:33:30.245098	\N	2021-07-15 09:19:58.574741
16	1	1	bread	amul	saas/itemicon/default.png	0	1	2021-07-16 13:22:00.021406	\N	2021-07-16 13:22:31.810909
5	1	1	wwwwww	amul	saas/itemicon/default.png	0	1	2021-07-13 01:44:46.266478	\N	2021-07-19 17:39:19.31454
64	18	20	Butter	Amul	saas/itemicon/default.png	0	1	2021-08-24 16:47:52.854165	\N	2021-08-24 16:48:11.387781
65	2	1	Chips	Lays	saas/itemicon/default.png	0	1	2021-08-24 16:56:30.933951	\N	\N
17	1	2	milk	amul	saas/itemicon/default.png	0	1	2021-07-19 14:38:28.962336	\N	2021-07-20 06:50:14.373173
19	1	2	Milk	Sudha	saas/itemicon/default.png	0	1	2021-07-19 17:48:37.276399	\N	2021-07-20 07:29:43.951353
6	1	1	baby paneer	baby	saas/itemicon/default.png	0	1	2021-07-13 08:09:17.521804	\N	2021-07-20 07:30:14.909128
14	1	1	Milk	Amul	saas/itemicon/default.png	0	1	2021-07-15 07:03:28.551754	\N	2021-07-20 07:30:27.047805
18	1	7	Orange	farm-fresh	saas/itemicon/default.png	0	1	2021-07-19 17:45:41.576642	\N	2021-07-20 07:31:23.311677
20	1	7	Apple	farm-fresh	saas/itemicon/default.png	0	1	2021-07-19 17:55:44.470602	\N	2021-07-20 09:13:13.306137
15	3	4	Paneercvn	amul	saas/itemicon/default.png	0	1	2021-07-15 08:52:12.771251	\N	2021-07-21 06:50:18.884259
12	3	2	ghggjhfh	amul	saas/itemicon/default.png	0	1	2021-07-14 02:40:51.013259	\N	2021-07-21 13:41:09.159507
11	3	2	ghgh	amul	saas/itemicon/default.png	0	1	2021-07-13 12:57:35.425497	\N	2021-07-21 14:14:10.843644
24	1	7	Mango	farm-fresh	saas/itemicon/default.png	0	1	2021-07-21 18:03:54.622815	\N	\N
25	1	6	Butter	amul	saas/itemicon/default.png	0	1	2021-07-22 01:42:19.788403	\N	2021-07-22 01:44:26.350956
22	1	7	Orange	farm-fresh	saas/itemicon/default.png	0	1	2021-07-20 09:15:28.822864	\N	2021-07-22 08:57:13.138986
23	1	2	Milk	Amul	saas/itemicon/default.png	0	1	2021-07-20 14:19:04.676268	\N	2021-07-22 09:01:14.792123
21	1	7	Apple	farm-fresh	saas/itemicon/default.png	0	1	2021-07-20 09:13:47.512108	\N	2021-07-22 09:42:03.868521
13	1	1	milk	Amul	saas/itemicon/default.png	0	1	2021-07-14 10:09:30.910866	\N	2021-08-02 06:27:39.981826
30	1	1	milk	Amul	saas/itemicon/default.png	0	1	2021-08-02 06:28:11.327893	\N	2021-08-02 06:49:39.061875
32	1	7	test2	test2	saas/itemicon/default.png	0	1	2021-08-02 06:53:23.890225	\N	2021-08-02 06:54:15.843478
31	1	1	test	test	saas/itemicon/default.png	0	1	2021-08-02 06:52:35.80968	\N	2021-08-02 07:25:15.182826
35	1	1	test3	amul	saas/itemicon/default.png	0	1	2021-08-02 10:09:57.133559	\N	2021-08-02 10:15:15.127202
34	1	1	test	test	saas/itemicon/default.png	0	1	2021-08-02 07:25:21.189247	\N	2021-08-02 10:15:30.974394
33	1	7	test2	test2	saas/itemicon/default.png	0	1	2021-08-02 06:54:41.63006	\N	2021-08-02 10:17:22.706676
36	1	7	hfrxh	h	saas/itemicon/default.png	0	1	2021-08-05 11:57:45.880078	\N	2021-08-05 11:58:18.069225
37	1	7	ghgh	amul	saas/itemicon/default.png	0	1	2021-08-05 11:59:17.241202	\N	2021-08-05 12:15:50.042452
38	1	7	Paneercvn	amul	saas/itemicon/default.png	0	1	2021-08-05 14:11:03.646393	\N	2021-08-05 14:13:08.299753
39	1	1	wwwwww	amul	saas/itemicon/default.png	0	1	2021-08-05 14:12:36.3563	\N	2021-08-05 14:13:24.441269
47	9	5	Chicken Curry	Nandu's	saas/itemicon/default.png	0	1	2021-08-08 15:53:11.372622	\N	\N
28	1	1	Cookies	Amul	saas/itemicon/default.png	0	1	2021-07-22 10:24:32.090839	\N	2021-08-23 20:03:38.612597
44	9	5	Chicken	Nandu's	saas/itemicon/default.png	0	1	2021-08-06 19:29:19.542551	\N	2021-08-24 02:02:59.574062
48	9	1	ghgh	amul	saas/itemicon/default.png	0	1	2021-08-24 02:03:26.100616	\N	2021-08-24 02:05:21.322734
49	1	1	Milk	Amul	saas/itemicon/default.png	0	1	2021-08-24 12:15:19.372148	\N	\N
50	11	15	Book 11	super book	saas/itemicon/default.png	0	1	2021-08-24 12:55:13.560565	\N	2021-08-24 12:55:13
54	11	7	Orange	new	saas/itemicon/default.png	0	1	2021-08-24 13:42:53.826535	\N	\N
55	1	12	chicken	meat	saas/itemicon/default.png	0	1	2021-08-24 13:43:53.722887	\N	2021-08-24 13:45:35.870902
57	18	21	 Milk	Ananda	saas/itemicon/default.png	0	1	2021-08-24 14:42:42.500757	\N	2021-08-24 15:22:22.551525
58	18	14	Metro 2033	generic	saas/itemicon/default.png	0	1	2021-08-24 14:43:41.190199	\N	2021-08-24 15:22:24.884338
59	18	12	beef	generic	saas/itemicon/default.png	0	1	2021-08-24 14:45:48.130451	\N	2021-08-24 15:22:26.297327
60	18	19	biscuit	britainia	saas/itemicon/default.png	0	1	2021-08-24 14:58:14.536374	\N	2021-08-24 15:22:27.180105
52	1	7	Orange	farm-fresh	saas/itemicon/default.png	0	1	2021-08-24 13:10:42.52218	\N	2021-08-25 01:10:23.124632
69	21	20	Milk	Amul	saas/itemicon/default.png	0	1	2021-08-25 09:49:11.470722	\N	\N
70	21	22	Chips	Lays	saas/itemicon/default.png	0	1	2021-08-25 09:49:33.549991	\N	\N
51	11	14	Book 1	super book	saas/itemicon/default.png	0	1	2021-08-24 12:59:53.362611	\N	\N
72	21	20	Cheese	Ananda	saas/itemicon/default.png	0	1	2021-08-25 11:21:43.394615	\N	\N
53	11	14	Book 15	new	saas/itemicon/default.png	0	1	2021-08-24 13:41:15.50179	\N	\N
7	2	1	Paneer	amul	saas/itemicon/default.png	0	1	2021-07-13 09:14:34.863684	\N	\N
8	2	1	Dahi	amul	saas/itemicon/default.png	0	1	2021-07-13 09:15:29.552901	\N	\N
29	1	1	Chips	Lays	saas/itemicon/default.png	0	1	2021-07-22 13:55:55.242166	\N	2021-07-22 14:11:30.816564
71	21	30	chicken legg	xyz	saas/itemicon/default.png	0	1	2021-08-25 09:50:04.471944	\N	\N
73	21	21	Sunflower Oil	Fortune	saas/itemicon/default.png	0	1	2021-08-25 11:24:48.539639	\N	\N
74	11	7	Banana	new	saas/itemicon/default.png	0	1	2021-08-25 11:42:14.638037	\N	\N
76	11	32	Onion	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:35:23.649218	\N	\N
77	11	32	Potato	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:36:23.737434	\N	\N
78	9	20	Milk	Nandini	saas/itemicon/default.png	0	1	2021-08-25 14:39:36.896083	\N	\N
79	11	32	Radish	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:39:56.234979	\N	\N
80	11	32	Tomato	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:40:43.891661	\N	\N
81	11	32	Cauliflower	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:45:27.300056	\N	\N
83	9	31	Mutton	Nandu's	saas/itemicon/default.png	0	1	2021-08-25 14:51:30.015949	\N	\N
27	1	1	Butter	Amul	saas/itemicon/default.png	0	1	2021-07-22 10:22:55.734704	2021-10-06 08:02:48.092303	\N
67	11	7	Green Banana	Green Banana	saas/itemicon/default.png	0	1	2021-08-24 20:40:38.56471	\N	\N
56	1	1	Cookies	amul	saas/itemicon/default.png	0	0	2021-08-24 13:46:08.17801	2021-10-06 08:03:14.90677	\N
75	1	33	Basumati rice	Itc	saas/itemicon/default.png	0	1	2021-08-25 13:36:14.700105	2021-10-06 08:02:46.847506	\N
82	11	32	carrot	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:45:57.918655	2021-10-14 09:40:02.842553	\N
84	9	20	Butter	Nandini	saas/itemicon/default.png	0	1	2021-08-25 14:53:18.38705	\N	\N
85	11	32	Beans	fresh	saas/itemicon/default.png	0	1	2021-08-25 14:54:44.907676	\N	\N
86	9	7	Orange	new	saas/itemicon/default.png	0	1	2021-08-25 14:59:13.15616	\N	\N
88	21	33	Basmati Rice 	India gate	saas/itemicon/default.png	0	1	2021-08-26 05:29:27.818195	\N	\N
89	1	1	Magnum	Icecream	saas/itemicon/default.png	0	1	2021-08-26 16:37:18.587105	\N	\N
90	11	25	OnePlus	Mobile	saas/itemicon/default.png	0	1	2021-08-26 21:27:35.333342	\N	\N
68	21	20	Butter	Amul	saas/itemicon/default.png	0	1	2021-08-25 09:48:49.775119	\N	2021-08-27 11:20:52.778798
139	23	31	Chicken	Nandu's	saas/itemicon/default	0	1	2021-09-02 19:20:51.2533	\N	2021-09-02 19:20:51
87	23	31	Mutton	Nandu's	saas/itemicon/default.png	0	1	2021-08-25 16:04:48.519683	\N	2021-09-27 18:32:26.357527
140	1	1	chocolate	Amul	saas/itemicon/default.png	0	1	2021-10-07 08:19:41.871693	\N	\N
141	1	7	Banana	farm-fresh	saas/itemicon/default.png	0	1	2021-10-07 08:20:58.663373	\N	\N
142	1	7	Grapes	farm-fresh	saas/itemicon/default.png	0	1	2021-10-07 08:31:43.872678	\N	\N
143	1	1	ketchup	nestle	saas/itemicon/default.png	0	1	2021-10-07 08:40:48.701093	\N	\N
144	1	7	pineapple	farm-fresh	saas/itemicon/default.png	0	1	2021-10-07 09:13:17.998082	\N	\N
145	1	1	Dairy Milk	Amul	saas/itemicon/default.png	0	1	2021-10-07 09:49:25.058154	\N	\N
146	1	7	Green Banana	Aro	saas/itemicon/default.png	0	1	2021-10-09 13:08:55.95209	\N	\N
147	32	37	T-Shirt	Jack & Jones	saas/itemicon/default.png	0	1	2021-10-11 16:26:44.732255	\N	2021-10-11 16:27:38.140726
148	32	37	T-Shirt	Jack & Jones	saas/itemicon/default.png	0	1	2021-10-11 16:27:52.830419	\N	\N
149	32	38	T-Shirt for Women	Jack & Jones	saas/itemicon/default.png	0	1	2021-10-11 16:29:04.338885	\N	\N
150	23	25	Notebook	Classmate	saas/itemicon/default.png	0	1	2021-10-11 16:38:07.760631	\N	\N
151	1	7	new product	new brand	saas/itemicon/default.png	0	0	2021-10-12 18:16:34.558092	2021-10-12 18:17:34.616798	\N
152	32	37	Blue Chequered Men Shirt Cotton light coloured printed full sleeve Chinese collar	Pepe Jeans	saas/itemicon/default.png	0	1	2021-10-12 19:09:04.547369	\N	\N
153	32	39	Skinny high waist blue faded women's jeans	Pepe Jeans	saas/itemicon/default.png	0	1	2021-10-12 19:11:01.849901	\N	\N
154	32	38	Round neck yellow printed t-shirt 	H&M Fashion	saas/itemicon/default.png	0	1	2021-10-12 19:12:55.077312	\N	\N
155	23	25	Pen	Cello	saas/itemicon/default.png	0	1	2021-10-12 19:14:45.496079	\N	\N
156	23	25	Sketch pen	Elkos	saas/itemicon/default.png	0	1	2021-10-12 19:15:15.798107	\N	\N
157	23	25	Crayon	camel	saas/itemicon/default.png	0	1	2021-10-12 19:15:51.959614	\N	\N
158	11	14	Book 20	Ashirvad	saas/itemicon/default.png	0	1	2021-10-14 06:45:01.360029	\N	\N
66	11	7	Apple	Apple	saas/itemicon/default.png	0	1	2021-08-24 20:40:10.066901	2021-10-14 09:40:05.257549	\N
26	1	7	Apple	freshhh	saas/itemicon/default.png	0	1	2021-07-22 09:48:31.163726	2021-10-14 11:47:16.272431	\N
\.


--
-- Data for Name: store_item_uploads; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_item_uploads (id, store_id, user_id, file_name, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: store_item_variable; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_item_variable (id, store_item_id, quantity, quantity_unit, mrp, selling_price, status, created_at, updated_at, deleted_at, stock) FROM stdin;
97	53	1	7	50	45	1	2021-08-24 13:41:15.508473	\N	\N	9
117	70	1	7	120	100	1	2021-08-25 09:49:33.553777	\N	\N	30
100	56	250	5	30	20	1	2021-08-24 13:46:08.184405	\N	\N	110
121	72	500	5	100	85	1	2021-08-25 11:21:43.400572	\N	\N	15
122	72	100	5	100	50	1	2021-08-25 11:22:22.201568	\N	2021-09-03 17:59:35.720451	10
65	28	1000	3	1000	1000	1	2021-08-02 06:51:02.080422	\N	2021-08-23 20:03:37.398575	10
61	28	10	4	10	10	1	2021-07-26 16:26:16.507182	2021-08-02 06:50:39.088592	2021-08-23 20:03:38.609612	10
85	44	1	2	200	150	1	2021-08-06 19:29:19.548859	2021-08-09 18:19:52.227414	2021-08-24 02:02:59.571365	10
87	48	2	3	7	2	1	2021-08-24 02:03:26.106542	\N	2021-08-24 02:05:18.079174	10
88	48	2	4	76	75	1	2021-08-24 02:05:13.519765	\N	2021-08-24 02:05:21.320612	10
120	70	100	5	60	50	1	2021-08-25 09:50:47.341485	2021-09-06 07:39:17.469039	\N	71
217	72	2	3	500	350	1	2021-09-03 18:09:14.997164	\N	\N	5
131	77	500	5	50	43	1	2021-08-25 14:36:23.742197	\N	\N	10
104	57	10	4	10	5	1	2021-08-24 14:45:14.241949	\N	2021-08-24 15:22:22.549287	10
102	58	1	7	650	500	1	2021-08-24 14:43:41.194461	\N	2021-08-24 15:22:24.882242	10
105	59	1	3	1000	500	1	2021-08-24 14:45:48.134951	\N	2021-08-24 15:22:26.289489	10
106	60	250	5	60	40	1	2021-08-24 14:58:14.540368	\N	2021-08-24 15:22:27.177827	10
107	61	12	5	10	5	1	2021-08-24 15:01:20.990851	\N	2021-08-24 15:22:27.938501	10
108	62	1	4	45	20	1	2021-08-24 16:44:10.983113	\N	\N	10
109	63	1	7	25	20	1	2021-08-24 16:46:07.752828	\N	\N	10
111	65	15	5	60	40	1	2021-08-24 16:56:30.938238	\N	\N	10
96	51	1	3	80	70	1	2021-08-24 13:20:27.025073	\N	2021-08-25 09:29:56.584019	10
45	24	500	3	35	30	1	2021-07-22 09:44:57.183574	\N	2021-07-22 10:31:11.093692	10
4	7	10	3	76	75	1	2021-07-13 09:14:34.867732	\N	\N	10
5	8	1000	3	200	200	1	2021-07-13 09:15:29.556611	\N	\N	10
6	9	10	3	76	75	1	2021-07-13 09:28:39.812919	\N	\N	10
53	29	500	5	50	45	1	2021-07-22 13:57:19.26957	\N	2021-07-22 14:11:26.327212	10
55	24	250	5	35	30	1	2021-07-26 14:25:56.849676	\N	2021-07-26 14:29:22.463852	10
18	19	15	6	35	30	1	2021-07-19 17:48:37.282392	\N	2021-07-20 06:51:01.21665	10
20	20	50	3	120	115	1	2021-07-19 17:55:44.477887	\N	2021-07-20 06:56:44.284335	10
59	13	1	5	120	30	1	2021-07-26 16:17:19.53079	\N	2021-07-26 16:29:34.174789	10
54	24	400	3	120	115	1	2021-07-22 14:13:21.165264	\N	2021-07-26 16:29:46.468595	10
82	37	2	4	76	75	1	2021-08-05 12:01:20.060987	\N	2021-08-05 12:15:42.00102	10
58	13	959	4	35	30	1	2021-07-26 16:15:39.693977	2021-07-26 16:35:36.73818	2021-07-26 16:38:12.895872	10
60	28	250	3	35	30	1	2021-07-26 16:24:12.960271	\N	2021-08-02 06:24:20.471191	10
51	13	250	4	120	115	1	2021-07-22 10:29:06.021292	\N	2021-08-02 06:27:37.409207	10
63	30	2	3	76	75	1	2021-08-02 06:28:11.334483	\N	2021-08-02 06:49:35.828121	10
49	28	100	5	50	40	1	2021-07-22 10:24:32.096002	\N	2021-08-02 06:50:07.708815	10
32	24	5	3	200	180	1	2021-07-22 08:27:40.591496	\N	2021-07-22 08:29:12.376961	10
33	24	250	5	35	30	1	2021-07-22 08:28:43.82555	\N	2021-07-22 08:47:10.451296	10
23	21	300	5	60	55	1	2021-07-20 09:14:12.359687	2021-07-21 18:43:38.121806	2021-07-22 08:48:29.30309	10
24	21	250	5	35	20	1	2021-07-20 09:14:34.491238	2021-07-22 06:50:17.355186	2021-07-22 08:51:05.328684	10
28	23	500	6	35	33	1	2021-07-20 14:19:28.793395	\N	2021-07-22 08:53:50.84829	10
27	23	1	3	45	40	1	2021-07-20 14:19:04.682305	\N	2021-07-22 09:00:25.80108	10
22	21	1	3	120	115	1	2021-07-20 09:13:47.516454	2021-07-22 06:50:06.917648	2021-07-22 09:02:56.980868	10
34	21	250	4	35	30	1	2021-07-22 09:02:36.461984	\N	2021-07-22 09:13:44.257626	10
35	21	500	4	45	30	1	2021-07-22 09:04:53.120645	\N	2021-07-22 09:15:11.023929	10
38	21	50	6	120	115	1	2021-07-22 09:26:34.711761	\N	2021-07-22 09:29:31.002966	10
39	21	25	5	35	30	1	2021-07-22 09:27:47.232875	\N	2021-07-22 09:29:34.007524	10
37	21	28	4	35	30	1	2021-07-22 09:17:35.315997	\N	2021-07-22 09:42:00.675895	10
40	21	50	4	45	30	1	2021-07-22 09:29:49.013353	\N	2021-07-22 09:42:01.59968	10
41	21	99	4	45	30	1	2021-07-22 09:31:02.054509	\N	2021-07-22 09:42:02.323395	10
42	21	8	4	45	30	1	2021-07-22 09:31:35.312665	\N	2021-07-22 09:42:03.18019	10
69	31	1	5	1000	200	1	2021-08-02 06:55:49.326691	\N	2021-08-02 06:56:05.351051	10
66	31	1000	3	1000	1000	1	2021-08-02 06:52:35.815141	2021-08-02 06:53:48.731255	2021-08-02 07:24:15.709942	10
70	31	1	4	1	1	1	2021-08-02 07:16:21.337822	\N	2021-08-02 07:24:16.800052	10
71	31	10	4	76	75	1	2021-08-02 07:19:16.63769	\N	2021-08-02 07:24:17.589994	10
78	35	1	3	1	1	1	2021-08-02 10:14:58.894571	\N	2021-08-02 10:15:06.015013	10
76	35	1000	7	1000	1000	1	2021-08-02 10:11:00.064602	\N	2021-08-02 10:15:13.414747	10
80	36	2	4	1000	75	1	2021-08-05 11:57:59.83065	\N	2021-08-05 11:58:04.449989	10
86	47	1	1	200	180	1	2021-08-08 15:53:11.377519	\N	\N	10
77	24	11	3	11	11	1	2021-08-02 10:12:34.132716	\N	2021-08-23 14:27:42.51643	10
99	55	1	3	120	115	1	2021-08-24 13:43:53.729827	\N	2021-08-24 13:45:35.868148	10
101	57	1	4	500	200	1	2021-08-24 14:42:42.50561	\N	2021-08-24 15:22:21.441467	10
110	64	50	5	25	20	1	2021-08-24 16:47:52.857923	\N	2021-08-24 16:48:11.385562	10
95	51	1	1	80	70	1	2021-08-24 13:19:43.8518	\N	2021-08-25 09:29:52.775749	10
118	71	250	5	120	115	1	2021-08-25 09:50:04.477956	\N	\N	10
124	73	10	4	1700	1500	1	2021-08-25 11:24:48.546938	\N	\N	10
127	75	2	3	76	75	1	2021-08-25 13:36:14.705087	\N	\N	10
132	76	250	5	40	35	1	2021-08-25 14:36:48.347695	\N	\N	10
115	68	250	5	60	55	1	2021-08-25 09:48:49.781168	\N	2021-08-27 11:20:52.775958	10
133	78	0	4	25	20	1	2021-08-25 14:39:36.899706	\N	\N	10
218	88	100	5	100	90	1	2021-09-03 18:10:30.843606	\N	\N	0
221	24	750	5	60	55	1	2021-09-14 10:28:28.595091	\N	\N	0
135	80	2	3	200	170	1	2021-08-25 14:40:43.895454	\N	\N	10
136	80	1	3	100	80	1	2021-08-25 14:42:44.786227	\N	\N	10
116	69	1	4	60	55	1	2021-08-25 09:49:11.476581	2021-09-06 09:04:30.815596	\N	78
46	26	250	5	60	55	1	2021-07-22 09:48:31.16918	2021-10-05 15:24:01.868286	\N	123
125	66	5	3	500	450	1	2021-08-25 11:41:04.829088	2021-09-29 05:41:54.915048	\N	3
98	54	200	5	60	55	1	2021-08-24 13:42:53.837302	\N	\N	10
47	26	500	5	120	115	1	2021-07-22 09:48:51.982354	2021-10-05 15:47:55.892697	\N	59
126	74	500	5	170	150	1	2021-08-25 11:42:14.642991	2021-10-04 08:56:54.315625	\N	4
128	75	1	3	50	50	1	2021-08-25 13:37:03.531075	\N	\N	99
114	51	11	7	123	122	1	2021-08-25 07:00:09.124466	2021-10-07 14:56:38.266141	\N	2
130	76	500	5	75	65	1	2021-08-25 14:35:23.653847	2021-10-06 07:15:46.357416	\N	0
29	24	1	3	58	55	1	2021-07-21 18:03:54.629228	2021-07-26 16:34:18.362482	\N	25
57	27	50	5	20	15	1	2021-07-26 15:53:03.020762	\N	\N	144
50	27	500	5	120	115	1	2021-07-22 10:26:22.093199	\N	\N	36
89	49	1	4	60	28	1	2021-08-24 12:15:19.376722	\N	\N	8
134	79	1	3	85	80	1	2021-08-25 14:39:56.239012	\N	\N	10
137	80	3	3	300	260	1	2021-08-25 14:43:14.078025	\N	\N	0
148	87	500	5	7	3	0	2021-08-25 16:05:09.543581	2021-08-25 18:07:40.36151	2021-09-27 18:32:24.446149	10
138	81	1	7	15	9	1	2021-08-25 14:45:27.304857	\N	\N	10
140	81	2	7	30	18	1	2021-08-25 14:47:08.166151	\N	\N	10
141	81	3	7	45	25	1	2021-08-25 14:49:35.724868	\N	\N	10
146	86	1	3	60	50	1	2021-08-25 14:59:13.160132	\N	\N	10
147	87	1	3	10	5	1	2021-08-25 16:04:48.523821	\N	2021-08-26 14:58:48.44445	10
142	83	1	3	3	2	1	2021-08-25 14:51:30.020069	\N	\N	10
143	84	200	5	50	2	1	2021-08-25 14:53:18.390865	\N	\N	10
219	24	500	5	120	115	1	2021-09-14 10:27:55.881959	\N	\N	10
153	54	400	5	120	110	1	2021-08-25 18:52:55.986422	\N	\N	0
7	10	2	3	76	75	1	2021-07-13 09:32:26.772943	\N	\N	10
16	18	15	3	85	80	1	2021-07-19 17:45:41.583876	\N	2021-07-20 07:31:04.708729	10
44	24	230	3	31	30	1	2021-07-22 09:42:51.419545	2021-07-26 16:34:26.820706	2021-08-02 06:24:33.319898	10
25	22	500	5	45	40	1	2021-07-20 09:15:28.827441	2021-07-20 09:16:11.237219	2021-07-22 08:51:18.449208	10
36	21	250	4	45	30	1	2021-07-22 09:14:39.456103	\N	2021-07-22 09:41:59.889485	10
48	27	300	5	60	55	1	2021-07-22 10:22:55.739112	2021-07-22 10:27:20.022576	2021-07-22 10:27:38.781061	10
74	33	2	4	76	75	1	2021-08-02 09:43:14.671008	\N	2021-08-02 10:17:19.55947	10
103	58	10	7	300	200	1	2021-08-24 14:44:48.651691	\N	2021-08-24 15:22:23.84658	10
93	52	250	5	60	40	1	2021-08-24 13:10:42.527024	\N	2021-08-25 01:10:23.121887	10
162	88	11	3	5000	1000	1	2021-08-26 13:50:34.082991	\N	2021-09-03 17:57:47.154037	10
155	80	6	3	400	350	1	2021-08-25 18:54:19.993147	\N	\N	10
156	88	1	3	100	99	1	2021-08-26 05:29:27.822894	\N	\N	10
157	88	5	3	450	440	1	2021-08-26 05:29:42.306853	\N	\N	10
158	88	500	5	50	49	1	2021-08-26 05:29:51.266793	\N	\N	10
159	49	11	4	21	20	1	2021-08-26 13:44:48.727291	\N	2021-08-26 13:44:53.559897	10
154	80	5	3	400	300	1	2021-08-25 18:53:31.10097	\N	2021-08-26 13:46:17.154772	10
119	68	100	5	35	30	1	2021-08-25 09:50:23.663076	\N	2021-08-26 13:47:57.291948	10
161	72	800	5	80	30	1	2021-08-26 13:49:44.823957	\N	\N	10
163	73	30	4	1000	800	1	2021-08-26 13:51:31.088139	\N	\N	10
123	72	1	3	500	450	1	2021-08-25 11:23:22.022417	\N	\N	20
160	73	50	4	1500	1000	1	2021-08-26 13:47:10.165656	\N	\N	11
166	89	10	7	3000	2499	1	2021-08-26 16:38:30.926865	\N	\N	-7
150	24	2	3	100	90	1	2021-08-25 18:44:02.036938	\N	\N	15
151	24	300	5	15	11	1	2021-08-25 18:44:38.549992	2021-09-06 10:57:37.305564	\N	10
220	24	250	5	35	30	1	2021-09-14 10:28:06.936241	\N	\N	10
144	85	1	3	90	75	1	2021-08-25 14:54:44.911645	\N	\N	10
129	75	10	3	500	500	1	2021-08-25 13:37:28.613735	\N	\N	50
92	27	250	5	120	100	1	2021-08-24 13:09:27.727519	\N	\N	50
167	89	2	7	600	500	1	2021-08-26 16:45:46.726225	\N	\N	160
165	89	1	7	300	280	0	2021-08-26 16:37:18.591817	2021-08-26 16:46:29.470965	\N	10
164	87	1	3	10	1	1	2021-08-26 15:01:10.880235	\N	2021-09-27 18:32:26.354559	9
246	157	1	7	60	55	1	2021-10-12 19:15:51.963436	\N	\N	40
139	82	500	5	50	35	1	2021-08-25 14:45:57.923689	\N	\N	10
247	26	500	7	2000	1500	1	2021-10-12 19:33:47.124666	\N	\N	50
222	24	5	3	300	285	1	2021-09-14 10:28:51.893488	\N	\N	6
149	24	1	5	35	30	1	2021-08-25 16:17:00.261333	\N	\N	7
248	148	2	7	300	270	1	2021-10-12 19:35:34.220779	\N	\N	1
168	90	1	7	24999	23000	1	2021-08-26 21:27:35.338089	2021-09-29 07:25:09.135443	\N	5
112	66	2	3	250	225	0	2021-08-24 20:40:10.071803	2021-10-08 10:48:10.364801	\N	8
249	158	1	7	50	40	1	2021-10-14 06:45:01.366519	\N	\N	10
230	143	250	5	35	30	1	2021-10-07 08:40:48.705824	\N	\N	2
233	146	100	5	20	15	1	2021-10-09 13:08:55.959177	\N	\N	50
224	26	100	5	35	30	1	2021-10-05 16:17:08.467337	\N	\N	40
56	26	1	3	180	160	1	2021-07-26 15:52:22.815644	2021-10-05 16:19:06.814801	\N	4
234	147	1	7	300	275	1	2021-10-11 16:26:44.737047	\N	2021-10-11 16:27:38.137815	10
235	148	1	7	300	275	1	2021-10-11 16:27:52.835486	\N	\N	10
236	149	1	7	300	275	1	2021-10-11 16:29:04.342942	\N	\N	10
225	26	50	5	35	10	1	2021-10-06 06:23:13.134813	\N	\N	30
237	150	1	7	65	62	1	2021-10-11 16:38:07.764798	\N	\N	50
223	26	2	3	400	380	1	2021-10-05 15:23:01.314149	2021-10-06 06:24:25.86993	\N	71
238	150	1	3	200	150	1	2021-10-12 16:44:21.239616	\N	\N	10
152	67	2	7	100	50	1	2021-08-25 18:46:12.26397	\N	\N	12
226	140	1	7	60	40	1	2021-10-07 08:19:41.877202	\N	\N	100
227	141	100	5	30	30	1	2021-10-07 08:20:58.6684	\N	\N	30
228	141	500	5	60	55	1	2021-10-07 08:29:23.390932	\N	\N	5
229	142	1	3	120	30	1	2021-10-07 08:31:43.876518	\N	\N	5
231	144	250	5	60	40	1	2021-10-07 09:13:18.002607	\N	\N	5
232	145	1	7	60	30	1	2021-10-07 09:49:25.064522	\N	\N	40
145	85	2	3	180	140	1	2021-08-25 14:56:30.019304	\N	\N	8
113	67	1	7	500	100	1	2021-08-24 20:40:38.568648	2021-10-04 08:49:03.947801	\N	5
239	151	10	5	100	90	1	2021-10-12 18:16:34.563424	\N	\N	50
240	152	1	7	400	375	1	2021-10-12 19:09:04.55267	\N	\N	20
241	153	1	7	700	620	1	2021-10-12 19:11:01.854165	\N	\N	20
242	154	1	7	500	470	1	2021-10-12 19:12:55.087273	\N	\N	30
243	152	1	4	375	350	1	2021-10-12 19:13:36.22935	\N	\N	15
244	155	1	7	10	10	1	2021-10-12 19:14:45.500063	\N	\N	300
245	156	1	7	50	48	1	2021-10-12 19:15:15.801829	\N	\N	45
\.


--
-- Data for Name: store_localities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_localities (id, store_id, locality_id, status, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Data for Name: store_menu_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_menu_categories (id, store_id, menu_category_id, status, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	1	2021-07-13 07:46:57.49029	\N	2021-07-14 05:14:56.323792
4	1	5	1	2021-07-14 05:15:56.940402	\N	2021-07-14 07:05:52.097441
3	1	4	1	2021-07-14 05:15:56.93776	\N	2021-07-14 07:05:53.088292
2	1	1	1	2021-07-14 05:15:56.933559	\N	2021-07-14 07:05:53.905674
7	1	4	1	2021-07-14 07:11:27.719154	\N	2021-07-14 07:16:51.760864
6	1	3	1	2021-07-14 07:11:27.716301	\N	2021-07-14 07:16:52.457265
5	1	1	1	2021-07-14 07:11:27.712464	\N	2021-07-14 07:16:53.317459
9	1	7	1	2021-07-14 07:36:40.099372	\N	2021-07-14 07:40:00.138124
8	1	6	1	2021-07-14 07:36:40.095255	\N	2021-07-14 07:40:01.618025
10	1	1	1	2021-07-14 07:54:51.335455	\N	2021-07-14 08:15:39.758713
11	1	2	1	2021-07-14 07:54:51.339729	\N	2021-07-14 08:15:42.107055
12	1	4	1	2021-07-14 08:02:59.3743	\N	2021-07-14 08:15:43.387026
18	1	7	1	2021-07-14 08:15:54.816667	\N	2021-07-14 13:47:58.326033
19	1	6	1	2021-07-14 08:15:54.819401	\N	2021-07-14 13:47:59.969825
21	1	1	1	2021-07-14 08:15:54.825161	\N	2021-07-15 02:05:11.73572
17	1	5	1	2021-07-14 08:15:54.813828	\N	2021-07-15 02:05:13.365895
14	3	1	1	2021-07-14 08:14:39.261555	\N	2021-07-15 02:05:22.984774
13	3	4	1	2021-07-14 08:14:39.258335	\N	2021-07-15 02:05:24.163985
20	1	2	1	2021-07-14 08:15:54.822333	\N	2021-07-16 12:48:34.80196
15	1	3	1	2021-07-14 08:15:54.807112	\N	2021-07-17 09:56:25.073598
16	1	4	1	2021-07-14 08:15:54.810879	\N	2021-07-17 09:56:25.873234
22	3	2	1	2021-07-15 02:05:49.983702	\N	2021-07-18 01:49:49.820159
24	3	3	1	2021-07-15 02:05:49.990687	\N	2021-07-18 02:11:24.462486
23	3	1	1	2021-07-15 02:05:49.987671	\N	2021-07-18 02:12:53.785746
25	3	4	1	2021-07-15 02:05:49.993591	\N	2021-07-18 02:13:07.044887
26	3	5	1	2021-07-15 02:05:49.996352	\N	2021-07-18 02:13:11.06556
27	3	2	1	2021-07-18 02:13:46.315288	\N	2021-07-18 02:13:53.225164
29	3	4	1	2021-07-18 02:54:20.736936	\N	2021-07-18 02:54:33.004171
28	3	3	1	2021-07-18 02:54:20.733579	\N	2021-07-19 09:52:25.5016
30	3	7	1	2021-07-18 02:54:20.740096	\N	2021-07-19 09:52:28.03194
32	3	4	1	2021-07-18 02:54:47.693805	\N	2021-07-21 07:47:45.85525
31	3	6	1	2021-07-18 02:54:20.742828	\N	2021-07-21 07:47:48.678973
38	3	3	1	2021-07-21 08:02:44.877654	\N	\N
39	3	4	1	2021-07-21 08:02:44.88204	\N	\N
35	1	3	1	2021-07-19 05:44:54.850462	\N	2021-07-22 10:18:27.26857
34	1	1	1	2021-07-19 05:44:54.847679	\N	2021-07-24 04:33:59.683157
33	1	2	1	2021-07-19 05:44:54.843472	\N	2021-07-24 04:34:01.98298
36	1	4	1	2021-07-19 05:44:54.852999	\N	2021-07-24 04:34:03.881997
37	1	7	1	2021-07-19 09:07:13.004977	\N	2021-07-24 04:34:05.352386
40	1	1	1	2021-07-24 04:34:16.621763	\N	2021-07-24 04:43:25.388687
41	1	7	1	2021-07-24 04:34:16.625792	\N	2021-07-24 04:43:27.24173
42	1	1	1	2021-07-24 05:09:43.540565	\N	2021-07-25 02:30:46.421434
43	1	7	1	2021-07-24 05:09:43.545809	\N	2021-07-25 02:30:49.811383
44	1	1	1	2021-07-25 02:47:33.560751	\N	2021-07-25 14:54:41.370346
47	11	14	1	2021-08-11 15:21:02.569442	\N	\N
48	11	15	1	2021-08-11 15:21:02.574695	\N	\N
51	18	22	1	2021-08-24 14:39:27.515731	\N	2021-08-24 15:23:36.112402
52	18	19	1	2021-08-24 14:39:27.520865	\N	2021-08-24 15:23:40.553644
53	18	1	1	2021-08-24 14:39:27.526013	\N	2021-08-24 15:23:45.184165
50	18	20	1	2021-08-24 14:39:27.509424	\N	2021-08-24 15:23:49.365007
60	2	19	1	2021-08-24 16:54:15.871084	\N	\N
61	2	22	1	2021-08-24 16:54:15.876961	\N	\N
62	2	1	1	2021-08-24 16:54:15.881828	\N	\N
49	11	7	1	2021-08-24 13:23:20.990964	\N	2021-08-24 18:30:18.517576
55	18	1	1	2021-08-24 15:23:58.586455	\N	2021-08-24 20:33:32.472749
56	18	19	1	2021-08-24 15:23:58.592008	\N	2021-08-24 20:33:34.397464
57	18	21	1	2021-08-24 15:23:58.596952	\N	2021-08-24 20:33:36.657393
58	18	20	1	2021-08-24 15:23:58.601763	\N	2021-08-24 20:33:38.501692
59	18	22	1	2021-08-24 15:23:58.606499	\N	2021-08-24 20:33:40.519929
63	11	7	1	2021-08-24 20:35:48.320662	\N	\N
64	18	22	1	2021-08-24 21:36:31.733845	\N	\N
65	10	1	1	2021-08-25 01:00:00.880513	\N	2021-08-25 01:00:29.055519
66	10	19	1	2021-08-25 01:00:00.886937	\N	2021-08-25 01:00:31.827291
67	21	20	1	2021-08-25 09:46:24.04317	\N	\N
69	21	22	1	2021-08-25 09:46:24.055412	\N	\N
70	21	30	1	2021-08-25 09:46:24.0604	\N	\N
71	21	29	1	2021-08-25 09:46:24.065028	\N	\N
72	11	32	1	2021-08-25 12:43:21.006336	\N	\N
74	9	20	1	2021-08-25 14:35:38.435396	\N	\N
75	9	7	1	2021-08-25 14:35:38.441391	\N	\N
76	9	31	1	2021-08-25 14:50:47.854191	\N	\N
77	9	25	1	2021-08-25 14:50:47.859187	\N	\N
78	9	26	1	2021-08-25 14:50:47.863929	\N	\N
79	9	15	1	2021-08-25 14:50:47.86885	\N	\N
80	9	14	1	2021-08-25 14:50:47.873599	\N	\N
81	9	17	1	2021-08-25 14:50:47.878059	\N	\N
82	9	28	1	2021-08-25 14:50:47.88256	\N	\N
83	9	27	1	2021-08-25 14:50:47.887108	\N	\N
84	9	29	1	2021-08-25 14:50:47.891922	\N	\N
85	9	30	1	2021-08-25 14:50:47.896445	\N	\N
86	9	32	1	2021-08-25 14:50:47.903832	\N	\N
87	9	33	1	2021-08-25 14:50:47.908407	\N	\N
88	9	21	1	2021-08-25 14:50:47.912993	\N	\N
89	9	22	1	2021-08-25 14:50:47.917635	\N	\N
90	9	1	1	2021-08-25 14:50:47.922403	\N	\N
91	9	19	1	2021-08-25 14:50:47.929687	\N	\N
96	21	33	1	2021-08-26 05:28:30.177661	\N	\N
97	1	20	1	2021-08-30 05:20:02.195961	\N	2021-09-16 09:58:10.475903
99	1	32	1	2021-09-21 09:16:55.316771	\N	2021-09-21 09:16:58.872608
100	11	26	1	2021-09-22 05:13:05.727046	\N	2021-09-22 05:30:48.979401
68	21	21	1	2021-08-25 09:46:24.050197	\N	2021-09-23 07:03:29.269998
73	1	33	1	2021-08-25 13:34:25.646523	\N	2021-09-23 07:43:44.488901
46	1	7	1	2021-07-25 14:58:20.557983	\N	2021-09-25 02:00:12.654481
101	1	7	1	2021-09-25 02:09:33.224537	\N	\N
102	32	22	1	2021-09-27 18:20:31.53199	\N	\N
103	32	20	1	2021-09-27 18:20:31.538348	\N	\N
104	32	1	1	2021-09-27 18:20:31.543735	\N	\N
105	32	33	1	2021-09-27 18:20:31.548659	\N	\N
106	32	19	1	2021-09-27 18:20:31.553601	\N	\N
107	32	37	1	2021-09-27 18:20:31.558652	\N	\N
108	32	38	1	2021-09-27 18:20:31.56356	\N	\N
109	32	39	1	2021-09-27 18:20:31.568514	\N	\N
93	23	31	1	2021-08-25 16:04:00.691835	\N	2021-09-27 18:34:27.107215
94	23	29	1	2021-08-25 16:04:00.697044	\N	2021-09-27 18:34:29.595555
95	23	30	1	2021-08-25 16:04:00.701856	\N	2021-09-27 18:34:31.819913
45	1	1	1	2021-07-25 14:57:29.589924	\N	2021-10-04 02:36:52.822068
54	1	21	1	2021-08-24 14:47:50.604591	\N	2021-10-04 02:36:57.840858
98	1	20	1	2021-09-16 11:52:04.827135	\N	2021-10-04 02:38:30.710688
116	1	33	1	2021-10-06 19:26:32.566258	\N	\N
115	1	20	1	2021-10-06 19:26:32.559089	\N	2021-10-06 19:27:21.32506
117	1	1	1	2021-10-06 19:27:25.24934	\N	\N
92	11	25	1	2021-08-25 15:07:11.360628	\N	2021-10-08 11:16:01.87267
118	11	25	1	2021-10-08 11:18:15.525041	\N	\N
119	11	61	1	2021-10-08 11:18:15.532334	\N	\N
110	23	17	1	2021-09-27 18:34:41.964046	\N	2021-10-12 16:33:33.472113
114	23	26	1	2021-09-27 18:34:41.985629	\N	2021-10-12 16:33:38.41605
111	23	25	1	2021-09-27 18:34:41.969753	\N	2021-10-12 16:33:40.395672
112	23	15	1	2021-09-27 18:34:41.975096	\N	2021-10-12 16:33:42.567074
113	23	14	1	2021-09-27 18:34:41.980338	\N	2021-10-12 16:33:44.296855
120	23	14	1	2021-10-12 16:33:57.471146	\N	\N
121	23	15	1	2021-10-12 16:33:57.47755	\N	\N
122	23	17	1	2021-10-12 16:33:57.482969	\N	\N
123	23	26	1	2021-10-12 16:33:57.488115	\N	\N
124	23	61	1	2021-10-12 16:33:57.492958	\N	\N
125	23	25	1	2021-10-12 16:33:57.49773	\N	\N
\.


--
-- Data for Name: store_merchants; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_merchants (id, store_id, merchant_id, status, created_at, updated_at, deleted_at) FROM stdin;
1	1	1	1	2021-07-12 14:36:14.257555	\N	\N
2	2	2	1	2021-07-13 07:43:37.334578	\N	\N
3	3	3	1	2021-07-13 09:28:01.45992	\N	\N
4	4	5	1	2021-07-30 09:30:43.82975	\N	\N
5	5	5	1	2021-07-30 09:39:06.515688	\N	\N
6	6	7	1	2021-08-02 19:48:48.60682	\N	\N
7	7	7	1	2021-08-02 20:01:46.902617	\N	\N
8	8	7	1	2021-08-03 16:26:40.601383	\N	\N
9	9	7	1	2021-08-03 16:26:56.535162	\N	\N
10	10	8	1	2021-08-05 16:37:34.120805	\N	\N
11	11	5	1	2021-08-11 11:33:47.070531	\N	\N
12	12	9	1	2021-08-23 21:13:44.522167	\N	\N
13	13	1	1	2021-08-24 09:52:43.81864	\N	\N
14	14	1	1	2021-08-24 10:09:26.949753	\N	\N
15	15	10	1	2021-08-24 10:41:45.967062	\N	\N
16	16	11	1	2021-08-24 10:48:17.48392	\N	\N
17	17	12	1	2021-08-24 13:42:38.469326	\N	\N
18	18	13	1	2021-08-24 14:13:19.31553	\N	\N
19	19	14	1	2021-08-25 04:34:03.816242	\N	\N
20	20	15	1	2021-08-25 04:35:38.083836	\N	\N
21	21	16	1	2021-08-25 09:45:31.605258	\N	\N
22	22	17	1	2021-08-25 13:25:52.527583	\N	\N
23	23	18	1	2021-08-25 15:59:34.090465	\N	\N
24	24	19	1	2021-08-25 17:54:31.236239	\N	\N
25	25	20	1	2021-08-29 02:19:48.471574	\N	\N
26	26	21	1	2021-08-29 06:29:18.885329	\N	\N
27	27	1	1	2021-08-30 03:43:53.451579	\N	\N
28	28	1	1	2021-08-30 06:06:24.016965	\N	\N
29	29	1	1	2021-08-30 06:33:59.162583	\N	\N
30	30	22	1	2021-08-30 08:43:13.808269	\N	\N
31	31	23	1	2021-09-16 09:19:53.708246	\N	\N
32	32	18	1	2021-09-16 18:39:42.846406	\N	\N
33	33	1	1	2021-09-22 18:54:22.058116	\N	\N
34	34	1	1	2021-09-22 19:29:43.210206	\N	\N
35	35	1	1	2021-09-22 19:36:01.869185	\N	\N
36	36	1	1	2021-09-22 19:37:54.215745	\N	\N
37	37	1	1	2021-09-28 17:21:53.007749	\N	\N
38	38	1	1	2021-10-07 10:50:11.357292	\N	\N
39	39	5	1	2021-10-11 05:15:07.514546	\N	\N
40	40	26	1	2021-10-12 17:03:27.757002	\N	\N
41	41	27	1	2021-10-14 06:16:07.20989	\N	\N
\.


--
-- Data for Name: store_mis; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_mis (id, date, order_delivered, order_canceled, new_items_added, average_order_value, total_order_value, total_discount_value, delivery_fees, commision, turnover, total_tax, store_id, created_at, updated_at, deleted_at) FROM stdin;
1	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	22	2021-09-23 09:04:52.906764	\N	\N
2	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	24	2021-09-23 09:04:52.936081	\N	\N
3	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	21	2021-09-23 09:04:52.963349	\N	\N
4	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	18	2021-09-23 09:04:52.99295	\N	\N
5	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	2	2021-09-23 09:04:53.078233	\N	\N
6	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	25	2021-09-23 09:04:53.105579	\N	\N
7	2021-09-23 00:00:00	0	1	0	0	0	0	0	0	0	0	11	2021-09-23 09:04:53.132881	\N	\N
8	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	10	2021-09-23 09:04:53.161756	\N	\N
9	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	32	2021-09-23 09:04:53.188877	\N	\N
10	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	1	2021-09-23 09:04:53.215688	\N	\N
11	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	12	2021-09-23 09:04:53.242852	\N	\N
12	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	33	2021-09-23 09:04:53.271022	\N	\N
13	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	23	2021-09-23 09:04:53.301387	\N	\N
14	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	34	2021-09-23 09:04:53.329035	\N	\N
15	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	35	2021-09-23 09:04:53.356358	\N	\N
16	2021-09-23 00:00:00	0	0	0	0	0	0	0	0	0	0	36	2021-09-23 09:04:53.383482	\N	\N
\.


--
-- Data for Name: store_payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.store_payments (id, store_id, beneficiary_name, name_of_bank, ifsc_code, vpa, account_number, status, created_at, updated_at, deleted_at, confirmed) FROM stdin;
12	21	Ritika Prajapati	HDFC	HDFC123	123@okicici	12556478353	1	2021-08-25 11:22:13.408486	\N	\N	\N
14	23	Parthib Ghosh	State Bank Of India	SBIN0000068	abcd@ybl	hdhdhdhdhdhhd	1	2021-08-26 16:02:44.321073	\N	2021-08-26 16:09:26.848383	\N
13	1	Merchant1	SBI	SBI124	123@okicici	12556478353	1	2021-08-25 11:27:01.484557	\N	2021-08-25 15:51:36.326045	\N
15	1	Merchant	HDFC	SBI124	123@okicici	12556478353	1	2021-08-31 14:59:20.669524	\N	2021-09-01 10:53:54.105163	\N
16	1	Ritika Prajapati	SBI	SBI124	123@okicici	12556478353	1	2021-09-01 10:54:07.446137	\N	\N	\N
17	1	Ritika Prajapati	SBI	SBI124	123@okicici	12556478353	1	2021-09-13 18:09:04.972711	\N	\N	1
18	23	Parthib Ghosh	State Bank Of India	abc	abc@ybl	53535353535	1	2021-09-20 18:05:58.213592	\N	\N	1
19	32	Parthib Ghosh	State Bank Of India	SBIN0000068	abcd@ybl	53535353535	1	2021-09-27 18:42:46.308774	\N	\N	1
20	37	Anuraj	KOTAK	G5435	4843	4354648463	1	2021-10-12 18:11:44.927067	\N	\N	1
\.


--
-- Data for Name: storetaxes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.storetaxes (id, store_id, name, description, tax_type, amount, created_at, updated_at, deleted_at) FROM stdin;
1	1	CGST	string	1	30	2021-09-13 18:26:00.321412	2021-09-14 07:07:32.308812	2021-09-14 07:07:32.316307
3	1	CGST	string	1	10	2021-09-14 07:09:51.040268	2021-09-14 07:10:07.274094	2021-09-14 07:10:07.281679
5	1	IGST	string	1	23	2021-09-14 09:37:00.060083	2021-09-14 09:37:18.545185	2021-09-14 09:37:18.552806
4	1	GST	string	1	9	2021-09-14 08:50:58.926207	2021-09-14 09:37:52.972578	2021-09-14 09:37:52.980161
2	1	CGST	string	1	8	2021-09-14 06:01:05.086394	2021-09-14 09:38:22.284325	2021-09-14 09:38:22.29231
6	1	CGST	string	1	8	2021-09-14 09:38:54.100578	2021-09-14 09:39:09.106251	2021-09-14 09:39:09.114301
7	1	CGST	string	1	23	2021-09-14 09:40:43.548809	2021-09-14 09:40:54.146271	2021-09-14 09:40:54.154034
9	1	GST	string	1	9	2021-09-15 13:38:34.973947	2021-09-15 13:38:34.964128	\N
11	23	Custom	string	2	30	2021-09-22 18:51:53.554043	2021-09-22 18:59:12.070018	\N
10	11	value	string	2	40	2021-09-22 05:30:34.605465	2021-09-23 12:57:16.672486	\N
12	1	VAT	string	2	30	2021-09-27 18:13:09.213481	2021-09-27 18:13:58.151541	\N
13	32	aa	string	2	30	2021-09-27 18:15:13.707007	2021-09-27 18:15:19.480334	2021-09-27 18:15:19.488163
14	32	aa	string	2	30	2021-09-27 18:15:31.031978	2021-09-27 18:15:31.021617	\N
16	11	TNNN	string	2	10	2021-10-08 08:15:42.943022	2021-10-08 08:16:23.405365	\N
15	32	aaa	string	2	20	2021-09-27 18:15:51.941147	2021-10-13 17:43:40.14109	\N
8	1	CGST	string	1	8	2021-09-14 09:41:52.426489	2021-10-14 12:03:32.430866	\N
\.


--
-- Data for Name: super_admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.super_admin (id, email, name, password_hash, active, phone, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at, image) FROM stdin;
1	qwerty@gmail.com	Ratul	$2b$12$sSXLjMJA4s2iskyN.7tCoeQJY4siZbtJV.6scJLiXpqnRUq7OervK	f	9956630830	super_admin	\N	\N	2021-07-12 13:42:52.022504	2021-07-12 13:42:52.022504	\N	\N
\.


--
-- Data for Name: supervisor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supervisor (id, email, name, password_hash, active, phone, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at, image) FROM stdin;
1	supervisor@gmail.com	The Supervisor	$2b$12$qYRxnL8eTRowGZuCgP3Fg.vP.T7xC4o.1QaPjqlhtYM6zthm5u4F.	f	9876543210	supervisor	\N	\N	2021-07-23 12:11:37.255769	2021-07-23 12:11:37.249763	\N	\N
2	ram@gmail.com	ram	$2b$12$1lk2T8ccJ0GdQZFJ97GQ2uFxNvcf7YIICKXniTQo0X1FPueznxV.m	f	7576575541	supervisor	\N	\N	2021-07-27 02:47:33.892513	2021-07-27 02:47:33.887869	\N	\N
3	fhxcfdhr@email.com	jeet	$2b$12$YSyJvWJBepmA9h4v1wtuC.PgNHCxhSvcVTjasieyf3RktuefLYuwq	f	70014386	supervisor	\N	\N	2021-07-27 05:36:34.052737	2021-07-27 05:36:34.048138	\N	\N
4	test2@gmail.com	test2	$2b$12$Uhc7TB1kqfB9a7Up7hQkueACDijbd.0gEXQdD4WeXlKSb/DjLDMtK	f	535435435	supervisor	\N	\N	2021-07-27 10:44:01.456223	2021-07-27 10:44:01.451728	\N	\N
5	raw@email.com	wsetw	$2b$12$BhsWqufpK18hbHoiQPnBaOb8aQ1SsnnaJT5.eeBnO4k.xiFGpchee	f	452	supervisor	\N	\N	2021-07-27 10:47:58.934817	2021-07-27 10:47:58.930108	\N	\N
6	now@gmail.com	now	$2b$12$/yeAYynT9XtASoiYyAHDNeUOlkOFgIAzexMPDrEk0ekzklDIRQ0Sa	f	141443	supervisor	\N	\N	2021-07-29 14:30:39.012257	2021-07-29 14:30:39.006293	\N	\N
7	ramu@gmail.com	rmu	$2b$12$0aNu8u0UkpDLSF1ICP7rme3l/bFh1esaKgRC2FTh4YDuK2oGzB/zu	f	4354353	supervisor	\N	\N	2021-08-03 14:09:45.585041	2021-08-03 14:09:45.578822	\N	\N
8	praja.ritika.94@gmail.com	Ritika prajapati	$2b$12$H.BwtH6p68xw1Sc7aguqN.PTbWJgsl3JO8aL8DeF14n/NWhpjInTq	f	8757445651	supervisor	\N	\N	2021-08-24 12:10:44.386167	2021-08-24 12:10:44.380533	\N	\N
9	rosupervisor@gmail.com	ro supervisor	$2b$12$09TZz02D5X38fvNn0LKaB.f4mlC.kBue.ihgpaAAr.w.SzVhWHeUC	f	1234567899	supervisor	\N	\N	2021-08-31 07:09:13.013325	2021-08-31 07:09:13.008302	\N	\N
10	atrayan	Atrayan	$2b$12$n7JhDNnj6suAfINxy68iMO.2/nHwXynPOhu.BF9kfbkYcX0gvxq42	f	9007411811	supervisor	\N	\N	2021-09-08 03:24:01.93029	2021-09-08 03:24:01.921901	\N	\N
11	abc@gmail.com	abc	$2b$12$IiZXF/Jd2Cx7hPGCwFGNievQYMy.lHTkXxQ.nUoFNLt1S/W5Eeg96	f	658789768	supervisor	\N	\N	2021-09-15 06:27:46.839039	2021-09-15 06:27:46.833993	\N	\N
12	zyz@gmail.com	xyz	$2b$12$8D4eprbHYYhoO2hhEeVy3OG0XsUDfDkyYwsPvtifYW8vOxawEc4La	f	554235585	supervisor	\N	\N	2021-09-30 08:53:27.928021	2021-09-30 08:53:27.92184	\N	\N
13	ayu@gmail.com	ayu	$2b$12$ghP.J9RhvdC.6ZE99Y7mfe7m.YY0P54kgJTyuCVpZhcehHsKhNN4i	f	3435657778	supervisor	\N	\N	2021-09-30 08:55:50.211974	2021-09-30 08:55:50.20632	\N	\N
14	qw@gmail.com	qw	$2b$12$GJg8rriOk6VvkQhnDi1u9u8dsClPYG4EJu4zbSJzsGIROTokP3cuu	f	24237856396	supervisor	\N	\N	2021-09-30 09:01:02.01614	2021-09-30 09:01:02.00934	\N	\N
\.


--
-- Data for Name: supervisor_otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.supervisor_otp (id, "isVerified", counter, otp) FROM stdin;
\.


--
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, txnid, amount, productinfo, firstname, email, phone, url, hash_, key, salt, open_payment_token, open_payment_data, payu_gateway_response, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, email, name, password_hash, active, phone, role, email_verified_at, phone_verified_at, created_at, updated_at, deleted_at, image) FROM stdin;
1	Theon1947@einrot.com	simpi	$2b$12$yN/JI6g77xvYiu2mk5x.4Odn.y1sGlmIy5W.N503/SEGPZ9FEHPYO	t	1230980000	customer	2021-07-12 13:36:07.562197	\N	2021-07-12 13:34:24.577993	2021-07-12 13:36:07.560693	\N	\N
2	simpi@armyspy.com	simpi	$2b$12$AqIVQk8fMV1cArc11gX/IunNWotGenjys1QsQYiM/LwrbjQZiFknq	t	1234567890	customer	2021-07-13 07:19:01.088297	\N	2021-07-13 07:17:21.869682	2021-07-13 07:19:01.087209	\N	\N
3	string	string	$2b$12$R9X733HQGQX39oYLD7ufZe.NDMdhJC5wD6A9iQ8Z2PlRyPAs0D8xu	f	string	customer	\N	\N	2021-07-15 18:43:49.351543	2021-07-15 18:43:49.348917	\N	\N
5	simpii@armyspy.com	simmi	$2b$12$vfKUPgyMTv43jtAmGfl6Heb2WIBc2MtH67CV66hflqn0e74M/6ufS	t	3456789909	customer	2021-07-23 09:52:05.116035	\N	2021-07-23 09:50:56.149077	2021-07-23 09:52:05.115255	\N	\N
6	sim@armyspy.com	sim	$2b$12$OkJTK7JD3hA8uHuhzzhi0OT86N5Qnzo8O/gTtW7mJ/wAnRNO2/d6K	t	1111100000	customer	2021-07-23 10:02:44.553257	\N	2021-07-23 10:01:36.63954	2021-07-23 10:02:44.552481	\N	\N
8	parthib.ghosh103@gmail.com	Parthib	$2b$12$7ldHpMSpI8hOX5xZz5dZ9.4Od12OIIfHwVNEtNG8HX.NNHgA1xLOy	f	85989467222	customer	\N	\N	2021-08-02 05:41:42.635146	2021-08-02 05:41:42.632524	\N	\N
10	rajesh@gmail.com	rajesh	$2b$12$FfrbcJpOPzSDPwwQTw8cne7EaYcD6XJGkKtVuuFFPfbYYWEwhBBpW	f	7724083836	customer	\N	\N	2021-08-09 19:26:58.369346	2021-08-09 19:26:58.366484	\N	\N
11	rajesh111@gmail.com	rajesh	$2b$12$Q.c2S/lR3t6rnfvRpNCFB.rYLjt3/L1VOgqLNW7NA0kyOGRBH1m66	f	7724083837	customer	2021-08-02 06:04:00	\N	2021-08-09 19:30:28.918825	2021-08-09 19:30:28.91686	\N	\N
12	simpisingh21@gmail.com	simpi	$2b$12$7T3ndtBY2vPbYSlHt33lTujxvNtNp.9pqg2Yaa2dv53cvQyicjBvq	t	1234764764	customer	2021-08-11 09:15:56.864718	\N	2021-08-11 09:15:26.402605	2021-08-11 09:15:56.863983	\N	\N
14	abc@armyspy.com	simpiii	$2b$12$5QVW8ckwbhhV5HdfS7fzxOFCejAaXXuUQk7XK4waNaHQahrPatNFm	t	1010101010	customer	2021-08-11 13:25:11.092076	\N	2021-08-11 13:18:52.731992	2021-08-11 13:25:11.090796	\N	\N
15	dg@gmail.com	Dg	$2b$12$w6CE2RrPDXGjCzj/KOxU4O8JPlPg48JVDIhfw.VEeATsAi76m4UYy	f	9876543210	customer	\N	\N	2021-08-25 07:29:50.691794	2021-08-25 07:29:50.689781	\N	\N
16	praja.ritika.94@gmail.com	Ritika prajapati	$2b$12$tpWThr8W6fUg.1t9XDdWgOD9OhziQLAy24V1G66diiRpHCy.WXLGi	f	8757445651	customer	\N	\N	2021-08-25 15:01:47.178081	2021-08-25 15:01:47.176001	\N	\N
17	atrayan33@gmail.com	Atrayan Mukherjee	$2b$12$kstd26UQ/x7vSBm1JypBTuy.O9rSgjQocdvf.gXGhPZIr6Qn7OyA.	f	9007411811	customer	\N	\N	2021-08-25 21:06:14.812823	2021-08-25 21:06:14.810732	\N	\N
18	fidoubt@gmail.com	doubtfix	$2b$12$x5Sgd20K/8Bfe8L6aHoXjulItj2tt617LjDgC3NSQUBq2V9dZGR46	f	1234567123	customer	\N	\N	2021-08-29 17:31:19.195007	2021-08-29 17:31:19.19297	\N	\N
20	atrayan37@gmail.com	Atrayan	$2b$12$mcYmuL3AwNSjjweVQ7ajj.ECqc12PqazA.DyscXWL9jsfruFIYhS2	f	9007411812	customer	\N	\N	2021-09-22 18:51:02.641854	2021-09-22 18:51:02.639766	\N	\N
21	anurajsingh883@gmail.com	Anuraj	$2b$12$jTDe8oEeYSG5IUQX73JH5eotdVA5G5RtS/qvusTwtBpifSC0nJmJu	t	9007712266	customer	2021-09-24 19:54:12.521151	\N	2021-09-24 14:21:27.855487	2021-09-24 19:54:12.520328	\N	\N
4	simpi@isl.net.in	simmi singh	$2b$12$REisE3WcIN23z4a7J8lD1OYUUamvXp3gKzl0NCx.bY2WbealPkovG	t	9509524971	customer	2021-07-20 12:19:34.378092	\N	2021-07-20 12:18:37.099167	2021-10-08 11:04:28.745208	\N	\N
19	shishir@isl.net.in	shishir	$2b$12$r01i/QAUnaYcbMzaVR4o7OsMeXyMjt7dGrpyFp1LHeK2eQtIlxADW	f	1234567898	customer	\N	\N	2021-09-05 17:18:20.022497	2021-10-17 15:23:39.894879	\N	\N
13	rajeshthakur1r@gmail.com	simpi	$2b$12$AXa2WWDgngPv52F79AAx..JwK.CfwzmN7CvSUVcyfpl.ib0HwDZne	t	1111111111	customer	2021-08-11 09:19:24.022208	\N	2021-08-11 09:18:57.874747	2021-10-05 13:46:26.375354	\N	\N
9	parthib85989@gmail.com	ParthibGhosh	$2b$12$zkMGT0meJsy7IXJeu1DdT.KBFrQNfv8oua79iBCiFXrzPEOz4EWg.	t	7795016331	customer	2021-08-02 06:04:00.310166	\N	2021-08-02 05:44:40.237774	2021-10-05 20:19:33.874054	\N	\N
7	rohinipatilrp20@gmail.com	Rohini P	$2b$12$lL7CHr6l.8UesSrJfNugMeawtKrIZd2cOCaH.Ktgrg4bA3HHYMkl2	t	7845424878	customer	2021-07-25 15:06:23.284744	\N	2021-07-25 15:05:56.074703	2021-10-08 10:28:25.207927	\N	\N
\.


--
-- Data for Name: user_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_address (id, user_id, address1, address2, address3, landmark, phone, latitude, longitude, status, created_at, updated_at, deleted_at, city_id) FROM stdin;
3	2	address1	address2	address3	landmark abc	1234567890	19.0759837	72.8776559	1	2021-07-13 07:58:37.179056	\N	\N	\N
4	2	add1	add2	add3	landmarj	1234578900	19.0759837	72.8776559	1	2021-07-21 15:07:22.927094	\N	\N	\N
5	6	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#acbv	address3	landmark k	1234567890	19.0759837	72.8776559	1	2021-07-24 08:41:35.698693	\N	\N	\N
6	2	B1-402	Ajnara Homes	Near Punchsheel	Noida extension	7845122356	19.075985	72.877655	1	2021-07-25 14:52:52.646464	\N	\N	\N
8	6	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#ssss	address3	landmark	1234560000	19.0759837	72.8776559	1	2021-07-27 13:42:52.919883	\N	\N	\N
13	2	A2	B2	C2	D2	8975421884	19.075985	72.877655	1	2021-08-04 17:04:53.231156	\N	\N	\N
18	14	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#342	address3	landmark	9509524971	19.0759837	72.8776559	1	2021-08-12 13:32:41.421801	\N	\N	\N
21	13	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#345	address3	landmark	1093847556	19.0759837	72.8776559	1	2021-08-25 08:11:49.287769	\N	\N	\N
22	13	Park Street, Park Street area, Kolkata, West Bengal 700071, India	#345	address3	landmark	2344555999	22.55445	88.34984999999999	1	2021-08-25 10:11:50.121261	\N	\N	\N
19	13	Abhishek, Apartment B, 35, Lokhandwala Complex Rd, Lokhandwala Complex, Andheri West, Mumbai, Maharashtra 400053, India	#345 hsr layout	address3	landmark k	8888888888	0	0	1	2021-08-13 11:50:44.129517	\N	\N	\N
27	13	Quest mall, lathar complax, Cossipore, Newland, College Square, Kolkata, West Bengal 700012, India	#67888	address3	landmark	2623736276	22.572646	88.36389500000001	1	2021-08-27 07:34:12.155602	\N	\N	\N
28	13	Quest mall, lathar complax, Cossipore, Newland, College Square, Kolkata, West Bengal 700012, India	#dfg	address3	landmark	4545676677	22.572646	88.36389500000001	1	2021-08-27 07:35:53.11627	\N	\N	\N
29	13	Quest mall, lathar complax, Cossipore, Newland, College Square, Kolkata, West Bengal 700012, India	#3456	address3	landmark	1234566789	22.572646	88.36389500000001	1	2021-08-27 10:41:19.891293	\N	\N	\N
30	4	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#345	address3	landmark	2345678900	19.0759837	72.8776559	1	2021-08-31 05:57:18.270883	\N	\N	1
31	13	b wing green view sosaity, Lower Parel, Friends Colony, Babhai Naka, Borivali West, Mumbai, Maharashtra 400070, India	#123	address3	landmark	1234567890	19.0759837	72.8776559	1	2021-08-31 06:57:25.81133	\N	\N	1
32	13	2, HSR Layout, Vinayak nagar, D' Souza Layout, Electronic City, Bengaluru, Karnataka 560100, India	#eeeee	address3	landmark	1234567890	12.9715987	77.5945627	1	2021-08-31 09:58:07.734955	\N	\N	2
33	13	Quest mall, lathar complax, Cossipore, Newland, College Square, Kolkata, West Bengal 700012, India	11	address3	landmark	9007712266	22.572646	88.36389500000001	1	2021-09-09 10:50:22.1353	\N	\N	19
34	14	2, HSR Layout, Vinayak nagar, D' Souza Layout, Electronic City, Bengaluru, Karnataka 560100, India	hh	address3	landmark	9999999999	12.9715987	77.5945627	1	2021-09-09 12:42:48.82447	\N	\N	2
38	13	Ram Tonde, Mumbai Airport, Lower Parel, Friends Colony, Hallow Pul, Kurla, Mumbai, Maharashtra 400070, India	#345	address3	landmark	2334456772	19.0759837	72.8776559	1	2021-09-21 14:42:00.607655	\N	\N	1
39	13	abc	abc	abc	landmark	1234567890	12.9715987	77.5945627	1	2021-09-21 14:45:05.968232	\N	\N	2
40	7	420, 100 Feet Rd, KHB Colony, Koramangala 4th Block, Koramangala, Bengaluru, Karnataka 560034, India	123	address3	landmark	1234567899	12.9351929	77.62448069999999	1	2021-09-22 14:46:46.050897	\N	\N	2
41	7	mumbai	123	address3	landmark	4545454454	12.9351929	77.62448069999999	1	2021-09-23 07:06:20.075664	\N	\N	2
43	7	chennai	122	address3	landmark	8514222222	12.9351929	77.62448069999999	1	2021-09-23 12:44:59.765396	\N	\N	2
44	2	Ram Tonde, Mumbai Airport, Lower Parel, Friends Colony, Hallow Pul, Kurla, Mumbai, Maharashtra 400070, India	Mumbai	address3	landmark	8652265563	19.0759837	72.8776559	1	2021-09-24 09:08:33.062083	\N	\N	1
26	9	1st Cross, Borivali, Mumbai	#22	address3	landmar	7795016339	19.075983	72.877655	1	2021-08-26 15:20:49.742587	\N	\N	13
16	9	#22	1st Cross	BTM	Map me dekh lo	5363737373	12.928218	77.609024	1	2021-08-11 18:34:03.814865	\N	\N	13
46	9	22	1st crosa	Vishwas Bar and Restaurant 	Vishwas Bar and Restaurant 	0000000000	12.928095	77.60906	1	2021-10-05 19:34:34.758486	\N	\N	2
47	9	qw	qw	qw	qw	6565656565	12.9715987	77.5945627	1	2021-10-05 19:42:33.726389	\N	\N	2
48	9	22	New	New	New	2222222222	12.928095	77.60906	1	2021-10-05 20:01:33.285236	\N	\N	2
49	7	a	s	s	We	9690000000	12.971599	77.59457	1	2021-10-06 05:49:25.750846	\N	\N	2
42	7	88	555555	44	123	8522554555	0	0	1	2021-09-23 12:37:38.126628	\N	\N	2
45	13	wwwww	wwwww	wwwww k	wwwww k	1010101010	0	0	1	2021-10-04 16:42:17.468473	\N	\N	1
36	7	E-1103	Ajnara Homes	near Punchsheel greennn	ek moorthy	7845123355	0	0	1	2021-09-13 16:34:36.156825	\N	\N	2
50	7	Ram Tonde, Mumbai Airport, Lower Parel, Friends Colony, Hallow Pul, Kurla, Mumbai, Maharashtra 400070, India	123	address3	landmark	9419419441	19.0759837	72.8776559	1	2021-10-08 13:44:05.460309	\N	\N	1
51	19	Ram Tonde, Mumbai Airport, Lower Parel, Friends Colony, Hallow Pul, Kurla, Mumbai, Maharashtra 400070, India	#342	address3	landmark	9509524971	19.0759837	72.8776559	1	2021-10-17 15:25:08.268916	\N	\N	1
52	19	2, HSR Layout, Vinayak nagar, D' Souza Layout, Electronic City, Bengaluru, Karnataka 560100, India	#342	address3	landmark	9509524971	12.9715987	77.5945627	1	2021-10-17 15:26:07.300584	\N	\N	2
\.


--
-- Data for Name: user_cities; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_cities (id, user_id, city_id, role, status, created_at, updated_at, deleted_at) FROM stdin;
2	2	2	supervisor	1	2021-07-27 02:47:34.198428	\N	\N
5	4	1	supervisor	1	2021-07-27 10:44:01.762227	\N	\N
6	5	1	supervisor	1	2021-07-27 10:47:59.24028	\N	\N
7	5	2	supervisor	1	2021-07-27 10:47:59.244396	\N	\N
9	4	1	supervisor	1	2021-07-29 14:28:10.994439	\N	\N
10	6	2	supervisor	1	2021-07-29 14:30:39.317557	\N	\N
12	6	1	supervisor	1	2021-07-29 14:32:40.810175	\N	2021-07-29 15:18:25.482299
11	6	1	supervisor	1	2021-07-29 14:32:16.980348	\N	2021-07-29 15:18:32.632795
13	6	1	supervisor	1	2021-07-29 15:29:51.441349	\N	\N
14	6	1	supervisor	1	2021-07-29 15:32:34.181416	\N	\N
3	3	1	supervisor	1	2021-07-27 05:36:34.358475	\N	2021-08-02 04:41:49.938171
4	3	2	supervisor	1	2021-07-27 05:36:34.362648	\N	2021-08-02 04:41:54.52937
1	1	1	supervisor	1	2021-07-23 12:11:37.561655	\N	2021-08-02 04:43:02.338401
8	1	1	supervisor	1	2021-07-29 14:26:21.747987	\N	2021-08-02 04:46:22.878576
16	1	2	supervisor	1	2021-08-02 04:46:34.519103	\N	2021-08-02 04:48:10.077872
15	1	1	supervisor	1	2021-08-02 04:46:34.516416	\N	2021-08-02 04:48:12.318124
17	1	8	supervisor	1	2021-08-02 04:46:34.521109	\N	2021-08-02 04:48:15.008072
18	1	1	supervisor	1	2021-08-02 04:48:20.507099	\N	\N
20	1	8	supervisor	1	2021-08-02 04:48:20.512496	\N	\N
21	1	2	supervisor	1	2021-08-02 05:29:55.784258	\N	2021-08-02 05:29:59.437297
22	7	2	supervisor	1	2021-08-03 14:09:45.890039	\N	\N
23	7	8	supervisor	1	2021-08-03 14:09:45.894134	\N	\N
24	7	1	supervisor	1	2021-08-03 14:11:17.47357	\N	\N
25	7	1	supervisor	1	2021-08-03 14:11:55.620685	\N	\N
26	7	2	supervisor	1	2021-08-03 14:11:55.623975	\N	\N
27	7	8	supervisor	1	2021-08-03 14:11:55.626012	\N	\N
28	7	1	supervisor	1	2021-08-03 14:12:10.263944	\N	\N
29	7	2	supervisor	1	2021-08-03 14:12:10.265975	\N	\N
30	7	8	supervisor	1	2021-08-03 14:12:10.26818	\N	\N
31	5	1	supervisor	1	2021-08-03 14:12:57.475644	\N	\N
32	5	2	supervisor	1	2021-08-03 14:12:57.477715	\N	\N
33	5	8	supervisor	1	2021-08-03 14:12:57.479802	\N	\N
19	1	2	supervisor	1	2021-08-02 04:48:20.510354	\N	2021-08-05 13:55:48.485091
34	1	10	supervisor	1	2021-08-05 13:55:55.471727	\N	\N
35	8	1	supervisor	1	2021-08-24 12:10:44.692015	\N	2021-08-24 20:53:56.095176
36	8	1	supervisor	1	2021-08-24 21:11:14.531445	\N	\N
37	1	2	supervisor	1	2021-08-25 07:32:11.833763	\N	\N
38	9	2	supervisor	1	2021-08-31 07:09:13.318726	\N	\N
39	9	10	supervisor	1	2021-08-31 07:09:13.323316	\N	\N
40	9	8	supervisor	1	2021-08-31 07:09:13.327097	\N	\N
41	9	1	supervisor	1	2021-08-31 07:09:13.330334	\N	\N
42	10	1	supervisor	1	2021-09-08 03:24:02.237059	\N	\N
43	10	2	supervisor	1	2021-09-08 03:24:02.242034	\N	\N
44	10	11	supervisor	1	2021-09-08 03:24:02.24529	\N	\N
45	11	11	supervisor	1	2021-09-15 06:27:47.144788	\N	\N
46	12	11	supervisor	1	2021-09-30 08:53:28.234052	\N	\N
47	12	8	supervisor	1	2021-09-30 08:53:28.238801	\N	\N
48	12	19	supervisor	1	2021-09-30 08:53:28.242235	\N	\N
49	13	11	supervisor	1	2021-09-30 08:55:50.517671	\N	\N
50	14	8	supervisor	1	2021-09-30 09:01:02.322121	\N	\N
\.


--
-- Data for Name: user_otp; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_otp (id, "isVerified", counter, otp) FROM stdin;
3	t	9	4
2	f	13	13
1	t	13	19
4	t	21	12
5	f	1	14
6	t	4	7
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 17, true);


--
-- Name: admin_otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_otp_id_seq', 1, false);


--
-- Name: blacklist_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.blacklist_tokens_id_seq', 1295, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categories_id_seq', 26, true);


--
-- Name: cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cities_id_seq', 25, true);


--
-- Name: city_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.city_categories_id_seq', 69, true);


--
-- Name: citymisdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.citymisdetail_id_seq', 12, true);


--
-- Name: coupon_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupon_categories_id_seq', 135, true);


--
-- Name: coupon_cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupon_cities_id_seq', 60, true);


--
-- Name: coupon_merchants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupon_merchants_id_seq', 4, true);


--
-- Name: coupon_stores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupon_stores_id_seq', 4, true);


--
-- Name: coupons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.coupons_id_seq', 61, true);


--
-- Name: delivery_agent_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.delivery_agent_id_seq', 2, true);


--
-- Name: distributor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.distributor_id_seq', 1, true);


--
-- Name: hub_bank_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hub_bank_details_id_seq', 1, false);


--
-- Name: hub_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hub_id_seq', 1, false);


--
-- Name: hub_order_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hub_order_lists_id_seq', 1, false);


--
-- Name: hub_order_tax_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hub_order_tax_id_seq', 1, false);


--
-- Name: hub_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hub_orders_id_seq', 1, false);


--
-- Name: hubtaxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.hubtaxes_id_seq', 1, false);


--
-- Name: item_order_lists_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_order_lists_id_seq', 1609, true);


--
-- Name: item_order_tax_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_order_tax_id_seq', 364, true);


--
-- Name: item_orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.item_orders_id_seq', 676, true);


--
-- Name: localities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.localities_id_seq', 27, true);


--
-- Name: menu_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menu_categories_id_seq', 61, true);


--
-- Name: merchant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.merchant_id_seq', 27, true);


--
-- Name: merchant_otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.merchant_otp_id_seq', 1, false);


--
-- Name: merchant_transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.merchant_transactions_id_seq', 1, false);


--
-- Name: misdetail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.misdetail_id_seq', 4, true);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_id_seq', 1, false);


--
-- Name: notification_templates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_templates_id_seq', 1, false);


--
-- Name: progress_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.progress_id_seq', 3, true);


--
-- Name: quantity_unit_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.quantity_unit_id_seq', 8, true);


--
-- Name: refund_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.refund_id_seq', 1, false);


--
-- Name: session_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.session_id_seq', 94, true);


--
-- Name: store_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_categories_id_seq', 107, true);


--
-- Name: store_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_id_seq', 41, true);


--
-- Name: store_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_item_id_seq', 158, true);


--
-- Name: store_item_uploads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_item_uploads_id_seq', 1, false);


--
-- Name: store_item_variable_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_item_variable_id_seq', 249, true);


--
-- Name: store_localities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_localities_id_seq', 1, false);


--
-- Name: store_menu_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_menu_categories_id_seq', 125, true);


--
-- Name: store_merchants_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_merchants_id_seq', 41, true);


--
-- Name: store_mis_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_mis_id_seq', 16, true);


--
-- Name: store_payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.store_payments_id_seq', 20, true);


--
-- Name: storetaxes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.storetaxes_id_seq', 16, true);


--
-- Name: super_admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.super_admin_id_seq', 1, true);


--
-- Name: supervisor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supervisor_id_seq', 14, true);


--
-- Name: supervisor_otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.supervisor_otp_id_seq', 1, false);


--
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);


--
-- Name: user_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_address_id_seq', 52, true);


--
-- Name: user_cities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_cities_id_seq', 50, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 21, true);


--
-- Name: user_otp_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_otp_id_seq', 6, true);


--
-- Name: admin admin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_email_key UNIQUE (email);


--
-- Name: admin_otp admin_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_otp
    ADD CONSTRAINT admin_otp_pkey PRIMARY KEY (id);


--
-- Name: admin admin_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_phone_key UNIQUE (phone);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: blacklist_tokens blacklist_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens
    ADD CONSTRAINT blacklist_tokens_pkey PRIMARY KEY (id);


--
-- Name: blacklist_tokens blacklist_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens
    ADD CONSTRAINT blacklist_tokens_token_key UNIQUE (token);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: city_categories city_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_categories
    ADD CONSTRAINT city_categories_pkey PRIMARY KEY (id);


--
-- Name: citymisdetail citymisdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citymisdetail
    ADD CONSTRAINT citymisdetail_pkey PRIMARY KEY (id);


--
-- Name: coupon_categories coupon_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_categories
    ADD CONSTRAINT coupon_categories_pkey PRIMARY KEY (id);


--
-- Name: coupon_cities coupon_cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_cities
    ADD CONSTRAINT coupon_cities_pkey PRIMARY KEY (id);


--
-- Name: coupon_merchants coupon_merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_merchants
    ADD CONSTRAINT coupon_merchants_pkey PRIMARY KEY (id);


--
-- Name: coupon_stores coupon_stores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_stores
    ADD CONSTRAINT coupon_stores_pkey PRIMARY KEY (id);


--
-- Name: coupons coupons_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_pkey PRIMARY KEY (id);


--
-- Name: delivery_agent delivery_agent_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.delivery_agent
    ADD CONSTRAINT delivery_agent_pkey PRIMARY KEY (id);


--
-- Name: distributor distributor_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distributor
    ADD CONSTRAINT distributor_email_key UNIQUE (email);


--
-- Name: distributor distributor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.distributor
    ADD CONSTRAINT distributor_pkey PRIMARY KEY (id);


--
-- Name: hub_bank_details hub_bank_details_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_bank_details
    ADD CONSTRAINT hub_bank_details_pkey PRIMARY KEY (id);


--
-- Name: hub_order_lists hub_order_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_lists
    ADD CONSTRAINT hub_order_lists_pkey PRIMARY KEY (id);


--
-- Name: hub_order_tax hub_order_tax_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_tax
    ADD CONSTRAINT hub_order_tax_pkey PRIMARY KEY (id);


--
-- Name: hub_orders hub_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_orders
    ADD CONSTRAINT hub_orders_pkey PRIMARY KEY (id);


--
-- Name: hub hub_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub
    ADD CONSTRAINT hub_pkey PRIMARY KEY (id);


--
-- Name: hubtaxes hubtaxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hubtaxes
    ADD CONSTRAINT hubtaxes_pkey PRIMARY KEY (id);


--
-- Name: item_order_lists item_order_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_lists
    ADD CONSTRAINT item_order_lists_pkey PRIMARY KEY (id);


--
-- Name: item_order_tax item_order_tax_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_tax
    ADD CONSTRAINT item_order_tax_pkey PRIMARY KEY (id);


--
-- Name: item_orders item_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_orders
    ADD CONSTRAINT item_orders_pkey PRIMARY KEY (id);


--
-- Name: localities localities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_pkey PRIMARY KEY (id);


--
-- Name: menu_categories menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_categories
    ADD CONSTRAINT menu_categories_pkey PRIMARY KEY (id);


--
-- Name: merchant merchant_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant
    ADD CONSTRAINT merchant_email_key UNIQUE (email);


--
-- Name: merchant_otp merchant_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_otp
    ADD CONSTRAINT merchant_otp_pkey PRIMARY KEY (id);


--
-- Name: merchant merchant_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant
    ADD CONSTRAINT merchant_pkey PRIMARY KEY (id);


--
-- Name: merchant_transactions merchant_transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_transactions
    ADD CONSTRAINT merchant_transactions_pkey PRIMARY KEY (id);


--
-- Name: misdetail misdetail_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.misdetail
    ADD CONSTRAINT misdetail_pkey PRIMARY KEY (id);


--
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: notification_templates notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification_templates
    ADD CONSTRAINT notification_templates_pkey PRIMARY KEY (id);


--
-- Name: progress progress_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress
    ADD CONSTRAINT progress_pkey PRIMARY KEY (id);


--
-- Name: progress progress_uid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.progress
    ADD CONSTRAINT progress_uid_key UNIQUE (uid);


--
-- Name: quantity_unit quantity_unit_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quantity_unit
    ADD CONSTRAINT quantity_unit_pkey PRIMARY KEY (id);


--
-- Name: refund refund_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_pkey PRIMARY KEY (id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (id);


--
-- Name: store_categories store_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_categories
    ADD CONSTRAINT store_categories_pkey PRIMARY KEY (id);


--
-- Name: store_item store_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item
    ADD CONSTRAINT store_item_pkey PRIMARY KEY (id);


--
-- Name: store_item_uploads store_item_uploads_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_uploads
    ADD CONSTRAINT store_item_uploads_pkey PRIMARY KEY (id);


--
-- Name: store_item_variable store_item_variable_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_variable
    ADD CONSTRAINT store_item_variable_pkey PRIMARY KEY (id);


--
-- Name: store_localities store_localities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_localities
    ADD CONSTRAINT store_localities_pkey PRIMARY KEY (id);


--
-- Name: store_menu_categories store_menu_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_menu_categories
    ADD CONSTRAINT store_menu_categories_pkey PRIMARY KEY (id);


--
-- Name: store_merchants store_merchants_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_merchants
    ADD CONSTRAINT store_merchants_pkey PRIMARY KEY (id);


--
-- Name: store_mis store_mis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_mis
    ADD CONSTRAINT store_mis_pkey PRIMARY KEY (id);


--
-- Name: store_payments store_payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_payments
    ADD CONSTRAINT store_payments_pkey PRIMARY KEY (id);


--
-- Name: store store_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_pkey PRIMARY KEY (id);


--
-- Name: storetaxes storetaxes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storetaxes
    ADD CONSTRAINT storetaxes_pkey PRIMARY KEY (id);


--
-- Name: super_admin super_admin_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.super_admin
    ADD CONSTRAINT super_admin_email_key UNIQUE (email);


--
-- Name: super_admin super_admin_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.super_admin
    ADD CONSTRAINT super_admin_phone_key UNIQUE (phone);


--
-- Name: super_admin super_admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.super_admin
    ADD CONSTRAINT super_admin_pkey PRIMARY KEY (id);


--
-- Name: supervisor supervisor_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor
    ADD CONSTRAINT supervisor_email_key UNIQUE (email);


--
-- Name: supervisor_otp supervisor_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor_otp
    ADD CONSTRAINT supervisor_otp_pkey PRIMARY KEY (id);


--
-- Name: supervisor supervisor_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor
    ADD CONSTRAINT supervisor_phone_key UNIQUE (phone);


--
-- Name: supervisor supervisor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor
    ADD CONSTRAINT supervisor_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: user_address user_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address
    ADD CONSTRAINT user_address_pkey PRIMARY KEY (id);


--
-- Name: user_cities user_cities_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_cities
    ADD CONSTRAINT user_cities_pkey PRIMARY KEY (id);


--
-- Name: user user_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_key UNIQUE (email);


--
-- Name: user_otp user_otp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_otp
    ADD CONSTRAINT user_otp_pkey PRIMARY KEY (id);


--
-- Name: user user_phone_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_phone_key UNIQUE (phone);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ix_coupons_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_coupons_code ON public.coupons USING btree (code);


--
-- Name: ix_coupons_expired_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_coupons_expired_at ON public.coupons USING btree (expired_at);


--
-- Name: ix_coupons_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_coupons_status ON public.coupons USING btree (status);


--
-- Name: ix_coupons_target; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_coupons_target ON public.coupons USING btree (target);


--
-- Name: admin_otp admin_otp_otp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin_otp
    ADD CONSTRAINT admin_otp_otp_fkey FOREIGN KEY (otp) REFERENCES public.admin(id);


--
-- Name: city_categories city_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_categories
    ADD CONSTRAINT city_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: city_categories city_categories_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.city_categories
    ADD CONSTRAINT city_categories_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id) ON DELETE CASCADE;


--
-- Name: citymisdetail citymisdetail_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citymisdetail
    ADD CONSTRAINT citymisdetail_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: citymisdetail citymisdetail_mis_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.citymisdetail
    ADD CONSTRAINT citymisdetail_mis_id_fkey FOREIGN KEY (mis_id) REFERENCES public.misdetail(id);


--
-- Name: coupon_categories coupon_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_categories
    ADD CONSTRAINT coupon_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: coupon_categories coupon_categories_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_categories
    ADD CONSTRAINT coupon_categories_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id);


--
-- Name: coupon_cities coupon_cities_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_cities
    ADD CONSTRAINT coupon_cities_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: coupon_cities coupon_cities_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_cities
    ADD CONSTRAINT coupon_cities_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id);


--
-- Name: coupon_merchants coupon_merchants_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_merchants
    ADD CONSTRAINT coupon_merchants_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id) ON DELETE CASCADE;


--
-- Name: coupon_merchants coupon_merchants_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_merchants
    ADD CONSTRAINT coupon_merchants_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchant(id) ON DELETE CASCADE;


--
-- Name: coupon_stores coupon_stores_coupon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_stores
    ADD CONSTRAINT coupon_stores_coupon_id_fkey FOREIGN KEY (coupon_id) REFERENCES public.coupons(id);


--
-- Name: coupon_stores coupon_stores_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupon_stores
    ADD CONSTRAINT coupon_stores_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: coupons coupons_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.coupons
    ADD CONSTRAINT coupons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: hub_bank_details hub_bank_details_hub_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_bank_details
    ADD CONSTRAINT hub_bank_details_hub_id_fkey FOREIGN KEY (hub_id) REFERENCES public.hub(id) ON DELETE CASCADE;


--
-- Name: hub hub_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub
    ADD CONSTRAINT hub_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: hub hub_distributor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub
    ADD CONSTRAINT hub_distributor_id_fkey FOREIGN KEY (distributor_id) REFERENCES public.distributor(id);


--
-- Name: hub_order_lists hub_order_lists_hub_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_lists
    ADD CONSTRAINT hub_order_lists_hub_order_id_fkey FOREIGN KEY (hub_order_id) REFERENCES public.hub_orders(id);


--
-- Name: hub_order_tax hub_order_tax_hub_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_tax
    ADD CONSTRAINT hub_order_tax_hub_order_id_fkey FOREIGN KEY (hub_order_id) REFERENCES public.hub_orders(id);


--
-- Name: hub_order_tax hub_order_tax_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_order_tax
    ADD CONSTRAINT hub_order_tax_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.hubtaxes(id);


--
-- Name: hub_orders hub_orders_hub_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_orders
    ADD CONSTRAINT hub_orders_hub_id_fkey FOREIGN KEY (hub_id) REFERENCES public.hub(id);


--
-- Name: hub_orders hub_orders_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hub_orders
    ADD CONSTRAINT hub_orders_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchant(id);


--
-- Name: hubtaxes hubtaxes_hub_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.hubtaxes
    ADD CONSTRAINT hubtaxes_hub_id_fkey FOREIGN KEY (hub_id) REFERENCES public.hub(id);


--
-- Name: item_order_lists item_order_lists_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_lists
    ADD CONSTRAINT item_order_lists_item_order_id_fkey FOREIGN KEY (item_order_id) REFERENCES public.item_orders(id);


--
-- Name: item_order_tax item_order_tax_item_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_tax
    ADD CONSTRAINT item_order_tax_item_order_id_fkey FOREIGN KEY (item_order_id) REFERENCES public.item_orders(id);


--
-- Name: item_order_tax item_order_tax_tax_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_order_tax
    ADD CONSTRAINT item_order_tax_tax_id_fkey FOREIGN KEY (tax_id) REFERENCES public.storetaxes(id);


--
-- Name: item_orders item_orders_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_orders
    ADD CONSTRAINT item_orders_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: item_orders item_orders_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.item_orders
    ADD CONSTRAINT item_orders_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: localities localities_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.localities
    ADD CONSTRAINT localities_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: menu_categories menu_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menu_categories
    ADD CONSTRAINT menu_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: merchant_otp merchant_otp_otp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_otp
    ADD CONSTRAINT merchant_otp_otp_fkey FOREIGN KEY (otp) REFERENCES public."user"(id);


--
-- Name: merchant_transactions merchant_transactions_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.merchant_transactions
    ADD CONSTRAINT merchant_transactions_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: notification notification_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: refund refund_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refund
    ADD CONSTRAINT refund_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.item_orders(id);


--
-- Name: session session_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: store_categories store_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_categories
    ADD CONSTRAINT store_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


--
-- Name: store_categories store_categories_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_categories
    ADD CONSTRAINT store_categories_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: store store_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: store store_da_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store
    ADD CONSTRAINT store_da_id_fkey FOREIGN KEY (da_id) REFERENCES public.delivery_agent(id);


--
-- Name: store_item store_item_menu_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item
    ADD CONSTRAINT store_item_menu_category_id_fkey FOREIGN KEY (menu_category_id) REFERENCES public.menu_categories(id) ON DELETE CASCADE;


--
-- Name: store_item store_item_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item
    ADD CONSTRAINT store_item_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: store_item_variable store_item_variable_quantity_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_variable
    ADD CONSTRAINT store_item_variable_quantity_unit_fkey FOREIGN KEY (quantity_unit) REFERENCES public.quantity_unit(id) ON DELETE CASCADE;


--
-- Name: store_item_variable store_item_variable_store_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_item_variable
    ADD CONSTRAINT store_item_variable_store_item_id_fkey FOREIGN KEY (store_item_id) REFERENCES public.store_item(id) ON DELETE CASCADE;


--
-- Name: store_menu_categories store_menu_categories_menu_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_menu_categories
    ADD CONSTRAINT store_menu_categories_menu_category_id_fkey FOREIGN KEY (menu_category_id) REFERENCES public.menu_categories(id) ON DELETE CASCADE;


--
-- Name: store_menu_categories store_menu_categories_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_menu_categories
    ADD CONSTRAINT store_menu_categories_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: store_merchants store_merchants_merchant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_merchants
    ADD CONSTRAINT store_merchants_merchant_id_fkey FOREIGN KEY (merchant_id) REFERENCES public.merchant(id) ON DELETE CASCADE;


--
-- Name: store_merchants store_merchants_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_merchants
    ADD CONSTRAINT store_merchants_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: store_mis store_mis_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_mis
    ADD CONSTRAINT store_mis_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: store_payments store_payments_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.store_payments
    ADD CONSTRAINT store_payments_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id) ON DELETE CASCADE;


--
-- Name: storetaxes storetaxes_store_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.storetaxes
    ADD CONSTRAINT storetaxes_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.store(id);


--
-- Name: supervisor_otp supervisor_otp_otp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.supervisor_otp
    ADD CONSTRAINT supervisor_otp_otp_fkey FOREIGN KEY (otp) REFERENCES public.supervisor(id);


--
-- Name: user_address user_address_city_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address
    ADD CONSTRAINT user_address_city_id_fkey FOREIGN KEY (city_id) REFERENCES public.cities(id);


--
-- Name: user_address user_address_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_address
    ADD CONSTRAINT user_address_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user_otp user_otp_otp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_otp
    ADD CONSTRAINT user_otp_otp_fkey FOREIGN KEY (otp) REFERENCES public."user"(id);


--
-- PostgreSQL database dump complete
--

