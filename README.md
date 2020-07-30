# README

A tableless authentication app that uses Redis for user storage. The Create Interactor validates and handles user parameters, hashes passwords using Bcrypt, and then stores the user as a Hash in a Redis database.

<img src="https://i.imgur.com/CvEJhVd.png" width="400">

Future development:

Login session tokens - to elminate possible vulnerabilities in a replay attack we can add a login token (uuid) on the user and store it on the session instead of the user id. This will make it much harder to guess a user's other credentials if somehow their session gets captured by a third party

Expiring sessions - expire user sessions after a certain amount of time. Reseting sessions periodically will prevent cases where an existing session may be captured or fixated maliciously

Redis Locks - as the app scales up locks will prevent retries when writing to the Redis db when latency increases

Redis pipelining - Redis commands can be consolidated into a pipeline to increase execution time

Relational database - if we add more user data and the size of the db increases, the db can be larger than the amount of memory available in Redis, we can leverage a relational database to store some values that don't need to be fetched so quickly
