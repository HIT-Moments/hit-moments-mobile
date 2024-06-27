import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/models/friend_model.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hit_moments/app/providers/language_provider.dart';

class MyFriendViewSheet extends StatefulWidget {
  @override
  State<MyFriendViewSheet> createState() => _MyFriendViewSheetState();
}

class _MyFriendViewSheetState extends State<MyFriendViewSheet> {
  bool _isFocused = false; // Biến trạng thái để kiểm soát việc hiển thị
  FocusNode _focusNode = FocusNode();
  bool _showAll = false;
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<User> friendsUsers =
        usersF.where((user) => friends.friendsList!.contains(user.id)).toList();
    final List<User> friendRequestUsers = usersF
        .where((user) => friends.friendRequests!.contains(user.id))
        .toList();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${friends.friendsList!.length}/20',
                  style: const TextStyle(
                      fontSize: 26, color: ColorConstants.primaryLight1),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  AppLocalizations.of(context)!.friend,
                  style: const TextStyle(
                      fontSize: 26, color: ColorConstants.primaryLight1),
                )
              ],
            ),
            Text(
              AppLocalizations.of(context)!.addMyCloseFriends,
              style: const TextStyle(
                  fontSize: 22, color: ColorConstants.primaryLight1),
            ),
            TextFormField(
              focusNode: _focusNode,
              textAlign: _isFocused ? TextAlign.left : TextAlign.center,
              decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.addNewFriend,
                  hintStyle: const TextStyle(
                    color: ColorConstants.primaryLight1,
                    fontSize: 22,
                  ),
                  prefixIcon: _isFocused
                      ? Padding(
                          padding: const EdgeInsets.all(
                              15.0), // Adjust padding to make the icon look smaller
                          child: SvgPicture.asset(
                            'assets/icons/search.svg',
                            color: ColorConstants.primaryLight1,
                          ),
                        )
                      : null,
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none, // This removes the border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide
                        .none, // This removes the border for the enabled state
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide
                        .none, // This removes the border for the focused state
                  ),
                  filled: true,
                  fillColor: ColorConstants.primaryDark1),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              textBaseline: TextBaseline.ideographic,
              children: [
                SvgPicture.asset(
                  'assets/icons/person-fill.svg',
                  width: 24,
                  height: 24,
                  color: ColorConstants.primaryLight1,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.myFriends,
                  style: const TextStyle(
                      color: ColorConstants.primaryLight1, fontSize: 23),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: MyFriends(users: friendsUsers),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/user-star-fill.svg',
                  width: 24,
                  height: 24,
                  color: ColorConstants.primaryLight1,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.myFriendRequest,
                  style: const TextStyle(
                      color: ColorConstants.primaryLight1, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: MyFriendRequests(users: friendRequestUsers),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/suggestion.svg',
                  width: 24,
                  height: 24,
                  color: ColorConstants.primaryLight1,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  AppLocalizations.of(context)!.suggestFriend,
                  style: const TextStyle(
                      color: ColorConstants.primaryLight1, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              child: MySuggestionFriends(users: usersF),
            ),
          ],
        ),
      ),
    );
  }
}

class MyFriendView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        onPressed: () => showMyFriendViewModal(context),
        child: Text('Show My Friends'),
      ),
    ));
  }

  void showMyFriendViewModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled:
            true, // Allow the modal to expand to the full height
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            initialChildSize:
                0.95, // Start fully expanded to full screen height
            minChildSize: 0.5, // Can shrink to half screen height
            maxChildSize: 1.0, // Can expand to full screen height
            builder: (_, controller) {
              return Container(
                child: MyFriendViewSheet(),
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: ColorConstants.primaryDark1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              );
            },
          );
        });
  }
}

class MyFriends extends StatefulWidget {
  const MyFriends({super.key, required this.users});
  final List<User> users;

  @override
  State<MyFriends> createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {
  bool _showAll = false;
  @override
  Widget build(BuildContext context) {
    int itemCount = _showAll ? widget.users.length : 3;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.users[index].avatar!),
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.users[index].fullName,
                    style: TextStyle(
                        color: ColorConstants.primaryLight1, fontSize: 20),
                  )),
                  InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/multiplication-sign.svg',
                      width: 24,
                      height: 24,
                      color: ColorConstants.primaryLight1,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.users.length >
            3) // Chỉ hiển thị nút nếu có nhiều hơn 3 bạn bè
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.primaryLight1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                child: Text(
                  _showAll
                      ? AppLocalizations.of(context)!.collapse
                      : AppLocalizations.of(context)!.seeMore,
                  style: const TextStyle(
                    color: ColorConstants.primaryLight1,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MyFriendRequests extends StatefulWidget {
  const MyFriendRequests({super.key, required this.users});
  final List<User> users;

  @override
  State<MyFriendRequests> createState() => _MyFriendRequestsState();
}

class _MyFriendRequestsState extends State<MyFriendRequests> {
  bool _showAll = false;
  @override
  Widget build(BuildContext context) {
    int itemCount = _showAll ? widget.users.length : 3;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.users[index].avatar!),
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.users[index].fullName,
                    style: TextStyle(
                        color: ColorConstants.primaryLight1, fontSize: 20),
                  )),
                  InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/check.svg',
                      width: 24,
                      height: 24,
                      color: ColorConstants.primaryLight1,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  InkWell(
                    child: SvgPicture.asset(
                      'assets/icons/multiplication-sign.svg',
                      width: 24,
                      height: 24,
                      color: ColorConstants.primaryLight1,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.users.length >
            3) // Chỉ hiển thị nút nếu có nhiều hơn 3 bạn bè
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.primaryLight1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                child: Text(
                  _showAll
                      ? AppLocalizations.of(context)!.collapse
                      : AppLocalizations.of(context)!.seeMore,
                  style: const TextStyle(
                    color: ColorConstants.primaryLight1,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class MySuggestionFriends extends StatefulWidget {
  const MySuggestionFriends({super.key, required this.users});
  final List<User> users;

  @override
  State<MySuggestionFriends> createState() => _MySuggestionFriendsState();
}

class _MySuggestionFriendsState extends State<MySuggestionFriends> {
  bool _showAll = false;
  @override
  Widget build(BuildContext context) {
    int itemCount = _showAll ? widget.users.length : 3;
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.users[index].avatar!),
              ),
              title: Row(
                children: [
                  Expanded(
                      child: Text(
                    widget.users[index].fullName,
                    style: TextStyle(
                        color: ColorConstants.primaryLight1, fontSize: 20),
                  )),
                  InkWell(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: ColorConstants.primaryLight1),
                          borderRadius: BorderRadius.circular(20),
                          color: ColorConstants.primaryDark1),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/add.svg',
                            width: 20,
                            height: 20,
                            color: ColorConstants.primaryLight1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(AppLocalizations.of(context)!.add,
                                style: TextStyle(
                                    color: ColorConstants.primaryLight1,
                                    fontSize: 22)),
                          )
                        ],
                      ),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            );
          },
        ),
        if (widget.users.length >
            3) // Chỉ hiển thị nút nếu có nhiều hơn 3 bạn bè
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: ColorConstants.primaryLight1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  _showAll = !_showAll;
                });
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                child: Text(
                  _showAll
                      ? AppLocalizations.of(context)!.collapse
                      : AppLocalizations.of(context)!.seeMore,
                  style: const TextStyle(
                    color: ColorConstants.primaryLight1,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

// Bạn bè của người dùng
final Friend friends = Friend(
  userId: '1',
  friendsList: ['2', '3', '6', '7'],
  friendRequests: ['4', '5', '8', '9'],
);
// Thông tin của bạn bè
final List<User> usersF = [
  User(
    id: '2',
    fullName: 'Nguyễn Văn Nam',
    avatar:
        'https://cdn.thoitiet247.edu.vn/wp-content/uploads/2024/04/nhung-hinh-anh-girl-xinh-de-thuong.webp',
  ),
  User(
    id: '3',
    fullName: 'Trần Thị Ngọc',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-27.webp',
  ),
  User(
    id: '4',
    fullName: 'Phạm Văn Tú',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-7.webp',
  ),
  User(
    id: '5',
    fullName: 'Lê Thị Hồng',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-6.webp',
  ),
  User(
    id: '6',
    fullName: 'Nguyễn Văn E',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-30.webp',
  ),
  User(
    id: '7',
    fullName: 'Trần Thị F',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '8',
    fullName: 'Nguyễn Thị F',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
  User(
    id: '9',
    fullName: 'Trần Nguyễn',
    avatar:
        'https://cebcu.com/wp-content/uploads/2024/01/anh-gai-xinh-cute-de-thuong-het-ca-nuoc-cham-34.webp',
  ),
];
