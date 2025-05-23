import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';

class FundPaymentDialogWidget extends StatelessWidget {
  const FundPaymentDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: Image.asset(Images.warning, width: 70, height: 70),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
              child: Text(
                'do_you_want_to_cancel_this_payment'.tr, textAlign: TextAlign.center,
                style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: Colors.red),
              ),
            ),

            TextButton(
              onPressed: () {
                if(Get.isDialogOpen!){
                  Get.back();
                }
                Get.back();
              },
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), minimumSize:  const Size(Dimensions.webMaxWidth, 40), padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
              ),
              child: Text('cancel_payment'.tr, textAlign: TextAlign.center, style: PoppinsBold.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
            ),
          ]),
        ),
      ),
    );
  }
}
