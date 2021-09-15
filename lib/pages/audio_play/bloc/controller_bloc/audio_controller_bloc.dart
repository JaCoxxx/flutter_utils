import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_utils/pages/audio_play/config/audio_play_controller.dart';
import 'package:meta/meta.dart';

part 'audio_controller_event.dart';
part 'audio_controller_state.dart';

class AudioControllerBloc extends Bloc<AudioControllerEvent, AudioControllerState> {
  AudioControllerBloc() : super(AudioControllerState().init());

  @override
  Stream<AudioControllerState> mapEventToState(
    AudioControllerEvent event,
  ) async* {
  }
}
