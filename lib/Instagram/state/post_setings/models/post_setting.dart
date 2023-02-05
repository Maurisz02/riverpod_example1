import '../constants/constants.dart';

//this enum has 2 enum cases
enum PostSetting {
  allowLikes(
    title: Constants.allowLikesTitle,
    description: Constants.allowLikesDescription,
    storageKey: Constants.allowLikesStorageKey,
  ),

  allowComments(
    title: Constants.allowCommentsTitle,
    description: Constants.allowCommentsDescription,
    storageKey: Constants.allowCommentsStorageKey,
  );

//properties
  final String title;
  final String description;
  final String storageKey;

//constructor
  const PostSetting({
    required this.title,
    required this.description,
    required this.storageKey,
  });
}
