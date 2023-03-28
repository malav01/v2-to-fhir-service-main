import ballerina/http;
// import wso2healthcare/healthcare.hl7;
import wso2healthcare/healthcare.hl7v23;
import ballerina/log;

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

    # service function to transform a v2 message to fhir
    # + return - transformed message as a json
    resource function post v2tofhir/transform(http:RequestContext ctx, http:Request request) returns json|error {
        // extract the payload from the request
        json hl7Message = check request.getJsonPayload();
        hl7v23:ADR_A19 clonedMessageRecord = check hl7Message.cloneWithType(hl7v23:ADR_A19);
        // transform the message to fhir
        json transformToFHIRResult = transformToFHIR(clonedMessageRecord);
        log:printInfo("Transformed FHIR message: " + transformToFHIRResult.toString());
        return transformToFHIRResult;
    }
}
