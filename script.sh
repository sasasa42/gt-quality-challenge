python3 -m pip install --user virtualenv
python3 -m venv venv
. venv/bin/activate
pip3 install -r requirements.txt
CUR_DIR=$(pwd)
webdrivermanager firefox chrome --linkpath $CUR_DIR/venv
robot test-suite.robot