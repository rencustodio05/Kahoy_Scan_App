import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'data/store/kahoy_store.dart';
import 'features/home/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KahoyStore.instance.init();
  runApp(const KahoyScanApp());
}

class KahoyScanApp extends StatelessWidget {
  const KahoyScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kahoy Scan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const HomeScreen(),
    );
  }
}
