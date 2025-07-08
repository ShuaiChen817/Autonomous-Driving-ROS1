#!/usr/bin/env python


import rospy
from dynamic_reconfigure.client import Client

def update_parameters():
    client = Client('/move_base/TebLocalPlannerROS')
    # 设置自动重新规划的容忍度参数
    params = {
        'replanning_interval': 1.0,
        'replanning_lookahead': 3.0
    }
    client.update_configuration(params)

if __name__ == '__main__':
    rospy.init_node('update_teb_parameters')
    update_parameters()
