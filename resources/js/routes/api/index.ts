import auth from './auth'
import personas from './personas'
import personalAdministrativo from './personal-administrativo'
import sesiones from './sesiones'
import tokensRecuperacion from './tokens-recuperacion'
import usuarios from './usuarios'
import permisos from './permisos'
import roles from './roles'
import bitacora from './bitacora'
import pacientes from './pacientes'
import especialidades from './especialidades'
import medicos from './medicos'
import bloqueos from './bloqueos'
import citas from './citas'
import notificaciones from './notificaciones'
import reportes from './reportes'
import pagos from './pagos'
const api = {
    auth: Object.assign(auth, auth),
personas: Object.assign(personas, personas),
personalAdministrativo: Object.assign(personalAdministrativo, personalAdministrativo),
sesiones: Object.assign(sesiones, sesiones),
tokensRecuperacion: Object.assign(tokensRecuperacion, tokensRecuperacion),
usuarios: Object.assign(usuarios, usuarios),
permisos: Object.assign(permisos, permisos),
roles: Object.assign(roles, roles),
bitacora: Object.assign(bitacora, bitacora),
pacientes: Object.assign(pacientes, pacientes),
especialidades: Object.assign(especialidades, especialidades),
medicos: Object.assign(medicos, medicos),
bloqueos: Object.assign(bloqueos, bloqueos),
citas: Object.assign(citas, citas),
notificaciones: Object.assign(notificaciones, notificaciones),
reportes: Object.assign(reportes, reportes),
pagos: Object.assign(pagos, pagos),
}

export default api