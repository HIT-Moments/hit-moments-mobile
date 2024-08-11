import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/models/user_model.dart';
import '../../core/config/api_url.dart';

class AuthService{

  Future<dynamic> login(String email, String password) async {
    Map<String, dynamic> body = {
      'email': email,
      'password': password
    };
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.login,
        RequestMethod.POST,
        body: body
      );
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        String token = response['data']['accessToken'];
        String userID = response['data']['user']['_id'];
        print("iduser: ${userID}");
        setToken(token);
        setUserID(userID);
      }else{
        print("looxi ${response['message']} vaf ${statusCode}");
      }
      return statusCode;
    }catch(e){
      print("Lỗi là: ${e}");
      return 0;
    }
  }


  Future<dynamic> register(String fullName, String phoneNumber, String dateOfBirth,
      String email, String passWord) async{
    Map<String, dynamic> body = {
      'fullname': fullName,
      'email': email,
      'password': passWord,
      'phoneNumber': phoneNumber,
      'dob': '1999-12-31T17:00:00.000Z',
    };
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.register, RequestMethod.POST, body: body);
      int statusCode = response['statusCode'];
      String mess = response['message'];
      return statusCode;
      }catch(e){
      return 0;
    }
  }
  
  Future<dynamic> getMe() async{
    try{
      var response = await BaseConnect.onRequest(
          ApiUrl.getMe, RequestMethod.GET);
      int statusCode = response['statusCode'];
      if(statusCode == 200){
        User user = User.fromJson(response['data']['user']);
        return user;
      }else{
        return statusCode;
      }
    }catch(e){
      return e.toString();
    }
  }

}