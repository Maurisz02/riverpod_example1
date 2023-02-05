import 'package:flutter/foundation.dart'
    show immutable; //only need immutable from the package
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../posts/typedefs/user_id.dart';
import './auth_result.dart';

@immutable
class AuthState {
  final AuthResult? result;
  final bool isLoading;
  final UserId? userId;

//simple dart constructor
  const AuthState({
    required this.result,
    required this.isLoading,
    required this.userId,
  });

//at the first time this is the auto value for them
  const AuthState.unknown()
      : result = null,
        isLoading = false,
        userId = null;

  AuthState copiedWithIsLoading(bool isLoading) => AuthState(
        result: result,
        isLoading: isLoading,
        userId: userId,
      );

//Check whether two references are to the same object.
  @override
  bool operator ==(covariant AuthState other) =>
      identical(this, other) ||
      (result == other.result &&
          isLoading == other.isLoading &&
          userId == other.userId);

//need hash code to work
  @override
  int get hashCode => Object.hash(
        result,
        isLoading,
        userId,
      );
}
