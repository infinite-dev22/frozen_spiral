import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../database/activity/activity_model.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc() : super(ActivityInitial());

  Stream<ActivityState> mapEventToState(
    ActivityEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
