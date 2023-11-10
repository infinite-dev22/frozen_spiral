import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(FileInitial());

  Stream<FileState> mapEventToState(
    FileEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
