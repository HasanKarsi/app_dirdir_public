import 'dart:io';

import 'package:app_dirdir/CommonWidget/PlatformDuyarliAlertDialog.dart';
import 'package:app_dirdir/CommonWidget/SocialLoginButton.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:app_dirdir/services/FirebaseCMServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  File? _profilePhoto; // nullable yap, varsayılan null
  TextEditingController _controllerUserName = TextEditingController();

  get url => null;

  @override
  void initState() {
    super.initState();
    // userName'i ilk değer olarak ata
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _controllerUserName = TextEditingController(
      text: userViewModel.user?.userName ?? "",
    );
  }

  @override
  void dispose() {
    _controllerUserName.dispose();
    super.dispose();
  }

  void _kameraFotoCek(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  void _galeridenFotoCek(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    UserViewModel userViewModel = Provider.of<UserViewModel>(context);
    debugPrint("🔷 Okunan user nesnesi : ${userViewModel.user.toString()}");

    return Scaffold(
      backgroundColor: AppConstants.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım - Header
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppConstants.backgroundGradient,
              ),
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 48), // Boş alan - dengeleme için
                      Expanded(
                        child: Text(
                          'Profil',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _cikisIcinOnayIste(context),
                        icon: Icon(Icons.logout, color: AppConstants.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  // Profil fotoğrafı
                  GestureDetector(
                    onTap: () => _profilFotoSecenekleri(context),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppConstants.white,
                              width: 4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppConstants.black.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage:
                                _profilePhoto != null
                                    ? FileImage(_profilePhoto!) as ImageProvider
                                    : NetworkImage(
                                      userViewModel.user!.profileURL!,
                                    ),
                            backgroundColor: AppConstants.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppConstants.lightYellow,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppConstants.white,
                                width: 2,
                              ),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                              Icons.camera_alt,
                              color: AppConstants.darkGreen,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  Text(
                    userViewModel.user?.userName ?? "Kullanıcı",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.white,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    userViewModel.user?.eMail ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Ana içerik
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Bilgiler bölümü
                    Container(
                      decoration: BoxDecoration(
                        color: AppConstants.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppConstants.darkGrey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hesap Bilgileri",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.darkGreen,
                            ),
                          ),
                          SizedBox(height: 20),

                          // E-posta alanı
                          _buildInfoField(
                            label: "E-posta",
                            value: userViewModel.user!.eMail ?? "",
                            icon: Icons.email_outlined,
                            isReadOnly: true,
                          ),

                          SizedBox(height: 16),

                          // Kullanıcı adı alanı
                          _buildEditableField(
                            label: "Kullanıcı Adı",
                            controller: _controllerUserName,
                            icon: Icons.person_outline,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Kaydet butonu
                    Socialloginbutton(
                      onPressed: () {
                        _userNameGuncelle(context, userViewModel);
                        _profilFotoGuncelle(context, userViewModel);
                      },
                      buttonText: "Değişiklikleri Kaydet",
                      buttonColor: AppConstants.primaryGreen,
                    ),

                    SizedBox(height: 32),

                    // Çıkış yap butonu
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.shade200,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(Icons.logout, color: Colors.red.shade600),
                        title: Text(
                          "Çıkış Yap",
                          style: TextStyle(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.red.shade400,
                          size: 16,
                        ),
                        onTap: () => _cikisIcinOnayIste(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
    required IconData icon,
    bool isReadOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isReadOnly ? AppConstants.lightGrey : AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.lightGrey, width: 1),
      ),
      child: TextFormField(
        initialValue: value,
        readOnly: isReadOnly,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppConstants.primaryGreen),
          labelText: label,
          labelStyle: TextStyle(color: AppConstants.darkGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isReadOnly ? AppConstants.lightGrey : AppConstants.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        style: TextStyle(
          color: isReadOnly ? AppConstants.darkGrey : AppConstants.black,
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.lightGrey, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppConstants.primaryGreen),
          labelText: label,
          labelStyle: TextStyle(color: AppConstants.darkGrey),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppConstants.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  void _profilFotoSecenekleri(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppConstants.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: AppConstants.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AppConstants.lightGrey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Profil Fotoğrafı",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.darkGreen,
                        ),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryGreen.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                        title: Text(
                          'Fotoğraf Çek',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppConstants.darkGreen,
                          ),
                        ),
                        onTap: () {
                          _kameraFotoCek(context);
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        leading: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppConstants.lightYellow.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.photo_library,
                            color: AppConstants.darkOrange,
                          ),
                        ),
                        title: Text(
                          'Galeriden Seç',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppConstants.darkGreen,
                          ),
                        ),
                        onTap: () {
                          _galeridenFotoCek(context);
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Kullanıcı oturumunu kapatır.
  Future<bool> _cikisYap(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    bool sonuc = await userViewModel.signOut(); // Firebase'den oturumu kapatır
    return sonuc; // Başarılı bir şekilde çıkış yapıldıysa true döner
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    bool? sonuc = await Platformduyarlialertdialog(
      title: "Emin misiniz?",
      content: "Çıkış yapmak istediğinize emin misiniz?",
      buttonText: "Evet",
      cancelButtonText: "Hayır",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(
    BuildContext context,
    UserViewModel userViewModel,
  ) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_userViewModel.user!.userName != _controllerUserName.text) {
      var updateResult = await _userViewModel.updateUserName(
        _userViewModel.user!.userId,
        _controllerUserName.text,
      );

      if (updateResult == true) {
        Platformduyarlialertdialog(
          title: "Bilgi",
          content: "Kullanıcı adınız başarıyla güncellendi.",
          buttonText: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName.text = _userViewModel.user!.userName!;
        Platformduyarlialertdialog(
          title: "Hata",
          content:
              "Bu kullanıcı adı zaten kullanılıyor.\n Farklı bir kullanıcı adı deneyin.",
          buttonText: "Tamam",
        ).goster(context);
      }
    }
  }

  Future<void> _profilFotoGuncelle(
    BuildContext context,
    UserViewModel userViewModel,
  ) async {
    final _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    if (_profilePhoto != null) {
      await _userViewModel.uploadFile(
        _userViewModel.user!.userId,
        "profilePhoto",
        _profilePhoto!,
      );
      //debugPrint("🔷 gelen Url: $url");
      Platformduyarlialertdialog(
        title: "Başarılı",
        content: "Profil fotoğrafınız başarıyla güncellendi.",
        buttonText: "Tamam",
      ).goster(context);
    }
  }
}
