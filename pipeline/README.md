# Usage

define the following in a secrets.yml file

* git-user
* git-token-password
* artifactory-username
* artifactory-password

update main.tf to include actual passwords (or use a variable file), then use terraform to setup concourse

```
terraform apply
```

# Setup your pipeline

## Prerequisite: Login into your Concourse target

To use Concourse on AWS pre-prod, first login to your team
```
fly login \
    -t <TARGET> -c <CONCOURSE_URL> \
    -u <CONCOURSE_USERNAME> -p <CONCOURSE_PASSWORD>
```

## 1. Set env variables:
```
export TARGET=<fillme>
export SECRETS_FILE=<fillme>
```

where ```TARGET``` is the name you chose when you logged into your Concourse server ```SECRETS_FILE``` should be set to the absolute or relative path of your secret variable file. You must specify the following vars:

    ```
    git-user: FILL_ME
    git-token-password: FILL_ME

    artifactory-username: FILL_ME
    artifactory-password: FILL_ME

    concourse-username: FILL_ME
    concourse-password: FILL_ME
    ```

## 2. Setup (one-off script)
From the repo's root dir, run:
```
pipeline/setup.sh
```

## Notes
* you need to do this procedure only the first time
* when you make changes to PuP's jobs, they will eventually be applied by PuP itself after the `update-pipeline` job runs
