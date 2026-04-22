import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Exceptions

sealed class ImageFinderException implements Exception {
  final String message;
  const ImageFinderException(this.message);
}

class NetworkException extends ImageFinderException {
  final int? statusCode;
  const NetworkException(super.message, {this.statusCode});
}

class NoResultsException extends ImageFinderException {
  const NoResultsException(super.message);
}

class DownloadException extends ImageFinderException {
  final int? statusCode;
  const DownloadException(super.message, {this.statusCode});
}

class ParseException extends ImageFinderException {
  const ParseException(super.message);
}

class RequestTimeoutException extends ImageFinderException {
  const RequestTimeoutException(super.message);
}

// Models

enum ImageQuality {
  tiny('180'),
  small('340'),
  medium('640'),
  large('960'),
  extraLarge('1280');

  final String value;
  const ImageQuality(this.value);
}

enum ImageType { photo, illustration, vector }

class ImageApiResponse {
  final List<Uint8List> images;
  final String credits;
  final int width;
  final int height;
  ImageApiResponse({required this.images, required this.credits, required this.width, required this.height});
}


abstract class IImageFinder {
  Future<ImageApiResponse> findImage(
    String description,
    ImageQuality quality, {
    ImageType? type,
    int images,
  });
}


class PixabayImageFinder implements IImageFinder {
  final String _apiKey;
  final http.Client _client;
  final Duration timeout;

  PixabayImageFinder({
    required String apiKey,
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  })  : _apiKey = apiKey,
        _client = client ?? http.Client();

  @override
  Future<ImageApiResponse> findImage(
    String description,
    ImageQuality quality, {
    ImageType? type,
    int images = 10,
  }) async {
    final Uri url = Uri.parse(
      'https://pixabay.com/api/'
      '?key=$_apiKey'
      '&q=${Uri.encodeComponent(description)}'
      '${type != null ? '&image_type=${type.name}' : ''}'
      '&per_page=$images'
      '&safesearch=true',
    );

    late http.Response response;

    try {
      response = await _client.get(url).timeout(timeout);
    } on TimeoutException {
      throw RequestTimeoutException(
        'Request timed out after ${timeout.inSeconds}s',
      );
    } catch (e) {
      throw NetworkException('Failed to reach the server: $e');
    }

    if (response.statusCode != 200) {
      throw NetworkException(
        'Server returned an error',
        statusCode: response.statusCode,
      );
    }

    late Map<String, dynamic> data;

    try {
      data = jsonDecode(response.body);
    } catch (e) {
      throw ParseException('Failed to parse server response');
    }

    final List hits = data['hits'] ?? [];

    if (hits.isEmpty) {
      throw NoResultsException('No images found for "$description"');
    }

    final firstHit = hits.first;
    final int width = firstHit['webformatWidth'] ?? 640;
    final int height = firstHit['webformatHeight'] ?? 360;

    final List<Uint8List> imageBytes = await Future.wait(
      hits.map((hit) => _downloadImage(hit, quality)),
    );

    return ImageApiResponse(
      images: imageBytes,
      credits: 'Images provided by Pixabay — ${hits.first['pageURL']}',
      width: width,
      height: height,
    );
  }

  Future<Uint8List> _downloadImage(Map hit, ImageQuality quality) async {
    final String imageUrl = _resolveQuality(hit, quality);

    late http.Response response;

    try {
      response = await _client.get(Uri.parse(imageUrl)).timeout(timeout);
    } on TimeoutException {
      throw RequestTimeoutException(
        'Image download timed out after ${timeout.inSeconds}s',
      );
    } catch (e) {
      throw DownloadException('Failed to reach image URL: $e');
    }

    if (response.statusCode != 200) {
      throw DownloadException(
        'Failed to download image',
        statusCode: response.statusCode,
      );
    }

    return response.bodyBytes;
  }

  String _resolveQuality(Map hit, ImageQuality quality) {
    if (quality == ImageQuality.extraLarge) {
      return hit['largeImageURL'] ?? hit['webformatURL'];
    }
    return (hit['webformatURL'] as String).replaceAll('_640', '_${quality.value}');
  }
}