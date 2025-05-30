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
  late List<Pais> _paisesCarregados;
  final int _quantidadePorCarregamento = 10;
  int _quantidadeDeCarrementos = 0;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _paises = List.empty(growable: true);
    _paisesCarregados = List.empty(growable: true);
    _cargaInicial();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _carregarPaises();
      }
    });
  }

  _cargaInicial() async {
    var paisesManager = PaisesManager();
    var paises = await paisesManager.obterPaises();
    setState(() {
      _paises = paises;
      _paisesCarregados = paises.sublist(0, _quantidadePorCarregamento);
      _quantidadeDeCarrementos++;
    });
  }

  _carregarPaises() async {
    if (_isLoading) return;
    if (_quantidadeDeCarrementos * _quantidadePorCarregamento >= _paises.length) return;
    
    setState(() {
      _isLoading = true;
    });

    // Simula atraso para exibir carregamento
    await Future.delayed(const Duration(seconds: 1));

    var inicio = _quantidadeDeCarrementos * _quantidadePorCarregamento;
    var fim = inicio + _quantidadePorCarregamento;
    if (fim > _paises.length) fim = _paises.length;

    setState(() {
      _paisesCarregados.addAll(_paises.sublist(inicio, fim));
      _quantidadeDeCarrementos++;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _paises.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _paisesCarregados.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _paisesCarregados.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return ListTile(
                  leading: Image.network(
                    _paisesCarregados[index].imagemUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(_paisesCarregados[index].nome)
                );
              },
            ),
    );
  }
}