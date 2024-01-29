part of 'file_bloc.dart';

abstract class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object?> get props => [];
}

class GetFilesEvent extends FileEvent {
}

class GetFileEvent extends FileEvent {
  final int fileId;

  GetFileEvent(this.fileId);

  @override
  List<Object?> get props => [fileId];
}

class PostFileEvent extends FileEvent {
  final Map<String, dynamic> file;
  final int fileId;

  PostFileEvent(this.file, this.fileId);

  @override
  List<Object?> get props => [fileId, file];
}

class PutFileEvent extends FileEvent {
  final int fileId;
  final Map<String, dynamic> file;

  PutFileEvent(
    this.fileId,
    this.file,
  );

  @override
  List<Object?> get props => [fileId, file];
}

class DeleteFileEvent extends FileEvent {
  final int fileId;

  DeleteFileEvent(this.fileId);

  @override
  List<Object?> get props => [fileId];
}
