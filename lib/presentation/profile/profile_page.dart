import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelbuddy/data/sources/firebase_auth_services.dart';
import 'package:travelbuddy/presentation/auth/cubit/user_cubit.dart';
import 'package:travelbuddy/service_locator.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            onPressed: () {
              context
                  .read<UserCubit>()
                  .getUser(sl<FirebaseAuthServices>().currentUser!.email!);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserFailed) {
            return Center(child: Text(state.message));
          } else if (state is UserInitial) {
            context
                .read<UserCubit>()
                .getUser(sl<FirebaseAuthServices>().currentUser!.email!);
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserSuccess) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      child: Text(
                        state.user.name[0].toUpperCase(),
                        style: const TextStyle(fontSize: 32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildInfoCard(
                    title: 'Name',
                    value: state.user.name,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Email',
                    value: state.user.email,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Completed Deliveries',
                    value: state.user.completedDeliveries.toString(),
                    icon: Icons.local_shipping,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    title: 'Reward Points',
                    value: state.user.rewardPoints.toString(),
                    icon: Icons.star,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
