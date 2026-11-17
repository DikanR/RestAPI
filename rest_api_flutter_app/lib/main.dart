import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/views/umkm_view.dart';
import 'umkm_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'UMKM Rest API App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),
      initialRoute: '/umkm',
      getPages: [
        GetPage(name: '/umkm', page: () => const UmkmView()),
        GetPage(name: '/umkm/add', page: () => const UmkmFormPage()),
      ],
    );
  }
}
