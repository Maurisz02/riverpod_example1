import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/auth/models/auth_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/auth_state.dart';
import '../backend/authenticator.dart';
import '../../user_info/backend/user_info_storage.dart';
import '../../posts/typedefs/user_id.dart';

//AuthState is a modal object a class
//Authenticator() is the engine for the server side code it lift the logic
//AuthStateNotifier is the window which connect the widgets and the server-side logic together

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _authenticator = const Authenticator();
  final _userInfoStorage = const UserInfoStorage();

//if the user already logged in it gives the user value else set the unknown
//constructor of riverpod
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (_authenticator.isAlreadyLoggedIn) {
      state = AuthState(
        result: AuthResult.success,
        isLoading: false,
        userId: _authenticator.userId,
      );
    }
  }

  Future<void> logOut() async {
    state = state.copiedWithIsLoading(true);
    await _authenticator.logOut();
    state = const AuthState.unknown();
  }

  Future<void> loginWithGoogle() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithGoogle();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> loginWithFacebook() async {
    state = state.copiedWithIsLoading(true);
    final result = await _authenticator.loginWithFacebook();
    final userId = _authenticator.userId;

    if (result == AuthResult.success && userId != null) {
      await saveUserInfo(
        userId: userId,
      );
    }
    state = AuthState(
      result: result,
      isLoading: false,
      userId: userId,
    );
  }

  Future<void> saveUserInfo({required UserId userId}) =>
      _userInfoStorage.saveUserInfo(
        userId: userId,
        displayName: _authenticator.displayName,
        email: _authenticator.email,
      );
}
