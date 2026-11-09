import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
/**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/bitacora',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\BitacoraController::index
 * @see app/Http/Controllers/BitacoraController.php:15
 * @route '/api/bitacora'
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
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
export const live = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: live.url(options),
    method: 'get',
})

live.definition = {
    methods: ["get","head"],
    url: '/api/bitacora/live',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
live.url = (options?: RouteQueryOptions) => {
    return live.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
live.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: live.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
live.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: live.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
    const liveForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: live.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
        liveForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: live.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\BitacoraController::live
 * @see app/Http/Controllers/BitacoraController.php:118
 * @route '/api/bitacora/live'
 */
        liveForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: live.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    live.form = liveForm
/**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
export const resumen = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: resumen.url(options),
    method: 'get',
})

resumen.definition = {
    methods: ["get","head"],
    url: '/api/bitacora/resumen',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
resumen.url = (options?: RouteQueryOptions) => {
    return resumen.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
resumen.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: resumen.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
resumen.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: resumen.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
    const resumenForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: resumen.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
        resumenForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: resumen.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\BitacoraController::resumen
 * @see app/Http/Controllers/BitacoraController.php:202
 * @route '/api/bitacora/resumen'
 */
        resumenForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: resumen.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    resumen.form = resumenForm
/**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/bitacora/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
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
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\BitacoraController::show
 * @see app/Http/Controllers/BitacoraController.php:172
 * @route '/api/bitacora/{id}'
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
const bitacora = {
    index: Object.assign(index, index),
live: Object.assign(live, live),
resumen: Object.assign(resumen, resumen),
show: Object.assign(show, show),
}

export default bitacora