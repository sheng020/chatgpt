package com.atom.base

import android.content.Context
import android.content.SharedPreferences

class KeyValue {

    companion object {

        private lateinit var application: Context

        fun init(context: Context) {
            application = context
        }

        inline fun <reified T : Any> put(
            key: String,
            value: T
        ) {


            val editor = defaultSharedPrefer()?.edit()
            when (T::class) {
                String::class -> {
                    editor?.putString(key, value as String)?.apply()
                }
                Int::class -> {
                    editor?.putInt(key, value as Int)?.apply()
                }
                Float::class -> {
                    editor?.putFloat(key, value as Float)?.apply()
                }
                Boolean::class -> {
                    editor?.putBoolean(key, value as Boolean)?.apply()
                }
                Long::class -> {
                    editor?.putLong(key, value as Long)?.apply()
                }
                else -> {
                    throw UnsupportedOperationException("unsupported value")
                }
            }
        }

        inline fun <reified T : Any> get(
            key: String,
            defaultValue: T
        ): T {

            val prefer = defaultSharedPrefer()
            when (T::class) {
                String::class -> {
                    return prefer?.getString(key, defaultValue as? String) as T
                }
                Int::class -> {
                    return prefer?.getInt(key, defaultValue as? Int ?: 0) as T
                }
                Float::class -> {
                    return prefer?.getFloat(key, defaultValue as? Float ?: 0f) as T
                }
                Boolean::class -> {
                    return prefer?.getBoolean(key, defaultValue as? Boolean ?: false) as T
                }
                Long::class -> {
                    return prefer?.getLong(key, defaultValue as? Long ?: 0L) as T
                }
            }
            return defaultValue
        }


        fun defaultSharedPrefer(): SharedPreferences? {
            if (::application.isInitialized) {
                return application.getSharedPreferences("default_key_value", Context.MODE_PRIVATE)
            }
            return null
        }

    }

}

