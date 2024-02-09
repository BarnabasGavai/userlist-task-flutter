import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mytask/models/user.dart';
import 'package:mytask/repos/repository.dart';
import 'package:geolocator/geolocator.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  int page = 1;
  //Loads all the users from this list, Without calling the API again and again
  List<User> users = [];
  //Newly added users are loaded from here. Because first all the old users needs to be displayed and lastly these users will be loaded
  List<User> newlyAdded = [];
  final UserRepo userRepo;

  UserBloc(this.userRepo) : super(UserInitial()) {
    //This event is only emitted once during the first launch of the app.. It fetches the data from API
    on<InitialLoad>(
      (event, emit) async {
        emit(UserLoading("Getting Data from server.."));

        try {
          var response = await userRepo.initialData();
          users = response;

          /* This condition is common in all events, It Assumes whether there is more data in the API without calling the API. This is done to control the circular indicator when scrolling is done..*/
          if (users.length < (page) * 15) {
            //If the above condition is true, then it means all the data from which was first fetched from the API is loaded, so now we can load the newly added data at last as the new data is stored at the end even in the API.
            users.addAll(newlyAdded);
            emit(UserSuccess(users: users, hasData: false));
          } else {
            emit(UserSuccess(users: users, hasData: true));
          }
        } catch (e) {
          //User failed event
          emit(UserFailure("Failed to Load Data! ${e.toString()}"));
        }
      },
    );

    //Loads the data in homescreen without calling the API..
    on<UserFetched>((event, emit) async {
      emit(UserLoading("Loading..."));
      try {
        /* This condition is common in all events, It Assumes whether there is more data in the API without calling the API. This is done to control the circular indicator when scrolling is done..*/
        if (users.length < (page) * 15) {
          users.addAll(newlyAdded);
          emit(UserSuccess(users: users, hasData: false));
        } else {
          emit(UserSuccess(users: users, hasData: true));
        }
      } catch (e) {
        UserFailure(e.toString());
      }
    });

    //This event is called when scrolling is done to load more data (Pagination) and more data is then called from the API
    on<FetchMore>((event, emit) async {
      //This if condition checks whether already some sort of loading is on or not.
      if (state is LoadingMore) {
      } else {
        emit(LoadingMore(users: users));
        try {
          List<User> tempusers = [];
          tempusers = await userRepo.moreUsers(page + 1);
          page = page + 1;
          users.addAll(tempusers);
          tempusers = [];

          if (users.length < (page) * 15) {
            users.addAll(newlyAdded);
            newlyAdded = [];
            emit(UserSuccess(users: users, hasData: false));
          } else {
            emit(UserSuccess(users: users, hasData: true));
          }
        } catch (e) {
          emit(UserFailure(e.toString()));
        }
      }
    });

    //Event for updating the user
    on<UpdateUser>(
      (event, emit) async {
        emit(UserLoading("Updating user details.."));
        String latitude = "";
        String longitude = "";
        try {
          await Geolocator.requestPermission();
          Position position = await determinePosition();
          latitude = position.latitude.toString();
          longitude = position.latitude.toString();
        } catch (e) {
          print("User location not detected");
        }
        User updatedUser = User(
            id: event.id,
            name: event.name,
            email: event.email,
            gender: event.gender,
            phone: event.phone,
            city: event.city,
            state: event.state,
            address: event.address,
            latitude: longitude,
            longitude: longitude,
            status: "active");

        try {
          //updates user in the API
          String response = await userRepo.updateCurrUser(updatedUser);
          int chk = 0;
          //Updates user in our local list
          for (var user in users) {
            if (user.id == updatedUser.id) {
              int ind = users.indexOf(user);
              users[ind] = updatedUser;
              chk = 1;
            }
          }

          if (chk == 0) {
            for (var user in newlyAdded) {
              if (user.id == updatedUser.id) {
                int ind = newlyAdded.indexOf(user);
                newlyAdded[ind] = updatedUser;
                chk = 1;
              }
            }
          }
          /* This condition is common in all events, It Assumes whether there is more data in the API without calling the API. This is done to control the circular indicator when scrolling is done..*/
          if (users.length < (page) * 15) {
            users.addAll(newlyAdded);
            newlyAdded = [];
            emit(UserSuccess(users: users, hasData: false));
          } else {
            emit(UserSuccess(users: users, hasData: true));
          }
        } catch (e) {
          emit(UserFailure(e.toString()));
        }
      },
    );

    // Event to delete a user from both API and our local list
    on<DeleteUser>(
      (event, emit) async {
        emit(UserLoading("Deleting the user"));
        try {
          int id = event.id;

          String response = await userRepo.deleteCurrUser(id);

          for (var element in users) {
            if (element.id == id) {
              users.remove(element);
            }
          }
          for (var element in newlyAdded) {
            if (element.id == id) {
              newlyAdded.remove(element);
            }
          }

          /* This condition is common in all events, It Assumes whether there is more data in the API without calling the API. This is done to control the circular indicator when scrolling is done..*/
          if (users.length < (page) * 15) {
            users.addAll(newlyAdded);
            newlyAdded = [];
            emit(UserSuccess(users: users, hasData: false));
          } else {
            emit(UserSuccess(users: users, hasData: true));
          }
        } catch (e) {
          emit(UserFailure(e.toString()));
        }
      },
    );

//Event to add a new user to both API and our local list
    on<AddUser>(
      (event, emit) async {
        emit(UserLoading("Adding new user.."));
        String latitude = "";
        String longitude = "";
        try {
          LocationPermission permission = await Geolocator.requestPermission();
          Position position = await determinePosition();
          latitude = position.latitude.toString();
          longitude = position.latitude.toString();
        } catch (e) {
          print("Location Error: ${e.toString()}");
        }

        try {
          User newUser = User(
              name: event.name,
              email: event.email,
              gender: event.gender,
              status: "active",
              address: event.address,
              state: event.state,
              city: event.city,
              latitude: latitude,
              longitude: longitude,
              phone: event.phone);
          int response = await userRepo.newUser(newUser);
          newUser.id = response;
          newlyAdded.add(newUser);

          /* This condition is common in all events, It Assumes whether there is more data in the API without calling the API. This is done to control the circular indicator when scrolling is done..*/
          if (users.length < (page) * 15) {
            users.addAll(newlyAdded);
            newlyAdded = [];
            emit(UserSuccess(users: users, hasData: false));
          } else {
            emit(UserSuccess(users: users, hasData: true));
          }
        } catch (e) {
          emit(UserFailure(e.toString()));
        }
      },
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
