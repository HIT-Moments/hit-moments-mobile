import 'package:flutter/cupertino.dart';

import '../datasource/network_services/music_service.dart';
import '../models/music_model.dart';

class MusicProvider extends ChangeNotifier{
  List<Music> musics = [];
  bool isLoadingListMusic = false;
  MusicService musicService = MusicService();
  void getListMusic()async{
    isLoadingListMusic = true;
    notifyListeners();
    try{
      var res = await musicService.getListMusic();
      if(res!=200){
        musics = res;
        isLoadingListMusic = false;
        notifyListeners();
      }
    }catch(e){
      print("Lỗi $e");
    }
  }
}