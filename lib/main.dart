import 'package:app_jugueria/componentes/info_global.dart';
import 'package:app_jugueria/controladores/clienteController.dart';
import 'package:app_jugueria/controladores/administradorController.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/manualModel.dart';
import 'package:app_jugueria/modelos/usuarioModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:app_jugueria/vistas/app_listaManual.dart';
import 'package:app_jugueria/vistas/app_manualCliente.dart';
import 'package:app_jugueria/vistas/app_registrarManual.dart';
import 'package:app_jugueria/vistas/app_seleccionarMesa.dart';
import 'package:app_jugueria/vistas/app_mensajeConfirmacion.dart';
import 'package:app_jugueria/vistas/app_confirmarPedido.dart';
import 'package:app_jugueria/vistas/app_asignarAdicionales.dart';
import 'package:app_jugueria/vistas/app_listaAdicionales.dart';
import 'package:app_jugueria/vistas/app_listaPedidos.dart';
import 'package:app_jugueria/vistas/app_dashboardVentas.dart';
import 'package:app_jugueria/vistas/app_seleccionarAdicionales.dart';
import 'package:app_jugueria/vistas/app_seleccionarProducto.dart';
import 'package:app_jugueria/vistas/app_liberarMesa.dart';
import 'package:flutter/material.dart';
import 'package:app_jugueria/componentes/app_buttons.dart';
import 'package:app_jugueria/vistas/app_login.dart';
import 'package:app_jugueria/vistas/app_loginClientes.dart';
import 'package:app_jugueria/vistas/app_menu.dart';
import 'package:app_jugueria/vistas/app_listaCategorias.dart';
import 'package:app_jugueria/vistas/app_listaProductos.dart';
import 'package:app_jugueria/vistas/app_listaMesas.dart';
import 'package:app_jugueria/vistas/app_listaClientes.dart';
import 'package:app_jugueria/vistas/app_listaAdministradores.dart';
import 'package:app_jugueria/vistas/app_registrarAdicionales.dart';
import 'package:app_jugueria/vistas/app_registrarCategorias.dart';
import 'package:app_jugueria/vistas/app_registrarProductos.dart';
import 'package:app_jugueria/vistas/app_registrarMesa.dart';
import 'package:app_jugueria/vistas/app_registrarClientes.dart';
import 'package:app_jugueria/vistas/app_registrarClientesLogin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    //home: MyApp(),
    initialRoute: "/",
    routes: {
      '/': (context) => MyApp(),
      '/login': (context) => AppLogin(),
      '/login-cliente': (context) => AppLoginCliente(),
      '/registrar-cliente-login': (context) => AppRegistrarClienteLogin(),
      '/menu-administrador': (context) => AppMenu(),
      '/registrar-categoria': (context) => AppRegistroCategoria(),
      '/registrar-adicional': (context) => AppRegistroAdicional(),
      '/registrar-manual': (context) => AppRegistroManual(),
      '/registrar-mesa': (context) => AppRegistroMesa(),
      '/manual-cliente': (context) => AppManualCliente(),
      '/lista-manual': (context) => AppListaManual(),
      //'/mensaje-confirmacion': (context) => AppMensajeConfirmacion(),
      //'/seleccionar-productos': (context) => AppSeleccionarProducto(),
      // '/registrar-producto': (context) => AppRegistroProducto(),
      // '/principal': (context) => AppMenu(),
      // '/principal': (context) => AppMenu(),
      // '/principal': (context) => AppMenu(),
    },
    onGenerateRoute: (settings) {
      switch (settings.name) {
        case '/editar-manual':
          final ManualModel manualModel = settings.arguments as ManualModel;
          return MaterialPageRoute(
            builder: (context) => AppRegistroManual(
              manualModel: manualModel,
            ),
          );
        case '/mensaje-confirmacion':
          final PedidoModel pedidoModel = settings.arguments as PedidoModel;
          return MaterialPageRoute(
            builder: (context) => AppMensajeConfirmacion(
              pedidoModel: pedidoModel,
            ),
          );
        case '/confirmar-pedido':
          final args = settings.arguments as Map<String, dynamic>;
          final List<ProductoModel> listaProductos =
              args['listaProductos'] as List<ProductoModel>;
          final List<int> listaCantidades =
              args['listaCantidades'] as List<int>;
          final List<List<AdicionalModel>> listaDetalle =
              args['listaDetalles'] as List<List<AdicionalModel>>;
          final double total = args['total'] as double;
          return MaterialPageRoute(
            builder: (context) => AppConfirmarPedido(
                productos: listaProductos,
                cantidades: listaCantidades,
                listaDetalle: listaDetalle,
                total: total),
          );
        case '/seleccionar-mesas':
          // final List<MesaModel> listaMesas =
          //     settings.arguments as List<MesaModel>;
          return MaterialPageRoute(
            builder: (context) => AppSeleccionarMesa(
                //data: listaMesas,
                ),
          );
        case '/liberar-mesas':
          return MaterialPageRoute(
            builder: (context) => AppLiberarMesa(
                //data: listaMesas,
                ),
          );
        case '/seleccionar-productos':
          final List<ProductoModel> listaProductos =
              settings.arguments as List<ProductoModel>;
          return MaterialPageRoute(
            builder: (context) => AppSeleccionarProducto(
              listaProductos: listaProductos,
            ),
          );
        case '/asignar-adicionales':
          final args = settings.arguments as Map<String, dynamic>;
          final List<AdicionalModel> adicionales =
              args['adicionales'] as List<AdicionalModel>;
          final List<AdicionalModel> adicionalesAsignados =
              args['adicionalesAsignados'] as List<AdicionalModel>;
          final CategoriaModel categoria = args['categoria'] as CategoriaModel;
          return MaterialPageRoute(
            builder: (context) => AppAsignarAdicional(
                categoria: categoria,
                adicionales: adicionales,
                adicionalesAsignados: adicionalesAsignados),
          );
        case '/seleccionar-adicionales':
          final args = settings.arguments as Map<String, dynamic>;
          final List<ProductoModel> productos =
              args['productos'] as List<ProductoModel>;
          final List<int> cantidades = args['cantidades'] as List<int>;
          final double total = args['total'] as double;
          return MaterialPageRoute(
            builder: (context) => AppSeleccionarAdicional(
                productos: productos, cantidades: cantidades, total: total),
          );
        case '/editar-adicional':
          final AdicionalModel adicional = settings.arguments as AdicionalModel;
          return MaterialPageRoute(
            builder: (context) => AppRegistroAdicional(adicional: adicional),
          );
        case '/registrar-producto':
          final List<CategoriaModel> listaCategorias =
              settings.arguments as List<CategoriaModel>;
          return MaterialPageRoute(
            builder: (context) =>
                AppRegistroProducto(listaCategorias: listaCategorias),
          );
        case '/registrar-cliente':
          final List<TipoDocumentoModel> listaDocumentos =
              settings.arguments as List<TipoDocumentoModel>;
          return MaterialPageRoute(
            builder: (context) =>
                AppRegistroCliente(listaTipoDocumento: listaDocumentos),
          );
        case '/editar-categoria':
          final CategoriaModel categoria = settings.arguments as CategoriaModel;
          return MaterialPageRoute(
            builder: (context) =>
                AppRegistroCategoria(categoriaModel: categoria),
          );
        case '/editar-cliente':
          final args = settings.arguments as Map<String, dynamic>;
          final List<TipoDocumentoModel> listaDocumentos =
              args['lista'] as List<TipoDocumentoModel>;
          final ClienteModel clienteModel =
              args['clienteModel'] as ClienteModel;
          return MaterialPageRoute(
            builder: (context) => AppRegistroCliente(
                listaTipoDocumento: listaDocumentos,
                clienteModel: clienteModel),
          );
        case '/editar-mesa':
          final MesaModel mesaModel = settings.arguments as MesaModel;
          return MaterialPageRoute(
            builder: (context) => AppRegistroMesa(mesaModel: mesaModel),
          );
        case '/editar-producto':
          final args = settings.arguments as Map<String, dynamic>;
          final List<CategoriaModel> listaCategorias =
              args['lista'] as List<CategoriaModel>;
          final ProductoModel productoModel =
              args['productoModel'] as ProductoModel;
          return MaterialPageRoute(
            builder: (context) => AppRegistroProducto(
                listaCategorias: listaCategorias, productoModel: productoModel),
          );
        case '/lista-categorias':
          final List<CategoriaModel> lista =
              settings.arguments as List<CategoriaModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaCategoria(data: lista),
          );
        case '/lista-productos':
          final List<ProductoModel> lista =
              settings.arguments as List<ProductoModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaProducto(data: lista),
          );
        case '/lista-mesas':
          final List<MesaModel> lista = settings.arguments as List<MesaModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaMesa(data: lista),
          );
        case '/lista-clientes':
          final List<ClienteModel> lista =
              settings.arguments as List<ClienteModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaCliente(data: lista),
          );
        case '/lista-administradores':
          final List<AdministradorModel> lista =
              settings.arguments as List<AdministradorModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaAdministradores(data: lista),
          );
        case '/lista-adicionales':
          final List<AdicionalModel> lista =
              settings.arguments as List<AdicionalModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaAdicional(data: lista),
          );
        case '/lista-pedidos':
          final List<PedidoModel> lista =
              settings.arguments as List<PedidoModel>;
          return MaterialPageRoute(
            builder: (context) => AppListaPedido(data: lista),
          );
        case '/dashboard-pedidos':
          return MaterialPageRoute(
            builder: (context) => AppDashboardPedido(),
          );
        default:
          break;
      }
    },
  ));
}

enum WidgetState { NONE, LOADING, LOADED, ERROR }

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  WidgetState _widgetState = WidgetState.LOADED;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obtenerPreferencias();
  }

  @override
  Widget build(BuildContext context) {
    switch (_widgetState) {
      case WidgetState.NONE:
      case WidgetState.LOADING:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/frutas_fondo1.jpg"),
                // opacity: 0.9,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.amber.shade900),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Iniciando sesion...",
                        style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20.0,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      )
                    ]),
              ),
            ),
          ),
        );
      case WidgetState.LOADED:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/frutas_fondo1.jpg"),
                // opacity: 0.9,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: MediaQuery.of(context).size.height / 4 * 3,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppButtons(
                            textColor: Colors.black,
                            backgroundColor: Color.fromRGBO(241, 241, 241, 1),
                            borderColor: Color.fromRGBO(241, 241, 241, 1),
                            text: "Administrar",
                            fontSize: 15,
                            width: 250,
                            height: 50,
                            funcion: () {
                              InfoGlobal.incrementarVentanas();
                              Navigator.pushNamed(context, '/login');
                            }),
                        const SizedBox(height: 15),
                        AppButtons(
                          textColor: Colors.black,
                          backgroundColor: Color.fromRGBO(241, 241, 241, 1),
                          borderColor: Color.fromRGBO(241, 241, 241, 1),
                          text: "Comprar ahora",
                          fontSize: 15,
                          width: 250,
                          height: 50,
                          funcion: () async {
                            InfoGlobal.incrementarVentanas();
                            Navigator.pushNamed(context, '/login-cliente');
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    width: 150,
                    child: Image.asset("assets/devesoft_blanco.png"),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          // body:
        );
      case WidgetState.ERROR:
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/frutas_fondo1.jpg"),
                // opacity: 0.9,
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                  child: Text(
                "ERROR AL INICIAR SESION!!",
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 20.0,
                    color: Colors.white,
                    decoration: TextDecoration.none),
              )),
            ),
          ),
        );
    }
  }

  void obtenerPreferencias() async {
    // Obtain shared preferences.
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? usuarioCliente = prefs.getString('usuarioCliente');
    final String? contraseniaCliente = prefs.getString('contraseniaCliente');
    final String? usuarioAdministrador =
        prefs.getString('usuarioAdministrador');
    final String? contraseniaAdministrador =
        prefs.getString('contraseniaAdministrador');

    if (usuarioAdministrador != null) {
      try {
        setState(() {
          _widgetState = WidgetState.LOADING;
        });

        AdministradorController administradorCtrl = AdministradorController();

        UsuarioModel usuarioModel = UsuarioModel(
            nombreUsuario: usuarioAdministrador,
            contraseniaUsuario: contraseniaAdministrador);

        AdministradorModel administradorModel = AdministradorModel();

        List<AdministradorModel> respuesta =
            await administradorCtrl.validarLogin(usuarioModel);

        if (respuesta.length == 1) {
          administradorModel.nombreAdministrador =
              respuesta[0].nombreAdministrador;
          administradorModel.apellidoAdministrador =
              respuesta[0].apellidoAdministrador;
          administradorModel.numeroDocumento = respuesta[0].numeroDocumento;
          administradorModel.tipoDocumentoModel =
              TipoDocumentoModel(id: respuesta[0].tipoDocumentoModel!.id);
          administradorModel.telefonoAdministrador =
              respuesta[0].telefonoAdministrador;
          administradorModel.emailAdministrador =
              respuesta[0].emailAdministrador;

          usuarioModel.id = respuesta[0].usuario!.id;
          administradorModel.usuario = usuarioModel;
          InfoGlobal.administradorModel = administradorModel;
          InfoGlobal.incrementarVentanas();
          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/dashboard-pedidos');

          setState(() {
            _widgetState = WidgetState.LOADED;
          });
        } else {
          InfoGlobal.mensajeFallo(
              context, "Usuario y/o contraseña incorrecto.", 2);
          setState(() {
            _widgetState = WidgetState.LOADED;
          });
        }
      } catch (e) {
        InfoGlobal.mensajeFallo(context,
            "Ha ocurrido un error al intentar logearse\n ${e.toString()}", 2);
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
      }
    } else if (usuarioCliente != null) {
      try {
        setState(() {
          _widgetState = WidgetState.LOADING;
        });
        ClienteController clienteCtrll = ClienteController();

        UsuarioModel usuarioModel = UsuarioModel(
            nombreUsuario: usuarioCliente,
            contraseniaUsuario: contraseniaCliente);

        ClienteModel clienteModel = ClienteModel();

        List<ClienteModel> respuesta =
            await clienteCtrll.validarLogin(usuarioModel);

        // print(respuesta[0].id);s
        if (respuesta.length == 1) {
          clienteModel.id = respuesta[0].id;
          clienteModel.nombreCliente = respuesta[0].nombreCliente;
          clienteModel.apellidoCliente = respuesta[0].apellidoCliente;
          clienteModel.numeroDocumento = respuesta[0].numeroDocumento;
          clienteModel.tipoDocumentoModel =
              TipoDocumentoModel(id: respuesta[0].tipoDocumentoModel!.id);
          clienteModel.telefonoCliente = respuesta[0].telefonoCliente;
          clienteModel.emailCliente = respuesta[0].emailCliente;

          usuarioModel.id = respuesta[0].usuario!.id;
          clienteModel.usuario = usuarioModel;

          InfoGlobal.clienteModel = clienteModel;

          Navigator.of(context).pop();
          Navigator.pushNamed(context, '/seleccionar-mesas');
          setState(() {
            _widgetState = WidgetState.LOADED;
          });
        } else {
          InfoGlobal.mensajeFallo(
              context, "Usuario y/o contraseña incorrecto.", 2);
          setState(() {
            _widgetState = WidgetState.LOADED;
          });
        }
      } catch (e) {
        InfoGlobal.mensajeFallo(context,
            "Ha ocurrido un error al intentar logearse\n ${e.toString()}", 2);
        setState(() {
          _widgetState = WidgetState.LOADED;
        });
      }
    } else {
      debugPrint("No se cargo datos de administrador ni de cliente.");
    }
  }
}
