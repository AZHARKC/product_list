import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:product_list/presentation/bloc/product/product_event.dart';
import 'package:product_list/widgets/product_detail_page.dart';
import 'package:product_list/widgets/product_list.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'data/repositories/product_repository.dart';
import 'data/datasources/remote/product_remote_datasource.dart';
import 'data/datasources/local/product_local_datasource.dart';
import 'presentation/bloc/product/product_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  final database = await openDatabase(
    join(await getDatabasesPath(), 'product_db.db'),
    version: 1,
    onCreate: (db, version) async {


      await db.execute('''
  CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    title TEXT,
    description TEXT,
    category TEXT,
    price REAL,
    discountPercentage REAL,
    rating REAL,
    stock INTEGER,
    brand TEXT,
    thumbnail TEXT,
    image TEXT

  )
''');
      },
  );


  final local = ProductLocalDataSourceImpl(database );
  final remote = ProductRemoteDataSourceImpl(http.Client());


  final repo = ProductRepository(remote: remote, local: local);

  runApp(MyApp(repo: repo));
}

class MyApp extends StatelessWidget {
  final ProductRepository repo;

  const MyApp({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   home: BlocProvider(
    //     create: (_) => ProductBloc(repo)..add(const ProductEvent.started()),
    //     child: const ProductListPage(),
    //   ),
    // );
    final GoRouter router = GoRouter(
        routes:[
          GoRoute(
            path: '/',
            builder: (context, state) => BlocProvider(
              create: (_) => ProductBloc(repo)..add(const ProductEvent.started()),
              child: const ProductListPage(),
            ),
          ),
          GoRoute(
            path: '/product/:id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '');
              return ProductDetailPage(productId: id, repository: repo);
            },
          ),
        ],

    );
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}


