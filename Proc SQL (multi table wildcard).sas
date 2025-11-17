/****************************************************************************************/
/*** This demo showcases the multi-table query capability of sasioduk.                ***/
/*** Run this demo section by section. Highlight the codes to run.                    ***/
/***    PART 1: Pre  2025.07 (using SAS engine)         SAS dataset: 27GB             ***/
/***    PART 2: Post 2025.07 (using sasioduk engine)    Parquet data: 2.1GB & 19.2GB  ***/
/****************************************************************************************/
options fullstimer;
 
/******************************************************************************/
/***    PART 1: Pre  2025.07 (using SAS engine)  SAS dataset: 27GB          ***/
/******************************************************************************/

/* SAS libname statement */
libname saslib '/data-netapp-ultra/data/demo-quickstart/sasdata';

/******************************************************************************/
/* Combine all 12 months of nyc trips into a single data set for 2011.  This  */
/* Data Step processing takes 2-4 minutes,  if demonstrating for a customer,  */
/* you don't necessarily need to run it, but do highlight the need for extra  */
/* processing and note the additional time. Each monthly file is ~2GB         */
/******************************************************************************/

data saslib.yellow_tripdata_2011;
  set saslib.yellow_tripdata_201101 
	  saslib.yellow_tripdata_201102
	  saslib.yellow_tripdata_201103
	  saslib.yellow_tripdata_201104
	  saslib.yellow_tripdata_201105
	  saslib.yellow_tripdata_201106
	  saslib.yellow_tripdata_201107
	  saslib.yellow_tripdata_201108
	  saslib.yellow_tripdata_201109
	  saslib.yellow_tripdata_201110
	  saslib.yellow_tripdata_201111
	  saslib.yellow_tripdata_201112;
run;	  

/* Query a single Year(2011) SAS dataset (27GB) */
/* This PROC SQL step takes approximately 1min 55secs */
PROC SQL;

  SELECT
    passenger_count, 
    payment_type,
    count(*)           AS num_trips,
    avg(trip_distance) AS avg_distance,
    avg(fare_amount)   AS avg_fare,
    avg(tip_amount)    AS avg_tip

  FROM 
    saslib.yellow_tripdata_2011 
	/* The size of this SAS dataset is 27GB */

  WHERE
    passenger_count is not NULL AND
    passenger_count > 0 AND
    passenger_count < 5 AND
    trip_distance < 100 AND
    trip_distance > 0

  GROUP BY
    passenger_count, payment_type

  ORDER BY 
    payment_type, passenger_count;

QUIT;
 


/***************************************************************************************/
/***    PART 2: Post 2025.07 (using sasioduk engine)   Parquet data: 2.1GB & 19.2GB  ***/
/***************************************************************************************/
 
/* SASIODUK libname statement */
libname duklib sasioduk 
		file_type="parquet"
        file_path="/data-netapp-ultra/data/nyc/parquet/yellow/";

/* Query all 12 months of Year2011 parquet data in a single step using wildcard (2.1GB) */
/* This PROC SQL step takes approximately 2.5secs */
PROC SQL;

  SELECT
    passenger_count, 
    payment_type,
    count(*)           AS num_trips,
    avg(trip_distance) AS avg_distance,
    avg(fare_amount)   AS avg_fare,
    avg(tip_amount)    AS avg_tip

  FROM 
    duklib.'2011/*'n
	/* The total size of Year 2011 parquet datasets is 2.1GB */

  WHERE
    passenger_count is not NULL AND
    passenger_count > 0 AND
    passenger_count < 5 AND
    trip_distance < 100 AND
    trip_distance > 0

  GROUP BY
    passenger_count, payment_type

  ORDER BY 
    payment_type, passenger_count;

QUIT;


/* Query all Year 2011 to 2019 (9 years x 12 months) of parquet data (19.2GB) */
/* This PROC SQL step takes approximately 15secs */
PROC SQL;

  SELECT
    passenger_count, 
    payment_type,
    count(*)           AS num_trips,
    avg(trip_distance) AS avg_distance,
    avg(fare_amount)   AS avg_fare,
    avg(tip_amount)    AS avg_tip

  FROM 
    duklib.'201*/*'n
	/* The total size of 9 years of parquet datasets is 19.2GB                */
	/* Individual monthly files are stored in separate subdirectories by year */
    /* The wild card allows us to the read the data using a single reference  */

  WHERE
    passenger_count is not NULL AND
    passenger_count > 0 AND
    passenger_count < 5 AND
    trip_distance < 100 AND
    trip_distance > 0

  GROUP BY
    passenger_count, payment_type

  ORDER BY 
    payment_type, passenger_count;

QUIT;
