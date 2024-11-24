import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/extensions/theme_extensions.dart';
import 'package:hit_moments/app/custom/widgets/scale_on_tap_widget.dart';
import 'package:provider/provider.dart';

import '../../../models/moment_model.dart';
import '../../../providers/list_moment_provider.dart';

class GridViewMoment extends StatefulWidget {
  const GridViewMoment({super.key, required this.listMoment, required this.onSelected});
  final List<MomentModel> listMoment;
  final void Function(MomentModel, int) onSelected;
  @override
  State<GridViewMoment> createState() => _GridViewMomentState();
}

class _GridViewMomentState extends State<GridViewMoment> {

  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        context.read<ListMomentProvider>().loadMoreListMoment();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(12),
      color: AppColors.of(context).neutralColor1,
      child: GridView.builder(
        itemCount: widget.listMoment.length,
          controller: _scrollController,
          gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h
          ),
          itemBuilder: (context, index) => imgMoment(context, widget.listMoment[index], index),
      ),
    );
  }



  Widget imgMoment(BuildContext context, MomentModel moment, int index){
    return ScaleOnTapWidget(
        child: AspectRatio(
          aspectRatio: 3/4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.w),
            child: Image.network(moment.image!, fit: BoxFit.cover,),
          ),
        ),
        onTap: (isSelect) {
          widget.onSelected(moment, index);
        },
    );
  }
}
