# Proj3

### Steps to run code
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

## 1. Group members
Yihui Wang UFID# 8316-4355   
Wei Zhao UFID# 9144-4835

## 2. What is working
We implement the network join and routing as described in the Tapestry paper (Section 3: TAPESTRY ALGORITHMS). We implement it using a similar API to the one described in the paper. Each node has an ID which is achieved by using SHA-1. Each node also owns a neighbour map with multiple levels, where each level contains links to nodes matching a prefix up to a digit position in the ID and contains a number of entries equal to the ID’s base. We use the Dynamic Node Algorithm as described in the paper when a new node joining the network. When a new node is added to the network, the new node will notify all need-to-know nodes in the network and update its own table. When routing for a node, the n hop shares a prefix of length n with the destination ID. Tapestry looks in its n+1 level map for the entry matching the next digit in the destination ID. Any existing node in the system can be reached in at most logb(N) hops, in a system with namespace size N, IDs of base b.

## 3. What is the largest network we managed to deal with
The namespace N in our project is 1.46x10^48 (16 to the power of 40) because we use SHA-1 to create id for the nodes. So our network can have 1.46x10^48 nodes theoretically. We were able to create a network with 10000 nodes and it can run properly. With node number increasing, we believe the network can still run properly until the number of nodes reach 1.46x10^48. Apprantly, The only factor it can change is the running time. We also observed that the most time cost was in the table creating part, sending message is a rather faster process compare to creating table.
