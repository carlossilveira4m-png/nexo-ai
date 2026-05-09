import 'package:flutter/material.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planos Premium'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              children: const [
                _PlanCard(
                  title: 'Premium',
                  price: 'R\$ 19,90',
                  period: '/mês',
                  yearlyPrice: 'ou R\$ 199/ano',
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  features: [
                    '✓ IA Ilimitada',
                    '✓ Memória Ilimitada',
                    '✓ Modo Voz',
                    '✓ Sincronização Cloud',
                    '✓ Múltiplos Dispositivos',
                    '✓ Sem Anúncios',
                  ],
                ),
                _PlanCard(
                  title: 'Pro',
                  price: 'R\$ 49,90',
                  period: '/mês',
                  gradient: LinearGradient(
                    colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)],
                  ),
                  features: [
                    '✓ Tudo do Premium',
                    '✓ Assistente Avançado',
                    '✓ Automações Inteligentes',
                    '✓ Integração WhatsApp',
                    '✓ Análises Comportamentais',
                    '✓ Suporte Prioritário',
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Page indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // CTA Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF6366F1),
                    ),
                    onPressed: () {
                      // Navigate to payment
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Iniciando pagamento...'),
                        ),
                      );
                    },
                    child: const Text(
                      'Começar Teste Gratuito',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final String? yearlyPrice;
  final LinearGradient gradient;
  final List<String> features;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.gradient,
    required this.features,
    this.yearlyPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            baseline: TextBaseline.alphabetic,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                period,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          if (yearlyPrice != null) ...
            [
              const SizedBox(height: 8),
              Text(
                yearlyPrice!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          const SizedBox(height: 32),
          const Text(
            'Inclui:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                feature,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFCBD5E1),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
