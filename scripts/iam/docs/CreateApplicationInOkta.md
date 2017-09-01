# Creating an Application In Okta
This task requires you to be an Administrator in okta.  An existing organziation named 'S5A' will be used for the task and we will configure access to the 'Saks Preprod' AWS account.

I.  Login to https://[org]-admin.okta.com (e.g. https://s5a-admin.okta.com) and click the *Admin* button in the to right.   Then navigate to 'Applications->Applications' and click 	'Add Application' button.  In the search bar enter 'Amazon Web Services'.  Select the application and click add.

II. Walk through the create application wizard for General Settings and initial Sign-On Options:

![General Settings](images/createApp-GeneralSettings.png "General Settings")

![Sign On Options ](images/createApplication-SignOnOptions-Part-1.png "Sign On Options 1")


III. Download the *Identity Provider metadata* and save that to the file *infra-services/aws-iac/iam/oktaIdP-metadata.xml*


IV. Create the Identity Provider in AWS using the downloaded metadata for the application.  The script is assuming that your AWS cli credentials file has a profile section named *saks-preprod* that contains the access/secret key of a user with full IAM permissions in the Saks Preprod account. 
Execute the following script:

```
cd infra-services/aws-iac/iam
/create-identity-provider.sh saks-preprod

```
The script will output two pieces of information that you will need to continue configuring the application in Okta and should be saved:

* **SAMLProviderArn** which identifies the identify provider within AWS
* **AccessKeyId** and **SecretAccessKey** are the cli keys for an *Okta* that only has two permissions:  the ability to list roles and the ability to assume roles through saml authentication.

Output of the script will look like the following:

```
Creating SAML Identify Provider named: Okta_IdP
{
    "SAMLProviderArn": "arn:aws:iam::195056086334:saml-provider/Okta_IdP"
}
Creating the IAM user that will be used as a proxy between the Identify Provider and AWS
{
    "User": {
        "UserName": "Okta",
        "Path": "/",
        "CreateDate": "2017-06-05T16:03:01.926Z",
        "UserId": "AIDAJCAKMQILW3WMDDZBE",
        "Arn": "arn:aws:iam::195056086334:user/Okta"
    }
}
Creating the access keys for the IAM user. These are needed for the app to provision users with roles created in AWS.
{
    "AccessKey": {
        "UserName": "Okta",
        "Status": "Active",
        "CreateDate": "2017-06-05T16:03:02.520Z",
        "SecretAccessKey": "***********",
        "AccessKeyId": "AKIAIMRGWAZ4IPNJITAA"
    }
}
```

V. Continue configuring the 'Sign-On Options' stage:
![Sign On Options 1](images/createApplication-SignOnOptions-Part-2.png "Sign-On Options Part 2")

VI. Provision the Okta Application to access AWS
![Provision Application](images/createApplication-Provisioning.png "Provision Application")

Test the API credentials work:

![Provision Test](images/createApplication-Provisioning-TestAPI.png "Provision Test")

VII. Create the AWS roles and policies that Okta authenticated users can assume.

Execute the following script that will create the common roles that users of HBC Digital AWS accounts can assume.  The command assumes there is a profile section in your AWS cli credentials file named *saks-preprod*.

```
cd infra-services/aws-iac/iam
./create-all-user-policies-and-roles.sh saks-preprod
```

VIII. Now you must for the Okta application to reload the available roles from the AWS account.  Open the 'Amazon Web Services - Saks Preprod' application and open the 'Provision' table.  Click 'Edit' and then 'Save' which no changes. This trigger Okta to retrieve the newly created Roles created in AWS.  NOTE:  This will need to be done each time you add/delete roles in AWS that should be use by the application.

VIV. Assign users to the Okta Application and assign them roles.  Select the 'People' table for the application and select the user to add.  Choose one of the 'SAML User Roles' that the user may use when logging into AWS.  Ignore the 'Role' drop down, those are all roles in the AWS account, but one that a user can assume from an Okta log in.

![Assign Users](images/updateApp-AssignUsers.png "Assign Users")

![Assign Roles](images/updateApp-AssignUserRole.png "Assign Role")





