import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/style.dart';
import '../viewmodels/volViewModel.dart';
import 'DetailsVol.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(140);

  @override
  Widget build(BuildContext context) {
    final volViewModel = context.watch<VolViewModel>();

    return AppBar(
      elevation: 0,
      backgroundColor: AppStyle.bleuHorizon,
      toolbarHeight: 80,
      title: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 32),
          children: [
            TextSpan(text: 'Flight', style: AppStyle.titleLight),
            TextSpan(text: 'Search', style: AppStyle.titleBold),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: AppStyle.surfaceAlt,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: const Color(0x3300F0FF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                _StopOption(label: 'TOUS', type: StopType.all),
                _StopOption(label: 'DIRECT', type: StopType.zero),
                _StopOption(label: '1 ESCALE', type: StopType.one),
                _StopOption(label: '2 ESCALES', type: StopType.two),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StopOption extends StatelessWidget {
  const _StopOption({required this.label, required this.type});

  final String label;
  final StopType type;

  @override
  Widget build(BuildContext context) {
    final volViewModel = context.watch<VolViewModel>();
    final isSelected = volViewModel.selectedStop == type;

    return GestureDetector(
      onTap: () => context.read<VolViewModel>().setStopType(type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppStyle.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppStyle.stopSelectorText.copyWith(
            color: isSelected ? AppStyle.bleuStratosphere : AppStyle.texteSecondaire,
          ),
        ),
      ),
    );
  }
}

class VolsListeVue extends StatelessWidget {
  const VolsListeVue({super.key});

  @override
  Widget build(BuildContext context) {
    final volViewModel = context.watch<VolViewModel>();

    if (volViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (volViewModel.trajets.isEmpty) {
      return const Center(child: Text('Aucun vol trouve pour cette selection'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: volViewModel.trajets.length,
      itemBuilder: (context, index) {
        final trajet = volViewModel.trajets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            decoration: AppStyle.flightCardDecoration,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DetailsVol(trajet: trajet)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      _airportInfo(trajet.departIATA, 'Depart', CrossAxisAlignment.start),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: AppStyle.badgeFond,
                              child: Text(
                                trajet.nombreEscales == 0
                                    ? 'Direct'
                                    : '${trajet.nombreEscales} escale${trajet.nombreEscales > 1 ? 's' : ''}',
                                style: AppStyle.badgeTexte,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              height: 1,
                              color: const Color(0x3300F0FF),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              trajet.compagnies,
                              style: AppStyle.airportLongName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      _airportInfo(trajet.arriverIATA, 'Arrivee', CrossAxisAlignment.end),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _airportInfo(String code, String label, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(code, style: AppStyle.airportCode),
        Text(label, style: AppStyle.airportLongName),
      ],
    );
  }
}
