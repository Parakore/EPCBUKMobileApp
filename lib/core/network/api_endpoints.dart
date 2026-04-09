class ApiEndpoints {
  static const String baseUrl = 'https://api.utcms.gov.in/v1';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String refreshToken = '/auth/refresh-token';

  // Dashboard
  static const String dashboardMetrics = '/dashboard/metrics';
  static const String recentActivity = '/dashboard/activity';

  // command center
  static const String commandCenter = '/command-center';

  // AI
  static const String aiAnalysis = '/ai/analysis';
  static const String analytics = '/analytics';

  // GIS
  static const String gisMarkers = '/gis/markers';
  static const String spatialData = '/gis/spatial-data';
  static const String submitGeoTag = '/gis/submit-geotag';

  // Applications
  static const String applications = '/applications';
  static String applicationDetail(String id) => '/applications/$id';
  static const String createApplication = '/applications';
  static String updateApplication(String id) => '/applications/$id';
  static String deleteApplication(String id) => '/applications/$id';

  // workflow
  static const String workflow = '/workflow';
  static String workflowDetail(String id) => '/workflow/$id';

  // Valuation
  static const String calculateValuation = '/valuation/calculate';
  static String valuationDetail(String id) => '/valuation/$id';

  // Workflow
  static const String workflowProcess = '/workflow/process';
  static String workflowHistory(String id) => '/workflow/history/$id';

  // Valuation Approvals Queue
  static const String valuationApprovalsQueue = '/valuation-approvals-queue';
  static String rejectOrApprove(String id) =>
      '/valuation-approvals-queue/reject-or-approve/$id';

  // payments
  static const String getPaymentDetails = '/payments/get-payment-details';
  static const String paymentHistory = '/payments/history';

  // Notifications
  static const String notifications = '/notifications';
  static String markNotificationRead(String id) => '/notifications/read/$id';
  static const String markAllNotificationsRead = '/notifications/read-all';

  // DMS
  static const String dms = '/dms';
  static const String uploadDocument = '/dms/upload';
  static String getDocuments(String appId) => '/dms/documents/$appId';

  // Compliance Queue
  static const String complianceQueue = '/compliance-queue';
  static const String compliance = complianceQueue;

  // Citizen Grievance Portal
  static const String citizenGrievancePortal = '/citizen-grievance-portal';
  static const String grievance = citizenGrievancePortal;

  // Reports
  static const String reportsList = '/reports';
  static const String generateReport = '/reports/generate';
  static String downloadReport(String id) => '/reports/download/$id';
  // User Management
  static const String createUser = '/users';
  static String fetchuserDetail(String id) => '/users/$id';
  static String updateUser(String id) => '/users/$id';
  static String deleteUser(String id) => '/users/$id';

  // audit
  static const String audit = '/audit';
  static const String auditLogs = audit;

  // Settings
  static const String settings = '/settings';
}
