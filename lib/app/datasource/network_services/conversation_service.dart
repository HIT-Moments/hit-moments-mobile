import 'package:hit_moments/app/models/chat_message_model.dart';
import 'package:hit_moments/app/models/message_model.dart';

import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
import '../../models/conversation_model.dart';
// class ConversationService{
//   Future<List<Conversation>> getConversations() async {
//     try {
//       print("getConversations");
//       var response = await BaseConnect.onRequest(
//         ApiUrl.getConversation,
//         RequestMethod.GET,
//       );
//       int statusCode = response['statusCode'];
//       if (statusCode == 200) {
//         List<Map<String, dynamic>> conversationList = response['data']["myConversations"];
//         return conversationList.map((item) => Conversation.fromJson(item)).toList().cast<Conversation>();
//       } else {
//         print("Lỗi: ${response['message']} ");
//       }
//     } catch (e) {
//       print("Lỗi: ${e}");
//     }
//     return [];
//   }
// }
class ConversationService{
  Future<dynamic> getConversations() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getConversation,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List< dynamic> conversationList = response['data']["conversations"]??[] ;
        return conversationList.map((item) => Conversation.fromJson(item as dynamic)).toList();
      } else {
        return statusCode;
      }
    } catch (e) {
      print("Lỗi: $e");
    }
    return [];
  }
  Future<List<Message>> getConversationById(String conversationId) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getConversationById,
        RequestMethod.GET,
        idParam: conversationId,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List<dynamic> messageList = response['data']["conversation"]["messages"];
        return messageList.map((item) => Message.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        print("Lỗi: ${response['message']} ");
      }
    } catch (e) {
      print("Lỗi: ${e}");
    }
    return [];
  }
  Future<List<Message>> getConversationByReceiverId(String userId) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getChatMessageByReceiverId,
        RequestMethod.GET,
        idParam: userId,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        List<dynamic> messageList = response['data']["message"];
        return messageList.map((item) => Message.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        print("Lỗi: ${response['message']} ");
      }
    } catch (e) {
      print("Lỗi: ${e}");
    }
    return [];
  }
  Future<dynamic>sendMessage(String userId,String text) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.sendMessage,
        RequestMethod.POST,
        body: {
          "text": text,
        },
        idParam: userId,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        print("Gửi tin nhắn thành công");
      } else {
        print("Lỗi: ${response['message']} ");
      }
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
    }
  }
}