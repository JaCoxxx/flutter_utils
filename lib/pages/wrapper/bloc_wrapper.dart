import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_utils/pages/audio_play/bloc/controller_bloc/audio_controller_bloc.dart';

/// jacokwu
/// 9/6/21 3:17 PM

class BlocWrapper extends StatelessWidget {

  final Widget child;

  BlocWrapper({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AudioControllerBloc(),),
        ],
        child: child
    );
  }

}
