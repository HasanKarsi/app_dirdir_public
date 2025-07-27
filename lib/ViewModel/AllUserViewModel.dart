import 'package:flutter/material.dart';
import 'package:app_dirdir/Locator.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/Repository/UserRepository.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<UserModel> _tumKullanicilar = [];
  UserModel? _enSonGetirilenUser;
  static const int sayfaBasinaGonderiSayisi = 15; 
  bool _hasMore = true;
  bool _isLoadingMore = false; // Yeni loading durumu değişkeni

  bool get hasMoreLoading => _isLoadingMore;
  final USerRepository _userRepository = locator<USerRepository>();
  List<UserModel> get kullanicilarListesi => _tumKullanicilar;

  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }

  // refresh ve sayfalama için
  // yeniElemanlarGetir true yapılır
  // ilk açılış için yeniElemanlarGetir false değer verilir.
  getUserWithPagination(
    UserModel? enSonGetirilenUser,
    bool yeniElemanlarGetiriliyor,
  ) async {
    if (_tumKullanicilar.isNotEmpty) {
      _enSonGetirilenUser = _tumKullanicilar.last;
      debugPrint(
        "🧭 En son getirilen kullanıcı: ${_enSonGetirilenUser!.userName}",
      );
    }

    if (yeniElemanlarGetiriliyor) {
      _isLoadingMore = true;
      notifyListeners();
    } else {
      state = AllUserViewState.Busy;
    }

    try {
      var yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser,
        sayfaBasinaGonderiSayisi,
      );

      if (yeniListe.length < sayfaBasinaGonderiSayisi) {
        _hasMore = false;
      }

      // Debug için kullanıcıları yazdır
      for (var user in yeniListe) {
        debugPrint("✅ Getirilen kullanıcı: ${user.userName}");
      }

      _tumKullanicilar.addAll(yeniListe);

      if (yeniElemanlarGetiriliyor) {
        _isLoadingMore = false;
      }

      state = AllUserViewState.Loaded;
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Kullanıcı getirme hatası: $e");
      _isLoadingMore = false;
      state = AllUserViewState.Loaded;
      notifyListeners();
    }
  }

  Future<void> dahaFazlaKullaniciGetir() async {
    debugPrint("🧭 Daha fazla kullanıcı getir tetiklendi -- ViewModel");
    if (_hasMore && !_isLoadingMore) {
      // Düzeltildi
      await getUserWithPagination(_enSonGetirilenUser, true);
    } else {
      debugPrint("🧭 Daha fazla kullanıcı yok veya zaten yükleniyor");
    }
  }

  Future<void> kullaniciListesiRefresh() async {
    debugPrint("🔄 Kullanıcı listesi yenileniyor");
    _hasMore = true;
    _isLoadingMore = false;
    _enSonGetirilenUser = null;
    _tumKullanicilar.clear();
    state = AllUserViewState.Busy;
    await getUserWithPagination(_enSonGetirilenUser, false);
  }
}
