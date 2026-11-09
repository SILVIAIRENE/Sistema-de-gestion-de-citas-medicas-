import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
export const index = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/citas/{id}/historial-estados',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
index.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return index.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
index.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
index.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
    const indexForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
        indexForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\HistorialEstadoCitaController::index
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:18
 * @route '/api/citas/{id}/historial-estados'
 */
        indexForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    index.form = indexForm
/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::store
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:35
 * @route '/api/citas/{id}/historial-estados'
 */
export const store = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(args, options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/citas/{id}/historial-estados',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::store
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:35
 * @route '/api/citas/{id}/historial-estados'
 */
store.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return store.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HistorialEstadoCitaController::store
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:35
 * @route '/api/citas/{id}/historial-estados'
 */
store.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\HistorialEstadoCitaController::store
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:35
 * @route '/api/citas/{id}/historial-estados'
 */
    const storeForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\HistorialEstadoCitaController::store
 * @see app/Http/Controllers/HistorialEstadoCitaController.php:35
 * @route '/api/citas/{id}/historial-estados'
 */
        storeForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(args, options),
            method: 'post',
        })
    
    store.form = storeForm
const historialEstados = {
    index: Object.assign(index, index),
store: Object.assign(store, store),
}

export default historialEstados