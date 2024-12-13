part of 'user_cubit.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserSuccess extends UserState {
  final User user;

  UserSuccess(this.user);
}

final class UserFailed extends UserState {
  final String message;

  UserFailed(this.message);
}
