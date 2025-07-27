import 'dart:io';
import 'package:app_dirdir/CommonWidget/PlatformDuyarliWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Platformduyarlialertdialog extends Platformduyarliwidget {
  Platformduyarlialertdialog({
    required this.title,
    required this.content,
    this.buttonText,
    this.cancelButtonText,
  });

  final String title;
  final String content;
  final String? buttonText;
  final String? cancelButtonText;

  Future<bool> goster(BuildContext context) async {
    if (!context.mounted) return false; // Flutter 3.7+ için
    bool? sonuc;
    if (Platform.isIOS) {
      sonuc = await showCupertinoDialog<bool>(
        context: context,
        builder: (context) => this,
      );
    } else {
      sonuc = await showDialog<bool>(
        barrierDismissible: false,
        context: context,
        builder: (context) => this,
      );
    }
    return sonuc ?? false;
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        tumButonlar.add(
          CupertinoDialogAction(
            child: Text(cancelButtonText!),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      tumButonlar.add(
        CupertinoDialogAction(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonText != null) {
        tumButonlar.add(
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(cancelButtonText!),
          ),
        );
      }

      tumButonlar.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text("Tamam"),
        ),
      );
    }

    return tumButonlar;
  }
}
