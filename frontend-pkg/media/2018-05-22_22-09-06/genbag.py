# -*- coding: utf-8 -*-

import rosbag
from std_msgs.msg import String

topic = '/task'

bag = rosbag.Bag('task.bag', 'w')
try:
    msg = String()
    msg.data = "Empty string"
    bag.write(topic, msg)
finally:
    bag.close()

