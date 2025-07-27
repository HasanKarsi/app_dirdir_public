// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app_dirdir/App/KonusmalarimPage.dart';
import 'package:app_dirdir/App/KullanicilarPage.dart';
import 'package:app_dirdir/App/MyCostomButtomNavi.dart';
import 'package:app_dirdir/App/ProfilPage.dart';
import 'package:app_dirdir/App/TabItems.dart';
import 'package:app_dirdir/ViewModel/AllUserViewModel.dart';
import 'package:app_dirdir/services/FirebaseCMServices.dart';
import 'package:app_dirdir/services/LocalNotificationService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app_dirdir/model/UserModel.dart';
import 'package:provider/provider.dart';

/// Uygulamanın ana sayfası.
/// Kullanıcı oturum açmışsa bu sayfa gösterilir.
class HomePage extends StatefulWidget {
  /// Firebase'den alınan kullanıcı bilgisi.
  /// Bu bilgi, oturum açmış kullanıcıyı temsil eder.

  final UserModel user;

  /// Ana sayfa widget'ı.
  /// Kullanıcı bilgisi (`user`) parametre olarak alınır.
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.Kullanicilar; // Varsayılan sekme

  /// Navigator anahtarları, her sekme için ayrı bir navigator state'i tutar.
  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Profil: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim:
          const KonusmalarimPage(), // Konuşmalarım sayfasını dönerir
      TabItem.Profil: const ProfilPage(), // Profil sayfasını dönerir
    };
  }

  @override
  Widget build(BuildContext context) {
    return FCMWrapper(
      child: Container(
        child: Mycostombuttomnavi(
          navigatorKeys: navigatorKeys, // Navigator anahtarlarını sağlar
          sayfaOlusturucu: tumSayfalar(),
          currentTab: _currentTab,
          onSelectTab: (secilenTab) {
            if (secilenTab == _currentTab) {
              // Eğer kullanıcı zaten seçili sekmeye tıkladıysa
              navigatorKeys[secilenTab]!.currentState?.popUntil(
                (route) => route.isFirst,
              ); // Navigator'ı ilk sayfaya geri döndürür
            }
            setState(() {
              _currentTab =
                  secilenTab; // Kullanıcının seçtiği sekmeyi günceller
            });
            debugPrint(
              'Seçilen sekme: ${TabItemsData.tumTablolar[secilenTab]!.title}',
            ); // Seçilen sekmeyi konsola yazdırır
          },
        ),
      ),
    );
  }
}

class FCMWrapper extends StatefulWidget {
  final Widget child;

  const FCMWrapper({super.key, required this.child});

  @override
  State<FCMWrapper> createState() => _FCMWrapperState();
}

class _FCMWrapperState extends State<FCMWrapper> {
  get navigatorKeys => null;

  @override
  void initState() {
    super.initState();
    _initFCM();
  }

  void _initFCM() async {
    // Yerel bildirim servisini başlat
    LocalNotificationService.initialize();
    await LocalNotificationService.createNotificationChannel();

    print('📱 Local Notification Service başlatıldı');

    // FCM'i başlat (token al, kaydet ve refresh listener başlat)
    await FirebaseCMServices.instance.initializeFCM();

    // Foreground message handler - Uygulama içinde SnackBar göster
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📱 Foreground message alındı: ${message.notification?.title}');

      // Uygulama açıkken SnackBar göster (daha iyi UX)
      LocalNotificationService.showInAppNotification(message);
    });

    // Message tıklandığında
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📱 Message açıldı: ${message.notification?.title}');
      // Burada belirli bir sayfaya yönlendirme yapabilirsiniz
      if (message.data['page'] == 'KonusmalarimPage.dart') {
        //Ilerleyen Surecte cypilacak!!!!!!!!!!!!!!
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
