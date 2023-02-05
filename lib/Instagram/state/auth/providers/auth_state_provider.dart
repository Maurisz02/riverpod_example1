import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifiers/auth_state_notfier.dart';
import '../models/auth_state.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  //dont need ref because the ref is the statenotifier
  (_) => AuthStateNotifier(),
);
