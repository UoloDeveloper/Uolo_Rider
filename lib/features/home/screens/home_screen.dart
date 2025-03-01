import 'dart:async';

import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_delivery/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_delivery/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_delivery/features/order/screens/order_request_screen.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/helper/price_converter_helper.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_alert_dialog_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/order_shimmer_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/order_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/title_widget.dart';
import 'package:sixam_mart_delivery/features/home/widgets/count_card_widget.dart';
import 'package:sixam_mart_delivery/features/home/widgets/earning_widget.dart';
import 'package:sixam_mart_delivery/features/order/screens/running_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   Future<void> _loadData() async {
//     Get.find<OrderController>().getIgnoreList();
//     Get.find<OrderController>().removeFromIgnoreList();
//     await Get.find<ProfileController>().getProfile();
//     await Get.find<OrderController>().getCurrentOrders();
//     await Get.find<NotificationController>().getNotificationList();
//     bool isBatteryOptimizationDisabled = GetPlatform.isAndroid ? (await DisableBatteryOptimization.isBatteryOptimizationDisabled)! : true;
//     if(!isBatteryOptimizationDisabled && GetPlatform.isAndroid) {
//       DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _loadData();

//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         // leading: Padding(
//         //   padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//         //   child: Image.asset(Images.logo, height: 30, width: 30),
//         // ),
//         titleSpacing: 0, elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Text(AppConstants.appName, maxLines: 1, overflow: TextOverflow.ellipsis, style: PoppinsMedium.copyWith(
//             color: Theme.of(context).cardColor, fontSize: 25,
//           )),
//         ),
//         actions: [
//           IconButton(
//             icon: GetBuilder<NotificationController>(builder: (notificationController) {
//               return Stack(children: [

//                 Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),

//                 notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
//                   height: 10, width: 10, decoration: BoxDecoration(
//                   color: Theme.of(context).primaryColor, shape: BoxShape.circle,
//                   border: Border.all(width: 1, color: Theme.of(context).cardColor),
//                 ),
//                 )) : const SizedBox(),

//               ]);
//             }),
//             onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
//           ),
//           GetBuilder<ProfileController>(builder: (profileController) {
//             return GetBuilder<OrderController>(builder: (orderController) {
//               return (profileController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
//                 width: 75, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
//                 activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
//                 value: profileController.profileModel!.active == 1, onToggle: (bool isActive) async {
//                   if(!isActive && orderController.currentOrderList!.isNotEmpty) {
//                     showCustomSnackBar('you_can_not_go_offline_now'.tr);
//                   }else {
//                     if(!isActive) {
//                       Get.dialog(ConfirmationDialogWidget(
//                         icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
//                         onYesPressed: () {
//                           Get.back();
//                           profileController.updateActiveStatus();
//                         },
//                       ));
//                     }else {
//                       LocationPermission permission = await Geolocator.checkPermission();
//                       if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
//                           || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
//                         if(GetPlatform.isAndroid) {
//                           Get.dialog(ConfirmationDialogWidget(
//                             icon: Images.locationPermission,
//                             iconSize: 200,
//                             hasCancel: false,
//                             description: 'this_app_collects_location_data'.tr,
//                             onYesPressed: () {
//                               Get.back();
//                               _checkPermission(() => profileController.updateActiveStatus());
//                             },
//                           ), barrierDismissible: false);
//                         }else {
//                           _checkPermission(() => profileController.updateActiveStatus());
//                         }
//                       }else {
//                         profileController.updateActiveStatus();
//                       }
//                     }
//                   }
//                 },
//               ) : const SizedBox();
//             });
//           }),
//           const SizedBox(width: Dimensions.paddingSizeSmall),
//         ],
//       ),

//       body: RefreshIndicator(
//         onRefresh: () async {
//           return await _loadData();
//         },
//         child:
        
//          SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           padding: const EdgeInsets.all(0),
//           child: GetBuilder<ProfileController>(builder: (profileController) {
//             return Column(children: [
              
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: 300,
//                 color: Theme.of(context).primaryColor,
//                 child: Column(mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                  children: [
//                   SizedBox(
//                     height: 40,
//                   ),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text('Partner Aswin'.tr, style: TextStyle(
//                       fontSize: 20,
//                       color: Colors.white,
                      
//                      )),
//                    ),


                  
//                 ])
//               ),

//                Container(
//                 color: Colors.white,
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height - 300,
               
                
//                )
//             ]);
//             // return Column(children: [

//             //   GetBuilder<OrderController>(builder: (orderController) {
//             //     bool hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList!.isNotEmpty;
//             //     bool hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList!.length > 1;
//             //     return Column(children: [
//             //       hasActiveOrder ? TitleWidget(
//             //         title: 'active_order'.tr, onTap: hasMoreOrder ? () {
//             //           Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: const RunningOrderScreen());
//             //         } : null,
//             //       ) : const SizedBox(),
//             //       SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeExtraSmall : 0),
//             //       orderController.currentOrderList == null ? OrderShimmerWidget(
//             //         isEnabled: orderController.currentOrderList == null,
//             //       ) : orderController.currentOrderList!.isNotEmpty ? OrderWidget(
//             //         orderModel: orderController.currentOrderList![0], isRunningOrder: true, orderIndex: 0,
//             //       ) : const SizedBox(),
//             //       SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeDefault : 0),
//             //     ]);
//             //   }),

//             //   (profileController.profileModel != null && profileController.profileModel!.earnings == 1) ? Column(children: [

//             //     TitleWidget(title: 'earnings'.tr),
//             //     const SizedBox(height: Dimensions.paddingSizeExtraSmall),

//             //     Container(
//             //       padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//             //       decoration: BoxDecoration(
//             //         borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//             //         color: Theme.of(context).primaryColor,
//             //       ),
//             //       child: Column(children: [

//             //         Row(mainAxisAlignment: MainAxisAlignment.start, children: [

//             //           const SizedBox(width: Dimensions.paddingSizeSmall),
//             //           Image.asset(Images.wallet, width: 60, height: 60),
//             //           const SizedBox(width: Dimensions.paddingSizeLarge),

//             //           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

//             //             Text(
//             //               'balance'.tr,
//             //               style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).cardColor),
//             //             ),
//             //             const SizedBox(height: Dimensions.paddingSizeSmall),

//             //             profileController.profileModel != null ? Text(
//             //               PriceConverterHelper.convertPrice(profileController.profileModel!.balance),
//             //               style: PoppinsBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
//             //               maxLines: 1, overflow: TextOverflow.ellipsis,
//             //             ) : Container(height: 30, width: 60, color: Colors.white),

//             //           ]),
//             //         ]),
//             //         const SizedBox(height: 30),
//             //         Row(children: [

//             //           EarningWidget(
//             //             title: 'today'.tr,
//             //             amount: profileController.profileModel?.todaysEarning,
//             //           ),
//             //           Container(height: 30, width: 1, color: Theme.of(context).cardColor),

//             //           EarningWidget(
//             //             title: 'this_week'.tr,
//             //             amount: profileController.profileModel?.thisWeekEarning,
//             //           ),
//             //           Container(height: 30, width: 1, color: Theme.of(context).cardColor),

//             //           EarningWidget(
//             //             title: 'this_month'.tr,
//             //             amount: profileController.profileModel?.thisMonthEarning,
//             //           ),

//             //         ]),

//             //       ]),
//             //     ),
//             //     const SizedBox(height: Dimensions.paddingSizeDefault),
//             //   ]) : const SizedBox(),

//             //   TitleWidget(title: 'orders'.tr),
//             //   const SizedBox(height: Dimensions.paddingSizeExtraSmall),

//             //   Row(children: [

//             //     Expanded(child: CountCardWidget(
//             //       title: 'todays_orders'.tr, backgroundColor: Theme.of(context).secondaryHeaderColor, height: 180,
//             //       value: profileController.profileModel?.todaysOrderCount.toString(),
//             //     )),
//             //     const SizedBox(width: Dimensions.paddingSizeSmall),

//             //     Expanded(child: CountCardWidget(
//             //       title: 'this_week_orders'.tr, backgroundColor: Theme.of(context).colorScheme.error, height: 180,
//             //       value: profileController.profileModel?.thisWeekOrderCount.toString(),
//             //     )),

//             //   ]),
//             //   const SizedBox(height: Dimensions.paddingSizeSmall),

//             //   CountCardWidget(
//             //     title: 'total_orders'.tr, backgroundColor: Theme.of(context).primaryColor, height: 140,
//             //     value: profileController.profileModel?.orderCount.toString(),
//             //   ),
//             //   const SizedBox(height: Dimensions.paddingSizeSmall),

//             //   profileController.profileModel != null ? Container(
//             //     height: 120, width: MediaQuery.of(context).size.width,
//             //     padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
//             //     decoration: BoxDecoration(
//             //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//             //       color: Theme.of(context).primaryColor.withOpacity(0.05),
//             //       border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.1)),
//             //     ),
//             //     child: Column(
//             //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             //       crossAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//             //       children: [

//             //         Row(mainAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center, children: [

//             //           Text(PriceConverterHelper.convertPrice(profileController.profileModel!.cashInHands), style: PoppinsBold.copyWith(fontSize: 30)),
//             //           const SizedBox(width: Dimensions.paddingSizeSmall),

//             //           (profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1) ? CustomButtonWidget(
//             //             width: 110, height: 40,
//             //             buttonText: 'view_details'.tr,
//             //             backgroundColor: Theme.of(context).primaryColor,
//             //             onPressed: () => Get.toNamed(RouteHelper.getCashInHandRoute()),
//             //           ) : const SizedBox(),

//             //         ]),

//             //         Text('cash_in_your_hand'.tr, style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),

//             //       ],
//             //     ),
//             //   ) : const CashInHandCardShimmer(),

//             // ]);
          
          
//           }),
//         ),
//       ),
//     );
//   }





import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   Future<void> _loadData() async {
//     // Your data loading logic
//      Get.find<OrderController>().getIgnoreList();
//     Get.find<OrderController>().removeFromIgnoreList();
//     await Get.find<ProfileController>().getProfile();
//     await Get.find<OrderController>().getCurrentOrders();
//     await Get.find<NotificationController>().getNotificationList();
//     bool isBatteryOptimizationDisabled = GetPlatform.isAndroid ? (await DisableBatteryOptimization.isBatteryOptimizationDisabled)! : true;
//     if(!isBatteryOptimizationDisabled && GetPlatform.isAndroid) {
//       DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     _loadData(); // Avoid calling this directly; use a FutureBuilder or similar for better practice.

//     return Scaffold(
//       backgroundColor: Theme.of(context).primaryColor,
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).primaryColor,
//         titleSpacing: 0,
//         elevation: 0,
//         title: Padding(
//           padding: const EdgeInsets.all(15),
//           child: Text(
//             'Uolo'.tr,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//               color: Theme.of(context).cardColor,
//               fontSize: 25,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications, size: 25, color: Theme.of(context).textTheme.bodyLarge!.color),
//             onPressed: () => Get.toNamed('/notifications'), // Replace with your route
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadData,
//         child:CustomScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         slivers: [
//           // Persistent header with curve
//         GetBuilder<ProfileController>(builder: (profileController) {
//               return SliverPersistentHeader(
//                 pinned: true,
//                 delegate: _FixedHeightHeaderDelegate(
//                   child: Stack(
//                     clipBehavior: Clip.none, // Allows overlap
//                     children: [
//                       // Header Background
//                       Container(
//                         width: MediaQuery.of(context).size.width,
//                         height: 300,
//                         color: Theme.of(context).primaryColor,
//                         child: Padding(
//                           padding: const EdgeInsets.only(left: 10,right: 10),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Balance'.tr, style: TextStyle(fontSize: 20, color: Colors.white)),
//                               SizedBox(height: 5),
//                               Text( "${ profileController.profileModel!.balance != null ?  PriceConverterHelper.convertPrice(profileController.profileModel!.balance) : "0.00" }", style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold)),
                          
//                                    const SizedBox(height: 20),
//                         Row(children: [
              
//                           EarningWidget(

//                             title: 'today'.tr,
//                             amount: profileController.profileModel?.todaysEarning,
//                           ),
//                           Container(height: 30, width: 1, color: Theme.of(context).cardColor),
              
//                           EarningWidget(
//                             title: 'this_week'.tr,
//                             amount: profileController.profileModel?.thisWeekEarning,
//                           ),
//                           Container(height: 30, width: 1, color: Theme.of(context).cardColor),
              
//                           EarningWidget(
//                             title: 'this_month'.tr,
//                             amount: profileController.profileModel?.thisMonthEarning,
//                           ),
              
//                         ]),


//                         profileController.profileModel != null ? Padding(
//                           padding: const EdgeInsets.all(15),
//                           child: Container(
                            
//                                           height: 115, width: MediaQuery.of(context).size.width,
//                                           padding: const EdgeInsets.all(10),
//                                           decoration: BoxDecoration(
//                                             borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//                                             color: Theme.of(context).cardColor.withOpacity(0.05),
//                                             border: Border.all(width: 2, color: Theme.of(context).primaryColor.withOpacity(0.1)),
//                                           ),
//                                           child: Column(
//                                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                             crossAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//                                             children: [
                          
//                                               Row(mainAxisAlignment: profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center, children: [
                          
//                                                 Text(PriceConverterHelper.convertPrice(profileController.profileModel!.cashInHands), style: PoppinsBold.copyWith(fontSize: 30,color: Theme.of(context).cardColor)),
//                                                 const SizedBox(width: Dimensions.paddingSizeSmall),
                          
                          
//                                               ]),
                          
//                                               Row(
//                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                 children: [
//                                                   Text('cash_in_your_hand'.tr, style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).cardColor )),

                                                  
//                                                 Column(
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             (profileController.profileModel!.cashInHands! > 0 && profileController.profileModel!.earnings == 1) ? CustomButtonWidget(
//                               width: 110, height: 40,
//                               buttonText: 'view_details'.tr,
//                               backgroundColor: Theme.of(context).primaryColor,
//                               onPressed: () => Get.toNamed(RouteHelper.getCashInHandRoute()),
//                             ) : const SizedBox(),
//                           ],
//                                                 ),
//                                                 ],
//                                               ),
                          
//                                             ],
//                                           ),
//                                         ),
//                         ) : const CashInHandCardShimmer(),

              
//                             ],
//                           ),
//                         )
//                         ,
//                       ),
//                       // Curve Overlay
//                       Positioned(
//                         bottom: -1, // Slight overlap to hide the black line
//                         left: 0,
//                         right: 0,
//                         child: Container(
//                           height: 10, // Height of the curve
//                           decoration: const BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(20),
//                               topRight: Radius.circular(20),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             }
//           ),
//           // Remaining content
//        GetBuilder<ProfileController>(builder: (profileController) {
//               return SliverToBoxAdapter(
              
//                 child: ClipRRect(
//                   // borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
//                   child: SingleChildScrollView(
//                 physics: AlwaysScrollableScrollPhysics(), 
//                     child: Container(
//                       decoration: const BoxDecoration(
//                         color: Colors.white,
//                       ),
//                       height: 1000,
                    
//                       child: Column(
//                         children: [
//                            GetBuilder<OrderController>(builder: (orderController) {
//                         bool hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList!.isNotEmpty;
//                         bool hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList!.length > 1;
//                         return Padding(
//                           padding: const EdgeInsets.all(0),
//                           child: Column(children: [
//                             hasActiveOrder ? TitleWidget(
//                               title: 'active_order'.tr, onTap: hasMoreOrder ? () {
//                                 Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: const RunningOrderScreen());
//                               } : null,
//                             ) : const SizedBox(),
//                             SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeExtraSmall : 0),
//                             orderController.currentOrderList == null ? OrderShimmerWidget(
//                               isEnabled: orderController.currentOrderList == null,
//                             ) : orderController.currentOrderList!.isNotEmpty ? OrderWidget(
//                               orderModel: orderController.currentOrderList![0], isRunningOrder: true, orderIndex: 0,
//                             ) : const SizedBox(),
//                             // SizedBox(height: hasActiveOrder ? Dimensions.paddingSizeDefault : 0),
//                           ]),
//                         );
//                       }),
                                  
                                  
                                  
//                          TitleWidget(title: 'orders'.tr),
//                     const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                                  
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(children: [
                                    
//                         Expanded(child: CountCardWidget(
//                           title: 'todays_orders'.tr, backgroundColor: Theme.of(context).secondaryHeaderColor, height: 100,
//                           value: profileController.profileModel?.todaysOrderCount.toString(),
//                         )),
//                         const SizedBox(width: Dimensions.paddingSizeSmall),
                                    
//                         Expanded(child: CountCardWidget(
//                           title: 'this_week_orders'.tr, backgroundColor: Theme.of(context).colorScheme.error, height: 100,
//                           value: profileController.profileModel?.thisWeekOrderCount.toString(),
//                         )),
                                    
//                       ]),
//                     ),
//                     const SizedBox(height: Dimensions.paddingSizeSmall),
//                       CountCardWidget(
//                                     title: 'total_orders'.tr, backgroundColor: Theme.of(context).primaryColor, height: 100,
                    
//                                     value: profileController.profileModel?.orderCount.toString(),
//                                   ),
                                  
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }
//           ),
//         ],
//       ),
//         // CustomScrollView(
//         //   physics: const AlwaysScrollableScrollPhysics(),
//         //   slivers: [
//         //     // Fixed height container as a persistent header
//         //     SliverPersistentHeader(
//         //       pinned: true,
//         //       delegate: _FixedHeightHeaderDelegate(
//         //         child: 
                
//         //          Column(
//         //           children: [
//         //               Container(
//         //                 width: MediaQuery.of(context).size.width,
//         //                 height: 300,
//         //                 color: Theme.of(context).primaryColor,
//         //               ),

                     
//         //           ],
//         //         )
               
//         //       ),
//         //     ),
//         //     // Remaining content
//         //     SliverToBoxAdapter(

//         //       child:  Container(
//         //                 width: MediaQuery.of(context).size.width,
//         //                 decoration: const BoxDecoration(
//         //                    color: Colors.white,
//         //                    borderRadius: BorderRadius.only(
//         //                     topLeft: Radius.circular(20),
//         //                     topRight: Radius.circular(20),  
//         //                    )
//         //                 ),
//         //                 height: 1000,
                       
//         //               ),
//         //     ),
//         //   ],
//         // ),
     
     
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _loadData() async {
    // Your data loading logic
    Get.find<OrderController>().getIgnoreList();
    Get.find<OrderController>().removeFromIgnoreList();
    await Get.find<ProfileController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    if (GetPlatform.isAndroid) {
      bool isBatteryOptimizationDisabled = (await DisableBatteryOptimization.isBatteryOptimizationDisabled) ?? true;
      if (!isBatteryOptimizationDisabled) {
        DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
      }

    }

      Get.find<OrderController>().getCurrentOrders();
 Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getCurrentOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        leading: SizedBox(),
        leadingWidth: 0,
        backgroundColor: Theme.of(context).primaryColor,
        titleSpacing: 0,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(
            'Uolo'.tr,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Theme.of(context).cardColor,
              fontSize: 25,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
          actions: [
          IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              return Stack(children: [

                Icon(Icons.notifications, size: 25, color: Theme.of(context).cardColor),

                notificationController.hasNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : const SizedBox(),

              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
          // GetBuilder<ProfileController>(builder: (profileController) {
          //   return GetBuilder<OrderController>(builder: (orderController) {
          //     return (profileController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
                
          //       width: 75, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
          //       activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
          //       value: profileController.profileModel!.active == 1, onToggle: (bool isActive) async {
          //         if(!isActive && orderController.currentOrderList!.isNotEmpty) {
          //           showCustomSnackBar('you_can_not_go_offline_now'.tr);
          //         }else {
          //           if(!isActive) {
          //             Get.dialog(ConfirmationDialogWidget(
          //               icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
          //               onYesPressed: () {
          //                 Get.back();
          //                 profileController.updateActiveStatus();
          //               },
          //             ));
          //           }else {
          //             LocationPermission permission = await Geolocator.checkPermission();
          //             if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
          //                 || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
          //               if(GetPlatform.isAndroid) {
          //                 Get.dialog(ConfirmationDialogWidget(
          //                   icon: Images.locationPermission,
          //                   iconSize: 200,
          //                   hasCancel: false,
          //                   description: 'this_app_collects_location_data'.tr,
          //                   onYesPressed: () {
          //                     Get.back();
          //                     _checkPermission(() => profileController.updateActiveStatus());
          //                   },
          //                 ), barrierDismissible: false);
          //               }else {
          //                 _checkPermission(() => profileController.updateActiveStatus());
          //               }
          //             }else {
          //               profileController.updateActiveStatus();
          //             }
          //           }
          //         }
          //       },
          //     ) : const SizedBox();
          //   });
          // }),
          // const SizedBox(width: Dimensions.paddingSizeSmall),
        ],
   
   
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: GetBuilder<ProfileController>(builder: (profileController) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  GetBuilder<ProfileController>(builder: (profileController) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 300,
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // SizedBox(height: 20,),
                                Text('Balance'.tr, style: const TextStyle(fontSize: 20, color: Colors.white)),
                                const SizedBox(height: 5),
                                Text(
                                  profileController.profileModel?.balance != null
                                      ? PriceConverterHelper.convertPrice(profileController.profileModel!.balance!)
                                      : "0.00",
                                  style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    EarningWidget(
                                      title: 'today'.tr,
                                      amount: profileController.profileModel?.todaysEarning,
                                    ),
                                    Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                                    EarningWidget(
                                      title: 'this_week'.tr,
                                      amount: profileController.profileModel?.thisWeekEarning,
                                    ),
                                    Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                                    EarningWidget(
                                      title: 'this_month'.tr,
                                      amount: profileController.profileModel?.thisMonthEarning,
                                    ),
                                  ],
                                ),
                               
                        SizedBox(height: 50,),
                               Row(
                                 mainAxisAlignment:   MainAxisAlignment.spaceBetween,
                                 children: [
                                   Column(
                                    crossAxisAlignment:CrossAxisAlignment.start ,
                                     children: [
                                       Text("Status : ${profileController.profileModel?.active == 1 ? 'Online' : 'Offline'}", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold
                                       ),),

                                      Text(
          profileController.profileModel?.active == 1
              ? "Open For Delivery"
              : "Not Available",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 16, // Adjusted for a cleaner look
          ),
        ),


             
                                 ],
                               ),
                                                      GetBuilder<ProfileController>(builder: (profileController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (profileController.profileModel != null && orderController.currentOrderList != null) ? FlutterSwitch(
                
                // width: 75, height: 30, valueFontSize: Dimensions.fontSizeExtraSmall, showOnOff: true,
                // activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                // value: profileController.profileModel!.active == 1, 
                
                 width: 70, // Increased size
                height: 30, // Increased size
                toggleSize: 25, // Increased toggle size
                valueFontSize: 10.0,
                showOnOff: true,
                activeText: 'Online',
                inactiveText: 'Offline',
                activeColor: const Color.fromARGB(255, 4, 117, 63),
                inactiveColor: const Color.fromARGB(255, 245, 32, 32),
                value: profileController.profileModel!.active == 1,
                onToggle: (bool isActive) async {
                  if(!isActive && orderController.currentOrderList!.isNotEmpty) {
                    showCustomSnackBar('you_can_not_go_offline_now'.tr);
                  }else {
                    if(!isActive) {
                      Get.dialog(ConfirmationDialogWidget(
                        // icon: '', 
                        description: 'are_you_sure_to_offline'.tr,
                        onYesPressed: () {
                          Get.back();
                          profileController.updateActiveStatus();
                        },
                      ));
                    }else {
                      LocationPermission permission = await Geolocator.checkPermission();
                      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
                          || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
                        if(GetPlatform.isAndroid) {
                          Get.dialog(ConfirmationDialogWidget(
                            icon: Images.locationPermission,
                            iconSize: 200,
                            hasCancel: false,
                            description: 'this_app_collects_location_data'.tr,
                            onYesPressed: () {
                              Get.back();
                              _checkPermission(() => profileController.updateActiveStatus());
                            },
                          ), barrierDismissible: false);
                        }else {
                          _checkPermission(() => profileController.updateActiveStatus());
                        }
                      }else {
                        profileController.updateActiveStatus();
                      }
                    }
                  }
                },
              ) : const SizedBox();
            });
          }),
                               ])



              
                ],
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -1,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 10,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  GetBuilder<OrderController>(builder: (orderController) {
                         bool hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList!.length > 1;
                    return Container(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: [
                    //       if (orderController.currentOrderList?.isNotEmpty ?? false)
                    //         Padding(
                    //           padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault, right: Dimensions.paddingSizeDefault, ),
                    //           child: TitleWidget(
                    //             title: 'active_order'.tr,
                    //              onTap: hasMoreOrder ? () {
                    //   // Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: const RunningOrderScreen());
                    //   //  Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: const OrderRequestScreen(
                    //   //   onTap: null,
                    //   //  ));
                    //   Get.to(OrderRequestScreen(onTap: (){},));
                    // } : null,
                    //           ),
                    //         ),
                    //       if (orderController.currentOrderList != null)
                    //         OrderWidget(
                    //           orderModel: orderController.currentOrderList!.first,
                    //           isRunningOrder: true,
                    //           orderIndex: 0,
                    //         ),
                          // TitleWidget(title: 'orders'.tr),


                          // Container(
                          //   width:  MediaQuery.of(context).size.width  ,
                          //   height: 250,
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.all(Radius.circular(10)) ,
                          //     boxShadow: BoxShadow() 
                          //   ),
                            
                          // ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 200,
                              
                              decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(197, 66, 6, 96), Color.fromARGB(196, 47, 129, 237)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
                              // BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.all(Radius.circular(20)),
                              //   // gradient: LinearGradient(
                              //   //   colors: [Theme.of(context).primaryColor, Colors.lightBlue],
                              //   //   begin: Alignment.topLeft,
                              //   //   end: Alignment.bottomRight,
                              //   // ),
                              //   boxShadow: [
                              //     BoxShadow(
                              //       color: Colors.black26,
                              //       blurRadius: 10.0,
                              //       spreadRadius: 2.0,
                              //       offset: Offset(0, 4), 
                              //     ),
                              //   ],
                              // ),
                              padding: EdgeInsets.all(16.0), 
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        Text("Orders", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),),
                                      ],
                                    ),
                                  ),

                SizedBox(height: 40,),
                                   Padding(
                                     padding: const EdgeInsets.only(left: 20,right: 20),
                                     child: Row(
                                      // crossAxisAlignment: cr,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Text("Today", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                                            Text("${ profileController.profileModel?.todaysOrderCount.toString()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("This Week", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),

                                            Text("${ profileController.profileModel?.thisWeekOrderCount.toString()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Total", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),

                                            Text("${ profileController.profileModel?.orderCount.toString()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
                                          ],
                                        ),
                                      ],
                                                                       ),
                                   ),
                                ],
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: CountCardWidget(
                          //           title: 'todays_orders'.tr,
                          //           backgroundColor: Theme.of(context).primaryColor,
                          //           height: 100,
                          //           value: profileController.profileModel?.todaysOrderCount.toString(),
                          //         ),
                          //       ),
                          //       const SizedBox(width: Dimensions.paddingSizeSmall),
                          //       Expanded(
                          //         child: CountCardWidget(
                          //           title: 'this_week_orders'.tr,
                          //           backgroundColor: Theme.of(context).primaryColor,
                          //           height: 100,
                          //           value: profileController.profileModel?.thisWeekOrderCount.toString(),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          // Padding(
                          //   // padding: const EdgeInsets.all(8.0),
                          //   padding: const EdgeInsets.only(left: 8, right: 8, ),
                          //   child: CountCardWidget(
                          //     title: 'total_orders'.tr,
                          //     backgroundColor: Theme.of(context).primaryColor,
                          //     height: 100,
                          //     value: profileController.profileModel?.orderCount.toString(),
                          //   ),
                          // ),

                           if (profileController.profileModel != null)
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: 170,
                                      width: MediaQuery.of(context).size.width,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                        color: Theme.of(context).primaryColor.withOpacity(1),
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                        
                                                Text(
                                                  PriceConverterHelper.convertPrice(profileController.profileModel!.cashInHands!),
                                                  style: PoppinsBold.copyWith(fontSize: 30, color: Theme.of(context).cardColor),
                                                ),
                                        
                                                if (profileController.profileModel!.cashInHands! > 0 &&
                                                    profileController.profileModel!.earnings == 1)
                                                  CustomButtonWidget(
                                                    width: 110,
                                                    height: 40,
                                                    buttonText: 'view_details'.tr,
                                                    backgroundColor: Theme.of(context).cardColor.withOpacity(0.2),
                                                    onPressed: () => Get.toNamed(RouteHelper.getCashInHandRoute()),
                                                  ),
                                         
                                              ],
                                            ),
                                            Text(
                                              'cash_in_your_hand'.tr,
                                              style: PoppinsMedium.copyWith(
                                                fontSize: Dimensions.fontSizeLarge,
                                                color: Theme.of(context).cardColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else 
                                 const CashInHandCardShimmer(),

                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}


class _FixedHeightHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FixedHeightHeaderDelegate({required this.child});

  @override
  double get minExtent => 300;

  @override
  double get maxExtent => 300;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}


  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied /*|| (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)*/) {
      Get.dialog(CustomAlertDialogWidget(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialogWidget(description: permission == LocationPermission.whileInUse ? 'you_denied'.tr : 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        // checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }


class CashInHandCardShimmer extends StatelessWidget {
  const CashInHandCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: true,
      child: Container(
        height: 120, width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Colors.grey[300],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [

          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(height: 20, width: 150, color: Colors.white),
            const SizedBox(width: Dimensions.paddingSizeSmall),
    
            Container(height: 40, width: 100, color: Colors.white),
          ]),
    
          Row(children: [
            Container(height: 15, width: 200, color: Colors.white),
          ]),
    
        ]),
      ),
    );
  }
}











// class BottomWaveClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     // Start from the bottom-left corner
//     path.lineTo(0.0, size.height);

//     // Smooth curve on the left edge with a rounded corner
//     path.quadraticBezierTo(30, size.height - 30, 60, size.height - 60); // Smoother curve
//     path.quadraticBezierTo(90, size.height - 90, 120, size.height - 60); // Additional smoothness

//     // Straight line towards the middle
//     path.lineTo(size.width - 120, size.height - 60);
    
//     // Smooth curve on the right edge with a rounded corner
//     path.quadraticBezierTo(size.width - 90, size.height - 90, size.width - 60, size.height - 60); // Smoother curve
//     path.quadraticBezierTo(size.width - 30, size.height - 30, size.width, size.height); // Additional smoothness

//     // Close the path to the top-right corner
//     path.lineTo(size.width, 0.0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }


// class BottomRoundedClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     Path path = Path();

//     // Start from the top-left corner
//     path.lineTo(0, size.height - 20);

//     // Bottom-left corner curve
//     path.quadraticBezierTo(0, size.height, 20, size.height);

//     // Bottom edge
//     path.lineTo(size.width - 20, size.height);

//     // Bottom-right corner curve
//     path.quadraticBezierTo(size.width, size.height, size.width, size.height - 20);

//     // Right edge back to the top-right corner
//     path.lineTo(size.width, 0);

//     // Close the path
//     path.lineTo(0, 0);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) {
//     return false;
//   }
// }


class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    // Start from the bottom-left corner
    path.lineTo(0.0, size.height);

    // Smooth curve on the left edge with a rounded corner
    path.quadraticBezierTo(30, size.height - 20, 60, size.height - 30); // Smoother curve
    path.quadraticBezierTo(90, size.height - 40, 120, size.height - 30); // Additional smoothness

    // Straight line towards the middle
    path.lineTo(size.width - 120, size.height - 30);
    
    // Smooth curve on the right edge with a rounded corner
    path.quadraticBezierTo(size.width - 90, size.height - 40, size.width - 60, size.height - 30); // Smoother curve
    path.quadraticBezierTo(size.width - 30, size.height - 20, size.width, size.height); // Additional smoothness

    // Close the path to the top-right corner
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}










