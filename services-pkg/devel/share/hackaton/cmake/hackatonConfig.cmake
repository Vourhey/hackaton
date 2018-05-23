# generated from catkin/cmake/template/pkgConfig.cmake.in

# append elements to a list and remove existing duplicates from the list
# copied from catkin/cmake/list_append_deduplicate.cmake to keep pkgConfig
# self contained
macro(_list_append_deduplicate listname)
  if(NOT "${ARGN}" STREQUAL "")
    if(${listname})
      list(REMOVE_ITEM ${listname} ${ARGN})
    endif()
    list(APPEND ${listname} ${ARGN})
  endif()
endmacro()

# append elements to a list if they are not already in the list
# copied from catkin/cmake/list_append_unique.cmake to keep pkgConfig
# self contained
macro(_list_append_unique listname)
  foreach(_item ${ARGN})
    list(FIND ${listname} ${_item} _index)
    if(_index EQUAL -1)
      list(APPEND ${listname} ${_item})
    endif()
  endforeach()
endmacro()

# pack a list of libraries with optional build configuration keywords
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_pack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  set(_argn ${ARGN})
  list(LENGTH _argn _count)
  set(_index 0)
  while(${_index} LESS ${_count})
    list(GET _argn ${_index} lib)
    if("${lib}" MATCHES "^(debug|optimized|general)$")
      math(EXPR _index "${_index} + 1")
      if(${_index} EQUAL ${_count})
        message(FATAL_ERROR "_pack_libraries_with_build_configuration() the list of libraries '${ARGN}' ends with '${lib}' which is a build configuration keyword and must be followed by a library")
      endif()
      list(GET _argn ${_index} library)
      list(APPEND ${VAR} "${lib}${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}${library}")
    else()
      list(APPEND ${VAR} "${lib}")
    endif()
    math(EXPR _index "${_index} + 1")
  endwhile()
endmacro()

# unpack a list of libraries with optional build configuration keyword prefixes
# copied from catkin/cmake/catkin_libraries.cmake to keep pkgConfig
# self contained
macro(_unpack_libraries_with_build_configuration VAR)
  set(${VAR} "")
  foreach(lib ${ARGN})
    string(REGEX REPLACE "^(debug|optimized|general)${CATKIN_BUILD_CONFIGURATION_KEYWORD_SEPARATOR}(.+)$" "\\1;\\2" lib "${lib}")
    list(APPEND ${VAR} "${lib}")
  endforeach()
endmacro()


if(hackaton_CONFIG_INCLUDED)
  return()
endif()
set(hackaton_CONFIG_INCLUDED TRUE)

# set variables for source/devel/install prefixes
if("TRUE" STREQUAL "TRUE")
  set(hackaton_SOURCE_PREFIX /home/demo/hackaton/services-pkg/src/hackaton)
  set(hackaton_DEVEL_PREFIX /home/demo/hackaton/services-pkg/devel)
  set(hackaton_INSTALL_PREFIX "")
  set(hackaton_PREFIX ${hackaton_DEVEL_PREFIX})
else()
  set(hackaton_SOURCE_PREFIX "")
  set(hackaton_DEVEL_PREFIX "")
  set(hackaton_INSTALL_PREFIX /home/demo/hackaton/services-pkg/install)
  set(hackaton_PREFIX ${hackaton_INSTALL_PREFIX})
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "WARNING: package 'hackaton' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  message("${_msg}")
endif()

# flag project as catkin-based to distinguish if a find_package()-ed project is a catkin project
set(hackaton_FOUND_CATKIN_PROJECT TRUE)

if(NOT "/home/demo/hackaton/services-pkg/devel/include " STREQUAL " ")
  set(hackaton_INCLUDE_DIRS "")
  set(_include_dirs "/home/demo/hackaton/services-pkg/devel/include")
  if(NOT " " STREQUAL " ")
    set(_report "Check the issue tracker '' and consider creating a ticket if the problem has not been reported yet.")
  elseif(NOT " " STREQUAL " ")
    set(_report "Check the website '' for information and consider reporting the problem.")
  else()
    set(_report "Report the problem to the maintainer 'Vadim Manaenko <vadim.razorq@gmail.com>' and request to fix the problem.")
  endif()
  foreach(idir ${_include_dirs})
    if(IS_ABSOLUTE ${idir} AND IS_DIRECTORY ${idir})
      set(include ${idir})
    elseif("${idir} " STREQUAL "include ")
      get_filename_component(include "${hackaton_DIR}/../../../include" ABSOLUTE)
      if(NOT IS_DIRECTORY ${include})
        message(FATAL_ERROR "Project 'hackaton' specifies '${idir}' as an include dir, which is not found.  It does not exist in '${include}'.  ${_report}")
      endif()
    else()
      message(FATAL_ERROR "Project 'hackaton' specifies '${idir}' as an include dir, which is not found.  It does neither exist as an absolute directory nor in '/home/demo/hackaton/services-pkg/src/hackaton/${idir}'.  ${_report}")
    endif()
    _list_append_unique(hackaton_INCLUDE_DIRS ${include})
  endforeach()
endif()

set(libraries "")
foreach(library ${libraries})
  # keep build configuration keywords, target names and absolute libraries as-is
  if("${library}" MATCHES "^(debug|optimized|general)$")
    list(APPEND hackaton_LIBRARIES ${library})
  elseif(TARGET ${library})
    list(APPEND hackaton_LIBRARIES ${library})
  elseif(IS_ABSOLUTE ${library})
    list(APPEND hackaton_LIBRARIES ${library})
  else()
    set(lib_path "")
    set(lib "${library}-NOTFOUND")
    # since the path where the library is found is returned we have to iterate over the paths manually
    foreach(path /home/demo/hackaton/services-pkg/devel/lib;/home/demo/ws/install/lib;/nix/store/p3h3vcm9878kampb7lbirq62l970rzfw-robonomics_lighthouse-0.0/lib;/nix/store/qz1diiqjnxw2yqg28pgqd9ycajhrd9z6-ros_comm-1.13.6/lib;/nix/store/ml3zazw2qbhk762z3h8bc2q5bwdb9fwl-catkin-0.7.11/lib;/nix/store/1drwnr147a08vbicylwjvi418sp1ldzf-message_filters-1.13.6/lib;/nix/store/2nb4grs2x8dwxnfl1klr1lvmlsl10653-rosconsole-1.13.6/lib;/nix/store/y6pmscmm54ylq3j3waa55d0xx5a3xnd4-cpp_common-0.6.9/lib;/nix/store/rxv4d4p339vydvii9ykshfh164hld6m8-rosbuild-1.14.1/lib;/nix/store/4jwzpfxbhkwc72nf449wwf4d5xycxxqp-message_generation-0.4.0/lib;/nix/store/r8sr4x3ywwv7zk6ww54f53phx05wzanm-genmsg-0.5.10/lib;/nix/store/pl9qf788d874dsqng1iwl937yajnxifb-gencpp-0.5.5/lib;/nix/store/ilmi2kpy8hcw1yb5iik6dlhgxxb0x6cs-genpy-0.6.6/lib;/nix/store/w8rc1qlx46i73ss9xsgfmlnk4m30l90z-message_runtime-0.4.12/lib;/nix/store/ry1jpxgjwipfgf6w454kh4yiqk9k153s-roscpp_serialization-0.6.9/lib;/nix/store/vi1q5i5yj6f7gsqs3lkfgq6an3lm1r2s-rostime-0.6.9/lib;/nix/store/gl79x42g0kv6iw7f49sl20fbfrk5lj1n-roscpp_traits-0.6.9/lib;/nix/store/pj3is2n1qbrq04313w1r2zsznfcbxiw0-rosunit-1.14.1/lib;/nix/store/z2sh17wnlkn04vqdbz5ljxxjv6q75fvj-roslib-1.14.1/lib;/nix/store/3186npfigdkhvdn4x4ph4vnbjkwbk223-rospack-2.4.4/lib;/nix/store/z4q07k1wihjjahglgxd9pxd28kccf98k-cmake_modules-0.4.1/lib;/nix/store/kxl4f13szgzlgrrnx98d5dmiy4jhbfcy-rostest-1.13.6/lib;/nix/store/8crsw1rrgr8g6n0d1n9hnqn8r0wbzlf9-rosgraph-1.13.6/lib;/nix/store/gw04741lajyqsnagwr5kxa7gp2m1lbc1-roslaunch-1.13.6/lib;/nix/store/ppmx71pncr96zzrvbh682lz0869m546l-rosclean-1.14.1/lib;/nix/store/c2sk817vwjfn0pywmxxv9ab5qyii0a7x-rosgraph_msgs-1.11.2/lib;/nix/store/y9z70945cywf9wgc91frjsyc9rxm8vpf-std_msgs-0.5.11/lib;/nix/store/h2wpvhw1f77ak6mc43wc3333yjbnbwx7-rosmaster-1.13.6/lib;/nix/store/yv0lvix9nr2mmylyn14jpyv80nyb6ynv-rosout-1.13.6/lib;/nix/store/a2d9hmq3wnw42c2x6bnjkjz27iag9342-roscpp-1.13.6/lib;/nix/store/3bs81k9zzqvimxl6s9r3frscf5dg17yy-roslang-1.14.1/lib;/nix/store/85s4h4w7wk5jf6n7xy36hw5wzb859vi0-xmlrpcpp-1.13.6/lib;/nix/store/l39q2i4x0a5s8hkp8s6sjhi8qi1aisjl-rosparam-1.13.6/lib;/nix/store/88j53ngi4afzz9l2m4xxj1gijh2csz6y-rospy-1.13.6/lib;/nix/store/kijjbdi8syzpcka3yrwrbb66zzhqnay4-ros-1.14.1/lib;/nix/store/dicy6vf873lyn1q6k9qqn2123y7nx3f8-rosbash-1.14.1/lib;/nix/store/7xjslar9flqnysfn3qjhd4p8076xp4nc-rosboost_cfg-1.14.1/lib;/nix/store/8nq17py87y0flkn86ha56wv7dwz2k95p-roscreate-1.14.1/lib;/nix/store/1pfc9q723rr6h94vgdmy3ga4bgv1mnpl-rosmake-1.14.1/lib;/nix/store/zapllp53y5x6bkwrfz0fijqpnhpaqn4g-rosbag-1.13.6/lib;/nix/store/bzaj2wpma9sl2qgq3svmf3idx4hyrjir-rosbag_storage-1.13.6/lib;/nix/store/fnpjz72j9nvi393s4in1p7kfa32cyy25-roslz4-1.13.6/lib;/nix/store/mxy767kh19zy4xgxdxmkdj9dw93ihan1-std_srvs-1.11.2/lib;/nix/store/l69n0xciv2cn1c4h2lw12spvl1vqf6q0-topic_tools-1.13.6/lib;/nix/store/8ijv4xbhxgjz30948xpnpfahq7w7srkd-rosmsg-1.13.6/lib;/nix/store/nsx53jj73dy8srhq66icmjxvqc4pima4-rosnode-1.13.6/lib;/nix/store/4rfqbcsina7cha298h2vgr3110pjylxi-rostopic-1.13.6/lib;/nix/store/mqdc0bhg7kf3i7n9ymc26l1y7dksl1ln-rosservice-1.13.6/lib;/nix/store/3v2xfcw3h7xg52hlrd1512cm9km0k2k2-roswtf-1.13.6/lib;/nix/store/f42shrfjxm4caaddxvyxwdfrblsypvmk-robonomics_control-0/lib;/nix/store/4abn9zw2aw2pfwbvd3kzwdzdfaqy2lzw-robonomics_liability-0.0/lib)
      find_library(lib ${library}
        PATHS ${path}
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
      if(lib)
        set(lib_path ${path})
        break()
      endif()
    endforeach()
    if(lib)
      _list_append_unique(hackaton_LIBRARY_DIRS ${lib_path})
      list(APPEND hackaton_LIBRARIES ${lib})
    else()
      # as a fall back for non-catkin libraries try to search globally
      find_library(lib ${library})
      if(NOT lib)
        message(FATAL_ERROR "Project '${PROJECT_NAME}' tried to find library '${library}'.  The library is neither a target nor built/installed properly.  Did you compile project 'hackaton'?  Did you find_package() it before the subdirectory containing its code is included?")
      endif()
      list(APPEND hackaton_LIBRARIES ${lib})
    endif()
  endif()
endforeach()

set(hackaton_EXPORTED_TARGETS "hackaton_generate_messages_cpp;hackaton_generate_messages_py")
# create dummy targets for exported code generation targets to make life of users easier
foreach(t ${hackaton_EXPORTED_TARGETS})
  if(NOT TARGET ${t})
    add_custom_target(${t})
  endif()
endforeach()

set(depends "")
foreach(depend ${depends})
  string(REPLACE " " ";" depend_list ${depend})
  # the package name of the dependency must be kept in a unique variable so that it is not overwritten in recursive calls
  list(GET depend_list 0 hackaton_dep)
  list(LENGTH depend_list count)
  if(${count} EQUAL 1)
    # simple dependencies must only be find_package()-ed once
    if(NOT ${hackaton_dep}_FOUND)
      find_package(${hackaton_dep} REQUIRED NO_MODULE)
    endif()
  else()
    # dependencies with components must be find_package()-ed again
    list(REMOVE_AT depend_list 0)
    find_package(${hackaton_dep} REQUIRED NO_MODULE ${depend_list})
  endif()
  _list_append_unique(hackaton_INCLUDE_DIRS ${${hackaton_dep}_INCLUDE_DIRS})

  # merge build configuration keywords with library names to correctly deduplicate
  _pack_libraries_with_build_configuration(hackaton_LIBRARIES ${hackaton_LIBRARIES})
  _pack_libraries_with_build_configuration(_libraries ${${hackaton_dep}_LIBRARIES})
  _list_append_deduplicate(hackaton_LIBRARIES ${_libraries})
  # undo build configuration keyword merging after deduplication
  _unpack_libraries_with_build_configuration(hackaton_LIBRARIES ${hackaton_LIBRARIES})

  _list_append_unique(hackaton_LIBRARY_DIRS ${${hackaton_dep}_LIBRARY_DIRS})
  list(APPEND hackaton_EXPORTED_TARGETS ${${hackaton_dep}_EXPORTED_TARGETS})
endforeach()

set(pkg_cfg_extras "hackaton-msg-extras.cmake")
foreach(extra ${pkg_cfg_extras})
  if(NOT IS_ABSOLUTE ${extra})
    set(extra ${hackaton_DIR}/${extra})
  endif()
  include(${extra})
endforeach()
