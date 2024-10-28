import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../widgets/custom_button.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                currentPage = index;
              });
            },
            children: [
              _buildPage(
                image: 'assets/imagen1.png',
                title: 'Gestiona alquileres fácilmente',
                description:
                    'Simplifica la administración de tus propiedades y mantén todo bajo control.',
              ),
              _buildPage(
                image: 'assets/imagen2.png',
                title: 'Plataforma amigable con los arrendadores',
                description:
                    'Una experiencia diseñada para facilitar la vida de los arrendadores.',
              ),
              _buildPage(
                image: 'assets/imagen3.png',
                title: 'La gestión es clave',
                description:
                    'Monitorea y optimiza el manejo de tus propiedades para mejorar la rentabilidad de tus alquileres.',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: CustomButton(
              text: currentPage == 2 ? 'Empezar' : 'Siguiente',
              onPressed: () {
                if (currentPage < 2) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                } else {
                  // Guardar que el onboarding ya se ha visto
                  final box = GetStorage();
                  box.write('hasSeenOnboarding', true);

                  // Redirigir a la página de Login y limpiar el historial
                  Get.offAllNamed('/login');
                }
              },
              isLoading:
                  false, // Cambia esto a true si deseas mostrar el loading
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String image,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 300),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
