#!/bin/bash

if [[ $# != 2 || $# !=0 ]] ; then 
	echo "Error: need 0/2 argument!"
	echo "Usage: ./copy_new_Processor.sh  [old_process   new_processor]"
fi

basic_folder=$ILCSOFT/Marlin/v01-09/examples/mymarlin/

# this folder should have an action.sh file, which is used to compile processor in the future.
# I suppose this file will be put in the same directory with copy_new_Processor.sh
action_file_folder="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" && pwd  )"

if [[ $# == 2 ]] ; then 
	old_processor=$(basename "$1")
	new_processor=$(basename "$2")
	old_folder=$(dirname "${1}")"/"
	new_folder=$(dirname "${2}")"/"
elif [[ $# == 0 ]] ; then 
	old_process=MyProcessor
	new_processor=MyProcessor1
	old_folder=$basic_folder
	new_folder=./
fi


if [ -d ${new_folder}${new_processor}  ] ; then
	echo "Already have  ${new_processor},  please change a name!"
	echo "Usage: ./copy_new_Processor.sh    old_process   new_processor"
	exit
fi


cp -r ${old_folder}  ${new_folder}

echo "the new folder is ${new_processor}"
echo


if [ -d ${new_folder}  ] ; then
	cd ${new_folder}
else
	echo "Error: does not create ${new_processor}, please check!"
	exit
fi


echo "checking the CMakeLists.txt."
echo


if [ -a "CMakeLists.txt"  ] ; then
	echo "Already have CMakeList, editing necessary libraries ..."
else
	echo "no CMakeList,  copy it from the source."
	source_cmake=${basic_folder}CMakeLists.txt
	if [ ! -a ${source_cmake}  ] ; then
		echo "Error: no source CMakeLists.txt, please find a new CMake source."
	fi
	cp ${source_cmake} ./
	echo "editing necessary libraries ..."
fi

sed -i "9c\ PROJECT( ${new_processor} )" CMakeLists.txt


lib_test=` grep "std=gnu++" CMakeLists.txt | sed -e "s/ //g" `
if [[ ${lib_test} == "" ]] ; then
	echo "adding c++ compiling condition ..."
	sed -i '58c\ ADD_DEFINITIONS( "-Wall -ansi -pedantic -std=gnu++11" )' CMakeLists.txt
	sed -i '59c\ ADD_DEFINITIONS( "-Wno-long-long" )' CMakeLists.txt
fi

root_test=` grep "ROOT REQUIRED" CMakeLists.txt | sed -e "s/ //g" `
if [[ ${root_test} == "" ]] ; then
	echo "adding root libraries ..."
	sed -i '31a\ FIND_PACKAGE( ROOT REQUIRED )' CMakeLists.txt
	sed -i '32a\ INCLUDE_DIRECTORIES( ${ROOT_INCLUDE_DIRS} )' CMakeLists.txt
	sed -i '33a\ LINK_LIBRARIES( ${ROOT_LIBRARIES} )' CMakeLists.txt
fi


lcio_test=` grep "LCIO REQUIRED" CMakeLists.txt | sed -e "s/ //g" `
if [[ ${lcio_test} == "" ]] ; then
	echo "adding lcio libraries ..."
	sed -i '34a\ FIND_PACKAGE( LCIO REQUIRED )' CMakeLists.txt
	sed -i '35a\ INCLUDE_DIRECTORIES( ${LCIO_INCLUDE_DIRS} )' CMakeLists.txt
	sed -i '36a\ LINK_LIBRARIES( ${LCIO_LIBRARIES} )' CMakeLists.txt
fi




echo "checking the source files."
echo 




if [ -d "src"  ] ; then
	echo "Already have  --src-- filter with the source file"
else
	echo "no source filter, mkdir new src filter"
	mkdir src 
	if [ -a *.cc  ] ; then
		echo "Already have source file, move to src filter"
		mv *.cc ./src
	else
		echo "no source file, stop"
		exit
	fi
fi


cd ./src/
mv ${old_process}.cc ${new_processor}.cc
for f in *.cc ; do
	sed -i "s/${old_process}/${new_processor}/g" ` grep Processor -rl ./ `
done
cd ..


echo "checking the include files."
echo 

if [ -d "include"  ] ; then
	echo "Already have  --include-- filter with the header file"
else
	echo "no header filter"
	mkdir include
	if [ -a *.h  ] ; then
		echo "Already have header file, move to head filter"
		mv *.h ./include
	else
		echo "no head file, stop"
		exit
	fi
fi

cd ./include/
mv ${old_process}.h ${new_processor}.h
for f in *.h ; do
	sed -i "s/${old_process}/${new_processor}/g" ` grep Processor -rl ./ `
done
cd ..


echo "checking the lib files."
echo 

if [ -d "lib"  ] ; then
	echo "Already have  --lib-- filter, deleting old files ..."
	rm ./lib/*
else
	echo "no lib filter"
	mkdir lib 
fi


echo "checking the build files."
echo 



if [ -d "build"  ] ; then
	echo "Already have  --build-- filter, deleting old files ..."
	rm ./build -r
	mkdir build 
else
	echo "no build filter"
	mkdir build 
fi


if [ -d xml ] ; then
	echo "Already have  --xml-- folder with the steering file"
else
	echo "no steering folder"
	mkdir xml 
	cd xml
	Marlin -x > mysteer.xml
	cd ..
fi


if [ -d bin ] ; then
	echo "Already have  --bin-- folder for execute file"
else
	echo "no bin folder"
	mkdir bin 
	cp ${action_file_foler}/action ./bin/
fi

cd ./build

if [ -a "make.output"  ] ; then
	rm make.output
fi

echo "begin to config"
echo 
cmake -C $ILCSOFT/ILCSoft.cmake ..    &> make.output                                                                 
wait
echo "begin to make"
echo 
make &> make.output
wait
echo "begin to make install"
echo 
make install &> make.output
ERRORMESSAGE=$(grep "error" -irn ./make.output)
echo "check the error message"
echo 
echo ${ERRORMESSAGE} 

if [[ ${ERRORMESSAGE} != "" ]]; then
	echo 
	echo "Notice, Error found!"
	exit
else
	echo "no error, export processor to system..."
fi

cd ../

dll_test=` echo ${MARLIN_DLL} | grep "lib${new_processor}" `

echo "Check whether your Marlin processor has been written into .bashrc or not,  if you don't need that processor please delete them from .bashrc. " 
echo

if [[  $dll_test == ""  ]] ;then
	inform="dir=$DIR/../ \n PROJECTNAME=${PROJECTNAME}\n libname=$dir\"/lib/lib$PROJECTNAME\" \n export MARLIN_DLL=\${MARLIN_DLL}:\${libname}.so \n	echo \"install the lib to MARLIN_DLL ,  the lib is at  \${libname}.so\""
	echo -e $inform >> ${HOME}/.bashrc
	echo "now you should use \"source ~/.bashrc\" command to make your processor works."
else
	echo "The following is the keywords \"MARLIN_DLL\", Please check whether your processor is included! (Usually it is the last one)  if it is included, you can run Marlin with your processor now. " 
	echo ""
	echo ${MARLIN_DLL}
fi

echo 
echo "end"

