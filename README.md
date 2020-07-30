# README

A tableless authentication app that uses Redis for user storage. The Create Interactor validates and handles user parameters, hashes passwords using Bcrypt, and then stores the user as a Hash in a Redis database.

![alt text](https://i.imgur.com/CvEJhVd.png | width=100)

Future development:

Login session tokens - to elminate vulnerabilities to a replay attack we can add a login token (uuid) on the user and store it on the session instead of the user id. This will make it much harder to guess a user's other credentials if somehow their session gets captured

Expiring sessions - expire user sessions after a certain amount of time to reset sessions periodically to prevent cases where a session may be captured or fixated maliciously

Redis Locks - as the app scales locks will prevent retries when writing to the db as latency increases

Redis pipelining - Redis commands can be consolidated into a pipeline to increase execution time

Relational database - if we add more user data and the size of the db increases, it can become larger than memory, we'll need to leverage some values being stored in a relational db
