import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'platform_select_event.dart';
part 'platform_select_state.dart';

class PlatformSelectBloc
    extends Bloc<PlatformSelectEvent, PlatformSelectState> {
  PlatformSelectBloc() : super(PlatformSelectInitial()) {
    on<PlatformSelectEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
