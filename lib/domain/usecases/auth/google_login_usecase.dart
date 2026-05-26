import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class GoogleLoginUseCase {
  final AuthRepository repository;

  GoogleLoginUseCase(this.repository);

  Future<User> execute({required String idToken, String? fcmToken}) async {
    return await repository.googleLogin(idToken: idToken, fcmToken: fcmToken);
  }
}
