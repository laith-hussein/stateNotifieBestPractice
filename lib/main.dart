import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier_best_practice/model.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('stateNoifire')),
      body: Column(children: [
        const FilterList(),
        Consumer(builder: (context, ref, child) {
          final filter = ref.watch(favoriteStateProvider);
          switch (filter) {
            case FavoriteStates.all:
              return FilmsList(provider: filmsNotifierProvider);

            case FavoriteStates.favorite:
              return FilmsList(provider: favoriteProvider);
            case FavoriteStates.notFavorite:
              return FilmsList(provider: notFavoriteProvider);
          }
        })
      ]),
    );
  }
}

class FilmsList extends ConsumerWidget {
  final AlwaysAliveProviderBase<Iterable<Film>> provider;

  const FilmsList({required this.provider, super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final films = ref.watch(provider);
    return Expanded(
        child: ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              final film = films.elementAt(index);
              final favoriteIcon = film.isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border);
              return ListTile(
                title: Text(film.name),
                subtitle: Text(film.description),
                trailing: IconButton(
                  onPressed: () {
                    final isFav = !film.isFavorite;
                    ref
                        .read(filmsNotifierProvider.notifier)
                        .updateFilm(film, isFav);
                  },
                  icon: favoriteIcon,
                ),
              );
            }));
  }
}

class FilterList extends StatelessWidget {
  const FilterList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: ((context, ref, child) {
      return DropdownButton(
        value: ref.watch(favoriteStateProvider),
        items: FavoriteStates.values
            .map((fs) => DropdownMenuItem(
                value: fs, child: Text(fs.toString().split('.').last)))
            .toList(),
        onChanged: (value) {
          ref.watch(favoriteStateProvider.notifier).state = value!;
        },
      );
    }));
  }
}
