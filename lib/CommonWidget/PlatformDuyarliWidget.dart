import 'dart:io';
import 'package:flutter/material.dart';

abstract class Platformduyarliwidget extends StatelessWidget {
  const Platformduyarliwidget({super.key});

  // Platforma duyarlı widget oluşturma
  Widget buildIOSWidget(BuildContext context);

  Widget buildAndroidWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    // Platform kontrolü yaparak uygun widget'ı döndür
    if (Platform.isIOS) {
      return buildIOSWidget(context);
    } else {
      return buildAndroidWidget(context);
    }
  }
}
