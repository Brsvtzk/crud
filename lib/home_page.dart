import 'package:crud/banco_de_dados.dart';
import 'package:crud/pessoa.dart';
import 'package:crud/pessoa_detalhe.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BancoDeDados db = BancoDeDados();

  List<Pessoa> pessoas;

  @override
  void initState() {
    updateView();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastros'),
      ),
      body: ListView.builder(
          itemCount: this.pessoas?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Row(
                  children: [
                    Text(this.pessoas[index].nome),
                    IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          abrirPessoaDetalhe(this.pessoas[index]);
                        }),
                    IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deletarPessoa(this.pessoas[index]);
                        })
                  ],
                ),
                Row(
                  children: [
                    Text(this.pessoas[index].email),
                  ],
                )
              ],
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Novo registro',
        onPressed: () async {
          bool response = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PessoaDetalhes(Pessoa(null, '', '')),
            ),
          );
          if (response == true) {
            updateView();
          }
        },
      ),
    );
  }

  abrirPessoaDetalhe(Pessoa p) async {
    bool response = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PessoaDetalhes(p)));
    if (response == true) {
      updateView();
    }
  }

  updateView() {
    db.listar().then((listaPessoa) {
      print(listaPessoa.length);
      setState(() {
        this.pessoas = listaPessoa;
      });
    });
  }

  deletarPessoa(Pessoa p) {
    AlertDialog dialog = AlertDialog(
      title: Text('Cadastros'),
      content: Text('Confirmar exclusão?'),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Sim'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text('Não'),
        )
      ],
    );
    showDialog(context: context, builder: (_) => dialog).then(
      (resposta) {
        if (resposta == true) {
          db.remover(p).then((value) => updateView());
        }
      },
    );
  }
}
