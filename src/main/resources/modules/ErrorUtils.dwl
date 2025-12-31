%dw 2.0

// This function takes the 'error' object and a custom type string
fun getErrorStructure(errorObj, customType) = {
    error: {
        // Uses the custom type if provided, otherwise tries to find it in the error object
        errorType: if (customType != null) customType 
                   else (errorObj.errorType.namespace ++ ":" ++ errorObj.errorType.identifier) default "UNKNOWN",
        
        errorMessage: errorObj.description default "Unknown Error Occurred",
        
        // Formats the timestamp exactly as requested
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}