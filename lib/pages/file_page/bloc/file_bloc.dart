import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:smart_case/database/file/file_model.dart';
import 'package:smart_case/services/apis/smartcase_apis/file_api.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  FileBloc() : super(const FileState()) {
    on<GetFilesEvent>(_mapGetFilesEventToState);
  }

  Future<FutureOr<void>> _mapGetFilesEventToState(
      GetFilesEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(status: FileStatus.filesLoading));
    await FileApi.fetchAll().then((files) {
      emit(state.copyWith(status: FileStatus.filesSuccess, files: files));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: FileStatus.filesSuccess));
    });
  }
}
