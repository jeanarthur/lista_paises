import 'package:flutter/material.dart';
import 'package:lista_paises/models/pais.dart';
import 'package:lista_paises/services/paises_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Pais> _paises;

  @override
  void initState() {
    super.initState();
    _paises = List.empty();
    _carregarPaises();
  }

  _carregarPaises() async {
    var paisesManager = PaisesManager();
    var paises = await paisesManager.obterPaises();
    setState(() {
      _paises = paises;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: _paises.isNotEmpty 
          ? ListView.builder(
            itemCount: _paises.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Image.network(_paises[index].imagemUrl),
                title: Text(_paises[index].nome),
              );
            },
          )
          : CircularProgressIndicator(),
      )
    );
  }
}
