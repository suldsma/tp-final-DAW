--
-- PostgreSQL database dump
--

\restrict cUfPNVg2soyKWFYbHcmI9aP1oodufrggD0lRhgDa6PMNtBhW0nmsmFp0DeUBWvk

-- Dumped from database version 16.13
-- Dumped by pg_dump version 16.13

-- Started on 2026-05-22 18:44:17

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
-- TOC entry 2 (class 3079 OID 17045)
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- TOC entry 5057 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- TOC entry 902 (class 1247 OID 18751)
-- Name: clientes_estado_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.clientes_estado_enum AS ENUM (
    'ACTIVO',
    'BAJA'
);


ALTER TYPE public.clientes_estado_enum OWNER TO postgres;

--
-- TOC entry 920 (class 1247 OID 19914)
-- Name: estado_meta; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estado_meta AS ENUM (
    'PENDIENTE',
    'COMPLETADA',
    'CANCELADA'
);


ALTER TYPE public.estado_meta OWNER TO postgres;

--
-- TOC entry 911 (class 1247 OID 19892)
-- Name: estados_clientes; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estados_clientes AS ENUM (
    'ACTIVO',
    'BAJA'
);


ALTER TYPE public.estados_clientes OWNER TO postgres;

--
-- TOC entry 914 (class 1247 OID 19898)
-- Name: estados_proyectos; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estados_proyectos AS ENUM (
    'ACTIVO',
    'FINALIZADO',
    'BAJA'
);


ALTER TYPE public.estados_proyectos OWNER TO postgres;

--
-- TOC entry 917 (class 1247 OID 19906)
-- Name: estados_tareas; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estados_tareas AS ENUM (
    'PENDIENTE',
    'FINALIZADA',
    'BAJA'
);


ALTER TYPE public.estados_tareas OWNER TO postgres;

--
-- TOC entry 908 (class 1247 OID 19886)
-- Name: estados_usuarios; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.estados_usuarios AS ENUM (
    'ACTIVO',
    'BAJA'
);


ALTER TYPE public.estados_usuarios OWNER TO postgres;

--
-- TOC entry 899 (class 1247 OID 18736)
-- Name: proyectos_estado_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.proyectos_estado_enum AS ENUM (
    'ACTIVO',
    'FINALIZADO',
    'BAJA'
);


ALTER TYPE public.proyectos_estado_enum OWNER TO postgres;

--
-- TOC entry 905 (class 1247 OID 18775)
-- Name: tareas_estado_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tareas_estado_enum AS ENUM (
    'PENDIENTE',
    'FINALIZADA',
    'BAJA'
);


ALTER TYPE public.tareas_estado_enum OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 19221)
-- Name: actualizar_fecha_actualizacion(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.actualizar_fecha_actualizacion() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.fecha_actualizacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.actualizar_fecha_actualizacion() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 18906)
-- Name: registrar_auditoria(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.registrar_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO auditorias (
        "id_usuario",
        "nombre_usuario",
        "tipo_entidad",
        "id_entidad",
        "tipo_operacion",
        "datosCambio",
        "detalles",
        "fecha_operacion"
    )
    VALUES (
        1, 
        'Sistema (Trigger)',
        TG_TABLE_NAME,
        COALESCE(NEW.id, OLD.id),
        TG_OP,
        CASE
            WHEN TG_OP = 'INSERT' THEN row_to_json(NEW)::jsonb
            WHEN TG_OP = 'DELETE' THEN row_to_json(OLD)::jsonb
            ELSE jsonb_build_object('antes', row_to_json(OLD)::jsonb, 'despues', row_to_json(NEW)::jsonb)
        END,
        'Operación automática ejecutada por la base de datos.',
        NOW()
    );

    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.registrar_auditoria() OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 18902)
-- Name: validar_baja_cliente(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_baja_cliente() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.estado = 'BAJA' AND OLD.estado <> 'BAJA' THEN
        IF EXISTS (
            SELECT 1 FROM proyectos WHERE id_cliente = NEW.id
        ) THEN
            RAISE EXCEPTION 'No se puede dar de baja un cliente que está registrado en algún proyecto.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_baja_cliente() OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 18904)
-- Name: validar_cliente_activo_en_proyecto(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_cliente_activo_en_proyecto() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.id_cliente IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM clientes
            WHERE id = NEW.id_cliente AND estado = 'ACTIVO'
        ) THEN
            RAISE EXCEPTION 'Solo se pueden asignar clientes en estado ACTIVO a los proyectos.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_cliente_activo_en_proyecto() OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 18910)
-- Name: verificar_tareas_vencidas(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.verificar_tareas_vencidas() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.estado = 'FINALIZADA' THEN
        IF NOT EXISTS (
            SELECT 1
            FROM tareas
            WHERE "idProyecto" = NEW."idProyecto" AND estado = 'PENDIENTE'
        ) THEN
            NULL;
        END IF;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.verificar_tareas_vencidas() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 231 (class 1259 OID 20066)
-- Name: auditorias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auditorias (
    id integer NOT NULL,
    tipo_entidad character varying(50) NOT NULL,
    id_entidad integer NOT NULL,
    tipo_operacion character varying(20) NOT NULL,
    id_usuario integer NOT NULL,
    nombre_usuario character varying(100) NOT NULL,
    datos_cambio jsonb,
    detalles text,
    fecha_operacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.auditorias OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 20065)
-- Name: auditorias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auditorias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auditorias_id_seq OWNER TO postgres;

--
-- TOC entry 5058 (class 0 OID 0)
-- Dependencies: 230
-- Name: auditorias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auditorias_id_seq OWNED BY public.auditorias.id;


--
-- TOC entry 219 (class 1259 OID 19937)
-- Name: clientes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    nombre character varying(120) NOT NULL,
    email character varying(120),
    telefono character varying(20),
    direccion text,
    estado public.estados_clientes DEFAULT 'ACTIVO'::public.estados_clientes NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_cliente_email CHECK (((email IS NULL) OR ((email)::text ~ '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$'::text)))
);


ALTER TABLE public.clientes OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 19936)
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO postgres;

--
-- TOC entry 5059 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- TOC entry 225 (class 1259 OID 19997)
-- Name: comentarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comentarios (
    id integer NOT NULL,
    id_tarea integer NOT NULL,
    id_usuario integer NOT NULL,
    contenido character varying(1000) NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_comentario_length CHECK ((length((contenido)::text) >= 1))
);


ALTER TABLE public.comentarios OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 19996)
-- Name: comentarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.comentarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comentarios_id_seq OWNER TO postgres;

--
-- TOC entry 5060 (class 0 OID 0)
-- Dependencies: 224
-- Name: comentarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.comentarios_id_seq OWNED BY public.comentarios.id;


--
-- TOC entry 227 (class 1259 OID 20022)
-- Name: metas_intermedias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.metas_intermedias (
    id integer NOT NULL,
    id_proyecto integer NOT NULL,
    nombre character varying(200) NOT NULL,
    descripcion text,
    fecha_objetivo date,
    estado public.estado_meta DEFAULT 'PENDIENTE'::public.estado_meta NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT ck_meta_nombre_length CHECK ((length((nombre)::text) >= 3))
);


ALTER TABLE public.metas_intermedias OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 20021)
-- Name: metas_intermedias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.metas_intermedias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.metas_intermedias_id_seq OWNER TO postgres;

--
-- TOC entry 5061 (class 0 OID 0)
-- Dependencies: 226
-- Name: metas_intermedias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.metas_intermedias_id_seq OWNED BY public.metas_intermedias.id;


--
-- TOC entry 221 (class 1259 OID 19955)
-- Name: proyectos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proyectos (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    estado public.estados_proyectos DEFAULT 'ACTIVO'::public.estados_proyectos NOT NULL,
    id_cliente integer,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_finalizacion_objetivo date,
    fecha_finalizacion_real date,
    CONSTRAINT ck_proyecto_fechas CHECK (((fecha_finalizacion_real IS NULL) OR (fecha_finalizacion_real >= (fecha_creacion)::date))),
    CONSTRAINT ck_proyecto_nombre_length CHECK ((length((nombre)::text) >= 3))
);


ALTER TABLE public.proyectos OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 19954)
-- Name: proyectos_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proyectos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proyectos_id_seq OWNER TO postgres;

--
-- TOC entry 5062 (class 0 OID 0)
-- Dependencies: 220
-- Name: proyectos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proyectos_id_seq OWNED BY public.proyectos.id;


--
-- TOC entry 229 (class 1259 OID 20044)
-- Name: tarea_meta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarea_meta (
    id integer NOT NULL,
    id_tarea integer NOT NULL,
    id_meta integer NOT NULL,
    fecha_asignacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.tarea_meta OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 20043)
-- Name: tarea_meta_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarea_meta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarea_meta_id_seq OWNER TO postgres;

--
-- TOC entry 5063 (class 0 OID 0)
-- Dependencies: 228
-- Name: tarea_meta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarea_meta_id_seq OWNED BY public.tarea_meta.id;


--
-- TOC entry 223 (class 1259 OID 19977)
-- Name: tareas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tareas (
    id integer NOT NULL,
    descripcion character varying(500) NOT NULL,
    estado public.estados_tareas DEFAULT 'PENDIENTE'::public.estados_tareas NOT NULL,
    id_proyecto integer NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_actualizacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_finalizacion date,
    CONSTRAINT ck_tarea_descripcion_length CHECK ((length((descripcion)::text) >= 3))
);


ALTER TABLE public.tareas OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 19976)
-- Name: tareas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tareas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tareas_id_seq OWNER TO postgres;

--
-- TOC entry 5064 (class 0 OID 0)
-- Dependencies: 222
-- Name: tareas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tareas_id_seq OWNED BY public.tareas.id;


--
-- TOC entry 217 (class 1259 OID 19922)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    clave text NOT NULL,
    estado public.estados_usuarios DEFAULT 'ACTIVO'::public.estados_usuarios NOT NULL,
    fecha_creacion timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_ultimo_acceso timestamp without time zone,
    rol character varying(50) DEFAULT 'USER'::character varying,
    CONSTRAINT ck_usuario_nombre_length CHECK ((length((nombre)::text) >= 3))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 19921)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 216
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 233 (class 1259 OID 20095)
-- Name: v_progreso_proyectos; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_progreso_proyectos AS
SELECT
    NULL::integer AS id,
    NULL::character varying(150) AS nombre,
    NULL::public.estados_proyectos AS estado,
    NULL::bigint AS total_tareas,
    NULL::bigint AS tareas_completadas,
    NULL::numeric AS porcentaje_completado;


ALTER VIEW public.v_progreso_proyectos OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 20090)
-- Name: v_proyectos_retrasados; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_proyectos_retrasados AS
SELECT
    NULL::integer AS id,
    NULL::character varying(150) AS nombre,
    NULL::public.estados_proyectos AS estado,
    NULL::character varying(120) AS cliente_nombre,
    NULL::date AS fecha_finalizacion_objetivo,
    NULL::integer AS dias_retraso,
    NULL::bigint AS total_tareas,
    NULL::bigint AS tareas_completadas;


ALTER VIEW public.v_proyectos_retrasados OWNER TO postgres;

--
-- TOC entry 4822 (class 2604 OID 20069)
-- Name: auditorias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditorias ALTER COLUMN id SET DEFAULT nextval('public.auditorias_id_seq'::regclass);


--
-- TOC entry 4801 (class 2604 OID 19940)
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 20000)
-- Name: comentarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios ALTER COLUMN id SET DEFAULT nextval('public.comentarios_id_seq'::regclass);


--
-- TOC entry 4816 (class 2604 OID 20025)
-- Name: metas_intermedias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metas_intermedias ALTER COLUMN id SET DEFAULT nextval('public.metas_intermedias_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 19958)
-- Name: proyectos id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos ALTER COLUMN id SET DEFAULT nextval('public.proyectos_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 20047)
-- Name: tarea_meta id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarea_meta ALTER COLUMN id SET DEFAULT nextval('public.tarea_meta_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 19980)
-- Name: tareas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas ALTER COLUMN id SET DEFAULT nextval('public.tareas_id_seq'::regclass);


--
-- TOC entry 4797 (class 2604 OID 19925)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 5051 (class 0 OID 20066)
-- Dependencies: 231
-- Data for Name: auditorias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auditorias (id, tipo_entidad, id_entidad, tipo_operacion, id_usuario, nombre_usuario, datos_cambio, detalles, fecha_operacion) FROM stdin;
\.


--
-- TOC entry 5039 (class 0 OID 19937)
-- Dependencies: 219
-- Data for Name: clientes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.clientes (id, nombre, email, telefono, direccion, estado, fecha_creacion, fecha_actualizacion) FROM stdin;
1	Tech Solutions SRL	contact@techsolutions.com	+54-11-1234-5678	\N	ACTIVO	2026-05-21 21:09:55.817063	2026-05-21 21:09:55.817063
2	Innovasoft SA	info@innovasoft.com	+54-11-9876-5432	\N	ACTIVO	2026-05-21 21:09:55.817063	2026-05-21 21:09:55.817063
3	Comercial	\N	\N	\N	ACTIVO	2026-05-22 00:16:34.880369	2026-05-22 00:16:34.880369
4	Industrial	\N	\N	\N	ACTIVO	2026-05-22 00:17:09.744606	2026-05-22 00:17:32.020073
5	CEIA	\N	\N	\N	ACTIVO	2026-05-22 00:49:13.761112	2026-05-22 00:49:13.761112
6	Empresa Alfa	\N	\N	\N	ACTIVO	2026-05-22 00:50:22.871537	2026-05-22 00:50:22.871537
7	Prueba Integración Total	\N	\N	\N	ACTIVO	2026-05-22 00:58:55.488809	2026-05-22 00:58:55.488809
8	Constructora del Litoral S.A.	\N	\N	\N	ACTIVO	2026-05-22 15:31:46.576847	2026-05-22 15:31:46.576847
\.


--
-- TOC entry 5045 (class 0 OID 19997)
-- Dependencies: 225
-- Data for Name: comentarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comentarios (id, id_tarea, id_usuario, contenido, fecha_creacion, fecha_actualizacion) FROM stdin;
\.


--
-- TOC entry 5047 (class 0 OID 20022)
-- Dependencies: 227
-- Data for Name: metas_intermedias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.metas_intermedias (id, id_proyecto, nombre, descripcion, fecha_objetivo, estado, fecha_creacion, fecha_actualizacion) FROM stdin;
\.


--
-- TOC entry 5041 (class 0 OID 19955)
-- Dependencies: 221
-- Data for Name: proyectos; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proyectos (id, nombre, estado, id_cliente, fecha_creacion, fecha_actualizacion, fecha_finalizacion_objetivo, fecha_finalizacion_real) FROM stdin;
1	gestion	FINALIZADO	\N	2026-05-22 00:33:07.081793	2026-05-22 00:35:32.143026	\N	\N
2	Sistema de Control de Stock	ACTIVO	\N	2026-05-22 00:51:14.439952	2026-05-22 00:51:14.439952	\N	\N
3	Proyecto de Prueba	ACTIVO	7	2026-05-22 00:59:37.010201	2026-05-22 01:00:43.903553	\N	\N
4	pdf	ACTIVO	8	2026-05-22 15:33:56.466148	2026-05-22 15:33:56.466148	\N	\N
\.


--
-- TOC entry 5049 (class 0 OID 20044)
-- Dependencies: 229
-- Data for Name: tarea_meta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tarea_meta (id, id_tarea, id_meta, fecha_asignacion) FROM stdin;
\.


--
-- TOC entry 5043 (class 0 OID 19977)
-- Dependencies: 223
-- Data for Name: tareas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tareas (id, descripcion, estado, id_proyecto, fecha_creacion, fecha_actualizacion, fecha_finalizacion) FROM stdin;
1	susana	BAJA	1	2026-05-22 00:40:20.583626	2026-05-22 00:40:38.271698	\N
2	sssss	FINALIZADA	1	2026-05-22 00:40:49.21381	2026-05-22 00:40:58.075504	\N
3	Diseñar la base de datos de productos	PENDIENTE	1	2026-05-22 00:51:50.566412	2026-05-22 00:51:50.566412	\N
4	Tarea de Verificación	PENDIENTE	3	2026-05-22 01:01:12.763951	2026-05-22 01:01:12.763951	\N
5	Diseño de planos iniciales	PENDIENTE	4	2026-05-22 15:35:43.108478	2026-05-22 15:37:25.682646	\N
\.


--
-- TOC entry 5037 (class 0 OID 19922)
-- Dependencies: 217
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuarios (id, nombre, clave, estado, fecha_creacion, fecha_ultimo_acceso, rol) FROM stdin;
1	usuario	$2a$10$h0nXVHF1KJek4B4ybI9B.eke1v0PMY6le3KHUcf9XVmBmfWqZhU3m	ACTIVO	2026-05-21 21:09:55.817063	\N	ADMIN
\.


--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 230
-- Name: auditorias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auditorias_id_seq', 1, false);


--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 218
-- Name: clientes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.clientes_id_seq', 8, true);


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 224
-- Name: comentarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.comentarios_id_seq', 1, false);


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 226
-- Name: metas_intermedias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.metas_intermedias_id_seq', 1, false);


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 220
-- Name: proyectos_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proyectos_id_seq', 4, true);


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 228
-- Name: tarea_meta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tarea_meta_id_seq', 1, false);


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 222
-- Name: tareas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tareas_id_seq', 5, true);


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 216
-- Name: usuarios_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuarios_id_seq', 1, true);


--
-- TOC entry 4872 (class 2606 OID 20074)
-- Name: auditorias auditorias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditorias
    ADD CONSTRAINT auditorias_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 19950)
-- Name: clientes clientes_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_nombre_key UNIQUE (nombre);


--
-- TOC entry 4839 (class 2606 OID 19948)
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- TOC entry 4855 (class 2606 OID 20007)
-- Name: comentarios comentarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4862 (class 2606 OID 20033)
-- Name: metas_intermedias metas_intermedias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metas_intermedias
    ADD CONSTRAINT metas_intermedias_pkey PRIMARY KEY (id);


--
-- TOC entry 4847 (class 2606 OID 19967)
-- Name: proyectos proyectos_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_nombre_key UNIQUE (nombre);


--
-- TOC entry 4849 (class 2606 OID 19965)
-- Name: proyectos proyectos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT proyectos_pkey PRIMARY KEY (id);


--
-- TOC entry 4868 (class 2606 OID 20050)
-- Name: tarea_meta tarea_meta_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarea_meta
    ADD CONSTRAINT tarea_meta_pkey PRIMARY KEY (id);


--
-- TOC entry 4853 (class 2606 OID 19988)
-- Name: tareas tareas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT tareas_pkey PRIMARY KEY (id);


--
-- TOC entry 4864 (class 2606 OID 20035)
-- Name: metas_intermedias uk_meta_nombre_proyecto; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metas_intermedias
    ADD CONSTRAINT uk_meta_nombre_proyecto UNIQUE (id_proyecto, nombre);


--
-- TOC entry 4870 (class 2606 OID 20052)
-- Name: tarea_meta uk_tarea_meta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarea_meta
    ADD CONSTRAINT uk_tarea_meta UNIQUE (id_tarea, id_meta);


--
-- TOC entry 4833 (class 2606 OID 19934)
-- Name: usuarios usuarios_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_nombre_key UNIQUE (nombre);


--
-- TOC entry 4835 (class 2606 OID 19932)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4873 (class 1259 OID 20080)
-- Name: idx_auditoria_entidad; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_entidad ON public.auditorias USING btree (tipo_entidad, id_entidad);


--
-- TOC entry 4874 (class 1259 OID 20082)
-- Name: idx_auditoria_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_fecha ON public.auditorias USING btree (fecha_operacion);


--
-- TOC entry 4875 (class 1259 OID 20081)
-- Name: idx_auditoria_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_auditoria_usuario ON public.auditorias USING btree (id_usuario);


--
-- TOC entry 4840 (class 1259 OID 19951)
-- Name: idx_cliente_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX idx_cliente_email ON public.clientes USING btree (email) WHERE (email IS NOT NULL);


--
-- TOC entry 4841 (class 1259 OID 19953)
-- Name: idx_cliente_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cliente_estado ON public.clientes USING btree (estado);


--
-- TOC entry 4842 (class 1259 OID 19952)
-- Name: idx_cliente_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_cliente_nombre ON public.clientes USING btree (nombre);


--
-- TOC entry 4856 (class 1259 OID 20020)
-- Name: idx_comentario_fecha; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comentario_fecha ON public.comentarios USING btree (fecha_creacion);


--
-- TOC entry 4857 (class 1259 OID 20018)
-- Name: idx_comentario_tarea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comentario_tarea ON public.comentarios USING btree (id_tarea);


--
-- TOC entry 4858 (class 1259 OID 20019)
-- Name: idx_comentario_usuario; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_comentario_usuario ON public.comentarios USING btree (id_usuario);


--
-- TOC entry 4859 (class 1259 OID 20042)
-- Name: idx_meta_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meta_estado ON public.metas_intermedias USING btree (estado);


--
-- TOC entry 4860 (class 1259 OID 20041)
-- Name: idx_meta_proyecto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_meta_proyecto ON public.metas_intermedias USING btree (id_proyecto);


--
-- TOC entry 4843 (class 1259 OID 19973)
-- Name: idx_proyecto_cliente; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proyecto_cliente ON public.proyectos USING btree (id_cliente);


--
-- TOC entry 4844 (class 1259 OID 19974)
-- Name: idx_proyecto_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proyecto_estado ON public.proyectos USING btree (estado);


--
-- TOC entry 4845 (class 1259 OID 19975)
-- Name: idx_proyecto_fecha_objetivo; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_proyecto_fecha_objetivo ON public.proyectos USING btree (fecha_finalizacion_objetivo);


--
-- TOC entry 4850 (class 1259 OID 19995)
-- Name: idx_tarea_estado; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tarea_estado ON public.tareas USING btree (estado);


--
-- TOC entry 4865 (class 1259 OID 20064)
-- Name: idx_tarea_meta_meta; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tarea_meta_meta ON public.tarea_meta USING btree (id_meta);


--
-- TOC entry 4866 (class 1259 OID 20063)
-- Name: idx_tarea_meta_tarea; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tarea_meta_tarea ON public.tarea_meta USING btree (id_tarea);


--
-- TOC entry 4851 (class 1259 OID 19994)
-- Name: idx_tarea_proyecto; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tarea_proyecto ON public.tareas USING btree (id_proyecto);


--
-- TOC entry 4831 (class 1259 OID 19935)
-- Name: idx_usuario_nombre; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_usuario_nombre ON public.usuarios USING btree (nombre);


--
-- TOC entry 5035 (class 2618 OID 20098)
-- Name: v_progreso_proyectos _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.v_progreso_proyectos AS
 SELECT p.id,
    p.nombre,
    p.estado,
    count(t.id) AS total_tareas,
    sum(
        CASE
            WHEN (t.estado = 'FINALIZADA'::public.estados_tareas) THEN 1
            ELSE 0
        END) AS tareas_completadas,
        CASE
            WHEN (count(t.id) = 0) THEN (0)::numeric
            ELSE round(((100.0 * (sum(
            CASE
                WHEN (t.estado = 'FINALIZADA'::public.estados_tareas) THEN 1
                ELSE 0
            END))::numeric) / (count(t.id))::numeric), 2)
        END AS porcentaje_completado
   FROM (public.proyectos p
     LEFT JOIN public.tareas t ON (((p.id = t.id_proyecto) AND (t.estado <> 'BAJA'::public.estados_tareas))))
  GROUP BY p.id;


--
-- TOC entry 5034 (class 2618 OID 20093)
-- Name: v_proyectos_retrasados _RETURN; Type: RULE; Schema: public; Owner: postgres
--

CREATE OR REPLACE VIEW public.v_proyectos_retrasados AS
 SELECT p.id,
    p.nombre,
    p.estado,
    c.nombre AS cliente_nombre,
    p.fecha_finalizacion_objetivo,
    (CURRENT_DATE - p.fecha_finalizacion_objetivo) AS dias_retraso,
    count(t.id) AS total_tareas,
    sum(
        CASE
            WHEN (t.estado = 'FINALIZADA'::public.estados_tareas) THEN 1
            ELSE 0
        END) AS tareas_completadas
   FROM ((public.proyectos p
     LEFT JOIN public.clientes c ON ((p.id_cliente = c.id)))
     LEFT JOIN public.tareas t ON ((p.id = t.id_proyecto)))
  WHERE ((p.estado = 'ACTIVO'::public.estados_proyectos) AND (p.fecha_finalizacion_objetivo < CURRENT_DATE))
  GROUP BY p.id, c.id;


--
-- TOC entry 4884 (class 2620 OID 20085)
-- Name: clientes trigger_actualizar_clientes; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_clientes BEFORE UPDATE ON public.clientes FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_actualizacion();


--
-- TOC entry 4889 (class 2620 OID 20088)
-- Name: comentarios trigger_actualizar_comentarios; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_comentarios BEFORE UPDATE ON public.comentarios FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_actualizacion();


--
-- TOC entry 4890 (class 2620 OID 20089)
-- Name: metas_intermedias trigger_actualizar_metas; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_metas BEFORE UPDATE ON public.metas_intermedias FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_actualizacion();


--
-- TOC entry 4886 (class 2620 OID 20086)
-- Name: proyectos trigger_actualizar_proyectos; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_proyectos BEFORE UPDATE ON public.proyectos FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_actualizacion();


--
-- TOC entry 4888 (class 2620 OID 20087)
-- Name: tareas trigger_actualizar_tareas; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_actualizar_tareas BEFORE UPDATE ON public.tareas FOR EACH ROW EXECUTE FUNCTION public.actualizar_fecha_actualizacion();


--
-- TOC entry 4885 (class 2620 OID 20083)
-- Name: clientes trigger_validar_baja_cliente; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_validar_baja_cliente BEFORE UPDATE ON public.clientes FOR EACH ROW WHEN ((new.estado IS DISTINCT FROM old.estado)) EXECUTE FUNCTION public.validar_baja_cliente();


--
-- TOC entry 4887 (class 2620 OID 20084)
-- Name: proyectos trigger_validar_cliente_activo_proyecto; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_validar_cliente_activo_proyecto BEFORE INSERT OR UPDATE ON public.proyectos FOR EACH ROW EXECUTE FUNCTION public.validar_cliente_activo_en_proyecto();


--
-- TOC entry 4883 (class 2606 OID 20075)
-- Name: auditorias fk_auditoria_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auditorias
    ADD CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4878 (class 2606 OID 20008)
-- Name: comentarios fk_comentario_tarea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT fk_comentario_tarea FOREIGN KEY (id_tarea) REFERENCES public.tareas(id) ON DELETE CASCADE;


--
-- TOC entry 4879 (class 2606 OID 20013)
-- Name: comentarios fk_comentario_usuario; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT fk_comentario_usuario FOREIGN KEY (id_usuario) REFERENCES public.usuarios(id);


--
-- TOC entry 4880 (class 2606 OID 20036)
-- Name: metas_intermedias fk_meta_proyecto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.metas_intermedias
    ADD CONSTRAINT fk_meta_proyecto FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id) ON DELETE CASCADE;


--
-- TOC entry 4876 (class 2606 OID 19968)
-- Name: proyectos fk_proyectos_cliente; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proyectos
    ADD CONSTRAINT fk_proyectos_cliente FOREIGN KEY (id_cliente) REFERENCES public.clientes(id) ON DELETE SET NULL;


--
-- TOC entry 4881 (class 2606 OID 20058)
-- Name: tarea_meta fk_tarea_meta_meta; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarea_meta
    ADD CONSTRAINT fk_tarea_meta_meta FOREIGN KEY (id_meta) REFERENCES public.metas_intermedias(id) ON DELETE CASCADE;


--
-- TOC entry 4882 (class 2606 OID 20053)
-- Name: tarea_meta fk_tarea_meta_tarea; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarea_meta
    ADD CONSTRAINT fk_tarea_meta_tarea FOREIGN KEY (id_tarea) REFERENCES public.tareas(id) ON DELETE CASCADE;


--
-- TOC entry 4877 (class 2606 OID 19989)
-- Name: tareas fk_tareas_proyecto; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tareas
    ADD CONSTRAINT fk_tareas_proyecto FOREIGN KEY (id_proyecto) REFERENCES public.proyectos(id) ON DELETE CASCADE;


-- Completed on 2026-05-22 18:44:18

--
-- PostgreSQL database dump complete
--

\unrestrict cUfPNVg2soyKWFYbHcmI9aP1oodufrggD0lRhgDa6PMNtBhW0nmsmFp0DeUBWvk

