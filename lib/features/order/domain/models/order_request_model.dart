import 'dart:convert';

class DeliveryRequestModel {
  int? id;
  int? orderId;
  int? deliverymanId;
  String? status;
  String? requestedAt;
  String? createdAt;
  String? updatedAt;
  Order? order;

  DeliveryRequestModel({
    this.id,
    this.orderId,
    this.deliverymanId,
    this.status,
    this.requestedAt,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  DeliveryRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    deliverymanId = json['deliveryman_id'];
    status = json['status'];
    requestedAt = json['requested_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['deliveryman_id'] = deliverymanId;
    data['status'] = status;
    data['requested_at'] = requestedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    return data;
  }
}

class Order {
  int? id;
  int? userId;
  double? orderAmount;
  double? couponDiscountAmount;
  String? couponDiscountTitle;
  String? paymentStatus;
  String? orderStatus;
  double? totalTaxAmount;
  String? paymentMethod;
  String? transactionReference;
  int? deliveryAddressId;
  int? deliveryManId;
  String? couponCode;
  String? orderNote;
  String? orderType;
  int? checked;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  double? deliveryCharge;
  String? scheduleAt;
  String? callback;
  String? otp;
  String? pending;
  String? accepted;
  String? confirmed;
  String? processing;
  String? handover;
  String? pickedUp;
  String? delivered;
  String? canceled;
  String? refundRequested;
  String? refunded;
  DeliveryAddress? deliveryAddress;
  int? scheduled;
  double? storeDiscountAmount;
  double? originalDeliveryCharge;
  String? failed;
  String? adjusment;
  int? edited;
  String? deliveryTime;
  int? zoneId;
  int? moduleId;
  String? orderAttachment;
  int? parcelCategoryId;
  DeliveryAddress? receiverDetails;
  String? chargePayer;
  double? distance;
  double? dmTips;
  String? freeDeliveryBy;
  String? refundRequestCanceled;
  bool? prescriptionOrder;
  String? taxStatus;
  int? dmVehicleId;
  String? cancellationReason;
  String? canceledBy;
  String? couponCreatedBy;
  String? discountOnProductBy;
  String? processingTime;
  String? unavailableItemNote;
  bool? cutlery;
  String? deliveryInstruction;
  double? taxPercentage;
  double? additionalCharge;
  String? orderProof;
  double? partiallyPaidAmount;
  bool? isGuest;
  double? flashAdminDiscountAmount;
  double? flashStoreDiscountAmount;
  String? cashBackId;
  double? extraPackagingAmount;
  double? refBonusAmount;
  String? moduleType;
  List<String>? orderAttachmentFullUrl;
  List<String>? orderProofFullUrl;
  List<dynamic>? storage;
  Module? module;

  Order({
    this.id,
    this.userId,
    this.orderAmount,
    this.couponDiscountAmount,
    this.couponDiscountTitle,
    this.paymentStatus,
    this.orderStatus,
    this.totalTaxAmount,
    this.paymentMethod,
    this.transactionReference,
    this.deliveryAddressId,
    this.deliveryManId,
    this.couponCode,
    this.orderNote,
    this.orderType,
    this.checked,
    this.storeId,
    this.createdAt,
    this.updatedAt,
    this.deliveryCharge,
    this.scheduleAt,
    this.callback,
    this.otp,
    this.pending,
    this.accepted,
    this.confirmed,
    this.processing,
    this.handover,
    this.pickedUp,
    this.delivered,
    this.canceled,
    this.refundRequested,
    this.refunded,
    this.deliveryAddress,
    this.scheduled,
    this.storeDiscountAmount,
    this.originalDeliveryCharge,
    this.failed,
    this.adjusment,
    this.edited,
    this.deliveryTime,
    this.zoneId,
    this.moduleId,
    this.orderAttachment,
    this.parcelCategoryId,
    this.receiverDetails,
    this.chargePayer,
    this.distance,
    this.dmTips,
    this.freeDeliveryBy,
    this.refundRequestCanceled,
    this.prescriptionOrder,
    this.taxStatus,
    this.dmVehicleId,
    this.cancellationReason,
    this.canceledBy,
    this.couponCreatedBy,
    this.discountOnProductBy,
    this.processingTime,
    this.unavailableItemNote,
    this.cutlery,
    this.deliveryInstruction,
    this.taxPercentage,
    this.additionalCharge,
    this.orderProof,
    this.partiallyPaidAmount,
    this.isGuest,
    this.flashAdminDiscountAmount,
    this.flashStoreDiscountAmount,
    this.cashBackId,
    this.extraPackagingAmount,
    this.refBonusAmount,
    this.moduleType,
    this.orderAttachmentFullUrl,
    this.orderProofFullUrl,
    this.storage,
    this.module,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderAmount = json['order_amount']?.toDouble();
    couponDiscountAmount = json['coupon_discount_amount']?.toDouble();
    couponDiscountTitle = json['coupon_discount_title'];
    paymentStatus = json['payment_status'];
    orderStatus = json['order_status'];
    totalTaxAmount = json['total_tax_amount']?.toDouble();
    paymentMethod = json['payment_method'];
    transactionReference = json['transaction_reference'];
    deliveryAddressId = json['delivery_address_id'];
    deliveryManId = json['delivery_man_id'];
    couponCode = json['coupon_code'];
    orderNote = json['order_note'];
    orderType = json['order_type'];
    checked = json['checked'];
    storeId = json['store_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deliveryCharge = json['delivery_charge']?.toDouble();
    scheduleAt = json['schedule_at'];
    callback = json['callback'];
    otp = json['otp'];
    pending = json['pending'];
    accepted = json['accepted'];
    confirmed = json['confirmed'];
    processing = json['processing'];
    handover = json['handover'];
    pickedUp = json['picked_up'];
    delivered = json['delivered'];
    canceled = json['canceled'];
    refundRequested = json['refund_requested'];
    refunded = json['refunded'];
    if (json['delivery_address'] != null && json['delivery_address'] is String) {
      deliveryAddress = DeliveryAddress.fromJson(jsonDecode(json['delivery_address']));
    }
    scheduled = json['scheduled'];
    storeDiscountAmount = json['store_discount_amount']?.toDouble();
    originalDeliveryCharge = json['original_delivery_charge']?.toDouble();
    failed = json['failed'];
    adjusment = json['adjusment'];
    edited = json['edited'];
    deliveryTime = json['delivery_time'];
    zoneId = json['zone_id'];
    moduleId = json['module_id'];
    orderAttachment = json['order_attachment'];
    parcelCategoryId = json['parcel_category_id'];
    receiverDetails = json['receiver_details'] != null ? DeliveryAddress.fromJson(jsonDecode(json['receiver_details'])) : null;
    chargePayer = json['charge_payer'];
    distance = json['distance']?.toDouble();
    dmTips = json['dm_tips']?.toDouble();
    freeDeliveryBy = json['free_delivery_by'];
    refundRequestCanceled = json['refund_request_canceled'];
    prescriptionOrder = json['prescription_order'];
    taxStatus = json['tax_status'];
    dmVehicleId = json['dm_vehicle_id'];
    cancellationReason = json['cancellation_reason'];
    canceledBy = json['canceled_by'];
    couponCreatedBy = json['coupon_created_by'];
    discountOnProductBy = json['discount_on_product_by'];
    processingTime = json['processing_time'];
    unavailableItemNote = json['unavailable_item_note'];
    cutlery = json['cutlery'];
    deliveryInstruction = json['delivery_instruction'];
    taxPercentage = json['tax_percentage']?.toDouble();
    additionalCharge = json['additional_charge']?.toDouble();
    orderProof = json['order_proof'];
    partiallyPaidAmount = json['partially_paid_amount']?.toDouble();
    isGuest = json['is_guest'];
    flashAdminDiscountAmount = json['flash_admin_discount_amount']?.toDouble();
    flashStoreDiscountAmount = json['flash_store_discount_amount']?.toDouble();
    cashBackId = json['cash_back_id'];
    extraPackagingAmount = json['extra_packaging_amount']?.toDouble();
    refBonusAmount = json['ref_bonus_amount']?.toDouble();
    moduleType = json['module_type'];
    orderAttachmentFullUrl = json['order_attachment_full_url'] != null ? List<String>.from(json['order_attachment_full_url']) : [];
    orderProofFullUrl = json['order_proof_full_url'] != null ? List<String>.from(json['order_proof_full_url']) : [];
    storage = json['storage'] != null ? List<dynamic>.from(json['storage']) : [];
    module = json['module'] != null ? Module.fromJson(json['module']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_amount'] = orderAmount;
    data['coupon_discount_amount'] = couponDiscountAmount;
    data['coupon_discount_title'] = couponDiscountTitle;
    data['payment_status'] = paymentStatus;
    data['order_status'] = orderStatus;
    data['total_tax_amount'] = totalTaxAmount;
    data['payment_method'] = paymentMethod;
    data['transaction_reference'] = transactionReference;
    data['delivery_address_id'] = deliveryAddressId;
    data['delivery_man_id'] = deliveryManId;
    data['coupon_code'] = couponCode;
    data['order_note'] = orderNote;
    data['order_type'] = orderType;
    data['checked'] = checked;
    data['store_id'] = storeId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['delivery_charge'] = deliveryCharge;
    data['schedule_at'] = scheduleAt;
    data['callback'] = callback;
    data['otp'] = otp;
    data['pending'] = pending;
    data['accepted'] = accepted;
    data['confirmed'] = confirmed;
    data['processing'] = processing;
    data['handover'] = handover;
    data['picked_up'] = pickedUp;
    data['delivered'] = delivered;
    data['canceled'] = canceled;
    data['refund_requested'] = refundRequested;
    data['refunded'] = refunded;
    if (deliveryAddress != null) {
      data['delivery_address'] = jsonEncode(deliveryAddress!.toJson());
    }
    data['scheduled'] = scheduled;
    data['store_discount_amount'] = storeDiscountAmount;
    data['original_delivery_charge'] = originalDeliveryCharge;
    data['failed'] = failed;
    data['adjusment'] = adjusment;
    data['edited'] = edited;
    data['delivery_time'] = deliveryTime;
    data['zone_id'] = zoneId;
    data['module_id'] = moduleId;
    data['order_attachment'] = orderAttachment;
    data['parcel_category_id'] = parcelCategoryId;
    if (receiverDetails != null) {
      data['receiver_details'] = jsonEncode(receiverDetails!.toJson());
    }
    data['charge_payer'] = chargePayer;
    data['distance'] = distance;
    data['dm_tips'] = dmTips;
    data['free_delivery_by'] = freeDeliveryBy;
    data['refund_request_canceled'] = refundRequestCanceled;
    data['prescription_order'] = prescriptionOrder;
    data['tax_status'] = taxStatus;
    data['dm_vehicle_id'] = dmVehicleId;
    data['cancellation_reason'] = cancellationReason;
    data['canceled_by'] = canceledBy;
    data['coupon_created_by'] = couponCreatedBy;
    data['discount_on_product_by'] = discountOnProductBy;
    data['processing_time'] = processingTime;
    data['unavailable_item_note'] = unavailableItemNote;
    data['cutlery'] = cutlery;
    data['delivery_instruction'] = deliveryInstruction;
    data['tax_percentage'] = taxPercentage;
    data['additional_charge'] = additionalCharge;
    data['order_proof'] = orderProof;
    data['partially_paid_amount'] = partiallyPaidAmount;
    data['is_guest'] = isGuest;
    data['flash_admin_discount_amount'] = flashAdminDiscountAmount;
    data['flash_store_discount_amount'] = flashStoreDiscountAmount;
    data['cash_back_id'] = cashBackId;
    data['extra_packaging_amount'] = extraPackagingAmount;
    data['ref_bonus_amount'] = refBonusAmount;
    data['module_type'] = moduleType;
    data['order_attachment_full_url'] = orderAttachmentFullUrl;
    data['order_proof_full_url'] = orderProofFullUrl;
    data['storage'] = storage;
    if (module != null) {
      data['module'] = module!.toJson();
    }
    return data;
  }
}

class DeliveryAddress {
  String? contactPersonName;
  String? contactPersonNumber;
  String? contactPersonEmail;
  String? addressType;
  String? address;
  String? floor;
  String? road;
  String? house;
  String? longitude;
  String? latitude;

  DeliveryAddress({
    this.contactPersonName,
    this.contactPersonNumber,
    this.contactPersonEmail,
    this.addressType,
    this.address,
    this.floor,
    this.road,
    this.house,
    this.longitude,
    this.latitude,
  });

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    contactPersonName = json['contact_person_name'];
    contactPersonNumber = json['contact_person_number'];
    contactPersonEmail = json['contact_person_email'];
    addressType = json['address_type'];
    address = json['address'];
    floor = json['floor'];
    road = json['road'];
    house = json['house'];
    longitude = json['longitude'];
    latitude = json['latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['contact_person_name'] = contactPersonName;
    data['contact_person_number'] = contactPersonNumber;
    data['contact_person_email'] = contactPersonEmail;
    data['address_type'] = addressType;
    data['address'] = address;
    data['floor'] = floor;
    data['road'] = road;
    data['house'] = house;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    return data;
  }
}

class Module {
  int? id;
  String? moduleName;
  String? moduleType;
  String? thumbnail;
  String? status;
  int? storesCount;
  String? createdAt;
  String? updatedAt;
  String? icon;
  int? themeId;
  String? description;
  int? allZoneService;
  String? iconFullUrl;
  String? thumbnailFullUrl;
  List<Storage>? storage;
  List<Translation>? translations;

  Module({
    this.id,
    this.moduleName,
    this.moduleType,
    this.thumbnail,
    this.status,
    this.storesCount,
    this.createdAt,
    this.updatedAt,
    this.icon,
    this.themeId,
    this.description,
    this.allZoneService,
    this.iconFullUrl,
    this.thumbnailFullUrl,
    this.storage,
    this.translations,
  });

  Module.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    moduleName = json['module_name'];
    moduleType = json['module_type'];
    thumbnail = json['thumbnail'];
    status = json['status'];
    storesCount = json['stores_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    icon = json['icon'];
    themeId = json['theme_id'];
    description = json['description'];
    allZoneService = json['all_zone_service'];
    iconFullUrl = json['icon_full_url'];
    thumbnailFullUrl = json['thumbnail_full_url'];
    if (json['storage'] != null) {
      storage = <Storage>[];
      json['storage'].forEach((v) {
        storage!.add(Storage.fromJson(v));
      });
    }
    if (json['translations'] != null) {
      translations = <Translation>[];
      json['translations'].forEach((v) {
        translations!.add(Translation.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['module_name'] = moduleName;
    data['module_type'] = moduleType;
    data['thumbnail'] = thumbnail;
    data['status'] = status;
    data['stores_count'] = storesCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['icon'] = icon;
    data['theme_id'] = themeId;
    data['description'] = description;
    data['all_zone_service'] = allZoneService;
    data['icon_full_url'] = iconFullUrl;
    data['thumbnail_full_url'] = thumbnailFullUrl;
    if (storage != null) {
      data['storage'] = storage!.map((v) => v.toJson()).toList();
    }
    if (translations != null) {
      data['translations'] = translations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Storage {
  int? id;
  String? dataType;
  String? dataId;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Storage({
    this.id,
    this.dataType,
    this.dataId,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Storage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dataType = json['data_type'];
    dataId = json['data_id'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['data_type'] = dataType;
    data['data_id'] = dataId;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Translation {
  int? id;
  String? translationableType;
  int? translationableId;
  String? locale;
  String? key;
  String? value;
  String? createdAt;
  String? updatedAt;

  Translation({
    this.id,
    this.translationableType,
    this.translationableId,
    this.locale,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  Translation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    translationableType = json['translationable_type'];
    translationableId = json['translationable_id'];
    locale = json['locale'];
    key = json['key'];
    value = json['value'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['translationable_type'] = translationableType;
    data['translationable_id'] = translationableId;
    data['locale'] = locale;
    data['key'] = key;
    data['value'] = value;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}