@echo off

set deps=dependencies\
set build=Build-cmake
set buildConfig=Debug
set buildFolderPrefix=Build
set cmakeGppArg=
set gppArg=
set dmbBranch=dev

set argCount=0
for %%x in (%*) do (
	set /A argCount+=1
	if "%%~x" == "g++" (
		echo --- 'g++' option passed. Build with g++ compiler
		set cmakeGppArg= -DCMAKE_CXX_COMPILER=g++ -DCMAKE_C_COMPILER=gpp
		set gppArg= g++
		set buildFolderPrefix=Build-g++
	) else if "%%~x" == "no-log" (
		echo --- 'no-log' option passed. Turn off LOG_ON compile definition
		set cmakeLogOnArg=
	) else if "%%~x" == "release" (
		echo --- 'release' option passed. Use Release build type
		set buildConfig=Release
	)
)

set build=%buildFolderPrefix%-cmake

echo --- Build config: %buildConfig% ---
echo --- Check dependencies

IF not exist %deps% ( mkdir %deps% )
cd %deps%
	IF not exist DataModelBuilder (
		echo --- Clone DataModelBuilder library from GitHub
		git clone https://github.com/skalexey/DataModelBuilder.git --branch %dmbBranch%
	)
cd ..

echo --- Build SkillBuilder

if not exist %build% (
	mkdir %build%
	if %errorlevel% == 0 ( echo --- '%build%' directory created
	) else ( echo --- Error while creating '%build%' directory. Exit 
		goto end )
) else ( echo --- '%build%' directory already exists )

cd %build%

cmake -S .. -DCMAKE_BUILD_TYPE:STRING=%buildConfig% -DCMAKE_PREFIX_PATH="C:/Qt/6.2.1/msvc2019_64/lib/cmake"%cmakeGppArg%

if %errorlevel% neq 0 (
	echo --- CMake generation error: %errorlevel%
	goto end
)

echo --- Build SkillBuilder with CMake

cmake --build . --config=%buildConfig%

if %errorlevel% neq 0 (
	echo --- SkillBuilder CMake build error: %errorlevel%
	goto end
) else (
	echo --- SkillBuilder CMake build successfully completed
)
cd ..

:end
