import 'package:crud/banco_de_dados.dart';
import 'package:crud/cidade.dart';
import 'package:crud/cidade_detalhe.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crud/api_clima.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController();
  var countStr = '';
  var ceu = ' ';
  double temp = 0.0;
  var respCidade = 'Bem-vindo';
  var respEst = '';
  String url = '';
  final main = Main();

  BancoDeDados db = BancoDeDados();

  List<Cidade> cidades;

  @override
  void initState() {
    updateView();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //barra superior com texto
        title: Text('Clima' +
            ' - ' +
            this.respCidade +
            this.respEst +
            ': ' +
            this.temp +
            'º ,' +
            this.ceu),
      ),
      body: ListView.builder(
          itemCount: this.cidades?.length ?? 0,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                margin: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          //nome da cidade
                          child: Text(
                            this.cidades[index].cidade,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),

                        //botão editar
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              abrirCidadeDetalhe(this.cidades[index]);
                            }),

                        //botão excluir
                        IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deletarPessoa(this.cidades[index]);
                            }),

                        //botão pesquisar
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
                        IconButton(
                            icon: Icon(Icons.star),
                            onPressed: () {
                              main.buscaTemp();
                            }),
                      ],
                    ),

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
    if (value1 != null) {
      this.url = 'http://api.openweathermap.org/data/2.5/weather?q=';
      url += value1;
      url += '&units=metric&lang=pt_br&appid=a4df9586d6404c5d0917ec7f220f9a5a';
    } else if (value2 != null) {
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
      this.temp = main['temp'];
      print(temp.runtimeType);
      print('$temp');

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
