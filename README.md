# Tapestry_Algorithm

## Problem Definition
The goal of this project is to implement in Elixir using the actor model the Tapestry Algorithm and a simple object access service to prove its usefulness. The specification of the Tapestry protocol can be found in the paper - Tapestry: A Resilient Global-Scale Overlay for Service Deployment by Ben Y. Zhao, Ling Huang, Jeremy Stribling, Sean C. Rhea, Anthony D. Joseph and John D. Kubiatowicz. Link to paper- https://pdos.csail.mit.edu/~strib/docs/tapestry/tapestry_jsac03.pdf. You can also refer to Wikipedia page: https://en.wikipedia.org/wiki/Tapestry_(DHT) . Here is other useful link: https://heim.ifi.uio.no/michawe/teaching/p2p-ws08/p2p-5-6.pdf . Here is a survey paper on comparison of peer-to-peer overlay network schemes- https://zoo.cs.yale.edu/classes/cs426/2017/bib/lua05survey.pdf.<br/>
Implement the network join and routing as described in the Tapestry paper (Section 3: TAPESTRY ALGORITHMS). You can change the message type sent and the specific activity as long as you implement it using a similar API to the one described in the paper.

## Group members
Yihui Wang UFID# 8316-4355   
Wei Zhao UFID# 9144-4835

## Steps to run code
1. Open the Terminal and go to the directory of the project.
2. Type in the following command:
```
mix run project3.exs numNodes numRequests
```
Where numNodes is the number of peers to be created in the peer to peer system and numRequests the number of requests each peer has to make. 

Example
```
mix run project3.exs 1000 1000
```
This command to create 1000 peers in the P2p system and each peer will perform 1000 requests.

3. The result (maximum number of hops that must be traversed for all requests for all nodes) will be shown on the screen.

## What is working
We implement the network join and routing as described in the Tapestry paper (Section 3: TAPESTRY ALGORITHMS). We implement it using a similar API to the one described in the paper. Each node has an ID which is achieved by using SHA-1. Each node also owns a neighbour map with multiple levels, where each level contains links to nodes matching a prefix up to a digit position in the ID and contains a number of entries equal to the ID’s base. We use the Dynamic Node Algorithm as described in the paper when a new node joining the network. When a new node is added to the network, the new node will notify all need-to-know nodes in the network and update its own table. When routing for a node, the n hop shares a prefix of length n with the destination ID. Tapestry looks in its n+1 level map for the entry matching the next digit in the destination ID. Any existing node in the system can be reached in at most logb(N) hops, in a system with namespace size N, IDs of base b.

## What is the largest network we managed to deal with
The namespace N in our project is 1.46x10^48 (16 to the power of 40) because we use SHA-1 to create id for the nodes. So our network can have 1.46x10^48 nodes theoretically. We were able to create a network with 10000 nodes and it can run properly. With node number increasing, we believe the network can still run properly until the number of nodes reach 1.46x10^48. Apprantly, The only factor it can change is the running time. We also observed that the most time cost was in the table creating part, sending message is a rather faster process compare to creating table.
