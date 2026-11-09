import { queryParams, type RouteQueryOptions, type RouteDefinition, type RouteFormDefinition, applyUrlDefaults } from './../../../../wayfinder'
/**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
export const historialCitas = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: historialCitas.url(args, options),
    method: 'get',
})

historialCitas.definition = {
    methods: ["get","head"],
    url: '/api/pacientes/{id}/historial-citas',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
historialCitas.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return historialCitas.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
historialCitas.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: historialCitas.url(args, options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
historialCitas.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: historialCitas.url(args, options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
    const historialCitasForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: historialCitas.url(args, options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
        historialCitasForm.get = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: historialCitas.url(args, options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\CitaController::historialCitas
 * @see app/Http/Controllers/CitaController.php:94
 * @route '/api/pacientes/{id}/historial-citas'
 */
        historialCitasForm.head = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: historialCitas.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    historialCitas.form = historialCitasForm
/**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
export const index = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})

index.definition = {
    methods: ["get","head"],
    url: '/api/citas',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
index.url = (options?: RouteQueryOptions) => {
    return index.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
index.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: index.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
index.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: index.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
    const indexForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: index.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
 */
        indexForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: index.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\CitaController::index
 * @see app/Http/Controllers/CitaController.php:28
 * @route '/api/citas'
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
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
export const disponibilidad = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: disponibilidad.url(options),
    method: 'get',
})

disponibilidad.definition = {
    methods: ["get","head"],
    url: '/api/citas/disponibilidad',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
disponibilidad.url = (options?: RouteQueryOptions) => {
    return disponibilidad.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
disponibilidad.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: disponibilidad.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
disponibilidad.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: disponibilidad.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
    const disponibilidadForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: disponibilidad.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
        disponibilidadForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: disponibilidad.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\CitaController::disponibilidad
 * @see app/Http/Controllers/CitaController.php:601
 * @route '/api/citas/disponibilidad'
 */
        disponibilidadForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: disponibilidad.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    disponibilidad.form = disponibilidadForm
/**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
export const proximoLibre = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: proximoLibre.url(options),
    method: 'get',
})

proximoLibre.definition = {
    methods: ["get","head"],
    url: '/api/citas/proximo-libre',
} satisfies RouteDefinition<["get","head"]>

/**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
proximoLibre.url = (options?: RouteQueryOptions) => {
    return proximoLibre.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
proximoLibre.get = (options?: RouteQueryOptions): RouteDefinition<'get'> => ({
    url: proximoLibre.url(options),
    method: 'get',
})
/**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
proximoLibre.head = (options?: RouteQueryOptions): RouteDefinition<'head'> => ({
    url: proximoLibre.url(options),
    method: 'head',
})

    /**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
    const proximoLibreForm = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
        action: proximoLibre.url(options),
        method: 'get',
    })

            /**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
        proximoLibreForm.get = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: proximoLibre.url(options),
            method: 'get',
        })
            /**
* @see \App\Http\Controllers\CitaController::proximoLibre
 * @see app/Http/Controllers/CitaController.php:812
 * @route '/api/citas/proximo-libre'
 */
        proximoLibreForm.head = (options?: RouteQueryOptions): RouteFormDefinition<'get'> => ({
            action: proximoLibre.url({
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'HEAD',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'get',
        })
    
    proximoLibre.form = proximoLibreForm
/**
* @see \App\Http\Controllers\CitaController::store
 * @see app/Http/Controllers/CitaController.php:152
 * @route '/api/citas'
 */
export const store = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

store.definition = {
    methods: ["post"],
    url: '/api/citas',
} satisfies RouteDefinition<["post"]>

/**
* @see \App\Http\Controllers\CitaController::store
 * @see app/Http/Controllers/CitaController.php:152
 * @route '/api/citas'
 */
store.url = (options?: RouteQueryOptions) => {
    return store.definition.url + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::store
 * @see app/Http/Controllers/CitaController.php:152
 * @route '/api/citas'
 */
store.post = (options?: RouteQueryOptions): RouteDefinition<'post'> => ({
    url: store.url(options),
    method: 'post',
})

    /**
* @see \App\Http\Controllers\CitaController::store
 * @see app/Http/Controllers/CitaController.php:152
 * @route '/api/citas'
 */
    const storeForm = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: store.url(options),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\CitaController::store
 * @see app/Http/Controllers/CitaController.php:152
 * @route '/api/citas'
 */
        storeForm.post = (options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: store.url(options),
            method: 'post',
        })
    
    store.form = storeForm
/**
* @see \App\Http\Controllers\CitaController::reprogramar
 * @see app/Http/Controllers/CitaController.php:371
 * @route '/api/citas/{id}/reprogramar'
 */
export const reprogramar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reprogramar.url(args, options),
    method: 'put',
})

reprogramar.definition = {
    methods: ["put"],
    url: '/api/citas/{id}/reprogramar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\CitaController::reprogramar
 * @see app/Http/Controllers/CitaController.php:371
 * @route '/api/citas/{id}/reprogramar'
 */
reprogramar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return reprogramar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::reprogramar
 * @see app/Http/Controllers/CitaController.php:371
 * @route '/api/citas/{id}/reprogramar'
 */
reprogramar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: reprogramar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\CitaController::reprogramar
 * @see app/Http/Controllers/CitaController.php:371
 * @route '/api/citas/{id}/reprogramar'
 */
    const reprogramarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: reprogramar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\CitaController::reprogramar
 * @see app/Http/Controllers/CitaController.php:371
 * @route '/api/citas/{id}/reprogramar'
 */
        reprogramarForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: reprogramar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    reprogramar.form = reprogramarForm
/**
* @see \App\Http\Controllers\CitaController::cancelar
 * @see app/Http/Controllers/CitaController.php:460
 * @route '/api/citas/{id}/cancelar'
 */
export const cancelar = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cancelar.url(args, options),
    method: 'put',
})

cancelar.definition = {
    methods: ["put"],
    url: '/api/citas/{id}/cancelar',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\CitaController::cancelar
 * @see app/Http/Controllers/CitaController.php:460
 * @route '/api/citas/{id}/cancelar'
 */
cancelar.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return cancelar.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::cancelar
 * @see app/Http/Controllers/CitaController.php:460
 * @route '/api/citas/{id}/cancelar'
 */
cancelar.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cancelar.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\CitaController::cancelar
 * @see app/Http/Controllers/CitaController.php:460
 * @route '/api/citas/{id}/cancelar'
 */
    const cancelarForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: cancelar.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\CitaController::cancelar
 * @see app/Http/Controllers/CitaController.php:460
 * @route '/api/citas/{id}/cancelar'
 */
        cancelarForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: cancelar.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    cancelar.form = cancelarForm
/**
* @see \App\Http\Controllers\CitaController::registrarAtencion
 * @see app/Http/Controllers/CitaController.php:536
 * @route '/api/citas/{id}/atender'
 */
export const registrarAtencion = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: registrarAtencion.url(args, options),
    method: 'put',
})

registrarAtencion.definition = {
    methods: ["put"],
    url: '/api/citas/{id}/atender',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\CitaController::registrarAtencion
 * @see app/Http/Controllers/CitaController.php:536
 * @route '/api/citas/{id}/atender'
 */
registrarAtencion.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return registrarAtencion.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::registrarAtencion
 * @see app/Http/Controllers/CitaController.php:536
 * @route '/api/citas/{id}/atender'
 */
registrarAtencion.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: registrarAtencion.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\CitaController::registrarAtencion
 * @see app/Http/Controllers/CitaController.php:536
 * @route '/api/citas/{id}/atender'
 */
    const registrarAtencionForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: registrarAtencion.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\CitaController::registrarAtencion
 * @see app/Http/Controllers/CitaController.php:536
 * @route '/api/citas/{id}/atender'
 */
        registrarAtencionForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: registrarAtencion.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    registrarAtencion.form = registrarAtencionForm
/**
* @see \App\Http\Controllers\CitaController::cambiarEstado
 * @see app/Http/Controllers/CitaController.php:847
 * @route '/api/citas/{id}/estado'
 */
export const cambiarEstado = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cambiarEstado.url(args, options),
    method: 'put',
})

cambiarEstado.definition = {
    methods: ["put"],
    url: '/api/citas/{id}/estado',
} satisfies RouteDefinition<["put"]>

/**
* @see \App\Http\Controllers\CitaController::cambiarEstado
 * @see app/Http/Controllers/CitaController.php:847
 * @route '/api/citas/{id}/estado'
 */
cambiarEstado.url = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions) => {
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

    return cambiarEstado.definition.url
            .replace('{id}', parsedArgs.id.toString())
            .replace(/\/+$/, '') + queryParams(options)
}

/**
* @see \App\Http\Controllers\CitaController::cambiarEstado
 * @see app/Http/Controllers/CitaController.php:847
 * @route '/api/citas/{id}/estado'
 */
cambiarEstado.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteDefinition<'put'> => ({
    url: cambiarEstado.url(args, options),
    method: 'put',
})

    /**
* @see \App\Http\Controllers\CitaController::cambiarEstado
 * @see app/Http/Controllers/CitaController.php:847
 * @route '/api/citas/{id}/estado'
 */
    const cambiarEstadoForm = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
        action: cambiarEstado.url(args, {
                    [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                        _method: 'PUT',
                        ...(options?.query ?? options?.mergeQuery ?? {}),
                    }
                }),
        method: 'post',
    })

            /**
* @see \App\Http\Controllers\CitaController::cambiarEstado
 * @see app/Http/Controllers/CitaController.php:847
 * @route '/api/citas/{id}/estado'
 */
        cambiarEstadoForm.put = (args: { id: string | number } | [id: string | number ] | string | number, options?: RouteQueryOptions): RouteFormDefinition<'post'> => ({
            action: cambiarEstado.url(args, {
                        [options?.mergeQuery ? 'mergeQuery' : 'query']: {
                            _method: 'PUT',
                            ...(options?.query ?? options?.mergeQuery ?? {}),
                        }
                    }),
            method: 'post',
        })
    
    cambiarEstado.form = cambiarEstadoForm
const CitaController = { historialCitas, index, disponibilidad, proximoLibre, store, reprogramar, cancelar, registrarAtencion, cambiarEstado }

export default CitaController