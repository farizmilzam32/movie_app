// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/repositories/movie_repository.dart';
import '../data_sources/remote/movie_remote_data_source.dart';
import '../models/movie_model.dart';

class MovieRepositoryImpl implements MovieRepository {
  MovieRemoteDataSource movieRemoteDataSource;
  MovieRepositoryImpl(
    this.movieRemoteDataSource,
  );

  @override
  Future<Either<Failure, List<MovieModel>>> getUpComingMovies() async {
    try {
      final result = await movieRemoteDataSource.getUpComingMovies();
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(errorMessage: failure.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getPopularMovies(int page) async {
    try {
      final result = await movieRemoteDataSource.getPopularMovies(page);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(errorMessage: failure.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getTrendingMovies(int page) async {
    try {
      final result = await movieRemoteDataSource.getTrendingMovies(page);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(errorMessage: failure.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMovieByGenre(int genreId) async {
    try {
      final result = await movieRemoteDataSource.getMoviesByGenre(genreId);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(errorMessage: failure.errorMessage));
    }
  }

  @override
  Future<Either<Failure, List<MovieModel>>> getMoviesByQuery(
      String query) async {
    try {
      final result = await movieRemoteDataSource.getMoviesByQuery(query);
      return Right(result);
    } on ServerException catch (failure) {
      return Left(ServerFailure(errorMessage: failure.errorMessage));
    }
  }
}
