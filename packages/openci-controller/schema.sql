--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9
-- Dumped by pg_dump version 16.9
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
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: openci_user
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN NEW.updated_at = NOW();
RETURN NEW;
END;
$$;
ALTER FUNCTION public.update_updated_at_column() OWNER TO openci_user;
SET default_tablespace = '';
SET default_table_access_method = heap;
--
-- Name: _sqlx_migrations; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public._sqlx_migrations (
    version bigint NOT NULL,
    description text NOT NULL,
    installed_on timestamp with time zone DEFAULT now() NOT NULL,
    success boolean NOT NULL,
    checksum bytea NOT NULL,
    execution_time bigint NOT NULL
);
ALTER TABLE public._sqlx_migrations OWNER TO openci_user;
--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.api_keys (
    id integer NOT NULL,
    user_id integer NOT NULL,
    name character varying(255) NOT NULL,
    hashed_key character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone,
    prefix character varying(8) NOT NULL
);
ALTER TABLE public.api_keys OWNER TO openci_user;
--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.api_keys_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.api_keys_id_seq OWNER TO openci_user;
--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.api_keys_id_seq OWNED BY public.api_keys.id;
--
-- Name: build_jobs; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.build_jobs (
    id integer NOT NULL,
    workflow_id integer NOT NULL,
    repository_id integer NOT NULL,
    build_status character varying(50) DEFAULT 'queued'::character varying NOT NULL,
    commit_sha character varying(40) NOT NULL,
    build_branch character varying(255) NOT NULL,
    base_branch character varying(255) NOT NULL,
    commit_message text,
    commit_author_name character varying(255),
    commit_author_email character varying(255),
    pr_number integer,
    pr_title text,
    github_check_run_id bigint NOT NULL,
    github_app_id integer NOT NULL,
    github_installation_id bigint NOT NULL,
    started_at timestamp with time zone,
    finished_at timestamp with time zone,
    worker_id character varying(255),
    exit_code integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT build_jobs_build_status_check CHECK (
        (
            (build_status)::text = ANY (
                (
                    ARRAY ['queued'::character varying, 'inProgress'::character varying, 'failure'::character varying, 'success'::character varying, 'cancelled'::character varying]
                )::text []
            )
        )
    )
);
ALTER TABLE public.build_jobs OWNER TO openci_user;
--
-- Name: build_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.build_jobs_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.build_jobs_id_seq OWNER TO openci_user;
--
-- Name: build_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.build_jobs_id_seq OWNED BY public.build_jobs.id;
--
-- Name: command_logs; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.command_logs (
    id integer NOT NULL,
    build_job_id integer NOT NULL,
    command text NOT NULL,
    log_stdout text DEFAULT ''::text NOT NULL,
    log_stderr text DEFAULT ''::text NOT NULL,
    exit_code integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.command_logs OWNER TO openci_user;
--
-- Name: command_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.command_logs_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.command_logs_id_seq OWNER TO openci_user;
--
-- Name: command_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.command_logs_id_seq OWNED BY public.command_logs.id;
--
-- Name: github_events; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.github_events (
    id integer NOT NULL,
    repository_id integer,
    event_type character varying(50) NOT NULL,
    action character varying(50),
    delivery_id character varying(255) NOT NULL,
    payload jsonb NOT NULL,
    processed boolean DEFAULT false NOT NULL,
    build_job_id integer,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.github_events OWNER TO openci_user;
--
-- Name: github_events_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.github_events_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.github_events_id_seq OWNER TO openci_user;
--
-- Name: github_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.github_events_id_seq OWNED BY public.github_events.id;
--
-- Name: repositories; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.repositories (
    id integer NOT NULL,
    user_id integer NOT NULL,
    github_id bigint NOT NULL,
    full_name character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    owner character varying(255) NOT NULL,
    node_id character varying(255),
    private boolean DEFAULT false NOT NULL,
    default_branch character varying(255) DEFAULT 'main'::character varying NOT NULL,
    webhook_secret character varying(255),
    installation_id bigint,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.repositories OWNER TO openci_user;
--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.repositories_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.repositories_id_seq OWNER TO openci_user;
--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.repositories_id_seq OWNED BY public.repositories.id;
--
-- Name: secrets; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.secrets (
    id integer NOT NULL,
    key character varying(255) NOT NULL,
    encrypted_value text NOT NULL,
    owners jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);
ALTER TABLE public.secrets OWNER TO openci_user;
--
-- Name: secrets_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.secrets_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.secrets_id_seq OWNER TO openci_user;
--
-- Name: secrets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.secrets_id_seq OWNED BY public.secrets.id;
--
-- Name: users; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    role character varying(50) DEFAULT 'member'::character varying NOT NULL,
    CONSTRAINT users_role_check CHECK (
        (
            (role)::text = ANY (
                (
                    ARRAY ['admin'::character varying, 'member'::character varying]
                )::text []
            )
        )
    )
);
ALTER TABLE public.users OWNER TO openci_user;
--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.users_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.users_id_seq OWNER TO openci_user;
--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
--
-- Name: workflows; Type: TABLE; Schema: public; Owner: openci_user
--

CREATE TABLE public.workflows (
    id integer NOT NULL,
    repository_id integer NOT NULL,
    name character varying(255) NOT NULL,
    current_working_directory character varying(255) DEFAULT ''::character varying NOT NULL,
    flutter_config jsonb NOT NULL,
    trigger_type character varying(50) NOT NULL,
    base_branch character varying(255) DEFAULT 'main'::character varying NOT NULL,
    owners jsonb NOT NULL,
    steps jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT workflows_trigger_type_check CHECK (
        (
            (trigger_type)::text = ANY (
                (
                    ARRAY ['push'::character varying, 'pullRequest'::character varying]
                )::text []
            )
        )
    )
);
ALTER TABLE public.workflows OWNER TO openci_user;
--
-- Name: workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: openci_user
--

CREATE SEQUENCE public.workflows_id_seq AS integer START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1;
ALTER SEQUENCE public.workflows_id_seq OWNER TO openci_user;
--
-- Name: workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: openci_user
--

ALTER SEQUENCE public.workflows_id_seq OWNED BY public.workflows.id;
--
-- Name: api_keys id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.api_keys
ALTER COLUMN id
SET DEFAULT nextval('public.api_keys_id_seq'::regclass);
--
-- Name: build_jobs id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.build_jobs
ALTER COLUMN id
SET DEFAULT nextval('public.build_jobs_id_seq'::regclass);
--
-- Name: command_logs id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.command_logs
ALTER COLUMN id
SET DEFAULT nextval('public.command_logs_id_seq'::regclass);
--
-- Name: github_events id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.github_events
ALTER COLUMN id
SET DEFAULT nextval('public.github_events_id_seq'::regclass);
--
-- Name: repositories id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.repositories
ALTER COLUMN id
SET DEFAULT nextval('public.repositories_id_seq'::regclass);
--
-- Name: secrets id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.secrets
ALTER COLUMN id
SET DEFAULT nextval('public.secrets_id_seq'::regclass);
--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.users
ALTER COLUMN id
SET DEFAULT nextval('public.users_id_seq'::regclass);
--
-- Name: workflows id; Type: DEFAULT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.workflows
ALTER COLUMN id
SET DEFAULT nextval('public.workflows_id_seq'::regclass);
--
-- Name: _sqlx_migrations _sqlx_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public._sqlx_migrations
ADD CONSTRAINT _sqlx_migrations_pkey PRIMARY KEY (version);
--
-- Name: api_keys api_keys_hashed_key_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.api_keys
ADD CONSTRAINT api_keys_hashed_key_key UNIQUE (hashed_key);
--
-- Name: api_keys api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.api_keys
ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);
--
-- Name: api_keys api_keys_prefix_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.api_keys
ADD CONSTRAINT api_keys_prefix_key UNIQUE (prefix);
--
-- Name: build_jobs build_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.build_jobs
ADD CONSTRAINT build_jobs_pkey PRIMARY KEY (id);
--
-- Name: command_logs command_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.command_logs
ADD CONSTRAINT command_logs_pkey PRIMARY KEY (id);
--
-- Name: github_events github_events_delivery_id_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.github_events
ADD CONSTRAINT github_events_delivery_id_key UNIQUE (delivery_id);
--
-- Name: github_events github_events_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.github_events
ADD CONSTRAINT github_events_pkey PRIMARY KEY (id);
--
-- Name: repositories repositories_full_name_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.repositories
ADD CONSTRAINT repositories_full_name_key UNIQUE (full_name);
--
-- Name: repositories repositories_github_id_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.repositories
ADD CONSTRAINT repositories_github_id_key UNIQUE (github_id);
--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.repositories
ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);
--
-- Name: secrets secrets_key_owners_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.secrets
ADD CONSTRAINT secrets_key_owners_key UNIQUE (key, owners);
--
-- Name: secrets secrets_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.secrets
ADD CONSTRAINT secrets_pkey PRIMARY KEY (id);
--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.users
ADD CONSTRAINT users_email_key UNIQUE (email);
--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.users
ADD CONSTRAINT users_pkey PRIMARY KEY (id);
--
-- Name: workflows workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.workflows
ADD CONSTRAINT workflows_pkey PRIMARY KEY (id);
--
-- Name: idx_api_keys_prefix; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_api_keys_prefix ON public.api_keys USING btree (prefix);
--
-- Name: idx_api_keys_user_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_api_keys_user_id ON public.api_keys USING btree (user_id);
--
-- Name: idx_build_jobs_build_status; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_build_jobs_build_status ON public.build_jobs USING btree (build_status);
--
-- Name: idx_build_jobs_repository_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_build_jobs_repository_id ON public.build_jobs USING btree (repository_id);
--
-- Name: idx_build_jobs_workflow_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_build_jobs_workflow_id ON public.build_jobs USING btree (workflow_id);
--
-- Name: idx_command_logs_build_job_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_command_logs_build_job_id ON public.command_logs USING btree (build_job_id);
--
-- Name: idx_github_events_processed; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_github_events_processed ON public.github_events USING btree (processed);
--
-- Name: idx_repositories_user_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_repositories_user_id ON public.repositories USING btree (user_id);
--
-- Name: idx_workflows_repository_id; Type: INDEX; Schema: public; Owner: openci_user
--

CREATE INDEX idx_workflows_repository_id ON public.workflows USING btree (repository_id);
--
-- Name: repositories update_repositories_updated_at; Type: TRIGGER; Schema: public; Owner: openci_user
--

CREATE TRIGGER update_repositories_updated_at BEFORE
UPDATE ON public.repositories FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
--
-- Name: secrets update_secrets_updated_at; Type: TRIGGER; Schema: public; Owner: openci_user
--

CREATE TRIGGER update_secrets_updated_at BEFORE
UPDATE ON public.secrets FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
--
-- Name: workflows update_workflows_updated_at; Type: TRIGGER; Schema: public; Owner: openci_user
--

CREATE TRIGGER update_workflows_updated_at BEFORE
UPDATE ON public.workflows FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();
--
-- Name: api_keys api_keys_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.api_keys
ADD CONSTRAINT api_keys_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
--
-- Name: build_jobs build_jobs_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.build_jobs
ADD CONSTRAINT build_jobs_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.repositories(id) ON DELETE CASCADE;
--
-- Name: build_jobs build_jobs_workflow_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.build_jobs
ADD CONSTRAINT build_jobs_workflow_id_fkey FOREIGN KEY (workflow_id) REFERENCES public.workflows(id);
--
-- Name: command_logs command_logs_build_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.command_logs
ADD CONSTRAINT command_logs_build_job_id_fkey FOREIGN KEY (build_job_id) REFERENCES public.build_jobs(id) ON DELETE CASCADE;
--
-- Name: github_events github_events_build_job_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.github_events
ADD CONSTRAINT github_events_build_job_id_fkey FOREIGN KEY (build_job_id) REFERENCES public.build_jobs(id);
--
-- Name: github_events github_events_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.github_events
ADD CONSTRAINT github_events_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.repositories(id) ON DELETE CASCADE;
--
-- Name: repositories repositories_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.repositories
ADD CONSTRAINT repositories_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;
--
-- Name: workflows workflows_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: openci_user
--

ALTER TABLE ONLY public.workflows
ADD CONSTRAINT workflows_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.repositories(id) ON DELETE CASCADE;
--
-- PostgreSQL database dump complete
--