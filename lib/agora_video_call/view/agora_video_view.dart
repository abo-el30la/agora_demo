import 'dart:io';

import 'package:agora_demo/config/agora.config.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/agora_video_cubit.dart';

class AgoraVideoPage extends StatelessWidget {
  const AgoraVideoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AgoraVideoCubit(),
      child: BlocConsumer<AgoraVideoCubit, AgoraVideoState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = context.read<AgoraVideoCubit>();
          return Scaffold(
            body: Flex(
              direction: Axis.vertical,
              children: [
                Flexible(
                  flex: 1,
                  child: cubit.isVideoEnabled
                      ? AgoraVideoView(
                          controller: VideoViewController(
                            rtcEngine: cubit.engine,
                            canvas: const VideoCanvas(uid: 0),
                            useFlutterTexture: Platform.isIOS,
                            useAndroidSurfaceView: Platform.isAndroid,
                          ),
                          onAgoraVideoViewCreated: (viewId) {
                            cubit.engine.startPreview();
                          },
                        )
                      : const Placeholder(),
                ),
                Visibility(
                  visible: cubit.remoteUid.isNotEmpty,
                  child: Flexible(
                    flex: cubit.remoteUid.isNotEmpty ? 1 : 0,
                    child: cubit.remoteUid.isNotEmpty
                        ? AgoraVideoView(
                            controller: VideoViewController.remote(
                              rtcEngine: cubit.engine,
                              canvas: VideoCanvas(uid: cubit.remoteUid.first),
                              connection: RtcConnection(channelId: channelId),
                              useFlutterTexture: Platform.isIOS,
                              useAndroidSurfaceView: Platform.isAndroid,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 20,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: cubit.isJoined ? Colors.green : Colors.red),
                          onPressed: () async {
                            await cubit.joinChannel(meetingChannelId: channelId, meetingToken: token);
                          },
                          child: const Text('Join'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: !cubit.isJoined ? Colors.green : Colors.red),
                          onPressed: () async {
                            await cubit.leaveChannel();
                          },
                          child: const Text('Leave'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: cubit.isAudioEnabled ? Colors.green : Colors.red),
                          onPressed: () async {
                            await cubit.muteAudio();
                          },
                          child: const Text('mute'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: cubit.isVideoEnabled ? Colors.green : Colors.red),
                          onPressed: () async {
                            await cubit.disableVideo();
                          },
                          child: const Text('video'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: cubit.isVideoEnabled ? Colors.green : Colors.red),
                          onPressed: () async {
                            await cubit.switchCamera();
                          },
                          child: const Text('switch camera'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
