import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_delivery/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart_delivery/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_delivery/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_delivery/features/address/controllers/address_controller.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_delivery/helper/date_converter_helper.dart';
import 'package:sixam_mart_delivery/helper/price_converter_helper.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_delivery/features/order/screens/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/features/order/screens/order_location_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderRequestWidget2 extends StatelessWidget {
  final OrderModel orderModel;
  final int index;
  final bool fromDetailsPage;
  final Function onTap;
  const OrderRequestWidget2({super.key, required this.orderModel, required this.index, required this.onTap, this.fromDetailsPage = false});

  @override
  Widget build(BuildContext context) {
    bool parcel = orderModel.orderType == 'parcel';
    double distance = Get.find<AddressController>().getRestaurantDistance(
      LatLng(double.parse(parcel ? orderModel.deliveryAddress?.latitude ?? '0' : orderModel.storeLat ?? '0'), double.parse(parcel ? orderModel.deliveryAddress?.longitude ?? '0' : orderModel.storeLng ?? '0')),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
      ),
      child: GetBuilder<OrderController>(builder: (orderController) {
        return Column(children: [

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(children: [

              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Container(
                  height: 45, width: 45, alignment: Alignment.center,
                  decoration: parcel ? BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ) : null,
                  child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: CustomImageWidget(
                    image: parcel ? '${orderModel.parcelCategory != null ? orderModel.parcelCategory!.imageFullUrl : ''}' : orderModel.storeLogoFullUrl ?? '',
                    height: parcel ? 30 : 45, width: parcel ? 30 : 45, fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(
                    parcel ? orderModel.parcelCategory != null ? orderModel.parcelCategory!.name ?? ''
                      : '' : orderModel.storeName ?? 'no_store_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    parcel ? 'parcel'.tr : '${orderModel.detailsCount} ${orderModel.detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                    style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    parcel ? orderModel.parcelCategory != null ? orderModel.parcelCategory!.description ?? '' : '' : orderModel.storeAddress ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ])),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                    children: [

                  Text(
                    '${DateConverterHelper.timeDistanceInMin(orderModel.createdAt!)} ${'mins_ago'.tr}',
                    style: PoppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  orderModel.deliveryAddress != null ? Container(
                    width: 110,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    child: Text(
                      '${distance > 1000 ? '1000+' : distance.toStringAsFixed(2)} ${'km_away_from_you'.tr}',
                      style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                    ),
                  ) : Container(
                    height: 20, width: 30,
                    color: Colors.green,
                  ),
                ]),
              ]),

              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 5,
                  margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                  child: ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                        height: 5, width: 10, color: Colors.blue,
                      );
                    },
                  ),
                ),
              ),

              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(Images.dmAvatar, height: 45, width: 45, fit: BoxFit.contain),
                ),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Text(
                    'deliver_to'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style:  PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Text(
                    parcel ? orderModel.receiverDetails?.address ?? '' : orderModel.deliveryAddress?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                  ),
                ])),

                InkWell(
                  onTap: () => Get.to(()=> OrderLocationScreen(orderModel: orderModel, orderController: orderController, index: index, onTap: onTap,)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                    decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text(
                      'Direction'.tr,
                      style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                    ),
                  ),
                ),
              ]),

            ]),
          ),

          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).disabledColor.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusDefault)),
            ),
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            margin: const EdgeInsets.all(0.2),
            child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [

              Expanded(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [

                  (Get.find<SplashController>().configModel!.showDmEarning! && Get.find<ProfileController>().profileModel != null
                      && Get.find<ProfileController>().profileModel!.earnings == 1) ? Text(
                    PriceConverterHelper.convertPrice(orderModel.originalDeliveryCharge! + orderModel.dmTips!),
                    style: PoppinsBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  ) : const SizedBox(),
                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    child: Text(
                      '${'payment'.tr} - ${orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : orderModel.paymentMethod == 'wallet' ? 'wallet'.tr : 'digitally_paid'.tr}',
                      style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                    ),
                  ),
                ]),
              ),

              Expanded(
                child: Row(children: [
                  Expanded(child: TextButton(
                    onPressed: () => Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, title: 'are_you_sure_to_ignore'.tr,
                      description: parcel ? 'you_want_to_ignore_this_delivery'.tr : 'you_want_to_ignore_this_order'.tr,
                      onYesPressed: ()  {
                        if(Get.isSnackbarOpen){
                          Get.back();
                        }
                        orderController.ignoreOrder(index);
                        Get.back();
                        showCustomSnackBar('order_ignored'.tr, isError: false);
                      },
                    ), barrierDismissible: false),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        side: BorderSide(width: 1, color: Theme.of(context).disabledColor),
                      ),
                    ),
                    child: Text('ignore'.tr, textAlign: TextAlign.center, style: PoppinsRegular.copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Expanded(child: CustomButtonWidget(
                    height: 40,
                    radius: Dimensions.radiusDefault,
                    buttonText: 'accept'.tr,
                    fontSize: Dimensions.fontSizeDefault,
                    onPressed: () => Get.dialog(ConfirmationDialogWidget(
                      icon: Images.warning, title: 'are_you_sure_to_accept'.tr,
                      description: parcel ? 'you_want_to_accept_this_delivery'.tr : 'you_want_to_accept_this_order'.tr,
                      onYesPressed: () {
                        orderController.acceptOrder(orderModel.id, index, orderModel).then((isSuccess) {
                          if(isSuccess) {
                            onTap();
                            orderModel.orderStatus = (orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'confirmed')
                                ? 'accepted' : orderModel.orderStatus;
                            Get.toNamed(
                              RouteHelper.getOrderDetailsRoute(orderModel.id),
                              arguments: OrderDetailsScreen(
                                orderId: orderModel.id, isRunningOrder: true, orderIndex: orderController.currentOrderList!.length-1,
                              ),
                            );
                          }else {
                            Get.find<OrderController>().getLatestOrders();
                          }
                        });
                      },
                    ), barrierDismissible: false),
                  )),
                ]),
              ),

            ]),
          ),

        ]);
      }),
    );
  }
}
















class OrderWidget2 extends StatefulWidget {
  final OrderModel orderModel;
  final int index;
  final bool fromDetailsPage;
  final Function onTap;
  const OrderWidget2({super.key, required this.orderModel, required this.index, required this.onTap, this.fromDetailsPage = false});

  @override
  State<OrderWidget2> createState() => _OrderWidget2State();
}
  
class _OrderWidget2State extends State<OrderWidget2> {


 double? deliveryCharge = 0;
              double itemsPrice = 0;
              double? discount = 0;
              double? couponDiscount = 0;
              double? tax = 0;
              double addOns = 0;
              double? dmTips = 0;
              double additionalCharge = 0;
              double extraPackagingAmount = 0;
              double referrerBonusAmount = 0;
              bool? isPrescriptionOrder = false;
              bool? taxIncluded = false;
              bool showChatPermission = true;
               double subTotal = 0;
               double  total = 0;


   @override
  void initState() {
    super.initState();

    Future<OrderDetailsModel> data = Get.find<OrderController>().getOrderDetailseachitem(widget.orderModel.id);

//     data.then((value) {
//       print("THE DATA IN order id ${value.id} IS ${value}");

//  deliveryCharge = widget.orderModel.deliveryCharge;
   
//        dmTips = widget.orderModel.dmTips;
//        isPrescriptionOrder = widget.orderModel.prescriptionOrder;
//        discount = widget.orderModel.storeDiscountAmount! + widget.orderModel.flashAdminDiscountAmount! + widget.orderModel.flashStoreDiscountAmount!;
//        tax = widget.orderModel.totalTaxAmount;
//        taxIncluded = widget.orderModel.taxStatus;
//        additionalCharge = widget.orderModel.additionalCharge!;
//        extraPackagingAmount = widget.orderModel.extraPackagingAmount!;
//        referrerBonusAmount = widget.orderModel.referrerBonusAmount!;
//        couponDiscount = widget.orderModel.couponDiscountAmount;
  

//        if(isPrescriptionOrder!){
//                   double orderAmount = widget.orderModel.orderAmount ?? 0;
//                   itemsPrice = (orderAmount + discount!) - ((taxIncluded! ? 0 : tax!) + deliveryCharge! + additionalCharge) - dmTips!;
//                 }else {
//                   // for (OrderDetailsModel orderDetails in value.) {
//                     for (AddOn addOn in value.addOns!) {
//                       addOns = addOns + (addOn.price! * addOn.quantity!);
//                     }
//                     itemsPrice = itemsPrice + (value.price! * value.quantity!);
//                   }

//        double subTotal = itemsPrice + addOns;
//               double total = itemsPrice + addOns - discount!+ (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount;

    
//      print("---------------------------------------------------THE TOTAL IS ${total}-----------------------------------------------------------------------");

//      setState(() {
//         double total = itemsPrice + addOns - discount!+ (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount;
//      });
//     });
 
 data.then((value) {
  print("THE DATA IN order id ${value.id} IS ${value}");

  deliveryCharge = widget.orderModel.deliveryCharge;
  dmTips = widget.orderModel.dmTips;
  isPrescriptionOrder = widget.orderModel.prescriptionOrder;
  discount = widget.orderModel.storeDiscountAmount! + widget.orderModel.flashAdminDiscountAmount! + widget.orderModel.flashStoreDiscountAmount!;
  tax = widget.orderModel.totalTaxAmount;
  taxIncluded = widget.orderModel.taxStatus;
  additionalCharge = widget.orderModel.additionalCharge!;
  extraPackagingAmount = widget.orderModel.extraPackagingAmount!;
  referrerBonusAmount = widget.orderModel.referrerBonusAmount!;
  couponDiscount = widget.orderModel.couponDiscountAmount;

  if (isPrescriptionOrder!) {
    double orderAmount = widget.orderModel.orderAmount ?? 0;
    itemsPrice = (orderAmount + discount!) - ((taxIncluded! ? 0 : tax!) + deliveryCharge! + additionalCharge) - dmTips!;
  } else {
    for (AddOn addOn in value.addOns!) {
      addOns = addOns + (addOn.price! * addOn.quantity!);
    }
    itemsPrice = itemsPrice + (value.price! * value.quantity!);
  }

  subTotal = itemsPrice + addOns; 
  total = itemsPrice + addOns - discount! + (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount;

  print("---------------------------------------------------THE TOTAL IS ${total}-----------------------------------------------------------------------");

  setState(() {

  });
});
  }




  @override
  Widget build(BuildContext context) {
    bool parcel = widget.orderModel.orderType == 'parcel';
    double distance = Get.find<AddressController>().getRestaurantDistance(
      LatLng(double.parse(parcel ? widget.orderModel.deliveryAddress?.latitude ?? '0' : widget.orderModel.storeLat ?? '0'), double.parse(parcel ? widget.orderModel.deliveryAddress?.longitude ?? '0' : widget.orderModel.storeLng ?? '0')),
    );
      
      
    return InkWell(
      onTap: () => Get.toNamed(RouteHelper.getOrderDetailsRoute(widget.orderModel.id), arguments: OrderDetailsScreen(orderId: widget.orderModel.id, isRunningOrder: true, orderIndex: widget.index)),
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
        ),
        child: GetBuilder<OrderController>(builder: (orderController) {
          return Column(children: [
      
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                                crossAxisAlignment: CrossAxisAlignment.start ,
                                 children: [
                                   Column(
                                    crossAxisAlignment: CrossAxisAlignment.start ,
                                     children: [
                                      Text("ORDER ID : ${widget.orderModel.id}",style: TextStyle(
                                        fontWeight:  FontWeight.bold
                                      ),),
                                       Text("${distance > 1000 ? '1000+' : distance.toStringAsFixed(2)} ${'Km To Pickup Point'.tr}",style: TextStyle(
                                         fontSize: Dimensions.fontSizeSmall,
                                         color: Theme.of(context).disabledColor.withOpacity(0.5),
                                         fontWeight: FontWeight.w300
                                       ),),
                                     ],
                                   ),
                               
                             
                               
                                                 Column(
                                                  crossAxisAlignment: CrossAxisAlignment.end ,
                                                   children: [
                                                    
                                    (Get.find<SplashController>().configModel!.showDmEarning! && Get.find<ProfileController>().profileModel != null
                                                     && Get.find<ProfileController>().profileModel!.earnings == 1) ? Text(
                                                  //  PriceConverterHelper.convertPrice(widget.orderModel.originalDeliveryCharge! + widget.orderModel.dmTips!),

                                                  total.toString(),
                                                   style: PoppinsBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                                                 ) : const SizedBox(),
      
                                                     Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      child: Text(
                        '${'payment'.tr} - ${widget.orderModel.paymentMethod == 'cash_on_delivery' ? 'cod'.tr : widget.orderModel.paymentMethod == 'wallet' ? 'wallet'.tr : 'digitally_paid'.tr}',
                        style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).disabledColor),
                      ),
                    ),
      
                  
                                                   ]
                                                 )
                                 ],
                               ),
                             ),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      
                  Container(
                    height: 45, width: 45, alignment: Alignment.center,
                    decoration: parcel ? BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).primaryColor.withOpacity(0.2),
                    ) : null,
                    child: ClipRRect(borderRadius: BorderRadius.circular(100), child: CustomImageWidget(
                      image: parcel ? '${widget.orderModel.parcelCategory != null ? widget.orderModel.parcelCategory!.imageFullUrl : ''}' : widget.orderModel.storeLogoFullUrl ?? '',
                      height: parcel ? 30 : 45, width: parcel ? 30 : 45, fit: BoxFit.cover,
                    )),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
      
                  Expanded(child: Row(
                    crossAxisAlignment:CrossAxisAlignment.start ,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // Text(
                        //   parcel ? orderModel.parcelCategory != null ? orderModel.parcelCategory!.name ?? ''
                        //     : '' : orderModel.storeName ?? 'no_store_data_found'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                        //   style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall),
                        // ),
                      
                        RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Colors.black), // Default style
                          children: [
                      
                            TextSpan( text: "PickUp:",style: TextStyle(
                              color:  Theme.of(context).disabledColor
                            ) ),
                            TextSpan(
                              text: parcel 
                                ? (widget.orderModel.parcelCategory != null 
                                    ? widget.orderModel.parcelCategory!.name ?? '' 
                                    : '') 
                                : (widget.orderModel.storeName ?? 'no_store_data_found'.tr),
                              style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall), // Style for the main text
                            ),
                            // You can add more TextSpan widgets here for additional styling if needed
                          ],
                        ),
                      ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      
                        Text(
                          parcel ? 'parcel'.tr : '${widget.orderModel.detailsCount} ${widget.orderModel.detailsCount! > 1 ? 'items'.tr : 'item'.tr}',
                          style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      
                        Text(
                          parcel ? widget.orderModel.parcelCategory != null ? widget.orderModel.parcelCategory!.description ?? '' : '' : widget.orderModel.storeAddress ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
      
                          Row(
                            children: [
                              Padding(
                                                   padding: const EdgeInsets.only(left: 0),
                                                   child: CustomInkWellWidget(child: Padding(
                                                     padding: const EdgeInsets.all(5),
                                                     child: Image.asset("assets/image/phone.png",height: 25,),
                                                   ), onTap: () async {
                                                     final phone = parcel ? widget.orderModel.deliveryAddress!.contactPersonNumber : widget.orderModel.storePhone;
                                          if(await canLaunchUrlString('tel:$phone')) {
                                                launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
                                              }else {
                                                showCustomSnackBar('invalid_phone_number_found');
                                              }
                                      
                                                   },  ),
                                                 ),
      
                                                   Padding(
                      padding: const EdgeInsets.only(left: 5),
                       child: CustomInkWellWidget(child: Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: Image.asset("assets/image/message.png",height: 25,),
                       ),onTap: () {
                         Get.toNamed(RouteHelper.getChatRoute(
                          notificationBody: NotificationBodyModel(
                            orderId: widget.orderModel.id, vendorId: orderController.orderDetailsModel![0].vendorId,
                          ),
                          user: User(
                            id: widget.orderModel.storeId, fName: widget.orderModel.storeName,
                            imageFullUrl: widget.orderModel.storeLogoFullUrl,
                          ),
                        ));
                       },),
                     )
                            ],
                          ),
      
                   
                      ]),
      
                     
                    ],
                  )),
      
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.end,
                  //     children: [
      
                  //   Text(
                  //     '${DateConverterHelper.timeDistanceInMin(orderModel.createdAt!)} ${'mins_ago'.tr}',
                  //     style: PoppinsMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeSmall),
                  //   ),
                  //   const SizedBox(height: Dimensions.paddingSizeSmall),
      
                  //   orderModel.deliveryAddress != null ? Container(
                  //     width: 110,
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor.withOpacity(0.15),
                  //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  //     ),
                  //     padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                  //     child: Text(
                  //       '${distance > 1000 ? '1000+' : distance.toStringAsFixed(2)} ${'km_away_from_you'.tr}',
                  //       style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall), textAlign: TextAlign.center,
                  //     ),
                  //   ) : Container(
                  //     height: 20, width: 30,
                  //     color: Colors.green,
                  //   ),
                  // ]),
      
                    (parcel || widget.orderModel.orderStatus != 'picked_up') ?   InkWell(
                    onTap: () async {
                       String url;
                if(parcel && (widget.orderModel.orderStatus == 'picked_up')) {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.receiverDetails!.latitude}'
                      ',${widget.orderModel.receiverDetails!.longitude}&mode=d';
                }else if(parcel) {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.deliveryAddress!.latitude}'
                      ',${widget.orderModel.deliveryAddress!.longitude}&mode=d';
                }else if(widget.orderModel.orderStatus == 'picked_up') {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.deliveryAddress!.latitude}'
                      ',${widget.orderModel.deliveryAddress!.longitude}&mode=d';
                }else {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.storeLat ?? '0'}'
                      ',${widget.orderModel.storeLng ?? '0'}&mode=d';
                }
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                } else {
                  showCustomSnackBar('${'could_not_launch'.tr} $url');
                }
                    },
                    // Get.to(()=> OrderLocationScreen(orderModel: orderModel, orderController: orderController, index: index, onTap: onTap,)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color:  Colors.blue  , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.directions,color: Theme.of(context).cardColor,size: 15,),
                          SizedBox(width: 5,),
                          Text(
                            'Direction'.tr,
                            style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                          ),
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                ]),
      
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: 5,
                    margin: const EdgeInsets.only(left: Dimensions.paddingSizeLarge),
                    child: ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
                          height: 5, width: 10,
                          decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor.withOpacity(0.9),
                             borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          ),
      
                        );
                      },
                    ),
                  ),
                ),
      
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(Images.dmAvatar, height: 45, width: 45, fit: BoxFit.contain),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
      
                  Expanded(child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      
                        Text(
                          'Drop off'.tr, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style:  PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).disabledColor  ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                         Text(
                          parcel ? widget.orderModel.receiverDetails?.contactPersonName ?? '' : widget.orderModel.deliveryAddress?.contactPersonName ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                        Text(
                          parcel ? widget.orderModel.receiverDetails?.address ?? '' : widget.orderModel.deliveryAddress?.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                      
                        
                                //          Row(
                                //           crossAxisAlignment: CrossAxisAlignment.start ,
                                //           mainAxisAlignment: MainAxisAlignment.start,
                                //            children: [
                                //              IconButton(onPressed: (){}, icon: Image.asset("assets/image/message.png",height: 20,),
                                //              padding: EdgeInsets.all(0),),
                                //                IconButton(onPressed: () async{
                                //   final phone = parcel ? orderModel.receiverDetails!.contactPersonNumber : orderModel.deliveryAddress!.contactPersonNumber;
                                //     if(await canLaunchUrlString('tel:$phone')) {
                                //           launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
                                //         }else {
                                //           showCustomSnackBar('invalid_phone_number_found');
                                //         }
                                // }, icon: Image.asset("assets/image/phone.png",height: 20,)),
                                //            ],
                                //          ),
                          Row(
                            children: [
                              Padding(
                                                   padding: const EdgeInsets.only(left: 0),
                                                   child: CustomInkWellWidget(child: Padding(
                                                     padding: const EdgeInsets.all(5.0),
                                                     child: Image.asset("assets/image/phone.png",height: 25,),
                                                   ), onTap: () async {
                                                     final phone = parcel ? widget.orderModel.receiverDetails!.contactPersonNumber : widget.orderModel.deliveryAddress!.contactPersonNumber;
                                          if(await canLaunchUrlString('tel:$phone')) {
                                                launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
                                              }else {
                                                showCustomSnackBar('invalid_phone_number_found');
                                              }
                                      
                                                   },  ),
                                                 ),
      
                                                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                       child: CustomInkWellWidget(child: Padding(
                         padding: const EdgeInsets.all(5.0),
                         child: Image.asset("assets/image/message.png",height: 25,),
                       ),onTap: () {
                         Get.toNamed(RouteHelper.getChatRoute(
                          notificationBody: NotificationBodyModel(
                            orderId: widget.orderModel.id, customerId: widget.orderModel.customer!.id,
                          ),
                          user: User(
                            id: widget.orderModel.customer!.id, fName: widget.orderModel.customer!.fName,
                            lName: widget.orderModel.customer!.lName, imageFullUrl: widget.orderModel.customer!.imageFullUrl,
                          ),
                        ));
                       },),
                     )  
                            ],
                          ),
      
                      
                      ]),
      
                   
                    ],
                  )),
      
         
            
            // IconButton(onPressed: (){
              
            // }, icon: Image.asset("assets/image/message.png"))
      
      
                (parcel || widget.orderModel.orderStatus == 'picked_up') ?   InkWell(
                    onTap: () async {
                       String url;
                if(parcel && (widget.orderModel.orderStatus == 'picked_up')) {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.receiverDetails!.latitude}'
                      ',${widget.orderModel.receiverDetails!.longitude}&mode=d';
                }else if(parcel) {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.deliveryAddress!.latitude}'
                      ',${widget.orderModel.deliveryAddress!.longitude}&mode=d';
                }else if(widget.orderModel.orderStatus == 'picked_up') {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.deliveryAddress!.latitude}'
                      ',${widget.orderModel.deliveryAddress!.longitude}&mode=d';
                }else {
                  url = 'https://www.google.com/maps/dir/?api=1&destination=${widget.orderModel.storeLat ?? '0'}'
                      ',${widget.orderModel.storeLng ?? '0'}&mode=d';
                }
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url, mode: LaunchMode.externalApplication);
                } else {
                  showCustomSnackBar('${'could_not_launch'.tr} $url');
                }
                    },
                    // Get.to(()=> OrderLocationScreen(orderModel: orderModel, orderController: orderController, index: index, onTap: onTap,)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color:  Colors.blue  , borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.directions,color: Theme.of(context).cardColor,size: 15,),
                          SizedBox(width: 5,),
                          Text(
                            'Direction'.tr,
                            style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).cardColor),
                          ),
                        ],
                      ),
                    ),
                  ) : SizedBox(),
                ]),
      
              ]),
            ),
      
            Container(
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(Dimensions.radiusDefault)),
              ),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              margin: const EdgeInsets.all(0.2),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
      
           
      
                Expanded(
                  child: Row(children: [
      
      
                    // Expanded(child: TextButton(
                    //   onPressed: () => Get.dialog(ConfirmationDialogWidget(
                    //     icon: Images.warning, title: 'are_you_sure_to_ignore'.tr,
                    //     description: parcel ? 'you_want_to_ignore_this_delivery'.tr : 'you_want_to_ignore_this_order'.tr,
                    //     onYesPressed: ()  {
                    //       if(Get.isSnackbarOpen){
                    //         Get.back();
                    //       }
                    //       orderController.ignoreOrder(index);
                    //       Get.back();
                    //       showCustomSnackBar('order_ignored'.tr, isError: false);
                    //     },
                    //   ), barrierDismissible: false),
                    //   style: TextButton.styleFrom(
                    //     minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    //       side: BorderSide(width: 1, color: Theme.of(context).disabledColor),
                    //     ),
                    //   ),
                    //   child: Text('ignore'.tr, textAlign: TextAlign.center, style: PoppinsRegular.copyWith(
                    //     color: Theme.of(context).textTheme.bodyLarge!.color,
                    //     fontSize: Dimensions.fontSizeLarge,
                    //   )),
                    // )),
      
      
                    // const SizedBox(width: Dimensions.paddingSizeSmall),
      
                    // Expanded(child: CustomButtonWidget(
                    //   height: 40,
                    //   radius: Dimensions.radiusDefault,
                    //   buttonText: 'accept'.tr,
                    //   fontSize: Dimensions.fontSizeDefault,
                    //   onPressed: () => Get.dialog(ConfirmationDialogWidget(
                    //     icon: Images.warning, title: 'are_you_sure_to_accept'.tr,
                    //     description: parcel ? 'you_want_to_accept_this_delivery'.tr : 'you_want_to_accept_this_order'.tr,
                    //     onYesPressed: () {
                    //       orderController.acceptOrder(orderModel.id, index, orderModel).then((isSuccess) {
                    //         if(isSuccess) {
                    //           onTap();
                    //           orderModel.orderStatus = (orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'confirmed')
                    //               ? 'accepted' : orderModel.orderStatus;
                    //           Get.toNamed(
                    //             RouteHelper.getOrderDetailsRoute(orderModel.id),
                    //             arguments: OrderDetailsScreen(
                    //               orderId: orderModel.id, isRunningOrder: true, orderIndex: orderController.currentOrderList!.length-1,
                    //             ),
                    //           );
                    //         }else {
                    //           Get.find<OrderController>().getLatestOrders();
                    //         }
                    //       });
                    //     },
                    //   ), barrierDismissible: false),
                    // )),
      
      
                     Expanded(child: CustomButtonWidget(
                      buttonText: "details".tr,
              onPressed: () {
                Get.toNamed(
                  RouteHelper.getOrderDetailsRoute(widget.orderModel.id),
                  arguments: OrderDetailsScreen(orderId: widget.orderModel.id, isRunningOrder: true, orderIndex: widget.index),
                );
              },
              // style: TextButton.styleFrom(minimumSize: const Size(1170, 45), padding: EdgeInsets.zero, shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: Theme.of(context).disabledColor),
              // )),
              // child: Text('details'.tr, textAlign: TextAlign.center, style: PoppinsBold.copyWith(
              //   color: Theme.of(context).disabledColor, fontSize: Dimensions.fontSizeLarge,
              // )),
            )),
      
            
                  ]),
                ),
      
              ]),
            ),
      
          ]);
        }),
      ),
    );
  }
}
