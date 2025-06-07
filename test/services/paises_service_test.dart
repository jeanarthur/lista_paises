import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:lista_paises/models/pais.dart';
import 'paises_manager_test.mocks.dart';

void main() {
  group('Testes do IPaisesManager', () {
    final mockService = MockIPaisesManager();

    test('Listagem com sucesso', () async {
      final paisesEsperados = [
        Pais('Brasil', 'https://bandeiras.com/brasil.png', 'Brasília', 'América do Sul', 211000000),
        Pais('Argentina', 'https://bandeiras.com/argentina.png', 'Buenos Aires', 'América do Sul', 45000000),
      ];

      when(mockService.obterPaises()).thenAnswer((_) async => paisesEsperados);

      final paises = await mockService.obterPaises();

      expect(paises, isNotEmpty);
      expect(paises.first.nome, equals('Brasil'));
      expect(paises.first.capital, equals('Brasília'));
      expect(paises.first.imagemUrl, equals('https://bandeiras.com/brasil.png'));
      expect(paises.first.regiao, equals('América do Sul'));
      expect(paises.first.populacao, equals(211000000));
    });

    test('Falha na listagem', () async {
      when(mockService.obterPaises()).thenThrow(Exception('Erro na API'));

      expect(() async => await mockService.obterPaises(), throwsException);
    });

    test('Buscar país específico com sucesso', () async {
      final resultadoEsperado = [
        Pais('Chile', 'https://bandeiras.com/chile.png', 'Santiago', 'América do Sul', 19000000)
      ];

      when(mockService.obterPaisesPorNome('Chile'))
          .thenAnswer((_) async => resultadoEsperado);

      final resultado = await mockService.obterPaisesPorNome('Chile');

      expect(resultado, isNotEmpty);
      expect(resultado.first.nome, equals('Chile'));
      expect(resultado.first.capital, equals('Santiago'));
      expect(resultado.first.imagemUrl, contains('chile.png'));
      expect(resultado.first.populacao, equals(19000000));
    });

    test('Busca de país que não existe', () async {
      when(mockService.obterPaisesPorNome('Narnia'))
          .thenAnswer((_) async => []);

      final resultado = await mockService.obterPaisesPorNome('Narnia');

      expect(resultado, isEmpty);
    });

    test('País com campos vazios (capital, bandeira)', () async {
      final resultadoEsperado = [
        Pais('País Desconhecido', '', '', '', 0)
      ];

      when(mockService.obterPaisesPorNome('País Desconhecido'))
          .thenAnswer((_) async => resultadoEsperado);

      final resultado = await mockService.obterPaisesPorNome('País Desconhecido');

      final pais = resultado.first;

      expect(pais.imagemUrl, isEmpty);
      expect(pais.capital, isEmpty);
      expect(pais.regiao, isEmpty);
      expect(pais.populacao, equals(0));
    });

    test('Verificar chamada ao método obterPaises()', () async {
      final mockService = MockIPaisesManager();

      when(mockService.obterPaises()).thenAnswer((_) async => []);

      await mockService.obterPaises();

      verify(mockService.obterPaises()).called(1);
    });
  });
}