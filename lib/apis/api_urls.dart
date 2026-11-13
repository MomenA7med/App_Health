class ApiUrls {
  /// Endpoints
  /// Authentication
  static const loginWithPassword = "/api/auth/login";
  static const register = "/api/patients/register";

  /// Medical Specialties
  static const medicalSpecialties = "/api/medical-specialties";
  static String specialtyDoctors(String specialtyId) =>
      "/api/medical-specialties/$specialtyId/doctors";

  /// Doctors
  static String doctorProfile(String doctorId) => "/api/doctors/$doctorId";
  static String doctorReviews(String doctorId) =>
      "/api/doctors/$doctorId/reviews";

  /// Lookups / Filters
  static const insuranceCompanies = "/api/insurance-companies";
  static const governorates = "/api/governorates";

  /// Hospitals
  static const hospitalsFilter = "/api/hospitals/filter";

  /// Addresses
  static const userAddresses = "/api/patients/me/addresses";

  static const refreshToken = "/auth/refresh-token";

  /// Tasks
  static taskSummary(int year) => "/BAU/api/SubTask/Summary/$year";
  static const taskList = "/BAU/api/SubTask/GetAll";
  static const taskDetails = "/BAU/api/SubTask/GetDetails";
  static const taskHistory = "/BAU/api/SubTask/History/";
  static const taskAttachments = "/BAU/api/SubTask/Attachments/";
  static const taskComments = "/BAU/api/SubTask/Comments/";
  static const uploadFile = "/FileService/api/Attachment/Upload";
  static const addComment = "/BAU/api/SubTask/Comments/Add";
  static const addFile = "/BAU/api/SubTask/AddFile";
  static const updateStatus = "/BAU/api/SubTask/UpdateStatus";
  static const updateProgress = "/BAU/api/SubTask/UpdateProgress";
  static const downloadFile = "/FileService/api/Attachment/DownloadFile/";
  static const deleteComment = "/BAU/api/SubTask/Comments/Delete/";
  static const verifyTask = "/BAU/api/SubTask/Verify";
  static const updateComment = "/BAU/api/SubTask/Comments/Update";
  static const deleteFile = "/BAU/api/SubTask/DeleteFile";
  static const deleteFileInComment = "/BAU/api/SubTask/Comments/DeleteFile";
  static const deleteTask = "/BAU/api/SubTask/Delete/";
  static String relatedActivityLookups(int year) =>
      "/BAU/api/MainTask/get/$year?hasCreatePermission=true";

  /// User Profile
  static const userProfile = "/UserManagement/api/Profile/Get";
  static const createTask = "/BAU/api/SubTask/Create";
  static const updateTask = "/BAU/api/SubTask/Update";
  static String getTaskDetails(int taskId) => "/BAU/api/SubTask/Get/$taskId";
  static const assigneesList =
      "/UserManagement/api/User/GetEmployeesInGroup/Recursive";
}
