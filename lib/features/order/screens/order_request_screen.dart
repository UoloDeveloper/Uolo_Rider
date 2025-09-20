import 'dart:async';
import 'package:sixam_mart_delivery/common/widgets/order_widget.dart';
import 'package:sixam_mart_delivery/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/order_requset_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class OrderRequestScreen extends StatefulWidget {
//   final Function onTap;
//   const OrderRequestScreen({super.key, required this.onTap});

//   @override
//   OrderRequestScreenState createState() => OrderRequestScreenState();
// }

// class OrderRequestScreenState extends State<OrderRequestScreen> {
//   Timer? _timer;

//   @override
//   initState() {
//     super.initState();

//     if(Get.find<ProfileController>().profileModel == null) {
//       Get.find<ProfileController>().getProfile();
//     }

//     Get.find<OrderController>().getLatestOrders();
//     _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
//       Get.find<OrderController>().getLatestOrders();
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _timer?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(

//       appBar: CustomAppBarWidget(title: 'order_request'.tr, isBackButtonExist: false),

//       body: GetBuilder<OrderController>(builder: (orderController) {
//         return orderController.latestOrderList != null ? orderController.latestOrderList!.isNotEmpty ? RefreshIndicator(
//           onRefresh: () async {
//             await Get.find<OrderController>().getLatestOrders();
//           },
//           child: ListView.builder(
//             itemCount: orderController.latestOrderList!.length,
//             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//             physics: const AlwaysScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return OrderRequestWidget(orderModel: orderController.latestOrderList![index], index: index, onTap: widget.onTap);
//             },
//           ),
//         ) : Center(child: Text('no_order_request_available'.tr)) : const Center(child: CircularProgressIndicator());
//       }),
//     );
//   }
// }


class OrderRequestScreen extends StatefulWidget {
  final Function? onTap;
  const OrderRequestScreen({super.key, required this.onTap});

  @override
  OrderRequestScreenState createState() => OrderRequestScreenState();
}

class OrderRequestScreenState extends State<OrderRequestScreen> {
  Timer? _timer;

  @override
  initState() {
    super.initState();

    if(Get.find<ProfileController>().profileModel == null) {
      Get.find<ProfileController>().getProfile();
    }

    Get.find<OrderController>().getCurrentOrders();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getCurrentOrders();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Theme.of(context).primaryColor ,
      appBar: CustomAppBarWidget(title: 'Active Orders'.tr, isBackButtonExist: false,),

      body: GetBuilder<OrderController>(builder: (orderController) {
        return orderController.currentOrderList != null ? orderController.currentOrderList!.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Get.find<OrderController>().getCurrentOrders(
              
            );
          },
          child: ListView.builder(
            itemCount: orderController.currentOrderList!.length,
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {

    
//              Future<OrderModel> data=     Get.find<OrderController>().getOrderWithIdeachitem(orderController.currentOrderList![index].id);

             
//  data.then((value) {
//    print(  "  THE DATA IN INDEX $index IS ${value}");
//  });
              return 
              // OrderWidget(
              //                 orderModel: orderController.currentOrderList![index],
              //                 isRunningOrder: true,
              //                 orderIndex: index,
              //               );
              
              OrderWidget2 (orderModel: orderController.currentOrderList![index], index: index, onTap: widget.onTap!,fromDetailsPage: true,);
            },
          ),
        ) : Center(child: Text('NO ACTIVE ORDERS',style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),)) : const Center(child: CircularProgressIndicator(
          color: Colors.white,
        ));
      }),
    );
  }
}
