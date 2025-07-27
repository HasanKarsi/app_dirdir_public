import 'package:app_dirdir/App/ErorExeption.dart';
import 'package:app_dirdir/CommonWidget/PlatformDuyarliAlertDialog.dart';
import 'package:app_dirdir/CommonWidget/SocialLoginButton.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

enum LoginType { register, login }

class EmailPasswordCreate extends StatefulWidget {
  const EmailPasswordCreate({super.key});

  @override
  State<EmailPasswordCreate> createState() => _EmailPasswordCreateState();
}

class _EmailPasswordCreateState extends State<EmailPasswordCreate> {
  String? _eMail, _password;
  String? _buttonText, _linkText;
  var _loginType = LoginType.login;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      debugPrint('E-posta: $_eMail, Şifre: $_password');

      final userModel = Provider.of<UserViewModel>(context, listen: false);

      if (_loginType == LoginType.login) {
        try {
          UserModel? girisYapanUser = await userModel
              .signInWithEmailAndPassword(_eMail!, _password!);
          if (girisYapanUser != null) {
            debugPrint(
              "Oturum acan User id : ${girisYapanUser.userId.toString()}",
            );
          }
        } on PlatformException catch (e) {
          Platformduyarlialertdialog(
            title: "Oturum Açma Hatası",
            content: ErorExeption.goster(e.code),
            buttonText: "Tamam",
          ).goster(context);
        } on FirebaseAuthException catch (e) {
          Platformduyarlialertdialog(
            title: "Oturum Açma Hatası",
            content: ErorExeption.goster(e.code),
            buttonText: "Tamam",
          ).goster(context);
        } catch (e) {
          debugPrint("Login error: $e");
          Platformduyarlialertdialog(
            title: "Oturum Açma Hatası",
            content: ErorExeption.goster(e.toString()),
            buttonText: "Tamam",
          ).goster(context);
        }
      } else {
        try {
          UserModel? olusturulanUser = await userModel
              .createUserWithEmailAndPassword(_eMail!, _password!);
          if (olusturulanUser != null) {
            debugPrint(
              "Oturum acan User id : ${olusturulanUser.userId.toString()}",
            );
          }
        } on PlatformException catch (e) {
          Platformduyarlialertdialog(
            title: "Hata",
            content: ErorExeption.goster(e.code),
            buttonText: "Tamam",
          ).goster(context);
        } on FirebaseAuthException catch (e) {
          Platformduyarlialertdialog(
            title: "Hata",
            content: ErorExeption.goster(e.code),
            buttonText: "Tamam",
          ).goster(context);
        } catch (e) {
          debugPrint("Registration error: $e");
          Platformduyarlialertdialog(
            title: "Hata",
            content: ErorExeption.goster(e.toString()),
            buttonText: "Tamam",
          ).goster(context);
        }
      }
    }
  }

  void _degistir() {
    setState(() {
      _loginType =
          _loginType == LoginType.login ? LoginType.register : LoginType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buttonText = _loginType == LoginType.login ? 'Giriş Yap' : 'Kayıt Ol';
    _linkText =
        _loginType == LoginType.login
            ? 'Hesabınız yok mu? Kayıt Olun'
            : 'Zaten bir hesabınız var mı? Giriş Yapın';

    final userViewModel = Provider.of<UserViewModel>(
      context,
    ); // UserViewModel'i al.

    // Kullanıcı oturum açmışsa, build tamamlandıktan sonra Navigator.pop çağrılır
    if (userViewModel.user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();
      });
    }

    return Scaffold(
      backgroundColor: AppConstants.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım - Başlık
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppConstants.backgroundGradient,
              ),
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppConstants.white,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _loginType == LoginType.login
                              ? 'Giriş Yap'
                              : 'Kayıt Ol',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(width: 48), // Dengeleme için
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    _loginType == LoginType.login
                        ? 'Hesabınıza giriş yapın'
                        : 'Yeni hesap oluşturun',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppConstants.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Alt kısım - Form
            Expanded(
              child:
                  userViewModel.state == ViewState.Idle
                      ? SingleChildScrollView(
                        padding: EdgeInsets.all(32),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 24),

                              // E-posta alanı
                              Container(
                                decoration: BoxDecoration(
                                  color: AppConstants.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.darkGrey.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: AppConstants.primaryGreen,
                                    ),
                                    labelText: 'E-posta',
                                    hintText: 'E-posta adresinizi girin',
                                    labelStyle: TextStyle(
                                      color: AppConstants.darkGrey,
                                    ),
                                    hintStyle: TextStyle(
                                      color: AppConstants.lightGrey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: AppConstants.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'E-posta adresi boş olamaz.';
                                    }
                                    if (!RegExp(
                                      r'^[^@]+@[^@]+\.[^@]+',
                                    ).hasMatch(value)) {
                                      return 'Geçerli bir e-posta adresi girin.';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _eMail = newValue;
                                  },
                                ),
                              ),

                              SizedBox(height: 20),

                              // Şifre alanı
                              Container(
                                decoration: BoxDecoration(
                                  color: AppConstants.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppConstants.darkGrey.withOpacity(
                                        0.1,
                                      ),
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_outline,
                                      color: AppConstants.primaryGreen,
                                    ),
                                    labelText: 'Şifre',
                                    hintText: 'Şifrenizi girin',
                                    labelStyle: TextStyle(
                                      color: AppConstants.darkGrey,
                                    ),
                                    hintStyle: TextStyle(
                                      color: AppConstants.lightGrey,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: AppConstants.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Şifre boş olamaz.';
                                    }
                                    if (value.length < 6) {
                                      return 'Şifre en az 6 karakter olmalıdır.';
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    _password = newValue;
                                  },
                                ),
                              ),

                              SizedBox(height: 32),

                              // Giriş/Kayıt butonu
                              Socialloginbutton(
                                onPressed: () => _formSubmit(),
                                buttonText: _buttonText!,
                                buttonColor: AppConstants.primaryGreen,
                              ),

                              SizedBox(height: 24),

                              // Geçiş butonu
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: AppConstants.primaryGreen.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextButton(
                                  onPressed: () => _degistir(),
                                  child: Text(
                                    _linkText!,
                                    style: TextStyle(
                                      color: AppConstants.primaryGreen,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : Container(
                        color: AppConstants.white,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppConstants.primaryGreen,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                _loginType == LoginType.login
                                    ? 'Giriş yapılıyor...'
                                    : 'Hesap oluşturuluyor...',
                                style: TextStyle(
                                  color: AppConstants.darkGrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
