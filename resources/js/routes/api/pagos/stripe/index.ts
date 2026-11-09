import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\PagoController::session
 * @see app/Http/Controllers/PagoController.php:286
 * @route '/api/pagos/stripe/crear-sesion'
 */
export const session = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: session.url(options),
    method: 'post',
})

session.definition = {
    methods: ["post"],
    url: '/api/pagos/stripe/crear-sesion',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PagoController::session
 * @see app/Http/Controllers/PagoController.php:286
 * @route '/api/pagos/stripe/crear-sesion'
 */
session.url = (options?: RouteQueryOptions) => {
    return session.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PagoController::session
 * @see app/Http/Controllers/PagoController.php:286
 * @route '/api/pagos/stripe/crear-sesion'
 */
session.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: session.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PagoController::session
 * @see app/Http/Controllers/PagoController.php:286
 * @route '/api/pagos/stripe/crear-sesion'
 */
    const sessionForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: session.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PagoController::session
 * @see app/Http/Controllers/PagoController.php:286
 * @route '/api/pagos/stripe/crear-sesion'
 */
        sessionForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: session.url(options),
            method: 'post',
        })
    
    session.form = sessionForm
const stripe = {
    session: Object.assign(session, session),
}

export default stripe