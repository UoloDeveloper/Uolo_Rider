import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sixam_mart_delivery/api/api_client.dart';
import 'package:sixam_mart_delivery/common/models/response_model.dart';
import 'package:sixam_mart_delivery/common/widgets/custom_snackbar_widget.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/ignore_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_cancellation_body.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_details_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/order_request_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/models/update_status_body_model.dart';
import 'package:sixam_mart_delivery/features/order/domain/repositories/order_repository_interface.dart';
import 'package:sixam_mart_delivery/util/app_constants.dart';

class OrderRepository implements OrderRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  OrderRepository({required this.apiClient, required this.sharedPreferences});

  @override
  Future<List<CancellationData>?> getCancelReasons() async {
    List<CancellationData>? orderCancelReasons;
    Response response = await apiClient.getData('${AppConstants.orderCancellationUri}?offset=1&limit=30&type=deliveryman');
    if (response.statusCode == 200) {
      OrderCancellationBody orderCancellationBody = OrderCancellationBody.fromJson(response.body);
      orderCancelReasons = [];
      for (var element in orderCancellationBody.reasons!) {
        orderCancelReasons.add(element);
      }
    }
    return orderCancelReasons;
  }

  @override
  Future<Response> get(int? id) async {
    Response response = await apiClient.getData('${AppConstants.currentOrderUri}${_getUserToken()}&order_id=$id');
    return response;
  }

  @override
  Future<PaginatedOrderModel?> getCompletedOrderList(int offset) async {
    PaginatedOrderModel? paginatedOrderModel;
    Response response = await apiClient.getData('${AppConstants.allOrdersUri}?token=${_getUserToken()}&offset=$offset&limit=10');
    if (response.statusCode == 200) {
      paginatedOrderModel = PaginatedOrderModel.fromJson(response.body);
    }
    return paginatedOrderModel;
  }

  @override
  Future<List<OrderModel>?> getList() async {
    List<OrderModel>? currentOrderList;
    Response response = await apiClient.getData(AppConstants.currentOrdersUri + _getUserToken());
    if(response.statusCode == 200) {
      currentOrderList = [];
      response.body.forEach((order) => currentOrderList!.add(OrderModel.fromJson(order)));
    }
    return currentOrderList;
  }

  @override
  Future<DeliveryRequestModel?> getLatestOrders() async {
    DeliveryRequestModel? latestOrderList;
    Response response = await apiClient.getData(AppConstants.GetpendingOrderUri + _getUserToken());
    if(response.statusCode == 200) {
    
      latestOrderList = DeliveryRequestModel.fromJson(response.body);
      // response.body.forEach((order) => latestOrderList!.add(OrderModel.fromJson(order)));
      // showCustomSnackBar('Successfully fetched latest orders ${ latestOrderList}', isError: false);
    }
    return latestOrderList;
  }

  // Improved getLatestOrders function with error handling
// @override
// Future<List<DeliveryRequestModel>?> getLatestOrders() async {
//   try {
//     final response = await apiClient.getData(AppConstants.GetpendingOrderUri + _getUserToken());
//     if (response.statusCode == 200) {
//       print('Successfully fetched latest orders ${response.body.toString()}');
//       final List<dynamic> body = jsonDecode(response.body) as List<dynamic>;
//       return body.map((order) => DeliveryRequestModel.fromJson(order)).toList();
//     } else {
//       print('Error fetching orders: Status code ${response.statusCode}');
//       return null;
//     }
//   } catch (e) {
//     print('Error fetching latest orders: $e');
//     return null;
//   }
// }


// @override
// Future<List<DeliveryRequestModel>?> getLatestOrders() async {
//   try {
//     final response = await apiClient.getData(AppConstants.GetpendingOrderUri + _getUserToken());
//     if (response.statusCode == 200) {
//            print('Successfully fetched latest orders ${response.body.toString()}');
//       final body = response.body;
//       // Handle empty response
//       if (body is Map<String, dynamic> && body.isEmpty) {
//         return [];
//       }
//       // Handle single object or list
//       if (body is Map<String, dynamic>) {
//         return [DeliveryRequestModel.fromJson(body)];
//       } else if (body is List<dynamic>) {
//         return body.map((order) => DeliveryRequestModel.fromJson(order as Map<String, dynamic>)).toList();
//       }
//       print('Unexpected response type: ${body.runtimeType}');
//       return [];
//     } else {
//       print('Error: Status code ${response.statusCode}');
//       return [];
//     }
//   } catch (e) {
//     print('Error fetching orders: $e');
//     return [];
//   }
// }
// @override
// Future<List<OrderModel>?> getLatestOrders() async {
//   List<OrderModel>? latestOrderList;
//   try {
//     Response response = await apiClient.getData(AppConstants.GetpendingOrderUri + _getUserToken());
//     if (response.statusCode == 200) {
//       if (response.body is List) {
//         latestOrderList = [];
//         (response.body as List<dynamic>).forEach((order) {
//           latestOrderList!.add(OrderModel.fromJson(order));
//         });
//       } else {
//         print('Error: response.body is not a List, got ${response.body.runtimeType}');
//       }
//     } else {
//       print('Error: Failed to fetch orders, status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error fetching orders: $e');
//   }
//   return latestOrderList;
// }
  @override
  Future<ResponseModel> updateOrderStatus(UpdateStatusBodyModel updateStatusBody, List<MultipartBody> proofAttachment) async {
    updateStatusBody.token = _getUserToken();
    ResponseModel responseModel;
    Response response = await apiClient.postMultipartData(AppConstants.updateOrderStatusUri, updateStatusBody.toJson(), proofAttachment, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<List<OrderDetailsModel>?> getOrderDetails(int? orderID) async {
    List<OrderDetailsModel>? orderDetailsModel;
    Response response = await apiClient.getData('${AppConstants.orderDetailsUri}${_getUserToken()}&order_id=$orderID');
    if (response.statusCode == 200) {
      orderDetailsModel = [];
      response.body.forEach((orderDetails) => orderDetailsModel!.add(OrderDetailsModel.fromJson(orderDetails)));
    }
    return orderDetailsModel;
  }

  @override
  Future<ResponseModel> acceptOrder(int? orderID, int? requestId ) async {

    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.acceptOrderUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID , 'request_id': requestId}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  Future<ResponseModel> declineOrder(int? orderID, int? requestId ) async {

    ResponseModel responseModel;
    Response response = await apiClient.postData(AppConstants.declineOrderUri, {"_method": "put", 'token': _getUserToken(), 'order_id': orderID , 'request_id': requestId}, handleError: false);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    }else {
      responseModel = ResponseModel(false, response.statusText);
    }
    return responseModel;
  }

  @override
  List<IgnoreModel> getIgnoreList() {
    List<IgnoreModel> ignoreList = [];
    List<String> stringList = sharedPreferences.getStringList(AppConstants.ignoreList) ?? [];
    for (var ignore in stringList) {
      ignoreList.add(IgnoreModel.fromJson(jsonDecode(ignore)));
    }
    return ignoreList;
  }

  @override
  void setIgnoreList(List<IgnoreModel> ignoreList) {
    List<String> stringList = [];
    for (var ignore in ignoreList) {
      stringList.add(jsonEncode(ignore.toJson()));
    }
    sharedPreferences.setStringList(AppConstants.ignoreList, stringList);
  }

  String _getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  @override
  Future add(value) {
    throw UnimplementedError();
  }

  @override
  Future delete(int? id) {
    throw UnimplementedError();
  }

  @override
  Future update(Map<String, dynamic> body) {
    throw UnimplementedError();
  }

}