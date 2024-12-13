part of 'delivery_requests_dart_cubit.dart';

@immutable
sealed class DeliveryRequestsDartState {}

final class DeliveryRequestsDartInitial extends DeliveryRequestsDartState {}

final class DeliveryRequestsDartLoading extends DeliveryRequestsDartState {}

final class DeliveryRequestsDartSuccess extends DeliveryRequestsDartState {
  final List<DeliveryRequest> deliveryRequests;

  DeliveryRequestsDartSuccess(this.deliveryRequests);
}

final class DeliveryRequestsDartFailed extends DeliveryRequestsDartState {
  final String message;

  DeliveryRequestsDartFailed(this.message);
}
