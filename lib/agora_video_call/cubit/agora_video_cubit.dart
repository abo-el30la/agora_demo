import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../config/agora.config.dart';
import '../../logger.dart';

part 'agora_video_state.dart';

class AgoraVideoCubit extends Cubit<AgoraVideoState> {
  AgoraVideoCubit() : super(AgoraVideoInitial()) {
    initEngine();
  }

  Future<void> _requestPermissionIfNeed() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await [Permission.microphone, Permission.camera].request();
    }
  }

  final RtcEngine engine = createAgoraRtcEngine();

  bool isJoined = false, frontCamera = true, switchRender = true;
  bool isAudioEnabled = true;
  bool isVideoEnabled = true;

  Set<int> remoteUid = {};
  final ChannelProfileType channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;

  Future<void> initEngine() async {
    await _requestPermissionIfNeed();
    await engine.initialize(RtcEngineContext(
      appId: appId,
    ));

    engine.registerEventHandler(RtcEngineEventHandler(
      onError: (ErrorCodeType err, String msg) {
        logger.e('[onError] err: $err, msg: $msg');
        emit(AgoraVideoJoinChannelError());
      },
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        logger.w('[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
        isJoined = true;
        emit(AgoraVideoJoinChannelSuccess());
      },
      onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
        logger.w('[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
        remoteUid.add(rUid);
        emit(AgoraVideoUserJoined());
      },
      onUserOffline: (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
        logger.w('[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
        remoteUid.removeWhere((element) => element == rUid);
        emit(AgoraVideoUserOffline());
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        logger.w('[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
        isJoined = false;
        remoteUid.clear();
        emit(AgoraVideoLeaveChannel());
      },
    ));

    await engine.enableVideo();
  }

  Future<void> joinChannel({
    required String meetingChannelId,
    required String meetingToken,
    int meetingUid = 0,
  }) async {
    await engine.joinChannel(
      token: meetingToken,
      channelId: meetingChannelId,
      uid: meetingUid,
      options: ChannelMediaOptions(
        channelProfile: channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
    // disable video and audio
    await disableVideo();
    await muteAudio();
    // enable video and audio again
    await disableVideo();
    await muteAudio();
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
    frontCamera = !frontCamera;
    emit(AgoraVideoCameraSwitch());
  }

  @override
  Future<void> close() async {
    await engine.leaveChannel();
    await engine.release();
    return super.close();
  }

  Future<void> disableVideo() async {
    isVideoEnabled = !isVideoEnabled;
    await engine.muteLocalVideoStream(!isVideoEnabled);
    emit(AgoraVideoChangeVideoVisibility());
  }

  Future<void> muteAudio() async {
    isAudioEnabled = !isAudioEnabled;
    await engine.muteLocalAudioStream(!isAudioEnabled);
    emit(AgoraVideoChangeAudioMute());
  }
}
