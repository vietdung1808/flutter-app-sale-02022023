import 'package:flutter/material.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'package:flutter_app_sale/common/constants/share_preference_key.dart';
import 'package:flutter_app_sale/common/helpers/app_share_prefs.dart';
import 'package:flutter_app_sale/common/widgets/loading_widget.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/data/repositories/product_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/pages/home/home_bloc.dart';
import 'package:flutter_app_sale/pages/home/home_event.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      appBar: AppBar(
        title: const Text("Products"),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            AppSharePreferences.remove(SharePreferenceKey.token)?.then((value) {
              if (value == true) {
                Navigator.pushNamedAndRemoveUntil(
                    context, RouteName.login, (route) => false);
              }
            });
          },
        ),
        actions: [
          Row(
            children: [
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, RouteName.orderHistory);
                },
                  child: Container(child: const Icon(Icons.history))),
              const SizedBox(width: 10),
              InkWell(
                onTap: (){
                  Navigator.pushNamed(context, RouteName.cart);
                },
                child: Consumer<HomeBloc>(
                  builder: (context, bloc, child) {
                    return StreamBuilder<CartModel>(
                        initialData: null,
                        stream: bloc.cartStream,
                        builder: (context, snapshot) {
                          if (snapshot.hasError ||
                              snapshot.data == null ||
                              snapshot.data?.products?.isEmpty == true) {
                            return InkWell(
                              child: Container(
                                  margin:
                                      const EdgeInsets.only(right: 10, top: 10),
                                  child:
                                      const Icon(Icons.shopping_cart_outlined)),
                            );
                          }
                          int count = 0;
                          snapshot.data?.products?.forEach((element) {
                            count += (element.quantity ?? 0).toInt();
                          });
                          return Container(
                            margin: const EdgeInsets.only(right: 10, top: 10),
                            child: badges.Badge(
                              badgeContent: Text(
                                count.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              child: const Icon(Icons.shopping_cart_outlined),
                            ),
                          );
                        });
                  },
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
        ],
      ),
      providers: [
        Provider(create: (context) => ApiRequest()),
        ProxyProvider<ApiRequest, ProductRepository>(
          create: (context) => ProductRepository(),
          update: (_, request, repository) {
            repository ??= ProductRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider<ApiRequest, CartRepository>(
          create: (context) => CartRepository(),
          update: (_, request, repository) {
            repository ??= CartRepository();
            repository.setApiRequest(request);
            return repository;
          },
        ),
        ProxyProvider2<ProductRepository, CartRepository, HomeBloc>(
          create: (context) => HomeBloc(),
          update: (_, productRepo, cartRepository, bloc) {
            bloc ??= HomeBloc();
            bloc.setProductRepo(productRepo);
            bloc.setCartRepo(cartRepository);
            return bloc;
          },
        )
      ],
      child: HomePageContainer(),
    );
  }
}

class HomePageContainer extends StatefulWidget {
  @override
  State<HomePageContainer> createState() => _HomePageContainerState();
}

class _HomePageContainerState extends State<HomePageContainer> {
  late HomeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(FetchProductsEvent());
    _bloc.eventSink.add(FetchCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return LoadingWidget(
      bloc: _bloc,
      child: SafeArea(
          child: Container(
        child: Stack(
          children: [
            StreamBuilder<List<ProductModel>>(
                initialData: const [],
                stream: _bloc.listProductsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError || snapshot.data?.isEmpty == true) {
                    return Container(
                      child: Center(child: Text("Data empty")),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _buildItemFood(snapshot.data?[index]);
                      });
                }),
          ],
        ),
      )),
    );
  }

  Widget _buildItemFood(ProductModel? product) {
    if (product == null) return Container();
    return SizedBox(
      height: 135,
      child: Card(
        elevation: 5,
        shadowColor: Colors.blueGrey,
        child: Container(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(ApiURL.baseUrl + (product.img ?? ""),
                    width: 150, height: 120, fit: BoxFit.fill),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(product.name.toString(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16)),
                      ),
                      Text(
                          "Giá : ${NumberFormat("#,###", "en_US").format(product.price)} đ",
                          style: const TextStyle(fontSize: 12)),
                      Row(children: [
                        ElevatedButton(
                          onPressed: () {
                            if (product.id?.isEmpty == true) return;
                            _bloc.eventSink
                                .add(AddCartEvent(idProduct: product.id ?? ''));
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return const Color.fromARGB(
                                      200, 240, 102, 61);
                                } else {
                                  return const Color.fromARGB(
                                      230, 240, 102, 61);
                                }
                              }),
                              shape: MaterialStateProperty.all(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))))),
                          child: const Text("Thêm vào giỏ",
                              style: TextStyle(fontSize: 14)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed(
                                  RouteName.productDetail,
                                  arguments: product);
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.pressed)) {
                                    return const Color.fromARGB(
                                        200, 11, 22, 142);
                                  } else {
                                    return const Color.fromARGB(
                                        230, 11, 22, 142);
                                  }
                                }),
                                shape: MaterialStateProperty.all(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))))),
                            child: Text("Chi tiết",
                                style: const TextStyle(fontSize: 14)),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
