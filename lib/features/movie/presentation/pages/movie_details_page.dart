// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constant/strings.dart';
import '../../../../core/utils/enum.dart';
import '../../../../core/utils/helper.dart';
import '../../../favorite/presentation/bloc/favorite/favorite_bloc.dart';
import '../bloc/movie_details/movie_details_bloc.dart';
import '../widgets/movie_details_widget.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  @override
  void initState() {
    context
        .read<MovieDetailsBloc>()
        .add(GetMovieDetailsEvent(movieId: widget.movieId));
    context
        .read<MovieDetailsBloc>()
        .add(CheckMovieISFavoriteOrNotEvent(movieId: widget.movieId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }
}

_bodyWidget() {
  return BlocConsumer<MovieDetailsBloc, MovieDetailsState>(
    listener: (context, state) {
      if (state.actionStatus == BlocStates.error) {
        Helper.showSnackBar(context, state.localFavoriteFailure);
      }

      if (state.actionStatus == BlocStates.success) {
        if (state.snackMessage == 'added') {
          Helper.showSnackBar(context, Strings.movieAdded);
          context
              .read<MovieDetailsBloc>()
              .add(SetMovieDetailsStatusToDefaultEvent());
          context.read<FavoriteBloc>().add(UpdateFavoriteMoviesEvent());
        }
        if (state.snackMessage == 'removed') {
          Helper.showSnackBar(context, Strings.movieRemoved);
          context
              .read<MovieDetailsBloc>()
              .add(SetMovieDetailsStatusToDefaultEvent());
          context.read<FavoriteBloc>().add(UpdateFavoriteMoviesEvent());
        }
      }
    },
    builder: (context, state) {
      switch (state.status) {
        case BlocStates.loading:
          return const Center(
            child: CircularProgressIndicator(),
          );
        case BlocStates.success:
          return MovieDetailsWidget(
            movieDetails: state.movieDetails,
            isFavorite: state.isFavorite,
          );
        case BlocStates.error:
          return Center(
            child: Text(state.failure),
          );
        default:
          return const SizedBox();
      }
    },
  );
}
