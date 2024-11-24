// import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:hit_moments/app/core/config/enum.dart';
// import 'package:hit_moments/app/models/moment_model.dart';
// import 'package:hit_moments/app/providers/moment_provider.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
//
// import '../../../core/constants/assets.dart';
// import '../../../core/extensions/format_time_extension.dart';
// import '../../../core/extensions/theme_extensions.dart';
//
// class MomentContentWidget extends StatefulWidget {
//   const MomentContentWidget({super.key, required this.momentModel});
//
//   final MomentModel momentModel;
//
//   @override
//   State<MomentContentWidget> createState() => _MomentContentWidgetState();
// }
//
// class _MomentContentWidgetState extends State<MomentContentWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   bool _isAnimationVisible = false;
//   late AudioPlayer _audioPlayer;
//   late AnimationController _animationController;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     parseString(widget.momentModel.weather ?? "");
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           setState(() {
//             _isAnimationVisible = false;
//           });
//         }
//       });
//     _audioPlayer = AudioPlayer();
//   }
//
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _controller.dispose();
//     // _animationController.dispose();
//     _audioPlayer.dispose();
//     super.dispose();
//   }
//
//   String? address;
//   String? temperature;
//   String? urlIcon;
//
//   void parseString(String input) {
//     print("alo$input");
//     final regex = RegExp(r'^(.*?)\|(.*?)\|(.*?)$');
//
//     if (regex.hasMatch(input)) {
//       final match = regex.firstMatch(input);
//
//       if (match != null) {
//         address = match.group(1);
//         temperature = match.group(2);
//         urlIcon = match.group(3);
//       }
//     }
//   }
//
//   Future<void> _togglePlayPause() async {
//     if (_isPlaying) {
//       // Pause the music and stop animation
//       await _audioPlayer.pause();
//     } else {
//       // Play the music and start animation
//       await _audioPlayer.play(UrlSource(widget.momentModel.linkMusic ?? ''));
//       // _animationController.repeat();
//     }
//     setState(() {
//       _isPlaying = !_isPlaying;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (context.watch<MomentProvider>().sendReactStatus ==
//         ModuleStatus.loading) {
//       setState(() {
//         _isAnimationVisible = true;
//       });
//       _controller.forward(from: 0);
//     }
//
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(50),
//           child: AspectRatio(
//             aspectRatio: 3 / 4,
//             child: Image.network(
//               widget.momentModel.image!,
//               fit: BoxFit.fill,
//               // width: 1.sw - 4.w,
//               // height: 1.sw - 4.w,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 16.w,
//           left: 16.w,
//           width: MediaQuery.of(context).size.width / 2,
//           child: Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(2),
//                 decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.all(Radius.circular(100))),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(40.w),
//                   child: CachedNetworkImage(
//                     imageUrl: widget.momentModel.imgAvatar ?? "",
//                     width: 40.w,
//                     height: 40.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: 8.w,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.momentModel.userName ?? "",
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                       style: AppTextStyles.of(context).regular16.copyWith(
//                         overflow: TextOverflow.ellipsis,
//                         color: AppColors.of(context).neutralColor1,
//                         shadows: [
//                           const Shadow(
//                             blurRadius: 1.0,
//                             color: Colors.black,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text(
//                       FormatTimeExtension().formatTimeDifference(
//                           widget.momentModel.createAt!, context),
//                       style: AppTextStyles.of(context).light14.copyWith(
//                         color: AppColors.of(context).neutralColor1,
//                         shadows: [
//                           Shadow(
//                             blurRadius: 1.0,
//                             color: AppColors.of(context).neutralColor12,
//                           ),
//                         ],
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//         Positioned(
//           top: 16.w,
//           right: 0,
//           width: urlIcon == null
//               ? MediaQuery.of(context).size.width / 3.5
//               : MediaQuery.of(context).size.width / 2.7,
//           child: Row(
//             children: [
//               urlIcon == null
//                   ? SvgPicture.asset(Assets.icons.sunSVG)
//                   : CachedNetworkImage(
//                       imageUrl: "https:$urlIcon",
//                       fit: BoxFit.cover,
//                     ),
//               SizedBox(
//                 width: 8.w,
//               ),
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Colors.transparent,
//                         Colors.black.withOpacity(0.3)
//                       ],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                     color: AppColors.of(context).neutralColor6,
//                     borderRadius: const BorderRadius.all(Radius.circular(20)),
//                   ),
//                   padding: EdgeInsets.only(
//                       left: 4.w, right: 4.w, top: 2.w, bottom: 2.w),
//                   margin: EdgeInsets.only(right: 16.w),
//                   alignment: Alignment.center,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Text(
//                         address ?? (widget.momentModel.uploadLocation ?? ""),
//                         maxLines: 1,
//                         style: AppTextStyles.of(context).light14.copyWith(
//                           height: 1,
//                           overflow: TextOverflow.ellipsis,
//                           color: AppColors.of(context).neutralColor1,
//                           shadows: [
//                             Shadow(
//                               blurRadius: 1.0,
//                               color: AppColors.of(context).neutralColor12,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         "${temperature ?? 29}℃",
//                         style: AppTextStyles.of(context).regular16.copyWith(
//                           height: 1,
//                           color: AppColors.of(context).neutralColor3,
//                           shadows: [
//                             Shadow(
//                               blurRadius: 1.0,
//                               color: AppColors.of(context).neutralColor12,
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//         // icon phát video ca nhạc
//         widget.momentModel.linkMusic != null && widget.momentModel.linkMusic!.isNotEmpty
//             ? Positioned(
//                 bottom: 16.w,
//                 right: 16.w,
//                 child: GestureDetector(
//                   onTap: _togglePlayPause,
//                   child: Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: AppColors.of(context).neutralColor1,
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(100)),
//                     ),
//                     child: SvgPicture.asset(
//                       _isPlaying?'assets/icons/Pause.svg' :'assets/icons/play-music.svg', // Ensure path is correct
//                       width: 24.w,
//                       height: 24.w,
//                       color: AppColors.of(context).neutralColor12,
//                     ),
//                   ),
//                 ),
//               )
//             : const SizedBox.shrink(),
//         if (widget.momentModel.content != null &&
//             widget.momentModel.content!.isNotEmpty)
//           Positioned(
//             bottom: 4.w,
//             left: 0,
//             right: 0,
//             child: Align(
//               alignment: Alignment.center,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 12.w),
//                 decoration: BoxDecoration(
//                     color: AppColors.of(context).neutralColor6,
//                     borderRadius: const BorderRadius.all(Radius.circular(30)),
//                     boxShadow: [
//                       BoxShadow(
//                           color: AppColors.of(context).neutralColor11,
//                           blurRadius: 5.h,
//                           offset: Offset(0, 3.h))
//                     ]),
//                 child: Text(
//                   widget.momentModel.content!,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: AppTextStyles.of(context)
//                       .light24
//                       .copyWith(color: AppColors.of(context).neutralColor12),
//                 ),
//               ),
//             ),
//           ),
//         if (_isAnimationVisible)
//           Positioned.fill(
//             child: Lottie.asset('assets/animations/react_heart1.json',
//                 fit: BoxFit.cover, controller: _controller),
//           ),
//       ],
//     );
//   }
// }

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hit_moments/app/core/config/enum.dart';
import 'package:hit_moments/app/models/moment_model.dart';
import 'package:hit_moments/app/providers/moment_provider.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/assets.dart';
import '../../../core/extensions/format_time_extension.dart';
import '../../../core/extensions/theme_extensions.dart';

class MomentContentWidget extends StatefulWidget {
  const MomentContentWidget({super.key, required this.momentModel});

  final MomentModel momentModel;

  @override
  State<MomentContentWidget> createState() => _MomentContentWidgetState();
}

class _MomentContentWidgetState extends State<MomentContentWidget>
    with TickerProviderStateMixin { // Change SingleTickerProviderStateMixin to TickerProviderStateMixin
  late AnimationController _controller;
  bool _isAnimationVisible = false;
  late AudioPlayer _audioPlayer;
  late AnimationController _playAnimationController;
  late Animation<double> _playAnimation;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    parseString(widget.momentModel.weather ?? "");
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isAnimationVisible = false;
        });
      }
    });

    _playAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _playAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(
      parent: _playAnimationController,
      curve: Curves.easeInOut,
    ));

    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    _playAnimationController.dispose();
    super.dispose();
  }

  String? address;
  String? temperature;
  String? urlIcon;

  void parseString(String input) {
    final regex = RegExp(r'^(.*?)\|(.*?)\|(.*?)$');

    if (regex.hasMatch(input)) {
      final match = regex.firstMatch(input);

      if (match != null) {
        address = match.group(1);
        temperature = match.group(2);
        urlIcon = match.group(3);
      }
    }
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      _playAnimationController.stop(); // Dừng animation khi nhạc tạm dừng
    } else {
      await _audioPlayer.play(UrlSource(widget.momentModel.linkMusic ?? ''));
      _playAnimationController.repeat(reverse: true); // Lặp animation khi nhạc phát
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }


  @override
  Widget build(BuildContext context) {
    if (context.watch<MomentProvider>().sendReactStatus ==
        ModuleStatus.loading) {
      setState(() {
        _isAnimationVisible = true;
      });
      _controller.forward(from: 0);
    }

    return Container(
      margin: EdgeInsets.only(top: 80.h),
      child: Stack(
        children: [
          SizedBox(
            height: 1.sw,
            width: 1.sw,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.w),
              child: FittedBox(
                fit: BoxFit.cover,
                child: Image.network(
                  widget.momentModel.image ??'',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(50),
          //   child: AspectRatio(
          //     aspectRatio: 3 / 4,
          //     child: Image.network(
          //       widget.momentModel.image!,
          //       fit: BoxFit.fill,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: 16.w,
          //   left: 16.w,
          //   width: MediaQuery.of(context).size.width / 2,
          //   child: Row(
          //     children: [
          //       Container(
          //         padding: const EdgeInsets.all(2),
          //         decoration: const BoxDecoration(
          //             color: Colors.white,
          //             borderRadius: BorderRadius.all(Radius.circular(100))),
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(40.w),
          //           child: CachedNetworkImage(
          //             imageUrl: widget.momentModel.imgAvatar ?? "",
          //             width: 40.w,
          //             height: 40.w,
          //             fit: BoxFit.cover,
          //           ),
          //         ),
          //       ),
          //       SizedBox(
          //         width: 8.w,
          //       ),
          //       Expanded(
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               widget.momentModel.userName ?? "",
          //               overflow: TextOverflow.ellipsis,
          //               maxLines: 1,
          //               style: AppTextStyles.of(context).regular16.copyWith(
          //                 overflow: TextOverflow.ellipsis,
          //                 color: AppColors.of(context).neutralColor1,
          //                 shadows: [
          //                   const Shadow(
          //                     blurRadius: 1.0,
          //                     color: Colors.black,
          //                   ),
          //                 ],
          //               ),
          //             ),
          //             Text(
          //               FormatTimeExtension().formatTimeDifference(
          //                   widget.momentModel.createAt!, context),
          //               style: AppTextStyles.of(context).light14.copyWith(
          //                 color: AppColors.of(context).neutralColor1,
          //                 shadows: [
          //                   Shadow(
          //                     blurRadius: 1.0,
          //                     color: AppColors.of(context).neutralColor12,
          //                   ),
          //                 ],
          //               ),
          //             )
          //           ],
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          Positioned(
            top: 16.w,
            right: 0,
            width: urlIcon == null
                ? MediaQuery.of(context).size.width / 3.5
                : MediaQuery.of(context).size.width / 2.7,
            child: Row(
              children: [
                urlIcon == null
                    ? SvgPicture.asset(Assets.icons.sunSVG)
                    : CachedNetworkImage(
                  imageUrl: "https:$urlIcon",
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  width: 8.w,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      color: AppColors.of(context).neutralColor6,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.only(
                        left: 4.w, right: 4.w, top: 2.w, bottom: 2.w),
                    margin: EdgeInsets.only(right: 16.w),
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          address ?? (widget.momentModel.uploadLocation ?? ""),
                          maxLines: 1,
                          style: AppTextStyles.of(context).light14.copyWith(
                            height: 1,
                            overflow: TextOverflow.ellipsis,
                            color: AppColors.of(context).neutralColor1,
                            shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: AppColors.of(context).neutralColor12,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${temperature ?? 29}℃",
                          style: AppTextStyles.of(context).regular16.copyWith(
                            height: 1,
                            color: AppColors.of(context).neutralColor3,
                            shadows: [
                              Shadow(
                                blurRadius: 1.0,
                                color: AppColors.of(context).neutralColor12,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          // Music play/pause icon with animation
          widget.momentModel.linkMusic != null && widget.momentModel.linkMusic!.isNotEmpty
              ?  Positioned(
            bottom: 16.w,
            right: 16.w,
            child:  Positioned(
              bottom: 16.w,
              right: 16.w,
              child: GestureDetector(
                onTap: _togglePlayPause,
                child: ScaleTransition(
                  scale: _playAnimation,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor1,
                      borderRadius: const BorderRadius.all(Radius.circular(100)),
                    ),
                    child: SvgPicture.asset(
                      _isPlaying
                          ? 'assets/icons/Pause.svg'
                          : 'assets/icons/play-music.svg',
                      width: 24.w,
                      height: 24.w,
                      color: AppColors.of(context).neutralColor12,
                    ),
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink(),

          if (widget.momentModel.content != null &&
              widget.momentModel.content!.isNotEmpty)
            Positioned(
              bottom: 4.w,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  decoration: BoxDecoration(
                      color: AppColors.of(context).neutralColor6,
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.of(context).neutralColor11,
                            blurRadius: 5.h,
                            offset: Offset(0, 3.h))
                      ]),
                  child: Text(
                    widget.momentModel.content!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.of(context)
                        .light20
                        .copyWith(color: AppColors.of(context).neutralColor12),
                  ),
                ),
              ),
            ),
          if (_isAnimationVisible)
            Positioned.fill(
              child: Lottie.asset('assets/animations/react_heart1.json',
                  fit: BoxFit.cover, controller: _controller),
            ),
        ],
      ),
    );
  }
}
