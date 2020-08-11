# Info
These files build the Linux Azure Devops build agent.  

## Manual building
This project is intended for Azure Devops Pipelines to build the Docker image, however it could be built manually.  If doing a manual build, you would need to replaced the PAT token in the Dockerfile with a valid token to connect to ADO.<br>
<pre>
git clone https://github.com/ataylor05/Docker.ADO.Build.Agents.git
cd Docker.ADO.Build.Agents\Linux
docker build -t ado-linux-agent:1.0 .
</pre>

# Docker in Docker
The Docker process on the Kubernetes hosts are being shared with the agent pods so that the pods are able to use the Docker engine.  This is done via the Kubernetes deloyment manifest by sharing the docker socket.<br>
<pre>
docker run -d --restart always -v /var/run/docker.sock:/var/run/docker.sock ado-linux-agent:1.0
</pre>


## Running containers locally
<pre>
docker container run -d --restart always ado-linux-agent:1.0
</pre>
