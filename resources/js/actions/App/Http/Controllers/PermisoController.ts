import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
const indexc54f071d346146e88c5c9f349b0ca52b = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: indexc54f071d346146e88c5c9f349b0ca52b.url(options),
    method: 'get',
})

indexc54f071d346146e88c5c9f349b0ca52b.definition = {
    methods: ["get","head"],
    url: '/api/permisos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
indexc54f071d346146e88c5c9f349b0ca52b.url = (options?: RouteQueryOptions) => {
    return indexc54f071d346146e88c5c9f349b0ca52b.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
indexc54f071d346146e88c5c9f349b0ca52b.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: indexc54f071d346146e88c5c9f349b0ca52b.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
indexc54f071d346146e88c5c9f349b0ca52b.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: indexc54f071d346146e88c5c9f349b0ca52b.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
    const indexc54f071d346146e88c5c9f349b0ca52bForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: indexc54f071d346146e88c5c9f349b0ca52b.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
        indexc54f071d346146e88c5c9f349b0ca52bForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: indexc54f071d346146e88c5c9f349b0ca52b.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/permisos'
 */
        indexc54f071d346146e88c5c9f349b0ca52bForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: indexc54f071d346146e88c5c9f349b0ca52b.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    indexc54f071d346146e88c5c9f349b0ca52b.form = indexc54f071d346146e88c5c9f349b0ca52bForm
    /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
const indexb6f50ebf31c4c52c345398f2eccefb34 = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: indexb6f50ebf31c4c52c345398f2eccefb34.url(options),
    method: 'get',
})

indexb6f50ebf31c4c52c345398f2eccefb34.definition = {
    methods: ["get","head"],
    url: '/api/roles/permisos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
indexb6f50ebf31c4c52c345398f2eccefb34.url = (options?: RouteQueryOptions) => {
    return indexb6f50ebf31c4c52c345398f2eccefb34.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
indexb6f50ebf31c4c52c345398f2eccefb34.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: indexb6f50ebf31c4c52c345398f2eccefb34.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
indexb6f50ebf31c4c52c345398f2eccefb34.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: indexb6f50ebf31c4c52c345398f2eccefb34.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
    const indexb6f50ebf31c4c52c345398f2eccefb34Form = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: indexb6f50ebf31c4c52c345398f2eccefb34.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
        indexb6f50ebf31c4c52c345398f2eccefb34Form.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: indexb6f50ebf31c4c52c345398f2eccefb34.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PermisoController::index
 * @see app/Http/Controllers/PermisoController.php:16
 * @route '/api/roles/permisos'
 */
        indexb6f50ebf31c4c52c345398f2eccefb34Form.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: indexb6f50ebf31c4c52c345398f2eccefb34.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    indexb6f50ebf31c4c52c345398f2eccefb34.form = indexb6f50ebf31c4c52c345398f2eccefb34Form

/**
* Multiple routes resolve to \App\Http\Controllers\PermisoController::index, so this export is a
* dictionary keyed by URI rather than a callable, with the verbs prefixed where two routes share a URI.
* Call a specific route with `index['<key>'](...)`, or import the route by name from your
* generated `routes/` directory.
*/
export const index = {
    '/api/permisos': indexc54f071d346146e88c5c9f349b0ca52b,
    '/api/roles/permisos': indexb6f50ebf31c4c52c345398f2eccefb34,
}

/**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/permisos/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
show.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return show.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PermisoController::show
 * @see app/Http/Controllers/PermisoController.php:30
 * @route '/api/permisos/{id}'
 */
        showForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    show.form = showForm
/**
* @see \App\Http\Controllers\PermisoController::store
 * @see app/Http/Controllers/PermisoController.php:50
 * @route '/api/permisos'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/permisos',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PermisoController::store
 * @see app/Http/Controllers/PermisoController.php:50
 * @route '/api/permisos'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PermisoController::store
 * @see app/Http/Controllers/PermisoController.php:50
 * @route '/api/permisos'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PermisoController::store
 * @see app/Http/Controllers/PermisoController.php:50
 * @route '/api/permisos'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PermisoController::store
 * @see app/Http/Controllers/PermisoController.php:50
 * @route '/api/permisos'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
const PermisoController = { index, show, store }

export default PermisoController