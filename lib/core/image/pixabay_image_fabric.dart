import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingu/core/models/credential_results.dart';
import 'package:lingu/core/settings/image_credentials_service.dart';
import 'package:lingu/core/image/i_image_finder.dart';

class PixabayImageFabric {
  final ImageCredentialsService _credentialsService;

  PixabayImageFabric(this._credentialsService);

  Future<IImageFinder?> create() async {
    final apiKey = _credentialsService.pixabayApiKey.value;
    if (apiKey == null || apiKey.isEmpty) return null;
    return PixabayImageFinder(
      apiKey: apiKey,
    );
  }

  Future<CredentialValidationResult> validate() async {
    final apiKey = _credentialsService.pixabayApiKey.value;
    if (apiKey == null || apiKey.isEmpty) {
      return CredentialInvalid('API Key cannot be empty');
    }

    try {
      final response = await http.get(
        Uri.parse('https://pixabay.com/api/?key=$apiKey&q=test&per_page=3'),
      );

      if (response.statusCode == 200) {
        return CredentialValid();
      } else {
        final data = jsonDecode(response.body);
        return CredentialInvalid(data.toString());
      }
    } catch (e) {
      return CredentialNetworkError();
    }
  }
}
