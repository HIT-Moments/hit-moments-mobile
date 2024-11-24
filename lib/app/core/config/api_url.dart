const example = 'example';

mixin class ApiUrl {
  // static const _urlBase = "https://api.hitmoments.com/v1";
  static const _urlBase = "http://192.168.0.103:3000/api/v1";
  // static const _urlBase = "http://10.218.1.162:3000/api/v1";
  static const forgotPassword = "$_urlBase/auth/forgot-password";
  static const login = "$_urlBase/auth/login";
  static const register = "$_urlBase/auth/register";
  static const getMe = "$_urlBase/auth/me";
  static const getListMoment = "$_urlBase/moments/";
  static const getListMomentByUserID = "$_urlBase/moments/user/";
  static const getFriends = "$_urlBase/friends/list-friends";
  static const getFriendsRequest = "$_urlBase/friends/list-received-request";
  static const deleteFriend = "$_urlBase/friends/delete-friend";
  static const confirmFriendRequest = "$_urlBase/friends/confirm-request";
  static const searchFriendOfUser = "$_urlBase/friends/search-user";
  static const declineFriendRequest = "$_urlBase/friends/delince-request";
  static const sentFriendRequestOfUser = "$_urlBase/friends/invite";
  static const getCurrentWeather = "http://api.weatherapi.com/v1/current.json";
  static const cancelRequestByUserId = "$_urlBase/friends/cancel-request";
  static const getConversation = "$_urlBase/conversations/me";
  static const createReport = "$_urlBase/reports";
  static const reacts = "$_urlBase/reacts";
  static const getConversationById = "$_urlBase/conversations";
  static const getListSuggestFriend = "$_urlBase/friends/suggestions";
  static const getChatMessage = "$_urlBase/messages/";
  static const sendMessage = "$_urlBase/messages";
  static const getChatMessageByReceiverId = "$_urlBase/messages";
  static const getListMusic = "$_urlBase/musics";
}
