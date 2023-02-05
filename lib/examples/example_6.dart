import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//example6
//statenotifierprovider like example 2 just we see more details
//build a simple filter + a list of movie + favorite manager

//a simple immutable Film class with data
@immutable
class Film {
  final String id;
  final String title;
  final String description;
  final bool isFavorite;

  const Film({
    required this.id,
    required this.title,
    required this.description,
    required this.isFavorite,
  });
//[] dont need to set like example 5 its positional arg means we can set a default value if its null
  Film copy({required bool isFavorite}) => Film(
        id: id,
        title: title,
        description: description,
        isFavorite: isFavorite,
      );

  @override
  String toString() =>
      'Film(id: $id, title: $title, description: $description, isFavorite: $isFavorite)';

//manage if something is equal
  @override
  bool operator ==(covariant Film other) =>
      id == other.id && isFavorite == other.isFavorite;

//create hash code for our object
  @override
  int get hasCode => Object.hashAll([id, isFavorite]);
}

//dummy list of film
const allFilms = [
  Film(
    id: '1',
    title: 'The Shawshank Redemption',
    description: 'Description for The Shawshank Redemption',
    isFavorite: false,
  ),
  Film(
    id: '2',
    title: 'The Godfather',
    description: 'Description for The Godfather',
    isFavorite: false,
  ),
  Film(
    id: '3',
    title: 'The Godfather: Part II',
    description: 'Description for The Godfather: Part II',
    isFavorite: false,
  ),
  Film(
    id: '4',
    title: 'The Dark Knight',
    description: 'Description for The Dark Knight',
    isFavorite: false,
  ),
];

//this notifier only decide if a film is favorite or not and change it if the user change it
//has state
class FilmsNotifier extends StateNotifier<List<Film>> {
  //at the begining it gets all the films from constructor
  FilmsNotifier() : super(allFilms);

  void update(Film film, bool isFavorite) {
    //the state is = to the List of films
    state = state
        //thisfilms = one of the element of allFilms because the state = allFilms
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }
}

enum FavoriteStatus {
  all,
  favorite,
  notFavorite,
}

//status provider
//has state
//set with state, notifier
final favoriteStatusProvider = StateProvider<FavoriteStatus>(
  (_) => FavoriteStatus.all,
);

//all films provider
//always alive provider
//set with notifier
final allFilmsProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (_) => FilmsNotifier(),
);

//just the favorite films
//always alive provider
final favoriteFilmsProvider = Provider<Iterable<Film>>(
  //the value is pending on the allFilmsProvider
  (ref) => ref.watch(allFilmsProvider).where((film) => film.isFavorite),
);

//just the not favorite films
//always alive provider
final notFavoriteFilmsProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(allFilmsProvider).where((film) => !film.isFavorite),
);

//home
class MyHomePage6 extends ConsumerWidget {
  const MyHomePage6({super.key});
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed StateNotifierProvider'),
      ),
      body: Column(
        children: [
          const FilterWidget(),
          Consumer(
            builder: (ctx, ref, ch) {
              final filter = ref.watch(favoriteStatusProvider);

              switch (filter) {
                case FavoriteStatus.all:
                  return FilmsWidget(provider: allFilmsProvider);
                case FavoriteStatus.favorite:
                  return FilmsWidget(provider: favoriteFilmsProvider);
                case FavoriteStatus.notFavorite:
                  return FilmsWidget(provider: notFavoriteFilmsProvider);
              }
            },
          ),
        ],
      ),
    );
  }
}

//displayed films -- list of all films
class FilmsWidget extends ConsumerWidget {
  //this will enaple to switch between providers and so the ui depend on something
  final AlwaysAliveProviderBase<Iterable<Film>> provider;

  const FilmsWidget({required this.provider, Key? key}) : super(key: key);

  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
      child: ListView.builder(
          itemCount: films.length,
          itemBuilder: (ctx, i) {
            final film = films.elementAt(i);
            final favoriteIcon = film.isFavorite
                ? const Icon(Icons.favorite)
                : const Icon(Icons.favorite_border);

            return ListTile(
              title: Text(film.title),
              subtitle: Text(film.description),
              trailing: IconButton(
                icon: favoriteIcon,
                onPressed: () {
                  final isFavorite = !film.isFavorite;
                  //we need to set this exact provider because it can handle the changes the favoriteFilms and the notFavoriteFilms depend from the allFilms
                  //these two are simple Providers so u can only change what iit display if its depend on a provider that can change like StateNotifierProvider, StateProvider, ChangeNOtifierProvider etc...
                  //update the stateNOtifierProvider value
                  ref.read(allFilmsProvider.notifier).update(film, isFavorite);
                },
              ),
            );
          }),
    );
  }
}

//this is the filter
class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (ctx, ref, ch) {
      return DropdownButton(
        //get the currently selected filter
        value: ref.watch(favoriteStatusProvider),
        items: FavoriteStatus.values
            .map(
              (e) => DropdownMenuItem(
                value: e,

                //enum look like FavoriteStatus.all , FavoriteStatus.favorite etc.
                child: Text(e.toString().split('.').last),
              ),
            )
            .toList(),
        onChanged: (val) {
          //update the StateProvider value
          ref.read(favoriteStatusProvider.notifier).state = val!;
        },
      );
    });
  }
}
