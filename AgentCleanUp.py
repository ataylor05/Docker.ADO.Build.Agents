from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
import argparse

parser = argparse.ArgumentParser(description='Azure Devops agent pool cleaner')
parser.add_argument('-o', action="store", dest="org")
parser.add_argument('-p', action="store", dest="pat")
parser.add_argument('-n', action="store", dest="name")

credentials = BasicAuthentication('', pat)
connection = Connection(base_url=org, creds=credentials)
taskAgentClient = connection.clients.get_task_agent_client()

def getPoolId(taskAgentClient, name):
    pools = taskAgentClient.get_agent_pools()
    for pool in pools:
        if pool.name == name:
            return pool.id

getPoolId(taskAgentClient, name)
