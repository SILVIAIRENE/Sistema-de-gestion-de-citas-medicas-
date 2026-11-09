import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../wayfinder'
/**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/sesiones',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\SesionController::index
 * @see app/Http/Controllers/SesionController.php:20
 * @route '/api/sesiones'
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
const sesiones = {
    index: Object.assign(index, index),
}

export default sesiones