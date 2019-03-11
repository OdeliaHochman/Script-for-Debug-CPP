#!/bin/bash

dir_path=$1 
program=$2
shift 
shift 

cd $dir_path
make >/dev/null 2>&1
successfullmake=$?


if [ "$successfullmake" -gt "0" ]; then
echo Compilation$'\t'Memory leaks$'\t'Thread race$'\n'
echo FAIL$'\t'FAIL$'\t'FAIL$'\t'
exit 7
fi
valgrind --leak-check=full --error-exitcode=1 -q ./$program $@ >/dev/null 2>&1
resv=$?

if [ "$resv" -gt "0" ]; then
check1=1
else

check1=0
fi

valgrind --tool=helgrind --error-exitcode=1 -q ./$program $@ >/dev/null 2>&1
resh=$?
if [ "$resh" -gt "0" ]; then

check2=1

else

check2=0
fi

echo Compilation$'\t'Memory leaks$'\t'Thread race$'\n'
ans=$successfullmake$check1$check2
if [ $ans -eq "000" ]; then
echo PASS$'\t'PASS$'\t'PASS
exit 0
elif [ $ans -eq "010" ]; then
echo PASS$'\t'FAIL$'\t'PASS
exit 2
elif [ $ans -eq "001" ]; then
echo PASS$'\t'PASS$'\t'FAIL
exit 1
else [ $ans -eq "011" ]; 
echo PASS$'\t'FAIL$'\t'FAIL
exit 3
fi

