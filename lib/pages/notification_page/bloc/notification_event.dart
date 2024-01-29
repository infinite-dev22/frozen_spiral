part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class GetNotificationsEvent extends NotificationEvent {
}

class GetNotificationEvent extends NotificationEvent {
  final int notificationId;

  GetNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class PostNotificationEvent extends NotificationEvent {
  final Map<String, dynamic> notification;
  final int notificationId;

  PostNotificationEvent(this.notification, this.notificationId);

  @override
  List<Object?> get props => [notificationId, notification];
}

class PutNotificationEvent extends NotificationEvent {
  final int notificationId;
  final Map<String, dynamic> notification;

  PutNotificationEvent(
      this.notificationId,
      this.notification,
      );

  @override
  List<Object?> get props => [notificationId, notification];
}

class DeleteNotificationEvent extends NotificationEvent {
  final int notificationId;

  DeleteNotificationEvent(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

