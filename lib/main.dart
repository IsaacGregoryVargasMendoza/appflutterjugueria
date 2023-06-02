import 'package:app_jugueria/controladores/mesaController.dart';
import 'package:app_jugueria/modelos/adicionalModel.dart';
import 'package:app_jugueria/modelos/categoriaModel.dart';
import 'package:app_jugueria/modelos/productoModel.dart';
import 'package:app_jugueria/modelos/mesaModel.dart';
import 'package:app_jugueria/modelos/clienteModel.dart';
import 'package:app_jugueria/modelos/administradorModel.dart';
import 'package:app_jugueria/modelos/tipoDocumentoModel.dart';
import 'package:app_jugueria/modelos/pedidoModel.dart';
import 'package:app_jugueria/controladores/productoController.dart';
import 'package:app_jugueria/vistas/app_seleccionarMesa.dart';
import 'package:app_jugueria/vistas/app_confirmarPedido.dart';
import 'package:app_jugueria/vistas/app_asignarAdicionales.dart';
import 'package:app_jugueria/vistas/app_listaAdicionales.dart';
import 'package:app_jugueria/vistas/app_listaPedidos.dart';
import 'package:app_jugueria/vistas/app_seleccionarAdicionales.dart';
import 'package:app_jugueria/vistas/app_seleccionarProducto.dart';
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
      //'/registrar-cliente': (context) => AppRegistroCliente(),
      '/registrar-mesa': (context) => AppRegistroMesa(),
      //'/seleccionar-productos': (context) => AppSeleccionarProducto(),
      // '/registrar-producto': (context) => AppRegistroProducto(),
      // '/principal': (context) => AppMenu(),
      // '/principal': (context) => AppMenu(),
      // '/principal': (context) => AppMenu(),
    },
    onGenerateRoute: (settings) {
      switch (settings.name) {
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
          // final ClienteModel cliente = settings.arguments as ClienteModel;
          // return MaterialPageRoute(
          //   builder: (context) => AppRegistroCliente(clienteModel: cliente),
          // );
          break;
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
        default:
          break;
      }
    },
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
                        Navigator.pushNamed(context, '/login-cliente');

                        ///login-cliente
                        //arguments: listaMesas);
                      },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                width: 150,
                child: Image.asset("assets/devesoft-blanco.png"),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
      // body:
    );
  }
}
