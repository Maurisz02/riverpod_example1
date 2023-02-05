import 'dart:io';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:riverpod_example1/Instagram/state/auth/providers/user_id_provider.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/models/file_type.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/models/thumbnail_request.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:riverpod_example1/Instagram/state/post_setings/models/post_setting.dart';
import 'package:riverpod_example1/Instagram/state/post_setings/providers/post_settings_provider.dart';
import 'package:riverpod_example1/Instagram/views/components/file_thumbnail_view.dart';
import 'package:riverpod_example1/Instagram/views/constants/strings.dart';

//we use flutter hook to
//a consumer stateful widget is use for if we need mounted

class CreateNewPostView extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;
  const CreateNewPostView({
    super.key,
    required this.fileToPost,
    required this.fileType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateNewPostViewState();
}

class _CreateNewPostViewState extends ConsumerState<CreateNewPostView> {
  @override
  Widget build(BuildContext context) {
    //we start the request for the pic or video
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );

    //we can switch the post setting true or false with this
    final postSettings = ref.watch(postSettingProvider);

    //with hooks we can create a texteditingcontroller for the comment
    //and we hooked in a state therefore we can change it
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);

    //watch if we write something to post and its value is equal to it if its true or false
    useEffect(
      () {
        void listener() {
          isPostButtonEnabled.value = postController.text.isNotEmpty;
        }

        //set to the textediting controller listener to watch it
        postController.addListener(listener);

        return () {
          postController.removeListener(listener);
        };
      },
      [
        postController
      ], //it means if the post controller changes rebuild the useffect
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            onPressed: isPostButtonEnabled.value
                ? () async {
                    //get the current user id
                    final userId = ref.read(userIdProvider);
                    //userid is an optional value
                    if (userId == null) {
                      return;
                    }

                    //get the message
                    final message = postController.text;
                    final isUploaded =
                        await ref.read(imageUploadProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              postSettings: postSettings,
                              userId: userId,
                            );
                    if (isUploaded && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(
              Icons.send,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),
            ...PostSetting.values.map(
              (postSetting) => ListTile(
                title: Text(postSetting.title),
                subtitle: Text(postSetting.description),
                trailing: Switch(
                  value: postSettings[postSetting] ?? false,
                  onChanged: (isOn) {
                    ref.read(postSettingProvider.notifier).setSetting(
                          postSetting,
                          isOn,
                        );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
