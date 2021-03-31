cmake_minimum_required (VERSION 3.1)

project (RGame_Proj)
set(CMAKE_CXX_STANDARD 17)
include("CMakeHelp/PathHelp.cmake")
include("CMakeHelp/Qt5Help.cmake")

#1.依赖库扫描
FolderTra_GetDir(depslibdirlist "${PROJECT_SOURCE_DIR_FATHER}/deps")
message("\n")
message("---------Deps Lib:---------")
foreach(libpath ${depslibdirlist})
	get_filename_component(libname ${libpath} NAME)
	list(APPEND depslibnames ${libname})
	message("${libname}")
endforeach()
message("\n")

#2.依赖库编译
AddSubDirRCS("${PROJECT_SOURCE_DIR_FATHER}/deps" "${PROJECT_BINARY_DIR_FATHER}")

#3.源代码
FolderTraRCS_GetCode(libcode "${CMAKE_CURRENT_LIST_DIR}")

#4.Qt库和代码编译，并添加到依赖库（1）和总体源代码中（3）
find_package(Qt5Widgets)  
find_package(Qt5Core)
find_package(Qt5Gui)
list(APPEND depslibnames Qt5::Widgets Qt5::Core Qt5::Gui)

QT5_WRAP_UI_DIY(genheader UIDIR "${CMAKE_CURRENT_LIST_DIR}/Ui/UiFile" OUTDIR "${CMAKE_CURRENT_LIST_DIR}/Ui/GenCode/UiHeader")
list(APPEND libcode ${genheader})
QT5_WRAP_CPP_DIY(genmoc HEADERDIR "${CMAKE_CURRENT_LIST_DIR}/Ui/Include" OUTDIR "${CMAKE_CURRENT_LIST_DIR}/Ui/GenCode/Moc")
list(APPEND libcode ${genmoc})
source_group("/Ui/GenCode/UiHeader" FILES ${genheader})
source_group("/Ui/GenCode/Moc" FILES ${genmoc})

#5.文件组织/EXE生成
SrcCodeGroupRCS("${CMAKE_CURRENT_LIST_DIR}" "")
AddTarget(CUREXE NAME "Demo" FOLDER "Demo" CODERES ${libcode} LIBRES ${depslibnames})

#6.Qt DLL 复制
add_custom_command(TARGET Demo POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Qt5::Core> $<TARGET_FILE_DIR:Demo>
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Qt5::Gui> $<TARGET_FILE_DIR:Demo>
    COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Qt5::Widgets> $<TARGET_FILE_DIR:Demo>
	COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:Qt5::QWindowsIntegrationPlugin> $<TARGET_FILE_DIR:Demo>/platforms/$<TARGET_FILE_NAME:Qt5::QWindowsIntegrationPlugin>
    )

#7.测试程序编译
AddSubDirRCS("${PROJECT_SOURCE_DIR_FATHER}/test" "${PROJECT_BINARY_DIR_FATHER}")
