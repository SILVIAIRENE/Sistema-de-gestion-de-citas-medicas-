import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/notificaciones',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\NotificacionController::index
 * @see app/Http/Controllers/NotificacionController.php:19
 * @route '/api/notificaciones'
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
/**
* @see \App\Http\Controllers\NotificacionController::store
 * @see app/Http/Controllers/NotificacionController.php:42
 * @route '/api/notificaciones'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/notificaciones',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificacionController::store
 * @see app/Http/Controllers/NotificacionController.php:42
 * @route '/api/notificaciones'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::store
 * @see app/Http/Controllers/NotificacionController.php:42
 * @route '/api/notificaciones'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificacionController::store
 * @see app/Http/Controllers/NotificacionController.php:42
 * @route '/api/notificaciones'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::store
 * @see app/Http/Controllers/NotificacionController.php:42
 * @route '/api/notificaciones'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\NotificacionController::regenerarLista
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
export const regenerarLista = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: regenerarLista.url(options),
    method: 'post',
})

regenerarLista.definition = {
    methods: ["post"],
    url: '/api/notificaciones/regenerar',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificacionController::regenerarLista
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
regenerarLista.url = (options?: RouteQueryOptions) => {
    return regenerarLista.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::regenerarLista
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
regenerarLista.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: regenerarLista.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificacionController::regenerarLista
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
    const regenerarListaForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: regenerarLista.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::regenerarLista
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
        regenerarListaForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: regenerarLista.url(options),
            method: 'post',
        })
    
    regenerarLista.form = regenerarListaForm
/**
* @see \App\Http\Controllers\NotificacionController::registrarGestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
export const registrarGestion = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: registrarGestion.url(args, options),
    method: 'put',
})

registrarGestion.definition = {
    methods: ["put"],
    url: '/api/notificaciones/{id}/gestion',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\NotificacionController::registrarGestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
registrarGestion.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
    if (typeof args === 'string' || typeof args === 'number') {
        args = { id: args }
    }

    
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                }

    return registrarGestion.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::registrarGestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
registrarGestion.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: registrarGestion.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\NotificacionController::registrarGestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
    const registrarGestionForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: registrarGestion.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::registrarGestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
        registrarGestionForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: registrarGestion.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    registrarGestion.form = registrarGestionForm
const NotificacionController = { index, store, regenerarLista, registrarGestion }

export default NotificacionController