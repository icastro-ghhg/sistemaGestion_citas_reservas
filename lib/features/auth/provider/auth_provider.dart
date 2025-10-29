import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authState,
);

final signInProvider = FutureProvider<void>((ref) async {
  await ref.read(authRepositoryProvider).signInWithGoogle();
});

final signOutProvider = FutureProvider<void>((ref) async {
  await ref.read(authRepositoryProvider).signOut();
});
