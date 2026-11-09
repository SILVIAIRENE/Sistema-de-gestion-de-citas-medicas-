import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
 */
export const index = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/medicos/{id}/especialidades',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
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
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
 */
index.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
 */
index.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
 */
    const indexForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
 */
        indexForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\MedicoEspecialidadController::index
 * @see app/Http/Controllers/MedicoEspecialidadController.php:17
 * @route '/api/medicos/{id}/especialidades'
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
* @see \App\Http\Controllers\MedicoEspecialidadController::sincronizar
 * @see app/Http/Controllers/MedicoEspecialidadController.php:31
 * @route '/api/medicos/{id}/especialidades'
 */
export const sincronizar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: sincronizar.url(args, options),
    method: 'put',
})

sincronizar.definition = {
    methods: ["put"],
    url: '/api/medicos/{id}/especialidades',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\MedicoEspecialidadController::sincronizar
 * @see app/Http/Controllers/MedicoEspecialidadController.php:31
 * @route '/api/medicos/{id}/especialidades'
 */
sincronizar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return sincronizar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\MedicoEspecialidadController::sincronizar
 * @see app/Http/Controllers/MedicoEspecialidadController.php:31
 * @route '/api/medicos/{id}/especialidades'
 */
sincronizar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: sincronizar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\MedicoEspecialidadController::sincronizar
 * @see app/Http/Controllers/MedicoEspecialidadController.php:31
 * @route '/api/medicos/{id}/especialidades'
 */
    const sincronizarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: sincronizar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\MedicoEspecialidadController::sincronizar
 * @see app/Http/Controllers/MedicoEspecialidadController.php:31
 * @route '/api/medicos/{id}/especialidades'
 */
        sincronizarForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: sincronizar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    sincronizar.form = sincronizarForm
const MedicoEspecialidadController = { index, sincronizar }

export default MedicoEspecialidadController