// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeMessage => 'WELCOME';

  @override
  String get userHint => 'User';

  @override
  String get passwordHint => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get invalidCredentials => 'Invalid credentials. Please try again.';

  @override
  String get home => 'Home';

  @override
  String get status => 'Status';

  @override
  String get history => 'History';

  @override
  String get shipments => 'Shipments';

  @override
  String get sensors => 'Sensors';

  @override
  String get admin => 'Admin';

  @override
  String lastUpdate(String time) {
    return 'Last update: $time';
  }

  @override
  String get searchByProductOrOwner => 'Search by product or owner...';

  @override
  String get shipmentsSummary => 'Shipments Summary';

  @override
  String get inTransit => 'In Transit';

  @override
  String get delivered => 'Delivered';

  @override
  String get orders => 'Orders';

  @override
  String get reminderIn10s => 'Notify in 10s';

  @override
  String get reminderSet => 'Reminder scheduled in 10 seconds.';

  @override
  String get air => 'Air ✈️';

  @override
  String get land => 'Land 🚛';

  @override
  String get searchByOrderId => 'Search by Order ID...';

  @override
  String get noOrdersFound => 'No orders found with that ID.';

  @override
  String orderId(String id) {
    return 'Order ID: $id';
  }

  @override
  String owner(String name) {
    return 'Owner: $name';
  }

  @override
  String get bluetoothDevices => 'Bluetooth Devices';

  @override
  String get noDevicesFound =>
      'No devices found. Make sure Bluetooth is enabled and press refresh.';

  @override
  String get searchDevices => 'Search Devices';

  @override
  String get unnamedDevice => 'Unnamed Device';

  @override
  String get connect => 'Connect';

  @override
  String get connecting => 'Connecting...';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get sensorData => 'Sensor Data';

  @override
  String get requestData => 'Request Data';

  @override
  String get temperatureLM35 => 'Temperature (LM35)';

  @override
  String get temperatureDHT => 'Temperature (DHT11)';

  @override
  String get humidity => 'Humidity';

  @override
  String get light => 'Light';

  @override
  String get language => 'Language';

  @override
  String get spanish => 'Español';

  @override
  String get english => 'English';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get todayStats => 'Today\'s Stats';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get monthlyReport => 'Monthly Report';

  @override
  String get totalShipments => 'Total Shipments';

  @override
  String get activeShipments => 'Active Shipments';

  @override
  String get completedToday => 'Completed Today';

  @override
  String get avgDeliveryTime => 'Average Delivery Time';

  @override
  String get days => 'days';

  @override
  String get hours => 'hours';

  @override
  String get minutes => 'minutes';

  @override
  String get performance => 'Performance';

  @override
  String get efficiency => 'Efficiency';

  @override
  String get satisfactionRate => 'Satisfaction Rate';

  @override
  String get onTimeDeliveries => 'On-Time Deliveries';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get createShipment => 'Create Shipment';

  @override
  String get scanQR => 'Scan QR';

  @override
  String get emergencyAlert => 'Emergency Alert';

  @override
  String get viewReports => 'View Reports';

  @override
  String get newShipment => 'New Shipment';

  @override
  String get editShipment => 'Edit Shipment';

  @override
  String get shipmentDetails => 'Shipment Details';

  @override
  String get trackingNumber => 'Tracking Number';

  @override
  String get trackingId => 'Tracking ID';

  @override
  String get recipient => 'Recipient';

  @override
  String get sender => 'Sender';

  @override
  String get origin => 'Origin';

  @override
  String get destination => 'Destination';

  @override
  String get estimatedDelivery => 'Estimated Delivery';

  @override
  String get actualDelivery => 'Actual Delivery';

  @override
  String get weight => 'Weight';

  @override
  String get dimensions => 'Dimensions';

  @override
  String get value => 'Value';

  @override
  String get priority => 'Priority';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get urgent => 'Urgent';

  @override
  String get packageType => 'Package Type';

  @override
  String get fragile => 'Fragile';

  @override
  String get liquid => 'Liquid';

  @override
  String get electronic => 'Electronic';

  @override
  String get document => 'Document';

  @override
  String get other => 'Other';

  @override
  String get route => 'Route';

  @override
  String get currentLocation => 'Current Location';

  @override
  String get nextStop => 'Next Stop';

  @override
  String get estimatedArrival => 'Estimated Arrival';

  @override
  String get pending => 'Pending';

  @override
  String get processing => 'Processing';

  @override
  String get shipped => 'Shipped';

  @override
  String get outForDelivery => 'Out for Delivery';

  @override
  String get delayed => 'Delayed';

  @override
  String get failed => 'Failed';

  @override
  String get returned => 'Returned';

  @override
  String get cancelled => 'Cancelled';

  @override
  String get filters => 'Filters';

  @override
  String get sortBy => 'Sort By';

  @override
  String get dateRange => 'Date Range';

  @override
  String get from => 'From';

  @override
  String get to => 'To';

  @override
  String get apply => 'Apply';

  @override
  String get clear => 'Clear';

  @override
  String get reset => 'Reset';

  @override
  String get search => 'Search';

  @override
  String get noResults => 'No results';

  @override
  String showingResults(int count) {
    return 'Showing $count results';
  }

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get preferences => 'Preferences';

  @override
  String get notifications => 'Notifications';

  @override
  String get theme => 'Theme';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get systemMode => 'Follow System';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get smsNotifications => 'SMS Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get security => 'Security';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get logout => 'Logout';

  @override
  String get sensorDashboard => 'Sensor Dashboard';

  @override
  String get connectedDevices => 'Connected Devices';

  @override
  String get deviceStatus => 'Device Status';

  @override
  String get connected => 'Connected';

  @override
  String get disconnected => 'Disconnected';

  @override
  String get batteryLevel => 'Battery Level';

  @override
  String get signalStrength => 'Signal Strength';

  @override
  String get lastReading => 'Last Reading';

  @override
  String get configure => 'Configure';

  @override
  String get calibrate => 'Calibrate';

  @override
  String get alerts => 'Alerts';

  @override
  String get thresholds => 'Thresholds';

  @override
  String get minValue => 'Minimum Value';

  @override
  String get maxValue => 'Maximum Value';

  @override
  String get gps => 'GPS';

  @override
  String get accelerometer => 'Accelerometer';

  @override
  String get pressure => 'Pressure';

  @override
  String get altitude => 'Altitude';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get lastMonth => 'Last Month';

  @override
  String get lastYear => 'Last Year';

  @override
  String get custom => 'Custom';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get view => 'View';

  @override
  String get share => 'Share';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get download => 'Download';

  @override
  String get upload => 'Upload';

  @override
  String get refresh => 'Refresh';

  @override
  String get retry => 'Retry';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get done => 'Done';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get loading => 'Loading...';

  @override
  String get pleaseWait => 'Please wait...';

  @override
  String get operationCompleted => 'Operation completed successfully';

  @override
  String get operationFailed => 'Operation failed';

  @override
  String get networkError => 'Network error';

  @override
  String get serverError => 'Server error';

  @override
  String get validationError => 'Validation error';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get featureNotAvailable => 'Feature not available';

  @override
  String get required => 'Required';

  @override
  String get optional => 'Optional';

  @override
  String get invalidFormat => 'Invalid format';

  @override
  String get tooShort => 'Too short';

  @override
  String get tooLong => 'Too long';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get passwordTooWeak => 'Password too weak';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get map => 'Map';

  @override
  String get satellite => 'Satellite';

  @override
  String get hybrid => 'Hybrid';

  @override
  String get terrain => 'Terrain';

  @override
  String get currentPosition => 'Current Position';

  @override
  String get selectLocation => 'Select Location';

  @override
  String get address => 'Address';

  @override
  String get coordinates => 'Coordinates';

  @override
  String get latitude => 'Latitude';

  @override
  String get longitude => 'Longitude';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get selectPhoto => 'Select Photo';

  @override
  String get removePhoto => 'Remove Photo';

  @override
  String get photos => 'Photos';

  @override
  String get attachments => 'Attachments';

  @override
  String get support => 'Support';

  @override
  String get helpCenter => 'Help Center';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get chatBot => 'Chat Bot';

  @override
  String get faq => 'Frequently Asked Questions';

  @override
  String get reports => 'Reports';

  @override
  String get analytics => 'Analytics';

  @override
  String get insights => 'Insights';

  @override
  String get trends => 'Trends';

  @override
  String get comparison => 'Comparison';

  @override
  String get forecast => 'Forecast';

  @override
  String get kpi => 'Key Performance Indicators';

  @override
  String get metrics => 'Metrics';

  @override
  String get qrCode => 'QR Code';

  @override
  String get barcode => 'Barcode';

  @override
  String get scanCode => 'Scan Code';

  @override
  String get generateQR => 'Generate QR';

  @override
  String get invalidCode => 'Invalid code';

  @override
  String get codeScanned => 'Code scanned successfully';
}
