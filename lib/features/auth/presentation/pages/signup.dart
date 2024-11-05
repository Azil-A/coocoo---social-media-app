import 'package:coocoo/features/auth/presentation/blocs/auth_cubit.dart';
import 'package:coocoo/features/auth/presentation/components/my_button.dart';
import 'package:coocoo/features/auth/presentation/components/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class SignupPage extends StatefulWidget {
  final void Function()? onToggle;
  const SignupPage({super.key,required this.onToggle});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

   void register(){
    final String name =nameController.text;
    final String email = emailController.text;
    final String pw =passwordController.text;
    final String confirmpw =confirmPasswordController.text;

    final authCubit =context.read<AuthCubit>();

    if(name.isNotEmpty && email.isNotEmpty && pw.isNotEmpty && confirmpw.isNotEmpty){
      if(pw == confirmpw){
        authCubit.register(name, email, pw);

      
      }
      else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords doesn't match")));

      }

    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter all the fields")));
    }
   }

   @override
   void dispose(){
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
   }
 



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              Icon(
                Icons.lock_open_outlined,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(
                height: 50,
              ),
              Text(
                "Let's Create an account",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary, fontSize: 16),
              ),
              const SizedBox(
                height: 30,
              ),
              MyTextField(
                  controller: nameController,
                  hintText: "Name",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false),
              const SizedBox(
                height: 10,
              ),
              MyTextField(
                  controller: passwordController,
                  hintText: "Password",
                  obscureText: true),
                  MyTextField(
                  controller: confirmPasswordController,
                  hintText: "Confirm Password",
                  obscureText: true),
              const SizedBox(
                height: 10,
              ),
                  const SizedBox(height: 25,),
                  MyButton(onTap: (){
                    register();
                  }, text: 'Register'),
                  const SizedBox(height: 50,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?  ",style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                      GestureDetector(
                        onTap: widget.onToggle,
                        child: Text(" Login now",style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),))
                    ],
                  )

            ],
          ),
        ),
      )),
    );
  }
}