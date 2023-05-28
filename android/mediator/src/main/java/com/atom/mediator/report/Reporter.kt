package com.atom.mediator.report

import android.content.Context

const val EVENT_ID = "eventId"
const val PARAMS = "params"

fun reportEvent(context: Context, eventId: String, params: Map<String, String>? = null) {
    /*val result: FlurryEventRecordStatus = if (params != null) {
        FlurryAgent.logEvent(eventId, params)
    } else {
        FlurryAgent.logEvent(eventId)
    }
    if (result == FlurryEventRecordStatus.kFlurryEventFailed) {
        var paramStr: String? = null
        if (params != null) {
            paramStr = Gson().toJson(params)
        }
        val dataBuilder =
            Data.Builder()
                .putString(EVENT_ID, eventId)

        if (paramStr != null) {
            dataBuilder.putString(PARAMS, paramStr)
        }
        val request = OneTimeWorkRequestBuilder<ReportWorker>()
            .setInitialDelay(1, TimeUnit.SECONDS)
            .setInputData(dataBuilder.build())
            .setBackoffCriteria(BackoffPolicy.EXPONENTIAL, 1, TimeUnit.MINUTES)
            .build()
        WorkManager.getInstance(context)
            .enqueue(request)
    }
    if (BuildConfig.DEBUG) {
        Log.d("cjslog", "logEvent:${eventId} result:${result?.name}")
    }*/
}

/*
@Keep
class ReportWorker(appContext: Context, workerParams: WorkerParameters) :
    Worker(appContext, workerParams) {
    override fun doWork(): Result {
        val eventId: String = inputData.getString(EVENT_ID)!!
        val paramStr = inputData.getString(PARAMS)

        val result: FlurryEventRecordStatus = if (paramStr != null) {
            val params = Gson().fromJson<Map<String, String>>(
                paramStr,
                TypeToken.getParameterized(
                    Map::class.java,
                    String::class.java,
                    String::class.java
                ).type
            )
            FlurryAgent.logEvent(eventId, params)
        } else {
            FlurryAgent.logEvent(eventId)
        }

        if (BuildConfig.DEBUG) {
            Log.d("cjslog", "logEvent worker:${eventId} result:${result.name}")
        }

        return if (result != FlurryEventRecordStatus.kFlurryEventRecorded) {
            Result.retry()
        } else {
            Result.success()
        }
    }

}*/
