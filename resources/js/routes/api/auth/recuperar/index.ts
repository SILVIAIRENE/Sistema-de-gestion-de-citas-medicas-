import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitar
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
export const solicitar = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitar.url(options),
    method: 'post',
})

solicitar.definition = {
    methods: ["post"],
    url: '/api/auth/recuperar-clave/solicitar',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitar
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
solicitar.url = (options?: RouteQueryOptions) => {
    return solicitar.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitar
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
solicitar.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitar.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitar
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
    const solicitarForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: solicitar.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitar
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
        solicitarForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: solicitar.url(options),
            method: 'post',
        })
    
    solicitar.form = solicitarForm
/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecer
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
export const restablecer = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: restablecer.url(options),
    method: 'post',
})

restablecer.definition = {
    methods: ["post"],
    url: '/api/auth/recuperar-clave/restablecer',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecer
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
restablecer.url = (options?: RouteQueryOptions) => {
    return restablecer.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecer
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
restablecer.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: restablecer.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecer
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
    const restablecerForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: restablecer.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecer
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
        restablecerForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: restablecer.url(options),
            method: 'post',
        })
    
    restablecer.form = restablecerForm
const recuperar = {
    solicitar: Object.assign(solicitar, solicitar),
restablecer: Object.assign(restablecer, restablecer),
}

export default recuperar