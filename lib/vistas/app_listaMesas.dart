import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/vistas/app_registrarMesa.dart';
import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaMesa extends StatefulWidget {
  List<MesaModel> data;

  AppListaMesa(this.data, {Key? key}) : super(key: key);
  @override
  State<AppListaMesa> createState() {
    return _AppListaMesaState();
  }
}

class _AppListaMesaState extends State<AppListaMesa> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Mesas"),
        backgroundColor: Colors.amber,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AppRegistroMesa()));
            },
            icon: FaIcon(FontAwesomeIcons.plus),
            // hoverColor: Colors.black,
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Dos columnas
          mainAxisSpacing: 10, // Espacio vertical entre los elementos
          crossAxisSpacing: 10, // Espacio horizontal entre los elementos
        ),
        itemCount: widget.data.length,
        padding: EdgeInsets.all(20),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // print(data![index]);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Expanded(
                  child: Image(
                    image: AssetImage("assets/mesa.jpg"),
                    fit: BoxFit.fill,
                    // height: 10,
                  ),
                  // child: Image.network(
                  //   data[index]., // URL de la imagen
                  //   fit: BoxFit.cover,
                  // ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.data[index].numeroMesa,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
