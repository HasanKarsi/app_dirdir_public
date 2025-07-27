import 'package:app_dirdir/model/KonusmaModel.dart';
import 'package:app_dirdir/model/MesajModel.dart';
import 'package:app_dirdir/model/UserModel.dart';

abstract class DbBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel?> readUser(String userId);
  Future<bool> updateUserName(String userId, String newUserName);
  Future<bool> updateProfilePhotoUrl(String userId, String profilPhotoUrl);
  Future<List<KonusmaModel>> getAllConversations(String userId);
  Stream<List<MesajModel>> getMessages(
    String currentUserId,
    String sohbetEdilenKullaniciId,
  );
  Future<bool> saveMessage(
    MesajModel kaydedilecekMesaj,
    UserModel gonderenKullanici,
    UserModel? alanKullanici,
  );
  Future<DateTime> saatiGoster(String userId);
  Future<List<UserModel>> getUserWithPagination(
    UserModel enSonGetirilenUser,
    int getirilecekUserSayisi,
  );
}
