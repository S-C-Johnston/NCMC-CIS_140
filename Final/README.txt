Manifest
-rwxr-xr-x  1 stewart  staff      49 Dec 21 19:53 DepartmentCodes.csv
-r-xr-xr-x  1 stewart  staff      49 Dec 21 19:35 DepartmentCodes.csv.bak
-rwxr-xr-x  1 stewart  staff     268 Dec 21 19:53 PatientsRecord.csv
-r-xr-xr-x  1 stewart  staff     268 Dec 21 19:35 PatientsRecord.csv.bak
-rwxr-xr-x  1 stewart  staff    1464 Dec 21 19:31 rebuildData.sh.overthink
-rwxr-xr-x  1 stewart  staff     514 Dec 21 19:54 rebuildFiles.sh

Permissions on the .csv data files for the final should be octal 755, as the
above manifest shows. If they're not, or if you need fresh copies of the data
files, run the ``rebuildFiles.sh`` script.  ``rebuildData.sh.overthink`` does
the same thing, but it is very overthought, hence the suffix. It is here for
historical reasons. It isn't _bad_, just a smidge overthought. 73 lines of
bullcrap which could be replaced by a one-liner. Oh, well.
