/// HomeScreen — bienvenida y banner de Cisco Packet Tracer.
/// La navegación la maneja ShellScreen (rail en desktop, drawer en móvil).
///
/// Requiere en pubspec.yaml:
///   url_launcher: ^6.3.0

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/theme.dart';
import '../../app/providers/locale_provider.dart';
import '../../utils/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings(isSpanish: context.watch<LocaleProvider>().isSpanish);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 860),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _WelcomeBanner(s: s),
            const SizedBox(height: 12),
            _PacketTracerBanner(s: s),
          ]),
        ),
      ),
    );
  }
}

// ── Welcome banner ─────────────────────────────────────────────────────────────

class _WelcomeBanner extends StatelessWidget {
  final AppStrings s;
  const _WelcomeBanner({required this.s});

  @override
  Widget build(BuildContext context) {
    final isSp = s.isSpanish;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.22)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Text('🔌', style: TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              isSp ? '¡Bienvenido a ${s.appTitle}!' : 'Welcome to ${s.appTitle}!',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 2),
            const Text(
              'IPv4/v6 · VLSM · VLAN · NAT · ACL · OSPF · Cisco IOS',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
            ),
          ])),
        ]),
        const SizedBox(height: 12),
        Text(
          isSp
            ? 'Esta app es tu compañero de estudio y trabajo para redes de computadoras. '
              'Con ella puedes calcular subredes IPv4/v6, diseñar esquemas VLAN, planificar '
              'rutas estáticas y dinámicas, configurar NAT y ACLs, y aprender Cisco IOS '
              'paso a paso — todo sin necesidad de un router físico.'
            : 'This app is your study and work companion for computer networks. '
              'Use it to calculate IPv4/v6 subnets, design VLAN schemes, plan static '
              'and dynamic routes, configure NAT and ACLs, and learn Cisco IOS step '
              'by step — all without needing a physical router.',
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary, height: 1.55),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('💡', style: TextStyle(fontSize: 14)),
            const SizedBox(width: 8),
            Expanded(child: Text(
              isSp
                ? 'Tip: usa esta app para calcular y planificar, y pon a prueba los '
                  'resultados en el simulador Cisco Packet Tracer antes de aplicarlos '
                  'en equipos reales.'
                : 'Tip: use this app to calculate and plan, then test the results in '
                  'Cisco Packet Tracer before applying them on real equipment.',
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.45),
            )),
          ]),
        ),
      ]),
    );
  }
}

// ── Packet Tracer banner ────────────────────────────────────────────────────────

class _PacketTracerBanner extends StatelessWidget {
  final AppStrings s;
  const _PacketTracerBanner({required this.s});

  static const _ptUrl =
      'https://www.netacad.com/es/articles/news/download-cisco-packet-tracer';

  Future<void> _openLink() async {
    final uri = Uri.parse(_ptUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSp = s.isSpanish;
    final isDesktop = MediaQuery.of(context).size.width > 700;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.accentBlue.withOpacity(0.25)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: AppTheme.accentBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('🖥️', style: TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              isSp ? 'Pon a prueba tus habilidades' : 'Test your skills',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              'Cisco Packet Tracer',
              style: TextStyle(
                color: AppTheme.accentBlue.withOpacity(0.85),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ])),
        ]),
        const SizedBox(height: 10),
        Text(
          isSp
            ? 'Cisco Packet Tracer es el simulador oficial de Cisco. Permite montar '
              'topologías de red completas con routers, switches y PCs virtuales, '
              'ejecutar comandos Cisco IOS reales y verificar la conectividad — '
              'ideal para practicar todo lo que calculas en esta app.'
            : 'Cisco Packet Tracer is Cisco\'s official network simulator. Build complete '
              'topologies with virtual routers, switches and PCs, run real Cisco IOS '
              'commands and verify connectivity — perfect for practicing everything '
              'you calculate in this app.',
          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.5),
        ),
        if (isDesktop) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openLink,
              icon: const Icon(Icons.open_in_new, size: 16),
              label: Text(isSp ? 'Ir a instalar Cisco Packet Tracer' : 'Download Cisco Packet Tracer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: Text(
              isSp ? 'Gratuito · Requiere cuenta Cisco NetAcad' : 'Free · Requires a Cisco NetAcad account',
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
            ),
          ),
        ] else ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark.withOpacity(0.5),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Icon(Icons.info_outline, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 8),
              Expanded(child: Text(
                isSp
                  ? 'Packet Tracer se instala en PC o Mac. '
                    'Búscalo en netacad.com desde tu computador para descargarlo gratis.'
                  : 'Packet Tracer installs on PC or Mac. '
                    'Find it at netacad.com from your computer to download it for free.',
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.45),
              )),
            ]),
          ),
        ],
      ]),
    );
  }
}
