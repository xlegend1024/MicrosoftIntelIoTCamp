<!-- markdownlint-disable MD002 MD003 MD033 MD034 -->
Intel IoT Gateway, Arduino 101 and Microsoft Azure Hands-On-Lab
===

Overview
---

In this lab, we will unbox and set up an Intel IoT Gateway and the Arduino 101 board (with a Seeed Grove Starter kit) along with several services available in Microsoft Azure to monitor the temperature and alert maintenance of a high temperature. Using Node-RED, running on the Intel NUC Gateway, the application will read the temperature value from a Grove temperature sensor and publish that data to an Azure IoT Hub.  From there a collection of Azure services including Stream Analytics, Event Hubs, SQL Database, Web Applications and Power BI Embedded will be used to both display the temperature data as well as alert the user to temperature readings over a certain threshold.

![Lab Architecture](images/00000-LabArchitecture.jpg)

<a name="PrePrerequisites"></a>
Prerequisites
---

In order to successfully complete this lab you will need:

- Intel Grove Commercial IoT Developer Kit **<a target="_blank" href="https://www.seeedstudio.com/Grove-IoT-Commercial-Developer-Kit-p-2665.html">link</a>**
- Arduino 101 **<a target="_blank" href="https://www.arduino.cc/en/Main/ArduinoBoard101">link</a>**
- A computer.  Windows, macOS or Linux
- An active Microsoft Azure Subscription.  If you do not have a current subscription, you can create one using the **<a target="_blank" href="https://azure.microsoft.com/en-us/free/">free trial</a>**
- Node.js 4.x or later.  You can install Node.js from **<a target="_blank" href="https://nodejs.org/en/">nodejs.org</a>**
- Visual Studio Code. Visual Studio Code is a free, open source, cross platform development environment.  You can install it from **<a target="_blank" href="http://code.visualstudio.com">code.visualstudio.com</a>**
- Git installed and in your system path - You can install Git from **<a target="_blank" href="https://git-scm.com/downloads">git-scm.com/downloads</a>**

    You also need to have your git global config setup with the user and email.  To ensure the global config options, run the following commands from your command prompt or terminal window after installing git:

    ```text
    git config --global user.name "Your Name"
    git config --global user.email "Your Email"
    ```

Tasks
---

1. [Getting Started with Grove IoT Commercial Developer Kit](#GettingStartedWithGrove)
1. [Intel NUC Developer Hub Overview](#IntelNucHubOverview)
1. [Blinking an LED with Node-RED](#Blinky)
1. [Reading the Temperature Sensor](#ReadingTemperatures)
1. [Planning your Azure Resources](#PlanningAzure)
1. [Creating an Azure IoT Hub](#CreateIoTHub)
1. [Creating an Azure IoT Hub Device Identity](#CreateIoTHubDeviceIdentity)
1. [Publishing Temperature Sensor Data to the Azure IoT Hub](#PublishToIoTHub)
1. [Processing Temperature Data with Stream Analytics](#ProcessingWithStreamAnalytics)
1. [Displaying Temperature Data with Azure Web Apps](#AzureWebApp)
1. [Sending Messages from the Azure IoT Hub to the Intel Gateway](#CloudToDeviceMessages)
1. [Cleaning Up](#CleaningUp)

___

<a name="GettingStartedWithGrove"></a>
Getting Started with Grove IoT Commercial Developer Kit
---

1. Unbox the Grove Starter Kit and Arduino 101:

    ![Grove Starter Kit](images/01010-GroveStarterKit.png)
    ![Arduino 101](images/01020-Arduino101.png)

1. Remove the Grove Base Shield from the Grove Starter Kit and attach it to the Arduino 101:

    ![Grove Base Shield](images/01030-AttachGroveBaseShield.png)

1. **IMPORTANT:** Ensure the base shield's voltage selector switch is set to 5V (move the VCC switch to the right):

    ![Base Sheild set to 5V](images/01040-BaseShield5V.png)

1. Connect the LCD screen to any I2C socket and rotary angle to A0 socket with a grove connector cable as shown below, the cables are in the green box:

    ![Rotary Encoder and LCD](images/01050-RotaryEncoderAndLCD.png)
    ![Rotary Encoder and LCD Attached](images/01060-RotaryEncoderAndLCDAttached.png)

1. Connect the Arduino 101 to the Intel IoT Gateway using the USB cable provided:

    ![Attach Arduino 101](images/01070-AttachArduino101.png)

1. Connect the Intel IoT Gateway to Ethernet and Power:

    ![IoT Gateway Ethernet and Power](images/01080-IoTGatewayEthernetAndPower.png)

1. Press the power button on the IoT Gateway to boot it.  It will take about two minutes or so for the device to boot.  Once it has booted the default Node-RED flow on the gateway will run and display the Gateway's IP Address on the LCD panel attached to the Arduino 101.  ***The IP Address displayed is the IP Address of your Intel IoT Gateway NUC.  You will use this to attach to your gateway throughout the rest of this lab.***

    <blockquote>
        <strong>Note</strong>: If you do not see your IP address within about <strong><em>five minutes</em></strong> (make sure you give the NUC plenty of time to boot), you can try the following:
        <ul>
        <li>Ensure that the network cable is connected properly and that it is connected to a network with Internet Access.  If you re-connect the cable wait at least one minute to see if the IP Address appears on the LCD.  The default flow only updates the display of the address once every minute.</li>
        <li>If you still don't see an IP Address, you can try re-booting it by pressing the powerbutton until the light turns off, then turning it back on again.</li>
        </ul>
    </blockquote>

    ![IP Address on LCD Panel](images/01090-IPAddressOnLCD.png)

1. Once the IP Address has been displayed, wait another two minutes and then open your browser and go to the IP Address from the previous step (`http://your.nucs.ip.address:1880` where `your.nucs.ip.address is` the IP Address from above). 
___

<a name="Blinky"></a>
Blinking an LED with Node-RED
---

In this exercise, you will use the Node-RED development environment pre-installed on the Intel IoT Gateway to blink the onboard LED on your Arduino 101.

1. To open the Node-RED development environment on your IoT Gateway:

    - In your browser, navigate to `http://your.nucs.ip.address:1880` where `your.nucs.ip.address is` your gateway's IP Address.
1. The Node-RED environment will show the default "**Flow 1**" workflow that is responsible for retrieving your gateway's IP Address and displaying it on the LCD panel as well as reading the value from the rotary angle sensor, changing the background color of the RGB LCD based on the sensor value, and displaying it in the charts on the IoT Gateway web portal.  Leave this flow as is for now.

    ![Node-RED Environment](images/04020-NodeRedEnvironment.png)

1. The Node-RED Environment can be used to create IoT workflows.

    ![Node-RED Environment Layout](images/04030-NodeRedEnvironmentLayout.png)

1. To create a new flow, click the "**+**" button to the right of the "**Flow 1**" tab along the top of the Visual Editor.  A new flow, named "**Flow 2**" will open on a new tab.

    ![Create Flow 2](images/04040-CreateFlow2.png)

1. From the "**UPM_Sensors**" group in the nodes panel, drag the "Grove LED" node into the visual editor.

    ![Add Grove LED node](images/04050-AddGroveLEDNode.png)

1. Double-click on the "**Grove LED**" node in the visual editor.  A window will open to allow you to edit the properties of the node:  Set the properties as follows, the click "**OK**" to save the changes.

    - Name: **Blinky**
    - Platform: **Firmata**
    - Pin - **D13**
    - Mode - **Blink**
    - Interval(ms) - **1000**

    ![Blinky Properties](images/04060-BlinkyProperties.png)

1. Click the "**Deploy**" button in the top right corner of the Node-RED environment to deploy the new flow.

    ![Deploy Blinky](images/04070-DeployBlinky.png)

1. Once the flow has been deployed, the LED onboard the Arduino 101 will start blinking on and off in one second (1000ms) intervals.

    > **Note**: With the Grove Base Shield attached to the Arduino, the LED will be difficult to see.  You will need to peek under the shield to see the LED on the Arduino 101 blinking on and off.

    ![Arduino 101 LED](images/04080-Arduino101LED.png)

1. In the Node-RED Visual Editor you can also see the "Blinky" node's status change with the "**OFF**" and "**ON**" indicator below it:

    ![Blink Node Statuts](images/04090-BlinkyNodeStatus.png)

 > **Note**: When connecting the Intel Iot Gateway to an Arduino 101, the gateway uses a subplatform called Firmata to communicate GPIO requests to the Arduino 101.
Firmata is a generic protocol for communicating with microcontrollers from software on a host computer. It is intended to work with any host computer software package.  Basically, this firmware establishes a protocol for talking to the Arduino from the host software.

___

<a name="ReadingTemperatures"></a>
Reading the Temperature Sensor
---

Now that you have a basic understanding of how to interact with the Gateway. Let’s move on to adding some more sensor data and processing to the gateway.
We will create Node-RED flow to get data from temperature sensor and display it in the debug panel. We will be extending this flow to send data to Azure IoT hub later.

1. Attach the **Grove Temperature Sensor** to the **Grove Base Shield** port **A1**
 using one of the supplied cables.

    ![Attach Temperature Sensor](images/05010-AttachTemperatureSensor.png)

1. In the Node-RED environment, create a new flow named "**Flow 3**"

    ![Create Flow 3](images/05020-CreateFlow3.png)

1. From the "**UPM_Sensors**" group in the nodes panel, drag a "**Grove Temperature Sensor**" into the visual editor for "**Flow 3**". Then double click on the new node, and set the properties as follows.  Click the "**OK**" button to save the changes:

    > **Note**: The interval of 10000ms really means the temperature will only update once every 10 seconds.  You can speed that up by lowering the number to 5000ms or even 1000ms, but later when we are publishing data to Azure it might be better to publish less frequently just to help reduce network traffic and resource utilization in Azure.

    - Name - **Leave Blank**
    - Platform - **Firmata**
    - Pin - **A1**
    - Unit - **Celsius**
    - Interval (ms) - **10000**

    ![Add Grove Temperature Sensor](images/05030-AddGroveTemperatureSensor.png)

1. From the "**function**" group add a "**function**" node to "**Flow 3**" and place it next it to the existing "**Temperature**" node as shown below.  Double click on the new "**function**" node and complete the properites as follows.  Click the "**OK**" button to save the changes:

    > **Note**: The purpose of this function is to provide the correct temperature when the sensor is being read with a 5V source. The "Grove Temperature" node assumes 3.3v by default.

    - Name - **Data Conversion**
    - Function - **Use the following code**

        ````javascript
        msg.payload = msg.payload * 3.3 / 5
        return msg;
        ````

    - Outputs - **1**

    ![Data Conversion Function](images/05040-AddFunctionNode.png)

1. Connect the existing "**Grove Temperature**" node to the new "**Data Conversion**" function node by dragging a line from the square box on the right edge of the "**Grove Temperature**" node to the square box on the left edge of the "**Data Conversion**" node.

    ![Connect Nodes](images/05050-ConnectNodes.png)

1. Add the following nodes, configure them as follows, and connect them as shown below:

    > **Note**: The "**Create Payload**" function creates the data payload that will eventually be sent up to the Azure IoT Hub.

    - From the "**function**" group, another "**function**" node.
        - Name - "**Create Payload**"
        - Function - **Use the following code**

            ````javascript
            var gateway = "IntelIoTGateway";
            return {
                payload: {
                    deviceID: gateway,
                    timestamp: new Date().toISOString(),
                    temperature: msg.payload
                }
            };
            ````
        - Outputs **1**
    - From the "**function**" group, add a "**json**" node.  No configuration is necessary.
    - From the "**output**" group, add a "**debug**" node.  No configuration is necessary.

    ![Flow 3 Nodes](images/05060-Flow3Nodes.png)

1. Go ahead and deploy the new flow by clicking on the "Deploy" button in the top right corner of the Node-RED window:

    ![Deploy](images/05065-Flow3Deploy.png)

1. Finally, we can test the new flow.
    - Ensure you are on the "**Flow 3**" tab
    - Click on the "**Debug**" tab to view debug messages generated by the green "**msg.payload**" debug node.
    - Click the "**Trashcan**" icon at the top of the debug tab to clear any existing debug messages.
    - Watch for the debug messages to appear on the "**debug**" tab.
    - If you are not seeing debug messages, ensure that the "**msg.payload**" debug node has its debug messages enabled:

        - Debug messages are enabled, and will appear on the "**debug**" tab:

        ![Debug messages enabled](images/05080-DebugMessagesEnabled.png)

        - Debug messages are disabled, and no messages will appear on the "**debug**" tab.

        ![Debug messages disabled](images/05090-DebugMessagesDisabled.png)

    <!-- markdownlint-disable MD028 -->

    > **Note**: If you can't see the entire debug message on the debug tab, you can drag the splitter bar between the "**Visual Editor**" and "**debug**" tab panels to expand the view, or you can scroll to the right on the "**debug**" tab using the horizontal scroll bar at the bottom of it.  Also, remember that the "**Grove Temperature**" node is only publishing a sensor value once every **10 seconds** (10,000ms) so you need to wait at least that long to see anything appear.

    > **Note**: You can touch the temperature sensor (or blow on it) to see the value of the "**temp**" displayed change on the "**debug**" tab.

    <!-- markdownlint-enable MD028 -->

    ![Flow 3 Debug Messages](images/05110-Flow3DebugMessages.png)

1. Ok, so seeing the debug messages is interesting, but it would be cooler if we could see the temperatures displayed on the LCD panel. To do that, from the **UPM_Sensors**, drag the "**Grove RGB LCD**" on to the Visual Editor as shown below, connect it to the output of the "**Data Conversion**" node, and configure it as follows:

    > **Note:** the RGB value is being set to green, and that means that when the temperature is displayed, the background color on the LCD panel will change to green for 1 second.

    - Name - "**Show the Temperature**"
    - Platform - "**Firmata**"
    - R - "**0**"
    - G - "**255**"
    - B - "**0**"
    - Cursor Row - "**1**"
    - Cursor Column - "**0**"

    ![Display Temp on LCD](images/05120-DisplayTempOnLcd.png)

1. Click the "**Deploy**" button to deploy the updated flow:

    ![Deploy the updated flow](images/05130-DeployFlow.png)

1. And now the LCD Panel should flash green, and update the display to show the current temperature on the second row of text.

    ![Current temp on the LCD](images/05140-TempOnLcd.png)

1. If you are having problems with your flow, you can get a copy of a working version of the flow from the <a target="_blank" href="./Node-RED%20Flows/Flow%203%20-%2001%20-%20Temperature%20on%20LCD.json">Node-RED Flows/Flow 3 - 01 - Temperature on LCD.json</a> file in the lab files.  To use it:

    ***YOU DO NOT NEED TO DO THESE STEPS UNLESS YOU ARE HAVING A PROBLEM AND WANT TO IMPORT WORKING CODE***

    - You should first delete the nodes you have by selecting them all, and pressing the "**Delete**" key on your keyboard.

        ![Select all nodes](images/05143-SelectAllNodes.png)

        you can tell that nodes are "selected" when they have an orange border:

        ![Select nodes have an orange border](images/05146-SelectedNodesOrangeBorder.png)

    - Open the "**<a target="_blank" href="./Node-RED%20Flows/Flow%203%20-%2001%20-%20Temperature%20on%20LCD.json">Node-RED Flows/Flow 3 - 01 - Temperature on LCD.json</a>**" file in the code editor of your choice, and ***copy its contents to your computer's clipboard***.

    - In the Node-RED editor, from the "Hamburger" button in the top right corner, select "**Import**" | "**Clipboard**"

        ![Import flow from clipboard](images/05150-ImportFromClipboard.png)

    - In the "**Import nodes**" window, paste the json you copied, and then press "**OK**".

        ![Paste flow code](images/05160-PasteFlowCode.png)

    - Drag the newly imported nodes to where you want them in the Visual Editor

___

<a name="PlanningAzure"></a>
Planning your Azure Resources
---

<a target="_blank" href="http://azure.com">Microsoft Azure</a> provides an incredibly powerful and flexible backend for your IoT solutions.  In this lab, we will configure a robust collection of services to mimic the real world solutions you may implement yourself.  With the number of services we will configure, it is helpful to first understand what those services are, and to gather the configuration details we will need for them in advance.  Having done so, the configuraiton of the services themselves will be much easier.  By being consitent on how we organize our resources as well as where we deploy them and how we name them, our job of working with them and managing them is made much simpler.

The following diagram provides an overview of the architecture we will be implementing:

![Lab Architecture](images/00000-LabArchitecture.jpg)

### Common Resource Group ###

We will be placing all of the azure resources we provision in this lab into a single "**Resource Group**" (<a target="_blank" href="https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/#resource-groups">link</a>).  Resource groups are a core concept in the "**Azure Resource Manager**" (<a target="_blank" href="https://azure.microsoft.com/en-us/documentation/articles/resource-group-overview/">link</a>) technology used by the Azure platform.  Resource Groups allow you to keep all the resources related to a solution in a single organizational container.  This in invaluable when securing, deploying, and removing the resources.

### Common Location or "Region" ###

We want to make sure to deploy all of the resources we create into the same Azure data center, or "**Region**" (<a target="_blank" href="https://azure.microsoft.com/en-us/regions/">link</a>). This will help to ensure that the resources have low latency connections to each other (for example, the web application can directly access the sql database), as well as keep our costs low by reducing the amount of data leaving a the data center and incurring any data egress charges.

That means that we need to select a region that supports all of the services we will use in our solution.  You can review the list of <a target="_blank" href="https://azure.microsoft.com/en-us/regions/services/">Products available by region</a> to verify that the services required by this lab are available in the region you want to use. The services used in this lab inclue:

- Azure IoT Hubs
- Azure Stream Analytics
- Azure Event Hubs
- Azure Storage
- Azure SQL Database
- Azure Web Apps

<a name="locations"></a>
At the time this is being written (October 2016), the following regions have all of the required services. **THIS LIST WILL GROW OVER TIME**. You are welcome to review the <a target="_blank" href="https://azure.microsoft.com/en-us/regions/services/">Products available by region</a> to see if any additional regions provide the resources needed.  Otherwise, simply pick the region from the list below that is closest to you, and ensure that you choose that region for each resource you deploy.

- West US
- North Europe
- West Europe
- Southeast Asia
- Australia Southeast

### Common Naming Convention ###

We will be provisioning a number of resources in this lab.  Some of these resources require globally unique names.  In addition, we need to be able to refer to those resources in the lab documentation.  To facilitate that, it is ***strongly recommended*** that you juse the naming convention outlined here.  In the architecture diagram above, you will see that resources have been named with a ***`<name>`*** prefix, and then some resource specific name.

Choose a ***`<name>`*** prefix that is unique to you.  It is recommended that you use something like your initials.  For example if your name where "**Jane Q. Doe"** you might select "**jqd**" as your name prefix. To add a little more uniqueness you could add in your two digit birth month.  For example, if Jane was born in "**October**" she might use "**jqd10**".  **Some resource names must be at least six characters or longer.  Having a prefix that is 4-6 characters long will help ensure our names meet the minimum length.**

You can choose anything you like, but it must help create unique names, and it should be short because you'll be typing it a fair amount.

For the purposes of this lab's examples, we'll use the "**mic16**" prefix, short for "**Microsoft Intel Camp 2016**".

**DO NOT USE THE _"mic16"_ PREFIX FOR YOUR OWN RESOURCES**.

### Service Descriptions ###

The following table is a summary of the Azure services you will create in the lab, to help you better understand the role of each service. **DO NOT rush into creating these services on your own**. We will walk through step-by-step instructions in the sections below.

| Service | Name | Description |
| ------- | ---- | ----------- |
| The Device | Intel NUC, Arduino 101 & Grove Sensors  | The Intel NUC is our "Device".  It get's sensor values from the Arduino 101 and Grove sensors that are attached.  We use an easy graphical development environment called "Node-RED" on the NUC to help the NUC send messages with sensor data to the cloud, as well as to receive messages from the cloud and act on them.  |
| Resource Group | ***&lt;name&gt;group*** | Azure Resource Groups provide a convenient way to organize all of the Azure resources for a solution into a single container.  The Resource Group can then be a unit of deployment, a securable collection, and an easy way to delete all of the resources in the group in a single operation.  We want to make sure that all of the resources we create in this lab are placed in the ***&lt;name&gt;group*** resource group.|
|  IoT Hub | ***&lt;name&gt;iot*** | Provides a way for devices (like the Intel NUC with Arduino 101 in our lab) to send and receive messages in the cloud.  Backend services can read those messages sent by our devices, act on them, and send messages back to the device as needed. |
| IoT Hub Device Identity | ***&lt;name&gt;IntelIoTGateway*** | This is the id we will use for our device's identity in the Azure IoT Hub Device Identiy Registry.  Normally you would use a system generated globally unique value like a GUID for your device identities, but for the lab it will be much easier if we use a friendlier human readable name.   |
|  Stream Analytics Job | ***&lt;name&gt;job*** | The Azure Stream Analytics Job provides a way to watch messages coming into the Azure IoT Hub from our devices and act on them.  In our case it will forward all messages off to a SQL Database so we can report on them, but it will also watch the temperature sensor values in those messages, and forward them to an Event Hub if they exceed a pre-defined threshold temperature.
| SQL Server |  ***&lt;name&gt;sql*** | The Azure SQL Server instance will host our Azure SQL Database. Other than creating it to host our database.  This is also where the administrative login for our SQL Server is defined, as well as the server level firewall rules that we will configure to allow connections from the Internet. |
| SQL Database |  ***&lt;name&gt;db*** | This will store the **dbo.Measurement** table and a couple of views.  The Stream Analytics Job above will forward all temperature messages sent to the IoT Hub into this table, and the Web Application and Power BI Embedded Reports will then query that data to provide reports on the temperature data. |
| Event Hub Namespace |  ***&lt;name&gt;ns*** | This is the Service Bus Namespace that hosts our Event Hub.  We really won't do much with this directly, we just need one to host our Event Hub for us.   |
| Event Hub | ***&lt;name&gt;alerts*** | The Event Hub is an internal messaging queue that we will use to pass along temperature alert messages.  The Stream Analytics Job will watch for temperature messages with sensor values that exceed a predefined temperature threshold and forward them off to this event hub.  We'll then create an Azure Function to read the messages out of this event hub and send alerts back to the device.  |
| Storage Account |  ***&lt;name&gt;storage*** | A few of the services require a storage account for their own purposes.  This account exists purely as a resource for those services.  We won't use it directly for our own purposes. |
| App Service Plan |  ***&lt;name&gt;plan*** | The App Service plan provides the execution environment (servers) for our Web App and Function App.  We can scale our App Service Plan up or down as needed to get give those services the resources they require to perform as desired.  |
| Web App |  ***&lt;name&gt;web*** | The Azure Web App is where we will deploy our Node.js application that provides the web site for our solution.  We can then go to this site to view temperatures from our devices queried from the SQL Database |

### Documenting Your Choices ###

We'll document the choices, names, connection strings, keys, etc. for the resources we create into a text file called "**[myresources.txt](./myresources.txt)**".  This file is in the root of the "**HOLs/**" folder wherever you copied or extracted the lab files for this lab to.  By documenting key pieces of information here it will make it much easier to retrieve them later.  You often need a connection string, or key for a resource long after you created it.  By recording the values here it keeps you from having to navigate back through the **Azure Portal** everytime you need to retrieve a value.

You could really edit "**myresources.txt**" with any text editor, but we'll be using **Visual Studio Code** for a number of tasks throughout this lab, so we'll take the opportunity here to get it open:

1. Open Visual Studio Code (if you don't have it installed you can download it for free for any platform from <a target="_blank" href="http://code.visualstudio.com">code.visualstudio.com</a>).

1. From the Visual Studio Code menu bar, select "**File**" | "**Open Folder...**", navigate to the folder where you extracted the lab content for this workshop, and select the "**HOLs**" folder.

1. In the "Explorer" panel, click on the "**myresources.txt**" file to open it. In the file, you can see numerous placeholders for information you will be collecting throughout this lab:

    ![Documenting Your Choices](images/06010-DocumentingYourChoices.png)

    > **Note**: You may notice that the colors used by your instance of "**Visual Studio Code**" don't match the colors shown in the screenshots in this documentation.  The screenshots here were taken with **Visual Studio Code**'s "**Color Theme**" set to "**Light+ (default light)**".  If you want to change yours to match (not required), from the "**Visual Studio Code**" menu bar select "**File**" | "**Preferences**" | "**Color Theme**", then in the command pallete drop down, select "**Light+ (default light)**".

    ![Light Color Theme](images/06015-DefaultLigtColorTheme.png)

1. Take the time now to update the **myresource.txt** file with appropriate values for the:

    > **Note**: when replacing placeholders throughout the lab, make sure to remove the **`<`** and **`>`** symbols at the ends of the placeholder as well.

    - Naming convetion prefix
    - Region (data center)
    - Resource Group Name

    ![Naming Convetion, Region & Group Section](images/06020-ConvetionRegionAndGroupSection.png)

    For example, here's the section with the "**mic16**" prefix, and "**West US**" region selected:

    ![Naming Convention, Region & Grou Documented](images/06030-ConventionRegionAndGroupDocumented.png)

___

<a name="CreateIoTHub"></a>
Creating an Azure IoT Hub
---

In this task, we'll create the ***&lt;name&gt;iot*** Azure IoT Hub and since it's our first Azure resource, we'll create the ***&lt;name&gt;group*** resource group to put it in.  Make sure that you understand the information in the [Planning your Azure Resources](#PlanningAzure) section before continuing.

1. Open the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>) and login to your subscription.  If you don't have a current Azure Subscription you can create a <a target="_blank" href="https://azure.microsoft.com/en-us/free/">free trial</a>.

1. Click the "**+ New**" button, then select "**Internet of Things**", and select "**Iot Hub**"

    ![New IoT Hub](images/07010-NewIoTHub.png)

1. Complete the properties for the new IoT Hub as shown below, the click the "**Create**" button to provision the new IoT Hub in the new Resource Group:

    - Name: ***&lt;name&gt;iot*** - Use the naming prefix you selected in the [Planning your Azure Resources](#PlanningAzure) section.
    - Pricing and scale tier: **S1 - Standard**  (There is a free tier, but we will be removing these resources at the end of the lab, and the S1 pricing teir should not impact your subscription significantly)
    - IoT Hub units: **1**
    - Device-to-cloud partitions: **4**
    - Subscription: **choose the subscription you wish to use if you have multiple available**
    - Resource Group: **Create new** resource group using the ***&lt;name&gt;group*** naming convention
    - Location: **Choose the location [listed above](#locations) that is closest to you, and then make sure to use that location for all other resources in the lab**
    - Pin to dashboard: **Checked** (this will place a tile for the IoT Hub on your portal dashboard.)

    > **Note**: The "**Enable Device Managent-PREVIEW**" option will likely not be there.  This screen shot was taken when that feature was still in preview.

    ![New IoT Hub Properites](images/07020-NewIoTHubProperites.png)

1. ***The IoT Hub could take five minutes or longer to deploy***.  While it is deploying, a tile will be shown on your portal dashboard that looks like this:

    ![IoT Hub Deploying Tile](images/07030-IoTHubDeployingTile.png)

1. Once the deployment is complete, the "**blade**" for your IoT Hub should open in the portal.

    ![IoT Hub Blad](images/07040-IoTHubProperties.png)

1. In order to connect to your IoT Hub from client applications, you need to know the name and key for a "Shared Access Policy" (SAS Policy) that provides your client application the necessary privileges.  Your IoT Hub comes pre-provisioned with a number of  SAS policies that you can use, or you can create additonal policies as needed.  In this lab we will use two of the default SAS policies.

    - "**iothubowner**" - This policy allows applications that connect with it full access to the IoT Hub.  They can manage devices registered with the hub, as well as send and receive messages.  We will use this SAS policy when we want to manage our IoT Hub.
    - "**service**" - This policy is intended for back-end services or client applications that need to interact with devices via the IoT Hub.  These applications need to be able to receive messages coming into the hub from devices in the field ("**Device-to-Cloud**" messages), as well as send messages back to those devices ("**Cloud-to-Device**" messages).  This policy is granted the "service connect" permission which allows it to do just that.

1. In the portal, with your IoT Hub blade open, click on the "**Shared access policies**" along the left edge to see the hub's SAS policies:

    ![SAS Policies Link](images/07050-SASPoliciesLink.png)

1. Click on the "**iothubowner**" policy name to see its details, then click on the ![Copy Icon](images/00000-CopyIcon.png) icon to the right of the "**Connect string - primary key**" to copy the connection string to your clipboard.

    ![iothubowner SAS Policy](images/07060-IoTHubOwnerPolicy.png)

1. Update the the "**[myresources.txt](./myresources.txt)**" file with the "***&lt;name&gt;iot***" iot hub name, and "**iothubowner**" connection string so you can retrieve them easily later.

    ![Document iothubowner Connection String](images/07070-DocumentIoTHubOwnerConnectionString.png)

1. Repeate the last two steps to copy and document the "**service**" SAS policy primary connection string:

    > **Note**: Make sure to save the changes to the **[myresources.txt](./myresources.txt)**" file each time.

    ![service SAS policy](images/07080-ServiceSASPolicy.png)

    ![Document service SAS policy connection string](images/07090-DocumentServicePolicyConnectionString.png)

1. The last thing we need to do to configure our IoT Hub is to add a "**Consumer Group**" for the ***&lt;name&gt;job*** Stream Analytics Job to use as it reads messages from the IoT Hub.

    > **Note**: Consumer groups enable multiple consuming applications to each have a separate view of the event stream, and to read the stream independently at their own pace and with their own offsets. In a stream processing architecture, each downstream application equates to a consumer group.  By creating a consumer group specifically for the Stream Analytics Job, it allows us to use other tools (like iothub-explorer) to monitor messages using the **$Default** consumer group, and not conflict with the Stream Analytics job. Basically each consumer group allows you to run a different application (or pool of consumers) on the hub and allow each application to receive their own copy of the messages.

    - Click on the "**Endpoints**" link along the left, then click on the "**Events**" endpoint

    ![Open the Events Endpoint](images/07095-OpenEventsEndpoint.png)

    - In the "**Properties** blade for the "Events" endpoint, at the bottom, enter the following name into the empty box below the **$Default** consumer group:

        `streamanalytics`

    - Click the "**Save**" button at the top of the "**Properties**" blade to save the new consumer group, and close the "**Properties**" blade.

    ![Create streamanalytics Consumer Group](images/07100-StreamAnalyticsConsumerGroup.png)

___

<a name="CreateIoTHubDeviceIdentity"></a>
Creating an Azure IoT Hub Device Identity
---

Now that we have our Azure IoT Hub created, we want to create an entry in the hub's device identity registry.  A "device identity" in the IoT Hub's device identity registry is basically a unique id and access key that can be used by the actual device in the field (The Intel NUC and with Arduino 101 in our case) to connect to the IoT Hub.  The connection string for the device entry in the registry will be used by the actual device to securely connect to the IoT Hub and send and receive messages as that device.  You can learn more about Azure IoT Hub devices in the "**<a target="_blank" href="https://azure.microsoft.com/en-us/documentation/articles/iot-hub-devguide-identity-registry/">Identity registry</a>**" article online.

There is a graphical tool for Windows called "**Device Explorer**".  We won't document its use here in this lab, but if you are on Windows and wish to try it can you can download it from here <a target="_blank" href="https://github.com/Azure/azure-iot-sdks/releases/latest">github.com/Azure/azure-iot-sdks/releases/latest</a> (look for the first "**SetupDeviceExplorer.msi**" link) and learn more about it here: <a target="_blank" href="https://github.com/Azure/azure-iot-sdk-csharp/blob/master/tools/DeviceExplorer/readme.md">How to use Device Explorer for IoT Hub devices</a>.

1. Goto **<a target="_blank" href="https://portal.azure.com">Azure Portal</a>**. 

1. Find and click "**Device Explorer**" from EXPLORERS menu of Azure IoT Hub.

    ![Add Device Identity from portal](CreateIoTDeviceID/iotdevid_1.png)

1. Click **+ Add** button at the top:

    ![Add Device Identity from portal](CreateIoTDeviceID/iotdevid_2.png)

1. Now name the device, leave options as default and click "**SAVE**" at the botton.

    ![Add Device Identity from portal](CreateIoTDeviceID/iotdevid_3.png)
    
1. When it is added successfuly you can see the name of the devie on the portal.

    ![Add Device Identity from portal](CreateIoTDeviceID/iotdevid_4.png)

1. If you click the name of the device you can see the detail information such as connection strings.

    ![Add Device Identity from portal](CreateIoTDeviceID/iotdevid_5.png)

1. Copy the connection string for the new device from the command output, and document it along with your device id in the "**[myresources.txt](./myresources.txt)**" file:

    ![Document Device Identity](images/08030-DocumentDeviceIdentity.png)
___

<a name="PublishToIoTHub"></a>
Publishing Temperature Sensor Data to the Azure IoT Hub
---

1. ***from your computer*** open the Node-RED development environment in the browser (Remember you can just point your browser to port 1880 on your NUC, eg: `http://your.nucs.ip.address:1880` where `your.nucs.ip.address is` your NUC's IP Address).  If you already had it open, make sure to refresh it.  In the list of nodes on the left, you should see a new "**cloud**" category, and within it the "**azureiothub**" node:

    <blockquote>
      <strong>Note</strong>: if the "<strong>cloud</strong>" category and "<strong>azureiothubnode</strong>" node don't appear, you may need to manually install the "<strong>node-red-control-azureiothubnode</strong>" package on the NUC.  If that is necessary, ssh into the NUC, and from the prompt run the following two commands:<br/>
      <pre><code class="lank-bash">npm install -g node-red-contrib-azureiothubnode</code></pre>
      <pre><code class="lank-bash">systemctl restart node-red-experience</code></pre>
    </blockquote>

    ![New azureiothubnode](images/09080-AzureIoTHubNode.png)

1. Open the "**[myresources.txt](./myresources.txt)**" file, and copy the "**IoT Hub Device Connection String**" you pasted in after creating the Azure IoT Hub Device Identity.

    > **Note**: Make sure to copy the "**IoT Hub Device Connection String**" and not the connection strings for the "iothubowner" or "service" SAS policies.  You'll know you have the right one if you can see the "**`DeviceId=<name>IntelIoTGateway`**" device id (or whatever device Id you used) that you created earlier.

    ![Copy IoT Hub Device Connection String](images/09100-CopyDeviceConnectionString.png)

1. Drag the "**azureiothub**" node onto the Node-RED visual editor, connect it to the "**json**" node's output as shown below, configure it as follows, and click "**OK**"

    - Name - "**Azure IoT Hub**"
    - Protocol - "**HTTP**"
    - Connection String - **Paste in the "IoT Hub Device Connection String" you just copied from "[myresources.txt](./myresources.txt)"**.  Again, make sure it's the connection string with that contains your "**`DeviceId=<name>IntelIoTGateway`**" device id we created earlier.

    ![Add azureiothub Node to the Flow](images/09090-AddAzureIoTHubNode.png)

1. Next, double click on the "**Create Payload**" node. This function generates the actual JSON message that will be sent to the Azure IoT Hub. We will want to be able to retrieve the actual device id from that payload later, so we want to update it to use the device ID we created in our Azure IoTadventurous Hub Device Identity registry previously.

    - Replace the default "**IntelIoTGateway**" name with the "***&lt;name&gt;IntelIoTGateway***" you created (It should match the "**`DeviceId=<name>IntelIoTGateway`**" device id value in the connection string you used above, then click "**OK**"

    ![Edit DeviceId in Create Payload](images/09110-EditDeviceIdInCreatePayload.png)

1. Click the "**Deploy**" button to deploy the changes.  At this point, the Node-RED flow on the NUC should begin publishing Temperature data to your Azure IoT Hub as your `<name>IntelIotGateway` device.

    ![Deploy the Changes](images/09120-DeployChanges.png)

1. Remember that we had the Node-RED flow only getting temperatue values once every 10 seconds (10000ms).  It is recommended that you don't publish too much more frequently during this event.  It just helps to reduce the amount of traffic on the network.

___

<a name="ProcessingWithStreamAnalytics"></a>
Processing Temperature Data with Stream Analytics
---

Now that we have messages making it into our Azure IoT Hub from our device, we can start to process those messages in the cloud.

In the [Planning your Azure Resources](#PlanningAzure) section, we discussed the ***&lt;name&gt;job*** Stream Analytics Job and its two outputs, the ***&lt;name&gt;db*** SQL Database and the ***&lt;name&gt;alerts*** Event Hub.  It's much easier to configure the Stream Analytics job if it's outputs already exist.  So we'll start by creating those resources first.

### Creating the Azure SQL Database ###

We'll start out creating the ***&lt;name&gt;sql*** Azure SQL Server, and the ***&lt;name&gt;db*** database on it.  The ***&lt;name&gt;job*** Stream Analytics job will forward ALL of the messages that come into the Azure IoT Hub from our device off to the "**dbo.Measurement**" table inside the database. We can then query that table for reporting purposes, or whatever!

1. In your web browser, login to the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>)

1. If you have any blades open from before, you can close them by clicking the "X" icon in their top right corner.

1. Click "**+ New**" | "**Databases**" | "**SQL Database**"

    ![New SQL Database](images/10010-NewSQLDatabase.png)

1. In the properties blade for the new SQL Database, complete the following fields, ***but don't click create yet***, we still need to configure our new Azure SQL Server and select a pricing tier:

    - Database name - ***&lt;name&gt;db***
    - Subscription - **Choose the subscription you used for your Azure IoT Hub**
    - Resource group - Choose "**Use existing**" and select the ***&lt;name&gt;group*** we created when provising the Azure IoT Hub.
    - Select source - "**Blank database**"
    - Want to use SQL elastic pool? - "**Not Now**" (this option was made available after the screen show below was captured).  Just make sure to not enable it if the option is visible for you.
    - Collation - Leave it at the default "**SQL_Latin1_General_CP1_CI_AS**"

    ![New SQL Database Properties](images/10020-NewSqlDbProperties.png)

1. Next, click  the "**Server | Configure require settings**", the "**Create a new server**" and complete the "**New server**" properties as follows, the click the "**Select**" button to select the new server:

    > **Note**: Pay attention to the "Server admin login" and "Password" you use.  It's recommended that you keep the values shown below and not use your own.  If you change them, you will need to make sure to use them in all of the subsequent places where these values are assumed.

    - Server name - ***&lt;name&gt;sql***
    - Server admin login - **`sqladmin`**
    - Password - **`P@ssw0rd`** (Captial "`P`", an "`@`" instead of an "a" and a zero, "`0`", instead of an "o")
    - Confirm Password - **`P@ssw0rd`**
    - Location - **Select the same region you provisioned the Azure IoT Hub into**
    - Create V12 server - **Yes** (if it is present.  If the option doesn't appear, V12 is assumed)
    - Allow azure services to access server: **Checked**

    ![New SQL Server Properties](images/10030-NewSQLServerProperites.png)

1. Click "**Pricing tier**", then find and select the "**B Basic**" pricing tier, and click the "**Select**" button to select it.

    ![Basic Pricing Tier](images/CreateSQLDB_1.png)

1. Finally, we can create the new Azure SQL Database and Server.  Ensure that the "**Pin to dashboard**" checkbox is **checked**, and click the "**Create**" button to create them.

    ![Create Database and Server](images/10050-CreateDatabaseAndServer.png)

1. It'll take a few minutes to provision your new Azure SQL Server and Database, but when the deployment is done, the blade for the Database will open. When it does, click on the link to the server at the top of the blade:

    ![Click Server Link](images/10060-ClickOnServerLink.png)

1. Then on the blade for the SQL Server, click the "**Show firewall settings**" link:

    ![Show Firewall Settings](images/10070-ShowFirewallSettings.png)

1. On the "**Firewall settings**" blade, create a new firewall rule with the following settings, then click the "**Save**" button.

    > **Note**: This firewall rule allows traffic from anybody on the internet to access your SQL Server.  Normally, you would not do this.  We are doing it here in the lab environment to ensure network issues aren't a problem for us.  **DO NOT DO THIS ON YOUR PRODUCTION SERVER INSTANCES!**

    - Rule Name - **Everyone**
    - Start IP - **0.0.0.0**
    - End IP - **255.255.255.255**

    ![Everyone Firewall Rule](images/10080-EveryoneFirewallRule.png)

1. Go ahead and take a minute to document all of your SQL Database and SQL Server related information in the "**[myresources.txt](./myresources.txt)**" file.

    ![Document SQL](images/10085-DocumentSQL.png)

1. Click on the icon for the "**Explorer**" panel, select the "**SQL Database Scripts\Create SQL Database Objects.sql**" file.  Copy **all** queries from <a target="_blank" href="https://raw.githubusercontent.com/xlegend1024/MicrosoftIntelIoTCamp/master/HOLs/SQL%20Database%20Scripts/Create%20SQL%20Database%20Objects.sql">here</a>.

    ![SQL Tools Initialization](images/10147-SQLToolsInitialization.png)
    <blockquote>
The "**Create SQL Database Objects.sql**" script creates the following objects:
    - The "**dbo.Measurement**" table.  This table is structured to match the data being sent by the Node-RED flow Intel NUC.  It has the following columns:
        - "**MeasurementID**" is a dynamically generated ID for each row in the database.
        - "**deviceID**" is a nvarchar field that will store the device id sent by the device.
        - "**timestamp**" is a datetime field that will store the "**timestamp** generated on the Intel NUC when the message was created.
        - "**temperature**" is a float column that will store the temperature sensor values.
    - The "**dbo.RecentMeasurements**" view is used by the web application to display the 20 most recent messages.
    - The "**dbo.Devices**" view is used by the web application to display a row for each device, along with their latest reading
    </blockquote>
1. Goto **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>**, and select SQL DB management blade.  

1. Select **Tool** at the top.

    ![MS SQL Connect](images/CreateSQLDB_2.png)

1. Select **Query editor (preview)**.

    ![MS SQL Connect](images/CreateSQLDB_2.1.png)

1. Login using SQL Server authentication type.

    ![MS SQL Connect](images/CreateSQLDB_3.png)

1. Paste copied queries and run.

    ![MS SQL Connect](images/CreateSQLDB_4.png)

### Create the Stream Analytics Job ###

Great, now we have all the pieces that the ***&lt;name&gt;job*** Stream Analytics job needs.  We have the ***&lt;name&gt;iot*** Azure IoT Hub as the **input**, and the ***&lt;name&gt;db*** SQL Database and ***&lt;name&gt;alerts*** Event Hub as the **outputs**.  Now we just need to create our Stream Analtyics Job and wire it up!

1. In the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>), click "**+ New**" | "**Internet of Things**" | "**Stream Analytics job**"

    ![Create Stream Analytics Job](images/10270-CreateStreamAnalyticsJob.png)

1. In the "**New Stream Analytics Job**" blade, complete the properties as follows, then click the "**Create**" button.

    - Name - ***&lt;name&gt;job***
    - Subscription - **Chose the same subscription used for the previous resources**
    - Resource group - Choose "**Use existing**" and select the ***&lt;name&gt;group*** resource group created previously
    - Location - **Use the same location as the previous resources**
    - Pin to dashboard - **Checked**

    ![New ASA Job Properties](images/10280-NewASAJobProperties.png)

1. Once the new Stream Analytics Job has been deployed, its blade will open in the portal.  Click the "**Inputs**" tile on the blade to open the inputs for the job.

    ![Inputs](images/10290-Inputs.png)

1. Then at the top of the "**Inputs**" blade, click the "**+ Add**" button, and in the "**New Input**" blade configure the properties for the iothub input as follows, the click "**Create**":

    - Input alias - **iothub** (keep this name so you don't have to edit the query.  If you use a different name here, you'll have to edit the query to match it).
    - Source Type - **Data stream**
    - Source - **Iot hub**
    - Subscription - **Use IoT hub from current subscription**
    - IoT hub - ***&lt;name&gt;iot***
    - Endpoint - **Messaging**
    - Shared access policy name - **service**
    - Consumer group - **streamanalytics** (We made this back when we provisioned the IoT HUb)
    - Event serialization format - **JSON**
    - Encoding - **UTF-8**

    ![iothub Input Properties](images/10300-IoTHubInput.png)

1. Close the "**Inputs**" blade, then back on the job blade, click "**Outputs**"

    ![Outputs](images/10310-Outputs.png)

1. Then on the "**Outputs**" blade, click the "**+ Add**" button and in the "**New output**" blade complete the properties as follows then click the "**Create**" button:

    - Name - **sqldb** (As with the input above, it is recommended that you don't change this name.  The query assumes the name.  If you change the name here, you'll have to update the query to match.)
    - Sink - **SQL database**
    - Subscription - **Use SQL database from current subscription**
    - Database - ***&lt;name&gt;db***
    - Server name - **_&lt;name&gt;sql_.database.windows.net** (although you can't change it here, more just FYI)
    - Username - ***sqladmin@&lt;name&gt;sql***
    - Password - **P@ssw0rd**
    - Table - **dbo.Measurement**

    ![SQL DB Output Properties](images/10320-SQLDBOutputProperties.png)

1. Watch for the notification under the "**Notifications**" icon (bell) to verify that the connection test to the "**sqldb**" output was successful.  If it wasn't go back and fix what failed.

    ![Successful Connection](images/10330-SuccessfulConnectionTest.png)

1. Close the "**Outputs**" blade, and then back on the job blade, click the "**Query**" button.

    ![Query](images/10360-Queries.png)

1. Back in Visual Studio Code with the "**HOLs**" folder open, locate open the "**Stream Analytics\Stream Analytics Query.sql**" file and copy its contents to the clipboard, **OR** copy query from <a target="_blank" href="https://raw.githubusercontent.com/xlegend1024/MicrosoftIntelIoTCamp/master/HOLs/Stream%20Analytics/Stream%20Analytics%20Query.sql">here</a>.

    > **Note**: Stream Analytics uses a SQL like syntax for its queries.  It provides a very powerful way to query the data streaming through the Azure IoT Hub as if it were data in a table.  Pretty cool!

   ```
   SELECT    deviceID,    [timestamp] as [timestamp],    temperature
   INTO    sqldb
   FROM    iothub
   ```
1. Back in the browser, replace the default syntax in the query with the code you just copied, then click the "**Save**" button along the top.

    <blockquote>
      <<strong>Note</strong>: There are actually one query here.<br/>
      <ul>
        <li>The query all of the messages from the "<strong>iothub</strong>" intput and dumps them into the "<strong>sqldb</strong>" output.</li>
      </ul>
    </blockquote>

1. Close the "**Query**" blade, and back on the job blade, click the "**Error Policy** link along the left.  Change the policy to "**Drop**" and click the "**Save**" button along the top:

    ![Drop Errors](images/10385-DropErrors.png)

1. Click the "**Overview**" link along the left to return to the job's properities:

    ![Overview](images/10387-Overview.png)

1. Click the "**Start**" button along the top, select "**Now**" to have it start processing messages on from now on, and not ones in the past, the click "**Start**" button to start the job.

    ![Start the job](images/10390-StartJob.png)

1. It will take a few minutes for the job to start.  Watch for the notification that it started successfully.

    ![Job Started](images/10400-JobStarted.png)

1. At this point, we should have data being forwarded into our SQL Database.  We can verify that using Azure Portal **Query Editor (preview)**.  In Code, open the "**SQL Database Scripts\Query Measurement Data.sql**" file and copy the queries. Goto Azure portal, open SQL DB management blaze. Or copy from <a target="_blank" href="https://raw.githubusercontent.com/xlegend1024/MicrosoftIntelIoTCamp/master/HOLs/SQL%20Database%20Scripts/Query%20Measurement%20Data.sql">here</a>.

    ![Job Started](images/CreateSQLDB_2.png)
    
    ![Job Started](images/CreateSQLDB_2.1.png)
    
    ![Job Started](images/CreateSQLDB_3.png)
___

<a name="AzureWebApp"></a>
Displaying Temperature Data with Azure Web Apps
---

Now that we have our device message data being stored in our Azure SQL Database, let's use a web application to display that data!

We'll start by creating the Azure App Service Plan and Web App in the portal.

### Setup the Web App in Azure ###

1. Open the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>) in the browser.  and close any open blades from previous steps. Then click "**+ New**" | "**Web + mobile**" | "**Web App**"

    ![New Web App](images/11010-NewWebApp.png)

1. In the "**Web App**" blade fill the properties out as follows, ***but don't click Create yet! We need to configure the App Service Plan First***

    - App name - ***&lt;name&gt;web***
    - Subscription - **Chose the same subscription used for the previous resources**
    - Resource group - Choose "**Use existing**" and select the ***&lt;name&gt;group*** resource group created previously
    - App Insights - **Off**

    ![New Web App Properties](images/11020-WebAppProperties.png)

1. Click on the "**App Service plan/location"** then click "**Create New**"

    ![Create New Plan](images/11030-CreateNewPlan.png)

1. Then in the "**App Service plan**" blade complete the properties as follows, then click "**OK**"

    - App service plan - ***&lt;name&gt;plan***
    - Location - **Use the same location as the previous resources**
    - Pricing tier - Select "**B1 Basic**"

    ![App Service Plan Properties](images/11040-AppServicePlanProperties.png)

1. Finally, ensure that the "**Pin to dashboard**" checkbox is **checked** and click the "**Create**" button:

    ![Create Web App](images/11050-CreateWebApp.png)

1. Once the Web App is deployed, its blade will open in the portal.  When it does, click the "**Deployment options**" button along the left, then click "**Choose Source**" and then select **"Local Git Repository**":

    ![Setup git repo](images/11060-SetupGitRepo.png)

1. If you haven't setup your deployment credentials for your account subscription yet, you'll need to.  Click "**Setup connection**" and enter the credentials to use, and click "**OK**":

    > **Note**: If you are not prompted for your deployment credentials, then you have likely already set them for your subscription in the past.  You can go ahead and finish creating the deployment source, the after you have created it, use the "**Deployment Credentials**" link along the left side of your Web App blade to get to the same settings shown here.

    - Deployment user name - ***&lt;name&gt;user***
    - Password - **P@ssw0rd**
    - Confirm Password - **P@ssw0rd**

    ![Deployment Credentials](images/11070-DeploymentCredentials.png)

1. Then back on the "**Deployment source**" blade click "**OK**" to confirm the settings:

    ![Deployment Source Confirmation](images/11080-DeploymentSourceOk.png)

1. Click the "**Overview**" link along the left, hover of the "**Git clone url**, the click the "copy" icon that appears to copy it to your clipboard.

    ![Git Clone URL](images/11090-GitCloneUrl.png)

1. Finally, document all the settings for your web app in the "**[myresources.txt](./myresources.txt)**" file.

    ![Document Web App](images/11100-WebAppDocumentation.png)

### Debug the Node.js Web Application Locally ###

**YOU NEED TO OPEN A SEPARATE COPY OF VISUAL STUDIO CODE FOR THIS SECTION.  YOU SHOULD LEAVE THE EXISTING INSTANCE OF VISUAL STUDIO CODE OPEN SO YOU CAN EASILY GET TO THE MYRESOURCES.TXT FILE, BUT MAKE SURE THAT THE FOLLOWING STEPS DONE USING A SEPARATE INSTANCE OF VISUAL STUDIO CODE THAT IS POINTING AT THE "_HOLs/WebApp_" FOLDER DIRECTLY.**

The reason for this is that we are going to be using the Node.js Debugging and Git Integration capabilities of Visual Studio Code in this task to help us debug and deploy our Node.js Web Application.  These are awesome features built-in to Visual Studio Code, but they require that the "root" folder code is pointing at is both the root the application you wish to debug as well as the root of the git repository you want to manage.  For that reason, we need to open the **"HOLs/WebApp** folder directly in Visual Studio Code for these steps to work.

1. Open a new instance of Visual Studio Code. If you already have Visual Studio Code open, from the menu bar, select "**File**" | "**New Window**"

1. From the menu bar in the new instance select "**File**" | "**Open Folder...**" and find the "**HOLs\WebApp** folder under where you extracted the lab files.  Then inside that folder in VS Code, select the "**config.json**" file.

    ![config.json](images/11110-ConfigJson.png)

1. Use the values you've saved to the "**[myresources.txt](./myresources.txt)**" (the **myresources.txt** file should still be accessible in the original instance of visual studio code) to paste the required values into the config.json file. You can close the config.json when you are done.  **IGNORE THE POWERBI... SETTINGS. WE'LL GET TO THOSE LATER**

    > **Note**: The "**iotHubConnString** should be the one for your "**service**" SAS policy, that's the one with "**`SharedAccessKeyName=service`**" in it.  This web app doesn't "manage" your iot devices, it just communicates with them as a back end service and the "service" Shared Access Policy on our IoT Hub gives the web app all the permissions it needs. Additonally, the **sqlLogin** is just the Azure SQL Server Login, *NOT* the Qualified SQL Login (e.g. use **sqladmin**, not **sqladmin@mic16sql**).

    ![Update config.json](images/11120-UpdateWebAppConfigJson.png)

1. Next, click on the "**Debug**" icon along the left, then click the "**gear**" icon along the top to configure the debugger:

    ![New Debug Config](images/11125-NewDebugConfig.png)

1. When prompted, select "**Node.js**" as the environment

    > **Note**: If you are see an option for the "**Node.js v6.3+ (Experimental)**" **DO NOT** select it.

    ![Node.js debug environment](images/11140-NodeJsEnvironment.png)

1. In the "**launch.json**" file that appears, modify the "**program** path to point to the "**server.js**" file.  Then save and close the "**launch.json**" file.

    > **Note**: This tells the debugger to start with the **server.js** file in the root of our web application's folder.

    ![Start with server.js](images/11150-StartWithServerjs.png)

1. In Open a command prompt or terminal window, and change into the "**HOLs\WebApp** path.  From there, run the following commands:

    > **Note:** Bower requires that **git** is installed and configured.  Refer to the **[Prerequisites](#Prerequisites)** section for installation links and configuration steps.

    ```text
    npm install -g bower
    npm install
    ```
1. Back in VS Code, on the Debug panel, click the green "**play**" button along the top to start debugging the web app.

    ![Debug](images/11160-Debug.png)

1. On Windows, you may be prompted to verify the firewall configuration.  If so, select all networks, and click "**Allow access**":

    ![Firewall](images/11165-Firewall.png)

1. In the Debug Console (if your's isn't visible press **Ctrl+Shift+Y**), you should see that the app is running on [http://localhost:3000](http://localhost:3000)

    ![Listening on Port 3000](images/11170-ListeningOnPort3000.png)

1. In your browser, navigate to [http://localhost:3000](http://localhost:3000).  There are three main sections on the web page

    - The "**Temperature History**" shows the 20 most recent readings.  That data is coming directly from the Azure SQL Database's "**dbo.RecentMeasurements**" view

    - The "**Devices**" area displays a row for each device along with their latest sensor values.  That data comes from the Azure SQL Databases' "**dbo.Devices** view.

    - The "**Chart**" section currently has a placeholder image promising that a chart is coming soon.  If you complete the [TIME PERMITTING - Display Temperature Data with Power BI Embedded](#PowerBIEmbedded) portion of the lab, you will make good on that promise.

    ![Web App Running Locally](images/11180-WebAppRunningLocally.png)

1. You can stop the debug session by pressing the red "**square**" or "**stop**" button the debug toolbar in Visual Studio Code:

    ![Stop Debugging](images/11190-StopDebugging.png)

### Deploying the Web App to Azure ###

The last step is to get this web application running in Azure, not locally.  Earlier, when we configured the Web Application we set it up to deploy from a git repository.  To deploy we can simply push our web app code via git up to the Web App's repo.  Visual Studio Code makes that simple to do!

1. In Visual Studio Code, click the "**git**" icon to open the "**git**" panel, and then click the "**Initialize git repository**" button.

    ![Initialize git repository](images/11200-InitLocalGitRepo.png)

1. Type in a message (like "**Initial commit**) in the box at the top, and click the "**checkmark**" commit icon to commit the changes to the new repo.  Make sure to click the "**checkmark**" commit icon to commit or you will receive errors when you try to push to remote repo in Azure in the next step.

    ![Initial Commit](images/11210-InitialCommit.png)

1. Refer to the Azure Web App Resources information you recently save in the "**[myresources.txt](./myresources.txt)**" file. Copy the "**Git Clone URL** value to your clipboard.  Next, open a command prompt or terminal window,  navigate to the "**HOLs\WebApp**" directory. and issue the following command at the prompt:

    > **Note**: MAKE SURE YOUR COMMAND PROMPT IS POINTING AT THE "**HOLs\WebApp**" PATH.

    ```text
    git remote add origin <your git clone ul>>
    ```

    for example:

    ```text
    git remote add origin https://mic16user@mic16web.scm.azurewebsites.net:443/mic16web.git
    ```

1. Then, back in Visual Studio Code,  on the "**git**" panel, click the "**...**" ellipsis menu at the top, then select "**Publish**", and confirm the publish when prompted.

    > **Note**: If you receive an `error: src refspec master does not match any.` in the Visual Studio Code "Output" window it is likely because you forgot to commit two steps ago.  Make sure to click the "**checkmark**" commit icon on the VS Code "Git" panel to commit as documented above.

    ![Publish](images/11220-Publish.png)

    ![Confirm Publish](images/11230-ConfirmPublish.png)

1. When prompted, enter the deployment credentials you configured previously (these should also be copied down in your "**[myresources](./myresources.txt)**" file) and click "**OK**" to authenticate:

    ![Deployment Credentials](images/11240-DeploymentCredentials.png)

1. In the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>), on the "**Deployment optons**" page for your ***&lt;name&gt;web*** web app, you should see the deployment kick off.  The deployment will likely take a few minutes.  Wait until it displays the green checkmark, and "Active".

    ![Deployment in Portal](images/11250-DeploymentInPortal.png)

1. And finally, you should be able to open your site in Azure to verify it is working.

    > **Note**: The URL to your site in azure should be ***`http://<name>web.azurewebsites.net`*** . For example **`http://mic16web.azurewebsites.net`** . You should have also documented this in your "**[myresources.txt](./myresources.txt)**" file.

    ![Site Running in Azure](images/11260-SiteRunningInAzure.png)

___

<a name="CloudToDeviceMessages"></a>
Sending Messages from the Azure IoT Hub to the Intel Gateway
---

All of the message flow so far has been from the device to the cloud (device-to-cloud messages). In this section, we'll see how to send messages from the cloud back down to the device (cloud-to-device messages).

We'll configure our Intel NUC to turn on its buzzer for one second if it receives a message from the Azure IoT Hub with the following format:

```json
{
    "type"    : "temp",
    "message" : "some message"
}
```

### Add the Buzzer Device and Code to the Intel NUC ###

1. Attach the "**Buzzer**" to "**D3**" on the "**Grove Base Shield"** as shown below:

    ![Buzzer Attached](images/12010-BuzzerAttached.png)

1. Copy the contents out of "**[HOLs\Node-RED Flows\Flow 3 - 03 - Alert and Buzzer Nodes Only.json](./Node-RED%20Flows/Flow%203%20-%2003%20-%20Alert%20and%20Buzzer%20Nodes%20Only.json)**"  file into the clipboard.

1. Open the Intel NUCs Node-RED development environment in your browser (`http://your.nucs.ip.address:1880` where `your.nucs.ip.address is` your NUC's IP Address),  from the "**Hamburger**" menu in the top right corner select "**Import**" | "**Clipboard**"

    ![Import From Clipboard](images/12020-ImportFromClipboard.png)

1. Paste the code copied from the "**[HOLs\Node-RED Flows\Flow 3 - 03 - Alert and Buzzer Nodes Only.json](./Node-RED%20Flows/Flow%203%20-%2003%20-%20Alert%20and%20Buzzer%20Nodes%20Only.json)**" file into the "**Import nodes**" box, and click "**OK**".

    ![Import Nodes](images/12030-ImportNodes.png)

1. Then move your mouse to place the imported nodes where you want (if you hold the shift key while you move your mouse the nodes will snap to the grid), and then connect the output of the "**azureiothub**" node to the input of the "**To String**" node as shown below.  Click the "**Deploy**" button when you are done to deploy the changes.

     The nodes being added do the following:

    - The **To String** function converts the byte data returned by the "**azureiothub**" node into a string value.
    - The **json** node then deserializes that string into an object.
    - The "**msg.payload**" debug node displays the object to the **debug** panel.
    - The "**If Temp Alert** node checks the "type" property on the object to see if it is literally "temp" if it is, the subsequent tasks are allowed to run.
    - The "**Turn on Buzzer**" task does nothing more than create a payload with a value of 1 to cause the buzzer to turn on.
    - The "**Grove Buzzer**" then looks at the payload coming in, and if it is a 1, id sounds the buzzer for a hard coded one second (1000000 microseconds).
    - The "**Get the Message**" node extracts just the "message" property from the object and passes it to the "**Show the Message**" node.
    - The "**Show the Message**" node displays the message text on the second row of the LCD panel and flashes the background of the panel red (rgb 255,0,0).

    ![Imported Nodes](images/12040-ImportedNodes.png)

1. Just to clarify, the "azureiothub" node in Node-RED behaves a little differently than other nodes.  It doesn't take data in from the left, process it, and pass it out on the right.  Instead whatever comes IN to it from the left is SENT to the Azure IoT Hub.  If however the node RECEIVES a message FROM the IoT Hub, it sends it OUT on the right.  So the nodes that are "**before**" (from a flow perspective) the "**azureiothub**" node are dealing with ***sending device-to-cloud messages***, while the nodes "**after**" it deal with ***receiving cloud-to-device messages***.

    ![Node Roles](images/12045-NodePurposes.png)

1. The Azure Web App we deployed in the previous task has a handy way to test the buzzer.  Open up the ***`http://<name>web.azurewebsites.net`*** web application in browser.

1. Just to the left of each device under the "**Devices**" heading there is a small green button with a lightning bolt on it (![Test Buzzer Button](images/00000-TestBuzzerButton.png)).  Click that button next to the device where you have deployed the updated Node-RED code, and you should:

    - Hear the buzzer sound
    - See the test message "***Buzzer Test***" displayed briefly on the LCD
    - See the LCD background change to red briefly.

    <blockquote>
        <strong>Note</strong>: If the test doesn't function try restarting the Azure Web App (you can open the web app in the portal, and click the "<strong>Restart</strong>" or "<strong>Stop</strong>" and "<strong>Start</strong>" buttons along the top), as well as ssh'ing into your Intel NUC and issuing a shutdown / reboot command:<br/>
        <pre><code class="lang-bash">shutdown 0 -raw</code></pre>
    </blockquote>

    ![Test Buzzer Button on Web Site](images/12050-TestBuzzerOnWebsite.png)

    ![Buzzer Test Message](images/12060-BuzzerTestMessageOnLcd.png)
___

<a name="CleaningUp"></a>
Cleaning Up
---

Once you are done with the lab, unless you want to continue with these resources in Azure you can delete them.

1. In the browser, go to the **<a target="_blank" href="https://portal.azure.com/">Azure Portal</a>** (<a target="_blank" href="https://portal.azure.com/">https://portal.azure.com</a>), and click on the "**Resource Groups**", select the "***&lt;name&gt;group***" and on the "**Overview**" page, review its contents.  When you are ready, click the "**Delete**" button along the top.

    > **Note**: There are a number of interesting things to check out on your resource group before you delete it.  Take a minute and check out the "**Resouce Costs**", "**Automation Script**" and "**Monitoring**" options.

    ![Delete Resource Group](images/14010-ResourceGroupInformation.png)

1. On the "**Are you sure...**" page, enter your resource group name into the "**TYPE THE RESOURCE GROUP NAME**" box, and click the "**Delete** button along the bottom. Depending on how many resources are in the group, it may take a while for the deletion to complete.

    ***BE AWARE! WHEN YOU DELETE THE RESOURCE GROUP ALL OF THE RESOURCES IN IT WILL BE DELETED AS WELL.  MAKE SURE YOU ARE DELETING THE CORRRECT RESOURCE GROUP AND THAT YOU INTEND TO DELETE ALL THE RESOURCES IN THE GROUP BEFORE PROCEEDING.***

    ![Delete the group](images/14020-DeleteResourceGroup.png)

1. It's possible that some tiles will be left on your dashboard event after deleting the resources they represent.  You can remove them yourself just by hovering over them with your mouse, clicking on the ellipsis ("**...**") and choosing "**Unpin from dashboard**".

    ![Unpin Tiles](images/14030-UnpinTiles.png)

1. After deleting the resource group and all the resources that were provisioned in this lab, you won't have recurring charges or resource utilitization related to the work you did here.
