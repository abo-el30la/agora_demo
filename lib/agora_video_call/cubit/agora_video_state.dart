part of 'agora_video_cubit.dart';

abstract class AgoraVideoState {}

class AgoraVideoInitial extends AgoraVideoState {}

class AgoraVideoJoinChannelSuccess extends AgoraVideoState {}

class AgoraVideoJoinChannelError extends AgoraVideoState {}

class AgoraVideoUserJoined extends AgoraVideoState {}

class AgoraVideoUserOffline extends AgoraVideoState {}

class AgoraVideoLeaveChannel extends AgoraVideoState {}

class AgoraVideoCameraSwitch extends AgoraVideoState {}

class AgoraVideoChangeVideoVisibility extends AgoraVideoState {}

class AgoraVideoChangeAudioMute extends AgoraVideoState {}