import 'package:flutter/material.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/constants/app_color.dart';
import 'package:flutter_app_sale/common/constants/app_styles.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/pages/cart/cart_event.dart';
import 'package:flutter_app_sale/pages/order_history/order_history_bloc.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:intl/intl.dart';

import 'package:provider/provider.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({Key? key}) : super(key: key);

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
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
          ProxyProvider<CartRepository, OrderHistoryBloc>(
            create: (context) => OrderHistoryBloc(),
            update: (_, repository, bloc) {
              bloc ??= OrderHistoryBloc();
              bloc.setCartRepo(repository);
              return bloc;
            },
          ),
        ],
        appBar: AppBar(
          title: Text('Order history'),
        ),
        child: OrderHistoryContainer());
  }
}

class OrderHistoryContainer extends StatefulWidget {
  const OrderHistoryContainer({Key? key}) : super(key: key);

  @override
  State<OrderHistoryContainer> createState() => _OrderHistoryContainerState();
}

class _OrderHistoryContainerState extends State<OrderHistoryContainer> {
  late OrderHistoryBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(GetOrderHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CartModel>>(
        initialData: const [],
        stream: _bloc.listCartStream,
        builder: (context, snapshot) {
          if (snapshot.hasError || snapshot.data?.isEmpty == true) {
            return Container(
              child: Center(child: Text("Data empty")),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildItemCart(snapshot.data?[index]);
              });
        });
  }

  Widget _buildItemCart(CartModel? cart) {
    if (cart == null) return Container();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, RouteName.orderDetail, arguments: cart);
      },
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 5,
          shadowColor: Colors.blueGrey,
          child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Giá : ${DateFormat("dd/MM/yyyy HH:mm", "en_US").format(cart.createDate ?? DateTime.now())}",
                    style: AppStyles.h5.copyWith(color: AppColors.textColor),
                  ),
                  Text(
                    "Giá : ${NumberFormat("#,###", "en_US").format(cart.price)} đ",
                    style: AppStyles.h5.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
