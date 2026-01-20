import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class OauthService {
  // Instance GoogleSignIn ditaruh di sini agar terpusat
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '103304029532-j66493juqr72sgmnu3eurtc1p4m2ooki.apps.googleusercontent.com',
    scopes: ['email', 'openid', 'profile'],
  );

  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // 1. Jalankan proses login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancel login

      // 2. Ambil idToken dari hasil login
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) return null;

      // 3. Kirim idToken ke backend Flask kamu
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/oauth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            jsonDecode(response.body)['error'] ?? 'Gagal login ke server');
      }
    } catch (e) {
      rethrow; // Biarkan controller yang menangani error-nya untuk snackbar
    }
  }

  // Tambahkan fungsi logout jika perlu
  static Future<void> logout() async {
    try {
      // Menghapus sesi Google agar muncul pilihan akun (account picker) saat login lagi
      await _googleSignIn.signOut();

      // Opsional: Gunakan disconnect() jika ingin benar-benar memutus tautan (revoke access)
      // await _googleSignIn.disconnect();
    } catch (e) {
      print("Error during Google Logout: $e");
    }
  }
}
