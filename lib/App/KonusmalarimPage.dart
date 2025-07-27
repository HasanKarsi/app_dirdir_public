import 'package:app_dirdir/App/KonusmaPage.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:app_dirdir/model/KonusmaModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  const KonusmalarimPage({super.key});

  @override
  State<KonusmalarimPage> createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    UserViewModel _userModel = Provider.of<UserViewModel>(context);

    return Scaffold(
      backgroundColor: AppConstants.lightGrey,
      appBar: AppBar(
        title: Text("Konuşmalar", style: AppConstants.titleTextStyle),
        backgroundColor: AppConstants.primaryGreen,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppConstants.white),
            onPressed: () {
              // Arama fonksiyonu eklenebilir
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppConstants.white),
            onSelected: (value) {
              // Menu işlemleri
            },
            itemBuilder: (BuildContext context) {
              return [PopupMenuItem(value: 'settings', child: Text('Ayarlar'))];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: _userModel.getAllConversations(_userModel.user!.userId),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            var tumKonusmalar = konusmaListesi.data!;
            return RefreshIndicator(
              onRefresh: _konusmalarimListesiniYenile,
              color: AppConstants.primaryGreen,
              backgroundColor: AppConstants.white,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: tumKonusmalar.isEmpty ? 1 : tumKonusmalar.length,
                itemBuilder: (context, index) {
                  if (tumKonusmalar.isEmpty) {
                    return Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppConstants.primaryGreen.withOpacity(
                                  0.1,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.chat_bubble_outline,
                                size: 64,
                                color: AppConstants.primaryGreen,
                              ),
                            ),
                            SizedBox(height: 24),
                            Text(
                              'Henüz konuşma yapılmamış',
                              style: AppConstants.emptyStateTextStyle,
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Yeni bir konuşma başlatın',
                              style: AppConstants.messageTextStyle,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  var oAnkiKonusma = tumKonusmalar[index];
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppConstants.white,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    child: Material(
                      color: AppConstants.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            CupertinoPageRoute(
                              builder:
                                  (context) => KonusmaPage(
                                    currentUser: _userModel.user!,
                                    sohbetEdilenKullanici: UserModel.idVeResim(
                                        userId: oAnkiKonusma.kimleKonusuyor!,
                                        profileURL:
                                            oAnkiKonusma
                                                .konusulanUserProfileUrl!,
                                      )
                                      ..userName =
                                          oAnkiKonusma
                                              .konusulanUserName, // userName'i ayrıca set ediyoruz
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: AppConstants.listItemPadding,
                          child: Row(
                            children: [
                              // Profil resmi
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppConstants.primaryGreen
                                        .withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: AppConstants.avatarRadius,
                                  backgroundColor: AppConstants.lightGrey,
                                  backgroundImage: NetworkImage(
                                    oAnkiKonusma.konusulanUserProfileUrl!,
                                  ),
                                  onBackgroundImageError: (
                                    exception,
                                    stackTrace,
                                  ) {
                                    // Hata durumunda varsayılan ikon göster
                                  },
                                  child:
                                      oAnkiKonusma
                                              .konusulanUserProfileUrl!
                                              .isEmpty
                                          ? Icon(
                                            Icons.person,
                                            color: AppConstants.darkGrey,
                                            size: 30,
                                          )
                                          : null,
                                ),
                              ),

                              SizedBox(width: 16),

                              // İsim ve mesaj kısmı
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            oAnkiKonusma.konusulanUserName ??
                                                'Bilinmeyen Kullanıcı',
                                            style: AppConstants.nameTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          oAnkiKonusma.aradakiFark ?? '',
                                          style: AppConstants.timeTextStyle,
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: 4),

                                    Row(
                                      children: [
                                        // Mesaj durumu ikonu (gönderildi, okundu vs.)
                                        Icon(
                                          Icons.done_all,
                                          size: 16,
                                          color:
                                              oAnkiKonusma.konusmaGoruldu ==
                                                      true
                                                  ? AppConstants.primaryGreen
                                                  : AppConstants.darkGrey,
                                        ),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            oAnkiKonusma.sonMesaj ??
                                                'Mesaj yok',
                                            style:
                                                AppConstants.messageTextStyle,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ),
                                        // Okunmamış mesaj sayısı (varsa)
                                        /*                                         if (oAnkiKonusma.konusmaGoruldu != true)
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppConstants.primaryGreen,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              '1',
                                              style: TextStyle(
                                                color: AppConstants.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ), */
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Yeni konuşma başlatma fonksiyonu
          // Navigator.push(...) ile kullanıcı seçim sayfasına yönlendirilebilir
        },
        backgroundColor: AppConstants.primaryGreen,
        child: Icon(Icons.chat, color: AppConstants.white),
      ),
    );
  }

  Future<void> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
    // Burada verileri yenileme işlemleri yapılabilir
    // Örneğin, veritabanından yeni veriler çekilebilir
  }
}
