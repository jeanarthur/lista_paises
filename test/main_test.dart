import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_paises/main.dart';
import 'package:lista_paises/models/pais.dart';
import 'package:mockito/mockito.dart';

import 'services/paises_manager_test.mocks.dart';

// Um HttpOverrides que não faz nada (silencia o 400)
// Adicionado para evitar erros na busca das url de imagens (em testes não é executado as requests)
class _NoOpHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? c) {
    final client = super.createHttpClient(c);
    // garante que não haja bloqueio por certificado, etc.
    client.badCertificateCallback = (_, __, ___) => true;
    return client;
  }
}

main(){
  setUpAll(() {
    HttpOverrides.global = _NoOpHttpOverrides();
  });
  tearDownAll(() {
    HttpOverrides.global = null;
  });

  testWidgets('Cenário 01 - Verificar se o nome do país é carregado no componente', (WidgetTester tester) async {
    // mock para paises. Usar o widget padrao, com a requisicao real, gerava o erro:
    // Warning: At least one test in this suite creates an HttpClient. When running a test suite that uses
    // TestWidgetsFlutterBinding, all HTTP requests will return status code 400, and no network request
    // will actually be made. Any test expecting a real network connection and status code will fail.
    // To test code that needs an HttpClient, provide your own HttpClient implementation to the code under
    // test, so that your test can consistently provide a testable response to the code under test.
    var mockPaisesManager = MockIPaisesManager();
    final paisesTestes = [
      Pais('Brasil', 'https://bandeiras.com/brasil.png', 'Brasília', 'América do Sul', 211000000),
      Pais('Argentina', 'https://bandeiras.com/argentina.png', 'Buenos Aires', 'América do Sul', 45000000),
    ];
    when(mockPaisesManager.obterPaises()).thenAnswer((_) async => paisesTestes);

    await tester.pumpWidget(MyApp(paisesManager: mockPaisesManager));
    await tester.pumpAndSettle();
    
    expect(find.widgetWithText(ListTile, 'Brasil'), findsOne);
    expect(find.widgetWithText(ListTile, 'Argentina'), findsOne);
  });

  testWidgets('Cenário 02 - Verificar se ao clicar em um país os dados são abertos', (WidgetTester tester) async {
    // mock para paises. Usar o widget padrao, com a requisicao real, gerava o erro:
    // Warning: At least one test in this suite creates an HttpClient. When running a test suite that uses
    // TestWidgetsFlutterBinding, all HTTP requests will return status code 400, and no network request
    // will actually be made. Any test expecting a real network connection and status code will fail.
    // To test code that needs an HttpClient, provide your own HttpClient implementation to the code under
    // test, so that your test can consistently provide a testable response to the code under test.
    var mockPaisesManager = MockIPaisesManager();
    final paisesTestes = [
      Pais('Brasil', 'https://bandeiras.com/brasil.png', 'Brasília', 'América do Sul', 211000000),
      Pais('Argentina', 'https://bandeiras.com/argentina.png', 'Buenos Aires', 'América do Sul', 45000000),
    ];
    when(mockPaisesManager.obterPaises()).thenAnswer((_) async => paisesTestes);
    
    await tester.pumpWidget(MyApp(paisesManager: mockPaisesManager));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ListTile, 'Brasil'));
    await tester.pumpAndSettle();

    expect(find.text('Capital: ${paisesTestes[0].capital}'), findsOne);
    expect(find.text('Região: ${paisesTestes[0].regiao}'), findsOne);
    expect(find.text('População: ${paisesTestes[0].populacao}'), findsOne);
  });

  testWidgets(' Cenário 03 - Verificar se um componente de imagem é carregado com a bandeira', (WidgetTester tester) async {
    // mock para paises. Usar o widget padrao, com a requisicao real, gerava o erro:
    // Warning: At least one test in this suite creates an HttpClient. When running a test suite that uses
    // TestWidgetsFlutterBinding, all HTTP requests will return status code 400, and no network request
    // will actually be made. Any test expecting a real network connection and status code will fail.
    // To test code that needs an HttpClient, provide your own HttpClient implementation to the code under
    // test, so that your test can consistently provide a testable response to the code under test.
    var mockPaisesManager = MockIPaisesManager();
    final paisesTestes = [
      Pais('Brasil', 'https://bandeiras.com/brasil.png', 'Brasília', 'América do Sul', 211000000),
      Pais('Argentina', 'https://bandeiras.com/argentina.png', 'Buenos Aires', 'América do Sul', 45000000),
    ];
    when(mockPaisesManager.obterPaises()).thenAnswer((_) async => paisesTestes);
    
    await tester.pumpWidget(MyApp(paisesManager: mockPaisesManager));
    await tester.pumpAndSettle();

    expect(find.image(NetworkImage(paisesTestes[0].imagemUrl)), findsOne);
    expect(find.image(NetworkImage(paisesTestes[1].imagemUrl)), findsOne);
  });
}