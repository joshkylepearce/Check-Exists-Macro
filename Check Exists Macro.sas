/************************************************************************************
***** Program: 	Check Exists Macro	*****
***** Author:	joshkylepearce		*****
************************************************************************************/

/************************************************************************************
Purpose:
Check whether a dataset or external file already exists.

Input Parameters:
1. type		- Binary indicator 'dataset' or 'file'.
2. path		- The name and location of the dataset/file.

Macro Usage:
1.	Run the check exists macro code.
2.	Call the check exists macro and enter the input parameters.
	e.g. %check_exists(
	type	= dataset,
	file	= work.library
	);

Notes:
1. 	Input parameters are compatible with/without quotations. 
	This is addressed within the macro.
2.	Input parameter 'type' dictates whether the user is interested in an
	internal or an external file. Input options are 'dataset' and 'file'.
3.	The type parameter options 'dataset' and 'file' are not case sensitive. 
	This is addressed within the macro.
************************************************************************************/

%macro check_exists(type,path);

/*
Input parameters are only compatible with macro if not in quotes.
Account for single & double quotations.
*/
/*Remove double quotes*/
%let type = %sysfunc(compress(&type., '"'));
%let path = %sysfunc(compress(&path., '"'));
/*Remove single quotes*/
%let type = %sysfunc(compress(&type., "'"));
%let path = %sysfunc(compress(&path., "'"));

/*If the input paramater 'type' is set to 'dataset'*/
%if %sysfunc(upcase(&type.)) = DATASET %then %do;
   /*Check if the dataset exists*/
    %if %sysfunc(exist(&path.)) %then %do;
		/*Write a note to the log to confirm that the dataset exists*/
        %put NOTE: The dataset &path. exists.;
    %end;
    %else %do;
        /*Error message if the dataset does not exist*/
        %put ERROR: The dataset &path. does not exist. Operation aborted.;
    %end;
%end;

/*If the input paramater 'type' is set to 'file' */
%else %if %sysfunc(upcase(&type.)) = FILE %then %do;
    /*Check if the external file exists*/
    %if %sysfunc(fileexist(&path.)) %then %do;
        /*Write a note to the log to confirm that the file exists*/
        %put NOTE: The file &path. exists.;
    %end;
    %else %do;
        /*Error message if the file does not exist*/
        %put ERROR: The file &path. does not exist. Operation aborted.;
    %end;
%end;

/*Error if neither 'dataset' nor 'file' is specified for input paramater 'type'*/
%else %do;
	/*Error message if neither 'dataset' nor 'file' is entered*/
    %put ERROR: Invalid type specified. Operation aborted.;
	%put Please specify either 'dataset' or 'file' as the type.;
%end;

%mend check_exists;

/************************************************************************************
Example 1: Macro Usage With Internal Dataset
************************************************************************************/

/*Call the macro and check whether a dataset exists*/
%check_exists(type=dataset, path=sashelp.cars);

/*Call the macro and check whether a non-existent dataset exists*/
%check_exists(type=dataset, path=WORK.NONEXISTENDATA);

/************************************************************************************
Example 2: Macro Usage With External File
************************************************************************************/

/*Call the macro and check whether a file exists*/
%check_exists(type=file, path=\\sasebi\SAS User Data\Josh Pearce\DATA\TOURISM.xlsx);

/*Call the macro and check whether a non-existent file exists*/
%check_exists(type=file, path=\\sasebi\SAS User Data\Josh Pearce\DATA\NON EXISTENT FILE.xlsx);