import 'package:crud/banco_de_dados.dart';
import 'package:crud/pessoa.dart';
import 'package:flutter/material.dart';

class PessoaDetalhes extends StatefulWidget {
  Pessoa pessoa;

  PessoaDetalhes(this.pessoa);

  @override
  _PessoaDetalhesState createState() => _PessoaDetalhesState(this.pessoa);
}

class _PessoaDetalhesState extends State<PessoaDetalhes> {
  TextEditingController nomeCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  BancoDeDados db = BancoDeDados();

  Pessoa pessoa;

  _PessoaDetalhesState(this.pessoa);

  @override
  Widget build(BuildContext context) {
    nomeCtrl.text = this.pessoa.nome;

    emailCtrl.text = this.pessoa.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: this.nomeCtrl,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextField(
                controller: this.emailCtrl,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              RaisedButton(
                  child: Text("Salvar"),
                  onPressed: () {
                    this.gravar();
                  })
            ],
          )),
    );
  }

  void gravar() {
    this.pessoa.nome = nomeCtrl.text;
    this.pessoa.email = emailCtrl.text;
    this.db.gravar(this.pessoa).then((value) {
      AlertDialog dialog = AlertDialog(
        title: Text('Cadastros'),
        content: Text('Cadastro atualizado'),
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Ok'))
        ],
      );

      showDialog(context: context, builder: (_) => dialog).then(
        (value) => Navigator.of(context).pop(true),
      );

      //Navigator.of(context).pop(true);
    });
  }
}
