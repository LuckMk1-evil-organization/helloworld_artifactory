pipeline {
    agent none
    environment {
        ORG_NAME = "CBT"
        GIT_REPO_NAME = 'RemiTest'
        PROJECT_NAME = 'RemiTest'
        CHANNEL = "stable"
		BRANCH_NAME= "main"
        ARTIFACTORY_REPOS = "CBTGEN-SNAPSHOT"
        ARTIFACTORY_REPO_NAME = "CBTGEN-SNAPSHOT"

        X86_DOCKER_IMAGE = "registry.gear.ge.com/cbt/gcc8-with-coverity:0.12.1"
        X86_64_DOCKER_IMAGE = "registry.gear.ge.com/cbt/gcc8-with-coverity:0.12.1"
        ARMV7_DOCKER_IMAGE = "conanio/gcc8-armv7hf:1.45.0"
        ARMV7_GCC7_DOCKER_IMAGE = "conanio/gcc7-armv7hf:1.45.0"
        ARMV8_DOCKER_IMAGE = "conanio/gcc8-armv8:1.45.0"
		
        X86_CONAN_PROFILE = "profiles/x86"
        X86_64_CONAN_PROFILE = "profiles/x86_64"
        ARMV7_CONAN_PROFILE = "profiles/armv7"
        ARMV7_GCC7_CONAN_PROFILE = "profiles/armv7_gcc7"
        ARMV8_CONAN_PROFILE = "profiles/armv8"

        CONAN_REVISIONS_ENABLED=1
    }
    options {
        buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '10'))
        skipDefaultCheckout true
        disableConcurrentBuilds()
    }

    stages {

        stage('Parallel build on all target') {
            failFast false
			parallel {

                /*stage('Win64') {
                    agent {
                        label "Windows_2019"
                    }
                    stages {
                        stage('Build Win64') {
                            steps {
                                script {
                                    checkout scm
                                    env.BUILD_VERSION = getWinPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    powershell "pip install -U conan"
                                    conanWinConfiguration(ARTIFACTORY_REPOS)
                                    powershell "python -m pip install --quiet --upgrade pip"
                                    powershell "python -m pip install cmake --quiet --upgrade --force-reinstall --no-cache"
                                    powershell "conan create . ${BUILD_VERSION}@${ORG_NAME}/${CHANNEL} --build=missing"
                                }
                            }
                        }
                        stage('Deploy Win64') {
                            steps {
                                script {
                                    def artifactoryRepo = getArtifactoryRepo(ARTIFACTORY_REPO_NAME)
                                    echo artifactoryRepo
                                    powershell "conan remote list"
                                    powershell "conan search ${PROJECT_NAME}/${BUILD_VERSION}@${ORG_NAME}/${CHANNEL}"
                                    powershell "conan upload ${PROJECT_NAME}/${BUILD_VERSION}@${ORG_NAME}/${CHANNEL} --all -r=${artifactoryRepo}"
                                }
                            }
                        }
                    }
                }*/

                stage('x86_64') {
                    agent {
                        docker {
                            image X86_64_DOCKER_IMAGE
                            args "-v /var/jenkins_home/workspace/${PROJECT_NAME}/${BRANCH_NAME}/.conan:/root/.conan"
                            label 'dind'
                            reuseNode true
                        }
                    }

                    stages {
                        stage('Build x86_64') {
                            steps {
                                script {
                                    sh "env"
                                    checkout scm
                                    env.BUILD_VERSION = getPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    sh "pip install conan --upgrade"
                                    conanConfiguration(ARTIFACTORY_REPOS)
                                    createPackage(X86_64_CONAN_PROFILE)
                                }
                            }
                        }

                        stage('Deploy x86_64') {
                            steps {
                                script {
                                    pushToArtifactory(ARTIFACTORY_REPOS)
                                }
                            }
                        }

                    }
                }

                stage('x86') {
                    agent {
                        docker {
                            image X86_DOCKER_IMAGE
                            args "-v /var/jenkins_home/workspace/${PROJECT_NAME}/${BRANCH_NAME}/.conan:/root/.conan"
                            label 'dind'
                            reuseNode true
                        }
                    }

                    stages {
                        stage('Build x86') {
                            steps {
                                script {
                                    checkout scm
                                    env.BUILD_VERSION = getPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    conanConfiguration(ARTIFACTORY_REPOS)
                                    createPackage(X86_CONAN_PROFILE)
                                }
                            }
                        }

                        stage('Deploy x86') {
                            steps {
                                script {
                                    pushToArtifactory(ARTIFACTORY_REPOS)
                                }
                            }
                        }
                    }
                }

                stage('armv7') {
                    agent {
                        docker {
                            image ARMV7_DOCKER_IMAGE
                            args "-v /var/jenkins_home/workspace/${PROJECT_NAME}/${BRANCH_NAME}/.conan:/root/.conan"
                            label 'dind'
                            reuseNode true
                        }
                    }

                    stages {
                        stage('Build armv7') {
                            steps {
                                script {
                                    checkout scm
                                    env.BUILD_VERSION = getPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    sh "pip install conan --upgrade"
                                    conanConfiguration(ARTIFACTORY_REPOS)
                                    createPackage(ARMV7_CONAN_PROFILE)
                                }
                            }
                        }

                        stage('Deploy armv7') {
                            steps {
                                script {
                                    pushToArtifactory(ARTIFACTORY_REPOS)
                                }
                            }
                        }
                    }
                }

                stage('armv8') {
                    agent {
                        docker {
                            image ARMV8_DOCKER_IMAGE
                            args "-v /var/jenkins_home/workspace/${PROJECT_NAME}/${BRANCH_NAME}/.conan:/root/.conan"
                            label 'dind'
                            reuseNode true
                        }
                    }

                    stages {
                        stage('Build armv8') {
                            steps {
                                script {
                                    checkout scm
                                    sh "pip install conan --upgrade"
                                    env.BUILD_VERSION = getPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    conanConfiguration(ARTIFACTORY_REPOS)
                                    createPackage(ARMV8_CONAN_PROFILE)
                                }
                            }
                        }

                        stage('Deploy armv8') {
                            steps {
                                script {
                                    pushToArtifactory(ARTIFACTORY_REPOS)
                                }
                            }
                        }
                    }
                }

                /*stage('gcc7 armv7') {
                    agent {
                        docker {
                            image ARMV7_GCC7_DOCKER_IMAGE
                            args "-v /var/jenkins_home/workspace/${PROJECT_NAME}/${BRANCH_NAME}/.conan:/root/.conan"
                            label 'dind'
                            reuseNode true
                        }
                    }

                    stages {
                        stage('Build gcc7 armv7') {
                            steps {
                                script {
                                    checkout scm
                                    env.BUILD_VERSION = getPackageVersion()
                                    echo "Version: ${BUILD_VERSION}"
                                    sh "pip install conan --upgrade"
                                    conanConfiguration(ARTIFACTORY_REPOS)
                                    createPackage(ARMV7_GCC7_CONAN_PROFILE)
                                }
                            }
                        }

                        stage('Deploy gcc7 armv7') {
                            steps {
                                script {
                                    pushToArtifactory()
                                }
                            }
                        }
                    }
                }*/
            } // Parallel
        }
    }
}


/**
 * Conan configuration
 */
def conanWinConfiguration(artifactoryRepos) {
    def artifactoryRepoList = "${artifactoryRepos}".split(',').collect { it as String }
    try {
        withCredentials([usernamePassword(credentialsId: 'GENERIC_CBT_SSO', passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
            artifactoryRepoList.each { repo ->
                powershell "conan remote add ${repo} https://artifactory.build.ge.com/api/conan/${repo} True"
                powershell "conan user -p $ARTIFACTORY_PASSWORD -r ${repo} $ARTIFACTORY_USER"
            }
        }
    }
    catch (error) {
        echo "Remote already added"
    }
}

/**
 * Conan configuration
 */
def conanConfiguration(artifactoryRepos) {
    def artifactoryRepoList = "${artifactoryRepos}".split(',').collect { it as String }
    try {
        withCredentials([usernamePassword(credentialsId: 'GENERIC_CBT_SSO', passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
            artifactoryRepoList.each { repo ->
                sh "conan remote add ${repo} https://artifactory.build.ge.com/api/conan/${repo} True"
                sh "conan user -p $ARTIFACTORY_PASSWORD -r ${repo} $ARTIFACTORY_USER"
            }
        }
    }
    catch (error) {
        echo "Remote already added"
    }
}

/**
 * Get conan package version
 */
def getWinPackageVersion() {
    def version = powershell(script: "\$a = gc conanfile.py | Select-String -Pattern 'version_mq'; \$b = \$a -split '\"'; \$b[1]", returnStdout: true).trim()
    return version
}

/**
 * Get conan package version
 */
def getPackageVersion() {
    def version = sh(script: "grep -w version_mq conanfile.py | awk '{print \$3}'", returnStdout: true).trim()
    return version
}

/**
 * Create conan package
 */
def createPackage(profile) {
    // generate package for static library
    //sh "conan create . 0.0.1@${ORG_NAME}/${CHANNEL} --profile ${profile} --build=missing"
}

/**
 * Get Artifactory repository name
 */
def getArtifactoryRepo(String repo) {
    if (env.BRANCH_NAME == "master") {
        return repo
    } else {
        return repo + '-SNAPSHOT'
    }
}

/**
 * Upload conan package to Artifactory repository
 */
def pushToArtifactory(artifactoryRepos) {
    def artifactoryRepoList = "${artifactoryRepos}".split(',').collect { it as String }
	try {
		withCredentials([usernamePassword(credentialsId: 'GENERIC_CBT_SSO', passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
		    artifactoryRepoList.each { repo ->
			sh "curl -sSf -u $ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD -X PUT -T src 'https://artifactory.build.ge.com/api/conan/CBTGEN-SNAPSHOT/RemiTest/hello.zip'"
		    }
		} 
	}
	catch(err){
		echo "curl error " + err
	    }
	/*
    def artifactoryRepo = getArtifactoryRepo(ARTIFACTORY_REPO_NAME)
    echo artifactoryRepo
    sh "conan remote list"
    sh "conan search ${PROJECT_NAME}/0.0.1@${ORG_NAME}/${CHANNEL}"
    sh "conan upload ${PROJECT_NAME}/0.0.1@${ORG_NAME}/${CHANNEL} --all -r=${artifactoryRepo}"
    */
}
