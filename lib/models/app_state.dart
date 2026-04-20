import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  String? _userName;
  String? _phoneNumber;
  bool _isVerified = false;
  List<OrderNotification> _notifications = [];

  String? get userName => _userName;
  String? get phoneNumber => _phoneNumber;
  bool get isVerified => _isVerified;
  List<OrderNotification> get notifications => _notifications;
  int get unreadNotificationCount => _notifications.where((n) => !n.isRead).length;

  void setUserInfo(String name, String phone) {
    _userName = name;
    _phoneNumber = phone;
    notifyListeners();
  }

  void setVerificationStatus(bool status) {
    _isVerified = status;
    notifyListeners();
  }

  void addNotification(OrderNotification notification) {
    _notifications.insert(0, notification);
    notifyListeners();
  }

  void markNotificationAsRead(String id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      notifyListeners();
    }
  }

  void clearAllNotifications() {
    _notifications.clear();
    notifyListeners();
  }
}

class OrderNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  bool isRead;
  final NotificationType type;

  OrderNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    required this.type,
  });
}

enum NotificationType {
  newOrder,
  orderUpdate,
  payment,
  verification,
  general,
}