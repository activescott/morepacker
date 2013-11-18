#!/bin/bash
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log
#NOTE: erb is from ruby. Tested with ruby 1.9.3p385
erb packer.json.erb > ./packer.json

packer build packer.json
