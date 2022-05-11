*** Settings ***

Resource    test-steps.robot
Suite Setup    Set Up
Suite Teardown    Close All Browsers

*** Test Cases ***

# 1 AC1
As a Clerk I should be able to insert single record with incorrect data
    Given I setup a list of incorrect data
    When I try to insert the single records    ${incorrectList}

# 1 AC1
As a Clerk I should be able to insert single record with correct data
# NOTE: Generate some test data. Switch as per requirement(generated or hardcoded)
    Given I generate some correct data
    # Given I setup a list of correct data
# NOTE: Switch between ${genCrctList} and ${correctList} as per requirement(generated or hardcoded)
    When I try to insert the single records   ${genCrctList}

# 1 AC1
As a Clerk I should be able to insert single record through json file
    When I try to insert the record through json file    ${insSglEndpoint}    json/single.json

# NOTE: This will break the system and will have to start the app. again
# Insert single record with breaking data
    # Given I setup a list of breaking data
    # When I try to insert the required data    ${breakingList}

# 2 AC1
As a Clerk I should be able to insert multiple records with incorrect data
    Given I setup a list of incorrect data
    When I try to insert multiple records in one request    ${incorrectList}

# 2 AC1
As a Clerk I should be able to insert multiple records with correct data
    Given I generate some correct data
    # Given I setup a list of correct data
    When I try to insert multiple records in one request    ${genCrctList}

# 2 AC1
As a Clerk I should be able to insert multiple records through json file
    When I try to insert the record through json file    ${insMultplEndpoint}    json/multiple.json

As a Clerk I should be able to upload a csv file to the portal
# 3 AC1
    Given the first row of the csv is a header
# 3 AC2
    When I verify the subsequent details
# 3 AC3
    Given I go to the portal
    And I upload the csv file

# 4
As the Bookkeeper I should be able to query the amount of tax relief
    Given I rake the DB
    And I generate some correct data
    # Given I setup a list of correct data
    And I try to insert multiple records in one request    ${genCrctList}
    And I calculate the relief
    And I hit the get endpoint to fetch the taxrelief
    Then I compare the calculated and system calculated reliefs

As the Governor I should be able to dispense relief to the working heroes
    # 5 AC1
    Given I go to the portal
    And I upload the csv file
    Then I see a red colored button
    # 5 AC2
    And the text on the button must read Dispense Now
    # 5 AC3
    And after clicking the button should show cash dispensed

As a tester I test for the security of the application
    When I call a get or post request with other http methods    ${insSglEndpoint}    json/single.json
    When I try to insert the record through json file    ${insSglEndpoint}    json/multiple.json
    When I try to insert the record through json file    ${insSglEndpoint}    json/html.json
    When I try to insert the record through json file    ${insSglEndpoint}    json/splchars.json
    When I try to insert the record through json file    ${insSglEndpoint}    json/sqlInjctn.json

    