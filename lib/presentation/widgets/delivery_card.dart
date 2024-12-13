import 'package:flutter/material.dart';
import 'package:travelbuddy/data/models/delivery_request.dart';
import 'package:travelbuddy/presentation/request/request_info.dart';

class DeliveryCard extends StatelessWidget {
  final DeliveryRequest delivery;

  const DeliveryCard({
    super.key,
    required this.delivery,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return RequestInfoPage(request: delivery);
          }));
        },
        title: Text(
          delivery.itemName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          'Drop Location: ${delivery.dropOffAddress}',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${delivery.rewardPoints} pts',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
