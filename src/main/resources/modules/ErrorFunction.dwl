%dw 2.0

// Update inputs to accept String OR Null
fun buildError(eType: String | Null, eMsg: String | Null) = {
  error: {
    // If eType is null, default to "UNKNOWN"
    errorType: eType default "UNKNOWN:ERROR", 
    
    // If eMsg is null, default to a generic message
    errorMessage: eMsg default "An unexpected error occurred",
    
    timestamp: now() as String {format: "yyyy-MM-dd'T'HH:mm:ss"}
  }
}