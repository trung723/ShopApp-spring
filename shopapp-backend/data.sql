--------------------------------------------------------
--  File created - Thursday-September-19-2024   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for DB Link SYS_HUB
--------------------------------------------------------

  CREATE DATABASE LINK "SYS_HUB"
   USING 'SEEDDATA';
--------------------------------------------------------
--  DDL for Type ADR_HOME_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_HOME_T" FORCE AS OBJECT
(
  product_type          VARCHAR2(8),                        /* product type */
  product_id            VARCHAR2(30),                         /* product id */
  instance_id           VARCHAR2(30),                        /* instance id */
  precedence            INTEGER,       /* precedence level of this adr home */
  adr_id                INTEGER,              /* hash value of the adr home */


-- **********************************************************************
-- Construct an ADR home object representing ADR home at a location
-- described by application specific naming
-- **********************************************************************

  CONSTRUCTOR FUNCTION adr_home_t
  (
    SELF IN OUT NOCOPY  adr_home_t,
    product_type        VARCHAR2,
    product_id          VARCHAR2,
    instance_id         VARCHAR2,
    precedence          INTEGER
  )
  RETURN SELF AS RESULT
);
/
CREATE OR REPLACE NONEDITIONABLE TYPE BODY "SYS"."ADR_HOME_T" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
e
374 1da
P9zZCTAoS//oIklLqMdGlhwD0V0wg2Pxmgwdf3TGEBkP98baUC06bSlrUA0x4rj2gIO2uSbn
nrzjyvm1dTME9njMdcYNyIsFXbchP7RmVjurjzpDgjQQNJ1Ali9I4Xz09v4M9m6whyMMS/zw
0oOrLxjm9ngEetXFh6bLmJQRHWH+cNigBahekEn6p9gGZ6/GR66skdV9wvXelWApJW4PBPT6
vzCZbMWRFyVCce8tjIvpfRJl7424fkW8bUt7b1PbDd+3juBZLazlqevLWZoyKrizXAfJzQXm
aWrvVielYuyOyj8nvlKvstHK92M+vc18gxx4hswyUu11mmg9LkWsYFIZyShSohWB+dRrXBpT
7JBGUtr4tu+7+K52WLUkyk4dyACiz5jeCFb+KJV0KsbCISRYWQpZw1nTbWWY542yXJ4NAxNM
3oiRblLLxkW0DtjQhqbUHeJf2Rj4MXijjHJQ

/

  GRANT EXECUTE ON "SYS"."ADR_HOME_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_CORR_KEYS_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_CORR_KEYS_T" FORCE AS
  VARRAY(10) OF adr_incident_corr_key_t;

/

  GRANT EXECUTE ON "SYS"."ADR_INCIDENT_CORR_KEYS_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_CORR_KEY_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_CORR_KEY_T" FORCE AS OBJECT
(
  name                  VARCHAR2(64),                /* correlation key name */
  value                 VARCHAR2(512),               /* correlation key value*/
  flags                 INTEGER                     /* correlation key flags */
);

/
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_ERR_ARGS_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_ERR_ARGS_T" FORCE AS
  VARRAY(12) OF VARCHAR2(64);

/
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_FILES_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_FILES_T" FORCE AS
  VARRAY(10) OF adr_incident_file_t;

/

  GRANT EXECUTE ON "SYS"."ADR_INCIDENT_FILES_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_FILE_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_FILE_T" FORCE AS OBJECT
(
  dirpath               VARCHAR2(512),         /* directory path of the file */
  filename              VARCHAR2(64)                            /* file name */
);

/
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_INFO_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_INFO_T" FORCE AS OBJECT
(
  problem_key             VARCHAR2(64),       /* problem key of the incident */
  error_facility          VARCHAR2(10),                    /* error facility */
  error_number            INTEGER,                           /* error number */
  error_message           VARCHAR2(1024),                   /* error message */
  ecid                    VARCHAR2(64),              /* execution context id */
  signalling_component    VARCHAR2(64),              /* signalling component */
  signalling_subcomponent VARCHAR2(64),          /* signalling sub component */
  suspect_component       VARCHAR2(64),                 /* suspect component */
  suspect_subcomponent    VARCHAR2(64),             /* suspect sub component */
  error_args              adr_incident_err_args_t,        /* error arguments */
  correlation_keys        adr_incident_corr_keys_t,      /* correlation keys */
  files                   adr_incident_files_t  /* additional incident files */
);

/

  GRANT EXECUTE ON "SYS"."ADR_INCIDENT_INFO_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_INCIDENT_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_INCIDENT_T" AS OBJECT
(
  home                   adr_home_t,           /* adr home for this incident */
  id                     INTEGER,                             /* incident id */
  staged                 VARCHAR2(1),                  /* is staged incident */
  in_update              VARCHAR2(1),         /* is in the process of update */
  pending                adr_incident_info_t,            /* for internal use */


  -- **********************************************************************
  -- Gets the id of this incident
  -- **********************************************************************

  MEMBER FUNCTION get_id RETURN INTEGER,


  -- **********************************************************************
  -- Gets the path to the directory where incident diagnostic files reside
  -- Value is <ADR_HOME>/incident/incdir_<ID>
  -- **********************************************************************

  MEMBER FUNCTION get_incident_location RETURN VARCHAR2,


  -- **********************************************************************
  -- Writes diagnostics to the default incident file
  -- **********************************************************************

  MEMBER PROCEDURE dump_incident
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    data     IN VARCHAR2                    /* data to dump in incident file */
  ),


  -- **********************************************************************
  -- Writes RAW diagnostics to the default incident file
  -- **********************************************************************

  MEMBER PROCEDURE dump_incident_raw
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    data     IN RAW                     /* RAW data to dump in incident file */
  ),


  -- **********************************************************************
  -- Writes diagnostics to a specified incident file in the incident
  -- directory
  -- **********************************************************************

  MEMBER PROCEDURE dump_incfile
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    filename IN VARCHAR2,          /* additional incident file to be created */
    data     IN VARCHAR2                       /* data to dump in above file */
  ),


  -- **********************************************************************
  -- Writes raw diagnostic data to the specified incident file in the
  -- incident directory
  -- **********************************************************************

  MEMBER PROCEDURE dump_incfile_raw
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    filename IN VARCHAR2,          /* additional incident file to be created */
    data     IN RAW                        /* RAW data to dump in above file */
  ),


  -- **********************************************************************
  -- Adds correlation key to this incident
  -- **********************************************************************

  MEMBER PROCEDURE add_correlation_key
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    name     IN VARCHAR2,                            /* correlation key name */
    value    IN VARCHAR2,                           /* correlation key value */
    flags    IN INTEGER DEFAULT NULL                /* correlation key flags */
  ),


  -- **********************************************************************
  -- Registers a file with this incident.
  -- The file can be anywhere in ADR home.
  -- **********************************************************************

  MEMBER PROCEDURE register_file
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    dirpath  IN VARCHAR2,                      /* directory path of the file */
    filename IN VARCHAR2                                        /* file name */
  ),


  -- **********************************************************************
  -- Registers a file in incident directory with this incident
  -- **********************************************************************

  MEMBER PROCEDURE register_file
  (
    SELF     IN OUT NOCOPY adr_incident_t,
    filename IN VARCHAR2                                        /* file name */
  ),


  -- **********************************************************************
  -- Marks the beginning of post-create updates to this incident
  --  This should be used to add correlation keys, adding additional
  --  incident files and other incident metadata changes after
  --  the incident has already been created
  -- **********************************************************************

  MEMBER PROCEDURE begin_update(SELF IN OUT NOCOPY adr_incident_t),


  -- **********************************************************************
  -- Marks the end of post-create updates to this incident
  --  begin_update and end_update must always be used together
  -- **********************************************************************

  MEMBER PROCEDURE end_update(SELF IN OUT NOCOPY adr_incident_t)
);
/
CREATE OR REPLACE NONEDITIONABLE TYPE BODY "SYS"."ADR_INCIDENT_T" wrapped
a000000
1
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
abcd
e
1059 4ac
Z1AOX8Q1iflal7dHP4FVUb8DTcUwg83qea4GZy+8ZJvVGz9rFFpfwWwf9CynuazXjXkDVeXP
J1DTeRQRel+qtcmceQwp/fJHbJz2WgwXycF5TxeIXUcXfJt9dIsI9onYubcwLaOA9so1sB3I
EOh+e+Dh1KjEY4ZSdXyIrY42t2uPj7j6G1kOkLaPedsby8ZJkSN72+rUCPfaO06XeQdl0e+x
A/Snq0mxorTqom5jzHeVSGy2blNwGUwVSahYfEuC9ILTokepSug1ok24ZokEpEleOcYIVevZ
m7+H+GrgpGJPu8EeXUIyflYgdkJEYQcBGfLvm/TdQwQiS19RICG66t1oUvAELMuwyzx9veca
583FW5PWgtmzk+2IRVLOGnhWKdUFuZlyySGOdBFXgQPUjDc9MZcJQ72HFjcSYcFypkttOtFY
Gj73FA1Vg02HiNPe2C2GZW0H4gWxbRKt5mFSsXXiwAgmfj3m7Tq6Mbnqxuo3uXMqk5ZRV1gk
z2JdM+FMPEGyQexWg6lYgQM8XMk3HElUwFd7IMLFNsMOOueg7zVIy0D+1ICZwlwaJ/Wcvjrz
U6pFrHPKnV4FqqCq0820xiL1SkrL6b+ZU71j9829r3FzDIhz4IIWjO/tGBYm4fTRwBeh81ax
27KTjJW0bLdwxhVHW2cxdUbR6KnbTY9pxlD7YwtxtgIi30CvbPUXTMjqX7AOFUOEc5C++9mD
JggfR6zjve70N8rc3XeYkevwhXuttTpz0geDiKlIpc7kYV/uSPv+TkPA82oSwj9ZKxYwWiuz
BQx6D5bcbwq0zwLadp5BRQC2dV5ZwHUXaKFOM8wCfBUV9UEFQrDlbdng/qQiM2beSm2LEoja
XOqYsINlGFx0n1CUIYlcYVU7XogRsm+Yt2ccNP8FZ6Sibsv98NiDPWEfwDFePljY1YJemKl2
fSC4SjtFn2KyfSJuM5uENDIO0+cR25Djd7NSL2wm78+sW4Ad7iXrJhVRWcLWVzN4BDOWAwx5
TO9j3zmYlN7eWISVfEQfjV2zqwoRnOsa8UkjNven+wEkaoeyKoN1s9/6itqFw3ILAmnJtdm9
xHyTmIJWLfXsLj48t2ILgwLoo4a17np77M/fn9Sx8D3J4/2Riyf13SkYTbOE+LmU3WslR9Cp
ZwbdgG3C5ukmVJwaSJr5pj5mO64=

/

  GRANT EXECUTE ON "SYS"."ADR_INCIDENT_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_LOG_MSG_ARGS_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_LOG_MSG_ARGS_T" FORCE AS VARRAY(32) OF adr_log_msg_arg_t;

/

  GRANT EXECUTE ON "SYS"."ADR_LOG_MSG_ARGS_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_LOG_MSG_ARG_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_LOG_MSG_ARG_T" FORCE AS OBJECT
(
  name       VARCHAR2(64),                      /* log message argument name */
  value      VARCHAR2(128)                     /* log message argument value */
);

/

  GRANT EXECUTE ON "SYS"."ADR_LOG_MSG_ARG_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_LOG_MSG_ECID_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_LOG_MSG_ECID_T" FORCE AS OBJECT
(
  id         VARCHAR2(100),                          /* execution context id */
  rid        VARCHAR2(100)                  /* execution context sequence id */
);

/

  GRANT EXECUTE ON "SYS"."ADR_LOG_MSG_ECID_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_LOG_MSG_ERRID_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_LOG_MSG_ERRID_T" FORCE AS OBJECT
(
  id         VARCHAR2(100),                             /* error instance id */
  rid        VARCHAR2(100)                              /* error sequence id */
);

/

  GRANT EXECUTE ON "SYS"."ADR_LOG_MSG_ERRID_T" TO "DBA";
--------------------------------------------------------
--  DDL for Type ADR_LOG_MSG_SUPPL_ATTRS_T
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE TYPE "SYS"."ADR_LOG_MSG_SUPPL_ATTRS_T" FORCE AS
  VARRAY(32) OF adr_log_msg_suppl_attr_t;

/

  GRANT EXECUTE ON "SYS"."ADR_LOG_MSG_SUPPL_ATTRS_T" TO "DBA";
