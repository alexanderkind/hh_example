import 'package:hooks_riverpod/hooks_riverpod.dart';

extension RefKeepProvidersExtension on AutoDisposeRef {
  void keepProvider(ProviderListenable provider) {
    listen(provider, (_, __) {});
  }

  void keepProviders(Iterable<ProviderListenable> providers) {
    providers.forEach(keepProvider);
  }
}
