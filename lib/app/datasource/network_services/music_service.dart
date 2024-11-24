import 'package:hit_moments/app/core/base/base_connect.dart';
import 'package:hit_moments/app/core/config/api_url.dart';

import '../../models/music_model.dart';

class MusicService{
  Future<dynamic> getListMusic() async {
    try{
      final response = await BaseConnect.onRequest(
        ApiUrl.getListMusic,
        RequestMethod.GET,
      );
      if(response["statusCode"] == 200){
        List<dynamic> data = response["data"]["music"];
        return data.map((e) => Music.fromJson(e as dynamic)).toList();
      }
      return response["statusCode"];
    }
    catch(e){
      print("Lỗi $e");
      return e;
    }
  }
}