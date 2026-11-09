import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
export const login = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

login.definition = {
    methods: ["post"],
    url: '/api/auth/login',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
login.url = (options?: RouteQueryOptions) => {
    return login.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
login.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: login.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
    const loginForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: login.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\SesionController::login
 * @see app/Http/Controllers/SesionController.php:43
 * @route '/api/auth/login'
 */
        loginForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: login.url(options),
            method: 'post',
        })
    
    login.form = loginForm
/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
export const logoutSummary = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: logoutSummary.url(options),
    method: 'get',
})

logoutSummary.definition = {
    methods: ["get","head"],
    url: '/api/auth/logout-summary',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.url = (options?: RouteQueryOptions) => {
    return logoutSummary.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: logoutSummary.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
logoutSummary.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: logoutSummary.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
    const logoutSummaryForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: logoutSummary.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
        logoutSummaryForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: logoutSummary.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\SesionController::logoutSummary
 * @see app/Http/Controllers/SesionController.php:337
 * @route '/api/auth/logout-summary'
 */
        logoutSummaryForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: logoutSummary.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    logoutSummary.form = logoutSummaryForm
/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
const logout028457b752b2e7db1fe4736d8c51831d = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout028457b752b2e7db1fe4736d8c51831d.url(options),
    method: 'post',
})

logout028457b752b2e7db1fe4736d8c51831d.definition = {
    methods: ["post"],
    url: '/api/auth/logout',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
logout028457b752b2e7db1fe4736d8c51831d.url = (options?: RouteQueryOptions) => {
    return logout028457b752b2e7db1fe4736d8c51831d.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
logout028457b752b2e7db1fe4736d8c51831d.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logout028457b752b2e7db1fe4736d8c51831d.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
    const logout028457b752b2e7db1fe4736d8c51831dForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: logout028457b752b2e7db1fe4736d8c51831d.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/api/auth/logout'
 */
        logout028457b752b2e7db1fe4736d8c51831dForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: logout028457b752b2e7db1fe4736d8c51831d.url(options),
            method: 'post',
        })
    
    logout028457b752b2e7db1fe4736d8c51831d.form = logout028457b752b2e7db1fe4736d8c51831dForm
    /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/logout'
 */
const logoutf732b903d9f8919b4c24bef1f8bb897a = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logoutf732b903d9f8919b4c24bef1f8bb897a.url(options),
    method: 'post',
})

logoutf732b903d9f8919b4c24bef1f8bb897a.definition = {
    methods: ["post"],
    url: '/logout',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/logout'
 */
logoutf732b903d9f8919b4c24bef1f8bb897a.url = (options?: RouteQueryOptions) => {
    return logoutf732b903d9f8919b4c24bef1f8bb897a.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/logout'
 */
logoutf732b903d9f8919b4c24bef1f8bb897a.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: logoutf732b903d9f8919b4c24bef1f8bb897a.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/logout'
 */
    const logoutf732b903d9f8919b4c24bef1f8bb897aForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: logoutf732b903d9f8919b4c24bef1f8bb897a.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\SesionController::logout
 * @see app/Http/Controllers/SesionController.php:219
 * @route '/logout'
 */
        logoutf732b903d9f8919b4c24bef1f8bb897aForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: logoutf732b903d9f8919b4c24bef1f8bb897a.url(options),
            method: 'post',
        })
    
    logoutf732b903d9f8919b4c24bef1f8bb897a.form = logoutf732b903d9f8919b4c24bef1f8bb897aForm

/**
* Multiple routes resolve to \App\Http\Controllers\SesionController::logout, so this export is a
* dictionary keyed by URI rather than a callable, with the verbs prefixed where two routes share a URI.
* Call a specific route with `logout['<key>'](...)`, or import the route by name from your
* generated `routes/` directory.
*/
export const logout = {
    '/api/auth/logout': logout028457b752b2e7db1fe4736d8c51831d,
    '/logout': logoutf732b903d9f8919b4c24bef1f8bb897a,
}

/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
export const me = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})

me.definition = {
    methods: ["get","head"],
    url: '/api/auth/me',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.url = (options?: RouteQueryOptions) => {
    return me.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: me.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
me.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: me.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
    const meForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: me.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
        meForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: me.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\SesionController::me
 * @see app/Http/Controllers/SesionController.php:406
 * @route '/api/auth/me'
 */
        meForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: me.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    me.form = meForm
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
const SesionController = { login, logoutSummary, logout, me, index }

export default SesionController