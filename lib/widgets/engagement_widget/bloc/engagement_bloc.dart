import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'engagement_event.dart';
part 'engagement_state.dart';

class EngagementBloc extends Bloc<EngagementEvent, EngagementState> {
  EngagementBloc() : super(EngagementInitial()) {
    on<EngagementEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
