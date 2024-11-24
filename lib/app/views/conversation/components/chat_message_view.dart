import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/conversation_provider.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/theme_extensions.dart';
import '../../../l10n/l10n.dart';
import '../../../models/user_model.dart';

class ChatMessageView extends StatefulWidget {
  const ChatMessageView(
      {super.key, required this.conversationId, required this.receiver});
  final String conversationId;
  final User receiver;

  @override
  State<ChatMessageView> createState() => _ChatMessageViewState();
}

class _ChatMessageViewState extends State<ChatMessageView> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // late IO.Socket socket;
  // final StreamController<String> _streamController = StreamController<String>();
  Timer? _typingTimer;  // Timer to handle typing state.
  late String senderId;
  // late ConversationProvider _appProvider;
  @override
  void initState() {
    super.initState();
    // _appProvider = Provider.of<ConversationProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      callApi();
      print('id: ${getUserID()}');
      // if (!_appProvider.socket.connected) {
      //   _appProvider.connectAndListen();
      // }
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }

  @override
  void dispose() {
    // _appProvider.disconnectSocket();
    super.dispose();
  }

  bool containsImageTag(String text) {
    return !text.contains('[@isImg123@]');
  }

  void callApi() async {
    if (widget.conversationId.isNotEmpty) {
      context
          .read<ConversationProvider>()
          .getChatMessage(widget.conversationId);
    } else {
      context
          .read<ConversationProvider>()
          .getChatMessageByReceiverId(widget.receiver.id);
    }
  }

  void handleOnlineUsers(dynamic data) {
    // Handle the list of online users
    print('Online users: $data');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          toolbarHeight: 52.w,
          title: Container(
            margin: EdgeInsets.only(top: 12.h),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                    widget.receiver.avatar ?? '',
                    width: 28.w,
                    height: 28.w,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  widget.receiver.fullName,
                  style: AppTextStyles.of(context).light20.copyWith(
                        color: AppColors.of(context).neutralColor12,
                        height: 1,
                      ),
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: !context.watch<ConversationProvider>().isLoadingChatMessage
            ? GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
              child: Column(
                  children: [
                    Expanded(
                        child: SingleChildScrollView(
                      reverse: true,
                      child: ListView.builder(
                        controller: _scrollController,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount:
                            context.watch<ConversationProvider>().messages.length,
                        itemBuilder: (context, index) {
                          final messages = context.watch<ConversationProvider>().messages;
                          final message = messages[index];
                          final bool isMe = message.senderId != widget.receiver.id;

                          // Kiểm tra xem tin nhắn trước đó và sau đó có phải từ cùng 1 người gửi không
                          final bool shouldShowAvatar = (index == 0 || messages[index - 1].senderId != message.senderId);
                          return Container(
                            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nếu không phải mình gửi và tin nhắn trước đó không phải từ cùng 1 người gửi thì hiển thị avatar
                                if (!isMe && shouldShowAvatar)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      widget.receiver.avatar ?? '',
                                      width: 28.w,
                                      height: 28.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                // Nếu avatar không hiển thị, thêm một SizedBox với kích thước tương đương để đẩy nội dung
                                if (!isMe && !shouldShowAvatar)
                                  SizedBox(width: 28.w), // Kích thước của avatar để tạo khoảng trống

                                SizedBox(width: 8.w), // Thêm khoảng trống giữa avatar/không avatar và tin nhắn
                                Expanded( // Đảm bảo nội dung tin nhắn không vượt quá không gian sẵn có
                                  child: Column(
                                    crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                    children: [
                                      containsImageTag(message.text!) != false
                                          ? Container(
                                        margin: EdgeInsets.only(
                                          top: 4.h,
                                          left: isMe ? 92.w : 8.w,
                                          right: !isMe ? 92.w : 8.w,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? AppColors.of(context).primaryColor3
                                              : AppColors.of(context).neutralColor4,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: Text(
                                          message.text ?? '',
                                          style: AppTextStyles.of(context).regular20.copyWith(
                                            color: AppColors.of(context).neutralColor12,
                                          ),
                                        ),
                                      )
                                          : Container(
                                        margin: EdgeInsets.only(
                                          top: 4.h,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 12.w,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(15),
                                          child: Image.network(
                                            message.text!.replaceAll('[@isImg123@]', ''),
                                            width: 140.w,
                                            height: 140.w,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )),
                    Container(
                      margin: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).neutralColor7,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: TextFormField(
                        controller: _controller,
                        onChanged: (value) {
                          // if (_typingTimer?.isActive ?? false) _typingTimer?.cancel();  // Hủy bộ đếm thời gian trước đó nếu còn gõ
                          // _startTyping();  // Gọi phương thức gửi thông báo đang gõ
                          //
                          // // Thiết lập độ trễ để phát ra sự kiện `disOnTyping` khi dừng gõ
                          // _typingTimer = Timer(const Duration(seconds: 3), () {
                          //   _stopTyping();
                          // });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          hintText: S.of(context).titleSendMessage,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide.none),
                          suffixIcon: GestureDetector(
                            onTap: _sendMessage,
                            child: Container(
                              width: 16.w,
                              margin: EdgeInsets.only(right: 12.w),
                              alignment: Alignment.center,
                              child: SvgPicture.asset(
                                Assets.icons.sendSVG,
                                color: AppColors.of(context).neutralColor9,
                                width: 24.w,
                                height: 24.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  String trimTrailingWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+$'), '');
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      final trimmedText = trimTrailingWhitespace(_controller.text);
      final conversationProvider = context.read<ConversationProvider>();
      conversationProvider.sendMessage(widget.receiver.id, trimmedText);
      if (conversationProvider.isSending != true) {
        // if (widget.conversationId.isNotEmpty) {
        //   conversationProvider.getChatMessage(widget.conversationId);
        // } else {
        conversationProvider.getConversations();
        // }
      }
// Dọn sạch controller
      _controller.clear();

      // Ngừng gửi thông báo đang nhập
      if (_typingTimer != null) {
        _typingTimer!.cancel();
        _typingTimer = null;
      }
    }
  }
  void onTyping() async{
    // socket.emit('onTyping', {
    //   'text': 'typing...',
    // });
  }
  void _startTyping() {
    final conversationProvider = context.read<ConversationProvider>();
    // Chỉ gửi thông báo nếu người gửi không phải là người nhận
    if (widget.receiver.id != getUserID() && !conversationProvider.isTyping) {
      conversationProvider.onTyping(widget.receiver.id);
    }
  }

  void _stopTyping() {
    final conversationProvider = context.read<ConversationProvider>();
    // Chỉ gửi thông báo nếu người gửi không phải là người nhận
    if (widget.receiver.id != getUserID() && conversationProvider.isTyping) {
      conversationProvider.disOnTyping(widget.receiver.id);
    }
  }



}