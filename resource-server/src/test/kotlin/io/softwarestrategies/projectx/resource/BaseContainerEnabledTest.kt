package io.softwarestrategies.projectx.resource

import io.r2dbc.spi.ConnectionFactory
import org.junit.jupiter.api.MethodOrderer
import org.junit.jupiter.api.TestMethodOrder
import org.springframework.test.context.ActiveProfiles
import org.springframework.test.context.DynamicPropertyRegistry
import org.springframework.test.context.DynamicPropertySource
import org.springframework.test.context.TestPropertySource
import org.testcontainers.containers.PostgreSQLContainer
import org.testcontainers.junit.jupiter.Container
import org.testcontainers.junit.jupiter.Testcontainers
import reactor.core.publisher.Flux
import java.io.File

@ActiveProfiles("Test")
@Testcontainers
@TestMethodOrder(MethodOrderer.OrderAnnotation::class)
@TestPropertySource("classpath:application-test.yml")
abstract class BaseContainerEnabledTest {

    companion object {

        var databaseIsInitialized = false

        fun initializeDatabase(connectionFactory: ConnectionFactory, vararg scripts: String) {
            scripts.forEach { scriptFileName ->
                File(ClassLoader.getSystemResource(scriptFileName).file).readLines().forEach { statement ->
                    executeSqlStatement(connectionFactory, statement)
                }
            }
        }

        fun executeSqlStatement(connectionFactory: ConnectionFactory, sqlStatement: String) {
            Flux.from(connectionFactory.create())
                .flatMap { c -> Flux.from(c.createBatch().add(sqlStatement).execute()).doFinally { c.close() } }
                .log().blockLast()
        }

        @Container
        val postgreSQLContainer = PostgreSQLContainer<Nothing>("postgres:13.0-alpine").apply {
            withDatabaseName("projectx")
        }

        @JvmStatic
        @DynamicPropertySource
        fun properties(registry: DynamicPropertyRegistry) {
            val databaseUrl = postgreSQLContainer.jdbcUrl.replace("jdbc", "r2dbc") + "&TC_IMAGE_TAG=13.0-alpine-test"
            registry.add("spring.r2dbc.url") { databaseUrl }
            registry.add("spring.r2dbc.username", postgreSQLContainer::getUsername);
            registry.add("spring.r2dbc.password", postgreSQLContainer::getPassword);
            registry.add("spring.r2dbc.port", postgreSQLContainer::getFirstMappedPort);
        }
    }
}