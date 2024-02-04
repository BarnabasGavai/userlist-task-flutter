import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mytask/bloc/user_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final scrollController = ScrollController();
  void scrollListening() {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          context.read<UserBloc>().add(FetchMore());
        }
      }
    });
  }

  @override
  void initState() {
    context.read<UserBloc>().add(UserFetched());
    super.initState();
    scrollListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "U S E R S",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.add_circle,
                  color: Colors.black,
                )),
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserFailure) {
              return Text(state.error);
            }

            if (state is! UserSuccess && state is! LoadingMore) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data;
            if (state is UserSuccess) {
              data = state.users;
            } else if (state is LoadingMore) {
              data = state.users;
            } else {
              data = [];
            }
            return Container(
              padding: const EdgeInsets.only(top: 15),
              color: const Color.fromARGB(255, 243, 243, 243),
              child: ListView.builder(
                controller: scrollController,
                itemCount: data.length + 1,
                itemBuilder: (context, index) {
                  if (index < data.length) {
                    return Padding(
                        padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                        child: ListTile(
                          title: Text(data[index].name),
                          subtitle: Text(data[index].email),
                          trailing: Text(data[index].gender),
                        ));
                  } else {
                    if (state is! UserSuccess) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is UserSuccess) {
                      if (state.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }
                  }
                },
              ),
            );
          },
        ));
  }
}
