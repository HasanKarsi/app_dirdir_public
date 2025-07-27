class ErorExeption {
  static String goster(String hataKodu) {
    // Hata kodunu köşeli parantezden ayıkla
    final regExp = RegExp(r'\[firebase_auth\/([^\]]+)\]');
    final match = regExp.firstMatch(hataKodu);
    String code = hataKodu;
    if (match != null) {
      code = match.group(1)!;
    }
    code = code.toLowerCase().replaceAll('_', '-').trim();

    switch (code) {
      case "invalid-email":
        return "Geçersiz e-posta adresi.";
      case "user-not-found":
        return "Kullanıcı bulunamadı.";
      case "wrong-password":
        return "Yanlış şifre.";
      case "email-already-in-use":
        return "Bu e-posta zaten kullanılıyor.";
      case "weak-password":
        return "Şifre çok zayıf. Lütfen daha güçlü bir şifre girin.";
      case "operation-not-allowed":
        return "Bu işlem şu anda aktif değil. Lütfen daha sonra tekrar deneyin.";
      case "too-many-requests":
        return "Çok fazla deneme yapıldı. Lütfen daha sonra tekrar deneyin.";
      case "network-request-failed":
        return "Ağ bağlantı hatası. Lütfen internetinizi kontrol edin.";
      case "user-disabled":
        return "Bu kullanıcı hesabı devre dışı bırakılmış.";
      case "invalid-credential":
        return "Kimlik bilgileri geçersiz veya süresi dolmuş.";
      case "account-exists-with-different-credential":
        return "Bu e-posta başka bir oturum yöntemiyle zaten kayıtlı.";
      case "invalid-verification-code":
        return "Doğrulama kodu geçersiz.";
      case "invalid-verification-id":
        return "Doğrulama ID'si geçersiz.";
      // Diğer bilinen hata kodlarını buraya ekleyebilirsiniz.
      default:
        // Eğer hata kodu dışında açıklama varsa onu da ekle
        if (hataKodu.length > 50) {
          return "Beklenmeyen hata: $hataKodu";
        }
        return "Beklenmeyen hata oluştu ($code)";
    }
  }
}
