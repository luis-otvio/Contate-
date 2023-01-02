import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lancamento_contatos/colors.dart';
import 'package:lancamento_contatos/globals.dart';
import 'package:lancamento_contatos/view/atendimentos/atendimentos_page.dart';
import 'package:lancamento_contatos/view/atendimentos/detalhes_atendimento_page.dart';
import 'package:lancamento_contatos/view/atendimentos/novo_atendimento_page.dart';

import 'package:lancamento_contatos/view/clientes/clientes_page.dart';
import 'package:lancamento_contatos/view/clientes/detalhes_cliente_page.dart';
import 'package:lancamento_contatos/view/clientes/novo_cliente_page.dart';
import 'package:lancamento_contatos/view/home_page.dart';
import 'package:lancamento_contatos/view/login_page.dart';

import 'package:lancamento_contatos/model/usuario_model.dart';
import 'package:lancamento_contatos/model/cliente_model.dart';
import 'package:lancamento_contatos/model/atendimento_model.dart';

// ignore: prefer_typing_uninitialized_variables
String? paginaInicial;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter<Usuario>(UsuarioAdapter());
  Hive.registerAdapter<Cliente>(ClienteAdapter());
  Hive.registerAdapter<Atendimento>(AtendimentoAdapter());

  await Hive.initFlutter();

  // Verifica se o usuário já foi configurado
  Box<Usuario> box = await Hive.openBox<Usuario>('usuarios');
  if (box.isEmpty) {
    paginaInicial = '/login';
  } else {
    usuarioLogado = box.getAt(0)!;
    paginaInicial = '/home';
  }

  await Hive.openBox<Cliente>('clientes');
  await Hive.openBox<Atendimento>('atendimentos');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contate+',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      supportedLocales: const [Locale('pt')],
      theme: ThemeData(
        primarySwatch: primaryColor,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: paginaInicial,
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/clientes': (context) => const ClientesPage(),
        '/detalhes_cliente': (context) => const DetalhesClientePage(),
        '/novo_cliente': (context) => const NovoClientePage(),
        '/atendimentos': (context) => const AtendimentosPage(),
        '/detalhes_atendimento': (context) => const DetalhesAtendimentoPage(),
        '/novo_atendimento': (context) => const NovoAtendimentoPage(),
      },
    );
  }
}