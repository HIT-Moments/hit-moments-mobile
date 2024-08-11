import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notif;
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
  List<Message> messages = [];
  bool isSending = false;

  IO.Socket socket = IO.io('https://api.hitmoments.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'query': {
      'userId': getUserID(),
    }
  });

  void getConversations() async {
    isLoading = true;
    conversations = await ConversationService().getConversations();
    isLoading = false;
    notifyListeners();
  }

  void getChatMessage(String conversationId) async {
    isLoadingChatMessage = true;
    notifyListeners();
    messages = await ConversationService().getConversationById(conversationId);
    isLoadingChatMessage = false;
    notifyListeners();
  }

  void getChatMessageByReceiverId(String receiverId) async {
    isLoadingChatMessage = true;
    notifyListeners();
    messages = await ConversationService().getConversationByReceiverId(receiverId);
    isLoadingChatMessage = false;
    notifyListeners();
  }

  Future<void> sendMessage(String userId, String message) async {
    isSending = true;
    int status = await ConversationService().sendMessage(userId, message);
    if (status == 200) {
      socket.emit('newMessage', {
        'text': message,
      });
      Message newMessage = Message(
        id: '',
        text: message,
        createdAt: DateTime.now(),
        senderId: getUserId(),
      );
      messages.add(newMessage);
      // messages = await ConversationService().getConversationByReceiverId(userId);
      isSending = false;
    }
    notifyListeners();
  }

  void connectAndListen() async {
    socket.onConnect((_) {
      print('Connected to the server'); // Debug print
    });
    socket.on('newMessage', (data) {
      print('newMessage event triggered $data'); // Debug print
      // _showNotification(data['text']);
      messages.add(Message.fromJson(data as Map<String, dynamic>));
      notifyListeners();
    });
    socket.connect();
  }

  void disconnectSocket() {
    if (socket.connected) {
      print('Disconnected from the server');
      socket.close();
    }
  }
  // final notif.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // notif.FlutterLocalNotificationsPlugin();
  //
  // ConversationProvider() {
  //   _configureLocalNotifications();
  // }
  //
  // Future<void> _configureLocalNotifications() async {
  //   const notif.AndroidInitializationSettings initializationSettingsAndroid =
  //   notif.AndroidInitializationSettings('app_icon');
  //
  //   final notif.InitializationSettings initializationSettings = notif.InitializationSettings(
  //     android: initializationSettingsAndroid,
  //   );
  //
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }
  //
  // Future<void> _showNotification(String messageText) async {
  //   print("mess:$messageText");
  //   const notif.AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   notif.AndroidNotificationDetails(
  //     'new_message_channel_id',
  //     'New Message',
  //     importance: notif.Importance.max,
  //     priority: notif.Priority.high,
  //   );
  //
  //   const notif.NotificationDetails platformChannelSpecifics =
  //   notif.NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   // Sử dụng timestamp hoặc một giá trị ngẫu nhiên cho ID thông báo
  //   final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     notificationId,
  //     'New Message',
  //     messageText,
  //     platformChannelSpecifics,
  //   );
  // }

}
