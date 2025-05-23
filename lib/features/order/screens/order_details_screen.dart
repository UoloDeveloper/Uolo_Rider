import 'dart:async';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sixam_mart_delivery/features/language/controllers/language_controller.dart';
import 'package:sixam_mart_delivery/features/notification/controllers/notification_controller.dart';
import 'package:sixam_mart_delivery/features/order/controllers/order_controller.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_delivery/features/notification/domain/models/notification_body_model.dart';
import 'package:sixam_mart_delivery/features/chat/domain/models/conversation_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_delivery/helper/price_converter_helper.dart';
import 'package:sixam_mart_delivery/helper/responsive_helper.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/confirmation_dialog_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/camera_button_sheet_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/cancellation_dialogue_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/collect_money_delivery_sheet_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/order_item_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/verify_delivery_sheet_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/info_card_widget.dart';
import 'package:sixam_mart_delivery/features/order/widgets/slider_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int? orderId;
  final bool? isRunningOrder;
  final int? orderIndex;
  final bool fromNotification;
  final bool fromLocationScreen;
  const OrderDetailsScreen({super.key, required this.orderId, required this.isRunningOrder, required this.orderIndex,
    this.fromNotification = false, this.fromLocationScreen = false});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> with WidgetsBindingObserver {
  Timer? _timer;

  void _startApiCalling(){
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      Get.find<OrderController>().getOrderWithId(widget.orderId!);
    });
  }

  Future<void> _loadData() async {
    Get.find<OrderController>().pickPrescriptionImage(isRemove: true, isCamera: false);
    await Get.find<OrderController>().getOrderWithId(widget.orderId);
    Get.find<OrderController>().getOrderDetails(widget.orderId, Get.find<OrderController>().orderModel!.orderType == 'parcel');
    await Get.find<OrderController>().getLatestOrders();
    if(Get.find<OrderController>().showDeliveryImageField){
      Get.find<OrderController>().changeDeliveryImageStatus(isUpdate: false);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _loadData();
    _startApiCalling();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.paused) {
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {

    bool? cancelPermission = Get.find<SplashController>().configModel!.canceledByDeliveryman;
    bool selfDelivery = Get.find<ProfileController>().profileModel!.type != 'zone_wise';

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async{
        if((widget.fromNotification || widget.fromLocationScreen)) {
          Future.delayed(const Duration(milliseconds: 0), () async {
            await Get.offAllNamed(RouteHelper.getInitialRoute());
          });
        } else {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: CustomAppBarWidget(title: 'order_details'.tr, onBackPressed: (){
        if(widget.fromNotification || widget.fromLocationScreen) {
            Get.offAllNamed(RouteHelper.getInitialRoute());
          } else {
            Get.back();
          }
        }),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: GetBuilder<OrderController>(builder: (orderController) {

              OrderModel? controllerOrderModel = orderController.orderModel;

              bool restConfModel = Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman';

              bool? parcel, processing, accepted, confirmed, handover, pickedUp, cod, wallet, partialPay, offlinePay;

              late bool showBottomView;
              late bool showSlider;
              bool showDeliveryConfirmImage = false;

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
              OrderModel? order = controllerOrderModel;
              if(order != null && orderController.orderDetailsModel != null) {
                deliveryCharge = order.deliveryCharge;
                dmTips = order.dmTips;
                isPrescriptionOrder = order.prescriptionOrder;
                discount = order.storeDiscountAmount! + order.flashAdminDiscountAmount! + order.flashStoreDiscountAmount!;
                tax = order.totalTaxAmount;
                taxIncluded = order.taxStatus;
                additionalCharge = order.additionalCharge!;
                extraPackagingAmount = order.extraPackagingAmount!;
                referrerBonusAmount = order.referrerBonusAmount!;
                couponDiscount = order.couponDiscountAmount;
                if(isPrescriptionOrder!){
                  double orderAmount = order.orderAmount ?? 0;
                  itemsPrice = (orderAmount + discount) - ((taxIncluded! ? 0 : tax!) + deliveryCharge! + additionalCharge) - dmTips!;
                }else {
                  for (OrderDetailsModel orderDetails in orderController.orderDetailsModel!) {
                    for (AddOn addOn in orderDetails.addOns!) {
                      addOns = addOns + (addOn.price! * addOn.quantity!);
                    }
                    itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                  }
                }

                if (order.storeBusinessModel == 'commission') {
                  showChatPermission = true;
                } else if (order.storeBusinessModel == 'subscription') {
                  showChatPermission = order.storeChatPermission == 1;
                } else {
                  showChatPermission = true;
                }
              }
              double subTotal = itemsPrice + addOns;
              double total = itemsPrice + addOns - discount+ (taxIncluded! ? 0 : tax!) + deliveryCharge! - couponDiscount! + dmTips! + additionalCharge + extraPackagingAmount - referrerBonusAmount;

              if(controllerOrderModel != null){
                parcel = controllerOrderModel.orderType == 'parcel';
                processing = controllerOrderModel.orderStatus == AppConstants.processing;
                accepted = controllerOrderModel.orderStatus == AppConstants.accepted;
                confirmed = controllerOrderModel.orderStatus == AppConstants.confirmed;
                handover = controllerOrderModel.orderStatus == AppConstants.handover;
                pickedUp = controllerOrderModel.orderStatus == AppConstants.pickedUp;
                cod = controllerOrderModel.paymentMethod == 'cash_on_delivery';
                wallet = controllerOrderModel.paymentMethod == 'wallet';
                partialPay = controllerOrderModel.paymentMethod == 'partial_payment';
                offlinePay = controllerOrderModel.paymentMethod == 'offline_payment';

                showDeliveryConfirmImage = pickedUp && Get.find<SplashController>().configModel!.dmPictureUploadStatus!;
                bool restConfModel = Get.find<SplashController>().configModel!.orderConfirmationModel != 'deliveryman';
                showBottomView = (parcel && accepted) || accepted || confirmed || processing || handover
                    || pickedUp || (widget.isRunningOrder ?? true);
                showSlider = (cod && accepted && !restConfModel && !selfDelivery) || handover || pickedUp
                    || (parcel && accepted);
              }

              return (orderController.orderDetailsModel != null && controllerOrderModel != null) ? Column(children: [

                Expanded(child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(children: [
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                     Text(
                            "ORDER ID",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Text('${controllerOrderModel.id.toString()}', style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                          )),
                      
                         
                        ]),
                    // Row(children: [
                    //   Text('${parcel! ? 'delivery_id'.tr : 'order_id'.tr}:', style: TextStyle(
                    //     fontSize: 15,
                    //     fontWeight: FontWeight.w500
                    //   )),
                    //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    //   Text(controllerOrderModel.id.toString(), style: PoppinsMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600)),
                    //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    //   const Expanded(child: SizedBox()),
                    //   Container(height: 7, width: 7, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green)),
                    //   const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                    //   Text(
                    //     controllerOrderModel.orderStatus!.tr,
                    //     style: TextStyle(
                    //       fontSize: 15,
                    //       fontWeight: FontWeight.w500
                    //     ),
                    //   ),
                    // ]),
                    // const SizedBox(height: Dimensions.paddingSizeLarge),

                    Row(children: [
                      Text('${parcel! ? 'charge_payer'.tr : 'item'.tr}:', style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                      const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                      Text(
                        parcel ? controllerOrderModel.chargePayer!.tr : orderController.orderDetailsModel!.length.toString(),
                        style: PoppinsMedium.copyWith(color: Theme.of(context).primaryColor),
                      ),
                      const Expanded(child: SizedBox()),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                        decoration: BoxDecoration(color: Theme.of(context).primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          cod! ? 'cod'.tr : wallet! ? 'wallet'.tr : partialPay! ? 'partially_pay'.tr : offlinePay! ? 'offline_payment'.tr : 'digitally_paid'.tr,
                          style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ]),

                    orderController.orderDetailsModel!.isNotEmpty && orderController.orderDetailsModel![0].itemDetails != null && orderController.orderDetailsModel![0].itemDetails!.moduleType == 'food'
                    ? Column(children: [
                      const Divider(height: Dimensions.paddingSizeLarge),

                      Row(children: [
                        Text('${'cutlery'.tr}: ', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                        const Expanded(child: SizedBox()),

                        Text(
                          controllerOrderModel.cutlery! ? 'yes'.tr : 'no'.tr,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                      ]),
                    ]) : const SizedBox(),

                    controllerOrderModel.unavailableItemNote != null ? Column(
                      children: [
                        const Divider(height: Dimensions.paddingSizeLarge),

                        Row(children: [
                          Text('${'unavailable_item_note'.tr}: ', style: PoppinsMedium),

                          Text(
                            controllerOrderModel.unavailableItemNote!,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                        ]),
                      ],
                    ) : const SizedBox(),

                    controllerOrderModel.deliveryInstruction != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Divider(height: Dimensions.paddingSizeLarge),
                      RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                            text: '${'delivery_instruction'.tr}: ',
                            style: PoppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyMedium!.color),
                            children: <TextSpan>[
                              TextSpan(text: controllerOrderModel.deliveryInstruction!,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                  ).copyWith(fontSize: Dimensions.fontSizeSmall)
                              )
                            ]
                        ),
                      ),
                    ]) : const SizedBox(),
                    SizedBox(height: controllerOrderModel.deliveryInstruction != null ? Dimensions.paddingSizeSmall : 0),

                    const Divider(height: Dimensions.paddingSizeLarge),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Padding(
                      // padding: const EdgeInsets.all(8.0),
                       padding: const EdgeInsets.only(left: 0,right: 0),
                      child: InfoCardWidget(
                        title: parcel ? 'sender_details'.tr : 'store_details'.tr,
                        address: parcel ? controllerOrderModel.deliveryAddress : DeliveryAddress(address: controllerOrderModel.storeAddress),
                        image: parcel ? '' : '${controllerOrderModel.storeLogoFullUrl}',
                        name: parcel ? controllerOrderModel.deliveryAddress!.contactPersonName : controllerOrderModel.storeName,
                        phone: parcel ? controllerOrderModel.deliveryAddress!.contactPersonNumber : controllerOrderModel.storePhone,
                        latitude: parcel ? controllerOrderModel.deliveryAddress!.latitude : controllerOrderModel.storeLat,
                        longitude: parcel ? controllerOrderModel.deliveryAddress!.longitude : controllerOrderModel.storeLng,
                        showButton: (controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                            && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded'),
                        isStore: parcel ? false : true, isChatAllow: showChatPermission,
                        messageOnTap: () => Get.toNamed(RouteHelper.getChatRoute(
                          notificationBody: NotificationBodyModel(
                            orderId: controllerOrderModel.id, vendorId: orderController.orderDetailsModel![0].vendorId,
                          ),
                          user: User(
                            id: controllerOrderModel.storeId, fName: controllerOrderModel.storeName,
                            imageFullUrl: controllerOrderModel.storeLogoFullUrl,
                          ),
                        )),
                        order: order!,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                   (parcel || controllerOrderModel.orderStatus != 'picked_up')  ?   SizedBox()  :   Padding(
                      padding: const EdgeInsets.only(left: 0,right: 0),
                      child: InfoCardWidget(
                        title: parcel ? 'receiver_details'.tr : 'customer_contact_details'.tr,
                        address: parcel ? controllerOrderModel.receiverDetails : controllerOrderModel.deliveryAddress,
                        image: parcel ? '' : controllerOrderModel.customer != null ? '${controllerOrderModel.customer!.imageFullUrl}' : '',
                        name: parcel ? controllerOrderModel.receiverDetails!.contactPersonName : controllerOrderModel.deliveryAddress!.contactPersonName,
                        phone: parcel ? controllerOrderModel.receiverDetails!.contactPersonNumber : controllerOrderModel.deliveryAddress!.contactPersonNumber,
                        latitude: parcel ? controllerOrderModel.receiverDetails!.latitude : controllerOrderModel.deliveryAddress!.latitude,
                        longitude: parcel ? controllerOrderModel.receiverDetails!.longitude : controllerOrderModel.deliveryAddress!.longitude,
                        showButton: controllerOrderModel.orderStatus != 'delivered' && controllerOrderModel.orderStatus != 'failed'
                            && controllerOrderModel.orderStatus != 'canceled' && controllerOrderModel.orderStatus != 'refunded',
                        isStore: parcel ? false : true, isChatAllow: showChatPermission,
                        messageOnTap: () => Get.toNamed(RouteHelper.getChatRoute(
                          notificationBody: NotificationBodyModel(
                            orderId: controllerOrderModel.id, customerId: controllerOrderModel.customer!.id,
                          ),
                          user: User(
                            id: controllerOrderModel.customer!.id, fName: controllerOrderModel.customer!.fName,
                            lName: controllerOrderModel.customer!.lName, imageFullUrl: controllerOrderModel.customer!.imageFullUrl,
                          ),
                        )),
                        order: order,
                      ),
                    ),
                    const SizedBox(height: Dimensions.paddingSizeLarge),

                    parcel ? Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
                      ),
                      child: controllerOrderModel.parcelCategory != null ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('parcel_category'.tr, style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                        Row(children: [
                          ClipOval(child: CustomImageWidget(
                            image: '${controllerOrderModel.parcelCategory!.imageFullUrl}',
                            height: 35, width: 35, fit: BoxFit.cover,
                          )),
                          const SizedBox(width: Dimensions.paddingSizeSmall),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(
                              controllerOrderModel.parcelCategory!.name!, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ).copyWith(fontSize: Dimensions.fontSizeSmall),
                            ),
                            Text(
                              controllerOrderModel.parcelCategory!.description!, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ).copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                            ),
                          ])),
                        ]),
                      ]) : SizedBox(
                        width: context.width,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('parcel_category'.tr, style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          )),
                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          Text('no_parcel_category_data_found'.tr, style: PoppinsMedium),
                        ]),
                      ),
                    ) : Container(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Items :'.tr, style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            )),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: orderController.orderDetailsModel!.length,
                            itemBuilder: (context, index) {
                              return OrderItemWidget(order: controllerOrderModel, orderDetails: orderController.orderDetailsModel![index]);
                            },
                          ),
                        ],
                      ),
                    ),

                    (controllerOrderModel.orderNote  != null && controllerOrderModel.orderNote!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('additional_note'.tr, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Container(
                        width: 1170,
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(width: 1, color: Theme.of(context).disabledColor),
                        ),
                        child: Text(
                          controllerOrderModel.orderNote!,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500
                          ).copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                        ),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      (Get.find<SplashController>().getModule(controllerOrderModel.moduleType).orderAttachment!
                      && controllerOrderModel.orderAttachmentFullUrl != null && controllerOrderModel.orderAttachmentFullUrl!.isNotEmpty)
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('prescription'.tr, style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                        const SizedBox(height: Dimensions.paddingSizeSmall),
                        Center(child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                          child: CustomImageWidget(
                            image: '${controllerOrderModel.orderAttachmentFullUrl}',
                            width: 200,
                          ),
                        )),
                        const SizedBox(height: Dimensions.paddingSizeLarge),
                      ]) : const SizedBox(),

                    ]) : const SizedBox(),

                    (controllerOrderModel.orderStatus == 'delivered' && controllerOrderModel.orderProofFullUrl != null
                    && controllerOrderModel.orderProofFullUrl!.isNotEmpty) ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const SizedBox(height: Dimensions.paddingSizeSmall),
                      Text('order_proof'.tr, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 1.5,
                            crossAxisCount: ResponsiveHelper.isTab(context) ? 5 : 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 5,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controllerOrderModel.orderProofFullUrl!.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: InkWell(
                                onTap: () => openDialog(context, controllerOrderModel.orderProofFullUrl![index]),
                                child: Center(child: ClipRRect(
                                  borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                  child: CustomImageWidget(
                                    image: controllerOrderModel.orderProofFullUrl![index],
                                    width: 100, height: 100,
                                  ),
                                )),
                              ),
                            );
                          }),

                      const SizedBox(height: Dimensions.paddingSizeLarge),
                    ]) : const SizedBox(),
                    // const SizedBox(height: Dimensions.paddingSizeExtraLarge),`

                    !parcel ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('item_price'.tr, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(PriceConverterHelper.convertPrice(itemsPrice), style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                      ]),
                    ]) : const SizedBox(),
                    SizedBox(height: !parcel ? 10 : 0),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('addons'.tr, style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                        Text('+ ${PriceConverterHelper.convertPrice(addOns)}', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    ) : const SizedBox(),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Divider(
                      thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5),
                    ) : const SizedBox(),

                    Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${'subtotal'.tr} ${taxIncluded ? '(${'tax_included'.tr})' : ''}', style: PoppinsMedium),
                        Text(PriceConverterHelper.convertPrice(subTotal), style: PoppinsMedium),
                      ],
                    ) : const SizedBox(),
                    // SizedBox(height: Get.find<SplashController>().getModuleConfig(order.moduleType).addOn! ? 10 : 0),

                    // !parcel ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //   Text('discount'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   Row(mainAxisSize: MainAxisSize.min, children: [
                    //     Text('(-) ${PriceConverterHelper.convertPrice(discount)}', style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   ]),
                    // ]) : const SizedBox(),
                    // SizedBox(height: !parcel ? 10 : 0),

                    // couponDiscount > 0 ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //   Text('coupon_discount'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   Text(
                    //     '(-) ${PriceConverterHelper.convertPrice(couponDiscount)}',
                    //     style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500),
                    //   ),
                    // ]) : const SizedBox(),
                    // SizedBox(height: couponDiscount > 0 ? 10 : 0),

                    // (referrerBonusAmount > 0) ? Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('referral_discount'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //     Text('(-) ${PriceConverterHelper.convertPrice(referrerBonusAmount)}', style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   ],
                    // ) : const SizedBox(),
                    // SizedBox(height: referrerBonusAmount > 0 ? 10 : 0),

                    // !taxIncluded && !parcel ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //   Text('vat_tax'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   Text('(+) ${PriceConverterHelper.convertPrice(tax)}', style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    // ]) : const SizedBox(),
                    // SizedBox(height: taxIncluded ? 0 : 10),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('delivery_man_tips'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //     Text('(+) ${PriceConverterHelper.convertPrice(dmTips)}', style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   ],
                    // ),
                    const SizedBox(height: 10),

                    // (extraPackagingAmount > 0) ? Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Text('extra_packaging'.tr, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //     Text('(+) ${PriceConverterHelper.convertPrice(extraPackagingAmount)}', style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   ],
                    // ) : const SizedBox(),
                    // SizedBox(height: extraPackagingAmount > 0 ? 10 : 0),

                    // (order.additionalCharge != null && order.additionalCharge! > 0) ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    //   Text(Get.find<SplashController>().configModel!.additionalChargeName!, style: TextStyle(
                    // fontSize: 15,
                    // fontWeight:FontWeight.w500)),
                    //   Text('(+) ${PriceConverterHelper.convertPrice(order.additionalCharge)}', style: TextStyle(
                    //fontSize: 15,
                    //fontWeight: FontWeight.w500), textDirection: TextDirection.ltr),
                    // ]) : const SizedBox(),
                    (order.additionalCharge != null && order.additionalCharge! > 0) ? const SizedBox(height: 10) : const SizedBox(),

                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('delivery_fee'.tr, style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                      Text('+ ${PriceConverterHelper.convertPrice(deliveryCharge)}', style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      )),
                    ]),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: Divider(thickness: 1, color: Theme.of(context).hintColor.withOpacity(0.5)),
                    ),

                    partialPay! ? DottedBorder(
                      color: Theme.of(context).primaryColor,
                      strokeWidth: 1,
                      strokeCap: StrokeCap.butt,
                      dashPattern: const [8, 5],
                      padding: const EdgeInsets.all(0),
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(Dimensions.radiusDefault),
                      child: Ink(
                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        color: !restConfModel ? Theme.of(context).primaryColor.withOpacity(0.05) : Colors.transparent,
                        child: Column(children: [

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('total_amount'.tr, style: PoppinsMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor,
                            )),
                            Text(
                              PriceConverterHelper.convertPrice(total),
                              style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).primaryColor),
                            ),
                          ]),
                          const SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('paid_by_wallet'.tr, style: !restConfModel ? PoppinsMedium : TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            )),
                            Text(
                              PriceConverterHelper.convertPrice(order.payments![0].amount),
                              style: !restConfModel ? PoppinsMedium : TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text('${order.payments?[1].paymentStatus == 'paid' ? 'paid_by'.tr : 'due_amount'.tr} (${order.payments![1].paymentMethod?.tr})', style: !restConfModel ? PoppinsMedium : TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500
                            )),
                            Text(
                              PriceConverterHelper.convertPrice(order.payments![1].amount),
                              style: !restConfModel ? PoppinsMedium : TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ]),
                        ]),
                      ),
                    ) : const SizedBox(),
                    SizedBox(height: partialPay ? 20 : 0),

                    !partialPay ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('total_amount'.tr, style: PoppinsMedium.copyWith(
                        fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600
                      )),
                      Text(
                        PriceConverterHelper.convertPrice(total),
                        style: PoppinsMedium.copyWith( fontSize: Dimensions.fontSizeExtraLarge, color: Theme.of(context).primaryColor,fontWeight: FontWeight.w600),
                      ),
                    ]) : const SizedBox(),

                  ]),
                )),

                showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered' ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('completed_after_delivery_picture'.tr, style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    )),
                    const SizedBox(height: Dimensions.paddingSizeSmall),

                    Container(
                      height: 80,
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: orderController.pickedPrescriptions.length+1,
                        itemBuilder: (context, index) {
                          XFile? file = index == orderController.pickedPrescriptions.length ? null : orderController.pickedPrescriptions[index];
                          if(index < 5 && index == orderController.pickedPrescriptions.length) {
                            return InkWell(
                              onTap: () {
                                if(GetPlatform.isIOS) {
                                  Get.find<OrderController>().pickPrescriptionImage(isRemove: false, isCamera: false);
                                }else {
                                  Get.bottomSheet(const CameraButtonSheetWidget());
                                }
                              },
                              child: Container(
                                height: 60, width: 60, alignment: Alignment.center, decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                color: Theme.of(context).primaryColor.withOpacity(0.1),
                              ),
                                child:  Icon(Icons.camera_alt_sharp, color: Theme.of(context).primaryColor, size: 32),
                              ),
                            );
                          }
                          return file != null ? Container(
                            margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            ),
                            child: Stack(children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                child: GetPlatform.isWeb ? Image.network(
                                  file.path, width: 60, height: 60, fit: BoxFit.cover,
                                ) : Image.file(
                                  File(file.path), width: 60, height: 60, fit: BoxFit.cover,
                                ),
                              ),
                            ]),
                          ) : const SizedBox();
                        },
                      ),
                    ),
                  ]),
                ) : const SizedBox(),

                showDeliveryConfirmImage && controllerOrderModel.orderStatus != 'delivered' && !parcel ? CustomButtonWidget(
                  buttonText: 'complete_delivery'.tr,
                  onPressed: () {
                    if(Get.find<SplashController>().configModel!.orderDeliveryVerification!){
                      Get.find<NotificationController>().sendDeliveredNotification(controllerOrderModel.id);

                      Get.bottomSheet(VerifyDeliverySheetWidget(
                        currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: partialPay! ? controllerOrderModel.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                        cod: cod! || (partialPay && controllerOrderModel.payments![1].paymentMethod == 'cash_on_delivery'),
                      ), isScrollControlled: true).then((isSuccess) {

                        if(isSuccess && (cod! || (partialPay! && controllerOrderModel.payments![1].paymentMethod == 'cash_on_delivery'))){
                          Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                            currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                            orderAmount: partialPay! ? controllerOrderModel.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                            cod: cod || (partialPay && controllerOrderModel.payments![1].paymentMethod == 'cash_on_delivery'),
                          ), isScrollControlled: true, isDismissible: false);
                        }
                      });
                    } else{
                      Get.bottomSheet(CollectMoneyDeliverySheetWidget(
                        currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: partialPay! ? controllerOrderModel.payments![1].amount!.toDouble() : controllerOrderModel.orderAmount,
                        cod: cod! || (partialPay && controllerOrderModel.payments![1].paymentMethod == 'cash_on_delivery'),
                      ), isScrollControlled: true);
                    }

                  },
                ) : showBottomView ? ((accepted! && !parcel && (!cod || restConfModel || selfDelivery))
                 || processing! || confirmed!) ? Container(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    border: Border.all(width: 1, color: Get.isDarkMode ? Colors.grey[700]! : Colors.grey[200]!),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    processing! ? 'order_is_preparing'.tr : 'order_waiting_for_process'.tr,
                    style: PoppinsMedium,
                  ),
                ) : showSlider ? ((cod && accepted && !restConfModel && cancelPermission! && !selfDelivery)
                || (parcel && accepted && cancelPermission!)) ? Row(children: [

                  Expanded(child: TextButton(
                    onPressed: () {
                      orderController.setOrderCancelReason('');
                      Get.dialog(CancellationDialogueWidget(orderId: widget.orderId));
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(1170, 40), padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                        side: BorderSide(width: 1, color: Theme.of(context).textTheme.bodyLarge!.color!),
                      ),
                    ),
                    child: Text('cancel'.tr, textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500
                    ).copyWith(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: Dimensions.fontSizeLarge,
                    )),
                  )),
                  const SizedBox(width: Dimensions.paddingSizeSmall),
                  Expanded(child: CustomButtonWidget(
                    buttonText: 'confirm'.tr, height: 40,
                    onPressed: () {
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning, title: 'are_you_sure_to_confirm'.tr,
                        description: parcel! ? 'you_want_to_confirm_this_delivery'.tr : 'you_want_to_confirm_this_order'.tr,
                        onYesPressed: () {
                          if((Get.find<SplashController>().configModel!.orderDeliveryVerification! || cod!) && !parcel!) {
                            orderController.updateOrderStatus(
                              controllerOrderModel, parcel ? AppConstants.handover : AppConstants.confirmed, back: widget.fromLocationScreen? false: true,
                              gotoDashboard: widget.fromLocationScreen? true: false,
                            );
                          }
                          else if(parcel! && cod! && controllerOrderModel.chargePayer != 'sender') {
                            orderController.updateOrderStatus(controllerOrderModel, AppConstants.handover);
                          }
                          else if(parcel && controllerOrderModel.chargePayer == 'sender' && cod!) {
                            orderController.updateOrderStatus(controllerOrderModel, AppConstants.handover);
                          }
                        },
                      ), barrierDismissible: false);
                    },
                  )),

                ]) : SliderButton(
                  action: () {

                    if((cod! && accepted! && !restConfModel && !selfDelivery) || (parcel! && accepted!)) {

                      if(orderController.isLoading) {
                        orderController.initLoading();
                      }
                      Get.dialog(ConfirmationDialogWidget(
                        icon: Images.warning, title: 'are_you_sure_to_confirm'.tr,
                        description: parcel! ? 'you_want_to_confirm_this_delivery'.tr : 'you_want_to_confirm_this_order'.tr,
                        onYesPressed: () {
                          orderController.updateOrderStatus(
                            controllerOrderModel, parcel! ? AppConstants.handover : AppConstants.confirmed, back: widget.fromLocationScreen? false: true,
                            gotoDashboard: widget.fromLocationScreen? true: false
                          );
                        },
                      ), barrierDismissible: false);
                    }

                  else if(pickedUp!) {
                    if(parcel && controllerOrderModel.chargePayer != 'sender') {
                      Get.bottomSheet(VerifyDeliverySheetWidget(
                        currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: controllerOrderModel.orderAmount, cod: true, isParcel: parcel,
                      ), isScrollControlled: true).then((value) {
                        if(value == 'show_price_view') {
                          Get.bottomSheet(VerifyDeliverySheetWidget(
                            currentOrderModel: controllerOrderModel, verify: false, isSetOtp: false,
                            orderAmount: controllerOrderModel.orderAmount, cod: true, isSenderPay: false, isParcel: parcel,
                          ), isScrollControlled: true);
                        }
                      });
                    }
                    else if((Get.find<SplashController>().configModel!.orderDeliveryVerification! || cod) && !parcel){
                      Get.bottomSheet(VerifyDeliverySheetWidget(
                        currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: controllerOrderModel.orderAmount, cod: cod,
                      ), isScrollControlled: true);
                    }
                    else if(!cod && parcel && controllerOrderModel.chargePayer == 'sender'){
                      Get.bottomSheet(VerifyDeliverySheetWidget(
                        currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                        orderAmount: controllerOrderModel.orderAmount, cod: cod,
                      ), isScrollControlled: true);
                    }
                    else {
                      Get.find<OrderController>().updateOrderStatus(controllerOrderModel, AppConstants.delivered, back: widget.fromLocationScreen? false: true,
                        gotoDashboard: widget.fromLocationScreen? true: false);
                    }
                  }

                  else if(parcel && controllerOrderModel.chargePayer == 'sender' && cod){
                    Get.bottomSheet(VerifyDeliverySheetWidget(
                      currentOrderModel: controllerOrderModel, verify: Get.find<SplashController>().configModel!.orderDeliveryVerification,
                      orderAmount: controllerOrderModel.orderAmount, cod: cod, isSenderPay: true, isParcel: parcel,
                    ), isScrollControlled: true).then((value) {
                      if(value == 'show_price_view') {
                        Get.bottomSheet(VerifyDeliverySheetWidget(
                          currentOrderModel: controllerOrderModel, verify: false, isSetOtp: false,
                          orderAmount: controllerOrderModel.orderAmount, cod: cod, isSenderPay: true, isParcel: parcel,
                        ), isScrollControlled: true);
                      }
                    });
                  }

                  else if(handover!) {
                    if(Get.find<ProfileController>().profileModel!.active == 1) {
                      Get.find<OrderController>().updateOrderStatus(controllerOrderModel, AppConstants.pickedUp, back: widget.fromLocationScreen? false: true,
                        gotoDashboard: widget.fromLocationScreen? true: false);
                    }else {
                      showCustomSnackBar('make_yourself_online_first'.tr);
                    }
                  }

                  },
                  label: Text(
                    (parcel && accepted) ? 'swipe_to_confirm_delivery'.tr
                        : (cod && accepted && !restConfModel && !selfDelivery) ? 'swipe_to_confirm_order'.tr
                        : pickedUp! ? parcel ? 'swipe_to_deliver_parcel'.tr
                        : 'swipe_to_deliver_order'.tr : handover! ? parcel ? 'swipe_to_pick_up_parcel'.tr
                        : 'swipe_to_pick_up_order'.tr : '',
                    style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor),
                  ),
                  dismissThresholds: 0.5, dismissible: false, shimmer: true,
                  width: 1170, height: 60, buttonSize: 50, radius: 10,
                  icon: Center(child: Icon(
                    Get.find<LocalizationController>().isLtr ? Icons.double_arrow_sharp : Icons.keyboard_arrow_left,
                    color: Colors.white, size: 40.0,
                  )),
                  isLtr: Get.find<LocalizationController>().isLtr,
                  boxShadow: const BoxShadow(blurRadius: 0),
                  buttonColor: Theme.of(context).primaryColor,
                  backgroundColor:
                  Theme.of(context).primaryColor,
                  //  const Color(0xffF4F7FC),
                  baseColor: Theme.of(context).primaryColor,
                ) : const SizedBox() : const SizedBox(),

              ]) : const Center(child: CircularProgressIndicator());
            }),
          ),
        ),
      ),
    );
  }

  void openDialog(BuildContext context, String imageUrl) => showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
        child: Stack(children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
            child: PhotoView(
              tightMode: true,
              imageProvider: NetworkImage(imageUrl),
              heroAttributes: PhotoViewHeroAttributes(tag: imageUrl),
            ),
          ),

          Positioned(top: 0, right: 0, child: IconButton(
            splashRadius: 5,
            onPressed: () => Get.back(),
            icon: const Icon(Icons.cancel, color: Colors.red),
          )),

        ]),
      );
    },
  );
}
