# MassDeployV1S-WP-Win

Proces to massively deploy **V1S&WP** agent to multiple **Windows EC2 instances** using **AWS SSM**

To maximize the compatibility, this project was developed using **Powershell version 1** 

The following steps will help you to deploy the full Trend Micro Basecamp Agent, so this process is not intended for updates of previous Trend Micro Workload Security deployments, use it only for **new deployments**.

This script and step-by-step was created based on the following AWS documentation:

    - https://aws.amazon.com/getting-started/hands-on/remotely-run-commands-ec2-instance-systems-manager/

A second reference that was used to for this project, was its sister project for Linux EC2 instances and that can be found in the following link:
    - https://github.com/VitorCora/MassDeployV1S-WP

We are going to be using **AWS System Manager - Node Management - Run Command** for the following activity (Can also be triggered through AWS System Manager - Node Management - Fleet Manager)

This script was crafted with a dual purpose, to work on massive cloud deployments and also for Onprem deployments via GPOs or SCCPs
** The means to use this script in GPOs or SCCPs is **not contemplated** in this guide.

# Pre requisites

All your instances must have a role that allows AWS SSM to access and manage them
* Steps to create and change role on the Step #

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/4f2bcfac-9f3c-4098-bd17-4fc747f0af30)

** **Further tests and analysis on my environment proved that the IAM role doesn`t need to be added to the instance, this pre requisite may be avoided for the sake of time**

Working Trend Vision One tenant
*Steps to the creation of the tenant on the the Step ##

Upload the Windows agent to an AWS S3 bucket accessible to the instances/servers that will be protected
*Steps to download the agent on the Step ####
* Steps to create and allow public access of the agent in the Step #####

# Create an IAM role to enable EC2 to access AWS System Manager

**Further tests and analysis on my environment proved that the IAM role doesn`t need to be added to the instance, this pre requisite may be avoided for the sake of time**

**You may jump for the next session**

Go to the **IAM** service on your AWS console and click on **Roles**
 - https://us-east-1.console.aws.amazon.com/iam/home?region=us-east-1#/roles

On the **Roles** page click on **Create Role**

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/2ec056d8-50ae-44ec-8a52-5554a186970c)

Under **Select trusted entity**, select **AWS service**

On the **Use case** selection, select **EC2**

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/dcfd853e-db23-425f-8d76-189e946a1cc7)

Click on **Next**, at the bottom right corner

On de **Add permissions** page, under the **Permissions policies**, look for the  **AmazonEC2RoleforSSM**, tick it and click on **Next**, at the bottom right corner

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/ae385a27-4171-4ae5-bb7d-29191d1d80a7)

Now we are on the last page.

On the page **Name, review, and create**

Under the **Role Name** paste 
 - EnablesEC2ToAccessSystemsManagerRole

Under the **Description** paste 
    - Enables an EC2 instance to access Systems Manager

Your should looks as follows:
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/bf98cf7e-d2eb-4935-a7ee-e431530122b4)
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/67fc2d60-7784-415f-a250-bdbac6de5053)

And click **Create role** to finish it

# AWS S3 Bucket - part 1

## Create an AWS S3 Bucket

Create an AWS S3 bucket on the S3 service:
    - https://s3.console.aws.amazon.com/s3/get-started?region=us-east-1&bucketType=general

On the AWS S3 Page, click on the orange button that says **Create Bucket** on the right top

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/1f9a5d5a-f047-4773-903e-84a359df135b)

On the **Create Bucket** Page, under **General configuration**, chose an **unique name** for your bucket

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/aa117ad7-4097-459c-b0b2-ec29906c018b)

Under the **Block Public Access settings for this bucket** session,

Tick off the **Block all public access** and tick the **acknowledgement** that object from this bucket may now be public.

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/8a4e6e0f-662c-41d0-9b37-03c9f42adeda)

Now click on the Orange button that says **Create bucket** on the bottom right corner

# Trend Vision One

## Create your Vision One instance


## Enable Vision One Server & Workload Protection

## Generate your Vision One Server & Workload Protection agent

Log into your Vision One console and chose your tenant

On your Vision One Tenant on the left-hand side, look for **Endpoint Security** in the Service column.

Click on it and navigate to **Endpoint Inventory**

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/c897164c-8983-4c2c-b1dd-04a3acb9bc8f)

On the Endpoint Inventory page, click On **Agent Installer** on the top right corner (Highlighted on yellow)
![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/40c01fbb-0088-4a12-8813-5a8d98d8d000)

A curtain will pop out:
    - On **Server & Workload Protection**
        - Select your **Operating system**: Windows
        - Leave the **Auto dectect** selection ticked 
        - **Protection Manager**: Choose your Manager
        - CLick on the Blue circle to **download installer**

![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/6159bd0f-291b-4bd5-8246-5a9fa15ee4d7)



After the download is ready, on your computer, rename the file as **TMServerAgent_Windows.zip**

# AWS S3 Bucket - part 2

## Upload the agent to your AWS S3 Bucket

Now it is time to upload your agent to your AWS S3 Bucket.

You may use console access or AWS CLI.

## On the AWS Console, navigate to the AWS S3 page:
    
    - https://s3.console.aws.amazon.com/s3/home?region=us-east-1#
    
    - Locate your bucket and open it
![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/34948779-2b0d-4e97-a719-f00cfc6dc11c)
        
    - Click on the yellow button on the Right side of the page that says **Upload**
   ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/a940b014-7524-468e-8cb2-9657a114e88e)
        
    - On the upload page click on **Add Files**
    
    - On the pop-up Find your Agent and click on Open
![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/7b3187ea-6982-4c8d-84db-7e3bd5a6bb5e)

        
    - Now you just need to click on the Orange button that says **Upload** on the bottom of the page
 ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/3617be11-a628-4437-8e92-e889f25d400e)

You should have something similar to the following:
    ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/483053f4-7105-404f-b051-827801ddc7ce)

## Using bash and AWS CLI

### AWS CLI MV method

On the bash, move to the folder where your Agent lives.

On this folder run the following command:
    - aws s3 mv TMServerAgent_Windows.zip s3://**<YOUR BUCKET NAME>**/TMServerAgent_Windows.zip
        ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/b790ee68-b77f-4b48-a448-ccb9775b3cd8)

You should have something similar to the following:
    ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/46bd3de2-c282-4685-84a3-dbda33590ac8)

### AWS API PUT-OBJECT method

On the bash, move to the folder where your Agent lives.

On this folder run the following command:
    - aws s3api put-object --bucket **<YOUR BUCKET NAME>** --key TMServerAgent_Windows.zip --body TMServerAgent_Windows.zip
        ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/db448d7a-bc3b-4851-ac11-6935308c0283)

You should have something similar to the following:
    ![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/2095240b-1458-42aa-af3e-c0f90efd23df)

## Make the agent public on the AWS S3 Bucket

Now is the time to make your agent public, so that all your accounts that need to access it may be able to download it. **Please do not store any other software, credential or classified information in the Bucket.**

Enter on your recently created bucket.

Look for the **Permissions Tab** and select it

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/7b0d62c0-6a2e-48e2-9082-71ef09318a7b)

Under the Bucket policy session, click on Edit and add the following permission:

```
{
    "Version": "2012-10-17",
    "Statement": [   
        {
            "Sid": "Allowobjectaccess",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "**<YOURBUCKETARN>**/TMServerAgent_Windows.zip"
        }
    ]
}
```

Your should look somewhat like the following, but with your **BUCKET ARN** at the **Resource session** 
![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/deb67e13-250a-4a66-9392-9213a8bc32ca)


Now click on **Save Changes** at the bottom right corner

# Run Command

## Script

Copy and paste the following script into the Command Parameters session:

<powershell>
# Force PowerShell to use TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Define the URL from which to download the program
$url = "https://**<YOUR BUCKET>**.s3.amazonaws.com/TMServerAgent_Windows.zip"

# Define the path where the program will be downloaded
$downloadPath = "$env:TEMP\TMServerAgent_Windows.zip"

# Create a WebClient object
$webClient = New-Object System.Net.WebClient

# Download the program using the DownloadFile method (compatible with PowerShell v1)
$webClient.DownloadFile($url, $downloadPath)

# Check if the file was downloaded successfully
if (Test-Path $downloadPath) {
    Write-Host "Program downloaded successfully."
    Write-Host "Running the program..."

    # Extract the downloaded file using Shell.Application (compatible with PowerShell v1)
    $shell = New-Object -ComObject Shell.Application
    
    # Define the destination folder path
    $destinationFolderPath = "$env:TEMP\TMServerAgent"
    
    # Create the destination folder if it doesn't exist
    if (-not (Test-Path $destinationFolderPath)) {
        New-Item -ItemType Directory -Path $destinationFolderPath | Out-Null
    }
    
    # Get the zip folder and destination folder objects
    $zipFolder = $shell.NameSpace($downloadPath)
    $destinationFolder = $shell.NameSpace($destinationFolderPath)
    
    # Check if the destination folder object is not null
    if ($destinationFolder -ne $null) {
        # Copy the items from the zip folder to the destination folder
        $destinationFolder.CopyHere($zipFolder.Items(), 16)

        # Replace 'EndpointBasecamp.exe' with the actual name of the executable you want to run from the extracted files
        $programPath = "$env:TEMP\TMServerAgent\EndpointBasecamp.exe"
        
        # Check if the program exists in the destination folder
        if (Test-Path $programPath) {
            Write-Host "Running the program located at: $programPath"
            Start-Process -FilePath $programPath
        } else {
            Write-Host "Error: Program not found at $programPath"
        }
    } else {
        Write-Host "Error: Destination folder not accessible."
    }
} else {
    Write-Host "Error: Failed to download the program from $url"
}
</powershell>  

This code example can also be found in the main repository:
    - https://github.com/VitorCora/MassDeployV1S-WP-Win/blob/main/DeployBasecampWin.ps1

It should look like the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP-Win/assets/59590152/88c3f9cd-24b8-453d-957a-3c1ef77b0e45)


Next step is to select the target instances

On the Target selection session you may choose based on "Instance TAGs", "Manually"or based on "Resource Group".

For this example I chose manually, but for a massive deployment the use of a TAG Key::Value pair is highly recommended (eg. TrendProtect::YES)

It should look similar to the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/ad7ed3b6-2cef-4020-949f-6e93514aed82)

Next recommended session to be edited is Output options

On the Outputs options session choose an AWS S3 bucket of your preference to store your logs, this will ensure that you will have full access to the log history and possible errors.

It should look similar to the following:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/dc02270b-e0c2-41bf-9a89-e061c2c57ca3)

# Final result:

## With Role IAM in the instances:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/5633c1ef-16e3-4552-ad8e-1fa3433113e5)

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/13008120-11ac-414f-9baa-896033dd660f)

## Without the Role IAM to 4 of the 5 instances:

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/9aa4c9ef-a40b-44c7-acf9-0ff29dc9860b)

![image](https://github.com/VitorCora/MassDeployV1S-WP/assets/59590152/0e9ef3bf-23bb-4b84-8c2e-9a98bbb26d09)

After testing both methods, my conclusion is that the role IAM is not necessary for this type of deployment, what ease the burden and make it simpler for the Cloud teams to deploy on scale.
