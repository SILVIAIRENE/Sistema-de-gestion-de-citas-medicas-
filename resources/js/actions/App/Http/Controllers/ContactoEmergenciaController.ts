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
* @see \App\Http\Controllers\ContactoEmergenciaController::agregarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
export const agregarContactoEmergencia = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: agregarContactoEmergencia.url(args, options),
    method: 'post',
})

agregarContactoEmergencia.definition = {
    methods: ["post"],
    url: '/api/pacientes/{id}/contactos-emergencia',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::agregarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
agregarContactoEmergencia.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return agregarContactoEmergencia.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::agregarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
agregarContactoEmergencia.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: agregarContactoEmergencia.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\ContactoEmergenciaController::agregarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
    const agregarContactoEmergenciaForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: agregarContactoEmergencia.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::agregarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:40
 * @route '/api/pacientes/{id}/contactos-emergencia'
 */
        agregarContactoEmergenciaForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: agregarContactoEmergencia.url(args, options),
            method: 'post',
        })
    
    agregarContactoEmergencia.form = agregarContactoEmergenciaForm
/**
* @see \App\Http\Controllers\ContactoEmergenciaController::eliminarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
export const eliminarContactoEmergencia = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminarContactoEmergencia.url(args, options),
    method: 'delete',
})

eliminarContactoEmergencia.definition = {
    methods: ["delete"],
    url: '/api/pacientes/{id}/contactos-emergencia/{contactoId}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::eliminarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
eliminarContactoEmergencia.url = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions) => {
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

    return eliminarContactoEmergencia.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace('{contactoId}', parsedArgs.contactoId.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\ContactoEmergenciaController::eliminarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
eliminarContactoEmergencia.delete = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminarContactoEmergencia.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\ContactoEmergenciaController::eliminarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
    const eliminarContactoEmergenciaForm = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: eliminarContactoEmergencia.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\ContactoEmergenciaController::eliminarContactoEmergencia
 * @see app/Http/Controllers/ContactoEmergenciaController.php:100
 * @route '/api/pacientes/{id}/contactos-emergencia/{contactoId}'
 */
        eliminarContactoEmergenciaForm.delete = (args: { id: string | number, contactoId: string | number } | [id: string | number, contactoId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: eliminarContactoEmergencia.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    eliminarContactoEmergencia.form = eliminarContactoEmergenciaForm
const ContactoEmergenciaController = { index, agregarContactoEmergencia, eliminarContactoEmergencia }

export default ContactoEmergenciaController