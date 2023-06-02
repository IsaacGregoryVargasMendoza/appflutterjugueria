import 'package:app_jugueria/componentes/app_drawer.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/controladores/adicionalController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppListaAdicional extends StatefulWidget {
  List<AdicionalModel>? data;

  AppListaAdicional({this.data, Key? key}) : super(key: key);
  @override
  State<AppListaAdicional> createState() {
    return AppListaAdicionalState();
  }
}

class AppListaAdicionalState extends State<AppListaAdicional> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lista de adicionales"),
        backgroundColor: Colors.green.shade900,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/registrar-adicional');
            },
            icon: const FaIcon(FontAwesomeIcons.plus),
          ),
        ],
      ),
      drawer: AppMenuDrawer(),
      body: Stack(children: <Widget>[
        ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: widget.data!.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                AdicionalModel adicionalModel = AdicionalModel(
                    id: widget.data![index].id,
                    nombreAdicional: widget.data![index].nombreAdicional,
                    letraAdicional: widget.data![index].letraAdicional,
                    visibleAdicional: widget.data![index].visibleAdicional);
                Navigator.pushNamed(
                  context,
                  '/editar-adicional',
                  arguments: adicionalModel,
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 10, 0, 10),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        // border: BorderDirectional(
                        //   bottom: BorderSide(width: 1),
                        // ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.data![index].nombreAdicional}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                softWrap: true,
                                textAlign: TextAlign.start,
                              ),
                              (widget.data![index].visibleAdicional == 1)
                                  ? Text(
                                      "Letra: ${widget.data![index].letraAdicional} \nVisible: SI",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    )
                                  : Text(
                                      "Letra: ${widget.data![index].letraAdicional} \nVisible: NO",
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                      softWrap: true,
                                      textAlign: TextAlign.start,
                                    )
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  // shadowColor: Colors.red,
                                  primary:
                                      (widget.data![index].visibleAdicional ==
                                              1)
                                          ? Colors.red.shade600
                                          : Colors.green.shade600),
                              onPressed: () async {
                                AdicionalController adicionalCtrll =
                                    AdicionalController();

                                (widget.data![index].visibleAdicional == 1)
                                    ? await adicionalCtrll.hiddenAdicional(
                                        widget.data![index].id!)
                                    : await adicionalCtrll
                                        .showAdicional(widget.data![index].id!);

                                List<AdicionalModel> lista =
                                    await adicionalCtrll.getAdicionales();
                                setState(() {
                                  widget.data = lista;
                                });
                              },
                              child: (widget.data![index].visibleAdicional == 1)
                                  ? const FaIcon(FontAwesomeIcons.eyeSlash)
                                  : const FaIcon(FontAwesomeIcons.eye))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ]),
    );
  }
}
