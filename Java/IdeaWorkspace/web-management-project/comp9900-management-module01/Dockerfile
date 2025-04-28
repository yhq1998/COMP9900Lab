# 使用Maven构建项目
FROM maven:3.9-amazoncorretto-17 AS build

# 设置工作目录
WORKDIR /app

# 复制Maven配置文件
COPY pom.xml .

# 下载依赖（利用Docker缓存，提高构建速度）
RUN mvn dependency:go-offline -B

# 复制源代码
COPY src ./src

# 构建应用
RUN mvn package -DskipTests

# 第二阶段：使用JDK运行应用
FROM amazoncorretto:17-alpine

# 设置工作目录
WORKDIR /app

# 从构建阶段复制JAR文件
COPY --from=build /app/target/*.jar app.jar

# 暴露端口
EXPOSE 8080

# 设置Java选项
ENV JAVA_OPTS="-Xms256m -Xmx512m"

# 运行应用
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"] 