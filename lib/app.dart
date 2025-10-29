import 'package:flutter/material.dart';
import 'features/auth/provider/auth_provider.dart';
import 'features/auth/presentation/login_page.dart';
import 'features/votes/presentation/votes_list_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vote App',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: authState.when(
        data: (user) =>
            user != null ? const VotesListPage() : const LoginPage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      ),
    );
  }
}
