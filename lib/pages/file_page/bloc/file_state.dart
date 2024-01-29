part of 'file_bloc.dart';

enum FileStatus {
  initial,
  fileSuccess,
  filesSuccess,
  fileError,
  filesError,
  fileLoading,
  filesLoading,
  selected,
  fileNoData,
  filesNoData,
}

extension FileStatusX on FileStatus {
  bool get isInitial => this == FileStatus.initial;

  bool get fileIsSuccess => this == FileStatus.fileSuccess;

  bool get filesIsSuccess => this == FileStatus.filesSuccess;

  bool get fileIsError => this == FileStatus.fileError;

  bool get filesIsError => this == FileStatus.filesError;

  bool get fileIsLoading => this == FileStatus.fileLoading;

  bool get filesIsLoading => this == FileStatus.filesLoading;

  bool get fileIsNoData => this == FileStatus.fileNoData;

  bool get filesIsNoData => this == FileStatus.filesNoData;
}

@immutable
class FileState extends Equatable {
  final List<SmartFile>? files;
  final SmartFile? file;
  final FileStatus? status;
  final int? idSelected;

  const FileState({
    List<SmartFile>? files,
    this.file,
    this.status = FileStatus.initial,
    this.idSelected = 0,
  }) : files = files ?? const [];

  @override
  List<Object?> get props => [
    files,
    file,
    status,
    idSelected,
  ];

  FileState copyWith({
    List<SmartFile>? files,
    SmartFile? file,
    FileStatus? status,
    int? idSelected,
  }) {
    return FileState(
      files: files,
      file: file,
      status: status,
      idSelected: idSelected,
    );
  }
}

class FileInitial extends FileState {
  @override
  List<Object> get props => [];
}

class FilesInitial extends FileState {
  @override
  List<Object> get props => [];
}

class FileLoading extends FileState {}

class FilesLoading extends FileState {}

class FileSuccessful extends FileState {
  @override
  List<Object?> get props => [];
}

class FilesSuccessful extends FileState {
  @override
  List<Object?> get props => [];
}

class FileError extends FileState {}

class FilesError extends FileState {}

class FileNoData extends FileState {}

class FilesNoData extends FileState {}
