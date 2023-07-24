import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

import '../models/client.dart';

class ClientListItem extends StatelessWidget {
  const ClientListItem({
    Key? key,
    required this.client,
    required this.onDelete,
  }) : super(key: key);

  final Client client;
  final Function(Client) onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Colors.grey[200],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(client.dateTime),
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                client.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actionExtentRatio: 0.20,
        actionPane: const SlidableStrechActionPane(),
        secondaryActions: [
          IconSlideAction(
            color: Colors.red,
            icon: Icons.delete,
            caption: 'Excluir!',
            onTap: () {
              onDelete(client);
            },
          ),
          IconSlideAction(
            color: Colors.yellow,
            icon: Icons.edit,
            caption: 'Editar!',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
