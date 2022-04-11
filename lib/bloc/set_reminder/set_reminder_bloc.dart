import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'set_reminder_event.dart';
part 'set_reminder_state.dart';

class SetReminderBloc extends Bloc<SetReminderEvent, SetReminderState> {
  SetReminderBloc() : super(SetReminderInitial()) {
    on<SetReminderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
