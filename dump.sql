--
-- PostgreSQL database dump
--

-- Dumped from database version 12.14 (Ubuntu 12.14-1.pgdg20.04+1)
-- Dumped by pg_dump version 12.14 (Ubuntu 12.14-1.pgdg20.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sessions (
    id integer NOT NULL,
    token text NOT NULL,
    active boolean DEFAULT true NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sessions_id_seq OWNED BY public.sessions.id;


--
-- Name: shortens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.shortens (
    id integer NOT NULL,
    url text NOT NULL,
    "shortUrl" text NOT NULL,
    "userId" integer NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL,
    views integer DEFAULT 0 NOT NULL
);


--
-- Name: shortens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.shortens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: shortens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.shortens_id_seq OWNED BY public.shortens.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    name text NOT NULL,
    "createdAt" timestamp without time zone DEFAULT now() NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions ALTER COLUMN id SET DEFAULT nextval('public.sessions_id_seq'::regclass);


--
-- Name: shortens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shortens ALTER COLUMN id SET DEFAULT nextval('public.shortens_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.sessions VALUES (1, '128549a8-92ab-4f45-ac39-9c3cff0c62b8', true, 1, '2023-03-03 17:07:01.178065');


--
-- Data for Name: shortens; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.shortens VALUES (1, 'class URL {
  constructor(input, base = undefined) {
    // toUSVString is not needed.
    input = `${input}`;
    let base_context;
    if (base !== undefined) {
      base_context = new URL(base)[context];
    }
    this[context] = new URLContext();
    parse(input, -1, base_context, undefined,
          FunctionPrototypeBind(onParseComplete, this),
          FunctionPrototypeBind(onParseError, this, input));
  }

  get [special]() {
    return (this[context].flags & URL_FLAGS_SPECIAL) !== 0;
  }

  get [cannotBeBase]() {
    return (this[context].flags & URL_FLAGS_CANNOT_BE_BASE) !== 0;
  }

  // https://url.spec.whatwg.org/#cannot-have-a-username-password-port
  get [cannotHaveUsernamePasswordPort]() {
    const { host, scheme } = this[context];
    return ((host == null || host === '''') ||
            this[cannotBeBase] ||
            scheme === ''file:'');
  }

  [inspect.custom](depth, opts) {
    if (this == null ||
        ObjectGetPrototypeOf(this[context]) !== URLContext.prototype) {
      throw new ERR_INVALID_THIS(''URL'');
    }

    if (typeof depth === ''number'' && depth < 0)
      return this;

    const constructor = getConstructorOf(this) || URL;
    const obj = ObjectCreate({ constructor });

    obj.href = this.href;
    obj.origin = this.origin;
    obj.protocol = this.protocol;
    obj.username = this.username;
    obj.password = this.password;
    obj.host = this.host;
    obj.hostname = this.hostname;
    obj.port = this.port;
    obj.pathname = this.pathname;
    obj.search = this.search;
    obj.searchParams = this.searchParams;
    obj.hash = this.hash;

    if (opts.showHidden) {
      obj.cannotBeBase = this[cannotBeBase];
      obj.special = this[special];
      obj[context] = this[context];
    }

    return `${constructor.name} ${inspect(obj, opts)}`;
  }

  [kFormat](options) {
    if (options)
      validateObject(options, ''options'');

    options = {
      fragment: true,
      unicode: false,
      search: true,
      auth: true,
      ...options
    };
    const ctx = this[context];
    // https://url.spec.whatwg.org/#url-serializing
    let ret = ctx.scheme;
    if (ctx.host !== null) {
      ret += ''//'';
      const has_username = ctx.username !== '''';
      const has_password = ctx.password !== '''';
      if (options.auth && (has_username || has_password)) {
        if (has_username)
          ret += ctx.username;
        if (has_password)
          ret += `:${ctx.password}`;
        ret += ''@'';
      }
      ret += options.unicode ?
        domainToUnicode(ctx.host) : ctx.host;
      if (ctx.port !== null)
        ret += `:${ctx.port}`;
    }
    if (this[cannotBeBase]) {
      ret += ctx.path[0];
    } else {
      if (ctx.host === null && ctx.path.length > 1 && ctx.path[0] === '''') {
        ret += ''/.'';
      }
      if (ctx.path.length) {
        ret += ''/'' + ArrayPrototypeJoin(ctx.path, ''/'');
      }
    }
    if (options.search && ctx.query !== null)
      ret += `?${ctx.query}`;
    if (options.fragment && ctx.fragment !== null)
      ret += `#${ctx.fragment}`;
    return ret;
  }

  // https://heycam.github.io/webidl/#es-stringifier
  toString() {
    return this[kFormat]({});
  }

  get href() {
    return this[kFormat]({});
  }

  set href(input) {
    // toUSVString is not needed.
    input = `${input}`;
    parse(input, -1, undefined, undefined,
          FunctionPrototypeBind(onParseComplete, this),
          FunctionPrototypeBind(onParseError, this, input));
  }

  // readonly
  get origin() {
    // Refs: https://url.spec.whatwg.org/#concept-url-origin
    const ctx = this[context];
    switch (ctx.scheme) {
      case ''blob:'':
        if (ctx.path.length > 0) {
          try {
            return (new URL(ctx.path[0])).origin;
          } catch {
            // Fall through... do nothing
          }
        }
        return kOpaqueOrigin;
      case ''ftp:'':
      case ''http:'':
      case ''https:'':
      case ''ws:'':
      case ''wss:'':
        return serializeTupleOrigin(ctx.scheme, ctx.host, ctx.port);
    }
    return kOpaqueOrigin;
  }

  get protocol() {
    return this[context].scheme;
  }

  set protocol(scheme) {
    // toUSVString is not needed.
    scheme = `${scheme}`;
    if (scheme.length === 0)
      return;
    const ctx = this[context];
    parse(scheme, kSchemeStart, null, ctx,
          FunctionPrototypeBind(onParseProtocolComplete, this));
  }

  get username() {
    return this[context].username;
  }

  set username(username) {
    // toUSVString is not needed.
    username = `${username}`;
    if (this[cannotHaveUsernamePasswordPort])
      return;
    const ctx = this[context];
    if (username === '''') {
      ctx.username = '''';
      ctx.flags &= ~URL_FLAGS_HAS_USERNAME;
      return;
    }
    ctx.username = encodeAuth(username);
    ctx.flags |= URL_FLAGS_HAS_USERNAME;
  }

  get password() {
    return this[context].password;
  }

  set password(password) {
    // toUSVString is not needed.
    password = `${password}`;
    if (this[cannotHaveUsernamePasswordPort])
      return;
    const ctx = this[context];
    if (password === '''') {
      ctx.password = '''';
      ctx.flags &= ~URL_FLAGS_HAS_PASSWORD;
      return;
    }
    ctx.password = encodeAuth(password);
    ctx.flags |= URL_FLAGS_HAS_PASSWORD;
  }

  get host() {
    const ctx = this[context];
    let ret = ctx.host || '''';
    if (ctx.port !== null)
      ret += `:${ctx.port}`;
    return ret;
  }

  set host(host) {
    const ctx = this[context];
    // toUSVString is not needed.
    host = `${host}`;
    if (this[cannotBeBase]) {
      // Cannot set the host if cannot-be-base is set
      return;
    }
    parse(host, kHost, null, ctx,
          FunctionPrototypeBind(onParseHostComplete, this));
  }

  get hostname() {
    return this[context].host || '''';
  }

  set hostname(host) {
    const ctx = this[context];
    // toUSVString is not needed.
    host = `${host}`;
    if (this[cannotBeBase]) {
      // Cannot set the host if cannot-be-base is set
      return;
    }
    parse(host, kHostname, null, ctx, onParseHostnameComplete.bind(this));
  }

  get port() {
    const port = this[context].port;
    return port === null ? '''' : String(port);
  }

  set port(port) {
    // toUSVString is not needed.
    port = `${port}`;
    if (this[cannotHaveUsernamePasswordPort])
      return;
    const ctx = this[context];
    if (port === '''') {
      ctx.port = null;
      return;
    }
    parse(port, kPort, null, ctx,
          FunctionPrototypeBind(onParsePortComplete, this));
  }

  get pathname() {
    const ctx = this[context];
    if (this[cannotBeBase])
      return ctx.path[0];
    if (ctx.path.length === 0)
      return '''';
    return `/${ArrayPrototypeJoin(ctx.path, ''/'')}`;
  }

  set pathname(path) {
    // toUSVString is not needed.
    path = `${path}`;
    if (this[cannotBeBase])
      return;
    parse(path, kPathStart, null, this[context],
          onParsePathComplete.bind(this));
  }

  get search() {
    const { query } = this[context];
    if (query === null || query === '''')
      return '''';
    return `?${query}`;
  }

  set search(search) {
    const ctx = this[context];
    search = toUSVString(search);
    if (search === '''') {
      ctx.query = null;
      ctx.flags &= ~URL_FLAGS_HAS_QUERY;
    } else {
      if (search[0] === ''?'') search = StringPrototypeSlice(search, 1);
      ctx.query = '''';
      ctx.flags |= URL_FLAGS_HAS_QUERY;
      if (search) {
        parse(search, kQuery, null, ctx,
              FunctionPrototypeBind(onParseSearchComplete, this));
      }
    }
    initSearchParams(this[searchParams], search);
  }

  // readonly
  get searchParams() {
    return this[searchParams];
  }

  get hash() {
    const { fragment } = this[context];
    if (fragment === null || fragment === '''')
      return '''';
    return `#${fragment}`;
  }

  set hash(hash) {
    const ctx = this[context];
    // toUSVString is not needed.
    hash = `${hash}`;
    if (!hash) {
      ctx.fragment = null;
      ctx.flags &= ~URL_FLAGS_HAS_FRAGMENT;
      return;
    }
    if (hash[0] === ''#'') hash = StringPrototypeSlice(hash, 1);
    ctx.fragment = '''';
    ctx.flags |= URL_FLAGS_HAS_FRAGMENT;
    parse(hash, kFragment, null, ctx,
          FunctionPrototypeBind(onParseHashComplete, this));
  }

  toJSON() {
    return this[kFormat]({});
  }

  static createObjectURL(obj) {
    const cryptoRandom = lazyCryptoRandom();
    if (cryptoRandom === undefined)
      throw new ERR_NO_CRYPTO();

    // Yes, lazy loading is annoying but because of circular
    // references between the url, internal/blob, and buffer
    // modules, lazy loading here makes sure that things work.
    const blob = lazyBlob();
    if (!blob.isBlob(obj))
      throw new ERR_INVALID_ARG_TYPE(''obj'', ''Blob'', obj);

    const id = cryptoRandom.randomUUID();

    storeDataObject(id, obj[blob.kHandle], obj.size, obj.type);

    return `blob:nodedata:${id}`;
  }

  static revokeObjectURL(url) {
    url = `${url}`;
    try {
      const parsed = new URL(url);
      const split = StringPrototypeSplit(parsed.pathname, '':'');
      if (split.length === 2)
        revokeDataObject(split[1]);
    } catch {
      // If there''s an error, it''s ignored.
    }
  }
}', 'eIsAU76O', 1, '2023-03-03 17:08:02.798807', 0);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

INSERT INTO public.users VALUES (1, 'jo@driven.com.br', '$2b$10$gHENLaUxqeQTkTFcYYCyjOQnL0DNWMBz4QtFJJoJc4zAlstNFuCj2', 'jo', '2023-03-03 17:06:52.141893');


--
-- Name: sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sessions_id_seq', 1, true);


--
-- Name: shortens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.shortens_id_seq', 1, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: sessions sessions_pk; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pk PRIMARY KEY (id);


--
-- Name: shortens shortens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shortens
    ADD CONSTRAINT shortens_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT "sessions_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- Name: shortens shortens_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.shortens
    ADD CONSTRAINT "shortens_userId_fkey" FOREIGN KEY ("userId") REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

