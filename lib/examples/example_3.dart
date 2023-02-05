import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//the third example
//there are 2 providers
//there are cities and provide its weather for the selected city

//a couple hardcoded city enum
enum City {
  stockholm,
  paris,
  tokyo,
}

/*Map<City, String> city = {
  City.stockholm: '❄️',
  City.paris: '🌧️',
  City.tokyo: '🍃',
};*/

//A future function that returns a WeatherEmoji
//the typedef is for to understand what the function will exactly return
//windows + . to open emoji keyboard
typedef WeatherEmoji = String;
Future<WeatherEmoji> getWeather(City city) {
  //future.delayed represent an api call
  //a simple enum Map
  return Future.delayed(
      const Duration(seconds: 1),
      () => {
            City.stockholm: '❄️',
            City.paris: '🌧️',
            City.tokyo: '🍃',
          }[city]!
      //'🔥', //ha az adott city ben nincs megadva egy város emoji a akor tűzet mutat
      );
}

//State provider its like a Provider but it has a state which can change
//hold a state which has a state that can change
//will be changed by the ui
//read because wee need to know its state and set the state
//watch beacuse we need to decide which city we choose
//?DIfference between StateProvider = simply u can set its value and StateNotifierProvider = class which has function that u can call to change state need a StateNotifierProvider
final currentCityProvider = StateProvider<City?>(
  //ui writes to this and read from this
  (ref) => null,
);

const unknownWeatherEmoji = '🤷';

//this future provider will listen to changes in the map enum and provide its value to the currentCityProvider
//it returns a WeatherEmoji
//this provider depend on the StateProvider state and return the correct emoji for the state = city
final weatherProvider = FutureProvider<WeatherEmoji>(
  (ref) {
    //ui reads this
    //watch the StateProvider because we want to return the correct emoji dependig on the user choice
    final city = ref.watch(currentCityProvider);
    if (city != null) {
      //this function return the emoji for the given city
      return getWeather(city);
    } else {
      return unknownWeatherEmoji;
    }
  },
);

class MyHomePage3 extends ConsumerWidget {
  const MyHomePage3({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //this is an AsyncValue which means it has some function like .when()-- various state like data,loading,error
    //we watch it because it will change depending on which city is selected
    final currentWeather = ref.watch(weatherProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Multiple provider, FutureProvider, StateProvider'),
      ),
      body: Column(
        children: [
          currentWeather.when(
            data: (data) => Text(
              data,
              style: const TextStyle(
                fontSize: 30,
              ),
            ),
            error: (_, __) => const Text('Error'),
            loading: () => const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: City.values.length,
              itemBuilder: (ctx, i) {
                final city = City.values[i];
                //we watch the StateProvider here because we want to know which cities did the user select
                final isSelected = city == ref.watch(currentCityProvider);

                return ListTile(
                  title: Text(
                    city.toString(),
                  ),
                  trailing: isSelected ? const Icon(Icons.check) : null,
                  onTap: () {
                    //we set the value of the StateProvider state, we dont want to watch here
                    ref.read(currentCityProvider.notifier).state = city;
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
