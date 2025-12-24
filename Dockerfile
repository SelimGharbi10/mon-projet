FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /app-build
COPY pom.xml . 
COPY src ./src
RUN mvn -B -DskipTests package

FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=build /app-build/target/*.jar app.jar

ENV JAVA_TOOL_OPTIONS="-XX:+UseContainerSupport"
HEALTHCHECK --interval=30s --timeout=3s --start-period=25s --retries=3 \
  CMD sh -c 'wget -qO- http://localhost:8089/actuator/health || exit 1'
ENTRYPOINT ["java","-jar","/app/app.jar"]
