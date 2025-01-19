import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hm_web_flutter/home_page.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: 'dotenv');

  usePathUrlStrategy();

  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purpleAccent),
        scaffoldBackgroundColor: Color(0x57ffe3f1),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0x57ffe3f1),
          surfaceTintColor: Color(0x57ffe3f1),
          scrolledUnderElevation: 0,
          elevation: 0
        ),
      ),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) => DetailPage(
          id: state.pathParameters['id']!,
        ),
      ),
    ],
  );
});
