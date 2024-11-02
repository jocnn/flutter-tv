import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../routes/routes.dart';
import '../../../../domain/enums.dart';
import '../../../../domain/repositories/authentication_repository.dart';
import '../controller/sign_in_controller.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignInController>(
      create: (_) => SignInController(),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              child: Builder(builder: (context) {
                final controller = Provider.of<SignInController>(context);
                return AbsorbPointer(
                  absorbing: controller.fetching,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (text) {
                          controller.onUsernameChanged(text);
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
                          controller.onPasswordChanged(text);
                        },
                        decoration: const InputDecoration(
                          hintText: 'password',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                        validator: (value) {
                          value = value?.replaceAll(' ', '') ?? '';

                          if (value.length < 4) return 'Invalid password';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      if (controller.fetching)
                        const CircularProgressIndicator()
                      else
                        MaterialButton(
                          onPressed: () {
                            final isValid = Form.of(context).validate();
                            if (isValid) {
                              _submit(context);
                            }
                          },
                          color: Colors.blue.shade800,
                          textColor: Colors.white,
                          child: const Text('Sign in'),
                        )
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit(BuildContext context) async {
    final SignInController controller = context.read();
    controller.onFetchingChanged(true);

    final result = await context.read<AuthenticationRepository>().signIn(
          controller.username,
          controller.password,
        );

    if (!mounted) return;

    result.when(
      (failure) {
        controller.onFetchingChanged(false);
        final message = {
          SignInFailure.notFound: 'Not found',
          SignInFailure.unAuthorized: 'Invalid password',
          SignInFailure.unknown: 'Error',
          SignInFailure.network: 'Network error',
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
