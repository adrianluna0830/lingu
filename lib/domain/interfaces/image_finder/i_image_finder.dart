import 'dart:async';
import 'package:lingu/domain/interfaces/image_finder/image_api_response.dart';
import 'package:lingu/domain/interfaces/image_finder/image_quality.dart';
import 'package:lingu/domain/interfaces/image_finder/image_type.dart';


abstract class IImageFinder {
  Future<ImageApiResponse> findImage(
    String description,
    ImageQuality quality, {
    ImageType? type,
    int images,
  });
}
