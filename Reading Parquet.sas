/***********************************************************************/
/*** This demo highlights two different methods to assign SASIODUK   ***/
/*** Run this demo section by section. Highlight the code to run.    ***/
/***  - test by running a PROC CONTENTS and PROC MEANS               ***/
/***       PART 1: Pre-Assign all libname parameters                 ***/
/***       PART 2: Assign the file_type option when it is referenced ***/
/***********************************************************************/
ods graphics on;


/***********************************************************************/
/***       PART 1: Assign the file type as part of the libname stmt  ***/
/***********************************************************************/
libname duklib1 sasioduk 
		file_type=parquet 
		file_path="/data-netapp-ultra/data/nyc/parquet/yellow";   
run;

***************************************************************;
**  explore all 12 months of the 2011 data in a single pass  **;
***************************************************************;
proc contents data=duklib1.'2011/*'n;
run;
proc means data=duklib1.'2011/*'n n nmiss mean min max std;
run;
proc print data=duklib1.'2011/*'n(obs=10);
run; 

***************************************************************;
**  explore a single month of data  (january = '01')         **;
***************************************************************;
proc contents data=duklib1.'2011/*01'n;
run;
proc means data=duklib1.'2011/*01'n n nmiss mean min max std;
run;
proc print data=duklib1.'2011/*01'n(obs=10);
run; 





/* Scroll down */


/***********************************************************************/
/***       PART 2: Assign the file_type option as it is referenced   ***/
/***********************************************************************/
libname duklib2 sasioduk 
		file_path="/data-netapp-ultra/data/nyc/parquet/yellow";   
run;

***************************************************************;
**  explore all 12 months of the 2011 data in a single pass  **;
***************************************************************;
proc contents data=duklib2.'2011/*.parquet'n(file_type=parquet);
run;
proc means data=duklib2.'2011/*.parquet'n(file_type=parquet) n nmiss mean min max std;
run;
proc print data=duklib2.'2011/*.parquet'n(file_type=parquet obs=10);
run; 

***************************************************************;
**  explore a single month of data  (january = '01')         **;
***************************************************************;
proc contents data=duklib2.'2011/*01.parquet'n(file_type=parquet);
run;
proc means data=duklib2.'2011/*01.parquet'n(file_type=parquet) n nmiss mean min max std;
run;
proc print data=duklib2.'2011/*01.parquet'n(file_type=parquet obs=10);
run; 

