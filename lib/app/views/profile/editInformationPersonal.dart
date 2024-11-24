import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_snack_bar.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import '../../core/constants/text_style_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class editInformationPersonal extends StatefulWidget {
  final User userInfor;

  const editInformationPersonal({super.key, required this.userInfor});

  @override
  State<editInformationPersonal> createState() =>
      editInformationPersonalState();
}

class editInformationPersonalState extends State<editInformationPersonal> {
  bool isEditing = false; // Add this line
  // late User userInfor;
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String? _imageFile;

  @override
  void initState() {
    super.initState();
    // context.read<UserProvider>().getMe();
    imageController.text = widget.userInfor.avatar!;
    fullNameController.text = widget.userInfor.fullName;
    phoneNumberController.text = widget.userInfor.phoneNumber ?? '';
    dobController.text = formatDate(widget.userInfor.dob!) ?? '';
    emailController.text = widget.userInfor.email! ?? '';
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   userInfor = context.watch<UserProvider>().user;
  //   imageController.text = userInfor.avatar!;
  //   fullNameController.text = userInfor.fullName;
  //   phoneNumberController.text = userInfor.phoneNumber ?? '';
  //   dobController.text = formatDate(userInfor.dob!) ?? '';
  //   emailController.text = userInfor.email! ?? '';
  // }
  Future<void> _pickImage() async {
    final action = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                S.of(context).changeYourProfilePicture,
                textAlign: TextAlign.center,
                style: TextStyleConstant.lightLight24.copyWith(
                  color: AppColors.of(context).neutralColor10,
                ),
              ),
              Text(
                S.of(context).titleChangeAvatar,
                textAlign: TextAlign.center,
                style: TextStyleConstant.lightLight20.copyWith(
                  color: AppColors.of(context).neutralColor8,
                ),
              )
            ],
          ),
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.of(context).neutralColor8,
                    width: 1,
                  ),
                  top: BorderSide(
                    color: AppColors.of(context).neutralColor8,
                    width: 1,
                  ),
                ),
              ),
              child: SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, ImageSource.camera);
                },
                child: Center(
                  child: Text(
                    S.of(context).takePicture,
                    style: TextStyleConstant.lightLight24.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.of(context).neutralColor8,
                    width: 1,
                  ),
                ),
              ),
              child: SimpleDialogOption(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      imageController.text = pickedFile.path;
                      _imageFile = pickedFile.path;
                    });
                    Navigator.pop(context);
                  }
                },
                child: Center(
                  child: Text(
                    S.of(context).selectFromGallery,
                    style: TextStyleConstant.lightLight24.copyWith(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
              },
              child: Center(
                child: Text(
                  S.of(context).cancel,
                  style: TextStyleConstant.lightLight24.copyWith(
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final String formatted = formatter.format(date);
    return formatted;
  }

  void selectedEdit(BuildContext context) async {
    if (isEditing) {
      DateTime dob = DateFormat('dd/MM/yyyy').parse(dobController.text);
      String formattedDob = DateFormat('MM/dd/yyyy').format(dob);
      await Provider.of<UserProvider>(context, listen: false).updateUser(
        fullNameController.text,
        emailController.text,
        phoneNumberController.text,
        formattedDob,
        _imageFile != null ? File(_imageFile!) : null,
      );
      if (Provider.of<UserProvider>(context, listen: false).isLoadingProfile ==
          false) {
        context.read<UserProvider>().getMe();
        setState(() {
          isEditing = !isEditing;
          context.read<AuthProvider>().updateAvatar(
              Provider.of<UserProvider>(context, listen: false).user.avatar!);
        });
        AppSnackBar.showSuccess(context,S.of(context).updateProfileSuccess);
      } else {
        AppSnackBar.showError(context,S.of(context).error, S.of(context).updateProfileFail);
      }
    } else {
      setState(() {
        isEditing = !isEditing;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.only(top: 15.w),
            child: Text(
              overflow: TextOverflow.ellipsis,
              S.of(context).personalInformation,
              style: AppTextStyles.of(context).bold32,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 60.h),
                    padding: EdgeInsets.only(top: 80.h),
                    height: 500.h,
                    decoration: BoxDecoration(
                      color: AppColors.of(context).primaryColor2,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.of(context).neutralColor8,
                          offset: const Offset(0, -2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 12.w),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Information(
                              iconUrl: Assets.icons.userProfile,
                              title: widget.userInfor.fullName,
                              isEditing: isEditing,
                              controller: fullNameController,
                              option: false,
                            ),
                            Information(
                              iconUrl: Assets.icons.phoneLight,
                              title: widget.userInfor.phoneNumber!,
                              isEditing: isEditing,
                              controller: phoneNumberController,
                              option: false,
                            ),
                            Information(
                              iconUrl: Assets.icons.calendarOutline,
                              title: formatDate(widget.userInfor.dob!),
                              isEditing: isEditing,
                              controller: dobController,
                              option: true,
                            ),
                            Information(
                              iconUrl: Assets.icons.mail2,
                              title: widget.userInfor.email!,
                              isEditing: isEditing,
                              controller: emailController,
                              option: false,
                            ),
                            SizedBox(
                              height: 20.w,
                            ),
                            GestureDetector(
                              onTap: () => selectedEdit(context),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.of(context).neutralColor7,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 8.w),
                                  child: Text(
                                    isEditing
                                        ? S.of(context).complete
                                        : S.of(context).editProfile,
                                    style: AppTextStyles.of(context)
                                        .regular20
                                        .copyWith(
                                            color: AppColors.of(context)
                                                .neutralColor11),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: _imageFile != null
                            ? Image.file(
                                File(_imageFile!),
                                height: 120.w,
                                width: 120.w,
                                fit: BoxFit.fill,
                              )
                            : Image.network(
                                widget.userInfor.avatar!,
                                height: 120.w,
                                width: 120.w,
                                fit: BoxFit.fill,
                              ),
                      ),
                      isEditing == true
                          ? Positioned(
                              right: 10,
                              bottom: 0,
                              child: GestureDetector(
                                onTap: () {
                                  _pickImage();
                                },
                                child: SvgPicture.asset(
                                  Assets.icons.add,
                                  width: 30.w,
                                  height: 30.w,
                                  // color: AppColors.of(context).primaryColor10,
                                  // color: Colors.lightBlueAccent,
                                ),
                              ))
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Information extends StatelessWidget {
  const Information({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.isEditing,
    this.controller,
    required this.option,
  });

  final String iconUrl;
  final String title;
  final bool isEditing;
  final TextEditingController? controller;
  final bool option;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            iconUrl,
            width: 20.w,
            height: 20.w,
            color: AppColors.of(context).primaryColor10,
          ),
          SizedBox(
            width: 16.w,
          ),
          SizedBox(
            width: 160.w,
            child: isEditing
                ? (option == false
                    ? TextFormField(
                        controller: controller,
                        style: AppTextStyles.of(context).light20,
                      )
                    : TextFormField(
                        controller: controller,
                        style: AppTextStyles.of(context).light20,
                        readOnly: true,
                        onTap: () => selectedDob(context),
                      ))
                : Text(
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    title,
                    style: AppTextStyles.of(context).light20,
                  ),
          ),
        ],
      ),
    );
  }

  void selectedDob(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: formatter.parse(controller!.text),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller!.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }
}


// Future<void> _pickImage() async {
//   final action = await showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text(
//           S.of(context).chooseOnAction,
//           style: TextStyleConstant.lightLight24.copyWith(
//             color: AppColors.of(context).neutralColor12,
//           ),
//         ),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               GestureDetector(
//                 child: Text(
//                   S.of(context).takePicture,
//                   style: TextStyle(color: Colors.blue, fontSize: 20.sp),
//                 ),
//                 onTap: () {
//                   Navigator.pop(context, ImageSource.camera);
//                 },
//               ),
//               Padding(padding: EdgeInsets.all(8.w)),
//               GestureDetector(
//                 child: Text(
//                   S.of(context).selectFromGallery,
//                   style: TextStyle(color: Colors.blue, fontSize: 20.sp),
//                 ),
//                 onTap: () async {
//                   final picker = ImagePicker();
//                   final pickedFile = await picker.pickImage(
//                     source: ImageSource.gallery,
//                   ); // Mở thư viện ảnh
//                   if (pickedFile != null) {
//                     setState(() {
//                       imageController.text = pickedFile.path;
//                       _imageFile = pickedFile.path;
//                     });
//                     Navigator.pop(context);
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       );
//     },
//   );
// }
