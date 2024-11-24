import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/datasource/network_services/conversation_service.dart';
import 'package:hit_moments/app/models/react_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../core/config/enum.dart';
import '../datasource/local/storage.dart';
import '../datasource/network_services/moment_service.dart';
import '../models/message_model.dart';

class MomentProvider extends ChangeNotifier{
  String sendReactResult = "";
  String createReportResult = "";
  String createMomentResult = "";
  List<ReactModel> listReact=[];
  ModuleStatus sendReactStatus = ModuleStatus.initial;
  ModuleStatus sendMessStatus = ModuleStatus.initial;
  ModuleStatus createReportStatus = ModuleStatus.initial;
  ModuleStatus createMomentStatus = ModuleStatus.initial;
  ModuleStatus getReactStatus = ModuleStatus.initial;
  ModuleStatus deleteMomentStatus = ModuleStatus.initial;

  IO.Socket socket = IO.io('https://api.hitmoments.com', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'query': {
      'userId': getUserId(),
    }
  });

  Future<void> sendReact(String momentID) async{
    sendReactStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().sendReact(momentID);
    sendReactResult = response;
    sendReactStatus = ModuleStatus.success;
    notifyListeners();
  }
  Future<void> createReport(String momentID, String description, String error) async{
    createReportStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().createReport(momentID, description);
    if(response==201){
      createReportStatus = ModuleStatus.success;
    }else if(response==409){
      createReportResult = error;
      createReportStatus = ModuleStatus.fail;
    }
    else{
      createReportStatus = ModuleStatus.fail;
    }
    notifyListeners();
  }
  Future<void> sendMessage(String userID, String message) async{
    createReportStatus = ModuleStatus.loading;
    notifyListeners();
    int status = await ConversationService().sendMessage(userID, message);
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
      sendMessStatus = ModuleStatus.success;
      // messages.add(newMessage);
      // // messages = await ConversationService().getConversationByReceiverId(userId);
      // isSending = false;
    }else{
      sendMessStatus = ModuleStatus.fail;
    }
    notifyListeners();
  }


  Future<void> getReact(String momentID) async{
    getReactStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().getReact(momentID);
    listReact = response;
    getReactStatus = ModuleStatus.success;
    notifyListeners();
  }

  Future<void> deleteMoment(String momentID) async{
    deleteMomentStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await MomentService().deleteMoment(momentID);
    if(response==200){
      deleteMomentStatus = ModuleStatus.success;

    }else{
      deleteMomentStatus = ModuleStatus.fail;
    }
    notifyListeners();

  }

  Future<void> createMoment(String? content, String? weather, XFile image,String? musicId, String? linkMusic) async{
    createMomentStatus = ModuleStatus.loading;
    notifyListeners();
    final response =  await MomentService().createMoment(content, weather, image, musicId, linkMusic);
    if(response == 201){
      createMomentResult = "Thành công";
      createMomentStatus = ModuleStatus.success;

    }else{
      createMomentResult = "Thất bại do $response";
      createMomentStatus = ModuleStatus.fail;

    }
    notifyListeners();
  }
}