
import 'dart:async';
import 'dart:io';


import 'package:feedme_vendor/Onboarding/Login/model_login.dart';
import 'package:feedme_vendor/Onboarding/Login/model_logout.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelAddBank.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelDelete.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelEarning.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelLoginStripe.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelPayout.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelSocial.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelStatusUpdate.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelTokenUpdate.dart';
import 'package:feedme_vendor/Onboarding/Models/ModelchangePassword.dart';
import 'package:feedme_vendor/Onboarding/Models/catModel.dart';
import 'package:feedme_vendor/Onboarding/Models/editModel.dart';
import 'package:feedme_vendor/Onboarding/Models/forgotModel.dart';
import 'package:feedme_vendor/Onboarding/Models/menuModel.dart';
import 'package:feedme_vendor/Onboarding/Registration/model_register.dart';
import 'package:feedme_vendor/Screens/ModelOrders.dart';
import 'package:feedme_vendor/Screens/ModelStatus.dart';

import 'network_utils.dart';



class RestDatasource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final BASE_URL = "http://13.58.214.98:8700/api/";
  static final CHANGE_PASS = BASE_URL + "changepassword";
  static final SIGNUP_URL = BASE_URL + "registervendor";
  static final REGISTER_SOCIAL = BASE_URL + "register_social";
  static final LOGIN_URL = BASE_URL + "login";
  static final CATEGORY = BASE_URL + "category_listing";
  static final LOGOUT = BASE_URL + "logout";
  static final EDIT_VENDOR = BASE_URL + "editVendorProfile";
  static final GET_MENU = BASE_URL + "menulisting_vendorId";
  static final GET_ORDERS = BASE_URL + "vendor_order_listing";
  static final DELETE_ITEM = BASE_URL + "delete_item";
  static final UPDATE_STATUS = BASE_URL + "order_status";
  static final FORGOT_PASSWORD = BASE_URL + "forgotpassword";
  static final LOGIN_STRIPE = BASE_URL + "Login_stripe";
  static final UPDATE_PROFILE_STATUS = BASE_URL + "updateStatus";
  static final ADD_BANK = BASE_URL + "addBank";
  static final PAY_OUT = BASE_URL + "payout";
  static final EARNING = BASE_URL + "earning";
  static final UPDATE_TOKEN = BASE_URL + "firebase_token";



  Future<ModelRegister> register(String email, String password, String confirm_password) {
    print("Input Params: "+"email - "+email +"\n"+"password - "+password +"\n"+ "Confirm Passowrd - " +confirm_password);
    return _netUtil.post(SIGNUP_URL, body: {
      "email": email,
      "password": password,
      "confirm_password": confirm_password,
      "auth_type": "email"
    }).then((dynamic res) {
      print("Response :"+res.toString());
      print("Message :"+res["message"]);
      if(res["status"]!=200) {
        throw new Exception(res["message"]);
      }else {
        return new ModelRegister.fromJson(res);
      }
      });
  }
  Future<ModelSocial> registerSocial(String email,String first_name, String auth_type) {
    print("Input Params: "+"email - "+email +"\n"+"authtype - "+auth_type) ;
    print("first_name at Client " + first_name.toString()+"");
    return _netUtil.post(REGISTER_SOCIAL, body: {
      "email": email,
      "auth_type": auth_type,
      "first_name": first_name,
      "user_type": "vendor"
    }).then((dynamic res) {
      print("Response :"+res.toString());
      print("Message :"+res["message"]);
      if(res["status"]==200) {
        return new ModelSocial.fromJson(res);

      }else if(res["status"]==401){
        return new ModelSocial.fromJson(res);
      }else {
        throw new Exception(res["message"]);
      }
    });
  }
  Future<ModelLogin> login(String email, String password, String auth_type) {
  /*  Map<String, String> map = {
      'Content-Type': 'application/json; charset=UTF-8',
    };*/
    return _netUtil.post(LOGIN_URL, body: {
      "email": email,
      "password": password,
      "auth_type": auth_type,
      "type": "vendor"
    }).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelLogin.fromJson(res);
    });
  }
  Future<ModelLogin> loginSocial(String email, String password, String auth_type) {
    /*  Map<String, String> map = {
      'Content-Type': 'application/json; charset=UTF-8',
    };*/
    return _netUtil.post(LOGIN_URL, body: {
      "email": email,
      "password": password,
      "auth_type": auth_type,
      "type": "vendor"
    }).then((dynamic res) {
      print(res.toString());
      if(res["status"]==200) {
        return new ModelLogin.fromJson(res);
      }else if(res["status"]==401){
        return new ModelLogin.fromJson(res);
      }else{
        throw new Exception(res["message"]);
      }

    });
  }



  Future<ModelAddBank> addBank(String token, String routing_number,String account_holder_name, String account_number) {
    Map<String, String> map = {
      "Authorization":token,
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    print("Token "+token.toString()+"^");
    print("routing_number "+routing_number);
    print("account_holder_name "+account_holder_name);
    print("account_number "+account_number);
    return _netUtil.post(ADD_BANK, body: {
      "routing_number": "110000000",
      "account_holder_name": account_holder_name,
      "account_number": "000123456789"

    }, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) {
        throw new Exception(res["message"]);
      }
      return new ModelAddBank.fromJson(res);
    });
  }



  Future<ModelPayout> payOut(String token) {
    Map<String, String> map = {
      "Authorization":token,
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    };
    print("Token "+token.toString()+"^");

    return _netUtil.post(PAY_OUT, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) {
        throw new Exception(res["message"]);
      }
      return new ModelPayout.fromJson(res);
    });
  }


  Future<ForgotPasswordModel> forgotPass(String email) {
    return _netUtil.post(FORGOT_PASSWORD, body: {
      "email": email
    }).then((dynamic res) {
      print(res.toString());

      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ForgotPasswordModel.fromJson(res);
    });
  }
  Future<ModelMenu> getMenu(String token) {
      Map<String, String> map = {
        "Authorization":token
    };
      print("Token At Client "+token+"");
    return _netUtil.get(GET_MENU, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelMenu.fromJson(res);
    });
  }


  Future<ModelEarning> getEarning(String token) {
    Map<String, String> map = {
      "Authorization":token
    };
    print("Token At Client "+token+"");
    return _netUtil.get(EARNING, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelEarning.fromJson(res);
    });
  }
  Future<ModelOrders> getOrders(String token) {
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.get(GET_ORDERS, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelOrders.fromJson(res);
    });
  }
  Future<ModelLoginStripe> loginStripe(String token) {
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.post(LOGIN_STRIPE, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelLoginStripe.fromJson(res);
    });
  }
  Future<ModelDelete> deleteItem(String token, String id, String item_no) {
    print("Id: "+id);
    print("itemNo: "+item_no);
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.post(DELETE_ITEM, headers: map, body: {
      "id":id,
      "item_no":item_no
    }).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelDelete.fromJson(res);
    });
  }
  Future<ModelChangePAssword> changePass(String token, String oldPass, String password, String ConfirmPAss) {
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.post(CHANGE_PASS, body: {
      "old_password": oldPass,
      "new_password": password,
      "confirm_password": ConfirmPAss
    }, headers: map).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelChangePAssword.fromJson(res);
    });
  }

  Future<ModelEdit> editProfile(String firstName , String lastName , String restroName , String restroAddress , String token, String mobile, File file) {
    Map<String, String> map = {
      "Authorization":token,
      'Content-Type': 'multipart/form-data',
    };

    return _netUtil.post(EDIT_VENDOR, headers: map, body: {
      "first_name": firstName,
      "last_name": lastName,
      "restro_name": restroName,
      "restro_address": restroAddress,
      "mobile": mobile,
      "image": file
    }).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelEdit.fromJson(res);
    });
  }
  Future<ModelStatus> updateStatus(String token, String id , String status) {
   print("Id "+id);
   print("Status "+status);
    Map<String, String> map = {
      "Authorization":token
    };

    return _netUtil.post(UPDATE_STATUS, headers: map, body: {
      "id": id,
      "status": status,

    }).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelStatus.fromJson(res);
    });
  }

  Future<ModelTokenUpdate> updateToken(String token, String firebaseToken) {
    print("Token "+token.toString());
    print("firebaseToken "+firebaseToken.toString());
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.post(UPDATE_TOKEN, headers: map, body: {
      "token": firebaseToken
    }).then((dynamic res) {
      print(res.toString());

      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelTokenUpdate.fromJson(res);
    });
  }
  Future<ModelStatusUpdate> updateProfileStatus(String token,String status) {
    print("Id "+status);
    print("Status "+status);
    Map<String, String> map = {
      "Authorization":token
    };

    return _netUtil.post(UPDATE_PROFILE_STATUS, headers: map, body: {
      "profile_status": status,

    }).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelStatusUpdate.fromJson(res);
    });
  }
  Future<ModelLogout> logOut(String token) {
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.post(LOGOUT,headers: map).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new ModelLogout.fromJson(res);
    });
  }


  Future<ModelCategory> getCat(String token) {
    Map<String, String> map = {
      "Authorization":token
    };
    return _netUtil.get(CATEGORY,headers:map).then((dynamic res) {
      print(res.toString());
      if(res["success"]!=true) throw new Exception(res["message"]);

      return new ModelCategory.fromJson(res);

    });
  }
/*
  Future<Products> getProducts(String cat_id) {
    return _netUtil.post(PRODUCT_BY_SERVICE, body: {
      "service_id": cat_id,
    }).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new Products.fromJson(res);
    });
  }

  Future<AboutUsModel> getAboutUs() {
    return _netUtil.get(ABOUT_US).then((dynamic res) {
      print(res.toString());
      if(res["status"]!=200) throw new Exception(res["message"]);

      return new AboutUsModel.fromJson(res);
    });
  }*/
}
