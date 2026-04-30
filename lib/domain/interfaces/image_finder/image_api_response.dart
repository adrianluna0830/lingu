import 'dart:typed_data';

class ImageApiResponse {
  final List<Uint8List> images;
  final String credits;
  final int width;
  final int height;
  ImageApiResponse({required this.images, required this.credits, required this.width, required this.height});
}
