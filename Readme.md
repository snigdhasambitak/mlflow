# MLFlow 

This repository is used to deploy MLFlow, a framework used for managing the end-to-end machine learning lifecycle. Notice that this deployment does not configure MLFlow as an artifact repository for the models. Instead it just offers the tracking server for experiments.  

![](/rsc/MLflow-logo.png "MLFlow logo")


#### **Pre-requirements for the cluster-mode deployment**
* Create a PostgresSQL 13 database in Google Cloud SQL for the MLFlow backend store, and create the login credentials to access it.

Additionally, if you want to deploy the platform in a local cluster:  

* minikube version: v1.28.0
* kubectl
    * Client Version: v1.25.1
    * Kustomize Version: v4.5.7
    * Server Version: v1.25.3
* envsubst (GNU gettext-runtime) 0.21.1

#### **Pre-requirements for the local-mode deployment**
* Docker 20.10.20
* Docker Compose version v2.12.1

---

## Deploying and running MLFlow
### **Kubernetes**

> The deployment for the staging/production cluster is a bit different than the one for the local cluster, since it uses specific features provided by GKE. The differences are:
> - the authentication mechanism: the deployment for the staging/production cluster uses the Workloads Identity feature, while the deployment for the local cluster stores a service account key file as a Kubernetes secret.
> - the deployment for the local cluster does not include an ingress.
  

#### Staging/Production cluster
The whole process for building and deploying all the components in Kubernetes in a staging/production cluster is automated through Estafette.

#### Dev/Local cluster
For development and debugging purposes, a script to build and deploy all the resources in a local minikube cluster is provided.

1. Make sure you have minikube up and running and that you created a cluster.

2. Edit all the environment variables under the [config/k8s-local](/config/k8s-local/) folder properly.
    1. `gcp_sa.env`
        - `GCLOUD_SERVICE_ACCOUNT_JSON`: a GCP service account JSON key file content. The service account must have permissions to access a Google Cloud SQL instance. The content of the JSON key file must be provided in a base64-encoded format.
    2. `mlflow_postgres.env`
        - `GCLOUD_PROJECT_NAME_SQL`: the GCP project ID the Cloud SQL instance belongs to.
        - `GCLOUD_ZONE_SQL`: the region where the Cloud SQL instance is located.
        - `GCLOUD_SQL_INSTANCE`: the name of the Cloud SQL instance.
        - `MLFLOW_SQL_USER`: the user name of the MLFlow database.
        - `MLFLOW_SQL_PASSWORD`: the password for the MLFLow database user. It must be url-encoded to avoid issues with special characters.
        - `MLFLOW_SQL_DB`: the name of the MLFlow database.

3. Run the following script:

```sh
./scripts/run-local-k8s.sh
```  

The script will first enter the Minikube's docker environment and will build the docker image for the MLFlow tracking server.
Secondly, it will export all the environment variables contained in every file under the [config/k8s-local](/config/k8s-local/) folder.  
Finally, it will switch the `kubectl` context to make sure it points to the Minikube cluster and will apply all the manifests under the [kubernetes/environments/local](/kubernetes/environments/local/) folder.

> To access the MLFlow UI, run `kubectl port-forward svc/mlflow-tracking-server 5000:5000` and go to [http://localhost:5000](http://localhost:5000)  


4. If you want to delete all the resources, run the following script:

```sh
./script/destroy-local-k8s.sh
```

The script will switch the `kubectl` context to make sure it points to the Minikube cluster and will delete all the resources under the platform namespace.

### Local environment

1. In order to build and run all the components in your local machine, execute the following script:

```sh
./scripts/run-local.sh
```

It will pull/build and run all the necessary Docker images. Take into account the it may take a few seconds until all the services are in a healthy state.  
If you'd like to change any configuration of the tools, refer to the files in the [`config/local`](/config/local) folder.

> To access the MLFlow UI, go to [http://localhost:5000](http://localhost:5000)

2. If you want to stop all the containers, run the following script:

```sh
./scripts/stop-local.sh
```

The script will stop and delete all the docker resources.
