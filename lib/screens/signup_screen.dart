import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sw2_parcial1_movil/screens/screens.dart';
import 'package:sw2_parcial1_movil/services/services.dart';
import 'package:sw2_parcial1_movil/theme/app_theme.dart';
import 'package:sw2_parcial1_movil/utils/utils.dart';
import 'package:sw2_parcial1_movil/widgets/widgets.dart';

class SingUpScreen extends StatelessWidget {
  SingUpScreen({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
        body: ListView(
      padding: const EdgeInsets.only(top: 0),
      physics: const BouncingScrollPhysics(),
      children: [
        Stack(
          children: [HeaderSignUp(), LogoHeader()],
        ),
        _Titulo(),
        Form(
          key: _formKey,
          child: Column(
            children: [
              _TextField(
                emailController: _emailController,
                passwordController: _passwordController,
                nameController: _nameController,
                phoneController: _phoneController,
              ),
              Container(
                margin: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(50)),
                    width: double.infinity,
                child: TextButton(
                  onPressed: authService.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final email = _emailController.text.trim();
                            final password = _passwordController.text.trim();
                            final name = _nameController.text.trim();
                            final mobile = _phoneController.text.trim();
                            //print(email);
                            final succes = await authService.register(
                                name, email, password, mobile);
                            if (succes) {
                              if (context.mounted) {
                                Navigator.pushReplacementNamed(
                                    context, 'login');
                              }
                            } else {
                              if (context.mounted) {
                                displayDialog(
                                    context,
                                    'Error al crear el useuario',
                                    'complete bien los campos',
                                    Icons.error,
                                    Colors.red);
                              }
                            }
                          }
                        },
                  child:  TextFrave(
                    text: authService.isLoading 
                        ? 'Espere...' 
                        : 'SIGN UP',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

/* class _Botton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Color(0xff5511b0), borderRadius: BorderRadius.circular(50)),
      child: TextButton(
        child:
            const TextFrave(text: 'SIGN UP', color: Colors.white, fontSize: 18),
        onPressed: () {},
      ),
    );
  }
}
 */
class _TextField extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController phoneController;

  const _TextField(
      {required this.emailController,
      required this.passwordController,
      required this.nameController,
      required this.phoneController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          TextFieldCustom(
            icono: Icons.person,
            type: TextInputType.text,
            texto: 'Username',
            controller: nameController,
            errorMessagge: 'Username is required',
          ),
          const SizedBox(height: 20),
          TextFieldCustom(
            icono: Icons.mail_outline,
            type: TextInputType.emailAddress,
            texto: 'Email Address',
            controller: emailController,
            errorMessagge: 'Email is required',
          ),
          const SizedBox(height: 20),
          TextFieldCustom(
            icono: Icons.phone,
            type: TextInputType.number,
            texto: 'Mobile',
            controller: phoneController,
            errorMessagge: 'Mobile is required',
          ),
          const SizedBox(height: 20),
          TextFieldCustom(
            icono: Icons.visibility_off,
            type: TextInputType.text,
            pass: true,
            texto: 'Password',
            controller: passwordController,
            errorMessagge: 'Password is required',
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _Titulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          TextButton(
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => LoginScreen())),
            child: const TextFrave(
                text: 'SIGN IN',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          const TextFrave(text: '/', fontSize: 25, color: Colors.grey),
          TextButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => SingUpScreen())),
              child: const TextFrave(
                  text: 'SIGN UP',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black))
        ],
      ),
    );
  }
}
