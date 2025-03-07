#!/bin/bash

mlflow db upgrade "${MLFLOW_BACKEND_STORE_URI}"

# No need to pass any options, since it's all configured via environment variables
mlflow server
