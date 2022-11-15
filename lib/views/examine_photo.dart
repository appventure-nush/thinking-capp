import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:photo_view/photo_view.dart';
import 'package:thinking_capp/utils/animation.dart';
import 'package:thinking_capp/widgets/app_bar.dart';

class ExaminePhotoView extends StatefulWidget {
  final String title;
  final String photoUrl;
  final String? heroTag;
  final Map<IconData, Function()> suffixIcons;

  const ExaminePhotoView({
    Key? key,
    this.title = 'View photo',
    required this.photoUrl,
    this.heroTag, // can supply a custom tag to prevent undesired transitions
    this.suffixIcons = const {},
  }) : super(key: key);

  @override
  State<ExaminePhotoView> createState() => _ExaminePhotoViewState();
}

class _ExaminePhotoViewState extends State<ExaminePhotoView> {
  bool _isZooming = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoView(
            backgroundDecoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            minScale: PhotoViewComputedScale.contained,
            scaleStateChangedCallback: (scaleState) {
              setState(() => _isZooming = scaleState.isScaleStateZooming);
            },
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.heroTag ?? widget.photoUrl,
            ),
            imageProvider: CachedNetworkImageProvider(widget.photoUrl),
          ),
          TweenAnimationBuilder(
            duration: mediumAnimationDuration,
            tween: Tween(
              begin: Offset(0, -1),
              end: _isZooming ? Offset(0, -1) : Offset(0, 0),
            ),
            builder: (context, offset, child) {
              return FractionalTranslation(
                translation: offset as Offset,
                child: MyAppBar(title: widget.title),
              );
            },
          ),
        ],
      ),
    );
  }
}
