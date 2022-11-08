import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thinking_capp/colors/palette.dart';
import 'package:thinking_capp/views/examine_photo.dart';

class PhotoCarousel extends StatefulWidget {
  final List<String> photoUrls;

  const PhotoCarousel({Key? key, required this.photoUrls}) : super(key: key);

  @override
  State<PhotoCarousel> createState() => _PhotoCarouselState();
}

class _PhotoCarouselState extends State<PhotoCarousel> {
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            PageView.builder(
              scrollBehavior:
                  const ScrollBehavior().copyWith(scrollbars: false),
              onPageChanged: _onPageChanged,
              itemCount: widget.photoUrls.length,
              itemBuilder: (context, index) {
                final photoUrl = widget.photoUrls[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ExaminePhotoView(
                        photoUrl: photoUrl,
                        heroTag: hashCode.toString() + photoUrl,
                      ),
                      transition: Transition.fadeIn,
                    );
                  },
                  child: Hero(
                    tag: hashCode.toString() + photoUrl,
                    child: CachedNetworkImage(
                      imageUrl: photoUrl,
                      height: 260,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Palette.primary, width: 2),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(0),
                    ],
                  ),
                ),
              ),
            ),
            if (widget.photoUrls.length > 1)
              Positioned(
                left: 0,
                right: 0,
                bottom: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < widget.photoUrls.length; i++)
                      Container(
                        width: 16,
                        height: 4,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Palette.primary
                              .withOpacity(i == _currentIndex ? 1 : 0.4),
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
