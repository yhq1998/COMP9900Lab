--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Postgres.app)
-- Dumped by pg_dump version 17.4 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: my_app_db; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE my_app_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = icu LOCALE = 'en_US.UTF-8' ICU_LOCALE = 'en-US';


ALTER DATABASE my_app_db OWNER TO postgres;

\connect my_app_db

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: driver_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.driver_status AS ENUM (
    'available',
    'busy',
    'offline'
);


ALTER TYPE public.driver_status OWNER TO postgres;

--
-- Name: order_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_status AS ENUM (
    'pending',
    'confirmed',
    'completed',
    'cancelled'
);


ALTER TYPE public.order_status OWNER TO postgres;

--
-- Name: order_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.order_type AS ENUM (
    'private',
    'bus_carpool'
);


ALTER TYPE public.order_type OWNER TO postgres;

--
-- Name: vehicle_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.vehicle_type AS ENUM (
    '16-seater',
    '22-seater',
    '30-seater'
);


ALTER TYPE public.vehicle_type OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    full_name character varying(100),
    email character varying(100),
    phone_number character varying(20),
    password character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'ADMIN'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: admin_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.admin ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.admin_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: drivers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.drivers (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    full_name character varying(100),
    email character varying(255),
    phone_number character varying(20) NOT NULL,
    password character varying(255) NOT NULL,
    photo text,
    driver_license_number character varying(50),
    vehicle character varying(100),
    status public.driver_status DEFAULT 'available'::public.driver_status NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.drivers OWNER TO postgres;

--
-- Name: drivers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.drivers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.drivers_id_seq OWNER TO postgres;

--
-- Name: drivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.drivers_id_seq OWNED BY public.drivers.id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    id integer NOT NULL,
    order_id integer NOT NULL,
    rating integer,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_id_seq OWNED BY public.feedback.id;


--
-- Name: gps_tracking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.gps_tracking (
    id integer NOT NULL,
    vehicle_id integer NOT NULL,
    latitude numeric(9,6),
    longitude numeric(9,6),
    "timestamp" timestamp without time zone DEFAULT now()
);


ALTER TABLE public.gps_tracking OWNER TO postgres;

--
-- Name: gps_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.gps_tracking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.gps_tracking_id_seq OWNER TO postgres;

--
-- Name: gps_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.gps_tracking_id_seq OWNED BY public.gps_tracking.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    message text NOT NULL,
    recipient_id integer,
    notification_type character varying(50) DEFAULT 'info'::character varying,
    is_read boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    id integer NOT NULL,
    order_number character varying(50) NOT NULL,
    user_id integer NOT NULL,
    driver_id integer,
    vehicle_id integer,
    order_type public.order_type DEFAULT 'private'::public.order_type NOT NULL,
    start_location text NOT NULL,
    end_location text NOT NULL,
    estimated_time integer,
    fare numeric(10,2),
    passenger_count integer,
    luggage_info text,
    status public.order_status DEFAULT 'pending'::public.order_status NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orders_id_seq OWNER TO postgres;

--
-- Name: orders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    order_id integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    payment_method character varying(50) NOT NULL,
    status character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: promotions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.promotions (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    discount numeric(10,2) NOT NULL,
    start_date timestamp with time zone,
    end_date timestamp with time zone,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.promotions OWNER TO postgres;

--
-- Name: promotions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.promotions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.promotions_id_seq OWNER TO postgres;

--
-- Name: promotions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.promotions_id_seq OWNED BY public.promotions.id;


--
-- Name: system_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.system_log (
    id integer NOT NULL,
    username character varying(50),
    operation character varying(255),
    method character varying(255),
    params text,
    ip character varying(50),
    "time" bigint,
    exception text,
    create_time timestamp without time zone,
    description character varying(255),
    type character varying(20)
);


ALTER TABLE public.system_log OWNER TO postgres;

--
-- Name: system_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.system_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_log_id_seq OWNER TO postgres;

--
-- Name: system_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.system_log_id_seq OWNED BY public.system_log.id;


--
-- Name: trips; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.trips (
    id integer NOT NULL,
    order_id integer NOT NULL,
    driver_id integer NOT NULL,
    vehicle_id integer NOT NULL,
    start_time timestamp without time zone,
    end_time timestamp without time zone,
    distance numeric(10,2)
);


ALTER TABLE public.trips OWNER TO postgres;

--
-- Name: trips_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.trips_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trips_id_seq OWNER TO postgres;

--
-- Name: trips_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.trips_id_seq OWNED BY public.trips.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    full_name character varying(100),
    email character varying(255),
    phone_number character varying(20) NOT NULL,
    password character varying(255) NOT NULL,
    photo text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: vehicles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.vehicles (
    id integer NOT NULL,
    type public.vehicle_type NOT NULL,
    plate_number character varying(20) NOT NULL,
    gps_location public.geography(Point,4326),
    available boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.vehicles OWNER TO postgres;

--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.vehicles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.vehicles_id_seq OWNER TO postgres;

--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.vehicles.id;


--
-- Name: drivers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers ALTER COLUMN id SET DEFAULT nextval('public.drivers_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN id SET DEFAULT nextval('public.feedback_id_seq'::regclass);


--
-- Name: gps_tracking id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gps_tracking ALTER COLUMN id SET DEFAULT nextval('public.gps_tracking_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: orders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders ALTER COLUMN id SET DEFAULT nextval('public.orders_id_seq'::regclass);


--
-- Name: promotions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions ALTER COLUMN id SET DEFAULT nextval('public.promotions_id_seq'::regclass);


--
-- Name: system_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_log ALTER COLUMN id SET DEFAULT nextval('public.system_log_id_seq'::regclass);


--
-- Name: trips id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trips ALTER COLUMN id SET DEFAULT nextval('public.trips_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: vehicles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, username, full_name, email, phone_number, password, role, created_at, updated_at) FROM stdin;
3	admin123	Admin User	admin@example.com	1234567890	$2a$10$WKlHajj2PzjNqxoSXWk/reX.0u5eQztLg5UpvB6YpeqEYRQbTclji	ADMIN	2025-04-09 06:12:50.901115	2025-04-09 06:12:50.901115
13	Admin3	Admin	Admin@qq.com	02323231231	$2a$10$sh3rg869Woyfrrma8bOuAOnUURQqyrsRmMqCS22UeewoZedlanpLS	ADMIN	2025-04-21 19:37:04.717862	2025-04-21 19:37:04.717862
15	Admin	Admin	Admin@qq.com	0401333222	$2a$10$xMO1Iv6uPZU7Fv6SpWXa2uU/6AiBQeUd9FPNSlTP63MseVm7Z94gW	ADMIN	2025-04-21 20:10:00.439331	2025-04-21 20:10:00.439331
\.


--
-- Data for Name: drivers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.drivers (id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at) FROM stdin;
1	A11111111111	A11111111112	A11111111111@qq.com	13299999999	13299999999		13299999999	13299999999	available	2025-04-20 14:38:08.282+10	2025-04-20 14:43:35.781651+10
2	driver1	driver1	driver1@qq.com	13299999998	13299999999		13299999999	13299999999	available	2025-04-20 14:47:54.262+10	2025-04-21 20:26:33.918679+10
\.


--
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.feedback (id, order_id, rating, created_at) FROM stdin;
\.


--
-- Data for Name: gps_tracking; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.gps_tracking (id, vehicle_id, latitude, longitude, "timestamp") FROM stdin;
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, title, message, recipient_id, notification_type, is_read, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (id, order_number, user_id, driver_id, vehicle_id, order_type, start_location, end_location, estimated_time, fare, passenger_count, luggage_info, status, created_at, updated_at) FROM stdin;
18	ORD-1745043587434	4	3	1	private	Office	Coffee shop	2	18.00	0	Big: 1, Small: 1, Wheelchair required	completed	2025-04-19 16:19:48.181356+10	2025-04-19 16:21:55.253631+10
11	ORD-1744272010881	1	3	1	private	Office	Coffee shop	3	10.00	0	Big: 1, Small: 1, Wheelchair required	completed	2025-04-10 18:00:30.070716+10	2025-04-11 23:31:56.461663+10
26	ORD-1745132908808	1	3	1	bus_carpool	Kuala Lumpur International Airport	1 Utama Shopping Centre	\N	10.00	4	big:1, small:1	confirmed	2025-04-20 17:09:12.909095+10	2025-04-20 17:09:12.909095+10
13	ORD-1744273818565	1	3	1	private	Office	Shopping center	7	10.00	0	Big: 0, Small: 0, Wheelchair required	completed	2025-04-10 18:30:37.739436+10	2025-04-10 18:31:15.042438+10
2	ORD-CONFIRMED-001	1	3	1	private	Kuala Lumpur International Airport	Wanda Plaza	60	120.00	1	Big: 1, Small: 1, Wheelchair required	completed	2025-04-08 20:28:10.964841+10	2025-04-08 20:28:10.964841+10
3	ORD-COMPLETED-001	1	3	1	private	Kuala Lumpur International Airport	Wanda Plaza	60	150.00	1	Big: 1, Small: 1, Wheelchair required	completed	2025-04-08 20:28:10.983274+10	2025-04-08 20:28:10.983274+10
28	ORD-1745134506177	1	3	1	private	Office	Coffee shop	1	0.00	0	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-20 17:35:06.531489+10	2025-04-20 17:36:15.799737+10
24	ORD-1745050593469	1	3	1	private	Kuala Lumpur International Airport	1 Utama Shopping Centre	\N	10.00	15	big:2, small:1	confirmed	2025-04-19 18:16:53.331051+10	2025-04-19 18:16:53.331051+10
20	ORD-1745044168389	4	3	1	bus_carpool	Kuala Lumpur International Airport	1 Utama Shopping Centre	\N	11.00	1	big:0, small:0	completed	2025-04-19 16:29:37.871556+10	2025-04-19 16:29:37.871556+10
10	ORD-1744270871571	1	3	1	private	Office	Coffee shop	1	11.00	0	Big: 1, Small: 1	completed	2025-04-10 17:41:30.806447+10	2025-04-11 18:43:10.187729+10
12	ORD-1744272219714	1	3	2	private	Coffee shop	Shopping center	58	11.00	0	Big: 1, Small: 1, Wheelchair required	completed	2025-04-10 18:03:58.86169+10	2025-04-10 18:04:26.256823+10
17	ORD-1744895119419	1	3	1	private	Office	Coffee shop	2	20.00	0	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-17 23:05:19.955108+10	2025-04-19 16:22:16.444139+10
14	ORD-1744378723900	1	3	1	private	Shopping mall	Office	4	11.00	0	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-11 23:38:43.961278+10	2025-04-19 16:22:15.633861+10
4	ORD-CANCELLED-001	1	3	1	private	Kuala Lumpur International Airport	Wanda Plaza	60	11.00	1	Big: 1, Small: 1, Wheelchair required	cancelled	2025-04-08 20:28:11.009634+10	2025-04-08 20:28:11.009634+10
21	ORD-1745045558208	8	3	1	bus_carpool	1 Utama Shopping Centre	Kuala Lumpur International Airport	\N	10.00	1	big:1, small:2	completed	2025-04-19 16:52:50.232+10	2025-04-19 16:52:50.232+10
23	ORD-1745049837939	1	3	1	private	Office	Coffee shop	5	0.00	0	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-19 18:03:58.178076+10	2025-04-19 18:04:17.846082+10
19	ORD-1745043778994	4	3	1	private	Coffee shop	Shopping center	4	19.00	0	Big: 2, Small: 2, Wheelchair required	completed	2025-04-19 16:22:59.733598+10	2025-04-19 16:23:52.497198+10
22	ORD-1745047408048	9	3	1	private	Office	Coffee shop	2	0.00	0	Big: 1, Small: 1, Wheelchair required	completed	2025-04-19 17:23:29.141169+10	2025-04-19 17:23:45.395796+10
16	ORD-1744386443907	1	3	1	bus_carpool	Kuala Lumpur International Airport	1 Utama Shopping Centre	\N	10.00	3	big:1, small:1	completed	2025-04-12 01:48:17.253311+10	2025-04-12 01:48:17.253311+10
25	ORD-1745132716454	1	3	1	private	Office	Coffee shop	4	20.00	0	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-20 17:05:16.821342+10	2025-04-21 04:17:44.614+10
1	ORD-PENDING-001	1	3	1	private	Kuala Lumpur International Airport	Wanda Plaza	60	30.00	1	Big: 1, Small: 1, Wheelchair required	confirmed	2025-04-08 20:28:10.938141+10	2025-04-21 20:35:36.83+10
27	ORD-1745134315560	1	3	2	bus_carpool	Kuala Lumpur International Airport	1 Utama Shopping Centre	\N	20.00	5	big:0, small:5	pending	2025-04-20 17:32:09.781219+10	2025-04-21 20:34:05.935+10
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, order_id, amount, payment_method, status, created_at) FROM stdin;
8dd15a5c-51e5-45b8-9736-6ce44d1cc9a4	13	10.00	PayPal	pending	2025-04-19 16:14:06.511466
83c63bae-d05d-4d69-b86e-6534769f0e05	19	19.00	PayPal	pending	2025-04-19 16:26:48.118356
8ab18754-a322-408f-b58c-0d259abbf23c	18	18.00	PayPal	pending	2025-04-19 16:33:01.980002
f5ed6425-f5c7-4a8c-9864-c33b6a7f4d0f	21	10.00	PayPal	pending	2025-04-19 16:54:00.250447
56ca9680-02ed-47ed-a476-a551dcdf3699	21	10.00	PayPal	pending	2025-04-19 16:54:01.222507
a1b80526-a7db-4a0d-af29-72d7e805f92c	25	10.00	PayPal	pending	2025-04-20 17:06:56.338601
3dfacb2f-17d5-4c76-a766-5dd2496a6157	25	10.00	PayPal	pending	2025-04-20 17:06:58.770935
a64e08e4-79f7-470f-ad69-e8f48d94fe83	25	10.00	PayPal	pending	2025-04-20 17:10:38.041484
\.


--
-- Data for Name: promotions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.promotions (id, code, title, description, discount, start_date, end_date, active, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: system_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.system_log (id, username, operation, method, params, ip, "time", exception, create_time, description, type) FROM stdin;
1	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	137	\N	2025-04-20 14:02:20.770167	\N	INFO
2	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:02:24.405352	\N	INFO
3	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:02:25.652392	\N	INFO
4	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:02:27.088432	\N	INFO
5	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:29.974607	\N	INFO
6	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:32.336442	\N	INFO
7	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:02:34.33074	\N	INFO
8	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 14:02:37.291243	\N	INFO
9	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:37.30841	\N	INFO
10	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:38.778013	\N	INFO
11	test1	\N	com.unsw.controller.PaymentController.list()	[null,"",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:39.817956	\N	INFO
12	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:02:52.765213	\N	INFO
13	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 14:12:34.280556	\N	INFO
14	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:12:36.64826	\N	INFO
15	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 14:12:45.73718	\N	INFO
16	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:12:45.763731	\N	INFO
17	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:12:47.358266	\N	INFO
18	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:12:53.216399	\N	INFO
19	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:12:53.233253	\N	INFO
20	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:13:14.964191	\N	INFO
21	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:13:14.97819	\N	INFO
22	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 14:17:12.007652	\N	INFO
23	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:22:02.757106	\N	INFO
24	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:22:04.67607	\N	INFO
25	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:22:06.103472	\N	INFO
26	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:22:07.94262	\N	INFO
27	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:22:12.430886	\N	INFO
28	test1	\N	com.unsw.controller.DriverController.save()	[{"id":null,"username":"driver1","fullName":"driver1","email":"driver1@qq.com","phoneNumber":"13299999999","password":"driver1","photo":"","driverLicenseNumber":"A11111111111","vehicle":"","status":"available","createdAt":"2025-04-20T04:23:00.120+00:00","updatedAt":"2025-04-20T04:23:00.120+00:00"}]	0:0:0:0:0:0:0:1	1745122980120	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type driver_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 220\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.insert-Inline\n### The error occurred while setting parameters\n### SQL: INSERT INTO drivers (             username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at         ) VALUES (             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?         )\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type driver_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 220\n; bad SQL grammar []	2025-04-20 14:23:00.124445	\N	ERROR
29	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	134	\N	2025-04-20 14:23:04.343956	\N	INFO
30	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:23:06.513493	\N	INFO
31	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:23:08.883795	\N	INFO
32	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:23:10.555705	\N	INFO
33	anonymousUser	\N	com.unsw.controller.UserController.save()	[{"id":1,"username":"test1","fullName":"test1","email":"123@qq.com","phoneNumber":"13299999999","password":"password123","photo":"","createdAt":"2025-04-20T04:23:14.362+00:00","updatedAt":"2025-04-20T04:23:14.362+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:23:34.125091	\N	INFO
34	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:23:34.139374	\N	INFO
35	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:23:48.487768	\N	INFO
36	test1	\N	com.unsw.controller.AdminController.getById()	[5]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:23:56.301578	\N	INFO
37	test1	\N	com.unsw.controller.AdminController.getById()	[4]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:23:59.761953	\N	INFO
38	test1	\N	com.unsw.controller.AdminController.delete()	[5]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:24:04.450547	\N	INFO
39	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:24:07.084297	\N	INFO
40	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:24:12.771804	\N	INFO
41	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:28:47.10379	\N	INFO
78	test1	\N	com.unsw.controller.DriverController.save()	[{"id":null,"username":"driver1","fullName":"driver1","email":"driver1@qq.com","phoneNumber":"13299999999","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":null,"updatedAt":null,"statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 14:47:49.002057	\N	INFO
377	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:57:49.883909	\N	INFO
42	test1	\N	com.unsw.controller.DriverController.save()	[{"id":null,"username":"13299999999","fullName":"13299999999","email":"13299999999@qq.com","phoneNumber":"13299999999","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:29:09.973+00:00","updatedAt":"2025-04-20T04:29:09.973+00:00"}]	0:0:0:0:0:0:0:1	1745123349973	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type driver_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 220\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.insert-Inline\n### The error occurred while setting parameters\n### SQL: INSERT INTO drivers (             username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at         ) VALUES (             ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?         )\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type driver_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 220\n; bad SQL grammar []	2025-04-20 14:29:09.975834	\N	ERROR
43	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	133	\N	2025-04-20 14:29:11.607914	\N	INFO
44	test1	\N	com.unsw.controller.DriverController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:29:14.244249	\N	INFO
45	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	30	\N	2025-04-20 14:37:17.911674	\N	INFO
46	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	123	\N	2025-04-20 14:37:23.608055	\N	INFO
47	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:37:25.856569	\N	INFO
48	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:37:27.263285	\N	INFO
49	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:37:28.618268	\N	INFO
50	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:37:31.137065	\N	INFO
51	test1	\N	com.unsw.controller.DriverController.save()	[{"id":1,"username":"A11111111111","fullName":"A11111111111","email":"A11111111111@qq.com","phoneNumber":"13299999999","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:38:08.282+00:00","updatedAt":"2025-04-20T04:38:08.282+00:00","statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 14:38:08.289834	\N	INFO
52	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:38:12.118952	\N	INFO
53	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:38:22.643098	\N	INFO
54	anonymousUser	\N	com.unsw.controller.UserController.update()	[1,{"id":1,"username":"test1","fullName":"test1","email":"123@qq.com","phoneNumber":"13299999998","password":null,"photo":"","createdAt":"2025-04-20T04:23:14.362+00:00","updatedAt":"2025-04-20T04:38:24.719+00:00"}]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 14:38:28.688741	\N	INFO
55	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:38:28.704812	\N	INFO
56	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:38:31.443709	\N	INFO
57	test1	\N	com.unsw.controller.AdminController.getById()	[4]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:38:32.908525	\N	INFO
58	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:38:36.01226	\N	INFO
59	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 14:38:38.431433	\N	INFO
60	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:38:38.448359	\N	INFO
61	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:38:40.193745	\N	INFO
62	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 14:39:09.913455	\N	INFO
63	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:39:19.462572	\N	INFO
64	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:39:38.6653	\N	INFO
65	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	106	\N	2025-04-20 14:43:22.558522	\N	INFO
66	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	17	\N	2025-04-20 14:43:25.206274	\N	INFO
67	test1	\N	com.unsw.controller.DriverController.getById()	[1]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:43:31.074781	\N	INFO
68	test1	\N	com.unsw.controller.DriverController.update()	[1,{"id":1,"username":"A11111111111","fullName":"A11111111112","email":"A11111111111@qq.com","phoneNumber":"13299999999","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:38:08.282+00:00","updatedAt":"2025-04-20T04:43:35.779+00:00","statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:43:35.783494	\N	INFO
69	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:43:35.804258	\N	INFO
70	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 14:43:39.014295	\N	INFO
71	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:43:57.710014	\N	INFO
72	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:43:58.855091	\N	INFO
73	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:44:01.79945	\N	INFO
74	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:44:01.819071	\N	INFO
75	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:44:05.762664	\N	INFO
76	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:44:11.881019	\N	INFO
77	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 14:46:59.059436	\N	INFO
122	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:58:59.689423	\N	INFO
123	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:58:59.70698	\N	INFO
79	test1	\N	com.unsw.controller.DriverController.save()	[{"id":2,"username":"driver1","fullName":"driver1","email":"driver1@qq.com","phoneNumber":"13299999998","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:47:54.262+00:00","updatedAt":"2025-04-20T04:47:54.262+00:00","statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 14:47:54.267264	\N	INFO
80	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:47:54.286232	\N	INFO
81	test1	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"offline"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:48:02.212631	\N	INFO
82	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:48:02.234623	\N	INFO
83	test1	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"available"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:05.783695	\N	INFO
84	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:48:05.811631	\N	INFO
85	test1	\N	com.unsw.controller.DriverController.getById()	[2]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:48:13.133178	\N	INFO
86	test1	\N	com.unsw.controller.DriverController.getById()	[2]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:15.90063	\N	INFO
87	test1	\N	com.unsw.controller.DriverController.update()	[2,{"id":2,"username":"driver1","fullName":"driver1","email":"driver1@qq.com","phoneNumber":"13299999998","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:47:54.262+00:00","updatedAt":"2025-04-20T04:48:20.882+00:00","statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:48:20.884929	\N	INFO
88	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:48:20.906896	\N	INFO
89	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:48:24.705407	\N	INFO
90	test1	\N	com.unsw.controller.DriverController.getById()	[2]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:27.831868	\N	INFO
91	test1	\N	com.unsw.controller.DriverController.update()	[2,{"id":2,"username":"driver1","fullName":"driver1","email":"driver1@qq.com","phoneNumber":"13299999998","password":"13299999999","photo":"","driverLicenseNumber":"13299999999","vehicle":"13299999999","status":"available","createdAt":"2025-04-20T04:47:54.262+00:00","updatedAt":"2025-04-20T04:48:32.338+00:00","statusEnum":"AVAILABLE"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:48:32.340671	\N	INFO
92	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:48:32.370073	\N	INFO
93	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:34.716956	\N	INFO
94	test1	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"offline"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:40.285376	\N	INFO
95	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:40.308	\N	INFO
96	test1	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"available"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:44.865775	\N	INFO
97	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:48:44.885951	\N	INFO
98	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:46.88688	\N	INFO
99	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:48.161839	\N	INFO
100	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:48:49.218984	\N	INFO
101	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:50.418319	\N	INFO
102	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	144	\N	2025-04-20 14:48:55.805089	\N	INFO
103	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:48:58.10228	\N	INFO
104	anonymousUser	\N	com.unsw.controller.UserController.update()	[1,{"id":1,"username":"test1","fullName":"test1","email":"123@qq.com","phoneNumber":"13299999998","password":null,"photo":"","createdAt":"2025-04-20T04:23:14.362+00:00","updatedAt":"2025-04-20T04:49:12.462+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 14:49:14.960248	\N	INFO
105	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:49:14.973064	\N	INFO
106	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:49:17.35327	\N	INFO
107	anonymousUser	\N	com.unsw.controller.UserController.update()	[1,{"id":1,"username":"test1","fullName":"test1","email":"123@qq.com","phoneNumber":"13299999998","password":null,"photo":"","createdAt":"2025-04-20T04:23:14.362+00:00","updatedAt":"2025-04-20T04:49:19.129+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:49:21.014019	\N	INFO
108	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:49:21.035038	\N	INFO
109	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:49:22.459987	\N	INFO
110	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 14:52:02.818796	\N	INFO
111	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:52:06.187751	\N	INFO
112	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:52:29.895436	\N	INFO
113	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:52:32.462154	\N	INFO
114	test1	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"offline"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:52:35.931487	\N	INFO
115	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:52:35.954165	\N	INFO
116	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:52:52.417146	\N	INFO
117	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 14:55:04.228165	\N	INFO
118	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 14:57:28.668997	\N	INFO
119	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:58:44.523576	\N	INFO
120	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:58:53.62668	\N	INFO
121	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 14:58:55.248487	\N	INFO
124	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	136	\N	2025-04-20 14:59:06.314179	\N	INFO
125	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:59:08.114951	\N	INFO
126	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 14:59:12.703494	\N	INFO
127	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 14:59:12.717365	\N	INFO
128	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	214	\N	2025-04-20 15:30:29.121265	\N	INFO
129	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 15:30:32.522197	\N	INFO
130	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 15:30:32.537104	\N	INFO
131	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	212	\N	2025-04-20 15:39:57.216711	\N	INFO
132	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 15:39:59.916217	\N	INFO
133	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-20 15:39:59.928872	\N	INFO
134	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	19	\N	2025-04-20 15:40:05.942271	\N	INFO
135	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 15:40:06.695505	\N	INFO
136	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 15:40:08.15171	\N	INFO
137	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 15:40:17.533891	\N	INFO
138	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 16:05:03.915341	\N	INFO
139	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:14:15.719359	\N	INFO
140	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:14:15.737675	\N	INFO
141	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:15:00.028311	\N	INFO
142	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:15:02.453215	\N	INFO
143	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:15:04.274654	\N	INFO
144	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 16:15:04.291484	\N	INFO
145	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:15:17.664037	\N	INFO
146	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 16:15:17.676157	\N	INFO
147	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745129717670	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:15:17.739468	\N	ERROR
148	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	137	\N	2025-04-20 16:15:21.85985	\N	INFO
149	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 16:15:24.410097	\N	INFO
150	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 16:15:25.019333	\N	INFO
151	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:15:25.645656	\N	INFO
152	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 16:15:27.95165	\N	INFO
153	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:15:27.966587	\N	INFO
154	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	15	\N	2025-04-20 16:16:15.210064	\N	INFO
155	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:16:15.294063	\N	INFO
156	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	221	\N	2025-04-20 16:42:45.755264	\N	INFO
157	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 16:42:48.762604	\N	INFO
158	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	17	\N	2025-04-20 16:42:49.948455	\N	INFO
159	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 16:42:51.239466	\N	INFO
160	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 16:42:53.619473	\N	INFO
161	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:42:53.640035	\N	INFO
162	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 16:43:02.890561	\N	INFO
163	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 16:43:02.906866	\N	INFO
165	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	139	\N	2025-04-20 16:43:06.241943	\N	INFO
167	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:43:10.48025	\N	INFO
168	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 16:44:45.631158	\N	INFO
169	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:44:45.63919	\N	INFO
174	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 16:46:24.05484	\N	INFO
164	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745131382898	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:43:02.97302	\N	ERROR
166	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 16:43:10.461084	\N	INFO
170	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745131485636	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:44:45.639828	\N	ERROR
172	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:46:22.948121	\N	INFO
175	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745131584058	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:46:24.062497	\N	ERROR
179	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:46:39.906942	\N	INFO
182	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745131629370	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:47:09.373412	\N	ERROR
1273	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:04.003453	\N	INFO
1276	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:04.099497	\N	INFO
1279	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:14.410207	\N	INFO
1280	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:14.452024	\N	INFO
1284	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:22.39929	\N	INFO
1285	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 20:35:22.438127	\N	INFO
1288	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":30,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:35:25.868+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:25.869995	\N	INFO
1290	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:25.974873	\N	INFO
1293	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-21T10:35:36.830+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:35:36.834516	\N	INFO
1295	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:36.978455	\N	INFO
171	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	137	\N	2025-04-20 16:45:01.937481	\N	INFO
173	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:46:22.970938	\N	INFO
176	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 16:46:24.065278	\N	INFO
178	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:46:39.887037	\N	INFO
180	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 16:47:09.363218	\N	INFO
1274	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:04.004641	\N	INFO
1282	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:14.456398	\N	INFO
1287	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:22.443804	\N	INFO
1289	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:25.934529	\N	INFO
1291	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:25.978504	\N	INFO
1294	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:36.890342	\N	INFO
1296	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:36.981556	\N	INFO
1299	Admin	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 20:38:20.24984	\N	INFO
1300	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:38:27.511428	\N	INFO
177	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	136	\N	2025-04-20 16:46:36.103514	\N	INFO
181	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:47:09.370301	\N	INFO
183	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	140	\N	2025-04-20 16:49:01.645573	\N	INFO
184	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:49:03.829786	\N	INFO
185	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:49:03.848336	\N	INFO
186	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 16:49:12.060553	\N	INFO
187	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 16:49:12.069806	\N	INFO
188	test1	\N	com.unsw.controller.DriverController.list()	[null,null,"ACTIVE",1,10]	0:0:0:0:0:0:0:1	1745131752064	org.springframework.dao.DataIntegrityViolationException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/DriversMapper.xml]\n### The error may involve com.unsw.mapper.DriversMapper.findByPage-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, username, full_name, email, phone_number, password, photo, driver_license_number, vehicle, status, created_at, updated_at       FROM drivers          WHERE  status = ?::driver_status          ORDER BY id DESC                       LIMIT ? OFFSET (? - 1) * ?\n### Cause: org.postgresql.util.PSQLException: ERROR: invalid input value for enum driver_status: "ACTIVE"\n; ERROR: invalid input value for enum driver_status: "ACTIVE"	2025-04-20 16:49:12.07183	\N	ERROR
189	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-20 16:49:14.32615	\N	INFO
190	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 16:49:17.599542	\N	INFO
191	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 16:49:17.61541	\N	INFO
192	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	240	\N	2025-04-20 17:53:27.878526	\N	INFO
193	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	23	\N	2025-04-20 17:53:33.01016	\N	INFO
194	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 17:53:33.064153	\N	INFO
195	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 18:01:04.975609	\N	INFO
196	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 18:01:25.023545	\N	INFO
197	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 18:01:32.973459	\N	INFO
198	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 18:11:06.458921	\N	INFO
199	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	255	\N	2025-04-20 18:15:12.776766	\N	INFO
200	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-20 18:15:15.09939	\N	INFO
201	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 18:15:15.160516	\N	INFO
202	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 18:15:16.916925	\N	INFO
203	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	12	\N	2025-04-20 18:15:18.491934	\N	INFO
204	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 18:15:19.696184	\N	INFO
205	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 18:15:34.718802	\N	INFO
206	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	19	\N	2025-04-20 18:15:34.785664	\N	INFO
207	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	14	\N	2025-04-20 18:17:19.976881	\N	INFO
208	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	16	\N	2025-04-20 18:17:27.181926	\N	INFO
209	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	19	\N	2025-04-20 18:17:27.270269	\N	INFO
210	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 18:19:27.781088	\N	INFO
211	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 18:19:29.667557	\N	INFO
212	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 18:19:29.71857	\N	INFO
213	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 18:19:37.140189	\N	INFO
214	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	231	\N	2025-04-20 18:24:03.395264	\N	INFO
215	test1	\N	com.unsw.controller.OrderController.list()	["","","","",null,null,1,10]	0:0:0:0:0:0:0:1	1745137446047	org.springframework.jdbc.BadSqlGrammarException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.findByParams-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, order_number, user_id, driver_id, vehicle_id, order_type, start_location, end_location,          estimated_time, fare, passenger_count, luggage_info, status, created_at, updated_at       FROM orders                    ORDER BY created_at DESC                       LIMIT ?, ?\n### Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n; bad SQL grammar []	2025-04-20 18:24:06.115294	\N	ERROR
216	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	130	\N	2025-04-20 18:24:14.968596	\N	INFO
303	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 22:40:18.273324	\N	INFO
217	test1	\N	com.unsw.controller.OrderController.list()	["","","","",null,null,1,10]	0:0:0:0:0:0:0:1	1745137469950	org.springframework.jdbc.BadSqlGrammarException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.findByParams-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, order_number, user_id, driver_id, vehicle_id, order_type, start_location, end_location,          estimated_time, fare, passenger_count, luggage_info, status, created_at, updated_at       FROM orders                    ORDER BY created_at DESC                       LIMIT ?, ?\n### Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n; bad SQL grammar []	2025-04-20 18:24:29.957443	\N	ERROR
218	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	129	\N	2025-04-20 18:24:51.369398	\N	INFO
219	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	13	\N	2025-04-20 18:25:02.245608	\N	INFO
220	test1	\N	com.unsw.controller.OrderController.list()	["","","","",null,null,1,10]	0:0:0:0:0:0:0:1	1745137516105	org.springframework.jdbc.BadSqlGrammarException: \n### Error querying database.  Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.findByParams-Inline\n### The error occurred while setting parameters\n### SQL: SELECT           id, order_number, user_id, driver_id, vehicle_id, order_type, start_location, end_location,          estimated_time, fare, passenger_count, luggage_info, status, created_at, updated_at       FROM orders                    ORDER BY created_at DESC                       LIMIT ?, ?\n### Cause: org.postgresql.util.PSQLException: ERROR: LIMIT #,# syntax is not supported\n  Hint: Use separate LIMIT and OFFSET clauses.\n  Position: 287\n; bad SQL grammar []	2025-04-20 18:25:16.108299	\N	ERROR
221	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	137	\N	2025-04-20 18:25:25.312856	\N	INFO
222	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	246	\N	2025-04-20 18:33:58.779505	\N	INFO
223	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-20 18:34:01.472433	\N	INFO
224	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 18:36:46.83983	\N	INFO
225	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	19	\N	2025-04-20 18:36:49.518357	\N	INFO
226	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 18:36:57.135314	\N	INFO
227	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 18:50:13.594458	\N	INFO
228	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 18:50:40.866562	\N	INFO
229	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	13	\N	2025-04-20 18:55:04.391694	\N	INFO
230	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 18:55:07.409009	\N	INFO
231	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	139	\N	2025-04-20 18:55:12.452184	\N	INFO
232	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 18:55:17.057638	\N	INFO
233	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	216	\N	2025-04-20 22:01:16.788257	\N	INFO
234	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:01:21.447743	\N	INFO
235	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	24	\N	2025-04-20 22:01:22.555209	\N	INFO
236	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:01:24.180406	\N	INFO
237	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	17	\N	2025-04-20 22:01:28.299283	\N	INFO
238	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:13:46.60962	\N	INFO
239	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:13:49.85035	\N	INFO
240	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	15	\N	2025-04-20 22:19:18.951149	\N	INFO
241	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	39	\N	2025-04-20 22:19:18.976952	\N	INFO
242	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:19:33.283+00:00"}]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 22:19:33.2942	\N	INFO
243	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:19:33.369252	\N	INFO
244	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:24:26.49088	\N	INFO
245	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:24:26.497152	\N	INFO
246	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:24:26.559085	\N	INFO
247	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	31	\N	2025-04-20 22:24:26.593469	\N	INFO
248	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	51	\N	2025-04-20 22:24:26.60829	\N	INFO
249	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:24:58.004+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:24:58.008043	\N	INFO
250	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:24:58.082957	\N	INFO
251	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:24:58.130317	\N	INFO
1275	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:35:04.096665	\N	INFO
1277	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:04.10068	\N	INFO
1278	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:35:14.341+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:14.342724	\N	INFO
1281	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:14.456352	\N	INFO
1283	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:35:22.328+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:22.330416	\N	INFO
1286	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:22.443476	\N	INFO
1292	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:35:25.97893	\N	INFO
1297	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:35:36.983317	\N	INFO
1298	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:38:16.590752	\N	INFO
252	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:24:58.134744	\N	INFO
253	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:24:58.136385	\N	INFO
254	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-20 22:25:51.193234	\N	INFO
255	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:25:53.961404	\N	INFO
256	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:25:58.48008	\N	INFO
257	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 22:25:58.490389	\N	INFO
258	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:25:58.538783	\N	INFO
259	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:25:58.551452	\N	INFO
260	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 22:25:58.553678	\N	INFO
261	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	139	\N	2025-04-20 22:26:13.230849	\N	INFO
262	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:26:15.380798	\N	INFO
263	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:26:15.384428	\N	INFO
264	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:26:15.425687	\N	INFO
265	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:26:15.429866	\N	INFO
266	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	11	\N	2025-04-20 22:26:15.4434	\N	INFO
267	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:29:50.705387	\N	INFO
268	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:29:50.705961	\N	INFO
269	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:29:50.778331	\N	INFO
270	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:29:50.780823	\N	INFO
271	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	27	\N	2025-04-20 22:29:50.804205	\N	INFO
272	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:30:15.589+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:30:15.593629	\N	INFO
273	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 22:30:15.648313	\N	INFO
274	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:30:15.701017	\N	INFO
275	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:30:15.708443	\N	INFO
276	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:30:15.709289	\N	INFO
277	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":30,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:31:27.666+00:00"}]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:31:27.672601	\N	INFO
278	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 22:31:27.752196	\N	INFO
279	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:31:27.807032	\N	INFO
280	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	14	\N	2025-04-20 22:31:27.827809	\N	INFO
281	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	37	\N	2025-04-20 22:31:27.850171	\N	INFO
282	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:31:45.959+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:31:45.962731	\N	INFO
283	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:31:46.018276	\N	INFO
284	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:31:46.04913	\N	INFO
285	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:31:46.061388	\N	INFO
286	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	34	\N	2025-04-20 22:31:46.091954	\N	INFO
287	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:35:09.557832	\N	INFO
288	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	12	\N	2025-04-20 22:35:09.563851	\N	INFO
289	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:35:09.626809	\N	INFO
290	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	23	\N	2025-04-20 22:35:09.656674	\N	INFO
291	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	57	\N	2025-04-20 22:35:09.688091	\N	INFO
292	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:35:19.561+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:35:19.564455	\N	INFO
293	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:35:19.633062	\N	INFO
294	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:35:19.668209	\N	INFO
295	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:35:19.672726	\N	INFO
296	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:35:19.676045	\N	INFO
297	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:39:58.408669	\N	INFO
298	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:39:58.409762	\N	INFO
299	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:39:58.481705	\N	INFO
300	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:39:58.485336	\N	INFO
302	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:40:18.203+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:40:18.207424	\N	INFO
305	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:40:18.321778	\N	INFO
307	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:40:27.368+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:40:27.37139	\N	INFO
311	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:40:27.51294	\N	INFO
313	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:23.022564	\N	INFO
314	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:23.096181	\N	INFO
318	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:26.871671	\N	INFO
320	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 22:44:26.911878	\N	INFO
322	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:44:28.879+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:28.881972	\N	INFO
326	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:28.978295	\N	INFO
327	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:44:31.307+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:31.308712	\N	INFO
328	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:31.341647	\N	INFO
329	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:31.36834	\N	INFO
336	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:34.22703	\N	INFO
340	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:36.077412	\N	INFO
301	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:39:58.492252	\N	INFO
304	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:40:18.315258	\N	INFO
310	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:40:27.51235	\N	INFO
312	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:23.023173	\N	INFO
316	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:23.104229	\N	INFO
321	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:26.912772	\N	INFO
325	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:28.977151	\N	INFO
331	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:31.373232	\N	INFO
333	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:34.19089	\N	INFO
334	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:34.221952	\N	INFO
337	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":30,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:44:35.964+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:35.968057	\N	INFO
341	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 22:44:36.081684	\N	INFO
306	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:40:18.323309	\N	INFO
308	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:40:27.440307	\N	INFO
309	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:40:27.504614	\N	INFO
315	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:23.098891	\N	INFO
317	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:44:26.801+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:44:26.806277	\N	INFO
319	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:26.911142	\N	INFO
323	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:28.939004	\N	INFO
324	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:28.972805	\N	INFO
330	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:31.372496	\N	INFO
332	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:44:34.134+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:44:34.137411	\N	INFO
335	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:44:34.225533	\N	INFO
338	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-20 22:44:36.030141	\N	INFO
339	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:44:36.061698	\N	INFO
342	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:47:40.072254	\N	INFO
343	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:47:40.073442	\N	INFO
344	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:47:40.152527	\N	INFO
345	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:47:40.153701	\N	INFO
346	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 22:47:40.159189	\N	INFO
347	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:47:48.031+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:47:48.034205	\N	INFO
348	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:47:48.094683	\N	INFO
349	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:47:48.161055	\N	INFO
350	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:47:48.166131	\N	INFO
351	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 22:47:48.167657	\N	INFO
352	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:12.872151	\N	INFO
353	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:48:12.873629	\N	INFO
354	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:12.924837	\N	INFO
355	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:12.926395	\N	INFO
356	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:48:12.931437	\N	INFO
357	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:15.315135	\N	INFO
358	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 22:48:15.31712	\N	INFO
359	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-20 22:48:15.369061	\N	INFO
360	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:48:15.380422	\N	INFO
361	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	21	\N	2025-04-20 22:48:15.401842	\N	INFO
362	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:48:19.798+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:48:19.801655	\N	INFO
363	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:48:19.864203	\N	INFO
364	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:19.89595	\N	INFO
365	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:48:19.899976	\N	INFO
366	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:48:19.900803	\N	INFO
367	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:33.15589	\N	INFO
368	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:51:33.156601	\N	INFO
369	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:33.232781	\N	INFO
370	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:33.232823	\N	INFO
371	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:51:33.251653	\N	INFO
372	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T12:51:46.214+00:00"}]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 22:51:46.222561	\N	INFO
373	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:46.292454	\N	INFO
374	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:46.326025	\N	INFO
375	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 22:51:46.332039	\N	INFO
376	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 22:51:46.331916	\N	INFO
378	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 22:58:35.270546	\N	INFO
379	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 22:58:39.579776	\N	INFO
380	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 23:02:03.429776	\N	INFO
381	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-20 23:02:04.380459	\N	INFO
382	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:02:20.403849	\N	INFO
383	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:02:22.95733	\N	INFO
384	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	34	\N	2025-04-20 23:02:22.983568	\N	INFO
385	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:02:23.011603	\N	INFO
386	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:02:23.013272	\N	INFO
387	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	21	\N	2025-04-20 23:02:23.03807	\N	INFO
388	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:06:33.235555	\N	INFO
389	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:06:33.236241	\N	INFO
390	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	18	\N	2025-04-20 23:06:33.311733	\N	INFO
391	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:06:33.294843	\N	INFO
392	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	84	\N	2025-04-20 23:06:33.37303	\N	INFO
393	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:06:46.515096	\N	INFO
394	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:06:47.512427	\N	INFO
395	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:06:52.760276	\N	INFO
396	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:06:55.017164	\N	INFO
397	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:06:55.024681	\N	INFO
398	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:06:55.068465	\N	INFO
399	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:06:55.072255	\N	INFO
400	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	28	\N	2025-04-20 23:06:55.099505	\N	INFO
401	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:07:43.633624	\N	INFO
402	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:07:44.65612	\N	INFO
403	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	16	\N	2025-04-20 23:09:46.262512	\N	INFO
404	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:09:47.5135	\N	INFO
405	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:09:49.584934	\N	INFO
406	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:09:51.124448	\N	INFO
407	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-20 23:09:54.278843	\N	INFO
408	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	34	\N	2025-04-20 23:09:54.309019	\N	INFO
409	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	13	\N	2025-04-20 23:09:54.341691	\N	INFO
410	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 23:09:54.40232	\N	INFO
411	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	53	\N	2025-04-20 23:09:54.412818	\N	INFO
412	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:10:00.674736	\N	INFO
413	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:10:02.369299	\N	INFO
414	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:14:17.873382	\N	INFO
415	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:14:27.743707	\N	INFO
416	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:14:27.745061	\N	INFO
417	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-20 23:14:27.789849	\N	INFO
418	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 23:14:27.80088	\N	INFO
419	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	58	\N	2025-04-20 23:14:27.849506	\N	INFO
420	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:15:24.47331	\N	INFO
421	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:15:25.295805	\N	INFO
422	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:15:28.317018	\N	INFO
423	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	19	\N	2025-04-20 23:15:31.753675	\N	INFO
424	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:15:33.668531	\N	INFO
425	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	137	\N	2025-04-20 23:28:18.29755	\N	INFO
426	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:20.957405	\N	INFO
427	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:21.649131	\N	INFO
428	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:28:23.585395	\N	INFO
429	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:25.498566	\N	INFO
430	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:25.499679	\N	INFO
431	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:25.54457	\N	INFO
432	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:25.548153	\N	INFO
438	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:33.193975	\N	INFO
433	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:25.549023	\N	INFO
434	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T13:28:33.120+00:00"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:28:33.12534	\N	INFO
435	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:28:33.145607	\N	INFO
437	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:33.193477	\N	INFO
436	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:33.189494	\N	INFO
439	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T13:28:35.697+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:35.69895	\N	INFO
440	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:35.749554	\N	INFO
441	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:35.784283	\N	INFO
442	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:28:35.789098	\N	INFO
443	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:28:35.788717	\N	INFO
444	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:30:06.393485	\N	INFO
445	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:30:06.397505	\N	INFO
446	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:30:06.488254	\N	INFO
447	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:30:06.489466	\N	INFO
448	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:30:06.494045	\N	INFO
449	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:32:30.677268	\N	INFO
450	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:32:31.665496	\N	INFO
451	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:32:32.460279	\N	INFO
452	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:32:35.128867	\N	INFO
453	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:32:35.132013	\N	INFO
454	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-20 23:32:35.186973	\N	INFO
455	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:32:35.188061	\N	INFO
456	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-20 23:32:35.199341	\N	INFO
457	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:32:39.73269	\N	INFO
458	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:32:40.813703	\N	INFO
459	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	138	\N	2025-04-20 23:37:42.700841	\N	INFO
460	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:37:48.582643	\N	INFO
461	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:37:48.58524	\N	INFO
462	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:37:48.64728	\N	INFO
463	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:37:48.646732	\N	INFO
464	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:37:48.650546	\N	INFO
465	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	12	\N	2025-04-20 23:40:41.937462	\N	INFO
466	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	42	\N	2025-04-20 23:40:41.966797	\N	INFO
467	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:40:41.997946	\N	INFO
468	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:40:42.004716	\N	INFO
469	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	51	\N	2025-04-20 23:40:42.046297	\N	INFO
470	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-20 23:41:04.719484	\N	INFO
471	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:41:04.762816	\N	INFO
472	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:04.781053	\N	INFO
473	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:41:04.785056	\N	INFO
474	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:41:08.055986	\N	INFO
475	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:08.082531	\N	INFO
476	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:41:08.101818	\N	INFO
477	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	32	\N	2025-04-20 23:41:08.130833	\N	INFO
478	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:23.448762	\N	INFO
479	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:41:24.142538	\N	INFO
480	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:41:24.980474	\N	INFO
481	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:41:26.604874	\N	INFO
482	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:27.917072	\N	INFO
483	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:41:27.918212	\N	INFO
484	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:27.967362	\N	INFO
485	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:41:27.969623	\N	INFO
486	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:41:27.971732	\N	INFO
487	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:46:07.565464	\N	INFO
488	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:07.566247	\N	INFO
489	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:07.643915	\N	INFO
490	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:07.648877	\N	INFO
491	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	11	\N	2025-04-20 23:46:07.658618	\N	INFO
492	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:18.842248	\N	INFO
494	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:46:18.892548	\N	INFO
496	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:46:19.911572	\N	INFO
499	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:19.958207	\N	INFO
502	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:21.141248	\N	INFO
504	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:49:55.32728	\N	INFO
506	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-20 23:49:55.384975	\N	INFO
513	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:50:02.995407	\N	INFO
493	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:18.887691	\N	INFO
497	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:19.952216	\N	INFO
500	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:21.093193	\N	INFO
501	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:21.136401	\N	INFO
507	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:49:55.387854	\N	INFO
510	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:50:02.952783	\N	INFO
514	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-20 23:50:02.999178	\N	INFO
517	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:55:44.991592	\N	INFO
495	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:46:18.894942	\N	INFO
498	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:46:19.957415	\N	INFO
503	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-20 23:46:21.141744	\N	INFO
505	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	11	\N	2025-04-20 23:49:55.33697	\N	INFO
508	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:49:55.388854	\N	INFO
509	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:50:00.933105	\N	INFO
511	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:50:02.953961	\N	INFO
512	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:50:02.995319	\N	INFO
515	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:55:34.600033	\N	INFO
516	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-20 23:55:34.654542	\N	INFO
518	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-20 23:55:45.082185	\N	INFO
519	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	214	\N	2025-04-20 23:56:21.660857	\N	INFO
520	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	40	\N	2025-04-20 23:56:26.328435	\N	INFO
521	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	17	\N	2025-04-20 23:56:26.367859	\N	INFO
522	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-20 23:56:36.687843	\N	INFO
523	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:56:39.8157	\N	INFO
524	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-20 23:56:47.548559	\N	INFO
525	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	17	\N	2025-04-21 00:21:46.190635	\N	INFO
526	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	30	\N	2025-04-21 00:21:46.194142	\N	INFO
527	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:22:08.938397	\N	INFO
528	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 00:22:08.942954	\N	INFO
529	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T14:22:15.484+00:00"}]	0:0:0:0:0:0:0:1	15	\N	2025-04-21 00:22:15.499507	\N	INFO
530	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	12	\N	2025-04-21 00:22:15.590455	\N	INFO
531	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 00:22:22.711463	\N	INFO
532	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	46	\N	2025-04-21 00:22:22.748748	\N	INFO
533	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:22:22.767658	\N	INFO
534	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:22:22.768934	\N	INFO
535	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	13	\N	2025-04-21 00:22:22.779931	\N	INFO
536	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:22:26.298262	\N	INFO
537	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	13	\N	2025-04-21 00:22:26.36034	\N	INFO
538	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:22:26.368103	\N	INFO
539	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 00:22:26.376919	\N	INFO
540	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:22:27.179902	\N	INFO
541	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:22:27.231523	\N	INFO
542	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:22:27.239261	\N	INFO
543	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:22:27.243209	\N	INFO
544	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:22:28.191906	\N	INFO
545	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:22:28.23827	\N	INFO
546	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:22:28.244593	\N	INFO
547	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:22:28.245925	\N	INFO
548	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 00:22:36.907347	\N	INFO
549	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 00:22:36.956534	\N	INFO
550	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:22:36.967075	\N	INFO
551	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	37	\N	2025-04-21 00:22:36.999023	\N	INFO
552	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:22:44.364117	\N	INFO
553	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 00:22:47.925435	\N	INFO
554	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:22:50.476132	\N	INFO
555	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:22:52.581858	\N	INFO
557	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:23:08.74125	\N	INFO
556	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:23:08.739264	\N	INFO
558	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:23:08.790984	\N	INFO
559	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:23:08.791323	\N	INFO
560	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:23:08.79499	\N	INFO
563	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:23:42.915948	\N	INFO
561	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	141	\N	2025-04-21 00:23:33.972107	\N	INFO
562	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:23:42.911069	\N	INFO
564	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:23:42.964451	\N	INFO
565	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 00:23:42.982698	\N	INFO
568	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 00:25:25.045679	\N	INFO
569	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:25:25.064041	\N	INFO
573	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:25:47.862231	\N	INFO
574	test1	\N	com.unsw.controller.OrderController.getById()	[27]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:25:47.878788	\N	INFO
576	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:26:59.672081	\N	INFO
577	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:26:59.759526	\N	INFO
583	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:27:52.740608	\N	INFO
585	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:27:52.787528	\N	INFO
586	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:27:52.797082	\N	INFO
587	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:30:43.95445	\N	INFO
589	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:43.965749	\N	INFO
593	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:30:43.973418	\N	INFO
594	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:30:43.976586	\N	INFO
598	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:30:43.984176	\N	INFO
603	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:44.029765	\N	INFO
604	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:30:44.069477	\N	INFO
607	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:33:26.627688	\N	INFO
610	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:33:26.708245	\N	INFO
613	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:33:37.205021	\N	INFO
616	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:33:37.270659	\N	INFO
617	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:39:29.390718	\N	INFO
619	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:39:29.402476	\N	INFO
622	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 00:39:29.498061	\N	INFO
625	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:39:29.50763	\N	INFO
628	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:41:26.419208	\N	INFO
629	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:41:26.4985	\N	INFO
566	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 00:23:42.985826	\N	INFO
567	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 00:25:25.012492	\N	INFO
570	test1	\N	com.unsw.controller.OrderController.getById()	[27]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:25:25.081704	\N	INFO
571	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:25:47.832701	\N	INFO
572	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:25:47.848504	\N	INFO
575	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:26:59.670836	\N	INFO
578	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:26:59.75996	\N	INFO
579	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:26:59.781061	\N	INFO
580	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"passowrd123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	129	\N	2025-04-21 00:27:34.98812	\N	INFO
581	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	138	\N	2025-04-21 00:27:40.710076	\N	INFO
582	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:27:52.737819	\N	INFO
584	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:27:52.786114	\N	INFO
588	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:30:43.956122	\N	INFO
590	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:30:43.966357	\N	INFO
591	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:30:43.969255	\N	INFO
595	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:30:43.977488	\N	INFO
596	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:43.981645	\N	INFO
600	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	35	\N	2025-04-21 00:30:44.016537	\N	INFO
601	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:44.020976	\N	INFO
602	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:44.025681	\N	INFO
605	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:30:44.07304	\N	INFO
611	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 00:33:26.709117	\N	INFO
612	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:33:37.203736	\N	INFO
614	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:33:37.264405	\N	INFO
618	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:39:29.392222	\N	INFO
620	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:39:29.406478	\N	INFO
621	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:39:29.487543	\N	INFO
623	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 00:39:29.498061	\N	INFO
626	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:39:29.508353	\N	INFO
627	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:41:26.418045	\N	INFO
630	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 00:41:26.507079	\N	INFO
631	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:41:26.512302	\N	INFO
632	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":1,"driverId":3,"vehicleId":1,"orderType":"bus_carpool","startLocation":"Kuala Lumpur International Airport","endLocation":"1 Utama Shopping Centre","estimatedTime":null,"fare":10,"passengerCount":5,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T14:41:31.898+00:00"}]	0:0:0:0:0:0:0:1	1745160091898	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET user_id = ?,             driver_id = ?,             vehicle_id = ?,             order_type = ?,             start_location = ?,             end_location = ?,                          fare = ?,             passenger_count = ?,                          status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n; bad SQL grammar []	2025-04-21 00:41:32.002563	\N	ERROR
592	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:30:43.972132	\N	INFO
597	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:30:43.982081	\N	INFO
599	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:30:43.989245	\N	INFO
606	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:30:44.073701	\N	INFO
608	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 00:33:26.629276	\N	INFO
609	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 00:33:26.703449	\N	INFO
615	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 00:33:37.266352	\N	INFO
624	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 00:39:29.498619	\N	INFO
633	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":1,"driverId":3,"vehicleId":1,"orderType":"bus_carpool","startLocation":"Kuala Lumpur International Airport","endLocation":"1 Utama Shopping Centre","estimatedTime":null,"fare":10,"passengerCount":5,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T14:41:41.537+00:00"}]	0:0:0:0:0:0:0:1	1745160101537	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET user_id = ?,             driver_id = ?,             vehicle_id = ?,             order_type = ?,             start_location = ?,             end_location = ?,                          fare = ?,             passenger_count = ?,                          status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n; bad SQL grammar []	2025-04-21 00:41:41.541393	\N	ERROR
634	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	215	\N	2025-04-21 02:33:55.569462	\N	INFO
635	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	25	\N	2025-04-21 02:34:00.499895	\N	INFO
636	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	43	\N	2025-04-21 02:34:00.517117	\N	INFO
637	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:34:00.562411	\N	INFO
638	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:34:00.563738	\N	INFO
639	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	37	\N	2025-04-21 02:34:00.600242	\N	INFO
640	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":1,"driverId":3,"vehicleId":1,"orderType":"bus_carpool","startLocation":"Kuala Lumpur International Airport","endLocation":"1 Utama Shopping Centre","estimatedTime":null,"fare":10,"passengerCount":5,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:34:08.824+00:00"}]	0:0:0:0:0:0:0:1	1745166848824	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET user_id = ?,             driver_id = ?,             vehicle_id = ?,             order_type = ?,             start_location = ?,             end_location = ?,                          fare = ?,             passenger_count = ?,                          status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n; bad SQL grammar []	2025-04-21 02:34:08.910356	\N	ERROR
641	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":1,"driverId":3,"vehicleId":1,"orderType":"bus_carpool","startLocation":"Kuala Lumpur International Airport","endLocation":"1 Utama Shopping Centre","estimatedTime":null,"fare":10,"passengerCount":5,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:34:18.316+00:00"}]	0:0:0:0:0:0:0:1	1745166858316	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET user_id = ?,             driver_id = ?,             vehicle_id = ?,             order_type = ?,             start_location = ?,             end_location = ?,                          fare = ?,             passenger_count = ?,                          status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "order_type" is of type order_type but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 124\n; bad SQL grammar []	2025-04-21 02:34:18.317937	\N	ERROR
642	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:36:27.472553	\N	INFO
643	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 02:36:27.476213	\N	INFO
644	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	13	\N	2025-04-21 02:36:27.484469	\N	INFO
645	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:36:27.486496	\N	INFO
646	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:36:27.487076	\N	INFO
647	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 02:36:27.505074	\N	INFO
648	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	35	\N	2025-04-21 02:36:27.534141	\N	INFO
649	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:36:27.588193	\N	INFO
654	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:37:26.458519	\N	INFO
661	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 02:38:25.116127	\N	INFO
664	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:38:25.162255	\N	INFO
665	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T16:38:26.644+00:00"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:38:26.649912	\N	INFO
666	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 02:38:26.707218	\N	INFO
667	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:26.740425	\N	INFO
673	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:38:29.341013	\N	INFO
675	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T16:38:31.330+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:38:31.334989	\N	INFO
677	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:31.42352	\N	INFO
680	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T16:38:33.030+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:38:33.034295	\N	INFO
684	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:33.158047	\N	INFO
688	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:04.783595	\N	INFO
691	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:07.93821	\N	INFO
693	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:13.387683	\N	INFO
694	test1	\N	com.unsw.controller.AdminController.getById()	[1]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:39:16.551322	\N	INFO
698	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:41:39.369101	\N	INFO
701	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.584529	\N	INFO
706	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.598343	\N	INFO
708	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.605604	\N	INFO
712	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.683312	\N	INFO
713	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 02:50:09.686693	\N	INFO
717	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.694281	\N	INFO
722	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:50:41.395965	\N	INFO
726	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:50:49.410+00:00"}]	0:0:0:0:0:0:0:1	1745167849410	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:50:49.414393	\N	ERROR
729	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:50:56.674245	\N	INFO
732	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:50:56.743316	\N	INFO
733	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:51:04.911+00:00"}]	0:0:0:0:0:0:0:1	1745167864911	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:51:04.913995	\N	ERROR
735	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 03:01:37.688485	\N	INFO
739	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:01:37.774784	\N	INFO
650	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:36:27.592556	\N	INFO
652	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:37:26.37939	\N	INFO
655	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	24	\N	2025-04-21 02:37:26.495222	\N	INFO
657	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:37:37.300+00:00"}]	0:0:0:0:0:0:0:1	1745167057300	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:37:37.304349	\N	ERROR
658	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:37:45.074+00:00"}]	0:0:0:0:0:0:0:1	1745167065074	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:37:45.076526	\N	ERROR
659	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:38:04.251+00:00"}]	0:0:0:0:0:0:0:1	1745167084251	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:38:04.257097	\N	ERROR
660	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T16:38:25.062+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:38:25.065738	\N	INFO
663	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:25.158254	\N	INFO
670	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T16:38:29.280+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:38:29.284177	\N	INFO
671	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 02:38:29.302487	\N	INFO
674	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:29.341696	\N	INFO
678	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 02:38:31.435778	\N	INFO
683	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:33.157058	\N	INFO
686	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:39:04.707486	\N	INFO
690	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 02:39:04.795578	\N	INFO
692	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:08.782022	\N	INFO
695	test1	\N	com.unsw.controller.AdminController.getById()	[2]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:18.697206	\N	INFO
697	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:41:39.314182	\N	INFO
699	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:41:39.371089	\N	INFO
704	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:50:09.585162	\N	INFO
714	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.686706	\N	INFO
718	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:50:09.694827	\N	INFO
721	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:41.393009	\N	INFO
723	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:41.48183	\N	INFO
769	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	89	\N	2025-04-21 03:29:42.02508	\N	INFO
770	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:29:48.581569	\N	INFO
771	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	16	\N	2025-04-21 03:29:50.385009	\N	INFO
651	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 02:36:27.597575	\N	INFO
653	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:37:26.381512	\N	INFO
662	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:38:25.155613	\N	INFO
669	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:26.746699	\N	INFO
672	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:29.335389	\N	INFO
676	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 02:38:31.387258	\N	INFO
679	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	38	\N	2025-04-21 02:38:31.465804	\N	INFO
682	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:38:33.150006	\N	INFO
685	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:38:43.155+00:00"}]	0:0:0:0:0:0:0:1	1745167123155	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:38:43.158597	\N	ERROR
687	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:04.708848	\N	INFO
689	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:39:04.786486	\N	INFO
696	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:41:39.31182	\N	INFO
700	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 02:41:39.38391	\N	INFO
703	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.58453	\N	INFO
710	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 02:50:09.639971	\N	INFO
715	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.687393	\N	INFO
720	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.700379	\N	INFO
728	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:56.672507	\N	INFO
730	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:56.736449	\N	INFO
737	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:01:37.770512	\N	INFO
744	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:02:50.746+00:00"}]	0:0:0:0:0:0:0:1	1745168570746	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:02:50.751602	\N	ERROR
656	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	51	\N	2025-04-21 02:37:26.513874	\N	INFO
668	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:38:26.745573	\N	INFO
681	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 02:38:33.09745	\N	INFO
702	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.584918	\N	INFO
705	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	11	\N	2025-04-21 02:50:09.593897	\N	INFO
707	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:09.604623	\N	INFO
709	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	31	\N	2025-04-21 02:50:09.635745	\N	INFO
711	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 02:50:09.644487	\N	INFO
716	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.693718	\N	INFO
719	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 02:50:09.699455	\N	INFO
724	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 02:50:41.483551	\N	INFO
725	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 02:50:41.506158	\N	INFO
727	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:50:49.432+00:00"}]	0:0:0:0:0:0:0:1	1745167849432	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:50:49.434058	\N	ERROR
731	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 02:50:56.740217	\N	INFO
736	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:01:37.689744	\N	INFO
738	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:01:37.77246	\N	INFO
740	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:01:51.914+00:00"}]	0:0:0:0:0:0:0:1	1745168511914	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:01:51.9214	\N	ERROR
742	test1	\N	com.unsw.controller.OrderController.update()	[23,{"id":23,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"completed","createdAt":null,"updatedAt":"2025-04-20T17:01:58.561+00:00"}]	0:0:0:0:0:0:0:1	1745168518561	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:01:58.564278	\N	ERROR
745	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:02:50.828+00:00"}]	0:0:0:0:0:0:0:1	1745168570828	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:02:50.830612	\N	ERROR
734	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T16:51:04.935+00:00"}]	0:0:0:0:0:0:0:1	1745167864935	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 02:51:04.937941	\N	ERROR
741	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:01:51.942+00:00"}]	0:0:0:0:0:0:0:1	1745168511942	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:01:51.944106	\N	ERROR
743	test1	\N	com.unsw.controller.OrderController.update()	[23,{"id":23,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"completed","createdAt":null,"updatedAt":"2025-04-20T17:01:58.581+00:00"}]	0:0:0:0:0:0:0:1	1745168518581	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:01:58.583589	\N	ERROR
746	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:04:37.038+00:00"}]	0:0:0:0:0:0:0:1	1745168677038	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:04:37.043635	\N	ERROR
747	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:04:37.095+00:00"}]	0:0:0:0:0:0:0:1	1745168677095	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:04:37.097246	\N	ERROR
748	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	17	\N	2025-04-21 03:07:31.61454	\N	INFO
749	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	54	\N	2025-04-21 03:07:31.652946	\N	INFO
751	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 03:07:31.730728	\N	INFO
750	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 03:07:31.730675	\N	INFO
752	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:07:31.737638	\N	INFO
755	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 03:10:50.148365	\N	INFO
757	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:10:50.250582	\N	INFO
759	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	57	\N	2025-04-21 03:10:50.307084	\N	INFO
772	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:29:52.492405	\N	INFO
753	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:07:42.951+00:00"}]	0:0:0:0:0:0:0:1	1745168862951	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:07:42.954606	\N	ERROR
754	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:08:24.535+00:00"}]	0:0:0:0:0:0:0:1	1745168904535	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:08:24.540727	\N	ERROR
756	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	39	\N	2025-04-21 03:10:50.180619	\N	INFO
758	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 03:10:50.257146	\N	INFO
760	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:11:04.137+00:00"}]	0:0:0:0:0:0:0:1	1745169064137	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:11:04.140461	\N	ERROR
761	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:15:02.956+00:00"}]	0:0:0:0:0:0:0:1	1745169302956	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:15:02.959911	\N	ERROR
762	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	206	\N	2025-04-21 03:15:38.737192	\N	INFO
763	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-21 03:15:43.938416	\N	INFO
764	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	35	\N	2025-04-21 03:15:43.95999	\N	INFO
765	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	33	\N	2025-04-21 03:15:44.075677	\N	INFO
766	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	37	\N	2025-04-21 03:15:44.089542	\N	INFO
767	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	68	\N	2025-04-21 03:15:44.099635	\N	INFO
768	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"cancelled","createdAt":null,"updatedAt":"2025-04-20T17:16:10.722+00:00"}]	0:0:0:0:0:0:0:1	1745169370722	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:16:10.787298	\N	ERROR
773	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:29:54.384066	\N	INFO
774	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:30:03.869116	\N	INFO
775	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:30:07.257006	\N	INFO
776	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	49	\N	2025-04-21 03:30:09.494097	\N	INFO
777	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:30:32.377148	\N	INFO
778	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:30:46.09305	\N	INFO
779	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-21 03:31:38.98136	\N	INFO
780	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	31	\N	2025-04-21 03:31:38.988365	\N	INFO
781	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:31:39.120247	\N	INFO
782	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 03:31:39.143268	\N	INFO
783	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	27	\N	2025-04-21 03:31:39.159227	\N	INFO
784	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	201	\N	2025-04-21 03:43:47.444263	\N	INFO
785	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 03:43:51.150899	\N	INFO
786	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	15	\N	2025-04-21 03:43:52.057928	\N	INFO
787	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:43:53.279716	\N	INFO
788	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 03:43:55.479788	\N	INFO
789	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	36	\N	2025-04-21 03:43:55.505511	\N	INFO
790	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:43:55.57665	\N	INFO
791	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	14	\N	2025-04-21 03:43:55.600896	\N	INFO
792	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	55	\N	2025-04-21 03:43:55.634679	\N	INFO
793	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:44:15.868+00:00"}]	0:0:0:0:0:0:0:1	1745171055868	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:44:15.952874	\N	ERROR
794	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:44:23.095+00:00"}]	0:0:0:0:0:0:0:1	1745171063094	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:44:23.110063	\N	ERROR
795	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:44:34.110+00:00"}]	0:0:0:0:0:0:0:1	1745171074110	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:44:34.113019	\N	ERROR
796	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T17:44:50.655+00:00"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 03:44:50.661272	\N	INFO
797	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 03:44:50.73955	\N	INFO
798	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:44:50.792033	\N	INFO
799	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:44:50.798676	\N	INFO
800	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	37	\N	2025-04-21 03:44:50.837551	\N	INFO
801	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T17:44:53.312+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:44:53.315032	\N	INFO
804	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:44:53.434976	\N	INFO
810	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:45:26.380375	\N	INFO
811	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T17:45:29.085+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:45:29.088655	\N	INFO
812	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:45:29.178444	\N	INFO
815	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:45:29.225702	\N	INFO
802	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:44:53.381693	\N	INFO
805	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:44:53.436278	\N	INFO
806	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T17:45:26.263+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:45:26.265913	\N	INFO
809	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:45:26.378733	\N	INFO
814	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 03:45:29.22179	\N	INFO
803	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:44:53.427368	\N	INFO
807	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 03:45:26.333264	\N	INFO
808	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:45:26.373409	\N	INFO
813	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 03:45:29.211976	\N	INFO
816	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:46:00.123+00:00"}]	0:0:0:0:0:0:0:1	1745171160122	org.springframework.jdbc.BadSqlGrammarException: \n### Error updating database.  Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n### The error may exist in file [/Users/yhq/Java/IdeaWorkspace/web-management-project/comp9900-management-module01/target/classes/mapper/OrdersMapper.xml]\n### The error may involve com.unsw.mapper.OrdersMapper.updateByPrimaryKeySelective-Inline\n### The error occurred while setting parameters\n### SQL: UPDATE orders          SET status = ?,                          updated_at = ?          WHERE id = ?\n### Cause: org.postgresql.util.PSQLException: ERROR: column "status" is of type order_status but expression is of type character varying\n  Hint: You will need to rewrite or cast the expression.\n  Position: 37\n; bad SQL grammar []	2025-04-21 03:46:00.125967	\N	ERROR
817	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	14	\N	2025-04-21 03:55:28.430133	\N	INFO
818	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	30	\N	2025-04-21 03:55:28.438737	\N	INFO
819	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 03:55:28.624004	\N	INFO
820	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	25	\N	2025-04-21 03:55:28.642462	\N	INFO
821	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	35	\N	2025-04-21 03:55:28.664017	\N	INFO
822	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T17:55:34.100+00:00"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 03:55:34.105789	\N	INFO
823	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:55:34.189034	\N	INFO
824	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:55:34.235089	\N	INFO
825	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 03:55:34.240668	\N	INFO
826	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 03:55:34.247772	\N	INFO
827	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T17:55:38.366+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:55:38.370547	\N	INFO
828	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:55:38.454711	\N	INFO
829	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 03:55:38.491277	\N	INFO
830	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 03:55:38.506446	\N	INFO
831	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	39	\N	2025-04-21 03:55:38.53679	\N	INFO
832	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"completed","createdAt":null,"updatedAt":"2025-04-20T17:55:44.197+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:55:44.200374	\N	INFO
833	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 03:55:44.269354	\N	INFO
834	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:55:44.324581	\N	INFO
835	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:55:44.329535	\N	INFO
836	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:55:44.334275	\N	INFO
837	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 03:56:41.670341	\N	INFO
838	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 03:56:41.670385	\N	INFO
839	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 03:56:41.783457	\N	INFO
840	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 03:56:41.785163	\N	INFO
841	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 03:56:41.793981	\N	INFO
842	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:00:18.309753	\N	INFO
843	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:00:18.310044	\N	INFO
844	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:00:18.46287	\N	INFO
845	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:00:18.467017	\N	INFO
846	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	12	\N	2025-04-21 04:00:18.48193	\N	INFO
847	test1	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:00:56.191+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:00:56.196867	\N	INFO
848	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:00:56.263233	\N	INFO
849	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:00:56.331933	\N	INFO
850	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:00:56.33869	\N	INFO
851	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:00:56.339095	\N	INFO
852	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:01:01.844+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:01.848187	\N	INFO
855	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:02.000493	\N	INFO
857	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:04.53835	\N	INFO
859	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:06.612635	\N	INFO
862	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:06.715395	\N	INFO
864	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:11.114191	\N	INFO
867	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:11.167942	\N	INFO
869	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:01:19.175787	\N	INFO
872	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:19.228573	\N	INFO
853	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:01:01.933321	\N	INFO
854	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:01.993837	\N	INFO
858	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:06.60867	\N	INFO
861	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:06.71372	\N	INFO
866	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:01:11.166009	\N	INFO
871	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:19.227393	\N	INFO
856	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:01:02.002352	\N	INFO
860	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:06.709934	\N	INFO
863	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:01:11.040+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:01:11.043538	\N	INFO
865	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:11.160864	\N	INFO
868	test1	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:01:19.086+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:19.088013	\N	INFO
870	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:01:19.221779	\N	INFO
873	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:02:21.974945	\N	INFO
874	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:02:21.976592	\N	INFO
875	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:02:22.149365	\N	INFO
876	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:02:22.14931	\N	INFO
877	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:02:22.156918	\N	INFO
878	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:07:54.594751	\N	INFO
879	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:07:54.595397	\N	INFO
880	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:07:54.727178	\N	INFO
881	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:07:54.729494	\N	INFO
882	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	38	\N	2025-04-21 04:07:54.775273	\N	INFO
883	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:08:03.24328	\N	INFO
884	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:08:03.246166	\N	INFO
885	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:08:03.3408	\N	INFO
886	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:08:03.344823	\N	INFO
887	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:08:03.347842	\N	INFO
888	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:08:35.394+00:00"}]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:08:35.396794	\N	INFO
889	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:08:35.46943	\N	INFO
890	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	19	\N	2025-04-21 04:08:35.539847	\N	INFO
891	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:08:35.542946	\N	INFO
892	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:08:35.543543	\N	INFO
893	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:16:54.009285	\N	INFO
894	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:16:54.010554	\N	INFO
895	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	24	\N	2025-04-21 04:16:54.20675	\N	INFO
896	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	49	\N	2025-04-21 04:16:54.210002	\N	INFO
897	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:16:54.213332	\N	INFO
898	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:16:58.788+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:16:58.790811	\N	INFO
899	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:16:58.809239	\N	INFO
900	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 04:16:58.869601	\N	INFO
901	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:16:58.870455	\N	INFO
902	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:16:58.8732	\N	INFO
903	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:17:01.741+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:01.744326	\N	INFO
904	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:01.819466	\N	INFO
905	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:01.867093	\N	INFO
906	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:01.871764	\N	INFO
907	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:01.873579	\N	INFO
908	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:17:08.208+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:08.212208	\N	INFO
909	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:08.282942	\N	INFO
910	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:08.325222	\N	INFO
911	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:08.329023	\N	INFO
912	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:08.331805	\N	INFO
913	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	143	\N	2025-04-21 04:17:30.159128	\N	INFO
918	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 04:17:37.686878	\N	INFO
921	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:37.79376	\N	INFO
922	test1	\N	com.unsw.controller.OrderController.update()	[25,{"id":25,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":"confirmed","createdAt":null,"updatedAt":"2025-04-20T18:17:44.614+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:44.616556	\N	INFO
923	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	44	\N	2025-04-21 04:17:44.727109	\N	INFO
926	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:44.827027	\N	INFO
927	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:52.869848	\N	INFO
928	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:52.884887	\N	INFO
930	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:23:30.645659	\N	INFO
934	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:23:30.784193	\N	INFO
938	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:23:36.546614	\N	INFO
914	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:17:34.832934	\N	INFO
917	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:37.686604	\N	INFO
920	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:37.792744	\N	INFO
924	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:17:44.815843	\N	INFO
929	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:52.897955	\N	INFO
931	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:23:30.64569	\N	INFO
932	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:23:30.774821	\N	INFO
935	test1	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:23:36.367+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:23:36.370318	\N	INFO
936	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 04:23:36.440178	\N	INFO
937	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:23:36.537337	\N	INFO
940	test1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	1745173429220	org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.unsw.mapper.PaymentsMapper.findByPage	2025-04-21 04:23:49.225569	\N	ERROR
915	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:35.474452	\N	INFO
916	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:36.045936	\N	INFO
919	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:17:37.790807	\N	INFO
925	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:17:44.821336	\N	INFO
933	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 04:23:30.783546	\N	INFO
939	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:23:36.547201	\N	INFO
941	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test1","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	157	\N	2025-04-21 04:49:56.935425	\N	INFO
942	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:50:01.49558	\N	INFO
943	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 04:50:02.277379	\N	INFO
944	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:50:03.246235	\N	INFO
945	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	11	\N	2025-04-21 04:50:05.135337	\N	INFO
946	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	61	\N	2025-04-21 04:50:05.183082	\N	INFO
947	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:50:05.22097	\N	INFO
948	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:50:05.225283	\N	INFO
949	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	46	\N	2025-04-21 04:50:05.265525	\N	INFO
950	test1	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":20,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-20T18:50:35.764+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:50:35.768166	\N	INFO
951	test1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:50:35.832401	\N	INFO
952	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:50:35.876805	\N	INFO
953	test1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:50:35.882395	\N	INFO
954	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:50:35.884093	\N	INFO
955	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 04:50:43.008368	\N	INFO
956	anonymousUser	\N	com.unsw.controller.UserController.update()	[1,{"id":1,"username":"test1","fullName":"test1","email":"123@qq.com","phoneNumber":"13299999991","password":null,"photo":"","createdAt":"2025-04-20T04:23:14.362+00:00","updatedAt":"2025-04-20T18:50:45.724+00:00"}]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 04:50:52.547889	\N	INFO
957	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:50:52.560162	\N	INFO
958	test1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	12	\N	2025-04-21 04:50:55.901702	\N	INFO
959	test1	\N	com.unsw.controller.DriverController.getById()	[2]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:50:58.821618	\N	INFO
960	test1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:51:01.742686	\N	INFO
961	test1	\N	com.unsw.controller.AdminController.getById()	[1]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:51:03.923686	\N	INFO
962	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	116	\N	2025-04-21 04:51:38.814373	\N	INFO
963	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	11	\N	2025-04-21 04:51:43.313199	\N	INFO
964	admin1	\N	com.unsw.controller.AdminController.delete()	[1]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 04:51:48.497482	\N	INFO
965	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 04:51:50.417527	\N	INFO
966	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 04:51:53.989442	\N	INFO
967	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 05:06:32.392116	\N	INFO
968	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	213	\N	2025-04-21 12:44:32.046206	\N	INFO
969	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 12:44:40.396239	\N	INFO
970	admin1	\N	com.unsw.controller.AdminController.getById()	[2]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 12:44:44.801482	\N	INFO
971	admin1	\N	com.unsw.controller.AdminController.getById()	[3]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:44:48.824997	\N	INFO
972	admin1	\N	com.unsw.controller.AdminController.getById()	[4]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:44:50.829834	\N	INFO
973	admin1	\N	com.unsw.controller.AdminController.getById()	[2]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:44:59.343452	\N	INFO
974	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 12:45:47.226017	\N	INFO
975	admin1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	21	\N	2025-04-21 12:45:53.132559	\N	INFO
976	admin1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	1745203556278	org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.unsw.mapper.PaymentsMapper.findByPage	2025-04-21 12:45:56.279786	\N	ERROR
977	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-21 12:45:58.287948	\N	INFO
978	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 12:46:03.600389	\N	INFO
979	admin1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 12:46:21.612555	\N	INFO
980	admin1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	67	\N	2025-04-21 12:46:21.670927	\N	INFO
981	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:46:21.711101	\N	INFO
982	admin1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:46:21.713115	\N	INFO
983	admin1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 12:46:21.72588	\N	INFO
988	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	134	\N	2025-04-21 12:46:50.853738	\N	INFO
989	admin1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:51:25.43697	\N	INFO
992	admin1	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 12:51:25.542699	\N	INFO
995	admin1	\N	com.unsw.controller.AdminController.delete()	[4]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 12:51:52.330827	\N	INFO
1000	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:53:10.929943	\N	INFO
1001	admin123	\N	com.unsw.controller.AdminController.delete()	[2]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:53:14.382711	\N	INFO
1005	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 12:54:04.486449	\N	INFO
1006	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 12:54:12.953094	\N	INFO
1010	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:55:22.867998	\N	INFO
984	admin1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 12:46:34.775693	\N	INFO
985	admin1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	1745203601750	org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.unsw.mapper.PaymentsMapper.findByPage	2025-04-21 12:46:41.751017	\N	ERROR
986	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-21 12:46:43.354943	\N	INFO
987	admin1	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	1745203608479	org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.unsw.mapper.PaymentsMapper.findByPage	2025-04-21 12:46:48.480694	\N	ERROR
990	admin1	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 12:51:25.440265	\N	INFO
991	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:51:25.529523	\N	INFO
993	admin1	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	59	\N	2025-04-21 12:51:25.590493	\N	INFO
994	admin1	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 12:51:31.107826	\N	INFO
996	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:51:58.620723	\N	INFO
997	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:52:37.681515	\N	INFO
998	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"test2","fullName":null,"email":null,"phoneNumber":null,"password":"password123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:52:44.181225	\N	INFO
999	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	136	\N	2025-04-21 12:53:04.476889	\N	INFO
1002	admin123	\N	com.unsw.controller.AdminController.save()	[{"id":null,"username":"admin1","fullName":null,"email":"admin@qq.com","phoneNumber":null,"password":"admin1","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 12:53:38.091367	\N	INFO
1003	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:53:46.089008	\N	INFO
1004	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	1745204041427	org.apache.ibatis.binding.BindingException: Invalid bound statement (not found): com.unsw.mapper.PaymentsMapper.findByPage	2025-04-21 12:54:01.428496	\N	ERROR
1007	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	136	\N	2025-04-21 12:54:22.772418	\N	INFO
1008	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 12:54:48.036736	\N	INFO
1009	admin123	\N	com.unsw.controller.AdminController.save()	[{"id":null,"username":"admin3","fullName":null,"email":"admin3@qq.com","phoneNumber":null,"password":"admin3","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 12:55:14.651189	\N	INFO
1011	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:03:26.82341	\N	INFO
1012	admin123	\N	com.unsw.controller.AdminController.save()	[{"id":null,"username":"admin4","fullName":null,"email":"admin4@qq.com","phoneNumber":null,"password":"$2a$10$6.j50ev3ql6eC5wos9gfyeLuYvr4rEJFnWI6ujsRiJCLgS/pNVunm","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	105	\N	2025-04-21 13:03:52.164569	\N	INFO
1013	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 13:03:57.99479	\N	INFO
1014	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 13:08:57.234294	\N	INFO
1015	admin123	\N	com.unsw.controller.AdminController.save()	[{"id":null,"username":"admin5","fullName":null,"email":"admin@qq.com","phoneNumber":null,"password":"$2a$10$lw1B24Tq1Zyc481xXxDUEOt204qpiCB4LvFaG3sKzNs2TQVP259wG","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	104	\N	2025-04-21 13:09:31.313456	\N	INFO
1016	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 13:09:34.155469	\N	INFO
1017	admin123	\N	com.unsw.controller.AdminController.delete()	[9]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 13:09:38.450312	\N	INFO
1018	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 13:09:43.095009	\N	INFO
1019	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 13:33:47.693555	\N	INFO
1020	admin123	\N	com.unsw.controller.AdminController.getById()	[8]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:33:52.069469	\N	INFO
1021	admin123	\N	com.unsw.controller.AdminController.save()	[{"id":null,"username":"admin6","fullName":null,"email":"admin6@qq.com","phoneNumber":null,"password":"$2a$10$iHACRLhnJVhLCPUCYOi5JOZdjKtjx5bPqFcRjCgvKgWiGBVM.1YCK","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	107	\N	2025-04-21 13:34:15.26094	\N	INFO
1022	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 13:34:19.192394	\N	INFO
1023	admin123	\N	com.unsw.controller.AdminController.delete()	[10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 13:35:44.234498	\N	INFO
1024	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 13:35:46.517427	\N	INFO
1025	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:35:51.084641	\N	INFO
1026	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	16	\N	2025-04-21 13:35:51.683336	\N	INFO
1027	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:35:52.143254	\N	INFO
1028	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	15	\N	2025-04-21 13:35:56.402663	\N	INFO
1029	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 13:35:57.348748	\N	INFO
1030	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 13:36:00.200153	\N	INFO
1031	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 13:36:00.939462	\N	INFO
1032	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	59	\N	2025-04-21 13:36:00.996832	\N	INFO
1033	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 13:36:01.026586	\N	INFO
1034	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:36:01.037837	\N	INFO
1037	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 13:44:27.03954	\N	INFO
1039	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	15	\N	2025-04-21 13:44:27.161242	\N	INFO
1035	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	53	\N	2025-04-21 13:36:01.082067	\N	INFO
1036	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 13:44:27.033731	\N	INFO
1038	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 13:44:27.139111	\N	INFO
1040	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	55	\N	2025-04-21 13:44:27.19439	\N	INFO
1041	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin1","fullName":null,"email":null,"phoneNumber":null,"password":"admin1","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 13:58:00.843564	\N	INFO
1042	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	146	\N	2025-04-21 13:58:04.533649	\N	INFO
1043	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	236	\N	2025-04-21 14:56:19.314575	\N	INFO
1044	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	67	\N	2025-04-21 14:56:21.254158	\N	INFO
1045	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 14:57:08.791529	\N	INFO
1046	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 15:03:04.042325	\N	INFO
1047	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	212	\N	2025-04-21 15:36:08.001968	\N	INFO
1048	anonymousUser	\N	com.unsw.controller.AuthController.register()	[{"id":null,"username":"admin9","fullName":"Admin","email":"","phoneNumber":"","password":"$2a$10$87sbzrshlfgJJX4ces/./ODz0JJkkNyDGO6D3blRCeBS03gIq5ubS","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	256	\N	2025-04-21 15:36:43.223784	\N	INFO
1049	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin9","fullName":null,"email":null,"phoneNumber":null,"password":"admin9","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	130	\N	2025-04-21 15:36:57.903809	\N	INFO
1050	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin9","fullName":null,"email":null,"phoneNumber":null,"password":"admin9","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	126	\N	2025-04-21 15:37:02.529056	\N	INFO
1051	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin9","fullName":null,"email":null,"phoneNumber":null,"password":"admin9","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	133	\N	2025-04-21 15:37:04.629647	\N	INFO
1052	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	116	\N	2025-04-21 15:37:26.866009	\N	INFO
1053	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	12	\N	2025-04-21 15:53:43.536522	\N	INFO
1054	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	14	\N	2025-04-21 15:53:44.26901	\N	INFO
1055	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 15:53:45.397174	\N	INFO
1056	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	19	\N	2025-04-21 15:53:46.904483	\N	INFO
1057	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	80	\N	2025-04-21 15:53:46.971807	\N	INFO
1058	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 15:53:47.014027	\N	INFO
1059	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 15:53:47.079443	\N	INFO
1060	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	36	\N	2025-04-21 15:53:47.094046	\N	INFO
1061	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 15:53:48.412359	\N	INFO
1062	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 15:53:49.290045	\N	INFO
1063	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 15:53:51.522023	\N	INFO
1064	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	16	\N	2025-04-21 16:29:10.327432	\N	INFO
1065	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 16:29:11.730706	\N	INFO
1066	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 16:29:12.583652	\N	INFO
1067	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	15	\N	2025-04-21 16:29:15.055424	\N	INFO
1068	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	108	\N	2025-04-21 16:29:15.152748	\N	INFO
1069	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 16:29:15.155764	\N	INFO
1070	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	29	\N	2025-04-21 16:29:15.18774	\N	INFO
1071	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	29	\N	2025-04-21 16:29:15.234646	\N	INFO
1072	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 16:29:16.694793	\N	INFO
1073	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	9	\N	2025-04-21 16:29:17.579269	\N	INFO
1074	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 16:29:20.036938	\N	INFO
1075	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	124	\N	2025-04-21 16:58:05.525425	\N	INFO
1076	anonymousUser	\N	com.unsw.controller.AuthController.register()	[{"id":null,"username":"Admin","fullName":"Admin","email":"Admin@qq.com","phoneNumber":"0401000000","password":"$2a$10$MNS1.R.mTRbS.DtzKWPf.uT.TOxGME22VEgt/3J1Ho9pNpTxWQEb2","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	299	\N	2025-04-21 19:24:13.760288	\N	INFO
1077	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin","fullName":null,"email":null,"phoneNumber":null,"password":"Admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	109	\N	2025-04-21 19:24:19.152	\N	INFO
1123	Admin	\N	com.unsw.controller.AdminController.delete()	[14]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:08:46.891325	\N	INFO
1078	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin","fullName":null,"email":null,"phoneNumber":null,"password":"Admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	136	\N	2025-04-21 19:24:25.09942	\N	INFO
1079	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin9","fullName":null,"email":null,"phoneNumber":null,"password":"admin9","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-21 19:25:37.075043	\N	INFO
1080	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin9","fullName":null,"email":null,"phoneNumber":null,"password":"admin9","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	122	\N	2025-04-21 19:25:44.617893	\N	INFO
1081	anonymousUser	\N	com.unsw.controller.AuthController.register()	[{"id":null,"username":"Admin3","fullName":"Admin","email":"Admin@qq.com","phoneNumber":"02323231231","password":"$2a$10$sh3rg869Woyfrrma8bOuAOnUURQqyrsRmMqCS22UeewoZedlanpLS","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	197	\N	2025-04-21 19:37:04.730004	\N	INFO
1082	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin3","fullName":null,"email":null,"phoneNumber":null,"password":"Admin3","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	159	\N	2025-04-21 19:37:17.965936	\N	INFO
1083	Admin3	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 19:37:35.760308	\N	INFO
1084	Admin3	\N	com.unsw.controller.AdminController.delete()	[11]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 19:37:42.333837	\N	INFO
1085	Admin3	\N	com.unsw.controller.AdminController.delete()	[8]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 19:37:45.453244	\N	INFO
1086	Admin3	\N	com.unsw.controller.AdminController.delete()	[7]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 19:37:47.936849	\N	INFO
1087	Admin3	\N	com.unsw.controller.AdminController.delete()	[6]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 19:37:50.961211	\N	INFO
1088	Admin3	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 19:37:53.630321	\N	INFO
1089	Admin3	\N	com.unsw.controller.AdminController.delete()	[12]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 19:37:58.486634	\N	INFO
1090	Admin3	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 19:38:00.532958	\N	INFO
1091	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"admin123","fullName":null,"email":null,"phoneNumber":null,"password":"admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	134	\N	2025-04-21 19:54:59.540296	\N	INFO
1092	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	114	\N	2025-04-21 19:55:02.178739	\N	INFO
1093	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 19:55:05.039421	\N	INFO
1094	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	12	\N	2025-04-21 19:55:06.020285	\N	INFO
1095	admin123	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 19:55:07.213085	\N	INFO
1096	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	18	\N	2025-04-21 19:55:09.071056	\N	INFO
1097	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	38	\N	2025-04-21 19:55:09.092342	\N	INFO
1098	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 19:55:09.19554	\N	INFO
1099	admin123	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 19:55:09.207192	\N	INFO
1100	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 19:55:15.262347	\N	INFO
1101	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 19:55:17.409888	\N	INFO
1102	admin123	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 19:55:18.938697	\N	INFO
1103	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 19:55:19.745695	\N	INFO
1104	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 19:55:22.103516	\N	INFO
1105	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 19:56:26.279155	\N	INFO
1106	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 19:56:27.185407	\N	INFO
1107	admin123	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 19:57:36.332651	\N	INFO
1108	admin123	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 19:57:40.110612	\N	INFO
1109	anonymousUser	\N	com.unsw.controller.AuthController.register()	[{"id":null,"username":"Admin","fullName":"Admin","email":"Admin@qq.com","phoneNumber":"0401203442","password":"$2a$10$5GkXcKV3FBYagiqNDDquEey9jw9o8Am.roUlBXJAf1sQj4dtnZege","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	195	\N	2025-04-21 19:59:41.27647	\N	INFO
1110	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin","fullName":null,"email":null,"phoneNumber":null,"password":"Admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	152	\N	2025-04-21 19:59:53.9241	\N	INFO
1111	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:06:13.198541	\N	INFO
1112	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	16	\N	2025-04-21 20:06:13.966802	\N	INFO
1113	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 20:06:14.560514	\N	INFO
1114	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	11	\N	2025-04-21 20:06:16.176954	\N	INFO
1115	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	67	\N	2025-04-21 20:06:16.235045	\N	INFO
1116	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:06:16.29516	\N	INFO
1117	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 20:06:16.311828	\N	INFO
1118	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 20:06:17.478974	\N	INFO
1119	Admin	\N	com.unsw.controller.PaymentController.list()	[null,null,null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 20:06:18.076588	\N	INFO
1120	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:06:19.41322	\N	INFO
1121	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin","fullName":null,"email":null,"phoneNumber":null,"password":"Admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	133	\N	2025-04-21 20:08:38.987567	\N	INFO
1122	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:08:42.356614	\N	INFO
1124	anonymousUser	\N	com.unsw.controller.AuthController.register()	[{"id":null,"username":"Admin","fullName":"Admin","email":"Admin@qq.com","phoneNumber":"0401333222","password":"$2a$10$xMO1Iv6uPZU7Fv6SpWXa2uU/6AiBQeUd9FPNSlTP63MseVm7Z94gW","role":"ADMIN","createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	135	\N	2025-04-21 20:10:00.441522	\N	INFO
1125	anonymousUser	\N	com.unsw.controller.AuthController.adminLogin()	[{"id":null,"username":"Admin","fullName":null,"email":null,"phoneNumber":null,"password":"Admin123","role":null,"createdAt":null,"updatedAt":null}]	0:0:0:0:0:0:0:1	109	\N	2025-04-21 20:10:15.464189	\N	INFO
1126	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:24:38.817001	\N	INFO
1128	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:24:51.292008	\N	INFO
1129	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:24:54.584292	\N	INFO
1130	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:24:58.187209	\N	INFO
1131	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:25:06.053331	\N	INFO
1132	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:25:07.372948	\N	INFO
1134	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:25:13.16815	\N	INFO
1136	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:25:47.343058	\N	INFO
1137	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:25:51.737961	\N	INFO
1138	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:25:57.203038	\N	INFO
1139	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:26:14.677774	\N	INFO
1140	Admin	\N	com.unsw.controller.DriverController.getById()	[2]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:26:19.948558	\N	INFO
1141	Admin	\N	com.unsw.controller.DriverController.updateStatus()	[2,{"status":"available"}]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:26:33.922302	\N	INFO
1142	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:26:33.949361	\N	INFO
1143	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:26:37.102332	\N	INFO
1127	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 20:24:44.491336	\N	INFO
1133	anonymousUser	\N	com.unsw.controller.UserController.list()	["",1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:25:09.819631	\N	INFO
1135	Admin	\N	com.unsw.controller.AdminController.list()	["",1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:25:19.245915	\N	INFO
1144	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	11	\N	2025-04-21 20:30:52.497956	\N	INFO
1145	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	63	\N	2025-04-21 20:30:52.550177	\N	INFO
1146	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:30:52.609775	\N	INFO
1147	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 20:30:52.624349	\N	INFO
1148	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:40.362568	\N	INFO
1149	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 20:32:40.365941	\N	INFO
1150	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:40.46257	\N	INFO
1151	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 20:32:40.477444	\N	INFO
1152	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	56	\N	2025-04-21 20:32:40.522269	\N	INFO
1153	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:32:49.185+00:00"}]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:32:49.193032	\N	INFO
1154	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	8	\N	2025-04-21 20:32:49.267716	\N	INFO
1155	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:49.320131	\N	INFO
1156	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:32:49.328306	\N	INFO
1157	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:49.328203	\N	INFO
1158	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:32:52.381+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:52.38402	\N	INFO
1159	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:52.466039	\N	INFO
1160	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:52.506739	\N	INFO
1161	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 20:32:52.518269	\N	INFO
1162	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	33	\N	2025-04-21 20:32:52.547193	\N	INFO
1163	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:32:54.958+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:54.960593	\N	INFO
1164	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:55.037445	\N	INFO
1165	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:55.084777	\N	INFO
1166	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:55.090724	\N	INFO
1167	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 20:32:55.099007	\N	INFO
1168	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:32:57.622+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:57.62458	\N	INFO
1169	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:32:57.708555	\N	INFO
1170	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:32:57.752876	\N	INFO
1171	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:32:57.763716	\N	INFO
1172	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:32:57.766994	\N	INFO
1173	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:06.404417	\N	INFO
1174	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	7	\N	2025-04-21 20:33:06.408383	\N	INFO
1176	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	10	\N	2025-04-21 20:33:06.543707	\N	INFO
1175	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:06.543196	\N	INFO
1177	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:06.547962	\N	INFO
1178	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:34.023136	\N	INFO
1179	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:34.024538	\N	INFO
1180	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:34.118611	\N	INFO
1181	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:34.121864	\N	INFO
1182	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:34.124886	\N	INFO
1183	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:40.737+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:40.74067	\N	INFO
1184	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 20:33:40.821162	\N	INFO
1185	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:40.867896	\N	INFO
1186	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:40.872992	\N	INFO
1187	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:40.87173	\N	INFO
1188	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:44.302+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:44.303941	\N	INFO
1189	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:33:44.373127	\N	INFO
1192	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:44.430878	\N	INFO
1193	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:48.036742	\N	INFO
1196	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:48.155185	\N	INFO
1199	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:51.148492	\N	INFO
1202	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:51.202651	\N	INFO
1203	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:53.169+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:53.171401	\N	INFO
1204	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:53.24399	\N	INFO
1206	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:53.293352	\N	INFO
1210	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:55.36981	\N	INFO
1214	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:58.070574	\N	INFO
1216	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:58.121555	\N	INFO
1218	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:00.618+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:00.620412	\N	INFO
1222	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:00.73223	\N	INFO
1223	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:03.385+00:00"}]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:03.388344	\N	INFO
1227	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:03.501026	\N	INFO
1232	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:06.058915	\N	INFO
1234	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:09.270331	\N	INFO
1237	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:09.382455	\N	INFO
1239	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:12.130417	\N	INFO
1241	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:12.202132	\N	INFO
1243	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:14.114+00:00"}]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 20:34:14.119537	\N	INFO
1245	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:14.230231	\N	INFO
1248	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:16.947+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:16.949736	\N	INFO
1249	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:17.001884	\N	INFO
1251	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:17.052574	\N	INFO
1256	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:34:21.108572	\N	INFO
1262	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:24.092117	\N	INFO
1265	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:26.03974	\N	INFO
1269	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:27.765955	\N	INFO
1270	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:27.808145	\N	INFO
1190	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:44.424221	\N	INFO
1194	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:33:48.038181	\N	INFO
1195	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:48.151602	\N	INFO
1200	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:51.197356	\N	INFO
1205	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:53.288332	\N	INFO
1208	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:55.281+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:55.283758	\N	INFO
1212	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:33:55.37628	\N	INFO
1217	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:58.122387	\N	INFO
1219	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	6	\N	2025-04-21 20:34:00.67213	\N	INFO
1220	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:00.725908	\N	INFO
1224	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:03.453901	\N	INFO
1225	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:03.493601	\N	INFO
1230	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:06.054109	\N	INFO
1236	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:09.37899	\N	INFO
1238	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":3,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:12.104+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:12.106563	\N	INFO
1242	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:12.203821	\N	INFO
1247	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:14.234513	\N	INFO
1250	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:17.047056	\N	INFO
1254	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:20.996462	\N	INFO
1255	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:21.103436	\N	INFO
1260	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:24.087265	\N	INFO
1263	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":30,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:25.930+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:25.932749	\N	INFO
1266	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:26.044035	\N	INFO
1268	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:27.697+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:27.699065	\N	INFO
1272	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:27.811425	\N	INFO
1191	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:44.429769	\N	INFO
1197	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:48.159982	\N	INFO
1198	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":1,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:51.071+00:00"}]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:51.072987	\N	INFO
1201	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:51.201905	\N	INFO
1207	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:53.294312	\N	INFO
1209	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	4	\N	2025-04-21 20:33:55.31053	\N	INFO
1211	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:33:55.375568	\N	INFO
1213	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:33:57.995+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:57.997276	\N	INFO
1215	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:33:58.116178	\N	INFO
1221	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	0	\N	2025-04-21 20:34:00.730032	\N	INFO
1226	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:03.499291	\N	INFO
1228	Admin	\N	com.unsw.controller.OrderController.update()	[27,{"id":27,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":2,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":null,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:05.935+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:05.937614	\N	INFO
1229	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	3	\N	2025-04-21 20:34:06.00972	\N	INFO
1231	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:06.058017	\N	INFO
1233	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:09.266409	\N	INFO
1235	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	5	\N	2025-04-21 20:34:09.376026	\N	INFO
1240	anonymousUser	\N	com.unsw.controller.UserController.list()	[null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:12.198221	\N	INFO
1244	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:14.190017	\N	INFO
1246	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:14.233869	\N	INFO
1252	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:17.052574	\N	INFO
1253	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:20.995316	\N	INFO
1257	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:21.111893	\N	INFO
1258	Admin	\N	com.unsw.controller.OrderController.update()	[1,{"id":1,"orderNumber":null,"userId":null,"driverId":null,"vehicleId":null,"orderType":null,"startLocation":null,"endLocation":null,"estimatedTime":null,"fare":10,"passengerCount":null,"luggageInfo":null,"status":null,"createdAt":null,"updatedAt":"2025-04-21T10:34:23.967+00:00"}]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:23.969873	\N	INFO
1259	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:24.046194	\N	INFO
1261	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:24.091474	\N	INFO
1264	Admin	\N	com.unsw.controller.OrderController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:26.000716	\N	INFO
1267	Admin	\N	com.unsw.controller.DriverController.list()	[null,null,null,1,10]	0:0:0:0:0:0:0:1	1	\N	2025-04-21 20:34:26.043939	\N	INFO
1271	Admin	\N	com.unsw.controller.VehicleController.list()	[]	0:0:0:0:0:0:0:1	2	\N	2025-04-21 20:34:27.808149	\N	INFO
\.


--
-- Data for Name: trips; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.trips (id, order_id, driver_id, vehicle_id, start_time, end_time, distance) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, full_name, email, phone_number, password, photo, created_at, updated_at) FROM stdin;
1	test1	test1	123@qq.com	13299999991	password123		2025-04-20 14:23:14.362+10	2025-04-21 04:50:45.724+10
\.


--
-- Data for Name: vehicles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.vehicles (id, type, plate_number, gps_location, available, created_at) FROM stdin;
1	16-seater	NSW 123	\N	t	2025-04-08 10:17:56.758759
2	22-seater	NSW 125	\N	t	2025-04-10 06:28:38.774183
3	30-seater	NSW 127	\N	t	2025-04-10 06:29:10.408313
\.


--
-- Name: admin_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.admin_id_seq', 15, true);


--
-- Name: drivers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.drivers_id_seq', 2, true);


--
-- Name: feedback_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.feedback_id_seq', 1, false);


--
-- Name: gps_tracking_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.gps_tracking_id_seq', 1, false);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, false);


--
-- Name: orders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_id_seq', 1, false);


--
-- Name: promotions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.promotions_id_seq', 1, false);


--
-- Name: system_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.system_log_id_seq', 1300, true);


--
-- Name: trips_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.trips_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: vehicles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.vehicles_id_seq', 1, false);


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: admin admin_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_username_key UNIQUE (username);


--
-- Name: drivers drivers_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_phone_number_key UNIQUE (phone_number);


--
-- Name: drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (id);


--
-- Name: drivers drivers_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.drivers
    ADD CONSTRAINT drivers_username_key UNIQUE (username);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: gps_tracking gps_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gps_tracking
    ADD CONSTRAINT gps_tracking_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: orders orders_order_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_order_number_key UNIQUE (order_number);


--
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: promotions promotions_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_code_key UNIQUE (code);


--
-- Name: promotions promotions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.promotions
    ADD CONSTRAINT promotions_pkey PRIMARY KEY (id);


--
-- Name: system_log system_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.system_log
    ADD CONSTRAINT system_log_pkey PRIMARY KEY (id);


--
-- Name: trips trips_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT trips_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_phone_number_key UNIQUE (phone_number);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: vehicles vehicles_plate_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.vehicles
    ADD CONSTRAINT vehicles_plate_number_key UNIQUE (plate_number);


--
-- Name: idx_system_log_create_time; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_system_log_create_time ON public.system_log USING btree (create_time);


--
-- Name: idx_system_log_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_system_log_type ON public.system_log USING btree (type);


--
-- Name: idx_system_log_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_system_log_username ON public.system_log USING btree (username);


--
-- Name: trips fk_driver; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_driver FOREIGN KEY (driver_id) REFERENCES public.drivers(id) ON DELETE CASCADE;


--
-- Name: payments fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: trips fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: feedback fk_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT fk_order FOREIGN KEY (order_id) REFERENCES public.orders(id) ON DELETE CASCADE;


--
-- Name: trips fk_vehicle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.trips
    ADD CONSTRAINT fk_vehicle FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id) ON DELETE CASCADE;


--
-- Name: gps_tracking fk_vehicle; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.gps_tracking
    ADD CONSTRAINT fk_vehicle FOREIGN KEY (vehicle_id) REFERENCES public.vehicles(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

