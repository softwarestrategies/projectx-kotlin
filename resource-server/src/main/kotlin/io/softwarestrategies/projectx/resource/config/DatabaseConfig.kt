package io.softwarestrategies.projectx.resource.config

import io.r2dbc.postgresql.PostgresqlConnectionConfiguration
import io.r2dbc.postgresql.PostgresqlConnectionFactory
import io.r2dbc.spi.ConnectionFactory
import io.softwarestrategies.projectx.resource.data.utils.DatabaseToProjectReadingConverter
import io.softwarestrategies.projectx.resource.data.utils.ProjectStatusToStringWritingConverter
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Primary
import org.springframework.context.annotation.Profile
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration
import org.springframework.data.r2dbc.repository.config.EnableR2dbcRepositories
import org.springframework.r2dbc.connection.R2dbcTransactionManager
import org.springframework.transaction.ReactiveTransactionManager
import org.springframework.transaction.annotation.EnableTransactionManagement
import org.springframework.transaction.reactive.TransactionalOperator


@Configuration
@EnableR2dbcRepositories
@EnableTransactionManagement
class DatabaseConfig : AbstractR2dbcConfiguration() {

    @Value("\${spring.r2dbc.host:localhost}")
    val R2DBC_HOST: String = ""

    @Value("\${spring.r2dbc.username}")
    val R2DBC_USERNAME: String = "???"

    @Value("\${spring.r2dbc.password}")
    val R2DBC_PASSWORD: String = "???"

    @Value("\${spring.r2dbc.port:5432}")
    val R2DBC_PORT: Int = 0

    @Bean
    @Primary
    override fun connectionFactory(): ConnectionFactory {
        return PostgresqlConnectionFactory(
                PostgresqlConnectionConfiguration.builder()
                        .host(R2DBC_HOST)
                        .database("projectx")
                        .username(R2DBC_USERNAME)
                        .password(R2DBC_PASSWORD)
                        .port(R2DBC_PORT)
                        .build()
        )
    }

    @Bean
    fun reactiveTransactionManager(
            @Qualifier("connectionFactory") connectionFactory: ConnectionFactory
    ): ReactiveTransactionManager {
        return R2dbcTransactionManager(connectionFactory)
    }

    @Bean
    fun transactionalOperator(
            @Qualifier("reactiveTransactionManager") reactiveTransactionManager: ReactiveTransactionManager?
    ): TransactionalOperator? {
        return TransactionalOperator.create(reactiveTransactionManager!!)
    }

    override fun getCustomConverters(): List<Any> {
        return java.util.List.of(
                DatabaseToProjectReadingConverter(),
                ProjectStatusToStringWritingConverter()
        )
    }
}
