import 'package:cloud_firestore/cloud_firestore.dart';

class MesajModel {
  final String kimden;
  final String kime;
  final bool bendenMi;
  final String mesaj;
  final String konusmaSahibi;
  final Timestamp? zaman;

  MesajModel({
    required this.kimden,
    required this.kime,
    required this.bendenMi,
    required this.mesaj,
    required this.konusmaSahibi,
    this.zaman,
  });

  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kime': kime,
      'bendenMi': bendenMi,
      'mesaj': mesaj,
      'konusmaSahibi': konusmaSahibi,
      'zaman': zaman != null ? zaman! : FieldValue.serverTimestamp(),
    };
  }

  MesajModel.fromMap(Map<String, dynamic> map)
    : kimden = map['kimden'],
      kime = map['kime'],
      bendenMi = map['bendenMi'],
      mesaj = map['mesaj'],
      konusmaSahibi = map['konusmaSahibi'],
      zaman = map['zaman'];

  @override
  String toString() {
    return 'MesajModel{'
        ' kimden: $kimden,'
        ' kime: $kime,'
        ' bendenMi: $bendenMi,'
        ' mesaj: $mesaj,'
        ' konusmaSahibi: $konusmaSahibi,'
        ' zaman: $zaman'
        '}';
  }
}
