import 'package:flutter/foundation.dart';
import 'package:hit_moments/app/core/config/enum.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart' as notif;
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/message_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../datasource/network_services/conversation_service.dart';
import '../models/chat_message_model.dart';
import '../models/conversation_model.dart';

class ConversationProvider extends ChangeNotifier {
  List<Conversation> conversations = [];
  ModuleStatus loadingMessageStatus = ModuleStatus.initial;
  bool isLoading = false;
  bool isLoadingChatMessage = false;
  List<ChatMessage> chatMessages = [];
  List<Message> messages = [];
  bool isSending = false;
  bool isTyping = false;
  // https://api.hitmoments.com
  IO.Socket socket = IO.io('http://192.168.0.104:3000', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'query': {
      'userId': getUserID(),
    }
  });

  void getConversations() async {
    // isLoading = true;
    loadingMessageStatus = ModuleStatus.loading;
    notifyListeners();
    final data = await ConversationService().getConversations();
    if(data is List<Conversation>) {
      conversations = data;
      loadingMessageStatus = ModuleStatus.success;
    } else {
      loadingMessageStatus = ModuleStatus.fail;
    }
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
  void onTyping(String userId) {
    isTyping = true; // Đặt trạng thái gõ là true
    socket.emit('onTyping', {
      'userId': userId, // Gửi ID người dùng
    });
    notifyListeners();
  }

  void disOnTyping(String userId) {
    isTyping = false; // Đặt trạng thái gõ là false
    socket.emit('disOnTyping', {
      'userId': userId, // Gửi ID người dùng
    });
    notifyListeners();
  }

  void connectAndListen() async {
    socket.onConnect((_) {
      print('Connected to the server'); // Debug print
    });
    socket.on('newMessage', (data) {
      // print('newMessage event triggered $data'); // Debug print
      // _showNotification(data['text']);
      messages.add(Message.fromJson(data as Map<String, dynamic>));
      notifyListeners();
    });
    socket.on('onTyping', (data) {
      if (data['userId'] != getUserID()) { // Chỉ cập nhật trạng thái gõ cho người nhận
        isTyping = true;
        print("On typing");
        notifyListeners();
      }
    });

    socket.on('disOnTyping', (data) {
      if (data['userId'] != getUserID()) { // Chỉ cập nhật trạng thái dừng gõ cho người nhận
        isTyping = false;
        print("disOn typing");
        notifyListeners();
      }
    });
    socket.connect();
  }

  void disconnectSocket() {
    if (socket.connected) {
      // print('Disconnected from the server');
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
