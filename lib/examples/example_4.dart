import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//this is example 4
//Using StreamProvider
//Stream timer and depen on it we show different names

//List of names
const names = [
  'Alice',
  'Bob',
  'Charlie',
  'David',
  'Eve',
  'Fred',
  'Ginny',
  'Harriet',
  'Ilenia',
  'Joseph',
  'Kincaid',
  'Larry',
];

//this is just providing the stream event
//simulate the stream event
final tickerProvider = StreamProvider(
  ((ref) => Stream.periodic(
        const Duration(seconds: 1),
        (i) => i + 1,
      )),
);

//this StreamProvider is pending from the tickerProvider and return the name
final namesProvider = StreamProvider(
  //here we watching the steram provider stream
  (ref) => ref.watch(tickerProvider.stream).map(
        //this count is the tickerProvider i hover over map and see Function(int) so every 1 second we change the i and in this provider we watching its stream so we changes the names as well
        (count) => names.getRange(0, count),
      ),
);

class MyHomePage4 extends ConsumerWidget {
  const MyHomePage4({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch the namesProvider because it always provides different values due to the tickerProvider
    final names = ref.watch(namesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamProvider'),
      ),
      body: names.when(
        data: (names) {
          return ListView.builder(
            itemCount: names.length,
            itemBuilder: (ctx, i) {
              return ListTile(
                title: Text(names.elementAt(i)),
              );
            },
          );
        },
        error: (error, stackTrace) =>
            //there will be an error if all of the names are written into the screen
            const Text('Reached the end of the list!'),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
