import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../domain/repositories/account_repository.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../../../routes/routes.dart';
import '../../../../domain/repositories/connectivity_repository.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _init(),
    );
  }

  Future<void> _init() async {
    final ConnectivityRepository connectivityRepository = context.read();
    final AuthenticationRepository authenticationRepository = context.read();
    final AccountRepository accountRepository = context.read();
    final hasInternet = await connectivityRepository.hasInternet;

    if (hasInternet) {
      debugPrint('🔥 hay internet ');
      final isSignedIn = await authenticationRepository.isSignedIn;

      if (isSignedIn) {
        final user = await accountRepository.getUserData();

        if (mounted) {
          if (user != null) {
            _goTo(Routes.home);
          } else {
            _goTo(Routes.signIn);
          }
        }
      } else if (mounted) {
        _goTo(Routes.signIn);
      }
    } else {
      debugPrint('😭 sin internet');
      _goTo(Routes.offLine);
    }
  }

  void _goTo(String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
