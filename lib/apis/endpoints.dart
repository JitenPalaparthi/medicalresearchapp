class EndPoint {
  static const String BASE_URL = "http://medicalResearch_service:50061/";
  //static const String BASE_URL = "http://127.0.0.1:50061/";

  // public user

  static const String SIGN_IN = "v1/public/user/mobile/signin";
  static const String REGISTER = "v1/public/user/register";
  static const String RESETPASSWORD = "v1/public/user/resetPassword";
  static const String GET_USER = "v1/user/get/";
  static const String GET_USERS = "v1/user/getAll/";
  static const String UPDATE_USER_BY_ID = "v1/user/update/";

  // Template
  static const String GET_TEMPLATEBYID = "v1/template/get/";
  static const String GET_TEMPLATEMETADATA = "v1/template/metadata/getAll";

  // ProjectData

  static const String ADD_PROJECTDATA = "v1/project/data/add";

  static const String GETALL_PROJECTDATA = "v1/project/data/getAll";

  static const String DELETE_PROJECTDATABYID = "v1/project/data/delete";

  static const String DOWNLOAD_PROJECTDATABYID = "v1/project/data/download";
}
