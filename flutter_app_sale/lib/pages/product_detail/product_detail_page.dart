import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_app_sale/common/base/base_widget.dart';
import 'package:flutter_app_sale/common/constants/api_url.dart';
import 'package:flutter_app_sale/common/constants/app_color.dart';
import 'package:flutter_app_sale/common/constants/app_styles.dart';
import 'package:flutter_app_sale/data/api_requests/api_request.dart';
import 'package:flutter_app_sale/data/repositories/cart_repository.dart';
import 'package:flutter_app_sale/data/repositories/product_repository.dart';
import 'package:flutter_app_sale/models/cart_model.dart';
import 'package:flutter_app_sale/models/product_model.dart';
import 'package:flutter_app_sale/pages/home/home_event.dart';
import 'package:flutter_app_sale/pages/product_detail/product_detail_bloc.dart';
import 'package:flutter_app_sale/routes.dart';
import 'package:intl/intl.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class ProductDetailPage extends StatefulWidget {
  ProductModel productModel;

  ProductDetailPage({super.key, required this.productModel});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
          ProxyProvider<CartRepository, ProductDetailBloc>(
            create: (context) => ProductDetailBloc(),
            update: (_, repository, bloc) {
              bloc ??= ProductDetailBloc();
              bloc.setCartRepo(repository);
              return bloc;
            },
          ),
        ],
        appBar: AppBar(
          title: const Text('Product Detail'),
          actions: [
            Row(
              children: [
                InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.cart);
                  },
                  child: Consumer<ProductDetailBloc>(
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
        child: ProductDetailContainer(
          productModel: widget.productModel,
        ));

    // return Scaffold(
    //     appBar:
    //     body:
    //
    //   ),
    // );
  }
}

class ProductDetailContainer extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailContainer({Key? key, required this.productModel})
      : super(key: key);

  @override
  State<ProductDetailContainer> createState() => _ProductDetailContainerState();
}

class _ProductDetailContainerState extends State<ProductDetailContainer> {
  late ProductDetailBloc _bloc;
  List<String> imgList = [];
  final _imgController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc = context.read();
    _bloc.eventSink.add(FetchCartEvent());
    imgList = widget.productModel.gallery ?? [];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          // width: double.infinity,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: size.width,
                  child: PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    controller: _imgController,
                    scrollDirection: Axis.horizontal,
                    itemCount: imgList.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        ApiURL.baseUrl + imgList[index],
                        fit: BoxFit.fitWidth,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: 8,
                    width: size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imgList.length,
                      itemBuilder: (context, index) {
                        return buildIndicator(index == _currentIndex, size);
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productModel.name ?? '',
                style: AppStyles.h4.copyWith(color: Colors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Đơn giá: ${NumberFormat('#,###', 'en-US').format(widget.productModel.price ?? 0)} VNĐ',
                style: AppStyles.h5
                    .copyWith(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.productModel.address ?? '',
                style: AppStyles.h5.copyWith(color: AppColors.textColor),
              ),
            ),
          ]),
    floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.productModel.id?.isEmpty == true) return;
          _bloc.eventSink
              .add(AddCartEvent(idProduct: widget.productModel.id ?? ''));
        },
        label: const Text('Thêm vào giỏ hàng'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget buildIndicator(bool isActive, Size size) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 30,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }
}
