import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/model/MesajModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/ViewModel/ChatViewModel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class KonusmaPage extends StatefulWidget {
  final UserModel currentUser;
  final UserModel sohbetEdilenKullanici;

  const KonusmaPage({
    Key? key,
    required this.currentUser,
    required this.sohbetEdilenKullanici,
  }) : super(key: key);

  @override
  _KonusmaPageState createState() => _KonusmaPageState();
}

class _KonusmaPageState extends State<KonusmaPage> {
  var _mesajController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  ChatViewModel? _chatViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _mesajController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChatViewModel>(
      create: (context) {
        _chatViewModel = ChatViewModel(
          currentUser: widget.currentUser,
          sohbetEdilenUser: widget.sohbetEdilenKullanici,
        );
        return _chatViewModel!;
      },
      child: Scaffold(
        backgroundColor: AppConstants.lightGrey,
        appBar: AppBar(
          backgroundColor: AppConstants.primaryGreen,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppConstants.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppConstants.white,
                backgroundImage:
                    widget.sohbetEdilenKullanici.profileURL?.isNotEmpty == true
                        ? NetworkImage(widget.sohbetEdilenKullanici.profileURL!)
                        : null,
                child:
                    widget.sohbetEdilenKullanici.profileURL?.isNotEmpty != true
                        ? Icon(
                          Icons.person,
                          color: AppConstants.darkGrey,
                          size: 20,
                        )
                        : null,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.sohbetEdilenKullanici.userName ??
                          "Bilinmeyen Kullanıcı",
                      style: TextStyle(
                        color: AppConstants.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    /*                     Text(
                      "Çevrimiçi",
                      style: TextStyle(
                        color: AppConstants.white.withOpacity(0.8),
                        fontSize: 12,
                      ),
                    ),
 */
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.videocam, color: AppConstants.white),
              onPressed: () {
                // Video arama fonksiyonu
              },
            ),
            IconButton(
              icon: Icon(Icons.call, color: AppConstants.white),
              onPressed: () {
                // Sesli arama fonksiyonu
              },
            ),
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: AppConstants.white),
              onSelected: (value) {
                // Menu işlemleri
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(value: 'info', child: Text('Kişi bilgileri')),
                  PopupMenuItem(
                    value: 'media',
                    child: Text('Medya, bağlantılar ve dokümanlar'),
                  ),
                  PopupMenuItem(value: 'search', child: Text('Ara')),
                  PopupMenuItem(value: 'mute', child: Text('Sessiz')),
                  PopupMenuItem(value: 'block', child: Text('Engelle')),
                ];
              },
            ),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            color: AppConstants.lightGrey,
            image: DecorationImage(
              image: AssetImage('Images/dirdiriconv2.png'),
              fit: BoxFit.cover,
              opacity: 0.05, // Çok hafif görünüm için opacity azaltıldı
            ),
          ),
          child: Consumer<ChatViewModel>(
            builder: (context, chatModel, child) {
              if (chatModel.state == ChatViewState.Busy) {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppConstants.primaryGreen,
                  ),
                );
              } else {
                return Column(
                  children: <Widget>[
                    _buildMesajListesi(),
                    _buildYeniMesajGir(),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        if (chatModel.mesajlarListesi.isEmpty) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppConstants.primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      size: 48,
                      color: AppConstants.primaryGreen,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Mesajlarınız uçtan uca şifrelenir",
                    style: AppConstants.emptyStateTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "İlk mesajınızı gönderin",
                    style: AppConstants.messageTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            itemBuilder: (context, index) {
              // Normal mesajları göster
              if (index < chatModel.mesajlarListesi.length) {
                return _konusmaBalonuOlustur(chatModel.mesajlarListesi[index]);
              }
              // Loading indicator sadece daha fazla mesaj varsa göster
              else if (chatModel.hasMoreLoading) {
                return _yeniElemanlarYukleniyorIndicator();
              }
              // Hiçbir şey gösterme
              else {
                return const SizedBox.shrink();
              }
            },
            itemCount:
                chatModel.hasMoreLoading
                    ? chatModel.mesajlarListesi.length + 1
                    : chatModel.mesajlarListesi.length,
          ),
        );
      },
    );
  }

  Widget _buildYeniMesajGir() {
    return Consumer<ChatViewModel>(
      builder: (context, chatModel, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          color: AppConstants.white,
          child: SafeArea(
            child: Row(
              children: <Widget>[
                // Emoji butonu
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: AppConstants.darkGrey,
                      size: 24,
                    ),
                    onPressed: () {
                      // Emoji picker açılabilir
                    },
                  ),
                ),

                // Mesaj giriş alanı
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.lightGrey,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: AppConstants.primaryGreen.withOpacity(0.3),
                        width: 0.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _mesajController,
                            maxLines: null,
                            style: TextStyle(
                              fontSize: 16.0,
                              color: AppConstants.black,
                            ),
                            decoration: InputDecoration(
                              hintText: "Mesaj yazın",
                              hintStyle: TextStyle(
                                color: AppConstants.darkGrey,
                                fontSize: 16,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                        // Ek butonlar
                        IconButton(
                          icon: Icon(
                            Icons.attach_file,
                            color: AppConstants.darkGrey,
                            size: 24,
                          ),
                          onPressed: () {
                            // Dosya ekleme fonksiyonu
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.camera_alt,
                            color: AppConstants.darkGrey,
                            size: 24,
                          ),
                          onPressed: () {
                            // Kamera fonksiyonu
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Gönder butonu
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  child: Material(
                    color: AppConstants.primaryGreen,
                    borderRadius: BorderRadius.circular(25),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(25),
                      onTap: () async {
                        if (_mesajController.text.trim().isNotEmpty) {
                          MesajModel kaydedilecekMesaj = MesajModel(
                            kimden: chatModel.currentUser.userId,
                            kime: chatModel.sohbetEdilenUser.userId,
                            bendenMi: true,
                            mesaj: _mesajController.text.trim(),
                            zaman: Timestamp.now(),
                            konusmaSahibi: _chatViewModel!.currentUser.userId,
                          );
                          _mesajController.clear();
                          var sonuc = await chatModel.saveMessage(
                            kaydedilecekMesaj,
                            chatModel.currentUser,
                          );
                          if (sonuc) {
                            if (_scrollController.hasClients) {
                              _scrollController.animateTo(
                                0,
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 300),
                              );
                            }
                          }
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Icon(
                          Icons.send,
                          size: 20,
                          color: AppConstants.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _konusmaBalonuOlustur(MesajModel oankiMesaj) {
    var saatDakikaDegeri = "";
    try {
      saatDakikaDegeri = _saatDakikaGoster(oankiMesaj.zaman ?? Timestamp.now());
    } catch (e) {
      debugPrint("Tarih formatında hata: ${e.toString()}");
      saatDakikaDegeri = "--:--";
    }

    var benimMesajimMi = oankiMesaj.bendenMi;

    if (benimMesajimMi) {
      // Gönderilen mesajlar (sağ taraf)
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.primaryGreen,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.darkGrey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(
                          color: AppConstants.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            saatDakikaDegeri,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppConstants.white.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.done_all,
                            size: 16,
                            color: AppConstants.lightYellow,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Alınan mesajlar (sol taraf)
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Profil resmi
            CircleAvatar(
              radius: 16,
              backgroundColor: AppConstants.lightGrey,
              backgroundImage:
                  widget.sohbetEdilenKullanici.profileURL?.isNotEmpty == true
                      ? NetworkImage(widget.sohbetEdilenKullanici.profileURL!)
                      : null,
              child:
                  widget.sohbetEdilenKullanici.profileURL?.isNotEmpty != true
                      ? Icon(
                        Icons.person,
                        color: AppConstants.darkGrey,
                        size: 18,
                      )
                      : null,
            ),
            SizedBox(width: 8),

            // Mesaj balonu
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                decoration: BoxDecoration(
                  color: AppConstants.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppConstants.darkGrey.withOpacity(0.2),
                      spreadRadius: 0,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oankiMesaj.mesaj,
                        style: TextStyle(
                          color: AppConstants.black,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        saatDakikaDegeri,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppConstants.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  String _saatDakikaGoster(Timestamp date) {
    var formatter = DateFormat.Hm();
    var formatlanmisTarih = formatter.format(date.toDate());
    return formatlanmisTarih;
  }

  void _scrollListener() {
    if (_chatViewModel == null) return;

    if (_scrollController.hasClients &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        !_isLoading &&
        _chatViewModel!.hasMoreLoading) {
      debugPrint("📄 Scroll tetiklendi - eski mesajlar yükleniyor");
      eskiMesajlariGetir();
    }
  }

  void eskiMesajlariGetir() async {
    if (_isLoading ||
        _chatViewModel == null ||
        !_chatViewModel!.hasMoreLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await _chatViewModel!.dahaFazlaMesajGetir();

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _yeniElemanlarYukleniyorIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppConstants.primaryGreen,
          ),
        ),
      ),
    );
  }
}
