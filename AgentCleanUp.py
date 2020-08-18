from azure.devops.connection import Connection
from msrest.authentication import BasicAuthentication
import argparse

parser = argparse.ArgumentParser(description='Azure Devops agent pool cleaner')
parser.add_argument('-o', action="store", dest="org", help="Azure Devops URL for organization")
parser.add_argument('-p', action="store", dest="pat", help="Personal Access Token")
parser.add_argument('-n', action="store", dest="name", help="Agent pool name")
args = parser.parse_args()

credentials = BasicAuthentication('', args.pat)
connection = Connection(base_url=args.org, creds=credentials)
taskAgentClient = connection.clients.get_task_agent_client()

def getPoolId(taskAgentClient, name):
    pools = taskAgentClient.get_agent_pools()
    for pool in pools:
        if pool.name == name:
            return pool.id

def getAgentList(taskAgentClient, poolId):
    return taskAgentClient.get_agents(pool_id=poolId)

def removeOfflineAgents(taskAgentClient, poolId, agentList):
    for agent in agentList:
        if agent.status == "offline":
            taskAgentClient.delete_agent(pool_id=poolId, agent_id=agent.id)

poolId = getPoolId(taskAgentClient, args.name)
agentList = getAgentList(taskAgentClient, poolId)
removeOfflineAgents(taskAgentClient, poolId, agentList)
