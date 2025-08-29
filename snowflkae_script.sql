create database adzuna_db;

-- creating storage
create or replace storage integration adzuna_s3_integration
    type = external_stage
    storage_provider = s3
    enabled = true
    storage_aws_role_arn = "arn:aws:iam::263167772235:role/adzuna_snowflake_role"
    storage_allowed_locations = ('s3://adzuna-etl-project-ah/')
    comment = 'Creating connection to S3'

    

desc integration adzuna_s3_integration;

CREATE OR REPLACE FILE FORMAT my_parquet_format TYPE = 'PARQUET';

-- creating stage 
create or replace stage adzuna_stage
    url = 's3://adzuna-etl-project-ah/transform_data/'
    storage_integration = adzuna_s3_integration
    file_format = my_parquet_format


create or replace table adzuna_db.public.adzuna_jobs_staging(
    job_id string,
    job_title string,
    job_location string,
    job_company string,
    job_category string,
    job_description string,
    job_url string,
    job_created timestamp,
    etl_at timestamp
);


select * from adzuna_jobs_staging;
truncate table adzuna_db.public.adzuna_jobs_staging;

COPY INTO adzuna_db.public.adzuna_jobs_staging
FROM (
    SELECT
        $1:job_id::STRING AS job_id,
        $1:job_title::STRING AS job_title,
        $1:job_location::STRING AS job_location,
        $1:job_company::STRING AS job_company,
        $1:job_category::STRING AS job_category,
        $1:job_description::STRING AS job_description,
        $1:job_url::STRING AS job_url,
        $1:job_created::TIMESTAMP AS job_created,
        CURRENT_TIMESTAMP() AS etl_at
    FROM @adzuna_stage
)
FILE_FORMAT = (FORMAT_NAME = 'my_parquet_format');

-- SHOW STAGES LIKE 'adzuna_stage';
-- DESC STORAGE INTEGRATION ADZUNA_S3_INTEGRATION;
-- LIST @ADZUNA_STAGE;

create or replace schema pipe;

create or replace pipe adzuna_db.pipe.adzuna_jobs_pipe
auto_ingest = true 
as 
COPY INTO adzuna_db.public.adzuna_jobs_staging
FROM (
    SELECT
        $1:job_id::STRING AS job_id,
        $1:job_title::STRING AS job_title,
        $1:job_location::STRING AS job_location,
        $1:job_company::STRING AS job_company,
        $1:job_category::STRING AS job_category,
        $1:job_description::STRING AS job_description,
        $1:job_url::STRING AS job_url,
        $1:job_created::TIMESTAMP AS job_created,
        CURRENT_TIMESTAMP() AS etl_at
    FROM @adzuna_db.public.adzuna_stage
)
FILE_FORMAT = (FORMAT_NAME = 'my_parquet_format');

desc pipe adzuna_db.pipe.adzuna_jobs_pipe;




