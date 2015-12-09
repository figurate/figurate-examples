# Starting from the Openjdk-8 container
FROM java:openjdk-8-jdk

EXPOSE 8080 8443

# Set the WORKDIR. All following commands will be run in this directory.
WORKDIR /app

# Copying all gradle files necessary to install gradle with gradlew
COPY gradle gradle
COPY \
  build.gradle \
  gradle.properties \
  gradlew \
  settings.gradle \
  ./
COPY feed-aggregator/build.gradle ./feed-aggregator/

# Install the gradle version used in the repository through gradlew
RUN ./gradlew

# Run gradle assemble to install dependencies before adding the whole repository
RUN ./gradlew feed-aggregator:assemble

# Run gradle tasks to initialise the app for execution
RUN ./gradlew clean copyBundles launcherConfig loggerConfig configurationConfig

ADD . ./

ENTRYPOINT ["/app/gradlew"]

CMD ["-q", "tasks", "--all"]
