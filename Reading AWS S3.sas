/***********************************************************************/
/*** This demo showcases the read capabilities with AWS S3 bucket.   ***/
/***********************************************************************/

/* SASIODUK libname statement */
libname duklib sasioduk;

PROC SQL;
	/* connect using the SASIODUK configuration profile */
    CONNECT USING duklib;

    /***************************************************************************/
    /* This block runs inside DuckDB:                                          */
    /***************************************************************************/ 
    EXECUTE (

		/*  Prepare DuckDB inside SAS to support cloud-based data access. */
        SET extension_directory = '/tmp/.extensions';
        INSTALL httpfs;
        LOAD httpfs;
        INSTALL aws;
        LOAD aws;

        /* Create an S3 credential secret (called secret2) so the database     */ 
        /* engine can authenticate with AWS and access the specified S3 bucket */ 
        CREATE OR REPLACE SECRET secret2 (
            TYPE s3,
            PROVIDER config,
            KEY_ID 'XXXXXXXXXX',
            SECRET 'YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY',
            REGION 'ABCD'
        );
    ) BY duklib;

    /* select 10 rows */
    SELECT * FROM CONNECTION TO duklib (
        SELECT *
        FROM 's3://datasets/nyc/parquet/yellow/2020/yellow_tripdata_2020-04.parquet'
        LIMIT 10
    );
QUIT;





