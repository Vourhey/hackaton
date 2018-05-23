#!/nix/store/azw9ys2m2fpfzf730xjcxja890gpyp58-python3-3.6.4/bin/python
# -*- coding: utf-8 -*-

# Software License Agreement (BSD License)
#
# Copyright (c) 2012, Willow Garage, Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above
#    copyright notice, this list of conditions and the following
#    disclaimer in the documentation and/or other materials provided
#    with the distribution.
#  * Neither the name of Willow Garage, Inc. nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
# ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

'''This file generates shell code for the setup.SHELL scripts to set environment variables'''

from __future__ import print_function
import argparse
import copy
import errno
import os
import platform
import sys

CATKIN_MARKER_FILE = '.catkin'

system = platform.system()
IS_DARWIN = (system == 'Darwin')
IS_WINDOWS = (system == 'Windows')

# subfolder of workspace prepended to CMAKE_PREFIX_PATH
ENV_VAR_SUBFOLDERS = {
    'CMAKE_PREFIX_PATH': '',
    'LD_LIBRARY_PATH' if not IS_DARWIN else 'DYLD_LIBRARY_PATH': 'lib',
    'PATH': 'bin',
    'PKG_CONFIG_PATH': os.path.join('lib', 'pkgconfig'),
    'PYTHONPATH': 'lib/python3.6/site-packages',
}


def rollback_env_variables(environ, env_var_subfolders):
    '''
    Generate shell code to reset environment variables
    by unrolling modifications based on all workspaces in CMAKE_PREFIX_PATH.
    This does not cover modifications performed by environment hooks.
    '''
    lines = []
    unmodified_environ = copy.copy(environ)
    for key in sorted(env_var_subfolders.keys()):
        subfolders = env_var_subfolders[key]
        if not isinstance(subfolders, list):
            subfolders = [subfolders]
        value = _rollback_env_variable(unmodified_environ, key, subfolders)
        if value is not None:
            environ[key] = value
            lines.append(assignment(key, value))
    if lines:
        lines.insert(0, comment('reset environment variables by unrolling modifications based on all workspaces in CMAKE_PREFIX_PATH'))
    return lines


def _rollback_env_variable(environ, name, subfolders):
    '''
    For each catkin workspace in CMAKE_PREFIX_PATH remove the first entry from env[NAME] matching workspace + subfolder.

    :param subfolders: list of str '' or subfoldername that may start with '/'
    :returns: the updated value of the environment variable.
    '''
    value = environ[name] if name in environ else ''
    env_paths = [path for path in value.split(os.pathsep) if path]
    value_modified = False
    for subfolder in subfolders:
        if subfolder:
            if subfolder.startswith(os.path.sep) or (os.path.altsep and subfolder.startswith(os.path.altsep)):
                subfolder = subfolder[1:]
            if subfolder.endswith(os.path.sep) or (os.path.altsep and subfolder.endswith(os.path.altsep)):
                subfolder = subfolder[:-1]
        for ws_path in _get_workspaces(environ, include_fuerte=True, include_non_existing=True):
            path_to_find = os.path.join(ws_path, subfolder) if subfolder else ws_path
            path_to_remove = None
            for env_path in env_paths:
                env_path_clean = env_path[:-1] if env_path and env_path[-1] in [os.path.sep, os.path.altsep] else env_path
                if env_path_clean == path_to_find:
                    path_to_remove = env_path
                    break
            if path_to_remove:
                env_paths.remove(path_to_remove)
                value_modified = True
    new_value = os.pathsep.join(env_paths)
    return new_value if value_modified else None


def _get_workspaces(environ, include_fuerte=False, include_non_existing=False):
    '''
    Based on CMAKE_PREFIX_PATH return all catkin workspaces.

    :param include_fuerte: The flag if paths starting with '/opt/ros/fuerte' should be considered workspaces, ``bool``
    '''
    # get all cmake prefix paths
    env_name = 'CMAKE_PREFIX_PATH'
    value = environ[env_name] if env_name in environ else ''
    paths = [path for path in value.split(os.pathsep) if path]
    # remove non-workspace paths
    workspaces = [path for path in paths if os.path.isfile(os.path.join(path, CATKIN_MARKER_FILE)) or (include_fuerte and path.startswith('/opt/ros/fuerte')) or (include_non_existing and not os.path.exists(path))]
    return workspaces


def prepend_env_variables(environ, env_var_subfolders, workspaces):
    '''
    Generate shell code to prepend environment variables
    for the all workspaces.
    '''
    lines = []
    lines.append(comment('prepend folders of workspaces to environment variables'))

    paths = [path for path in workspaces.split(os.pathsep) if path]

    prefix = _prefix_env_variable(environ, 'CMAKE_PREFIX_PATH', paths, '')
    lines.append(prepend(environ, 'CMAKE_PREFIX_PATH', prefix))

    for key in sorted([key for key in env_var_subfolders.keys() if key != 'CMAKE_PREFIX_PATH']):
        subfolder = env_var_subfolders[key]
        prefix = _prefix_env_variable(environ, key, paths, subfolder)
        lines.append(prepend(environ, key, prefix))
    return lines


def _prefix_env_variable(environ, name, paths, subfolders):
    '''
    Return the prefix to prepend to the environment variable NAME, adding any path in NEW_PATHS_STR without creating duplicate or empty items.
    '''
    value = environ[name] if name in environ else ''
    environ_paths = [path for path in value.split(os.pathsep) if path]
    checked_paths = []
    for path in paths:
        if not isinstance(subfolders, list):
            subfolders = [subfolders]
        for subfolder in subfolders:
            path_tmp = path
            if subfolder:
                path_tmp = os.path.join(path_tmp, subfolder)
            # skip nonexistent paths
            if not os.path.exists(path_tmp):
                continue
            # exclude any path already in env and any path we already added
            if path_tmp not in environ_paths and path_tmp not in checked_paths:
                checked_paths.append(path_tmp)
    prefix_str = os.pathsep.join(checked_paths)
    if prefix_str != '' and environ_paths:
        prefix_str += os.pathsep
    return prefix_str


def assignment(key, value):
    if not IS_WINDOWS:
        return 'export %s="%s"' % (key, value)
    else:
        return 'set %s=%s' % (key, value)


def comment(msg):
    if not IS_WINDOWS:
        return '# %s' % msg
    else:
        return 'REM %s' % msg


def prepend(environ, key, prefix):
    if key not in environ or not environ[key]:
        return assignment(key, prefix)
    if not IS_WINDOWS:
        return 'export %s="%s$%s"' % (key, prefix, key)
    else:
        return 'set %s=%s%%%s%%' % (key, prefix, key)


def find_env_hooks(environ, cmake_prefix_path):
    '''
    Generate shell code with found environment hooks
    for the all workspaces.
    '''
    lines = []
    lines.append(comment('found environment hooks in workspaces'))

    generic_env_hooks = []
    generic_env_hooks_workspace = []
    specific_env_hooks = []
    specific_env_hooks_workspace = []
    generic_env_hooks_by_filename = {}
    specific_env_hooks_by_filename = {}
    generic_env_hook_ext = 'bat' if IS_WINDOWS else 'sh'
    specific_env_hook_ext = environ['CATKIN_SHELL'] if not IS_WINDOWS and 'CATKIN_SHELL' in environ and environ['CATKIN_SHELL'] else None
    # remove non-workspace paths
    workspaces = [path for path in cmake_prefix_path.split(os.pathsep) if path and os.path.isfile(os.path.join(path, CATKIN_MARKER_FILE))]
    for workspace in reversed(workspaces):
        env_hook_dir = os.path.join(workspace, 'etc', 'catkin', 'profile.d')
        if os.path.isdir(env_hook_dir):
            for filename in sorted(os.listdir(env_hook_dir)):
                if filename.endswith('.%s' % generic_env_hook_ext):
                    # remove previous env hook with same name if present
                    if filename in generic_env_hooks_by_filename:
                        i = generic_env_hooks.index(generic_env_hooks_by_filename[filename])
                        generic_env_hooks.pop(i)
                        generic_env_hooks_workspace.pop(i)
                    # append env hook
                    generic_env_hooks.append(os.path.join(env_hook_dir, filename))
                    generic_env_hooks_workspace.append(workspace)
                    generic_env_hooks_by_filename[filename] = generic_env_hooks[-1]
                elif specific_env_hook_ext is not None and filename.endswith('.%s' % specific_env_hook_ext):
                    # remove previous env hook with same name if present
                    if filename in specific_env_hooks_by_filename:
                        i = specific_env_hooks.index(specific_env_hooks_by_filename[filename])
                        specific_env_hooks.pop(i)
                        specific_env_hooks_workspace.pop(i)
                    # append env hook
                    specific_env_hooks.append(os.path.join(env_hook_dir, filename))
                    specific_env_hooks_workspace.append(workspace)
                    specific_env_hooks_by_filename[filename] = specific_env_hooks[-1]
    env_hooks = generic_env_hooks + specific_env_hooks
    env_hooks_workspace = generic_env_hooks_workspace + specific_env_hooks_workspace
    count = len(env_hooks)
    lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_COUNT', count))
    for i in range(count):
        lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_%d' % i, env_hooks[i]))
        lines.append(assignment('_CATKIN_ENVIRONMENT_HOOKS_%d_WORKSPACE' % i, env_hooks_workspace[i]))
    return lines


def _parse_arguments(args=None):
    parser = argparse.ArgumentParser(description='Generates code blocks for the setup.SHELL script.')
    parser.add_argument('--extend', action='store_true', help='Skip unsetting previous environment variables to extend context')
    return parser.parse_known_args(args=args)[0]


if __name__ == '__main__':
    try:
        try:
            args = _parse_arguments()
        except Exception as e:
            print(e, file=sys.stderr)
            sys.exit(1)

        # environment at generation time
        CMAKE_PREFIX_PATH = '/home/demo/ws/install;/home/demo/.nix-profile;/nix/store/7inxdf88zz2msxmd3m6dhhxdsxkbad5k-patchelf-0.9;/nix/store/n9kdl63krsqix92b9hz5hwfy2322zi3h-paxctl-0.9;/nix/store/4r5kszyy0iirc5agfah45lvz7mnnsrb4-gcc-wrapper-7.3.0;/nix/store/1is4c0vfcs0q5i3ygij21y6z713lihw9-binutils-wrapper-2.28.1;/nix/store/pw831glmj7p4n8kkdvrcbmfxks5gwndp-cmake-3.10.2;/nix/store/azw9ys2m2fpfzf730xjcxja890gpyp58-python3-3.6.4;/nix/store/isgcl5hnimpn9l9p4j2bf0g7ng4mki9f-empy-3.3.2;/nix/store/a3yibhgsiw69spd5yr6qsjd1xw5mcl1j-python3.6-setuptools-38.4.1;/nix/store/wzj3x9vizyxr73kr0qkcsg67j78h1zj3-python3.6-catkin_pkg-0.4.1;/nix/store/f5f2bhmw9c78sysk64b25c3m77hj9fj0-python3.6-pyparsing-2.2.0;/nix/store/fvfhzwvyy8qbcn4d7x2091zh8b4c9yxn-python3.6-docutils-0.14;/nix/store/f0qr0qff284jj3ssng83r876bpg4bjih-python3.6-python-dateutil-2.6.1;/nix/store/k8138y84xaajarcnj04f0wwavi64v788-python3.6-six-1.11.0;/nix/store/sci1772jpz3f3944m663adbdfrir9lfk-python3.6-rospkg-1.1.4;/nix/store/rp8vvvf15fni2dxn1p46hv6ly3k0xca3-python3.6-PyYAML-3.12;/nix/store/12qfz5rm6pascd2icibd0dfb94wnn5bv-libyaml-0.1.7;/nix/store/p3h3vcm9878kampb7lbirq62l970rzfw-robonomics_lighthouse-0.0;/nix/store/qz1diiqjnxw2yqg28pgqd9ycajhrd9z6-ros_comm-1.13.6;/nix/store/ml3zazw2qbhk762z3h8bc2q5bwdb9fwl-catkin-0.7.11;/nix/store/1drwnr147a08vbicylwjvi418sp1ldzf-message_filters-1.13.6;/nix/store/2nb4grs2x8dwxnfl1klr1lvmlsl10653-rosconsole-1.13.6;/nix/store/v6h7zmbxpblcl8k6pmn4kwiv7q7nq469-boost-1.66_0-dev;/nix/store/9crjr6hk4jqqr1jyqj5729cry9xfdah6-boost-1.66_0;/nix/store/y6pmscmm54ylq3j3waa55d0xx5a3xnd4-cpp_common-0.6.9;/nix/store/5zvpazncq9apk11nnbcfwdqmwq3sx7fg-console_bridge-0.3.2;/nix/store/370pw7k81b80p360px75fdbb1awnk7g1-log4cxx-0.10.0;/nix/store/rxv4d4p339vydvii9ykshfh164hld6m8-rosbuild-1.14.1;/nix/store/4jwzpfxbhkwc72nf449wwf4d5xycxxqp-message_generation-0.4.0;/nix/store/r8sr4x3ywwv7zk6ww54f53phx05wzanm-genmsg-0.5.10;/nix/store/pl9qf788d874dsqng1iwl937yajnxifb-gencpp-0.5.5;/nix/store/ilmi2kpy8hcw1yb5iik6dlhgxxb0x6cs-genpy-0.6.6;/nix/store/w8rc1qlx46i73ss9xsgfmlnk4m30l90z-message_runtime-0.4.12;/nix/store/ry1jpxgjwipfgf6w454kh4yiqk9k153s-roscpp_serialization-0.6.9;/nix/store/vi1q5i5yj6f7gsqs3lkfgq6an3lm1r2s-rostime-0.6.9;/nix/store/gl79x42g0kv6iw7f49sl20fbfrk5lj1n-roscpp_traits-0.6.9;/nix/store/pj3is2n1qbrq04313w1r2zsznfcbxiw0-rosunit-1.14.1;/nix/store/z2sh17wnlkn04vqdbz5ljxxjv6q75fvj-roslib-1.14.1;/nix/store/3186npfigdkhvdn4x4ph4vnbjkwbk223-rospack-2.4.4;/nix/store/z4q07k1wihjjahglgxd9pxd28kccf98k-cmake_modules-0.4.1;/nix/store/r4z3dg2sl2nrwpsggpa8j62j0jdfc2q1-tinyxml-2-6.0.0;/nix/store/kxl4f13szgzlgrrnx98d5dmiy4jhbfcy-rostest-1.13.6;/nix/store/8crsw1rrgr8g6n0d1n9hnqn8r0wbzlf9-rosgraph-1.13.6;/nix/store/w06vy6gijmm6hdmsdvkc71mrvdz4f06z-python3.6-netifaces-0.10.6;/nix/store/gw04741lajyqsnagwr5kxa7gp2m1lbc1-roslaunch-1.13.6;/nix/store/ppmx71pncr96zzrvbh682lz0869m546l-rosclean-1.14.1;/nix/store/c2sk817vwjfn0pywmxxv9ab5qyii0a7x-rosgraph_msgs-1.11.2;/nix/store/y9z70945cywf9wgc91frjsyc9rxm8vpf-std_msgs-0.5.11;/nix/store/h2wpvhw1f77ak6mc43wc3333yjbnbwx7-rosmaster-1.13.6;/nix/store/yv0lvix9nr2mmylyn14jpyv80nyb6ynv-rosout-1.13.6;/nix/store/a2d9hmq3wnw42c2x6bnjkjz27iag9342-roscpp-1.13.6;/nix/store/3bs81k9zzqvimxl6s9r3frscf5dg17yy-roslang-1.14.1;/nix/store/85s4h4w7wk5jf6n7xy36hw5wzb859vi0-xmlrpcpp-1.13.6;/nix/store/l39q2i4x0a5s8hkp8s6sjhi8qi1aisjl-rosparam-1.13.6;/nix/store/n8rkvcbsxjns23b1xj757js233l6f9ss-python3.6-defusedxml-0.5.0;/nix/store/88j53ngi4afzz9l2m4xxj1gijh2csz6y-rospy-1.13.6;/nix/store/kijjbdi8syzpcka3yrwrbb66zzhqnay4-ros-1.14.1;/nix/store/dicy6vf873lyn1q6k9qqn2123y7nx3f8-rosbash-1.14.1;/nix/store/7xjslar9flqnysfn3qjhd4p8076xp4nc-rosboost_cfg-1.14.1;/nix/store/8nq17py87y0flkn86ha56wv7dwz2k95p-roscreate-1.14.1;/nix/store/1pfc9q723rr6h94vgdmy3ga4bgv1mnpl-rosmake-1.14.1;/nix/store/zapllp53y5x6bkwrfz0fijqpnhpaqn4g-rosbag-1.13.6;/nix/store/bzaj2wpma9sl2qgq3svmf3idx4hyrjir-rosbag_storage-1.13.6;/nix/store/fnpjz72j9nvi393s4in1p7kfa32cyy25-roslz4-1.13.6;/nix/store/mkg9j8ynbiv2ayzm31jma2nqph2mb2zi-lz4-131-dev;/nix/store/7648y273ir2jis6aj9rgiq4nqmcj1zgm-lz4-131;/nix/store/qh7vxajagv1x0q2xzi0bw70s1gscaqb1-bzip2-1.0.6.0.1-dev;/nix/store/9wj6nikq0h48gmh8dhdr6dyqd54xgzk0-bzip2-1.0.6.0.1-bin;/nix/store/khz209lcxylk55hy1qqvk8r8jxjpg01x-bzip2-1.0.6.0.1;/nix/store/mxy767kh19zy4xgxdxmkdj9dw93ihan1-std_srvs-1.11.2;/nix/store/l69n0xciv2cn1c4h2lw12spvl1vqf6q0-topic_tools-1.13.6;/nix/store/8ijv4xbhxgjz30948xpnpfahq7w7srkd-rosmsg-1.13.6;/nix/store/nsx53jj73dy8srhq66icmjxvqc4pima4-rosnode-1.13.6;/nix/store/4rfqbcsina7cha298h2vgr3110pjylxi-rostopic-1.13.6;/nix/store/mqdc0bhg7kf3i7n9ymc26l1y7dksl1ln-rosservice-1.13.6;/nix/store/3v2xfcw3h7xg52hlrd1512cm9km0k2k2-roswtf-1.13.6;/nix/store/20w194dak4jxj1cc4514p2x0kdl6ms1d-ipfs-0.4.13;/nix/store/27ldpw82vczc8c1hji3jy4r7kldg9nd9-ipfs-0.4.13-bin;/nix/store/mil4alb859krdv7bn9f7jfs15dmv43li-python3.6-pexpect-4.4.0;/nix/store/s7mdp90m0bzadf9lklym1sxzcicrka5x-python3.6-ptyprocess-0.5.2;/nix/store/n5jx6k8q6kf9chq8lzj8d9h3h3xb01vs-python3.6-base58-0.2.4;/nix/store/il4v82isspr7vkdvjxqqw4gpylag6v6v-python3.6-web3-v4.0.0-beta.9;/nix/store/0jdvg7nk3j7s81crhjpiawlcbs4h9xs9-python3.6-lru-dict-1.1.6;/nix/store/yp5fcvqn4mw5s6grqh04iqdi8vvcdkvf-python3.6-requests-2.18.4-dev;/nix/store/6hc41krivra1kdldmbj1ryw49iyv9xvx-python3.6-urllib3-1.22;/nix/store/xryvgd7ix47wq8zp4vwzp6gjcnppcl92-python3.6-pyOpenSSL-17.5.0-dev;/nix/store/cfd0bdfmmcixgjvlxc7silq3z0xkrp65-python3.6-cryptography-2.1.4-dev;/nix/store/g1xnwdyc7ld3xxiy1xq8ayw7wm502n5f-python3.6-idna-2.6;/nix/store/iwdldhq7y0ay679b6mrqnp31azivdxif-python3.6-asn1crypto-0.24.0;/nix/store/99hsnz98s8yhj6vvpxi6xk8grbw6ab2i-python3.6-packaging-16.8;/nix/store/pq1241d3nkm1vr4zqzn3r7kz1h8wfa03-python3.6-cffi-1.11.5-dev;/nix/store/1rh13l22z3j08ikir2bl4v6mldf747l6-libffi-3.2.1-dev;/nix/store/5mg32439k1lam17dwq9xyk52i4hcwlqy-libffi-3.2.1;/nix/store/bc7ahdcmnvnnfzm7ldz38pd956nixxa3-python3.6-pycparser-2.14;/nix/store/9ricrz9p4lh62rgv843nnbbisnhxlxya-python3.6-cffi-1.11.5;/nix/store/j9y5hk6aza9v5y62nlshzh0msbw1dvrw-python3.6-cryptography-2.1.4;/nix/store/i20az3687dz87z09zm93y6qsmaklrpgh-python3.6-pyasn1-0.4.2;/nix/store/lhjzwp2x9gfl9l09wsa03bmjn7qkrwx2-python3.6-pyOpenSSL-17.5.0;/nix/store/sm2dmnrsql964mvj12qr02vnjrcrg7k9-python3.6-certifi-2018.1.18;/nix/store/zwxw8vg5vk3dr5p3wr09d2dzc6ib0pl9-python3.6-pysocks-1.6.6;/nix/store/fbfp9mcjayb0v6yawj2q8m9r6xjfz0lp-python3.6-chardet-3.0.4;/nix/store/qarjvm7jpqgz3hjk19jz8vqzmbvk96mb-python3.6-requests-2.18.4;/nix/store/npwylvxbkmg81bhkw9sgm5ng3syyz0as-python3.6-eth-abi-v1.0.0-beta.0;/nix/store/33ncf985d8ihiczcgi7lmcdrd169m5i3-python3.6-eth-utils-v1.0.0-beta.1;/nix/store/j2sq7hjw4jd7r365cqhgvzylnw36j6ci-python3.6-cytoolz-0.9.0;/nix/store/pdbx879mpq2izcrd91l4wdzh7nc7pjg7-python3.6-toolz-0.9.0;/nix/store/k08g7pfq0hzma9lm28vznlwzm5yw7mdj-python3.6-eth-hash-v0.1.0-alpha.3;/nix/store/9yd2k1jz3inp9z3hddvrbq62c9apk846-python3.6-pycryptodome-3.4.9;/nix/store/xy9ydyv7545cfhhib8w7lrbfla699rag-python3.6-pysha3-1.0.2;/nix/store/9qk34ihwd9s8i30m8bcx11d8qa2y2q1d-python3.6-eth-account-v0.1.0-alpha.2;/nix/store/ki2gjkj864x95vv0l9g82jxj91l8qy0q-python3.6-attrdict-2.0.0;/nix/store/41yagq9x8bk6p21qdf4wdsjy2vmzlwsc-python3.6-coverage-4.5.1;/nix/store/q80x28j8z74x0p1ach3i5s579f5chy7k-python3.6-nose-1.3.7;/nix/store/8rcbydqrd26qna7bbp6mbg6j4iz9vhdr-python3.6-eth-keyfile-v0.5.1;/nix/store/x7sd7sknx1dp26rn4bcd1qzkimhi040b-python3.6-eth-keys-v0.2.0-beta.1;/nix/store/hibh22vxv6zvm87c58qrdidlvnbznn84-python3.6-eth-rlp-v0.1.0-alpha.2;/nix/store/lqgyzw64g5q31ifpahwx7hbbzdg73aqv-python3.6-hexbytes-0.1.0b0;/nix/store/qlas52jxp4siicvrs8rgswdidqw7fg8w-python3.6-rlp-0.6.0;/nix/store/f42shrfjxm4caaddxvyxwdfrblsypvmk-robonomics_control-0;/nix/store/q61pr9l2l31hqrkan0m4zd0wqv85cmnp-python3.6-numpy-1.14.1;/nix/store/4abn9zw2aw2pfwbvd3kzwdzdfaqy2lzw-robonomics_liability-0.0;/nix/store/2c0rvqsgbg9mmgirkgakpa7qf4zjj1j9-python3.6-ipfsapi-0.4.2.post1'.split(';')
        # prepend current workspace if not already part of CPP
        base_path = os.path.dirname(__file__)
        if base_path not in CMAKE_PREFIX_PATH:
            CMAKE_PREFIX_PATH.insert(0, base_path)
        CMAKE_PREFIX_PATH = os.pathsep.join(CMAKE_PREFIX_PATH)

        environ = dict(os.environ)
        lines = []
        if not args.extend:
            lines += rollback_env_variables(environ, ENV_VAR_SUBFOLDERS)
        lines += prepend_env_variables(environ, ENV_VAR_SUBFOLDERS, CMAKE_PREFIX_PATH)
        lines += find_env_hooks(environ, CMAKE_PREFIX_PATH)
        print('\n'.join(lines))

        # need to explicitly flush the output
        sys.stdout.flush()
    except IOError as e:
        # and catch potential "broken pipe" if stdout is not writable
        # which can happen when piping the output to a file but the disk is full
        if e.errno == errno.EPIPE:
            print(e, file=sys.stderr)
            sys.exit(2)
        raise

    sys.exit(0)
