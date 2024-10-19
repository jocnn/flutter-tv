import 'package:flutter/material.dart';

import '../../../../../main.dart';
import '../../../../domain/enums.dart';
import '../../../routes/routes.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  String _username = '', _password = '';
  bool _fetching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            child: AbsorbPointer(
              absorbing: _fetching,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(() {
                        _username = text.trim().toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'username',
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    validator: (value) {
                      value = value?.trim().toLowerCase() ?? '';

                      if (value.isEmpty) return 'Invalid username';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (text) {
                      setState(() {
                        _password = text.replaceAll(' ', '').toLowerCase();
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'password',
                      hintStyle: TextStyle(color: Colors.black38),
                    ),
                    validator: (value) {
                      value = value?.replaceAll(' ', '').toLowerCase() ?? '';

                      if (value.length < 4) return 'Invalid password';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Builder(
                    builder: (context) {
                      if (_fetching) {
                        return const CircularProgressIndicator();
                      }

                      return MaterialButton(
                        onPressed: () {
                          final isValid = Form.of(context).validate();
                          if (isValid) {
                            _submit(context);
                          }
                        },
                        color: Colors.blue.shade800,
                        textColor: Colors.white,
                        child: const Text('Sign in'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _fetching = true;
    });

    final result = await Injector.of(context).authenticationRepository.signIn(
          _username,
          _password,
        );

    if (!mounted) return;

    result.when(
      (failure) {
        setState(() {
          _fetching = false;
        });
        final message = {
          SignInFailure.notFound: 'Not found',
          SignInFailure.unAuthorized: 'Invalid password',
          SignInFailure.unknown: 'Error',
        }[failure];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message!)),
        );
      },
      (user) {
        Navigator.pushReplacementNamed(
          context,
          Routes.home,
        );
      },
    );
  }
}
