import 'package:mockito/mockito.dart';
import 'package:niira/services/game_service.dart';

class MockGameService extends Mock implements GameService {
  @override
  String currentGameId = '';
}
