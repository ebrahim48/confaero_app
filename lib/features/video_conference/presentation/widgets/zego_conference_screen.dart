import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';

import '../../../../core/constants/zego_config.dart';

class ZegoConferenceScreen extends StatefulWidget {
  final int appId;
  final String token;
  final String roomId;
  final String userId;
  final String userName;
  final String role;

  const ZegoConferenceScreen({
    super.key,
    required this.appId,
    required this.token,
    required this.roomId,
    required this.userId,
    required this.userName,
    this.role = 'ATTENDEE',
  });

  @override
  State<ZegoConferenceScreen> createState() => _ZegoConferenceScreenState();
}

class _ZegoConferenceScreenState extends State<ZegoConferenceScreen> {
  bool _micOn = false;
  bool _camOn = false;
  bool _joined = false;
  String? _errorMessage;

  bool get _isSpeaker => widget.role == 'SPEAKER';

  @override
  void initState() {
    super.initState();
    _joinRoom();
  }

  Future<void> _joinRoom() async {
    try {
      // Destroy any stale engine from previous sessions.
      await ZegoUIKit().uninit();

      // AppSign mode — use real appSign, no server token needed for joinRoom.
      ZegoUIKit().login(widget.userId, widget.userName);
      await ZegoUIKit()
          .init(appID: widget.appId, appSign: ZegoConfig.appSign);

      ZegoUIKit()
        ..turnCameraOn(_isSpeaker)
        ..turnMicrophoneOn(_isSpeaker)
        ..useFrontFacingCamera(true)
        ..setAudioOutputToSpeaker(true);

      // AppSign mode: join room WITHOUT token.
      final result = await ZegoUIKit().joinRoom(widget.roomId);

      if (!mounted) return;

      if (result.errorCode == 0) {
        setState(() {
          _joined = true;
          _micOn = _isSpeaker;
          _camOn = _isSpeaker;
        });
      } else {
        setState(() => _errorMessage =
            'Join failed (code ${result.errorCode})\n${result.extendedData}');
      }
    } catch (e) {
      if (mounted) setState(() => _errorMessage = 'Error: $e');
    }
  }

  @override
  void dispose() {
    ZegoUIKit().leaveRoom().whenComplete(() => ZegoUIKit().uninit());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZegoScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (ctx, child) => Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              if (_errorMessage != null)
                _buildError()
              else if (!_joined)
                _buildLoading()
              else
                _buildVideoGrid(),
              _buildTopBar(),
              if (_joined) _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Joining session...',
                style: TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      );

  Widget _buildError() => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );

  Widget _buildVideoGrid() => ZegoAudioVideoContainer(
        layout: ZegoLayout.gallery(
          showNewScreenSharingViewInFullscreenMode: true,
          showScreenSharingFullscreenModeToggleButtonRules:
              ZegoShowFullscreenModeToggleButtonRules.alwaysShow,
        ),
        foregroundBuilder: (ctx, size, user, extra) {
          if (user == null) return const SizedBox();
          return Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: Text(
                user.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                ),
              ),
            ),
          );
        },
        backgroundBuilder: (ctx, size, user, extra) {
          final initial = (user?.name.isNotEmpty == true)
              ? user!.name[0].toUpperCase()
              : '?';
          return Container(
            color: const Color(0xff0f3460),
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: size.width * 0.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      );

  Widget _buildTopBar() => Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black87, Colors.transparent],
            ),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Live Session',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _isSpeaker ? Colors.redAccent : Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _isSpeaker ? 'SPEAKER' : 'ATTENDEE',
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildBottomControls() => Positioned(
        bottom: 24,
        left: 0,
        right: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ControlButton(
              icon: _micOn ? Icons.mic : Icons.mic_off,
              label: _micOn ? 'Mute' : 'Unmute',
              onTap: () {
                ZegoUIKit().turnMicrophoneOn(!_micOn);
                setState(() => _micOn = !_micOn);
              },
            ),
            _ControlButton(
              icon: _camOn ? Icons.videocam : Icons.videocam_off,
              label: _camOn ? 'Cam Off' : 'Cam On',
              onTap: () {
                ZegoUIKit().turnCameraOn(!_camOn);
                setState(() => _camOn = !_camOn);
              },
            ),
            _ControlButton(
              icon: Icons.call_end,
              label: 'Leave',
              color: Colors.red,
              onTap: () =>
                  Navigator.of(context, rootNavigator: true).pop(),
            ),
          ],
        ),
      );
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color == Colors.red ? Colors.red : Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}
