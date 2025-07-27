import 'dart:io';

import 'package:app_dirdir/Locator.dart';
import 'package:app_dirdir/Repository/UserRepository.dart';
import 'package:app_dirdir/model/KonusmaModel.dart';
import 'package:app_dirdir/model/MesajModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/services/authBase.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserViewModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final USerRepository _userRepository = locator<USerRepository>();
  UserModel? _user;

  UserModel? get user => _user;

  get state => _state;

  set state(value) {
    _state = value;
    notifyListeners();
  }

  // Constructor, Bir UserViewModel nesnesi oluşturulduğunda currentUser() fonksiyonunu çağırır.
  //Oturum acan user varsa direk _user dolu olsun veya bos olsun diye
  UserViewModel() {
    currentUser();
  }

  @override
  Future<UserModel?> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = (await _userRepository.currentUser())!;
      return _user;
    } catch (e) {
      debugPrint("ViewModel Error in currentUser: $e");
    } finally {
      state = ViewState.Idle;
    }
    return null;
  }

  @override
  Future<UserModel?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = (await _userRepository.signInAnonymously())!;
      return _user;
    } catch (e) {
      debugPrint("ViewModel Error in signInAnonymously: $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("ViewModel Error in signOut: $e");
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = (await _userRepository.signInWithGoogle())!;
      if (_user != null) {
        return _user;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("ViewModel Error in signInWithGoogle: $e");
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      state = ViewState.Busy;
      _user =
          (await _userRepository.createUserWithEmailAndPassword(
            email,
            password,
          ))!;
    } finally {
      state = ViewState.Idle;
    }
    return _user;
  }

  @override
  Future<UserModel?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      state = ViewState.Busy;
      _user =
          (await _userRepository.signInWithEmailAndPassword(email, password))!;
      return _user;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    var sonuc = await _userRepository.updateUserName(userID, newUserName);
    if (sonuc == true) {
      _user!.userName = newUserName;
    }
    return sonuc;
  }

  Future<String> uploadFile(String userId, String fileType, File file) async {
    var sonuc = await _userRepository.uploadFile(userId, fileType, file);
    return sonuc;
  }

  Stream<List<MesajModel>> getMessages(
    String currentUserId,
    String sohbetEdilenKullaniciId,
  ) {
    return _userRepository.getMessages(currentUserId, sohbetEdilenKullaniciId);
  }

  Future<List<KonusmaModel>> getAllConversations(String userId) async {
    var tumKonusmalar = await _userRepository.getAllConversations(userId);
    return tumKonusmalar;
  }

  Future<List<UserModel>> getUserWithPagination(
    UserModel? enSonKullanici,
    int getirilecekKullaniciSayisi,
  ) async {
    return await _userRepository.getUserWithPagination(
      enSonKullanici,
      getirilecekKullaniciSayisi,
    );
  }
}
