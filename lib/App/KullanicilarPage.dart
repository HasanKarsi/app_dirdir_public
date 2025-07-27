import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app_dirdir/App/KonusmaPage.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/ViewModel/AllUserViewModel.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  @override
  _KullanicilarPageState createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_listeScrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lightGrey,
      appBar: AppBar(
        backgroundColor: AppConstants.primaryGreen,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Yeni Sohbet", style: AppConstants.titleTextStyle),
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
              return [
                PopupMenuItem(value: 'invite', child: Text('Arkadaş davet et')),
                PopupMenuItem(value: 'help', child: Text('Yardım')),
              ];
            },
          ),
        ],
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(
                color: AppConstants.primaryGreen,
              ),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              onRefresh: model.kullaniciListesiRefresh,
              color: AppConstants.primaryGreen,
              backgroundColor: AppConstants.white,
              child:
                  model.kullanicilarListesi.isEmpty
                      ? _kullaniciYokUi()
                      : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        physics:
                            AlwaysScrollableScrollPhysics(), // Bu satır önemli
                        itemBuilder: (context, index) {
                          if (model.hasMoreLoading &&
                              index == model.kullanicilarListesi.length) {
                            return _yeniElemanlarYukleniyorIndicator();
                          } else {
                            return _userListeElemaniOlustur(index);
                          }
                        },
                        itemCount:
                            model.hasMoreLoading
                                ? model.kullanicilarListesi.length + 1
                                : model.kullanicilarListesi.length,
                      ),
            );
          } else {
            return const Center(child: Text("Bir hata oluştu"));
          }
        },
      ),
    );
  }

  Widget _kullaniciYokUi() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.contacts_outlined,
                    color: AppConstants.primaryGreen,
                    size: 64,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "Henüz kullanıcı yok",
                  style: AppConstants.emptyStateTextStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  "Yeni kullanıcıları davet edin",
                  style: AppConstants.messageTextStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _userListeElemaniOlustur(int index) {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final tumKullanicilarViewModel = Provider.of<AllUserViewModel>(
      context,
      listen: false,
    );

    if (index >= tumKullanicilarViewModel.kullanicilarListesi.length) {
      return const SizedBox.shrink();
    }

    var _oAnkiUser = tumKullanicilarViewModel.kullanicilarListesi[index];

    if (_oAnkiUser.userId == userViewModel.user?.userId) {
      return const SizedBox.shrink();
    }

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
                      currentUser: userViewModel.user!,
                      sohbetEdilenKullanici: _oAnkiUser,
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
                      color: AppConstants.primaryGreen.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: AppConstants.avatarRadius,
                    backgroundColor: AppConstants.lightGrey,
                    backgroundImage:
                        _oAnkiUser.profileURL?.isNotEmpty == true
                            ? NetworkImage(_oAnkiUser.profileURL!)
                            : null,
                    onBackgroundImageError: (exception, stackTrace) {
                      // Hata durumunda varsayılan ikon göster
                    },
                    child:
                        _oAnkiUser.profileURL?.isNotEmpty != true
                            ? Icon(
                              Icons.person,
                              color: AppConstants.darkGrey,
                              size: 30,
                            )
                            : null,
                  ),
                ),

                SizedBox(width: 16),

                // İsim ve email kısmı
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _oAnkiUser.userName ?? 'İsim yok',
                        style: AppConstants.nameTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 14,
                            color: AppConstants.darkGrey,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              _oAnkiUser.eMail ?? 'E-mail yok',
                              style: AppConstants.messageTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Sağ ok işareti
                Icon(
                  Icons.chevron_right,
                  color: AppConstants.darkGrey.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      setState(() {
        _isLoading = true;
      });

      final _tumKullanicilarViewModel = Provider.of<AllUserViewModel>(
        context,
        listen: false,
      );

      await _tumKullanicilarViewModel.dahaFazlaKullaniciGetir();

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      debugPrint(
        "📄 Listenin altına yaklaşıldı - daha fazla kullanıcı getiriliyor",
      );
      dahaFazlaKullaniciGetir();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
