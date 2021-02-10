import 'package:crud/banco_de_dados.dart';
import 'package:crud/cidade.dart';
import 'package:crud/cidade_detalhe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double tempDouble = 0.0;
  String tempString = '';
  var controller = TextEditingController();
  var countStr = '';
  var ceu = ' ';
  var respCidade = 'Bem-vindo';
  var respEst = '';
  String url = '';

  BancoDeDados db = BancoDeDados();

  List<Cidade> cidades;

  @override
  void initState() {
    updateView();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        //barra superior com texto
        title: Text(
          'Clima' +
              ' - ' +
              this.respCidade +
              this.respEst +
              ': ' +
              '\n$tempDouble' +
              'ºC, ' +
              this.ceu,
          maxLines: 2,
          textAlign: TextAlign.left,
          textScaleFactor: 1.5,
        ),
      ),
      body: ListView.builder(
          itemCount: this.cidades?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(12),
              color: Colors.cyan[50],
              child: Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(children: [
                      Container(
                        //nome da cidade
                        child: Text(
                          this.cidades[index].cidade,
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                    ]),

                    //cep
                    Row(
                      children: [
                        Container(
                            child: Text(
                          this.cidades[index].cep,
                          style: TextStyle(fontSize: 18),
                        )),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //botão editar
                        Center(
                          child: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                abrirCidadeDetalhe(this.cidades[index]);
                              }),
                        ),

                        //botão excluir
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletarPessoa(this.cidades[index]);
                            }),

                        //botão clima
                        IconButton(
                            icon: Icon(Icons.wb_sunny),
                            onPressed: () {
                              setState(() {
                                respCidade = this.cidades[index].cep;
                              });
                              realizaConsulta(this.respCidade[index]);
                              consultaClima(index);
                            }),

                        //botão consultar clima
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

      //botão flutuante
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Novo registro',
        onPressed: () async {
          bool response = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CidadeDetalhes(Cidade(null, '', '')),
            ),
          );
          if (response == true) {
            updateView();
          }
        },
      ),
      backgroundColor: Colors.cyan[100],
    );
  }

  abrirCidadeDetalhe(Cidade p) async {
    bool response = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => CidadeDetalhes(p)));
    if (response == true) {
      updateView();
    }
  }

  updateView() {
    db.listar().then((listaCidade) {
      print(listaCidade.length);
      setState(() {
        this.cidades = listaCidade;
      });
    });
  }

  deletarPessoa(Cidade p) {
    AlertDialog dialog = AlertDialog(
      title: Text('Cadastros'),
      content: Text('Confirmar exclusão?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text('Sim'),
        ),
        TextButton(
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

  realizaConsulta(respCidade) async {
    String url = 'http://cep.republicavirtual.com.br/web_cep.php?cep=';
    url += this.respCidade;
    url += '&formato=jsonp';

    var resposta = await http.get(url);
    var json = jsonDecode(resposta.body);

    setState(() {
      this.respCidade = json['cidade'];
      this.respEst = ', ' + json['uf'];
    });

    print(this.respCidade + this.respEst);
  }

  consultaClima(index) async {
    //divide String com nome da cidade em mais variáveis
    final tagName = this.cidades[index].cidade;
    final split = tagName.split(' ');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    print(values);

    final value1 = values[0];
    final value2 = values[1];
    final value3 = values[2];
    final value4 = values[3];

    //se o nome tiver mais que duas palavras, corrige a url
    if (value2 == null) {
      this.url = 'http://api.openweathermap.org/data/2.5/weather?q=';
      url += value1;
      url += '&units=metric&lang=pt_br&appid=a4df9586d6404c5d0917ec7f220f9a5a';
    } else if (value2 != null && value3 == null) {
      //se tiver duas palavras
      this.url = 'http://api.openweathermap.org/data/2.5/weather?q=';
      url += value1;
      url += '%20';
      url += value2;
      url += '&units=metric&lang=pt_br&appid=a4df9586d6404c5d0917ec7f220f9a5a';
    } else if (value3 != null) {
      //se tiver tres palavras
      this.url = 'http://api.openweathermap.org/data/2.5/weather?q=';
      url += value1;
      url += '%20';
      url += value2;
      url += '%20';
      url += value3;
      url += '&units=metric&lang=pt_br&appid=a4df9586d6404c5d0917ec7f220f9a5a';
    }

    print(value1);
    print(value2);
    print(value3);
    print(value4);
    print(url);

    //api de clima

    var resposta = await http.get(url);
    if (resposta.statusCode == 200) {
      var parsedJson = jsonDecode(resposta.body);
      print('${parsedJson.runtimeType} : $parsedJson');
      var main = parsedJson['main'];
      this.tempDouble = main['temp'];

      Map<String, dynamic> json = jsonDecode(resposta.body);
      List<dynamic> info = json['weather'];
      this.ceu = info[0]['description'];
      print(this.ceu);

      updateView();
    } else {
      print('Falha na requisição: ${resposta.statusCode}.');
    }
  }
}
