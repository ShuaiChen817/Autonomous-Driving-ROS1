// Auto-generated. Do not edit!

// (in-package waypoint_manager.srv)


"use strict";

const _serializer = _ros_msg_utils.Serialize;
const _arraySerializer = _serializer.Array;
const _deserializer = _ros_msg_utils.Deserialize;
const _arrayDeserializer = _deserializer.Array;
const _finder = _ros_msg_utils.Find;
const _getByteLength = _ros_msg_utils.getByteLength;
let geometry_msgs = _finder('geometry_msgs');

//-----------------------------------------------------------


//-----------------------------------------------------------

class CheckWaypointRequest {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.current_pose = null;
    }
    else {
      if (initObj.hasOwnProperty('current_pose')) {
        this.current_pose = initObj.current_pose
      }
      else {
        this.current_pose = new geometry_msgs.msg.Pose();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type CheckWaypointRequest
    // Serialize message field [current_pose]
    bufferOffset = geometry_msgs.msg.Pose.serialize(obj.current_pose, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type CheckWaypointRequest
    let len;
    let data = new CheckWaypointRequest(null);
    // Deserialize message field [current_pose]
    data.current_pose = geometry_msgs.msg.Pose.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    return 56;
  }

  static datatype() {
    // Returns string type for a service object
    return 'waypoint_manager/CheckWaypointRequest';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '8aa49ba45d5b9d2df8a650fff8d23e31';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    geometry_msgs/Pose current_pose
    
    ================================================================================
    MSG: geometry_msgs/Pose
    # A representation of pose in free space, composed of position and orientation. 
    Point position
    Quaternion orientation
    
    ================================================================================
    MSG: geometry_msgs/Point
    # This contains the position of a point in free space
    float64 x
    float64 y
    float64 z
    
    ================================================================================
    MSG: geometry_msgs/Quaternion
    # This represents an orientation in free space in quaternion form.
    
    float64 x
    float64 y
    float64 z
    float64 w
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new CheckWaypointRequest(null);
    if (msg.current_pose !== undefined) {
      resolved.current_pose = geometry_msgs.msg.Pose.Resolve(msg.current_pose)
    }
    else {
      resolved.current_pose = new geometry_msgs.msg.Pose()
    }

    return resolved;
    }
};

class CheckWaypointResponse {
  constructor(initObj={}) {
    if (initObj === null) {
      // initObj === null is a special case for deserialization where we don't initialize fields
      this.is_close_enough = null;
      this.next_waypoint = null;
    }
    else {
      if (initObj.hasOwnProperty('is_close_enough')) {
        this.is_close_enough = initObj.is_close_enough
      }
      else {
        this.is_close_enough = false;
      }
      if (initObj.hasOwnProperty('next_waypoint')) {
        this.next_waypoint = initObj.next_waypoint
      }
      else {
        this.next_waypoint = new geometry_msgs.msg.PoseStamped();
      }
    }
  }

  static serialize(obj, buffer, bufferOffset) {
    // Serializes a message object of type CheckWaypointResponse
    // Serialize message field [is_close_enough]
    bufferOffset = _serializer.bool(obj.is_close_enough, buffer, bufferOffset);
    // Serialize message field [next_waypoint]
    bufferOffset = geometry_msgs.msg.PoseStamped.serialize(obj.next_waypoint, buffer, bufferOffset);
    return bufferOffset;
  }

  static deserialize(buffer, bufferOffset=[0]) {
    //deserializes a message object of type CheckWaypointResponse
    let len;
    let data = new CheckWaypointResponse(null);
    // Deserialize message field [is_close_enough]
    data.is_close_enough = _deserializer.bool(buffer, bufferOffset);
    // Deserialize message field [next_waypoint]
    data.next_waypoint = geometry_msgs.msg.PoseStamped.deserialize(buffer, bufferOffset);
    return data;
  }

  static getMessageSize(object) {
    let length = 0;
    length += geometry_msgs.msg.PoseStamped.getMessageSize(object.next_waypoint);
    return length + 1;
  }

  static datatype() {
    // Returns string type for a service object
    return 'waypoint_manager/CheckWaypointResponse';
  }

  static md5sum() {
    //Returns md5sum for a message object
    return '5529b14aaeb24aca958c63e0dc31a853';
  }

  static messageDefinition() {
    // Returns full string definition for message
    return `
    bool is_close_enough
    geometry_msgs/PoseStamped next_waypoint
    
    ================================================================================
    MSG: geometry_msgs/PoseStamped
    # A Pose with reference coordinate frame and timestamp
    Header header
    Pose pose
    
    ================================================================================
    MSG: std_msgs/Header
    # Standard metadata for higher-level stamped data types.
    # This is generally used to communicate timestamped data 
    # in a particular coordinate frame.
    # 
    # sequence ID: consecutively increasing ID 
    uint32 seq
    #Two-integer timestamp that is expressed as:
    # * stamp.sec: seconds (stamp_secs) since epoch (in Python the variable is called 'secs')
    # * stamp.nsec: nanoseconds since stamp_secs (in Python the variable is called 'nsecs')
    # time-handling sugar is provided by the client library
    time stamp
    #Frame this data is associated with
    string frame_id
    
    ================================================================================
    MSG: geometry_msgs/Pose
    # A representation of pose in free space, composed of position and orientation. 
    Point position
    Quaternion orientation
    
    ================================================================================
    MSG: geometry_msgs/Point
    # This contains the position of a point in free space
    float64 x
    float64 y
    float64 z
    
    ================================================================================
    MSG: geometry_msgs/Quaternion
    # This represents an orientation in free space in quaternion form.
    
    float64 x
    float64 y
    float64 z
    float64 w
    
    `;
  }

  static Resolve(msg) {
    // deep-construct a valid message object instance of whatever was passed in
    if (typeof msg !== 'object' || msg === null) {
      msg = {};
    }
    const resolved = new CheckWaypointResponse(null);
    if (msg.is_close_enough !== undefined) {
      resolved.is_close_enough = msg.is_close_enough;
    }
    else {
      resolved.is_close_enough = false
    }

    if (msg.next_waypoint !== undefined) {
      resolved.next_waypoint = geometry_msgs.msg.PoseStamped.Resolve(msg.next_waypoint)
    }
    else {
      resolved.next_waypoint = new geometry_msgs.msg.PoseStamped()
    }

    return resolved;
    }
};

module.exports = {
  Request: CheckWaypointRequest,
  Response: CheckWaypointResponse,
  md5sum() { return 'fd3bf256af2f5620dd30fdc56eb0cf84'; },
  datatype() { return 'waypoint_manager/CheckWaypoint'; }
};
