FROM ubuntu
MAINTAINER foi-oss version: 1.0

# Update and create workspace
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y locales apt-utils sudo git python python3 python-pip python3-pip python-jinja2 libssl-dev curl software-properties-common zip wget default-jdk scala vim libdb1-compat tzdata initscripts
RUN pip2 install --upgrade pip
RUN pip3 install --upgrade pip
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN mkdir /home/tools

# Install Android SDK
RUN mkdir /home/tools/android-sdk
RUN cd /home/tools/android-sdk && wget https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip && unzip /home/tools/android-sdk/sdk*.zip -d /home/tools/android-sdk
RUN yes | /home/tools/android-sdk/tools/bin/sdkmanager --licenses
RUN /home/tools/android-sdk/tools/bin/sdkmanager "platform-tools" "platforms;android-26"
ENV ANDROID_HOME /home/tools/android-sdk

# Install SUPER Android Analyzer - https://github.com/SUPERAndroidAnalyzer/super
RUN mkdir /home/tools/super && cd /home/tools/super && wget https://github.com/SUPERAndroidAnalyzer/super/releases/download/0.4.1/super-analyzer_0.4.1_ubuntu_amd64.deb
RUN dpkg -i /home/tools/super/*.deb

# Install StaCoAn
RUN cd /home/tools && git clone https://github.com/vincentcox/StaCoAn.git
RUN cd /home/tools/StaCoAn/src && pip3 install -r requirements.txt

# Install QARK
RUN cd /home/tools && git clone https://github.com/linkedin/qark.git

# Install AndroBugs Framework
RUN cd /home/tools && git clone https://github.com/AndroBugs/AndroBugs_Framework.git

# Install JAADAS
RUN cd /home/tools && git clone https://github.com/flankerhqd/JAADAS
RUN mkdir /opt/gradle && cd /opt/gradle && wget https://services.gradle.org/distributions/gradle-4.6-bin.zip
RUN unzip -d /opt/gradle /opt/gradle/gradle-*.zip
RUN ln -s /opt/gradle/gradle-*/bin/gradle /usr/bin/gradle
RUN cd /home/tools/JAADAS && gradle fatJar
