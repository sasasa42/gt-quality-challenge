*** Settings ***
Library    OperatingSystem
Library    RequestsLibrary
Library    SeleniumLibrary
Library    FakerLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    DateTime
Library    utility.py
Resource    locators.robot

*** Variables ***
${url}    http://localhost:8080
${insSglEndpoint}    ${url}/calculator/insert
${insMultplEndpoint}    ${url}/calculator/insertMultiple
${browser}    chrome
${i}    0
${getTaxReliefEndpoint}    ${url}/calculator/taxRelief
${age18Max}    1
${age35Max}    0.8
${age50Max}    0.5
${age75Max}    0.367
${age76Min}    0.05
${genderMBonus}    0
${genderFBonus}    500
${rakeDBEndpoint}    ${url}/calculator/rakeDatabase

*** Keywords ***

Set Up
   Set Selenium Implicit Wait    5
   Set Selenium Timeout    15

I setup a list of incorrect data 
    ${capsBirthday}=    Create Dictionary    Birthday=01011990    gender=m    name=test    natid=12345678    salary=123456    tax=1234
    ${noBirthday}=    Create Dictionary    gender=m    name=test    natid=12345678    salary=123456    tax=1234
    ${invalidMonth}=    Create Dictionary    birthday=12312022    gender=m    name=test    natid=habidjwqed    salary=761281912    tax=123332
    ${noZeroDay}=    Create Dictionary    birthday=1122000    gender=m    name=test    natid=habidjwqed    salary=761281912    tax=123332
    ${incorrectList}=    Create List    ${capsBirthday}    ${noBirthday}    ${invalidMonth}    ${noZeroDay}
    Set Global Variable    ${incorrectList}

I setup a list of breaking data
    ${capsGender}=    Create Dictionary    birthday=01011990    Gender=m    name=test    natid=12345678    salary=123456    tax=1234
    ${breakingList}=    Create List    ${capsGender}
    Set Global Variable    ${breakingList}

I generate some correct data
    ${birthday1}    Date    %d%m%Y
    ${birthday2}    Date    %d%m%Y
    ${birthday3}    Date    %d%m%Y
    ${birthday4}    Date    %d%m%Y
    ${birthday5}    Date    %d%m%Y
    
    ${gender1}    Random Element    ('m', 'f' , 'M', 'F')
    ${gender2}    Random Element    ('m', 'f' , 'M', 'F')
    ${gender3}    Random Element    ('m', 'f' , 'M', 'F')
    ${gender4}    Random Element    ('m', 'f' , 'M', 'F')
    ${gender5}    Random Element    ('m', 'f' , 'M', 'F')

    ${name1}    Name
    ${name2}    Name
    ${name3}    Name
    ${name4}    Name
    ${name5}    Name

    ${natid1}    Random Number    8    True
    ${natid2}    Random Number    8    True
    ${natid3}    Random Number    8    True
    ${natid4}    Random Number    8    True
    ${natid5}    Random Number    8    True

    ${salary1}    Random Int    500    100000000
    ${salary2}    Random Int    500    100000000
    ${salary3}    Random Int    500    100000000
    ${salary4}    Random Int    500    100000000
    ${salary5}    Random Int    500    100000000

    ${tax1}    Pyfloat    1    5    True    max_value=9
    ${tax2}    Pyfloat    2    4    True    max_value=99
    ${tax3}    Pyfloat    3    4    True    max_value=999
    ${tax4}    Pyfloat    4    5    True    max_value=9999
    ${tax5}    Pyfloat    5    1    True    max_value=99999
    
    ${genCrctData1}=    Create Dictionary    birthday=${birthday1}    gender=${gender1}    name=${name1}    natid=${natid1}    salary=${salary1}    tax=${tax1}
    ${genCrctData2}=    Create Dictionary    birthday=${birthday2}    gender=${gender2}    name=${name2}    natid=${natid2}    salary=${salary2}    tax=${tax2}
    ${genCrctData3}=    Create Dictionary    birthday=${birthday3}    gender=${gender3}    name=${name3}    natid=${natid3}    salary=${salary3}    tax=${tax3}
    ${genCrctData4}=    Create Dictionary    birthday=${birthday4}    gender=${gender4}    name=${name4}    natid=${natid4}    salary=${salary4}    tax=${tax4}
    ${genCrctData5}=    Create Dictionary    birthday=${birthday5}    gender=${gender5}    name=${name5}    natid=${natid5}    salary=${salary5}    tax=${tax5}
    ${genCrctList}=    Create List    ${genCrctData1}    ${genCrctData2}    ${genCrctData3}    ${genCrctData4}    ${genCrctData5}
    Set Global Variable    ${genCrctList}

I setup a list of correct data
    ${correctData1}=    Create Dictionary    birthday=01011990    gender=m    name=test    natid=12345678    salary=5362728.242    tax=25363.253
    ${correctData2}=    Create Dictionary    birthday=12011990    gender=f    name=test    natid=54253782    salary=2626738.2563    tax=2536.3273
    ${correctData3}=    Create Dictionary    birthday=31122000    gender=m    name=test    natid=habidjwqed    salary=2828.3533    tax=12.2533
    ${correctData4}=    Create Dictionary    birthday=31122000    gender=m    name=test    natid=jhbweif7    salary=4    tax=0
    ${correctData5}=    Create Dictionary    birthday=01072004    gender=m    name=test    natid=2345f3    salary=276346.242    tax=1233.3
    ${correctList}=    Create List    ${correctData1}    ${correctData2}    ${correctData3}    ${correctData4}    ${correctData5}
    Set Global Variable    ${correctList}

I try to insert the single records
    [Arguments]    ${dataList}
    Create Session    singleInsert    ${insSglEndpoint}
    FOR    ${jsonData}    IN    @{dataList}
        Run Keyword And Continue On Failure    Post On Session    singleInsert    ${insSglEndpoint}    json=${jsonData}
    END

I try to insert the record through json file
    [Arguments]    ${endpoint}    ${fileName}
    Create Session    jsonFileInsert    ${endpoint}
    ${jsonData}=    Load JSON From File    ${fileName}
    Run Keyword And Continue On Failure    Post On Session    jsonFileInsert    ${endpoint}    json=${jsonData}

I try to insert multiple records in one request
    [Arguments]    ${dataList}
    Create Session    multipleInsert    ${insMultplEndpoint}
    Run Keyword And Continue On Failure    Post On Session    multipleInsert    ${insMultplEndpoint}    json=@{dataList}

I go to the portal
    Open Browser    ${url}   ${browser}
    Maximize Browser Window

I upload the csv file
    Choose File    ${file-input}    ${CURDIR}/workingHeroes.csv
    Click Element    ${btn-refresh-tax-relief}

the first row of the csv is a header
    ${csv}=    Get File    ${CURDIR}/workingHeroes.csv
    @{read}=    Create List    ${csv}
    @{lines}=    Split To Lines    @{read}
    @{headers}=    Split String    ${lines}[0]    ,
    Sort List    ${headers}
    ${length}=    Get Length    ${headers}
    Should Be Equal As Integers    ${length}    6
    @{expectedHeaders}=    Create List    birthday    gender    name    natid    salary    tax
    Set Test Variable    ${i}    0
    FOR    ${header}    IN    @{headers}
        Should Be Equal As Strings    ${header}    ${expectedHeaders}[${i}]
        ${i}=    Evaluate    ${i}+1
    END

I verify the subsequent details
    ${csv}=    Get File    ${CURDIR}/workingHeroes.csv
    @{read}=    Create List    ${csv}
    @{lines}=    Split To Lines    @{read}
    ${lineLength}=    Get Length    ${lines}
    Should Be True    ${lineLength} > 1
    @{headers}=    Split String    ${lines}[0]    ,
    ${headerLength}=    Get Length    ${headers}
    Should Be Equal As Integers    ${headerLength}    6
    Set Test Variable    ${i}    0
    ${pairValues}=    Create Dictionary
    FOR    ${lineIndex}    IN RANGE    1    ${lineLength}
        @{values}=     Split String    ${lines}[${lineIndex}]    ,
        FOR    ${headerIndex}    IN RANGE    0    ${headerLength}
        Set To Dictionary    ${pairValues}    ${headers}[${headerIndex}]=${values}[${headerIndex}]
        END
        Log    ${pairValues}
        ${birthdayValue}=    Get From Dictionary    ${pairValues}    birthday
        Should Match Regexp    ${birthdayValue}    ^(0[1-9]|[12][0-9]|3[01])(0[1-9]|1[0-2])\\d{4}$
        ${genderValue}=    Get From Dictionary    ${pairValues}    gender
        Should Match Regexp    ${genderValue}    ^(?:m|M|f|F)$
        ${nameValue}=    Get From Dictionary    ${pairValues}    name
        ${natidValue}=    Get From Dictionary    ${pairValues}    natid
        Should Match Regexp    ${natidValue}    ^.{4,}$
        ${salaryValue}=    Get From Dictionary    ${pairValues}    salary
        ${taxValue}=    Get From Dictionary    ${pairValues}    tax
    END
    
# 4 AC1 and AC2
I hit the get endpoint to fetch the taxrelief
    ${reliefValues}=    Create Dictionary
    ${systemRounded}=    Create Dictionary
    Create Session    getTaxRelief    ${getTaxReliefEndpoint}
    ${response}=    Get On Session    getTaxRelief    ${getTaxReliefEndpoint}
    @{listHeroes}=    Copy List    ${response.json()}
    ${lengthList}=    Get Length    ${listHeroes}
    FOR    ${element}    IN    @{listHeroes}
    # Check masking afer 4 characs
        ${natidValue}=    Get From Dictionary    ${element}    natid
        ${firstFour}=    Get Substring    ${natidValue}    0    4
        ${exceptFirstFour}=    Get Substring    ${natidValue}    4
        ${replaceLastChars}=    Replace String    ${exceptFirstFour}    $    $
        ${joinChars}=       Catenate    SEPARATOR=  ${firstFour}   ${replaceLastChars}
        Should Be Equal As Strings    ${natidValue}    ${joinChars}
        ${nameValue}=    Get From Dictionary    ${element}    name
        ${reliefValue}=    Get From Dictionary    ${element}    relief
        Set To Dictionary    ${reliefValues}    ${natidValue}=${reliefValue}
        Set Global Variable    ${reliefValues}
    END
        
I rake the DB
    Create Session    rakeDB    ${rakeDBEndpoint}
    Run Keyword And Continue On Failure    Post On Session    rakeDB    ${rakeDBEndpoint}

# 4 AC3 and 4 AC5
I calculate the relief
    ${calculatedReliefs}=    Create Dictionary
    ${normalRoundedCalculated}=    Create Dictionary
    # NOTE: Switch between ${genCrctList} and ${correctList} as per requirement(generated or hardcoded)
    FOR    ${element}    IN    @{genCrctList}
        ${birthdayValue}=    Get From Dictionary   ${element}    birthday
        ${genderValue}=    Get From Dictionary    ${element}    gender
        ${natidValue}=    Get From Dictionary    ${element}    natid
        ${natidValue}=     Convert To String    ${natidValue}
        ${salaryValue}=    Get From Dictionary    ${element}    salary
        ${taxValue}=    Get From Dictionary    ${element}    tax
        ${convertedDate}=    Convert Date    ${birthdayValue}    date_format=%d%m%Y
        ${curDate}=    Get Current Date
        ${age}=       Subtract Date From Date    ${curDate}    ${convertedDate}    verbose
        ${days}=    Split String    ${age}    ${SPACE}
        ${days}=    Get From List    ${days}    0
        ${age}=    Evaluate    ${days}/365
        ${age}=    Evaluate    utility.ageFlooring(${age})    modules=utility
        ${18Max}    Evaluate    ${age} <= 18
        ${35Max}    Evaluate    18 < ${age} <= 35
        ${50Max}    Evaluate    35 < ${age} <= 50
        ${75Max}    Evaluate    50 < ${age} <= 75
        ${76Min}    Evaluate    ${age} >= 76
        ${variable}=    Run Keyword If    ${18Max}== True    Set Variable    ${age18Max}
        ...    ELSE IF    ${35Max}== True    Set Variable    ${age35Max}
        ...    ELSE IF    ${50Max}== True    Set Variable    ${age50Max}
        ...    ELSE IF    ${75Max}== True    Set Variable    ${age75Max}
        ...    ELSE IF    ${76Min}== True    Set Variable    ${age76Min}
        ${genderBonus}=    Run Keyword If    '${genderValue}'=='m' or '${genderValue}'=='M'    Set Variable    ${genderMBonus}
        ...    ELSE IF    '${genderValue}'=='f' or '${genderValue}'=='F'    Set Variable    ${genderFBonus}
# 4 AC3
        ${calculatedTaxRelief}=    Evaluate    ((${salaryValue}-${taxValue})*${variable})+${genderBonus}
# 4 AC5
        ${zeroToFifty}=    Evaluate    0.00 < ${calculatedTaxRelief} < 50.00
        Run Keyword If    ${zeroToFifty}==False    Set To Dictionary    ${calculatedReliefs}    ${natidValue}=${calculatedTaxRelief}
        ${splCalculated}=    Run Keyword If    ${zeroToFifty}==True    Set Variable    50.00
        ${calculatedTaxRelief}=    Run Keyword If    ${zeroToFifty}==True    Set Variable    ${splCalculated}
        Run Keyword If    ${zeroToFifty}==True    Set To Dictionary    ${calculatedReliefs}    ${natidValue}=${calculatedTaxRelief}
        Set Global Variable    ${calculatedReliefs}
    END

# 4 AC4 and 4 AC6
I compare the calculated and system calculated reliefs
    ${decimalList}    Create List
    FOR    ${element}    IN    ${calculatedReliefs}
            ${compareCalculated}=    Get Dictionary Values    ${element}
            Set Test Variable    ${compareCalculated}
            FOR    ${element}    IN    @{compareCalculated}
                ${flooredValue}    Evaluate    utility.reliefFlooring(${element})    modules=utility
                ${flooredValue}    Evaluate    "%.2f" % ${flooredValue}
                Append To List    ${decimalList}    ${flooredValue}
                Log    ${decimalList}
                Set Test Variable    ${decimalList}
            END
    END

    FOR    ${element}    IN    ${reliefValues}
            ${compareSystem}=    Get Dictionary Values    ${element}
            Set Test Variable    ${compareSystem}
    END
# The below keyword can be used to compare the raw calculated relief with system
    # Run Keyword And Continue On Failure    Lists Should Be Equal    ${compareCalculated}    ${compareSystem}
    Lists Should Be Equal    ${decimalList}    ${compareSystem}  

I see a red colored button
    ${elem}    Get Webelement    css=.btn-danger
    ${bg color}    Call Method    ${elem}    value_of_css_property    background-color
    Should Be Equal As Strings    rgba(220, 53, 69, 1)    ${bg color}
    
    # Using Javascript
    # ${background_color}=  Execute Javascript  return window.getComputedStyle(document.getElementsByClassName("btn-danger")[0],null).getPropertyValue('background-color');
    # ${background_color}=  Execute Javascript  return document.defaultView.getComputedStyle(document.getElementsByClassName("btn-danger")[0],null)['background-color'];

the text on the button must read Dispense Now
    Wait Until Element Is Visible    ${btn-dispense-now}

after clicking the button should show cash dispensed
    Scroll Element Into View    ${btn-dispense-now}
    Click Element    ${btn-dispense-now}
    Wait Until Element Is Visible    ${txt-cash-dispensed}
    
I call a get or post request with other http methods
    [Arguments]    ${endpoint}    ${fileName}
    Create Session    jsonFileInsert    ${endpoint}
    ${jsonData}=    Load JSON From File    ${fileName}
    Run Keyword And Continue On Failure    Put On Session    jsonFileInsert    ${endpoint}    json=${jsonData}
