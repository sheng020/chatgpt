package com.atom.base

import android.content.Context
import androidx.startup.Initializer

class BaseInitializer : Initializer<BaseInitializer> {

    //private lateinit var mDatabase: AppDatabase

    //fun getFavoriteDao() = mDatabase.favoriteDao()

    /*private fun initDatabase(context: Context) {
        mDatabase= Room.databaseBuilder(
            context,
            AppDatabase::class.java, "endi_native_db"
        ).build()
    }*/

    override fun create(context: Context): BaseInitializer {
        KeyValue.init(context)
        //HttpService.init()
        //initDatabase(context)
        return this
    }

    override fun dependencies(): MutableList<Class<out Initializer<*>>> {
        return mutableListOf()
    }
}