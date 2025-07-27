import 'package:flutter/material.dart';

class AppConstants {
  // WhatsApp benzeri renk paleti
  static const Color primaryGreen = Color(0xFF606c38); // Ana yeşil
  static const Color darkGreen = Color(0xFF2f3e28); // Koyu yeşil
  static const Color lightYellow = Color(0xFFdda15e); // Açık sarı
  static const Color darkOrange = Color(0xFFbc6c25); // Koyu turuncu

  // Ek renkler
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF757575);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Colors.transparent;

  // WhatsApp benzeri gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryGreen, darkGreen],
  );

  // Text styles
  static const TextStyle titleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: white,
  );

  static const TextStyle nameTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: black,
  );

  static const TextStyle messageTextStyle = TextStyle(
    fontSize: 14,
    color: darkGrey,
  );

  static const TextStyle timeTextStyle = TextStyle(
    fontSize: 12,
    color: darkGrey,
  );

  static const TextStyle emptyStateTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: darkGreen,
  );

  // Paddings
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: 16.0,
    vertical: 8.0,
  );

  // Border radius
  static const double defaultBorderRadius = 12.0;
  static const double avatarRadius = 24.0;

  // Sizes
  static const double appBarHeight = 56.0;
  static const double listItemHeight = 72.0;
}
