import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:product_list/presentation/bloc/product/product_bloc.dart';
import 'package:product_list/presentation/bloc/product/product_event.dart';
import 'package:product_list/presentation/bloc/product/product_state.dart';


class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();



    // Listen for scroll position to trigger loadMore
    _scrollController.addListener(() {
      final bloc = context.read<ProductBloc>();
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        bloc.add(const ProductEvent.loadMore());
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
      appBar: AppBar(title: const Text("Products")),
      body: BlocListener<ProductBloc, ProductState>(
        listener:(context, state){
          if(state is NoMoreData){
            Fluttertoast.showToast(
              msg: " No more products to load",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
    child:  BlocBuilder<ProductBloc, ProductState>(
    builder: (context, state)     {
          switch (state) {
            case Initial():
              return const Center(child: Text("Initializing..."));

            case Loading():
              return const Center(child: CircularProgressIndicator());



            case Loaded(:final products):
              return ListView.builder(
                controller: _scrollController,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        product.thumbnail ?? '',
                        width: 60,
                        height: 60,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text('\$${product.price?.toStringAsFixed(2)}'),
                      onTap:() {
                        context.push('/product/${product.id}');
                      } ,
                    ),
                  );
                },
              );

            case Error(:final message):
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(height: 8),
                    Text("Error: $message"),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(const ProductEvent.started());
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            case NoMoreData(:final products):
              return ListView.builder(
                controller: _scrollController,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ListTile(
                      leading: Image.network(
                        product.thumbnail ?? '',
                        width: 60,
                        height: 60,
                        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                      title: Text(product.title),
                      subtitle: Text(product.description),
                      trailing: Text('\$${product.price?.toStringAsFixed(2)}'),
                    ),
                  );
                },
              );
              throw UnimplementedError();
          }
        },
      ),
      ) );
  }
}









