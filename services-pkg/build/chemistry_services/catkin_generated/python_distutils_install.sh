#!/nix/store/zqh3l3lyw32q1ayb15bnvg9f24j5v2p0-bash-4.4-p12/bin/sh

if [ -n "$DESTDIR" ] ; then
    case $DESTDIR in
        /*) # ok
            ;;
        *)
            /bin/echo "DESTDIR argument must be absolute... "
            /bin/echo "otherwise python's distutils will bork things."
            exit 1
    esac
    DESTDIR_ARG="--root=$DESTDIR"
fi

echo_and_run() { echo "+ $@" ; "$@" ; }

echo_and_run cd "/home/demo/hackaton/services-pkg/src/chemistry_services"

# ensure that Python install destination exists
echo_and_run mkdir -p "$DESTDIR/home/demo/hackaton/services-pkg/install/lib/python3.6/site-packages"

# Note that PYTHONPATH is pulled from the environment to support installing
# into one location when some dependencies were installed in another
# location, #123.
echo_and_run /usr/bin/env \
    PYTHONPATH="/home/demo/hackaton/services-pkg/install/lib/python3.6/site-packages:/home/demo/hackaton/services-pkg/build/lib/python3.6/site-packages:$PYTHONPATH" \
    CATKIN_BINARY_DIR="/home/demo/hackaton/services-pkg/build" \
    "/nix/store/azw9ys2m2fpfzf730xjcxja890gpyp58-python3-3.6.4/bin/python" \
    "/home/demo/hackaton/services-pkg/src/chemistry_services/setup.py" \
    build --build-base "/home/demo/hackaton/services-pkg/build/chemistry_services" \
    install \
    $DESTDIR_ARG \
     --prefix="/home/demo/hackaton/services-pkg/install" --install-scripts="/home/demo/hackaton/services-pkg/install/bin"
