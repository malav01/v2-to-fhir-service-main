import wso2healthcare/healthcare.hl7v23;
import wso2healthcare/healthcare.fhir.r4;
import wso2healthcare/healthcare.hl7;

public function transformToFHIR(hl7:Message message) returns json {
    if message is hl7v23:ADR_A19 {
        // This utility function is used to convert ADR_A19 message into FHIR Patient resources. This has pre-build mapping done from the
        // Implementation guide: https://build.fhir.org/ig/HL7/v2-to-fhir/branches/master/index.html.
        // In upcoming releases these utility functions will be provided as inbuilt mapping functions by WSO2 Healthcare Accelerator packages.
        return ADR_A19ToPatient(message);
    } else if message is hl7v23:ADT_A01 {
        return ADT_A01ToPatient(message);
    }
}

function ADT_A01ToPatient(hl7v23:ADT_A01 adtA01) returns r4:Patient => {

    name: GetHL7_PID_PatientName(adtA01.pid.pid5, adtA01.pid.pid9), 
    birthDate: adtA01.pid.pid7.ts1, 
    gender: GetHL7_PID_AdministrativeSex(adtA01.pid.pid8), 
    address: GetHL7_PID_Address(adtA01.pid.pid12, adtA01.pid.pid11), 
    telecom: GetHL7_PID_PhoneNumber(adtA01.pid.pid13, adtA01.pid.pid14), 
    communication: GetHL7_PID_PrimaryLanguage(adtA01.pid.pid15), 
    maritalStatus: {
        coding: GetHL7_PID_MaritalStatus(adtA01.pid.pid16) 
    },
    identifier: GetHL7_PID_SSNNumberPatient(adtA01.pid.pid19), 
    extension: GetHL7_PID_BirthPlace(adtA01.pid.pid23), 
    multipleBirthBoolean: GetHL7_PID_MultipleBirthIndicator(adtA01.pid.pid24), 
    multipleBirthInteger: GetHL7_PID_BirthOrder(adtA01.pid.pid25), 
    deceasedDateTime: adtA01.pid.pid29.ts1, 
    deceasedBoolean: GetHL7_PID_PatientDeathIndicator(adtA01.pid.pid30) 
};

function ADR_A19ToPatient(hl7v23:ADR_A19 adrA19) returns r4:Patient[] {

    hl7v23:QUERY_RESPONSE[] queryResponses = adrA19.query_response;
    r4:Patient[] patientArr = [];
    foreach hl7v23:QUERY_RESPONSE queryResponse in queryResponses {
        if queryResponse.pid is hl7v23:PID {
            r4:Patient patient = PIDToPatient(<hl7v23:PID>queryResponse.pid);
            patientArr.push(patient);
        }
    }
    return patientArr;
}

function PIDToPatient(hl7v23:PID pid) returns r4:Patient => {
    
    name: GetHL7_PID_PatientName(pid.pid5, pid.pid9),
    birthDate: pid.pid7.ts1,
    gender: GetHL7_PID_AdministrativeSex(pid.pid8),
    address: GetHL7_PID_Address(pid.pid12, pid.pid11),
    telecom: GetHL7_PID_PhoneNumber(pid.pid13, pid.pid14),
    communication: GetHL7_PID_PrimaryLanguage(pid.pid15),
    maritalStatus: {
        coding: GetHL7_PID_MaritalStatus(pid.pid16)
    },
    identifier: GetHL7_PID_SSNNumberPatient(pid.pid19),
    extension: GetHL7_PID_BirthPlace(pid.pid23),
    multipleBirthBoolean: GetHL7_PID_MultipleBirthIndicator(pid.pid24),
    multipleBirthInteger: GetHL7_PID_BirthOrder(pid.pid25),
    deceasedDateTime: pid.pid29.ts1,
    deceasedBoolean: GetHL7_PID_PatientDeathIndicator(pid.pid30)
};
