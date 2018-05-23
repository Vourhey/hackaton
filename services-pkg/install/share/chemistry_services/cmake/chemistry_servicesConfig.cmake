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


if(chemistry_services_CONFIG_INCLUDED)
  return()
endif()
set(chemistry_services_CONFIG_INCLUDED TRUE)

# set variables for source/devel/install prefixes
if("FALSE" STREQUAL "TRUE")
  set(chemistry_services_SOURCE_PREFIX /home/demo/hackaton/services-pkg/src/chemistry_services)
  set(chemistry_services_DEVEL_PREFIX /home/demo/hackaton/services-pkg/devel)
  set(chemistry_services_INSTALL_PREFIX "")
  set(chemistry_services_PREFIX ${chemistry_services_DEVEL_PREFIX})
else()
  set(chemistry_services_SOURCE_PREFIX "")
  set(chemistry_services_DEVEL_PREFIX "")
  set(chemistry_services_INSTALL_PREFIX /home/demo/hackaton/services-pkg/install)
  set(chemistry_services_PREFIX ${chemistry_services_INSTALL_PREFIX})
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "WARNING: package 'chemistry_services' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  message("${_msg}")
endif()

# flag project as catkin-based to distinguish if a find_package()-ed project is a catkin project
set(chemistry_services_FOUND_CATKIN_PROJECT TRUE)

if(NOT "include " STREQUAL " ")
  set(chemistry_services_INCLUDE_DIRS "")
  set(_include_dirs "include")
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
      get_filename_component(include "${chemistry_services_DIR}/../../../include" ABSOLUTE)
      if(NOT IS_DIRECTORY ${include})
        message(FATAL_ERROR "Project 'chemistry_services' specifies '${idir}' as an include dir, which is not found.  It does not exist in '${include}'.  ${_report}")
      endif()
    else()
      message(FATAL_ERROR "Project 'chemistry_services' specifies '${idir}' as an include dir, which is not found.  It does neither exist as an absolute directory nor in '/home/demo/hackaton/services-pkg/install/${idir}'.  ${_report}")
    endif()
    _list_append_unique(chemistry_services_INCLUDE_DIRS ${include})
  endforeach()
endif()

set(libraries "")
foreach(library ${libraries})
  # keep build configuration keywords, target names and absolute libraries as-is
  if("${library}" MATCHES "^(debug|optimized|general)$")
    list(APPEND chemistry_services_LIBRARIES ${library})
  elseif(TARGET ${library})
    list(APPEND chemistry_services_LIBRARIES ${library})
  elseif(IS_ABSOLUTE ${library})
    list(APPEND chemistry_services_LIBRARIES ${library})
  else()
    set(lib_path "")
    set(lib "${library}-NOTFOUND")
    # since the path where the library is found is returned we have to iterate over the paths manually
    foreach(path /home/demo/hackaton/services-pkg/install/lib;/home/demo/chemistry-quality-control/services-pkg/install/lib;/nix/store/qkihjym2vgl71fhzrb2lj3ymq0lpx7hk-robonomics_lighthouse-0.0/lib;/nix/store/dd5lx3pn0zq9lsmanhhvx0xh19xgn8zd-ros_comm-1.13.6/lib;/nix/store/k3zhkq4s75ynis4hqiq6klib1wvy5cg5-catkin-0.7.11/lib;/nix/store/bc4gzxmh83rrac4q64k2mpjjapcpw2h8-message_filters-1.13.6/lib;/nix/store/zwfjq4w2vkmkddyma72y9iyzmiyfp033-rosconsole-1.13.6/lib;/nix/store/bw5a2xcycdbl9amidifzfl6iamb80jd9-cpp_common-0.6.9/lib;/nix/store/cgqcx28b318rzf4pwv5dwmp2zbax5x86-rosbuild-1.14.1/lib;/nix/store/6djpsfp03hvvbzs82fc94b6a0zrpmb90-message_generation-0.4.0/lib;/nix/store/8x6l8x6fxzmh2i0fzw0pcn5c5i2jr2dk-genmsg-0.5.10/lib;/nix/store/zs6hxm9pv20lyl9chkrzcxczxz82m7nv-gencpp-0.5.5/lib;/nix/store/mjjafwgywyx8jaxgxj8a3k8zdfp0icn7-genpy-0.6.6/lib;/nix/store/2ihz3fk8n42mipj833j8n4d0x23z494m-message_runtime-0.4.12/lib;/nix/store/lg6v3ms85ax9psf7clygdpbgi172b58c-roscpp_serialization-0.6.9/lib;/nix/store/rndpp7flgi93qd3gwsbwhj0cbvzdqxhh-rostime-0.6.9/lib;/nix/store/n23063j21zhdkkrwgkaz15khipgrrdj5-roscpp_traits-0.6.9/lib;/nix/store/7412psx4abq50hz3jwnpdz4yklc6afm5-rosunit-1.14.1/lib;/nix/store/mwhpydbhhlp5h5754kpjkv7sa38fq91h-roslib-1.14.1/lib;/nix/store/ahifn31bwwnjjidvxg3jkx08gfbjgp70-rospack-2.4.4/lib;/nix/store/d3bp1i28srj31czd6vfqim5znrpqbfw4-cmake_modules-0.4.1/lib;/nix/store/zfnvq1lv14pcnqcw9x72pkbc0siiaidg-rostest-1.13.6/lib;/nix/store/lml1ixfgb0sdhijgrkinl9wgi3zgcakq-rosgraph-1.13.6/lib;/nix/store/829qk1c0w799f0nyxkhi6llmxq2s0nhx-roslaunch-1.13.6/lib;/nix/store/zmfcswl7y3q10kmm8n4ppmrzpx0wzq5l-rosclean-1.14.1/lib;/nix/store/xfvv8gfmkzmf24knq7yh8x5nzm27f9zn-rosgraph_msgs-1.11.2/lib;/nix/store/jli5azjw90zyyr2r5jgya2zy9110m586-std_msgs-0.5.11/lib;/nix/store/9581g2ckpyjm5ingc1hahan5469lsz26-rosmaster-1.13.6/lib;/nix/store/qm11zjhkb2dp5izbf3izcrz1wgziwmdg-rosout-1.13.6/lib;/nix/store/bzga4imscbmwcm8ffwp6crvqr8ns07bg-roscpp-1.13.6/lib;/nix/store/8xvrhpzxmsgsmawh9dk8b8c4rl3a90w6-roslang-1.14.1/lib;/nix/store/sgvqn31x7g4480z3q1968rxappjrwdlj-xmlrpcpp-1.13.6/lib;/nix/store/nal34a3k9yvl60ck5hana4gki49pip6k-rosparam-1.13.6/lib;/nix/store/cywmq1ssm59v8xfarr335a5fvdyvbqck-rospy-1.13.6/lib;/nix/store/mlhdr0zhxgnc26dabw8k8qysd1irc9qb-ros-1.14.1/lib;/nix/store/vs8mkgchap4rv0jxpzay5r6dw0vnm7qz-rosbash-1.14.1/lib;/nix/store/571a3ncp31qfmp6h68rhnb7sg42r72dc-rosboost_cfg-1.14.1/lib;/nix/store/fjn5jv3f52ssa3sfkzhq5lqp0f76w1s7-roscreate-1.14.1/lib;/nix/store/y4giw0brrjg1zg856ihqbj7s8swix0rd-rosmake-1.14.1/lib;/nix/store/7gg5d272bpnad5flzpaf228rk9nz1aq3-rosbag-1.13.6/lib;/nix/store/6v00jvwaybcwi0cag9vaj63fvz113dvs-rosbag_storage-1.13.6/lib;/nix/store/0yz2n4khrf1vyrbpfyxxpfpkss2knacv-roslz4-1.13.6/lib;/nix/store/ib1ps0vvdrxxdaakaazyaid7vhmbgd7i-std_srvs-1.11.2/lib;/nix/store/sr46cqsfxhyvqj426bl1945cn6rvx3w0-topic_tools-1.13.6/lib;/nix/store/af3bqrjrvbi74fz5yijwynykzwhc2acm-rosmsg-1.13.6/lib;/nix/store/c3vypg01h4mn5zz3zj0nlm8y5ajx9vh2-rosnode-1.13.6/lib;/nix/store/wdb4a5j7clsiivmqx0gvsc8qdfcqcbfh-rostopic-1.13.6/lib;/nix/store/ijb4vd2micadzhd584f68z5z12yijvwv-rosservice-1.13.6/lib;/nix/store/6j7iygiw6pj5pdn9g7h3c0fydm7cvip0-roswtf-1.13.6/lib;/nix/store/hgb4gbcgb2dd3hnbbpngghfw33j845hy-robonomics_control-0/lib;/nix/store/khqwgi07p4hcy477vb9ylcwb0j09cq4j-robonomics_liability-0.0/lib)
      find_library(lib ${library}
        PATHS ${path}
        NO_DEFAULT_PATH NO_CMAKE_FIND_ROOT_PATH)
      if(lib)
        set(lib_path ${path})
        break()
      endif()
    endforeach()
    if(lib)
      _list_append_unique(chemistry_services_LIBRARY_DIRS ${lib_path})
      list(APPEND chemistry_services_LIBRARIES ${lib})
    else()
      # as a fall back for non-catkin libraries try to search globally
      find_library(lib ${library})
      if(NOT lib)
        message(FATAL_ERROR "Project '${PROJECT_NAME}' tried to find library '${library}'.  The library is neither a target nor built/installed properly.  Did you compile project 'chemistry_services'?  Did you find_package() it before the subdirectory containing its code is included?")
      endif()
      list(APPEND chemistry_services_LIBRARIES ${lib})
    endif()
  endif()
endforeach()

set(chemistry_services_EXPORTED_TARGETS "chemistry_services_generate_messages_cpp;chemistry_services_generate_messages_py")
# create dummy targets for exported code generation targets to make life of users easier
foreach(t ${chemistry_services_EXPORTED_TARGETS})
  if(NOT TARGET ${t})
    add_custom_target(${t})
  endif()
endforeach()

set(depends "")
foreach(depend ${depends})
  string(REPLACE " " ";" depend_list ${depend})
  # the package name of the dependency must be kept in a unique variable so that it is not overwritten in recursive calls
  list(GET depend_list 0 chemistry_services_dep)
  list(LENGTH depend_list count)
  if(${count} EQUAL 1)
    # simple dependencies must only be find_package()-ed once
    if(NOT ${chemistry_services_dep}_FOUND)
      find_package(${chemistry_services_dep} REQUIRED NO_MODULE)
    endif()
  else()
    # dependencies with components must be find_package()-ed again
    list(REMOVE_AT depend_list 0)
    find_package(${chemistry_services_dep} REQUIRED NO_MODULE ${depend_list})
  endif()
  _list_append_unique(chemistry_services_INCLUDE_DIRS ${${chemistry_services_dep}_INCLUDE_DIRS})

  # merge build configuration keywords with library names to correctly deduplicate
  _pack_libraries_with_build_configuration(chemistry_services_LIBRARIES ${chemistry_services_LIBRARIES})
  _pack_libraries_with_build_configuration(_libraries ${${chemistry_services_dep}_LIBRARIES})
  _list_append_deduplicate(chemistry_services_LIBRARIES ${_libraries})
  # undo build configuration keyword merging after deduplication
  _unpack_libraries_with_build_configuration(chemistry_services_LIBRARIES ${chemistry_services_LIBRARIES})

  _list_append_unique(chemistry_services_LIBRARY_DIRS ${${chemistry_services_dep}_LIBRARY_DIRS})
  list(APPEND chemistry_services_EXPORTED_TARGETS ${${chemistry_services_dep}_EXPORTED_TARGETS})
endforeach()

set(pkg_cfg_extras "chemistry_services-msg-extras.cmake")
foreach(extra ${pkg_cfg_extras})
  if(NOT IS_ABSOLUTE ${extra})
    set(extra ${chemistry_services_DIR}/${extra})
  endif()
  include(${extra})
endforeach()
