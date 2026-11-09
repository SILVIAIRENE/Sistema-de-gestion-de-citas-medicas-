import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\PacienteController::autoRegistroWeb
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
export const autoRegistroWeb = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: autoRegistroWeb.url(options),
    method: 'post',
})

autoRegistroWeb.definition = {
    methods: ["post"],
    url: '/api/auth/autoregistro-paciente',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PacienteController::autoRegistroWeb
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
autoRegistroWeb.url = (options?: RouteQueryOptions) => {
    return autoRegistroWeb.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::autoRegistroWeb
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
autoRegistroWeb.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: autoRegistroWeb.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PacienteController::autoRegistroWeb
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
    const autoRegistroWebForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: autoRegistroWeb.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PacienteController::autoRegistroWeb
 * @see app/Http/Controllers/PacienteController.php:343
 * @route '/api/auth/autoregistro-paciente'
 */
        autoRegistroWebForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: autoRegistroWeb.url(options),
            method: 'post',
        })
    
    autoRegistroWeb.form = autoRegistroWebForm
/**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/pacientes',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PacienteController::index
 * @see app/Http/Controllers/PacienteController.php:25
 * @route '/api/pacientes'
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
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/pacientes/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
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
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\PacienteController::show
 * @see app/Http/Controllers/PacienteController.php:69
 * @route '/api/pacientes/{id}'
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
* @see \App\Http\Controllers\PacienteController::store
 * @see app/Http/Controllers/PacienteController.php:103
 * @route '/api/pacientes'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/pacientes',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\PacienteController::store
 * @see app/Http/Controllers/PacienteController.php:103
 * @route '/api/pacientes'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::store
 * @see app/Http/Controllers/PacienteController.php:103
 * @route '/api/pacientes'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\PacienteController::store
 * @see app/Http/Controllers/PacienteController.php:103
 * @route '/api/pacientes'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PacienteController::store
 * @see app/Http/Controllers/PacienteController.php:103
 * @route '/api/pacientes'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\PacienteController::update
 * @see app/Http/Controllers/PacienteController.php:181
 * @route '/api/pacientes/{id}'
 */
export const update = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/pacientes/{id}',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\PacienteController::update
 * @see app/Http/Controllers/PacienteController.php:181
 * @route '/api/pacientes/{id}'
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
* @see \App\Http\Controllers\PacienteController::update
 * @see app/Http/Controllers/PacienteController.php:181
 * @route '/api/pacientes/{id}'
 */
update.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\PacienteController::update
 * @see app/Http/Controllers/PacienteController.php:181
 * @route '/api/pacientes/{id}'
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
* @see \App\Http\Controllers\PacienteController::update
 * @see app/Http/Controllers/PacienteController.php:181
 * @route '/api/pacientes/{id}'
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
/**
* @see \App\Http\Controllers\PacienteController::inactivar
 * @see app/Http/Controllers/PacienteController.php:267
 * @route '/api/pacientes/{id}/inactivar'
 */
export const inactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

inactivar.definition = {
    methods: ["put"],
    url: '/api/pacientes/{id}/inactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\PacienteController::inactivar
 * @see app/Http/Controllers/PacienteController.php:267
 * @route '/api/pacientes/{id}/inactivar'
 */
inactivar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return inactivar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::inactivar
 * @see app/Http/Controllers/PacienteController.php:267
 * @route '/api/pacientes/{id}/inactivar'
 */
inactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\PacienteController::inactivar
 * @see app/Http/Controllers/PacienteController.php:267
 * @route '/api/pacientes/{id}/inactivar'
 */
    const inactivarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: inactivar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PacienteController::inactivar
 * @see app/Http/Controllers/PacienteController.php:267
 * @route '/api/pacientes/{id}/inactivar'
 */
        inactivarForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: inactivar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    inactivar.form = inactivarForm
/**
* @see \App\Http\Controllers\PacienteController::reactivar
 * @see app/Http/Controllers/PacienteController.php:312
 * @route '/api/pacientes/{id}/reactivar'
 */
export const reactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

reactivar.definition = {
    methods: ["put"],
    url: '/api/pacientes/{id}/reactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\PacienteController::reactivar
 * @see app/Http/Controllers/PacienteController.php:312
 * @route '/api/pacientes/{id}/reactivar'
 */
reactivar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return reactivar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\PacienteController::reactivar
 * @see app/Http/Controllers/PacienteController.php:312
 * @route '/api/pacientes/{id}/reactivar'
 */
reactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\PacienteController::reactivar
 * @see app/Http/Controllers/PacienteController.php:312
 * @route '/api/pacientes/{id}/reactivar'
 */
    const reactivarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: reactivar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\PacienteController::reactivar
 * @see app/Http/Controllers/PacienteController.php:312
 * @route '/api/pacientes/{id}/reactivar'
 */
        reactivarForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: reactivar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    reactivar.form = reactivarForm
const PacienteController = { autoRegistroWeb, index, show, store, update, inactivar, reactivar }

export default PacienteController