# mytask

An app to perform CRUD operation on a list of users from the API.
The app is developed taking care of good programming practices such as State Management, Pagination, Optimized loading, and coding architecture.
Bloc state management was used for this project.

## Dependencies
- [**Flutter Bloc**](https://pub.dev/packages/flutter_bloc)
- [**Geolocator**](https://pub.dev/packages/geolocator)

## Sample pics
![User List](https://i.ibb.co/NYndXrG/Screenshot-20240209-162542.jpg)
![Edit User](https://i.ibb.co/3WvkRvZ/Screenshot-20240209-162536.jpg)

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


