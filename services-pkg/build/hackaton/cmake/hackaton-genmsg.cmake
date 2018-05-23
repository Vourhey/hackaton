# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "hackaton: 0 messages, 1 services")

set(MSG_I_FLAGS "-Istd_msgs:/nix/store/jli5azjw90zyyr2r5jgya2zy9110m586-std_msgs-0.5.11/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(hackaton_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv" NAME_WE)
add_custom_target(_hackaton_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${GENMSG_CHECK_DEPS_SCRIPT} "hackaton" "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv" ""
)

#
#  langs = gencpp;genpy
#

### Section generating for lang: gencpp
### Generating Messages

### Generating Services
_generate_srv_cpp(hackaton
  "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/hackaton
)

### Generating Module File
_generate_module_cpp(hackaton
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/hackaton
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(hackaton_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(hackaton_generate_messages hackaton_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv" NAME_WE)
add_dependencies(hackaton_generate_messages_cpp _hackaton_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(hackaton_gencpp)
add_dependencies(hackaton_gencpp hackaton_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS hackaton_generate_messages_cpp)

### Section generating for lang: genpy
### Generating Messages

### Generating Services
_generate_srv_py(hackaton
  "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton
)

### Generating Module File
_generate_module_py(hackaton
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(hackaton_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(hackaton_generate_messages hackaton_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/demo/hackaton/services-pkg/src/hackaton/srv/PublishToBC.srv" NAME_WE)
add_dependencies(hackaton_generate_messages_py _hackaton_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(hackaton_genpy)
add_dependencies(hackaton_genpy hackaton_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS hackaton_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/hackaton)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/hackaton
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(hackaton_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton)
  install(CODE "execute_process(COMMAND \"/nix/store/azw9ys2m2fpfzf730xjcxja890gpyp58-python3-3.6.4/bin/python\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton
    DESTINATION ${genpy_INSTALL_DIR}
    # skip all init files
    PATTERN "__init__.py" EXCLUDE
    PATTERN "__init__.pyc" EXCLUDE
  )
  # install init files which are not in the root folder of the generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton
    DESTINATION ${genpy_INSTALL_DIR}
    FILES_MATCHING
    REGEX "${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/hackaton/.+/__init__.pyc?$"
  )
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(hackaton_generate_messages_py std_msgs_generate_messages_py)
endif()
