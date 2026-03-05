-- Snowflake Setup
USE ROLE ACCOUNTADMIN;

CREATE DATABASE IF NOT EXISTS EYADC;
CREATE SCHEMA IF NOT EXISTS EYADC.INTEGRATIONS;

USE DATABASE EYADC;
USE SCHEMA INTEGRATIONS;
CREATE NETWORK RULE IF NOT EXISTS PYPI_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org', 'files.pythonhosted.org');

CREATE NETWORK RULE IF NOT EXISTS PLANETARY_COMPUTER_NETWORK_RULE
  MODE = EGRESS
  TYPE = HOST_PORT
  VALUE_LIST = (
    -- Primary API endpoints
    'planetarycomputer.microsoft.com',
    'api.planetarycomputer.microsoft.com',
    'planetarycomputer.microsoft.com:443',
    
    -- STAC specification endpoints
    'api.stacspec.org',
    'stacspec.org',
    
    -- Azure Blob Storage (needed for data access)
    'planetarycomputer.blob.core.windows.net',
    'cpdataeuwest.blob.core.windows.net',
    'ai4edataeuwest.blob.core.windows.net',
    'naipeuwest.blob.core.windows.net',
    
    -- Azure Data Lake Storage (for Zarr access)
    'planetarycomputer.dfs.core.windows.net',
    'cpdataeuwest.dfs.core.windows.net',
    
    -- SAS token and authentication endpoints
    '*.blob.core.windows.net',
    '*.dfs.core.windows.net',
    
    -- Microsoft authentication (if needed)
    'login.microsoftonline.com',
    'management.azure.com'
  );

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION DATA_CHALLENGE_EXTERNAL_ACCESS
  ALLOWED_NETWORK_RULES = (
    EYADC.PUBLIC.PYPI_NETWORK_RULE,
    EYADC.PUBLIC.PLANETARY_COMPUTER_NETWORK_RULE
  )
  ENABLED = TRUE;


-- Verify integration creation
DESCRIBE INTEGRATION DATA_CHALLENGE_EXTERNAL_ACCESS;

ALTER ACCOUNT SET USE_WORKSPACES_FOR_SQL = 'always';