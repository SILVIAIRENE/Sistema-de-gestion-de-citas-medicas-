import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
import stripe from './stripe'
/**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/pagos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PagoController::index
 * @see app/Http/Controllers/PagoController.php:24
 * @route '/api/pagos'
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
* @see \App\Http\Controllers\PagoController::store
 * @see app/Http/Controllers/PagoController.php:122
 * @route '/api/pagos'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/pagos',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PagoController::store
 * @see app/Http/Controllers/PagoController.php:122
 * @route '/api/pagos'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PagoController::store
 * @see app/Http/Controllers/PagoController.php:122
 * @route '/api/pagos'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PagoController::store
 * @see app/Http/Controllers/PagoController.php:122
 * @route '/api/pagos'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PagoController::store
 * @see app/Http/Controllers/PagoController.php:122
 * @route '/api/pagos'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/pagos/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
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
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PagoController::show
 * @see app/Http/Controllers/PagoController.php:85
 * @route '/api/pagos/{id}'
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
* @see \App\Http\Controllers\PagoController::reembolso
 * @see app/Http/Controllers/PagoController.php:211
 * @route '/api/pagos/{id}/reembolso'
 */
export const reembolso = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: reembolso.url(args, options),
    method: 'post',
})

reembolso.definition = {
    methods: ["post"],
    url: '/api/pagos/{id}/reembolso',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PagoController::reembolso
 * @see app/Http/Controllers/PagoController.php:211
 * @route '/api/pagos/{id}/reembolso'
 */
reembolso.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return reembolso.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\PagoController::reembolso
 * @see app/Http/Controllers/PagoController.php:211
 * @route '/api/pagos/{id}/reembolso'
 */
reembolso.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: reembolso.url(args, options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PagoController::reembolso
 * @see app/Http/Controllers/PagoController.php:211
 * @route '/api/pagos/{id}/reembolso'
 */
    const reembolsoForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: reembolso.url(args, options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PagoController::reembolso
 * @see app/Http/Controllers/PagoController.php:211
 * @route '/api/pagos/{id}/reembolso'
 */
        reembolsoForm.post = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: reembolso.url(args, options),
            method: 'post',
        })
    
    reembolso.form = reembolsoForm
const pagos = {
    index: Object.assign(index, index),
store: Object.assign(store, store),
show: Object.assign(show, show),
reembolso: Object.assign(reembolso, reembolso),
stripe: Object.assign(stripe, stripe),
}

export default pagos