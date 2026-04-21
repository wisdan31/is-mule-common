%dw 2.0

// Builds error JSON from Mule's native error object (internal errors, APP:*, APIKIT:*, DB:*, etc.)
fun getErrorStructure(errorObj, customType) = {
    error: {
        errorType: customType 
            default ((errorObj.errorType.namespace default "UNKNOWN") 
                ++ ":" 
                ++ (errorObj.errorType.identifier default "UNKNOWN")),
        errorMessage: errorObj.description default "An unexpected error occurred",
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}

// Parses error JSON from an upstream HTTP response body (external API failures only)
fun getStructureFromPayload(payload, httpStatus) =
    // If the downstream service already returned our own error envelope, pass it through as-is
    if (payload.error is Object)
        payload
    // Otherwise normalize whatever the external API sent us
    else {
        error: {
            errorType: "HTTP:" ++ (httpStatus as String default "ERROR"),
            errorMessage: payload.message 
                default payload.errorMessage 
                default payload.error_description
                default "Upstream service returned an error",
            timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
        }
    }