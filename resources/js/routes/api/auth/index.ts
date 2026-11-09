import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../wayfinder'
import recuperar from './recuperar'
/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
export const login = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

login.definition = {
    methods: ["post"],
    url: '/api/auth/login',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
login.url = (options?: RouteQueryOptions) => {
    return login.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
login.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
    const loginForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: login.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
        loginForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: login.url(options),
            method: 'post',
        })
    
    login.form = loginForm
/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
export const logoutSummary = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: logoutSummary.url(options),
    method: 'get',
})

logoutSummary.definition = {
    methods: ["get","head"],
    url: '/api/auth/logout-summary',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.url = (options?: RouteQueryOptions) => {
    return logoutSummary.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: logoutSummary.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: logoutSummary.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
    const logoutSummaryForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: logoutSummary.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
        logoutSummaryForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: logoutSummary.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
        logoutSummaryForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: logoutSummary.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    logoutSummary.form = logoutSummaryForm
/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
export const logout = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout.url(options),
    method: 'post',
})

logout.definition = {
    methods: ["post"],
    url: '/api/auth/logout',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
logout.url = (options?: RouteQueryOptions) => {
    return logout.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
logout.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
    const logoutForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: logout.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
        logoutForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: logout.url(options),
            method: 'post',
        })
    
    logout.form = logoutForm
/**
* @see \App\Http\Controllers\PacienteController::autoregistroPaciente
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
export const autoregistroPaciente = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: autoregistroPaciente.url(options),
    method: 'post',
})

autoregistroPaciente.definition = {
    methods: ["post"],
    url: '/api/auth/autoregistro-paciente',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PacienteController::autoregistroPaciente
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
autoregistroPaciente.url = (options?: RouteQueryOptions) => {
    return autoregistroPaciente.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::autoregistroPaciente
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
autoregistroPaciente.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: autoregistroPaciente.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PacienteController::autoregistroPaciente
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
    const autoregistroPacienteForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: autoregistroPaciente.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PacienteController::autoregistroPaciente
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
        autoregistroPacienteForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: autoregistroPaciente.url(options),
            method: 'post',
        })
    
    autoregistroPaciente.form = autoregistroPacienteForm
/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
export const me = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})

me.definition = {
    methods: ["get","head"],
    url: '/api/auth/me',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.url = (options?: RouteQueryOptions) => {
    return me.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: me.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
    const meForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: me.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
        meForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: me.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
        meForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: me.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    me.form = meForm
const auth = {
    login: Object.assign(login, login),
recuperar: Object.assign(recuperar, recuperar),
logoutSummary: Object.assign(logoutSummary, logoutSummary),
logout: Object.assign(logout, logout),
autoregistroPaciente: Object.assign(autoregistroPaciente, autoregistroPaciente),
me: Object.assign(me, me),
}

export default auth