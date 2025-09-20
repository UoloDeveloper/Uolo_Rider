import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_button_widget.dart';
import 'package:sixam_mart_delivery/features/auth/controllers/auth_controller.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';


// class CongratulationDialogue extends StatelessWidget {
//   const CongratulationDialogue({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
          

//             Container(
//               width: 300,
//               padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
//               ),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 // Image.asset(Get.find<ThemeController>().darkTheme ? Images.congratulationDark : Images.congratulationLight, width: 100, height: 100),

//                 // Text('congratulations'.tr , style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeLarge)),
//                 const SizedBox(height: Dimensions.paddingSizeSmall),

//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
//                 //   child: Text(
//                 //     '${'you_will_earn'.tr} ${Get.find<AuthController>().getEarningPint()} ${'points_after_completing_this_order'.tr}',
//                 //     style: PoppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: Theme.of(context).disabledColor),
//                 //     textAlign: TextAlign.center,
//                 //   ),
//                 // ),
//                 const SizedBox(height: Dimensions.paddingSizeLarge),

//                 CustomButtonWidget(
//                   buttonText: 'visit_loyalty_points'.tr,
//                   onPressed: (){
//                     // Get.find<AuthController>().saveEarningPoint('');
//                     Get.back();
//                     // Get.toNamed(RouteHelper.getLoyaltyRoute());
//                   },
//                 )
//               ]),
//             ),
//            Lottie.asset(
//   'assets/animations/Animation - 1735370689159.json',
//   width: 300,
//   height: 300,
//   fit: BoxFit.fill,
//   repeat: false,
// ),
//             Positioned(
//               top: 5, right: 5,
//                 child: InkWell(
//                   onTap: (){
//                     // Get.find<AuthController>().;
//                     Get.back();
//                   },
//                     child: const Icon(Icons.clear, size: 18),
//                 ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class DeliveryBoyCongratulationDialogue extends StatefulWidget {
//   final double deliveryCharge;

//    DeliveryBoyCongratulationDialogue({super.key, required this.deliveryCharge});

//   @override
//   State<DeliveryBoyCongratulationDialogue> createState() => _DeliveryBoyCongratulationDialogueState();
// }

// class _DeliveryBoyCongratulationDialogueState extends State<DeliveryBoyCongratulationDialogue> {
//   final AudioPlayer _audioPlayer = AudioPlayer();


//    @override
//   void initState() {
//     super.initState();
//     _playSuccessSound();
//   }

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _playSuccessSound() async {
//     try {
//       await _audioPlayer.play(AssetSource('success-1-6297.mp3'),mode: PlayerMode.lowLatency,volume: 100 );
//     } catch (e) {
//       print("Error playing sound: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Center(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Container(
//               width: 350,
//               padding: const EdgeInsets.all(10.0),
//               decoration: BoxDecoration(
//                 color: Theme.of(context).cardColor,
//                 borderRadius: BorderRadius.circular(20.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black26,
//                     blurRadius: 10.0,
//                     offset: Offset(0, 5),
//                   ),
//                 ],
//               ),
//               child: Column(mainAxisSize: MainAxisSize.min, children: [
//                 const SizedBox(height: 20.0),

//                 // Title
                

//                  Lottie.asset(
//               'assets/animations/Animation - 1735372247407.json', // Replace with your animation file
//               width: 150,
//               height: 150,
//               fit: BoxFit.fill,
//               repeat: true,
//             ),
//                 Text(
//                   '🎉 Congratulations! 🎉',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.green,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10.0),

//                 // Delivery Charge Message
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 //   child: Text(
//                 //     'You Got \$${widget.deliveryCharge.toStringAsFixed(2)}:',
//                 //     style: TextStyle(
//                 //       fontSize: 16.0,
//                 //       color: Colors.black87,
//                 //     ),
//                 //     textAlign: TextAlign.center,
//                 //   ),
//                 // ),

//                 Padding(
//   padding: const EdgeInsets.symmetric(horizontal: 10.0),
//   child: RichText(
//     textAlign: TextAlign.center,
//     text: TextSpan(
//       text: 'You Got ',
//       style: TextStyle(
//         fontSize: 18.0,
//          fontWeight: FontWeight.w500,

//         color: Colors.black87,
//       ),
//       children: [
//         TextSpan(
//           text: '₹${widget.deliveryCharge.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontSize: 23.0,
//             fontWeight: FontWeight.w900,
//             color: Colors.blueAccent, // Highlighting the delivery charge
//           ),
//         ),
        
//         TextSpan(
//           text: '\n on this order.',
//           style: TextStyle(
//             fontSize: 18.0,
//              fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     ),
//   ),
// ),

//                 // const SizedBox(height: 5.0),

//                 // // Delivery Charge Amount
//                 // Text(
//                 //   '\$${widget.deliveryCharge.toStringAsFixed(2)}',
//                 //   style: TextStyle(
//                 //     fontSize: 24.0,
//                 //     fontWeight: FontWeight.bold,
//                 //     color: Colors.blueAccent,
//                 //   ),
//                 // ),
//                 const SizedBox(height: 20.0),

//                 // Button
//                 ElevatedButton(

//                   onPressed: () {
//                     // Navigator.of(context).pop(); // Close the dialog

//                     Get.back();
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Theme.of(context).primaryColor,
//                     padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 25.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30.0),
//                     ),
//                   ),
//                   child: Text(
//                     'Close',
//                     style: TextStyle(fontSize: 16.0, color: Colors.white),
//                   ),
//                 ),
//               ]),
//             ),
//             Lottie.asset(
//               'assets/animations/Animation - 1735370689159.json', // Replace with your animation file
//               width: 300,
//               height: 300,
//               fit: BoxFit.fill,
//               repeat: false,
//             ),
//             Positioned(
//               top: 10, right: 10,
//               child: InkWell(
//                 onTap: () {
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Icon(Icons.clear, size: 24, color: Colors.red),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart'; // Ensure you have this import for AudioPlayer
import 'package:get/get.dart'; // Ensure you have this import for Get

class DeliveryBoyCongratulationDialogue extends StatefulWidget {
  final double deliveryCharge;

  DeliveryBoyCongratulationDialogue({super.key, required this.deliveryCharge});

  @override
  State<DeliveryBoyCongratulationDialogue> createState() => _DeliveryBoyCongratulationDialogueState();
}

class _DeliveryBoyCongratulationDialogueState extends State<DeliveryBoyCongratulationDialogue> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _playSuccessSound();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playSuccessSound() async {
    try {
      await _audioPlayer.play(AssetSource('success-1-6297.mp3'), mode: PlayerMode.lowLatency, volume: 1.0);
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop(); // Close the dialog when tapping outside
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 350,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 20.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 20.0),

                  // Lottie Animation
                  Lottie.asset(
                    'assets/animations/Animation - 1735372247407.json',
                    width: 150,
                    height: 150,
                    fit: BoxFit.fill,
                    repeat: true,
                  ),
                  Text(
                    '🎉 Congratulations! 🎉',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 24.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10.0),

                  // Delivery Charge Message
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'You Got ',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                        children: [
                          TextSpan(
                            text: '₹${widget.deliveryCharge.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent,
                            ),
                          ),
                          TextSpan(
                            text: '\n on this order.',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  // Close Button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
              ]),
            ),
            Lottie.asset(
              'assets/animations/Animation - 1735370689159.json',
              width: 300,
              height: 300,
              fit: BoxFit.fill,
              repeat: false,
            ),
            Positioned(
              top: 10, right: 10,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Icon(Icons.clear, size: 24, color: Colors.red),
              ),
            )
          ],
        ),
      ),
    ));
  }
}