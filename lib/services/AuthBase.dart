// Bu dosya, kimlik doğrulama işlemleri için bir temel arayüz (AuthBase) tanımlar.
// AuthBase, uygulamanın farklı kimlik doğrulama hizmetlerini (örneğin Firebase veya sahte hizmetler)
// kolayca değiştirebilmesini sağlamak için oluşturulmuştur.
// Bu arayüz, kimlik doğrulama hizmetlerinin ortak bir yapı üzerinden çalışmasını garanti eder.
// AuthBase, kimlik doğrulama hizmetleri için uygulanması gereken üç temel metodu içerir:
// 1. currentUser(): Mevcut kullanıcıyı döndürür.
// 2. signInAnonymously(): Anonim giriş işlemini gerçekleştirir.
// 3. signOut(): Kullanıcıyı oturumdan çıkarır.

import 'package:app_dirdir/model/UserModel.dart';

abstract class AuthBase {
  Future<UserModel?> currentUser();
  Future<UserModel?> signInAnonymously();
  Future<bool> signOut();
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signInWithEmailAndPassword(String email, String password);
  Future<UserModel?> createUserWithEmailAndPassword(String email, String password);
}
