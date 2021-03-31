message(STATUS "include Qt5Help.cmake")

function(FolderTraRCS_GetUi result rootdir)
	file(GLOB_RECURSE allcode "${rootdir}/*.ui")
	set(${result} ${allcode} PARENT_SCOPE)
endfunction()

#Source Code From .../Qt/Qt5.12.2/5.12.2/winrt_x64_msvc2017/lib/cmake/Qt5Widgets/Qt5WidgetsMacros   QT5_WRAP_UI
#How to Use: QT5_WRAP_UI_DIY(<filelist>(return) UIDIR <.ui dir> OUTDIR <gen .h dir>)
function(QT5_WRAP_UI_DIY outfiles )

    set(options)
    set(oneValueArgs UIDIR OUTDIR)
    set(multiValueArgs OPTIONS)
	
	cmake_parse_arguments(_WRAP_UI "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
	
	set(ui_rootdir ${_WRAP_UI_UIDIR})
    set(ui_options ${_WRAP_UI_OPTIONS})
	set(ui_outdir ${_WRAP_UI_OUTDIR})
	
	FolderTraRCS_GetUi(ui_files ${ui_rootdir})
	
	message("\n")
	message("--------------QT5_WRAP_UI_DIY-------------")
    foreach(it ${ui_files})
		
		get_filename_component(dir ${it} DIRECTORY)
		string(REPLACE "${ui_rootdir}" "" reldir ${dir})
		get_filename_component(filename ${it} NAME_WE)
		
        get_filename_component(infile ${it} ABSOLUTE)
		message("${it}---------->Gen: ${ui_outdir}${reldir}/ui_${filename}.h")
        set(outfile "${ui_outdir}${reldir}/ui_${filename}.h")
		
        add_custom_command(OUTPUT ${outfile}
          COMMAND ${Qt5Widgets_UIC_EXECUTABLE}
          ARGS ${ui_options} -o ${outfile} ${infile}
          MAIN_DEPENDENCY ${infile} VERBATIM)
        set_source_files_properties(${infile} PROPERTIES SKIP_AUTOUIC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOMOC ON)
        set_source_files_properties(${outfile} PROPERTIES SKIP_AUTOUIC ON)
        list(APPEND ${outfiles} ${outfile})
		
    endforeach()
	message("\n")
    set(${outfiles} ${${outfiles}} PARENT_SCOPE)
	
endfunction()


#Source Code From .../Qt/Qt5.12.2/5.12.2/winrt_x64_msvc2017/lib/cmake/Qt5Core/Qt5CoreMacros.cmake   QT5_WRAP_CPP
#How to Use: QT5_WRAP_CPP_DIY(<filelist>(return) HEADERDIR <.h dir> OUTDIR <gen .cpp dir>)
function(QT5_WRAP_CPP_DIY outfiles )

    # get include dirs
    qt5_get_moc_flags(moc_flags)

    set(options)
    set(oneValueArgs TARGET HEADERDIR CPPDIR OUTDIR)
    set(multiValueArgs OPTIONS DEPENDS)

    cmake_parse_arguments(_WRAP_CPP "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(moc_options ${_WRAP_CPP_OPTIONS})
    set(moc_target ${_WRAP_CPP_TARGET})
    set(moc_depends ${_WRAP_CPP_DEPENDS})
	
	set(moc_headerdir ${_WRAP_CPP_HEADERDIR})
	set(moc_outdir ${_WRAP_CPP_OUTDIR})
	FolderTraRCS_GetCode(moc_files ${moc_headerdir})
	
	message("\n")
	message("--------------QT5_WRAP_CPP_DIY-------------")
    foreach(it ${moc_files})
	
		get_filename_component(dir ${it} DIRECTORY)
		string(REPLACE "${moc_headerdir}" "" reldir ${dir})
        
		get_filename_component(it ${it} ABSOLUTE)
        qt5_make_output_file(${it} moc_ cpp outfile)
		get_filename_component(filename ${outfile} NAME)
		
		message("${it}---------->Gen: ${moc_outdir}${reldir}/${filename}")
		set(outfile "${moc_outdir}${reldir}/${filename}")
		
        qt5_create_moc_command(${it} ${outfile} "${moc_flags}" "${moc_options}" "${moc_target}" "${moc_depends}")
        list(APPEND cppfiles ${outfile})
		
    endforeach()
	message("\n")
	
	
    set(${outfiles} ${cppfiles} PARENT_SCOPE)
	
endfunction()