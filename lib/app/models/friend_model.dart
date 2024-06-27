class Friend {
  final String userId;
  final List<String>? friendsList;
  final List<String>? friendRequests;

  Friend({
    required this.userId,
    this.friendsList,
    this.friendRequests,
  });
}
