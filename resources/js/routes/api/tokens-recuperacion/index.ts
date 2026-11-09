import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../wayfinder'
/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/tokens-recuperacion',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\TokenRecuperacionController::index
 * @see app/Http/Controllers/TokenRecuperacionController.php:19
 * @route '/api/tokens-recuperacion'
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
const tokensRecuperacion = {
    index: Object.assign(index, index),
}

export default tokensRecuperacion