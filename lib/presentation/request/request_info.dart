import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/data/sources/firebase_firestore_services.dart';
import 'package:travelbuddy/presentation/auth/cubit/user_cubit.dart';
import 'package:travelbuddy/presentation/landing/cubit/complete_requests_cubit.dart';
import 'package:travelbuddy/presentation/landing/cubit/delivery_requests_dart_cubit.dart';
import 'package:travelbuddy/service_locator.dart';

class RequestInfoPage extends StatelessWidget {
  final DeliveryRequest request;

  const RequestInfoPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Details'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoCard(
                title: 'Item Details',
                child: ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(request.itemName),
                  subtitle: Text('Reward: ${request.rewardPoints} points'),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Pickup Location',
                child: ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: const Text('From'),
                  subtitle: Text(request.pickupAddress),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Drop-off Location',
                child: ListTile(
                  leading: const Icon(Icons.pin_drop_outlined),
                  title: const Text('To'),
                  subtitle: Text(request.dropOffAddress),
                ),
              ),
              const SizedBox(height: 16),
              _buildInfoCard(
                title: 'Delivery Information',
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Time Frame'),
                      subtitle: Text(request.deliveryTimeFrame),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('Status'),
                      subtitle: Text(request.status),
                      trailing: _buildStatusChip(request.status),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (request.status == 'pending' &&
                  request.createdBy !=
                      sl<FirebaseAuthServices>().currentUser!.email)
                _buildAcceptButton(context, request),
              if (request.status == 'accepted' &&
                  request.createdBy ==
                      sl<FirebaseAuthServices>().currentUser!.email)
                _buildCompleteButton(context, request)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required Widget child}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    switch (status.toLowerCase()) {
      case 'pending':
        backgroundColor = Colors.orange;
        break;
      case 'accepted':
        backgroundColor = Colors.green;
        break;
      case 'completed':
        backgroundColor = Colors.blue;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: backgroundColor,
    );
  }
}

Widget _buildAcceptButton(BuildContext context, DeliveryRequest request) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        print(request.id);
        print(sl<FirebaseAuthServices>().currentUser!.email);
        var result = await sl<FirebaseFirestoreServices>()
            .updateDeliveryRequest(id: request.id, data: {
          'status': 'accepted',
          'assignedTo': sl<FirebaseAuthServices>().currentUser!.email
        });
        print(result);
        context.read<DeliveryRequestsDartCubit>().getDeliveryRequests();
        Navigator.of(context).pop();
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Accept Delivery'),
    ),
  );
}

Widget _buildCompleteButton(BuildContext context, DeliveryRequest request) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () async {
        var deliveryUser =
            await sl<FirebaseFirestoreServices>().getUser(request.assignedTo);
        sl<FirebaseFirestoreServices>()
            .updateDeliveryRequest(id: request.id, data: {
          'status': 'completed',
        });
        sl<FirebaseFirestoreServices>()
            .updateUser(id: deliveryUser!.uid, data: {
          'rewardPoints': deliveryUser.rewardPoints + request.rewardPoints,
          'completedDeliveries': deliveryUser.completedDeliveries + 1
        });
        if (context.mounted) {
          context.read<DeliveryRequestsDartCubit>().getDeliveryRequests();
          context.read<CompleteRequestsCubit>().getCompleteRequests(
              sl<FirebaseAuthServices>().currentUser!.email!);
          context
              .read<UserCubit>()
              .getUser(sl<FirebaseAuthServices>().currentUser!.email!);
          Navigator.of(context).pop();
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Complete Delivery'),
    ),
  );
}
