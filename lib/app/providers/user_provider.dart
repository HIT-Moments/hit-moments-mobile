// app/providers/user_provider.dart
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/datasource/network_services/auth_service.dart';
import 'package:hit_moments/app/datasource/network_services/user_service.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final AuthService authService = AuthService();
  final UserService userService = UserService();
  late List<User> users;
  late User user;
  List<User> friendList = [];
  List<User> friendListTmp = [];
  List<User> friendRequests = [];
  List<User> friendSuggests = [];
  ModuleStatus friendSuggestStatus = ModuleStatus.initial;
  String messageFSuggest = "";
  String messageSearchFriend = "";
  bool isLoandingFriendList = false,
      isLoandingFriendRequests = false,
      isLoandingFriendSuggests = false,
      isLoandingFriend = false,
      isLoandingProfiles = false,
      isLoandingUser = false,
      isLoadingProfile = false;

  bool isSearchFriend = false;

  void getFriendOfUser() async {
    isLoandingFriendList = true;
    notifyListeners();
    var response = await UserService.getFriends();
    friendList = response.map<User>((item) => User.fromJson(item)).toList();
    friendListTmp = friendList;
    isLoandingFriendList = false;
    notifyListeners();
  }

  void getFriendRequestOfUser() async {
    isLoandingFriendRequests = true;
    notifyListeners();
    var response = await UserService.getFriendsRequest();
    friendRequests = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendRequests = false;
    notifyListeners();
  }

  void getFriendUserByEmail(String emailOfFriend) async {
    isSearchFriend = true;
    notifyListeners();
    var response = await UserService.searchFriendUserByEmail(emailOfFriend);
    //
    if (response != 200) {
      friendList = response.map<User>((item) => User.fromJson(item)).toList();
      isSearchFriend = false;
      notifyListeners();
      return;
    }
  }

 void getMe() async {
    isLoandingProfiles = true;
    user = await authService.getMe() as User;
    isLoandingProfiles = false;
    notifyListeners();
  }

  void getFriendProposals() async {
    isLoandingFriendSuggests = true;
    notifyListeners();
    var response = await UserService.getListSuggestFriend();
    friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
    isLoandingFriendSuggests = false;
    notifyListeners();
  }

  void getFriendSuggest() async {
    friendSuggestStatus = ModuleStatus.loading;
    notifyListeners();
    var response = await UserService.getListSuggestFriend();
    friendSuggests = response.map<User>((item) => User.fromJson(item)).toList();
    friendSuggestStatus = ModuleStatus.success;
    notifyListeners();
  }

  void sentFriendRequest(String uid) async {
    final response = await UserService.sentRequestById(uid, false);
    messageFSuggest = response;
    notifyListeners();
  }

  void searchFriendRequest(String nameOrEmail, String errorString) async {
    friendSuggestStatus = ModuleStatus.loading;
    notifyListeners();
    final response = await UserService.searchFriendRequest(nameOrEmail);
    if (response == 0) {
      messageSearchFriend = errorString;
      friendSuggestStatus = ModuleStatus.fail;
    } else {
      friendSuggests =
          response.map<User>((item) => User.fromJson(item)).toList();
      friendSuggestStatus = ModuleStatus.success;
    }
    notifyListeners();
  }

  void refeshData() {
    friendList = friendListTmp;
    friendList.map((user) {
      print('User: ${user.fullName}, Email: ${user.email}');
    });
    // notifyListeners();
  }

  Future<void> updateUser(String? fullName, String? email, String? phoneNumber,
      String? dob, File? avatar) async {
    isLoadingProfile = true;
    notifyListeners();
    final response =
        await userService.updateUser(fullName, email, phoneNumber, dob, avatar);
    if (response != 200) {
      // print("alo");
      // print(response);
      user = User.fromJson(response);
      isLoadingProfile = false;
      print("edit provider$isLoadingProfile" );
      notifyListeners();
    }
  }
}
