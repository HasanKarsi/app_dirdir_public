import 'package:flutter/material.dart';

enum TabItem { Kullanicilar, Konusmalarim, Profil }

class TabItemsData {
  final String title; // Sekmenin başlığı
  final IconData icon; // Sekmenin ikonu

  TabItemsData({required this.title, required this.icon});
  static Map<TabItem, TabItemsData> tumTablolar = {
    TabItem.Kullanicilar: TabItemsData(
      title: 'Kişiler',
      icon: Icons.contacts_outlined,
    ),
    TabItem.Konusmalarim: TabItemsData(
      title: 'Sohbetler',
      icon: Icons.chat_bubble_outline,
    ),
    TabItem.Profil: TabItemsData(title: 'Profil', icon: Icons.person_outline),
  };
}
