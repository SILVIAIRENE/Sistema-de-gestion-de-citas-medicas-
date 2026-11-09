import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
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
* @see \App\Http\Controllers\NotificacionController::regenerar
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
export const regenerar = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: regenerar.url(options),
    method: 'post',
})

regenerar.definition = {
    methods: ["post"],
    url: '/api/notificaciones/regenerar',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\NotificacionController::regenerar
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
regenerar.url = (options?: RouteQueryOptions) => {
    return regenerar.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::regenerar
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
regenerar.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: regenerar.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\NotificacionController::regenerar
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
    const regenerarForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: regenerar.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::regenerar
 * @see app/Http/Controllers/NotificacionController.php:149
 * @route '/api/notificaciones/regenerar'
 */
        regenerarForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: regenerar.url(options),
            method: 'post',
        })
    
    regenerar.form = regenerarForm
/**
* @see \App\Http\Controllers\NotificacionController::gestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
export const gestion = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: gestion.url(args, options),
    method: 'put',
})

gestion.definition = {
    methods: ["put"],
    url: '/api/notificaciones/{id}/gestion',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\NotificacionController::gestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
gestion.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return gestion.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\NotificacionController::gestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
gestion.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: gestion.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\NotificacionController::gestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
    const gestionForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: gestion.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\NotificacionController::gestion
 * @see app/Http/Controllers/NotificacionController.php:84
 * @route '/api/notificaciones/{id}/gestion'
 */
        gestionForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: gestion.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    gestion.form = gestionForm
const notificaciones = {
    index: Object.assign(index, index),
store: Object.assign(store, store),
regenerar: Object.assign(regenerar, regenerar),
gestion: Object.assign(gestion, gestion),
}

export default notificaciones