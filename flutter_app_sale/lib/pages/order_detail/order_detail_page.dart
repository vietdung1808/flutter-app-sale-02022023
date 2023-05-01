import 'package:flutter/material.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'package:flutter_app_sale/common/constants/app_styles.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderDetailPage extends StatefulWidget {
  final CartModel cartModel;

  const OrderDetailPage({Key? key, required this.cartModel}) : super(key: key);

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
    num _sumPrice = 0;
    return Scaffold(
        appBar: AppBar(
          title: Text('Order Detail'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: widget.cartModel.products?.length ?? 0,
                  itemBuilder: (context, index) {
                    return _buildItemFood(widget.cartModel.products?[index]);
                  }),
            ),
            Container(
              decoration: const BoxDecoration(
                  border:
                      Border(top: BorderSide(width: 1.0, color: Colors.grey))),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: Text(
                    'Tổng tiền: ${NumberFormat("#,###", "en_US").format(widget.cartModel.price)} đ',
                    style: AppStyles.h5.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  )),
                ],
              ),
            )
          ],
        ));
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
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          style: AppStyles.h5.copyWith(color: Colors.red)),
                      Text('Số lượng: ${product.quantity}',
                          style: AppStyles.h5.copyWith(color: Colors.red)),
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
