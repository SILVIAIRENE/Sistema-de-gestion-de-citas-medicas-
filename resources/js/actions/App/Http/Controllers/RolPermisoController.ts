import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
 */
export const index = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/roles/{id}/permisos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
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
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
 */
index.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
 */
index.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
 */
    const indexForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
 */
        indexForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\RolPermisoController::index
 * @see app/Http/Controllers/RolPermisoController.php:17
 * @route '/api/roles/{id}/permisos'
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
* @see \App\Http\Controllers\RolPermisoController::sincronizarPermisos
 * @see app/Http/Controllers/RolPermisoController.php:31
 * @route '/api/roles/{id}/permisos'
 */
export const sincronizarPermisos = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: sincronizarPermisos.url(args, options),
    method: 'put',
})

sincronizarPermisos.definition = {
    methods: ["put"],
    url: '/api/roles/{id}/permisos',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\RolPermisoController::sincronizarPermisos
 * @see app/Http/Controllers/RolPermisoController.php:31
 * @route '/api/roles/{id}/permisos'
 */
sincronizarPermisos.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return sincronizarPermisos.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\RolPermisoController::sincronizarPermisos
 * @see app/Http/Controllers/RolPermisoController.php:31
 * @route '/api/roles/{id}/permisos'
 */
sincronizarPermisos.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: sincronizarPermisos.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\RolPermisoController::sincronizarPermisos
 * @see app/Http/Controllers/RolPermisoController.php:31
 * @route '/api/roles/{id}/permisos'
 */
    const sincronizarPermisosForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: sincronizarPermisos.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\RolPermisoController::sincronizarPermisos
 * @see app/Http/Controllers/RolPermisoController.php:31
 * @route '/api/roles/{id}/permisos'
 */
        sincronizarPermisosForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: sincronizarPermisos.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    sincronizarPermisos.form = sincronizarPermisosForm
const RolPermisoController = { index, sincronizarPermisos }

export default RolPermisoController