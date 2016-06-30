#!/bin/bash

THE_USER=${SUDO_USER:-${USERNAME:-guest}}

set -e

# download and build Node.js

sudo -u ${THE_USER} curl https://codeload.github.com/nodejs/node/tar.gz/v4.2.3 > node.v4.2.3.tar.gz
sudo -u ${THE_USER} tar -xvf node.v4.2.3.tar.gz
cd node-4.2.3/
sudo -u ${THE_USER} bash -c './configure'
sudo -u ${THE_USER} make
make install
cd ..

# install node-gyp and mocha

npm install node-gyp -g
npm install mocha -g

curl -sSL https://raw.githubusercontent.com/aspnet/Home/dev/dnvminstall.sh | DNX_BRANCH=dev sudo -u ${THE_USER} sh

su ${THE_USER} -l -s /bin/bash -c "source .dnx/dnvm/dnvm.sh && dnvm install latest -r coreclr -alias edge-coreclr"

# download and build Edge.js

sudo -u ${THE_USER} curl https://codeload.github.com/tjanczuk/edge/zip/master > edge.js.zip
sudo -u ${THE_USER} unzip edge.js.zip 
cd edge-master/
EDGE_DIRECTORY=$(pwd)
chown -R ${THE_USER} ~/.npm

su ${THE_USER} -l -s /bin/bash -c "source ~/.dnx/dnvm/dnvm.sh && dnvm use edge-coreclr && cd $EDGE_DIRECTORY && npm install"
su ${THE_USER} -l -s /bin/bash -c "source ~/.dnx/dnvm/dnvm.sh && dnvm use edge-coreclr && cd $EDGE_DIRECTORY && npm test"
su ${THE_USER} -l -s /bin/bash -c "source ~/.dnx/dnvm/dnvm.sh && dnvm use edge-coreclr && cd $EDGE_DIRECTORY && EDGE_USE_CORECLR=1 npm test"
