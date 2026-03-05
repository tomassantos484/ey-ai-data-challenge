USE ROLE ACCOUNTADMIN;
CREATE DATABASE IF NOT EXISTS EYADC;
CREATE SCHEMA IF NOT EXISTS EYADC.INTEGRATIONS;
CREATE SCHEMA IF NOT EXISTS EYADC.REPO;

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
    'planetarycomputer.microsoft.com',
    'api.planetarycomputer.microsoft.com',
    'planetarycomputer.microsoft.com:443',
    'api.stacspec.org',
    'stacspec.org',
    'planetarycomputer.blob.core.windows.net',
    'cpdataeuwest.blob.core.windows.net',
    'ai4edataeuwest.blob.core.windows.net',
    'naipeuwest.blob.core.windows.net',
    'planetarycomputer.dfs.core.windows.net',
    'cpdataeuwest.dfs.core.windows.net',
    '*.blob.core.windows.net',
    '*.dfs.core.windows.net',
    'login.microsoftonline.com',
    'management.azure.com'
  );
CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION DATA_CHALLENGE_EXTERNAL_ACCESS
  ALLOWED_NETWORK_RULES = (
    EYADC.INTEGRATIONS.PYPI_NETWORK_RULE,
    EYADC.INTEGRATIONS.PLANETARY_COMPUTER_NETWORK_RULE
  )
  ENABLED = TRUE;

SHOW NETWORK RULES IN SCHEMA EYADC.INTEGRATIONS;
DESCRIBE INTEGRATION DATA_CHALLENGE_EXTERNAL_ACCESS;