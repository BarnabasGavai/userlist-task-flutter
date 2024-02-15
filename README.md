# mytask

An app to perform CRUD operation on a list of users from the API.
The app is developed taking care of good programming practices such as State Management, Pagination, Optimized loading, and coding architecture.
Bloc state management was used for this project.

## Dependencies
- [**Flutter Bloc**](https://pub.dev/packages/flutter_bloc)
- [**Geolocator**](https://pub.dev/packages/geolocator)

## Sample pics
<img src="https://github.com/BarnabasGavai/userlist-task-flutter/assets/74435697/70286a14-40dc-4b40-bc63-617fb3b303cc" height="700">
<img src="https://github.com/BarnabasGavai/userlist-task-flutter/assets/74435697/3e82d94d-948c-45f6-8bf7-8330274e0512" height="700">



## Architecture
- Bloc: This part was divided into further 3 sections. First was bloc management where all the control and logic part was written to catch and emit states and events and the other two were bloc state and bloc events respectively
- User Model: A custom class named User which had all the properties and methods to convert a map into and from this class.
- Data Provider: All API Calls were made from here. It interacts with the API and fetches data.
- Repository: The data fetched by the API in the "Data Provider" layer is then passed into the Repository where it gets converted into the appropriate datatype.
- Data: This contains the files that have all the information such as the API KEY etc.
- Presentation/Screens: All UI-related widgets are built in this section.

## Bloc Events
- Initial Load
- Update User
- Fetch User
- Add User
- Delete User

## Bloc States
- Success State
- Loading State
- Loading More State
- Failed State


