import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_barbershop_dartweek/src/core/ui/constants.dart';
import 'package:project_barbershop_dartweek/src/core/ui/helpers/messages.dart';
import 'package:project_barbershop_dartweek/src/features/splash/splash_vm.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  var _scale = 10.0;
  var _animationOpacity = 0.0;

  double get _logoAnimationWidth => 100 * _scale;
  double get _logoAnimationHeight => 120 * _scale;

  var endAnimation = false;
  Timer? redirectTimer;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _animationOpacity = 1.0;
        _scale = 1.0;
      });
    });
    super.initState();
  }

  void redirect(String routeName) {
    if (!endAnimation) {
      redirectTimer?.cancel();
      redirectTimer = Timer(const Duration(milliseconds: 300), () {
        redirect(routeName);
      });
    } else {
      redirectTimer?.cancel();
      Navigator.of(context).pushNamedAndRemoveUntil(
        routeName,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(splashVMProvider, (_, state) {
      state.whenOrNull(
        error: (error, stackTrace) {
          log('Erro ao validar o login', error: error, stackTrace: stackTrace);
          Messages.showError('Erro ao validar login', context);
          redirect('/auth/login');
        },
        data: (data) {
          switch (data) {
            case SplashState.loggedADM:
              redirect('/home/adm');
            case SplashState.loggedEmployee:
              redirect('/home/employee');
            case _:
              redirect('/auth/login');
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              ImageConstants.backgroundChair,
            ),
            opacity: 0.2,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: const Duration(seconds: 1),
            curve: Curves.easeIn,
            opacity: _animationOpacity,
            onEnd: () {
              setState(() => endAnimation = true);
            },
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              width: _logoAnimationWidth,
              height: _logoAnimationHeight,
              curve: Curves.linearToEaseOut,
              child: Image.asset(
                ImageConstants.imageLogo,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
