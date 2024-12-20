// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/domain/entities/movie_details_entity.dart';
import '../../../../../core/domain/usecase/delete_favorite_movie_usecase.dart';
import '../../../../../core/domain/usecase/usecase.dart';
import '../../../../../core/utils/enum.dart';
import '../../../domain/usecases/get_all_favorite_movies_usecase.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final GetAllFavoriteMoviesUseCase getAllFavoriteMoviesUseCase;
  final DeleteFavoriteMovieUseCase deleteFavoriteMovieUseCase;
  FavoriteBloc(
    this.getAllFavoriteMoviesUseCase,
    this.deleteFavoriteMovieUseCase,
  ) : super(const FavoriteState()) {
    on<GetAllFavoriteMoviesEvent>(onGetAllFavoriteMoviesEvent);
    on<DeleteFavoriteMovieEvent>(onDeleteFavoriteMovieEvent);
    on<SetFavoriteToDefault>(onSetFavoriteToDefault);
    on<UpdateFavoriteMoviesEvent>(onUpdateFavoriteMoviesEvent);
  }

  FutureOr<void> onGetAllFavoriteMoviesEvent(
    GetAllFavoriteMoviesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    emit(state.copyWith(favoriteStatus: BlocStates.loading));

    final result = await getAllFavoriteMoviesUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          favoriteStatus: BlocStates.error,
          favoriteFailure: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          favoriteStatus: BlocStates.success,
          favoriteMoviesList: r,
        ),
      ),
    );
  }

  FutureOr<void> onUpdateFavoriteMoviesEvent(
    UpdateFavoriteMoviesEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await getAllFavoriteMoviesUseCase.call(NoParams());
    result.fold(
      (l) => emit(
        state.copyWith(
          favoriteStatus: BlocStates.error,
          favoriteFailure: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          favoriteStatus: BlocStates.success,
          favoriteMoviesList: r,
        ),
      ),
    );
  }

  FutureOr<void> onDeleteFavoriteMovieEvent(
    DeleteFavoriteMovieEvent event,
    Emitter<FavoriteState> emit,
  ) async {
    final result = await deleteFavoriteMovieUseCase.call(event.movieId);

    result.fold(
      (l) => emit(
        state.copyWith(
          favoriteActionStatus: BlocStates.error,
          favoriteFailure: l.errorMessage,
        ),
      ),
      (r) => emit(
        state.copyWith(
          favoriteActionStatus: BlocStates.success,
          id: event.movieId,
          favoriteMessage: 'removed',
        ),
      ),
    );
  }

  FutureOr<void> onSetFavoriteToDefault(
    SetFavoriteToDefault event,
    Emitter<FavoriteState> emit,
  ) {
    emit(
      state.copyWith(
        favoriteActionStatus: BlocStates.initial,
        favoriteMessage: '',
      ),
    );
  }
}
