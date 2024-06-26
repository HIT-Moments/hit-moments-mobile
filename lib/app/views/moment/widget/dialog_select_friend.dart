import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';

class DialogSelectFriend extends StatefulWidget {
  const DialogSelectFriend({super.key, required this.options, required this.isBack});
  final List<Map<String, dynamic>> options;
  final void Function() isBack;
  @override
  State<DialogSelectFriend> createState() => _DialogSelectFriendState();
}

class _DialogSelectFriendState extends State<DialogSelectFriend> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height/1.8),
      child: AlertDialog(
        
        content: Container(
          height: MediaQuery.of(context).size.height/4.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.options.map((selectedOption) {
                return Column(
                  children: [
                    ListTile(
                      title: SizedBox(
                        child: Row(
                          children: [
                            CircleAvatar(
                                radius: 17.w,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage("https://image.phunuonline.com.vn/fckeditor/upload/2024/20240509/images/fan-taylor-swift-cuu-doanh-_791715219308.jpg"),
                                  radius: 16.w,
                                )
                            ),
                            SizedBox(width: 8.w,),
                            Text(
                              selectedOption["menu"]??"",
                              style: AppTextStyles.of(context).light20.copyWith(
                                color: AppColors.of(context).neutralColor11
                              ),
                            )
                          ],
                        ),
                      ),
                      onTap: () {
                        widget.isBack();
                        Navigator.pop(context, selectedOption);
                      },
                    ),
                    if (widget.options.indexOf(selectedOption) < widget.options.length - 1)
                      Divider(
                        color: Colors.grey,
                        height: ScreenUtil().setHeight(1.0),
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
