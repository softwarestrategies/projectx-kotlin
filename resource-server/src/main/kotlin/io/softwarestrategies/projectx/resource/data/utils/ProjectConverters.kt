package io.softwarestrategies.projectx.resource.data.utils

import io.r2dbc.spi.Row
import io.r2dbc.spi.RowMetadata
import io.softwarestrategies.projectx.resource.data.dto.ProjectDTO
import io.softwarestrategies.projectx.resource.data.entity.Project
import org.springframework.core.convert.converter.Converter
import org.springframework.data.convert.ReadingConverter
import org.springframework.data.convert.WritingConverter
import java.time.LocalDateTime

class ProjectConverters {

    companion object {

        fun toProjectDto(project: Project): ProjectDTO? {
            val projectDTO = ProjectDTO()
            projectDTO.id = project.id!!
            projectDTO.name = project.name
            projectDTO.description = project.description
            projectDTO.userId = project.userId!!
            return projectDTO
        }

        fun toProject(projectDTO: ProjectDTO): Project? {
            val project = Project()
            project.id = projectDTO.id
            project.name = projectDTO.name
            project.description = projectDTO.description
            project.userId = projectDTO.userId
            project.status = projectDTO.status
            return project
        }

        fun rowHasValue(row: Row, key: String) : Boolean {
            try {
                row.get(key)
                return true
            }
            catch (e: Exception) {
                return false;
            }
        }

        fun toProjectFromRow(row: Row): Project {
            val project = Project()
            if (rowHasValue(row,"id"))          { project.id = row.get("id") as? Long }
            if (rowHasValue(row,"version"))     { project.version = row.get("version") as Int }
            if (rowHasValue(row,"created_on"))  { project.createdOn = row.get("created_on") as LocalDateTime }
            if (rowHasValue(row,"modified_on")) { project.modifiedOn = row.get("modified_on") as LocalDateTime }
            if (rowHasValue(row,"created_by"))  { project.createdBy = row.get("created_by") as String }
            if (rowHasValue(row,"modified_by")) { project.modifiedBy = row.get("modified_by") as String }
            if (rowHasValue(row,"user_id"))     { project.userId = (row.get("user_id") as Int).toLong() }
            if (rowHasValue(row,"name"))        { project.name = row.get("name") as String }
            if (rowHasValue(row,"description")) { project.description = row.get("description") as String }
            if (rowHasValue(row,"status"))      { project.status = Project.Status.fromAbbreviation(row.get("status") as String) }
            return project
        }
    }
}

@ReadingConverter
class DatabaseToProjectReadingConverter : Converter<Row?, Project?> {

    override fun convert(row: Row): Project {
        return ProjectConverters.toProjectFromRow(row);
    }
}

@WritingConverter
class ProjectStatusToStringWritingConverter : Converter<Project.Status?, String?> {
    override fun convert(projectStatus: Project.Status): String? {
        return projectStatus.abbreviation
    }
}
