import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod/riverpod.dart';

part 'model.freezed.dart';

@freezed
class Film with _$Film {
  const Film._();
  const factory Film({
    required int id,
    required String name,
    required String description,
    required bool isFavorite,
  }) = _Film;

  Film copy({required bool isFavorite}) => Film(
      id: id, name: name, description: description, isFavorite: isFavorite);
}

final allFilms = [
  const Film(
      id: 1, name: 'film1', description: 'film1film1film1', isFavorite: false),
  const Film(
      id: 2, name: 'film2', description: 'film2film2film2', isFavorite: false),
  const Film(
      id: 3, name: 'film3', description: 'film3film3film3', isFavorite: false),
  const Film(
      id: 4, name: 'film4', description: 'film4film4film4', isFavorite: false),
];

class FilmsNotifier extends StateNotifier<List<Film>> {
  FilmsNotifier() : super(allFilms);

// to update every were i need to use state
  void updateFilm(Film film, bool isFavorite) {
    state = state
        .map((thisFilm) => thisFilm.id == film.id
            ? thisFilm.copy(isFavorite: isFavorite)
            : thisFilm)
        .toList();
  }
}

enum FavoriteStates {
  all,
  favorite,
  notFavorite,
}

// to change it by button
final favoriteStateProvider = StateProvider<FavoriteStates>(
  (ref) => FavoriteStates.all,
);

final filmsNotifierProvider = StateNotifierProvider<FilmsNotifier, List<Film>>(
  (ref) => FilmsNotifier(),
);

final favoriteProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(filmsNotifierProvider).where((film) => film.isFavorite),
);

final notFavoriteProvider = Provider<Iterable<Film>>(
  (ref) => ref.watch(filmsNotifierProvider).where((film) => !film.isFavorite),
);
