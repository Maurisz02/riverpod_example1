import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; //riverpod + flutter hooks package 2 in 1

//example 2
//StateNotifierProvider state is like a stream, you can set the value of the state and you can read it = notify the state changes

//this is an extra operaor ehich can decide handle the situation when a number is null
extension OptionalInfixAdditional<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this; //this is the left vale like shadow + other
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

void testInt() {
  final int? int1 = 1;
  final int int2 = 1;
  //you cant add the two int because int1 can be unset or null so we have to declare it like (int1 ?? 0)
  // + is an infix operator
  //if here is an extra operator wher we define the situation if one of the int is null then it knows what to do
  //example int1 = null and int2 = 1 the result is 1
  final result = int1 + int2;
}

//ez a része mehet külön provider fájlba és ott egy counter.dart a
//this is what StateNotifierProvider will provide
class Counter extends StateNotifier<int?> {
  //the begin value is null
  Counter() : super(null);

//state is equal 1 if its null if it has value wich is not null it equals state + 1
  void increment() => state = state == null ? 1 : state + 1;

//get the state value
//we dont use here
  int? get value => state;

//get no ()
  int? get value2 {
    return state;
  }
}

//this is in the exact widget where you want to use
final counterProvider = StateNotifierProvider<Counter, int?>(
  //<This is the name of the StateNotifier which u want to provie, this is its value type>
  (ref) => Counter(),
);

class MyHomePage2 extends ConsumerWidget {
  const MyHomePage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //if here we write final counter = ref.watch(counterProvider) the whole Scaffold will rebuild any time the value change == BAD
    //watc inside a consumer it watch the changes and
    //read can be anywhere and it set the data
    return Scaffold(
      appBar: AppBar(
        title: const Text('StateNotifier - (StateNotifierProvider)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // with Consumer we can tell the program which Widget we wanna rebuild because its value changed
            //therefore the other widgets dont get rebuild so the performance will be good
            Consumer(
              //builder: (ctx, ref, ch) => Text(''),
              builder: (ctx, ref, ch) {
                final counter = ref.watch(counterProvider);

                return counter == null
                    ? const Text('Press the button ')
                    : Text('$counter');
              },
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                //use ref.read(counterProvider.notifier).increment whithout ()

                //you can reach your provider by using ref
                //ref read get the current snapshot of the value
                //with the providername.notifier you can call its function
                ref.read(counterProvider.notifier).increment();
              },
              child: const Text(
                'Increment',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
