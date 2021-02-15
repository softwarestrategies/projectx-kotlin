package io.softwarestrategies.projectx.resource.data.repository

import io.softwarestrategies.projectx.resource.data.entity.Project
import org.springframework.data.repository.kotlin.CoroutineCrudRepository
import org.springframework.stereotype.Repository

@Repository
interface ProjectRepository : CoroutineCrudRepository<Project, Long> {
}