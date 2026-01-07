%dw 2.0

// Function 1: CREATES error JSON 
fun getErrorStructure(errorObj, customType) = {
    error: {
        errorType: if (customType != null) customType 
                   else (errorObj.errorType.namespace ++ ":" ++ errorObj.errorType.identifier) default "UNKNOWN",
        errorMessage: errorObj.description default "Unknown Error Occurred",
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}

// Function 2: READS error JSON from payload 
fun getStructureFromPayload(payload, httpStatus) = {
    error: {
        errorType: if ((payload is Object) and (payload.error.errorType != null)) 
                       payload.error.errorType 
                   else 
                       ("HTTP:" ++ (httpStatus as String default "ERROR")),
       
        errorMessage: if ((payload is Object) and (payload.error.errorMessage != null)) 
                          payload.error.errorMessage
                      else if ((payload is Object) and (payload.message != null)) 
                          payload.message
                      else 
                          (payload as String default "Upstream Service Error"),
                      
        timestamp: now() as String { format: "yyyy-MM-dd'T'HH:mm:ss" }
    }
}