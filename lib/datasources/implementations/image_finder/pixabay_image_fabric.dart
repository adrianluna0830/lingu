import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lingu/datasources/implementations/image_finder/pixabay_image_finder.dart';
import 'package:lingu/domain/auth/models/credential_results.dart';
import 'package:lingu/domain/settings/services/image_credentials_service.dart';
import 'package:lingu/domain/interfaces/image_finder/i_image_finder.dart';

import 'package:lingu/domain/core/i_fabric.dart';

class PixabayImageFabric implements IAPIFabric<IImageFinder> {
  final ImageCredentialsService _credentialsService;

  PixabayImageFabric(this._credentialsService);

  @override
  Future<IImageFinder> create() async {
    final apiKey = _credentialsService.pixabayApiKey.value;
    assert(apiKey != null, 'API Key cannot be null before calling create()');
    assert(apiKey!.isNotEmpty, 'API Key cannot be empty before calling create()');
    
    return PixabayImageFinder(
      apiKey: apiKey!,
    );
  }

  @override
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
