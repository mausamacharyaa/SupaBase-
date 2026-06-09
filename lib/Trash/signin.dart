import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> continueWithGoogle() async {
  try {
    final GoogleSignIn signIn = GoogleSignIn.instance;
    await signIn.initialize(clientId: dotenv.env['CLIENT_ID']);
    
    final GoogleSignInAccount? account = await signIn.authenticate();
    
    final GoogleSignInAuthentication? googleAuth = await account?.authentication;
    
    final idToken = googleAuth?.idToken;
    final accessToken = googleAuth?.accessToken;

    if (idToken == null || accessToken == null) {
      throw 'Missing Google Auth Tokens';
    }

    // 3. Use the correct Supabase client instance syntax
    await Supabase.instance.client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );

  } catch (e) {
    // Note: You can replace print with a logger later if you want to clear the lint warning
    print(e); 
  }
}
