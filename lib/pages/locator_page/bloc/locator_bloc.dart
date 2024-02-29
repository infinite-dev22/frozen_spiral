import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'locator_event.dart';
part 'locator_state.dart';

class LocatorBloc extends Bloc<LocatorEvent, LocatorState> {
  LocatorBloc() : super(LocatorInitial()) {
    on<LocatorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
