package com.atom.base

import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.content.res.Resources
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Insets
import android.graphics.Point
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.util.DisplayMetrics
import android.util.TypedValue
import android.view.Display
import android.view.Gravity
import android.view.Surface
import android.view.View
import android.view.Window
import android.view.WindowInsets
import android.view.WindowManager
import android.view.WindowMetrics
import android.widget.Toast
import androidx.annotation.StringRes
import androidx.core.view.ViewCompat
import com.atom.base.Constants.Companion.FRIENDS_LANGUAGE
import com.atom.base.Constants.Companion.PREFER_KEY_FLOATING_VISIBLE
import com.atom.base.Constants.Companion.IS_NEW_USER
import com.atom.base.Constants.Companion.OPEN_AD_IMPRESSION

fun isNewUser(): Boolean {
    return KeyValue.get(IS_NEW_USER, true)
}

fun markAsRegularUser() {
    KeyValue.put(IS_NEW_USER, false)
}
fun isFloatingCheckEnable(): Boolean {
    return KeyValue.get(PREFER_KEY_FLOATING_VISIBLE, false)
}

fun getSourceLanguage(): String {
    return KeyValue.get(Constants.SOURCE_LANGUAGE, "en")
}

fun getTargetLanguage(): String {
    return KeyValue.get(Constants.TARGET_LANGUAGE, "hi")
}

fun getFriendsLanguage(): String {
    return KeyValue.get(FRIENDS_LANGUAGE, "en")
}

fun setFriendsLanguage(language: String) {
    KeyValue.put(FRIENDS_LANGUAGE, language)
}

fun Context.clipboard(label: CharSequence, text: CharSequence) {
    //enabledClipboard(delayed = 3000)

    try {
        val newLabel = "${packageName}_$label"
        val cm = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clipData = ClipData.newPlainText(newLabel, text)
        cm.setPrimaryClip(clipData)
    } catch (e: java.lang.Exception) {
        e.printStackTrace()
    }

}

fun Context.showToast(@StringRes resId: Int, duration: Int = Toast.LENGTH_SHORT) {
    val toast = Toast.makeText(applicationContext, resId, Toast.LENGTH_SHORT)
    toast.setGravity(Gravity.BOTTOM, 0, 0)
    toast.show()
}

fun Context.startGooglePlay(uri: Uri): Boolean {
    val intent = Intent(Intent.ACTION_VIEW, uri)
    intent.setPackage("com.android.vending")
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    return if (intent.resolveActivity(packageManager) != null) {
        startActivity(intent)
        true
    } else {
        false
    }

}

/**
 * @param isLight true表示通知栏上面到时间等字体的颜色是灰色的， false表示颜色是白色的。
 * @param fitSystemWindow true表示布局可以绘制到状态栏顶部， 状态栏和布局是重叠到。
 */
fun Activity.setDarkStatusBar(isLight: Boolean, fitSystemWindow: Boolean = true) {
    val window: Window = window ?: return
    val decorView: View = window.decorView

    //通知栏布局
    if (!fitSystemWindow) {
        window.clearFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS)
        decorView.systemUiVisibility =
            (View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN.or(View.SYSTEM_UI_FLAG_LAYOUT_STABLE))
        window.addFlags(WindowManager.LayoutParams.FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS)
        window.statusBarColor = Color.TRANSPARENT
    }

    //通知栏字体颜色
    ViewCompat.getWindowInsetsController(decorView)?.let { controller ->
        controller.isAppearanceLightStatusBars = isLight
    }
        ?: kotlin.run {
            if (isLight && Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val systemUiVisibility = window.decorView.systemUiVisibility
                window.decorView.systemUiVisibility =
                    systemUiVisibility.or(View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
            }
        }
}

fun Context.isDarkTheme(): Boolean {
    val flag = resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
    return flag == Configuration.UI_MODE_NIGHT_YES
}

fun Context.dim(redId: Int) = resources.getDimensionPixelOffset(redId).toFloat()

fun Context.statusBarHeight(): Int {
    val id = resources.getIdentifier("status_bar_height", "dimen", "android")
    return resources.getDimension(id).toInt()
}

fun Context.getDefaultLauncherPkg(): String? {
    return try {
        val intent = Intent(Intent.ACTION_MAIN)
        intent.addCategory(Intent.CATEGORY_HOME)
        val resolveInfo = packageManager.resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY)
        val defaultLauncherPackageName = resolveInfo?.activityInfo?.packageName
        //Log.v("cjslog", "defaultLauncherPackageName:$defaultLauncherPackageName")
        defaultLauncherPackageName
    } catch (e: Exception) {
        null
    }
}

fun Context.isLandscape(): Boolean {
    val wm = getSystemService(Context.WINDOW_SERVICE) as WindowManager
//    return wm.defaultDisplay.rotation % 2 != 0
    val rotation = wm.defaultDisplay.rotation
    return (rotation == Surface.ROTATION_90 || rotation == Surface.ROTATION_270)
}

fun drawableToBitmap(drawable: Drawable?): Bitmap? {
    if (null == drawable) {
        return null
    }
    val bitmap: Bitmap = Bitmap.createBitmap(
        drawable.intrinsicWidth,
        drawable.intrinsicHeight,
        Bitmap.Config.ARGB_8888
    )
    val canvas = Canvas(bitmap)
    drawable.setBounds(0, 0, canvas.width, canvas.height)
    drawable.draw(canvas)
    return bitmap
}

fun Context.getScreenWidth(): Int {
    val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager

    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        val windowMetrics: WindowMetrics = windowManager.currentWindowMetrics
        val insets: Insets = windowMetrics.windowInsets
            .getInsetsIgnoringVisibility(WindowInsets.Type.systemBars())
        windowMetrics.bounds.width() - insets.left - insets.right
    } else {
        val displayMetrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(displayMetrics)
        displayMetrics.widthPixels
    }
}

fun Context.getScreenHeight(): Int {
    val windowManager = getSystemService(Context.WINDOW_SERVICE) as WindowManager
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        val windowMetrics: WindowMetrics = windowManager.currentWindowMetrics
        val insets: Insets = windowMetrics.windowInsets
            .getInsetsIgnoringVisibility(WindowInsets.Type.systemBars())
        windowMetrics.bounds.height() - insets.top - insets.bottom
    } else {
        val displayMetrics = DisplayMetrics()
        windowManager.defaultDisplay.getMetrics(displayMetrics)
        displayMetrics.heightPixels
    }
}

fun Activity.getScreenRealHeight(): Int {

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
        val rect = windowManager.currentWindowMetrics.bounds
        return rect.height()
    }

    val display: Display = windowManager.defaultDisplay
    val realSize = Point()
    display.getRealSize(realSize)
    return realSize.y
}

fun Context.px2dp(px: Int): Float = px / resources.displayMetrics.density + 0.5f

fun dp2px(dp: Int): Int {
    return TypedValue.applyDimension(
        TypedValue.COMPLEX_UNIT_DIP,
        dp.toFloat(),
        Resources.getSystem().displayMetrics
    ).toInt()
}

fun Context.isLauncher(packageName: CharSequence?): Boolean {
    val pkg = packageName ?: return false
    return applicationContext.getDefaultLauncherPkg() == pkg.toString()
}

fun Context.isBrowser(packageName: String?): Boolean {
    val pkg = packageName ?: return false
    return try {
        val pm = packageManager
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.google.com"))
        intent.setPackage(pkg)
        val resolveInfos = pm.queryIntentActivities(intent, 0)
        resolveInfos.isNotEmpty()
    } catch (e: Exception) {
        e.printStackTrace()
        false
    }
}