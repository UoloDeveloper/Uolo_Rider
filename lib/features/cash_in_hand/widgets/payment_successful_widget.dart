import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_app_bar_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';

class PaymentSuccessfulWidget extends StatelessWidget {
  final bool success;
  const PaymentSuccessfulWidget({super.key, required this.success});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: '', isBackButtonExist: false),
      body: SafeArea(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

        Image.asset(success ? Images.checked : Images.warning, width: 100, height: 100, color: success ? Colors.green : Colors.red),
        const SizedBox(height: Dimensions.paddingSizeLarge),

        Text(
          success ? 'your_payment_is_successfully_completed'.tr : 'your_payment_is_not_done'.tr,
          style: PoppinsMedium.copyWith(fontSize: Dimensions.fontSizeLarge),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        const SizedBox(height: 30),

        Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          child: CustomButtonWidget(buttonText: 'okay'.tr, onPressed: () => Get.offAllNamed(RouteHelper.getInitialRoute())),
        ),
      ])),
    );
  }
}
