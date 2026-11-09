import SesionController from './SesionController'
import TokenRecuperacionController from './TokenRecuperacionController'
import PacienteController from './PacienteController'
import PersonaController from './PersonaController'
import PersonalAdministrativoController from './PersonalAdministrativoController'
import UsuarioController from './UsuarioController'
import PermisoController from './PermisoController'
import RolController from './RolController'
import RolPermisoController from './RolPermisoController'
import BitacoraController from './BitacoraController'
import InformacionMedicaController from './InformacionMedicaController'
import ContactoEmergenciaController from './ContactoEmergenciaController'
import CitaController from './CitaController'
import EspecialidadController from './EspecialidadController'
import MedicoController from './MedicoController'
import MedicoEspecialidadController from './MedicoEspecialidadController'
import HorarioController from './HorarioController'
import BloqueoAgendaController from './BloqueoAgendaController'
import HistorialEstadoCitaController from './HistorialEstadoCitaController'
import NotificacionController from './NotificacionController'
import ReporteController from './ReporteController'
import PagoController from './PagoController'
const Controllers = {
    SesionController: Object.assign(SesionController, SesionController),
TokenRecuperacionController: Object.assign(TokenRecuperacionController, TokenRecuperacionController),
PacienteController: Object.assign(PacienteController, PacienteController),
PersonaController: Object.assign(PersonaController, PersonaController),
PersonalAdministrativoController: Object.assign(PersonalAdministrativoController, PersonalAdministrativoController),
UsuarioController: Object.assign(UsuarioController, UsuarioController),
PermisoController: Object.assign(PermisoController, PermisoController),
RolController: Object.assign(RolController, RolController),
RolPermisoController: Object.assign(RolPermisoController, RolPermisoController),
BitacoraController: Object.assign(BitacoraController, BitacoraController),
InformacionMedicaController: Object.assign(InformacionMedicaController, InformacionMedicaController),
ContactoEmergenciaController: Object.assign(ContactoEmergenciaController, ContactoEmergenciaController),
CitaController: Object.assign(CitaController, CitaController),
EspecialidadController: Object.assign(EspecialidadController, EspecialidadController),
MedicoController: Object.assign(MedicoController, MedicoController),
MedicoEspecialidadController: Object.assign(MedicoEspecialidadController, MedicoEspecialidadController),
HorarioController: Object.assign(HorarioController, HorarioController),
BloqueoAgendaController: Object.assign(BloqueoAgendaController, BloqueoAgendaController),
HistorialEstadoCitaController: Object.assign(HistorialEstadoCitaController, HistorialEstadoCitaController),
NotificacionController: Object.assign(NotificacionController, NotificacionController),
ReporteController: Object.assign(ReporteController, ReporteController),
PagoController: Object.assign(PagoController, PagoController),
}

export default Controllers