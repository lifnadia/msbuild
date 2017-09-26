# CSharp CI Sample
This is a sample project for full CI with Jenkins pipeline
The project contains:
- CSharpCISample - console application that is the main artifact
- CSharpCISample.UnitTests - test project with mstest and nunit tests
- ci.msbuild - contains instructions for msbuild to building, testing and packaging the solution artifacts
- Jenkinsfile - contains instructions for Jenkins to create the ci pipeline

Repository (git): http://tfs2013:8080/tfs/DefaultCollection/Infrastructure/_git/CSharpCISample

Jenkins pipeline: http://cx-jenkins02:8080/job/CSharp%20CI%20Sample/

## Main Concepts
The solution tries to give a developer full control over the ci pipeline.
For a developer to own the pipeline, he/she must have all the information about the pipeline.
This solution encorage the developer to
1. run the pipeline locally
2. manage and update the Jenkins pipeline flow by commiting a change to the Jenkinsfile

The solution has 2 main files:
#### ci.msbuild
This file contains a set of **custom targets that should build, test and pack artifacts**.
It enables a developer to test the pipeline steps locally. 

  - exposes custom targets by the names: 
    - Build - building the solution in the desired configuration/platform
    - Test - testing with mstest or nunit
    - Pack - producing a zip file with the artifacts
    - Cleanup - cleaning up the workspace
  - exposes an additional target for convinience (CI) to run the entire pipeline. **It will be used locally and not by Jenkins**.

Please note: To do so he must setup his machine with some perquisites, as described below.

#### Jenkinsfile
A set of instructions for Jenkins about the **orchestration of the pipeline steps**.
As an orchestrator, it will use msbuild with its custom targets from ci.msbuild to execute the flow.


## Nuget Packages Used In The Solution
- Microsoft.VisualStudio.QualityTools.UnitTestFramework.Updated - MSTest
- NUnit and NUnit 3 Test Adapter - NUnit
- Shouldly - assertion library
- MSBuildTasks - extensions to msbuild targets
 

## Setting Up The Build Machine
Below are the installations needed to setup a machine that can build this project.

### msbuild
- https://www.microsoft.com/en-us/download/confirmation.aspx?id=48159
- add to path
	- C:\Windows\Microsoft.NET\Framework64\v4.0.30319

### nuget
- https://dist.nuget.org/index.html
- download to C:\build-tools
- add to path
	- C:\build-tools

### nunit
- https://github.com/nunit/nunit-console/releases/tag/3.7
- NUnit3 target in ci.msbuild assumes the test runner is installed on default location (C:\Program Files (x86)\NUnit.org)

### mstest
- https://www.visualstudio.com/thank-you-downloading-visual-studio/?sku=TestAgent&rel=15
- Msbuild target in ci.msbuild assumes the test runner is installed on default location (C:\Program Files (x86)\Microsoft Visual Studio\2017\TestAgent\Common7\IDE)
