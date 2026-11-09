import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\HorarioController::configurar
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
export const configurar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: configurar.url(args, options),
    method: 'post',
})

configurar.definition = {
    methods: ["post"],
    url: '/api/medicos/{id}/horarios',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\HorarioController::configurar
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
configurar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return configurar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::configurar
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
configurar.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: configurar.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\HorarioController::configurar
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
    const configurarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: configurar.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\HorarioController::configurar
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
        configurarForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: configurar.url(args, options),
            method: 'post',
        })
    
    configurar.form = configurarForm
/**
* @see \App\Http\Controllers\HorarioController::eliminar
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
export const eliminar = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminar.url(args, options),
    method: 'delete',
})

eliminar.definition = {
    methods: ["delete"],
    url: '/api/medicos/{id}/horarios/{horarioId}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\HorarioController::eliminar
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
eliminar.url = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions) => {
    if (Array.isArray(args)) {
        args = {
                    id: args[0],
                    horarioId: args[1],
                }
    }

    args = applyUrlDefaults(args)

    const parsedArgs = {
                        id: args.id,
                                horarioId: args.horarioId,
                }

    return eliminar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace('{horarioId}', parsedArgs.horarioId.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::eliminar
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
eliminar.delete = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminar.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\HorarioController::eliminar
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
    const eliminarForm = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: eliminar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\HorarioController::eliminar
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
        eliminarForm.delete = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: eliminar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    eliminar.form = eliminarForm
/**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
export const obtener = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: obtener.url(args, options),
    method: 'get',
})

obtener.definition = {
    methods: ["get","head"],
    url: '/api/medicos/{id}/horarios',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtener.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return obtener.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtener.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: obtener.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtener.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: obtener.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
    const obtenerForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: obtener.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
        obtenerForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: obtener.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\HorarioController::obtener
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
        obtenerForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: obtener.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    obtener.form = obtenerForm
const horarios = {
    configurar: Object.assign(configurar, configurar),
eliminar: Object.assign(eliminar, eliminar),
obtener: Object.assign(obtener, obtener),
}

export default horarios