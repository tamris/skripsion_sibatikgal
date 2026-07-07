import 'package:batikara/app/data/config/app_config.dart';
import 'package:batikara/app/data/provider/api_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.init();
  ApiProvider.init();
  await initializeDateFormatting('id_ID', null);

  // 3. Tambahkan blok kode ini untuk mengatur gaya status bar
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Membuat status bar transparan
    statusBarIconBrightness:
        Brightness.dark, // Membuat ikon (jam, baterai) menjadi gelap
  ));
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
