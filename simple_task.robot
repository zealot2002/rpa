*** Settings ***
Documentation     A simple RPA task.
...               This example demonstrates using Robot Framework for RPA.
Library           OperatingSystem

*** Tasks ***
Process Files In Directory
    ${files}=    List Files In Directory    ${CURDIR}
    FOR    ${file}    IN    @{files}
        Log    Found file: ${file}
    END
    Log    Process completed! 