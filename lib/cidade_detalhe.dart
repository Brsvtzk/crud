import 'package:crud/banco_de_dados.dart';
import 'package:crud/cidade.dart';
import 'package:flutter/material.dart';

class CidadeDetalhes extends StatefulWidget {
  Cidade cidade;

  CidadeDetalhes(this.cidade);

  @override
  _CidadeDetalhesState createState() => _CidadeDetalhesState(this.cidade);
}

class _CidadeDetalhesState extends State<CidadeDetalhes> {
  TextEditingController cidadeCtrl = TextEditingController();

  TextEditingController cepCtrl = TextEditingController();

  BancoDeDados db = BancoDeDados();

  Cidade cidade;

  _CidadeDetalhesState(this.cidade);

  @override
  Widget build(BuildContext context) {
    cidadeCtrl.text = this.cidade.cidade;

    cepCtrl.text = this.cidade.cep;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes'),
      ),
      body: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: this.cidadeCtrl,
                decoration: InputDecoration(labelText: 'Cidade'),
              ),
              TextField(
                controller: this.cepCtrl,
                decoration: InputDecoration(labelText: 'CEP'),
              ),
              RaisedButton(
                  color: Colors.cyan[50],
                  child: Text("Salvar"),
                  onPressed: () {
                    this.gravar();
                  })
            ],
          )),
      backgroundColor: Colors.cyan[100],
    );
  }

  void gravar() {
    this.cidade.cidade = cidadeCtrl.text;
    this.cidade.cep = cepCtrl.text;
    this.db.gravar(this.cidade).then((value) {
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
