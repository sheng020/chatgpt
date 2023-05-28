package com.atom.mediator

object MediatorService {

    private val serviceMap = HashMap<Class<out IService>, IService>()

    fun <T : IService> register(clz: Class<out T>, t: T) {
        serviceMap[clz] = t
    }

    fun <T : IService> getService(clz: Class<T>): T {
        return serviceMap[clz] as T
    }

    fun <T : IService> containService(clz: Class<T>): Boolean {
        return serviceMap.containsKey(clz)
    }
}