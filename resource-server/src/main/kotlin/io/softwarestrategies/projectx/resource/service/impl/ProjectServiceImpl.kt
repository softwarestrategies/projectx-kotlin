package io.softwarestrategies.projectx.resource.service.impl

import io.softwarestrategies.projectx.resource.data.entity.Project
import io.softwarestrategies.projectx.resource.data.repository.ProjectCustomRepository
import io.softwarestrategies.projectx.resource.data.repository.ProjectRepository
import io.softwarestrategies.projectx.resource.exception.EntityNotFoundException
import io.softwarestrategies.projectx.resource.service.ProjectService
import kotlinx.coroutines.flow.Flow
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Service


@Service
class ProjectServiceImpl @Autowired constructor(
    val projectCustomRepository: ProjectCustomRepository,
    val projectRepository: ProjectRepository
) : ProjectService {

    suspend override fun findAll(filters: String?): Flow<Project> {
        if (filters.isNullOrBlank()) {
            return projectRepository.findAll()
        }
        else {
            val filterCriteriaList: List<String> = filters.split(";")
            return projectCustomRepository.findAllFiltered(filterCriteriaList)
        }
    }

    suspend override fun findById(id: Long): Project {
        return when (val project = projectRepository.findById(id)) {
            null -> throw EntityNotFoundException("Project not found: " + id)
            else -> project
        }
    }

    suspend override fun save(project: Project): Project {
        return projectRepository.save(project)
    }

    suspend override fun delete(id: Long) {
        projectRepository.deleteById(id)
    }
}