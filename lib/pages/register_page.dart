
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key,required this.onTap});
  final void Function()? onTap;


  final TextEditingController _emailController = TextEditingController() ;
  final TextEditingController _pwController = TextEditingController() ;
  final TextEditingController _confirmPwController = TextEditingController() ;


  void register(BuildContext context)async{

    final _auth= AuthService();

    if(_pwController.text==_confirmPwController.text){
      try{
        await _auth.signUpWithEmailPassword(_emailController.text,_pwController.text);
      }catch(e){
        showDialog(context: context,
            builder: (context)=>AlertDialog(

              title: Text(e.toString()),
            ));
      }
    }else{
      showDialog(context: context,
          builder: (context)=>const AlertDialog(
            title: Text("Passwords don't Match!"),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monitor_weight_outlined,
                size: 60,
                color: Theme.of(context).colorScheme.primary,),

              SizedBox(height: 50,),

              Text("Let's create an account for you",
                style: TextStyle(fontSize: 16,
                    color: Theme.of(context).colorScheme.primary),),

              SizedBox(height: 25,),

              MyTextField(hinttext: "Email",
                obsecureText: false,
                focusNode: null,
                controller: _emailController,),

              SizedBox(height: 10,),

              MyTextField(hinttext: "Password",
                obsecureText: true,
                focusNode: null,
                controller: _pwController,),

              SizedBox(height: 10,),

              MyTextField(hinttext: "Confirm Password",
                obsecureText: true,
                focusNode: null,
                controller: _confirmPwController,),

              SizedBox(height: 5,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Password must be of Atleast 8 characters.',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 12),),
                  ],
                ),
              ),

              SizedBox(height: 25,),

              MyButton(text: "Register",
                onTap: ()=>register(context),),

              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                    style: TextStyle(color: Theme.of(context).colorScheme.primary),),
                  GestureDetector(
                    onTap: onTap,
                    child: Text("Login now",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary
                      ),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
