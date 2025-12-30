%dw 2.0
output application/json
---
{
    error: {
        "errorType": vars.errorType default "UNKNOWN_ERROR",
        "errorMessage": vars.errorMessage default "An unexpected error occurred",
        "timestamp": now() as String {format: "yyyy-MM-dd'T'HH:mm:ss"}
    }
}