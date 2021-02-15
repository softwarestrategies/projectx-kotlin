package io.softwarestrategies.projectx.resource.service

import io.r2dbc.spi.ConnectionFactory
import io.softwarestrategies.projectx.resource.BaseContainerEnabledTest
import io.softwarestrategies.projectx.resource.data.entity.Project
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.runBlocking
import org.junit.jupiter.api.Assertions
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.Order
import org.junit.jupiter.api.Test
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.annotation.Qualifier
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.context.ApplicationContext

@SpringBootTest()
class ProjectServiceTests : BaseContainerEnabledTest()  {

    @Autowired
    @Qualifier("connectionFactory")
    private lateinit var connectionFactory: ConnectionFactory

    @Autowired
    private lateinit var projectService: ProjectService

    @BeforeEach
    fun setUp(context: ApplicationContext) {
        if (!databaseIsInitialized) {
            initializeDatabase(connectionFactory, "projects_data_extra.sql")
            databaseIsInitialized = true
        }
    }

    @Test
    @Order(1)
    fun `test findAll()` () {
        runBlocking {
            val projects : List<Project> = projectService.findAll("").toList()
            Assertions.assertEquals(4, projects.size)
        }
    }

    @Test
    @Order(2)
    fun `test save()` () {
        val project = Project()
        project.name ="test name"
        project.description = "test description"
        project.userId = 2
        project.status = Project.Status.NEW

        runBlocking {
            projectService.save(project)

            val projects : List<Project> = projectService.findAll("").toList()
            Assertions.assertEquals(5, projects.size)
        }
    }

    @Test
    @Order(3)
    fun `test findById()` () {
        runBlocking {
            val project : Project = projectService.findById(3)
            Assertions.assertEquals("Third test project", project.description)
        }
    }
}
