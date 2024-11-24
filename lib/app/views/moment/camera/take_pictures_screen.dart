import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/providers/auth_provider.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';

import '../../../providers/music_provider.dart';
import '../../../providers/user_provider.dart';
import 'display_pictures_screen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.pageParentController});

  final PageController pageParentController;

  @override
  State<TakePictureScreen> createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late List<CameraDescription> cameras;
  late CameraController cameraController;
  bool isCameraReady = false;
  int direction = 0;
  FlashMode _flashMode = FlashMode.off;
  double zoomLevel = 1.0; // Zoom level from 1x to 5x

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isCameraReady) {  // Chỉ khởi tạo camera nếu chưa sẵn sàng
        startCamera(direction);
      }
      context.read<AuthProvider>().updateAvatar(getAvatarUser());
      context.read<MusicProvider>().getListMusic();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isCameraReady) {
      startCamera(direction);
    }
  }


// Add this method to toggle flash
  void toggleFlash() {
    setState(() {
      _flashMode =
          _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
    });
    cameraController.setFlashMode(_flashMode);
  }

  void turnOffFlash() {
    setState(() {
      _flashMode = FlashMode.off;
    });
    cameraController.setFlashMode(_flashMode);
  }

  Future<void> startCamera(int direction) async {
    try {
      cameras = await availableCameras();
    } catch (e) {
      return;
    }

    if (cameras.isEmpty) {
      return;
    }

    cameraController = CameraController(
      cameras[direction],
      ResolutionPreset.max,
      enableAudio: false,
    );

    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        isCameraReady = true;
      });
    }).catchError((e) {});
  }

  Future<File> cropImageToAspectRatio(File imageFile) async {
    final image = img.decodeImage(await imageFile.readAsBytes());
    final width = image?.width;
    final height = image?.height;

    // Tính toán kích thước mới để cắt theo tỷ lệ 3:4
    int? newWidth = width;
    int newHeight = (width! * 4) ~/ 3;

    if (newHeight > height!) {
      newHeight = height;
      newWidth = (height * 3) ~/ 4;
    }

    final croppedImage = img.copyCrop(
      image!,
      x: (width - newWidth!) ~/ 2,
      y: (height - newHeight) ~/ 2,
      width: newWidth,
      height: newHeight,
    );

    // Lưu ảnh đã cắt ra file mới
    final newPath =
        '${imageFile.path.substring(0, imageFile.path.length - 4)}_cropped.jpg';
    final croppedFile = File(newPath);
    await croppedFile.writeAsBytes(img.encodeJpg(croppedImage));

    return croppedFile;
  }

  // Change Zoom Level
  void toggleZoom() {
    setState(() {
      zoomLevel =
          zoomLevel >= 3.0 ? 1.0 : zoomLevel + 1.0; // Cycle zoom from 1x to 5x
    });
    cameraController.setZoomLevel(zoomLevel);
  }
  @override
  void deactivate() {
    // Dừng camera khi widget không còn visible
    cameraController.stopImageStream();
    super.deactivate();
  }


  @override
  void dispose() {
    // Dừng camera preview và giải phóng tài nguyên
    cameraController.stopImageStream();  // Dừng camera stream nếu đang chạy
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraReady) {
      return SafeArea(
          child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.of(context).primaryColor1,
          centerTitle: true,
          title: Container(
            margin: EdgeInsets.only(top: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () async {
                    await cameraController.pausePreview(); // Dừng camera
                    Navigator.pushNamed(context, AppRoutes.MY_PROFILE).then((_) async {
                      // Tiếp tục camera khi quay lại màn hình
                      await cameraController.resumePreview();
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: AppColors.of(context).neutralColor7,
                            width: 4.w)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        context.watch<AuthProvider>().avatar!,
                        width: 28.w,
                        height: 28.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await cameraController.pausePreview(); // Dừng camera
                    Navigator.pushNamed(context, AppRoutes.LIST_MY_FRIEND).then((_) async {
                      // Tiếp tục camera khi quay lại màn hình
                      await cameraController.resumePreview();
                    });
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.of(context).neutralColor7),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SvgPicture.asset(
                          Assets.icons.usersSVG,
                          height: 24.w,
                          width: 24.w,
                          color: AppColors.of(context).neutralColor11,
                        ),
                        Text(
                          AppLocalizations.of(context)!.addfriend,
                          style: AppTextStyles.of(context).regular24.copyWith(
                                color: AppColors.of(context).neutralColor11,
                              ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: AppColors.of(context).neutralColor6,
                  ),
                  child: GestureDetector(
                    child: SvgPicture.asset(
                      Assets.icons.message,
                      width: 20.w,
                      height: 20.w,
                      // color: AppColors.of(context).neutralColor6,
                    ),
                    // onTap: () =>
                    //     Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION),
                    onTap: () async {
                      await cameraController.pausePreview(); // Dừng camera
                      Navigator.pushNamed(context, AppRoutes.MY_CONVERSATION).then((_) async {
                        // Tiếp tục camera khi quay lại màn hình
                        await cameraController.resumePreview();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          toolbarHeight: 52.w, // Set the height of the AppBar here
        ),
        body: Container(
          margin:
              EdgeInsets.only(top: 80.h, left: 4.w, right: 4.w, bottom: 12.w),
          alignment: Alignment.center,
          child: Column(
            children: [
              Stack(
                children: [
                  // Center(
                  //   child: AspectRatio(
                  //     aspectRatio: 3 / 4,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(50),
                  //       child: CameraPreview(cameraController!),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 1.sw,
                    width: 1.sw,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.w),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width: cameraController.value.previewSize!.height,
                          height: cameraController.value.previewSize!.width,
                          child: CameraPreview(cameraController),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 20.h,
                    child: InkWell(
                      onTap: toggleZoom,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 4.w),
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor8,
                          borderRadius: BorderRadius.circular(50.w),
                        ),
                        child: Text(
                          "${zoomLevel.toStringAsFixed(0)}x",
                          style: AppTextStyles.of(context).regular12.copyWith(
                                color: AppColors.of(context).neutralColor1,
                              ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10.w,
                    top: 20.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.of(context).neutralColor8,
                      ),
                      child: InkWell(
                        onTap: toggleFlash,
                        child: SvgPicture.asset(
                          Assets.icons.lightning,
                          color: _flashMode == FlashMode.torch
                              ? AppColors.of(context)
                                  .primaryColor9 // Flash on color
                              : AppColors.of(context)
                                  .neutralColor1, // Fla// sh off color
                          width: 20.w,
                          height: 20.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 70.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 67.w,
                    height: 56.w,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(50)),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        'assets/icons/ic_library.svg',
                        width: 67.w,
                        height: 56.w,
                        color: AppColors.of(context).neutralColor12,
                      ),
                      onPressed: (){},
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      final image = await cameraController.takePicture();
                      //final croppedImage = await cropImageToAspectRatio(File(image.path));
                      turnOffFlash();
                      if (!context.mounted) return;
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(
                                image: image,
                                //imagePath: croppedImage.path,
                                users: context.watch<UserProvider>().friendList,
                              )));
                    },
                    style: OutlinedButton.styleFrom(
                        fixedSize: const Size(65, 65),
                        shape: const CircleBorder(),
                        side: BorderSide(
                            color: AppColors.of(context).primaryColor10,
                            width: 4.w),
                        padding: const EdgeInsets.all(6)),
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor8,
                          borderRadius: BorderRadius.circular(50)),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset(
                      Assets.icons.swap,
                      width: 67.w,
                      height: 56.w,
                      color: AppColors.of(context).neutralColor12,
                    ),
                    onPressed: () {
                      setState(() {
                        direction = direction == 0 ? 1 : 0;
                        startCamera(direction);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 28.w,
              ),
              Text(
                S.of(context).history,
                style: AppTextStyles.of(context).regular24.copyWith(
                      color: AppColors.of(context).neutralColor12,
                    ),
              ),
              GestureDetector(
                onTap: () {
                  widget.pageParentController.nextPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut);
                },
                child: SvgPicture.asset(
                  Assets.icons.downSVG,
                  width: 16.w,
                  height: 16.w,
                  color: AppColors.of(context).neutralColor9,
                ),
              ),
            ],
          ),
        ),
      ));
    } else {
      return const SizedBox();
    }
  }
}
