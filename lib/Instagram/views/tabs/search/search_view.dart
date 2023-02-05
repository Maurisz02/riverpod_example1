import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:riverpod_example1/Instagram/views/components/search_grid_view.dart';
import 'package:riverpod_example1/Instagram/views/constants/strings.dart';
import 'package:riverpod_example1/Instagram/views/extensions/dismiss_keyboard.dart';

//need hooks because of textCOntroller
class SearchView extends HookConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    final searchTerm = useState('');

    useEffect(
      () {
        controller.addListener(
          () {
            searchTerm.value = controller.text;
          },
        );
        return () {};
      },
      [controller], //valtozas oka
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: Strings.enterYourSearchTermHere,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    dismissKeyboard();
                  },
                ),
              ),
            ),
          ),
        ),
        SearchGridView(searchTerm: searchTerm.value),
      ],
    );
  }
}
