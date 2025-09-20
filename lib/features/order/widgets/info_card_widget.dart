import 'package:sixam_mart_delivery/common/widgets/custom_ink_well_widget.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_image_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class InfoCardWidget extends StatelessWidget {
  final String title;
  final String image;
  final String? name;
  final DeliveryAddress? address;
  final String? phone;
  final String? latitude;
  final String? longitude;
  final bool showButton;
  final bool isStore;
  final Function? messageOnTap;
  final OrderModel order;
  final bool isChatAllow;
  const InfoCardWidget({super.key, required this.title, required this.image, required this.name, required this.address, required this.phone,
    required this.latitude, required this.longitude, required this.showButton, this.messageOnTap, this.isStore = false, required this.order, required this.isChatAllow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault,fontWeight: FontWeight.w500, color: Theme.of(context).disabledColor)),

             showButton ? Row(children: [

                 Padding( 
                    padding: const EdgeInsets.only(left: 5),
                     child: CustomInkWellWidget(child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Image.asset("assets/image/phone.png",height: 25,),
                     ),onTap: () 
                      async {
                  if(await canLaunchUrlString('tel:$phone')) {
                    launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
                  }else {
                    showCustomSnackBar('invalid_phone_number_found');
                  }
                },),
                   )
              // TextButton.icon(
              //   onPressed: () async {
              //     if(await canLaunchUrlString('tel:$phone')) {
              //       launchUrlString('tel:$phone', mode: LaunchMode.externalApplication);
              //     }else {
              //       showCustomSnackBar('invalid_phone_number_found');
              //     }
              //   },
              //   icon: Icon(Icons.call, color: Theme.of(context).primaryColor, size: 20),
              //   label: Text(
              //     'call'.tr,
              //     style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              //   ),
              // ),

              ,isStore && isChatAllow ? order.isGuest! ? const SizedBox() : Padding( 
                    padding: const EdgeInsets.only(left: 5),
                     child: CustomInkWellWidget(child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Image.asset("assets/image/message.png",height: 25,),
                     ),onTap: () 
                      async {
                  String url ='https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&mode=d';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw '${'could_not_launch'.tr} $url';
                  }
              //   },
                     },),
                   )  : SizedBox()
              
              
              // TextButton.icon(
              //   onPressed: messageOnTap as void Function()?,
              //   icon: Icon(Icons.message, color: Theme.of(context).primaryColor, size: 20),
              //   label: Text(
              //     'chat'.tr,
              //     style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).primaryColor),
              //   ),
              // ) : const SizedBox(),,

            //  , TextButton.icon(
            //     onPressed: () async {
            //       String url ='https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&mode=d';
            //       if (await canLaunchUrlString(url)) {
            //         await launchUrlString(url, mode: LaunchMode.externalApplication);
            //       } else {
            //         throw '${'could_not_launch'.tr} $url';
            //       }
            //     },
            //     icon: Icon(Icons.directions, color: Theme.of(context).disabledColor, size: 20),
            //     label: Text(
            //       'direction'.tr,
            //       style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
            //     ),
            //   ),

,
            Padding( 
                    padding: const EdgeInsets.only(left: 5),
                     child: CustomInkWellWidget(child: Padding(
                       padding: const EdgeInsets.all(5.0),
                       child: Image.asset("assets/image/map.png",height: 25,),
                     ),onTap: () 
                      async {
                 String url ='https://www.google.com/maps/dir/?api=1&destination=$latitude,$longitude&mode=d';
                  if (await canLaunchUrlString(url)) {
                    await launchUrlString(url, mode: LaunchMode.externalApplication);
                  } else {
                    throw '${'could_not_launch'.tr} $url';
                  }
                },),
                   )

            ]) : const SizedBox(height: Dimensions.paddingSizeDefault),
          ],
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        (name != null && name!.isNotEmpty) ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ClipOval(child: CustomImageWidget(
          //   image: image,
          //   height: 50, width: 50, fit: BoxFit.cover,
          // )),
          // const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Text(name!, style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge,fontWeight: FontWeight.w500, color: Theme.of(context).primaryColor)),
            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

            Text(
              address!.address ?? '',
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 2, overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: address!.address != null ? 5: 0),

            (address!.streetNumber != null && address!.streetNumber!.isNotEmpty) ? Text('${'street_number'.tr}: ${address!.streetNumber!}, ',
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ) : const SizedBox(),
            
            (address!.house != null && address!.house!.isNotEmpty) ? Text('${'house'.tr}: ${address!.house!}, ',
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ) : const SizedBox(),
            
            (address!.floor != null && address!.floor!.isNotEmpty) ? Text('${'floor'.tr}: ${address!.floor!}' ,
              style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ) : const SizedBox(),

           

          ])),

        ]) : Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
          child: Text('no_store_data_found'.tr, style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeSmall)))),

      ]),
    );
  }
}
