import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:skinsight/core/theme/app_color.dart';

import '../api/api_config.dart';

class DetailPhotoProfile extends StatefulWidget {
  final String imgProfile;
  const DetailPhotoProfile({super.key, required this.imgProfile});

  @override
  State<DetailPhotoProfile> createState() => _DetailPhotoProfileState();
}

class _DetailPhotoProfileState extends State<DetailPhotoProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: whiteColor,
        appBar: AppBar(
          title: const Text(''),
        ),
        body: Center(
          child: Hero(
              tag: 'detail-profile',
              child: ExtendedImage.network(
               '${ApiConfig.imageBaseUrl}${widget.imgProfile}',
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                cache: true,
                loadStateChanged: (state) {
                  if (state.extendedImageLoadState == LoadState.failed) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Material(
                        borderRadius: BorderRadius.circular(0),
                        color: mainColor.withValues(alpha: 0.2),
                        child: Icon(
                          size: 53,
                          Icons.broken_image,
                          color: mainColor.withValues(alpha: 0.4),
                        ),
                      ),
                    );
                  } else if (state.extendedImageLoadState == LoadState.loading) {
                    return AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Material(
                        borderRadius: BorderRadius.circular(0),
                        color: whiteColor,
                        
                      ),
                    );
                  } 
                  return null;
                },
              )),
        ));
  }
}
