#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

-keep class com.shockwave.**
-dontwarn com.gemalto.jp2.JP2Decoder

-keep class org.spongycastle.** { *; }
-dontwarn org.spongycastle.**

# When I remove this, java.security.cert.CertificateException: X.509 not found is thrown
-keep class org.bouncycastle.** { *; }
-keep interface org.bouncycastle.**

-keep class com.fasterxml.jackson.** { *; }

-dontwarn javax.naming.**
-dontwarn org.bouncycastle.**
-dontwarn org.conscrypt.**
-dontwarn org.openjsse.**
-dontwarn org.w3c.dom.bootstrap.**


-keep public class com.smartvist.idverify.* { public *;}
-keep public class com.smartvist.idverify.** {public *;}
-dontwarn com.smartvist.idverify.**

#for enverify
-keep public class com.enqura.enverify.* { public *;}
-keep public class com.enqura.enverify.** { public *;}
-dontwarn com.enqura.enverify.**

-keep class svt.webrtc.*{*;}
-keep class svt.webrtc.**{*;}
-dontwarn svt.webrtc.**

#for idverify nfc reading
-keep class net.sf.scuba.smartcards.IsoDepCardService {*;}
-keep public class net.sf.scuba.** {*;}
-keep public class org.bouncycastle** { public *;}

-keep class com.enqura.enqualifydemo.data.model.**{*;}

#for enverify backend requests
-keep class com.squareup.okhttp.** { *; }

#for swagger
-keep class io.swagger.client.model.** {*;}

#for secured shared preferences
-keep class com.facebook.crypto.** { *; }
-keep class com.facebook.jni.** { *; }
-keepclassmembers class com.facebook.cipher.jni.** { *; }
-dontwarn com.facebook.**

-keep class com.smartvist.idverify.** {*;}
-keep class com.enqura.enverify.**{*;}



-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface <1>

# Keep inherited services.
-if interface * { @retrofit2.http.* <methods>; }
-keep,allowobfuscation interface * extends <1>
#ParametrizedType ClassCastException error fix
-keep,allowobfuscation,allowshrinking interface retrofit2.Call
-keep,allowobfuscation,allowshrinking class retrofit2.Response
-keep,allowobfuscation,allowshrinking class kotlin.coroutines.** { *; }

##---------------Begin: proguard configuration for Gson  ----------
# Gson uses generic type information stored in a class file when working with fields. Proguard
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature

# For using GSON @Expose annotation
-keepattributes *Annotation*

# Gson specific classes
-dontwarn sun.misc.**
#-keep class com.google.gson.stream.** { *; }

# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.examples.android.model.** { <fields>; }

# Prevent proguard from stripping interface information from TypeAdapter, TypeAdapterFactory,
# JsonSerializer, JsonDeserializer instances (so they can be used in @JsonAdapter)
-keep class * extends com.google.gson.TypeAdapter
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Prevent R8 from leaving Data object members always null
-keepclassmembers,allowobfuscation class * {
  @com.google.gson.annotations.SerializedName <fields>;
}

# Retain generic signatures of TypeToken and its subclasses with R8 version 3.0 and higher.
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken

##---------------End: proguard configuration for Gson  ----------

-keep class org.threeten.bp.** { *; }

-keep class com.useinsider.insider.Insider.* { *; }

-keep interface com.useinsider.insider.InsiderCallback.* { *; }
-keep class com.useinsider.insider.InsiderUser.* { *; }
-keep class com.useinsider.insider.InsiderProduct.* { *; }
-keep class com.useinsider.insider.InsiderEvent.* { *; }
-keep class com.useinsider.insider.InsiderCallbackType.* { *; }
-keep class com.useinsider.insider.InsiderGender.* { *; }
-keep class com.useinsider.insider.InsiderIdentifiers.* { *; }

-keep interface com.useinsider.insider.RecommendationEngine$SmartRecommendation.* { *; }
-keep interface com.useinsider.insider.MessageCenterData.* { *; }
-keep class com.useinsider.insider.Geofence.* { *; }
-keep class com.useinsider.insider.ContentOptimizerDataType.* { *; }
-keep class org.openudid.** { *; }
-keep class com.useinsider.insider.OpenUDID_manager.* { *; }

# Prevent error on database
-keep class io.flutter.plugin.editing.** { *; }

# Prevent AppSearchBar error
-keep class androidx.core.graphics.drawable.** { *; }