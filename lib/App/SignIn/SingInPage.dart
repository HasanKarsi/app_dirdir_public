import 'package:app_dirdir/App/SignIn/EmailPasswordCreate.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/CommonWidget/SocialLoginButton.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Kullanıcıların oturum açmasını sağlayan giriş sayfası.
/// Farklı oturum açma yöntemleri (Google, Facebook, E-posta, Misafir) sunar.
class SingInPage extends StatelessWidget {
  const SingInPage({super.key});

  /// Misafir girişi işlemini gerçekleştirir.
  /// Firebase üzerinden anonim oturum açar ve kullanıcı ID'sini konsola yazdırır.
  /*   Future<void> _guestLogin(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    UserModel? user =
        await userViewModel
            .signInAnonymously(); // Firebase üzerinden anonim oturum açma işlemi
    print(
      'Oturum acan user id : ${user?.userId}',
    ); // Kullanıcı ID'sini yazdırır
  } */

  void _googleSignIn(BuildContext context) async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);

    UserModel? user = await userViewModel.signInWithGoogle();
    if (user != null) {
      debugPrint('Oturum acan user id : ${user.userId}');
    }
  }

  void EmailPasswordLogin(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => const EmailPasswordCreate(),
        fullscreenDialog: true,
      ),
    ); // E-posta ile giriş sayfasına yönlendirir
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.lightGrey,
      body: SafeArea(
        child: Column(
          children: [
            // Üst kısım - Logo ve başlık
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppConstants.backgroundGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Container(
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: AppConstants.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'Images/dirdiriconv2.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.chat_bubble_outline,
                              size: 80,
                              color: AppConstants.white,
                            );
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    Text(
                      "DirDir",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.white,
                        letterSpacing: 2,
                      ),
                    ),

                    SizedBox(height: 8),

                    Text(
                      "Arkadaşlarınla güvenle mesajlaş",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Alt kısım - Giriş seçenekleri
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Oturum Açın",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 32),

                    // Google ile giriş butonu
                    Socialloginbutton(
                      onPressed: () => _googleSignIn(context),
                      buttonText: "Google ile Giriş Yap",
                      buttonColor: AppConstants.white,
                      textColor: AppConstants.black,
                      buttonIcon: Image.asset('Images/30x30G.png'),
                    ),

                    SizedBox(height: 16),

                    // E-posta ile giriş butonu
                    Socialloginbutton(
                      onPressed: () => EmailPasswordLogin(context),
                      buttonText: "E-posta ile Giriş Yap",
                      buttonColor: AppConstants.primaryGreen,
                      buttonIcon: Icon(
                        Icons.mail_outline,
                        color: AppConstants.white,
                      ),
                    ),

                    SizedBox(height: 32),

                    // Güvenlik mesajı
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppConstants.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.lock_outline,
                            color: AppConstants.primaryGreen,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Tüm mesajlarınız uçtan uca şifrelenir",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppConstants.darkGreen,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Alt bilgi
            Padding(
              padding: EdgeInsets.only(bottom: 24),
              child: Text(
                "© KARSH 2025 DirDir",
                style: TextStyle(fontSize: 12, color: AppConstants.darkGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
