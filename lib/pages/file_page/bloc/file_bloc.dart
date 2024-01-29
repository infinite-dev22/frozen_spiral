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
    on<GetFileEvent>(_mapGetFileEventToState);
    on<PostFileEvent>(_mapPostFileEventToState);
    on<PutFileEvent>(_mapPutFileEventToState);
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

  Future<FutureOr<void>> _mapGetFileEventToState(
      GetFileEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(status: FileStatus.filesLoading));
    await FileApi.fetch(event.fileId).then((file) {
      emit(state.copyWith(status: FileStatus.fileSuccess, file: file));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: FileStatus.fileSuccess));
    });
  }

  Future<FutureOr<void>> _mapPostFileEventToState(
      PostFileEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(status: FileStatus.filesLoading));
    await FileApi.post(event.file, event.fileId).then((file) {
      emit(state.copyWith(status: FileStatus.fileSuccess, file: file));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: FileStatus.fileSuccess));
    });
  }

  Future<FutureOr<void>> _mapPutFileEventToState(
      PutFileEvent event, Emitter<FileState> emit) async {
    emit(state.copyWith(status: FileStatus.filesLoading));
    await FileApi.put(event.file, event.fileId).then((file) {
      emit(state.copyWith(status: FileStatus.fileSuccess, file: file));
    }).onError((error, stackTrace) {
      if (kDebugMode) {
        print(error);
        print(stackTrace);
      }
      emit(state.copyWith(status: FileStatus.fileSuccess));
    });
  }
}
