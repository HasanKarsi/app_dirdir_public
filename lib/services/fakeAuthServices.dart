// Bu dosya, test amaçlı kullanılan sahte bir kimlik doğrulama hizmeti (FakeAuthServices) sağlar.
// FakeAuthServices, AuthBase arayüzünü uygular ve gerçek kimlik doğrulama işlemlerini taklit eder.
// Bu sınıf, uygulamanın kimlik doğrulama işlemlerini test etmek için kullanılır ve
// herhangi bir gerçek kimlik doğrulama servisine bağlanmaz.
// Kullanıcı kimliği (userId) sabit bir değer olarak döndürülür.

import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/services/authBase.dart';

class Fakeauthservices implements AuthBase {
  @override
  Future<UserModel?> currentUser() async {
    // Mevcut kullanıcıyı sahte bir kimlik ile döndürür.
    return UserModel(userId: "fake_user_id", eMail: 'fakeUser@fake.com');
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    // Anonim giriş işlemini sahte bir kimlik ile gerçekleştirir.
    return UserModel(userId: "fake_user_id", eMail: 'fakeUser@fake.com');
  }

  @override
  Future<bool> signOut() async {
    // Kullanıcıyı oturumdan çıkarma işlemini taklit eder.
    return true;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(
        userId: "google_User_Id_2132123",
        eMail: 'fakeUser@fake.com',
      ),
    );
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(
        userId: "created_User_Id_123e12",
        eMail: 'fakeUser@fake.com',
      ),
    );
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return await Future.delayed(
      Duration(seconds: 2),
      () => UserModel(
        userId: "sign_In_User_Id_123e12",
        eMail: 'fakeUser@fake.com',
      ),
    );
  }
}
