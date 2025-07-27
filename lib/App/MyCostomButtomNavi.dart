import 'package:app_dirdir/App/TabItems.dart';
import 'package:app_dirdir/CommonWidget/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Mycostombuttomnavi extends StatelessWidget {
  const Mycostombuttomnavi({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
    required this.sayfaOlusturucu,
    required this.navigatorKeys,
  });

  final TabItem? currentTab;
  final ValueChanged<TabItem>? onSelectTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: AppConstants.white,
        activeColor: AppConstants.primaryGreen,
        inactiveColor: AppConstants.darkGrey,
        border: Border(
          top: BorderSide(color: AppConstants.lightGrey, width: 0.5),
        ),
        height: 65,
        iconSize: 26,
        items: [
          _navItemOlustur(TabItem.Kullanicilar), // Kullanıcılar sekmesi
          _navItemOlustur(TabItem.Konusmalarim), // Konuşmalarım sekmesi
          _navItemOlustur(TabItem.Profil), // Profil sekmesi
        ],
        onTap:
            (index) =>
                onSelectTab!(TabItem.values[index]), // Sekme tıklandığında
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem =
            TabItem.values[index]; // Hangi sekme gösterilecek
        return CupertinoTabView(
          navigatorKey:
              navigatorKeys[gosterilecekItem]!, // İlgili sekmenin navigator anahtarı
          builder:
              (context) =>
                  sayfaOlusturucu[gosterilecekItem]!, // İlgili sayfayı göster
        );
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemsData.tumTablolar[tabItem];

    return BottomNavigationBarItem(
      icon: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Icon(olusturulacakTab!.icon, size: 24),
      ),
      activeIcon: Container(
        padding: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: AppConstants.primaryGreen.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                olusturulacakTab.icon,
                size: 24,
                color: AppConstants.primaryGreen,
              ),
              SizedBox(width: 6),
              Text(
                olusturulacakTab.title,
                style: TextStyle(
                  color: AppConstants.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
      label: '', // Boş bırakıyoruz çünkü activeIcon'da gösteriyoruz
    );
  }
}
