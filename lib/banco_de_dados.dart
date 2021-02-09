import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:crud/cidade.dart';

class BancoDeDados {
  String CREATE_TABLE =
      'create table cidade (idCidade integer primary key autoincrement not null, cidade varchar(32), cep varchar(32))';

  String tabela = 'cidade';

  Future<Database> abrirConexao() async {
    return openDatabase(
      join(await getDatabasesPath(), 'bd_cidade.db'),
      onCreate: (db, version) {
        return db.execute(
          this.CREATE_TABLE,
        );
      },
      version: 1,
    );
  }

  Future gravar(Cidade p) async {
    Database db = await this.abrirConexao();
    if (p.idCidade == null) {
      return db.insert(this.tabela, p.toMap());
    } else {
      return db.update(
        this.tabela,
        p.toMap(),
        where: 'idCidade = ?',
        whereArgs: [p.idCidade],
      );
    }
  }

  Future remover(Cidade p) async {
    Database db = await this.abrirConexao();
    return db.delete(
      this.tabela,
      where: 'idCidade = ?',
      whereArgs: [p.idCidade],
    );
  }

  Future<List<Cidade>> listar() async {
    Database db = await this.abrirConexao();
    List<Map<String, dynamic>> cidade = await db.query(this.tabela);
    return List.generate(
      cidade.length,
      (index) => Cidade.fromMap(cidade[index]),
    );
  }
}
