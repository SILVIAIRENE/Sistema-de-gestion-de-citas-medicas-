import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitarRecuperacion
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
export const solicitarRecuperacion = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitarRecuperacion.url(options),
    method: 'post',
})

solicitarRecuperacion.definition = {
    methods: ["post"],
    url: '/api/auth/recuperar-clave/solicitar',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitarRecuperacion
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
solicitarRecuperacion.url = (options?: RouteQueryOptions) => {
    return solicitarRecuperacion.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitarRecuperacion
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
solicitarRecuperacion.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: solicitarRecuperacion.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitarRecuperacion
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
    const solicitarRecuperacionForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: solicitarRecuperacion.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::solicitarRecuperacion
 * @see app/Http/Controllers/TokenRecuperacionController.php:36
 * @route '/api/auth/recuperar-clave/solicitar'
 */
        solicitarRecuperacionForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: solicitarRecuperacion.url(options),
            method: 'post',
        })
    
    solicitarRecuperacion.form = solicitarRecuperacionForm
/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecerContrasena
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
export const restablecerContrasena = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: restablecerContrasena.url(options),
    method: 'post',
})

restablecerContrasena.definition = {
    methods: ["post"],
    url: '/api/auth/recuperar-clave/restablecer',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecerContrasena
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
restablecerContrasena.url = (options?: RouteQueryOptions) => {
    return restablecerContrasena.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecerContrasena
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
restablecerContrasena.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: restablecerContrasena.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecerContrasena
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
    const restablecerContrasenaForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: restablecerContrasena.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::restablecerContrasena
 * @see app/Http/Controllers/TokenRecuperacionController.php:103
 * @route '/api/auth/recuperar-clave/restablecer'
 */
        restablecerContrasenaForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: restablecerContrasena.url(options),
            method: 'post',
        })
    
    restablecerContrasena.form = restablecerContrasenaForm
/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/tokens-recuperacion',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
        indexForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    index.form = indexForm
const TokenRecuperacionController = { solicitarRecuperacion, restablecerContrasena, index }

export default TokenRecuperacionController