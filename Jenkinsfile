pipeline {
	agent {
		node {
			label 'CI-dotnetcore'
		}
	}

	stages {
		stage('build') {
			steps {
				runMSbuild('Build')
			}
		}
		stage('prepare for testing') {
			steps {
				runMSbuild('CleanupTestResults')
			}
		}
		stage('test') {
			steps {
				parallel (
				  mstest: { runMSbuild('TestMsTest') },
				  nunit: { runMSbuild('TestNUnit') }
				)
				
			}
			post {
                always {
                    publishNUnitTestResults()
					publishMsTestResults()
                }
            }
		}
		stage('pack') { 
			steps {
				runMSbuild('Pack')
				archiveArtifacts('Artifacts.zip')
			}
			
		}
		stage('cleanup') {
			steps {
				runMSbuild('Cleanup')
			}
		}
	}
}

def runMSbuild(target){
	bat 'msbuild ci.msbuild /t:' + target
}

def publishNUnitTestResults(){
	step([$class: 'NUnitPublisher', testResultsPattern: 'TestResults\\NUnintResults.xml', debug: false, keepJUnitReports: true, skipJUnitArchiver:false, failIfNoResults: true])  
}

def publishMsTestResults(){
	step([
        $class: 'XUnitBuilder', testTimeMargin: '3000', thresholdMode: 1,
        thresholds: [
            [$class: 'FailedThreshold', failureNewThreshold: '', failureThreshold: '0', unstableNewThreshold: '', unstableThreshold: ''],
            [$class: 'SkippedThreshold', failureNewThreshold: '', failureThreshold: '', unstableNewThreshold: '', unstableThreshold: '']
        ],
        tools: [[
            $class: 'MSTestJunitHudsonTestType',
            deleteOutputFiles: true,
            failIfNotNew: true,
            pattern: 'TestResults\\MsTestResults.trx',
            skipNoTestFiles: false,
            stopProcessingIfError: true
        ]]
    ])
}
