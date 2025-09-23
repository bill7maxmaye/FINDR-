import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/usecases/get_notifications.dart';
import '../../domain/usecases/mark_notification_as_read.dart';
import '../../domain/usecases/mark_all_as_read.dart' as usecase;
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotifications _getNotifications;
  final MarkNotificationAsRead _markAsRead;
  final usecase.MarkAllAsRead _markAllAsRead;

  NotificationBloc({
    required GetNotifications getNotifications,
    required MarkNotificationAsRead markAsRead,
    required usecase.MarkAllAsRead markAllAsRead,
  })  : _getNotifications = getNotifications,
        _markAsRead = markAsRead,
        _markAllAsRead = markAllAsRead,
        super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<ArchiveNotification>(_onArchiveNotification);
    on<DeleteNotification>(_onDeleteNotification);
    on<FilterByType>(_onFilterByType);
    on<FilterByStatus>(_onFilterByStatus);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    
    try {
      final notifications = await _getNotifications(
        type: event.type,
        status: event.status,
      );
      
      final unreadCount = notifications
          .where((n) => n.status == NotificationStatus.unread)
          .length;
      
      emit(NotificationLoaded(
        notifications: notifications,
        selectedType: event.type,
        selectedStatus: event.status,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: $e'));
    }
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      add(LoadNotifications(
        type: currentState.selectedType,
        status: currentState.selectedStatus,
      ));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _markAsRead(event.notificationId);
      
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          if (n.id == event.notificationId) {
            return n.copyWith(status: NotificationStatus.read);
          }
          return n;
        }).toList();
        
        final unreadCount = updatedNotifications
            .where((n) => n.status == NotificationStatus.unread)
            .length;
        
        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark notification as read: $e'));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _markAllAsRead();
      
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          return n.copyWith(status: NotificationStatus.read);
        }).toList();
        
        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: 0,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark all notifications as read: $e'));
    }
  }

  Future<void> _onArchiveNotification(
    ArchiveNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Implementation would depend on your repository
      // For now, we'll just remove it from the list
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();
        
        final unreadCount = updatedNotifications
            .where((n) => n.status == NotificationStatus.unread)
            .length;
        
        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to archive notification: $e'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Implementation would depend on your repository
      // For now, we'll just remove it from the list
      if (state is NotificationLoaded) {
        final currentState = state as NotificationLoaded;
        final updatedNotifications = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();
        
        final unreadCount = updatedNotifications
            .where((n) => n.status == NotificationStatus.unread)
            .length;
        
        emit(currentState.copyWith(
          notifications: updatedNotifications,
          unreadCount: unreadCount,
        ));
      }
    } catch (e) {
      emit(NotificationError('Failed to delete notification: $e'));
    }
  }

  Future<void> _onFilterByType(
    FilterByType event,
    Emitter<NotificationState> emit,
  ) async {
    add(LoadNotifications(
      type: event.type,
      status: state is NotificationLoaded 
          ? (state as NotificationLoaded).selectedStatus 
          : null,
    ));
  }

  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<NotificationState> emit,
  ) async {
    add(LoadNotifications(
      type: state is NotificationLoaded 
          ? (state as NotificationLoaded).selectedType 
          : null,
      status: event.status,
    ));
  }
}
