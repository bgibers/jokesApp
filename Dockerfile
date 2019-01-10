FROM maven:3.5.2-jdk-8-alpine AS build
WORKDIR /app

# copy the Project Object Model file
COPY ./pom.xml ./pom.xml

# fetch all dependencies
RUN mvn dependency:go-offline -B

# copy your other files
COPY src /app/src  
RUN mvn -f /app/pom.xml clean install -Dmaven.test.skip

FROM openjdk:8-alpine
COPY --from=build /app/target/jokeapp-0.0.1-SNAPSHOT.jar app/target/jokeapp-0.0.1-SNAPSHOT.jar  
EXPOSE 8080  
ENTRYPOINT ["java","-jar","app/target/jokeapp-0.0.1-SNAPSHOT.jar"]  