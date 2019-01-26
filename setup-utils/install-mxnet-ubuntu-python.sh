#!/usr/bin/env bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

######################################################################
# This script installs MXNet for Python along with all required dependencies on a Ubuntu Machine.
# Tested on Ubuntu 14.0 + distro.
######################################################################
set -e

MXNET_HOME="$(dirname $(realpath $(dirname $0)))"
echo "MXNet root folder: $MXNET_HOME"

echo "Installing build-essential, libatlas-base-dev, libopencv-dev, pip3, graphviz ..."
sudo apt-get update
sudo apt-get install -y build-essential libatlas-base-dev libopencv-dev graphviz libopenblas-dev

echo "Installing Numpy..."
sudo apt-get install python3 python3-numpy

echo "Installing Python setuptools pip..."
sudo apt-get install -y python3-setuptools python3-pip

echo "Updating pip..."
pip3 install -U pip

echo "Building MXNet core. This can take few minutes..."
cd "$MXNET_HOME"
make -j$(nproc)

echo "Installing Python package for MXNet..."
pip3 install -e python/ --user

echo "Adding MXNet path to your ~/.bashrc file"
echo "export PYTHONPATH=$MXNET_HOME/python:$PYTHONPATH" >> ~/.bashrc
source ~/.bashrc

echo "Install Graphviz for plotting MXNet network graph..."
pip3 install graphviz pyyaml --user

echo "Done! MXNet for Python installation is complete. Go ahead and explore P3 with Python :-)"
