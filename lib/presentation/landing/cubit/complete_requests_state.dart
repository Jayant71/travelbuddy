part of 'complete_requests_cubit.dart';

@immutable
sealed class CompleteRequestsState {}

final class CompleteRequestsInitial extends CompleteRequestsState {}

final class CompleteRequestsLoading extends CompleteRequestsState {}

final class CompleteRequestsSuccess extends CompleteRequestsState {
  final List<DeliveryRequest> completeRequests;

  CompleteRequestsSuccess(this.completeRequests);
}

final class CompleteRequestsFailed extends CompleteRequestsState {
  final String message;

  CompleteRequestsFailed(this.message);
}
