import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../wayfinder'
import especialidades from './especialidades'
import horarios from './horarios'
/**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/medicos',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\MedicoController::index
 * @see app/Http/Controllers/MedicoController.php:23
 * @route '/api/medicos'
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
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/medicos/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
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
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\MedicoController::show
 * @see app/Http/Controllers/MedicoController.php:59
 * @route '/api/medicos/{id}'
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
* @see \App\Http\Controllers\MedicoController::store
 * @see app/Http/Controllers/MedicoController.php:79
 * @route '/api/medicos'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/medicos',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\MedicoController::store
 * @see app/Http/Controllers/MedicoController.php:79
 * @route '/api/medicos'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\MedicoController::store
 * @see app/Http/Controllers/MedicoController.php:79
 * @route '/api/medicos'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\MedicoController::store
 * @see app/Http/Controllers/MedicoController.php:79
 * @route '/api/medicos'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\MedicoController::store
 * @see app/Http/Controllers/MedicoController.php:79
 * @route '/api/medicos'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\MedicoController::update
 * @see app/Http/Controllers/MedicoController.php:177
 * @route '/api/medicos/{id}'
 */
export const update = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/medicos/{id}',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\MedicoController::update
 * @see app/Http/Controllers/MedicoController.php:177
 * @route '/api/medicos/{id}'
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
* @see \App\Http\Controllers\MedicoController::update
 * @see app/Http/Controllers/MedicoController.php:177
 * @route '/api/medicos/{id}'
 */
update.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\MedicoController::update
 * @see app/Http/Controllers/MedicoController.php:177
 * @route '/api/medicos/{id}'
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
* @see \App\Http\Controllers\MedicoController::update
 * @see app/Http/Controllers/MedicoController.php:177
 * @route '/api/medicos/{id}'
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
* @see \App\Http\Controllers\MedicoController::inactivar
 * @see app/Http/Controllers/MedicoController.php:256
 * @route '/api/medicos/{id}/inactivar'
 */
export const inactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

inactivar.definition = {
    methods: ["put"],
    url: '/api/medicos/{id}/inactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\MedicoController::inactivar
 * @see app/Http/Controllers/MedicoController.php:256
 * @route '/api/medicos/{id}/inactivar'
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
* @see \App\Http\Controllers\MedicoController::inactivar
 * @see app/Http/Controllers/MedicoController.php:256
 * @route '/api/medicos/{id}/inactivar'
 */
inactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\MedicoController::inactivar
 * @see app/Http/Controllers/MedicoController.php:256
 * @route '/api/medicos/{id}/inactivar'
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
* @see \App\Http\Controllers\MedicoController::inactivar
 * @see app/Http/Controllers/MedicoController.php:256
 * @route '/api/medicos/{id}/inactivar'
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
* @see \App\Http\Controllers\MedicoController::reactivar
 * @see app/Http/Controllers/MedicoController.php:307
 * @route '/api/medicos/{id}/reactivar'
 */
export const reactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

reactivar.definition = {
    methods: ["put"],
    url: '/api/medicos/{id}/reactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\MedicoController::reactivar
 * @see app/Http/Controllers/MedicoController.php:307
 * @route '/api/medicos/{id}/reactivar'
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
* @see \App\Http\Controllers\MedicoController::reactivar
 * @see app/Http/Controllers/MedicoController.php:307
 * @route '/api/medicos/{id}/reactivar'
 */
reactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\MedicoController::reactivar
 * @see app/Http/Controllers/MedicoController.php:307
 * @route '/api/medicos/{id}/reactivar'
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
* @see \App\Http\Controllers\MedicoController::reactivar
 * @see app/Http/Controllers/MedicoController.php:307
 * @route '/api/medicos/{id}/reactivar'
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
const medicos = {
    index: Object.assign(index, index),
show: Object.assign(show, show),
store: Object.assign(store, store),
update: Object.assign(update, update),
inactivar: Object.assign(inactivar, inactivar),
reactivar: Object.assign(reactivar, reactivar),
especialidades: Object.assign(especialidades, especialidades),
horarios: Object.assign(horarios, horarios),
}

export default medicos