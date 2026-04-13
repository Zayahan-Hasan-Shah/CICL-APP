# CICL App - Comprehensive Documentation

## Overview

CICL App is a Flutter-based mobile application for insurance claim management, family member management, and health-related services. The app provides users with the ability to manage insurance claims, track family members, view hospital and laboratory networks, and access various health-related features.

**Version:** 1.0.0+6  
**Platform:** Flutter (iOS, Android, Web, Windows, macOS, Linux)  
**State Management:** Riverpod  
**Navigation:** GoRouter  

---

## Project Architecture

### Directory Structure

```
lib/
├── src/
│   ├── app/                    # App initialization and configuration
│   ├── controllers/            # Business logic and data handling
│   ├── core/                   # Core utilities and services
│   ├── models/                 # Data models
│   ├── providers/              # Riverpod state providers
│   ├── routing/                # Navigation and routing
│   ├── states/                 # State management classes
│   ├── views/                  # UI screens
│   └── widgets/                # Reusable UI components
└── main.dart                   # App entry point
```

### Architecture Pattern

The app follows a **Clean Architecture** pattern with separation of concerns:

- **Presentation Layer:** Views and Widgets
- **Business Logic Layer:** Controllers and Providers
- **Data Layer:** Models and Storage Services
- **Core Layer:** Utilities, Constants, and Services

---

## Dependencies and Packages

### Core Dependencies

- **flutter_riverpod:** State management
- **go_router:** Declarative routing
- **sizer:** Responsive design
- **http:** HTTP client for API calls
- **shared_preferences:** Local storage
- **equatable:** Value equality
- **file_picker:** File selection
- **image_picker:** Image capture/selection
- **local_auth:** Biometric authentication
- **permission_handler:** Device permissions
- **google_fonts:** Typography
- **flutter_svg:** SVG rendering
- **table_calendar:** Calendar widget
- **upgrader:** App version management
- **package_info_plus:** App information

---

## Features and Functionalities

### 1. Authentication System

#### Login Features
- **Traditional Login:** Email/password authentication
- **Biometric Login:** Fingerprint authentication support
- **Session Management:** JWT token handling with expiry
- **Auto-login:** Token validation and automatic session restoration
- **Forgot Password:** Password recovery functionality

#### Security Features
- **SSL/TLS:** Custom certificate pinning
- **Token Expiry:** Automatic token refresh and validation
- **Secure Storage:** Encrypted credential storage for biometrics
- **Session Cleanup:** Complete logout with data clearing

### 2. Navigation System

#### App Routes
- **Splash Screen:** App initialization
- **Login Screen:** User authentication
- **Dashboard:** Main navigation with bottom tabs
- **Home Screen:** Overview and quick actions
- **Family Management:** Family member CRUD operations
- **Claim Management:** Insurance claim tracking
- **Profile Screen:** User profile and settings
- **Hospital Network:** Hospital directory
- **Laboratory Network:** Laboratory directory
- **BMI Calculator:** Health metric calculation
- **Claim Limits:** Coverage limit information

#### Navigation Architecture
- **Declarative Routing:** Using GoRouter
- **Deep Linking:** Support for direct navigation
- **Route Guards:** Authentication-based navigation
- **State Preservation:** Maintaining navigation state

### 3. Family Management

#### Features
- **Family Member Registration:** Add new family members
- **Member Details:** View comprehensive member information
- **Relationship Management:** Define family relationships
- **Gender-based Data:** Gender-specific information handling
- **CNIC/B-form:** Identity document management

#### Data Model
```dart
class FamilyModel {
  final int branchCode;
  final String clientCode;
  final String cardNumber;
  final String name;
  final String dateOfBirth;
  final String relation;
  final String gender;
  final String? cnic;
  final String clientName;
}
```

### 4. Claim Management

#### Features
- **Claim Submission:** File new insurance claims
- **Claim Tracking:** Monitor claim status and progress
- **Claim History:** View past claims and details
- **Document Upload:** Attach supporting documents
- **Amount Tracking:** Bill, deductible, and approved amounts

#### Data Model
```dart
class Claim {
  final int srvcode;
  final String clmseqnos;
  final String cuserid;
  final String reportdate;
  final int billamount;
  final int deductamount;
  final int approvamt;
  final String serviceName;
}
```

### 5. Health Services

#### Hospital Network
- **Hospital Directory:** Comprehensive hospital listing
- **Location-based Search:** Find nearby hospitals
- **Specialty Filtering:** Search by medical specialties
- **Contact Information:** Hospital details and contacts

#### Laboratory Network
- **Lab Directory:** Laboratory service providers
- **Discount Information:** Available discounts and offers
- **Service Categories:** Different lab service types
- **Pricing Information:** Service cost details

#### BMI Calculator
- **Health Metrics:** Body Mass Index calculation
- **Health Insights:** BMI-based health recommendations
- **Data Tracking:** Historical BMI data

---

## API Integration

### Base Configuration
- **Base URL:** `https://ciclportal.cicl.com.pk`
- **Content-Type:** `application/json`
- **User-Agent:** `CICL-Mobile-App/1.0`

### API Endpoints

#### Authentication
- **POST** `/api/login` - User authentication
- **POST** `/api/forgot-password` - Password recovery

#### Claims
- **GET** `/api/get-claims` - Retrieve user claims
- **POST** `/api/add-claim` - Submit new claim
- **GET** `/api/get-claim-detail` - Get claim details

#### Family Management
- **GET** `/api/family-members` - Get family members
- **POST** `/api/add-family-member` - Add family member

#### User Services
- **GET** `/api/user-limits` - Get claim limits
- **GET** `/api/get-card-details` - Get card information
- **GET** `/api/get-services` - Get available services

### Network Features
- **Retry Logic:** Automatic retry for failed requests
- **Timeout Handling:** Configurable request timeouts
- **Error Handling:** Comprehensive error management
- **Multipart Requests:** File upload support
- **SSL Pinning:** Custom certificate validation

---

## State Management

### Riverpod Architecture

#### Providers Structure
- **Auth Providers:** Authentication state management
- **Family Providers:** Family member data management
- **Claim Providers:** Claim data and operations
- **Navigation Providers:** UI state management
- **Service Providers:** API service management

#### State Classes
- **Auth State:** Login, loading, success, error states
- **Fingerprint State:** Biometric authentication states
- **Data States:** Loading, success, error for data operations

### State Flow
1. **User Interaction** → Widget Event
2. **Widget Event** → Provider Method Call
3. **Provider Method** → Controller Business Logic
4. **Controller** → API Call/Storage Operation
5. **Response** → State Update
6. **State Update** → UI Rebuild

---

## Security Implementation

### Authentication Security
- **JWT Tokens:** Secure token-based authentication
- **Token Expiry:** Automatic token validation and refresh
- **Biometric Authentication:** Local fingerprint authentication
- **Secure Storage:** Encrypted credential storage

### Network Security
- **SSL/TLS:** HTTPS communication
- **Certificate Pinning:** Custom certificate validation
- **Request Headers:** Secure HTTP headers
- **Data Validation:** Input sanitization and validation

### Data Protection
- **Local Storage Encryption:** Sensitive data encryption
- **Session Management:** Secure session handling
- **Data Cleanup:** Complete data removal on logout
- **Privacy Compliance:** User data protection

---

## UI Components and Widgets

### Common Widgets
- **Attachment Uploader:** File upload component
- **Custom Bottom Navigation:** Tab navigation
- **Form Widgets:** Reusable form components
- **Loading Indicators:** Progress indicators
- **Error Widgets:** Error display components

### Screen-specific Widgets
- **Login Widgets:** Authentication forms
- **Family Widgets:** Family member cards and forms
- **Claim Widgets:** Claim cards and detail views
- **Profile Widgets:** User profile components

### Design System
- **Colors:** Centralized color scheme
- **Typography:** Google Fonts integration
- **Assets:** Organized image and icon assets
- **Responsive Design:** Sizer-based responsive layout

---

## Data Handling

### Local Storage
- **SharedPreferences:** User preferences and session data
- **Storage Service:** Centralized storage management
- **Data Models:** Structured data representation
- **Cache Management:** Local data caching

### Data Models
- **User Model:** User information and authentication data
- **Family Model:** Family member details
- **Claim Model:** Insurance claim information
- **Service Model:** Health service data

### Data Validation
- **Input Validation:** Form field validation
- **API Response Validation:** Response data validation
- **Error Handling:** Comprehensive error management
- **Data Sanitization:** Input data cleaning

---

## Performance Optimization

### Network Optimization
- **HTTP Client Optimization:** Reusable HTTP client
- **Request Caching:** Response caching mechanism
- **Lazy Loading:** On-demand data loading
- **Connection Pooling:** Efficient connection management

### UI Performance
- **Widget Optimization:** Efficient widget rebuilding
- **State Management:** Optimized state updates
- **Image Optimization:** Efficient image handling
- **Memory Management:** Proper resource cleanup

---

## File Management

### File Upload Features
- **Multiple File Types:** Support for various file formats
- **File Size Validation:** Maximum file size checking
- **Image Picker:** Camera and gallery integration
- **File Picker:** Document selection functionality

### File Storage
- **Temporary Storage:** Temporary file handling
- **File Validation:** File type and size validation
- **Cleanup Management:** Automatic file cleanup

---

## Error Handling

### Exception Management
- **Global Exception Handler:** Centralized error handling
- **User-friendly Messages:** User-appropriate error messages
- **Error Logging:** Debug information logging
- **Recovery Mechanisms:** Error recovery strategies

### Network Errors
- **Connection Errors:** Network connectivity issues
- **Server Errors:** HTTP error response handling
- **Timeout Errors:** Request timeout management
- **Parse Errors:** Data parsing error handling

---

## Testing Strategy

### Unit Testing
- **Model Testing:** Data model validation
- **Controller Testing:** Business logic testing
- **Provider Testing:** State management testing
- **Utility Testing:** Helper function testing

### Integration Testing
- **API Integration:** Endpoint testing
- **Storage Integration:** Local storage testing
- **Navigation Testing:** Route and navigation testing
- **Widget Testing:** UI component testing

---

## Deployment and Distribution

### Build Configuration
- **Environment Configuration:** Development/staging/production
- **Version Management:** Semantic versioning
- **Build Optimization:** Release build optimization
- **Asset Management:** Asset bundling and optimization

### App Store Distribution
- **Android:** Google Play Store deployment
- **iOS:** Apple App Store deployment
- **Version Updates:** Automatic update notifications
- **Release Notes:** Version change documentation

---

## Future Enhancements

### Planned Features
- **Push Notifications:** Real-time notifications
- **Offline Mode:** Offline functionality support
- **Advanced Analytics:** User behavior analytics
- **Multi-language Support:** Internationalization
- **Enhanced Security:** Advanced security features

### Technical Improvements
- **Performance Optimization:** Further performance enhancements
- **Code Refactoring:** Continuous code improvement
- **Testing Coverage:** Increased test coverage
- **Documentation:** Enhanced documentation

---

## Development Guidelines

### Code Standards
- **Dart Style:** Official Dart style guide
- **Flutter Best Practices:** Recommended Flutter patterns
- **Clean Code Principles:** Maintainable code practices
- **Documentation:** Comprehensive code documentation

### Git Workflow
- **Branch Strategy:** Feature branch workflow
- **Commit Standards:** Conventional commit messages
- **Code Review:** Peer review process
- **CI/CD:** Automated build and deployment

---

## Support and Maintenance

### Monitoring
- **Crash Reporting:** Automatic crash detection
- **Performance Monitoring:** App performance tracking
- **User Analytics:** User behavior analysis
- **Error Tracking:** Real-time error monitoring

### Maintenance
- **Regular Updates:** Dependency updates
- **Security Patches:** Security vulnerability fixes
- **Performance Tuning:** Ongoing optimization
- **Feature Updates:** New feature development

---

## Conclusion

CICL App is a comprehensive insurance management application built with modern Flutter architecture, providing users with seamless access to insurance services, family management, and health-related features. The application follows best practices in security, performance, and user experience, ensuring a reliable and efficient solution for insurance claim management.

The modular architecture and clean code structure make the application maintainable and scalable, allowing for future enhancements and feature additions while maintaining code quality and performance standards.
