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
  @override
  void initState() {
    context.read<UserBloc>().add(UserFetched());
    super.initState();
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

            if (state is! UserSuccess) {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }

            final data = state.users;
            return Container(
              padding: const EdgeInsets.only(top: 15),
              color: const Color.fromARGB(255, 243, 243, 243),
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.fromLTRB(11, 8, 11, 8),
                      child: ListTile(
                        title: Text(data[index].name),
                        subtitle: Text(data[index].email),
                        trailing: Text(data[index].gender),
                      ));
                },
              ),
            );
          },
        ));
  }
}
