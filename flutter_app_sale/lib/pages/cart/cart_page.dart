import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'package:flutter_app_sale/common/constants/app_color.dart';
import 'package:flutter_app_sale/common/constants/app_styles.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/pages/cart/cart_event.dart';
import 'package:flutter_app_sale/pages/home/home_event.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:flutter_app_sale/utils/message_utils.dart';
import 'cart_bloc.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
        providers: [
          Provider(create: (context) => ApiRequest()),
          ProxyProvider<ApiRequest, CartRepository>(
            create: (context) => CartRepository(),
            update: (_, request, repository) {
              repository ??= CartRepository();
              repository.setApiRequest(request);
              return repository;
            },
          ),
          ProxyProvider<CartRepository, CartBloc>(
            create: (context) => CartBloc(),
            update: (_, repository, bloc) {
              bloc ??= CartBloc();
              bloc.setCartRepo(repository);
              return bloc;
            },
          ),
        ],
        appBar: AppBar(
          title: Text('Giỏ hàng'),
        ),
        child: CartPageContainer());
  }
}

class CartPageContainer extends StatefulWidget {
  const CartPageContainer({Key? key}) : super(key: key);

  @override
  State<CartPageContainer> createState() => _CartPageContainerState();
}

class _CartPageContainerState extends State<CartPageContainer> {
  late CartBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(FetchCartEvent());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _bloc.messageStream.listen((event) {
        MessageUtils.showMessage(context, "Alert!!", event.toString());
      });

      _bloc.progressStream.listen((event) {
        if (event is ConfirmOrderSuccessEvent) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(RouteName.home, (route) => false);
          MessageUtils.showMessage(context, "Success!!", event.message);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String _idCart = '';
    num _sumPrice = 0;
    return StreamBuilder<CartModel>(
        initialData: null,
        stream: _bloc.cartStream,
        builder: (context, snapshot) {
          if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data?.products?.isEmpty == true) {
            return Image.asset('assets/images/img_empty_cart.png');
          } else {
            _idCart = snapshot.data?.id ?? '';
            snapshot.data?.products?.forEach((element) {
              _sumPrice += (element.quantity ?? 0) * (element.price ?? 0);
            });
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data?.products?.length ?? 0,
                      itemBuilder: (context, index) {
                        return _buildItemFood(
                            snapshot.data?.products?[index], _idCart);
                      }),
                ),
                Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1.0, color: Colors.grey))),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        'Tổng tiền: ${NumberFormat("#,###", "en_US").format(_sumPrice)} đ',
                        style: AppStyles.h5.copyWith(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      )),
                      ElevatedButton(
                          onPressed: () {
                            _bloc.eventSink
                                .add(ConfirmOrderEvent(idCart: _idCart));
                          },
                          child: Text('Mua hàng'))
                    ],
                  ),
                )
              ],
            );
          }
        });
  }

  Widget _buildItemFood(ProductModel? product, String idCart) {
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
                            _bloc.eventSink.add(UpdateCartEvent(
                                idProduct: product.id ?? '',
                                idCart: idCart,
                                quantity: (product.quantity ?? 0) - 1));
                          },
                          child: const Text("-"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('${product.quantity}',
                              style: AppStyles.h5.copyWith(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              _bloc.eventSink.add(UpdateCartEvent(
                                  idProduct: product.id ?? '',
                                  idCart: idCart,
                                  quantity: (product.quantity ?? 0) + 1));
                            },
                            child: const Text("+")),
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
