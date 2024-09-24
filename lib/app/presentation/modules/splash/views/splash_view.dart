import 'package:flutter/material.dart';

import '../../../../../main.dart';

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
    final connectivityRepo = Injector.of(context).connectivityRepository;
    final hasInternet = await connectivityRepo.hasInternet;

    if (hasInternet) {
      debugPrint("🔥");
    } else {
      debugPrint("😭");
    }
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
