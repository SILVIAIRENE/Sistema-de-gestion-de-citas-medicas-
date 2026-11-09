import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
/**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/personal-administrativo',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::index
 * @see app/Http/Controllers/PersonalAdministrativoController.php:16
 * @route '/api/personal-administrativo'
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
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/personal-administrativo/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
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
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::show
 * @see app/Http/Controllers/PersonalAdministrativoController.php:30
 * @route '/api/personal-administrativo/{id}'
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
* @see \App\Http\Controllers\PersonalAdministrativoController::store
 * @see app/Http/Controllers/PersonalAdministrativoController.php:50
 * @route '/api/personal-administrativo'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/personal-administrativo',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::store
 * @see app/Http/Controllers/PersonalAdministrativoController.php:50
 * @route '/api/personal-administrativo'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::store
 * @see app/Http/Controllers/PersonalAdministrativoController.php:50
 * @route '/api/personal-administrativo'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PersonalAdministrativoController::store
 * @see app/Http/Controllers/PersonalAdministrativoController.php:50
 * @route '/api/personal-administrativo'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::store
 * @see app/Http/Controllers/PersonalAdministrativoController.php:50
 * @route '/api/personal-administrativo'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\PersonalAdministrativoController::update
 * @see app/Http/Controllers/PersonalAdministrativoController.php:87
 * @route '/api/personal-administrativo/{id}'
 */
export const update = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/personal-administrativo/{id}',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::update
 * @see app/Http/Controllers/PersonalAdministrativoController.php:87
 * @route '/api/personal-administrativo/{id}'
 */
update.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return update.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\PersonalAdministrativoController::update
 * @see app/Http/Controllers/PersonalAdministrativoController.php:87
 * @route '/api/personal-administrativo/{id}'
 */
update.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\PersonalAdministrativoController::update
 * @see app/Http/Controllers/PersonalAdministrativoController.php:87
 * @route '/api/personal-administrativo/{id}'
 */
    const updateForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: update.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PersonalAdministrativoController::update
 * @see app/Http/Controllers/PersonalAdministrativoController.php:87
 * @route '/api/personal-administrativo/{id}'
 */
        updateForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: update.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    update.form = updateForm
const personalAdministrativo = {
    index: Object.assign(index, index),
show: Object.assign(show, show),
store: Object.assign(store, store),
update: Object.assign(update, update),
}

export default personalAdministrativo