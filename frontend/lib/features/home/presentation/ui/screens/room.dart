// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;

// import 'package:flutter/material.dart';
// import 'package:livekit_client/livekit_client.dart';
// import 'package:livekit_example/method_channels/replay_kit_channel.dart';

// import '../exts.dart';
// import '../utils.dart';
// import '../widgets/controls.dart';
// import '../widgets/participant.dart';
// import '../widgets/participant_info.dart';

// class RoomPage extends StatefulWidget {
//   final Room room;
//   final EventsListener<RoomEvent> listener;

//   const RoomPage(
//     this.room,
//     this.listener, {
//     super.key,
//   });

//   @override
//   State<StatefulWidget> createState() => _RoomPageState();
// }

// class _RoomPageState extends State<RoomPage> {
//   List<ParticipantTrack> participantTracks = [];
//   EventsListener<RoomEvent> get _listener => widget.listener;
//   bool get fastConnection => widget.room.engine.fastConnectOptions != null;
//   bool _flagStartedReplayKit = false;
//   @override
//   void initState() {
//     super.initState();
//     // add callback for a `RoomEvent` as opposed to a `ParticipantEvent`
//     widget.room.addListener(_onRoomDidUpdate);
//     // add callbacks for finer grained events
//     _setUpListeners();
//     _sortParticipants();
//     WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
//       if (!fastConnection) {
//         _askPublish();
//       }
//     });

//     if (lkPlatformIs(PlatformType.android)) {
//       Hardware.instance.setSpeakerphoneOn(true);
//     }

//     if (lkPlatformIs(PlatformType.iOS)) {
//       ReplayKitChannel.listenMethodChannel(widget.room);
//     }

//     if (lkPlatformIsDesktop()) {
//       onWindowShouldClose = () async {
//         unawaited(widget.room.disconnect());
//         await _listener.waitFor<RoomDisconnectedEvent>(
//             duration: const Duration(seconds: 5));
//       };
//     }
//   }

//   @override
//   void dispose() {
//     // always dispose listener
//     (() async {
//       if (lkPlatformIs(PlatformType.iOS)) {
//         ReplayKitChannel.closeReplayKit();
//       }
//       widget.room.removeListener(_onRoomDidUpdate);
//       await _listener.dispose();
//       await widget.room.dispose();
//     })();
//     onWindowShouldClose = null;
//     super.dispose();
//   }

//   /// for more information, see [event types](https://docs.livekit.io/client/events/#events)
//   void _setUpListeners() => _listener
//     ..on<RoomDisconnectedEvent>((event) async {
//       if (event.reason != null) {
//         print('Room disconnected: reason => ${event.reason}');
//       }
//       WidgetsBindingCompatible.instance?.addPostFrameCallback(
//           (timeStamp) => Navigator.popUntil(context, (route) => route.isFirst));
//     })
//     ..on<ParticipantEvent>((event) {
//       // sort participants on many track events as noted in documentation linked above
//       _sortParticipants();
//     })
//     ..on<RoomRecordingStatusChanged>((event) {
//       context.showRecordingStatusChangedDialog(event.activeRecording);
//     })
//     ..on<RoomAttemptReconnectEvent>((event) {
//       print(
//           'Attempting to reconnect ${event.attempt}/${event.maxAttemptsRetry}, '
//           '(${event.nextRetryDelaysInMs}ms delay until next attempt)');
//     })
//     ..on<LocalTrackSubscribedEvent>((event) {
//       print('Local track subscribed: ${event.trackSid}');
//     })
//     ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
//     ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
//     ..on<TrackSubscribedEvent>((_) => _sortParticipants())
//     ..on<TrackUnsubscribedEvent>((_) => _sortParticipants())
//     ..on<TrackE2EEStateEvent>(_onE2EEStateEvent)
//     ..on<ParticipantNameUpdatedEvent>((event) {
//       print(
//           'Participant name updated: ${event.participant.identity}, name => ${event.name}');
//       _sortParticipants();
//     })
//     ..on<ParticipantMetadataUpdatedEvent>((event) {
//       print(
//           'Participant metadata updated: ${event.participant.identity}, metadata => ${event.metadata}');
//     })
//     ..on<RoomMetadataChangedEvent>((event) {
//       print('Room metadata changed: ${event.metadata}');
//     })
//     ..on<DataReceivedEvent>((event) {
//       String decoded = 'Failed to decode';
//       try {
//         decoded = utf8.decode(event.data);
//       } catch (err) {
//         print('Failed to decode: $err');
//       }
//       context.showDataReceivedDialog(decoded);
//     })
//     ..on<AudioPlaybackStatusChanged>((event) async {
//       if (!widget.room.canPlaybackAudio) {
//         print('Audio playback failed for iOS Safari ..........');
//         bool? yesno = await context.showPlayAudioManuallyDialog();
//         if (yesno == true) {
//           await widget.room.startAudio();
//         }
//       }
//     });

//   void _askPublish() async {
//     final result = await context.showPublishDialog();
//     if (result != true) return;
//     // video will fail when running in ios simulator
//     try {
//       await widget.room.localParticipant?.setCameraEnabled(true);
//     } catch (error) {
//       print('could not publish video: $error');
//       await context.showErrorDialog(error);
//     }
//     try {
//       await widget.room.localParticipant?.setMicrophoneEnabled(true);
//     } catch (error) {
//       print('could not publish audio: $error');
//       await context.showErrorDialog(error);
//     }
//   }

//   void _onRoomDidUpdate() {
//     _sortParticipants();
//   }

//   void _onE2EEStateEvent(TrackE2EEStateEvent e2eeState) {
//     print('e2ee state: $e2eeState');
//   }

//   void _sortParticipants() {
//     List<ParticipantTrack> userMediaTracks = [];
//     List<ParticipantTrack> screenTracks = [];
//     for (var participant in widget.room.remoteParticipants.values) {
//       for (var t in participant.videoTrackPublications) {
//         if (t.isScreenShare) {
//           screenTracks.add(ParticipantTrack(
//             participant: participant,
//             type: ParticipantTrackType.kScreenShare,
//           ));
//         } else {
//           userMediaTracks.add(ParticipantTrack(participant: participant));
//         }
//       }
//     }
//     // sort speakers for the grid
//     userMediaTracks.sort((a, b) {
//       // loudest speaker first
//       if (a.participant.isSpeaking && b.participant.isSpeaking) {
//         if (a.participant.audioLevel > b.participant.audioLevel) {
//           return -1;
//         } else {
//           return 1;
//         }
//       }

//       // last spoken at
//       final aSpokeAt = a.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;
//       final bSpokeAt = b.participant.lastSpokeAt?.millisecondsSinceEpoch ?? 0;

//       if (aSpokeAt != bSpokeAt) {
//         return aSpokeAt > bSpokeAt ? -1 : 1;
//       }

//       // video on
//       if (a.participant.hasVideo != b.participant.hasVideo) {
//         return a.participant.hasVideo ? -1 : 1;
//       }

//       // joinedAt
//       return a.participant.joinedAt.millisecondsSinceEpoch -
//           b.participant.joinedAt.millisecondsSinceEpoch;
//     });

//     final localParticipantTracks =
//         widget.room.localParticipant?.videoTrackPublications;
//     if (localParticipantTracks != null) {
//       for (var t in localParticipantTracks) {
//         if (t.isScreenShare) {
//           if (lkPlatformIs(PlatformType.iOS)) {
//             if (!_flagStartedReplayKit) {
//               _flagStartedReplayKit = true;

//               ReplayKitChannel.startReplayKit();
//             }
//           }
//           screenTracks.add(ParticipantTrack(
//             participant: widget.room.localParticipant!,
//             type: ParticipantTrackType.kScreenShare,
//           ));
//         } else {
//           if (lkPlatformIs(PlatformType.iOS)) {
//             if (_flagStartedReplayKit) {
//               _flagStartedReplayKit = false;

//               ReplayKitChannel.closeReplayKit();
//             }
//           }

//           userMediaTracks.add(
//               ParticipantTrack(participant: widget.room.localParticipant!));
//         }
//       }
//     }
//     setState(() {
//       participantTracks = [...screenTracks, ...userMediaTracks];
//     });
//   }

//   @override
//   Widget build(BuildContext context) => Scaffold(
//         body: Stack(
//           children: [
//             Column(
//               children: [
//                 Expanded(
//                     child: participantTracks.isNotEmpty
//                         ? ParticipantWidget.widgetFor(participantTracks.first,
//                             showStatsLayer: true)
//                         : Container()),
//                 if (widget.room.localParticipant != null)
//                   SafeArea(
//                     top: false,
//                     child: ControlsWidget(
//                         widget.room, widget.room.localParticipant!),
//                   )
//               ],
//             ),
//             Positioned(
//                 left: 0,
//                 right: 0,
//                 top: 0,
//                 child: SizedBox(
//                   height: 120,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: math.max(0, participantTracks.length - 1),
//                     itemBuilder: (BuildContext context, int index) => SizedBox(
//                       width: 180,
//                       height: 120,
//                       child: ParticipantWidget.widgetFor(
//                           participantTracks[index + 1]),
//                     ),
//                   ),
//                 )),
//           ],
//         ),
//       );
// }
