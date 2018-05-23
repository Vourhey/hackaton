# -*- coding: utf-8 -*-
from __future__ import print_function
import argparse
import os
import stat
import sys

# find the import for catkin's python package - either from source space or from an installed underlay
if os.path.exists(os.path.join('/nix/store/k3zhkq4s75ynis4hqiq6klib1wvy5cg5-catkin-0.7.11/share/catkin/cmake', 'catkinConfig.cmake.in')):
    sys.path.insert(0, os.path.join('/nix/store/k3zhkq4s75ynis4hqiq6klib1wvy5cg5-catkin-0.7.11/share/catkin/cmake', '..', 'python'))
try:
    from catkin.environment_cache import generate_environment_script
except ImportError:
    # search for catkin package in all workspaces and prepend to path
    for workspace in "/home/demo/ws/install;/nix/store/p3h3vcm9878kampb7lbirq62l970rzfw-robonomics_lighthouse-0.0;/nix/store/qz1diiqjnxw2yqg28pgqd9ycajhrd9z6-ros_comm-1.13.6;/nix/store/ml3zazw2qbhk762z3h8bc2q5bwdb9fwl-catkin-0.7.11;/nix/store/1drwnr147a08vbicylwjvi418sp1ldzf-message_filters-1.13.6;/nix/store/2nb4grs2x8dwxnfl1klr1lvmlsl10653-rosconsole-1.13.6;/nix/store/y6pmscmm54ylq3j3waa55d0xx5a3xnd4-cpp_common-0.6.9;/nix/store/rxv4d4p339vydvii9ykshfh164hld6m8-rosbuild-1.14.1;/nix/store/4jwzpfxbhkwc72nf449wwf4d5xycxxqp-message_generation-0.4.0;/nix/store/r8sr4x3ywwv7zk6ww54f53phx05wzanm-genmsg-0.5.10;/nix/store/pl9qf788d874dsqng1iwl937yajnxifb-gencpp-0.5.5;/nix/store/ilmi2kpy8hcw1yb5iik6dlhgxxb0x6cs-genpy-0.6.6;/nix/store/w8rc1qlx46i73ss9xsgfmlnk4m30l90z-message_runtime-0.4.12;/nix/store/ry1jpxgjwipfgf6w454kh4yiqk9k153s-roscpp_serialization-0.6.9;/nix/store/vi1q5i5yj6f7gsqs3lkfgq6an3lm1r2s-rostime-0.6.9;/nix/store/gl79x42g0kv6iw7f49sl20fbfrk5lj1n-roscpp_traits-0.6.9;/nix/store/pj3is2n1qbrq04313w1r2zsznfcbxiw0-rosunit-1.14.1;/nix/store/z2sh17wnlkn04vqdbz5ljxxjv6q75fvj-roslib-1.14.1;/nix/store/3186npfigdkhvdn4x4ph4vnbjkwbk223-rospack-2.4.4;/nix/store/z4q07k1wihjjahglgxd9pxd28kccf98k-cmake_modules-0.4.1;/nix/store/kxl4f13szgzlgrrnx98d5dmiy4jhbfcy-rostest-1.13.6;/nix/store/8crsw1rrgr8g6n0d1n9hnqn8r0wbzlf9-rosgraph-1.13.6;/nix/store/gw04741lajyqsnagwr5kxa7gp2m1lbc1-roslaunch-1.13.6;/nix/store/ppmx71pncr96zzrvbh682lz0869m546l-rosclean-1.14.1;/nix/store/c2sk817vwjfn0pywmxxv9ab5qyii0a7x-rosgraph_msgs-1.11.2;/nix/store/y9z70945cywf9wgc91frjsyc9rxm8vpf-std_msgs-0.5.11;/nix/store/h2wpvhw1f77ak6mc43wc3333yjbnbwx7-rosmaster-1.13.6;/nix/store/yv0lvix9nr2mmylyn14jpyv80nyb6ynv-rosout-1.13.6;/nix/store/a2d9hmq3wnw42c2x6bnjkjz27iag9342-roscpp-1.13.6;/nix/store/3bs81k9zzqvimxl6s9r3frscf5dg17yy-roslang-1.14.1;/nix/store/85s4h4w7wk5jf6n7xy36hw5wzb859vi0-xmlrpcpp-1.13.6;/nix/store/l39q2i4x0a5s8hkp8s6sjhi8qi1aisjl-rosparam-1.13.6;/nix/store/88j53ngi4afzz9l2m4xxj1gijh2csz6y-rospy-1.13.6;/nix/store/kijjbdi8syzpcka3yrwrbb66zzhqnay4-ros-1.14.1;/nix/store/dicy6vf873lyn1q6k9qqn2123y7nx3f8-rosbash-1.14.1;/nix/store/7xjslar9flqnysfn3qjhd4p8076xp4nc-rosboost_cfg-1.14.1;/nix/store/8nq17py87y0flkn86ha56wv7dwz2k95p-roscreate-1.14.1;/nix/store/1pfc9q723rr6h94vgdmy3ga4bgv1mnpl-rosmake-1.14.1;/nix/store/zapllp53y5x6bkwrfz0fijqpnhpaqn4g-rosbag-1.13.6;/nix/store/bzaj2wpma9sl2qgq3svmf3idx4hyrjir-rosbag_storage-1.13.6;/nix/store/fnpjz72j9nvi393s4in1p7kfa32cyy25-roslz4-1.13.6;/nix/store/mxy767kh19zy4xgxdxmkdj9dw93ihan1-std_srvs-1.11.2;/nix/store/l69n0xciv2cn1c4h2lw12spvl1vqf6q0-topic_tools-1.13.6;/nix/store/8ijv4xbhxgjz30948xpnpfahq7w7srkd-rosmsg-1.13.6;/nix/store/nsx53jj73dy8srhq66icmjxvqc4pima4-rosnode-1.13.6;/nix/store/4rfqbcsina7cha298h2vgr3110pjylxi-rostopic-1.13.6;/nix/store/mqdc0bhg7kf3i7n9ymc26l1y7dksl1ln-rosservice-1.13.6;/nix/store/3v2xfcw3h7xg52hlrd1512cm9km0k2k2-roswtf-1.13.6;/nix/store/f42shrfjxm4caaddxvyxwdfrblsypvmk-robonomics_control-0;/nix/store/4abn9zw2aw2pfwbvd3kzwdzdfaqy2lzw-robonomics_liability-0.0".split(';'):
        python_path = os.path.join(workspace, 'lib/python3.6/site-packages')
        if os.path.isdir(os.path.join(python_path, 'catkin')):
            sys.path.insert(0, python_path)
            break
    from catkin.environment_cache import generate_environment_script

code = generate_environment_script('/home/demo/hackaton/services-pkg/devel/env.sh')

output_filename = '/home/demo/hackaton/services-pkg/build/catkin_generated/setup_cached.sh'
with open(output_filename, 'w') as f:
    #print('Generate script for cached setup "%s"' % output_filename)
    f.write('\n'.join(code))

mode = os.stat(output_filename).st_mode
os.chmod(output_filename, mode | stat.S_IXUSR)
