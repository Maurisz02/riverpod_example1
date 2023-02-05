import 'package:flutter/foundation.dart' show immutable;

//constans which needs the login
@immutable
class Constants {
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
  static const googleCom = 'google.com';
  static const emailScope = 'email';
  static const emailScope2 =
      'https://www.googleapis.com/auth/contacts.readonly';

//constructor which cannot be set outside
  const Constants._();
}
