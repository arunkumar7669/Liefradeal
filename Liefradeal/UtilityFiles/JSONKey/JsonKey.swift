//
//  JSONKey.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 13/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class JSONKey: NSObject {
    
//    For Item
    static let MENU_CATEGORY = "Menu_Cat"
    static let MENU_SUB_CATEGORY = "subItemsRecord"
    static let ITEM_ID = "ItemID"
    static let ITEM_NAME = "RestaurantPizzaItemName"
    static let ITEM_SIZE = "RestaurantPizzaItemSizeName"
    static let ITEM_OFFER_PRICE = "RestaurantPizzaItemPrice"
    static let ITEM_UPDATED_PRICE = "updatedAmount"
    static let ITEM_DESCRIPTION = "ResPizzaDescription"
    static let ITEM_FOOD_TYPE = "Food_Type_Non"
    static let ITEM_FOOD_IMAGE = "food_Icon"
    static let ITEM_IS_SIZE_AVAILABLE = "sizeavailable"
    static let ITEM_IS_EXTRA_AVAILABLE = "extraavailable"
    static let ITEM_IS_POPULAR = "Food_Popular"
    static let ITEM_IS_ADDED_TO_CART = "isAddedToCart"
    static let ITEM_QUANTITY = "quantity"
    static let ITEM_SIZE_ID = "itemSizeID"
    static let ITEM_EXTRA_ID = "itemExtraID"
    static let ITEM_CHOOSE_CHAUCE_ID = "chooseChauce"
    static let ITEM_IS_EDITABLE = "isEditable"
    static let ITEM_CART_PRICE = "itemCartPrice"
    static let ITEM_ORIGINAL_PRICE = "RestaurantPizzaItemOldPrice"
    static let ITEM_UPDATED_ORIGINAL_PRICE = "originalUpdatedAmount"
    static let ITEM_CART_ORIGINAL_PRICE = "itemCartOriginalPrice"
    static let ITEM_SIZE_NAME = "itemSizeName"
    static let ITEM_EXTRA_NAME = "itemExtraName"
    static let ITEM_SIZE_QUANTITY = "itemSizeQuantity"
    static let ITEM_EXTRA_QUANTITY = "itemExtraQuantity"
    static let ITEM_SIZE_PRICE = "itemSizePrice"
    static let ITEM_EXTRA_PRICE = "itemExtraPrice"
    static let ITEM_FOOD_TAX_APPLICABLE = "food_tax_applicable"
    
//    For Category
    static let MENU_CATEGORY_LIST = "RestaurantMencategory"
    static let CATEGORY_ID = "id"
    static let CATEGORY_NAME = "category_name"
    static let CATEGORY_IMAGE = "category_img"
    static let CATEGORY_DESCRIPTION = "category_description"
    static let CATEGORY_RESTAURANT_ID = "restaurant_id"
    static let CATEGORY_SUB_CATEGORY_OBJECT_ID = "sc_obj_id"
    
//    For Slider
    static let SLIDER_BANNER_LIST = "FrontBannersList"
    static let SLIDER_IMAGE = "app_banner_img"
    
//    For Common
    static let ERROR_CODE = "error"
    static let ERROR_MESSAGE = "error_msg"
    static let SUCCESS_CODE = "success"
    static let SUCCESS_MESSAGE = "success_msg"
    
//    Customer Details
    static let CUSTOMER_COUNTRY_NAME = "customer_country"
    static let CUSTOMER_COUNTRY_CODE = "customer_country_code"
    static let CUSTOMER_POST_CODE = "customer_postcode"
    static let CUSTOMER_FULL_ADDRESS = "customer_full_address"
    static let CUSTOMER_CURRENCY = "customer_currency"
    static let CUSTOMER_DEFAULT_LANGUAGE = "customer_default_langauge"
    static let CUSTOMER_CITY = "customer_city"
    static let CUSTOMER_LATITUDE = "customer_lat"
    static let CUSTOMER_LONGITUDE = "customer_long"
    static let CUSTOMER_LOCALITY = "customer_locality"
    static let API_KEY = "api_key"
    
//    Restaurant Details
    static let RESTAURANT_ID = "id"
    static let RESTAURANT_NAME = "restaurant_name"
    static let RESTAURANT_CURRENCY_SYMBOL = "website_CurrencySymbole"
    static let RESTAURANT_HOME_DELIVERY_AVAILABLE = "HomeDeliveryAvailable"
    static let RESTAURANT_PICKUP_AVAILABLE = "PickupAvailable"
    static let RESTAURANT_DINING_AVAILABLE = "DineInAvailable"
    static let RESTAURANT_CITY = "restaurantCity"
    static let RESTAURANT_CASH_ON_DELIVERY_AVAILABLE = "restaurant_onlycashonAvailable"
    static let RESTAURANT_LOYALTY_POINT_AVAILABLE = "loyalty_program_enable"
    static let RESTAURANT_TABLE_BOOKING_AVAILABLE = "BookaTablesupportAvailable"
    static let RESTAURANT_ONLINE_PAYMENT_AVAILABLE = "restaurant_cardacceptAvailable"
    static let RESTAURANT_PAYLATER_AVAILABLE = "payLater_Available"
    
    static let RESTAURANT_LOGO_IMAGE_URL = "restaurant_Logo"
    static let RESTAURANT_COVER_IMAGE_URL = "restaurant_cover"
    static let RESTAURANT_LATITUDE = "restaurant_LatitudePoint"
    static let RESTAURANT_LONGITUDE = "restaurant_LongitudePoint"
    static let RESTAURANT_CONTACT_NUMBER = "restaurant_contact_mobile"
    static let RESTAURANT_CONTACT_EMAIL = "restaurant_contact_email"
    static let RESTAURANT_ADDRESS = "restaurant_address"
    static let RESTAURANT_ABOUT = "restaurant_about"
    static let RESTAURANT_RATING = "ratingValue"
    
    
//    Item Size
    static let ITEM_SIZE_LIST = "RestaurantMenItemsSize"
    static let SIZE_ID = "id"
    static let SIZE_ITEM_ID = "FoodItemID"
    static let SIZE_ITEM_NAME = "FoodItemName"
    static let SIZE_NAME = "RestaurantPizzaItemName"
    static let SIZE_OFFER_PRICE = "RestaurantPizzaItemPrice"
    static let SIZE_EXTRA_AVAILABLE = "extraavailable"
    static let SIZE_ORIGINAL_PRICE = "RestaurantPizzaItemOldPrice"
    static let SIZE_IS_SELECTED = "isSizeSelected"
    static let SIZE_TITLE = "Size"
    
//    Item Extra Topping
    static let ITEM_EXTRA_TOPPING = "Menu_ItemExtraGroup"
    static let ITEM_EXTRA_TOPPING_LIST = "subExtraItemsRecord"
    static let ITEM_EXTRA_TOPPING_ID = "ExtraID"
    static let ITEM_EXTRA_TOPPING_NAME = "Food_Group_Name"
    static let ITEM_EXTRA_TOPPING_FOOD_NAME = "Food_Addons_Name"
    static let ITEM_EXTRA_TOPPING_PRICE = "Food_Price_Addons"
    static let ITEM_EXTRA_TOPPING_SELECTION_LIMIT = "Free_Topping_Selection_allowed"
    static let ITEM_EXTRA_TOPPING_SELECTION_TYPE = "Food_addons_selection_Type"
    static let ITEM_EXTRA_TOPPING_IS_SELECTED = "isExtraToppingSelected"
    
//    Login & Signup
    static let CUSTOMER_ID = "CustomerId"
    static let USER_NAME = "user_name"
    static let USER_EMAIL = "user_email"
    static let USER_PHONE = "user_phone"
    static let USER_PROFILE_ADDRESS = "user_address"
    static let USER_POSTALCODE = "user_postcode"
    static let USER_PHOTO_URL = "user_photo"
    static let USER_FIRST_NAME = "first_name"
    static let USER_LAST_NAME = "last_name"
    static let USER_FLAT_NAME = "customerFlat_Name"
    static let USER_STREET_NAME = "company_street"
    static let USER_HOUSE_NUMBER = "customerFloor_House_Number"
    static let USER_CITY_NAME = "user_city"
    
//    For Address
    static let USER_ADDRESS = "user"
    static let DELIVERY_ADDRESS = "deliveryaddress"
    static let ADDRESS = "address"
    static let ADDRESS_ID = "id"
    static let POSTAL_CODE = "zipcode"
    static let CITY_NAME = "city_name"
    static let ADDRESS_LATITUDE = "customer_address_lat"
    static let ADDRESS_LONGITUDE = "customer_address_long"
    static let COMPANY_STREET = "company_street"
    static let ADDRESS_TITLE = "address_title"
    static let IS_ADDRESS_SELECTED = "isAddressSelected"
    
//    Apply Coupon
    static let COUPON_CODE_PRICE = "CouponCodePrice"
    
//    Apply coupon
    static let ORDER_DATA = "orders"
    static let ORDER_LIST = "OrderViewResult"
    static let ORDER_ID = "order_identifyno"
    static let ORDER_TIME = "order_time"
    static let ORDER_RESTAURANT_ID = "restaurant_id"
    static let ORDER_RESTAURANT_NAME = "restaurant_name"
    static let ORDER_RESTAURANT_ADDRESS = "restaurant_address"
    static let ORDER_TYPE = "order_type"
    static let ORDER_PRICE = "ordPrice"
    static let ORDER_DATE = "order_date"
    static let ORDER_FOOD_ITEM_LIST = "OrderFoodItem"
    static let ORDER_ITEM_NAME = "ItemsName"
    static let ORDER_ITEM_QUANTITY = "quantity"
    static let ORDER_ITEM_SIZE = "item_size"
    static let ORDER_ITEM_CURRENCY = "Currency"
    static let ORDER_ITEM_PRICE = "menuprice"
    static let ORDER_ITEM_EXTRATOPING = "ExtraTopping"
    static let ORDER_DETAIL_ITEM = "OrderDetailItem"
    static let ORDER_SERVICE_AMOUNT = "ServiceFees"
    static let ORDER_PACKAGE_AMOUNT = "PackageFees"
    static let ORDER_DELIVERY_AMOUNT = "DeliveryCharge"
    static let ORDER_TIP_AMOUNT = "extraTipAddAmount"
    static let ORDER_SALE_TAX = "SalesTaxAmount"
    static let ORDER_VAT_TAX = "VatTax"
    static let ORDER_SUBTOTAL = "subTotal"
    static let ORDER_STATUS = "status"
    static let ORDER_STATUS_MESSAGE = "order_status_msg"
    static let ORDER_CUTOMER_ADDRESS = "order_display_message"
    static let PAYMENT_MODE = "payment_mode"
    static let ORDER_FOOD_TAX_7 = "getFoodTaxTotal7"
    static let ORDER_DRINK_TAX_19 = "getFoodTaxTotal19"
    
//    Restaurant Review
    static let RESTAURANT_REVIEW_DATA = "review"
    static let RESTAURANT_REVIEW_LIST = "RestaurantReviews"
    static let RESTAURANT_REVIEW_ID = "review_id"
    static let RESTAURANT_REVIEW_COMMENT = "customerReviewComment"
    static let RESTAURANT_REVIEW_DATE = "reviewpostedDate"
    static let RESTAURANT_REVIEW_IMAGE = "customerimage"
    static let RESTAURANT_REVIEW_CUSTOMER_NAME = "customerName"
    static let RESTAURANT_REVIEW_DELIVERY_RATING = "deliveryrating"
    static let RESTAURANT_REVIEW_FRIEND_RATING = "friendlinessrating"
    static let RESTAURANT_REVIEW_NAME = "restaurant_name"
    static let RESTAURANT_REVIEW_RATING = "rating"
    static let RESTAURANT_ORDER_ID = "Order_Number"
    
//    Postal Code info
    static let POSTALCODE_MINIMUM_ORDER = "minimum_order"
    static let POSTALCODE_CITY = "Customer_City"
    static let POSTALCODE_SHIPPING_CHARGE = "shipping_charge"
    static let POSTALCODE_DELIVERY_CHARGE = "delivery_charge"
    static let POSTALCODE_POSTAL_CODE = "postcode"
    
//    Loyalty Points
    static let TOTAL_LOYALTY_POINTS = "Total_Loyalty_points"
    static let TOTAL_LOYALTY_AMOUNT = "Total_Loyalty_amount"
    
//    Restaurant Branches
    static let BRANCH_LIST = "RestaurantBranchList"
    static let BRANCH_ID = "id"
    static let BRANCH_NUMBER = "Branch_Mobile"
    static let BRANCH_EMAIL = "Branch_Email"
    static let BRANCH_ADDRESS = "RestaurantBranch_Address"
    static let BRANCH_POSTAL_CODE = "RestaurantBranchZipCode"
    static let BRANCH_LATITUDE = "branch_latitude"
    static let BRANCH_LONGITUDE = "branch_longitude"
    static let BRANCH_RESTAURANT_NAME = "RestaurantBranchName"
    static let BRANCH_DELIVERY_DISTANCE = "Branch_delivery_distance"
    
//    Delivery Area
    static let DELIVERY_AREA_LIST = "DeliveryAreaList"
    static let DELIVERY_AREA_ID = "id"
    static let DELIVERY_AREA_POSTAL_CODE = "postcode"
    static let DELIVERY_AREA_ADMIN_DISTRICT = "Admin_district"
    static let DELIVERY_AREA_LATITUDE = "Postcode_lat"
    static let DELIVERY_AREA_LONGITUDE = "Postcode_long"
    static let DELIVERY_AREA_MIN_RANGE = "min_radius_range"
    static let DELIVERY_AREA_MAX_RANGE = "max_radius_range"
    static let DELIVERY_AREA_MINIMUM_ORDER = "minimum_order"
    static let DELIVERY_AREA_DELIVERY_CHARGE = "delivery_charge"
    static let DELIVERY_AREA_SHIPPING_CHARGE = "shipping_charge"
    static let DELIVERY_AREA_DELIVERY_TIME = "delivery_time"
    
//    Table Details
    static let TABLE_LIST = "TableListList"
    static let TABLE_ID = "id"
    static let TABLE_NUMBER = "table_number"
    static let TABLE_IS_AVAILABLE = "available_for_book"
    static let TABLE_NAME = "table_name"
    static let TABLE_PEOPLE_NUMBER = "number_of_people"
    static let TABLE_IMAGE_ICON = "table_icon_img"
    static let TABLE_SERVICE_CHARGE = "table_service_charge_amount"
    static let TABLE_CHARGE_PER_PERSON = "tabl_per_person_charge"
    static let TABLE_DISCOUNT_PERCENTAGE = "table_discount_amount"
    static let TABLE_MINIMUM_DIPOSIT_PERCENTAGE = "minimum_deposit_percentage"
    static let TABLE_DISCOUNT_AVAILABLE_DAYS = "discount_available_days"
    static let TABLE_BOOK_RANDOM_NUMBER = "table_book_random_number"
    
//    Manage Ticket
    static let TICKET_LIST = "ComplaintsHistory"
    static let TICKET_ID = "complaint_id"
    static let TICKET_ORDER_ID = "orderIDNumber"
    static let TICKET_MESSAGE = "orderIssueMessage"
    static let TICKET_ISSUE = "orderIssue"
    static let TICKET_STATUS = "Order_Status_Message"
    static let TICKET_REPLY = "restaurant_order_issue_reply"
    
//    Loyalty Points
    static let LOYALTY_POST_REVIEW = "post_review_points"
    static let LOYALTY_PER_ORDER = "per_order_loyality_point"
    static let LOYALTY_REFER_FRIEND = "refer_friends_points"
    static let LOYALTY_SPEND_MORE = "spend_more_than_points"
    static let LOYALTY_BIRTHDAY_CELEBRATION = "birthday_celebrations_points"
    static let LOYALTY_MEDIA_SHARE = "social_media_sharing_points"
    static let LOYALTY_FIRST_ORDER = "place_first_orders_points"
    static let LOYALTY_SIGN_UP_POINT = "sign_points"
    static let LOYALTY_GROUP_ORDERING = "place_group_ordering_points"
    
//    Gallery
    static let GALLERY_PHOTO = "GalleryPhoto"
    static let GALLERY_LIST = "FoodGalleryList"
    static let GALLERY_CATEGORY_ID = "photo_tab_id"
    static let GALLERY_CATEGORY_NAME = "tab_name"
    static let GALLERY_PHOTO_ID = "PhotoID"
    static let GALLERY_PHOTO_TITLE = "restaurant_ImageTitle"
    static let GALLERY_PHOTO_URL = "food_photo"
    
//    Offer
    static let OFFER_ID = "id"
    static let OFFER_TITLE_NAME = "CouponTitle"
    static let OFFER_DESCRIPTION = "coupon_description"
    static let OFFER_COUPON_CODE = "CouponCode"
    static let OFFER_COUPON_IMAGE = "coupon_img"
    static let OFFER_COUPON_LIMIT = "CouponValidTill"
}
