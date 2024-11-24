import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/core/constants/assets.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/app_bar_widget.dart';
import 'package:hit_moments/app/custom/widgets/app_snack_bar.dart';
import 'package:hit_moments/app/custom/widgets/custom_dialog.dart';
import 'package:hit_moments/app/l10n/l10n.dart';
import 'package:hit_moments/app/models/user_model.dart';
import 'package:hit_moments/app/providers/list_moment_provider.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:hit_moments/app/providers/music_provider.dart';
import 'package:hit_moments/app/providers/weather_provider.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final XFile image;
  final List<User> users;

  const DisplayPictureScreen(
      {super.key, required this.image, required this.users});

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  //Controller
  late TextEditingController feelingController;
  late TextEditingController imageController;
  late TextEditingController weatherController;
  late TextEditingController locationController;
  late TextEditingController userNameController;
  late TextEditingController createAtController;
  late TextEditingController updateAtController;
  late TextEditingController imgAvatarController;
  bool checkWeather = false;
  String? weather;
  int? playingIndex;
  AudioPlayer audioPlayer = AudioPlayer();
  String? nameMusic;
  String? musicId;
  late XFile editedImage;
  String? linkMusic;

  Future<void> checkAndSaveImage(String imagePath) async {
    // Check the current status of the storage permission
    var status = await Permission.photos.status;

    if (status.isGranted) {
      // If permission is granted, save the image to the gallery
      await saveImageToGallery(imagePath);
    }
    if (status.isDenied) {
      // If permission is denied, request it
      _showError();
    }
    if (status.isPermanentlyDenied) {
      _showError();
    }
  }

  void _showError() {
    showCustomDialog(
      context,
      title: S.of(context).error,
      content: Text(
        S.of(context).errorStorage,
        style: AppTextStyles.of(context)
            .regular24
            .copyWith(color: AppColors.of(context).neutralColor12),
        textAlign: TextAlign.center,
      ),
      backgroundPositiveButton: AppColors.of(context).primaryColor10,
      textPositive: S.of(context).ok,
      onPressPositive: () async {
        Navigator.of(context).pop();
        await openAppSettings();
      },
      colorTextPositive: AppColors.of(context).primaryColor1,
      hideNegativeButton: true,
    );
  }

  Future<void> saveImageToGallery(String imagePath) async {
    final result = await ImageGallerySaver.saveFile(imagePath);
    if (result['isSuccess']) {
      // if mounted
      if (mounted) {
        AppSnackBar.showSuccess(context, S.of(context).saveImageSuccess);
      }
    } else {
      // if mounted
      if (mounted) {
        AppSnackBar.showError(
            context, S.of(context).error, S.of(context).saveImageFail);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListMomentProvider>().getListMoment();
    });
    if (context.read<WeatherProvider>().weatherStatus == ModuleStatus.initial) {
      context.read<WeatherProvider>().getCurrentPosition();
    }
    editedImage = XFile(widget.image.path);
  }

  void initController() {
    feelingController = TextEditingController();
    imageController = TextEditingController();
    weatherController = TextEditingController();
    locationController = TextEditingController();
    userNameController = TextEditingController();
    createAtController = TextEditingController();
    updateAtController = TextEditingController();
    imgAvatarController = TextEditingController();
  }

  @override
  void dispose() {
    audioPlayer.dispose(); // Dispose the audio player
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBarWidget(
          title: S.of(context).sendto,
          action: Padding(
            padding: EdgeInsets.only(right: 16.w,bottom: 8.w),
            child: GestureDetector(
              onTap: () async {
                await checkAndSaveImage(widget.image.path);
              },
              child: SvgPicture.asset(
                Assets.icons.download2SVG,
                color: AppColors.of(context).neutralColor12,
                width: 36.w,
                height: 36.w,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          // Make the entire body scrollable
          child: Column(
            children: [
              _buildHeaderPicture(),
              SizedBox(height: 50.w),
              _buildEditImage(),
              SizedBox(height: 50.h),
              _buildBottomScreen(),
            ],
          ),
        ),
      ),
    );
  }

  // Mở giao diện chỉnh sửa ảnh từ image_editor_plus
  // Open the image editor and update the displayed image on return
  Future<void> _openImageEditor() async {
    // Read the current image file as bytes
    final imageBytes = await File(editedImage.path).readAsBytes();

    // Open the image editor and wait for the edited image bytes
    final editedFileBytes = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImageEditor(
          image: imageBytes,
        ),
        fullscreenDialog: true,
      ),
    );

    // If an edited image is returned, save it to a new file and update the state
    if (editedFileBytes != null) {
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/edited_image_${DateTime.now().millisecondsSinceEpoch}.png';
      final editedFileInstance =
          await File(filePath).writeAsBytes(editedFileBytes);

      setState(() {
        // Update to the new edited image
        editedImage = XFile(editedFileInstance.path);
      });
    }
  }

  Widget _buildEditImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _openImageEditor,
        ),
      ],
    );
  }

  Widget _buildPicture() {
    return Padding(
      padding: EdgeInsets.only(top: 80.h, left: 4.w, right: 4.w),
      child: SizedBox(
        height: 1.sw - 16.w,
        width: 1.sw - 16.w,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50.w),
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.file(
              File(editedImage.path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.red);
              },
            ),
          ),
        ),
      ),
      // child: AspectRatio(
      //   aspectRatio: 3 / 4,
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(50),
      //     child: Image.file(
      //       File(editedImage.path),
      //       fit: BoxFit.cover,
      //       errorBuilder: (context, error, stackTrace) {
      //         return const Icon(Icons.error, color: Colors.red);
      //       },
      //     ),
      //   ),
      // ),
    );
  }

  void showModalSheetSelectMusic(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final musicProvider = context.watch<MusicProvider>();
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter set) {
            return Container(
              padding: EdgeInsets.all(16.w),
              child: musicProvider.isLoadingListMusic
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.of(context).neutralColor6,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.searchNameMusic,
                              hintStyle: AppTextStyles.of(context)
                                  .light20
                                  .copyWith(
                                      color:
                                          AppColors.of(context).neutralColor12),

                              contentPadding: EdgeInsets.only(
                                  left: 16.w,
                                  right: 16.w,
                                  top: 6.w,
                                  bottom: 6.w),
                              border: InputBorder.none,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // musicProvider.searchMusic();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8.w),
                                  margin: EdgeInsets.only(right: 8.w),
                                  child: SvgPicture.asset(
                                    Assets.icons.search,
                                    color: AppColors.of(context).neutralColor10,
                                  ),
                                ),
                              ),
                            ),
                            style: AppTextStyles.of(context)
                                .light20
                                .copyWith(color: AppColors.of(context).neutralColor12),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: musicProvider.musics.length,
                            itemBuilder: (context, index) {
                              final music = musicProvider.musics[index];
                              bool isPlaying = playingIndex == index;
                              return ListTile(
                                onTap: () {
                                  set(() {
                                    if (playingIndex == index) {
                                      playingIndex = null;
                                      audioPlayer.stop();
                                      setState(() {
                                        nameMusic = null;
                                        musicId = null;
                                        linkMusic = null;
                                      }); // Stop the music
                                    } else {
                                      playingIndex = index;
                                      audioPlayer.play(UrlSource(
                                          music.linkMusic)); // Play the music
                                      setState(() {
                                        nameMusic = music.name;
                                        musicId = music.id;
                                        linkMusic = music.linkMusic;
                                      });
                                    }
                                  });
                                },
                                title: Row(
                                  children: [
                                    isPlaying
                                        ? Image.asset(
                                            Assets.icons.musicGif,
                                            width: 20.w,
                                            height: 20.w,
                                            color: AppColors.of(context)
                                                .neutralColor12,
                                          )
                                        : const SizedBox(),
                                    Text(music.name,
                                        style: AppTextStyles.of(context)
                                            .light24
                                            .copyWith(
                                                color: AppColors.of(context)
                                                    .neutralColor12)),
                                  ],
                                ),
                                subtitle: Text(music.author,
                                    style: AppTextStyles.of(context)
                                        .light16
                                        .copyWith(
                                            color: AppColors.of(context)
                                                .neutralColor9)),
                                trailing: GestureDetector(
                                  onTap: () {
                                    set(() {
                                      if (playingIndex == index) {
                                        playingIndex = null;
                                        audioPlayer.stop();
                                        setState(() {
                                          nameMusic = null;
                                          musicId = null;
                                        }); // Stop the music
                                      } else {
                                        playingIndex = index;
                                        audioPlayer.play(UrlSource(
                                            music.linkMusic)); // Play the music
                                        setState(() {
                                          nameMusic = music.name;
                                          musicId = music.id;
                                        });
                                      }
                                    });
                                  },
                                  child: isPlaying
                                      ? SvgPicture.asset(
                                          Assets.icons.pause,
                                          color: AppColors.of(context)
                                              .primaryColor10,
                                          width: 24.w,
                                          height: 24.w,
                                        )
                                      : SvgPicture.asset(
                                          Assets.icons.playMusic,
                                          color: AppColors.of(context)
                                              .neutralColor10,
                                          width: 24.w,
                                          height: 24.w,
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            );
          },
        );
      },
    );
  }

  Future<void> createMoment() async {
    final momentProvider = context.read<MomentProvider>();
    if (checkWeather == false) {
      weather = "";
    } else {
      weather = weatherController.text;
    }
    await momentProvider.createMoment(
        feelingController.text, weather, editedImage, musicId, linkMusic);
    if (momentProvider.createMomentStatus == ModuleStatus.success) {
      await context.read<ListMomentProvider>().getListMoment();
      Navigator.of(context).pop();
      AppSnackBar.showSuccess(context, S.of(context).createMomentSuccess);
    } else {
      // Navigator.of(context).pop();
      AppSnackBar.showError(context, S.of(context).error,
          S.of(context).error + S.of(context).createMomentFail);
    }
  }

  Widget _buildHeaderPicture() {
    return Form(
      key: _globalKey,
      child: Stack(alignment: Alignment.topRight, children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _buildPicture(),
            !context.watch<MusicProvider>().isLoadingListMusic
                ? Positioned(
                    top: 80.w,
                    child: GestureDetector(
                      onTap: () {
                        showModalSheetSelectMusic(context);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.of(context).neutralColor11,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 4.w),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              Assets.icons.music,
                              width: 14.w,
                              height: 14.w,
                              color: AppColors.of(context).neutralColor1,
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              nameMusic != null
                                  ? nameMusic!
                                  : AppLocalizations.of(context)!.addMusic,
                              style: AppTextStyles.of(context).light14.copyWith(
                                  color: AppColors.of(context).neutralColor1),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            Consumer<WeatherProvider>(
                builder: (context, weatherProvider, child) {
              if (weatherProvider.weatherStatus != ModuleStatus.initial) {
                weatherController.text =
                    "${weatherProvider.weather?.city}|${weatherProvider.weather?.tempC}|${weatherProvider.weather?.icon}";
                return checkWeather
                    ? Positioned(
                        top: 88.w,
                        right: 10.w,
                        width: weatherProvider.weather?.icon == null
                            ? MediaQuery.of(context).size.width / 3.5
                            : MediaQuery.of(context).size.width / 2.7,
                        child: Row(
                          children: [
                            weatherProvider.weather?.icon == null
                                ? SvgPicture.asset(Assets.icons.sunSVG,
                                    height: 14.w, width: 12.w)
                                : CachedNetworkImage(
                                    imageUrl:
                                        "https:${weatherProvider.weather?.icon}",
                                    fit: BoxFit.cover,
                                  ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3)
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.only(left: 8.w, right: 8.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      textAlign: TextAlign.center,
                                      weatherProvider.weather?.city ?? "",
                                      maxLines: 1,
                                      style: AppTextStyles.of(context)
                                          .light14
                                          .copyWith(
                                        height: 1,
                                        overflow: TextOverflow.ellipsis,
                                        color:
                                            AppColors.of(context).neutralColor1,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1.0,
                                            color: AppColors.of(context)
                                                .neutralColor12,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      "${weatherProvider.weather?.tempC ?? 29}℃",
                                      style: AppTextStyles.of(context)
                                          .regular16
                                          .copyWith(
                                        height: 1,
                                        color:
                                            AppColors.of(context).neutralColor3,
                                        shadows: [
                                          Shadow(
                                            blurRadius: 1.0,
                                            color: AppColors.of(context)
                                                .neutralColor12,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox();
              } else {
                return const SizedBox();
              }
            }),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 88.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.of(context).neutralColor7,
                borderRadius: BorderRadius.circular(20.w),
              ),
              child: TextFormField(
                enableSuggestions: false,
                autocorrect: false,
                controller: feelingController,
                style: AppTextStyles.of(context)
                    .light20
                    .copyWith(color: AppColors.of(context).neutralColor12, height: 1),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textAlignVertical: TextAlignVertical.center,
                cursorHeight: 20.h,
                cursorColor: AppColors.of(context).neutralColor10,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.feel,
                  isCollapsed: true, // Bắt buộc không thêm padding mặc định
                  hintStyle: AppTextStyles.of(context)
                      .light16
                      .copyWith(color: AppColors.of(context).neutralColor1),
                  contentPadding: EdgeInsets.only(
                      left: 12.w, right: 8.w, top: 7.w, bottom: 4.w),
                  counterStyle: AppTextStyles.of(context)
                      .light16
                      .copyWith(color: AppColors.of(context).neutralColor12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.w),
                    borderSide: BorderSide(color: AppColors.of(context).neutralColor7),
                  ),
                  disabledBorder: OutlineInputBorder(
                      borderSide:  BorderSide(color: AppColors.of(context).neutralColor7), borderRadius: BorderRadius.circular(20.w)),
                  enabledBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColors.of(context).neutralColor7),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:  BorderSide(color: AppColors.of(context).neutralColor7),
                    borderRadius: BorderRadius.circular(20.w),
                  ),
                  counterText: "", // Add this line
                ),
                maxLines: 1,
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Widget _buildBottomScreen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
          onTap: () async {
            Navigator.of(context).pop();
          },
          child: SvgPicture.asset(
            Assets.icons.remove,
            color: AppColors.of(context).neutralColor12,
            width: 36.w,
            height: 36.w,
          ),
        ),
        OutlinedButton(
          onPressed: () async {
            createMoment();
          },
          style: OutlinedButton.styleFrom(
              fixedSize: const Size(65, 65),
              backgroundColor: AppColors.of(context).neutralColor6,
              shape: const CircleBorder(),
              side: BorderSide(
                  color: AppColors.of(context).primaryColor10, width: 4),
              padding: const EdgeInsets.fromLTRB(4, 6, 12, 2)),
          child: SvgPicture.asset(
            Assets.icons.sendSVG,
            height: 60.w,
            width: 60.w,
            color: AppColors.of(context).neutralColor12,
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              checkWeather = !checkWeather;
            });
          },
          child: !checkWeather
              ? SvgPicture.asset(
                  Assets.icons.cloud1SVG,
                  color: AppColors.of(context).neutralColor12,
                )
              : SvgPicture.asset(Assets.icons.cloud2SVG),
        ),
      ],
    );
  }
}
