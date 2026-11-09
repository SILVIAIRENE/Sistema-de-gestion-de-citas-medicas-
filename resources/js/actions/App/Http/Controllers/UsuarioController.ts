import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/usuarios',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\UsuarioController::index
 * @see app/Http/Controllers/UsuarioController.php:25
 * @route '/api/usuarios'
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
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
 */
export const show = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})

show.definition = {
    methods: ["get","head"],
    url: '/api/usuarios/{id}',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
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
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
 */
show.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: show.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
 */
show.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: show.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
 */
    const showForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: show.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
 */
        showForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: show.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\UsuarioController::show
 * @see app/Http/Controllers/UsuarioController.php:68
 * @route '/api/usuarios/{id}'
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
* @see \App\Http\Controllers\UsuarioController::store
 * @see app/Http/Controllers/UsuarioController.php:92
 * @route '/api/usuarios'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/usuarios',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\UsuarioController::store
 * @see app/Http/Controllers/UsuarioController.php:92
 * @route '/api/usuarios'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\UsuarioController::store
 * @see app/Http/Controllers/UsuarioController.php:92
 * @route '/api/usuarios'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\UsuarioController::store
 * @see app/Http/Controllers/UsuarioController.php:92
 * @route '/api/usuarios'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\UsuarioController::store
 * @see app/Http/Controllers/UsuarioController.php:92
 * @route '/api/usuarios'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\UsuarioController::update
 * @see app/Http/Controllers/UsuarioController.php:180
 * @route '/api/usuarios/{id}'
 */
export const update = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

update.definition = {
    methods: ["put"],
    url: '/api/usuarios/{id}',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\UsuarioController::update
 * @see app/Http/Controllers/UsuarioController.php:180
 * @route '/api/usuarios/{id}'
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
* @see \App\Http\Controllers\UsuarioController::update
 * @see app/Http/Controllers/UsuarioController.php:180
 * @route '/api/usuarios/{id}'
 */
update.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: update.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\UsuarioController::update
 * @see app/Http/Controllers/UsuarioController.php:180
 * @route '/api/usuarios/{id}'
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
* @see \App\Http\Controllers\UsuarioController::update
 * @see app/Http/Controllers/UsuarioController.php:180
 * @route '/api/usuarios/{id}'
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
* @see \App\Http\Controllers\UsuarioController::cambiarRol
 * @see app/Http/Controllers/UsuarioController.php:273
 * @route '/api/usuarios/{id}/cambiar-rol'
 */
export const cambiarRol = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cambiarRol.url(args, options),
    method: 'put',
})

cambiarRol.definition = {
    methods: ["put"],
    url: '/api/usuarios/{id}/cambiar-rol',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\UsuarioController::cambiarRol
 * @see app/Http/Controllers/UsuarioController.php:273
 * @route '/api/usuarios/{id}/cambiar-rol'
 */
cambiarRol.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return cambiarRol.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\UsuarioController::cambiarRol
 * @see app/Http/Controllers/UsuarioController.php:273
 * @route '/api/usuarios/{id}/cambiar-rol'
 */
cambiarRol.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cambiarRol.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\UsuarioController::cambiarRol
 * @see app/Http/Controllers/UsuarioController.php:273
 * @route '/api/usuarios/{id}/cambiar-rol'
 */
    const cambiarRolForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: cambiarRol.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\UsuarioController::cambiarRol
 * @see app/Http/Controllers/UsuarioController.php:273
 * @route '/api/usuarios/{id}/cambiar-rol'
 */
        cambiarRolForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: cambiarRol.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    cambiarRol.form = cambiarRolForm
/**
* @see \App\Http\Controllers\UsuarioController::inactivar
 * @see app/Http/Controllers/UsuarioController.php:335
 * @route '/api/usuarios/{id}/inactivar'
 */
export const inactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

inactivar.definition = {
    methods: ["put"],
    url: '/api/usuarios/{id}/inactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\UsuarioController::inactivar
 * @see app/Http/Controllers/UsuarioController.php:335
 * @route '/api/usuarios/{id}/inactivar'
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
* @see \App\Http\Controllers\UsuarioController::inactivar
 * @see app/Http/Controllers/UsuarioController.php:335
 * @route '/api/usuarios/{id}/inactivar'
 */
inactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: inactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\UsuarioController::inactivar
 * @see app/Http/Controllers/UsuarioController.php:335
 * @route '/api/usuarios/{id}/inactivar'
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
* @see \App\Http\Controllers\UsuarioController::inactivar
 * @see app/Http/Controllers/UsuarioController.php:335
 * @route '/api/usuarios/{id}/inactivar'
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
* @see \App\Http\Controllers\UsuarioController::reactivar
 * @see app/Http/Controllers/UsuarioController.php:400
 * @route '/api/usuarios/{id}/reactivar'
 */
export const reactivar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

reactivar.definition = {
    methods: ["put"],
    url: '/api/usuarios/{id}/reactivar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\UsuarioController::reactivar
 * @see app/Http/Controllers/UsuarioController.php:400
 * @route '/api/usuarios/{id}/reactivar'
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
* @see \App\Http\Controllers\UsuarioController::reactivar
 * @see app/Http/Controllers/UsuarioController.php:400
 * @route '/api/usuarios/{id}/reactivar'
 */
reactivar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reactivar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\UsuarioController::reactivar
 * @see app/Http/Controllers/UsuarioController.php:400
 * @route '/api/usuarios/{id}/reactivar'
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
* @see \App\Http\Controllers\UsuarioController::reactivar
 * @see app/Http/Controllers/UsuarioController.php:400
 * @route '/api/usuarios/{id}/reactivar'
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
const UsuarioController = { index, show, store, update, cambiarRol, inactivar, reactivar }

export default UsuarioController