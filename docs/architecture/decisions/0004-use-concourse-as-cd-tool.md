# 2. Use Concourse CI as CD Tool

Date: 2017-07-27

## Status

Accepted

## Context

The entire organization has been using a centralized approach to CD: a monolithic server shared by all teams, managed by the Infra team through manual operations; configs and pipelines are not versioned; changes to templates affected all pipelines.

The organization aims to move to a Decentralized approach to reduce lead time and promote autonomy, by decoupling Infra team and Delivery teams so that the latter ones can independently define and manage the path-to-production for their own apps.

We want: Pipelines as code, repeatable and independent builds, non-snowflake elastic agents, versioning and automation over manual operations. We want teams to be able to setup their own CD server, and able to scale it easily with minimum or no maintenance.

## Decision

We will use [Concourse CI](http://concourse.ci), which fulfills the above needs and we found to be very easy to learn and setup. It promotes pipelines as code as the rule, preventing manual tweaking via UI, and it is also designed to scale.

## Consequences

* No-snowflake: Test, Build, Deploy and any other job will run in isolated containers
* It will be possible to specify any docker image for build, so teams can also bake their own images, if needed
* Concourse supports different Operating Systems
* Pipelines will be defined as code with YAML files, preferrably to be checked in along with code each app repo
* No manual operations, UI will be merely for monitoring and triggering pipelines
* As code, pipelines can go through PR and code-reviews, improving knowledge sharing
* Teams could share a same Concourse instance or setup their own on AWS, reusing the provided [ref-arch](https://github.com/saksdirect/aws-ref-arch/tree/master/terraform/concourse)
* Developers can very easily setup a local Concourse, via Docker or Vagrant, to test and run pipelines locally
* A lot of existing plugins (called "resources") and integrations can be used
* Developing custom resources will be as easy as writing up to 3 shell scripts
* Secrets can be secured by integrating Vault as a Credentials Manager
* Pipelines configs, state and history are persisted on a common PostgreSQL database
* Workers and Schedulers can be scaled up and out easily in clusters, as long as they share the same db

Risks and tradeoffs:
* Maturity: unlike other tools, some common features you might expect are missing and could be added in the future
* Branching is not supported directly (yet), but pull-requests are already
* Roll-back is not intuitive, as well as deploying/running a specific revision
* Developing custom resources can compensate, but requires extra effort by the teams
* Secrets, without implementing Credentials Management, can be read from the server
* Vault, added recently ([v.3.3.0](https://github.com/concourse/concourse/releases/tag/v3.0.0)), is the only supported Credentials Manager today; others will be added in the future; managing Vault requires extra effort
* Versioning: Concourse promotes semantic versioning, it's a change but we prefer it to the previous approach (build counters)
* Currently, semantic version does not support git tagging, there is a 3rd party resource (see [here](https://github.com/laurentverbruggen/concourse-git-semver-tag-resource))
