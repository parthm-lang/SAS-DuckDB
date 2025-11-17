/***********************************************************************/
/*** This demo showcases the read capabilities with ADLS.            ***/

/***********************************************************************/
/*
/* SASIODUK libname statement */
libname duklib sasioduk;


PROC SQL;
    /* connect using the SASIODUK configuration profile */
	connect using duklib;
  
    /***************************************************************************/
    /* This block runs inside DuckDB:                                          */
    /***************************************************************************/ 
	EXECUTE (

    		/*  Prepare DuckDB inside SAS to support cloud-based data access. */                                     
			SET extension_directory = '/tmp/.extensions';
			INSTALL httpfs;
			LOAD httpfs;
			INSTALL azure;
			LOAD azure;

			/* Authenticate to Azure using Managed Identity (secure and cloud-native)  */
			CREATE OR REPLACE SECRET secret2 (
    			TYPE         azure,
                PROVIDER     credential_chain,
                CHAIN        managed_identity,
     			ACCOUNT_NAME 'XXXXXX' /* ADLS2 storage account name */
			);
	) by duklib;

    /* Read Parquet files directly from Azure Data Lake Storage (ADLS2). */
	SELECT * FROM connection TO duklib (
		SELECT *
	    FROM
	      'XXXXX:/path/data/*.parquet' 
	    LIMIT 10
	);
QUIT;


