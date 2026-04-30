import 'package:lingu/domain/auth/models/credential_results.dart';


abstract class IAPIFabric<T> {
  Future<CredentialValidationResult> validate();
  Future<T> create();
}
