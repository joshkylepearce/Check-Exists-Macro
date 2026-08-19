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
Example 2: Macro Usage With External File

Original repo code pointed at a local network share:
  \\sasebi\SAS User Data\Josh Pearce\DATA\TOURISM.xlsx
Substituted below with the session's own WORK directory, since Jenner's sandbox
has no access to that network share, and a real filesystem path is needed for
FILEEXIST to check honestly (WORK is guaranteed to exist in any SAS session).
The macro logic is unchanged.
************************************************************************************/

/*Call the macro and check whether a file exists*/
%check_exists(type=file, path=%sysfunc(pathname(work)));

/*Call the macro and check whether a non-existent file exists*/
%check_exists(type=file, path=%sysfunc(pathname(work))/NON_EXISTENT_FILE.xlsx);
