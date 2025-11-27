package com.unluco.piapiri.enqualify.model

data class ConfigurationModel(
    val title: String,
    val apiServerUser: String,
    val domainName: String,
    val aiCertificateName: Array<String>,
    val backOfficeCertificateName: Array<String>,
    val aiUsername: String,
    val aiPassword: String,
    val signalServer: String,
    val stunServer: String,
    val turnServer: String,
    val turnServerUser: String,
    val turnServerKey: String,
    val apiServer: String,
    val msPrivateKey: String,
    val isMediaServerEnabled: Boolean
)
