import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/graph_screen.dart'; 
import 'utils/storage_helper.dart';

void main() async {
  // 必须加上这行，确保 Flutter 原生层已经准备好，才能读写文件
  WidgetsFlutterBinding.ensureInitialized(); 
  
  // 初始化我们的统一存储路径
  await AppStorage.init(); 

  runApp(const WayHomeApp());
}

class WayHomeApp extends StatefulWidget {
  const WayHomeApp({super.key});

  @override
  State<WayHomeApp> createState() => _WayHomeAppState();
}

class _WayHomeAppState extends State<WayHomeApp> {
  Locale _currentLocale = const Locale('zh');

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'zh' ? const Locale('en') : const Locale('zh');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _currentLocale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh'), Locale('en')],
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: MainGraphScreen(onToggleLang: _toggleLanguage),
    );
  }
}