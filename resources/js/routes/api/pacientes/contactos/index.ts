import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
export const index = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/pacientes/{id}/contactos-emergencia',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
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
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
index.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
index.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
    const indexForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
        indexForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::index
 * @see app/Http/Controllers/ContactoEmergenciaController.php:18
 * @route '/api/pacientes/{id}/contactos-emergencia'
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
* @see \App\Http\Controllers\ContactoEmergenciaController::store
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
export const store = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(args, options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/pacientes/{id}/contactos-emergencia',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::store
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
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
* @see \App\Http\Controllers\ContactoEmergenciaController::store
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
store.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\ContactoEmergenciaController::store
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
    const storeForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::store
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
        storeForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(args, options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\ContactoEmergenciaController::destroy
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
export const destroy = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

destroy.definition = {
    methods: ["delete"],
    url: '/api/pacientes/{id}/contactos-emergencia/{contactoId}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::destroy
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
destroy.url = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions) => {
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                    contactoId: args[1],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                                contactoId: args.contactoId,
                }

    return destroy.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace('{contactoId}', parsedArgs.contactoId.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::destroy
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
destroy.delete = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: destroy.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\ContactoEmergenciaController::destroy
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
    const destroyForm = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: destroy.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::destroy
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
        destroyForm.delete = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: destroy.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    destroy.form = destroyForm
const contactos = {
    index: Object.assign(index, index),
store: Object.assign(store, store),
destroy: Object.assign(destroy, destroy),
}

export default contactos