import 'package:mysql1/mysql1.dart';

class Configuracion {
  static final instancia = ConnectionSettings(
    host: '34.176.109.9',
    port: 3306,
    user: 'basesql-jugueria-2023',
    password: '123456789.',
    db: 'app-jugueria',
  );
}
