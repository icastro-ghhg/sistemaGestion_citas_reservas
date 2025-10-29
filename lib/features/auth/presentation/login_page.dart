import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signIn = ref.watch(signInProvider);

    return Scaffold(
      body: Center(
        child: signIn.when(
          data: (_) => ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text('Iniciar sesión con Google'),
            onPressed: () {
              ref.refresh(signInProvider);
            },
          ),
          loading: () =>
              const CircularProgressIndicator(color: Colors.deepPurple),
          error: (e, _) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $e'),
              ElevatedButton(
                onPressed: () => ref.refresh(signInProvider),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
