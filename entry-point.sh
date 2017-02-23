#!/bin/bash

export PATH=$PATH:$(realpath ./scripts)

export LI3DS_ROOT_PATH=$(realpath .)
export LI3DS_RESSOURCES_PATH=$LI3DS_ROOT_PATH/ressources

ls scripts/ -1