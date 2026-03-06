import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import './routes.dart' show Routes;


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: Routes.splash ,
  routes: [
    GoRoute( 
      path: Routes.splash,
      builder: (context, state) => const,
    )
  ]
);