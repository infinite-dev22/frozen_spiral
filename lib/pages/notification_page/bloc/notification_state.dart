part of 'notification_bloc.dart';

enum NotificationStatus {
  initial,
  notificationSuccess,
  notificationsSuccess,
  notificationError,
  notificationsError,
  notificationLoading,
  notificationsLoading,
  selected,
  notificationNoData,
  notificationsNoData,
}

extension NotificationStatusX on NotificationStatus {
  bool get isInitial => this == NotificationStatus.initial;

  bool get notificationIsSuccess => this == NotificationStatus.notificationSuccess;

  bool get notificationsIsSuccess => this == NotificationStatus.notificationsSuccess;

  bool get notificationIsError => this == NotificationStatus.notificationError;

  bool get notificationsIsError => this == NotificationStatus.notificationsError;

  bool get notificationIsLoading => this == NotificationStatus.notificationLoading;

  bool get notificationsIsLoading => this == NotificationStatus.notificationsLoading;

  bool get notificationIsNoData => this == NotificationStatus.notificationNoData;

  bool get notificationsIsNoData => this == NotificationStatus.notificationsNoData;
}

@immutable
class NotificationState extends Equatable {
  final List<Notifications>? notifications;
  final Notifications? notification;
  final NotificationStatus? status;
  final int? idSelected;

  const NotificationState({
    List<Notifications>? notifications,
    this.notification,
    this.status = NotificationStatus.initial,
    this.idSelected = 0,
  }) : notifications = notifications ?? const [];

  @override
  List<Object?> get props => [
    notifications,
    notification,
    status,
    idSelected,
  ];

  NotificationState copyWith({
    List<Notifications>? notifications,
    Notifications? notification,
    NotificationStatus? status,
    int? idSelected,
  }) {
    return NotificationState(
      notifications: notifications,
      notification: notification,
      status: status,
      idSelected: idSelected,
    );
  }
}

class NotificationInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationsInitial extends NotificationState {
  @override
  List<Object> get props => [];
}

class NotificationLoading extends NotificationState {}

class NotificationsLoading extends NotificationState {}

class NotificationSuccessful extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationsSuccessful extends NotificationState {
  @override
  List<Object?> get props => [];
}

class NotificationError extends NotificationState {}

class NotificationsError extends NotificationState {}

class NotificationNoData extends NotificationState {}

class NotificationsNoData extends NotificationState {}
