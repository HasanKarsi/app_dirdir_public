import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_dirdir/Locator.dart';
import 'package:app_dirdir/model/MesajModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/Repository/UserRepository.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  List<MesajModel> _tumMesajlar = [];
  ChatViewState _state = ChatViewState.Idle;
  static const int sayfaBasinaGonderiSayisi = 15;
  final USerRepository _userRepository = locator<USerRepository>();
  final UserModel currentUser;
  final UserModel sohbetEdilenUser;
  MesajModel? _enSonGetirilenMesaj;
  MesajModel? _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _yeniMesajDinleListener = false;

  bool get hasMoreLoading => _hasMore && !_isLoadingMore;

  StreamSubscription<List<MesajModel>>? _streamSubscription;

  ChatViewModel({required this.currentUser, required this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }

  List<MesajModel> get mesajlarListesi => _tumMesajlar;

  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    debugPrint("ChatViewModel dispose edildi");
    _streamSubscription?.cancel();
    super.dispose();
  }

  Future<bool> saveMessage(
    MesajModel kaydedilecekMesaj,
    UserModel currentUser,
  ) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj, currentUser);
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_isLoadingMore && yeniMesajlarGetiriliyor) return;

    if (_tumMesajlar.isNotEmpty) {
      _enSonGetirilenMesaj = _tumMesajlar.last;
      debugPrint("🔄 En son mesaj: ${_enSonGetirilenMesaj!.mesaj}");
    }

    if (yeniMesajlarGetiriliyor) {
      _isLoadingMore = true;
      notifyListeners();
      debugPrint("📄 Eski mesajlar yükleniyor...");
    } else {
      state = ChatViewState.Busy;
      debugPrint("🔄 İlk yükleme başlatılıyor...");
    }

    try {
      var getirilenMesajlar = await _userRepository.getMessagewithPagination(
        currentUser.userId,
        sohbetEdilenUser.userId,
        _enSonGetirilenMesaj,
        sayfaBasinaGonderiSayisi,
      );

      debugPrint("✅ ${getirilenMesajlar.length} mesaj getirildi");

      if (getirilenMesajlar.length < sayfaBasinaGonderiSayisi) {
        _hasMore = false;
        debugPrint("🔚 Daha fazla mesaj yok");
      }

      // Duplicate kontrolü
      List<MesajModel> yeniMesajlar = [];
      for (var yeniMesaj in getirilenMesajlar) {
        bool mevcutMu = _tumMesajlar.any(
          (mevcutMesaj) =>
              mevcutMesaj.zaman?.millisecondsSinceEpoch ==
                  yeniMesaj.zaman?.millisecondsSinceEpoch &&
              mevcutMesaj.mesaj == yeniMesaj.mesaj &&
              mevcutMesaj.kimden == yeniMesaj.kimden,
        );

        if (!mevcutMu) {
          yeniMesajlar.add(yeniMesaj);
        }
      }

      _tumMesajlar.addAll(yeniMesajlar);
      debugPrint(
        "📝 ${yeniMesajlar.length} yeni mesaj eklendi, toplam: ${_tumMesajlar.length}",
      );

      if (_tumMesajlar.isNotEmpty && _listeyeEklenenIlkMesaj == null) {
        _listeyeEklenenIlkMesaj = _tumMesajlar.first;
        debugPrint(
          "🥇 İlk mesaj kaydedildi: ${_listeyeEklenenIlkMesaj!.mesaj}",
        );
      }

      if (yeniMesajlarGetiriliyor) {
        _isLoadingMore = false;
      }

      state = ChatViewState.Loaded;

      if (!_yeniMesajDinleListener) {
        _yeniMesajDinleListener = true;
        debugPrint("👂 Stream listener atanıyor");
        yeniMesajListenerAta();
      }
    } catch (e) {
      debugPrint("❌ Mesaj yükleme hatası: $e");
      _isLoadingMore = false;
      state = ChatViewState.Loaded;
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
    debugPrint("📄 Daha fazla mesaj getir tetiklendi");
    if (_hasMore && !_isLoadingMore) {
      getMessageWithPagination(true);
    } else {
      debugPrint(
        "⚠️ Daha fazla mesaj yok veya zaten yükleniyor. hasMore: $_hasMore, isLoading: $_isLoadingMore",
      );
    }
  }

  void yeniMesajListenerAta() {
    debugPrint("👂 Yeni mesajlar için stream listener atandı");
    _streamSubscription = _userRepository
        .getMessages(currentUser.userId, sohbetEdilenUser.userId)
        .listen((anlikData) {
          if (anlikData.isNotEmpty) {
            var yeniMesaj = anlikData[0];
            debugPrint("🔔 Yeni mesaj geldi: ${yeniMesaj.mesaj}");

            if (yeniMesaj.zaman != null) {
              // Duplicate kontrolü
              bool mevcutMu = _tumMesajlar.any(
                (mevcutMesaj) =>
                    mevcutMesaj.zaman?.millisecondsSinceEpoch ==
                        yeniMesaj.zaman?.millisecondsSinceEpoch &&
                    mevcutMesaj.mesaj == yeniMesaj.mesaj &&
                    mevcutMesaj.kimden == yeniMesaj.kimden,
              );

              if (!mevcutMu) {
                _tumMesajlar.insert(0, yeniMesaj);
                _listeyeEklenenIlkMesaj = yeniMesaj;
                state = ChatViewState.Loaded;
                debugPrint("✅ Yeni mesaj listeye eklendi");
              } else {
                debugPrint("⚠️ Duplicate mesaj, eklenmedi");
              }
            }
          }
        });
  }

  Future<void> refresh() async {
    debugPrint("🔄 Chat refresh");
    _hasMore = true;
    _isLoadingMore = false;
    _enSonGetirilenMesaj = null;
    _listeyeEklenenIlkMesaj = null;
    _yeniMesajDinleListener = false;
    _streamSubscription?.cancel();
    _tumMesajlar.clear();
    state = ChatViewState.Busy;
    getMessageWithPagination(false);
  }
}
