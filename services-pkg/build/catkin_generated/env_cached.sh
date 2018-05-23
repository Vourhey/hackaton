#!/nix/store/zqh3l3lyw32q1ayb15bnvg9f24j5v2p0-bash-4.4-p12/bin/sh
# generated from catkin/cmake/templates/env.sh.in

if [ $# -eq 0 ] ; then
  /bin/echo "Usage: env.sh COMMANDS"
  /bin/echo "Calling env.sh without arguments is not supported anymore. Instead spawn a subshell and source a setup file manually."
  exit 1
fi

# ensure to not use different shell type which was set before
CATKIN_SHELL=sh

# source setup_cached.sh from same directory as this file
_CATKIN_SETUP_DIR=$(cd "`dirname "$0"`" > /dev/null && pwd)
. "$_CATKIN_SETUP_DIR/setup_cached.sh"
exec "$@"
