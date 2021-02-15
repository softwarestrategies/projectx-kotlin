package io.softwarestrategies.projectx.resource.data.repository

import io.r2dbc.spi.Row
import io.softwarestrategies.projectx.resource.data.entity.Project
import io.softwarestrategies.projectx.resource.data.utils.ProjectConverters
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.reactive.asFlow
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.data.r2dbc.core.R2dbcEntityTemplate
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.stereotype.Repository
import java.util.function.Function


@Repository
class ProjectCustomRepository @Autowired constructor(val r2dbcEntityTemplate: R2dbcEntityTemplate) {

    val ROW_MAPPER: Function<Row, Project> = Function<Row, Project> { row: Row ->
        ProjectConverters.toProjectFromRow(row)
    }

/*
    suspend fun findAll(): Flow<Project> {
        return r2dbcEntityTemplate
                .select(Project::class.java)
                .all()
                .asFlow()
    }

    suspend fun findById(id: Long): Project? {
        return r2dbcEntityTemplate
                .select(Project::class.java)
                .matching(query(where("id").`is`(id)))
                .awaitOneOrNull()
    }

    suspend fun save(project: Project): Project {
        return r2dbcEntityTemplate
                .insert(Project::class.java)
                .using(project)
                .awaitFirst()
    }

    suspend fun deleteById(id: Long) {
        r2dbcEntityTemplate
                .delete(Project::class.java)
                .matching(query(where("id").`is`(id))).allAndAwait()
    }
*/

    // name:=:project 2;description:like:%test%

    suspend fun findAllFiltered(filterCriterionList: List<String>): Flow<Project> {
        var sqlStatement = "SELECT id, name, description FROM project "

        if (!filterCriterionList.isEmpty()) {
            sqlStatement += " WHERE "

            for (iterationCounter in 0..filterCriterionList.size-1)             {
                val filterCriterion: List<String>
                        = filterCriterionList.get(iterationCounter).split(":")
                val fieldName = filterCriterion[0]
                val relationship = filterCriterion[1]

                sqlStatement += fieldName + " " + relationship + " :" + fieldName + " "

                if (iterationCounter < filterCriterionList.size-1) {
                    sqlStatement += " AND "
                }
            }
        }

        var sqlQuery: DatabaseClient.GenericExecuteSpec = r2dbcEntityTemplate.databaseClient.sql(sqlStatement)

        if (!filterCriterionList.isEmpty()) {
            for (iterationCounter in 0..filterCriterionList.size-1)             {
                val criterion: List<String> = filterCriterionList.get(iterationCounter).split(":")
                val fieldName = criterion[0]
                val queryValue = criterion[2]

                sqlQuery = if (queryValue.isEmpty()) {
                    sqlQuery.bindNull(fieldName, String::class.java)
                } else {
                    sqlQuery.bind(fieldName, queryValue)
                }
            }
        }

        return sqlQuery.map(ROW_MAPPER).all().asFlow()
    }
}
