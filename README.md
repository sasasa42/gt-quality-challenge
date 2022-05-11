# Pre-requisites
Install python3
Install pip3

# Star the server in the project root directory
java -jar OppenheimerProjectDev.jar

# Run Functional Test 
<!-- For First time run, Run the below shell script file in the project root directory -->
sh script.sh
<!-- For subsequent runs -->
. venv/bin/activate
robot test-suite.robot

# For running Performance Test using K6
<!-- Insall K6 on mac using the below command: -->
brew install k6
<!-- To run sample performance test run the below command: -->
k6 run perfTest.js