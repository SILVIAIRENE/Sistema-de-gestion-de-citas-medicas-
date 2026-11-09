import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/pacientes/{id}/informacion-medica',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
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
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\InformacionMedicaController::show
 * @see app/Http/Controllers/InformacionMedicaController.php:20
 * @route '/api/pacientes/{id}/informacion-medica'
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