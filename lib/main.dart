import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> saveStaticApiToken() async {
  const storage = FlutterSecureStorage();


  const String professorJWT = 'eyJhbGciOiJSUzI1NiIsImtpZCI6ImZiOWY5MzcxZDU3NTVmM2UzODNhNDBhYjNhMTcyY2Q4YmFjYTUxN2YiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20iLCJhenAiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJhdWQiOiIyMTIyNjc2ODY2MDQtMGo0a3M5c25pa2plMHNzdGpqbW10Mm1tZTJvZHYyZnUuYXBwcy5nb29nbGV1c2VyY29udGVudC5jb20iLCJzdWIiOiIxMDgwNzg3MzA0NzI4OTUxNDI5ODMiLCJoZCI6InV0ZW0uY2wiLCJlbWFpbCI6ImNjaGFsYUB1dGVtLmNsIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsImF0X2hhc2giOiJna2Z1TXBYb3lIcWZkNXl2a3Zid3pBIiwibmFtZSI6IkNSSVNUSUFOIEpBVklFUiBDSEFMQSBST0RSSUdVRVoiLCJwaWN0dXJlIjoiaHR0cHM6Ly9saDMuZ29vZ2xldXNlcmNvbnRlbnQuY29tL2EvQUNnOG9jSWdHemQ0WERzSktQN0VpZDlfTFhnNGVJUWNrWEZ1Njl5M2FfMjhsWmx3RXlNWDRnPXM5Ni1jIiwiZ2l2ZW5fbmFtZSI6IkNSSVNUSUFOIEpBVklFUiIsImZhbWlseV9uYW1lIjoiQ0hBTEEgUk9EUklHVUVaIiwiaWF0IjoxNzYwOTg3MjY0LCJleHAiOjE3NjA5OTA4NjR9.ZzUWlLGFFAnvU5R5qO7QC8nfsc4HsYjoe6Nz7jjtyjh4Xq0xbzzl_kPouFnqhjg77NPsMTaxKGRl-klJ6AYVK0kNvdV5-SsQZ-ntgRasblW-AjD1nqvE-d_t2TKf75imXvQFWgSCWE6Hfm13evu3B-m8xCXyfsfKpKl2R2_6siSH14obPACAz1iaZg3QIyEx0wkBjKmm5z5JTgpHTnslvz4xZ1ps2jm3MUOtEJvuYice5-iNCgJbRw8cuzFdyxXPIRDFGbBjtVkyYn_EEA3Ry8qlcezTcGd_ELkSzFCOaL1zYoobAaUYhiE5zGEySg7WzPmCuo8yPDaCEzy0UM_-jA';


  await storage.write(key: 'api_jwt', value: professorJWT);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await saveStaticApiToken();
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  runApp(const ProviderScope(child: MyApp()));
}
