import 'package:cloud_firestore/cloud_firestore.dart';

class KonusmaModel {
  final String? konusmaSahibi;
  final String? konusmaSahibiName;
  final String? kimleKonusuyor;
  final bool? konusmaGoruldu;
  final Timestamp? olusturulmaTarihi;
  final String? sonMesaj;
  final Timestamp? gorulmeTarihi;
  String? konusulanUserName;
  String? konusulanUserProfileUrl;
  DateTime? sonOkunmaZamani;
  String? aradakiFark;

  KonusmaModel({
    this.konusmaSahibi,
    this.konusmaSahibiName,
    this.kimleKonusuyor,
    this.konusmaGoruldu,
    this.olusturulmaTarihi,
    this.sonMesaj,
    this.gorulmeTarihi,
  });

  Map<String, dynamic> toMap() {
    return {
      'konusmaSahibi': konusmaSahibi,
      'konusmaSahibiName': konusmaSahibiName,
      'kimleKonusuyor': kimleKonusuyor,
      'konusmaGoruldu': konusmaGoruldu,
      'olusturulmaTarihi': olusturulmaTarihi ?? FieldValue.serverTimestamp(),
      'sonMesaj': sonMesaj ?? FieldValue.serverTimestamp(),
      'gorulmeTarihi': gorulmeTarihi,
    };
  }

  KonusmaModel.fromMap(Map<String, dynamic> map)
    : konusmaSahibi = map['konusmaSahibi'],
      konusmaSahibiName = map['konusmaSahibiName'],
      kimleKonusuyor = map['kimleKonusuyor'],
      konusmaGoruldu = map['konusmaGoruldu'],
      olusturulmaTarihi = map['olusturulmaTarihi'],
      sonMesaj = map['sonMesaj'],
      gorulmeTarihi = map['gorulmeTarihi'];

  @override
  String toString() {
    return 'KonusmaModel{'
        ' konusmaSahibi: $konusmaSahibi,'
        ' konusmaSahibiName: $konusmaSahibiName,'
        ' kimleKonusuyor: $kimleKonusuyor,'
        ' konusmaGoruldu: $konusmaGoruldu,'
        ' olusturulmaTarihi: $olusturulmaTarihi,'
        ' sonMesaj: $sonMesaj,'
        ' gorulmeTarihi: $gorulmeTarihi'
        '}';
  }
}
