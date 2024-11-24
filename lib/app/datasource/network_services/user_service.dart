import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:mime/mime.dart';
import '../../core/base/base_connect.dart';
import '../../core/config/api_url.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserService {
  static Future<dynamic> getFriends() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getFriends,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      print(response['data']["friendList"]);
      if (statusCode == 200) {
        return response['data']["friendList"];
      } else {
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> getFriendsRequest() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getFriendsRequest,
        RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      if (statusCode == 200) {
        return response['data']["friendRequests"];
      } else {
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<int> deleteFriendOfUserById(String id) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.deleteFriend, RequestMethod.DELETE,
          body: {"friendId": id});
      print("Status delete friend: ${response['statusCode']}");
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<int> confirmFriendRequestOfUserBy(
      String friendId, int option) async {
    try {
      var response;
      if (option == 1) {
        response = await BaseConnect.onRequest(
            ApiUrl.confirmFriendRequest, RequestMethod.POST,
            body: {"requesterId": friendId});
      } else {
        response = await BaseConnect.onRequest(
            ApiUrl.declineFriendRequest, RequestMethod.POST,
            body: {"requesterId": friendId});
      }
      print("Status decline friend: ${response['statusCode']}");
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> searchFriendUserByEmail(String emailOfFriend) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.searchFriendOfUser, RequestMethod.GET,
          queryParam: {"search": emailOfFriend});
      print("Status search friend: ${response['data']['users']}");
      if(response["statusCode"] == 200){
        return response["data"]["users"];
      }
      else{
        return response["statusCode"];
      }
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> sentRequestById(String id, bool isResult) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.sentFriendRequestOfUser, RequestMethod.POST,
          body: {"receiverId": id});
      if(isResult){
        int statusCode = response['statusCode'];
        return statusCode;
      }else{
        return response['statusCode']['message'];
      }
    } catch (e) {
      if(isResult){
        print("Lỗi: ${e}");
        return 0;
      }else{
        return e.toString();
      }

    }
  }

  static Future<int> cancelRequestByUserId(String id) async {
    try {
      var response = await BaseConnect.onRequest(
          ApiUrl.cancelRequestByUserId, RequestMethod.POST,
          body: {"receiverId": id});
      return response['statusCode'];
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }

  static Future<dynamic> getListSuggestFriend() async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.getListSuggestFriend,
        RequestMethod.GET,
      );
      return response['data']["suggestedUsers"].take(5);
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic> searchFriendRequest(String nameOrEmail) async {
    try {
      var response = await BaseConnect.onRequest(
        ApiUrl.searchFriendOfUser,
        RequestMethod.GET,
        queryParam: {"search": nameOrEmail}
      );
      return response['data']["users"].take(5);
    } catch (e) {
      print("Lỗi: ${e}");
      return 0;
    }
  }
  static Future<dynamic>getMe() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getMe,
          RequestMethod.GET,
      );
      int statusCode = response['statusCode'];
      print(response['data']["user"]);
      if(statusCode == 200){
        print(response['data']["user"]);
        return User.fromJson(response['data']["user"]);
      }else{
        print("Lỗi: ${response['message']} ");
      }
      return statusCode;
    }catch(e){
      print("Lỗi: ${e}");
      return 0;
    }
  }
  Future<dynamic> updateUser(String? fullName,String? email, String? phoneNumber, String? dob,  File? avatar) async {
    try {
      // Tạo yêu cầu MultipartRequest
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(ApiUrl.getMe),
      );
      if (avatar != null) {
        File file = File(avatar.path);
        if (!await file.exists()) {
          print("File does not exist at path: ${file.path}");
          return "File does not exist";
        }
        // Lấy MIME type của tệp
        String? mimeType = lookupMimeType(file.path);
        if (mimeType == null) {
          print("MIME type could not be determined");
          return "MIME type could not be determined";
        }
        request.files.add(await http.MultipartFile.fromPath(
          'avatar',
          file.path,
          contentType: MediaType.parse(mimeType),
          filename: 'update_avatar.jpg',
        ));
      }
      request.headers['Authorization'] = 'Bearer ${getToken()}';
      if(fullName != null) {
        request.fields['fullname'] = fullName;
      }
      if(email != null) {
        request.fields['email'] = email;
      }
      if(phoneNumber != null) {
        request.fields['phoneNumber'] = phoneNumber;
      }
      if(dob != "" && dob != null) {
        request.fields['dob'] = dob;
      }
      var response = await request.send();
      var responseStream = response.stream.transform(utf8.decoder);
      var body = await responseStream.join();
      // print(body);
      int statusCode = response.statusCode;
      if(statusCode == 200) {
        var jsonResponse = jsonDecode(body);
        var user = jsonResponse['data']['user'];
        setAvatarUser(user['avatar']);
        return user;
      }
      else{
        return statusCode;
      }
    } catch (e) {
      print("Error while uploading file: $e");
      return e;
    }
  }
}

