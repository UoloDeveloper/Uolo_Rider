import 'package:country_code_picker/country_code_picker.dart';
import 'package:sixam_mart_delivery/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/features/splash/controllers/splash_controller.dart';
import 'package:sixam_mart_delivery/helper/custom_validator_helper.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/images.dart';
import 'package:sixam_mart_delivery/util/styles.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// class SignInScreen extends StatelessWidget {
//   final FocusNode _phoneFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   SignInScreen({super.key});

//   @override
//   Widget build(BuildContext context) {

//     String? countryDialCode = Get.find<AuthController>().getUserCountryCode().isNotEmpty ? Get.find<AuthController>().getUserCountryCode()
//         : CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).dialCode;
//     _phoneController.text =  Get.find<AuthController>().getUserNumber();
//     _passwordController.text = Get.find<AuthController>().getUserPassword();

//     return Scaffold(
//       body: SafeArea(child: Center(
//         child: SingleChildScrollView(
//           physics: const BouncingScrollPhysics(),
//           padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//           child: Center(
//             child: SizedBox(
//               width: 1170,
//               child: GetBuilder<AuthController>(builder: (authController) {

//                 return Column(children: [

//                   Image.asset(Images.logo, width: 200),
//                   const SizedBox(height: Dimensions.paddingSizeExtraLarge),

//                   Text('sign_in'.tr.toUpperCase(), style: PoppinsBlack.copyWith(fontSize: 30)),
//                   const SizedBox(height: 50),

//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
//                       color: Theme.of(context).cardColor,
//                       boxShadow: Get.isDarkMode ? null : [BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)],
//                     ),
//                     child: Column(children: [

//                       CustomTextFieldWidget(
//                         hintText: 'phone'.tr,
//                         controller: _phoneController,
//                         focusNode: _phoneFocus,
//                         nextFocus: _passwordFocus,
//                         inputType: TextInputType.phone,
//                         divider: true,
//                         isPhone: true,
//                         border: false,
//                         onCountryChanged: (CountryCode countryCode) {
//                           countryDialCode = countryCode.dialCode;
//                         },
//                         countryDialCode: countryDialCode ?? CountryCode.fromCountryCode(Get.find<SplashController>().configModel!.country!).code,
//                       ),

//                       CustomTextFieldWidget(
//                         hintText: 'password'.tr,
//                         controller: _passwordController,
//                         focusNode: _passwordFocus,
//                         inputAction: TextInputAction.done,
//                         inputType: TextInputType.visiblePassword,
//                         prefixIcon: Icons.lock,
//                         isPassword: true,
//                         border: false,
//                         onSubmit: (text) => GetPlatform.isWeb ? _login(
//                           authController, _phoneController, _passwordController, countryDialCode!, context,
//                         ) : null,
//                       ),

//                     ]),
//                   ),
//                   const SizedBox(height: 10),

//                   Row(children: [
//                     Expanded(
//                       child: ListTile(
//                         onTap: () => authController.toggleRememberMe(),
//                         leading: Checkbox(
//                           activeColor: Theme.of(context).primaryColor,
//                           value: authController.isActiveRememberMe,
//                           onChanged: (bool? isChecked) => authController.toggleRememberMe(),
//                         ),
//                         title: Text('remember_me'.tr),
//                         contentPadding: EdgeInsets.zero,
//                         dense: true,
//                         horizontalTitleGap: 0,
//                       ),
//                     ),
//                     TextButton(
//                       onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
//                       child: Text('${'forgot_password'.tr}?'),
//                     ),
//                   ]),
//                   const SizedBox(height: 50),

//                   !authController.isLoading ? CustomButtonWidget(
//                     buttonText: 'sign_in'.tr,
//                     onPressed: () => _login(authController, _phoneController, _passwordController, countryDialCode!, context),
//                   ) : const Center(child: CircularProgressIndicator()),
//                   SizedBox(height: Get.find<SplashController>().configModel!.toggleDmRegistration! ? Dimensions.paddingSizeSmall : 0),

//                   Get.find<SplashController>().configModel!.toggleDmRegistration! ? TextButton(
//                     style: TextButton.styleFrom(
//                       minimumSize: const Size(1, 40),
//                     ),
//                     onPressed: () {
//                       Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
//                     },
//                     child: RichText(text: TextSpan(children: [
//                       TextSpan(text: '${'join_as_a'.tr} ', style: PoppinsRegular.copyWith(color: Theme.of(context).disabledColor)),
//                       TextSpan(text: 'delivery_man'.tr, style: PoppinsMedium.copyWith(color: Theme.of(context).textTheme.bodyLarge!.color)),
//                     ])),
//                   ) : const SizedBox(),

//                 ]);
//               }),
//             ),
//           ),
//         ),
//       )),
//     );
//   }

//   void _login(AuthController authController, TextEditingController phoneText, TextEditingController passText, String countryCode, BuildContext context) async {
//     String phone = phoneText.text.trim();
//     String password = passText.text.trim();

//     String numberWithCountryCode = countryCode+phone;
//     PhoneValid phoneValid = await CustomValidatorHelper.isPhoneValid(numberWithCountryCode);
//     numberWithCountryCode = phoneValid.phone;

//     if (phone.isEmpty) {
//       showCustomSnackBar('enter_phone_number'.tr);
//     }else if (!phoneValid.isValid) {
//       showCustomSnackBar('invalid_phone_number'.tr);
//     }else if (password.isEmpty) {
//       showCustomSnackBar('enter_password'.tr);
//     }else if (password.length < 6) {
//       showCustomSnackBar('password_should_be'.tr);
//     }else {
//       authController.login(numberWithCountryCode, password).then((status) async {
//         if (status.isSuccess) {
//           if (authController.isActiveRememberMe) {
//             authController.saveUserNumberAndPassword(phone, password, countryCode);
//           } else {
//             authController.clearUserNumberAndPassword();
//           }
//           await Get.find<ProfileController>().getProfile();
//           Get.offAllNamed(RouteHelper.getInitialRoute());
//             print(status.message);
//               showCustomSnackBar(status.message);
//         }else {
//            print(status.message);
//           showCustomSnackBar(status.message);
//         }
//       });
//     }
//   }
// }


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? countryDialCode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      final authController = Get.find<AuthController>();
      final splashController = Get.find<SplashController>();

      countryDialCode = authController.getUserCountryCode().isNotEmpty
          ? authController.getUserCountryCode()
          : CountryCode.fromCountryCode(splashController.configModel!.country!).dialCode;

      _phoneController.text = authController.getUserNumber();
      _passwordController.text = authController.getUserPassword();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error initializing data: $e'),
      ));
      print('Error initializing data: $e');
      countryDialCode = '+1'; // Fallback to default dial code if needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: Center(
                    child: SizedBox(
                      width: 1170,
                      child: GetBuilder<AuthController>(builder: (authController) {
                        return Column(
                          children: [
                            Image.asset(Images.logo, width: 200),
                            const SizedBox(height: Dimensions.paddingSizeExtraLarge),
                            Text('sign_in'.tr.toUpperCase(), style: PoppinsBlack.copyWith(fontSize: 30)),
                            const SizedBox(height: 50),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                                color: Theme.of(context).cardColor,
                                boxShadow: Get.isDarkMode
                                    ? null
                                    : [
                                        BoxShadow(color: Colors.grey[200]!, spreadRadius: 1, blurRadius: 5)
                                      ],
                              ),
                              child: Column(
                                children: [
                                  CustomTextFieldWidget(
                                    hintText: 'phone'.tr,
                                    controller: _phoneController,
                                    focusNode: _phoneFocus,
                                    nextFocus: _passwordFocus,
                                    inputType: TextInputType.phone,
                                    divider: true,
                                    isPhone: true,
                                    border: false,
                                    onCountryChanged: (CountryCode countryCode) {
                                      setState(() {
                                        this.countryDialCode = countryCode.dialCode;
                                      });
                                    },
                                    countryDialCode: countryDialCode!,
                                  ),
                                  CustomTextFieldWidget(
                                    hintText: 'password'.tr,
                                    controller: _passwordController,
                                    focusNode: _passwordFocus,
                                    inputAction: TextInputAction.done,
                                    inputType: TextInputType.visiblePassword,
                                    prefixIcon: Icons.lock,
                                    isPassword: true,
                                    border: false,
                                    onSubmit: (text) => GetPlatform.isWeb
                                        ? _login(authController, _phoneController, _passwordController, countryDialCode!, context)
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    onTap: () => authController.toggleRememberMe(),
                                    leading: Checkbox(
                                      activeColor: Theme.of(context).primaryColor,
                                      value: authController.isActiveRememberMe,
                                      onChanged: (bool? isChecked) => authController.toggleRememberMe(),
                                    ),
                                    title: Text('remember_me'.tr),
                                    contentPadding: EdgeInsets.zero,
                                    dense: true,
                                    horizontalTitleGap: 0,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Get.toNamed(RouteHelper.getForgotPassRoute()),
                                  child: Text('${'forgot_password'.tr}?'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            !authController.isLoading
                                ? CustomButtonWidget(
                                    buttonText: 'sign_in'.tr,
                                    onPressed: () =>
                                        _login(authController, _phoneController, _passwordController, countryDialCode!, context),
                                  )
                                : const Center(child: CircularProgressIndicator()),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void _login(AuthController authController, TextEditingController phoneText, TextEditingController passText,
      String countryCode, BuildContext context) async {
    String phone = phoneText.text.trim();
    String password = passText.text.trim();

    String numberWithCountryCode = countryCode + phone;
    PhoneValid phoneValid = await CustomValidatorHelper.isPhoneValid(numberWithCountryCode);
    numberWithCountryCode = phoneValid.phone;

    if (phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!phoneValid.isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else {
      authController.login(numberWithCountryCode, password).then((status) async {
        if (status.isSuccess) {
          if (authController.isActiveRememberMe) {
            authController.saveUserNumberAndPassword(phone, password, countryCode);
          } else {
            authController.clearUserNumberAndPassword();
          }
          await Get.find<ProfileController>().getProfile();
          Get.offAllNamed(RouteHelper.getInitialRoute());
          print(status.message);
          // showCustomSnackBar(status.message);
        } else {

         
         
          print(status.message);
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}


// class SignInScreen extends StatelessWidget {
//   final FocusNode _phoneFocus = FocusNode();
//   final FocusNode _passwordFocus = FocusNode();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   SignInScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     String? countryDialCode;
//     try {
//       final userCountryCode = Get.find<AuthController>().getUserCountryCode();
//       final configModel = Get.find<SplashController>().configModel;

//       countryDialCode = userCountryCode.isNotEmpty
//           ? userCountryCode
//           : configModel?.country != null
//               ? CountryCode.fromCountryCode(configModel!.country!).dialCode
//               : null;
//     } catch (e) {
//       countryDialCode = null;
//       print('Error determining country dial code: $e');
//     }

//     if (countryDialCode == null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         showCustomSnackBar('Unable to determine country dial code.');
//       });
//     }

//     _phoneController.text = Get.find<AuthController>().getUserNumber();
//     _passwordController.text = Get.find<AuthController>().getUserPassword();

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
//             child: Center(
//               child: SizedBox(
//                 width: 1170,
//                 child: GetBuilder<AuthController>(
//                   builder: (authController) {
//                     return Column(
//                       children: [
//                         Image.asset(Images.logo, width: 200),
//                         const SizedBox(height: Dimensions.paddingSizeExtraLarge),
//                         Text('sign_in'.tr.toUpperCase(),
//                             style: PoppinsBlack.copyWith(fontSize: 30)),
//                         const SizedBox(height: 50),
//                         Container(
//                           decoration: BoxDecoration(
//                             borderRadius:
//                                 BorderRadius.circular(Dimensions.radiusSmall),
//                             color: Theme.of(context).cardColor,
//                             boxShadow: Get.isDarkMode
//                                 ? null
//                                 : [
//                                     BoxShadow(
//                                         color: Colors.grey[200]!,
//                                         spreadRadius: 1,
//                                         blurRadius: 5)
//                                   ],
//                           ),
//                           child: Column(
//                             children: [
//                               CustomTextFieldWidget(
//                                 hintText: 'phone'.tr,
//                                 controller: _phoneController,
//                                 focusNode: _phoneFocus,
//                                 nextFocus: _passwordFocus,
//                                 inputType: TextInputType.phone,
//                                 divider: true,
//                                 isPhone: true,
//                                 border: false,
//                                 onCountryChanged: (CountryCode countryCode) {
//                                   countryDialCode = countryCode.dialCode;
//                                 },
//                                 countryDialCode: countryDialCode ?? '+1',
//                               ),
//                               CustomTextFieldWidget(
//                                 hintText: 'password'.tr,
//                                 controller: _passwordController,
//                                 focusNode: _passwordFocus,
//                                 inputAction: TextInputAction.done,
//                                 inputType: TextInputType.visiblePassword,
//                                 prefixIcon: Icons.lock,
//                                 isPassword: true,
//                                 border: false,
//                                 onSubmit: (text) => GetPlatform.isWeb
//                                     ? _login(authController, context)
//                                     : null,
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 10),
//                         Row(
//                           children: [
//                             Expanded(
//                               child: ListTile(
//                                 onTap: () =>
//                                     authController.toggleRememberMe(),
//                                 leading: Checkbox(
//                                   activeColor:
//                                       Theme.of(context).primaryColor,
//                                   value: authController.isActiveRememberMe,
//                                   onChanged: (bool? isChecked) =>
//                                       authController.toggleRememberMe(),
//                                 ),
//                                 title: Text('remember_me'.tr),
//                                 contentPadding: EdgeInsets.zero,
//                                 dense: true,
//                                 horizontalTitleGap: 0,
//                               ),
//                             ),
//                             TextButton(
//                               onPressed: () =>
//                                   Get.toNamed(RouteHelper.getForgotPassRoute()),
//                               child: Text('${'forgot_password'.tr}?'),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 50),
//                         !authController.isLoading
//                             ? CustomButtonWidget(
//                                 buttonText: 'sign_in'.tr,
//                                 onPressed: () =>
//                                     _login(authController, context),
//                               )
//                             : const Center(child: CircularProgressIndicator()),
//                         SizedBox(
//                           height: Get.find<SplashController>().configModel
//                                   ?.toggleDmRegistration ??
//                               false
//                               ? Dimensions.paddingSizeSmall
//                               : 0,
//                         ),
//                         if (Get.find<SplashController>().configModel
//                                 ?.toggleDmRegistration ??
//                             false)
//                           TextButton(
//                             style: TextButton.styleFrom(
//                               minimumSize: const Size(1, 40),
//                             ),
//                             onPressed: () {
//                               Get.toNamed(RouteHelper
//                                   .getDeliverymanRegistrationRoute());
//                             },
//                             child: RichText(
//                               text: TextSpan(
//                                 children: [
//                                   TextSpan(
//                                       text: '${'join_as_a'.tr} ',
//                                       style: PoppinsRegular.copyWith(
//                                           color: Theme.of(context)
//                                               .disabledColor)),
//                                   TextSpan(
//                                       text: 'delivery_man'.tr,
//                                       style: PoppinsMedium.copyWith(
//                                           color: Theme.of(context)
//                                               .textTheme
//                                               .bodyLarge!
//                                               .color)),
//                                 ],
//                               ),
//                             ),
//                           ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _login(AuthController authController, BuildContext context) async {
//     final String phone = _phoneController.text.trim();
//     final String password = _passwordController.text.trim();
//     final String? countryCode = Get.find<AuthController>().getUserCountryCode();

//     if (phone.isEmpty) {
//       showCustomSnackBar('enter_phone_number'.tr);
//     } else if (countryCode == null) {
//       showCustomSnackBar('Invalid country code.');
//     } else if (password.isEmpty) {
//       showCustomSnackBar('enter_password'.tr);
//     } else if (password.length < 6) {
//       showCustomSnackBar('password_should_be'.tr);
//     } else {
//       final String numberWithCountryCode = '$countryCode$phone';
//       final PhoneValid phoneValid =
//           await CustomValidatorHelper.isPhoneValid(numberWithCountryCode);

//       if (!phoneValid.isValid) {
//         showCustomSnackBar('invalid_phone_number'.tr);
//       } else {
//         authController
//             .login(phoneValid.phone, password)
//             .then((status) async {
//           if (status.isSuccess) {
//             if (authController.isActiveRememberMe) {
//               authController.saveUserNumberAndPassword(
//                   phone, password, countryCode);
//             } else {
//               authController.clearUserNumberAndPassword();
//             }
//             await Get.find<ProfileController>().getProfile();
//             Get.offAllNamed(RouteHelper.getInitialRoute());
//             showCustomSnackBar(status.message);
//           } else {
//             showCustomSnackBar(status.message);
//           }
//         });
//       }
//     }
//   }
// }
