import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  String? eMail;
  String? userName;
  String? profileURL;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? level;

  UserModel({required this.userId, required this.eMail});

  UserModel.idVeResim({
    required this.userId,
    required this.profileURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'eMail': eMail,
      'userName':
          userName ?? eMail!.substring(0, eMail!.indexOf('@')) + randomSayiUret(),
      'profileURL':
          profileURL ??
          'https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png',
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'level': level ?? 1,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map)
    : userId = map['userId'],
      eMail = map['eMail'],
      userName = map['userName'],
      profileURL = map['profileURL'],
      createdAt = (map['createdAt'] as Timestamp).toDate(),
      updatedAt = (map['updatedAt'] as Timestamp).toDate(),
      level = map['level'];

  @override
  String toString() {
    return 'User{userId: $userId, email: $eMail, userName: $userName, profileURL: $profileURL, createdAt: $createdAt, updatedAt: $updatedAt, level: $level}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999);
    return rastgeleSayi.toString();
  }
}
