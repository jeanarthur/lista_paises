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
    
    _checarSePreencheuTela();
  }

  _carregarPaises() async {
    if (_isLoading) return;
    if (_quantidadeDeCarrementos * _quantidadePorCarregamento >= _paises.length) {
      return;
    }

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
    _checarSePreencheuTela();
  }

  // Verifica se lista preencheu tela (em telas maiores, se a lista inicial for pequena não tem o scroll para disparar o lazy load)
  void _checarSePreencheuTela() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.position.maxScrollExtent == 0 &&
          _paisesCarregados.length < _paises.length) {
        _carregarPaises();
      }
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
                  title: Text(_paisesCarregados[index].nome),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PaisDetalhesPage(pais: _paisesCarregados[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

class PaisDetalhesPage extends StatelessWidget {
  final Pais pais;
  const PaisDetalhesPage({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pais.nome),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(
              pais.imagemUrl,
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16.0),
            Text(
              pais.nome,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Capital: ${pais.capital}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Região: ${pais.regiao}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8.0),
            Text(
              'População: ${pais.populacao}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}