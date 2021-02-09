class Cidade {
  int idCidade;
  String cidade;
  String cep;

  Cidade(this.idCidade, this.cidade, this.cep);

  Map<String, dynamic> toMap() {
    return {
      'idCidade': this.idCidade,
      'cidade': this.cidade,
      'cep': this.cep,
    };
  }

  static fromMap(dados) {
    return Cidade(
      dados['idCidade'],
      dados['cidade'],
      dados['cep'],
    );
  }
}
