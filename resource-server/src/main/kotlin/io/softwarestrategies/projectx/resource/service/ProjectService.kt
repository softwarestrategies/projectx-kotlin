package io.softwarestrategies.projectx.resource.service

import io.softwarestrategies.projectx.resource.data.entity.Project
import kotlinx.coroutines.flow.Flow

interface ProjectService {

    suspend fun findAll(filters: String?): Flow<Project>
    suspend fun findById(id: Long): Project
    suspend fun save(project: Project): Project
    suspend fun delete(id: Long)
}
