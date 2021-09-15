part of 'audio_controller_bloc.dart';

class AudioControllerState {
  late AudioPlayController audioPlayController;

  AudioControllerState init() {
    return AudioControllerState()..audioPlayController = AudioPlayController();
  }

}