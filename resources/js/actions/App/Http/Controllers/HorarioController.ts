import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\HorarioController::configurarHorarios
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
export const configurarHorarios = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: configurarHorarios.url(args, options),
    method: 'post',
})

configurarHorarios.definition = {
    methods: ["post"],
    url: '/api/medicos/{id}/horarios',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\HorarioController::configurarHorarios
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
configurarHorarios.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return configurarHorarios.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::configurarHorarios
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
configurarHorarios.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: configurarHorarios.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\HorarioController::configurarHorarios
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
    const configurarHorariosForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: configurarHorarios.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\HorarioController::configurarHorarios
 * @see app/Http/Controllers/HorarioController.php:40
 * @route '/api/medicos/{id}/horarios'
 */
        configurarHorariosForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: configurarHorarios.url(args, options),
            method: 'post',
        })
    
    configurarHorarios.form = configurarHorariosForm
/**
* @see \App\Http\Controllers\HorarioController::eliminarHorario
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
export const eliminarHorario = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminarHorario.url(args, options),
    method: 'delete',
})

eliminarHorario.definition = {
    methods: ["delete"],
    url: '/api/medicos/{id}/horarios/{horarioId}',
} satisfies RouteDefinition<["delete"]>

/**
* @see \App\Http\Controllers\HorarioController::eliminarHorario
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
eliminarHorario.url = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions) => {
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

    return eliminarHorario.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace('{horarioId}', parsedArgs.horarioId.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::eliminarHorario
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
eliminarHorario.delete = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteDefinition<'delete'> => ({
    url: eliminarHorario.url(args, options),
    method: 'delete',
})

    /**
* @see \App\Http\Controllers\HorarioController::eliminarHorario
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
    const eliminarHorarioForm = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: eliminarHorario.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'DELETE',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\HorarioController::eliminarHorario
 * @see app/Http/Controllers/HorarioController.php:158
 * @route '/api/medicos/{id}/horarios/{horarioId}'
 */
        eliminarHorarioForm.delete = (args: { id: string | number, horarioId: string | number } | [id: string | number, horarioId: string | number ], options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: eliminarHorario.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'DELETE',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    eliminarHorario.form = eliminarHorarioForm
/**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
export const obtenerHorarios = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: obtenerHorarios.url(args, options),
    method: 'get',
})

obtenerHorarios.definition = {
    methods: ["get","head"],
    url: '/api/medicos/{id}/horarios',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtenerHorarios.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return obtenerHorarios.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtenerHorarios.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: obtenerHorarios.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
obtenerHorarios.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: obtenerHorarios.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
    const obtenerHorariosForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: obtenerHorarios.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
        obtenerHorariosForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: obtenerHorarios.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\HorarioController::obtenerHorarios
 * @see app/Http/Controllers/HorarioController.php:19
 * @route '/api/medicos/{id}/horarios'
 */
        obtenerHorariosForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: obtenerHorarios.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    obtenerHorarios.form = obtenerHorariosForm
const HorarioController = { configurarHorarios, eliminarHorario, obtenerHorarios }

export default HorarioController