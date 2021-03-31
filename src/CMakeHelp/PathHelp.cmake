message(STATUS "include PathHelp.cmake")

function(FolderTra_GetFileAndDir result rootdir)
	file(GLOB all LIST_DIRECTORIES true ${rootdir}/*)
	set(${result} ${all} PARENT_SCOPE)
endfunction()

function(FolderTra_GetFile result rootdir)
	file(GLOB allfile LIST_DIRECTORIES false ${rootdir}/*)
	set(${result} ${allfile} PARENT_SCOPE)
endfunction()

function(FolderTra_GetDir result rootdir)
	file(GLOB all LIST_DIRECTORIES true ${rootdir}/*)
	foreach(fileordir ${all})
		if (IS_DIRECTORY ${fileordir})    
			LIST(APPEND alldir ${fileordir})
		endif()
	endforeach()
	set(${result} ${alldir} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetFileAndDir result rootdir)
	file(GLOB_RECURSE all LIST_DIRECTORIES true ${rootdir}/*)
	set(${result} ${all} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetFile result rootdir)
	file(GLOB_RECURSE allfile LIST_DIRECTORIES false ${rootdir}/*)
	set(${result} ${allfile} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetDir result rootdir)
	file(GLOB_RECURSE all LIST_DIRECTORIES true ${rootdir}/*)
	foreach(fileordir ${all})
		if (IS_DIRECTORY ${fileordir})    
			LIST(APPEND alldir ${fileordir})
		endif()
	endforeach()
	set(${result} ${alldir} PARENT_SCOPE)
endfunction()



function(FolderTra_GetCode result rootdir)
	file(GLOB allcode "${rootdir}/*.h" "${rootdir}/*.hpp" "${rootdir}/*.cpp" "${rootdir}/*.c" "${rootdir}/*.inl" "${rootdir}/*.ui" "${rootdir}/*.qrc")
	set(${result} ${allcode} PARENT_SCOPE)
endfunction()

function(FolderTraRCS_GetCode result rootdir)
	file(GLOB_RECURSE allcode "${rootdir}/*.h" "${rootdir}/*.hpp" "${rootdir}/*.cpp" "${rootdir}/*.c" "${rootdir}/*.inl" "${rootdir}/*.ui" "${rootdir}/*.qrc")
	set(${result} ${allcode} PARENT_SCOPE)
endfunction()

#递归rootdir，获得所有代码文件，保留文件树的目录结构，将代码组织到IDE的idedir文件夹下
function(SrcCodeGroupRCS rootdir idedir)
	message("\n")
	
	FolderTraRCS_GetDir(dirlist ${rootdir})
	
	message("\n")
	message("--------------SrcCodeGroupRCS-------------")
	foreach(dir ${dirlist})
		FolderTra_GetCode(dircode ${dir})
		list(LENGTH dircode len)
		string(REPLACE "${rootdir}" "" reldir ${dir})
		message("${dir}---------->IDE: ${idedir}${reldir}     ${len}")
		if (${len} STRGREATER 0)  
			source_group("${idedir}${reldir}" FILES ${dircode})
		endif()
	endforeach()
	message("\n")
	
endfunction()

#非递归rootdir，将rootdir当前目录下的代码文件组织到IDE中
function(SrcCodeGroup rootdir idedir)
	FolderTra_GetCode(dircode ${rootdir})
	list(LENGTH dircode len)
	if (${len} STRGREATER 0)  
		source_group(${idedir} FILES ${dircode})
	endif()
endfunction()

#递归rootdir文件夹，搜索CMakeLists.txt文件，对含有此文件的文件夹进行add_subdirectory，并使得build生成的文件保留rootdir下目录结构输出到gendir中
function(AddSubDirRCS rootdir buiiddir)
	
	message("\n")
	message("--------------AddSubDirRCS(Build)-------------")
	get_filename_component(rootdir_name ${rootdir} NAME)
	file(GLOB_RECURSE all LIST_DIRECTORIES true ${rootdir}/*)
	set(dirs "")
	foreach(fileordir ${all})
	if(IS_DIRECTORY ${fileordir} AND EXISTS "${fileordir}/CMakeLists.txt")
		list(APPEND dirs ${fileordir})
	endif()
	endforeach()
	foreach(dir ${dirs})
		string(REPLACE "${rootdir}" "" relativepath ${dir})
		add_subdirectory(${dir} "${buiiddir}/${rootdir_name}${relativepath}")
		message("${dir}---------->Build: ${buiiddir}/${rootdir_name}${relativepath}")
	endforeach()
	message("\n")
endfunction()

#相当于C++里面的多参数函数
function(AddTarget)
	# 设置三个必须的参数options ，oneValueArgs ， multiValueArgs
	# 每个参数后面可以是多个"标签"
	set(options LIB CUREXE CUREXE_AUTO_NAME_FOLDER)
    set(oneValueArgs NAME FOLDER)
    set(multiValueArgs CODERES LIBRES LIB_INCLUDE_DIRS)
	
	#设置参数前缀，区分多参数标签和正常字符串
	#                    |前缀| |option字符串|  |oneval字符串|   |multival字符串|  |固定结尾|
	cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	#然后通过:${前缀_标签}来取得输入的数据
	
	#func CUREXE
	#          |设置标签|                |    NAME对应数据|         |FOLDER对应数据|    |CODERES对应数据|                  |LIBRES对应数据|
	#AddTarget(CUREXE                          NAME "Demo"           FOLDER "Demo"       CODERES ${libcode}                 LIBRES LibName)
	#然后再函数内部 ${ARGS_CUREXE}=True    ${ARGS_CUREXE}="Demo"  ${ARGS_FOLDER}="Demo"     ${ARGS_CODERES}=${libcode}       ${ARGS_LIBRES}=LibName 

	#组织当前目录下的代码并生成EXE，需要输入CODERES："生成EXE所需的非当前目录下的代码"  LIBRES"生成EXE所需的库" NAME"EXE名" FOLDER"EXE在IDE中所在的目录"
	if(${ARGS_CUREXE})
		SrcCodeGroup(${CMAKE_CURRENT_SOURCE_DIR} "/")
		
		FolderTra_GetCode(curcode ${CMAKE_CURRENT_SOURCE_DIR})
		add_executable (${ARGS_NAME} ${curcode} ${ARGS_CODERES})
		target_link_libraries(${ARGS_NAME} ${ARGS_LIBRES})
		set_target_properties(${ARGS_NAME} PROPERTIES FOLDER ${ARGS_FOLDER})
	endif()
	
	#组织当前目录下的代码并生成EXE(自动完成NAME FOLDER属性填充)，需要输入CODERES："生成EXE所需的非当前目录下的代码"  LIBRES"生成EXE所需的库"
	#NAME填充为 执行AddTarget的CMakeList的所在文件夹名   FOLDER填充为CMake所在根目录树
	if(${ARGS_CUREXE_AUTO_NAME_FOLDER})
		get_filename_component(nowdir_name ${CMAKE_CURRENT_SOURCE_DIR} NAME)
		get_filename_component(nowdir_father ${CMAKE_CURRENT_SOURCE_DIR} DIRECTORY)
		string(REPLACE "${PROJECT_SOURCE_DIR_FATHER}" "" nowdir_roottree ${nowdir_father})
		
		SrcCodeGroup(${CMAKE_CURRENT_SOURCE_DIR} "/")
		
		FolderTra_GetCode(curcode ${CMAKE_CURRENT_SOURCE_DIR})
		add_executable (${nowdir_name} ${curcode} ${ARGS_CODERES})
		target_link_libraries(${nowdir_name} ${ARGS_LIBRES})
		set_target_properties(${nowdir_name} PROPERTIES FOLDER ${nowdir_roottree})
	endif()
	
	#生成LIB 需要输入CODERES LIBRES NAME FOLDER
	if(${ARGS_LIB})
		add_library (${ARGS_NAME} ${ARGS_CODERES})
		target_link_libraries(${ARGS_NAME} ${ARGS_LIBRES})
		set_target_properties(${ARGS_NAME} PROPERTIES FOLDER ${ARGS_FOLDER})
		#必须要加了这句，否则include无法用<>找到路径
		target_include_directories(${ARGS_NAME} PUBLIC ${ARGS_LIB_INCLUDE_DIRS})
	endif()
	
endfunction()


get_filename_component(PROJECT_SOURCE_DIR_FATHER ${PROJECT_SOURCE_DIR} DIRECTORY)
get_filename_component(PROJECT_BINARY_DIR_FATHER ${PROJECT_BINARY_DIR} DIRECTORY)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR_FATHER}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${PROJECT_BINARY_DIR_FATHER}/bin")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${PROJECT_BINARY_DIR_FATHER}/bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR_FATHER}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${PROJECT_BINARY_DIR_FATHER}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${PROJECT_BINARY_DIR_FATHER}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${PROJECT_BINARY_DIR_FATHER}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${PROJECT_BINARY_DIR_FATHER}/lib")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${PROJECT_BINARY_DIR_FATHER}/lib")

set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set_property(GLOBAL PROPERTY PREDEFINED_TARGETS_FOLDER "CMakePredefinedTargets")