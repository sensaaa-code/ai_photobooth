import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router/app_router.dart';

/// Root widget of the application.
///
/// Uses [ConsumerWidget] so it can watch [routerProvider], which enables
/// the router's redirect guard to react to session state changes.
class PhotoboothApp extends ConsumerWidget {
  const PhotoboothApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the router provider — this also registers the ref.listen inside
    // routerProvider that triggers router.refresh() on session changes.
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'AI Photobooth',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
      ),
    );
  }
}