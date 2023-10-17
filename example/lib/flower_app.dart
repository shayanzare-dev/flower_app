import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'localization_service.dart';

class FlowerApp extends StatelessWidget {
  const FlowerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flower app',
        initialRoute: RouteNames.loadingPageFlower,
        getPages: RoutePages.pages,
        translations: LocalizationService(),
        locale: const Locale('en', 'US'),
      );
}
