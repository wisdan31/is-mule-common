%dw 2.0

// 1. Centralized Map for HTTP Status Codes
var statusMap = {
    "400": "HTTP:BAD_REQUEST",
    "404": "HTTP:NOT_FOUND",
    "401": "HTTP:UNAUTHORIZED",
    "403": "HTTP:FORBIDDEN",
    "500": "HTTP:INTERNAL_SERVER_ERROR",
    "503": "HTTP:SERVICE_UNAVAILABLE"
}

// 2. Existing function (Keep this for your APIKIT handlers)
fun getErrorStructure(errorObj, customType) = {
    error: {
        errorType: if (customType != null) customType 
                   else (errorObj.errorType.namespace ++ ":" ++ errorObj.errorType.identifier) default "UNKNOWN",
        errorMessage: errorObj.description default "Unknown Error Occurred",
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}

// 3. NEW function specifically for Backend/HTTP Payloads
fun getStructureFromPayload(payload, httpStatus) = {
    error: {
        // Logic moved here: Map the status code to a type
        errorType: statusMap[httpStatus as String] default ("HTTP:" ++ (httpStatus as String default "ERROR")),
        
        // Logic moved here: Find the message inside the payload
        errorMessage: payload.message 
                      default payload.error.errorMessage 
                      default payload as String 
                      default "Upstream Service Error",
                      
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}