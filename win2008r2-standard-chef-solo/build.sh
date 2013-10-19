#!/bin/bash
export PACKER_LOG=1
export PACKER_LOG_PATH=./packer.log
packer build packer.json