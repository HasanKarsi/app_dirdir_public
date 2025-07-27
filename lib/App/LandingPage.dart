import 'package:app_dirdir/App/HomePage.dart';
import 'package:app_dirdir/App/SignIn/SingInPage.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:app_dirdir/ViewModel/UserViewModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Uygulamanın açılış sayfası.
/// Kullanıcı oturum açmışsa `HomePage`, oturum açmamışsa `SingInPage` gösterilir.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(
      context,
    ); // UserViewModel'i al.

    if (userViewModel.state == ViewState.Idle) {
      if (userViewModel.user == null) {
        return SingInPage(); // Kullanıcı oturum açmamışsa giriş sayfasını göster.
      } else {
        return HomePage(
          user: userViewModel.user!, // Kullanıcı bilgisi gönderiliyor.
        ); // Kullanıcı oturum açmışsa ana sayfayı göster.
      }
    } else {
      return Scaffold(
        backgroundColor: AppConstants.primaryGreen,
        body: Container(
          decoration: BoxDecoration(gradient: AppConstants.backgroundGradient),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Ana logo resmi
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppConstants.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'Images/dirdiriconv2.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.chat_bubble_outline,
                          size: 120,
                          color: AppConstants.white,
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 40),

                // Uygulama adı
                Text(
                  "DırDır",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.white,
                    letterSpacing: 3,
                  ),
                ),

                SizedBox(height: 60),

                // Loading indicator
                CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.white),
                ),

                SizedBox(height: 20),

                Text(
                  "Yükleniyor...",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppConstants.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
