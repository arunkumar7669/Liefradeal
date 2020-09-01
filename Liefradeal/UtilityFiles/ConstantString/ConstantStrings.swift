//
//  ConstantStrings.swift
//  HarpersKabab
//
//  Created by Arun Kumar Rathore on 01/06/20.
//  Copyright © 2020 arunkumar. All rights reserved.
//

import UIKit

class ConstantStrings: NSObject {

    static let SELECTED_CHECK_BOX = "check_box"
    static let UNSELECTED_CHECK_BOX = "uncheck_box"
    
//    static let RUPEES_SYMBOL = "₹"
    static let RUPEES_SYMBOL = appCurrencySymbol
    static var CUSTOMER_MIN_DISTANCE = Double()
    
    static let VEG_IMAGE = ""
    static let NON_VEG_IMAGE = "food_type"
    
    static let VEG_FOOD_TYPE = "1"
    static let NON_VEG_FOOD_TYPE = "2"
    
    static let ITEM_ADDED_TO_CART = "1"
    static let ITEM_NOT_ADDED_TO_CART = "0"
    
    static let SELECTED_VALUE = "1"
    static let UNSELECTED_VALUE = "0"
    
    static let FOOD_TAX_7 = "7"
    static let FOOD_TAX_19 = "19"
    
    static var OK_STRING = "Ok"
    static var CANCEL_STRING = "Cancel"
    static let WELCOME_GUEST_STRING = "Welcome Guest"
    
    static let SELECTED_RADIO_BUTTON = "selected_radio"
    static let UNSELECTED_RADIO_BUTTON = "unselected_radio"
    static let CATGORY_PLACEHOLDER = "category_placeholder"
    static let SELECTED_ADDRESS_IMAGE = "selected_address"
    static let UNSELECTED_ADDRESS_IMAGE = "un_selected_address"
    
    static let FALSE_STRING = "No"
    static let TRUE_STRING = "Yes"
    
    static let DEVICE_VERSION = "iOS"
    
//    Food Status
    static let ORDER_RECIEVED_STATUS = 1
    static let ORDER_PREPARED_STATUS = 2
    static let ORDER_OUT_OF_DELIVERY_STATUS = 3
    static let ORDER_DELIVERED_STATUS = 4
    
//    Order Type Value
    static let ORDER_TYPE_VALUE = "orderType"
    static let POSTAL_CODE_STRING = "postalCodeString"
    static let ORDER_TYPE_DELIVERY = 1
    static let ORDER_TYPE_PICKUP = 2
    static let ORDER_TYPE_DINING = 3
    
    static var ORDER_TYPE_DELIVERY_STRING = "Delivery"
    static var ORDER_TYPE_PICKUP_STRING = "Pickup"
    static var ORDER_TYPE_DINING_STRING = "EAT-IN"
    static var ORDER_STATUS_CANCELLED = "Cancelled"
    static let ITEM_EXTRA_TOPPING_SELECTION_TYPE = "Checkbox"
    
//    Constant for User Defaults
    static let IS_GUEST_USER = "isGuestUser"
    static let IS_USER_LOGGED_IN = "isUserLoggedIn"
    
//    Userdefaults Store data string
    static let HOME_SLIDER_IMAGE = "homeSliderImage"
    static let CATEGORY_LIST = "categoryList"
    static let RESTAURANT_INFORMATION = "restaurantInformation"
    static let LOCATION_DATA = "locationData"
    static let RECOMMENDED_DATA = "recommendedData"
    static let RESTAURANT_INFO = "restaurantInfo"
    static let USER_LOCATION_INFO = "userLocationInfo"
    static let CART_ITEM_LIST = "cartItemList"
    static let USER_DETAILS = "userDetails"
    static let COUNTRY_CODE = "countryCode"
    static let POSTAL_CODE_INFO = "postalCodeInfo"
    static let LOYALTY_POINTS = "loyaltyPoints"
    static let IS_COUPON_APPLIED = "isCouponApplied"
    static let IS_LOYALTY_POINTS_REDEEMED = "isLoyaltyPointsRedeemed"
    static let APPLIED_COUPON_CODE = "appliedCouponCode"
    static let APPLIED_COUPON_AMOUNT = "appliedCouponAmount"
    static let APPLIED_LOYALTY_POINTS_AMOUNT = "appliedLoyalityPointsAmount"
    static let APPLIED_LOYALTY_POINTS = "appliedLoyalityPoints"
    static let STRIPE_PAYMENT_PUBLISH_KEY = "stripePaymentPublishKey"
    static let REFERRAL_STRING = "referralString"
    static let REFERRAL_CODE = "referralCode"
    static let REFERRAL_CODE_MESSAGE = "referralCodeMessage"
    static let REFERRAL_CODE_SHARE_FRIEND = "referralCodeShareFriend"
    static let SELECTED_TABLE_NUMBER = "selectedTableNumber"
    static let PAYPAL_CLIENT_KEY = "paypalClientKey"
    static let PAYPAL_SECRET_KEY = "paypalSecretKey"
    static let RESTAURANT_BRANCH_LIST = "restaurantBranchList"
    static let SELECTED_EAT_IN_BRANCH = "selectedEAT-INBranch"
    static let SEND_ORDER_KITCHEN_ID = "sendOrderKitchenID"
    static let SEND_ORDER_KITCHEN_LIST = "sendOrderKitchenList"
    static let MULTI_LANGUAGE_JSON_DATA = "multiLanguageJsonData"
    static let TABLE_PERSON_COUNT = "tablePersonCount"
    
//    Message for display
    static var ALERT = "Alert"
    static var INVALID = "Invalid"
    static var NETORK_ISSUE = "Network Issue"
    static var ITEMS = "Item(s)"
    
    static var DATA_IS_NOT_AVAILABLE = "Data isn't available here."
    static var FIRST_NAME_FIELD_IS_REQUIRED = "First name field is required."
    static var USERNAME_FIELD_IS_REQUIRED = "Username field is required."
    static var PASSWORD_FIELD_IS_REQUIRED = "Password field is required."
    static var MOBILE_NO_FIELD_IS_REQUIRED = "Mobile no field is required."
    static var MESSAGE_FIELD_IS_REQUIRED = "Message field is required."
    static var EMAIL_FIELD_IS_REQUIRED = "Email field is required."
    static var PLEASE_ENTER_VALID_MOBILE = "Please enter valid mobile no."
    static var PLEASE_ENTER_VALID_EMAIL = "Please enter valid email ID."
    static var ADDRESS_FIELD_IS_REQUIRED = "Address field is requied."
    static var DEVICE_DOES_NOT_SUPPORT_CAMERA = "Camera is not available on this device."
    static var COULD_NOT_CONNECT_TO_SERVER = "Could not connect to server please try again."
    static var FIRSTLY_PLEASE_ADD_INTO_CART = "Please firstly add into cart."
    static var ITEM_HAS_BEEN_ADDED_INTO_CART = "Item has been added into cart."
    static var SUCCESSFULLY_LOGGED_IN = "You are successfully logged in."
    static var ADDRESS_TITLE_FIELD_IS_REQUIRED = "Address title field is required."
    static var POSTAL_CODE_FIELD_IS_REQUIRED = "Postal code field is required."
    static var CITY_NAME_FIELD_IS_REQUIRED = "City name field is required."
    static var PLEASE_ENTER_VALID_POSTAL_CODE = "Please enter valid 6 digit postal code."
    static var PLEASE_SELECT_ORDER_TYPE = "Please select order type."
    static var APPLY_COUPON_IS_REQUIRED = "Apply coupon field is required."
    static var YOUR_COUPON_HAS_BEEN_APPLIED_SUCCESSFULLY = "Your coupon has been applied is successfully."
    static var PLEASE_SELECT_ADDRESS = "Please select address for delivery."
    static var PLEASE_SELECT_PAYMENT_MODE = "Please select payment mode."
    static var YOUR_CART_IS_EMPTY = "Cart is empty. Please add at least one item in your cart."
    static var NO_ORDER_YET = "No order yet."
    static var HOME_NUMBER_IS_REQUIRED = "House/Door/Flat number field is required."
    static var STREET_NAME_IS_REQUIRED = "Street name field is required."
    static var ENTER_VALID_POSTAL_CODE = "Please enter valid postal code."
    static var PLEASE_LOGIN_FIRSTLY = "Please login firstly."
    static var FLAT_NAME_IS_REQUIRED = "Flat name field is required."
    static var WRITE_REVIEW_IS_REQUIRED = "Write review field is required."
    static var RATING_REVIEW_COULD_NOT_SUBMITTED = "Your rating and review could not submitted. Plese try again later."
    static var OLD_PASSWORD_IS_REQUIRED = "Old Password field is required."
    static var NEW_PASSWORD_IS_REQUIRED = "New Password field is required."
    static var RE_TYPE_PASSWORD_IS_REQUIRED = "Re-Type Password field is required."
    static var BOTH_PASSWORD_SHOULD_BE_SAME = "New Password and Re-Type Password should be same."
    static var YOU_HAVE_ZERO_LOYALTY_POINTS = "You have 0 loyalty points. So you can not redeem it."
    static var ARE_YOU_SURE_YOU_WANT_TO_LOGOUT = "Are you sure you want logout?"
    static var PLEASE_CHOOSE_ONE_OPTION = "Please choose one option."
    
//    new for language
    static var YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = "You need to login first for book a table."
    static var NO_CORDINATES_AVAILABLE = "No cordinates available."
    static var NO_PICTURE_UPLOADED_YET = "No picture uploaded yet."
    static var NO_OFFER_AVAILABLE = "No offer available."
    static var LOYALTY_POINT_FIELD_IS_REQUIRED = "Loyalty point field is required."
    static var PLEASE_ENTER_MORE_THAN_POINTS = "Please enter more than 0 points."
    static var YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS = "You do not have enough loyalty points."
    static var YOUR_ORDER_COULD_NOT_PLACED = "Your order could not be placed. Please try again."
    static var PLEASE_SELECT_PAYMENT_METHOD = "Please select payment method."
    static var GO_TO_MENU = "Go to Menu"
    static var CONFIRM_DELIVERY_ADDRESS = "Confirm Delivery Address"
    static var PHONE_NUMBER = "Mobile Number"
    static var CONFIRM_AND_PAY = "Confirm & Pay"
    static var ITEM_HAS_BEEN_ADDED_IN_PAY_LATER_ORDER = "Item has been added in pay later order."
    static var PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING = "Please choose at least one topping."
    static var WRITE_A_REVIEW = "Write a Review"
    static var CONTINUE_ORDER = "Continue Order"
    static var YOU_ARE_NOT_AVAILABLE_AT_ANY_BRANCH = "Sorry! You are not available any branch so you can not place order."
    static var NEW_ITEM_ADDED = "New Item(s) Added"
    static var SEND_ORDER_TO_KITCHEN = "Send order to Kitchen"
    static var ORDER_SENT_TO_THE_KITCHEN = "Your order has been sent to kitchen successfully."
    static var YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW = "You can not edit your order which is sent to the kitchen so please add new item."
    static var YOUR_LANGUAGE_HAS_BEEN_CHANGED = "Your language has been changed successfully."
    static var PLEASE_SELECT_OPTION = "Please select option."
    static var SIZE_NOT_AVAILABLE = "Size is not available."
    static var PLEASE_SELECT_RESTAURANT_BRANCH = "Please select restaurant branch."
    static var ARE_YOU_SURE_YOU_WANT_DELETE_ADDRESS = "Are you sure you want delete this address?"
    
    static var CUSTOMER_NAME_IS_REQUIRED = "Please enter customer name"
    static var CUSTOMER_MOBILE_NUMBER_IS_REQUIRED = "Please enter customer mobile number"
    static var BOOKING_TIME_IS_REQUIRED = "Please enter booking time"
    static var BOOKING_DATE_IS_REQUIRED = "Please enter booking date"
    static var PLEASE_SELECT_TABLE_NUMBER = "Please select table"
    static var YOUR_ORDER_COUNT_NOT_CANCEL = "Your order could not be cancelled. Please try again."
    static var WE_COULD_NOT_TRACK_ORDER = "Sorry we are not able to track your order now. Please try again."
    static var NO_ANY_COMPLAINT = "There is no any complaints."
    static var YOUR_PROFILE_COULD_NOT_UPDATED = "Your profile could not be updated. Please try again."
}

//new for language
//YOUR_HAVE_CHOOSED_FREE_TOPPING = You have been choosed your $ free topping.          Done
//CHOOSE_ANY_FREE_TOPINGS = Choose Any $ Topping Free          Done
//PAY_NOW = Pay Now
//LANGUAGE_SETTINGS = "Language Settings"          Done
//YOU_NEED_TO_LOGIN_FIRST_FOR_BOOK_TABLE = "You need to login first for book a table."          Done
//NO_CORDINATES_AVAILABLE = "No cordinates available."          Done
//NO_PICTURE_UPLOADED_YET = "No picture uploaded yet."          Done
//NO_OFFER_AVAILABLE = "No offer available."          Done
//PLEASE_ENTER_MORE_THAN_POINTS = "Please enter more than 0 points."          Done
//YOU_DO_NOTE_HAVE_ENOUGH_LOYALTY_POINTS = "You do not have enough loyalty points."          Done
//YOUR_ORDER_COULD_NOT_PLACED = "Your order could not be placed. Please try again."          Done
//PLEASE_CHOOSE_AT_LEAST_ONE_TOPPING = "Please choose at least one topping."          Done
//NEW_ITEM_ADDED = "New Item(s) Added"          Done
//SEND_ORDER_TO_KITCHEN = "Send order to Kitchen"          Done
//YOU_CAN_NOT_EDIT_YOUR_ORDER_NOW = "You can not edit your order which is sent to the kitchen so please add new item."          Done
//YOUR_LANGUAGE_HAS_BEEN_CHANGED = "Your language has been changed successfully."          Done
//PLEASE_SELECT_OPTION = "Please select option."          Done
//SIZE_NOT_AVAILABLE = "Size is not available."          Done
//MIN_DELIVERY_LIMIT = "Sorry! Delivery is available at this address more then $ amount."          Done
//TOTAL_ITEM_IN_CART = "Total $ Items"\          Done
//WOOPS = "WOOPS!"          Done
//LOOK_LIKE_YOU_HAVE = "Looks like you haven't \n made your choice yet."          Done
//Food_Discount = “Food Discount”          Done
//PLEASE_SELECT_RESTAURANT_BRANCH = "Please select restaurant branch."
//GO_TO_HOME = "Go to Home"
//PAY_STRING = "Pay"
//NO_RESTAURANT_REVIEW = "No restaurant review yet."
//SPECIAL_OPENING_HOURS = "Specials Opening hours"
//NO_BRANCHES_AVAILABEL = "No Branches available."
//NO_DELIVERY_AREA_AVAILABLE = "No Delivery area available."
//YOU_CAN_NOT_SELECT_MORE_THAN_TABLE_LIMIT = "You can not select person more than table limit."
//YOU_CAN_NOT_SELECT_LESS_PERSON = "You can not select less than 1 person."
//TABLE_NUMBER_HAS_BEEN_BOOKED = "Table no $ has been already booked. So please choose another table."
//Your_booking_number = "Your booking number is"
//Note_string = "Note"
//YOU_WANT_TO_CANCEL_ADDRESS = "Are you sure you want cancel this order?"
//YOUR_ORDER_COUNT_NOT_CANCEL = "Your order could not be cancelled. Please try again."
//WE_COULD_NOT_TRACK_ORDER = "Sorry we are not able to track your order now. Please try again."
//NO_REVIEW_AVAILABLE = "No reviews available."
//NO_ANY_COMPLAINT = "There is no any complaints."
//Reply = "Reply"
//Looking_For = "Looking For"
//Friend = "Friend"
//Forgort_Password = "Forgot Password"


//Latest - 24 Aug, 2020
//Scan_Table_QR = "Scan Table QR"
//No_QR_code_is_detected = "No QR code is detected"
//NO_SITTING_AVAILABLE = "No sitting Table available."
//YOU_ARE_CURRENTLY_HERE = "You are currently in this restaurant"
//Book_Now = "Book Now"
//Search_Table_Number = "Search Table Number"



//Get_Started = "Get Started"
