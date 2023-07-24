import 'package:flutter/material.dart';
import 'package:projetohow/respositories/client_repository.dart';

import '../models/client.dart';
import '../widgets/client_list_item.dart';

class ClientListPage extends StatefulWidget {
  ClientListPage({super.key});

  @override
  State<ClientListPage> createState() => _ClientListPageState();
}

class _ClientListPageState extends State<ClientListPage> {
  final TextEditingController clientController = TextEditingController();
  final ClientRepository clientRepository = ClientRepository();

  List<Client> clients = [];

  Client? deletedClient;
  int? deletedClientPos;

  @override
  void initState() {
    super.initState();

    clientRepository.getClientList().then((value) {
      setState(() {
        clients = value;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: clientController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'adicione um cliente',
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          String text = clientController.text;
                          setState(() {
                            Client newClient = Client(
                              title: text,
                              dateTime: DateTime.now(),
                            );
                            clients.add(newClient);
                          });
                          clientController.clear();
                          clientRepository.saveClientList(clients);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(16),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 25,
                        )
                    )
                  ],
                ),
                SizedBox(height: 16,),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Client client in clients)
                        ClientListItem(
                          client: client,
                          onDelete: onDelete,
                        ),
                    ]
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${clients.length} cliente(s) cadastrado(s) !',
                      ),
                    ),
                    SizedBox(width: 8,),
                    ElevatedButton(
                        onPressed: showDeleteClientsConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(14),
                        ),
                        child: Text('Limpar!'))

                  ],
                )
              ],
            ),
          ),
       ),
      ),
    );
  }

  void onDelete(Client client) {
    deletedClient = client;
    deletedClientPos = clients.indexOf(client);
    setState(() {
      clients.remove(client);
    });
    clientRepository.saveClientList(clients);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Cliente ${client.title} foi excluído!'),
        action: SnackBarAction(
          label: 'Desfazer?',
          onPressed: () {
            setState(() {
              clients.insert(deletedClientPos!, deletedClient!);
            });
            clientRepository.saveClientList(clients);
          },
        ),
      ),
    );
  }

  void showDeleteClientsConfirmationDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text('Limpar Todos os Campos?'),
      content: Text('Tem certeza que deseja apagar todos os clientes?'),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar')
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllClients();
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: Text('Limpar Tudo!'),
        ),
      ],
    ),
    );
  }
    void deleteAllClients() {
    setState(() {
      clients.clear();
    });
    clientRepository.saveClientList(clients);
  }

}
