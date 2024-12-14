# TravelBuddy - Peer-to-Peer Delivery App

TravelBuddy is a Flutter mobile application that facilitates peer-to-peer delivery services. Users can create delivery requests for items they need to be transported and other users can accept these requests to earn reward points.

## Features

- User authentication with email/password and Google Sign-in
- Create and manage delivery requests
- Accept delivery requests from other users
- Track completed deliveries
- Profile management with delivery statistics
- Reward points system for completed deliveries

## A video demonstrating the above features



https://github.com/user-attachments/assets/08305cfc-bb88-4d94-9ef3-b3c6102c33cb


## Tech Stack

- Flutter & Dart
- Firebase Authentication
- Cloud Firestore
- BLoC Pattern for state management
- Dependency Injection using Service Locator

## Getting Started

1. Clone the repository
2. Configure Firebase project and add configuration files
3. Run `flutter pub get` to install dependencies
4. Run the app using `flutter run`

## Development Approach

The development of TravelBuddy followed these key principles:

### Architecture

- Used BLoC pattern for state management to separate business logic from UI
- Implemented clean architecture principles with clear separation of concerns
- Utilized repository pattern for data management

### Firebase Integration

- Leveraged Firebase Authentication for secure user management
- Used Cloud Firestore for real-time data storage and synchronization
- Implemented efficient querying for delivery requests

### User Experience

- Created an intuitive UI for easy navigation
- Implemented real-time updates for delivery status changes
- Added loading states and error handling for better user feedback

### Code Organization

- Structured code into logical modules (auth, landing, profile)
- Used cubit for simpler state management when applicable
- Maintained consistent coding patterns throughout the project

## Future Improvements

- Add real-time location tracking
- Implement chat functionality between users
- Add payment integration
- Enhance the reward system
- Add push notifications
