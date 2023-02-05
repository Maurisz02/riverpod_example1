import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart'; //riverpod + flutter hooks package 2 in 1
import 'package:firebase_core/firebase_core.dart';

/*import './examples/example_2.dart';
import './examples/example_3.dart';
import './examples/example_4.dart';
import './examples/example_5.dart';
import './examples/example_6.dart';*/

//import './Instagram/state/auth/backend/authenticator.dart';
import './Instagram/state/auth/providers/is_logged_in_provider.dart';
import './Instagram/views/components/loading/loading_screen.dart';
import './Instagram/state/providers/is_loading_provider.dart';
import './Instagram/views/login/login_view.dart';
import 'package:riverpod_example1/Instagram/views/main/main_view.dart';

//import './Instagram/state/auth/models/auth_result.dart';

//Consumer widget is a stateless widget, but u can provide value through the providers

Future<void> main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        indicatorColor: Colors.blueGrey, //when switching inside appbar
      ),
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Consumer(
        builder: (ctx, ref, ch) {
//when you watch you get the value it can be async value, rebuild your widget
//when you read yo may change something in the provider
//when you listen is not going to rebuild the widget, navigate or display loadig screen depend on the provider
          ref.listen<bool>(
            isLoadingProvder,
            (_, isLoading) {
              if (isLoading) {
                //next is is loading
                LoadingScreen.instance().show(context: ctx);
              } else {
                LoadingScreen.instance().hide();
              }
            },
          );

          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            return const MainView();
          } else {
            return const LoginView();
          }
        },
      ),
    );
  }
}

//Insta copy home page Widget when you are logged in
/*
class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MainView'),
      ),
      body: Consumer(
        builder: (ctx, ref, ch) => TextButton(
          onPressed: () async {
            await ref.read(authStateProvider.notifier).logOut();
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}
*/
//examle 1
//Provider
//a global provider, it jst provide a value nothing more
//hold a value which never change
final currentDate = Provider<DateTime>((ref) => DateTime.now());

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //we get the ref but its just a provider so it can provide a value
    final date = ref.watch(currentDate);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider'),
      ),
      body: Center(
        child: Text(date.toIso8601String()),
      ),
    );
  }
}
