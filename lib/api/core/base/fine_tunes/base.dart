
import '../entity/interfaces/enpoint.dart';
import 'interfaces/cancel.dart';
import 'interfaces/create.dart';
import 'interfaces/delete.dart';
import 'interfaces/events.dart';
import 'interfaces/list.dart';
import 'interfaces/retrieve.dart';

abstract class OpenAIFineTunesBase
    implements
        EndpointInterface,
        CreateInterface,
        ListInterface,
        RetrieveInterface,
        CancelInterface,
        EventsInterface,
        DeleteInterface {}
