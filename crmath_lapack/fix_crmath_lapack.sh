#!/bin/sh

# Decide which awk to use

if `awk --version | grep -q GNU`; then
    AWK='awk --posix'
else
    AWK='awk'
fi

# Customize files

FILES=`find ./ -name '*.f'`

for file in $FILES; do

    ${AWK} -f $(dirname "$0")/fix_crmath_lapack.awk $file > $file.tmp
    mv $file.tmp $file

done
